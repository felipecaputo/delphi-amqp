unit DelphiAMQP.Frames.ConnectionOpen;

interface

uses
  DelphiAMQP.Frames.BasicFrame, DelphiAMQP.Util.Attributes,
  DelphiAMQP.Constants, DelphiAMQP.AMQPValue;

type
  [AMQPFrame(TAMQPClasses.Connection, TAMQPConnectionMethods.Open)]
  TAMQPConnectionOpenFrame = class(TAMQPBasicFrame)
  private
    FvHost: TAMQPValueType;
    FReserved2: TAMQPValueType;
    FReserved1: TAMQPValueType;
  published
    [AMQPParam(0, TAMQPValueType.ShortString)]
    property VHost: TAMQPValueType read FvHost write FvHost;
    [AMQPParam(1, TAMQPValueType.ShortString)]
    property Reserved1: TAMQPValueType read FReserved1 write FReserved1;
    [AMQPParam(2, TAMQPValueType.Bool)]
    property Reserved2: TAMQPValueType read FReserved2 write FReserved2;
  end;


  [AMQPFrame(TAMQPClasses.Connection, TAMQPConnectionMethods.OpenOk)]
  TAMQPConnectionOpenOkFrame = class(TAMQPBasicFrame)
  private
    FReserved1: TAMQPValueType;
  published
    [AMQPParam(0, TAMQPValueType.ShortString)]
    property Reserved1: TAMQPValueType read FReserved1 write FReserved1;
  end;

implementation

end.
