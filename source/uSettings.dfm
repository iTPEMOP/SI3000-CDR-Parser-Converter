object frmSettings: TfrmSettings
  Left = 362
  Top = 224
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
      object chkNumber: TCheckBox
        Left = 16
        Top = 24
        Width = 240
        Height = 17
        Caption = 'Account number'
        TabOrder = 0
      end
      object chkDestNumber: TCheckBox
        Left = 16
        Top = 40
        Width = 240
        Height = 17
        Caption = 'Destitation number'
        TabOrder = 1
      end
      object chkCallStarts: TCheckBox
        Left = 16
        Top = 56
        Width = 240
        Height = 17
        Caption = 'Call starts'
        TabOrder = 2
      end
      object chkCallDuration: TCheckBox
        Left = 16
        Top = 72
        Width = 240
        Height = 17
        Caption = 'Call duration, sec.'
        TabOrder = 3
      end
      object chkCallEnds: TCheckBox
        Left = 16
        Top = 106
        Width = 240
        Height = 17
        Caption = 'Call ends'
        TabOrder = 4
      end
      object chkRecordIndex: TCheckBox
        Left = 276
        Top = 24
        Width = 240
        Height = 17
        Caption = 'Record index'
        TabOrder = 5
      end
      object chkRecordID: TCheckBox
        Left = 276
        Top = 40
        Width = 240
        Height = 17
        Caption = 'Record ID'
        TabOrder = 6
      end
      object chkRecordFlags: TCheckBox
        Left = 276
        Top = 56
        Width = 240
        Height = 17
        Caption = 'Record flags'
        TabOrder = 7
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
