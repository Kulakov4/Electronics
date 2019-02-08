unit DocBindExcelDataModule;

interface

uses
  System.SysUtils, System.Classes, ExcelDataModule, Excel2010, Vcl.OleServer,
  CustomExcelTable, FieldInfoUnit, Data.DB, SearchComponentOrFamilyQuery;

type
  TDocBindExcelTable = class(TCustomExcelTable)
  private
    FqSearchComponentOrFamily: TQuerySearchComponentOrFamily;
    function GetComponentName: TField;
    function GetDatasheet: TField;
    function GetDiagram: TField;
    function GetIDProduct: TField;
    function GetqSearchComponentOrFamily: TQuerySearchComponentOrFamily;
  protected
    function CheckComponent: Boolean;
    procedure CreateFieldDefs; override;
    procedure SetFieldsInfo; override;
    property qSearchComponentOrFamily: TQuerySearchComponentOrFamily read
        GetqSearchComponentOrFamily;
  public
    function CheckRecord: Boolean; override;
    property ComponentName: TField read GetComponentName;
    property Datasheet: TField read GetDatasheet;
    property Diagram: TField read GetDiagram;
    property IDProduct: TField read GetIDProduct;
  end;

  TDocBindExcelDM = class(TExcelDM)
  private
    function GetExcelTable: TDocBindExcelTable;
    { Private declarations }
  protected
    function CreateExcelTable: TCustomExcelTable; override;
  public
    property ExcelTable: TDocBindExcelTable read GetExcelTable;
    { Public declarations }
  end;

implementation

uses
  ErrorType, RecordCheck;

function TDocBindExcelTable.CheckComponent: Boolean;
var
  ARecordCheck: TRecordCheck;
begin
  Result := qSearchComponentOrFamily.SearchByValue(ComponentName.AsString) > 0;
  // Если нашли такое семейство или компонент
  if Result then
  begin
    Edit;
    IDProduct.AsInteger := qSearchComponentOrFamily.W.PK.Value;
    Post;
  end
  else
  begin
    ARecordCheck.ErrorType := etError;
    ARecordCheck.Row := ExcelRow.AsInteger;
    ARecordCheck.Col := ComponentName.Index + 1;
    ARecordCheck.ErrorMessage := ComponentName.AsString;
    ARecordCheck.Description := 'Семейство компонентов (компонент) с таким именем не найдено';
    ProcessErrors(ARecordCheck);
  end;
end;

function TDocBindExcelTable.CheckRecord: Boolean;
begin
  Result := inherited;
  if Result then
  begin
    // Проверяем что такой производитель существует
    Result := CheckComponent;
  end;
end;

procedure TDocBindExcelTable.CreateFieldDefs;
begin
  inherited;
  // при проверке будем заполнять код семейства или компонента
  FieldDefs.Add('IDProduct', ftInteger);
end;

function TDocBindExcelTable.GetComponentName: TField;
begin
  Result := FieldByName('ComponentName');
end;

function TDocBindExcelTable.GetDatasheet: TField;
begin
  Result := FieldByName('Datasheet');
end;

function TDocBindExcelTable.GetDiagram: TField;
begin
  Result := FieldByName('Diagram');
end;

function TDocBindExcelTable.GetIDProduct: TField;
begin
  Result := FieldByName('IDProduct');
end;

function TDocBindExcelTable.GetqSearchComponentOrFamily:
    TQuerySearchComponentOrFamily;
begin
  if FqSearchComponentOrFamily = nil then
  begin
    FqSearchComponentOrFamily := TQuerySearchComponentOrFamily.Create(Self);
  end;
  Result := FqSearchComponentOrFamily;
end;

procedure TDocBindExcelTable.SetFieldsInfo;
begin
  FieldsInfo.Add(TFieldInfo.Create('ComponentName', True,
    'Название семейства компонентов (компонента) не может быть пустым'));
  FieldsInfo.Add(TFieldInfo.Create('Datasheet'));
  FieldsInfo.Add(TFieldInfo.Create('Diagram'));
end;

function TDocBindExcelDM.CreateExcelTable: TCustomExcelTable;
begin
  Result := TDocBindExcelTable.Create(Self);
end;

function TDocBindExcelDM.GetExcelTable: TDocBindExcelTable;
begin
  Result := CustomExcelTable as TDocBindExcelTable;
end;

{ %CLASSGROUP 'Vcl.Controls.TControl' }

{$R *.dfm}

end.
