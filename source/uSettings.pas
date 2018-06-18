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
    lblPathHint: TLabel;
    grpExportFields: TGroupBox;
    btnSave: TButton;
    btnCancel: TButton;
    chkDN: TCheckBox;
    chkCN: TCheckBox;
    chkSD: TCheckBox;
    chkED: TCheckBox;
    chkSI: TCheckBox;
    chkCI: TCheckBox;
    chkFL: TCheckBox;
    chkCS: TCheckBox;
    chkSQ: TCheckBox;
    chkAC: TCheckBox;
    chkCU: TCheckBox;
    chkBS: TCheckBox;
    chkTS: TCheckBox;
    chkOC: TCheckBox;
    chkTD: TCheckBox;
    btnDefault: TButton;
    btnClearAll: TButton;
    chkDU: TCheckBox;
    chkOCN: TCheckBox;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure chkExportCSVClick(Sender: TObject);
    procedure pnlSelectDirClick(Sender: TObject);
    procedure chkDNClick(Sender: TObject);
    procedure chkBSClick(Sender: TObject);
    procedure btnClearAllClick(Sender: TObject);
    procedure btnDefaultClick(Sender: TObject);
  private
    procedure InitInterface;
    procedure LoadSettings;
    procedure ClearAllExportFields;
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

  chkAC.Enabled := chkDN.Checked;
  chkTS.Enabled := chkBS.Checked;
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
      begin
        (Components[i] as TCheckBox).Caption := IniFile.ReadString(
          lang,
          Name + '_' + Components[i].Name + '_Caption',
          (Components[i] as TCheckBox).Caption
        );
        (Components[i] as TCheckBox).Hint := IniFile.ReadString(
          lang,
          Name + '_' + Components[i].Name + '_Hint', (Components[i] as TCheckBox).Hint
        );
      end;
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
    chkSI.Checked := parser.IsSIExports;
    chkCI.Checked := parser.IsCIExports;
    chkFL.Checked := parser.IsFLExports;
    chkSQ.Checked := parser.IsSQExports;
    chkCS.Checked := parser.IsCSExports;
    chkAC.Checked := parser.IsACExports;
    chkDN.Checked := parser.IsDNExports;
    chkCN.Checked := parser.IsCNExports;
    chkSD.Checked := parser.IsSDExports;
    chkED.Checked := parser.IsEDExports;
    chkCU.Checked := parser.IsCUExports;
    chkBS.Checked := parser.IsBSExports;
    chkTS.Checked := parser.IsTSExports;
    chkOC.Checked := parser.IsOCExports;
    chkTD.Checked := parser.IsTDExports;
    chkDU.Checked := parser.IsDUExports;
    chkOCN.Checked := parser.IsOCNExports;
  finally
    parser.Free;
  end;
end;


procedure TfrmSettings.SaveSettings;
var
  parser: TParser;

  tt: string;
begin
  { TODO : Needs to extract Parser settings as a separate class }
  parser := TParser.Create('', nil, nil);
  try
    parser.LogLevel := rgLogLevel.ItemIndex;
    parser.IsExportEnable := chkExportCSV.Checked;

    tt := lbledtExportPath.Text;
    parser.ExportPath := tt;
    parser.ExportPath := lbledtExportPath.Text;
    parser.IsSIExports := chkSI.Checked;
    parser.IsCIExports := chkCI.Checked;
    parser.IsFLExports := chkFL.Checked;
    parser.IsSQExports := chkSQ.Checked;
    parser.IsCSExports := chkCS.Checked;
    parser.IsACExports := chkAC.Checked;
    parser.IsDNExports := chkDN.Checked;
    parser.IsCNExports := chkCN.Checked;
    parser.IsSDExports := chkSD.Checked;
    parser.IsEDExports := chkED.Checked;
    parser.IsCUExports := chkCU.Checked;
    parser.IsBSExports := chkBS.Checked;
    parser.IsTSExports := chkTS.Checked;
    parser.IsOCExports := chkOC.Checked;
    parser.IsTDExports := chkTD.Checked;
    parser.IsDUExports := chkDU.Checked;
    parser.IsOCNExports := chkOCN.Checked;
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


procedure TfrmSettings.chkDNClick(Sender: TObject);
begin
  chkAC.Enabled := chkDN.Checked;
  if not chkDN.Checked then
    chkAC.Checked := False;
end;

procedure TfrmSettings.chkBSClick(Sender: TObject);
begin
  chkTS.Enabled := chkBS.Checked;
  if not chkBS.Checked then
    chkTS.Checked := False;
end;

procedure TfrmSettings.ClearAllExportFields;
var
  i: Integer;
begin
  for i := 0 to ComponentCount - 1 do
    if (Components[i].ClassType = TCheckBox) then
      if (Components[i] as TCheckBox).Name <> 'chkExportCSV' then
        (Components[i] as TCheckBox).Checked := False;
end;

procedure TfrmSettings.btnClearAllClick(Sender: TObject);
begin
  ClearAllExportFields;
end;

procedure TfrmSettings.btnDefaultClick(Sender: TObject);
begin
  ClearAllExportFields;
  chkDN.Checked := True;
  chkCN.Checked := True;
  chkSD.Checked := True;
end;

end.
