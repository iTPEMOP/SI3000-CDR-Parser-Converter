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
    procedure aplctnvntsMainHint(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actOpenExecute(Sender: TObject);
    procedure actSaveLogExecute(Sender: TObject);
    procedure actSettingsExecute(Sender: TObject);
    procedure actEngExecute(Sender: TObject);
    procedure actRusExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure CheckI18N;
    procedure InitInterface;
    procedure SetLang(ALang: string);
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;
  lang: string;

implementation

{$R *.dfm}

uses IniFiles, Parser, I18NMessages;

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
          //Parser.Log(GetAMessage('ERROR_DURING_PARSING', lang));
          Application.MessageBox(
          PChar(Format(GetAMessage('ERROR_DURING_PARSING', lang), [dlgOpen.FileName])),
          PChar(GetAMessage('WARNING', lang)),
          MB_OK + MB_ICONWARNING
        );
        end;
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
  // save log
end;

procedure TfrmMain.actSettingsExecute(Sender: TObject);
begin
  // settings dialog
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
      IniFile.WriteString('ru', 'frmMain_mniFile_Caption', 'Файл');
    if not IniFile.ValueExists('en', 'frmMain_mniPreferences_Caption') then
      IniFile.WriteString('en', 'frmMain_mniPreferences_Caption', 'Preferences');
    if not IniFile.ValueExists('ru', 'frmMain_mniPreferences_Caption') then
      IniFile.WriteString('ru', 'frmMain_mniPreferences_Caption', 'Параметры');
    if not IniFile.ValueExists('en', 'frmMain_mniLanguage_Caption') then
      IniFile.WriteString('en', 'frmMain_mniLanguage_Caption', 'Language');
    if not IniFile.ValueExists('ru', 'frmMain_mniLanguage_Caption') then
      IniFile.WriteString('ru', 'frmMain_mniLanguage_Caption', 'Язык');

    if not IniFile.ValueExists('en', 'frmMain_actOpen_Caption') then
      IniFile.WriteString('en', 'frmMain_actOpen_Caption', 'Open');
    if not IniFile.ValueExists('ru', 'frmMain_actOpen_Caption') then
      IniFile.WriteString('ru', 'frmMain_actOpen_Caption', 'Открыть');
    if not IniFile.ValueExists('en', 'frmMain_actSaveLog_Caption') then
      IniFile.WriteString('en', 'frmMain_actSaveLog_Caption', 'Save log');
    if not IniFile.ValueExists('ru', 'frmMain_actSaveLog_Caption') then
      IniFile.WriteString('ru', 'frmMain_actSaveLog_Caption', 'Сохранить лог');
    if not IniFile.ValueExists('en', 'frmMain_actExit_Caption') then
      IniFile.WriteString('en', 'frmMain_actExit_Caption', 'Exit');
    if not IniFile.ValueExists('ru', 'frmMain_actExit_Caption') then
      IniFile.WriteString('ru', 'frmMain_actExit_Caption', 'Выйти');
    if not IniFile.ValueExists('en', 'frmMain_actSettings_Caption') then
      IniFile.WriteString('en', 'frmMain_actSettings_Caption', 'Settings');
    if not IniFile.ValueExists('ru', 'frmMain_actSettings_Caption') then
      IniFile.WriteString('ru', 'frmMain_actSettings_Caption', 'Настройки');
    if not IniFile.ValueExists('en', 'frmMain_actEng_Caption') then
      IniFile.WriteString('en', 'frmMain_actEng_Caption', 'English');
    if not IniFile.ValueExists('ru', 'frmMain_actEng_Caption') then
      IniFile.WriteString('ru', 'frmMain_actEng_Caption', 'Английский');
    if not IniFile.ValueExists('en', 'frmMain_actRus_Caption') then
      IniFile.WriteString('en', 'frmMain_actRus_Caption', 'Russian');
    if not IniFile.ValueExists('ru', 'frmMain_actRus_Caption') then
      IniFile.WriteString('ru', 'frmMain_actRus_Caption', 'Русский');

    if not IniFile.ValueExists('en', 'frmMain_actOpen_Hint') then
      IniFile.WriteString('en', 'frmMain_actOpen_Hint', 'Open|Open SI3000 file');
    if not IniFile.ValueExists('ru', 'frmMain_actOpen_Hint') then
      IniFile.WriteString('ru', 'frmMain_actOpen_Hint', 'Открыть|Открыть файл АТС SI3000');
    if not IniFile.ValueExists('en', 'frmMain_actSaveLog_Hint') then
      IniFile.WriteString('en', 'frmMain_actSaveLog_Hint', 'Save log|Save current log to text file');
    if not IniFile.ValueExists('ru', 'frmMain_actSaveLog_Hint') then
      IniFile.WriteString('ru', 'frmMain_actSaveLog_Hint', 'Сохранить лог|Сохранить текущий лог в текстовом файле');
    if not IniFile.ValueExists('en', 'frmMain_actExit_Hint') then
      IniFile.WriteString('en', 'frmMain_actExit_Hint', 'Exit|Exit program');
    if not IniFile.ValueExists('ru', 'frmMain_actExit_Hint') then
      IniFile.WriteString('ru', 'frmMain_actExit_Hint', 'Выйти|Выйти из программы');
    if not IniFile.ValueExists('en', 'frmMain_actSettings_Hint') then
      IniFile.WriteString('en', 'frmMain_actSettings_Hint', 'Settings|Program & parser settings');
    if not IniFile.ValueExists('ru', 'frmMain_actSettings_Hint') then
      IniFile.WriteString('ru', 'frmMain_actSettings_Hint', 'Настройки|Настройки интерфейса и парсера');
    if not IniFile.ValueExists('en', 'frmMain_actEng_Hint') then
      IniFile.WriteString('en', 'frmMain_actEng_Hint', 'English|Switch to English');
    if not IniFile.ValueExists('ru', 'frmMain_actEng_Hint') then
      IniFile.WriteString('ru', 'frmMain_actEng_Hint', 'Английский|Переключить на английский');
    if not IniFile.ValueExists('en', 'frmMain_actRus_Hint') then
      IniFile.WriteString('en', 'frmMain_actRus_Hint', 'Russian|Switch to Russian');
    if not IniFile.ValueExists('ru', 'frmMain_actRus_Hint') then
      IniFile.WriteString('ru', 'frmMain_actRus_Hint', 'Русский|Переключить на русский');
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
          name + '_' + Components[i].name + '_Caption', (Components[i] as TAction).Caption
        );
        (Components[i] as TAction).Hint := IniFile.ReadString(
          lang,
          name + '_' + Components[i].name + '_Hint', (Components[i] as TAction).Hint
        );
      end;

      if Components[i].ClassType = TMenuItem then
        if (Components[i] as TMenuItem).Action = nil then
          (Components[i] as TMenuItem).Caption := IniFile.ReadString(
            lang,
            name + '_' + Components[i].name + '_Caption', (Components[i] as TMenuItem).Caption
          );
    end;
  finally
    IniFile.Free;
  end;

  if lang = 'en' then
    dlgOpen.Filter := 'SI3000 files|*.ama|All files|*.*'
  else
    dlgOpen.Filter := 'SI3000 файлы|*.ama|Все файлы|*.*';
end;

function GetLang: string;
var
  IniFile: TIniFile;
begin
  Result := 'ru';
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

initialization
  Lang := GetLang;

end.
