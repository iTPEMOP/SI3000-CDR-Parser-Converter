unit Parser;

interface

uses SysUtils, StdCtrls, Classes, Gauges;

const
    AvgRecLength: Byte = 134;

type
  TParser = class
    private
      FFileName: string;
      FS: TFileStream;  // stream for parsing file
      FIsFSEnd: Boolean;

      FExportPath: String;
      FLogControl: TMemo;
      FProgressControl:TGauge;
      FIsExportEnable: Boolean;
      FRecCount: Integer;
      FProgress: Integer;
      function SetExportFileName: string;
      function GetExportPath: string;
      procedure SetExportPath(const APath: string);
      function ParseRecord(Progress: Integer; var ExportLine: string): Boolean;
      function ParseDateTimeChangesRecord(const RecData: array of Byte): Boolean;
      function ParseLossRecord(const RecData: array of Byte): Boolean;
      function ParseRebootRecord(const RecData: array of Byte): Boolean;
      function ParseCallRecord(const RecData: array of Byte): Boolean;
    public
      constructor Create(AFileName: string; ALogControl: TMemo; AGauge: TGauge);
      function PreFileCheck: Boolean;
      procedure Log(AMessage: string);
      procedure BrodcastProgress(AProgress: Integer);
      procedure ClearLog;
      function Parse: Boolean;

      property IsExportEnable: Boolean read FIsExportEnable write FIsExportEnable;
      property ExportPath: String read GetExportPath write SetExportPath;
      property RecCount: Integer read FRecCount;
      property Progress: Integer read FProgress;
  end;

implementation

{ TParser }

uses I18NMessages, uMain;

procedure TParser.ClearLog;
begin
  FLogControl.Lines.Clear;
end;

constructor TParser.Create(AFileName: string; ALogControl: TMemo; AGauge: TGauge);
begin
  FFileName := AFileName;
  FLogControl := ALogControl;
  FProgressControl := AGauge;
  FRecCount:= 0;
  FIsExportEnable := False;
end;

