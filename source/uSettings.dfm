object frmSettings: TfrmSettings
  Left = 998
  Top = 225
  Width = 600
  Height = 600
  Caption = 'frmSettings'
  Color = clBtnFace
  Constraints.MaxHeight = 600
  Constraints.MaxWidth = 600
  Constraints.MinHeight = 366
  Constraints.MinWidth = 600
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object pnlClient: TPanel
    Left = 0
    Top = 0
    Width = 592
    Height = 532
    Align = alClient
    TabOrder = 0
    object pnlTop: TPanel
      Left = 72
      Top = 8
      Width = 185
      Height = 41
      Caption = 'pnlTop'
      TabOrder = 0
    end
    object rgLogLevel: TRadioGroup
      Left = 2
      Top = 48
      Width = 588
      Height = 65
      Caption = 'Log level'
      Columns = 4
      ItemIndex = 2
      Items.Strings = (
        'Minimum'
        'Short'
        'Normal'
        'Verbose')
      TabOrder = 1
    end
    object pnlMiddle: TPanel
      Left = 16
      Top = 168
      Width = 553
      Height = 97
      Caption = 'pnlMiddle'
      TabOrder = 2
      object lblPathHint: TLabel
        Left = 24
        Top = 72
        Width = 44
        Height = 13
        Caption = 'Path Hint'
      end
      object chkExportCSV: TCheckBox
        Left = 8
        Top = 16
        Width = 200
        Height = 17
        Caption = 'Enable export to csv-formatted file'
        TabOrder = 0
        OnClick = chkExportCSVClick
      end
      object lbledtExportPath: TLabeledEdit
        Left = 152
        Top = 24
        Width = 121
        Height = 21
        EditLabel.Width = 57
        EditLabel.Height = 13
        EditLabel.Caption = 'Export path'
        TabOrder = 1
      end
      object pnlSelectDir: TPanel
        Left = 376
        Top = 32
        Width = 81
        Height = 41
        Caption = '...'
        TabOrder = 2
        Visible = False
        OnClick = pnlSelectDirClick
      end
    end
    object grpExportFields: TGroupBox
      Left = 16
      Top = 280
      Width = 545
      Height = 225
      Caption = 'Export fields'
      TabOrder = 3
      Visible = False
      object chkDN: TCheckBox
        Left = 16
        Top = 20
        Width = 240
        Height = 17
        Caption = 'AC, DN - area code,  directory number'
        TabOrder = 0
      end
      object chkCN: TCheckBox
        Left = 16
        Top = 34
        Width = 240
        Height = 17
        Caption = 'CN - called number'
        TabOrder = 1
      end
      object chkSD: TCheckBox
        Left = 16
        Top = 48
        Width = 240
        Height = 17
        Caption = 'SD - start date and time'
        TabOrder = 2
      end
      object chkDU: TCheckBox
        Left = 16
        Top = 62
        Width = 240
        Height = 17
        Caption = 'DU - call/service duration, sec.'
        TabOrder = 3
      end
      object chkED: TCheckBox
        Left = 16
        Top = 84
        Width = 240
        Height = 17
        Caption = 'ED - end date and time'
        TabOrder = 4
      end
      object chkSI: TCheckBox
        Left = 276
        Top = 20
        Width = 240
        Height = 17
        Caption = 'SI - CDR index'
        TabOrder = 7
      end
      object chkCI: TCheckBox
        Left = 276
        Top = 34
        Width = 240
        Height = 17
        Caption = 'CI - call identifier (Call ID)'
        TabOrder = 8
      end
      object chkFL: TCheckBox
        Left = 276
        Top = 48
        Width = 240
        Height = 17
        Caption = 'FL - flags'
        TabOrder = 9
      end
      object chkCS: TCheckBox
        Left = 16
        Top = 112
        Width = 240
        Height = 17
        Caption = 'CS - Charge status'
        TabOrder = 6
      end
      object chkSQ: TCheckBox
        Left = 16
        Top = 98
        Width = 240
        Height = 17
        Caption = 'SQ - record sequence'
        TabOrder = 5
      end
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 532
    Width = 592
    Height = 41
    Align = alBottom
    TabOrder = 1
    object btnSave: TButton
      Left = 8
      Top = 8
      Width = 75
      Height = 25
      Hint = '|Save settings'
      Caption = 'Save'
      ModalResult = 1
      TabOrder = 0
    end
    object btnCancel: TButton
      Left = 112
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
end
