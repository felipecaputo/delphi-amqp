unit DelphiAMQP.AMQPValue;

interface

uses
  System.Classes, System.SysUtils, System.Generics.Collections;

type
  EAMQPParserException = class(Exception);

  TAMQPValueType = class
  private
    FWriter: TBinaryWriter;
    FValueType: Char;
    FValue: TBytes;
    FAMQPTable: TDictionary<string, TAMQPValueType>;
    FFieldArray: TList<TAMQPValueType>;

    procedure ReadValue(const AStream: TBytesStream; const ASize: Integer);
    procedure ParseShortString(const AStream: TBytesStream);
    procedure ParseLongString(const AStream: TBytesStream);
    procedure ParseAMQPTable(const AStream: TBytesStream);
    procedure ParseAMQPFieldValuePair(const AStream: TBytesStream);
    procedure ParseByteArray(const AStream: TBytesStream);
    procedure ParseFieldArray(const AStream: TBytesStream);

    function GetAsString: string;
    procedure SetAsString(const AValue: string);
    procedure SetShortString(const AValue: string);
    procedure SetLongString(const AValue: string);
    function GetAsByte: Byte;
    procedure SetAsByte(const Value: Byte);
  public
    const
      Boolean = 't';
      ShortShortInt = 'b';
      ShortShortUInt = 'B';
      ShortInt = 's';
      ShortUInt = 'u';
      LongInt = 'I';
      LongUInt = 'i';
      LongLongInt = 'l';
//      LongLongUInt = 'l';
      Float = 'f';
      Double = 'd';
      DecimalValue = 'D';
      ShortString = 'Z';
      LongString = 'S';
      FieldArray = 'A';
      Timestamp = 'T';
      FieldTable = 'F';
      ByteArray = 'x';
      NoValue = 'V';

    constructor Create(const AValueType: Char);

    procedure Parse(const AType: Char; const AStream: TBytesStream); overload;
    procedure Parse(const AStream: TBytesStream); overload;
    procedure Write(AStream: TBytesStream);

    property ValueType: Char read FValueType write FValueType;
    property AsString: string read GetAsString Write SetAsString;
    property AsByte: Byte read GetAsByte Write SetAsByte;
  end;

implementation

uses
  DelphiAMQP.Util.Helpers, System.DateUtils, System.Math;

{ TAMQPValueType }

const
  sINVALID_STREAM = 'Invalid stream';

function TAMQPValueType.GetAsByte: Byte;
begin
  Result := FValue[0];
end;

function TAMQPValueType.GetAsString: string;
var
  offset: Byte;
begin
  offset := IfThen(TAMQPValueType.ShortString = FValueType, 1, 4);
  Result := TEncoding.ANSI.GetString(FValue, offset, Length(FValue) - offset);
end;

procedure TAMQPValueType.Parse(const AType: Char; const AStream: TBytesStream);
begin
  case AType of
    TAMQPValueType.Boolean, TAMQPValueType.ShortShortInt, TAMQPValueType.ShortShortUInt: ReadValue(AStream, 1);
    TAMQPValueType.ShortInt, TAMQPValueType.ShortUInt: ReadValue(AStream, 2);
    TAMQPValueType.LongInt, TAMQPValueType.Float, TAMQPValueType.LongUInt: ReadValue(AStream, 4);
    TAMQPValueType.LongLongInt, TAMQPValueType.Double, TAMQPValueType.Timestamp: ReadValue(AStream, 8);
    TAMQPValueType.DecimalValue: ReadValue(AStream, 5);
    TAMQPValueType.ShortString: ParseShortString(AStream);
    TAMQPValueType.LongString: ParseLongString(AStream);
    TAMQPValueType.FieldTable: ParseAMQPTable(AStream);
    TAMQPValueType.ByteArray: ParseByteArray(AStream);
    TAMQPValueType.FieldArray: ParseFieldArray(AStream);
    else
     Exit;
  end;
end;

