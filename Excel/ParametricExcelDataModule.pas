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
    class function GetFieldNameByParamSubParamID(AParamSubParamID: Integer):
        String; static;
    function GetParamSubParamIDByFieldName(AFieldName: string; out
        AParamSubParamID: Integer): Boolean;
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

  // ���� ���� ������ ������ ����� ��������
  if FFamily then
  begin
    // ���� ��������� �����������
    Result := qSearchComponentOrFamily.SearchFamily(ComponentName.AsString) > 0;
    if not Result then
      AErrorMessage := '��������� ����������� � ����� ������ �� �������';
  end
  else
  begin
    // ���� ���������
    Result := qSearchComponentOrFamily.SearchComponent(ComponentName.AsString) > 0;
    if not Result then
      AErrorMessage := '��������� � ����� ������ �� ������';
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
    // ����������, ��� � ���� ������ ������
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

  // ����� ��� ���� �� �����
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
