object frmSettings: TfrmSettings
  Left = 580
  Top = 105
  Width = 600
  Height = 600
  BorderIcons = [biSystemMenu]
  Caption = 'frmSettings'
  Color = clBtnFace
  Constraints.MaxHeight = 600
  Constraints.MaxWidth = 600
  Constraints.MinHeight = 600
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
      Top = 120
      Width = 553
      Height = 73
      Caption = 'pnlMiddle'
      TabOrder = 2
      object lblPathHint: TLabel
        Left = 24
        Top = 56
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
        Left = 408
        Top = 8
        Width = 81
        Height = 41
        Caption = '...'
        TabOrder = 2
        Visible = False
        OnClick = pnlSelectDirClick
      end
    end
    object grpExportFields: TGroupBox
      Left = 0
      Top = 192
      Width = 593
      Height = 337
      Caption = 'Export fields'
      TabOrder = 3
      Visible = False
      object chkDN: TCheckBox
        Left = 16
        Top = 90
        Width = 240
        Height = 17
        Caption = 'DN -  directory number (owner number)'
        TabOrder = 5
        OnClick = chkDNClick
      end
      object chkCN: TCheckBox
        Left = 16
        Top = 130
        Width = 240
        Height = 17
        Caption = 'I100 CN - called number'
        TabOrder = 7
      end
      object chkSD: TCheckBox
        Left = 16
        Top = 144
        Width = 240
        Height = 17
        Caption = 'I102 SD - start date and time'
        TabOrder = 8
      end
      object chkED: TCheckBox
        Left = 16
        Top = 158
        Width = 240
        Height = 17
        Caption = 'I103 ED - end date and time'
        TabOrder = 9
      end
      object chkSI: TCheckBox
        Left = 16
        Top = 20
        Width = 240
        Height = 17
        Caption = 'SI - CDR index'
        TabOrder = 0
      end
      object chkCI: TCheckBox
        Left = 16
        Top = 34
        Width = 240
        Height = 17
        Caption = 'CI - call identifier (Call ID)'
        TabOrder = 1
      end
      object chkFL: TCheckBox
        Left = 16
        Top = 48
        Width = 240
        Height = 17
        Caption = 'FL - flags'
        TabOrder = 2
      end
      object chkCS: TCheckBox
        Left = 16
        Top = 76
        Width = 240
        Height = 17
        Caption = 'CS - charge status'
        TabOrder = 4
      end
      object chkSQ: TCheckBox
        Left = 16
        Top = 62
        Width = 240
        Height = 17
        Caption = 'SQ - record sequence'
        TabOrder = 3
      end
      object chkAC: TCheckBox
        Left = 28
        Top = 104
        Width = 240
        Height = 17
        Hint = 'Include owner area code as a separate field'
        Caption = 'AC - area code'
        TabOrder = 6
      end
      object chkCU: TCheckBox
        Left = 16
        Top = 172
        Width = 240
        Height = 17
        Caption = 'I104 CU - charging units'
        TabOrder = 10
      end
      object chkBS: TCheckBox
        Left = 16
        Top = 186
        Width = 240
        Height = 17
        Caption = 'I105 BS - basic service'
        TabOrder = 11
        OnClick = chkBSClick
      end
      object chkTS: TCheckBox
        Left = 28
        Top = 200
        Width = 240
        Height = 17
        Caption = 'I105 TS - teleservice'
        TabOrder = 12
      end
      object chkOC: TCheckBox
        Left = 16
        Top = 214
        Width = 240
        Height = 17
        Caption = 'I110 OC - origin category'
        TabOrder = 13
      end
      object chkTD: TCheckBox
        Left = 16
        Top = 228
        Width = 240
        Height = 17
        Caption = 'I111 TD - tariff direction'
        TabOrder = 14
      end
      object btnDefault: TButton
        Left = 386
        Top = 308
        Width = 95
        Height = 25
        Caption = 'Set default'
        TabOrder = 15
        OnClick = btnDefaultClick
      end
      object btnClearAll: TButton
        Left = 488
        Top = 308
        Width = 95
        Height = 25
        Caption = 'Clear all'
        TabOrder = 16
        OnClick = btnClearAllClick
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
      Left = 508
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
end
