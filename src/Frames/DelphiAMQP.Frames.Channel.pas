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
    [AMQPParam(0, TAMQPValueType.ShortString)]
    property Reserved1: TAMQPValueType read FReserved1 write FReserved1;
  end;

  [AMQPFrame(TAMQPClasses.Channel, TAMQPChannelMethods.Flow)]
  TAMQPChannelFlowFrame = class(TAMQPBasicFrame)
  private
    FActive: TAMQPValueType;
  published
    [AMQPParam(0, TAMQPValueType.Bit)]
    property Active: TAMQPValueType read FActive write FActive;
  end;

  [AMQPFrame(TAMQPClasses.Channel, TAMQPChannelMethods.FlowOk)]
  TAMQPChannelFlowOkFrame = class(TAMQPBasicFrame)
  private
    FActive: TAMQPValueType;
  published
    [AMQPParam(0, TAMQPValueType.Bit)]
    property Active: TAMQPValueType read FActive write FActive;
  end;


implementation

initialization
  TAMQPFrameFactory.RegisterFrame(TAMQPChannelOpenFrame);
  TAMQPFrameFactory.RegisterFrame(TAMQPChannelOpenOkFrame);

end.
