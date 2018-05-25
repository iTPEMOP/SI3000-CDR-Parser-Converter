program SI3000Parser;

uses
  Forms,
  uMain in 'uMain.pas' {frmMain},
  Parser in 'Parser.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
