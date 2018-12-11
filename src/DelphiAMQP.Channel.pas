unit DelphiAMQP.Channel;

interface

uses
  DelphiAMQP.ConnectionIntf, DelphiAMQP.Frames.Channel,
  System.SysUtils, DelphiAMQP.Exchanges, System.Generics.Collections,
  DelphiAMQP.AMQPValue;

type
  EAMQPChannel = class(Exception);

  TAMQPChannel = class
  private
    FChannelId: UInt16;
    FCon: IAMQPTCPConnection;
    FActive: Boolean;
    FExchanges: TAMQPExchanges;

    procedure SetActive(const Value: Boolean);
  public
    constructor Create(const ACon: IAMQPTCPConnection; const AChannelId: Integer);
    destructor Destroy; override;

    procedure Open;
    procedure Close(const ACode: UInt8 = 200; const AReason: string = 'Channel close');

    property ChannelId: UInt16 read FChannelId;
    property Active: Boolean read FActive write SetActive;

    property Exchanges: TAMQPExchanges read FExchanges write FExchanges;

    procedure QueueDeclare(const AQueueName: string; const APassive: Boolean = False;
      const ADurable: Boolean = False; const AExclusive: Boolean = False; const AAutoDelete: Boolean = False;
      const Arguments: TArray<TPair<string, TAMQPValueType>> = nil);

    procedure QueueBind(const AQueueName, AExchangeName: string; const ARoutingKey: string = '';
      const Arguments: TArray<TPair<string, TAMQPValueType>> = nil);

    procedure QueueUnbind(const AQueueName, AExchangeName: string; const ARoutingKey: string = '';
      const Arguments: TArray<TPair<string, TAMQPValueType>> = nil);

    function QueuePurge(const AQueueName: string): Integer;

    function QueueDelete(const AQueueName: string; AIfUnused: Boolean = True; AIfEmpty: Boolean = True): Integer;

    function basicConsume(const AQueueName: string; const ANoAck: Boolean = False;
      const AExclusive: Boolean = False; const AConsumerTag: string = '';
      const ANoLocal: Boolean = False; const Arguments: TArray<TPair<string, TAMQPValueType>> = nil): string;
    procedure basicCancel(const AConsumerTag: string);
  end;

implementation

uses
  DelphiAMQP.Frames.Queue, DelphiAMQP.Frames.BasicFrame, DelphiAMQP.Frames.Basic;

{ TAMQPChannel }

procedure TAMQPChannel.basicCancel(const AConsumerTag: string);
var
  frame: TAMQPBasicCancelFrame;
  replyFrame: TAMQPBasicFrame;
begin
  replyFrame := nil;
  frame := TAMQPBasicCancelFrame.Create;
  try
    frame.FrameHeader.Channel := FChannelId;
    frame.ConsumerTag.AsString := AConsumerTag;

    replyFrame := FCon.SendAndWaitReply(frame);
    if not (replyFrame is TAMQPBasicCancelOkFrame) then
      raise EAMQPChannel.Create('Error while canceling consume');
  finally
    replyFrame.Free;
    frame.Free;
  end;
end;

function TAMQPChannel.basicConsume(const AQueueName: string; const ANoAck, AExclusive: Boolean;
  const AConsumerTag: string; const ANoLocal: Boolean;
  const Arguments: TArray<TPair<string, TAMQPValueType>>): string;
var
  frame: TAMQPBasicConsumeFrame;
  replyFrame: TAMQPBasicFrame;
  arg: TPair<string, TAMQPValueType>;
begin
  replyFrame := nil;
  frame := TAMQPBasicConsumeFrame.Create;
  try
    frame.FrameHeader.Channel := FChannelId;
    frame.Reserved1.AsWord := 0;
    frame.QueueName.AsString := AQueueName;
    frame.ConsumerTag.AsString := AConsumerTag;

    frame.NoAck.AsBoolean := ANoAck;
    frame.Exclusive.AsBoolean := AExclusive;
    frame.NoLocal.AsBoolean := ANoLocal;

    for arg in Arguments do
      frame.Arguments.AsAMQPTable.Add(arg.Key, arg.Value);

    replyFrame := FCon.SendAndWaitReply(frame);
    if not (replyFrame is TAMQPBasicConsumeOkFrame) then
      raise EAMQPChannel.Create('Error creating consumer.');

    result := (replyFrame as TAMQPBasicConsumeOkFrame).ConsumerTag.AsString;
  finally
    replyFrame.Free;
    frame.Free;
  end;
