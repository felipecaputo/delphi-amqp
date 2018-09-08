unit DelphiAMQP.Frames.Connection;

interface

uses
  DelphiAMQP.Frames.BasicFrame, DelphiAMQP.Util.Attributes,
  DelphiAMQP.Constants, DelphiAMQP.AMQPValue, DelphiAMQP.Frames.Factory;

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

  [AMQPFrame(TAMQPClasses.Connection, TAMQPConnectionMethods.Secure)]
  TAMQPConnectionSecureFrame = class(TAMQPBasicFrame)
  private
    FChallenge: TAMQPValueType;
  published
    [AMQPParam(0, TAMQPValueType.LongString)]
    property Challenge: TAMQPValueType read FChallenge write FChallenge;
  end;

  [AMQPFrame(TAMQPClasses.Connection, TAMQPConnectionMethods.SecureOk)]
  TAMQPConnectionSecureOkFrame = class(TAMQPBasicFrame)
  private
    FResponse: TAMQPValueType;
  published
    property Response: TAMQPValueType read FResponse write FResponse;
  end;

  [AMQPFrame(TAMQPClasses.Connection, TAMQPConnectionMethods.Tune)]
  TAMQPConnectionTuneFrame = class(TAMQPBasicFrame)
  private
    FFrameMax: TAMQPValueType;
    FHeartBeat: TAMQPValueType;
    FChannelMax: TAMQPValueType;
  published
    [AMQPParam(0, TAMQPValueType.ShortInt)]
    property ChannelMax: TAMQPValueType read FChannelMax write FChannelMax;
    [AMQPParam(1, TAMQPValueType.LongInt)]
    property FrameMax: TAMQPValueType read FFrameMax write FFrameMax;
    [AMQPParam(2, TAMQPValueType.ShortInt)]
    property HeartBeat: TAMQPValueType read FHeartBeat write FHeartBeat;
  end;

  [AMQPFrame(TAMQPClasses.Connection, TAMQPConnectionMethods.TuneOk)]
  TAMQPConnectionTuneOkFrame = class(TAMQPBasicFrame)
  private
    FFrameMax: TAMQPValueType;
    FHeartBeat: TAMQPValueType;
    FChannelMax: TAMQPValueType;
  published
    [AMQPParam(0, TAMQPValueType.ShortInt)]
    property ChannelMax: TAMQPValueType read FChannelMax write FChannelMax;
    [AMQPParam(1, TAMQPValueType.LongInt)]
    property FrameMax: TAMQPValueType read FFrameMax write FFrameMax;
    [AMQPParam(2, TAMQPValueType.ShortInt)]
    property HeartBeat: TAMQPValueType read FHeartBeat write FHeartBeat;
  end;


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

  [AMQPFrame(TAMQPClasses.Connection, TAMQPConnectionMethods.Close)]
  TAMQPConnectionCloseFrame = class(TAMQPBasicFrame)
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

  [AMQPFrame(TAMQPClasses.Connection, TAMQPConnectionMethods.CloseOk)]
  TAMQPConnectionCloseOkFrame = class(TAMQPBasicFrame)

  end;



implementation

initialization
  TAMQPFrameFactory.RegisterFrame(TAMQPConnectionStartFrame);
  TAMQPFrameFactory.RegisterFrame(TAMQPConnectionStartOkFrame);
  TAMQPFrameFactory.RegisterFrame(TAMQPConnectionSecureFrame);
  TAMQPFrameFactory.RegisterFrame(TAMQPConnectionSecureOkFrame);
  TAMQPFrameFactory.RegisterFrame(TAMQPConnectionTuneFrame);
  TAMQPFrameFactory.RegisterFrame(TAMQPConnectionTuneOKFrame);
  TAMQPFrameFactory.RegisterFrame(TAMQPConnectionOpenFrame);
  TAMQPFrameFactory.RegisterFrame(TAMQPConnectionOpenOkFrame);
  TAMQPFrameFactory.RegisterFrame(TAMQPConnectionCloseFrame);
  TAMQPFrameFactory.RegisterFrame(TAMQPConnectionCloseOkFrame);

end.
