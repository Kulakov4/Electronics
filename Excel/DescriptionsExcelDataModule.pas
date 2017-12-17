unit DescriptionsExcelDataModule;

interface

uses
  System.SysUtils, System.Classes, ExcelDataModule, Excel2010, Vcl.OleServer,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, CustomExcelTable;

{$WARN SYMBOL_PLATFORM OFF}

type
  TDescriptionsExcelTable = class(TCustomExcelTable)
  private
    FDescriptionsDataSet: TFDDataSet;
    FDMemTable: TFDMemTable;
    function GetComponentName: TField;
    function GetComponentType: TField;
    function GetProducer: TField;
    procedure SetDescriptionsDataSet(const Value: TFDDataSet);
  protected
    function CheckDescription: Boolean;
    procedure Clone;
    procedure SetFieldsInfo; override;
  public
    constructor Create(AOwner: TComponent); override;
    function CheckRecord: Boolean; override;
    property ComponentName: TField read GetComponentName;
    property ComponentType: TField read GetComponentType;
    property DescriptionsDataSet: TFDDataSet read FDescriptionsDataSet
      write SetDescriptionsDataSet;
    property Producer: TField read GetProducer;
  end;

  TDescriptionsExcelDM = class(TExcelDM)
  private
    function GetExcelTable: TDescriptionsExcelTable;
    { Private declarations }
  protected
    function CreateExcelTable: TCustomExcelTable; override;
  public
    property ExcelTable: TDescriptionsExcelTable read GetExcelTable;
    { Public declarations }
  end;

implementation

{ %CLASSGROUP 'Vcl.Controls.TControl' }

uses System.Math, System.Variants, FieldInfoUnit, ProgressInfo;

{$R *.dfm}

constructor TDescriptionsExcelTable.Create(AOwner: TComponent);
begin
  inherited;
  FDMemTable := TFDMemTable.Create(Self);
end;

function TDescriptionsExcelTable.CheckDescription: Boolean;
var
  V: Variant;
begin
  // Ищем компонент с такм-же именем
  V := FDMemTable.LookupEx(ComponentName.FieldName, ComponentName.Value, 'ID');

  Result := VarIsNull(V);

  // Если нашли
  if not Result then
  begin
    MarkAsError(etWarring);

    Errors.AddError(ExcelRow.AsInteger, ComponentName.Index + 1,
      ComponentName.AsString, 'Компонент с таким наименованием уже существует');
  end;
end;

function TDescriptionsExcelTable.CheckRecord: Boolean;
begin
  Result := inherited;
  if Result then
  begin
    Result := CheckDescription;
  end;
end;

procedure TDescriptionsExcelTable.Clone;
var
  AFDIndex: TFDIndex;
begin
  // Клонируем курсор
  FDMemTable.CloneCursor(DescriptionsDataSet);

  // Создаём индекс
  AFDIndex := FDMemTable.Indexes.Add;
  AFDIndex.Fields := 'ComponentName';
  AFDIndex.Name := 'idxComponentName';
  AFDIndex.Active := True;
  FDMemTable.IndexName := AFDIndex.Name;
end;

function TDescriptionsExcelTable.GetComponentName: TField;
begin
  Result := FieldByName('ComponentName');
end;

function TDescriptionsExcelTable.GetComponentType: TField;
begin
  Result := FieldByName('ComponentType');
end;

function TDescriptionsExcelTable.GetProducer: TField;
begin
  Result := FieldByName('Producer');
end;

procedure TDescriptionsExcelTable.SetDescriptionsDataSet
  (const Value: TFDDataSet);
begin
  if FDescriptionsDataSet <> Value then
  begin
    FDescriptionsDataSet := Value;
    if FDescriptionsDataSet <> nil then
    begin
      Clone;
    end;
  end;
end;

procedure TDescriptionsExcelTable.SetFieldsInfo;
begin
  FieldsInfo.Add(TFieldInfo.Create('ComponentName', True,
    'Наименование компонента не должно быть пустым'));
  FieldsInfo.Add(TFieldInfo.Create('Producer', True,
    'Наименование производителя не должно быть пустым'));
  FieldsInfo.Add(TFieldInfo.Create('Description', True,
    'Описание компонента не должно быть пустым', False, 3000));
  FieldsInfo.Add(TFieldInfo.Create('ComponentType', True,
    'Тип компонента не должен быть пустым'));
end;

function TDescriptionsExcelDM.CreateExcelTable: TCustomExcelTable;
begin
  Result := TDescriptionsExcelTable.Create(Self);
end;

function TDescriptionsExcelDM.GetExcelTable: TDescriptionsExcelTable;
begin
  Result := CustomExcelTable as TDescriptionsExcelTable;
end;

end.
