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

  TAMQPChannelMethods = class
    public
      const
        Open = 10;
        OpenOk = 11;
        Flow = 20;
        FlowOk = 21;
        Close = 40;
        CloseOk = 41;
  end;

  TAMQPExchangeMethods = class
  public
    const
      Declare = 10;
      DeclareOK = 11;
      Delete = 20;
      DeleteOK = 21;
      //RabbitMQ specific methods
      Bind = 30;
      BindOk = 31;
      Unbind = 40;
      UnbindOk = 41;
  end;

  TAMQPQueueMethods = class
  public
    const
      Declare = 10;
      DeclareOk = 11;
      Bind = 20;
      BindOk = 21;
      Unbind = 50;
      UnbindOk = 51;
      Purge = 30;
      PurgeOk = 31;
      Delete = 40;
      DeleteOk = 41;
  end;

  TAMQPBasicMethods = class
  public
    const
      qos = 10;
      qosOk = 11;
      consume = 20;
      consumeOk = 21;
      cancel = 30;
      cancelOk = 31;
      publish = 40;
      publishOk = 41;
      return = 50;
      deliver = 60;
      get = 70;
      getOk = 71;
      getEmpty = 72;
      ack = 80;
      reject = 90;
      recoverAsync = 100;
      recover = 110;
      recoverOk = 111;
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
