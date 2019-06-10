unit DataBaseUnit;

interface

uses
  FireDAC.Comp.Client;

type
  TDataBase = class(TObject)
  private
    class procedure CreateNewDataBase(const ADataBaseFolder, AApplicationFolder
      : String); static;
    class function CreateTempDatabaseFileName: string; static;
    class function DatabaseFileName: string; static;
    class function GetDataBaseFile(const ADataBaseFolder: String;
      var AFileName: string; var AVersion: Double; AMaxVersion: Double)
      : Boolean; static;
    class function EmptyDatabaseFileName: string; static;
    class function GetUpdateScript(Version: Integer; ADBMigrationFolder: String)
      : string; static;
    class function UpdateDatabaseStructure(ADBMigrationFolder: String;
      ALastVersion: Integer; const ADataBaseFileName: String): Integer; static;
  protected
  public
    class function OpenDBConnection(AConnection: TFDConnection;
      const ADataBaseFolder, ADBMigrationFolder, AApplicationFolder: String)
      : Boolean; static;
  end;

implementation

uses
  System.Types, System.IOUtils, System.SysUtils, ProjectConst, DialogUnit,
  VersionQuery;

class procedure TDataBase.CreateNewDataBase(const ADataBaseFolder,
  AApplicationFolder: String);
var
  ADataBaseFileName: string;
  AEmptyDatabaseFileName: string;
begin
  // определяемся с именем файла "пустой" базы данных
  AEmptyDatabaseFileName := TPath.Combine(AApplicationFolder,
    EmptyDatabaseFileName);

  if not TFile.Exists(AEmptyDatabaseFileName) then
    raise Exception.Create(Format('Не могу создать пустую базу данных.' + #13#10
      + 'Не найден файл %s', [EmptyDatabaseFileName]));

  // Формируем полное имя базы данных
  ADataBaseFileName := TPath.Combine(ADataBaseFolder, DatabaseFileName);

  TFile.Copy(AEmptyDatabaseFileName, ADataBaseFileName);
end;

class function TDataBase.CreateTempDatabaseFileName: string;
begin
  Result := FormatDateTime('"database "yyyy-mm-dd" "hh-nn-ss".db"', Now);
end;

class function TDataBase.GetDataBaseFile(const ADataBaseFolder: String;
  var AFileName: string; var AVersion: Double; AMaxVersion: Double): Boolean;
var
  AMaxVer: Double;
  AMaxVerFileName: string;
  m: TStringDynArray;
begin
  Assert(not ADataBaseFolder.IsEmpty);
  Result := False;
  AMaxVer := 0;
  AMaxVerFileName := '';

  // Ищем какую-либо версию базы данных
  m := TDirectory.GetFiles(ADataBaseFolder,
    function(const Path: string; const SearchRec: TSearchRec): Boolean
    Var
      AExt: String;
      AFile_Name: string;
      StrArr: TArray<String>;
      AVer: Double;
    begin
      Result := False;
      AExt := TPath.GetExtension(SearchRec.Name);

      if AExt <> '.db' then
        Exit;

      AFile_Name := TPath.GetFileNameWithoutExtension(SearchRec.Name);
      if (AFile_Name.ToLower = 'database') and (AMaxVer = 0) then
      begin
        AMaxVer := 1;
        AMaxVerFileName := SearchRec.Name;
        Result := True;
        Exit;
      end;

      StrArr := AFile_Name.ToLower.Split(['_']);
      if (Length(StrArr) <> 2) or (StrArr[0] <> 'database') then
        Exit;

      AVer := StrToFloatDef(StrArr[1].Replace('.', ','), 0);

      if AVer = 0 then
        Exit;

      if (AVer > AMaxVer) and (AVer <= AMaxVersion) then
      begin
        AMaxVer := AVer;
        AMaxVerFileName := SearchRec.Name;
        Result := True;
        Exit;
      end;
    end);

  // Не нашли ни одного подходящего файла
  if AMaxVerFileName = '' then
    Exit;

  AFileName := TPath.Combine(ADataBaseFolder, AMaxVerFileName);
  AVersion := AMaxVer;
  Result := True;
end;

class function TDataBase.DatabaseFileName: string;
begin
  Result := Format('database_%.1f', [ProgramVersion]).Replace(',', '.') + '.db';
