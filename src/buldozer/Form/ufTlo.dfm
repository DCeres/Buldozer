object fmTlo: TfmTlo
  Left = 236
  Top = 130
  Caption = 'Bulldozer - '
  ClientHeight = 381
  ClientWidth = 638
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object MainMenu1: TMainMenu
    Left = 16
    Top = 8
    object Game1: TMenuItem
      Caption = '&Game'
      object RestartLevel1: TMenuItem
        Caption = 'Restart Level'
        ShortCut = 113
        OnClick = RestartLevel1Click
      end
      object UndoLastMove1: TMenuItem
        Caption = 'Undo Last Move'
        Enabled = False
        ShortCut = 16474
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Options1: TMenuItem
        Caption = 'Options...'
        OnClick = Options1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'Exit'
        ShortCut = 32883
        OnClick = Exit1Click
      end
    end
    object Help1: TMenuItem
      Caption = '&Help'
      object About1: TMenuItem
        Caption = 'About...'
        OnClick = About1Click
      end
    end
  end
  object ActionList1: TActionList
    Left = 16
    Top = 56
  end
end
