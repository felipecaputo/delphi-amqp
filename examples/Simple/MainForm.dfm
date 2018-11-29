object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 299
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object btnConnect: TButton
    Left = 496
    Top = 8
    Width = 119
    Height = 25
    Caption = 'btnConnect'
    TabOrder = 0
    OnClick = btnConnectClick
  end
  object btnClose: TButton
    Left = 496
    Top = 48
    Width = 119
    Height = 25
    Caption = 'btnClose'
    TabOrder = 1
    OnClick = btnCloseClick
  end
  object btnOpenChannel: TButton
    Left = 200
    Top = 32
    Width = 129
    Height = 25
    Caption = 'Open Channel'
    TabOrder = 2
    OnClick = btnOpenChannelClick
  end
  object btnCloseChannel: TButton
    Left = 200
    Top = 63
    Width = 129
    Height = 25
    Caption = 'Close Channel'
    TabOrder = 3
    OnClick = btnCloseChannelClick
  end
  object btnDeclareExchange: TButton
    Left = 200
    Top = 112
    Width = 129
    Height = 25
    Caption = 'Declare Exchange'
    TabOrder = 4
    OnClick = btnDeclareExchangeClick
  end
  object btnDeleteExchange: TButton
    Left = 200
    Top = 143
    Width = 129
    Height = 25
    Caption = 'Delete Exchange'
    TabOrder = 5
    OnClick = btnDeleteExchangeClick
  end
  object btnDeclareQueue: TButton
    Left = 200
    Top = 184
    Width = 129
    Height = 25
    Caption = 'Declare Queue'
    TabOrder = 6
    OnClick = btnDeclareQueueClick
  end
  object btnQueuePurge: TButton
    Left = 200
    Top = 220
    Width = 129
    Height = 25
    Caption = 'Queue Purge'
    TabOrder = 7
    OnClick = btnQueuePurgeClick
  end
  object btnQueueDelete: TButton
    Left = 200
    Top = 251
    Width = 129
    Height = 25
    Caption = 'Queue delete'
    TabOrder = 8
    OnClick = btnQueueDeleteClick
  end
end
