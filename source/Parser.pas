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
  RECORD_INDEX: string = 'R200_SI';
  RECORD_ID: string = 'R200_CI';
  RECORD_FLAGS: string = 'R200_FL';
  RECORD_SEQUENCE: string = 'R200_SQ';
  CHARGE_STATUS: string = 'R200_CS';
  ACCOUNT_AREA: string = 'R200_AC';
  ACCOUNT_NUMBER: string = 'R200_DN';
  CALLED_NUMBER: string = 'I100_CN';
  START_TIME: string = 'I102_SD';
  END_TIME: string = 'I103_ED';
  CHARGING_UNITS: string = 'I104_CU';
  BASIC_SERVICE: string = 'I105_BS';
  TELESERVICE: string = 'I105_TS';
  ORIGIN_CATEGORY: string = 'I110_OC';
  TARIFF_DIRECTION: string = 'I111_TD';
  CALL_DURATION: string = 'I115_DU';
//  ORIGINAL_CALLING_NUMBER : string = 'I119_OCN';
  CAUSE_VALUE: string = 'I121_CV';
  LOCATION: string = 'I121_LO';
  OSR_IP: string = 'I127_OSR_IP';
  OSL_IP: string = 'I127_OSL_IP';
  TSR_IP: string = 'I127_TSR_IP';
  TSL_IP: string = 'I127_TSL_IP';

  AvgRecLength: Byte = 134;

type
  { LongWord per byte type}
  Byte4 = array[0..3] of Byte;

  TParser = class
    private
      // Parser settings
      FIsExportEnable: Boolean;
      FExportPath: string;
      FIsEDExports: Boolean;  // SD - call ends date & time
      FIsSIExports: Boolean;  // SI - serial CDR index
      FIsCIExports: Boolean;  // CI - call ID
      FIsFLExports: Boolean;  // FL - flags
      FIsSQExports: Boolean;  // SQ - record sequence
      FIsCSExports: Boolean;  // CS - charge status
      FIsACExports: Boolean;  // AC - owner's area code
      FIsDNExports: Boolean;  // DN - directory number (owner's number)
      FIsCNExports: Boolean;  // CN - called number
      FIsSDExports: Boolean;  // SD - call starts date & time
      FIsCUExports: Boolean;  // CU - number of charging units
      FIsBSExports: Boolean;  // BS - basic service
      FIsTSExports: Boolean;  // TS - teleservice
      FIsOCExports: Boolean;  // OC - origin category
      FIsTDExports: Boolean;  // TD - tariff direction
      FIsDUExports: Boolean;  // DU - call/service duration, sec.
//      FIsOCNExports: Boolean; // OCN - original calling party number
      FIsCVExports: Boolean; // Call release cause: CV - cause value
      FIsLOExports: Boolean; // Call release cause: LO - location
      FIsOSR_IPExports: Boolean; // origin side remote RTP IP
      FIsOSL_IPExports: Boolean; // origin side local RTP IP
      FIsTSR_IPExports: Boolean; // terminating side remote RTP IP
      FIsTSL_IPExports: Boolean; // terminating side local RTP IP
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
      property IsEDExports: Boolean read FIsEDExports write FIsEDExports;
      property IsSIExports: Boolean read FIsSIExports write FIsSIExports;
      property IsCIExports: Boolean read FIsCIExports write FIsCIExports;
      property IsFLExports: Boolean read FIsFLExports write FIsFLExports;
      property IsSQExports: Boolean read FIsSQExports write FIsSQExports;
      property IsCSExports: Boolean read FIsCSExports write FIsCSExports;
      property IsCUExports: Boolean read FIsCUExports write FIsCUExports;
      property IsBSExports: Boolean read FIsBSExports write FIsBSExports;
      property IsTSExports: Boolean read FIsTSExports write FIsTSExports;
      property IsOCExports: Boolean read FIsOCExports write FIsOCExports;
      property IsTDExports: Boolean read FIsTDExports write FIsTDExports;
      property IsDUExports: Boolean read FIsDUExports write FIsDUExports;
