unit DelphiAMQP.Frames.ConnectionTune;

interface

uses
  DelphiAMQP.Frames.BasicFrame, DelphiAMQP.Util.Attributes,
  DelphiAMQP.Constants, DelphiAMQP.AMQPValue;

type
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

implementation

end.
