unit Parser;

interface

uses SysUtils, StdCtrls, Classes, Gauges;

const
  LOG_SECTION_NAME: string = 'Log';
  EXPORT_SECTION_NAME: string = 'Export';
  FIELDS_SECTION_NAME: string = 'Export fields';
  LOG_LEVEL_KEY_NAME: string = 'Log level';
  ENABLE_EXPORT_KEY_NAME: string = 'Enable export';
  EXPORT_PATH_KEY_NAME: string = 'Path';
  ACCOUNT_AREA: string = 'AC';
  ACCOUNT_NUMBER: string = 'DN';
  CALLED_NUMBER: string = 'CN';
  START_TIME: string = 'SD';
  DURATION: string = 'DU';
  END_TIME: string = 'ED';
  RECORD_INDEX: string = 'SI';
  RECORD_ID: string = 'CI';
  RECORD_FLAGS: string = 'FL';
  RECORD_SEQUENCE: string = 'SQ';
  CHARGE_STATUS: string = 'CS';
  CHARGING_UNITS: string = 'CU';
  BASIC_SERVICE: string = 'BS';
  TELESERVICE: string = 'TS';

  AvgRecLength: Byte = 134;

type
  { LongWord per byte type}
  Byte4 = array[0..3] of Byte;

  TParser = class
    private
      // Parser settings
      FIsExportEnable: Boolean;
      FExportPath: string;
      FIsACExports: Boolean;  // AC - owner's area code
      FIsDNExports: Boolean;  // DN - directory number (owner's number)
      FIsCNExports: Boolean;  // CN - called number
      FIsSDExports: Boolean;  // SD - call starts date & time
      FIsDUExports: Boolean;  // DU - call/service duration, sec.
      FIsEDExports: Boolean;  // SD - call ends date & time
      FIsSIExports: Boolean;  // SI - serial CDR index
      FIsCIExports: Boolean;  // CI - call ID
      FIsFLExports: Boolean;  // FL - flags
      FIsSQExports: Boolean;  // SQ - record sequence
      FIsCSExports: Boolean;  // CS - charge status
      FIsCUExports: Boolean;  // CU - number of charging units
      FIsBSExports: Boolean;  // BS - basic service
      FIsTSExports: Boolean;  // TS - teleservice
      FLogLevel: Byte; // 0 - none, 1 - min, 2 - normal, 3 - full

      FFileName: string;
      FS: TFileStream;  // stream for parsing file
      FIsFSEnd: Boolean;

      FLogControl: TMemo;
      FProgressControl:TGauge;
      FRecCount: Integer;
      FProgress: Integer;
      function SetExportFileName: string;
      function GetExportPath: string;
      procedure SetExportPath(const APath: string);
      function GetLogLevel: Byte;
      procedure SetLogLevel(const ALevel: Byte);
      function ParseRecord(Progress: Integer; var OneLine: string): Boolean;
      function ParseDateTimeChangesRecord(const RecData: array of Byte): Boolean;
      function ParseLossRecord(const RecData: array of Byte): Boolean;
      function ParseRebootRecord(const RecData: array of Byte): Boolean;
      function ParseCallRecord(const RecData: array of Byte; var OneLine: string): Boolean;
      procedure InitParams;
    public
      constructor Create(AFileName: string; ALogControl: TMemo; AGauge: TGauge);
      procedure SaveParams;
      function PreFileCheck: Boolean;
      procedure Log(AMessage: string);
      procedure BrodcastProgress(AProgress: Integer);
      procedure ClearLog;
      function Parse: Boolean;

      property LogLevel: Byte read GetLogLevel write SetLogLevel;
      property IsExportEnable: Boolean read FIsExportEnable write FIsExportEnable;
      property ExportPath: String read GetExportPath write SetExportPath;
      property IsACExports: Boolean read FIsACExports write FIsACExports;
      property IsDNExports: Boolean read FIsDNExports write FIsDNExports;
      property IsCNExports: Boolean read FIsCNExports write FIsCNExports;
      property IsSDExports: Boolean read FIsSDExports write FIsSDExports;
      property IsDUExports: Boolean read FIsDUExports write FIsDUExports;
      property IsEDExports: Boolean read FIsEDExports write FIsEDExports;
      property IsSIExports: Boolean read FIsSIExports write FIsSIExports;
      property IsCIExports: Boolean read FIsCIExports write FIsCIExports;
      property IsFLExports: Boolean read FIsFLExports write FIsFLExports;
      property IsSQExports: Boolean read FIsSQExports write FIsSQExports;
      property IsCSExports: Boolean read FIsCSExports write FIsCSExports;
      property IsCUExports: Boolean read FIsCUExports write FIsCUExports;
      property IsBSExports: Boolean read FIsBSExports write FIsBSExports;
      property IsTSExports: Boolean read FIsTSExports write FIsTSExports;

      property RecCount: Integer read FRecCount;
      property Progress: Integer read FProgress;
  end;