//      property IsOCNExports: Boolean read FIsOCNExports write FIsOCNExports;
      property IsCVExports: Boolean read FIsCVExports write FIsCVExports;
      property IsLOExports: Boolean read FIsLOExports write FIsLOExports;
      property IsOSR_IPExports: Boolean read FIsOSR_IPExports write FIsOSR_IPExports;
      property IsOSL_IPExports: Boolean read FIsOSL_IPExports write FIsOSL_IPExports;
      property IsTSR_IPExports: Boolean read FIsTSR_IPExports write FIsTSR_IPExports;
      property IsTSL_IPExports: Boolean read FIsTSL_IPExports write FIsTSL_IPExports;

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
    FIsEDExports := Ini.ReadBool(FIELDS_SECTION_NAME, END_TIME, False);
    FIsSIExports := Ini.ReadBool(FIELDS_SECTION_NAME, RECORD_INDEX, False);
    FIsCIExports := Ini.ReadBool(FIELDS_SECTION_NAME, RECORD_ID, False);
    FIsFLExports := Ini.ReadBool(FIELDS_SECTION_NAME, RECORD_FLAGS, False);
    FIsSQExports := Ini.ReadBool(FIELDS_SECTION_NAME, RECORD_SEQUENCE, False);
    FIsCSExports := Ini.ReadBool(FIELDS_SECTION_NAME, CHARGE_STATUS, False);
    FIsCUExports := Ini.ReadBool(FIELDS_SECTION_NAME, CHARGING_UNITS, False);
    FIsBSExports := Ini.ReadBool(FIELDS_SECTION_NAME, BASIC_SERVICE, False);
    FIsTSExports := Ini.ReadBool(FIELDS_SECTION_NAME, TELESERVICE, False);
    FIsOCExports := Ini.ReadBool(FIELDS_SECTION_NAME, ORIGIN_CATEGORY, False);
    FIsTDExports := Ini.ReadBool(FIELDS_SECTION_NAME, TARIFF_DIRECTION, False);
    FIsDUExports := Ini.ReadBool(FIELDS_SECTION_NAME, CALL_DURATION, True);
//    FIsOCNExports := Ini.ReadBool(FIELDS_SECTION_NAME, ORIGINAL_CALLING_NUMBER, False);
    FIsCVExports := Ini.ReadBool(FIELDS_SECTION_NAME, CAUSE_VALUE, False);
    FIsLOExports := Ini.ReadBool(FIELDS_SECTION_NAME, LOCATION, False);
    FIsOSR_IPExports := Ini.ReadBool(FIELDS_SECTION_NAME, OSR_IP, False);
    FIsOSL_IPExports := Ini.ReadBool(FIELDS_SECTION_NAME, OSL_IP, False);
    FIsTSR_IPExports := Ini.ReadBool(FIELDS_SECTION_NAME, TSR_IP, False);
    FIsTSL_IPExports := Ini.ReadBool(FIELDS_SECTION_NAME, TSL_IP, False);
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
    Ini.WriteBool(FIELDS_SECTION_NAME, END_TIME, FIsEDExports);
    Ini.WriteBool(FIELDS_SECTION_NAME, RECORD_INDEX, FIsSIExports);
    Ini.WriteBool(FIELDS_SECTION_NAME, RECORD_ID, FIsCIExports);
    Ini.WriteBool(FIELDS_SECTION_NAME, RECORD_FLAGS, FIsFLExports);
    Ini.WriteBool(FIELDS_SECTION_NAME, RECORD_SEQUENCE, FIsSQExports);
    Ini.WriteBool(FIELDS_SECTION_NAME, CHARGE_STATUS, FIsCSExports);
    Ini.WriteBool(FIELDS_SECTION_NAME, CHARGING_UNITS, FIsCUExports);
    Ini.WriteBool(FIELDS_SECTION_NAME, BASIC_SERVICE, FIsBSExports);
    Ini.WriteBool(FIELDS_SECTION_NAME, TELESERVICE, FIsTSExports);
    Ini.WriteBool(FIELDS_SECTION_NAME, ORIGIN_CATEGORY, FIsOCExports);
    Ini.WriteBool(FIELDS_SECTION_NAME, TARIFF_DIRECTION, FIsTDExports);
    Ini.WriteBool(FIELDS_SECTION_NAME, CALL_DURATION, FIsDUExports);