procedure TAMQPValueType.ParseAMQPFieldValuePair(const AStream: TBytesStream);
var
  fieldName, fieldValue: TAMQPValueType;
  valueType: Char;
begin
  fieldName := TAMQPValueType.Create(TAMQPValueType.ShortString);
  try
    fieldName.Parse(AStream);
    AStream.Read(valueType, 1);

    fieldValue := TAMQPValueType.Create(valueType);
    fieldValue.Parse(AStream);
    FAMQPTable.Add(fieldName.GetAsString, fieldValue);
  finally
    fieldName.Free;
  end;
end;

procedure TAMQPValueType.ParseAMQPTable(const AStream: TBytesStream);
var
  tableSize: UInt32;
  endPos: Int64;
begin
  tableSize := AStream.AMQPReadLongUInt;
  endPos := AStream.Position + tableSize;

  FAMQPTable := TDictionary<string, TAMQPValueType>.Create;
  while AStream.Position < endPos do
    ParseAMQPFieldValuePair(AStream);
end;

procedure TAMQPValueType.ParseByteArray(const AStream: TBytesStream);
var
  size: Int32;
begin
  size := AStream.AMQPReadLongInt;
  AStream.Read(FValue, size);
end;

procedure TAMQPValueType.ParseFieldArray(const AStream: TBytesStream);
var
  size: Integer;
begin
  //TODO: !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
end;

procedure TAMQPValueType.ParseLongString(const AStream: TBytesStream);
var
  Size: Cardinal;
begin
  Size := AStream.AMQPReadLongUInt;
  ReadValue(AStream, Size);
end;

procedure TAMQPValueType.ParseShortString(const AStream: TBytesStream);
var
  stringSize: TBytes;
begin
  SetLength(stringSize, 1);
  if AStream.Read(stringSize, 1) <> 1 then
    raise EAMQPParserException.Create(sINVALID_STREAM);

  ReadValue(AStream, stringSize[0]);
end;

procedure TAMQPValueType.ReadValue(const AStream: TBytesStream; const ASize: Integer);
begin
  SetLength(FValue, ASize);

  if AStream.Read(FValue, ASize) <> ASize then
    raise EAMQPParserException.Create(sINVALID_STREAM);
end;

procedure TAMQPValueType.SetAsByte(const Value: Byte);
begin
  SetLength(FValue, SizeOf(Byte));
  FValue[0] := Value;
end;

procedure TAMQPValueType.SetAsString(const AValue: string);
begin
  case ValueType of
    TAMQPValueType.ShortString: SetShortString(AValue);
    TAMQPValueType.LongString: SetLongString(AValue);
  else
    raise EAMQPParserException.Create('Field is not a string type.');
  end;
end;

procedure TAMQPValueType.Write(AStream: TBytesStream);
begin
  AStream.Write(FValue, Length(FValue));
end;

constructor TAMQPValueType.Create(const AValueType: Char);
begin
  FValueType := AValueType;
end;

procedure TAMQPValueType.Parse(const AStream: TBytesStream);
begin
  Self.Parse(FValueType, AStream);
end;

procedure TAMQPValueType.SetShortString(const AValue: string);
var
  stringSize: Byte;
begin
  if Length(AValue) > 255 then
    raise EAMQPParserException.Create('Shortstring has more than 255 chars.');

  stringSize := Length(AValue);

  SetLength(FValue, 1+ stringSize);
  Move(stringSize, FValue[0], 1);
  Move(TEncoding.ANSI.GetBytes(AValue)[0], FValue[1], stringSize);
end;

procedure TAMQPValueType.SetLongString(const AValue: string);
var
  stringSize: UInt32;
  stream: TBytesStream;
begin
  if AValue.Length > UInt32.MaxValue then
    raise EAMQPParserException.Create('Shortstring has more than 255 chars.');

  stringSize := Length(AValue);

  SetLength(FValue, 4 + stringSize);
  AMQPMoveHex(stringSize, FValue, 0, SizeOf(UInt32));
  Move(TEncoding.ANSI.GetBytes(AValue)[0], FValue[4], stringSize);
end;

end.
