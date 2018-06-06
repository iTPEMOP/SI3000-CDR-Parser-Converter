unit I18NMessages;


interface

const
  CONST_NAMES: array[0..27] of string = (
  { Log messages }
    'BEGIN_PARSE_en',
    'BEGIN_PARSE_ru',
    'PARSE_COMPLETED_SUCCESSFULLY_en',
    'PARSE_COMPLETED_SUCCESSFULLY_ru',
    'UNKNOWN_RECORD_TYPE_en',
    'UNKNOWN_RECORD_TYPE_ru',
    'DATETIME_CHANGE_IS_FOUND_en',
    'DATETIME_CHANGE_IS_FOUND_ru',
    'OLD_TIME_en',
    'OLD_TIME_ru',
    'NEW_TIME_en',
    'NEW_TIME_ru',
    'REASON_CLOCK_CORRECTION_en',
    'REASON_CLOCK_CORRECTION_ru',
    'REASON_SUMMER_WINTER_TIME_en',
    'REASON_SUMMER_WINTER_TIME_ru',
    'REASON_UNKNOWN_en',
    'REASON_UNKNOWN_ru',

  { Warnings }
    'WARNING_en',
    'WARNING_ru',
    'INFORMATION_en',
    'INFORMATION_ru',
    'IS_NOT_VALID_SI3000_FILE_en',
    'IS_NOT_VALID_SI3000_FILE_ru',
    'TOTAL_PARSED_en',
    'TOTAL_PARSED_ru',
    'ERROR_DURING_PARSING_en',
    'ERROR_DURING_PARSING_ru'
  );
  CONST_VALUES: array[0..27] of string = (
    'Begin parse "%s".',
    '�������������� ���� "%s".',
    'Parse completed succesfully.',
    '��������� ��������� �������.',
    'Unknown record type: %d.',
    '����������� ��� ������: %d.',
    'Datetime change record is found (%d).',
    '������� ������ �� ��������� ����/������� ����������� (%d).',
    '    Old datetime: %s.',
    '    ������ ����/�����: %s.',
    '    New datetime: %s.',
    '    ����� ����/�����: %s.',
    '    Reason: real-time clock correction.',
    '    �������: ������������� ������� ��.',
    '    Reason: summer/winter time.',
    '    �������: ������� �� ������/������ �����.',
    '    Reason: unknown.',
    '    �������: �� ����������.',

    'Warning',
    '��������������',
    'Information',
    '����������',
    '"%s" is not valid SI300 file.',
    '"%s" �� �������� ���������� SI3000 ������.',
    'Total parsed %d records.',
    '����� ���������� %d �������.',
    'An error occurred during parsing file "%s"! The file is corrupted probably.',
    '��������� ������ ��� ������� ����� "%s"! �������� ���� ���������.'
  );

function GetAMessage(AName, ALang: string): string;

implementation

uses StrUtils;

function GetAMessage(AName, ALang: string): string;
var
  idx: Integer;
begin
  Result := '??' + AName + '??';
  idx := AnsiIndexStr(AName + '_' + ALang, CONST_NAMES);
  if idx <> -1 then
    Result := CONST_VALUES[idx];
end;

end.

