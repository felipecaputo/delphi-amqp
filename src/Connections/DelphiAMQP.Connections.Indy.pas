unit DelphiAMQP.Connections.Indy;

interface

uses
  DelphiAMQP.Frames.BasicFrame, System.SysUtils, IdTCPClient, System.Classes,
  DelphiAMQP.ConnectionIntf;

type
  EAMQPBadFrame = class(Exception);

  TAMQPIndyConnection = class(TComponent, IAMQPTCPConnection)
  private
    FCon: TIdTcpClient;
    FUser: string;
    FPassword: string;

  public
    constructor Create(AOwner: TComponent); override;

    procedure Open;
    procedure Close;

    function SetHost(const AHost: string): IAMQPTCPConnection;
    function SetPort(const APort: Integer): IAMQPTCPConnection;
    function SetConnectionString(const AConnectionString: string): IAMQPTCPConnection;
    function SetUser(const AUser: string): IAMQPTCPConnection;
    function SetPassword(const APassword: string): IAMQPTCPConnection;

    procedure Send(const AFrame: TAMQPBasicFrame);
    function SendAndWaitReply(const AFrame: TAMQPBasicFrame; const ATimeOut: Cardinal = 0): TAMQPBasicFrame;
    function Receive(const ATimeOut: Cardinal = 0): TAMQPBasicFrame;
  end;

implementation

uses
  IdGlobal, DelphiAMQP.Frames.Header, DelphiAMQP.Constants, DelphiAMQP.Frames.Factory;

const
  sPROTOCOL_HEADER = 'AMQP';

{ TAMQPIndyConnection }

procedure TAMQPIndyConnection.Close;
begin
  FCon.Disconnect;
end;

constructor TAMQPIndyConnection.Create(AOwner: TComponent);
begin
  inherited;
  FCon := TIdTCPClient.Create(Self);
end;

procedure TAMQPIndyConnection.Open;
begin
  FCon.Connect;
  FCon.Socket.Write(sPROTOCOL_HEADER + Chr(0) + Chr(0) + Chr(9) + Chr(1), IndyTextEncoding_ASCII());
end;

function TAMQPIndyConnection.Receive(const ATimeOut: Cardinal = 0): TAMQPBasicFrame;
var
  Response: TIdBytes;
  Header: TAMQPFrameHeader;
  oStream: TBytesStream;
  oFrame: TAMQPBasicFrame;
begin
  FCon.ReadTimeout := ATimeOut;
  Response := nil;
  FCon.Socket.ReadBytes(Response, 7);
  Header := TAMQPFrameHeader.Create(TBytes(Response));
  try
    oStream := TBytesStream.Create;
    FCon.Socket.ReadStream(oStream, Header.Size);
    oStream.Position := 0;
    oFrame := TAMQPFrameFactory.BuildFrame(oStream);
    oFrame.Read(oStream);
    Response := nil;
    FCon.Socket.ReadBytes(Response, 1);
    if Response[0] <> FRAME_END then
      raise EAMQPBadFrame.CreateFmt('Bad frame received. Expected framend, received %d', [Response[0]]);

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
    FCon.Socket.Write(TIdBytes(Stream.Bytes));
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

function TAMQPIndyConnection.SetUser(const AUser: string): IAMQPTCPConnection;
begin
  FUser := AUser;
  Result := Self;
end;

end.
