unit DelphiAMQP.Connections.AMQPConnection;

interface

uses
  DelphiAMQP.ConnectionIntf, DelphiAMQP.Frames.Connection, DelphiAMQP.AMQPTypes, DelphiAMQP.AMQPValue,
  DelphiAMQP.Channel, System.Generics.Collections;

type
  TAMQPConnection = class
  private
    FCon: IAMQPTCPConnection;
    FPassword: string;
    FUser: string;
    FVirtualHost: string;

    FReadTimeOut: Integer;
    FChannels: TObjectDictionary<Integer, TAMQPChannel>;

    procedure ReplyConnectionStart(const AStartFrame: TAMQPConnectionStartFrame);
    procedure ReplyConnectionTune(const ATuneFrame: TAMQPConnectionTuneFrame);
    procedure DoOpenConnection();
    procedure HandleConnectionStart();

    function BuildLongStringAMQPField(const AValue: string): TAMQPValueType;
    procedure SetReadTimeOut(const Value: Integer);

    function GetNewChannelId: UInt16;
    function DoOpenChannel(const AChannelId: UInt16): TAMQPChannel;
  public
    constructor Create(const AConnection: IAMQPTCPConnection);
    destructor Destroy; override;

    procedure Open;
    procedure Close;

    function OpenChannel(const ChannelId: UInt16 = 0): TAMQPChannel;

    function SetHost(const AHost: string): TAMQPConnection;
    function SetPort(const APort: Integer): TAMQPConnection;
    function SetConnectionString(const AConnectionString: string): TAMQPConnection;
    function SetUser(const AUser: string): TAMQPConnection;
    function SetPassword(const APassword: string): TAMQPConnection;

    property TCPConnection: IAMQPTCPConnection read FCon;
    property ReadTimeOut: Integer read FReadTimeOut write SetReadTimeOut;
    property Channels: TObjectDictionary<Integer, TAMQPChannel> read FChannels write FChannels;
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
    response := FCon.SendAndWaitReply(closeFrame, FReadTimeOut);

    if response is TAMQPConnectionCloseFrame then
    begin
      closeOkFrame := TAMQPConnectionCloseOkFrame.Create;
      FCon.Send(closeOkFrame);
      FCon.Close;
    end
    else if response is TAMQPConnectionCloseOkFrame then
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
  FChannels := TObjectDictionary<Integer, TAMQPChannel>.Create;

  FReadTimeOut := 5000;
  FVirtualHost := '/';
end;

destructor TAMQPConnection.Destroy;
begin
  FreeAndNil(FChannels);
  inherited;
end;

function TAMQPConnection.DoOpenChannel(const AChannelId: UInt16): TAMQPChannel;
var
  newChannel: TAMQPChannel;
  channelId: UInt16;
begin
  if AChannelId = 0 then
    channelId := GetNewChannelId()
  else
    channelId := AChannelId;

  newChannel := TAMQPChannel.Create(FCon, ChannelId);
  try
    newChannel.Open();
    FChannels.Add(ChannelId, newChannel);

    Result := newChannel;
  except
    FreeAndNil(newChannel);
    raise;
  end;
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

function TAMQPConnection.GetNewChannelId: UInt16;
var
  I: UInt16;
begin
  Result := 0;

  for I := 1 to High(UInt16) do
  begin
    if FChannels.ContainsKey(I) then
      Continue;

    Result := I;
    Exit;
  end;

  if Result = 0 then
    raise EAMQPChannel.Create('Couldn''t generate new channel id.');
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

function TAMQPConnection.OpenChannel(const ChannelId: UInt16): TAMQPChannel;
begin
  if FChannels.TryGetValue(ChannelId, Result) then
     Exit;

  Result := DoOpenChannel(ChannelId);
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

procedure TAMQPConnection.SetReadTimeOut(const Value: Integer);
begin
  FReadTimeOut := Value;
end;

function TAMQPConnection.SetUser(const AUSer: string): TAMQPConnection;
begin
  FUser := AUser;
  FCon.SetUser(AUSer);
  Result := Self;
end;

end.
