unit DelphiAMQP.Frames.Header;

interface

uses
  System.SysUtils;

type
  TAMQPFrameHeader = class
  private
    FFrameType: Byte;
    FChannel: Word;
    FSize: FixedUInt;

    procedure SetFrameType(const Value: Byte);
    function GetFrameType: Byte;
    function GetChannel: Word;
    procedure SetChannel(const Value: Word);
    function GetSize: FixedUInt;
    procedure SetSize(const Value: FixedUInt);
  public
    constructor Create(const APayload: TBytes);

    procedure Load(const APayload: TBytes);

    property FrameType: Byte read GetFrameType write SetFrameType;
    property Channel: Word read GetChannel write SetChannel;
    property Size: FixedUInt read GetSize write SetSize;
  end;

implementation

uses
  System.Classes, DelphiAMQP.Util.Helpers;

{ TAMQPFrameHeader }

constructor TAMQPFrameHeader.Create(const APayload: TBytes);
begin
  if APayload <> nil then
    Load(APayload);
end;

function TAMQPFrameHeader.GetChannel: Word;
begin
  Result := FChannel;
end;

function TAMQPFrameHeader.GetFrameType: Byte;
begin
  Result := FFrameType;
end;

function TAMQPFrameHeader.GetSize: FixedUInt;
begin
  Result := FSize;
end;

procedure TAMQPFrameHeader.Load(const APayload: TBytes);
var
  oStream: TMemoryStream;
begin
  oStream := TMemoryStream.Create;
  try
    Assert(Length(APayload) = 7, 'Invalid frame header size');
    oStream.Size := 7;
    oStream.Write(APayload, 7);
    oStream.Position := 0;
    oStream.Read(FFrameType, 1);
    FChannel := oStream.AMQPReadShortUInt;
    FSize := oStream.AMQPReadLongUInt();
  finally
    oStream.Free;
  end;

end;

procedure TAMQPFrameHeader.SetChannel(const Value: Word);
begin
  FChannel := Value;
end;

procedure TAMQPFrameHeader.SetFrameType(const Value: Byte);
begin
  FFrameType := Value;
end;

procedure TAMQPFrameHeader.SetSize(const Value: FixedUInt);
begin
  FSize := Value;
end;

end.
