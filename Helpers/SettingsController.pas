unit SettingsController;

interface

uses IniFiles, SysUtils, Forms;

type
  TSettings = class(TObject)
  private
    FFileName: string;
    FIniFile: TIniFile;
    class var Instance: TSettings;
    function GetBodyTypesLandPatternFolder: string;
    function GetBodyTypesOutlineDrawingFolder: string;
    function GetBodyTypesImageFolder: string;
    function GetComponentsDrawingFolder: String;
    function GetComponentsImageFolder: String;
    function GetComponentsDiagramFolder: String;
    function GetComponentsDatasheetFolder: String;
    function GetDataBasePath: string;
    function GetDBMigrationFolder: string;
    function GetLastFolderForComponentsLoad: string;
    function GetIniFile: TIniFile;
    function GetParametricDataFolder: string;
    function GetLastFolderForExcelFile: string;
    procedure SetBodyTypesLandPatternFolder(const Value: string);
    procedure SetBodyTypesOutlineDrawingFolder(const Value: string);
    procedure SetBodyTypesImageFolder(const Value: string);
    procedure SetComponentsDrawingFolder(const Value: String);
    procedure SetComponentsImageFolder(const Value: String);
    procedure SetComponentsDiagramFolder(const Value: String);
    procedure SetComponentsDatasheetFolder(const Value: String);
    procedure SetDataBasePath(const Value: string);
    procedure SetDBMigrationFolder(const Value: string);
    procedure SetLastFolderForComponentsLoad(const Value: string);
    procedure SetParametricDataFolder(const Value: string);
    procedure SetLastFolderForExcelFile(const Value: string);
    // TODO: UpdatePath
    // function UpdatePath(const APath, ANewDBPath: string): string;
  protected
    property IniFile: TIniFile read GetIniFile;
  public
    constructor Create; virtual;
    function GetValue(const ASection, AParameter: string;
      const ADefault: string = ''): string;
    function GetPath(const ASection, AParameter, ADefaultFolder
      : string): string;
    class function NewInstance: TObject; override;
    procedure SetValue(const ASection, AParameter, Value: string);
    property BodyTypesLandPatternFolder: string
      read GetBodyTypesLandPatternFolder write SetBodyTypesLandPatternFolder;
    property BodyTypesOutlineDrawingFolder: string
      read GetBodyTypesOutlineDrawingFolder
      write SetBodyTypesOutlineDrawingFolder;
    property BodyTypesImageFolder: string read GetBodyTypesImageFolder
      write SetBodyTypesImageFolder;
    property ComponentsDrawingFolder: String read GetComponentsDrawingFolder
      write SetComponentsDrawingFolder;
    property ComponentsImageFolder: String read GetComponentsImageFolder
      write SetComponentsImageFolder;
    property ComponentsDiagramFolder: String read GetComponentsDiagramFolder
      write SetComponentsDiagramFolder;
    property ComponentsDatasheetFolder: String read GetComponentsDatasheetFolder
      write SetComponentsDatasheetFolder;
    property DataBasePath: string read GetDataBasePath write SetDataBasePath;
    property DBMigrationFolder: string read GetDBMigrationFolder write
        SetDBMigrationFolder;
    property LastFolderForComponentsLoad: string
      read GetLastFolderForComponentsLoad write SetLastFolderForComponentsLoad;
    property ParametricDataFolder: string read GetParametricDataFolder write
        SetParametricDataFolder;
    property LastFolderForExcelFile: string read GetLastFolderForExcelFile
      write SetLastFolderForExcelFile;
  end;

implementation

uses ProjectConst, System.IOUtils;

constructor TSettings.Create;
begin
  FFileName := ChangeFileExt(Application.ExeName, '.ini');
end;

function TSettings.GetBodyTypesLandPatternFolder: string;
begin
  Result := GetPath('BodyTypes', 'LandPatternFolder', sBodyLandPatternFolder);
end;

function TSettings.GetBodyTypesOutlineDrawingFolder: string;
begin
  Result := GetPath('BodyTypes', 'OutlineDrawingFolder',
    sBodyOutlineDrawingFolder);
end;

function TSettings.GetBodyTypesImageFolder: string;
begin
  Result := GetPath('BodyTypes', 'ImageFolder', sBodyImageFolder);
end;

function TSettings.GetComponentsDrawingFolder: String;
begin
  Result := GetPath('Components', 'DrawingFolder', sComponentsDrawingFolder);
end;

function TSettings.GetComponentsImageFolder: String;
begin
  Result := GetPath('Components', 'ImageFolder', sComponentsImageFolder);
end;

function TSettings.GetComponentsDiagramFolder: String;
begin
  Result := GetPath('Components', 'DiagramFolder', sComponentsDiagramFolder);
end;

function TSettings.GetComponentsDatasheetFolder: String;
begin
  Result := GetPath('Components', 'DatasheetFolder',
    sComponentsDatasheetFolder);
end;

function TSettings.GetDataBasePath: string;
begin
  Result := GetValue('Db', 'databasePath');
end;

function TSettings.GetDBMigrationFolder: string;
var
  ADefaultFolder: string;
begin
  ADefaultFolder := TPath.Combine( TPath.GetDirectoryName( Application.ExeName ), 'update');
  Result := GetValue('Db', 'DBMigrationFolder', ADefaultFolder);
end;

