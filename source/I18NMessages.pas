unit I18NMessages;


interface

const
  CONST_NAMES: array[0..5] of string = (
  { Log messages }
    'BEGIN_PARSE_en',
    'BEGIN_PARSE_ru',

  { Warnings }
    'WARNING_en',
    'WARNING_ru',
    'IS_NOT_VALID_SI3000_FILE_en',
    'IS_NOT_VALID_SI3000_FILE_ru'
  );
  CONST_VALUES: array[0..5] of string = (
    'Begin parse %s.',
    'Обрабатывается файл %s.',

    'Warning',
    'Предупреждение',
    '%s is not valid SI300 file.',
    '%s не является корректным SI3000 файлом.'
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

