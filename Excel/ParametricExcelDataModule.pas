unit ParametricExcelDataModule;

interface

uses
  System.SysUtils, System.Classes, ExcelDataModule, Excel2010, Vcl.OleServer,
  CustomExcelTable, Data.DB, System.Generics.Collections,
  FieldInfoUnit, SearchComponentOrFamilyQuery, SearchFamily,
  ComponentTypeSetUnit;

{$WARN SYMBOL_PLATFORM OFF}

type
  TParametricExcelTable = class(TCustomExcelTable)
  private
    FComponentTypeSet: TComponentTypeSet;
    FqSearchComponentOrFamily: TQuerySearchComponentOrFamily;
    function GetComponentName: TField;
    // TODO: GetIDBodyType
    // function GetIDBodyType: TField;
    function GetIDComponent: TField;
    function GetIDParentComponent: TField;
    function GetqSearchComponentOrFamily: TQuerySearchComponentOrFamily;
  protected
    function CheckComponent: Boolean;
    procedure CreateFieldDefs; override;
    property qSearchComponentOrFamily: TQuerySearchComponentOrFamily read
        GetqSearchComponentOrFamily;
  public
    constructor Create(AOwner: TComponent; AFieldsInfo: TList<TFieldInfo>;
        AComponentTypeSet: TComponentTypeSet); reintroduce;
    function CheckRecord: Boolean; override;
    class function GetFieldNameByParamSubParamID(AParamSubParamID: Integer):
        String; static;
    function GetParamSubParamIDByFieldName(AFieldName: string; out
        AParamSubParamID: Integer): Boolean;
    property ComponentName: TField read GetComponentName;
    property ComponentTypeSet: TComponentTypeSet read FComponentTypeSet;
    property IDComponent: TField read GetIDComponent;
    property IDParentComponent: TField read GetIDParentComponent;
  end;

  TParametricExcelDM = class(TExcelDM)
  private
    FComponentTypeSet: TComponentTypeSet;
    FFieldsInfo: TList<TFieldInfo>;
    function GetExcelTable: TParametricExcelTable;
    { Private declarations }
  protected
    function CreateExcelTable: TCustomExcelTable; override;
  public
    constructor Create(AOwner: TComponent; AFieldsInfo: TList<TFieldInfo>;
        AComponentTypeSet: TComponentTypeSet); reintroduce; overload;
    property ExcelTable: TParametricExcelTable read GetExcelTable;
    { Public declarations }
  end;

implementation

{ %CLASSGROUP 'Vcl.Controls.TControl' }

{$R *.dfm}

uses ProgressInfo, System.Variants, ErrorType;

const
  FParamPrefix = 'Param';

constructor TParametricExcelTable.Create(AOwner: TComponent; AFieldsInfo:
    TList<TFieldInfo>; AComponentTypeSet: TComponentTypeSet);
var
  AFieldInfo: TFieldInfo;
begin
  inherited Create(AOwner);
  for AFieldInfo in AFieldsInfo do
    FieldsInfo.Add(AFieldInfo);

  FComponentTypeSet := AComponentTypeSet;
end;

function TParametricExcelTable.CheckComponent: Boolean;
var
  AErrorMessage: string;
begin
  Result := False;
  AErrorMessage := '';
  Assert(FComponentTypeSet <> []);

  // Если надо искать только среди семейств
  if FComponentTypeSet = [ctFamily] then
  begin
    // Ищем семейство компонентов
    Result := qSearchComponentOrFamily.SearchFamily(ComponentName.AsString) > 0;
    if not Result then
      AErrorMessage := 'Семейство компонентов с таким именем не найдено';
  end;

  // Ищем компонент
  if FComponentTypeSet = [ctComponent] then
  begin
    Result := qSearchComponentOrFamily.SearchComponent(ComponentName.AsString) > 0;
    if not Result then
      AErrorMessage := 'Компонент с таким именем не найден';
  end;

  if FComponentTypeSet = [ctComponent, ctFamily] then
  begin
    Result := qSearchComponentOrFamily.SearchByValue(ComponentName.AsString) > 0;
    if not Result then
      AErrorMessage := 'Семейство или компонент с таким именем не найден';
  end;

  Edit;

  if Result then
  begin
    IDComponent.AsInteger := qSearchComponentOrFamily.PK.AsInteger;
    IDParentComponent.AsInteger :=
      qSearchComponentOrFamily.ParentProductID.AsInteger;
  end
  else
  begin
    // Запоминаем, что в этой строке ошибка
    ErrorType.AsInteger := Integer(etError);

    Errors.AddError(ExcelRow.AsInteger, ComponentName.Index + 1,
      ComponentName.AsString, AErrorMessage);
  end;

  Post;
end;

function TParametricExcelTable.CheckRecord: Boolean;
begin
  Result := inherited;
  if Result then
  begin
    // Проверяем что такой компонент существует
    Result := CheckComponent;
  end;
end;

procedure TParametricExcelTable.CreateFieldDefs;
begin
  inherited;
  // При проверке, будем заполнять идентификатор компонента
  FieldDefs.Add('IDComponent', ftInteger);
  FieldDefs.Add('IDParentComponent', ftInteger);
end;

function TParametricExcelTable.GetComponentName: TField;
begin
  Result := FieldByName(FieldsInfo[0].FieldName);
end;

class function TParametricExcelTable.GetFieldNameByParamSubParamID(
    AParamSubParamID: Integer): String;
begin
  Assert(AParamSubParamID > 0);
  Assert(not FParamPrefix.IsEmpty);

  Result := Format('%s_%d', [FParamPrefix, AParamSubParamID]);
end;

function TParametricExcelTable.GetIDComponent: TField;
begin
  Result := FieldByName('IDComponent');
end;

function TParametricExcelTable.GetParamSubParamIDByFieldName(AFieldName:
    string; out AParamSubParamID: Integer): Boolean;
var
  m: TArray<String>;
begin
  Assert(not FParamPrefix.IsEmpty);
  Assert(not AFieldName.IsEmpty);

  // Делим имя поля на части
  m := AFieldName.Split(['_']);
  Result := Length(m) = 2;

  if Result then
  begin
    AParamSubParamID := m[1].ToInteger;
    Assert(AParamSubParamID > 0);
  end
  else
  begin
    Assert(Length(m) = 1);
    AParamSubParamID := 0;
  end;
end;

function TParametricExcelTable.GetIDParentComponent: TField;
begin
  Result := FieldByName('IDParentComponent');
end;

function TParametricExcelTable.GetqSearchComponentOrFamily:
    TQuerySearchComponentOrFamily;
begin
  if FqSearchComponentOrFamily = nil then
    FqSearchComponentOrFamily := TQuerySearchComponentOrFamily.Create(Self);

  Result := FqSearchComponentOrFamily;
end;

constructor TParametricExcelDM.Create(AOwner: TComponent; AFieldsInfo:
    TList<TFieldInfo>; AComponentTypeSet: TComponentTypeSet);
begin
  Assert(AFieldsInfo <> nil);
  FFieldsInfo := AFieldsInfo;
  FComponentTypeSet := AComponentTypeSet;

  Create(AOwner);
end;

function TParametricExcelDM.CreateExcelTable: TCustomExcelTable;
begin
  Assert(FFieldsInfo <> nil);
  Result := TParametricExcelTable.Create(Self, FFieldsInfo, FComponentTypeSet);
end;

function TParametricExcelDM.GetExcelTable: TParametricExcelTable;
begin
  Result := CustomExcelTable as TParametricExcelTable;
end;

end.