function TParser.GetExportPath: string;
begin
  if (Length(FExportPath) > 0) and (Copy(FExportPath, Length(FExportPath), 1) <> '\') then
    FExportPath := FExportPath + '\';
  Result := FExportPath;
end;

procedure TParser.SetExportPath(const APath: string);
begin
  if Length(APath) > 0 then
    FExportPath := APath;
end;

function TParser.SetExportFileName: string;
begin
  Result := FExportPath + FormatDateTime('yyyymmdd-hhmmss', Now) + '.csv';
end;


procedure TParser.Log(AMessage: string);
begin
  FLogControl.Lines.Add(AMessage);
end;

procedure TParser.BrodcastProgress(AProgress: Integer);
begin
  FProgressControl.Progress := AProgress;
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
    CloseFile(AFile);
  end;
end;

function TParser.Parse: Boolean;
var
  ExportFile: TextFile;
  ApprRecCount: Integer;

  OneLine: string; // the line for export file
begin
  if IsExportEnable then
  begin
    AssignFile(ExportFile, SetExportFileName);
    Rewrite(ExportFile);
    OneLine := '';
    OneLine := OneLine + 'index' + ';';
    OneLine := OneLine + 'id' + ';';
    OneLine := OneLine + 'flags' + ';';
    OneLine := OneLine + 'user_number' + ';';
    OneLine := OneLine + 'dest_number' + ';';
    OneLine := OneLine + 'starts' + ';';
    OneLine := OneLine + 'ends' + ';';
    OneLine := OneLine + 'duration' + ';';
    if Length(OneLine) > 1 then
      Delete(OneLine, Length(OneLine), 1);
    Writeln(ExportFile, OneLine);
  end;

  FS := TFileStream.Create(FFileName, fmOpenRead);
  try
    // calculate approximate records count. See AvgRecLength const
    if FS.Size >= AvgRecLength then
      ApprRecCount := FS.Size div AvgRecLength
    else
      ApprRecCount := 1;

    while not FIsFSEnd do
    begin
      Inc(FRecCount);
      FProgress := Round(FRecCount / ApprRecCount * 100);
      if FProgress > 100 then
        FProgress := 100;
      BrodcastProgress(FProgress);
      OneLine := '';

      if ParseRecord(FProgress, OneLine) then
      begin
        if IsExportEnable then
          Writeln(ExportFile, OneLine);
      end
      else
      begin
        Result := False;
        Exit;
      end;
    end;
  finally
    FS.Free;
  end;

  Result := FIsFSEnd;
end;

function TParser.ParseDateTimeChangesRecord(const RecData: array of Byte): Boolean;
var
  datetimeStr: string;
begin
  Log(Format(GetAMessage('DATETIME_CHANGE_IS_FOUND', lang), [$d2]));
  datetimeStr := Format('20%s-%s-%s %s:%s:%s.%s00', [
    Format('%.*d', [2, RecData[0]]),
    Format('%.*d', [2, RecData[1]]),
    Format('%.*d', [2, RecData[2]]),
    Format('%.*d', [2, RecData[3]]),
    Format('%.*d', [2, RecData[4]]),
    Format('%.*d', [2, RecData[5]]),
    Format('%.*d', [1, RecData[6]])
  ]);
  Log(Format(GetAMessage('OLD_TIME', lang), [datetimeStr]));

  datetimeStr := Format('20%s-%s-%s %s:%s:%s.%s00', [
    Format('%.*d', [2, RecData[7]]),
    Format('%.*d', [2, RecData[8]]),
    Format('%.*d', [2, RecData[9]]),
    Format('%.*d', [2, RecData[10]]),
    Format('%.*d', [2, RecData[11]]),
    Format('%.*d', [2, RecData[12]]),
    Format('%.*d', [1, RecData[13]])
  ]);
  Log(Format(GetAMessage('NEW_TIME', lang), [datetimeStr]));

  case RecData[14] of
    1: Log(GetAMessage('REASON_CLOCK_CORRECTION', lang));
    2: Log(GetAMessage('REASON_SUMMER_WINTER_TIME', lang));
    else
      Log(GetAMessage('REASON_UNKNOWN', lang));
  end;

  Result := True;
end;

function TParser.ParseLossRecord(const RecData: array of Byte): Boolean;
var
  datetimeStr: string;
  lossRecordCount: LongInt;
begin
  Log(Format(GetAMessage('LOSS_RECORD_IS_FOUND', lang), [$d3]));
  datetimeStr := Format('20%s-%s-%s %s:%s:%s.%s00', [
    Format('%.*d', [2, RecData[0]]),
    Format('%.*d', [2, RecData[1]]),
    Format('%.*d', [2, RecData[2]]),
    Format('%.*d', [2, RecData[3]]),
    Format('%.*d', [2, RecData[4]]),
    Format('%.*d', [2, RecData[5]]),
    Format('%.*d', [1, RecData[6]])
  ]);
  Log(Format(GetAMessage('LOSS_START_TIME', lang), [datetimeStr]));

  datetimeStr := Format('20%s-%s-%s %s:%s:%s.%s00', [
    Format('%.*d', [2, RecData[7]]),
    Format('%.*d', [2, RecData[8]]),
    Format('%.*d', [2, RecData[9]]),
    Format('%.*d', [2, RecData[10]]),
    Format('%.*d', [2, RecData[11]]),
    Format('%.*d', [2, RecData[12]]),
    Format('%.*d', [1, RecData[13]])
  ]);
  Log(Format(GetAMessage('LOSS_END_TIME', lang), [datetimeStr]));

  lossRecordCount :=
    RecData[14] shl 3 +
    RecData[15] shl 2 +
    RecData[16] shl 1 +
    RecData[17];
  Log(Format(GetAMessage('TOTAL_RECORDS_ARE_LOST', lang), [lossRecordCount]));

  Result := True;
end;

function TParser.ParseRebootRecord(const RecData: array of Byte): Boolean;
var
  datetimeStr: string;
begin
  Log(Format(GetAMessage('REBOOT_RECORD_IS_FOUND', lang), [$d3]));
  datetimeStr := Format('20%s-%s-%s %s:%s:%s.%s00', [
    Format('%.*d', [2, RecData[0]]),
    Format('%.*d', [2, RecData[1]]),
    Format('%.*d', [2, RecData[2]]),
    Format('%.*d', [2, RecData[3]]),
    Format('%.*d', [2, RecData[4]]),
    Format('%.*d', [2, RecData[5]]),
    Format('%.*d', [1, RecData[6]])
  ]);
  Log(Format(GetAMessage('REBOOT_TIME', lang), [datetimeStr]));

  Result := True;
end;


function TParser.ParseRecord(Progress: Integer; var ExportLine: string): Boolean;
var
  TypeID: Byte;
  Len: Word;
  i: Integer;
  RecData: array of Byte;
begin
  Result := False;
  FS.Read(TypeID, 1);
  case TypeID of
    // Date and Time changes record $d2
    $d2:
    begin
      SetLength(RecData, 15);
      for I := 0 to 14 do
        FS.Read(RecData[i], 1);
      Result := ParseDateTimeChangesRecord(RecData);
    end;

    // Record of the lost of a certain amount of records
    $d3:
    begin
      SetLength(RecData, 18);
      for I := 0 to 17 do
        FS.Read(RecData[i], 1);
      Result := ParseLossRecord(RecData);
    end;

    // Reboot/restrart record
    $d4:
    begin
      SetLength(RecData, 11);
      for I := 0 to 10 do
        FS.Read(RecData[i], 1);
      Result := ParseRebootRecord(RecData);
    end;

    // The call record
    $c8:
    begin
      FS.Read(Len, 2);
      Len := Swap(Len);
      SetLength(RecData, Len - 3);
      for i := 0 to Length(RecData) - 1 do
        FS.Read(RecData[i], 1);
      Result := ParseCallRecord(RecData);
    end;
    else
      Log(Format(GetAMessage('UNKNOWN_RECORD_TYPE', lang), [TypeID]));
  end;

  FIsFSEnd := FS.Position >= FS.Size;
end;

function TParser.ParseCallRecord(const RecData: array of Byte): Boolean;
begin
  Log(Format('Запись о вызове %d', [RecCount]));
  Result := True;
end;


end.
