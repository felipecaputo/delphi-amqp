unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DelphiAMQP.ConnectionIntf, DelphiAMQP.Connections.Indy,
  Vcl.StdCtrls, DelphiAMQP.Connections.AMQPConnection;

type
  TForm1 = class(TForm)
    btnConnect: TButton;
    procedure btnConnectClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FAmqpConnection: TAMQPConnection;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btnConnectClick(Sender: TObject);
begin
  FAmqpConnection
    .SetHost('127.0.0.1')
    .SetPort(5672)
    .SetUser('guest')
    .SetPassword('guest')
    .Open();
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FAmqpConnection := TAMQPConnection.Create(TAMQPIndyConnection.Create(nil));
end;

end.
