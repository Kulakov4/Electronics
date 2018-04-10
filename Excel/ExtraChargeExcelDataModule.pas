unit ExtraChargeExcelDataModule;

interface

uses
  System.SysUtils, System.Classes, ExcelDataModule, Excel2010, Vcl.OleServer,
  CustomExcelTable, Data.DB, FireDAC.Comp.Client, FireDAC.Comp.DataSet,
  ExtraChargeSimpleQuery;

type
  TExtraChargeExcelTable = class(TCustomExcelTable)
  private
    FDMemTable: TFDMemTable;
    FExtraChargeDataSet: TFDDataSet;
    FqExtraChargeSimple: TQueryExtraChargeSimple;
    function GetqExtraChargeSimple: TQueryExtraChargeSimple;
    function GetRange: TField;
    function GetWholeSale: TField;
    procedure SetExtraChargeDataSet(const Value: TFDDataSet);
  protected
    function CheckRange: Boolean;
    procedure Clone;
    procedure SetFieldsInfo; override;
    property qExtraChargeSimple: TQueryExtraChargeSimple read GetqExtraChargeSimple;
  public
    constructor Create(AOwner: TComponent); override;
    function CheckRecord: Boolean; override;
    property ExtraChargeDataSet: TFDDataSet read FExtraChargeDataSet
      write SetExtraChargeDataSet;
    property Range: TField read GetRange;
    property WholeSale: TField read GetWholeSale;
  end;

  TExtraChargeExcelDM = class(TExcelDM)
  private
    function GetExcelTable: TExtraChargeExcelTable;
    { Private declarations }
  protected
    function CreateExcelTable: TCustomExcelTable; override;
  public
    property ExcelTable: TExtraChargeExcelTable read GetExcelTable;
    { Public declarations }
  end;

implementation

uses
  FieldInfoUnit, System.RegularExpressions, System.Variants;

constructor TExtraChargeExcelTable.Create(AOwner: TComponent);
begin
  inherited;
  FDMemTable := TFDMemTable.Create(Self);
end;

function TExtraChargeExcelTable.CheckRange: Boolean;
var
  AErrorMessage: string;
  AHigh: Integer;
  ALow: Integer;
//  Pattern: string;
//  RegEx: TRegEx;
  V: Variant;
begin
  // Ищем точно такой-же диапазон
  V := FDMemTable.LookupEx(Range.FieldName, Range.Value, 'ID', []);

  Result := VarIsNull(V);

  // Если не нашли
  if not Result then
  begin
    MarkAsError(etWarring);

    Errors.AddWarring(ExcelRow.AsInteger, Range.Index + 1, Range.AsString,
      'Такой диапазон уже существует');
    Exit;
  end;

  AErrorMessage := qExtraChargeSimple.CheckBounds(0, Range.AsString, ALow, AHigh );
  Result := AErrorMessage.IsEmpty;
//  Pattern := '^\d+-\d+$';
//  RegEx := TRegEx.Create(Pattern);
//  Result := RegEx.IsMatch(Range.AsString);

  // Если не нашли
  if not Result then
  begin
    MarkAsError(etError);

    Errors.AddError(ExcelRow.AsInteger, Range.Index + 1, Range.AsString,
      AErrorMessage
      {Format('%s не является диапазоном целых значений', [Range.AsString])});
  end;
end;

function TExtraChargeExcelTable.CheckRecord: Boolean;
begin
  Result := inherited;
  if Result then
  begin
    // Проверяем что такой производитель существует
    Result := CheckRange;
  end;
end;

procedure TExtraChargeExcelTable.Clone;
var
  AFDIndex: TFDIndex;
begin
  // Клонируем курсор
  FDMemTable.CloneCursor(ExtraChargeDataSet);

  // Создаём индекс
  AFDIndex := FDMemTable.Indexes.Add;
  AFDIndex.Fields := 'Range';
  AFDIndex.Name := 'idxExtraChargeRange';
  AFDIndex.Active := True;
  FDMemTable.IndexName := AFDIndex.Name;
end;

function TExtraChargeExcelTable.GetqExtraChargeSimple: TQueryExtraChargeSimple;
begin
  if FqExtraChargeSimple = nil then
    FqExtraChargeSimple := TQueryExtraChargeSimple.Create(Self);

  Result := FqExtraChargeSimple;
end;

function TExtraChargeExcelTable.GetRange: TField;
begin
  Result := FieldByName('Range');
end;

function TExtraChargeExcelTable.GetWholeSale: TField;
begin
  Result := FieldByName('WholeSale');
end;

procedure TExtraChargeExcelTable.SetFieldsInfo;
begin
  FieldsInfo.Add(TFieldInfo.Create('Range', True,
    'Диапазон не может быть пустым'));
  FieldsInfo.Add(TFieldInfo.Create('Wholesale', True,
    'Наценка не может быть пустой'));
end;

procedure TExtraChargeExcelTable.SetExtraChargeDataSet(const Value: TFDDataSet);
begin
  if FExtraChargeDataSet = Value then
    Exit;

  FExtraChargeDataSet := Value;
  if FExtraChargeDataSet = nil then
    Exit;

  Clone;
end;

function TExtraChargeExcelDM.CreateExcelTable: TCustomExcelTable;
begin
  Result := TExtraChargeExcelTable.Create(Self);
end;

function TExtraChargeExcelDM.GetExcelTable: TExtraChargeExcelTable;
begin
  Result := CustomExcelTable as TExtraChargeExcelTable;
end;

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

end.
