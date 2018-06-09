unit uSettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TfrmSettings = class(TForm)
    pnlClient: TPanel;
    pnlBottom: TPanel;
    pnlTop: TPanel;
    rgLogLevel: TRadioGroup;
    pnlMiddle: TPanel;
    chkExportCSV: TCheckBox;
    lbledtExportPath: TLabeledEdit;
    pnlSelectDir: TPanel;
    grpExportFields: TGroupBox;
    btnSave: TButton;
    btnCancel: TButton;
    chkNumber: TCheckBox;
    chkDestNumber: TCheckBox;
    chkCallStarts: TCheckBox;
    chkCallDuration: TCheckBox;
    chkCallEnds: TCheckBox;
    chkRecordIndex: TCheckBox;
    chkRecordID: TCheckBox;
    chkRecordFlags: TCheckBox;
    lblPathHint: TLabel;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure chkExportCSVClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure pnlSelectDirClick(Sender: TObject);
  private
    procedure InitInterface;
    procedure LoadSettings;
  public
    procedure SaveSettings;
  end;

var
  frmSettings: TfrmSettings;

implementation

{$R *.dfm}

uses IniFiles, uMain, FileCtrl, Parser;

procedure TfrmSettings.FormCreate(Sender: TObject);
begin
  with pnlTop do
  begin
    Caption := '';
    BevelOuter := bvNone;
    Height := 16;
    Align := alTop;
  end;

  rgLogLevel.Align := alTop;

  with pnlMiddle do
  begin
    Caption := '';
    BevelOuter := bvNone;
    Height := 106;
    Align := alTop;
    Width := pnlClient.Width - 4;
  end;

  with chkExportCSV do
  begin
    Top := 16;
    Left := 8;
  end;

  with lbledtExportPath do
  begin
    Top := 56;
    Left := 6;
    Width := pnlMiddle.Width - 8;
    Visible := chkExportCSV.Checked;
  end;

  with lblPathHint do
  begin
    Top := 80;
    Left := 8;
    Font.Color := clTeal;
    Visible := chkExportCSV.Checked;
  end;

  with pnlSelectDir do
  begin
    Left := lbledtExportPath.Width - 14;
    Top := lbledtExportPath.Top + 2;
    Height := 18;
    Width := 18;
  end;

  with grpExportFields do
  begin
    Align := alClient;
    Visible := chkExportCSV.Checked;
  end;

  InitInterface;
  LoadSettings;
end;

procedure TfrmSettings.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
    ModalResult := mrCancel;
end;

procedure TfrmSettings.chkExportCSVClick(Sender: TObject);
begin
  lbledtExportPath.Visible := chkExportCSV.Checked;
  pnlSelectDir.Visible := chkExportCSV.Checked;
  grpExportFields.Visible := chkExportCSV.Checked;
  lblPathHint.Visible := chkExportCSV.Checked;
end;

procedure TfrmSettings.FormResize(Sender: TObject);
begin
  btnCancel.Left := pnlBottom.Width - btnCancel.Width - 8;
end;

procedure TfrmSettings.InitInterface;
var
  IniFile: TIniFile;
  i: Integer;
