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
    FBitOffset: UInt8;
  public
    constructor Create(const AOrder: UInt8; const ADataType: Char; const ABitOffset: UInt8 = 0);

    property Order: UInt8 read FOrder write FOrder;
    property DataType: Char read FDataType write FDatatype;
    property BitOffset: UInt8 read FBitOffset write FBitOffset;
  end;

implementation

{ TAMQPFrameAttribute }

constructor AMQPFrameAttribute.Create(const AClassId, AMethodId: Word);
begin
  FClassId := AClassId;
  FMethodId := AMethodId;
end;

{ AMQPParamAttribute }

constructor AMQPParamAttribute.Create(const AOrder: UInt8; const ADataType: Char; const ABitOffset: UInt8 = 0);
begin
  FOrder := AOrder;
  FDataType := ADataType;
  FBitOffset := ABitOffset;
end;

end.
