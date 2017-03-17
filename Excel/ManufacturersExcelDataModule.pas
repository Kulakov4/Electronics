unit ManufacturersExcelDataModule;

interface

uses
  System.SysUtils, System.Classes, ExcelDataModule, Excel2010, Vcl.OleServer,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  CustomExcelTable;

{$WARN SYMBOL_PLATFORM OFF}

type
  TManufacturesExcelTable = class(TCustomExcelTable)
  private
    FDMemTable: TFDMemTable;
    FManufacturersDataSet: TFDDataSet;
    function GetName: TField;
    procedure SetManufacturersDataSet(const Value: TFDDataSet);
  protected
    function CheckManufacturer: Boolean;
    procedure Clone;
    procedure SetFieldsInfo; override;
  public
    constructor Create(AOwner: TComponent); override;
    function CheckRecord: Boolean; override;
    property ManufacturersDataSet: TFDDataSet read FManufacturersDataSet
      write SetManufacturersDataSet;
    property Name: TField read GetName;
  end;

  TManufacturersExcelDM = class(TExcelDM)
  private
    function GetExcelTable: TManufacturesExcelTable;
    { Private declarations }
  protected
    function CreateExcelTable: TCustomExcelTable; override;
  public
    property ExcelTable: TManufacturesExcelTable read GetExcelTable;
    { Public declarations }
  end;

implementation

{ %CLASSGROUP 'Vcl.Controls.TControl' }

{$R *.dfm}

uses System.Variants, System.Math, FieldInfoUnit, ProgressInfo;

constructor TManufacturesExcelTable.Create(AOwner: TComponent);
begin
  inherited;
  FDMemTable := TFDMemTable.Create(Self);
end;

function TManufacturesExcelTable.CheckManufacturer: Boolean;
var
  V: Variant;
begin
  // Ищем производителя с таким-же именем без учёта регистра
  V := FDMemTable.LookupEx(Name.FieldName, Name.Value, 'ID',
    [lxoCaseInsensitive]);

  Result := VarIsNull(V);

  // Если не нашли
  if not Result then
  begin
    MarkAsError(etWarring);

    Errors.AddWarring(ExcelRow.AsInteger, Name.Index + 1, Name.AsString,
      'Такой производитель уже существует');
  end;
end;

function TManufacturesExcelTable.CheckRecord: Boolean;
begin
  Result := inherited;
  if Result then
  begin
    // Проверяем что такой производитель существует
    Result := CheckManufacturer;
  end;
end;

procedure TManufacturesExcelTable.Clone;
var
  AFDIndex: TFDIndex;
begin
  // Клонируем курсор
  FDMemTable.CloneCursor(ManufacturersDataSet);

  // Создаём индекс
  AFDIndex := FDMemTable.Indexes.Add;
  AFDIndex.Fields := 'Name';
  AFDIndex.Name := 'idxManufacturersName';
  AFDIndex.Active := True;
  FDMemTable.IndexName := AFDIndex.Name;
end;

function TManufacturesExcelTable.GetName: TField;
begin
  Result := FieldByName('Name');
end;

procedure TManufacturesExcelTable.SetFieldsInfo;
begin
  FieldsInfo.Add(TFieldInfo.Create('Name', True,
    'Название производителя не может быть пустым'));
  FieldsInfo.Add(TFieldInfo.Create('Products'));
  FieldsInfo.Add(TFieldInfo.Create('ProducerType'));
end;

procedure TManufacturesExcelTable.SetManufacturersDataSet
  (const Value: TFDDataSet);
begin
  if FManufacturersDataSet <> Value then
  begin
    FManufacturersDataSet := Value;
    if FManufacturersDataSet <> nil then
    begin
      Clone;
    end;

  end;
end;

function TManufacturersExcelDM.CreateExcelTable: TCustomExcelTable;
begin
  Result := TManufacturesExcelTable.Create(Self);
end;

function TManufacturersExcelDM.GetExcelTable: TManufacturesExcelTable;
begin
  Result := CustomExcelTable as TManufacturesExcelTable;
end;

end.
