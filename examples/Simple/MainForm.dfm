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
end