function TSettings.GetLastFolderForComponentsLoad: string;
begin
  Result := GetValue('Folder', 'ComponentsLoadFolder', DataBasePath);
end;

function TSettings.GetIniFile: TIniFile;
begin
  Assert(not FFileName.IsEmpty);
  if not Assigned(FIniFile) then
    FIniFile := TIniFile.Create(FFileName);

  Result := FIniFile;
end;

function TSettings.GetParametricDataFolder: string;
begin
  Result := GetValue('Folder', 'ParametricDataFolder', DataBasePath);
end;

function TSettings.GetLastFolderForExcelFile: string;
begin
  Result := GetValue('Folder', 'ExcelFileLoadFolder', DataBasePath);
end;

function TSettings.GetValue(const ASection, AParameter: string;
  const ADefault: string = ''): string;
begin
  Result := IniFile.ReadString(ASection, AParameter, ADefault);
  if Result = ADefault then
    Result := IniFile.ReadString('Db', AParameter, ADefault);
end;

function TSettings.GetPath(const ASection, AParameter, ADefaultFolder
  : string): string;
var
  ADefValue: string;
begin
  Assert(TPath.IsRelativePath(ADefaultFolder));

  // ��������� ������ ���� "�� ���������"
  ADefValue := TPath.Combine(DataBasePath, ADefaultFolder);
  Result := GetValue(ASection, AParameter, ADefValue);

  // ���� � ���������� ������-��! ���������� ������������� ���� �� �����
  if TPath.IsRelativePath(Result) then
    Result := ADefValue; // ������ ��� �� �������� �� ���������

end;

class function TSettings.NewInstance: TObject;
begin
  if not Assigned(Instance) then
    Instance := TSettings(inherited NewInstance);

  Result := Instance;
end;

procedure TSettings.SetBodyTypesLandPatternFolder(const Value: string);
begin
  SetValue('BodyTypes', 'LandPatternFolder', Value);
end;

procedure TSettings.SetBodyTypesOutlineDrawingFolder(const Value: string);
begin
  SetValue('BodyTypes', 'OutlineDrawingFolder', Value);
end;

procedure TSettings.SetBodyTypesImageFolder(const Value: string);
begin
  SetValue('BodyTypes', 'ImageFolder', Value);
end;

procedure TSettings.SetComponentsDrawingFolder(const Value: String);
begin
  SetValue('Components', 'DrawingFolder', Value);
end;

procedure TSettings.SetComponentsImageFolder(const Value: String);
begin
  SetValue('Components', 'ImageFolder', Value);
end;

procedure TSettings.SetComponentsDiagramFolder(const Value: String);
begin
  SetValue('Components', 'DiagramFolder', Value);
end;

procedure TSettings.SetComponentsDatasheetFolder(const Value: String);
begin
  SetValue('Components', 'DatasheetFolder', Value);
end;

procedure TSettings.SetDataBasePath(const Value: string);
begin
  if DataBasePath <> Value then
  begin
    {
      BodyTypesOutlineDrawingFolder := UpdatePath(BodyTypesOutlineDrawingFolder, Value);
      BodyTypesLandPatternFolder := UpdatePath(BodyTypesLandPatternFolder, Value);
      BodyTypesImageFolder := UpdatePath(BodyTypesImageFolder, Value);
      ComponentsDrawingFolder := UpdatePath( ComponentsDrawingFolder, Value );
      ComponentsImageFolder := UpdatePath( ComponentsImageFolder, Value );
      ComponentsDiagramFolder := UpdatePath( ComponentsDiagramFolder, Value );
      ComponentsDatasheetFolder := UpdatePath( ComponentsDatasheetFolder, Value );
    }
    SetValue('Db', 'databasePath', Value);
  end;
end;

procedure TSettings.SetDBMigrationFolder(const Value: string);
begin
  if DBMigrationFolder <> Value then
  begin
    SetValue('Db', 'DBMigrationFolder', Value);
  end;
end;

procedure TSettings.SetLastFolderForComponentsLoad(const Value: string);
begin
  if LastFolderForComponentsLoad <> Value then
  begin
    SetValue('Folder', 'ComponentsLoadFolder', Value);
  end;
end;

procedure TSettings.SetParametricDataFolder(const Value: string);
begin
  if ParametricDataFolder <> Value then
  begin
    SetValue('Folder', 'ParametricDataFolder', Value);
  end;
end;

procedure TSettings.SetLastFolderForExcelFile(const Value: string);
begin
  if LastFolderForExcelFile <> Value then
  begin
    SetValue('Folder', 'ExcelFileLoadFolder', Value);
  end;
end;

procedure TSettings.SetValue(const ASection, AParameter, Value: string);
var
  IniFile: TIniFile;
begin
  if FFileName.IsEmpty then
    Exit;

  IniFile := TIniFile.Create(FFileName);
  try
    IniFile.WriteString(ASection, AParameter, Value);
  finally
    IniFile.Free;
  end;
end;

// TODO: UpdatePath
// function TSettings.UpdatePath(const APath, ANewDBPath: string): string;
// var
// S: string;
// begin
// Result := APath;
//
// // ���� ���� ���������� � ���� �� ���� ������
// if APath.IndexOf(DataBasePath) = 0 then
// begin
// S := TPath.Combine(ANewDBPath, APath.Substring(DatabasePath.Length + 1));
// if TDirectory.Exists(S) then
// Result := s;
// end;
// end;

end.
