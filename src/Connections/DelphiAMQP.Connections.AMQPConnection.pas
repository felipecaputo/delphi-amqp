unit DelphiAMQP.Connections.AMQPConnection;

interface

uses
  DelphiAMQP.ConnectionIntf, DelphiAMQP.Frames.Connection, DelphiAMQP.AMQPTypes, DelphiAMQP.AMQPValue;

type
  TAMQPConnection = class
  private
    FCon: IAMQPTCPConnection;
    FPassword: string;
    FUser: string;
    FVirtualHost: string;

  private
    FReadTimeOut: Integer;

    procedure ReplyConnectionStart(const AStartFrame: TAMQPConnectionStartFrame);
    procedure ReplyConnectionTune(const ATuneFrame: TAMQPConnectionTuneFrame);
    procedure DoOpenConnection();
    procedure HandleConnectionStart();

    function BuildLongStringAMQPField(const AValue: string): TAMQPValueType;
  public
    constructor Create(const AConnection: IAMQPTCPConnection);

    procedure Open;
    procedure Close;

    function SetHost(const AHost: string): TAMQPConnection;
    function SetPort(const APort: Integer): TAMQPConnection;
    function SetConnectionString(const AConnectionString: string): TAMQPConnection;
    function SetUser(const AUser: string): TAMQPConnection;
    function SetPassword(const APassword: string): TAMQPConnection;

    property TCPConnection: IAMQPTCPConnection read FCon;
    property ReadTimeOut: Integer read FReadTimeOut write FReadTimeOut;
  end;

implementation

uses
  System.SysUtils,
  DelphiAMQP.Util.Functions, DelphiAMQP.Constants,
  DelphiAMQP.Frames.BasicFrame;

{ TAMQPConnection }

function TAMQPConnection.BuildLongStringAMQPField(const AValue: string): TAMQPValueType;
begin
  Result := TAMQPValueType.Create(TAMQPValueType.LongString);
  try
    Result.AsString := AValue;
  except
    FreeAndNil(Result);
    raise;
  end;
end;

procedure TAMQPConnection.Close;
var
  closeFrame: TAMQPConnectionCloseFrame;
  closeOkFrame: TAMQPConnectionCloseOkFrame;
  response: TAMQPBasicFrame;
begin
  response := nil;
  closeOkFrame := nil;
  closeFrame := TAMQPConnectionCloseFrame.Create;
  try
    FCon.Send(closeFrame);
    response := FCon.Receive(FReadTimeOut);

    if response is TAMQPConnectionCloseFrame then
    begin
      closeOkFrame := TAMQPConnectionCloseOkFrame.Create;
      FCon.Send(closeOkFrame);
      FCon.Close;
    end;

    if response is TAMQPConnectionCloseOkFrame then
      FCon.Close;
  finally
    FreeAndNil(closeFrame);
    FreeAndNil(closeOkFrame);
    FreeAndNil(response);
  end;
end;

constructor TAMQPConnection.Create(const AConnection: IAMQPTCPConnection);
begin
  FCon := AConnection;
  FReadTimeOut := 5000;
  FVirtualHost := '/';
end;

procedure TAMQPConnection.DoOpenConnection;
var
  openCon: TAMQPConnectionOpenFrame;
  reply: TAMQPBasicFrame;
begin
  openCon := TAMQPConnectionOpenFrame.Create;
  try
    openCon.VHost.AsString := FVirtualHost;
    openCon.Reserved1.AsString := '';
    openCon.Reserved2.AsBoolean := False;

    FCon.Send(openCon);
    reply := FCon.Receive(FReadTimeOut);
    if not (reply is TAMQPConnectionOpenOkFrame) then
      raise Exception.Create('Error Message');
  finally
    FreeAndNil(openCon);
  end;
end;

procedure TAMQPConnection.HandleConnectionStart;
var
  oFrame: TAMQPConnectionStartFrame;
  Frame: TAMQPBasicFrame;
begin
  oFrame := FCon.Receive(FReadTimeOut) as TAMQPConnectionStartFrame;
  ReplyConnectionStart(oFrame);
  Frame := FCon.Receive(FReadTimeOut);
  ReplyConnectionTune(Frame as TAMQPConnectionTuneFrame);
  DoOpenConnection();
end;

procedure TAMQPConnection.Open;
begin
  FCon.Open;
  HandleConnectionStart();
end;

procedure TAMQPConnection.ReplyConnectionStart(const AStartFrame: TAMQPConnectionStartFrame);
var
  Reply: TAMQPConnectionStartOkFrame;
begin
  Reply := TAMQPConnectionStartOkFrame.Create;
  try
    Reply.ClientProperties.AsAMQPTable.Add('product', BuildLongStringAMQPField('delphi-amqp'));
    Reply.ClientProperties.AsAMQPTable.Add('version', BuildLongStringAMQPField('DELPHI_AMQP_VERSION'));
    {$IFDEF LINUX64}
    Reply.ClientProperties.AsAMQPTable.Add('platform', BuildLongStringAMQPField('linux'));
    {$ELSE}
    Reply.ClientProperties.AsAMQPTable.Add('platform', BuildLongStringAMQPField('windows'));
    {$ENDIF}


    Reply.Locale.AsString := 'en_US';
    Reply.Mechanism.AsString := LOGIN_TYPE_PLAIN;
    Reply.Response.AsString := getAMQPSecurityRespose(Reply.Mechanism.AsString, FUser, FPassword);
    FCon.Send(Reply);
  finally
    FreeAndNil(Reply);
  end;
end;

procedure TAMQPConnection.ReplyConnectionTune(const ATuneFrame: TAMQPConnectionTuneFrame);
var
  tuneOk: TAMQPConnectionTuneOkFrame;
begin
  tuneOk := TAMQPConnectionTuneOkFrame.Create;
  try
    tuneOk.ChannelMax.AsWord := ATuneFrame.ChannelMax.AsWord;
    tuneOk.FrameMax.AsInt32 := ATuneFrame.FrameMax.AsInt32;
    tuneOk.HeartBeat.AsWord := ATuneFrame.HeartBeat.AsWord;

    FCon.Send(tuneOk);
  finally
    FreeAndNil(tuneOk);
  end;
end;

function TAMQPConnection.SetConnectionString(const AConnectionString: string): TAMQPConnection;
begin
  FCon.SetConnectionString(AConnectionString);
  Result := Self;
end;

function TAMQPConnection.SetHost(const AHost: string): TAMQPConnection;
begin
  FCon.SetHost(AHost);
  Result := Self;
end;

function TAMQPConnection.SetPassword(const APassword: string): TAMQPConnection;
begin
  FPassword := APassword;
  FCon.SetPassword(APassword);
  Result := Self;
end;

function TAMQPConnection.SetPort(const APort: Integer): TAMQPConnection;
begin
  FCon.SetPort(APort);
  Result := Self;
end;

function TAMQPConnection.SetUser(const AUSer: string): TAMQPConnection;
begin
  FUser := AUser;
  FCon.SetUser(AUSer);
  Result := Self;
end;

end.
