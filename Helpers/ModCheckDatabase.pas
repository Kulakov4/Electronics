unit ModCheckDatabase;

interface

uses
  FireDAC.Comp.Client, System.SysUtils, System.Classes, Vcl.Forms,
  System.IOUtils;

type
  TDBMigration = class(TObject)
  private
    class function GetUpdateScript(Version: Integer; ADBMigrationFolder: String)
      : string; static;
  public
    class function UpdateDatabaseStructure(AFDConnection: TFDConnection;
      ADBMigrationFolder: String; ALastVersion: Integer): Integer; static;
  end;

implementation

class function TDBMigration.UpdateDatabaseStructure(AFDConnection
  : TFDConnection; ADBMigrationFolder: String; ALastVersion: Integer): Integer;
var
  ASQL: string;
  AUpdateConnection: TFDConnection;
  m: TArray<String>;
  s: string;
begin
  Assert(AFDConnection <> nil);
  Assert(ALastVersion > 0);
  Assert(not ADBMigrationFolder.IsEmpty);

  AUpdateConnection := TFDConnection.Create(nil);
  try
    AUpdateConnection.DriverName := AFDConnection.DriverName;
    AUpdateConnection.Params.database := AFDConnection.Params.database;
    AUpdateConnection.Params.DriverID := AFDConnection.Params.DriverID;
    AUpdateConnection.Connected := True;

    // Текущая версия БД
    Result := AUpdateConnection.ExecSQLScalar('select version from dbVersion');

    // Если у нас и так последняя версия БД или Версия БД больше чем надо
    if Result >= ALastVersion then
      Exit;

    // пока текущая версия БД не последняя
    while Result < ALastVersion do
    begin
      // Получаем очередной скрипт для обновления БД
      ASQL := GetUpdateScript(Result + 1, ADBMigrationFolder);
      m := ASQL.Split([#13#10#13#10]);

      // Начинаем транзакцию
      AUpdateConnection.StartTransaction;
      try

        for s in m do
        begin
          ASQL := s.Trim([' ', #13, #10]);
          if ASQL.IsEmpty then Continue;
          AUpdateConnection.ExecSQL(ASQL); // Выполняем обновление структуры БД
        end;

        AUpdateConnection.ExecSQL // Выполняем обновление версии БД
          (String.Format('update dbVersion set version = %d', [Result + 1]));
      except
        // Если во время обновления структуры БД произошла ошибка
        AUpdateConnection.Rollback;
        raise;
      end;
      AUpdateConnection.Commit;
      // Переход к следующей версии прошёл успешно!
      Inc(Result);
    end;
  finally
    AUpdateConnection.Connected := False;
    FreeAndNil(AUpdateConnection);
  end;
end;

class function TDBMigration.GetUpdateScript(Version: Integer;
  ADBMigrationFolder: String): string;
var
  AFileName: string;
  s: string;
begin
  Assert(not ADBMigrationFolder.IsEmpty);

  if TDirectory.Exists(ADBMigrationFolder) then
  begin
    AFileName := TPath.Combine(ADBMigrationFolder, Format('%d.sql', [Version]));
    if TFile.Exists(AFileName) then
    begin
      Result := TFile.ReadAllText(AFileName);
    end
    else
    begin
      raise Exception.CreateFmt
        ('Невозможно произвести обновление базы данных.'#13#10'Не найдена файл %s.',
        [AFileName]);
    end;
  end
  else
    raise Exception.Create
      ('Невозможно произвести обновление базы данных.'#13#10'Не найдена папка Update.');
end;

end.
