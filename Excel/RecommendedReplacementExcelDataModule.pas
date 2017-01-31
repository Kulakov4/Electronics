unit RecommendedReplacementExcelDataModule;

interface

uses
  System.SysUtils, System.Classes, ExcelDataModule, Excel2010, Vcl.OleServer,
  CustomExcelTable, Data.DB, SearchComponentQuery, System.Generics.Collections,
  FieldInfoUnit;

{$WARN SYMBOL_PLATFORM OFF}

type
  TParameterExcelTable = class(TCustomExcelTable)
  private
    FQuerySearchComponent: TQuerySearchComponent;
    function GetComponentName: TField;
// TODO: GetIDBodyType
//  function GetIDBodyType: TField;
    function GetIDComponent: TField;
    function GetIDParentComponent: TField;
  protected
    function CheckComponent: Boolean;
    procedure CreateFieldDefs; override;
    function GetValue: TField; virtual;
    procedure SetFieldsInfo; override;
  public
    constructor Create(AOwner: TComponent); override;
    function CheckRecord: Boolean; override;
    property ComponentName: TField read GetComponentName;
    property IDComponent: TField read GetIDComponent;
    property IDParentComponent: TField read GetIDParentComponent;
    property Value: TField read GetValue;
  end;

  TParameterExcelDM = class(TExcelDM)
  private
    { Private declarations }
  protected
    function CreateExcelTable: TCustomExcelTable; override;
  public
    { Public declarations }
  end;

  TParameterExcelTable2 = class(TCustomExcelTable)
  private
    FQuerySearchComponent: TQuerySearchComponent;
    function GetComponentName: TField;
// TODO: GetIDBodyType
//  function GetIDBodyType: TField;
    function GetIDComponent: TField;
    function GetIDParentComponent: TField;
    function GetQuerySearchComponent: TQuerySearchComponent;
  protected
    function CheckComponent: Boolean;
    procedure CreateFieldDefs; override;
    property QuerySearchComponent: TQuerySearchComponent read
        GetQuerySearchComponent;
  public
    constructor Create(AOwner: TComponent; AFieldsInfo: TList<TFieldInfo>);
        reintroduce;
    function CheckRecord: Boolean; override;
    class function GetFieldNameByIDParam(AIDParameter: Integer): String; static;
    function GetIDParamByFieldName(AFieldName: string): Integer;
    property ComponentName: TField read GetComponentName;
    property IDComponent: TField read GetIDComponent;
    property IDParentComponent: TField read GetIDParentComponent;
  end;

  TParameterExcelDM2 = class(TExcelDM)
  private
    FFieldsInfo: TList<TFieldInfo>;
    function GetExcelTable: TParameterExcelTable2;
  protected
    function CreateExcelTable: TCustomExcelTable; override;
  public
    constructor Create(AOwner: TComponent; AFieldsInfo: TList<TFieldInfo>);
        reintroduce; overload;
    property ExcelTable: TParameterExcelTable2 read GetExcelTable;
  end;

implementation

{ %CLASSGROUP 'Vcl.Controls.TControl' }

{$R *.dfm}

uses ProgressInfo, System.Variants;

const
  FParamPrefix = 'Param_';

constructor TParameterExcelTable.Create(AOwner: TComponent);
begin
  inherited;
  FQuerySearchComponent := TQuerySearchComponent.Create(Self);
end;

function TParameterExcelTable.CheckComponent: Boolean;
begin
  Result := FQuerySearchComponent.Search(ComponentName.AsString) > 0;

  Edit;

  if Result then
  begin
    IDComponent.AsInteger := FQuerySearchComponent.PKValue;
    IDParentComponent.AsInteger := FQuerySearchComponent.ParentProductID.AsInteger;
  end
  else
  begin
    // Запоминаем, что в этой строке ошибка
    ErrorType.AsInteger := Integer(etError);

    Errors.AddError(ExcelRow.AsInteger, ComponentName.Index + 1,
      ComponentName.AsString, 'Компонент с таким именем не найден');
  end;

  Post;
end;

function TParameterExcelTable.CheckRecord: Boolean;
begin
  Result := inherited;
  if Result then
  begin
    // Проверяем что такой компонент существует
    Result := CheckComponent;
  end;
end;

procedure TParameterExcelTable.CreateFieldDefs;
begin
  inherited;
  // При проверке, будем заполнять идентификатор компонента
  FieldDefs.Add('IDComponent', ftInteger);
  FieldDefs.Add('IDParentComponent', ftInteger);