end;

class function TDataBase.EmptyDatabaseFileName: string;
begin
  Result := Format('database_empty_%.1f', [ProgramVersion])
    .Replace(',', '.') + '.db';
end;

class function TDataBase.GetUpdateScript(Version: Integer;
ADBMigrationFolder: String): string;
var
  AFileName: string;
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

class function TDataBase.OpenDBConnection(AConnection: TFDConnection;
const ADataBaseFolder, ADBMigrationFolder, AApplicationFolder: String): Boolean;
var
  ADBVersion: Integer;
  AFileName: string;
  ANewFileName: string;
  AVersion: Double;
begin
  Result := False;
  Assert(AConnection <> nil);
  Assert(not ADataBaseFolder.IsEmpty);
  Assert(not ADBMigrationFolder.IsEmpty);
  Assert(not AApplicationFolder.IsEmpty);

  try
    // Ищем подходящий нам файл базы данных
    if GetDataBaseFile(ADataBaseFolder, AFileName, AVersion, ProgramVersion)
    then
    begin
      // Если подходящий файл базы данных найден
      Assert(AVersion <= ProgramVersion);

      if AVersion < ProgramVersion then
      begin
        Result := TDialog.Create.UpdateDataBaseDialog(AVersion, ProgramVersion);
        // Отказались от обновления БД
        if not Result then
          Exit;

        ANewFileName := TPath.Combine(ADataBaseFolder,
          CreateTempDatabaseFileName);

        TFile.Copy(AFileName, ANewFileName);
        try
          // Обновляем структуру БД
          UpdateDatabaseStructure(ADBMigrationFolder, DBVersion, ANewFileName);

        except
          // При обновлении версии БД произошла какая-то ошибка
          on E: Exception do
          begin
            // Удаляем временный файл
            try
              TFile.Delete(ANewFileName);
            except
              ;
            end;
            raise Exception.CreateFmt
              ('Ошибка при обновлении структуры базы данных.'#13#10'%s',
              [E.Message]);
          end;
        end;

        if not RenameFile(ANewFileName, DatabaseFileName) then
          raise Exception.CreateFmt('Не могу переименовать файл %s в %s',
            [ANewFileName, DatabaseFileName]);
      end;
    end
    else
    begin
      Result := TDialog.Create.CreateNewDatabaseDialog;
      // Отказались от создания новой базы данных
      if not Result then
        Exit;

      // Создаём новую БД
      CreateNewDataBase(ADataBaseFolder, AApplicationFolder);
    end;

    // Если дошли до этого места, значит файл базы данных или был обновлён, или создан, или сразу существовал
    if not TFile.Exists(DatabaseFileName) then
      raise Exception.CreateFmt('Не найден файл базы данных %s',
        [DatabaseFileName]);

    AConnection.DriverName := sDriverName;
    AConnection.Params.DriverID := sDriverName;
    AConnection.Params.Database := DatabaseFileName;
    // Устанавливаем соединение с БД
    AConnection.Open();

    // Проверяем версию БД в самой БД
    ADBVersion := TQueryVersion.GetDBVersion;
    if ADBVersion <> DBVersion then
    begin
      raise Exception.CreateFmt
        ('Неверная версия базы данных (надо %d, имеем %d)',
        [DBVersion, ADBVersion]);
    end;

    Result := True;
  except
    on E: Exception do
    begin
      Result := False;
      TDialog.Create.ErrorMessageDialog(E.Message);
    end;
  end;
end;

class function TDataBase.UpdateDatabaseStructure(ADBMigrationFolder: String;
ALastVersion: Integer; const ADataBaseFileName: String): Integer;
var
  ASQL: string;
  AUpdateConnection: TFDConnection;
  m: TArray<String>;
  s: string;
begin
  Assert(ALastVersion > 0);
  Assert(not ADBMigrationFolder.IsEmpty);

  AUpdateConnection := TFDConnection.Create(nil);
  try
    AUpdateConnection.DriverName := sDriverName;
    AUpdateConnection.Params.Database := ADataBaseFileName;
    // AUpdateConnection.Params.DriverID := sDriverName;
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
          if ASQL.IsEmpty then
            Continue;
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

end.
