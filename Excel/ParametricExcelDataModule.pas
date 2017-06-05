unit ParametricExcelDataModule;

interface

uses
  System.SysUtils, System.Classes, ExcelDataModule, Excel2010, Vcl.OleServer,
  CustomExcelTable, Data.DB, SearchComponentQuery, System.Generics.Collections,
  FieldInfoUnit;

{$WARN SYMBOL_PLATFORM OFF}

type
  TParametricExcelTable = class(TCustomExcelTable)
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
    class function GetFieldNameByIDParam(AIDParameter, AIDParentParameter:
        Integer): String; static;
    function GetIDParamByFieldName(AFieldName: string; out AIDParameter,
        AIDParentParameter: Integer): Boolean;
    property ComponentName: TField read GetComponentName;
    property IDComponent: TField read GetIDComponent;
    property IDParentComponent: TField read GetIDParentComponent;
  end;


  TParametricExcelDM = class(TExcelDM)
  private
    FFieldsInfo: TList<TFieldInfo>;
    function GetExcelTable: TParametricExcelTable;
    { Private declarations }
  protected
    function CreateExcelTable: TCustomExcelTable; override;
  public
    constructor Create(AOwner: TComponent; AFieldsInfo: TList<TFieldInfo>);
        reintroduce; overload;
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
    TList<TFieldInfo>);
var
  AFieldInfo: TFieldInfo;
begin
  inherited Create(AOwner);
  for AFieldInfo in AFieldsInfo do
    FieldsInfo.Add(AFieldInfo);
end;

function TParametricExcelTable.CheckComponent: Boolean;
begin
  Result := QuerySearchComponent.Search(ComponentName.AsString) > 0;

  Edit;

  if Result then
  begin
    IDComponent.AsInteger := QuerySearchComponent.PK.AsInteger;
    IDParentComponent.AsInteger := QuerySearchComponent.ParentProductID.AsInteger;
  end
  else
  begin
    // ����������, ��� � ���� ������ ������
    ErrorType.AsInteger := Integer(etError);

    Errors.AddError(ExcelRow.AsInteger, ComponentName.Index + 1,
      ComponentName.AsString, '��������� � ����� ������ �� ������');
  end;

  Post;
end;

function TParametricExcelTable.CheckRecord: Boolean;
begin
  Result := inherited;
  if Result then
  begin
    // ��������� ��� ����� ��������� ����������
    Result := CheckComponent;
  end;
end;

procedure TParametricExcelTable.CreateFieldDefs;
begin
  inherited;
  // ��� ��������, ����� ��������� ������������� ����������
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

  Result := Format('%s_%d_%d', [FParamPrefix, AIDParameter, AIDParentParameter]);
end;

function TParametricExcelTable.GetIDComponent: TField;
begin
  Result := FieldByName('IDComponent');
end;

function TParametricExcelTable.GetIDParamByFieldName(AFieldName: string; out
    AIDParameter, AIDParentParameter: Integer): Boolean;
var
  m: TArray<String>;
begin
  Assert(not FParamPrefix.IsEmpty);
  Assert(not AFieldName.IsEmpty);

  // ����� ��� ���� �� �����
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

function TParametricExcelTable.GetQuerySearchComponent: TQuerySearchComponent;
begin
  if FQuerySearchComponent = nil  then
    FQuerySearchComponent := TQuerySearchComponent.Create(Self);

  Result := FQuerySearchComponent;
end;

constructor TParametricExcelDM.Create(AOwner: TComponent; AFieldsInfo:
    TList<TFieldInfo>);
begin
  Assert(AFieldsInfo <> nil);
  FFieldsInfo := AFieldsInfo;

  Create(AOwner);
end;

function TParametricExcelDM.CreateExcelTable: TCustomExcelTable;
begin
  Assert(FFieldsInfo <> nil);
  Result := TParametricExcelTable.Create(Self, FFieldsInfo);
end;

function TParametricExcelDM.GetExcelTable: TParametricExcelTable;
begin
  Result := CustomExcelTable as TParametricExcelTable;
end;

end.