begin
  if lang = 'en' then
  begin
    Caption := 'Settings';
    with rgLogLevel do
    begin
      Items.Clear;
      Items.Add('Minimum');
      Items.Add('Short');
      Items.Add('Normal');
      Items.Add('Verbose');
    end;
  end;
  if lang = 'ru' then
  begin
    Caption := 'Настройки';
    with rgLogLevel do
    begin
      Items.Clear;
      Items.Add('Минимальный');
      Items.Add('Короткий');
      Items.Add('Нормальный');
      Items.Add('Подробный');
    end;
  end;

  IniFile := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'params.ini');
  try
    for i := 0 to ComponentCount - 1 do
    begin
      if Components[i].ClassType = TButton then
      begin
        (Components[i] as TButton).Caption := IniFile.ReadString(
          lang,
          Name + '_' + Components[i].Name + '_Caption',
          (Components[i] as TButton).Caption
        );
        (Components[i] as TButton).Hint := IniFile.ReadString(
          lang,
          Name + '_' + Components[i].Name + '_Hint', (Components[i] as TButton).Hint
        );
      end;

      if Components[i].ClassType = TLabel then
        (Components[i] as TLabel).Caption := IniFile.ReadString(
          lang,
          Name + '_' + Components[i].Name + '_Caption',
          (Components[i] as TLabel).Caption
        );

      if Components[i].ClassType = TRadioGroup then
        (Components[i] as TRadioGroup).Caption := IniFile.ReadString(
          lang,
          Name + '_' + Components[i].Name + '_Caption',
          (Components[i] as TRadioGroup).Caption
        );

      if Components[i].ClassType = TGroupBox then
        (Components[i] as TGroupBox).Caption := IniFile.ReadString(
          lang,
          Name + '_' + Components[i].Name + '_Caption',
          (Components[i] as TGroupBox).Caption
        );

      if Components[i].ClassType = TLabeledEdit then
        (Components[i] as TLabeledEdit).EditLabel.Caption := IniFile.ReadString(
          lang,
          Name + '_' + Components[i].Name + '_Caption',
          (Components[i] as TLabeledEdit).EditLabel.Caption
        );

      if Components[i].ClassType = TCheckBox then
        (Components[i] as TCheckBox).Caption := IniFile.ReadString(
          lang,
          Name + '_' + Components[i].Name + '_Caption',
          (Components[i] as TCheckBox).Caption
        );
    end;
  finally
    IniFile.Free;
  end;
end;

procedure TfrmSettings.LoadSettings;
var
  parser: TParser;
begin
  { TODO : Needs to extract Parser settings as a separate class }
  parser := TParser.Create('', nil, nil);
  try
    rgLogLevel.ItemIndex := parser.LogLevel;
    chkExportCSV.Checked := parser.IsExportEnable;
    lbledtExportPath.Text := parser.ExportPath;
    chkNumber.Checked := parser.IsAccountNumberExports;
    chkDestNumber.Checked := parser.IsDestNumberExports;
    chkCallStarts.Checked := parser.IsStartTimeExports;
    chkCallDuration.Checked := parser.IsDurationExports;
    chkCallEnds.Checked := parser.IsEndTimeExports;
    chkRecordIndex.Checked := parser.IsIndexExports;
    chkRecordID.Checked := parser.IsIDExports;
    chkRecordFlags.Checked := parser.IsFlagsExports;
  finally
    parser.Free;
  end;
end;


procedure TfrmSettings.SaveSettings;
var
  parser: TParser;
begin
  { TODO : Needs to extract Parser settings as a separate class }
  parser := TParser.Create('', nil, nil);
  try
    parser.LogLevel := rgLogLevel.ItemIndex;
    parser.IsExportEnable := chkExportCSV.Checked;
    parser.ExportPath := lbledtExportPath.Text;
    parser.IsAccountNumberExports := chkNumber.Checked;
    parser.IsDestNumberExports := chkDestNumber.Checked;
    parser.IsStartTimeExports := chkCallStarts.Checked;
    parser.IsDurationExports := chkCallDuration.Checked;
    parser.IsEndTimeExports := chkCallEnds.Checked;
    parser.IsIndexExports := chkRecordIndex.Checked;
    parser.IsIDExports := chkRecordID.Checked;
    parser.IsFlagsExports := chkRecordFlags.Checked;
    parser.SaveParams;
  finally
    parser.Free;
  end;
end;


procedure TfrmSettings.pnlSelectDirClick(Sender: TObject);
var
  dir: string;
  selectPathCaption: string;
begin
  if Length(lbledtExportPath.Text) > 1 then
    dir := lbledtExportPath.Text
  else
    dir := ExtractFilePath(ParamStr(0));
  if lang = 'en' then
    selectPathCaption := 'Select folder for .csv files';
  if lang = 'ru' then
    selectPathCaption := 'Выберите папку для сохранения .csv файлов';
  SelectDirectory(selectPathCaption, '', dir);
  lbledtExportPath.Text := dir;
end;


end.
