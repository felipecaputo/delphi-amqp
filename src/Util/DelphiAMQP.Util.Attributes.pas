unit DelphiAMQP.Util.Attributes;

interface

type
  AMQPFrameAttribute = class(TCustomAttribute)
  private
    FClassId: Word;
    FMethodId: Word;
  public
    constructor Create(const AClassId, AMethodId: Word);

    property ClassId: Word read FClassId write FClassId;
    property MethodId: Word read FMethodId write FMethodId;
  end;

  AMQPParamAttribute = class(TCustomAttribute)
  private
    FOrder: UInt8;
    FDataType: Char;
  public
    constructor Create(const AOrder: UInt8; const ADataType: Char);

    property Order: UInt8 read FOrder write FOrder;
    property DataType: Char read FDataType write FDatatype;
  end;

implementation

{ TAMQPFrameAttribute }

constructor AMQPFrameAttribute.Create(const AClassId, AMethodId: Word);
begin
  FClassId := AClassId;
  FMethodId := AMethodId;
end;

{ AMQPParamAttribute }

constructor AMQPParamAttribute.Create(const AOrder: UInt8; const ADataType: Char);
begin
  FOrder := AOrder;
  FDataType := ADataType;
end;

end.