//    Ini.WriteBool(FIELDS_SECTION_NAME, ORIGINAL_CALLING_NUMBER, FIsOCNExports);
    Ini.WriteBool(FIELDS_SECTION_NAME, CAUSE_VALUE, FIsCVExports);
    Ini.WriteBool(FIELDS_SECTION_NAME, LOCATION, FIsLOExports);
    Ini.WriteBool(FIELDS_SECTION_NAME, OSR_IP, FIsOSR_IPExports);
    Ini.WriteBool(FIELDS_SECTION_NAME, OSL_IP, FIsOSR_IPExports);
    Ini.WriteBool(FIELDS_SECTION_NAME, TSR_IP, FIsTSR_IPExports);
    Ini.WriteBool(FIELDS_SECTION_NAME, TSL_IP, FIsTSR_IPExports);
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
      OneLine := OneLine + 'R200_SI' + ';';
    if IsCIExports then
      OneLine := OneLine + 'R200_CI' + ';';
    if IsFLExports then
      OneLine := OneLine + 'R200_FL' + ';';
    if IsSQExports then
      OneLine := OneLine + 'R200_SQ' + ';';
    if IsCSExports then
      OneLine := OneLine + 'R200_CS' + ';';
    if IsDNExports then
    begin
      if IsACExports then
        OneLine := OneLine + 'R200_AC' + ';';
      OneLine := OneLine + 'R200_DN' + ';';
    end;
    if IsCNExports then
      OneLine := OneLine + 'I100_CN' + ';';
    if IsSDExports then
      OneLine := OneLine + 'I102_SD' + ';';
    if IsEDExports then
      OneLine := OneLine + 'I103_ED' + ';';
    if IsCUExports then
      OneLine := OneLine + 'I104_CU' + ';';
    if IsBSExports then
    begin
      OneLine := OneLine + 'I105_BS' + ';';
      if IsTSExports then
        OneLine := OneLine + 'I105_TS' + ';';
    end;
    if IsOCExports then
      OneLine := OneLine + 'I110_OC' + ';';
    if IsTDExports then
      OneLine := OneLine + 'I111_TD' + ';';
    if IsDUExports then
      OneLine := OneLine + 'I115_DU' + ';';