end;

procedure TAMQPChannel.Close(const ACode: UInt8; const AReason: string);
var
  frame: TAMQPChannelCloseFrame;
  replyFrame: TAMQPBasicFrame;
begin
  if not FActive then
    Exit;

  replyFrame := nil;
  frame := TAMQPChannelCloseFrame.Create;
  try
    frame.FrameHeader.Channel := FChannelId;
    frame.ReplyCode.AsWord := ACode;
    frame.ReplyText.AsString := AReason;
    frame.MethodId.AsWord := 0;
    frame.ClassId.AsWord := 0;

    replyFrame := FCon.SendAndWaitReply(frame, FCon.GetReadTimeOut);
    if not (replyFrame is TAMQPChannelCloseOkFrame) then
      raise Exception.Create('Error while closing channel'); //TODO: Handle it better

    FActive := False;
  finally
    FreeAndNil(frame);
    FreeAndNil(replyFrame);
  end;
end;

constructor TAMQPChannel.Create(const ACon: IAMQPTCPConnection; const AChannelId: Integer);
begin
  FCon := ACon;
  FChannelId := AChannelId;
  FExchanges := TAMQPExchanges.Create(FCon, FChannelId);
end;

procedure TAMQPChannel.Open;
var
  frame: TAMQPChannelOpenFrame;
  replyFrame: TAMQPBasicFrame;
begin
  if FActive then
    Exit;

  frame := TAMQPChannelOpenFrame.Create;
  try
    frame.FrameHeader.Channel := FChannelId;
    frame.Reserved1.AsBoolean := False;
    replyFrame := FCon.SendAndWaitReply(frame, FCon.GetReadTimeOut);

    if not Assigned(replyFrame) or (not (replyFrame is TAMQPChannelOpenOKFrame)) then
      raise EAMQPChannel.Create('Error while opening Channel'); //TODO: Handle it better

    FActive := True;
  finally
    FreeAndNil(frame);
  end;
end;

procedure TAMQPChannel.QueueBind(const AQueueName, AExchangeName, ARoutingKey: string;
  const Arguments: TArray<TPair<string, TAMQPValueType>>);
var
  frame: TAMQPQueueBindFrame;
  reply: TAMQPBasicFrame;
  arg: TPair<string, TAMQPValueType>;
begin
  reply := nil;
  frame := TAMQPQueueBindFrame.Create;
  try
    frame.FrameHeader.Channel := FChannelId;

    frame.Reserved1.AsWord := 0;
    frame.QueueName.AsString := AQueueName;
    frame.ExchangeName.AsString := AExchangeName;
    frame.RoutingKey.AsString := ARoutingKey;
    frame.NoWait.AsBoolean := False;

    for arg in Arguments do
      frame.Arguments.AsAMQPTable.Add(arg.Key, arg.Value);

    reply := FCon.SendAndWaitReply(frame);
    if not (reply is TAMQPQueueBindOkFrame) then
      raise EAMQPChannel.Create('Error while binding queue');
  finally
    frame.Free;
    reply.Free;
  end;
end;

procedure TAMQPChannel.QueueDeclare(const AQueueName: string; const APassive, ADurable: Boolean;
  const AExclusive: Boolean; const AAutoDelete: Boolean; const Arguments: TArray<TPair<string, TAMQPValueType>>);
var
  frame: TAMQPQueueDeclareFrame;
  reply: TAMQPBasicFrame;
  arg: TPair<string, TAMQPValueType>;