end;

function TParameterExcelTable.GetComponentName: TField;
begin
  Result := FieldByName(FieldsInfo[0].FieldName);
end;

function TParameterExcelTable.GetIDComponent: TField;
begin
  Result := FieldByName('IDComponent');
end;

function TParameterExcelTable.GetIDParentComponent: TField;
begin
  Result := FieldByName('IDParentComponent');
end;

function TParameterExcelTable.GetValue: TField;
begin
  Assert(False);
  Result := nil;
end;

procedure TParameterExcelTable.SetFieldsInfo;
begin
  FieldsInfo.Add(TFieldInfo.Create('ComponentName', True,
    'Название компонента не может быть пустым'));
end;

function TParameterExcelDM.CreateExcelTable: TCustomExcelTable;
begin
  Result := nil;
  Assert(False);
end;

constructor TParameterExcelTable2.Create(AOwner: TComponent; AFieldsInfo:
    TList<TFieldInfo>);
var
  AFieldInfo: TFieldInfo;
begin
  inherited Create(AOwner);
  for AFieldInfo in AFieldsInfo do
    FieldsInfo.Add(AFieldInfo);
end;

function TParameterExcelTable2.CheckComponent: Boolean;
begin
  Result := QuerySearchComponent.Search(ComponentName.AsString) > 0;

  Edit;

  if Result then
  begin
    IDComponent.AsInteger := QuerySearchComponent.PKValue;
    IDParentComponent.AsInteger := QuerySearchComponent.ParentProductID.AsInteger;
  end
  else
  begin
    // Запоминаем, что в этой строке ошибка
    ErrorType.AsInteger := Integer(etError);

    Errors.AddError(ExcelRow.AsInteger, ComponentName.Index + 1,
      ComponentName.AsString, 'Компонент с таким именем не найден');
  end;

  Post;
end;

function TParameterExcelTable2.CheckRecord: Boolean;
begin
  Result := inherited;
  if Result then
  begin
    // Проверяем что такой компонент существует
    Result := CheckComponent;
  end;
end;

procedure TParameterExcelTable2.CreateFieldDefs;
begin
  inherited;
  // При проверке, будем заполнять идентификатор компонента
  FieldDefs.Add('IDComponent', ftInteger);
  FieldDefs.Add('IDParentComponent', ftInteger);
end;

function TParameterExcelTable2.GetComponentName: TField;
begin
  Result := FieldByName(FieldsInfo[0].FieldName);
end;

class function TParameterExcelTable2.GetFieldNameByIDParam(AIDParameter:
    Integer): String;
begin
  Assert(AIDParameter > 0);
  Assert(not FParamPrefix.IsEmpty);

  Result := Format('%s%d', [FParamPrefix, AIDParameter]);
end;

function TParameterExcelTable2.GetIDComponent: TField;
begin
  Result := FieldByName('IDComponent');
end;

function TParameterExcelTable2.GetIDParamByFieldName(AFieldName: string):
    Integer;
var
  S: string;
begin
  Assert(not FParamPrefix.IsEmpty);
  Assert(not AFieldName.IsEmpty);

  if AFieldName.IndexOf(FParamPrefix) = 0 then
  begin
    S := AFieldName.Substring( FParamPrefix.Length );
    Result := StrToIntDef(S, 0);
  end
  else
    Result := 0;
end;

function TParameterExcelTable2.GetIDParentComponent: TField;
begin
  Result := FieldByName('IDParentComponent');
end;

function TParameterExcelTable2.GetQuerySearchComponent: TQuerySearchComponent;
begin
  if FQuerySearchComponent = nil  then
    FQuerySearchComponent := TQuerySearchComponent.Create(Self);

  Result := FQuerySearchComponent;
end;

constructor TParameterExcelDM2.Create(AOwner: TComponent; AFieldsInfo:
    TList<TFieldInfo>);
begin
  Assert(AFieldsInfo <> nil);
  FFieldsInfo := AFieldsInfo;

  Create(AOwner);
end;

function TParameterExcelDM2.CreateExcelTable: TCustomExcelTable;
begin
  Assert(FFieldsInfo <> nil);
  Result := TParameterExcelTable2.Create(Self, FFieldsInfo);
end;

function TParameterExcelDM2.GetExcelTable: TParameterExcelTable2;
begin
  Result := CustomExcelTable as TParameterExcelTable2;
end;

end.
