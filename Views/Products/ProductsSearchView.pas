unit ProductsSearchView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, GridFrame, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB, cxDBData, System.Actions,
  Vcl.ActnList, dxBar, cxClasses, Vcl.ComCtrls, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridBandedTableView,
  cxGridDBBandedTableView, cxGrid, ProductsSearchQuery, ProductsBaseView,
  cxTextEdit, cxBlobEdit, cxButtonEdit, cxSpinEdit, cxCurrencyEdit,
  cxGridCustomPopupMenu, cxGridPopupMenu, Vcl.Menus, dxSkinsCore, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMetropolis,
  dxSkinMetropolisDark, dxSkinMoneyTwins, dxSkinOffice2007Black,
  dxSkinOffice2007Blue, dxSkinOffice2007Green, dxSkinOffice2007Pink,
  dxSkinOffice2007Silver, dxSkinOffice2010Black, dxSkinOffice2010Blue,
  dxSkinOffice2010Silver, dxSkinOffice2013DarkGray, dxSkinOffice2013LightGray,
  dxSkinOffice2013White, dxSkinOffice2016Colorful, dxSkinOffice2016Dark,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinsDefaultPainters, dxSkinValentine,
  dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, dxSkinscxPCPainter, dxSkinsdxBarPainter,
  cxDBLookupComboBox, ProductSearchGroupUnit, TreeListFrame, ProductsBaseView2,
  ProductsView2;

type
  TViewProductsSearch = class(TViewProductsBase)
    actSearch: TAction;
    actClear: TAction;
    actPasteFromBuffer: TAction;
    dxbrbtnSearch: TdxBarButton;
    dxbrbtnClear: TdxBarButton;
    dxbrbtnApply: TdxBarButton;
    dxbrbtnPasteFromBuffer: TdxBarButton;
    dxBarButton1: TdxBarButton;
    dxBarSubItem1: TdxBarSubItem;
    dxBarButton2: TdxBarButton;
    dxBarButton3: TdxBarButton;
    procedure actClearExecute(Sender: TObject);
    procedure actPasteFromBufferExecute(Sender: TObject);
    procedure actSearchExecute(Sender: TObject);
    procedure clStoreHouseExternalIDGetDisplayText
      (Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
      var AText: string);
    procedure cxGridDBBandedTableViewDataControllerCompare(ADataController
      : TcxCustomDataController; ARecordIndex1, ARecordIndex2,
      AItemIndex: Integer; const V1, V2: Variant; var Compare: Integer);
    procedure clValuePropertiesChange(Sender: TObject);
    procedure cxGridDBBandedTableView2EditKeyDown
      (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
      AEdit: TcxCustomEdit; var Key: Word; Shift: TShiftState);
  private
    procedure DoOnBeginUpdate(Sender: TObject);
    procedure DoOnEndUpdate(Sender: TObject);
    function GetProductSearchGroup: TProductSearchGroup;
    procedure Search(ALike: Boolean);
    // TODO: FEmptyAmount
    // constFEmptyAmount = 0;
    procedure SetProductSearchGroup(const Value: TProductSearchGroup);
    { Private declarations }
  protected
    procedure MyInitializeComboBoxColumn; override;
  public
    procedure FocusValueColumn;
    procedure UpdateView; override;
    property ProductSearchGroup: TProductSearchGroup read GetProductSearchGroup
      write SetProductSearchGroup;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses SearchInterfaceUnit, dxCore, DialogUnit, cxMemo,
  ClipboardUnit, cxDropDownEdit, RepositoryDataModule, NotifyEvents;

procedure TViewProductsSearch.actClearExecute(Sender: TObject);
begin
  if CheckAndSaveChanges <> IDCANCEL then
  begin
    cxGridDBBandedTableView.BeginUpdate();
    try
      ProductSearchGroup.qProductsSearch.ClearSearchResult;
      UpdateView;
    finally
      cxGridDBBandedTableView.EndUpdate;
    end;
    FocusValueColumn;
  end;
end;

procedure TViewProductsSearch.actPasteFromBufferExecute(Sender: TObject);
begin
  MainView.BeginUpdate();
  try
    ProductSearchGroup.qProductsSearch.AppendRows
      (ProductSearchGroup.qProductsSearch.Value.FieldName,
      TClb.Create.GetRowsAsArray);
    UpdateView;
  finally
    MainView.EndUpdate;
  end;
end;

procedure TViewProductsSearch.actSearchExecute(Sender: TObject);
begin
  Search(False);
end;

procedure TViewProductsSearch.clStoreHouseExternalIDGetDisplayText
  (Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
  var AText: string);
begin
  if AText <> '' then
    AText := Format('%.3d', [StrToInt(AText)]);
end;

procedure TViewProductsSearch.clValuePropertiesChange(Sender: TObject);
var
  S: String;
begin
  if Sender is TcxTextEdit then
    S := (Sender as TcxTextEdit).EditingText;
  if Sender is TcxAutoHeightInplaceEdit then
    S := (Sender as TcxAutoHeightInplaceEdit).Text;

  actClear.Enabled := ProductSearchGroup.qProductsSearch.IsClearEnabled or
    not S.IsEmpty;
  actSearch.Enabled := ProductSearchGroup.qProductsSearch.IsSearchEnabled or
    not S.IsEmpty;
