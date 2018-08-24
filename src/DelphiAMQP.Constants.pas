unit DelphiAMQP.Constants;

interface

type
  TAMQPClasses = class
  public
    const
      Connection = 10;
      Channel = 20;
      Exchange = 40;
      Queue = 50;
      Basic = 60;
      Transaction = 90;
  end;

  TAMQPConnectionMethods = class
  public
    const
      Start = 10;
      StartOk = 11;
      Secure = 20;
      SecureOk = 21;
      Tune = 30;
      TuneOk = 31;
      Open = 40;
      OpenOk = 41;
      Close = 50;
      CloseOk = 51;
  end;


const
  DELPHI_AMQP_VERSION = '1.0.0';

  FRAME_END = 206;


  LOGIN_TYPE_PLAIN = 'PLAIN';
  LOGIN_TYPE_AMQPLAIN = 'AMQPLAIN';
  LOGIN_TYPE_EXTERNAL = 'EXTERNAL';
  LOGIN_TYPE_ANNONYMOUS = 'ANNONYMOUS';
  LOGIN_TYPES: array[0..3] of string = (LOGIN_TYPE_AMQPLAIN, LOGIN_TYPE_PLAIN,
    LOGIN_TYPE_EXTERNAL, LOGIN_TYPE_ANNONYMOUS);

implementation

end.
