unit ProductsBaseView2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, TreeListFrame, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxCustomData, cxStyles, cxTL,
  cxTLdxBarBuiltInMenu, dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
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
  dxSkinXmas2008Blue, dxSkinsdxBarPainter, System.Actions, Vcl.ActnList,
  cxClasses, dxBar, cxInplaceContainer, cxTLData, cxDBTL,
  cxMaskEdit, cxDBLookupComboBox, cxDropDownEdit, cxBarEditItem, Data.DB,
  cxCalc, DocFieldInfo, cxButtonEdit, Vcl.Menus, cxEdit, Vcl.ComCtrls,
  System.Contnrs, DescriptionPopupForm, ProductsBaseQuery,
  cxDBExtLookupComboBox,
  cxFilter, cxData, cxDataStorage, cxNavigator, cxDBData, cxGridCustomTableView,
  cxGridTableView, cxGridBandedTableView, cxGridDBBandedTableView,
  cxGridCustomView, cxGrid, ExtraChargeView, System.Generics.Collections,
  cxDataControllerConditionalFormattingRulesManagerDialog,
  ExtraChargeSimpleView;

type
  TViewProductsBase2 = class(TfrmTreeList)
    actCommit: TAction;
    actRollback: TAction;
    actOpenInParametricTable: TAction;
    actAddCategory: TAction;
    clID: TcxDBTreeListColumn;
    clIsGroup: TcxDBTreeListColumn;
    clIDComponentGroup: TcxDBTreeListColumn;
    clValue: TcxDBTreeListColumn;
    clIDProducer: TcxDBTreeListColumn;
    clDescription: TcxDBTreeListColumn;
    clDatasheet: TcxDBTreeListColumn;
    clDiagram: TcxDBTreeListColumn;
    clDrawing: TcxDBTreeListColumn;
    clImage: TcxDBTreeListColumn;
    clPackagePins: TcxDBTreeListColumn;
    clReleaseDate: TcxDBTreeListColumn;
    clAmount: TcxDBTreeListColumn;
    clPackaging: TcxDBTreeListColumn;
    clPriceR2: TcxDBTreeListColumn;
    clPriceD2: TcxDBTreeListColumn;
    clPriceR1: TcxDBTreeListColumn;
    clPriceD1: TcxDBTreeListColumn;
    clPriceR: TcxDBTreeListColumn;
    clPriceD: TcxDBTreeListColumn;
    clOriginCountryCode: TcxDBTreeListColumn;
    clOriginCountry: TcxDBTreeListColumn;
    clBatchNumber: TcxDBTreeListColumn;
    clCustomsDeclarationNumber: TcxDBTreeListColumn;
    clStorage: TcxDBTreeListColumn;
    clStoragePlace: TcxDBTreeListColumn;
    clSeller: TcxDBTreeListColumn;
    clDocumentNumber: TcxDBTreeListColumn;
    clBarcode: TcxDBTreeListColumn;
    actAddComponent: TAction;
    actDelete: TAction;
    dxBarManagerBar2: TdxBar;
    dxbcRetail: TdxBarCombo;
    cxbeiDollar: TcxBarEditItem;
    actOpenDatasheet: TAction;
    actLoadDatasheet: TAction;
    actOpenImage: TAction;
    actLoadImage: TAction;
    actOpenDiagram: TAction;
    actLoadDiagram: TAction;
    actOpenDrawing: TAction;
    actLoadDrawing: TAction;
    cxStyleRepository1: TcxStyleRepository;
    cxStyle1: TcxStyle;
    cxNormalStyle: TcxStyle;
    clIDCurrency: TcxDBTreeListColumn;
    clChecked: TcxDBTreeListColumn;
    actRefreshCources: TAction;
    dxbbRefreshCources: TdxBarButton;
    cxbeiEuro: TcxBarEditItem;
    clPriceE: TcxDBTreeListColumn;
    clPriceE1: TcxDBTreeListColumn;
    clPriceE2: TcxDBTreeListColumn;
    cxbeiExtraCharge: TcxBarEditItem;
    dxbcWholeSale: TdxBarCombo;
    clLoadDate: TcxDBTreeListColumn;
    clDollar: TcxDBTreeListColumn;
    clEuro: TcxDBTreeListColumn;
    actBandWidth: TAction;
    N2: TMenuItem;
    actColumnAutoWidth: TAction;
    N3: TMenuItem;
    actColumnWidth: TAction;
    N4: TMenuItem;
    actApplyBestFit: TAction;
    actExportToExcelDocument: TAction;
    actColumnFilter: TAction;
    actColumnFilter1: TMenuItem;
    cxbeiExtraChargeType: TcxBarEditItem;
    dxbcMinWholeSale: TdxBarCombo;
    actClearPrice: TAction;
    dxBarButton11: TdxBarButton;
    clSaleCount: TcxDBTreeListColumn;
    clSaleR: TcxDBTreeListColumn;
    clSaleD: TcxDBTreeListColumn;
    clSaleE: TcxDBTreeListColumn;
    actCreateBill: TAction;
    dxbbCreateBill: TdxBarButton;
    procedure actAddCategoryExecute(Sender: TObject);
    procedure actAddComponentExecute(Sender: TObject);
    procedure actApplyBestFitExecute(Sender: TObject);
    procedure actBandWidthExecute(Sender: TObject);
    procedure actClearPriceExecute(Sender: TObject);
    procedure actColumnAutoWidthExecute(Sender: TObject);
    procedure actColumnFilterExecute(Sender: TObject);
    procedure actColumnWidthExecute(Sender: TObject);
    procedure actCommitExecute(Sender: TObject);
    procedure actCreateBillExecute(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure actExportToExcelDocumentExecute(Sender: TObject);
    procedure actLoadDatasheetExecute(Sender: TObject);
    procedure actLoadDiagramExecute(Sender: TObject);
    procedure actLoadDrawingExecute(Sender: TObject);
    procedure actLoadImageExecute(Sender: TObject);
    procedure actOpenDatasheetExecute(Sender: TObject);
    procedure actOpenDiagramExecute(Sender: TObject);
    procedure actOpenDrawingExecute(Sender: TObject);
    procedure actOpenImageExecute(Sender: TObject);
    procedure actOpenInParametricTableExecute(Sender: TObject);
    procedure actRefreshCourcesExecute(Sender: TObject);
    procedure actRollbackExecute(Sender: TObject);
    procedure clDatasheetGetDisplayText(Sender: TcxTreeListColumn;
      ANode: TcxTreeListNode; var Value: string);
    procedure cxbeiDollarChange(Sender: TObject);
    procedure cxDBTreeListBandHeaderClick(Sender: TcxCustomTreeList;
      ABand: TcxTreeListBand);
    procedure cxDBTreeListCustomDrawDataCell(Sender: TcxCustomTreeList;
      ACanvas: TcxCanvas; AViewInfo: TcxTreeListEditCellViewInfo;
      var ADone: Boolean);
    procedure cxDBTreeListIsGroupNode(Sender: TcxCustomTreeList;
      ANode: TcxTreeListNode; var IsGroup: Boolean);
    procedure cxDBTreeListFocusedNodeChanged(Sender: TcxCustomTreeList;
      APrevFocusedNode, AFocusedNode: TcxTreeListNode);
    procedure cxDBTreeListInitEditValue(Sender, AItem: TObject;
      AEdit: TcxCustomEdit; var AValue: Variant);
    procedure cxDBTreeListSelectionChanged(Sender: TObject);
    procedure dxbcRetailChange(Sender: TObject);
    procedure dxbcRetailDrawItem(Sender: TdxBarCustomCombo; AIndex: Integer;
      ARect: TRect; AState: TOwnerDrawState);
    procedure clDescriptionPropertiesInitPopup(Sender: TObject);
    procedure cxbeiDollarPropertiesValidate(Sender: TObject;
      var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
    procedure cxbeiEuroChange(Sender: TObject);
    procedure cxDBTreeListColumnHeaderClick(Sender: TcxCustomTreeList;
      AColumn: TcxTreeListColumn);
    procedure cxDBTreeListExpanded(Sender: TcxCustomTreeList;
      ANode: TcxTreeListNode);
    procedure dxbcWholeSaleChange(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
    procedure cxbeiExtraChargeTypePropertiesChange(Sender: TObject);
    procedure cxbeiExtraChargePropertiesChange(Sender: TObject);
    procedure dxbcMinWholeSaleChange(Sender: TObject);
  private
    FCountEvents: TObjectList;
    FcxTreeListBandHeaderCellViewInfo: TcxTreeListBandHeaderCellViewInfo;
    FcxTreeListColumnHeaderCellViewInfo: TcxTreeListColumnHeaderCellViewInfo;
    FfrmDescriptionPopup: TfrmDescriptionPopup;
    FNeedResyncAfterPost: Boolean;
    FqProductsBase: TQueryProductsBase;
    FReadOnlyColumns: TList<TcxDBTreeListColumn>;
    FViewExtraChargeSimple: TViewExtraChargeSimple;

  const
    KeyFolder: String = 'Products';
    procedure DoAfterDelete(Sender: TObject);
    procedure DoAfterLoad(Sender: TObject);
    procedure DoAfterOpen(Sender: TObject);
    procedure DoAfterPost(Sender: TObject);
    procedure DoOnDescriptionPopupHide(Sender: TObject);
    function GetIDExtraChargeType: Integer;
    function GetIDExtraCharge: Integer;
    function GetViewExtraChargeSimple: TViewExtraChargeSimple;
    procedure SaveBarComboValue(AdxBarCombo: TdxBarCombo;
      const AFieldName: String);
    procedure SetIDExtraCharge(const Value: Integer);
    procedure SetIDExtraChargeType(const Value: Integer);
    procedure SetqProductsBase(const Value: TQueryProductsBase);
    procedure UpdateSelectedCount;
    { Private declarations }
  protected
    FSelectedCountPanelIndex: Integer;
    procedure UpdateBarComboText(AdxBarCombo: TdxBarCombo; AValue: Variant);
    procedure CreateCountEvents;
    function CreateProductView: TViewProductsBase2; virtual; abstract;
    procedure DoBeforeLoad(Sender: TObject);
    procedure DoOnCourceChange(Sender: TObject);
    procedure DoOnDollarCourceChange(Sender: TObject);
    procedure DoOnEuroCourceChange(Sender: TObject);
    procedure ExportToExcelDocument(const AFileName: String);
    function GetNodeID(ANode: TcxDBTreeListNode): TArray<Integer>;
    procedure InitializeColumns; override;
    procedure InternalRefreshData; override;
    function IsSyncToDataSet: Boolean; override;
    procedure LoadWholeSale;
    procedure OpenDoc(ADocFieldInfo: TDocFieldInfo);
    function PerсentToRate(APerсent: Double): Double;
    function RateToPerсent(ARate: Double): Double;
    // TODO: SortList
    // function SortList(AList: TList<TProductRecord>; ASortMode: Integer)
    // : TList<TProductRecord>;
    procedure UpdateProductCount; virtual;
    procedure UpdateFieldValue(AFields: TArray<TField>;
      AValues: TArray<Variant>);
    procedure UploadDoc(ADocFieldInfo: TDocFieldInfo);
    property IDExtraChargeType: Integer read GetIDExtraChargeType
      write SetIDExtraChargeType;
    property IDExtraCharge: Integer read GetIDExtraCharge
      write SetIDExtraCharge;
    property ViewExtraChargeSimple: TViewExtraChargeSimple
      read GetViewExtraChargeSimple;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BeginUpdate; override;
    function CheckAndSaveChanges: Integer;
    procedure EndUpdate; override;
    function GetSelectedID: TArray<Integer>;
    function IsFocusedNodeEquals(AColumn: TcxDBTreeListColumn;
      AValue: Variant): Boolean;
    procedure UpdateView; override;
    property qProductsBase: TQueryProductsBase read FqProductsBase
      write SetqProductsBase;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses DialogUnit, RepositoryDataModule, NotifyEvents, System.IOUtils,
  SettingsController, Winapi.Shellapi,
  System.StrUtils, GridSort, cxTLExportLink, OpenDocumentUnit, ProjectConst,
  HttpUnit, StrHelper, dxCore, CurrencyUnit, DBLookupComboBoxHelper,
  DataModule, MaxBillNumberQuery;

const
  clClickedColor = clRed;

constructor TViewProductsBase2.Create(AOwner: TComponent);
var
  AcxPopupEditproperties: TcxPopupEditproperties;
begin
  inherited;
  // Список полей при редактировании которых Enter - сохранение
  PostOnEnterFields.Add(clPriceR.DataBinding.FieldName);
  PostOnEnterFields.Add(clPriceD.DataBinding.FieldName);
  PostOnEnterFields.Add(clPriceE.DataBinding.FieldName);
  PostOnEnterFields.Add(clSaleCount.DataBinding.FieldName);

  // Где отображать кол-во выделенных записей
  FSelectedCountPanelIndex := 1;

  // Какую панель растягивать
  StatusBarEmptyPanelIndex := 2;

  GridSort.Add(TSortVariant.Create(clValue, [clValue]));
  GridSort.Add(TSortVariant.Create(clIDProducer, [clIDProducer, clValue]));
  GridSort.Add(TSortVariant.Create(clLoadDate, [clLoadDate, clValue]));
  ApplySort(clValue, soAscending);

  FCountEvents := TObjectList.Create;

  // Всплывающая форма с кратким описанием
  FfrmDescriptionPopup := TfrmDescriptionPopup.Create(Self);
  AcxPopupEditproperties := clDescription.Properties as TcxPopupEditproperties;
  AcxPopupEditproperties.PopupControl := FfrmDescriptionPopup;
  // Вручную задаём обработчик события
  AcxPopupEditproperties.OnInitPopup := clDescriptionPropertiesInitPopup;
  TNotifyEventWrap.Create(FfrmDescriptionPopup.OnHide, DoOnDescriptionPopupHide,
    FEventList);

  // Список колонок только "для чтения"
  FReadOnlyColumns := TList<TcxDBTreeListColumn>.Create;
  FReadOnlyColumns.Add(clPriceR);
  FReadOnlyColumns.Add(clPriceD);
  FReadOnlyColumns.Add(clPriceE);
  FReadOnlyColumns.Add(clPriceR1);
  FReadOnlyColumns.Add(clPriceD1);
  FReadOnlyColumns.Add(clPriceE1);
  FReadOnlyColumns.Add(clPriceR2);
  FReadOnlyColumns.Add(clPriceD2);
  FReadOnlyColumns.Add(clPriceE2);
  FReadOnlyColumns.Add(clLoadDate);
  FReadOnlyColumns.Add(clDollar);
  FReadOnlyColumns.Add(clEuro);
  FReadOnlyColumns.Add(clSaleR);
  FReadOnlyColumns.Add(clSaleD);
  FReadOnlyColumns.Add(clSaleE);
end;

destructor TViewProductsBase2.Destroy;
begin
  inherited;
  FreeAndNil(FReadOnlyColumns);
  FreeAndNil(FCountEvents);
end;

procedure TViewProductsBase2.actAddCategoryExecute(Sender: TObject);
begin
  inherited;
  qProductsBase.W.AddCategory;

  // cxDBTreeList.ApplyBestFit;
  cxDBTreeList.SetFocus;

  // Переводим колонку в режим редактирования
  clValue.Editing := True;
end;

procedure TViewProductsBase2.actAddComponentExecute(Sender: TObject);
var
  AID: Integer;
begin
  inherited;

  // BeginBlockEvents;
  try

    cxDBTreeList.Post;

    if cxDBTreeList.FocusedNode.IsGroupNode then
      AID := FocusedNodeValue(clID)
    else
    begin
      Assert(cxDBTreeList.FocusedNode.Parent <> nil);
      AID := cxDBTreeList.FocusedNode.Parent.Values[clID.ItemIndex];
    end;

    qProductsBase.W.AddProduct(AID);

    // cxDBTreeList.ApplyBestFit;
    cxDBTreeList.SetFocus;

    // Переводим колонку в режим редактирования
    clValue.Editing := True;
  finally
    // EndBlockEvents;
  end;
end;

procedure TViewProductsBase2.actApplyBestFitExecute(Sender: TObject);
begin
  inherited;
  MyApplyBestFit;
end;

procedure TViewProductsBase2.actBandWidthExecute(Sender: TObject);
var
  ABand: TcxTreeListBand;
  S1: string;
  S2: string;
begin
  inherited;
  Assert(FcxTreeListBandHeaderCellViewInfo <> nil);
  ABand := FcxTreeListBandHeaderCellViewInfo.Band;

  S1 := Format('Band width = %d', [ABand.Width]);
  S2 := Format('Band display width = %d', [ABand.DisplayWidth]);

  ShowMessage(Format('%s'#13#10'%s', [S1, S2]));
end;

procedure TViewProductsBase2.actClearPriceExecute(Sender: TObject);
begin
  inherited;

  BeginUpdate;
  try
    FqProductsBase.ClearInternalCalcFields;
    FocusFirstNode;
  finally
    EndUpdate;
  end;
  UpdateView;
end;

procedure TViewProductsBase2.actColumnAutoWidthExecute(Sender: TObject);
var
  AColumn: TcxTreeListColumn;
begin
  inherited;
  Assert(FcxTreeListColumnHeaderCellViewInfo <> nil);
  AColumn := FcxTreeListColumnHeaderCellViewInfo.Column;
  AColumn.Caption.Text := ' ';
  AColumn.ApplyBestFit;
end;

procedure TViewProductsBase2.actColumnFilterExecute(Sender: TObject);
var
  AColumn: TcxTreeListColumn;
  S: string;
begin
  inherited;
  AColumn := FcxTreeListColumnHeaderCellViewInfo.Column;

  S := Format('Column filtering = %s',
    [BoolToStr(AColumn.Options.Filtering, True)]);

  ShowMessage(S);
end;

procedure TViewProductsBase2.actColumnWidthExecute(Sender: TObject);
var
  AColumn: TcxTreeListColumn;
  S1: string;
  S2: string;
begin
  inherited;
  Assert(FcxTreeListColumnHeaderCellViewInfo <> nil);
  AColumn := FcxTreeListColumnHeaderCellViewInfo.Column;

  S1 := Format('Column width = %d', [AColumn.Width]);
  S2 := Format('Column display width = %d', [AColumn.DisplayWidth]);

  ShowMessage(Format('%s'#13#10'%s', [S1, S2]));
end;

procedure TViewProductsBase2.actCommitExecute(Sender: TObject);
begin
  inherited;
  // Мы просто завершаем транзакцию
  FqProductsBase.ApplyUpdates;
  UpdateView;
end;

procedure TViewProductsBase2.actCreateBillExecute(Sender: TObject);
var
  ABillID: Integer;
  AStoreHouseProductID: Integer;
begin
  inherited;

  if (FqProductsBase.DollarCource = 0) or (FqProductsBase.EuroCource = 0) then
  begin
    TDialog.Create.DollarOrEuroCourceUnknown;
    Exit;
  end;

  // Добавляем новый счёт
  ABillID := TDM.Create.QryBill.W.AddBill(FqProductsBase.DollarCource,
    FqProductsBase.EuroCource);
  try
    FqProductsBase.Basket.DisableControls;
    try
      FqProductsBase.Basket.First;
      while not FqProductsBase.Basket.Eof do
      begin
        // Идентификатор связи товар-склад у нас отрицательный
        AStoreHouseProductID := -FqProductsBase.Basket.FieldByName
          (FqProductsBase.PKFieldName).AsInteger;

        TDM.Create.qBillContent.W.AddContent(ABillID, AStoreHouseProductID,
          FqProductsBase.Basket.FieldByName
          (FqProductsBase.W.SaleCount.FieldName).Value);

        FqProductsBase.Basket.Next;
      end;
    finally
      FqProductsBase.Basket.EnableControls;
    end;

  except
    // Удаляем добавленный счёт
    TDM.Create.QryBill.W.LocateByPKAndDelete(ABillID);
    raise;
  end;
end;

procedure TViewProductsBase2.actDeleteExecute(Sender: TObject);
var
  AID: Integer;
  AIDS: TList<Integer>;
  i: Integer;
  S: string;
begin
  inherited;
  if cxDBTreeList.SelectionCount = 0 then
    Exit;

  if cxDBTreeList.Selections[0].IsGroupNode then
    S := 'Удалить группу компонентов с текущего склада?'
  else
    S := Format('Удалить %s?', [IfThen(cxDBTreeList.SelectionCount = 1,
      'компонент', 'компоненты')]);

  if not(TDialog.Create.DeleteRecordsDialog(S)) then
    Exit;

  AIDS := TList<Integer>.Create;
  try
    // Заполняем список идентификаторов узлов, которые будем удалять
    for i := 0 to cxDBTreeList.SelectionCount - 1 do
    begin
      AIDS.Add(cxDBTreeList.Selections[i].Values[clID.ItemIndex]);
    end;

    cxDBTreeList.BeginUpdate;
    try
      for AID in AIDS do
        qProductsBase.DeleteNode(AID);
      // Это почему-то не работает
      // cxDBTreeList.DataController.DeleteFocused;
    finally
      cxDBTreeList.EndUpdate;
    end;

  finally
    FreeAndNil(AIDS);
  end;
  UpdateView;
end;

procedure TViewProductsBase2.actExportToExcelDocumentExecute(Sender: TObject);
var
  AFileName: String;
  AViewProductsBase2: TViewProductsBase2;
begin
  inherited;

  Application.Hint := '';

  if not TDialog.Create.ShowDialog(TExcelFileSaveDialog,
    TSettings.Create.GetFolderFoExcelFile(KeyFolder),
    qProductsBase.ExportFileName, AFileName) then
    Exit;

  AViewProductsBase2 := CreateProductView;
  try
    AViewProductsBase2.qProductsBase := qProductsBase;
    AViewProductsBase2.ExportToExcelDocument(AFileName);
  finally
    FreeAndNil(AViewProductsBase2);
  end;

end;

procedure TViewProductsBase2.actLoadDatasheetExecute(Sender: TObject);
begin
  inherited;
  // Если компонент из теоретической базы, то и документацию открываем оттуда
  if IsFocusedNodeEquals(clChecked, 1) then
    UploadDoc(TComponentDatasheetDoc.Create)
  else
    UploadDoc(TWareHouseDatasheetDoc.Create);
end;

procedure TViewProductsBase2.actLoadDiagramExecute(Sender: TObject);
begin
  inherited;
  // Если компонент из теоретической базы, то и документацию открываем оттуда
  if IsFocusedNodeEquals(clChecked, 1) then
    UploadDoc(TComponentDiagramDoc.Create)
  else
    UploadDoc(TWareHouseDiagramDoc.Create);
end;

procedure TViewProductsBase2.actLoadDrawingExecute(Sender: TObject);
begin
  inherited;
  // Если компонент из теоретической базы, то и документацию открываем оттуда
  if IsFocusedNodeEquals(clChecked, 1) then
    UploadDoc(TComponentDrawingDoc.Create)
  else
    UploadDoc(TWareHouseDrawingDoc.Create);
end;

procedure TViewProductsBase2.actLoadImageExecute(Sender: TObject);
begin
  inherited;
  // Если компонент из теоретической базы, то и документацию открываем оттуда
  if IsFocusedNodeEquals(clChecked, 1) then
    UploadDoc(TComponentImageDoc.Create)
  else
    UploadDoc(TWareHouseImageDoc.Create);
end;

procedure TViewProductsBase2.actOpenDatasheetExecute(Sender: TObject);
begin
  inherited;
  OpenDoc(TWareHouseDatasheetDoc.Create);
end;

procedure TViewProductsBase2.actOpenDiagramExecute(Sender: TObject);
begin
  inherited;
  OpenDoc(TWareHouseDiagramDoc.Create);
end;

procedure TViewProductsBase2.actOpenDrawingExecute(Sender: TObject);
begin
  inherited;
  OpenDoc(TWareHouseDrawingDoc.Create);
end;

procedure TViewProductsBase2.actOpenImageExecute(Sender: TObject);
begin
  inherited;

  OpenDoc(TWareHouseImageDoc.Create);
end;

procedure TViewProductsBase2.actOpenInParametricTableExecute(Sender: TObject);
begin
  inherited;
  Assert(qProductsBase.FDQuery.RecordCount > 0);

  if qProductsBase.W.Value.F.AsString.Trim.IsEmpty then
  begin
    TDialog.Create.ErrorMessageDialog('Не задано наименование');
    Exit;
  end;

  if qProductsBase.W.IDProducer.F.AsInteger = 0 then
  begin
    TDialog.Create.ErrorMessageDialog('Не задан производитель');
    Exit;
  end;

  if not qProductsBase.LocateInComponents then
  begin
    TDialog.Create.ErrorMessageDialog
      (Format('Компонент %s не найден в теоретической базе',
      [qProductsBase.W.Value.F.AsString]));
    Exit;
  end;

end;

procedure TViewProductsBase2.actRefreshCourcesExecute(Sender: TObject);
begin
  inherited;
  try
    qProductsBase.DollarCource := TMyCurrency.Create.GetCourses(2, Date);
    qProductsBase.EuroCource := TMyCurrency.Create.GetCourses(3, Date);
    MyApplyBestFit;
  except
    TDialog.Create.ErrorMessageDialog('Курсы валют не обновлены');
  end;
  UpdateView;
end;

procedure TViewProductsBase2.actRollbackExecute(Sender: TObject);
begin
  inherited;
  cxDBTreeList.BeginUpdate;
  try
    qProductsBase.CancelUpdates;
    cxDBTreeList.FullCollapse;
  finally
    cxDBTreeList.EndUpdate;
  end;
  UpdateView;
end;

procedure TViewProductsBase2.BeginUpdate;
begin
  // Отписываемся от событий о смене кол-ва
  if FUpdateCount = 0 then
    FCountEvents.Clear;

  inherited;
end;

procedure TViewProductsBase2.UpdateBarComboText(AdxBarCombo: TdxBarCombo;
  AValue: Variant);
begin
  AdxBarCombo.Tag := 1;
  try
    if VarIsNull(AValue) then
    begin
      AdxBarCombo.ItemIndex := -1;
      AdxBarCombo.Text := ''
    end
    else
      AdxBarCombo.Text := AValue;
  finally
    AdxBarCombo.Tag := 0;
  end;
end;

function TViewProductsBase2.CheckAndSaveChanges: Integer;
begin
  Result := 0;
  if qProductsBase = nil then
    Exit;

  UpdateView;

  if qProductsBase.HaveAnyChanges then
  begin
    Result := TDialog.Create.SaveDataDialog;
    case Result of
      IDYES:
        actCommit.Execute;
      IDNO:
        begin
          actRollback.Execute;
        end;
    end;
  end;
end;

procedure TViewProductsBase2.clDatasheetGetDisplayText
  (Sender: TcxTreeListColumn; ANode: TcxTreeListNode; var Value: string);
begin
  inherited;
  if not Value.IsEmpty then
    Value := TPath.GetFileNameWithoutExtension(Value);
end;

procedure TViewProductsBase2.clDescriptionPropertiesInitPopup(Sender: TObject);
begin
  inherited;
  Assert(FfrmDescriptionPopup <> nil);
  // Привязываем выпадающую форму к данным
  FfrmDescriptionPopup.DescriptionW := qProductsBase.W;
end;

procedure TViewProductsBase2.CreateCountEvents;
begin
  // Подписываемся на события чтобы отслеживать кол-во
  TNotifyEventWrap.Create(qProductsBase.W.AfterOpen, DoAfterOpen, FCountEvents);

  TNotifyEventWrap.Create(qProductsBase.W.AfterPostM, DoAfterPost,
    FCountEvents);

  TNotifyEventWrap.Create(qProductsBase.W.AfterDelete, DoAfterDelete,
    FCountEvents);

  UpdateProductCount;
end;

procedure TViewProductsBase2.cxbeiDollarChange(Sender: TObject);
var
  r: Double;
  S: string;
begin
  inherited;
  S := cxbeiDollar.EditValue;
  r := StrToFloatDef(S, 0);
  if (not S.IsEmpty and (r = 0)) or (FqProductsBase.DollarCource = r) then
    Exit;

  // Обновлям курс доллара
  FqProductsBase.DollarCource := r;
end;

procedure TViewProductsBase2.cxbeiDollarPropertiesValidate(Sender: TObject;
  var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
var
  x: Double;
begin
  inherited;
  if DisplayValue = '' then
    Exit;

  x := StrToFloatDef(DisplayValue, 0);
  if x > 0 then
    Exit;

  ErrorText := 'Редактируемое значение не является курсом валюты';
  Error := True;
end;

procedure TViewProductsBase2.cxbeiEuroChange(Sender: TObject);
var
  r: Double;
  S: string;
begin
  inherited;
  S := cxbeiEuro.EditValue;

  r := StrToFloatDef(S, 0);
  if ((not S.IsEmpty) and (r = 0)) or (FqProductsBase.EuroCource = r) then
    Exit;

  // Обновлям курс Евро
  FqProductsBase.EuroCource := r;
end;

procedure TViewProductsBase2.cxbeiExtraChargePropertiesChange(Sender: TObject);
begin
  inherited;
  (Sender as TcxExtLookupComboBox).PostEditValue;

  // Ищем выбранную запись о диапазоне и оптовой наценке
  qProductsBase.ExtraChargeGroup.qExtraCharge2.W.LocateByPK(IDExtraCharge);

  // Сохраняем выбранный диапазон и значение оптовой наценки
  UpdateFieldValue([FqProductsBase.W.IDExtraChargeType.F,
    FqProductsBase.W.IDExtraCharge.F, FqProductsBase.W.WholeSale.F],
    [IDExtraChargeType, IDExtraCharge,
    qProductsBase.ExtraChargeGroup.qExtraCharge2.W.WholeSale.F.Value]);

  // Выбираем это значение в выпадающем списке
  UpdateBarComboText(dxbcWholeSale,
    qProductsBase.ExtraChargeGroup.qExtraCharge2.W.WholeSale.F.Value);
end;

procedure TViewProductsBase2.cxbeiExtraChargeTypePropertiesChange
  (Sender: TObject);
var
  A: TArray<String>;
  S: string;
begin
  inherited;
  (Sender as TcxLookupComboBox).PostEditValue;

  // Фильтруем оптовые наценки по типу
  qProductsBase.ExtraChargeGroup.qExtraCharge2.W.FilterByType
    (cxbeiExtraChargeType.EditValue);

  // Помещаем пустое значение в качестве выбранного
  dxbcWholeSale.Tag := 1;
  try
    dxbcWholeSale.ItemIndex := -1;

    // Получаем список оптовых наценок
    A := qProductsBase.ExtraChargeGroup.qExtraCharge2.W.GetWholeSaleList;

    // Заполняем выпадающий список оптовых наценок
    dxbcWholeSale.Items.Clear;
    for S in A do
      dxbcWholeSale.Items.Add(S);
  finally
    dxbcWholeSale.Tag := 0;
  end;
end;

procedure TViewProductsBase2.cxDBTreeListBandHeaderClick
  (Sender: TcxCustomTreeList; ABand: TcxTreeListBand);
begin
  inherited;

  if ABand.VisibleColumnCount = 0 then
    Exit;

  ApplySort(ABand.VisibleColumns[0]);
  { }
end;

procedure TViewProductsBase2.cxDBTreeListColumnHeaderClick
  (Sender: TcxCustomTreeList; AColumn: TcxTreeListColumn);
begin
  inherited;
  ApplySort(AColumn);
end;

procedure TViewProductsBase2.cxDBTreeListCustomDrawDataCell
  (Sender: TcxCustomTreeList; ACanvas: TcxCanvas;
  AViewInfo: TcxTreeListEditCellViewInfo; var ADone: Boolean);
var
  V: Variant;
begin
  inherited;

  if (AViewInfo.Selected) and (AViewInfo.Column = cxDBTreeList.FocusedColumn)
  then
    Exit;

  if (AViewInfo.Column <> clPriceR) and (AViewInfo.Column <> clPriceD) and
    (AViewInfo.Column <> clValue) then
    Exit;

  if AViewInfo.Column = clValue then
  begin
    V := AViewInfo.Node.Values[clChecked.ItemIndex];
    if VarIsNull(V) then
      Exit;

    if V = 1 then
    begin
      // Пишем чёрным по белому
      ACanvas.Font.Color := clBlack;
      ACanvas.FillRect(AViewInfo.BoundsRect, $0099FF99);
    end;
    Exit;
  end;

  V := AViewInfo.Node.Values[clIDCurrency.ItemIndex];
  if VarIsNull(V) then
    Exit;

  if ((V = 1) and (AViewInfo.Column = clPriceR)) or
    ((V = 2) and (AViewInfo.Column = clPriceD)) then
  begin
    // Пишем чёрным по белому
    ACanvas.Font.Color := clBlack;
    ACanvas.FillRect(AViewInfo.BoundsRect, $0099FF99);
  end;
  { }
end;

procedure TViewProductsBase2.cxDBTreeListExpanded(Sender: TcxCustomTreeList;
  ANode: TcxTreeListNode);
begin
  inherited;
  MyApplyBestFit;
end;

procedure TViewProductsBase2.cxDBTreeListFocusedNodeChanged
  (Sender: TcxCustomTreeList; APrevFocusedNode, AFocusedNode: TcxTreeListNode);
begin
  inherited;

  // Отображаем розничную наценку у текущей записи
  UpdateBarComboText(dxbcRetail, FqProductsBase.W.Retail.F.Value);
  // Отображаем оптовую наценку у текущей записи
  UpdateBarComboText(dxbcWholeSale, FqProductsBase.W.WholeSale.F.Value);
  // Отображаем минимальную оптовую наценку у текущей записи
  UpdateBarComboText(dxbcMinWholeSale, FqProductsBase.W.MinWholeSale.F.Value);

  if IDExtraChargeType <> qProductsBase.W.IDExtraChargeType.F.AsInteger then
  begin
    IDExtraChargeType := qProductsBase.W.IDExtraChargeType.F.AsInteger;
    // Фильтруем оптовые наценки по типу
    qProductsBase.ExtraChargeGroup.qExtraCharge2.W.FilterByType
      (IDExtraChargeType);
  end;

  IDExtraCharge := qProductsBase.W.IDExtraCharge.F.AsInteger;

  UpdateView;
end;

procedure TViewProductsBase2.cxDBTreeListInitEditValue(Sender, AItem: TObject;
  AEdit: TcxCustomEdit; var AValue: Variant);
var
  AColumn: TcxDBTreeListColumn;
  AcxMaskEdit: TcxMaskEdit;
  S: string;
  // S: string;
begin
  inherited;
  // В режиме вставки новой записи разрешаем редактирование цены
  if qProductsBase.FDQuery.State = dsInsert then
    Exit;

  AColumn := AItem as TcxDBTreeListColumn;

  if FReadOnlyColumns.IndexOf(AColumn) < 0 then
    Exit;

  S := AEdit.ClassName;

  if not(AEdit is TcxMaskEdit) then
    Exit;

  AcxMaskEdit := AEdit as TcxMaskEdit;
  AcxMaskEdit.Properties.ReadOnly := True;
  { }
end;

procedure TViewProductsBase2.cxDBTreeListIsGroupNode(Sender: TcxCustomTreeList;
  ANode: TcxTreeListNode; var IsGroup: Boolean);
var
  V: Variant;
begin
  inherited;
  V := ANode.Values[clIsGroup.ItemIndex];
  IsGroup := not VarIsNull(V) and (V = 1);
  { }
end;

procedure TViewProductsBase2.cxDBTreeListSelectionChanged(Sender: TObject);
begin
  inherited;
  UpdateSelectedCount;
end;

procedure TViewProductsBase2.DoAfterDelete(Sender: TObject);
begin
  UpdateProductCount;
end;

procedure TViewProductsBase2.DoAfterLoad(Sender: TObject);
begin
  cxDBTreeList.EndUpdate;
  cxDBTreeList.FullCollapse;

  UpdateView;
end;

procedure TViewProductsBase2.DoAfterOpen(Sender: TObject);
begin
  UpdateProductCount;
  UpdateView;
end;

procedure TViewProductsBase2.DoAfterPost(Sender: TObject);
begin
  if FNeedResyncAfterPost then
  begin
    FNeedResyncAfterPost := False;
    FqProductsBase.FDQuery.Resync([rmExact, rmCenter]);
  end;

  UpdateProductCount;
  MyApplyBestFit;
end;

procedure TViewProductsBase2.DoBeforeLoad(Sender: TObject);
begin
  cxDBTreeList.BeginUpdate;
end;

procedure TViewProductsBase2.DoOnCourceChange(Sender: TObject);
begin
  if not(FqProductsBase.FDQuery.Active) or
    (FqProductsBase.FDQuery.RecordCount = 0) then
    Exit;

  FNeedResyncAfterPost := FqProductsBase.FDQuery.State in [dsEdit, dsInsert];
  if not FNeedResyncAfterPost then
    FqProductsBase.FDQuery.Resync([rmExact, rmCenter]);
end;

procedure TViewProductsBase2.DoOnDollarCourceChange(Sender: TObject);
begin
  // Отображаем курс доллара в поле ввода
  cxbeiDollar.EditValue := qProductsBase.DollarCource.ToString;
  DoOnCourceChange(Sender);
end;

procedure TViewProductsBase2.DoOnEuroCourceChange(Sender: TObject);
begin
  // Отображаем курс евро в поле ввода
  cxbeiEuro.EditValue := qProductsBase.EuroCource.ToString;
  DoOnCourceChange(Sender);
end;

procedure TViewProductsBase2.DoOnDescriptionPopupHide(Sender: TObject);
begin
  UpdateView;
end;

procedure TViewProductsBase2.dxbcMinWholeSaleChange(Sender: TObject);
begin
  inherited;
  SaveBarComboValue(Sender as TdxBarCombo,
    FqProductsBase.W.MinWholeSale.FieldName);
end;

procedure TViewProductsBase2.dxbcRetailChange(Sender: TObject);
begin
  inherited;
  SaveBarComboValue(Sender as TdxBarCombo, FqProductsBase.W.Retail.FieldName);
end;

procedure TViewProductsBase2.dxbcRetailDrawItem(Sender: TdxBarCustomCombo;
  AIndex: Integer; ARect: TRect; AState: TOwnerDrawState);
var
  S: string;
begin
  inherited;

  if odSelected in AState then
  begin
    Brush.Color := clClickedColor;
    Font.Color := clHighlightText;
  end
  else
  begin
    Brush.Color := clWindow;
    Font.Color := clWindowText;
  end;

  Sender.Canvas.FillRect(ARect);
  if odFocused in AState then
    DrawFocusRect(Sender.Canvas.Handle, ARect);

  if AIndex >= 0 then
    S := Sender.Items[AIndex]
  else
    S := Sender.Text;
  if S <> '' then
    S := S + '%';

  Sender.Canvas.TextOut(ARect.Left + 2, ARect.Top + 2, S);
end;

procedure TViewProductsBase2.dxbcWholeSaleChange(Sender: TObject);
begin
  inherited;
  SaveBarComboValue(Sender as TdxBarCombo,
    FqProductsBase.W.WholeSale.FieldName);
end;

procedure TViewProductsBase2.EndUpdate;
begin
  inherited;
  if FUpdateCount = 0 then
    CreateCountEvents;
end;

procedure TViewProductsBase2.ExportToExcelDocument(const AFileName: String);
const
  W = 15;
begin
  // BeginUpdate;
  try
    cxDBTreeList.Root.Expand(True);
    MyApplyBestFit;
    clDollar.Width := clDollar.Width + W;
    clEuro.Width := clEuro.Width + W;
    cxExportTLToExcel(AFileName, cxDBTreeList, True, True, True, 'xls');
    MyApplyBestFit;
  finally
    // EndUpdate;
  end;
end;

function TViewProductsBase2.GetIDExtraChargeType: Integer;
begin
  if VarIsNull(cxbeiExtraChargeType.EditValue) then
    Result := 0
  else
    Result := cxbeiExtraChargeType.EditValue;
end;

function TViewProductsBase2.GetIDExtraCharge: Integer;
begin
  Result := cxbeiExtraCharge.EditValue;
end;

function TViewProductsBase2.GetNodeID(ANode: TcxDBTreeListNode)
  : TArray<Integer>;
var
  AChildNode: TcxDBTreeListNode;
  AID: Integer;
  AIDList: TList<Integer>;
  i: Integer;
  V: Variant;
begin
  AIDList := TList<Integer>.Create;
  try
    V := ANode.Values[clID.ItemIndex];
    Assert(not VarIsNull(V));
    AID := V;
    if AIDList.IndexOf(AID) < 0 then
      AIDList.Add(AID);

    if ANode.HasChildren then
    begin
      for i := 0 to ANode.Count - 1 do
      begin
        AChildNode := ANode.Items[i] as TcxDBTreeListNode;
        AIDList.AddRange(GetNodeID(AChildNode));
      end;
    end;
    Result := AIDList.ToArray;
  finally
    FreeAndNil(AIDList);
  end;
end;

function TViewProductsBase2.GetSelectedID: TArray<Integer>;
var
  AIDList: TList<Integer>;
  ANode: TcxDBTreeListNode;
  i: Integer;
begin
  AIDList := TList<Integer>.Create;
  try
    for i := 0 to cxDBTreeList.SelectionCount - 1 do
    begin
      ANode := cxDBTreeList.Selections[i] as TcxDBTreeListNode;
      AIDList.AddRange(GetNodeID(ANode));
    end;
    Result := AIDList.ToArray;
  finally
    FreeAndNil(AIDList);
  end;
end;

function TViewProductsBase2.GetViewExtraChargeSimple: TViewExtraChargeSimple;
begin
  if FViewExtraChargeSimple = nil then
    FViewExtraChargeSimple := TViewExtraChargeSimple.Create(Self);

  Result := FViewExtraChargeSimple;
end;

procedure TViewProductsBase2.InitializeColumns;
var
  AColumn: TcxDBTreeListColumn;
  ASortVariant: TSortVariant;
  i: Integer;
  j: Integer;
begin
  for i := 0 to cxDBTreeList.Bands.Count - 1 do
  begin
    cxDBTreeList.Bands[i].Caption.MultiLine := True;
    cxDBTreeList.Bands[i].Caption.ShowEndEllipsis := False;
    // cxDBTreeList.Bands[i].Expandable := tlbeNotExpandable

    for j := 0 to cxDBTreeList.Bands[i].ColumnCount - 1 do
    begin
      cxDBTreeList.Bands[i].Columns[j].Caption.MultiLine := True;
      cxDBTreeList.Bands[i].Columns[j].Caption.ShowEndEllipsis := False;

      AColumn := cxDBTreeList.Bands[i].Columns[j] as TcxDBTreeListColumn;
      ASortVariant := GridSort.GetSortVariant(AColumn);
      AColumn.Options.Sorting := ASortVariant <> nil;
    end;
  end;

  Assert(FqProductsBase <> nil);

  InitializeLookupColumn(clIDProducer,
    FqProductsBase.ProducersGroup.qProducers.W.DataSource, lsEditFixedList,
    FqProductsBase.ProducersGroup.qProducers.W.Name.FieldName);
end;

procedure TViewProductsBase2.InternalRefreshData;
begin
  Assert(qProductsBase <> nil);
  qProductsBase.RefreshQuery;
  cxDBTreeList.FullCollapse;
end;

function TViewProductsBase2.IsFocusedNodeEquals(AColumn: TcxDBTreeListColumn;
  AValue: Variant): Boolean;
var
  ANode: TcxTreeListNode;
  V: Variant;
begin
  Assert(AColumn <> nil);
  Assert(not VarIsNull(AValue));

  Result := False;
  ANode := cxDBTreeList.FocusedNode;
  if ANode = nil then
    Exit;

  V := ANode.Values[AColumn.ItemIndex];
  Result := not VarIsNull(V) and (V = AValue);
end;

function TViewProductsBase2.IsSyncToDataSet: Boolean;
var
  S1: string;
  S2: string;
  V1: Variant;
  V2: Variant;
begin
  Result := inherited and (qProductsBase <> nil);
  if not Result then
    Exit;

  V1 := cxDBTreeList.FocusedNode.Values[clValue.ItemIndex];
  V2 := qProductsBase.W.Value.F.Value;

  Result := (not VarIsNull(V1)) and (not VarIsNull(V2));
  if not Result then
    Exit;
  S1 := V1;
  S2 := V2;
  Result := S1 = S2;
end;

procedure TViewProductsBase2.LoadWholeSale;
begin
  dxbcWholeSale.Items.BeginUpdate;
  try
    qProductsBase.ExtraChargeGroup.qExtraCharge2.FDQuery.DisableControls;
    try
      qProductsBase.ExtraChargeGroup.qExtraCharge2.FDQuery.First;
      while not qProductsBase.ExtraChargeGroup.qExtraCharge2.FDQuery.Eof do
      begin
        dxbcWholeSale.Items.Add(qProductsBase.ExtraChargeGroup.qExtraCharge2.W.
          WholeSale.F.AsString);
        qProductsBase.ExtraChargeGroup.qExtraCharge2.FDQuery.Next;
      end;
    finally
      qProductsBase.ExtraChargeGroup.qExtraCharge2.FDQuery.EnableControls;
    end;
  finally
    dxbcWholeSale.Items.EndUpdate;
  end;
end;

procedure TViewProductsBase2.OpenDoc(ADocFieldInfo: TDocFieldInfo);
begin
  Application.Hint := '';
  TDocument.Open(Handle, ADocFieldInfo.Folder,
    FqProductsBase.FDQuery.FieldByName(ADocFieldInfo.FieldName).AsString,
    ADocFieldInfo.ErrorMessage, ADocFieldInfo.EmptyErrorMessage,
    sBodyTypesFilesExt);
end;

function TViewProductsBase2.PerсentToRate(APerсent: Double): Double;
begin
  Result := 1 + APerсent / 100
end;

procedure TViewProductsBase2.PopupMenuPopup(Sender: TObject);
var
  AHitTest: TcxTreeListHitTest;
  S: string;
begin
  inherited;
  FcxTreeListBandHeaderCellViewInfo := nil;
  FcxTreeListColumnHeaderCellViewInfo := nil;

  AHitTest := cxDBTreeList.HitTest;

  S := AHitTest.HitCell.ClassName;

  // Если щёлкнули на заголовке колонки
  if AHitTest.HitCell is TcxTreeListColumnHeaderCellViewInfo then
  begin
    FcxTreeListColumnHeaderCellViewInfo :=
      AHitTest.HitCell as TcxTreeListColumnHeaderCellViewInfo;
  end;

  // Если щёлкнули на заголовке бэнда
  if AHitTest.HitCell is TcxTreeListBandHeaderCellViewInfo then
  begin
    FcxTreeListBandHeaderCellViewInfo :=
      AHitTest.HitCell as TcxTreeListBandHeaderCellViewInfo;
  end;

  actBandWidth.Enabled := FcxTreeListBandHeaderCellViewInfo <> nil;
  actColumnAutoWidth.Enabled := FcxTreeListColumnHeaderCellViewInfo <> nil;
  actColumnWidth.Enabled := FcxTreeListColumnHeaderCellViewInfo <> nil;
end;

function TViewProductsBase2.RateToPerсent(ARate: Double): Double;
begin
  if ARate <= 0 then
  begin
    Result := 0;
    Exit;
  end;

  if ARate > 1 then
  begin
    Result := (ARate - 1) * 100;
  end
  else
  begin
    Result := (1 - ARate) * -100
  end;

end;

procedure TViewProductsBase2.SaveBarComboValue(AdxBarCombo: TdxBarCombo;
  const AFieldName: String);
var
  AValue: Double;
begin
  Assert(AdxBarCombo <> nil);
  Assert(not AFieldName.IsEmpty);

  if AdxBarCombo.Tag = 1 then
    Exit;

  AValue := StrToFloatDef(AdxBarCombo.Text, 0);

  if AValue < 0 then
    AValue := 0;

  UpdateFieldValue([FqProductsBase.W.Field(AFieldName)], [AValue]);

  // если ввели какое-то недопустимое значение или 0
  if AValue = 0 then
    UpdateBarComboText(AdxBarCombo, NULL);

  UpdateView;
end;

procedure TViewProductsBase2.SetIDExtraCharge(const Value: Integer);
begin
  cxbeiExtraCharge.EditValue := Value;
end;

procedure TViewProductsBase2.SetIDExtraChargeType(const Value: Integer);
begin
  cxbeiExtraChargeType.EditValue := Value;
end;

procedure TViewProductsBase2.SetqProductsBase(const Value: TQueryProductsBase);
// var
// p: TcxExtLookupComboBoxProperties;
begin
  if FqProductsBase = Value then
    Exit;

  FqProductsBase := Value;

  if FqProductsBase = nil then
    Exit;

  cxDBTreeList.DataController.DataSource := FqProductsBase.W.DataSource;

  InitializeColumns;
  TNotifyEventWrap.Create(FqProductsBase.BeforeLoad, DoBeforeLoad, FEventList);
  TNotifyEventWrap.Create(FqProductsBase.AfterLoad, DoAfterLoad, FEventList);
  TNotifyEventWrap.Create(FqProductsBase.OnDollarCourceChange,
    DoOnDollarCourceChange, FEventList);
  TNotifyEventWrap.Create(FqProductsBase.OnEuroCourceChange,
    DoOnEuroCourceChange, FEventList);

  // подписываемся на события о смене количества и надбавки
  CreateCountEvents;

  // Фильтруем оптовые надбавки по типу
  FqProductsBase.ExtraChargeGroup.qExtraCharge2.W.FilterByType(0);

  // Привязываем представление оптовых надбавок
  TDBLCB.InitProp(cxbeiExtraChargeType.Properties as
    TcxLookupComboBoxProperties,
    FqProductsBase.ExtraChargeGroup.qExtraChargeType.W.DataSource,
    FqProductsBase.ExtraChargeGroup.qExtraChargeType.PK.FieldName,
    FqProductsBase.ExtraChargeGroup.qExtraChargeType.W.Name.FieldName,
    lsFixedList);

  ViewExtraChargeSimple.qExtraCharge :=
    FqProductsBase.ExtraChargeGroup.qExtraCharge2;
  TExtDBLCB.InitProp(cxbeiExtraCharge.Properties as
    TcxExtLookupComboBoxProperties, ViewExtraChargeSimple.MainView,
    FqProductsBase.ExtraChargeGroup.qExtraCharge2.PKFieldName,
    FqProductsBase.ExtraChargeGroup.qExtraCharge2.W.Range.FieldName,
    lsFixedList, True, True);

  LoadWholeSale;

  UpdateView;
  MyApplyBestFit;
end;

procedure TViewProductsBase2.UpdateProductCount;
begin
  // На выбранном складе или в результате поиска без учёта групп
  StatusBar.Panels[0].Text :=
    Format('%d', [qProductsBase.NotGroupClone.RecordCount]);
end;

procedure TViewProductsBase2.UpdateFieldValue(AFields: TArray<TField>;
  AValues: TArray<Variant>);
var
  ANode: TcxDBTreeListNode;
  AUpdatedIDList: TList<Integer>;
  i: Integer;
begin
  AUpdatedIDList := TList<Integer>.Create;
  FqProductsBase.FDQuery.DisableControls;
  try
    for i := 0 to cxDBTreeList.SelectionCount - 1 do
    begin
      ANode := cxDBTreeList.Selections[i] as TcxDBTreeListNode;
      // if ANode.IsGroupNode then
      // Continue;

      FqProductsBase.UpdateFieldValue(ANode.Values[clID.ItemIndex], AFields,
        AValues, AUpdatedIDList);
    end;
  finally
    FqProductsBase.FDQuery.EnableControls;
    FreeAndNil(AUpdatedIDList);
    MyApplyBestFit;
  end;
end;

procedure TViewProductsBase2.UpdateSelectedCount;
begin
  StatusBar.Panels[FSelectedCountPanelIndex].Text :=
    Format('%d', [cxDBTreeList.SelectionCount]);
end;

procedure TViewProductsBase2.UpdateView;
var
  OK: Boolean;
begin
  inherited;
  OK := (qProductsBase <> nil) and (qProductsBase.FDQuery.Active) and
    (qProductsBase.Master <> nil) and (qProductsBase.Master.FDQuery.Active) and
    (qProductsBase.Master.FDQuery.RecordCount > 0);

  actCommit.Enabled := OK and qProductsBase.HaveAnyChanges;
  actRollback.Enabled := actCommit.Enabled;
  actOpenInParametricTable.Enabled := OK and
    (cxDBTreeList.DataController.DataSet.RecordCount > 0);
  actExportToExcelDocument.Enabled := OK and
    (cxDBTreeList.DataController.DataSet.RecordCount > 0);
  actAddCategory.Enabled := OK;

  actAddComponent.Enabled := OK and (cxDBTreeList.FocusedNode <> nil);

  actDelete.Enabled := OK and (cxDBTreeList.FocusedNode <> nil) and
    (cxDBTreeList.DataController.DataSet.RecordCount > 0);

  // Отображаем текущие курсы валют
  if qProductsBase.DollarCource > 0 then
    cxbeiDollar.EditValue := qProductsBase.DollarCource;
  if qProductsBase.EuroCource > 0 then
    cxbeiEuro.EditValue := qProductsBase.EuroCource;

  actCreateBill.Enabled := OK and (qProductsBase.Basket.RecordCount > 0)
  { and (FqProductsBase.DollarCource > 0) and (FqProductsBase.EuroCource > 0) };
end;

procedure TViewProductsBase2.UploadDoc(ADocFieldInfo: TDocFieldInfo);
var
  sourceFileName: string;
begin
  Application.Hint := '';
  // Открываем диалог выбора файла для загрузки
  if not TDialog.Create.ShowDialog(TMyOpenPictureDialog, ADocFieldInfo.Folder,
    '', sourceFileName) then
    Exit;

  FqProductsBase.LoadDocFile(sourceFileName, ADocFieldInfo);
end;

end.
