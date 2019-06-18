object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 746
  ClientWidth = 1105
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
  object Button1: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 10
    Top = 39
    Width = 1087
    Height = 690
    TabOrder = 1
  end
  object Edit1: TEdit
    Left = 89
    Top = 12
    Width = 72
    Height = 21
    TabOrder = 2
    Text = '01.05.2019'
  end
  object Edit2: TEdit
    Left = 167
    Top = 12
    Width = 72
    Height = 21
    TabOrder = 3
    Text = '31.05.2019'
  end
  object Edit3: TEdit
    Left = 432
    Top = 12
    Width = 121
    Height = 21
    TabOrder = 4
  end
  object IdAntiFreeze1: TIdAntiFreeze
    Left = 712
    Top = 232
  end
end
