unit DelphiAMQP.Frames.Factory;

interface

uses
  System.Classes,
  System.Rtti,
  System.SysUtils,
  DelphiAMQP.Constants,
  DelphiAMQP.Frames.BasicFrame;

type
  EAMQPFrameFactory = class(Exception);


  TAMQPFrameFactory = class
  private
    class function BuildConnectionFrame(const AMethod: Integer): TAMQPBasicFrame;
  public
    class function BuildFrame(const AClass, AMethod: Integer): TAMQPBasicFrame; overload;
    class function BuildFrame(const APayload: TBytesStream): TAMQPBasicFrame; overload;
  end;

implementation

uses
  DelphiAMQP.Frames.ConnectionStart,
  DelphiAMQP.Util.Helpers;

{ TAMQPFrameFactory }

class function TAMQPFrameFactory.BuildConnectionFrame(const AMethod: Integer): TAMQPBasicFrame;
begin

  case AMethod of
    TAMQPConnectionMethods.Start: Result := TAMQPConnectionStartFrame.Create();
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
begin
  case AClass of
    TAMQPClasses.Connection: Result := BuildConnectionFrame(AMethod);
    TAMQPClasses.Channel: Result := nil;
    TAMQPClasses.Exchange: Result := nil;
    TAMQPClasses.Queue: Result := nil;
    TAMQPClasses.Basic: Result := nil;
    TAMQPClasses.Transaction: Result := nil;
  else
    raise EAMQPFrameFactory.CreateFmt('Unsupported class [%d]', [AClass]);
  end;

end;

class function TAMQPFrameFactory.BuildFrame(const APayload: TBytesStream): TAMQPBasicFrame;
var
  ClassId, MethodId: Word;
begin
  APayload.Position := 0;
  ClassId := APayload.AMQPReadShortUInt;
  MethodId := APayload.AMQPReadShortUInt;
  Result := TAMQPFrameFactory.BuildFrame(ClassId, MethodId);
end;

end.
