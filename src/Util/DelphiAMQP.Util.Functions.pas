unit DelphiAMQP.Util.Functions;

interface

uses
  DelphiAMQP.Constants;

  function getAMQPSecurityRespose(const ALoginType, AUser, APassword: string): string;

implementation

uses
  System.SysUtils;

function getAMQPSecurityRespose(const ALoginType, AUser, APassword: string): string;
begin
  if ALoginType = LOGIN_TYPE_AMQPLAIN then
    Result := Format('{ LOGIN: %s, PASSWORD: %s }', [AUser, APassword])
  else if ALoginType = LOGIN_TYPE_PLAIN then
    Result := #0 + AUser + #0 + APassword
  else
    Result := #0;
end;

end.
