object fmOptions: TfmOptions
  Left = 322
  Top = 187
  BorderStyle = bsDialog
  Caption = 'Options'
  ClientHeight = 260
  ClientWidth = 169
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 24
    Top = 8
    Width = 121
    Height = 73
  end
  object ListBox1: TListBox
    Left = 8
    Top = 88
    Width = 153
    Height = 137
    ItemHeight = 13
    TabOrder = 0
    OnClick = ListBox1Click
    OnDblClick = ListBox1DblClick
  end
  object Button1: TButton
    Left = 47
    Top = 232
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 1
    OnClick = Button1Click
  end
end
