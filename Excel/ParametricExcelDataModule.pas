unit ParametricExcelDataModule;

interface

uses
  System.SysUtils, System.Classes, ExcelDataModule, Excel2010, Vcl.OleServer,
  CustomExcelTable, Data.DB, System.Generics.Collections,
  FieldInfoUnit, SearchComponentOrFamilyQuery, SearchFamily;

{$WARN SYMBOL_PLATFORM OFF}

type
  TParametricExcelTable = class(TCustomExcelTable)
  private
    FFamily: Boolean;
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
    constructor Create(AOwner: TComponent; AFieldsInfo: TList<TFieldInfo>; AFamily:
        Boolean); reintroduce;
    function CheckRecord: Boolean; override;
    class function GetFieldNameByIDParam(AIDParameter, AIDParentParameter
      : Integer): String; static;
    function GetIDParamByFieldName(AFieldName: string;
      out AIDParameter, AIDParentParameter: Integer): Boolean;
    property ComponentName: TField read GetComponentName;
    property IDComponent: TField read GetIDComponent;
    property IDParentComponent: TField read GetIDParentComponent;
  end;

  TParametricExcelDM = class(TExcelDM)
  private
    FFamily: Boolean;
    FFieldsInfo: TList<TFieldInfo>;
    function GetExcelTable: TParametricExcelTable;
    { Private declarations }
  protected
    function CreateExcelTable: TCustomExcelTable; override;
  public
    constructor Create(AOwner: TComponent; AFieldsInfo: TList<TFieldInfo>; AFamily:
        Boolean); reintroduce; overload;
    property ExcelTable: TParametricExcelTable read GetExcelTable;
    { Public declarations }
  end;

implementation

{ %CLASSGROUP 'Vcl.Controls.TControl' }

{$R *.dfm}

uses ProgressInfo, System.Variants;

const
  FParamPrefix = 'Param';

constructor TParametricExcelTable.Create(AOwner: TComponent; AFieldsInfo:
    TList<TFieldInfo>; AFamily: Boolean);
var
  AFieldInfo: TFieldInfo;
begin
  inherited Create(AOwner);
  for AFieldInfo in AFieldsInfo do
    FieldsInfo.Add(AFieldInfo);

  FFamily := AFamily;
end;

function TParametricExcelTable.CheckComponent: Boolean;
var
  AErrorMessage: string;
begin
  AErrorMessage := '';

  // Если надо искать только среди семейств
  if FFamily then
  begin
    // Ищем семейство компонентов
    Result := qSearchComponentOrFamily.SearchFamily(ComponentName.AsString) > 0;
    if not Result then
      AErrorMessage := 'Семейство компонентов с таким именем не найдено';
  end
  else
  begin
    // Ищем компонент
    Result := qSearchComponentOrFamily.SearchComponent(ComponentName.AsString) > 0;
    if not Result then
      AErrorMessage := 'Компонент с таким именем не найден';
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

class function TParametricExcelTable.GetFieldNameByIDParam(AIDParameter,
  AIDParentParameter: Integer): String;
begin
  Assert(AIDParameter > 0);
  Assert(not FParamPrefix.IsEmpty);

  Result := Format('%s_%d_%d', [FParamPrefix, AIDParameter,
    AIDParentParameter]);
end;

function TParametricExcelTable.GetIDComponent: TField;
begin
  Result := FieldByName('IDComponent');
end;

function TParametricExcelTable.GetIDParamByFieldName(AFieldName: string;
  out AIDParameter, AIDParentParameter: Integer): Boolean;
var
  m: TArray<String>;
begin
  Assert(not FParamPrefix.IsEmpty);
  Assert(not AFieldName.IsEmpty);

  // Делим имя поля на части
  m := AFieldName.Split(['_']);
  Result := Length(m) = 3;

  if Result then
  begin
    AIDParameter := m[1].ToInteger;
    Assert(AIDParameter > 0);
    AIDParentParameter := m[2].ToInteger;
  end
  else
  begin
    Assert(Length(m) = 2);
    AIDParameter := 0;
    AIDParentParameter := 0;
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
    TList<TFieldInfo>; AFamily: Boolean);
begin
  Assert(AFieldsInfo <> nil);
  FFieldsInfo := AFieldsInfo;
  FFamily := AFamily;

  Create(AOwner);
end;

function TParametricExcelDM.CreateExcelTable: TCustomExcelTable;
begin
  Assert(FFieldsInfo <> nil);
  Result := TParametricExcelTable.Create(Self, FFieldsInfo, FFamily);
end;

function TParametricExcelDM.GetExcelTable: TParametricExcelTable;
begin
  Result := CustomExcelTable as TParametricExcelTable;
end;

end.
