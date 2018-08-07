unit DelphiAMQP.AMQPValue;

interface

uses
  System.Classes, System.SysUtils, System.Generics.Collections;

type
  EAMQPParserException = class(Exception);

  TAMQPValueType = class
  private
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

    constructor Create(const AValueType: Char); override;

    procedure Parse(const AType: Char; const AStream: TBytesStream); overload;
    procedure Parse(const AStream: TBytesStream); overload;
    procedure Write(AStream: TBytesStream);

    property ValueType: Char read FValueType write FValueType;
    property AsString: string read GetAsString Write SetAsString;
  end;

implementation

uses
  DelphiAMQP.Util.Helpers, System.DateUtils;

{ TAMQPValueType }

const
  sINVALID_STREAM = 'Invalid stream';

function TAMQPValueType.GetAsString: string;
begin
  Result := TEncoding.ANSI.GetString(FValue);
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
  fieldName := TAMQPValueType.Create;
  try
    fieldName.ParseShortString(AStream);
    AStream.Read(valueType, 1);

    fieldValue := TAMQPValueType.Create;
    fieldValue.Parse(valueType, AStream);
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

procedure TAMQPValueType.SetAsString(const AValue: string);
begin

end;

procedure TAMQPValueType.Write(AStream: TBytesStream);
begin
  AStream.Write(FValue, Length(FValue));
end;

constructor TAMQPValueType.Create(const AValueType: Char);
begin
  inherited;
  FValueType := AValueType;
end;

procedure TAMQPValueType.Parse(const AStream: TBytesStream);
begin
  Self.Parse(FValueType, AStream);
end;

end.
