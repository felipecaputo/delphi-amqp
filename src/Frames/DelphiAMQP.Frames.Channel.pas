unit DelphiAMQP.Frames.Channel;

interface

uses
  DelphiAMQP.Frames.BasicFrame, DelphiAMQP.Constants, DelphiAMQP.Frames.Factory,
  DelphiAMQP.AMQPValue, DelphiAMQP.Util.Attributes;

type
  [AMQPFrame(TAMQPClasses.Channel, TAMQPChannelMethods.Open)]
  TAMQPChannelOpenFrame = class(TAMQPBasicFrame)
  private
    FReserved1: TAMQPValueType;
  published
    [AMQPParam(0, TAMQPValueType.ShortString)]
    property Reserved1: TAMQPValueType read FReserved1 write FReserved1;
  end;

  [AMQPFrame(TAMQPClasses.Channel, TAMQPChannelMethods.OpenOk)]
  TAMQPChannelOpenOKFrame = class(TAMQPBasicFrame)
  private
    FReserved1: TAMQPValueType;
  published
    [AMQPParam(0, TAMQPValueType.LongString)]
    property Reserved1: TAMQPValueType read FReserved1 write FReserved1;
  end;

  [AMQPFrame(TAMQPClasses.Channel, TAMQPChannelMethods.Flow)]
  TAMQPChannelFlowFrame = class(TAMQPBasicFrame)
  private
    FActive: TAMQPValueType;
  published
    [AMQPParam(0, TAMQPValueType.Bit, 0)]
    property Active: TAMQPValueType read FActive write FActive;
  end;

  [AMQPFrame(TAMQPClasses.Channel, TAMQPChannelMethods.FlowOk)]
  TAMQPChannelFlowOkFrame = class(TAMQPBasicFrame)
  private
    FActive: TAMQPValueType;
  published
    [AMQPParam(0, TAMQPValueType.Bit, 0)]
    property Active: TAMQPValueType read FActive write FActive;
  end;

  [AMQPFrame(TAMQPClasses.Channel, TAMQPChannelMethods.Close)]
  TAMQPChannelCloseFrame = class(TAMQPBasicFrame)
  private
    FReplyCode: TAMQPValueType;
    FReplyText: TAMQPValueType;
    FClassId: TAMQPValueType;
    FMethodId: TAMQPValueType;
  published
    [AMQPParam(0, TAMQPValueType.ShortInt)]
    property ReplyCode: TAMQPValueType read FReplyCode write FReplyCode;
    [AMQPParam(1, TAMQPValueType.ShortString)]
    property ReplyText: TAMQPValueType read FReplyText write FReplyText;
    [AMQPParam(2, TAMQPValueType.ShortInt)]
    property ClassId: TAMQPValueType read FClassId write FClassId;
    [AMQPParam(3, TAMQPValueType.ShortInt)]
    property MethodId: TAMQPValueType read FMethodId write FMethodId;
  end;

  [AMQPFrame(TAMQPClasses.Channel, TAMQPChannelMethods.CloseOk)]
  TAMQPChannelCloseOkFrame = class(TAMQPBasicFrame)
  // No parameters
  end;


implementation

initialization
  TAMQPFrameFactory.RegisterFrames([
    TAMQPChannelOpenFrame,
    TAMQPChannelOpenOkFrame,
    TAMQPChannelCloseFrame,
    TAMQPChannelCloseOkFrame,
    TAMQPChannelFlowFrame,
    TAMQPChannelFlowOkFrame]);

end.
