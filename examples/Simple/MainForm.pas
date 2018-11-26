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
    btnDeclareExchange: TButton;
    btnDeleteExchange: TButton;
    procedure btnConnectClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnOpenChannelClick(Sender: TObject);
    procedure btnCloseChannelClick(Sender: TObject);
    procedure btnDeclareExchangeClick(Sender: TObject);
    procedure btnDeleteExchangeClick(Sender: TObject);
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

procedure TForm1.btnDeclareExchangeClick(Sender: TObject);
var
  values: array [0..1] of string;
begin
  values[0] := 'Test';
  values[1] := 'direct';
  if not InputQuery('Delphi AMQP', ['Exchange name:', 'Exchange type'], values) then
    Exit;

  FChannel.Exchanges.Declare(values[0], values[1]);
end;

procedure TForm1.btnDeleteExchangeClick(Sender: TObject);
var
  exchange: string;
begin
  if InputQuery('Delphi AMQP', 'Exchange name:', exchange) then
    FChannel.Exchanges.Delete(exchange);
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
