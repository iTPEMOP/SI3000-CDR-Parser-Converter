unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ActnList, ComCtrls, AppEvnts, ImgList, ToolWin;

type
  TfrmMain = class(TForm)
    actlstMain: TActionList;
    actOpen: TAction;
    actSaveLog: TAction;
    actExit: TAction;
    actSettings: TAction;
    mmTop: TMainMenu;
    mniFile: TMenuItem;
    mniService: TMenuItem;
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
    procedure aplctnvntsMainHint(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actOpenExecute(Sender: TObject);
    procedure actSaveLogExecute(Sender: TObject);
    procedure actSettingsExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

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
begin
  // Open file
end;

procedure TfrmMain.actSaveLogExecute(Sender: TObject);
begin
  // save log
end;

procedure TfrmMain.actSettingsExecute(Sender: TObject);
begin
  // settings dialog
end;

end.
