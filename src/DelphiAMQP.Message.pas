unit DelphiAMQP.Message;

interface

uses
  System.Classes, System.JSON, DelphiAMQP.BasicProperties;

type
  TAMQPMessage = class
  private
    FBody: TStringStream;
    FProperties: TAMQPBasicProperties;
    function GetProperties: TAMQPBasicProperties;
    function GetBody: TStringStream;
  public
    property Properties: TAMQPBasicProperties read GetProperties;
    property Body: TStringStream read GetBody;
  end;

implementation

{ TAMQPMessage }

function TAMQPMessage.GetBody: TStringStream;
begin
  Result := FBody
end;

function TAMQPMessage.GetProperties: TAMQPBasicProperties;
begin
  Result := FProperties;
end;

end.
