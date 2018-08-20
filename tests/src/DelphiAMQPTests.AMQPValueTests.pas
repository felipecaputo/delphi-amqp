unit DelphiAMQPTests.AMQPValueTests;

interface

uses
  DUnitX.TestFramework, DelphiAMQP.AMQPValue;

type
  [TestFixture]
  TDelphiAMQPTests = class
  private
    FAmqpValue: TAMQPValueType;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    [MaxTimeAttribute(1)]
    [TestCase('SimpleString', 'A string')]
    [TestCase('Special string', '¡¿·¸ special string @#$%')]
    procedure TestShortString(const AValue: string);
    [Test]
    [MaxTimeAttribute(1)]
    [TestCase('SimpleString', 'A string')]
    [TestCase('Special string', '¡¿·¸ special string @#$%')]
    procedure TestLongString(const AValue: string);
    [Test]
    [MaxTimeAttribute(1)]
    [TestCase('Lowest', '0,0')]
    [TestCase('Highest', '255,255')]
    [TestCase('Middle', '127,127')]
    procedure TestByte(const AValue: Byte; const Expected: string);
    [Test]
    [MaxTimeAttribute(1)]
    [TestCase('Lowest', '-127,-127')]
    [TestCase('Middle', '20,20')]
    [TestCase('Highest', '127,127')]
    procedure TestAsInt8(const AValue: Int8; const Expected: string);
    [Test]
    [MaxTimeAttribute(1)]
    [TestCase('Lowest', '0,0')]
    [TestCase('Smaller', '378,378')]
    [TestCase('Small', '32268,32268')]
    [TestCase('Middle', '50000,50000')]
    [TestCase('Highest', '65535,65535')]
    procedure TestWord(const AValue: Word; const Expected: string);
    [Test]
    [MaxTimeAttribute(1)]
    [TestCase('Lowest', '0,0')]
    [TestCase('Smaller', '378,378')]
    [TestCase('Small', '32268,32268')]
    [TestCase('Middle', '50000,50000')]
    [TestCase('Highest', '165535,165535')]
    procedure TestUInt32(const AValue: UInt32; const Expected: string);
    [Test]
    [MaxTimeAttribute(1)]
    [TestCase('Lowest', '-1000000,-1000000')]
    [TestCase('Smaller', '-378,-378')]
    [TestCase('Zero', '0,0')]
    [TestCase('Small', '32268,32268')]
    [TestCase('Middle', '50000,50000')]
    [TestCase('Highest', '165535,165535')]
    procedure TestInt32(const AValue: Int32; const Expected: string);
    [Test]
    [MaxTimeAttribute(1)]
    [TestCase('Lowest', '-9223372036854775807,-9223372036854775807')]
    [TestCase('Smaller', '-378,-378')]
    [TestCase('Zero', '0,0')]
    [TestCase('Small', '32268,32268')]
    [TestCase('Middle', '50000,50000')]
    [TestCase('Highest', '9223372036854775807,9223372036854775807')]
    procedure TestUInt64(const AValue: Int64; const Expected: string);
    [Test]
    [MaxTimeAttribute(1)]
    [TestCase('Lowest', '1.3256,2,1.32')]
    [TestCase('High precision', '1.23456789,9,1.23456789')]
    procedure TestDecimal(const AValue: Double; const Precision: Byte; const Expected: string);
    [Test]
    [MaxTimeAttribute(1)]
    [TestCase('True', 'True,True')]
    [TestCase('False', 'False,False')]
    procedure TestBool(const AValue, Expected: Boolean);
  end;

implementation

uses
  System.SysUtils;

{ TDelphiAMQPTests }

procedure TDelphiAMQPTests.Setup;
begin
  FAmqpValue := TAMQPValueType.Create(TAMQPValueType.NoValue);
end;

procedure TDelphiAMQPTests.TearDown;
begin
  FreeAndNil(FAmqpValue);
end;

procedure TDelphiAMQPTests.TestAsInt8(const AValue: Int8; const Expected: string);
begin
  FAmqpValue.ValueType := TAMQPValueType.ShortShortInt;
  FAmqpValue.AsInt8 := AValue;
  Assert.AreEqual(IntToStr(FAmqpValue.AsInt8), Expected);
end;

procedure TDelphiAMQPTests.TestBool(const AValue, Expected: Boolean);
begin
  FAmqpValue.ValueType := TAMQPValueType.Bool;
  FAmqpValue.AsBoolean := AValue;
  Assert.AreEqual(FAmqpValue.AsBoolean, Expected);
  Assert.AreEqual(Length(FAmqpValue.Data), 1);
end;

procedure TDelphiAMQPTests.TestByte(const AValue: Byte; const Expected: string);
begin
  FAmqpValue.ValueType := TAMQPValueType.ShortShortUInt;
  FAmqpValue.AsByte := AValue;
  Assert.AreEqual(IntToStr(FAmqpValue.AsByte), Expected);
end;

procedure TDelphiAMQPTests.TestDecimal(const AValue: Double; const Precision: Byte;
  const Expected: string);
begin
  FAmqpValue.ValueType := TAMQPValueType.DecimalValue;
  FAmqpValue.FloatPrecision := Precision;
  FAmqpValue.AsDecimal := AValue;
  Assert.AreEqual(FloatToStr(FAmqpValue.AsDecimal).Replace(',','.',[rfReplaceAll]), Expected);
  Assert.AreEqual(Length(FAmqpValue.Data), 5);
end;

procedure TDelphiAMQPTests.TestInt32(const AValue: Int32; const Expected:
    string);
begin
  FAmqpValue.ValueType := TAMQPValueType.LongInt;
  FAmqpValue.AsInt32 := AValue;
  Assert.AreEqual(IntToStr(FAmqpValue.AsInt32), Expected);
end;

procedure TDelphiAMQPTests.TestLongString(const AValue: string);
begin
  FAmqpValue.ValueType := TAMQPValueType.LongString;
  FAmqpValue.AsString := AValue;
  Assert.AreEqual(AValue, FAmqpValue.AsString);
end;

procedure TDelphiAMQPTests.TestShortString(const AValue: string);
begin
  FAmqpValue.ValueType := TAMQPValueType.ShortString;
  FAmqpValue.AsString := AValue;
  Assert.AreEqual(AValue, FAmqpValue.AsString);
end;

procedure TDelphiAMQPTests.TestUInt32(const AValue: UInt32; const Expected:
    string);
begin
  FAmqpValue.ValueType := TAMQPValueType.LongUInt;
  FAmqpValue.AsUInt32 := AValue;
  Assert.AreEqual(IntToStr(FAmqpValue.AsUInt32), Expected);
end;

procedure TDelphiAMQPTests.TestUInt64(const AValue: Int64; const Expected: string);
begin
  FAmqpValue.ValueType := TAMQPValueType.LongLongInt;
  FAmqpValue.AsInt64 := AValue;
  Assert.AreEqual(IntToStr(FAmqpValue.AsInt64), Expected);
  Assert.AreEqual(Length(FAmqpValue.Data), 8);
end;

procedure TDelphiAMQPTests.TestWord(const AValue: Word; const Expected: string);
begin
  FAmqpValue.ValueType := TAMQPValueType.ShortUInt;
  FAmqpValue.AsWord := AValue;
  Assert.AreEqual(IntToStr(FAmqpValue.AsWord), Expected);
end;

initialization
  TDUnitX.RegisterTestFixture(TDelphiAMQPTests);

end.
