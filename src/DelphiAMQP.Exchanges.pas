unit DelphiAMQP.Exchanges;

interface

uses
  DelphiAMQP.ConnectionIntf, DelphiAMQP.Frames.Exchange, System.SysUtils;

type
  EAMQPExchange = class(Exception);

  TAMQPExchangeTypes = class
    public
      const
        Direct = 'direct';
        FanOut = 'fanout';
        Topic = 'topic';
        Headers = 'headers';
  end;

  TAMQPExchanges = class
  private
    FCon: IAMQPTCPConnection;
    FChannelId: Integer;
  public
    constructor Create(const AConnection: IAMQPTCPConnection; const AChannelId: Integer);

    procedure Declare(const AExchangeName: string; const AType: string = TAMQPExchangeTypes.Direct);
    procedure Delete(const AExchangeName: string; const AOnlyIfUnused: Boolean = True;
      const ANoWait: Boolean = False);

    procedure Bind(const ASourceExchange, ATargetExchange: string; const ARoutingKey: string);
    procedure Unbind(const ASourceExchange, ATargetExchange: string; const ARoutingKey: string);
  end;

implementation

uses
  DelphiAMQP.Frames.BasicFrame;

procedure TAMQPExchanges.Declare(const AExchangeName: string; const AType: string);
var
  frame: TAMQPExchangeDeclareFrame;
  response: TAMQPBasicFrame;
begin
  if AExchangeName = EmptyStr then
    raise EAMQPExchange.Create('Exchange name cannot be empty.');

  if AType = EmptyStr then
    raise EAMQPExchange.Create('Exchange type cannot be empty.');

  response := nil;
  frame := TAMQPExchangeDeclareFrame.Create;
  try
    frame.FrameHeader.Channel := FChannelId;
    frame.Reserverd1.AsWord := 0;
    frame.ExchangeName.AsString := AExchangeName;
    frame.ExchangeType.AsString := AType;
    frame.Durable.AsBoolean := True;
    response := FCon.SendAndWaitReply(frame);
    if not (response is TAMQPExchangeDeclareOkFrame) then
      raise EAMQPExchange.Create('Error while creating exchange');
  finally
    FreeAndNil(frame);
    FreeAndNil(Response);
  end;
end;

procedure TAMQPExchanges.Bind(const ASourceExchange, ATargetExchange, ARoutingKey: string);
var
  frame: TAMQPExchangeBindFrame;
  reply: TAMQPBasicFrame;
begin
  reply := nil;
  frame := TAMQPExchangeBindFrame.Create;
  try
    frame.Reserved1.AsWord := 0;
    frame.Destination.AsString := ATargetExchange;
    frame.Source.AsString := ASourceExchange;
    frame.RoutingKey.AsString := ARoutingKey;
    frame.NoWait.AsBoolean := False;

    reply := FCon.SendAndWaitReply(frame);
    if not (reply is TAMQPExchangeBindOkFrame) then
      raise EAMQPExchange.Create('Error while binding exchanges.');
  finally
    FreeAndNil(reply);
    FreeAndNil(frame);
  end;
end;

constructor TAMQPExchanges.Create(const AConnection: IAMQPTCPConnection; const AChannelId: Integer);
begin
  FCon := AConnection;
  FChannelId := AChannelId;
end;

procedure TAMQPExchanges.Delete(const AExchangeName: string; const AOnlyIfUnused: Boolean; const ANoWait: Boolean);
var
  frame: TAMQPExchangeDeleteFrame;
  response: TAMQPBasicFrame;
begin
  frame := TAMQPExchangeDeleteFrame.Create;
  try
    frame.Reserved1.AsWord := 0;
    frame.FrameHeader.Channel := FChannelId;
    frame.ExchangeName.AsString := AExchangeName;
    frame.IfUnused.AsBoolean := AOnlyIfUnused;
    frame.NoWait.AsBoolean := ANoWait;

    if ANoWait then
    begin
      Fcon.Send(frame);
      Exit;
    end;

    response := FCon.SendAndWaitReply(frame);
    if not (response is TAMQPExchangeDeleteOkFrame) then
      raise EAMQPExchange.Create('Error while deleting exchange');
  finally
    FreeAndNil(frame);
    FreeAndNil(response);
  end;
end;

procedure TAMQPExchanges.Unbind(const ASourceExchange, ATargetExchange, ARoutingKey: string);
var
  frame: TAMQPExchangeUnbindFrame;
  reply: TAMQPBasicFrame;
begin
  reply := nil;
  frame := TAMQPExchangeUnbindFrame.Create;
  try
    frame.Reserved1.AsWord := 0;
    frame.Destination.AsString := ATargetExchange;
    frame.Source.AsString := ASourceExchange;
    frame.RoutingKey.AsString := ARoutingKey;
    frame.NoWait.AsBoolean := False;

    reply := FCon.SendAndWaitReply(frame);
    if not (reply is TAMQPExchangeUnbindOkFrame) then
      raise EAMQPExchange.Create('Error while unbinding exchanges.');
  finally
    FreeAndNil(reply);
    FreeAndNil(frame);
  end;
end;

end.
