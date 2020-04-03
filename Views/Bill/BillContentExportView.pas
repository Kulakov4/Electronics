unit BillContentExportView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, GridFrame, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, dxSkinsCore,
  dxSkinsDefaultPainters, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit,
  cxNavigator, dxDateRanges, Data.DB, cxDBData, dxBarBuiltInMenu,
  cxGridCustomPopupMenu, cxGridPopupMenu, Vcl.Menus, System.Actions,
  Vcl.ActnList, dxBar, cxClasses, Vcl.ComCtrls, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridBandedTableView,
  cxGridDBBandedTableView, cxGrid, BillContentExportQry;

type
  TViewBillContentExport = class(TfrmGrid)
    procedure cxGridDBBandedTableViewCustomDrawGroupCell
      (Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
      AViewInfo: TcxGridTableCellViewInfo; var ADone: Boolean);
  private
    procedure CreateBandForColumns(AColumnArr: TArray<TcxGridDBBandedColumn>;
      ABandCaption: string); overload;
    procedure CreateBandForColumn(AColumn: TcxGridDBBandedColumn); overload;
    procedure CreateBandForColumn(const AFieldName: string); overload;
    procedure CreateBandForColumns(AFieldNames: TArray<String>;
      ABandCaption: string); overload;
    function GetclBillTitle: TcxGridDBBandedColumn;
    function GetclSumSaleR: TcxGridDBBandedColumn;
    function GetclBillNumber: TcxGridDBBandedColumn;
    function GetclValue: TcxGridDBBandedColumn;
    function GetW: TBillContentExportW;
    procedure SetW(const Value: TBillContentExportW);
    { Private declarations }
  protected
    procedure InitColumns(AView: TcxGridDBBandedTableView); override;
  public
    function Export(const AFileName: string): String;
    property clBillTitle: TcxGridDBBandedColumn read GetclBillTitle;
    property clSumSaleR: TcxGridDBBandedColumn read GetclSumSaleR;
    property clBillNumber: TcxGridDBBandedColumn read GetclBillNumber;
    property clValue: TcxGridDBBandedColumn read GetclValue;
    property W: TBillContentExportW read GetW write SetW;
    { Public declarations }
  end;

implementation

uses
  cxGridExportLink, System.Generics.Collections, GridSort, System.IOUtils;

{$R *.dfm}

procedure TViewBillContentExport.CreateBandForColumns
  (AColumnArr: TArray<TcxGridDBBandedColumn>; ABandCaption: string);
var
  ABand: TcxGridBand;
  AChildBand: TcxGridBand;
  AColumn: TcxGridDBBandedColumn;
begin
  ABand := MainView.Bands.Add;
  ABand.Caption := ABandCaption;

  for AColumn in AColumnArr do
  begin
    AChildBand := MainView.Bands.Add;
    AChildBand.Position.BandIndex := ABand.Index;
    AChildBand.Caption := AColumn.Caption;
    AColumn.Position.BandIndex := AChildBand.Index;
  end;
end;

procedure TViewBillContentExport.CreateBandForColumn
  (AColumn: TcxGridDBBandedColumn);
var
  ABand: TcxGridBand;
begin
  Assert(AColumn <> nil);
  ABand := MainView.Bands.Add;
  ABand.Caption := AColumn.Caption;
  AColumn.Position.BandIndex := ABand.Index;
end;

procedure TViewBillContentExport.CreateBandForColumn(const AFieldName: string);
begin
  CreateBandForColumn(MainView.GetColumnByFieldName(AFieldName));
end;

procedure TViewBillContentExport.CreateBandForColumns
  (AFieldNames: TArray<String>; ABandCaption: string);
var
  AColumn: TcxGridDBBandedColumn;
  AFieldName: string;
  L: TList<TcxGridDBBandedColumn>;
begin
  L := TList<TcxGridDBBandedColumn>.Create;
  try
    for AFieldName in AFieldNames do
    begin
      AColumn := MainView.GetColumnByFieldName(AFieldName);
      Assert(AColumn <> nil);
      L.Add(AColumn);
    end;
    CreateBandForColumns(L.ToArray, ABandCaption);
  finally
    FreeAndNil(L);
  end;
end;

procedure TViewBillContentExport.cxGridDBBandedTableViewCustomDrawGroupCell
  (Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridTableCellViewInfo; var ADone: Boolean);
var
  ARect: TRect;
  AText: string;
