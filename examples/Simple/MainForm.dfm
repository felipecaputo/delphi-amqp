object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 170
  ClientWidth = 782
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
    Left = 652
    Top = 4
    Width = 119
    Height = 25
    Caption = 'Connect'
    TabOrder = 0
    OnClick = btnConnectClick
  end
  object btnClose: TButton
    Left = 652
    Top = 35
    Width = 119
    Height = 25
    Caption = 'Close'
    TabOrder = 1
    OnClick = btnCloseClick
  end
  object btnOpenChannel: TButton
    Left = 8
    Top = 4
    Width = 129
    Height = 25
    Caption = 'Open Channel'
    TabOrder = 2
    OnClick = btnOpenChannelClick
  end
  object btnCloseChannel: TButton
    Left = 8
    Top = 35
    Width = 129
    Height = 25
    Caption = 'Close Channel'
    TabOrder = 3
    OnClick = btnCloseChannelClick
  end
  object btnDeclareExchange: TButton
    Left = 8
    Top = 98
    Width = 129
    Height = 25
    Caption = 'Declare Exchange'
    TabOrder = 4
    OnClick = btnDeclareExchangeClick
  end
  object btnDeleteExchange: TButton
    Left = 8
    Top = 129
    Width = 129
    Height = 25
    Caption = 'Delete Exchange'
    TabOrder = 5
    OnClick = btnDeleteExchangeClick
  end
  object btnDeclareQueue: TButton
    Left = 148
    Top = 4
    Width = 129
    Height = 25
    Caption = 'Declare Queue'
    TabOrder = 6
    OnClick = btnDeclareQueueClick
  end
  object btnQueuePurge: TButton
    Left = 148
    Top = 35
    Width = 129
    Height = 25
    Caption = 'Queue Purge'
    TabOrder = 7
    OnClick = btnQueuePurgeClick
  end
  object btnQueueDelete: TButton
    Left = 148
    Top = 66
    Width = 129
    Height = 25
    Caption = 'Queue delete'
    TabOrder = 8
    OnClick = btnQueueDeleteClick
  end
  object btnConsumeQueue: TButton
    Left = 290
    Top = 4
    Width = 129
    Height = 25
    Caption = 'Start Consumer'
    TabOrder = 9
    OnClick = btnConsumeQueueClick
  end
  object btnCancelConsume: TButton
    Left = 290
    Top = 35
    Width = 129
    Height = 25
    Caption = 'Cancel Consumer'
    TabOrder = 10
    OnClick = btnCancelConsumeClick
  end
end
