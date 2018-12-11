unit DelphiAMQP.Frames.Basic;

interface

uses
  DelphiAMQP.Frames.BasicFrame, DelphiAMQP.Constants, DelphiAMQP.Frames.Factory,
  DelphiAMQP.AMQPValue, DelphiAMQP.Util.Attributes;

type
  [AMQPFrame(TAMQPClasses.Basic, TAMQPBasicMethods.qos)]
  TAMQPBasicQosFrame = class(TAMQPBasicFrame)
  private
    FPrefetchSize: TAMQPValueType;
    FPrefetchCount: TAMQPValueType;
    FGlobal: TAMQPValueType;
  published
    [AMQPParam(0, TAMQPValueType.LongInt)]
    property PrefetchSize: TAMQPValueType read FPrefetchSize write FPrefetchSize;
    [AMQPParam(1, TAMQPValueType.ShortInt)]
    property PrefetchCount: TAMQPValueType read FPrefetchCount write FPrefetchCount;
    [AMQPParam(2, TAMQPValueType.Bit, 0)]
    property Global: TAMQPValueType read FGlobal write FGlobal;
  end;

  [AMQPFrame(TAMQPClasses.Basic, TAMQPBasicMethods.qosOk)]
  TAMQPBasicQosOkFrame = class(TAMQPBasicFrame)

  end;

  [AMQPFrame(TAMQPClasses.Basic, TAMQPBasicMethods.consume)]
  TAMQPBasicConsumeFrame = class(TAMQPBasicFrame)
  private
    FReserved1: TAMQPValueType;
    FQueueName: TAMQPValueType;
    FConsumerTag: TAMQPValueType;
    FNoLocal: TAMQPValueType;
    FNoAck: TAMQPValueType;
    FExclusive: TAMQPValueType;
    FNoWait: TAMQPValueType;
    FArguments: TAMQPValueType;
  published
    [AMQPParam(0, TAMQPValueType.ShortInt)]
    property Reserved1: TAMQPValueType read FReserved1 write FReserved1;
    [AMQPParam(1, TAMQPValueType.ShortString)]
    property QueueName: TAMQPValueType read FQueueName write FQueueName;
    [AMQPParam(2, TAMQPValueType.ShortString)]
    property ConsumerTag: TAMQPValueType read FConsumerTag write FConsumerTag;
    [AMQPParam(3, TAMQPValueType.Bit, 0)]
    property NoLocal: TAMQPValueType read FNoLocal write FNoLocal;
    [AMQPParam(4, TAMQPValueType.Bit, 1)]
    property NoAck: TAMQPValueType read FNoAck write FNoAck;
    [AMQPParam(5, TAMQPValueType.Bit, 2)]
    property Exclusive: TAMQPValueType read FExclusive write FExclusive;
    [AMQPParam(6, TAMQPValueType.Bit, 3)]
    property NoWait: TAMQPValueType read FNoWait write FNoWait;
    [AMQPParam(7, TAMQPValueType.FieldTable)]
    property Arguments: TAMQPValueType read FArguments write FArguments;
  end;

  [AMQPFrame(TAMQPClasses.Basic, TAMQPBasicMethods.consumeOk)]
  TAMQPBasicConsumeOkFrame = class(TAMQPBasicFrame)
  private
    FConsumerTag: TAMQPValueType;
  published
    [AMQPParam(0, TAMQPValueType.ShortString)]
    property ConsumerTag: TAMQPValueType read FConsumerTag write FConsumerTag;
  end;

  [AMQPFrame(TAMQPClasses.Basic, TAMQPBasicMethods.cancel)]
  TAMQPBasicCancelFrame = class(TAMQPBasicFrame)
  private
    FConsumerTag: TAMQPValueType;
    FNoWait: TAMQPValueType;
  published
    [AMQPParam(0, TAMQPValueType.ShortString)]
    property ConsumerTag: TAMQPValueType read FConsumerTag write FConsumerTag;
    [AMQPParam(1, TAMQPValueType.Bit, 0)]
    property NoWait: TAMQPValueType read FNoWait write FNoWait;
  end;

  [AMQPFrame(TAMQPClasses.Basic, TAMQPBasicMethods.cancelOk)]
  TAMQPBasicCancelOkFrame = class(TAMQPBasicFrame)
  private
    FConsumerTag: TAMQPValueType;
  published
    [AMQPParam(0, TAMQPValueType.ShortString)]
    property ConsumerTag: TAMQPValueType read FConsumerTag write FConsumerTag;
  end;

implementation

initialization
  TAMQPFrameFactory.RegisterFrames([
    TAMQPBasicQosFrame,
    TAMQPBasicQosOkFrame,
    TAMQPBasicConsumeFrame,
    TAMQPBasicConsumeOkFrame,
    TAMQPBasicCancelFrame,
    TAMQPBasicCancelOkFrame
  ]);

end.
