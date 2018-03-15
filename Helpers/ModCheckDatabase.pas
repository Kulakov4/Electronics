unit ModCheckDatabase;

interface

uses
  FireDAC.Comp.Client, System.SysUtils, System.Classes, Vcl.Forms,
  System.IOUtils;

type
  TDBMigration = class(TObject)
  private
    class function ExecUpdateScript(AFDConnection: TFDConnection;
      Version: Integer; ADBMigrationFolder: String): Boolean; static;
  public
    class function UpdateDatabaseStructure(AFDConnection: TFDConnection;
        ADBMigrationFolder: String; ALastVersion: Integer): Integer; static;
  end;

implementation

class function TDBMigration.UpdateDatabaseStructure(AFDConnection:
    TFDConnection; ADBMigrationFolder: String; ALastVersion: Integer): Integer;
var
  AUpdateConnection: TFDConnection;
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

    // ��������� ������
    Inc(Result);

    // ���� ���� SQL ������ ��� ��������� ������
    while ExecUpdateScript(AUpdateConnection, Result, ADBMigrationFolder) do
    begin
//      Inc(Result);
      AUpdateConnection.ExecSQL // ��������� ���������� ��
        (String.Format('update dbVersion set version = %d', [Result]));
      AUpdateConnection.Commit;

      Inc(Result);
    end;
    AUpdateConnection.Connected := False;
  finally
    FreeAndNil(AUpdateConnection);
  end;
end;

class function TDBMigration.ExecUpdateScript(AFDConnection: TFDConnection;
  Version: Integer; ADBMigrationFolder: String): Boolean;
var
  AFileName: string;
  S: string;
begin
  Assert(AFDConnection <> nil);
  Assert(AFDConnection.Connected);
  Assert(not ADBMigrationFolder.IsEmpty);

  if TDirectory.Exists(ADBMigrationFolder) then
  begin
    AFileName := TPath.Combine(ADBMigrationFolder, Format('%d.sql', [Version]));
    if TFile.Exists(AFileName) then
    begin
      S := TFile.ReadAllText(AFileName);
      AFDConnection.ExecSQL(S);
      AFDConnection.Commit;
      Result := True;
    end
    else
    begin
      Result := False;
    end;
  end
  else
    raise Exception.Create
      ('���������� ���������� ���������� ���� ������.'#13#10'�� ������� ����� Update.');
end;

end.