implementation

{ TParser }

uses I18NMessages, uMain, IniFiles;

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
  FIsExportEnable := True;
  InitParams;
end;

procedure TParser.InitParams;
var
  Ini: TIniFile;
begin
  FLogLevel := 1;
  Ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'params.ini');
  try
    FLogLevel := Ini.ReadInteger(LOG_SECTION_NAME, LOG_LEVEL_KEY_NAME, 2);
    FIsExportEnable := Ini.ReadBool(EXPORT_SECTION_NAME, ENABLE_EXPORT_KEY_NAME, True);
    FExportPath := Ini.ReadString(EXPORT_SECTION_NAME, EXPORT_PATH_KEY_NAME, '');
    FIsACExports := Ini.ReadBool(FIELDS_SECTION_NAME, ACCOUNT_AREA, False);
    FIsDNExports := Ini.ReadBool(FIELDS_SECTION_NAME, ACCOUNT_NUMBER, True);
    FIsCNExports := Ini.ReadBool(FIELDS_SECTION_NAME, CALLED_NUMBER, True);
    FIsSDExports := Ini.ReadBool(FIELDS_SECTION_NAME, START_TIME, True);
    FIsDUExports := Ini.ReadBool(FIELDS_SECTION_NAME, DURATION, True);
    FIsEDExports := Ini.ReadBool(FIELDS_SECTION_NAME, END_TIME, False);
    FIsSIExports := Ini.ReadBool(FIELDS_SECTION_NAME, RECORD_INDEX, False);
    FIsCIExports := Ini.ReadBool(FIELDS_SECTION_NAME, RECORD_ID, False);
    FIsFLExports := Ini.ReadBool(FIELDS_SECTION_NAME, RECORD_FLAGS, False);
    FIsSQExports := Ini.ReadBool(FIELDS_SECTION_NAME, RECORD_SEQUENCE, False);
    FIsCSExports := Ini.ReadBool(FIELDS_SECTION_NAME, CHARGE_STATUS, False);
    FIsCUExports := Ini.ReadBool(FIELDS_SECTION_NAME, CHARGING_UNITS, False);
    FIsBSExports := Ini.ReadBool(FIELDS_SECTION_NAME, BASIC_SERVICE, False);
    FIsTSExports := Ini.ReadBool(FIELDS_SECTION_NAME, TELESERVICE, False);
  finally
    Ini.Free;
  end;
end;

