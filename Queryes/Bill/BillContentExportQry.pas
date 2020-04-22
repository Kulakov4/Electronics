unit BillContentExportQry;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, DSWrap;

type
  TBillContentExportW = class(TDSWrap)
  private
    FStoreHouse: TFieldWrap;
    FBillTitle: TFieldWrap;
    FPriceR: TFieldWrap;
    FID: TFieldWrap;
    FBillNumber: TFieldWrap;
    FAmount: TFieldWrap;
    FBarcode: TFieldWrap;
    FBatchNumber: TFieldWrap;
    FBillDate: TFieldWrap;
    FCustomsDeclarationNumber: TFieldWrap;
    FDescriptionComponentName: TFieldWrap;
    FPriceD: TFieldWrap;
    FPriceD1: TFieldWrap;
    FPriceD2: TFieldWrap;
    FPriceD3: TFieldWrap;
    FDatasheet: TFieldWrap;
    FDiagram: TFieldWrap;
    FDocumentNumber: TFieldWrap;
    FDollar: TFieldWrap;
    FBillDollar: TFieldWrap;
    FDrawing: TFieldWrap;
    FEuro: TFieldWrap;
    FBillEuro: TFieldWrap;
    FImage: TFieldWrap;
    FLoadDate: TFieldWrap;
    FOriginCountry: TFieldWrap;
    FOriginCountryCode: TFieldWrap;
    FPackaging: TFieldWrap;
    FPriceE: TFieldWrap;
    FPriceE1: TFieldWrap;
    FPriceE2: TFieldWrap;
    FPriceR1: TFieldWrap;
    FPriceR2: TFieldWrap;
    FProducer: TFieldWrap;
    FReleaseDate: TFieldWrap;
    FSaleCount: TFieldWrap;
    FSaleD: TFieldWrap;
    FSaleE: TFieldWrap;
    FSaleR: TFieldWrap;
    FSeller: TFieldWrap;
    FShipmentDate: TFieldWrap;
    FStorage: TFieldWrap;
    FStoragePlace: TFieldWrap;
    FSumSaleR: TFieldWrap;
    FValue: TFieldWrap;
    FWidth: TFieldWrap;
    procedure DoAfterOpen(Sender: TObject);
    procedure OnDataSheetGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
  protected
    procedure InitFields; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AfterConstruction; override;
    procedure ApplyNotShipmentFilter;
    procedure ApplyShipmentFilter;
    procedure SetDisplayFormat(const AFields: Array of TField);
    property StoreHouse: TFieldWrap read FStoreHouse;
    property BillTitle: TFieldWrap read FBillTitle;
    property PriceR: TFieldWrap read FPriceR;
    property ID: TFieldWrap read FID;
    property BillNumber: TFieldWrap read FBillNumber;
    property Amount: TFieldWrap read FAmount;
    property Barcode: TFieldWrap read FBarcode;
    property BatchNumber: TFieldWrap read FBatchNumber;
    property BillDate: TFieldWrap read FBillDate;
    property CustomsDeclarationNumber: TFieldWrap
      read FCustomsDeclarationNumber;
    property DescriptionComponentName: TFieldWrap
      read FDescriptionComponentName;
    property PriceD: TFieldWrap read FPriceD;
    property PriceD1: TFieldWrap read FPriceD1;
    property PriceD2: TFieldWrap read FPriceD2;
    property PriceD3: TFieldWrap read FPriceD3;
    property Datasheet: TFieldWrap read FDatasheet;
    property Diagram: TFieldWrap read FDiagram;
    property DocumentNumber: TFieldWrap read FDocumentNumber;
    property Dollar: TFieldWrap read FDollar;
    property BillDollar: TFieldWrap read FBillDollar;
    property Drawing: TFieldWrap read FDrawing;
    property Euro: TFieldWrap read FEuro;
    property BillEuro: TFieldWrap read FBillEuro;
    property Image: TFieldWrap read FImage;
    property LoadDate: TFieldWrap read FLoadDate;
    property OriginCountry: TFieldWrap read FOriginCountry;
    property OriginCountryCode: TFieldWrap read FOriginCountryCode;
    property Packaging: TFieldWrap read FPackaging;
    property PriceE: TFieldWrap read FPriceE;
    property PriceE1: TFieldWrap read FPriceE1;
    property PriceE2: TFieldWrap read FPriceE2;
    property PriceR1: TFieldWrap read FPriceR1;
    property PriceR2: TFieldWrap read FPriceR2;
    property Producer: TFieldWrap read FProducer;
    property ReleaseDate: TFieldWrap read FReleaseDate;
    property SaleCount: TFieldWrap read FSaleCount;
    property SaleD: TFieldWrap read FSaleD;
    property SaleE: TFieldWrap read FSaleE;
    property SaleR: TFieldWrap read FSaleR;
    property Seller: TFieldWrap read FSeller;
    property ShipmentDate: TFieldWrap read FShipmentDate;
    property Storage: TFieldWrap read FStorage;
    property StoragePlace: TFieldWrap read FStoragePlace;
    property SumSaleR: TFieldWrap read FSumSaleR;
    property Value: TFieldWrap read FValue;
    property Width: TFieldWrap read FWidth;
  end;

  TQryBillContentExport = class(TQueryBase)
    procedure FDQueryCalcFields(DataSet: TDataSet);
  private
    FW: TBillContentExportW;
    procedure DoBeforeOpen(Sender: TObject);
    { Private declarations }
  protected
    procedure DoOnCalcFields;
    procedure InitFieldDefs; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    function SearchByPeriod(ABeginDate, AEndDate: TDate): Integer;
    property W: TBillContentExportW read FW;
    { Public declarations }
  end;

