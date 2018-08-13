unit DelphiAMQP.Frames.BasicFrame;

interface

uses
  DelphiAMQP.FrameIntf, System.Classes, System.SysUtils,
  DelphiAMQP.Frames.Header, System.Rtti;

type
  TAMQPBasicFrame = class(TComponent)
  protected
    FFrameHeader: TAMQPFrameHeader;
    FContentStream: TBytesStream;

    FMethodId: Word;
    FClassId: Word;

  public
    constructor Create(AOwner: TComponent); override;

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
  DelphiAMQP.AMQPValue, DelphiAMQP.Util.Helpers, System.TypInfo;

{ TAMQPBasicFrame }

constructor TAMQPBasicFrame.Create(AOwner: TComponent);
begin
  inherited;
  FFrameHeader := TAMQPFrameHeader.Create(nil);
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
    objType := context.GetType(Self);
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
begin
  //TODO: Try to unify this and Read
  context := TRttiContext.Create;
  try
    objType := context.GetType(Self);
    for parameter in methodParameters do
    begin
      objProp := objType.GetProperty(parameter);

      if objProp = nil then
        raise EAMQPParserException.CreateFmt('Property not found [%s]', [parameter]);

      prop := (objProp.GetValue(Self).AsObject as TAMQPValueType);
      prop.Write(AStream);
    end;
  finally
    context.Free;
  end;
end;

end.
