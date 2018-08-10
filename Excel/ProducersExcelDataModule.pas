unit ProducersExcelDataModule;

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
  TProducersExcelTable = class(TCustomExcelTable)
  private
    FDMemTable: TFDMemTable;
    FProducersDataSet: TFDDataSet;
    function GetName: TField;
    function GetProducerType: TField;
    procedure SetProducersDataSet(const Value: TFDDataSet);
  protected
    function CheckProducer: Boolean;
    procedure Clone;
    procedure SetFieldsInfo; override;
  public
    constructor Create(AOwner: TComponent); override;
    function CheckRecord: Boolean; override;
    property ProducersDataSet: TFDDataSet read FProducersDataSet
      write SetProducersDataSet;
    property Name: TField read GetName;
    property ProducerType: TField read GetProducerType;
  end;

  TProducersExcelDM = class(TExcelDM)
  private
    function GetExcelTable: TProducersExcelTable;
    { Private declarations }
  protected
    function CreateExcelTable: TCustomExcelTable; override;
  public
    property ExcelTable: TProducersExcelTable read GetExcelTable;
    { Public declarations }
  end;

implementation

{ %CLASSGROUP 'Vcl.Controls.TControl' }

{$R *.dfm}

uses System.Variants, System.Math, FieldInfoUnit, ProgressInfo, ErrorType;

constructor TProducersExcelTable.Create(AOwner: TComponent);
begin
  inherited;
  FDMemTable := TFDMemTable.Create(Self);
end;

function TProducersExcelTable.CheckProducer: Boolean;
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

function TProducersExcelTable.CheckRecord: Boolean;
begin
  Result := inherited;
  if Result then
  begin
    // Проверяем что такой производитель существует
    Result := CheckProducer;
  end;
end;

procedure TProducersExcelTable.Clone;
var
  AFDIndex: TFDIndex;
begin
  // Клонируем курсор
  FDMemTable.CloneCursor(ProducersDataSet);

  // Создаём индекс
  AFDIndex := FDMemTable.Indexes.Add;
  AFDIndex.Fields := 'Name';
  AFDIndex.Name := 'idxProducersName';
  AFDIndex.Active := True;
  FDMemTable.IndexName := AFDIndex.Name;
end;

function TProducersExcelTable.GetName: TField;
begin
  Result := FieldByName('Name');
end;

function TProducersExcelTable.GetProducerType: TField;
begin
  Result := FieldByName('ProducerType');
end;

procedure TProducersExcelTable.SetFieldsInfo;
begin
  FieldsInfo.Add(TFieldInfo.Create('Name', True,
    'Название производителя не может быть пустым'));
  FieldsInfo.Add(TFieldInfo.Create('Products'));
  FieldsInfo.Add(TFieldInfo.Create('ProducerType', True,
    'Тип производителя не может быть пустым'));
end;

procedure TProducersExcelTable.SetProducersDataSet(const Value: TFDDataSet);
begin
  if FProducersDataSet <> Value then
  begin
    FProducersDataSet := Value;
    if FProducersDataSet <> nil then
    begin
      Clone;
    end;

  end;
end;

function TProducersExcelDM.CreateExcelTable: TCustomExcelTable;
begin
  Result := TProducersExcelTable.Create(Self);
end;

function TProducersExcelDM.GetExcelTable: TProducersExcelTable;
begin
  Result := CustomExcelTable as TProducersExcelTable;
end;

end.
