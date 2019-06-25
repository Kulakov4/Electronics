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
    FCopyCommonValueToFamily: Boolean;
    FqSearchComponentOrFamily: TQuerySearchComponentOrFamily;
    FReplace: Boolean;
    function GetComponentName: TField;
    // TODO: GetIDBodyType
    // function GetIDBodyType: TField;
    function GetIDComponent: TField;
    function GetIDParentComponent: TField;
    function GetqSearchComponentOrFamily: TQuerySearchComponentOrFamily;
  protected
    function CheckComponent: Boolean;
    procedure CreateFieldDefs; override;
    property qSearchComponentOrFamily: TQuerySearchComponentOrFamily
      read GetqSearchComponentOrFamily;
  public
    constructor Create(AOwner: TComponent; AFieldsInfo: TList<TFieldInfo>;
        AComponentTypeSet: TComponentTypeSet; AReplace, ACopyCommonValueToFamily:
        Boolean); reintroduce;
    function CheckRecord: Boolean; override;
    class function GetFieldNameByParamSubParamID(AParamSubParamID: Integer)
      : String; static;
    function GetParamSubParamIDByFieldName(AFieldName: string;
      out AParamSubParamID: Integer): Boolean;
    property ComponentName: TField read GetComponentName;
    property ComponentTypeSet: TComponentTypeSet read FComponentTypeSet;
    property CopyCommonValueToFamily: Boolean read FCopyCommonValueToFamily;
    property IDComponent: TField read GetIDComponent;
    property IDParentComponent: TField read GetIDParentComponent;
    property Replace: Boolean read FReplace;
  end;

  TParametricExcelDM = class(TExcelDM)
  private
    FComponentTypeSet: TComponentTypeSet;
    FCopyCommonValueToFamily: Boolean;
    FFieldsInfo: TList<TFieldInfo>;
    FReplace: Boolean;
    function GetExcelTable: TParametricExcelTable;
    { Private declarations }
  protected
    function CreateExcelTable: TCustomExcelTable; override;
  public
    constructor Create(AOwner: TComponent; AFieldsInfo: TList<TFieldInfo>;
        AComponentTypeSet: TComponentTypeSet; AReplace, ACopyCommonValueToFamily:
        Boolean); reintroduce; overload;
    property ExcelTable: TParametricExcelTable read GetExcelTable;
    { Public declarations }
  end;

implementation

{ %CLASSGROUP 'Vcl.Controls.TControl' }

{$R *.dfm}

uses ProgressInfo, System.Variants, ErrorType, RecordCheck;

const
  FParamPrefix = 'Param';

constructor TParametricExcelTable.Create(AOwner: TComponent; AFieldsInfo:
    TList<TFieldInfo>; AComponentTypeSet: TComponentTypeSet; AReplace,
    ACopyCommonValueToFamily: Boolean);
var
  AFieldInfo: TFieldInfo;
begin
  inherited Create(AOwner);
  for AFieldInfo in AFieldsInfo do
    FieldsInfo.Add(AFieldInfo);

  FComponentTypeSet := AComponentTypeSet;
  FReplace := AReplace;
  FCopyCommonValueToFamily := ACopyCommonValueToFamily;
end;

function TParametricExcelTable.CheckComponent: Boolean;
var
  AErrorMessage: string;
  ARecordCheck: TRecordCheck;
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
    Result := qSearchComponentOrFamily.SearchComponent
      (ComponentName.AsString) > 0;
    if not Result then
      AErrorMessage := 'Компонент с таким именем не найден';
  end;

  if FComponentTypeSet = [ctComponent, ctFamily] then
  begin
    Result := qSearchComponentOrFamily.SearchByValue
      (ComponentName.AsString) > 0;
    if not Result then
      AErrorMessage := 'Семейство или компонент с таким именем не найден';
  end;

  if Result then
  begin
    Edit;
    IDComponent.AsInteger := qSearchComponentOrFamily.W.PK.AsInteger;
    IDParentComponent.AsInteger := qSearchComponentOrFamily.W.ParentProductID.
      F.AsInteger;
    Post;
  end
  else
  begin
    // Запоминаем, что в этой строке ошибка
    ARecordCheck.ErrorType := etError;
    ARecordCheck.Row := ExcelRow.AsInteger;
    ARecordCheck.Col := ComponentName.Index + 1;
    ARecordCheck.ErrorMessage := ComponentName.AsString;
    ARecordCheck.Description := AErrorMessage;
    ProcessErrors(ARecordCheck);
  end;
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

class function TParametricExcelTable.GetFieldNameByParamSubParamID
  (AParamSubParamID: Integer): String;
begin
  Assert(AParamSubParamID > 0);
  Assert(not FParamPrefix.IsEmpty);

  Result := Format('%s_%d', [FParamPrefix, AParamSubParamID]);
end;

function TParametricExcelTable.GetIDComponent: TField;
begin
  Result := FieldByName('IDComponent');
end;

function TParametricExcelTable.GetParamSubParamIDByFieldName(AFieldName: string;
  out AParamSubParamID: Integer): Boolean;
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

function TParametricExcelTable.GetqSearchComponentOrFamily
  : TQuerySearchComponentOrFamily;
begin
  if FqSearchComponentOrFamily = nil then
    FqSearchComponentOrFamily := TQuerySearchComponentOrFamily.Create(Self);

  Result := FqSearchComponentOrFamily;
end;

constructor TParametricExcelDM.Create(AOwner: TComponent; AFieldsInfo:
    TList<TFieldInfo>; AComponentTypeSet: TComponentTypeSet; AReplace,
    ACopyCommonValueToFamily: Boolean);
begin
  Assert(AFieldsInfo <> nil);
  FFieldsInfo := AFieldsInfo;
  FComponentTypeSet := AComponentTypeSet;
  FReplace := AReplace;
  FCopyCommonValueToFamily := ACopyCommonValueToFamily;

  Create(AOwner);
end;

function TParametricExcelDM.CreateExcelTable: TCustomExcelTable;
begin
  Assert(FFieldsInfo <> nil);
  Result := TParametricExcelTable.Create(Self, FFieldsInfo, FComponentTypeSet,
    FReplace, FCopyCommonValueToFamily);
end;

function TParametricExcelDM.GetExcelTable: TParametricExcelTable;
begin
  Result := CustomExcelTable as TParametricExcelTable;
end;

end.
