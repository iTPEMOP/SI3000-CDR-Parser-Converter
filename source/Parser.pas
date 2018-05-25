unit Parser;

interface

uses SysUtils, StdCtrls;

type
  TParser = class
    private
      FFileName: string;
      FLogControl: TMemo;
    public
      constructor Create(AFileName: string; ALogControl: TMemo);
      function PreFileCheck: Boolean;
      procedure Log(AMessage: string);
      procedure ClearLog;
  end;

implementation

{ TParser }


procedure TParser.ClearLog;
begin
  FLogControl.Lines.Clear;
end;

constructor TParser.Create(AFileName: string; ALogControl: TMemo);
begin
  FFileName := AFileName;
  FLogControl := ALogControl;
end;

procedure TParser.Log(AMessage: string);
begin
  FLogControl.Lines.Add(AMessage);
end;

function TParser.PreFileCheck: Boolean;
var
  AFile: file of Byte;
begin
  Result := False;
  if FileExists(FFileName) then
  begin
    AssignFile(AFile, FFileName);
    Reset(AFile);
    if FileSize(AFile) > 2 then
      Result := True;
  end;  
end;

end.