implementation

uses
  NotifyEvents, System.IOUtils, StrHelper, System.StrUtils;

constructor TBillContentExportW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'ID', 'ID', True);
  FBillTitle := TFieldWrap.Create(Self, 'BillTitle', 'Счёт');
  FBillNumber := TFieldWrap.Create(Self, 'BillNumber');
  FBillDate := TFieldWrap.Create(Self, 'BillDate');

  FShipmentDate := TFieldWrap.Create(Self, 'ShipmentDate');
  FWidth := TFieldWrap.Create(Self, 'Width');

  FValue := TFieldWrap.Create(Self, 'Value', 'Наименование');
  FStoreHouse := TFieldWrap.Create(Self, 'StoreHouse', 'Склад');
  FProducer := TFieldWrap.Create(Self, 'Producer', 'Производитель');
  FDescriptionComponentName := TFieldWrap.Create(Self,
    'DescriptionComponentName', 'Краткое описание');

  FDatasheet := TFieldWrap.Create(Self, 'DataSheet', 'Спецификация');
  FDiagram := TFieldWrap.Create(Self, 'Diagram', 'Схема');
  FDrawing := TFieldWrap.Create(Self, 'Drawing', 'Чертёж');
  FImage := TFieldWrap.Create(Self, 'Image', 'Изображение');

  FReleaseDate := TFieldWrap.Create(Self, 'ReleaseDate', 'Дата выпуска');
  FAmount := TFieldWrap.Create(Self, 'Amount', 'Остаток');
  FPackaging := TFieldWrap.Create(Self, 'Packaging', 'Упаковка');

  FPriceR := TFieldWrap.Create(Self, 'PriceR', '₽');
  FPriceD := TFieldWrap.Create(Self, 'PriceD', '$');
  FPriceE := TFieldWrap.Create(Self, 'PriceE', '€');
  FPriceR1 := TFieldWrap.Create(Self, 'PriceR1', '₽');
  FPriceD1 := TFieldWrap.Create(Self, 'PriceD1', '$');
  FPriceE1 := TFieldWrap.Create(Self, 'PriceE1', '€');
  FPriceR2 := TFieldWrap.Create(Self, 'PriceR2', '₽');
  FPriceD2 := TFieldWrap.Create(Self, 'PriceD2', '$');
  FPriceE2 := TFieldWrap.Create(Self, 'PriceE2', '€');

  FOriginCountryCode := TFieldWrap.Create(Self, 'OriginCountryCode',
    'Цифровой код');
  FOriginCountry := TFieldWrap.Create(Self, 'OriginCountry', 'Название');
  FBatchNumber := TFieldWrap.Create(Self, 'BatchNumber', 'Номер партии');
  FCustomsDeclarationNumber := TFieldWrap.Create(Self,
    'CustomsDeclarationNumber', 'Номер таможенной декларации');
  FStorage := TFieldWrap.Create(Self, 'Storage', 'Стеллаж №');
  FStoragePlace := TFieldWrap.Create(Self, 'StoragePlace', 'Место №');

  FSeller := TFieldWrap.Create(Self, 'Seller', 'Организация-продавец');
  FDocumentNumber := TFieldWrap.Create(Self, 'DocumentNumber', '№ документа');
  FBarcode := TFieldWrap.Create(Self, 'Barcode', 'Цифровой код');
  FLoadDate := TFieldWrap.Create(Self, 'LoadDate', 'Дата загрузки');

  FDollar := TFieldWrap.Create(Self, 'Dollar', '$');
  FEuro := TFieldWrap.Create(Self, 'Euro', '€');

  FSaleCount := TFieldWrap.Create(Self, 'SaleCount', 'Кол-во продажи');

  FBillDollar := TFieldWrap.Create(Self, 'BillDollar', '$');
  FBillEuro := TFieldWrap.Create(Self, 'BillEuro', '€');

  FSaleR := TFieldWrap.Create(Self, 'SaleR', '₽');
  FSaleD := TFieldWrap.Create(Self, 'SaleD', '$');
  FSaleE := TFieldWrap.Create(Self, 'SaleE', '€');

  FSumSaleR := TFieldWrap.Create(Self, 'SumSaleR', '₽');

  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, EventList);
end;

procedure TBillContentExportW.AfterConstruction;
begin
  inherited;
  if DataSet.Active then
    InitFields;
end;

