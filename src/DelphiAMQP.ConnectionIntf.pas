unit DelphiAMQP.ConnectionIntf;

interface

uses
  DelphiAMQP.Frames.BasicFrame, System.SysUtils;

type
  IAMQPTCPConnection = interface
    ['{DEFA8FE5-5081-474F-82F8-E3E3B4BF4DF8}']

    procedure Open;
    Procedure Close;

    procedure Send(const AFrame: TAMQPBasicFrame);
    function SendAndWaitReply(const AFrame: TAMQPBasicFrame; const ATimeOut: Cardinal = 0): TAMQPBasicFrame;
    function Receive(const ATimeOut: Cardinal = 0): TAMQPBasicFrame;

    function SetHost(const AHost: string): IAMQPTCPConnection;
    function SetPort(const APort: Integer): IAMQPTCPConnection;
    function SetConnectionString(const AConnectionString: string): IAMQPTCPConnection;
    function SetUser(const AUser: string): IAMQPTCPConnection;
    function SetPassword(const APassword: string): IAMQPTCPConnection;
    function SetReadTimeOut(const ATimeOut: Cardinal): IAMQPTCPConnection;

    function GetReadTimeOut: Cardinal;
  end;

implementation


end.
