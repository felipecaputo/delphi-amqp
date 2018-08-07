unit DelphiAMQP.Connections.Indy;

interface

uses
  DelphiAMQP.FrameIntf, System.SysUtils, IdTCPClient, System.Classes,
  DelphiAMQP.ConnectionIntf;

type
  EAMQPBadFrame = class(Exception);

  TAMQPIndyConnection = class(TComponent, IAMQPTCPConnection)
  private
    FCon: TIdTcpClient;
    FUser: string;
    FPassword: string;

    procedure HandleConnectionStart;
  public
    constructor Create(AOwner: TComponent); override;

    procedure Open;
    procedure Close;

    function SetHost(const AHost: string): IAMQPTCPConnection;
    function SetPort(const APort: Integer): IAMQPTCPConnection;
    function SetConnectionString(const AConnectionString: string): IAMQPTCPConnection;
    function SetUser(const AUser: string): IAMQPTCPConnection;
    function SetPassword(const APassword: string): IAMQPTCPConnection;

    procedure Send(const AFrame: IAMQPFrame);
    function SendAndWaitReply(const AFrame: IAMQPFrame; const ATimeOut: Cardinal = 0): IAMQPFrame;
    function Receive(const ATimeOut: Cardinal = 0): IAMQPFrame;
  end;

implementation

uses
  IdGlobal, DelphiAMQP.Frames.Header, DelphiAMQP.Fames.ConnectionStartHeader,
  DelphiAMQP.Constants;

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

procedure TAMQPIndyConnection.HandleConnectionStart;
var
  Response: TIdBytes;
  Header: TAMQPFrameHeader;
  oStream: TBytesStream;
  oFrame: TAMQPConnectionStartHeaderFrame;
begin
  FCon.ReadTimeout := 1000;
  FCon.Socket.Write(sPROTOCOL_HEADER + Chr(0) + Chr(0) + Chr(9) + Chr(1), IndyTextEncoding_ASCII());
  Response := nil;
  FCon.Socket.ReadBytes(Response, 7);
  Header := TAMQPFrameHeader.Create(TBytes(Response));
  try
    oStream := TBytesStream.Create;
    FCon.Socket.ReadStream(oStream, Header.Size);
    if Header.FrameType <> 1 then
      raise Exception.Create('Error Message');

    oFrame := TAMQPConnectionStartHeaderFrame.Create;
    oStream.Position := 0;
    oFrame.Parse(oStream);
    Response := nil;
    FCon.Socket.ReadBytes(Response, 1);
    if Response[0] <> FRAME_END then
      raise EAMQPBadFrame.CreateFmt('Bad frame received. Expected framend, received %d', [Response[0]]);
  finally
    Header.Free;
  end;
end;

procedure TAMQPIndyConnection.Open;
begin
  FCon.Connect;
  HandleConnectionStart();
end;

function TAMQPIndyConnection.Receive(const ATimeOut: Cardinal): IAMQPFrame;
begin

end;

procedure TAMQPIndyConnection.Send(const AFrame: IAMQPFrame);
begin
  FCon.Socket.Write(TIdBytes(AFrame.MethodFrame.AsBytes));
end;

function TAMQPIndyConnection.SendAndWaitReply(const AFrame: IAMQPFrame;
  const ATimeOut: Cardinal): IAMQPFrame;
begin

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