//    if IsOCNExports then
//      OneLine := OneLine + 'I119_OCN' + ';';
    if IsCVExports then
    begin
      OneLine := OneLine + 'I121_CV' + ';';
      if IsLOExports then
        OneLine := OneLine + 'I121_LO' + ';';
    end;
    if IsOSR_IPExports then
      OneLine := OneLine + 'I127_OSR_IP' + ';';
    if IsOSL_IPExports then
      OneLine := OneLine + 'I127_OSL_IP' + ';';
    if IsTSR_IPExports then
      OneLine := OneLine + 'I127_TSR_IP' + ';';
    if IsTSL_IPExports then
      OneLine := OneLine + 'I127_TSL_IP' + ';';

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
  currOffset: Integer; // just remember RecData index
  elementID, elementLen: Integer; // elementLen keeps length in bytes without bytes before it (elementID, flags etc.)
  CN : string;
  OR_IP, OL_IP, TR_IP, TL_IP: string;
  ST1, ST2, ST3, ST4, localOffset: Word;

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
    begin
      if IsACExports then
        OneLine := OneLine + Copy(DN, 1, ACL) + ';';
      OneLine := OneLine + Copy(DN, ACL + 1, Length(DN) - ACL) + ';';
    end;

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

      104: // I104 CU - number of charging units  ($68)
      begin
        elementLen := 3;
        if LogLevel > 1 then
          Log(Format(GetAMessage('I104_CU', lang), [(RecData[currOffset + 1] shl 16) + (RecData[currOffset + 2] shl 8) + (RecData[currOffset + 3])]));
        if IsCUExports then
          OneLine := OneLine + IntToStr((RecData[currOffset + 1] shl 16) + (RecData[currOffset + 2] shl 8) + (RecData[currOffset + 3])) + ';';

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
      end;

      106: // I106 SS -  supplementary service used by calling subscriber ($6A)
      begin
        elementLen := 1;
        if LogLevel > 1 then
          Log(Format(GetAMessage('I106_SS', lang), [RecData[currOffset + 1]]));

        { TODO 1 -cso-so : Maybe add to export }

        currOffset := currOffset + 1 + elementLen;
      end;

      107: // I107 SS -  supplementary service used by called subscriber ($6B)
      begin
        elementLen := 1;
        if LogLevel > 1 then
          Log(Format(GetAMessage('I107_SS', lang), [RecData[currOffset + 1]]));

        { TODO 1 -cso-so : Maybe add to export }

        currOffset := currOffset + 1 + elementLen;
      end;

      108: // I108 SS -  supplementary service used by called subscriber ($6Ñ)
      begin
        elementLen := 2;
        if LogLevel > 2 then
          Log(Format(GetAMessage('I108_TI', lang), [RecData[currOffset + 1]]));
        if LogLevel > 2 then
          Log(Format(GetAMessage('I108_SS', lang), [RecData[currOffset + 2]]));

        { TODO 1 -cso-so : Maybe add to export }

        currOffset := currOffset + 1 + elementLen;
      end;

      109: // Dialed digits ($6D)
      begin
        elementLen := RecData[currOffset + 1];
        // go through this element
        currOffset := currOffset + 1 + elementLen;
      end;

      110: // I110 OC - origin category ($6E)
      begin
        elementLen := 1;
        if LogLevel > 2 then
          Log(Format(GetAMessage('I110_OC', lang), [RecData[currOffset + 1]]));
        if IsExportEnable then
          if IsOCExports then
            OneLine := OneLine + IntToStr(RecData[currOffset + 1]) + ';';

        currOffset := currOffset + 1 + elementLen;
      end;

      111: // I111 TD - tariff direction ($6F)
      begin
        elementLen := 1;
        if LogLevel > 2 then
          Log(Format(GetAMessage('I111_TD', lang), [RecData[currOffset + 1]]));
        if IsExportEnable then
          if IsTDExports then
            OneLine := OneLine + IntToStr(RecData[currOffset + 1]) + ';';
        currOffset := currOffset + 1 + elementLen;
      end;

      112: // I112 FC - failure cause  ($70)
      { This element is no longer used. It was replaced by I121 Call Release Cause. }
      begin
        elementLen := 1;
        if LogLevel > 2 then
          Log(Format(GetAMessage('SKIPPED_ITEM_IS_FOUND', lang), [elementID, elementID]));
        currOffset := currOffset + 1 + elementLen;
      end;

      113: // I113 ITD - incoming trunk data  ($71)
      begin
        elementLen := 8;
        if LogLevel > 2 then
        begin
          Log(Format(GetAMessage('I113_ITD', lang), [
            (RecData[currOffset + 1] shl 8) + RecData[currOffset + 2],
            (RecData[currOffset + 3] shl 8) + RecData[currOffset + 4],
            RecData[currOffset + 5],
            (RecData[currOffset + 6] shl 8) + RecData[currOffset + 7],
            RecData[currOffset + 8]
          ]));
        end;

        currOffset := currOffset + 1 + elementLen;
      end;

      114: // I114 OTD - outgoing trunk data  ($72)
      begin
        elementLen := 8;
        if LogLevel > 2 then
        begin
          Log(Format(GetAMessage('I114_OTD', lang), [
            (RecData[currOffset + 1] shl 8) + RecData[currOffset + 2],
            (RecData[currOffset + 3] shl 8) + RecData[currOffset + 4],
            RecData[currOffset + 5],
            (RecData[currOffset + 6] shl 8) + RecData[currOffset + 7],
            RecData[currOffset + 8]
          ]));
        end;

        currOffset := currOffset + 1 + elementLen;
      end;

      115: // I115 DU - call/service duration  ($73)
      begin
        elementLen := 4;
        // get DU in msec to SI variale
        SI :=
          (RecData[currOffset + 1] shl 24) +
          (RecData[currOffset + 2] shl 16) +
          (RecData[currOffset + 3] shl 8) +
          (RecData[currOffset + 4]);
        // msec -> sec
        CI := SI mod 1000;
        SI := SI div 1000;
        if CI >= 500 then
          Inc(SI);
        if LogLevel > 0 then
          Log(Format(GetAMessage('I115_DU', lang), [SI]));
        if IsExportEnable then
          if IsDUExports then
            OneLine := OneLine + IntToStr(SI) + ';';

        currOffset := currOffset + 1 + elementLen;
      end;

      116: // I116 Checksum ($74)
      begin
        elementLen := RecData[currOffset + 1];
        if LogLevel > 2 then
          Log(Format(GetAMessage('I116_CS', lang), [IntToHex(RecData[currOffset + 2], 2), IntToHex(RecData[currOffset + 3], 2)]));

        currOffset := currOffset + elementLen;
      end;

      117: // I117 Business and Centrex group id ($75)
      begin
        elementLen := RecData[currOffset + 1];
        if LogLevel > 2 then
          Log(Format(GetAMessage('I117_BC', lang), [
            (RecData[currOffset + 2] shl 24) + (RecData[currOffset + 3] shl 16) + (RecData[currOffset + 4] shl 8) + (RecData[currOffset + 5]), // BGID
            (RecData[currOffset + 6] shl 24) + (RecData[currOffset + 7] shl 16) + (RecData[currOffset + 8] shl 8) + (RecData[currOffset + 9])  // CGID
            ]));

        currOffset := currOffset + elementLen;
      end;

      118: // I118 Carrier access code ($76)
      begin
        elementLen := RecData[currOffset + 1];
        if LogLevel > 1 then
        begin
          ACL := (RecData[currOffset + 2]) and $07;
          CN := '';
          for i := 0 to elementLen - 3 do
            CN := CN + IntToHex(RecData[currOffset + 3 + i], 2);
          if (ACL mod 2) > 0 then
            CN := Copy(CN, 1, Length(CN) - 1);
          Log(Format(GetAMessage('I118_CAC', lang), [
            (RecData[currOffset + 2] shr 5) and  $07, // CAC type
            ((RecData[currOffset + 2] shl 3) shr 3) and $03, // CAC prefix
            CN
          ]));
        end;

        currOffset := currOffset + elementLen;
      end;

      119: // I119 Original Calling Party Number ($77)
      begin
        elementLen := RecData[currOffset + 1];
        if LogLevel > 1 then
        begin
          DN := '';
          for i := 0 to RecData[2] - 1 do
            DN := DN + IntToHex(RecData[i + 2], 2);
          if (RecData[2] mod 2) > 0 then
            DN := Copy(DN, 1, Length(DN) - 1);
          Log(Format(GetAMessage('I119_OCN', lang), [DN]));
        end;
        {
        if IsExportEnable then
          if IsOCNExports then
            OneLine := OneLine + DN + ';';
        }
        currOffset := currOffset + elementLen;
      end;

      120: // I120 Prepaid account recharge data ($78)
      begin
        elementLen := RecData[currOffset + 1];
        if LogLevel > 2 then
          Log(Format(GetAMessage('SKIPPED_ITEM_IS_FOUND', lang), [elementID, elementID]));
        currOffset := currOffset + elementLen;
      end;

      121: // I121 CRC - call release cause ($79)
      begin
        elementLen := RecData[currOffset + 1];
        if LogLevel > 1 then
          Log(Format(GetAMessage('I121_CRC', lang), [
            (RecData[currOffset + 2] shl 8) + (RecData[currOffset + 3]),
             RecData[currOffset + 4] and $0F
          ]));
        if IsExportEnable then
          if IsCVExports then
          begin
            OneLine := OneLine + IntToStr((RecData[currOffset + 2] shl 8) + (RecData[currOffset + 3])) + ';';
            if IsLOExports then
              OneLine := OneLine + IntToStr(RecData[currOffset + 4] and $0F) + ';';
          end;

        currOffset := currOffset + elementLen;
      end;

      122: // I122 Charge Band Number ($7A)
      begin
        elementLen := RecData[currOffset + 1];
        if LogLevel > 2 then
          Log(Format(GetAMessage('I122_CBN', lang), [
            (RecData[currOffset + 2] shl 8) + (RecData[currOffset + 3]),
             RecData[currOffset + 4] and $01
          ]));

        currOffset := currOffset + elementLen;
      end;

      123: // I123 Common ñall ID ($7B)
      begin
        elementLen := RecData[currOffset + 1];
        if LogLevel > 2 then
          Log(Format(GetAMessage('I123_CCID', lang), [
            (RecData[currOffset + 2] shl 24) +
            (RecData[currOffset + 3] shl 16) +
            (RecData[currOffset + 4] shl 8) +
            (RecData[currOffset + 5])
          ]));

        currOffset := currOffset + elementLen;
      end;

      124: // I124 Durations before answer ($7C)
      begin
        elementLen := RecData[currOffset + 1];
        if LogLevel > 2 then
          Log(Format(GetAMessage('I124_DBA', lang), [
            (RecData[currOffset + 2] shl 24) +
            (RecData[currOffset + 3] shl 16) +
            (RecData[currOffset + 4] shl 8) +
            (RecData[currOffset + 5]),
            (RecData[currOffset + 6] shl 24) +
            (RecData[currOffset + 7] shl 16) +
            (RecData[currOffset + 8] shl 8) +
            (RecData[currOffset + 9])
          ]));

        currOffset := currOffset + elementLen;
      end;

      125: // I125 VoIP Info ($7D) - OLD
      begin
        elementLen := RecData[currOffset + 1];
        if LogLevel > 2 then
          Log(Format(GetAMessage('SKIPPED_ITEM_IS_FOUND', lang), [elementID, elementID]));
        currOffset := currOffset + elementLen;
      end;

      126: // I126 Amount of transferred tata ($7E) - OLD
      begin
        elementLen := RecData[currOffset + 1];
        if LogLevel > 2 then
          Log(Format(GetAMessage('SKIPPED_ITEM_IS_FOUND', lang), [elementID, elementID]));
        currOffset := currOffset + elementLen;
      end;

      127: // I127 IP Addresses ($7F)
      begin
        elementLen := RecData[currOffset + 1];
        OR_IP := '';
        OL_IP := '';
        TR_IP := '';
        TL_IP := '';
        if (RecData[currOffset + 2] and $01) > 0 then
          OR_IP := Format('%u.%u.%u.%u', [
            RecData[currOffset + 4],
            RecData[currOffset + 5],
            RecData[currOffset + 6],
            RecData[currOffset + 7]
          ]);
        if (RecData[currOffset + 2] and $02) > 0 then
          OL_IP := Format('%u.%u.%u.%u', [
            RecData[currOffset + 8],
            RecData[currOffset + 9],
            RecData[currOffset + 10],
            RecData[currOffset + 11]
          ]);
        if (RecData[currOffset + 2] and $04) > 0 then
          TR_IP := Format('%u.%u.%u.%u', [
            RecData[currOffset + 12],
            RecData[currOffset + 13],
            RecData[currOffset + 14],
            RecData[currOffset + 15]
          ]);
        if (RecData[currOffset + 2] and $08) > 0 then
          TL_IP := Format('%u.%u.%u.%u', [
            RecData[currOffset + 16],
            RecData[currOffset + 17],
            RecData[currOffset + 18],
            RecData[currOffset + 19]
          ]);
        if LogLevel > 1 then
          Log(Format(GetAMessage('I127_IPA', lang), [OR_IP, OL_IP, TR_IP, TL_IP]));

        if IsExportEnable then
        begin
          if IsOSR_IPExports then
            OneLine := OneLine + OR_IP + ';';
          if IsOSL_IPExports then
            OneLine := OneLine + OL_IP + ';';
          if IsTSR_IPExports then
            OneLine := OneLine + TR_IP + ';';
          if IsTSL_IPExports then
            OneLine := OneLine + TL_IP + ';';
        end;

        currOffset := currOffset + elementLen;
      end;

      128: // I128 VoIP Info ($80)
      begin
        elementLen := RecData[currOffset + 1];
        if LogLevel > 2 then
          Log(Format(GetAMessage('I128_VOIP', lang), [
            RecData[currOffset + 2],                                    // RC
            RecData[currOffset + 3],                                    // TC
            RecData[currOffset + 4],                                    // RP
            RecData[currOffset + 5],                                    // TP
            (RecData[currOffset + 6] shl 8) + RecData[currOffset + 7],  // RB
            (RecData[currOffset + 8] shl 8) + RecData[currOffset + 9],  // TB
            (RecData[currOffset + 10] shl 8) + RecData[currOffset + 11],// Max. buffer
            RecData[currOffset + 12] shr 7,                             // Side
            RecData[currOffset + 12] and $7F                            // VoIP type
          ]));

        currOffset := currOffset + elementLen;
      end;

      129: // I129 Amount of Transferred Data ($81)
      begin
        elementLen := RecData[currOffset + 1];
        if LogLevel > 2 then
          Log(Format(GetAMessage('I129_ATD', lang), [
            RecData[currOffset + 2],            // Side
            (RecData[currOffset + 3] shr 24) +  // Rx packets
            (RecData[currOffset + 4] shr 16) +
            (RecData[currOffset + 5] shr 8) +
            (RecData[currOffset + 6]),
            (RecData[currOffset + 7] shr 24) +  // Tx packets
            (RecData[currOffset + 8] shr 16) +
            (RecData[currOffset + 9] shr 8) +
            (RecData[currOffset + 10]),
            (RecData[currOffset + 11] shr 24) +  // Rx octets
            (RecData[currOffset + 12] shr 16) +
            (RecData[currOffset + 13] shr 8) +
            (RecData[currOffset + 14]),
            (RecData[currOffset + 15] shr 24) +  // Tx octets
            (RecData[currOffset + 16] shr 16) +
            (RecData[currOffset + 17] shr 8) +
            (RecData[currOffset + 18]),
            (RecData[currOffset + 19] shr 24) +  // Packets lost
            (RecData[currOffset + 20] shr 16) +
            (RecData[currOffset + 21] shr 8) +
            (RecData[currOffset + 22]),
            RecData[currOffset + 23],            // Avg. jitter
            RecData[currOffset + 24]            // Avg. latency
          ]));
        currOffset := currOffset + elementLen;
      end;

      130, // I130 Service Control Data ($82)
      131, // I131 New destination number ($83)
      132, // I132 QoS VoIP Data ($84)
      133: // I133 Additional Centrex Data ($85)
      begin
        elementLen := RecData[currOffset + 1];
        if LogLevel > 2 then
          Log(Format(GetAMessage('SKIPPED_ITEM_IS_FOUND', lang), [elementID, elementID]));
        currOffset := currOffset + elementLen;
      end;

      134: // I134 Additional statistics data ($86)
      begin
        elementLen := RecData[currOffset + 1];
        ST1 := 0;
        ST2 := 0;
        ST3 := 0;
        ST4 := 0;
        localOffset := 0;

        // Calling SS Group
        if (RecData[currOffset + 2] and $01) > 0 then
        begin
          ST1 := (RecData[currOffset + 3] shl 8) + (RecData[currOffset + 3]);
          localOffset := 2;
        end;

        // Called SS Group
        if (RecData[currOffset + 2] and $02) > 0 then
        begin
          ST2 := (RecData[currOffset + localOffset + 3] shl 8) + (RecData[currOffset + localOffset + 3]);
          localOffset := localOffset + 2;
        end;

        // Orig. Side SND Line Type
        if (RecData[currOffset + 2] and $04) > 0 then
        begin
          ST3 := RecData[currOffset + localOffset + 3];
          localOffset := localOffset + 1;
        end;

        // Term. Side SND Line Type
        if (RecData[currOffset + 2] and $08) > 0 then
        begin
          ST4 := RecData[currOffset + localOffset + 3];
          localOffset := localOffset + 1;
        end;

        if LogLevel > 2 then
          Log(Format(GetAMessage('I134_ASD', lang), [ST1, ST2, ST3, ST4]));

        currOffset := currOffset + elementLen;
      end;

      135, // I135 IMS charging identifier ($87)
      136, // I136 Inter Operator Identifiers ($88)
      137, // I137 Supplementary service additional info ($89)
      138, // I138 Calling Party Number ($8A)
      139, // I139 Additional Calling Number ($8B)
      140, // I140 Called Party Number ($8C)
      141, // I141 Sent Called Party Number ($8D)
      142, // I142 Third Party Number ($8E)
      143, // I143 Redirecting Party Number ($8F)
      144, // I144 Incoming Trunk Data - Name ($90)
      145, // I145 Outgoing Trunk Data - Name ($91)
      146, // I146 Node Info ($92)
      147, // I147 Global Call Reference ($93)
      148, // I148 MLPP Data ($94)
      149, // I149 Customer Data ($95)
      150, // I150 Received Called Party Number ($96)
      151, // I151 Call Type ($97)
      152, // I152 IN Service Data ($98)
      153, // I153 URI – Uniform Resource Identifier ($99)
      154, // I154 Free Format Operator Specific Data ($9A)

      156, // I156 Additional Numbers ($9C)
      157, // I157 SIP Data ($9D)
      158, // I158 FMC (Fix Mobile Convergence) Data ($9E)
      159, // I159 Centrex Numbers ($9F)
      160: // I160 Time Zone ($100)
      begin
        elementLen := RecData[currOffset + 1];
        if LogLevel > 2 then
          Log(Format(GetAMessage('SKIPPED_ITEM_IS_FOUND', lang), [elementID, elementID]));
        currOffset := currOffset + elementLen;
      end;
      else
      begin
        Log(Format(GetAMessage('UNKNOWN_ITEM_IS_FOUND', lang), [elementID, elementID]));
        currOffset := 250;
      end;
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
