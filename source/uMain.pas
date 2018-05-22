unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ActnList, ComCtrls;

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

end.
