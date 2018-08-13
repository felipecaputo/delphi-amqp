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
    [TestCase('SimpleString', 'A string')]
    [TestCase('Special string', '¡¿·¸ special string @#$%')]
    procedure TestShortString(const AValue: string);
    [Test]
    [TestCase('SimpleString', 'A string')]
    [TestCase('Special string', '¡¿·¸ special string @#$%')]
    procedure TestLongString(const AValue: string);
    [Test]
    [TestCase('Lowest', '0')]
    [TestCase('Highest', '255')]
    [TestCase('Middle', '127')]
    procedure TestByte(const AValue: Byte);
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

procedure TDelphiAMQPTests.TestByte(const AValue: Byte);
begin
  FAmqpValue.ValueType := TAMQPValueType.ShortShortUInt;
  FAmqpValue.AsByte := AValue;
  Assert.AreEqual(AValue, FAmqpValue.AsByte);
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

initialization
  TDUnitX.RegisterTestFixture(TDelphiAMQPTests);

end.
