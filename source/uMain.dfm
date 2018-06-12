object frmMain: TfrmMain
  Left = 292
  Top = 136
  Width = 1305
  Height = 675
  Caption = 'SI3000 Parser & Converter'
  Color = clBtnFace
  Constraints.MinHeight = 150
  Constraints.MinWidth = 500
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = mmTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object gProgress: TGauge
    Left = 64
    Top = 448
    Width = 100
    Height = 41
    Progress = 0
  end
  object sbpBottom: TStatusBar
    Left = 0
    Top = 610
    Width = 1297
    Height = 19
    Panels = <
      item
        Width = 296
      end
      item
        Width = 20
      end
      item
        Width = 50
      end>
  end
  object tlbTop: TToolBar
    Left = 0
    Top = 0
    Width = 1297
    Height = 29
    Caption = 'tlbTop'
    Images = ilMain
    TabOrder = 1
    object btnOpen: TToolButton
      Left = 0
      Top = 2
      Action = actOpen
    end
    object btnSaveLog: TToolButton
      Left = 23
      Top = 2
      Action = actSaveLog
    end
    object btnS2: TToolButton
      Left = 46
      Top = 2
      Width = 16
      Caption = 'btnS2'
      ImageIndex = 3
      Style = tbsSeparator
    end
    object btnSettings: TToolButton
      Left = 62
      Top = 2
      Action = actSettings
    end
  end
  object mmoLog: TMemo
    Left = 56
    Top = 192
    Width = 185
    Height = 89
    Color = clScrollBar
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Lucida Console'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object actlstMain: TActionList
    Images = ilMain
    Left = 24
    Top = 40
    object actOpen: TAction
      Category = 'File'
      Caption = 'Open'
      Hint = 'Open|Open CS file'
      ImageIndex = 0
      OnExecute = actOpenExecute
    end
    object actSaveLog: TAction
      Category = 'File'
      Caption = 'Save log'
      Enabled = False
      Hint = 'Save|Save current log'
      ImageIndex = 2
      OnExecute = actSaveLogExecute
    end
    object actExit: TAction
      Category = 'File'
      Caption = 'Exit'
      Hint = 'Exit|Exit program'
      ImageIndex = 4
      OnExecute = actExitExecute
    end
    object actSettings: TAction
      Category = 'Preferences'
      Caption = 'Settings'
      Hint = 'Settings|Program settings'
      ImageIndex = 6
      OnExecute = actSettingsExecute
    end
    object actEng: TAction
      Category = 'Preferences'
      AutoCheck = True
      Caption = 'English'
      Checked = True
      GroupIndex = 1
      Hint = 'English|Switch to english'
      OnExecute = actEngExecute
    end
    object actRus: TAction
      Category = 'Preferences'
      AutoCheck = True
      Caption = 'Russian'
      GroupIndex = 1
      Hint = 'Russian|Switch to russian'
      OnExecute = actRusExecute
    end
  end
  object mmTop: TMainMenu
    Images = ilMain
    Left = 88
    Top = 40
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
    object mniPreferences: TMenuItem
      Caption = 'Preferences'
      object mniSettings: TMenuItem
        Action = actSettings
      end
      object mniLanguage: TMenuItem
        Caption = 'Language'
        object mniEng: TMenuItem
          Action = actEng
          AutoCheck = True
          GroupIndex = 1
        end
        object mniRus: TMenuItem
          Action = actRus
          AutoCheck = True
          GroupIndex = 1
          RadioItem = True
        end
      end
    end
  end
  object aplctnvntsMain: TApplicationEvents
    OnHint = aplctnvntsMainHint
    Left = 160
    Top = 40
  end
  object ilMain: TImageList
    Left = 24
    Top = 96
    Bitmap = {
      494C010108000900040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000445005457830076799C00B9BBCC00D8D9E3000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000086868600AEAEAE00BEBEBE00DEDEDE00EDEDED000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000076767200767672007676720076767200000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000009D9D9D009D9D9D009D9D9D009D9D9D00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000A317D000C0D0F00001156004F82C7005A8DD2006699DE006598DD006497
      DC006295DA00426EB3002E559900001257000000000000000000000000000000
      00008F8F8F008383830088888800A2A2A200A4A4A400A7A7A700A7A7A700A7A7
      A700A6A6A6009D9D9D0097979700888888000000000000000000000000008E8A
      8A00000000000000000076767200DAD6D600DAD6D60076767200000000000000
      00008E8E8A00000000000000000000000000000000000000000000000000A2A2
      A20000000000000000009D9D9D00B5B5B500B5B5B5009D9D9D00000000000000
      0000A3A3A3000000000000000000000000000000000000000000000000000000
      00000C3582000E0F1200001861003164A800396CB000487BBE005184C8005A8D
      D2005E91D6005689CE004679BD00001962000000000000000000000000000000
      000090909000838383008A8A8A009A9A9A009C9C9C00A0A0A000A2A2A200A4A4
      A400A5A5A500A3A3A3009F9F9F008A8A8A0000000000000000008E8A8A00DEDA
      DA0096928E007E7A7A00726E6E006E6E6E006E6E6E00726E6E007E7A7A009692
      8E00DEDADA008E8A8A0000000000000000000000000000000000A2A2A200B6B6
      B600A4A4A4009E9E9E009B9B9B009B9B9B009B9B9B009B9B9B009E9E9E00A4A4
      A400B6B6B600A2A2A20000000000000000000000000000000000F9FCFA000000
      0000113F8B001313170000226D002A5DA1002B5EA2002B5EA2003363A900305E
      A8002B5EA2002B5EA2002B5CA00000236E000000000000000000FCFCFC000000
      000092929200858585008B8B8B009898980098989800989898009A9A9A009999
      99009898980098989800989898008C8C8C000000000086828200D6D6D2007A7A
      76003E3E3A009E9A9A00EAEAEA00FEFEFE00FEFEFE00EAEAEA00A29E9A003E3E
      3A007E7A7A00D6D6D600868282000000000000000000A0A0A000B5B5B5009E9E
      9E008F8F8F00A6A6A600BABABA00BFBFBF00BFBFBF00BABABA00A7A7A7008F8F
      8F009E9E9E00B5B5B500A0A0A000000000000000000000000000002FE6000000
      00001342900014161A00002470002A5DA1002B5EA2002A5DA1002E5CA2002E5C
      A5002B5EA2002B5EA20026559900002571000000000000000000979797000000
      000093939300858585008C8C8C00989898009898980098989800999999009999
      99009898980098989800979797008C8C8C0000000000000000008E8E8A005A5A
      560076727200E6E6E200EAE6E600F2EEEE00F2EEEE00EAE6E600E6E6E6007672
      72005A5A5600928E8A0000000000000000000000000000000000A3A3A3009696
      96009C9C9C00B9B9B900B9B9B900BBBBBB00BBBBBB00B9B9B900B9B9B9009C9C
      9C0096969600A3A3A30000000000000000000000000000000000002FE6000109
      CB00184A9A00191B200000287500295CA0002B5EA20024529700204A90002B57
      9F002B5EA2002B5DA1001E488C00012976000000000000000000979797009191
      910095959500878787008D8D8D00989898009898980096969600949494009898
      98009898980098989800949494008D8D8D0000000000000000007A767600AEAA
      A600D6D2D200BEBEBA0086828200000000000000000086828200BEBEBA00D6D6
      D200AEAAA6007A767600000000000000000000000000000000009D9D9D00AAAA
      AA00B4B4B400AFAFAF00A0A0A0000000000000000000A0A0A000AFAFAF00B5B5
      B500AAAAAA009D9D9D0000000000000000000033EE000033EE00002FE600095E
      FE000400B4001B1E2300002A7800295CA000295B9F0019408500163C84002854
      9D002B5EA2002350940013387B00012B79009898980098989800979797009D9D
      9D008F8F8F00878787008D8D8D00989898009898980092929200919191009797
      97009898980095959500909090008D8D8D0076767200767672006E6A6600C6C2
      BE00D2CECE0086828200000000008A8686008A8686000000000086828200D6D2
      CE00C6C2BE006E6A6A0076767200767672009D9D9D009D9D9D009A9A9A00B0B0
      B000B3B3B300A0A0A00000000000A1A1A100A1A1A10000000000A0A0A000B4B4
      B400B0B0B0009A9A9A009D9D9D009D9D9D000033EE004089FF002874FF00095E
      FE000055FE0007008100002E7D0014266900477ABF00477ABF00477ABF00477A
      BF00477ABF00477ABF00477ABF00012F7E0098989800A6A6A600A2A2A2009D9D
      9D009C9C9C008B8B8B008E8E8E008D8D8D00A0A0A000A0A0A000A0A0A000A0A0
      A000A0A0A000A0A0A000A0A0A0008E8E8E0076767200C2BEBE0086828200B2AE
      AE00B2AEAA00000000008A8A8600CAC6C600CAC6C6008A8A860000000000B6B2
      AE00B6B2AE008A868600C6C2BE00767672009D9D9D00AFAFAF00A0A0A000ABAB
      AB00ABABAB0000000000A2A2A200B1B1B100B1B1B100A2A2A20000000000ACAC
      AC00ACACAC00A1A1A100B0B0B0009D9D9D000033EE003F87FF002876FF00095D
      FE000055FE0007008100002F7F005287D100315EAA00305EA9003361AC00315F
      AA00305DA800305EA800305DA9000130800098989800A5A5A500A2A2A2009D9D
      9D009C9C9C008B8B8B008E8E8E00A3A3A3009A9A9A00999999009A9A9A009A9A
      9A009999990099999900999999008E8E8E0076767200C6C2BE009E9A9600B2AE
      AA00AEAAA600000000008E8A8A00DEDAD600DEDAD6008E8A8A0000000000B2AE
      AA00B2AEAA009E9A9A00C6C2C200767672009D9D9D00B0B0B000A6A6A600ABAB
      AB00AAAAAA0000000000A2A2A200B6B6B600B6B6B600A2A2A20000000000ABAB
      AB00ABABAB00A6A6A600B0B0B0009D9D9D000033EE000033EE00002CE600095D
      FE000400B400272A32000033840024579B00275A9E00275A9E002F60A4002B57
      A000275A9E00275A9E0024559900013485009898980098989800969696009D9D
      9D008F8F8F008A8A8A008F8F8F00979797009797970097979700999999009898
      98009797970097979700969696008F8F8F007676720076767200C6C6C200BEBA
      B6008A8686008A86860000000000928E8A00928E8A00000000008A8A86008A86
      8600BEBABA00CAC6C60076767200767672009D9D9D009D9D9D00B1B1B100AEAE
      AE00A1A1A100A1A1A10000000000A3A3A300A3A3A30000000000A2A2A200A1A1
      A100AEAEAE00B1B1B1009D9D9D009D9D9D000000000000000000002CE6000109
      CB002560B100292C35000035860024579B0026599D0025589C002C5BA0002D5B
      A40026599D0024579B00204F9200013687000000000000000000969696009191
      9100999999008B8B8B008F8F8F00979797009797970097979700989898009999
      99009797970097979700959595008F8F8F000000000000000000827E7E00DEDA
      D6008682820096928E008A8A860000000000000000008E8A8A0096928E008682
      8200DEDADA00827E7E00000000000000000000000000000000009F9F9F00B6B6
      B600A0A0A000A4A4A400A2A2A2000000000000000000A2A2A200A4A4A400A0A0
      A000B6B6B6009F9F9F0000000000000000000000000000000000002CE6000000
      00002560B1002D313A0000388B002154980024579B0020509300255097003563
      AF0023569A0021539700163D800001398C000000000000000000969696000000
      0000999999008C8C8C0090909000969696009797970095959500969696009B9B
      9B009696960096969600919191009090900000000000000000009A969200EEEA
      EA00EEEEEA006A6666005A5A5A0042424200424242005A5A5A006A666600F2EE
      EE00EEEEEA009A96960000000000000000000000000000000000A5A5A500BABA
      BA00BBBBBB00999999009696960090909000909090009696960099999900BBBB
      BB00BBBBBB00A5A5A50000000000000000000000000000000000000000000000
      00002560B1002F323D0000398C002053970023569900163F81001C448B003868
      B40022559900184285000C2B6C00013A8D000000000000000000000000000000
      0000999999008D8D8D0090909000969696009696960091919100939393009C9C
      9C0096969600929292008D8D8D0090909000000000008E8A8A00FEFEFE00EAE6
      E600F6F6F200EAE6E6009E9A9A004E4A4A004E4A4A009E9A9A00EEEAE600F6F6
      F600EAE6E600FEFEFE008E8E8A000000000000000000A2A2A200BFBFBF00B9B9
      B900BDBDBD00B9B9B900A6A6A6009292920092929200A6A6A600BABABA00BDBD
      BD00B9B9B900BFBFBF00A3A3A300000000000000000000000000000000000000
      00002560B10032373F00003C900025519700315FA700487AC800578AD9007CAF
      F40084B7FC007AADF2006A9DE200013D91000000000000000000000000000000
      0000999999008E8E8E00919191009696960099999900A0A0A000A4A4A400ADAD
      AD00AFAFAF00ACACAC00A8A8A800919191000000000000000000928E8E00FEFE
      FE00A29E9E0086828200EAEAEA00FEFEFE00FEFEFE00EAEAEA0086828200A29E
      9E00FEFEFE0096928E0000000000000000000000000000000000A3A3A300BFBF
      BF00A7A7A700A0A0A000BABABA00BFBFBF00BFBFBF00BABABA00A0A0A000A7A7
      A700BFBFBF00A4A4A40000000000000000000000000000000000000000000000
      00002560B10034384100003D910070A3E8007BAEF30088BBFF0085B8FD0083B6
      FB0078ACF200497FCA003069B500013E92000000000000000000000000000000
      0000999999008E8E8E0091919100AAAAAA00ADADAD00B0B0B000AFAFAF00AFAF
      AF00ACACAC00A1A1A1009B9B9B00919191000000000000000000000000009692
      8E00000000000000000076767200F2EEEE00F2EEEE0076767200000000000000
      000096928E00000000000000000000000000000000000000000000000000A4A4
      A40000000000000000009D9D9D00BBBBBB00BBBBBB009D9D9D00000000000000
      0000A4A4A4000000000000000000000000000000000000000000000000000000
      00000000000000000000044396005F87BC0083A2CB00CBD8EA00EDF2F8000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000093939300BABABA00CACACA00E9E9E900F8F8F8000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000076767200767672007676720076767200000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000009D9D9D009D9D9D009D9D9D009D9D9D00000000000000
      00000000000000000000000000000000000000000000148BD200148BD200ABD6
      EF00EFF7FC000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000009E9E9E009E9E9E00DDDD
      DD00F9F9F9000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000085DCF300A4F7FE0081EF
      FF0073EBFF006DD6F3004DBDE9001990D400148BD2002E98D70073BAE500F3F9
      FD000000000000000000000000000000000000000000B1B1B100B7B7B700B3B3
      B300B2B2B200AFAFAF00A9A9A9009F9F9F009E9E9E00A9A9A900C6C6C600FAFA
      FA0000000000000000000000000000000000000000003D3D3D0041414100A5A5
      A500ADADAD00A8A8A800A6A6A600A2A2A200A0A0A0009D9D9D009A9A9A009A9A
      9A00666666007F7F7F007D6FD90000000000000000008F8F8F0090909000A9A9
      A900ABABAB00AAAAAA00A9A9A900A8A8A800A8A8A800A7A7A700A6A6A600A6A6
      A600999999009F9F9F00A5A5A500000000000000000057BBE500A5F7FE0087F0
      FF007CEDFF0063E6FF0058E3FF0046DDFF0040DCFF0031AAE1001C94D600148B
      D200FAFDFE0000000000000000000000000000000000A9A9A900B7B7B700B4B4
      B400B3B3B300B0B0B000AFAFAF00ADADAD00ACACAC00A5A5A500A0A0A0009E9E
      9E00FDFDFD0000000000000000000000000000000000949494004B4B4B00128B
      F300128BF300128BF300128BF300128BF300128BF300128BF300128BF3001785
      D0001896EB00DDDDDD00999999000000000000000000C3C3C30098989800A1A1
      A100A1A1A100A1A1A100A1A1A100A1A1A100A1A1A100A1A1A100A1A1A1009E9E
      9E00A2A2A200B7B7B700A6A6A6000000000000000000148BD2008BDFF40092F3
      FF0088F0FF0071EAFF0066E7FF004FE1FF0046DEFF003FDCFF003FDCFF004CCB
      F100148BD200000000000000000000000000000000009E9E9E00B2B2B200B5B5
      B500B4B4B400B2B2B200B1B1B100AEAEAE00ADADAD00ACACAC00ACACAC00ABAB
      AB009E9E9E00000000000000000000000000000000003E3E3E0041414100F0F0
      F00000000000FDFDFD00FAFAFA00F3F3F300F0F0F000EAEAEA001785D00079CF
      F500DDFFFF00303030002121210000000000000000008F8F8F0090909000BCBC
      BC00BFBFBF00BFBFBF00BEBEBE00BCBCBC00BCBCBC00BABABA009E9E9E00AFAF
      AF00BCBCBC008C8C8C0088888800000000000000000036B5E60059BBE5009BF5
      FF008EF2FF0079EDFF006CE9FF0055E2FF004BDFFF003FDCFF003FDCFF003FDC
      FF00259EDB0000000000000000000000000000000000A6A6A600AAAAAA00B6B6
      B600B5B5B500B3B3B300B1B1B100AFAFAF00AEAEAE00ACACAC00ACACAC00ACAC
      AC00A2A2A200000000000000000000000000000000004242420044444400EFEF
      EF00CEBDB500CEBDB500CEBDB500CEBDB500CEBDB5001785D0001896EB00DDFF
      FF0084D3FF00303030002121210000000000000000009090900091919100BBBB
      BB00B0B0B000B0B0B000B0B0B000B0B0B000B0B0B0009E9E9E00A2A2A200BCBC
      BC00B1B1B1008C8C8C0088888800000000000000000061E9FF00148BD200ABF9
      FE009AF5FF0085EFFF007AEDFF0062E6FF0056E3FF0043DEFF003FDCFF003FDC
      FF003FDCFF00379CD900000000000000000000000000B0B0B0009E9E9E00B8B8
      B800B6B6B600B4B4B400B3B3B300B0B0B000AFAFAF00ADADAD00ACACAC00ACAC
      AC00ACACAC00ADADAD000000000000000000000000004C4C4C004B4B4B00EFEF
      EF00000000000000000000000000000000005353530079CFF500DDFFFF00FBFB
      FB00E2E2E2002F2F2F002121210000000000000000009393930092929200BBBB
      BB00BFBFBF00BFBFBF00BFBFBF00BFBFBF0094949400AFAFAF00BCBCBC00BEBE
      BE00B8B8B8008B8B8B0088888800000000000000000050E5FF000D9FE000A9F8
      FE00A3F7FF008CF2FF0081EEFF0068E8FF005CE4FF0048DFFF0040DCFF003FDC
      FF003FDCFF00148BD200EEF7FC000000000000000000AFAFAF00A1A1A100B7B7
      B700B7B7B700B5B5B500B3B3B300B1B1B100AFAFAF00ADADAD00ACACAC00ACAC
      AC00ACACAC009E9E9E00F8F8F8000000000000000000515151004E4E4E00EFEF
      EF00CEBDB500CEBDB500CEBDB500CEBDB50053535300CCE5FF0084D3FF00CEBD
      B500E6E6E6002F2F2F002121210000000000000000009494940093939300BBBB
      BB00B0B0B000B0B0B000B0B0B000B0B0B00094949400B9B9B900B1B1B100B0B0
      B000B9B9B9008B8B8B008888880000000000000000002EDCFF0000C8FD00148B
      D20034A1DB0067C6E9007CD5F0009EF6FE009DF5FE008CF1FE0072E9FE003FDC
      FF003FDCFF0057CFF200148BD2000000000000000000ABABAB00A5A5A5009E9E
      9E00A4A4A400ACACAC00B0B0B000B6B6B600B6B6B600B4B4B400B2B2B200ACAC
      AC00ACACAC00ACACAC009E9E9E0000000000000000005B5B5B0055555500F0F0
      F00000000000874F2900874F2900874F29000000000000000000000000000000
      0000F0F0F0002F2F2F002121210000000000000000009696960095959500BCBC
      BC00BFBFBF00959595009595950095959500BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BCBCBC008B8B8B008888880000000000000000002CDCFF0000CBFF0008B0
      EC000DA3E300148BD200148BD200148BD20031A0DB005BC3E9006BD2F00089F0
      FF0083EEFE0076EBFF00279FDC000000000000000000ABABAB00A6A6A600A3A3
      A300A1A1A1009E9E9E009E9E9E009E9E9E00A3A3A300ABABAB00AEAEAE00B4B4
      B400B3B3B300B2B2B200A2A2A20000000000000000006060600059595900E9E9
      E900FCFCFC00F4F4F400F4F4F400F5F5F500F5F5F500F5F5F500F5F5F5000000
      0000EAEAEA00313131002222220000000000000000009898980096969600BABA
      BA00BFBFBF00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BFBF
      BF00BABABA008C8C8C008888880000000000000000002EDAFF0000CBFF0000CB
      FF0000CBFF0000CBFF0000CBFF0000CBFF0000CBFF0000CBFF0000CBFF0003C2
      F8005FCDEE00178DD300148BD200DDEFF90000000000ABABAB00A6A6A600A6A6
      A600A6A6A600A6A6A600A6A6A600A6A6A600A6A6A600A6A6A600A6A6A600A5A5
      A500ACACAC00A0A0A0009E9E9E00F1F1F100000000006B6B6B006A6A6A006262
      6200606060004E4E4E004A4A4A0045454500424242003D3D3D003A3A3A003737
      370037373700343434002D2D2D0000000000000000009A9A9A009A9A9A009898
      980098989800939393009292920091919100909090008F8F8F008E8E8E008D8D
      8D008D8D8D008D8D8D008B8B8B0000000000000000002EDAFF0000CBFF0001CC
      FF0001CCFF0001CCFF0000CAFF0095F7FF0090F5FF008FF5FF008FF5FF008DF5
      FF008DF5FF00EEF7FC00000000000000000000000000ABABAB00A6A6A600A6A6
      A600A6A6A600A6A6A600A6A6A600B6B6B600B5B5B500B5B5B500B5B5B500B5B5
      B500B5B5B500F4F4F400000000000000000000000000707070006A6A6A005E5E
      5E005A5A5A0060606000616161005959590055555500535353004F4F4F004242
      42003B3B3B00383838003333330000000000000000009C9C9C009A9A9A009797
      9700969696009898980098989800969696009595950094949400939393009090
      90008E8E8E008E8E8E008C8C8C000000000000000000AFFDFF007AEFFF007CEF
      FF007CEFFF007CEFFF007EF3FF000000000000000000000000000000000039B4
      5E005AD984003AB55F0035AF58000000000000000000B8B8B800B3B3B300B3B3
      B300B3B3B300B3B3B300B4B4B400000000000000000000000000000000009B9B
      9B00A4A4A4009B9B9B009A9A9A00000000000000000075757500363636002B2B
      2A0022222200FAFAFA00F8F8F800F1F1F100EDEDED00E5E5E500E1E1E000DBDA
      DB0084858400404040003D3D3D0000000000000000009D9D9D008D8D8D008A8A
      8A0088888800BEBEBE00BEBEBE00BCBCBC00BBBBBB00B9B9B900B8B8B800B6B6
      B600A1A1A100909090008F8F8F0000000000000000002497D600148BD200148B
      D200148BD200148BD2002295D5000000000000000000000000000000000055AE
      650032AC55003AB55F0035AF58000000000000000000A1A1A1009E9E9E009E9E
      9E009E9E9E009E9E9E00A1A1A10000000000000000000000000000000000ACAC
      AC00999999009B9B9B009A9A9A0000000000000000007A7A7A003B3A3A002F2F
      2F0026262600FAFAFA00F8F8F700F1F1F100EDEDEE006B6B6B0068686800DADA
      DA0083838300444444004141410000000000000000009E9E9E008E8E8E008B8B
      8B0089898900BEBEBE00BDBDBD00BCBCBC00BBBBBB009A9A9A009A9A9A00B6B6
      B600A0A0A0009191910090909000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000063BE7600C7E6CA005AD9
      84004BCA7400259B410035AF5800000000000000000000000000000000000000
      00000000000000000000000000000000000000000000AFAFAF00E2E2E200A4A4
      A400A0A0A000959595009A9A9A00000000000000000082828200424242003535
      35002D2D2D00FAFAFA00F8F8F800F1F1F100EEEEED00717170006D6D6E00DADA
      DA00848484004C4C4C004A4A4A000000000000000000A0A0A000909090008D8D
      8D008B8B8B00BEBEBE00BEBEBE00BCBCBC00BBBBBB009C9C9C009B9B9B00B6B6
      B600A1A1A1009393930092929200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000044C16C0037B25B0054D3
      7D004BCA7400489D510021953A00000000000000000000000000000000000000
      000000000000000000000000000000000000000000009E9E9E009B9B9B00A3A3
      A300A0A0A000A8A8A80094949400000000000000000088888800444444003635
      36002D2D2D00FAFAFA00F8F8F800F1F1F100EDEDED00E5E4E500E0E1E000DADA
      DA0087878600505050004E4E4E000000000000000000A2A2A200919191008D8D
      8D008B8B8B00BEBEBE00BEBEBE00BCBCBC00BBBBBB00B9B9B900B8B8B800B6B6
      B600A1A1A1009494940093939300000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C9E8CC002DA54C002297
      3C00C1E0C3000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E2E2E200979797009494
      9400E0E0E0000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FC1FFC1FFC3FFC3FF000F000EC37EC37
      F000F000C003C003D000D00080018001D000D000C003C003C000C000C183C183
      0000000002400240000000000420042000000000042004200000000002400240
      C000C000C183C183D000D000C003C003F000F00080018001F000F000C003C003
      F000F000EC37EC37FC1FFC1FFC3FFC3F87FF87FFFFFFFFFF800F800F80018001
      800780078001800180078007880180018007800780018001800380038F018001
      80018001800180018001800188F1800180018001801180018000800080018001
      800380038001800181E181E18001800181E181E180018001FF81FF8180018001
      FF81FF8180018001FF87FF87FFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object dlgOpen: TOpenDialog
    DefaultExt = 'ama'
    Filter = 'SI3000 files|*.ama|All files|*.*'
    Left = 88
    Top = 96
  end
  object dlgSave: TSaveDialog
    DefaultExt = 'txt'
    Filter = 'Text files|*.txt|All files|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 144
    Top = 96
  end
end
