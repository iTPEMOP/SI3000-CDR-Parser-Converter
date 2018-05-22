object frmMain: TfrmMain
  Left = 416
  Top = 183
  Width = 1305
  Height = 675
  Caption = 'SI3000 Parser & Converter'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = mmTop
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object actlstMain: TActionList
    Left = 16
    Top = 16
    object actOpen: TAction
      Category = 'File'
      Caption = 'Open'
      Hint = 'Open|Open CS file'
    end
    object actSaveLog: TAction
      Category = 'File'
      Caption = 'Save log'
      Enabled = False
      Hint = 'Save|Save current log'
    end
    object actExit: TAction
      Category = 'File'
      Caption = 'Exit'
      Hint = 'Exit|Exit program'
    end
    object actSettings: TAction
      Category = 'Service'
      Caption = 'Settings'
      Hint = 'Settings|Program settings'
    end
  end
  object mmTop: TMainMenu
    Left = 88
    Top = 16
    object mniFile: TMenuItem
      Caption = 'File'
      object mniOpen: TMenuItem
        Action = actOpen
      end
      object mniSaveLog: TMenuItem
        Action = actSaveLog
      end
      object mniSeparator1: TMenuItem
        Caption = '-'
      end
      object mniExit: TMenuItem
        Action = actExit
      end
    end
    object mniService: TMenuItem
      Caption = 'Service'
      object mniSettings: TMenuItem
        Action = actSettings
      end
    end
  end
end
