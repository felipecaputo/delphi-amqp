unit DelphiAMQP.Frames.Queue;

interface

uses
  DelphiAMQP.Frames.BasicFrame, DelphiAMQP.Constants,
  DelphiAMQP.AMQPValue, DelphiAMQP.Util.Attributes;

type
  [AMQPFrame(TAMQPClasses.Queue, TAMQPQueueMethods.Declare)]
  TAMQPQueueDeclareFrame = class(TAMQPBasicFrame)
  private
    FReserved1: TAMQPValueType;
    FQueueName: TAMQPValueType;
    FPassive: TAMQPValueType;
    FDurable: TAMQPValueType;
    FExclusive: TAMQPValueType;
    FAutoDelete: TAMQPValueType;
    FNoWait: TAMQPValueType;
    FArguments: TAMQPValueType;
  published
    [AMQPParam(0, TAMQPValueType.ShortInt)]
    property Reserved1: TAMQPValueType read FReserved1 write FReserved1;
    [AMQPParam(1, TAMQPValueType.ShortString)]
    property QueueName: TAMQPValueType read FQueueName write FQueueName;
    [AMQPParam(2, TAMQPValueType.Bit, 0)]
    property Passive: TAMQPValueType read FPassive write FPassive;
    [AMQPParam(3, TAMQPValueType.Bit, 1)]
    property Durable: TAMQPValueType read FDurable write FDurable;
    [AMQPParam(4, TAMQPValueType.Bit, 2)]
    property Exclusive: TAMQPValueType read FExclusive write FExclusive;
    [AMQPParam(5, TAMQPValueType.Bit, 3)]
    property AutoDelete: TAMQPValueType read FAutoDelete write FAutoDelete;
    [AMQPParam(6, TAMQPValueType.Bit, 4)]
    property NoWait: TAMQPValueType read FNoWait write FNoWait;
    [AMQPParam(7, TAMQPValueType.FieldTable)]
    property Arguments: TAMQPValueType read FArguments write FArguments;
  end;

  [AMQPFrame(TAMQPClasses.Queue, TAMQPQueueMethods.DeclareOk)]
  TAMQPQueueDeclareOkFrame = class(TAMQPBasicFrame)
  private
    FQueueName: TAMQPValueType;
    FMessageCount: TAMQPValueType;
    FConsumerCount: TAMQPValueType;
  published
    [AMQPParam(0, TAMQPValueType.ShortString)]
    property QueueName: TAMQPValueType read FQueueName write FQueueName;
    [AMQPParam(1, TAMQPValueType.LongInt)]
    property MessageCount: TAMQPValueType read FMessageCount write FMessageCount;
    [AMQPParam(2, TAMQPValueType.LongInt)]
    property ConsumerCount: TAMQPValueType read FConsumerCount write FConsumerCount;
  end;

  [AMQPFrame(TAMQPClasses.Queue, TAMQPQueueMethods.Bind)]
  TAMQPQueueBindFrame = class(TAMQPBasicFrame)
  private
    FReserved1: TAMQPValueType;
    FQueueName: TAMQPValueType;
    FExchangeName: TAMQPValueType;
    FRoutingKey: TAMQPValueType;
    FNoWait: TAMQPValueType;
    FArguments: TAMQPValueType;
  published
    [AMQPParam(0, TAMQPValueType.ShortInt)]
    property Reserved1: TAMQPValueType read FReserved1 write FReserved1;
    [AMQPParam(1, TAMQPValueType.ShortString)]
    property QueueName: TAMQPValueType read FQueueName write FQueueName;
    [AMQPParam(2, TAMQPValueType.ShortString)]
    property ExchangeName: TAMQPValueType read FExchangeName write FExchangeName;
    [AMQPParam(3, TAMQPValueType.ShortString)]
    property RoutingKey: TAMQPValueType read FRoutingKey write FRoutingKey;
    [AMQPParam(4, TAMQPValueType.Bit, 0)]
    property NoWait: TAMQPValueType read FNoWait write FNoWait;
    [AMQPParam(5, TAMQPValueType.FieldTable)]
    property Arguments: TAMQPValueType read FArguments write FArguments;
  end;

  [AMQPFrame(TAMQPClasses.Queue, TAMQPQueueMethods.BindOk)]
  TAMQPQueueBindOkFrame = class(TAMQPBasicFrame)

  end;

  [AMQPFrame(TAMQPClasses.Queue, TAMQPQueueMethods.Unbind)]
  TAMQPQueueUnbindFrame = class(TAMQPBasicFrame)
  private
    FReserved1: TAMQPValueType;
    FQueueName: TAMQPValueType;
    FExchangeName: TAMQPValueType;
    FRoutingKey: TAMQPValueType;
    FArguments: TAMQPValueType;
  published
    [AMQPParam(0, TAMQPValueType.ShortInt)]
    property Reserved1: TAMQPValueType read FReserved1 write FReserved1;
    [AMQPParam(1, TAMQPValueType.ShortString)]
    property QueueName: TAMQPValueType read FQueueName write FQueueName;
    [AMQPParam(2, TAMQPValueType.ShortString)]
    property ExchangeName: TAMQPValueType read FExchangeName write FExchangeName;
    [AMQPParam(3, TAMQPValueType.ShortString)]
    property RoutingKey: TAMQPValueType read FRoutingKey write FRoutingKey;
    [AMQPParam(4, TAMQPValueType.FieldTable)]
    property Arguments: TAMQPValueType read FArguments write FArguments;
  end;

  [AMQPFrame(TAMQPClasses.Queue, TAMQPQueueMethods.UnbindOk)]
  TAMQPQueueUnbindOkFrame = class(TAMQPBasicFrame)

  end;

  [AMQPFrame(TAMQPClasses.Queue, TAMQPQueueMethods.Purge)]
  TAMQPQueuePurgeFrame = class(TAMQPBasicFrame)
  private
    FReserved1: TAMQPValueType;
    FQueueName: TAMQPValueType;
    FNoWait: TAMQPValueType;
  published
    [AMQPParam(0, TAMQPValueType.ShortInt)]
    property Reserved1: TAMQPValueType read FReserved1 write FReserved1;
    [AMQPParam(1, TAMQPValueType.ShortString)]
    property QueueName: TAMQPValueType read FQueueName write FQueueName;
    [AMQPParam(2, TAMQPValueType.Bit, 0)]
    property NoWait: TAMQPValueType read FNoWait write FNoWait;
  end;

  [AMQPFrame(TAMQPClasses.Queue, TAMQPQueueMethods.PurgeOk)]
  TAMQPQueuePurgeOkFrame = class(TAMQPBasicFrame)
  private
    FMessageCount: TAMQPValueType;
  published
    [AMQPParam(0, TAMQPValueType.LongInt)]
    property MessageCount: TAMQPValueType read FMessageCount write FMessageCount;
  end;

  [AMQPFrame(TAMQPClasses.Queue, TAMQPQueueMethods.Delete)]
  TAMQPQueueDeleteFrame = class(TAMQPBasicFrame)
  private
    FReserved1: TAMQPValueType;
    FQueueName: TAMQPValueType;
    FNoWait: TAMQPValueType;
    FIfEmpty: TAMQPValueType;
    FIfUnused: TAMQPValueType;
  published
    [AMQPParam(0, TAMQPValueType.ShortInt)]
    property Reserved1: TAMQPValueType read FReserved1 write FReserved1;
    [AMQPParam(1, TAMQPValueType.ShortString)]
    property QueueName: TAMQPValueType read FQueueName write FQueueName;
    [AMQPParam(2, TAMQPValueType.Bit, 0)]
    property IfUnused: TAMQPValueType read FIfUnused write FIfUnused;
    [AMQPParam(3, TAMQPValueType.Bit, 1)]
    property IfEmpty: TAMQPValueType read FIfEmpty write FIfEmpty;
    [AMQPParam(4, TAMQPValueType.Bit, 2)]
    property NoWait: TAMQPValueType read FNoWait write FNoWait;
  end;

  [AMQPFrame(TAMQPClasses.Queue, TAMQPQueueMethods.DeleteOk)]
  TAMQPQueueDeleteOkFrame = class(TAMQPBasicFrame)
  private
    FMessageCount: TAMQPValueType;
  published
    [AMQPParam(0, TAMQPValueType.LongInt)]
    property MessageCount: TAMQPValueType read FMessageCount write FMessageCount;
  end;

implementation

uses
  DelphiAMQP.Frames.Factory;

initialization
  TAMQPFrameFactory.RegisterFrames([
    TAMQPQueueDeclareFrame,
    TAMQPQueueDeclareOkFrame,
    TAMQPQueueBindFrame,
    TAMQPQueueBindOkFrame,
    TAMQPQueueUnbindFrame,
    TAMQPQueueUnbindOkFrame,
    TAMQPQueuePurgeFrame,
    TAMQPQueuePurgeOkFrame,
    TAMQPQueueDeleteFrame,
    TAMQPQueueDeleteOkFrame
  ]);

end.
