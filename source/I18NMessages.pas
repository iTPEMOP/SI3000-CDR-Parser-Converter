unit I18NMessages;


interface

const
  CONST_NAMES: array[0..65] of string = (
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
    'LOSS_RECORD_IS_FOUND_en',
    'LOSS_RECORD_IS_FOUND_ru',
    'LOSS_START_TIME_en',
    'LOSS_START_TIME_ru',
    'LOSS_END_TIME_en',
    'LOSS_END_TIME_ru',
    'TOTAL_RECORDS_ARE_LOST_en',
    'TOTAL_RECORDS_ARE_LOST_ru',
    'REBOOT_RECORD_IS_FOUND_en',
    'REBOOT_RECORD_IS_FOUND_ru',
    'REBOOT_TIME_en',
    'REBOOT_TIME_ru',
    'CALL_DATA_RECORD_IS_FOUND_en',
    'CALL_DATA_RECORD_IS_FOUND_ru',
    'CDR_LENGTH_en',
    'CDR_LENGTH_ru',
    'FIXED_DATA_en',
    'FIXED_DATA_ru',
    'SI_en',
    'SI_ru',
    'CI_en',
    'CI_ru',
    'FL_en',
    'FL_ru',
    'SQ_en',
    'SQ_ru',
    'CS_en',
    'CS_ru',
    'ACL_en',
    'ACL_ru',
    'DNL_en',
    'DNL_ru',
    'DN_en',
    'DN_ru',

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
    'ERROR_DURING_PARSING_ru',
    'LOG_IS_EMPTY_en',
    'LOG_IS_EMPTY_ru',
    'LOG_HAS_BEEN_SAVED_en',
    'LOG_HAS_BEEN_SAVED_ru'
  );
  CONST_VALUES: array[0..65] of string = (
    'Begin parse "%s".',
    'Обрабатывается файл "%s".',
    'Parse completed succesfully.',
    'Обработка завершена успешно.',
    'Unknown record type: %d.',
    'Неизвестный тип записи: %d.',
    'Datetime change record is found (%d).',
    'Найдена запись об изменении даты/времени коммутатора (%d).',
    '    Old datetime: %s.',
    '    Старые дата/время: %s.',
    '    New datetime: %s.',
    '    Новые дата/время: %s.',
    '    Reason: real-time clock correction.',
    '    Причина: корректировка времени ПК.',
    '    Reason: summer/winter time.',
    '    Причина: переход на летнее/зимнее время.',
    '    Reason: unknown.',
    '    Причина: не определена.',
    'Loss record is found (%d).',
    'Найдена запись о потере определенного числа записей (%d).',
    '    Start time: %s.',
    '    Начало потерь: %s.',
    '    End time: %s',
    '    Окончание потерь: %s',
    '    Total records are lost: %d.',
    '    Всего записей потеряно: %d.',
    'Reboot record is found (%d).',
    'Найдена запись о перезагрузке коммутатора (%d).',
    '    Reboot time: %s',
    '    Время перезагрузки: %s',
    'Call data racord is found (%d).',
    'Найдена запись о вызове (%d).',
    '  CDR length (bytes): %u',
    '  Длина этой записи (байт): %u',
    '                  ~~~~ Fixed part ~~~~',
    '                  ~~~~ Фиксированная часть записи ~~~~',
    '    SI - serial CRD index: %u',
    '    SI - индекс записи: %u',
    '    CI - call identifier: %u',
    '    CI - идентификатор вызова: %u',
    '    FL - flags: "%s"',
    '    FL - флаги вызова: "%s"',
    '    SQ - record sequence: %u',
    '    SQ - последовательность записи: %u',
    '    CS - charge status: %u',
    '    CS - статус расчета: %u',
    '    ACL - area zone length (digits): %u',
    '    ACL - длина кода зоны (цифр): %u',
    '    DNL - directory (owner) number length (digits): %u',
    '    DNL - длина абонентского номера (цифр): %u',
    '  Owner''s full number. AC - area code: "%s", DN - directory number: "%s"',
    '  Полный номер владельца. AC - код зоны: "%s", DN - номер телефона: "%s"',

    'Warning',
    'Предупреждение',
    'Information',
    'Информация',
    '"%s" is not valid SI300 file.',
    '"%s" не является корректным SI3000 файлом.',
    'Total parsed %d records.',
    'Всего обработано %d записей.',
    'An error occurred during parsing file "%s"! The file is corrupted probably.',
    'Произошла ошибка при анализе файла "%s"! Возможно файл поврежден.',
    'Log is empty!',
    'Лог работы парсера пуст!',
    'Log has been saved.',
    'Лог работы парсера сохранен успешно.'
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

