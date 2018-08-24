unit DelphiAMQP.Frames.BasicFrame;

interface

uses
  DelphiAMQP.FrameIntf, System.Classes, System.SysUtils,
  DelphiAMQP.Frames.Header, System.Rtti;

type
  TAMQPBasicFrame = class(TPersistent)
  private
    procedure FillFrameInfo();
    procedure BuildParams();
    procedure FreeParams();
  protected
    FContext: TRttiContext;
    FFrameHeader: TAMQPFrameHeader;
    FContentStream: TBytesStream;

    FMethodId: Word;
    FClassId: Word;

  public
    constructor Create(); virtual;
    destructor Destroy; override;

    function Parameters(): TArray<string>; virtual; abstract;

    procedure Read(const AStream: TBytesStream);
    procedure Write(const AStream: TBytesStream);

    property FrameHeader: TAMQPFrameHeader read FFrameHeader;
    property Content: TBytesStream read FContentStream;
  published
    property ClassId: Word read FClassId write FClassId;
    property MethodId: Word read FMethodId write FMethodId;
  end;

implementation

uses
  DelphiAMQP.AMQPValue, DelphiAMQP.Util.Helpers, System.TypInfo,
  DelphiAMQP.Util.Attributes;

{ TAMQPBasicFrame }

procedure TAMQPBasicFrame.BuildParams;
var
  prop: TRttiProperty;
  attr: TCustomAttribute;
begin
  for prop in FContext.GetType(Self.ClassType).GetProperties do
  begin

    for attr in prop.GetAttributes do
    begin
      if not (attr is AMQPParamAttribute) then
        Continue;

      if prop.GetValue(Self).AsObject = nil then
        prop.SetValue(Self, TValue.From<TAMQPValueType>(TAMQPValueType.Create((attr as AMQPParamAttribute).DataType)))
      else
        (prop.GetValue(Self).AsObject as TAMQPValueType).ValueType := (attr as AMQPParamAttribute).DataType;
    end;
  end;
end;

constructor TAMQPBasicFrame.Create;
begin
  inherited;
  FFrameHeader := TAMQPFrameHeader.Create(nil);
  FContext := TRttiContext.Create;
  FillFrameInfo();
  BuildParams();

  FrameHeader.FrameType := 1;
end;

destructor TAMQPBasicFrame.Destroy;
begin
  FContext.Free;
  FreeAndNil(FFrameHeader);
  FreeParams();
  inherited;
end;

procedure TAMQPBasicFrame.FillFrameInfo;
var
  attr: TCustomAttribute;
begin
  for attr in FContext.GetType(Self.ClassType).GetAttributes do
  begin
    if not (attr is AMQPFrameAttribute) then
      Continue;

    ClassId := (attr as AMQPFrameAttribute).ClassId;
    MethodId := (attr as AMQPFrameAttribute).MethodId;
  end;
end;

procedure TAMQPBasicFrame.FreeParams;
var
  prop: TRttiProperty;
  attr: TCustomAttribute;
  param: TObject;
begin
  for prop in FContext.GetType(Self.ClassType).GetProperties do
  begin
    for attr in prop.GetAttributes do
    begin
      if not (attr is AMQPParamAttribute) then
        Continue;

      param := prop.GetValue(Self).AsObject;

      if param = nil then
        Continue;

      param.Free;
      prop.SetValue(Self, TValue.From<TAMQPValueType>(nil))
    end;
  end;
end;

procedure TAMQPBasicFrame.Read(const AStream: TBytesStream);
var
  methodParameters: TArray<string>;
  parameter: string;
  context: TRttiContext;
  objType: TRttiType;
  objProp: TRttiProperty;
  prop: TAMQPValueType;
begin
  methodParameters := Self.Parameters;
  context := TRttiContext.Create;
  try
    objType := context.GetType(Self.ClassType);
    for parameter in methodParameters do
    begin
      objProp := objType.GetProperty(parameter);

      if objProp = nil then
        raise EAMQPParserException.CreateFmt('Property not found [%s]', [parameter]);

      prop := (objProp.GetValue(Self).AsObject as TAMQPValueType);
      prop.Parse(prop.ValueType, AStream);
    end;
  finally
    context.Free;
  end;
end;

procedure TAMQPBasicFrame.Write(const AStream: TBytesStream);
var
  methodParameters: TArray<string>;
  parameter: string;
  context: TRttiContext;
  objType: TRttiType;
  objProp: TRttiProperty;
  prop: TAMQPValueType;
  TempStream: TBytesStream;
  Test: TBytes;
begin
  //TODO: Try to unify this and Read
  TempStream := nil;
  context := TRttiContext.Create;
  try
    TempStream := TBytesStream.Create();

    SetLength(Test, 4);
    AMQPMoveEx(FClassId, Test, 0, 2);
    AMQPMoveEx(MethodId, Test, 2, 2);
    TempStream.Write(Test, 4);

    methodParameters := Parameters();

    objType := context.GetType(Self.ClassType);
    for parameter in methodParameters do
    begin
      objProp := objType.GetProperty(parameter);

      if objProp = nil then
        raise EAMQPParserException.CreateFmt('Property not found [%s]', [parameter]);

      prop := (objProp.GetValue(Self).AsObject as TAMQPValueType);
      prop.Write(TempStream);
    end;

    FrameHeader.Size := TempStream.Size;
    FrameHeader.Write(AStream);
    TempStream.Position := 0;
    AStream.Write(TempStream.Bytes, TempStream.Size);
  finally
    context.Free;
    FreeAndNil(TempStream);
  end;
end;

end.