//  i: Integer;
begin
  inherited;
  // Определяемся с тексом
  AText := AViewInfo.GridRecord.DisplayTexts[0];
  // i := AText.IndexOf('-');
  // AText := AText.Substring(i + 1);

  // Определяемся с границами ячейки
  ARect := AViewInfo.Bounds;

  ACanvas.FillRect(ARect);

  ARect.Left := ARect.Left + 30;
  ACanvas.DrawText(AText, ARect, cxAlignLeft);
  ADone := True;
end;

function TViewBillContentExport.Export(const AFileName: string): String;
var
  AFileExt: string;
begin
  MainView.DataController.Groups.FullExpand;
  MainView.ApplyBestFit;
  AFileExt := 'xls';
  Result := TPath.ChangeExtension(AFileName, AFileExt);

  // Экспортируем в Excel
  ExportGridToExcel(Result, cxGrid, True, True, True, AFileExt);

  // ExportViewToExcel(MainView, 'C:\Electronics DB\test.xls');
end;

function TViewBillContentExport.GetclBillTitle: TcxGridDBBandedColumn;
begin
  Result := MainView.GetColumnByFieldName(W.BillTitle.FieldName);
end;

function TViewBillContentExport.GetclSumSaleR: TcxGridDBBandedColumn;
begin
  Result := MainView.GetColumnByFieldName(W.SumSaleR.FieldName);
end;

function TViewBillContentExport.GetclBillNumber: TcxGridDBBandedColumn;
begin
  Result := MainView.GetColumnByFieldName(W.BillNumber.FieldName);
end;

function TViewBillContentExport.GetclValue: TcxGridDBBandedColumn;
begin
  Result := MainView.GetColumnByFieldName(W.Value.FieldName);
end;

function TViewBillContentExport.GetW: TBillContentExportW;
begin
  Result := DSWrap as TBillContentExportW;
end;

procedure TViewBillContentExport.InitColumns(AView: TcxGridDBBandedTableView);
begin
  inherited;
  clBillTitle.GroupIndex := 0;
  clBillTitle.Caption := '';

  CreateBandForColumn(W.Value.FieldName);
  // clValue.Position.Band.FixedKind := fkLeft;

  CreateBandForColumn(W.StoreHouse.FieldName);
  CreateBandForColumn(W.Producer.FieldName);
  CreateBandForColumn(W.DescriptionComponentName.FieldName);
  CreateBandForColumn(W.Datasheet.FieldName);
  CreateBandForColumn(W.Diagram.FieldName);
  CreateBandForColumn(W.Drawing.FieldName);
  CreateBandForColumn(W.Image.FieldName);
  CreateBandForColumn(W.ReleaseDate.FieldName);
  CreateBandForColumn(W.Amount.FieldName);
  CreateBandForColumn(W.Packaging.FieldName);

  CreateBandForColumns([W.PriceR2.FieldName, W.PriceD2.FieldName,
    W.PriceE2.FieldName], 'Оптовая цена');

  CreateBandForColumns([W.PriceR1.FieldName, W.PriceD1.FieldName,
    W.PriceE1.FieldName], 'Розничная цена (за 1 шт.)');

  CreateBandForColumns([W.PriceR.FieldName, W.PriceD.FieldName,
    W.PriceE.FieldName], 'Закупочная цена (без НДС)');

  CreateBandForColumns([W.OriginCountryCode.FieldName,
    W.OriginCountry.FieldName], 'Страна происхождения');

  CreateBandForColumn(W.BatchNumber.FieldName);
  CreateBandForColumn(W.CustomsDeclarationNumber.FieldName);

  CreateBandForColumns([W.Storage.FieldName, W.StoragePlace.FieldName],
    'Место хранения');

  CreateBandForColumn(W.Seller.FieldName);
  CreateBandForColumn(W.DocumentNumber.FieldName);
  CreateBandForColumn(W.Barcode.FieldName);
  CreateBandForColumn(W.LoadDate.FieldName);

  CreateBandForColumns([W.Dollar.FieldName, W.Euro.FieldName], 'Курсы валют');

  CreateBandForColumn(W.SaleCount.FieldName);

  CreateBandForColumns([W.SaleR.FieldName, W.SaleD.FieldName,
    W.SaleE.FieldName], 'Стоимость');

  CreateBandForColumns([clSumSaleR], 'Итого');
  clSumSaleR.Options.CellMerging := True;

  GridSort.Add(TSortVariant.Create(clBillNumber, [clBillNumber, clValue]));
  ApplySort(MainView, clBillNumber);
end;

procedure TViewBillContentExport.SetW(const Value: TBillContentExportW);
begin
  if DSWrap = Value then
    Exit;

  DSWrap := Value;
end;

end.
