unit DelphiAMQP.Frames.ConnectionStartOk;

interface

uses
  DelphiAMQP.Frames.BasicFrame, DelphiAMQP.AMQPValue, System.Generics.Collections,
  DelphiAMQP.Constants, DelphiAMQP.Util.Attributes;

type
  [AMQPFrame(TAMQPClasses.Connection, TAMQPConnectionMethods.StartOk)]
  TAMQPConnectionStartOkFrame = class(TAMQPBasicFrame)
  private
    FClientProperties: TAMQPValueType;
    FMechanism: TAMQPValueType;
    FResponse: TAMQPValueType;
    FLocale: TAMQPValueType;
  published
    [AMQPParamAttribute(0, TAMQPValueType.FieldTable)]
    property ClientProperties: TAMQPValueType read FClientProperties write FClientProperties;
    [AMQPParamAttribute(1, TAMQPValueType.ShortString)]
    property Mechanism: TAMQPValueType read FMechanism write FMechanism;
    [AMQPParamAttribute(2, TAMQPValueType.LongString)]
    property Response: TAMQPValueType read FResponse write FResponse;
    [AMQPParamAttribute(3, TAMQPValueType.ShortString)]
    property Locale: TAMQPValueType read FLocale write FLocale;
  end;

implementation

end.