begin
  reply := nil;
  frame := TAMQPQueueDeclareFrame.Create;
  try
    frame.FrameHeader.Channel := FChannelId;

    frame.Reserved1.AsWord := 0;
    frame.QueueName.AsString := AQueueName;
    frame.Passive.AsBoolean := APassive;
    frame.Durable.AsBoolean := ADurable;
    frame.Exclusive.AsBoolean := AExclusive;
    frame.AutoDelete.AsBoolean := AAutoDelete;
    frame.NoWait.AsBoolean := False;

    for arg in Arguments do
      frame.Arguments.AsAMQPTable.Add(arg.Key, arg.Value);

    reply := FCon.SendAndWaitReply(frame);
    if not (reply is TAMQPQueueDeclareOkFrame) then
      raise EAMQPChannel.Create('Error while declaring queue');
  finally
    reply.Free();
    frame.Free();
  end;
end;

function TAMQPChannel.QueueDelete(const AQueueName: string; AIfUnused, AIfEmpty: Boolean): Integer;
var
  frame: TAMQPQueueDeleteFrame;
  reply: TAMQPBasicFrame;
begin
  reply := nil;
  frame := TAMQPQueueDeleteFrame.Create;
  try
    frame.FrameHeader.Channel := FChannelId;

    frame.Reserved1.AsWord := 0;
    frame.QueueName.AsString := AQueueName;
    frame.IfUnused.AsBoolean := AIfUnused;
    frame.IfEmpty.AsBoolean := AIfEmpty;
    frame.NoWait.AsBoolean := False;

    reply := FCon.SendAndWaitReply(frame);
    if not (reply is TAMQPQueueDeleteOkFrame) then
      raise EAMQPChannel.Create('Error while deleting queue');

    Result := (reply as TAMQPQueueDeleteOkFrame).MessageCount.AsInt32;
  finally
    frame.Free;
    reply.Free;
  end;
end;

function TAMQPChannel.QueuePurge(const AQueueName: string): Integer;
var
  frame: TAMQPQueuePurgeFrame;
  reply: TAMQPBasicFrame;
begin
  reply := nil;
  frame := TAMQPQueuePurgeFrame.Create;
  try
    frame.FrameHeader.Channel := FChannelId;

    frame.Reserved1.AsWord := 0;
    frame.QueueName.AsString := AQueueName;
    frame.NoWait.AsBoolean := False;

    reply := FCon.SendAndWaitReply(frame);
    if not (reply is TAMQPQueuePurgeOkFrame) then
      raise EAMQPChannel.Create('Error while purging queue');

    Result := (reply as TAMQPQueuePurgeOkFrame).MessageCount.AsInt32;
  finally
    frame.Free;
    reply.Free;
  end;
end;

procedure TAMQPChannel.QueueUnbind(const AQueueName, AExchangeName, ARoutingKey: string;
  const Arguments: TArray<TPair<string, TAMQPValueType>>);
var
  frame: TAMQPQueueUnbindFrame;
  reply: TAMQPBasicFrame;
  arg: TPair<string, TAMQPValueType>;
begin
  reply := nil;
  frame := TAMQPQueueUnbindFrame.Create;
  try
    frame.FrameHeader.Channel := FChannelId;

    frame.Reserved1.AsWord := 0;
    frame.QueueName.AsString := AQueueName;
    frame.ExchangeName.AsString := AExchangeName;
    frame.RoutingKey.AsString := ARoutingKey;

    for arg in Arguments do
      frame.Arguments.AsAMQPTable.Add(arg.Key, arg.Value);

    reply := FCon.SendAndWaitReply(frame);
    if not (reply is TAMQPQueueUnbindOkFrame) then
      raise EAMQPChannel.Create('Error while unbinding queue');
  finally
    frame.Free;
    reply.Free;
  end;
end;

procedure TAMQPChannel.SetActive(const Value: Boolean);
begin
  if FActive = Value then
    Exit;

  if Value then
    Open()
  else
    Close();
end;

destructor TAMQPChannel.Destroy;
begin
  FreeAndNil(FExchanges);

  inherited;
end;

end.
