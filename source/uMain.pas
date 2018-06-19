unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ActnList, ComCtrls, AppEvnts, ImgList, ToolWin, StdCtrls,
  Gauges;

type
  TfrmMain = class(TForm)
    actlstMain: TActionList;
    actOpen: TAction;
    actSaveLog: TAction;
    actExit: TAction;
    actSettings: TAction;
    mmTop: TMainMenu;
    mniFile: TMenuItem;
    mniPreferences: TMenuItem;
    mniOpen: TMenuItem;
    mniSaveLog: TMenuItem;
    mniSeparator1: TMenuItem;
    mniExit: TMenuItem;
    mniSettings: TMenuItem;
    sbpBottom: TStatusBar;
    aplctnvntsMain: TApplicationEvents;
    ilMain: TImageList;
    tlbTop: TToolBar;
    btnOpen: TToolButton;
    btnSaveLog: TToolButton;
    btnS2: TToolButton;
    btnSettings: TToolButton;
    actEng: TAction;
    actRus: TAction;
    mniLanguage: TMenuItem;
    mniEng: TMenuItem;
    mniRus: TMenuItem;
    mmoLog: TMemo;
    dlgOpen: TOpenDialog;
    gProgress: TGauge;
    dlgSave: TSaveDialog;
    procedure aplctnvntsMainHint(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actOpenExecute(Sender: TObject);
    procedure actSaveLogExecute(Sender: TObject);
    procedure actSettingsExecute(Sender: TObject);
    procedure actEngExecute(Sender: TObject);
    procedure actRusExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure CheckI18N;
    procedure InitInterface;
    procedure SetLang(ALang: string);
    procedure EnsureLogSaveEnabled;
  end;

var
  frmMain: TfrmMain;
  lang: string;

implementation

{$R *.dfm}

uses IniFiles, Parser, I18NMessages, uSettings;

const
  SBP_HINT = 0;
  SBP_STATUS = 1;
  SBP_FILENAME = 2;

procedure TfrmMain.aplctnvntsMainHint(Sender: TObject);
begin
  if Trim(Application.Hint) <> '' then
    sbpBottom.Panels[SBP_HINT].Text := Application.Hint
  else
    sbpBottom.Panels[SBP_HINT].Text := '';
end;

procedure TfrmMain.actExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.actOpenExecute(Sender: TObject);
var
  Parser: TParser;
begin
  // Open file
  if dlgOpen.Execute then
  begin
    Parser := TParser.Create(dlgOpen.FileName, mmoLog, gProgress);
    try
      if Parser.PreFileCheck then
      begin
        Parser.ClearLog;
        sbpBottom.Panels[SBP_FILENAME].Text := dlgOpen.FileName;
        Parser.Log(Format(GetAMessage('BEGIN_PARSE', lang), [dlgOpen.FileName]));
        gProgress.Visible := True;
        if Parser.Parse then
        begin
          Parser.Log(GetAMessage('PARSE_COMPLETED_SUCCESSFULLY', lang));
          Application.MessageBox(
            PChar(Format(GetAMessage('TOTAL_PARSED', lang), [Parser.RecCount])),
            PChar(GetAMessage('INFORMATION', lang)),
            MB_OK + MB_ICONINFORMATION
          );
        end
        else
        begin
          Application.MessageBox(
            PChar(Format(GetAMessage('ERROR_DURING_PARSING', lang), [dlgOpen.FileName])),
            PChar(GetAMessage('WARNING', lang)),
            MB_OK + MB_ICONWARNING
          );
        end;
        EnsureLogSaveEnabled;
      end
      else
        Application.MessageBox(
          PChar(Format(GetAMessage('IS_NOT_VALID_SI3000_FILE', lang), [dlgOpen.FileName])),
          PChar(GetAMessage('WARNING', lang)),
          MB_OK + MB_ICONWARNING
        );
    finally
      Parser.Free;
      gProgress.Visible := False;
    end;
  end;

end;

procedure TfrmMain.actSaveLogExecute(Sender: TObject);
begin
  if mmoLog.Lines.Count > 0 then
  begin
    dlgSave.FileName := Format('log_%s_si3000_parser', [FormatDateTime('yyyy-mm-dd', Now)]);
    if dlgSave.Execute then
    begin
      mmoLog.Lines.SaveToFile(dlgSave.FileName);
      Application.MessageBox(
        PChar(GetAMessage('LOG_HAS_BEEN_SAVED', lang)),
        PChar(GetAMessage('INFORMATION', lang)),
        MB_OK + MB_ICONINFORMATION
      );
    end;
  end
  else
    Application.MessageBox(
      PChar(GetAMessage('LOG_IS_EMPTY', lang)),
      PChar(GetAMessage('WARNING', lang)),
      MB_OK + MB_ICONWARNING
    );
end;

procedure TfrmMain.actSettingsExecute(Sender: TObject);
begin
  frmSettings := TfrmSettings.Create(Application);
  try
    if frmSettings.ShowModal = mrOK then
      frmSettings.SaveSettings;
   finally
    {
      Ensure destroy frmSettings.
      Needs at TSfrmSettingsForm.InitInterface for correct form name value.
    }
    frmSettings.Free;
  end;
end;

procedure TfrmMain.actEngExecute(Sender: TObject);
begin
  SetLang('en');
  InitInterface;
end;

procedure TfrmMain.actRusExecute(Sender: TObject);
begin
  SetLang('ru');
  InitInterface;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  CheckI18N;
  InitInterface;
  mmoLog.Align := alClient;
  gProgress.Visible := False;
  with gProgress do
  begin
    Parent := sbpBottom;
    Top := 2;
    Left := 1;
    Height := sbpBottom.Height - Top;
    Width := sbpBottom.Panels[0].Width - Left * 2;
  end;
end;

procedure TfrmMain.CheckI18N;
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'params.ini');
  try
    if not IniFile.ValueExists('en', 'frmMain_mniFile_Caption') then
      IniFile.WriteString('en', 'frmMain_mniFile_Caption', 'File');
    if not IniFile.ValueExists('ru', 'frmMain_mniFile_Caption') then
      IniFile.WriteString('ru', 'frmMain_mniFile_Caption', '����');
    if not IniFile.ValueExists('en', 'frmMain_mniPreferences_Caption') then
      IniFile.WriteString('en', 'frmMain_mniPreferences_Caption', 'Preferences');
    if not IniFile.ValueExists('ru', 'frmMain_mniPreferences_Caption') then
      IniFile.WriteString('ru', 'frmMain_mniPreferences_Caption', '���������');
    if not IniFile.ValueExists('en', 'frmMain_mniLanguage_Caption') then
      IniFile.WriteString('en', 'frmMain_mniLanguage_Caption', 'Language');
    if not IniFile.ValueExists('ru', 'frmMain_mniLanguage_Caption') then
      IniFile.WriteString('ru', 'frmMain_mniLanguage_Caption', '����');

    if not IniFile.ValueExists('en', 'frmMain_actOpen_Caption') then
      IniFile.WriteString('en', 'frmMain_actOpen_Caption', 'Open');
    if not IniFile.ValueExists('ru', 'frmMain_actOpen_Caption') then
      IniFile.WriteString('ru', 'frmMain_actOpen_Caption', '�������');
    if not IniFile.ValueExists('en', 'frmMain_actSaveLog_Caption') then
      IniFile.WriteString('en', 'frmMain_actSaveLog_Caption', 'Save log');
    if not IniFile.ValueExists('ru', 'frmMain_actSaveLog_Caption') then
      IniFile.WriteString('ru', 'frmMain_actSaveLog_Caption', '��������� ���');
    if not IniFile.ValueExists('en', 'frmMain_actExit_Caption') then
      IniFile.WriteString('en', 'frmMain_actExit_Caption', 'Exit');
    if not IniFile.ValueExists('ru', 'frmMain_actExit_Caption') then
      IniFile.WriteString('ru', 'frmMain_actExit_Caption', '�����');
    if not IniFile.ValueExists('en', 'frmMain_actSettings_Caption') then
      IniFile.WriteString('en', 'frmMain_actSettings_Caption', 'Settings');
    if not IniFile.ValueExists('ru', 'frmMain_actSettings_Caption') then
      IniFile.WriteString('ru', 'frmMain_actSettings_Caption', '���������');
    if not IniFile.ValueExists('en', 'frmMain_actEng_Caption') then
      IniFile.WriteString('en', 'frmMain_actEng_Caption', 'English');
    if not IniFile.ValueExists('ru', 'frmMain_actEng_Caption') then
      IniFile.WriteString('ru', 'frmMain_actEng_Caption', '����������');
    if not IniFile.ValueExists('en', 'frmMain_actRus_Caption') then
      IniFile.WriteString('en', 'frmMain_actRus_Caption', 'Russian');
    if not IniFile.ValueExists('ru', 'frmMain_actRus_Caption') then
      IniFile.WriteString('ru', 'frmMain_actRus_Caption', '�������');

    if not IniFile.ValueExists('en', 'frmMain_actOpen_Hint') then
      IniFile.WriteString('en', 'frmMain_actOpen_Hint', 'Open|Open SI3000 file');
    if not IniFile.ValueExists('ru', 'frmMain_actOpen_Hint') then
      IniFile.WriteString('ru', 'frmMain_actOpen_Hint', '�������|������� ���� ��� SI3000');
    if not IniFile.ValueExists('en', 'frmMain_actSaveLog_Hint') then
      IniFile.WriteString('en', 'frmMain_actSaveLog_Hint', 'Save log|Save current log to text file');
    if not IniFile.ValueExists('ru', 'frmMain_actSaveLog_Hint') then
      IniFile.WriteString('ru', 'frmMain_actSaveLog_Hint', '��������� ���|��������� ������� ��� � ��������� �����');
    if not IniFile.ValueExists('en', 'frmMain_actExit_Hint') then
      IniFile.WriteString('en', 'frmMain_actExit_Hint', 'Exit|Exit program');
    if not IniFile.ValueExists('ru', 'frmMain_actExit_Hint') then
      IniFile.WriteString('ru', 'frmMain_actExit_Hint', '�����|����� �� ���������');
    if not IniFile.ValueExists('en', 'frmMain_actSettings_Hint') then
      IniFile.WriteString('en', 'frmMain_actSettings_Hint', 'Settings|Program & parser settings');
    if not IniFile.ValueExists('ru', 'frmMain_actSettings_Hint') then
      IniFile.WriteString('ru', 'frmMain_actSettings_Hint', '���������|��������� ���������� � �������');
    if not IniFile.ValueExists('en', 'frmMain_actEng_Hint') then
      IniFile.WriteString('en', 'frmMain_actEng_Hint', 'English|Switch to English');
    if not IniFile.ValueExists('ru', 'frmMain_actEng_Hint') then
      IniFile.WriteString('ru', 'frmMain_actEng_Hint', '����������|����������� �� ����������');
    if not IniFile.ValueExists('en', 'frmMain_actRus_Hint') then
      IniFile.WriteString('en', 'frmMain_actRus_Hint', 'Russian|Switch to Russian');
    if not IniFile.ValueExists('ru', 'frmMain_actRus_Hint') then
      IniFile.WriteString('ru', 'frmMain_actRus_Hint', '�������|����������� �� �������');

    // Settings form elements
    if not IniFile.ValueExists('en', 'frmSettings_btnSave_Caption') then
      IniFile.WriteString('en', 'frmSettings_btnSave_Caption', 'Save');
    if not IniFile.ValueExists('ru', 'frmSettings_btnSave_Caption') then
      IniFile.WriteString('ru', 'frmSettings_btnSave_Caption', '���������');
    if not IniFile.ValueExists('en', 'frmSettings_btnCancel_Caption') then
      IniFile.WriteString('en', 'frmSettings_btnCancel_Caption', 'Cancel');
    if not IniFile.ValueExists('ru', 'frmSettings_btnCancel_Caption') then
      IniFile.WriteString('ru', 'frmSettings_btnCancel_Caption', '������');
    if not IniFile.ValueExists('en', 'frmSettings_btnDefault_Caption') then
      IniFile.WriteString('en', 'frmSettings_btnDefault_Caption', 'Set default');
    if not IniFile.ValueExists('ru', 'frmSettings_btnDefault_Caption') then
      IniFile.WriteString('ru', 'frmSettings_btnDefault_Caption', '�� ���������');
    if not IniFile.ValueExists('en', 'frmSettings_btnClearAll_Caption') then
      IniFile.WriteString('en', 'frmSettings_btnClearAll_Caption', 'Clear all');
    if not IniFile.ValueExists('ru', 'frmSettings_btnClearAl_Caption') then
      IniFile.WriteString('ru', 'frmSettings_btnClearAl_Caption', '�������� ���');
    if not IniFile.ValueExists('en', 'frmSettings_lblPathHint_Caption') then
      IniFile.WriteString('en', 'frmSettings_lblPathHint_Caption', '(HINT: If not specified, the export file will be saved in the same folder where the source *.ama file.)');
    if not IniFile.ValueExists('ru', 'frmSettings_lblPathHint_Caption') then
      IniFile.WriteString('ru', 'frmSettings_lblPathHint_Caption', '(���������: ���� ���� �� ������, ���� �������� ����� �������� � ��� �� �����, ��� �������� ama-����.)');
    if not IniFile.ValueExists('en', 'frmSettings_rgLogLevel_Caption') then
      IniFile.WriteString('en', 'frmSettings_rgLogLevel_Caption', 'Log level');
    if not IniFile.ValueExists('ru', 'frmSettings_rgLogLevel_Caption') then
      IniFile.WriteString('ru', 'frmSettings_rgLogLevel_Caption', '��� ������ �������');
    if not IniFile.ValueExists('en', 'frmSettings_grpExportFields_Caption') then
      IniFile.WriteString('en', 'frmSettings_grpExportFields_Caption', 'Export fields');
    if not IniFile.ValueExists('ru', 'frmSettings_grpExportFields_Caption') then
      IniFile.WriteString('ru', 'frmSettings_grpExportFields_Caption', '�������������� ����');
    if not IniFile.ValueExists('en', 'frmSettings_lbledtExportPath_Caption') then
      IniFile.WriteString('en', 'frmSettings_lbledtExportPath_Caption', 'Export path');
    if not IniFile.ValueExists('ru', 'frmSettings_lbledtExportPath_Caption') then
      IniFile.WriteString('ru', 'frmSettings_lbledtExportPath_Caption', '���� ��� ������ ��������');
    if not IniFile.ValueExists('en', 'frmSettingd_chkExportCSV_Caption') then
      IniFile.WriteString('en', 'frmSettings_chkExportCSV_Caption', 'Enable export to csv-formatted file');
    if not IniFile.ValueExists('ru', 'frmSettings_chkExportCSV_Caption') then
      IniFile.WriteString('ru', 'frmSettings_chkExportCSV_Caption', '��������� ������� � csv-����');

    if not IniFile.ValueExists('en', 'frmSettings_chkSI_Caption') then
      IniFile.WriteString('en', 'frmSettings_chkSI_Caption', 'SI - CDR index');
    if not IniFile.ValueExists('ru', 'frmSettings_chkSI_Caption') then
      IniFile.WriteString('ru', 'frmSettings_chkSI_Caption', 'SI - ������ CDR ������');
    if not IniFile.ValueExists('en', 'frmSettings_chkCI_Caption') then
      IniFile.WriteString('en', 'frmSettings_chkCI_Caption', 'CI - call identifier (Call ID)');
    if not IniFile.ValueExists('ru', 'frmSettings_chkCI_Caption') then
      IniFile.WriteString('ru', 'frmSettings_chkCI_Caption', 'CI - ������������� ������ (Call ID)');
    if not IniFile.ValueExists('en', 'frmSettings_chkFL_Caption') then
      IniFile.WriteString('en', 'frmSettings_chkFL_Caption', 'FL - flags');
    if not IniFile.ValueExists('ru', 'frmSettings_chkFL_Caption') then
      IniFile.WriteString('ru', 'frmSettings_chkFL_Caption', 'FL - ����� ������');
    if not IniFile.ValueExists('en', 'frmSettings_chkSQ_Caption') then
      IniFile.WriteString('en', 'frmSettings_chkSQ_Caption', 'SQ - record sequence');
    if not IniFile.ValueExists('ru', 'frmSettings_chkSQ_Caption') then
      IniFile.WriteString('ru', 'frmSettings_chkSQ_Caption', 'SQ - ������������������ ������');
    if not IniFile.ValueExists('en', 'frmSettings_chkCS_Caption') then
      IniFile.WriteString('en', 'frmSettings_chkCS_Caption', 'CS - charge status');
    if not IniFile.ValueExists('ru', 'frmSettings_chkCS_Caption') then
      IniFile.WriteString('ru', 'frmSettings_chkCS_Caption', 'CS - ������ �������');
    if not IniFile.ValueExists('en', 'frmSettings_chkAC_Caption') then
      IniFile.WriteString('en', 'frmSettings_chkAC_Caption', 'AC - area code (owner number)');
    if not IniFile.ValueExists('ru', 'frmSettings_chkAC_Caption') then
      IniFile.WriteString('ru', 'frmSettings_chkAC_Caption', 'AC - ��� ���� ��������');
    if not IniFile.ValueExists('en', 'frmSettings_chkDN_Caption') then
      IniFile.WriteString('en', 'frmSettings_chkDN_Caption', 'DN -  directory number (owner number)');
    if not IniFile.ValueExists('ru', 'frmSettings_chkDN_Caption') then
      IniFile.WriteString('ru', 'frmSettings_chkDN_Caption', 'DN - ����� ��������');
    if not IniFile.ValueExists('en', 'frmSettings_chkCN_Caption') then
      IniFile.WriteString('en', 'frmSettings_chkCN_Caption', 'I100 CN - called number');
    if not IniFile.ValueExists('ru', 'frmSettings_chkCN_Caption') then
      IniFile.WriteString('ru', 'frmSettings_chkCN_Caption', 'I100 CN - ���������� �����');
    if not IniFile.ValueExists('en', 'frmSettings_chkSD_Caption') then
      IniFile.WriteString('en', 'frmSettings_chkSD_Caption', 'I102 SD - start date and time');
    if not IniFile.ValueExists('ru', 'frmSettings_chkSD_Caption') then
      IniFile.WriteString('ru', 'frmSettings_chkSD_Caption', 'I102 SD - ����/����� ������ ������');
    if not IniFile.ValueExists('en', 'frmSettings_chkED_Caption') then
      IniFile.WriteString('en', 'frmSettings_chkED_Caption', 'I103 ED - end date and time');
    if not IniFile.ValueExists('ru', 'frmSettings_chkED_Caption') then
      IniFile.WriteString('ru', 'frmSettings_chkED_Caption', 'I103 ED - ����/����� ��������� ������');
    if not IniFile.ValueExists('en', 'frmSettings_chkCU_Caption') then
      IniFile.WriteString('en', 'frmSettings_chkCU_Caption', 'I104 CU - charging units');
    if not IniFile.ValueExists('ru', 'frmSettings_chkCU_Caption') then
      IniFile.WriteString('ru', 'frmSettings_chkCU_Caption', 'I104 CU - ���������� �������� ���������');
    if not IniFile.ValueExists('en', 'frmSettings_chkBS_Caption') then
      IniFile.WriteString('en', 'frmSettings_chkBS_Caption', 'I105 BS - basic service');
    if not IniFile.ValueExists('ru', 'frmSettings_chkBS_Caption') then
      IniFile.WriteString('ru', 'frmSettings_chkBS_Caption', 'I105 BS - ������� ������');
    if not IniFile.ValueExists('en', 'frmSettings_chkTS_Caption') then
      IniFile.WriteString('en', 'frmSettings_chkTS_Caption', 'I105 TS - teleservice');
    if not IniFile.ValueExists('ru', 'frmSettings_chkTS_Caption') then
      IniFile.WriteString('ru', 'frmSettings_chkTS_Caption', 'I105 TS - ����������');
    if not IniFile.ValueExists('en', 'frmSettings_chkOC_Caption') then
      IniFile.WriteString('en', 'frmSettings_chkOC_Caption', 'I110 OC - origin category');
    if not IniFile.ValueExists('ru', 'frmSettings_chkOC_Caption') then
      IniFile.WriteString('ru', 'frmSettings_chkOC_Caption', 'I110 OC - �������� ��������� ������');
    if not IniFile.ValueExists('en', 'frmSettings_chkTD_Caption') then
      IniFile.WriteString('en', 'frmSettings_chkTD_Caption', 'I111 TD - tariff direction');
    if not IniFile.ValueExists('ru', 'frmSettings_chkTD_Caption') then
      IniFile.WriteString('ru', 'frmSettings_chkTD_Caption', 'I111 TD - ����������� ������');
    if not IniFile.ValueExists('en', 'frmSettings_chkDU_Caption') then
      IniFile.WriteString('en', 'frmSettings_chkDU_Caption', 'I115 DU - call/service duration, sec.');
    if not IniFile.ValueExists('ru', 'frmSettings_chkDU_Caption') then
      IniFile.WriteString('ru', 'frmSettings_chkDU_Caption', 'I115 DU - ����������������� ������/������, ���.');
    if not IniFile.ValueExists('en', 'frmSettings_chkOCN_Caption') then
      IniFile.WriteString('en', 'frmSettings_chkOCN_Caption', 'I119 OCN - original calling party number');
    if not IniFile.ValueExists('ru', 'frmSettings_chkOCN_Caption') then
      IniFile.WriteString('ru', 'frmSettings_chkOCN_Caption', 'I119 OCN - �������� ����� ����������� ��������');
    if not IniFile.ValueExists('en', 'frmSettings_chkCV_Caption') then
      IniFile.WriteString('en', 'frmSettings_chkCV_Caption', 'I121 CV - call release cause value');
    if not IniFile.ValueExists('ru', 'frmSettings_chkVC_Caption') then
      IniFile.WriteString('ru', 'frmSettings_chkCV_Caption', 'I121 CV - ��� ������� ������������ ������');
    if not IniFile.ValueExists('en', 'frmSettings_chkLO_Caption') then
      IniFile.WriteString('en', 'frmSettings_chkLO_Caption', 'I121 LO - location');
    if not IniFile.ValueExists('ru', 'frmSettings_chkLO_Caption') then
      IniFile.WriteString('ru', 'frmSettings_chkLO_Caption', 'I121 LO - ��������������');
    if not IniFile.ValueExists('en', 'frmSettings_chkOSR_IP_Caption') then
      IniFile.WriteString('en', 'frmSettings_chkOSR_IP_Caption', 'I127 origin side remote IP');
    if not IniFile.ValueExists('ru', 'frmSettings_chkOSR_IP_Caption') then
      IniFile.WriteString('ru', 'frmSettings_chkOSR_IP_Caption', 'I127 ��������� ��������� IP');
    if not IniFile.ValueExists('en', 'frmSettings_chkOSL_IP_Caption') then
      IniFile.WriteString('en', 'frmSettings_chkOSL_IP_Caption', 'I127 origin side local IP');
    if not IniFile.ValueExists('ru', 'frmSettings_chkOSL_IP_Caption') then
      IniFile.WriteString('ru', 'frmSettings_chkOSL_IP_Caption', 'I127 ��������� ��������� IP');
    if not IniFile.ValueExists('en', 'frmSettings_chkTSR_IP_Caption') then
      IniFile.WriteString('en', 'frmSettings_chkTSR_IP_Caption', 'I127 terminating side remote IP');
    if not IniFile.ValueExists('ru', 'frmSettings_chkTSR_IP_Caption') then
      IniFile.WriteString('ru', 'frmSettings_chkTSR_IP_Caption', 'I127 �������� ��������� IP');
    if not IniFile.ValueExists('en', 'frmSettings_chkTSL_IP_Caption') then
      IniFile.WriteString('en', 'frmSettings_chkTSL_IP_Caption', 'I127 terminating side local IP');
    if not IniFile.ValueExists('ru', 'frmSettings_chkTSL_IP_Caption') then
      IniFile.WriteString('ru', 'frmSettings_chkTSL_IP_Caption', 'I127 �������� ��������� IP');


    if not IniFile.ValueExists('en', 'frmSettings_chkAC_Hint') then
      IniFile.WriteString('en', 'frmSettings_chkAC_Hint', '|Include owner''s area code as a separate field');
    if not IniFile.ValueExists('ru', 'frmSettings_chkAC_Hint') then
      IniFile.WriteString('ru', 'frmSettings_chkAC_Hint', '|��� ���� �������� (��� ��������� ����)');
    if not IniFile.ValueExists('en', 'frmSettings_btnSave_Hint') then
      IniFile.WriteString('en', 'frmSettings_btnSave_Hint', '|Save settings and close window');
    if not IniFile.ValueExists('ru', 'frmSettings_btnSave_Hint') then
      IniFile.WriteString('ru', 'frmSettings_btnSave_Hint', '|��������� ��������� � ������� ����');
    if not IniFile.ValueExists('en', 'frmSettings_btnCancel_Hint') then
      IniFile.WriteString('en', 'frmSettings_btnCancel_Hint', '|Cancel without saving');
    if not IniFile.ValueExists('ru', 'frmSettings_btnCancel_Hint') then
      IniFile.WriteString('ru', 'frmSettings_btnCancel_Hint', '������� ���� ��� ���������� ���������');
    if not IniFile.ValueExists('en', 'frmSettings_btnDefault_Hint') then
      IniFile.WriteString('en', 'frmSettings_btnDefault_Hint', '|Set minimum required fields');
    if not IniFile.ValueExists('ru', 'frmSettings_btnDefault_Hint') then
      IniFile.WriteString('ru', 'frmSettings_btnDefault_Hint', '|���������� ���������� ����������� ����');
    if not IniFile.ValueExists('en', 'frmSettings_btnClearAll_Hint') then
      IniFile.WriteString('en', 'frmSettings_btnClearAll_Hint', '|Clear all fields');
    if not IniFile.ValueExists('ru', 'frmSettings_btnClearAll_Hint') then
      IniFile.WriteString('ru', 'frmSettings_btnClearAll_Hint', '|�������� ��� ����');

  finally
    IniFile.Free;
  end;