procedure TParser.SaveParams;
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'params.ini');
  try
    Ini.WriteInteger(LOG_SECTION_NAME, LOG_LEVEL_KEY_NAME, FLogLevel);
    Ini.WriteBool(EXPORT_SECTION_NAME, ENABLE_EXPORT_KEY_NAME, FIsExportEnable);
    Ini.WriteString(EXPORT_SECTION_NAME, EXPORT_PATH_KEY_NAME, FExportPath);
    Ini.WriteBool(FIELDS_SECTION_NAME, ACCOUNT_AREA, FIsACExports);
    Ini.WriteBool(FIELDS_SECTION_NAME, ACCOUNT_NUMBER, FIsDNExports);
    Ini.WriteBool(FIELDS_SECTION_NAME, CALLED_NUMBER, FIsCNExports);
    Ini.WriteBool(FIELDS_SECTION_NAME, START_TIME, FIsSDExports);
    Ini.WriteBool(FIELDS_SECTION_NAME, DURATION, FIsDUExports);
    Ini.WriteBool(FIELDS_SECTION_NAME, END_TIME, FIsEDExports);
    Ini.WriteBool(FIELDS_SECTION_NAME, RECORD_INDEX, FIsSIExports);
    Ini.WriteBool(FIELDS_SECTION_NAME, RECORD_ID, FIsCIExports);
    Ini.WriteBool(FIELDS_SECTION_NAME, RECORD_FLAGS, FIsFLExports);
    Ini.WriteBool(FIELDS_SECTION_NAME, RECORD_SEQUENCE, FIsSQExports);
    Ini.WriteBool(FIELDS_SECTION_NAME, CHARGE_STATUS, FIsCSExports);
    Ini.WriteBool(FIELDS_SECTION_NAME, CHARGING_UNITS, FIsCUExports);
    Ini.WriteBool(FIELDS_SECTION_NAME, BASIC_SERVICE, FIsBSExports);
    Ini.WriteBool(FIELDS_SECTION_NAME, TELESERVICE, FIsTSExports);
  finally
    Ini.Free;
  end;
end;

function TParser.GetExportPath: string;
begin
  Result := FExportPath;
end;