end;

procedure TViewProductsSearch.cxGridDBBandedTableView2EditKeyDown
  (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
  AEdit: TcxCustomEdit; var Key: Word; Shift: TShiftState);
var
  AColumn: TcxGridDBBandedColumn;
begin
  inherited;
  AColumn := AItem as TcxGridDBBandedColumn;
  if (Key = 13) and
    (AColumn.DataBinding.FieldName = clValue2.DataBinding.FieldName) then
  begin
    Search(True);
  end;
end;

procedure TViewProductsSearch.cxGridDBBandedTableViewDataControllerCompare
  (ADataController: TcxCustomDataController; ARecordIndex1, ARecordIndex2,
  AItemIndex: Integer; const V1, V2: Variant; var Compare: Integer);
var
  AcxGridDBBandedColumn: TcxGridDBBandedColumn;
begin
  if AItemIndex = 1 then
  begin
    if VarIsNull(V1) and not(VarIsNull(V2)) then
      Compare := -1;
    if VarIsNull(V2) and not(VarIsNull(V1)) then
      Compare := 1;
    if VarIsNull(V1) and VarIsNull(V2) then
      Compare := 0;
    if not(VarIsNull(V1) or VarIsNull(V2)) then
    begin
      if V1 > V2 then
        Compare := -1;
      if V1 < V2 then
        Compare := 1;
      if V1 = V2 then
        Compare := 0;
    end;
  end
  else
  begin
    case VarCompareValue(V1, V2) of
      vrEqual:
        Compare := 0;
      vrLessThan:
        Compare := -1;
      vrGreaterThan:
        Compare := 1;
    else
      Compare := 0;
    end;
  end;

  AcxGridDBBandedColumn := cxGridDBBandedTableView.Columns[AItemIndex];

  if AcxGridDBBandedColumn.SortOrder = soAscending then
    Compare := Compare * (-1); // инвертировать порядок при необходимости

end;

procedure TViewProductsSearch.DoOnBeginUpdate(Sender: TObject);
begin
  cxGridDBBandedTableView.BeginUpdate();
end;

procedure TViewProductsSearch.DoOnEndUpdate(Sender: TObject);
begin
  cxGridDBBandedTableView.EndUpdate();
  ApplyBestFitEx();
  UpdateView;
end;

procedure TViewProductsSearch.FocusValueColumn;
begin
  FocusColumnEditor(0, ProductSearchGroup.qProductsSearch.Value.FieldName);
end;

function TViewProductsSearch.GetProductSearchGroup: TProductSearchGroup;
begin
  Result := ProductBaseGroup as TProductSearchGroup;
end;

procedure TViewProductsSearch.MyInitializeComboBoxColumn;
begin
  inherited;
  // Инициализируем колонку с выпадающи списком складов
  InitializeLookupColumn(clStorehouseID2,
    ProductSearchGroup.qProductsSearch.qStoreHouseList.DataSource,
    lsEditFixedList, ProductSearchGroup.qProductsSearch.qStoreHouseList.
    Abbreviation.FieldName);
end;

procedure TViewProductsSearch.Search(ALike: Boolean);
begin
  cxGridDBBandedTableView.BeginUpdate(lsimPending);
  try
    CheckAndSaveChanges;
    ProductSearchGroup.qProductsSearch.DoSearch(ALike);
    UpdateView;
  finally
    cxGridDBBandedTableView.EndUpdate;
  end;
  ApplyBestFitEx();
  FocusValueColumn;
end;

procedure TViewProductsSearch.SetProductSearchGroup
  (const Value: TProductSearchGroup);
begin
  ProductBaseGroup := Value;

  if ProductBaseGroup <> nil then
  begin
    TNotifyEventWrap.Create(ProductSearchGroup.qProductsSearch.OnBeginUpdate,
      DoOnBeginUpdate, FEventList);
    TNotifyEventWrap.Create(ProductSearchGroup.qProductsSearch.OnEndUpdate,
      DoOnEndUpdate, FEventList);
  end;
end;

procedure TViewProductsSearch.UpdateView;
var
  Ok: Boolean;
begin
  inherited;
  Ok := (ProductSearchGroup <> nil) and
    (ProductSearchGroup.qProductsBase.FDQuery.Active);

  actClear.Enabled := ProductSearchGroup.qProductsSearch.IsClearEnabled;

  actSearch.Enabled := ProductSearchGroup.qProductsSearch.IsSearchEnabled;

  actCommit.Enabled := Ok and ProductSearchGroup.HaveAnyChanges and
    (ProductSearchGroup.qProductsSearch.Mode = RecordsMode);

  actRollback.Enabled := actCommit.Enabled;

  actPasteFromBuffer.Enabled := ProductSearchGroup.qProductsSearch.Mode =
    SearchMode;

  cxGridDBBandedTableView.OptionsData.Appending :=
    ProductSearchGroup.qProductsSearch.Mode = SearchMode;

  cxGridDBBandedTableView.OptionsData.Inserting :=
    ProductSearchGroup.qProductsSearch.Mode = SearchMode;

  actExportToExcelDocument.Enabled := Ok and
    (MainView.DataController.RecordCount > 0) and
    (ProductSearchGroup.qProductsSearch.Mode = RecordsMode);
end;

end.
