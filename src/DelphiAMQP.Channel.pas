unit DelphiAMQP.Channel;

interface

uses
  DelphiAMQP.ConnectionIntf, DelphiAMQP.Frames.Channel, DelphiAMQP.Frames.BasicFrame,
  System.SysUtils;

type
  EAMQPChannel = class(Exception);

  TAMQPChannel = class
  private
    FChannelId: UInt16;
    FCon: IAMQPTCPConnection;
    FActive: Boolean;
    procedure SetActive(const Value: Boolean);
  public
    constructor Create(const ACon: IAMQPTCPConnection; const AChannelId: Integer);

    procedure Open;
    procedure Close(const ACode: UInt8 = 200; const AReason: string = 'Channel close');

    property ChannelId: UInt16 read FChannelId;
    property Active: Boolean read FActive write SetActive;
  end;

implementation

{ TAMQPChannel }

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

procedure TAMQPChannel.SetActive(const Value: Boolean);
begin
  if FActive = Value then
    Exit;

  if Value then
    Open()
  else
    Close();
end;

end.
