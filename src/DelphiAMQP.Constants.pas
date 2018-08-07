unit DelphiAMQP.Constants;

interface

type
  TAMQPClasses = (Connection = 10, Channel = 20, Exchange = 40, Queue = 50, Basic = 60,
    Transaction = 90);
  TAMQPConnectionMethods = (Start = 10, StartOk = 11, Secure = 20, SecureOk = 21, Tune = 30,
    TuneOk = 31, Open = 40, OpenOk = 41, Close = 50, CloseOk = 51);

const
  FRAME_END = 206;

implementation

end.
