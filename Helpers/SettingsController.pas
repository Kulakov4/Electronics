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
    function GetCategoryID: Integer;
    function GetComponentsDrawingFolder: String;
    function GetComponentsImageFolder: String;
    function GetComponentsDiagramFolder: String;
    function GetComponentsDatasheetFolder: String;
    function GetWareHouseDiagramFolder: String;
    function GetWareHouseDrawingFolder: String;
    function GetWareHouseImageFolder: String;
    function GetWareHouseDatasheetFolder: String;
    function GetDataBasePath: string;
    function GetDBMigrationFolder: string;
    function GetLastFolderForComponentsLoad: string;
    function GetIniFile: TIniFile;
    function GetParametricDataFolder: string;
    function GetLastFolderForExcelFile: string;
    function GetProducer: String;
    function GetRate: Double;
    function GetLoadLastCategory: Boolean;
    procedure SetBodyTypesLandPatternFolder(const Value: string);
    procedure SetBodyTypesOutlineDrawingFolder(const Value: string);
    procedure SetBodyTypesImageFolder(const Value: string);
    procedure SetCategoryID(const Value: Integer);
    procedure SetComponentsDrawingFolder(const Value: String);
    procedure SetComponentsImageFolder(const Value: String);
    procedure SetComponentsDiagramFolder(const Value: String);
    procedure SetComponentsDatasheetFolder(const Value: String);
    procedure SetWareHouseDiagramFolder(const Value: String);
    procedure SetWareHouseDrawingFolder(const Value: String);
    procedure SetWareHouseImageFolder(const Value: String);
    procedure SetWareHouseDatasheetFolder(const Value: String);
    procedure SetDataBasePath(const Value: string);
    procedure SetDBMigrationFolder(const Value: string);
    procedure SetLastFolderForComponentsLoad(const Value: string);
    procedure SetParametricDataFolder(const Value: string);
    procedure SetLastFolderForExcelFile(const Value: string);
    procedure SetProducer(const Value: String);
    procedure SetRate(const Value: Double);
    procedure SetLoadLastCategory(const Value: Boolean);
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
    procedure SetValue(const ASection, AParameter: string;
      const Value: Variant);
    property BodyTypesLandPatternFolder: string
      read GetBodyTypesLandPatternFolder write SetBodyTypesLandPatternFolder;
    property BodyTypesOutlineDrawingFolder: string
      read GetBodyTypesOutlineDrawingFolder
      write SetBodyTypesOutlineDrawingFolder;
    property BodyTypesImageFolder: string read GetBodyTypesImageFolder
      write SetBodyTypesImageFolder;
    property CategoryID: Integer read GetCategoryID write SetCategoryID;
    property ComponentsDrawingFolder: String read GetComponentsDrawingFolder
      write SetComponentsDrawingFolder;
    property ComponentsImageFolder: String read GetComponentsImageFolder
      write SetComponentsImageFolder;
    property ComponentsDiagramFolder: String read GetComponentsDiagramFolder
      write SetComponentsDiagramFolder;
    property ComponentsDatasheetFolder: String read GetComponentsDatasheetFolder
      write SetComponentsDatasheetFolder;
    property WareHouseDiagramFolder: String read GetWareHouseDiagramFolder
      write SetWareHouseDiagramFolder;
    property WareHouseDrawingFolder: String read GetWareHouseDrawingFolder
      write SetWareHouseDrawingFolder;
    property WareHouseImageFolder: String read GetWareHouseImageFolder
      write SetWareHouseImageFolder;
    property WareHouseDatasheetFolder: String read GetWareHouseDatasheetFolder
      write SetWareHouseDatasheetFolder;
    property DataBasePath: string read GetDataBasePath write SetDataBasePath;
    property DBMigrationFolder: string read GetDBMigrationFolder
      write SetDBMigrationFolder;
    property LastFolderForComponentsLoad: string
      read GetLastFolderForComponentsLoad write SetLastFolderForComponentsLoad;
    property ParametricDataFolder: string read GetParametricDataFolder
      write SetParametricDataFolder;
    property LastFolderForExcelFile: string read GetLastFolderForExcelFile
      write SetLastFolderForExcelFile;
    property Producer: String read GetProducer write SetProducer;
    property Rate: Double read GetRate write SetRate;
    property LoadLastCategory: Boolean read GetLoadLastCategory write
        SetLoadLastCategory;
  end;

