program SI3000Parser;

uses
  Forms,
  uMain in 'uMain.pas' {frmMain},
  Parser in 'Parser.pas',
  I18NMessages in 'I18NMessages.pas',
  uSettings in 'uSettings.pas' {frmSettings};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'SI3000 Parser & Converter';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
