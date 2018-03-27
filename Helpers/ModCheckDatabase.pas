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

    // ������� ������ ��
    Result := AUpdateConnection.ExecSQLScalar('select version from dbVersion');

    // ���� � ��� � ��� ��������� ������ �� ��� ������ �� ������ ��� ����
    if Result >= ALastVersion then
      Exit;

    // ���� ������� ������ �� �� ���������
    while Result < ALastVersion do
    begin
      // �������� ��������� ������ ��� ���������� ��
      ASQL := GetUpdateScript(Result + 1, ADBMigrationFolder);
      m := ASQL.Split([#13#10#13#10]);

      // �������� ����������
      AUpdateConnection.StartTransaction;
      try

        for s in m do
        begin
          ASQL := s.Trim([' ', #13, #10]);
          if ASQL.IsEmpty then Continue;
          AUpdateConnection.ExecSQL(ASQL); // ��������� ���������� ��������� ��
        end;

        AUpdateConnection.ExecSQL // ��������� ���������� ������ ��
          (String.Format('update dbVersion set version = %d', [Result + 1]));
      except
        // ���� �� ����� ���������� ��������� �� ��������� ������
        AUpdateConnection.Rollback;
        raise;
      end;
      AUpdateConnection.Commit;
      // ������� � ��������� ������ ������ �������!
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
        ('���������� ���������� ���������� ���� ������.'#13#10'�� ������� ���� %s.',
        [AFileName]);
    end;
  end
  else
    raise Exception.Create
      ('���������� ���������� ���������� ���� ������.'#13#10'�� ������� ����� Update.');
end;

end.
