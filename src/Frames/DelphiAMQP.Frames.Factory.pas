unit DelphiAMQP.Frames.Factory;

interface

uses
  DelphiAMQP.Frames.BasicFrame, DelphiAMQP.Constants, System.SysUtils,
  System.Rtti;

type
  EAMQPFrameFactory = class(Exception);


  TAMQPFrameFactory = class
  private
    class function BuildConnectionFrame(const AMethod: Integer): TAMQPBasicFrame;
  public
    class function BuildFrame(const AClass, AMethod: Integer): TAMQPBasicFrame;
  end;

implementation

{ TAMQPFrameFactory }

class function TAMQPFrameFactory.BuildConnectionFrame(const AMethod: Integer):
    TAMQPBasicFrame;
var
  Method: TAMQPConnectionMethods;
begin
  Method := TAMQPConnectionMethods(AMethod);

  case Method of
    TAMQPConnectionMethods.Start: Result := nil;
    TAMQPConnectionMethods.StartOk: Result := nil;
    TAMQPConnectionMethods.Secure: Result := nil;
    TAMQPConnectionMethods.SecureOk: Result := nil;
    TAMQPConnectionMethods.Tune: Result := nil;
    TAMQPConnectionMethods.TuneOk: Result := nil;
    TAMQPConnectionMethods.Open: Result := nil;
    TAMQPConnectionMethods.OpenOk: Result := nil;
    TAMQPConnectionMethods.Close: Result := nil;
    TAMQPConnectionMethods.CloseOk: Result := nil;
    else
      raise EAMQPFrameFactory.CreateFmt('Unsupported method [%d] for Connection class', [AMethod]);
  end;
end;

class function TAMQPFrameFactory.BuildFrame(const AClass, AMethod: Integer): TAMQPBasicFrame;
var
  AMQPClass: TAMQPClasses;
begin
  AMQPClass := TAMQPClasses(AClass);

  case AMQPClass of
    Connection: Result := BuildConnectionFrame(AMethod);
    Channel: Result := nil;
    Exchange: Result := nil;
    Queue: Result := nil;
    Basic: Result := nil;
    Transaction: Result := nil;
    else
      raise EAMQPFrameFactory.CreateFmt('Unsupported class [%d]', [AClass]);
  end;

end;

end.
