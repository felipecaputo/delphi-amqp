unit DelphiAMQP.Frames.ConnectionStart;

interface

uses
  DelphiAMQP.Frames.Header, System.Generics.Collections, System.Classes, DelphiAMQP.AMQPValue,
  DelphiAMQP.Frames.BasicFrame, DelphiAMQP.Util.Attributes, DelphiAMQP.Constants;

type
  [AMQPFrame(TAMQPClasses.Connection, TAMQPConnectionMethods.Start)]
  TAMQPConnectionStartFrame = class(TAMQPBasicFrame)
  private
    FVersionMajor: TAMQPValueType;
    FVersionMinor: TAMQPValueType;
    FServerProperties: TAMQPValueType;
    FMecanisms: TAMQPValueType;
    FLocales: TAMQPValueType;
  published
    [AMQPParamAttribute(0, TAMQPValueType.ShortShortUInt)]
    property VersionMajor: TAMQPValueType read FVersionMajor write FVersionMajor;
    [AMQPParamAttribute(1, TAMQPValueType.ShortShortUInt)]
    property VersionMinor: TAMQPValueType read FVersionMinor write FVersionMinor;
    [AMQPParamAttribute(2, TAMQPValueType.FieldTable)]
    property ServerProperties: TAMQPValueType read FServerProperties write FServerProperties;
    [AMQPParamAttribute(3, TAMQPValueType.LongString)]
    property Mecanisms: TAMQPValueType read FMecanisms write FMecanisms;
    [AMQPParamAttribute(4, TAMQPValueType.LongString)]
    property Locales: TAMQPValueType read FLocales write FLocales;

  end;

implementation

end.