procedure TBillContentExportW.DoAfterOpen(Sender: TObject);
begin
  SetFieldsRequired(False);
  SetFieldsReadOnly(False);

  InitFields;
end;

procedure TBillContentExportW.InitFields;
var
  i: Integer;
begin
  SetDisplayFormat([PriceR2.F, PriceD2.F, PriceE2.F, PriceR1.F, PriceD1.F,
    PriceE1.F, PriceR.F, PriceD.F, PriceE.F, SaleR.F, SaleD.F, SaleE.F,
    SumSaleR.F]);

  Datasheet.F.OnGetText := OnDataSheetGetText;
  Diagram.F.OnGetText := OnDataSheetGetText;
  Drawing.F.OnGetText := OnDataSheetGetText;
  Image.F.OnGetText := OnDataSheetGetText;

  BillTitle.F.FieldKind := fkInternalCalc;

  // делаем выравнивание всех полей по левому краю
  for i := 0 to DataSet.FieldCount - 1 do
  begin
    // Колонка итого останется выровненной по правому краю
    if DataSet.Fields[i] = SumSaleR.F then
      Continue;

    DataSet.Fields[i].Alignment := taLeftJustify;
  end;
end;

procedure TBillContentExportW.OnDataSheetGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
var
  S: string;
begin
  S := Sender.AsString;
  if DisplayText and not S.IsEmpty then
    Text := TPath.GetFileNameWithoutExtension(S);
end;

procedure TBillContentExportW.SetDisplayFormat(const AFields: Array of TField);
var
  I: Integer;
begin
  Assert(Length(AFields) > 0);

  for I := Low(AFields) to High(AFields) do
  begin
    // Если поле не TNumericField - значит запрос вернул 0 записей и не удалось определить тип поля
    if (AFields[I] is TNumericField) then
      (AFields[I] as TNumericField).DisplayFormat := '###,##0.00';
  end;
end;

constructor TQryBillContentExport.Create(AOwner: TComponent);
begin
  inherited;
  FW := TBillContentExportW.Create(FDQuery);
  TNotifyEventWrap.Create(W.BeforeOpen, DoBeforeOpen, W.EventList);
end;

procedure TQryBillContentExport.DoOnCalcFields;
begin
  inherited;

  W.BillTitle.F.AsString := Format('Счёт №%s от %s%s',
    [Format('%.' + W.Width.F.AsString + 'd', [W.BillNumber.F.AsInteger]),
    FormatDateTime('dd.mm.yyyy', W.BillDate.F.AsDateTime),
    IfThen(W.ShipmentDate.F.IsNull, '', Format(' отгружен %s',
    [FormatDateTime('dd.mm.yyyy', W.ShipmentDate.F.AsDateTime)]))]);
end;

procedure TQryBillContentExport.FDQueryCalcFields(DataSet: TDataSet);
begin
  inherited;
  DoOnCalcFields;
end;

function TQryBillContentExport.SearchByPeriod(ABeginDate,
  AEndDate: TDate): Integer;
var
  AED: TDate;
  ANewSQL: string;
  ASD: TDate;
  AStipulation: string;
begin
  if ABeginDate <= AEndDate then
  begin
    ASD := ABeginDate;
    AED := AEndDate;
  end
  else
  begin
    ASD := AEndDate;
    AED := ABeginDate;
  end;

  // Делаем замену в SQL запросе
  AStipulation := Format('%s >= date(''%s'')',
    [W.BillDate.FieldName, FormatDateTime('YYYY-MM-DD', ASD)]);
  ANewSQL := ReplaceInSQL(SQL, AStipulation, 0);

  // Делаем замену в SQL запросе
  AStipulation := Format('%s <= date(''%s'')',
    [W.BillDate.FieldName, FormatDateTime('YYYY-MM-DD', AED)]);
  ANewSQL := ReplaceInSQL(ANewSQL, AStipulation, 1);

  FDQuery.SQL.Text := ANewSQL;
  W.RefreshQuery;
  Result := FDQuery.RecordCount;
end;

{$R *.dfm}

procedure TBillContentExportW.ApplyNotShipmentFilter;
begin
  DataSet.Filter := Format('%s is null', [ShipmentDate.FieldName]);
  DataSet.Filtered := True;
end;

procedure TBillContentExportW.ApplyShipmentFilter;
begin
  DataSet.Filter := Format('%s is not null', [ShipmentDate.FieldName]);
  DataSet.Filtered := True;
end;

procedure TQryBillContentExport.DoBeforeOpen(Sender: TObject);
begin
  InitFieldDefs;
  W.CreateDefaultFields(False);
  W.InitFields;
end;

procedure TQryBillContentExport.InitFieldDefs;
begin
  if FDQuery.FieldDefs.Count > 0 then
  begin
    FDQuery.FieldDefs.Clear;
    FDQuery.Fields.Clear;
  end;
  FDQuery.FieldDefs.Update;

  // Вычисляемое название счёта
  FDQuery.FieldDefs.Add(W.BillTitle.FieldName, ftWideString, 100);
end;

end.