end;

procedure TfrmMain.SetLang(ALang: string);
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'params.ini');
  try
    IniFile.WriteString('interface', 'lang', ALang);
  finally
    IniFile.Free;
  end;
  lang := ALang;
end;

procedure TfrmMain.InitInterface;
var
  IniFile: TIniFile;
  i: Integer;
begin
  actEng.Checked := lang = 'en';
  actRus.Checked := lang = 'ru';
  IniFile := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'params.ini');
  try
    for i := 0 to ComponentCount - 1 do
    begin
      if Components[i].ClassType = TAction then
      begin
        (Components[i] as TAction).Caption := IniFile.ReadString(
          lang,
          Name + '_' + Components[i].Name + '_Caption',
          (Components[i] as TAction).Caption
        );
        (Components[i] as TAction).Hint := IniFile.ReadString(
          lang,
          Name + '_' + Components[i].Name + '_Hint',
          (Components[i] as TAction).Hint
        );
      end;

      if Components[i].ClassType = TMenuItem then
        if (Components[i] as TMenuItem).Action = nil then
          (Components[i] as TMenuItem).Caption := IniFile.ReadString(
            lang,
            Name + '_' + Components[i].Name + '_Caption',
            (Components[i] as TMenuItem).Caption
          );
    end;
  finally
    IniFile.Free;
  end;

  if lang = 'en' then
  begin
    dlgOpen.Filter := 'SI3000 files|*.ama|All files|*.*';
    dlgOpen.Title := 'Open';
    dlgSave.Filter := 'Text files|*.txt|All files|*.*';
    dlgSave.Title := 'Save log to';
  end
  else
  begin
    dlgOpen.Filter := 'SI3000 �����|*.ama|��� �����|*.*';
    dlgOpen.Title := '�������';
    dlgSave.Filter := '��������� �����|*.txt|��� �����|*.*';
    dlgSave.Title := '��������� ��� � ����';
  end;
end;

function GetLang: string;
var
  IniFile: TIniFile;
begin
  Result := 'en';
  IniFile := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'params.ini');
  try
    if FileExists(ExtractFilePath(ParamStr(0)) + 'params.ini') then
    begin
      Result := IniFile.ReadString('interface', 'lang', 'ru');
    end
    else
    begin
      IniFile.WriteString('interface', 'lang', 'ru');
    end;
  finally
    IniFile.Free;
  end;
end;

procedure TfrmMain.EnsureLogSaveEnabled;
begin
  actSaveLog.Enabled := mmoLog.Lines.Count > 0;
end;

initialization
  lang := GetLang;

end.
