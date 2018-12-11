unit DelphiAMQP.Connections.Indy;

interface

uses
  DelphiAMQP.Frames.BasicFrame, System.SysUtils, IdTCPClient, System.Classes,
  DelphiAMQP.ConnectionIntf;

type
  EAMQPBadFrame = class(Exception);

  TAMQPIndyConnection = class(TInterfacedObject, IAMQPTCPConnection)
  private
    FCon: TIdTcpClient;
    FUser: string;
    FPassword: string;
    FTimeOut: Cardinal;

  public
    constructor Create;

    procedure Open;
    procedure Close;

    function SetHost(const AHost: string): IAMQPTCPConnection;
    function SetPort(const APort: Integer): IAMQPTCPConnection;
    function SetConnectionString(const AConnectionString: string): IAMQPTCPConnection;
    function SetUser(const AUser: string): IAMQPTCPConnection;
    function SetPassword(const APassword: string): IAMQPTCPConnection;
    function SetReadTimeOut(const ATimeOut: Cardinal): IAMQPTCPConnection;

    function GetReadTimeOut: Cardinal;

    procedure Send(const AFrame: TAMQPBasicFrame);
    function SendAndWaitReply(const AFrame: TAMQPBasicFrame;
      const ATimeOut: Cardinal = 0): TAMQPBasicFrame;
    function Receive(const ATimeOut: Cardinal = 0): TAMQPBasicFrame;

    property TimeOut: Cardinal read FTimeOut write FTimeOut;
  end;

implementation

uses
  IdGlobal, DelphiAMQP.Frames.Header, DelphiAMQP.Constants, DelphiAMQP.Frames.Factory,
  System.Math;

const
  sPROTOCOL_HEADER = 'AMQP';

{ TAMQPIndyConnection }

procedure TAMQPIndyConnection.Close;
begin
  FCon.Disconnect;
end;

constructor TAMQPIndyConnection.Create;
begin
  inherited;
  FCon := TIdTCPClient.Create(nil);
end;

function TAMQPIndyConnection.GetReadTimeOut: Cardinal;
begin
  Result := FCon.ReadTimeout;
end;

procedure TAMQPIndyConnection.Open;
begin
  FCon.Connect;
  FCon.Socket.Write(sPROTOCOL_HEADER + Chr(0) + Chr(0) + Chr(9) + Chr(1), IndyTextEncoding_ASCII());
end;

function TAMQPIndyConnection.Receive(const ATimeOut: Cardinal = 0): TAMQPBasicFrame;
var
  frameEndByte: Byte;
  Header: TAMQPFrameHeader;
  oStream: TBytesStream;
  oFrame: TAMQPBasicFrame;
begin
  Header := nil;
  if ATimeOut = 0 then
    FCon.ReadTimeout := FTimeOut
  else
    FCon.ReadTimeout := ATimeOut;

  oStream := TBytesStream.Create;
  try
    FCon.Socket.ReadStream(oStream, 7);
    Header := TAMQPFrameHeader.Create(oStream.Bytes);
    oStream.Clear();
    FCon.Socket.ReadStream(oStream, Header.Size + 1);
    oStream.Position := 0;
    oFrame := TAMQPFrameFactory.BuildFrame(oStream);
    oFrame.Read(oStream);
    oStream.Read(frameEndByte, 1);

    if frameEndByte <> FRAME_END then
      raise EAMQPBadFrame.CreateFmt('Bad frame received. Expected framend, received %d', [frameEndByte]);

    Result := oFrame;
  finally
    Header.Free;
  end;
end;

procedure TAMQPIndyConnection.Send(const AFrame: TAMQPBasicFrame);
var
  Stream: TBytesStream;
  FrameEnd: TBytes;
begin
  Stream := TBytesStream.Create();
  try
    //TODO: MAKE IT A BETTER WAY
    SetLength(FrameEnd, 1);
    FrameEnd[0] := FRAME_END;

    AFrame.Write(Stream);
    Stream.Write(FrameEnd, 1);
    Stream.Position := 0;
    FCon.Socket.Write(Stream, Stream.Size);
  finally
    FreeAndNil(Stream);
  end;
end;

function TAMQPIndyConnection.SendAndWaitReply(const AFrame: TAMQPBasicFrame; const ATimeOut: Cardinal = 0): TAMQPBasicFrame;
begin
  Send(AFrame);
  Result := Receive(ATimeOut);
end;

function TAMQPIndyConnection.SetConnectionString(
  const AConnectionString: string): IAMQPTCPConnection;
begin
  raise Exception.Create('Not Implemented Yet');
  Result := Self;
end;

function TAMQPIndyConnection.SetHost(const AHost: string): IAMQPTCPConnection;
begin
  FCon.Host := AHost;
  Result := Self;
end;

function TAMQPIndyConnection.SetPassword(const APassword: string): IAMQPTCPConnection;
begin
  FPassword := APassword;
  Result := Self;
end;

function TAMQPIndyConnection.SetPort(const APort: Integer): IAMQPTCPConnection;
begin
  FCon.Port := APort;
  Result := Self;
end;

function TAMQPIndyConnection.SetReadTimeOut(const ATimeOut: Cardinal): IAMQPTCPConnection;
begin
  FTimeOut := ATimeOut
end;

function TAMQPIndyConnection.SetUser(const AUser: string): IAMQPTCPConnection;
begin
  FUser := AUser;
  Result := Self;
end;

end.