implementation

uses ProjectConst, System.IOUtils, System.Variants;

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

function TSettings.GetCategoryID: Integer;
begin
  Result := StrToIntDef( GetValue('Db', 'CategoryID', '0'), 0);
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

function TSettings.GetWareHouseDiagramFolder: String;
begin
  Result := GetPath('WareHouse', 'DiagramFolder',
    TPath.Combine(sWareHouseFolder, sComponentsDiagramFolder));
end;

function TSettings.GetWareHouseDrawingFolder: String;
begin
  Result := GetPath('WareHouse', 'DrawingFolder',
    TPath.Combine(sWareHouseFolder, sComponentsDrawingFolder));
end;

function TSettings.GetWareHouseImageFolder: String;
begin
  Result := GetPath('WareHouse', 'ImageFolder', TPath.Combine(sWareHouseFolder,
    sComponentsImageFolder));
end;

function TSettings.GetWareHouseDatasheetFolder: String;
begin
  Result := GetPath('WareHouse', 'DatasheetFolder',
    TPath.Combine(sWareHouseFolder, sComponentsDatasheetFolder));
end;

function TSettings.GetDataBasePath: string;
begin
  Result := GetValue('Db', 'databasePath');
end;

function TSettings.GetDBMigrationFolder: string;
var
  ADefaultFolder: string;
begin
  ADefaultFolder := TPath.Combine(TPath.GetDirectoryName(Application.ExeName),
    'update');
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

function TSettings.GetProducer: String;
begin
  Result := GetValue('Producer', 'Producer', '');
end;

function TSettings.GetRate: Double;
begin
  Result := StrToFloatDef(GetValue('Rate', 'Rate', FloatToStr(DefaultRate)),
    DefaultRate);
end;

function TSettings.GetLoadLastCategory: Boolean;
begin
  Result := StrToBool( GetValue('Settings', 'LoadLastCategory', 'True') );
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

procedure TSettings.SetCategoryID(const Value: Integer);
begin
  SetValue('Db', 'CategoryID', Value);
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

procedure TSettings.SetWareHouseDiagramFolder(const Value: String);
begin
  SetValue('WareHouse', 'DiagramFolder', Value);
end;

procedure TSettings.SetWareHouseDrawingFolder(const Value: String);
begin
  SetValue('WareHouse', 'DrawingFolder', Value);
end;

procedure TSettings.SetWareHouseImageFolder(const Value: String);
begin
  SetValue('WareHouse', 'ImageFolder', Value);
end;

procedure TSettings.SetWareHouseDatasheetFolder(const Value: String);
begin
  SetValue('WareHouse', 'DatasheetFolder', Value);
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

procedure TSettings.SetProducer(const Value: String);
begin
  if Producer <> Value then
  begin
    SetValue('Producer', 'Producer', Value);
  end;
end;

procedure TSettings.SetRate(const Value: Double);
begin
  SetValue('Rate', 'Rate', Value);
end;

procedure TSettings.SetLoadLastCategory(const Value: Boolean);
begin
  SetValue('Settings', 'LoadLastCategory', Value);
end;

procedure TSettings.SetValue(const ASection, AParameter: string;
  const Value: Variant);
var
  AIniFile: TIniFile;
begin
  if FFileName.IsEmpty then
    Exit;

  AIniFile := TIniFile.Create(FFileName);
  try
    if VarIsStr(Value) then
      AIniFile.WriteString(ASection, AParameter, Value);
    if VarIsFloat(Value) then
      AIniFile.WriteFloat(ASection, AParameter, Value);
    if VarIsNumeric(Value) then
      AIniFile.WriteInteger(ASection, AParameter, Value);
    if VarIsType(Value, varBoolean) then
      AIniFile.WriteBool(ASection, AParameter, Value);
  finally
    AIniFile.Free;
  end;
end;

end.
