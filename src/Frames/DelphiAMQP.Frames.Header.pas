unit DelphiAMQP.Frames.Header;

interface

uses
  System.Classes, System.SysUtils;

type
  TAMQPFrameHeader = class(TPersistent)
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
    procedure Write(const AStream: TBytesStream);

    procedure Assign(ASource: TPersistent); override;

    property FrameType: Byte read GetFrameType write SetFrameType;
    property Channel: Word read GetChannel write SetChannel;
    property Size: FixedUInt read GetSize write SetSize;
  end;

implementation

uses
  DelphiAMQP.Util.Helpers;

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

procedure TAMQPFrameHeader.Write(const AStream: TBytesStream);
var
  data: TBytes;
begin
  SetLength(data, 7);
  AMQPMoveEx(FFrameType, data, 0, 1);
  AMQPMoveEx(FChannel, data, 1, 2);
  AMQPMoveEx(FSize, data, 3, 4);
  AStream.Write(data, 7);
end;

procedure TAMQPFrameHeader.Assign(ASource: TPersistent);
begin
  if not (ASource is TAMQPFrameHeader) then
    raise Exception.Create('Source must be a TAMQPFrameHeader object.');

  FFrameType := (ASource as TAMQPFrameHeader).FrameType;
  FChannel := (ASource as TAMQPFrameHeader).Channel;
  FSize := (ASource as TAMQPFrameHeader).Size;
end;

end.
