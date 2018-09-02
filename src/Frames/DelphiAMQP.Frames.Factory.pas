unit DelphiAMQP.Frames.Factory;

interface

uses
  System.Classes,
  System.Generics.Collections,
  System.Rtti,
  System.SysUtils,
  DelphiAMQP.Constants,
  DelphiAMQP.Frames.BasicFrame, DelphiAMQP.Frames.Connection;

type
  EAMQPFrameFactory = class(Exception);


  TAMQPFrameFactory = class
  private
    class var FContext: TRttiContext;

    class function GetFrameId(const AFrameClass: TAMQPFrameClass): Integer; overload;
    class function GetFrameId(const AClass, AMethod: Integer): Integer; overload;
    class var FSupportedFrames: TDictionary<Integer, TAMQPFrameClass>;
  public
    class procedure RegisterFrame(const AFrameClass: TAMQPFrameClass);

    class function BuildFrame(const AClass, AMethod: Integer): TAMQPBasicFrame; overload;
    class function BuildFrame(const APayload: TBytesStream): TAMQPBasicFrame; overload;
  end;

implementation

uses
  DelphiAMQP.Util.Helpers, DelphiAMQP.Util.Attributes;

{ TAMQPFrameFactory }

class function TAMQPFrameFactory.BuildFrame(const AClass, AMethod: Integer): TAMQPBasicFrame;
var
  frameClass: TAMQPFrameClass;
  classMethodId: Integer;
begin
  classMethodId := TAMQPFrameFactory.GetFrameId(AClass, AMethod);
  if not TAMQPFrameFactory.FSupportedFrames.TryGetValue(classMethodId, frameClass) then
    raise EAMQPFrameFactory.CreateFmt('Usuported frame for class %d / method %d', [AClass, AMethod]);

  Result := frameClass.Create();
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

class function TAMQPFrameFactory.GetFrameId(const AFrameClass: TAMQPFrameClass): Integer;
var
  attr: TCustomAttribute;
begin
  for attr in FContext.GetType(AFrameClass).GetAttributes do
  begin
    if not (attr is AMQPFrameAttribute) then
      Continue;

    Exit(GetFrameId((attr as AMQPFrameAttribute).ClassId, (attr as AMQPFrameAttribute).MethodId));
  end;

  raise EAMQPFrameFactory.CreateFmt('Class %s doesn''t have Frame info.', [AFrameClass.ClassName]);
end;

class function TAMQPFrameFactory.GetFrameId(const AClass, AMethod: Integer): Integer;
const
  sCLASS_MULTIPLIER = 100000;
begin
  Result := (AClass * sCLASS_MULTIPLIER) + AMethod;
end;

class procedure TAMQPFrameFactory.RegisterFrame(const AFrameClass: TAMQPFrameClass);
begin
  if not Assigned(TAMQPFrameFactory.FSupportedFrames) then
    TAMQPFrameFactory.FSupportedFrames := TDictionary<Integer,TAMQPFrameClass>.Create();

  TAMQPFrameFactory.FSupportedFrames.AddOrSetValue(GetFrameId(AFrameClass), AFrameClass);
end;

initialization
  TAMQPFrameFactory.FSupportedFrames := nil;
  TAMQPFrameFactory.FContext := TRttiContext.Create();

finalization
  FreeAndNil(TAMQPFrameFactory.FSupportedFrames);
  TAMQPFrameFactory.FContext.Free();

end.
