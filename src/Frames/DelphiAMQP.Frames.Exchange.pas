unit DelphiAMQP.Frames.Exchange;

interface

uses
  DelphiAMQP.Frames.BasicFrame, DelphiAMQP.Constants, DelphiAMQP.Frames.Factory,
  DelphiAMQP.AMQPValue, DelphiAMQP.Util.Attributes;

type
  [AMQPFrame(TAMQPClasses.Exchange, TAMQPExchangeMethods.Declare)]
  TAMQPExchangeDeclareFrame = class(TAMQPBasicFrame)
  private
    FReserverd1: TAMQPValueType;
    FExchangeName: TAMQPValueType;
    FExchangeType: TAMQPValueType;
    FPassive: TAMQPValueType;
    FDurable: TAMQPValueType;
    FInternal: TAMQPValueType;
    FNoWait: TAMQPValueType;
    FArguments: TAMQPValueType;
    FAutoDelete: TAMQPValueType;
  published
    [AMQPParam(0, TAMQPValueType.ShortInt)]
    property Reserverd1: TAMQPValueType read FReserverd1 write FReserverd1;
    [AMQPParam(1, TAMQPValueType.ShortString)]
    property ExchangeName: TAMQPValueType read FExchangeName write FExchangeName;
    [AMQPParam(2, TAMQPValueType.ShortString)]
    property ExchangeType: TAMQPValueType read FExchangeType write FExchangeType;
    [AMQPParam(3, TAMQPValueType.Bit, 0)]
    property Passive: TAMQPValueType read FPassive write FPassive;
    [AMQPParam(4, TAMQPValueType.Bit, 1)]
    property Durable: TAMQPValueType read FDurable write FDurable;
    [AMQPParam(5, TAMQPValueType.Bit, 2)]
    property AutoDelete: TAMQPValueType read FAutoDelete write FAutoDelete;
    [AMQPParam(6, TAMQPValueType.Bit, 3)]
    property Internal: TAMQPValueType read FInternal write FInternal;
    [AMQPParam(7, TAMQPValueType.Bit, 4)]
    property NoWait: TAMQPValueType read FNoWait write FNoWait;
    [AMQPParam(8, TAMQPValueType.FieldTable)]
    property Arguments: TAMQPValueType read FArguments write FArguments;
  end;

  [AMQPFrame(TAMQPClasses.Exchange, TAMQPExchangeMethods.DeclareOK)]
  TAMQPExchangeDeclareOkFrame = class(TAMQPBasicFrame)
  end;

  [AMQPFrame(TAMQPClasses.Exchange, TAMQPExchangeMethods.Delete)]
  TAMQPExchangeDeleteFrame = class(TAMQPBasicFrame)
  private
    FReserved1: TAMQPValueType;
    FExchangeName: TAMQPValueType;
    FIfUnused: TAMQPValueType;
    FNoWait: TAMQPValueType;
  published
    [AMQPParam(0, TAMQPValueType.ShortInt)]
    property Reserved1: TAMQPValueType read FReserved1 write FReserved1;
    [AMQPParam(1, TAMQPValueType.ShortString)]
    property ExchangeName: TAMQPValueType read FExchangeName write FExchangeName;
    [AMQPParam(2, TAMQPValueType.Bit, 0)]
    property IfUnused: TAMQPValueType read FIfUnused write FIfUnused;
    [AMQPParam(3, TAMQPValueType.Bit, 1)]
    property NoWait: TAMQPValueType read FNoWait write FNoWait;
  end;

  [AMQPFrame(TAMQPClasses.Exchange, TAMQPExchangeMethods.DeleteOK)]
  TAMQPExchangeDeleteOkFrame = class(TAMQPBasicFrame)
  end;

  [AMQPFrame(TAMQPClasses.Exchange, TAMQPExchangeMethods.Bind)]
  TAMQPExchangeBindFrame = class(TAMQPBasicFrame)
  private
    FReserved1: TAMQPValueType;
    FDestination: TAMQPValueType;
    FSource: TAMQPValueType;
    FRoutingKey: TAMQPValueType;
    FNoWait: TAMQPValueType;
    FArguments: TAMQPValueType;
  published
    [AMQPParam(0, TAMQPValueType.ShortInt)]
    property Reserved1: TAMQPValueType read FReserved1 write FReserved1;
    [AMQPParam(1, TAMQPValueType.ShortString)]
    property Destination: TAMQPValueType read FDestination write FDestination;
    [AMQPParam(2, TAMQPValueType.ShortString)]
    property Source: TAMQPValueType read FSource write FSource;
    [AMQPParam(3, TAMQPValueType.ShortString)]
    property RoutingKey: TAMQPValueType read FRoutingKey write FRoutingKey;
    [AMQPParam(4, TAMQPValueType.Bit, 1)]
    property NoWait: TAMQPValueType read FNoWait write FNoWait;
    [AMQPParam(5, TAMQPValueType.FieldTable)]
    property Arguments: TAMQPValueType read FArguments write FArguments;
  end;

  [AMQPFrame(TAMQPClasses.Exchange, TAMQPExchangeMethods.BindOK)]
  TAMQPExchangeBindOkFrame = class(TAMQPBasicFrame)
  end;

  [AMQPFrame(TAMQPClasses.Exchange, TAMQPExchangeMethods.Unbind)]
  TAMQPExchangeUnbindFrame = class(TAMQPBasicFrame)
  private
    FReserved1: TAMQPValueType;
    FDestination: TAMQPValueType;
    FSource: TAMQPValueType;
    FRoutingKey: TAMQPValueType;
    FNoWait: TAMQPValueType;
    FArguments: TAMQPValueType;
  published
    [AMQPParam(0, TAMQPValueType.ShortInt)]
    property Reserved1: TAMQPValueType read FReserved1 write FReserved1;
    [AMQPParam(1, TAMQPValueType.ShortString)]
    property Destination: TAMQPValueType read FDestination write FDestination;
    [AMQPParam(2, TAMQPValueType.ShortString)]
    property Source: TAMQPValueType read FSource write FSource;
    [AMQPParam(3, TAMQPValueType.ShortString)]
    property RoutingKey: TAMQPValueType read FRoutingKey write FRoutingKey;
    [AMQPParam(4, TAMQPValueType.Bit, 1)]
    property NoWait: TAMQPValueType read FNoWait write FNoWait;
    [AMQPParam(5, TAMQPValueType.FieldTable)]
    property Arguments: TAMQPValueType read FArguments write FArguments;
  end;

  [AMQPFrame(TAMQPClasses.Exchange, TAMQPExchangeMethods.UnbindOK)]
  TAMQPExchangeUnbindOkFrame = class(TAMQPBasicFrame)
  end;

implementation

initialization
  TAMQPFrameFactory.RegisterFrames([
    TAMQPExchangeDeclareFrame,
    TAMQPExchangeDeclareOkFrame,
    TAMQPExchangeDeleteFrame,
    TAMQPExchangeDeleteOkFrame,
    TAMQPExchangeBindFrame,
    TAMQPExchangeBindOkFrame,
    TAMQPExchangeUnbindFrame,
    TAMQPExchangeUnbindOkFrame
  ])

end.