procedure TParser.SetExportPath(const APath: string);
begin
  FExportPath := Trim(APath);
  if (Length(FExportPath) > 1) and (Copy(FExportPath, Length(FExportPath), 1) <> '\') then
    FExportPath := FExportPath + '\';
end;

function TParser.SetExportFileName: string;
begin
  Result := FExportPath + FormatDateTime('yyyymmdd-hhmmss', Now) + '.csv';
end;

function TParser.GetLogLevel: Byte;
begin
  Result := FLogLevel;
end;

procedure TParser.SetLogLevel(const ALevel: Byte);
begin
  if ALevel <> FLogLevel then
    FLogLevel := ALevel;
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
    if IsSIExports then
      OneLine := OneLine + 'SI' + ';';
    if IsCIExports then
      OneLine := OneLine + 'CI' + ';';
    if IsFLExports then
      OneLine := OneLine + 'FL' + ';';
    if IsSQExports then
      OneLine := OneLine + 'SQ' + ';';
    if IsCSExports then
      OneLine := OneLine + 'CS' + ';';
    if IsDNExports then
    begin
      if IsACExports then
        OneLine := OneLine + 'AC' + ';';
      OneLine := OneLine + 'DN' + ';';
    end;
    if IsCNExports then
      OneLine := OneLine + 'I100_CN' + ';';
    if IsSDExports then
      OneLine := OneLine + 'I102_SD' + ';';
    if IsEDExports then
      OneLine := OneLine + 'I103_ED' + ';';
    if IsDUExports then
      OneLine := OneLine + 'I104_CU' + ';';
    if IsBSExports then
    begin
      OneLine := OneLine + 'BS' + ';';
      if IsTSExports then
        OneLine := OneLine + 'TS' + ';';

    end;

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

  if IsExportEnable then
    CloseFile(ExportFile);

  Result := FIsFSEnd;
end;

function TParser.ParseDateTimeChangesRecord(const RecData: array of Byte): Boolean;
var
  datetimeStr: string;
begin
  if LogLevel > 0 then
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
  end;

  Result := True;
end;

function TParser.ParseLossRecord(const RecData: array of Byte): Boolean;
var
  i: Integer;
  datetimeStr: string;
  lossRecordCount: LongWord;
begin
  if LogLevel > 0 then
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

    for i := 0 to 3 do
      Byte4(lossRecordCount)[i] := RecData[17 - i];
    Log(Format(GetAMessage('TOTAL_RECORDS_ARE_LOST', lang), [lossRecordCount]));
  end;

  Result := True;
end;

function TParser.ParseRebootRecord(const RecData: array of Byte): Boolean;
var
  datetimeStr: string;
begin
  if LogLevel > 0 then
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
  end;

  Result := True;
end;


function TParser.ParseRecord(Progress: Integer; var OneLine: string): Boolean;
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

    // Call record
    $c8:
    begin
      FS.Read(Len, 2);
      Len := Swap(Len);
      SetLength(RecData, Len - 3);
      for i := 0 to Length(RecData) - 1 do
        FS.Read(RecData[i], 1);
      OneLine := '';
      Result := ParseCallRecord(RecData, OneLine);
    end;
    else
      Log(Format(GetAMessage('UNKNOWN_RECORD_TYPE', lang), [TypeID]));
  end;

  FIsFSEnd := FS.Position >= FS.Size;
end;

function DecToBin(Int: Integer): string;
var
  AMod: Integer;
begin
  while Int >= 2 do
  begin
    AMod := Int mod 2;
    Int := Int div 2;
    Result := IntToStr(AMod) + Result;
  end;
  Result := IntToStr(Int) + Result;
  while Length(Result) < 8 do
    Result := '0' + Result;
end;


function IsBitSet(const val: Byte; const TheBit: Byte): Boolean;
begin
  Result := (val and (1 shl TheBit)) <> 0;
end;

function Byte1PerBit(const Flag: Byte): string;
begin
  Result := '';
  if IsBitSet(Flag, 0) then
    Result := Result + 'CR,';
  if IsBitSet(Flag, 1) then
    Result :=  Result + 'FU,';
  if IsBitSet(Flag, 2) then
    Result :=  Result + 'FI,';
  if IsBitSet(Flag, 3) then
    Result :=  Result + 'CS,';
  if IsBitSet(Flag, 4) then
    Result :=  Result + 'CM,';
  if IsBitSet(Flag, 5) then
    Result :=  Result + 'AM,';
  if IsBitSet(Flag, 6) then
    Result :=  Result + 'IA,';
  if IsBitSet(Flag, 7) then
    Result :=  Result + 'DB,';
end;

function Byte2PerBit(const Flag: Byte): string;
begin
  Result := '';
  if IsBitSet(Flag, 0) then
    Result := Result + 'ID,';
  if IsBitSet(Flag, 1) then
    Result :=  Result + 'OO,';
  if IsBitSet(Flag, 2) then
    Result :=  Result + 'TO,';
  if IsBitSet(Flag, 3) then
    Result :=  Result + 'PO,';
  if IsBitSet(Flag, 4) then
    Result :=  Result + 'IP,';
  if IsBitSet(Flag, 5) then
    Result :=  Result + 'RC,';
  if IsBitSet(Flag, 6) then
    Result :=  Result + 'RS,';
  if IsBitSet(Flag, 7) then
    Result :=  Result + 'TC,';
end;

function Byte3PerBit(const Flag: Byte): string;
begin
  Result := '';
  if IsBitSet(Flag, 0) then
    Result := Result + 'CX,';
  if IsBitSet(Flag, 1) then
    Result :=  Result + 'PP,';
  if IsBitSet(Flag, 2) then
    Result :=  Result + 'SC,';
  if IsBitSet(Flag, 3) then
    Result :=  Result + 'OA,';
  if IsBitSet(Flag, 4) then
    Result :=  Result + 'FP,';
end;

function TParser.ParseCallRecord(const RecData: array of Byte; var OneLine: string): Boolean;
var
  i: Integer;
  SI, CI: LongWord;
  FL: string;
  SQ, CS: Byte;
  ACL, DNL: Byte;
  AC_DN_len: Integer; // Owner's area code + derectiry number length
  DN: string;
  currOffset: LongWord; // just remember RecData index
  elementID, elementLen: LongWord; // elementLen keeps length in bytes without bytes before it (elementID, flags etc.)
  CN : string;
begin
  if LogLevel > 0 then
    Log('|');
  if LogLevel > 2 then
  begin
    Log(Format(GetAMessage('CALL_DATA_RECORD_IS_FOUND', lang), [$c8]));
    Log(Format(GetAMessage('CDR_LENGTH', lang), [Length(RecData)]));
    Log(GetAMessage('FIXED_DATA', lang));
  end;

  { Working with fixed part of the record }

  // SI – serial CDR index
  for i := 0 to 3 do
    Byte4(SI)[i] := RecData[3 - i];
  if LogLevel > 1 then
    Log(Format(GetAMessage('SI', lang), [SI]));
  if IsExportEnable then
    if IsSIExports then
      OneLine := OneLine + IntToStr(SI) + ';';

  // CI - Call identifier
  for i := 0 to 3 do
    Byte4(CI)[i] := RecData[7 - i];
  if LogLevel > 1 then
    Log(Format(GetAMessage('CI', lang), [CI]));
  if IsExportEnable then
    if IsCIExports then
      OneLine := OneLine + IntToStr(CI) + ';';

  // FL - Flags
  FL := '';
  FL := FL + Byte1PerBit(RecData[8]);
  FL := FL + Byte2PerBit(RecData[9]);
  FL := FL + Byte3PerBit(RecData[10]);
  if Length(FL) > 0 then
    Delete(FL, Length(FL), 1);
  if LogLevel > 1 then
    Log(Format(GetAMessage('FL', lang), [FL]));
  if LogLevel > 2 then
  begin
    Log(Format('        F08-F01 : %s', [DecToBin(RecData[8])]));
    Log(Format('        F16-F09 : %s', [DecToBin(RecData[9])]));
    Log(Format('        F21-F17 : %s', [DecToBin(RecData[10])]));
  end;
  if IsExportEnable then
    if IsFLExports then
      OneLine := OneLine + FL + ';';

  // SQ - Record sequence & CS - Charge status
  SQ := (RecData[11] shr 4) and $0F;
  CS := RecData[11] and $0F;
  if LogLevel > 1 then
  begin
    Log(Format(GetAMessage('SQ', lang), [SQ]));
    Log(Format(GetAMessage('CS', lang), [CS]));
  end;
  if IsExportEnable then
  begin
    if IsSQExports then
      OneLine := OneLine + IntToStr(SQ) + ';';
    if IsCSExports then
      OneLine := OneLine + IntToStr(CS) + ';';
  end;

  // ACL - Area code length & DNL - Directory number length (Owner number length)
  ACL := (RecData[12] shr 5) and $07;
  DNL := RecData[12] and $1F;
  if LogLevel > 1 then
  begin
    Log(Format(GetAMessage('ACL', lang), [ACL]));
    Log(Format(GetAMessage('DNL', lang), [DNL]));
  end;

  // AC - Area code & DN - Directory number (Owner number)
  AC_DN_len := (ACL + DNL) div 2;
  if ((ACL + DNL) mod 2) > 0 then
    Inc(AC_DN_len);
  DN := '';
  for i := 0 to AC_DN_len - 1 do
    DN := DN + IntToHex(RecData[13 + i], 2);
  if ((ACL + DNL) mod 2) > 0 then
    DN := Copy(DN, 1, Length(DN) - 1);
  if LogLevel > 0 then
  begin
    Log(Format(GetAMessage('DN', lang), [Copy(DN, 1, ACL), Copy(DN, ACL + 1, Length(DN) - ACL)]));
  end;
  if IsExportEnable then
    if IsDNExports then
      if IsACExports then
        OneLine := OneLine + Copy(DN, 1, ACL) + ';';
      OneLine := OneLine + Copy(DN, ACL + 1, Length(DN) - ACL) + ';';

  { Working with dynamic part of the record }

  if LogLevel > 2 then
  begin
    Log(GetAMessage('DYNAMIC_DATA', lang));
  end;

  currOffset := 13 + AC_DN_len;
  while currOffset < Length(RecData) do
  begin
    elementID := RecData[currOffset];
    case elementID of
      100: // I100 CN - called number ($64)
      begin
        elementLen := RecData[currOffset + 1] div 2;
        if RecData[currOffset + 1] mod 2 > 0 then
          Inc(elementLen);
        CN := '';
        for i := 0 to elementLen - 1 do
          CN := CN + IntToHex(RecData[currOffset + 2 + i], 2);
        if (RecData[currOffset + 1] mod 2) > 0 then
          CN := Copy(CN, 1, Length(CN) - 1);
        if LogLevel > 0 then
          Log(Format(GetAMessage('I100_CN', lang), [CN]));
        if IsExportEnable then
          if IsCNExports then
            OneLine := OneLine + CN + ';';

        currOffset := currOffset + 2 + elementLen;
      end;

      101: // I101 Call Accepting Party Number ($65)
      begin
        elementLen := RecData[currOffset + 2] div 2;
        if RecData[currOffset + 2] mod 2 > 0 then
          Inc(elementLen);
        CN := '';
        for i := 0 to elementLen - 1 do
          CN := CN + IntToHex(RecData[currOffset + 3 + i], 2);
        if (RecData[currOffset + 2] mod 2) > 0 then
          CN := Copy(CN, 1, Length(CN) - 1);
        if LogLevel > 1 then
          Log(Format(GetAMessage('I101', lang), [CN, RecData[currOffset + 1]]));

        currOffset := currOffset + 3 + elementLen;
      end;

      102: // I102 SD - start date and time ($66)
      begin
        elementLen := 8;
        CN := Format('20%s-%s-%s %s:%s:%s.%s00', [
          Format('%.*d', [2, RecData[currOffset + 1]]),
          Format('%.*d', [2, RecData[currOffset + 2]]),
          Format('%.*d', [2, RecData[currOffset + 3]]),
          Format('%.*d', [2, RecData[currOffset + 4]]),
          Format('%.*d', [2, RecData[currOffset + 5]]),
          Format('%.*d', [2, RecData[currOffset + 6]]),
          Format('%.*d', [1, RecData[currOffset + 7]])
        ]);
        if LogLevel > 0 then
          Log(Format(GetAMessage('I102_SD', lang), [CN]));
        if IsExportEnable then
          if IsSDExports then
            OneLine := OneLine + CN + ';';

        currOffset := currOffset + 1 + elementLen;
      end;

      103: // I103 ED - end date and time ($67)
      begin
        elementLen := 8;
        CN := Format('20%s-%s-%s %s:%s:%s.%s00', [
          Format('%.*d', [2, RecData[currOffset + 1]]),
          Format('%.*d', [2, RecData[currOffset + 2]]),
          Format('%.*d', [2, RecData[currOffset + 3]]),
          Format('%.*d', [2, RecData[currOffset + 4]]),
          Format('%.*d', [2, RecData[currOffset + 5]]),
          Format('%.*d', [2, RecData[currOffset + 6]]),
          Format('%.*d', [1, RecData[currOffset + 7]])
        ]);
        if LogLevel > 0 then
          Log(Format(GetAMessage('I103_ED', lang), [CN]));
        if IsExportEnable then
          if IsEDExports then
            OneLine := OneLine + CN + ';';

        currOffset := currOffset + 1 + elementLen;
      end;

      104: // I104 CU - end date and time ($68)
      begin
        elementLen := 3;
        Byte4(SI)[0] := 0;
        Byte4(SI)[1] := RecData[currOffset + 3];
        Byte4(SI)[2] := RecData[currOffset + 2];
        Byte4(SI)[3] := RecData[currOffset + 1];
        if LogLevel > 1 then
          Log(Format(GetAMessage('I104_CU', lang), [SI]));
        if IsCUExports then
          OneLine := OneLine + IntToStr(SI) + ';';

        currOffset := currOffset + 1 + elementLen;
      end;

      105: // I105 BS - basic service ($69)
      begin
        elementLen := 2;
        if LogLevel > 1 then
          Log(Format(GetAMessage('I105_BS', lang), [RecData[currOffset + 1], RecData[currOffset + 2]]));

        if IsBSExports then
        begin
          OneLine := OneLine + IntToStr(RecData[currOffset + 1]) + ';';
          if IsTSExports then
            OneLine := OneLine + IntToStr(RecData[currOffset + 2]) + ';';
        end;
        currOffset := currOffset + 1 + elementLen;
        currOffset := currOffset + 200;
      end;

      else
        //Exit;
    end;
  end;




  if LogLevel > 0 then
    Log('-----------------------------------------------------------------');

  // delete last separator
  if (Length(OneLine) > 1) then
    Delete(OneLine, Length(OneLine), 1);

  Result := True;
end;

end.
