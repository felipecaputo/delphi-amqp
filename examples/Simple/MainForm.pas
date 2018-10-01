unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DelphiAMQP.ConnectionIntf, DelphiAMQP.Connections.Indy,
  Vcl.StdCtrls, DelphiAMQP.Connections.AMQPConnection, DelphiAMQP.Channel;

type
  TForm1 = class(TForm)
    btnConnect: TButton;
    btnClose: TButton;
    btnOpenChannel: TButton;
    btnCloseChannel: TButton;
    procedure btnConnectClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnOpenChannelClick(Sender: TObject);
    procedure btnCloseChannelClick(Sender: TObject);
  private
    FAmqpConnection: TAMQPConnection;
    FChannel: TAMQPChannel;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btnCloseChannelClick(Sender: TObject);
begin
  if not Assigned(FChannel) then
    Exit;

  FChannel.Close();
end;

procedure TForm1.btnCloseClick(Sender: TObject);
begin
  FAmqpConnection.Close();
end;

procedure TForm1.btnConnectClick(Sender: TObject);
begin
  FAmqpConnection
    .SetHost('127.0.0.1')
    .SetPort(5672)
    .SetUser('guest')
    .SetPassword('guest')
    .Open();
end;

procedure TForm1.btnOpenChannelClick(Sender: TObject);
begin
  FChannel := FAmqpConnection.OpenChannel()
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FAmqpConnection := TAMQPConnection.Create(TAMQPIndyConnection.Create());
end;

end.
