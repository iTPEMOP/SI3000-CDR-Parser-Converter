unit I18NMessages;


interface

const
  CONST_NAMES: array[0..15] of string = (
  { Log messages }
    'BEGIN_PARSE_en',
    'BEGIN_PARSE_ru',
    'PARSE_COMPLETED_SUCCESSFULLY_en',
    'PARSE_COMPLETED_SUCCESSFULLY_ru',
    'UNKNOWN_RECORD_TYPE_en',
    'UNKNOWN_RECORD_TYPE_ru',

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
  CONST_VALUES: array[0..15] of string = (
    'Begin parse "%s".',
    '�������������� ���� "%s".',
    'Parse completed succesfully.',
    '��������� ��������� �������.',
    'Unknown record type: %d.',
    '����������� ��� ������: %d.',

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

