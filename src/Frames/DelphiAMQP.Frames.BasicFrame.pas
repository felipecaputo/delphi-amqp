unit DelphiAMQP.Frames.BasicFrame;

interface

uses
  System.Rtti, DelphiAMQP.FrameIntf, System.Classes, System.SysUtils,
  DelphiAMQP.Frames.Header, DelphiAMQP.AMQPValue;

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
    FParameters: TArray<TAMQPValueType>;

    FMethodId: Word;
    FClassId: Word;

  public
    constructor Create(); virtual;
    destructor Destroy; override;

    procedure Read(const AStream: TBytesStream);
    procedure Write(const AStream: TBytesStream);

    property FrameHeader: TAMQPFrameHeader read FFrameHeader;
    property Content: TBytesStream read FContentStream;
  published
    property ClassId: Word read FClassId write FClassId;
    property MethodId: Word read FMethodId write FMethodId;
  end;

  TAMQPFrameClass = class of TAMQPBasicFrame;

implementation

uses
  DelphiAMQP.Util.Helpers, System.TypInfo, DelphiAMQP.Util.Attributes,
  System.Generics.Collections;

{ TAMQPBasicFrame }

procedure TAMQPBasicFrame.BuildParams;
var
  prop: TRttiProperty;
  attr: TCustomAttribute;
  paramAttr: AMQPParamAttribute;
  value: TAMQPValueType;
  data: TDictionary<Integer,TAMQPValueType>;
  I: Integer;
begin
  data := TDictionary<Integer, TAMQPValueType>.Create;
  try
    for prop in FContext.GetType(Self.ClassType).GetProperties do
    begin

      for attr in prop.GetAttributes do
      begin
        if not (attr is AMQPParamAttribute) then
          Continue;

        paramAttr := attr as AMQPParamAttribute;

        value := prop.GetValue(Self).AsObject as TAMQPValueType;
        if value = nil then
        begin
          value := TAMQPValueType.Create(paramAttr.DataType);
          try
            prop.SetValue(Self, TValue.From<TAMQPValueType>(value));
          except
            FreeAndNil(value);
            raise;
          end;
        end
        else
          value.ValueType := paramAttr.DataType;

        Data.Add(paramAttr.Order, value);
      end;
    end;

    SetLength(FParameters, Data.Count);
    for I := 0 to Pred(Data.Count) do
    begin
      if not Data.ContainsKey(I) then
        raise EAMQPParserException.CreateFmt('Missing parameter %d for frame %s',
          [I, Self.ClassName]);

      FParameters[I] := Data.Items[I];
    end;
  finally
    FreeAndNil(data);
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
  param: TAMQPValueType;
begin
  for param in FParameters do
    param.Parse(AStream);
end;

procedure TAMQPBasicFrame.Write(const AStream: TBytesStream);
var
  param: TAMQPValueType;
  TempStream: TBytesStream;
  methodInfo: TBytes;
begin
  TempStream := TBytesStream.Create();
  try
    SetLength(methodInfo, 4);
    AMQPMoveEx(FClassId, methodInfo, 0, 2);
    AMQPMoveEx(MethodId, methodInfo, 2, 2);
    TempStream.Write(methodInfo, 4);

    for param in FParameters do
      param.Write(TempStream);

    FrameHeader.Size := TempStream.Size;
    FrameHeader.Write(AStream);
    TempStream.Position := 0;
    AStream.Write(TempStream.Bytes, TempStream.Size);
  finally
    FreeAndNil(TempStream);
  end;
end;

end.
