unit DelphiAMQP.Util.Helpers;

interface

uses
  System.Classes, System.SysUtils;

type
  TAMQPStreamHelper = class helper for TMemoryStream
  private
  public
    function AMQPReadShortUInt: Word;
    function AMQPReadLongUInt: FixedUInt;
    function AMQPReadLongInt: Int32;
    function AMQPReadLongLongUInt: UInt64;
  end;

  TAMQPWriter = class
    class procedure WriteShortString(Data: TBytes; const AValue: string);
  end;

  procedure AMQPMoveEx(const Source; var Dest: TBytes; Offset, Count: Integer);

implementation

{ TAMQPStreamHelper }

procedure AMQPMoveEx(const Source; var Dest: TBytes; Offset, Count: Integer);
var
  temp: TBytes;
  I: Integer;
begin
  SetLength(temp, Count);
  Move(Source, temp[0], Count);
  for I := Pred(Count) downto 0 do
    Move(temp[I], Dest[Offset + Abs(Count - Succ(I))], SizeOf(Byte));
end;

function TAMQPStreamHelper.AMQPReadLongInt: Int32;
var
  buffer: TBytes;
begin
  SetLength(buffer, 4);
  Read(buffer, 4);
  Result := Int32(buffer[3]);
  Result := Result or Int32(buffer[2] shl 8);
  Result := Result or Int32(buffer[1] shl 16);
  Result := Result or Int32(buffer[0] shl 24);
end;

function TAMQPStreamHelper.AMQPReadLongLongUInt: UInt64;
var
  buffer: TBytes;
  Byte1: UInt32;
begin
  SetLength(buffer, 8);
  Read(buffer, 8);
  Byte1 := Int32(buffer[7]);
  Byte1 := Byte1 or UInt32(buffer[6] shl 8);
  Byte1 := Byte1 or UInt32(buffer[5] shl 16);
  Byte1 := Byte1 or UInt32(buffer[4] shl 24);
  Move(Byte1, Result, 4);
  Result := Result or UInt32(buffer[3]);
  Result := Result or UInt32(buffer[2] shl 8);
  Result := Result or UInt32(buffer[1] shl 16);
  Result := Result or UInt32(buffer[0] shl 24);
end;

function TAMQPStreamHelper.AMQPReadLongUInt: FixedUInt;
var
  buffer: TBytes;
begin
  SetLength(buffer, 4);
  Read(buffer, 4);
  Result := FixedUInt(buffer[3]);
  Result := Result or FixedUInt(buffer[2] shl 8);
  Result := Result or FixedUInt(buffer[1] shl 16);
  Result := Result or FixedUInt(buffer[0] shl 24);
end;

function TAMQPStreamHelper.AMQPReadShortUInt: Word;
var
  buffer: TBytes;
begin
  SetLength(buffer, 2);
  Read(buffer, 2);
  Result := Word(buffer[1]);
  Result := Result or Word(buffer[0] shl 8);
end;

{ TAMQPWriter }

class procedure TAMQPWriter.WriteShortString(Data: TBytes; const AValue: string);
var
  l: Byte;
  I: Integer;
  val: TBytes;
begin
  l := Length(AValue);
  SetLength(Data, l + 1);

  Data[0] := l;

  val := TEncoding.ANSI.GetBytes(AValue);

  for I := 0 to Pred(l) do
    Data[I+1] := val[I];
end;

end.
