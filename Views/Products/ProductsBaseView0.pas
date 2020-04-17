unit ProductsBaseView0;

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
  System.Contnrs, DescriptionPopupForm, cxDBExtLookupComboBox,
  cxFilter, cxData, cxDataStorage, cxNavigator, cxDBData, cxGridCustomTableView,
  cxGridTableView, cxGridBandedTableView, cxGridDBBandedTableView,
  cxGridCustomView, cxGrid, ExtraChargeView, System.Generics.Collections,
  cxDataControllerConditionalFormattingRulesManagerDialog,
  ExtraChargeSimpleView, DSWrap, HRTimer, dxNumericWheelPicker, cxTextEdit,
  cxCalendar, Vcl.ExtCtrls, cxCurrencyEdit, ProductsBaseQuery0,
  BaseProductsViewModel;

const
  WM_RESYNC_DATASET = WM_USER + 800;
  WM_AFTER_OPEN_OR_REFRESH = WM_USER + 802;
  WM_FULL_COLLAPSE = WM_USER + 803;

type
  TViewProductsBase0 = class(TfrmTreeList)
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
    clLoadDate: TcxDBTreeListColumn;
    clDollar: TcxDBTreeListColumn;
    clEuro: TcxDBTreeListColumn;
    actApplyBestFit: TAction;
    actExportToExcelDocument: TAction;
    clSaleCount: TcxDBTreeListColumn;
    clSaleR: TcxDBTreeListColumn;
    clSaleD: TcxDBTreeListColumn;
    clSaleE: TcxDBTreeListColumn;
    clStoreHouseID: TcxDBTreeListColumn;
    cxStyle2: TcxStyle;
    cxStyle3: TcxStyle;
    cxslFocusedColumn: TcxStyle;
    cxslSelectedColumn: TcxStyle;
    cxslOtherColumn: TcxStyle;
    cxslHighlited: TcxStyle;
    cxslSelectedColumn2: TcxStyle;
    cxbeiDate: TcxBarEditItem;
    Timer: TTimer;
    cxbeiTotalR: TcxBarEditItem;
    actCopyColumnHeader: TAction;
    N5: TMenuItem;
    dxBarButton1: TdxBarButton;
    procedure actApplyBestFitExecute(Sender: TObject);
    procedure actCopyColumnHeaderExecute(Sender: TObject);
    procedure actExportToExcelDocumentExecute(Sender: TObject);
    procedure actLoadDatasheetExecute(Sender: TObject);
    procedure actLoadDiagramExecute(Sender: TObject);
    procedure actLoadDrawingExecute(Sender: TObject);
    procedure actLoadImageExecute(Sender: TObject);
    procedure actOpenDatasheetExecute(Sender: TObject);
    procedure actOpenDiagramExecute(Sender: TObject);
    procedure actOpenDrawingExecute(Sender: TObject);
    procedure actOpenImageExecute(Sender: TObject);
    procedure actRefreshCourcesExecute(Sender: TObject);
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
    procedure clDescriptionPropertiesInitPopup(Sender: TObject);
    procedure cxbeiDollarPropertiesValidate(Sender: TObject;
      var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
    procedure cxbeiEuroChange(Sender: TObject);
    procedure cxDBTreeListColumnHeaderClick(Sender: TcxCustomTreeList;
      AColumn: TcxTreeListColumn);
    procedure cxDBTreeListExpanded(Sender: TcxCustomTreeList;
      ANode: TcxTreeListNode);
    procedure PopupMenuPopup(Sender: TObject);
    procedure cxDBTreeListAfterSummary(Sender: TObject);
    procedure cxDBTreeListEdited(Sender: TcxCustomTreeList;
      AColumn: TcxTreeListColumn);
    procedure TimerTimer(Sender: TObject);
    procedure clIDProducerPropertiesNewLookupDisplayText(Sender: TObject;
      const AText: TCaption);
  private
    FCountEvents: TObjectList;
    FcxTreeListBandHeaderCellViewInfo: TcxTreeListBandHeaderCellViewInfo;
    FcxTreeListColumnHeaderCellViewInfo: TcxTreeListColumnHeaderCellViewInfo;
    FfrmDescriptionPopup: TfrmDescriptionPopup;
    FM: TBaseProductsViewModel;
    FNeedResyncAfterPost: Boolean;
    FReadOnlyColumns: TList<TcxDBTreeListColumn>;
    FSelArr: TArray<Integer>;

  const
    KeyFolder: String = 'Products';
    procedure DoAfterCommitUpdates(Sender: TObject);
    procedure DoAfterDataChange(Sender: TObject);
    procedure DoAfterDelete(Sender: TObject);
    procedure DoAfterOpen(Sender: TObject);
    procedure DoAfterOpenOrRefresh(Sender: TObject);
    procedure DoAfterPost(Sender: TObject);
    procedure DoBeforeOpenOrRefresh(Sender: TObject);
    procedure DoOnDescriptionPopupHide(Sender: TObject);
    procedure ProcessResyncDataSetMessage(var Message: TMessage);
      message WM_RESYNC_DATASET;
    procedure ProcessSelectionChanged(var Message: TMessage);
      message WM_SELECTION_CHANGED;
    procedure SetM(const Value: TBaseProductsViewModel);
    procedure UpdateSelectedCount;
    { Private declarations }
  protected
    FResyncDataSetMessagePosted: Boolean;
    FSelectedCountPanelIndex: Integer;
    procedure ApplyGridSort; virtual;
    procedure UpdateBarComboText(AdxBarCombo: TdxBarCombo; AValue: Variant);
    procedure CreateCountEvents;
    function CreateProductView: TViewProductsBase0; virtual; abstract;
    procedure DoOnCourceChange(Sender: TObject);
    procedure DoOnDollarCourceChange(Sender: TObject);
    procedure DoOnEuroCourceChange(Sender: TObject);
    procedure ClearSelectionAfterOpenOrRefresh(var Message: TMessage);
      message WM_AFTER_OPEN_OR_REFRESH;
    procedure DoOnSelectionChange; virtual;
    function GetNodeID(ANode: TcxDBTreeListNode): TArray<Integer>;
    function GetW: TBaseProductsW; virtual;
    procedure InitializeColumns; override;
    procedure InternalRefreshData; override;
    function IsViewOK: Boolean; virtual;
    procedure OnFullCollapse(var Message: TMessage); message WM_FULL_COLLAPSE;
    procedure OnInitEditValue(Sender, AItem: TObject; AEdit: TcxCustomEdit;
      var AValue: Variant); virtual;
    procedure OpenDoc(ADocFieldInfo: TDocFieldInfo);
    procedure PostFullCollapseMessage;
    // TODO: SortList
    // function SortList(AList: TList<TProductRecord>; ASortMode: Integer)
    // : TList<TProductRecord>;
    procedure UpdateProductCount; virtual;
    procedure UploadDoc(ADocFieldInfo: TDocFieldInfo);
    property W: TBaseProductsW read GetW;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BeginUpdate; override;
    procedure ConnectView;
    procedure DisconnectView;
    procedure EndUpdate; override;
    procedure ExportToExcelDocument(const AFileName: String);
    function GetSelectedID: TArray<Integer>;
    function IsFocusedNodeEquals(AColumn: TcxDBTreeListColumn;
      AValue: Variant): Boolean;
    procedure UpdateView; override;
    property M: TBaseProductsViewModel read FM write SetM;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses DialogUnit, RepositoryDataModule, NotifyEvents, System.IOUtils,
  SettingsController, Winapi.Shellapi,
  System.StrUtils, GridSort, cxTLExportLink, OpenDocumentUnit, ProjectConst,
  HttpUnit, StrHelper, dxCore, CurrencyUnit, DBLookupComboBoxHelper,
  DataModule, MaxBillNumberQuery, MinWholeSaleForm, CreateBillForm, Vcl.Clipbrd;

const
  clClickedColor = clRed;

constructor TViewProductsBase0.Create(AOwner: TComponent);
var
  AcxPopupEditproperties: TcxPopupEditproperties;
begin
  inherited;

  // Где отображать кол-во выделенных записей
  FSelectedCountPanelIndex := 1;

  // Какую панель растягивать
  StatusBarEmptyPanelIndex := 2;

  ApplyGridSort;

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

  cxDBTreeList.OptionsSelection.HideFocusRect := True;
  cxDBTreeList.OptionsSelection.HideSelection := True;
  cxDBTreeList.OptionsView.FocusRect := False;
  cxDBTreeList.OptionsData.Deleting := False;
  cxDBTreeList.OptionsData.Inserting := False;
  cxDBTreeList.OptionsBehavior.ConfirmDelete := False;
  cxDBTreeList.OptionsBehavior.ImmediateEditor := True;

  // cxDBTreeList.OnCustomDrawDataCell := nil;
end;

destructor TViewProductsBase0.Destroy;
begin
  inherited;
  FreeAndNil(FReadOnlyColumns);
  FreeAndNil(FCountEvents);
end;

procedure TViewProductsBase0.actApplyBestFitExecute(Sender: TObject);
begin
  inherited;
  MyApplyBestFit;
  UpdateView;
end;

procedure TViewProductsBase0.actCopyColumnHeaderExecute(Sender: TObject);
var
  S: string;
begin
  inherited;

  S := '';

  // Если щелчок по заголовку бэнда
  if FcxTreeListBandHeaderCellViewInfo <> nil then
  begin
    S := FcxTreeListBandHeaderCellViewInfo.Band.Caption.Text.Trim;
  end;

  // Если щелчок по заголовку колонки
  if FcxTreeListColumnHeaderCellViewInfo <> nil then
  begin
    S := FcxTreeListColumnHeaderCellViewInfo.Column.Caption.Text.Trim;
    if S.IsEmpty and (FcxTreeListColumnHeaderCellViewInfo.Band <> nil) then
      S := FcxTreeListColumnHeaderCellViewInfo.Column.Position.Band.
        Caption.Text;
  end;

  if not S.IsEmpty then
    ClipBoard.AsText := S;
end;

procedure TViewProductsBase0.actExportToExcelDocumentExecute(Sender: TObject);
var
  AFileName: String;
  AViewProductsBase2: TViewProductsBase0;
begin
  inherited;

  Application.Hint := '';

  if not TDialog.Create.ShowDialog(TExcelFileSaveDialog,
    TSettings.Create.GetFolderFoExcelFile(KeyFolder), M.ExportFileName,
    AFileName) then
    Exit;

  AViewProductsBase2 := CreateProductView;
  try
    AViewProductsBase2.M := M;
    AViewProductsBase2.ExportToExcelDocument(AFileName);
  finally
    FreeAndNil(AViewProductsBase2);
  end;

end;

procedure TViewProductsBase0.actLoadDatasheetExecute(Sender: TObject);
begin
  inherited;
  // Если компонент из теоретической базы, то и документацию открываем оттуда
  if IsFocusedNodeEquals(clChecked, 1) then
    UploadDoc(TComponentDatasheetDoc.Create)
  else
    UploadDoc(TWareHouseDatasheetDoc.Create);
end;

procedure TViewProductsBase0.actLoadDiagramExecute(Sender: TObject);
begin
  inherited;
  // Если компонент из теоретической базы, то и документацию открываем оттуда
  if IsFocusedNodeEquals(clChecked, 1) then
    UploadDoc(TComponentDiagramDoc.Create)
  else
    UploadDoc(TWareHouseDiagramDoc.Create);
end;

procedure TViewProductsBase0.actLoadDrawingExecute(Sender: TObject);
begin
  inherited;
  // Если компонент из теоретической базы, то и документацию открываем оттуда
  if IsFocusedNodeEquals(clChecked, 1) then
    UploadDoc(TComponentDrawingDoc.Create)
  else
    UploadDoc(TWareHouseDrawingDoc.Create);
end;

procedure TViewProductsBase0.actLoadImageExecute(Sender: TObject);
begin
  inherited;
  // Если компонент из теоретической базы, то и документацию открываем оттуда
  if IsFocusedNodeEquals(clChecked, 1) then
    UploadDoc(TComponentImageDoc.Create)
  else
    UploadDoc(TWareHouseImageDoc.Create);
end;

procedure TViewProductsBase0.actOpenDatasheetExecute(Sender: TObject);
begin
  inherited;
  // Если компонент из теоретической базы, то и документацию открываем оттуда
  if IsFocusedNodeEquals(clChecked, 1) then
    OpenDoc(TComponentDatasheetDoc.Create)
  else
    OpenDoc(TWareHouseDatasheetDoc.Create);
end;

procedure TViewProductsBase0.actOpenDiagramExecute(Sender: TObject);
begin
  inherited;
  // Если компонент из теоретической базы, то и документацию открываем оттуда
  if IsFocusedNodeEquals(clChecked, 1) then
    OpenDoc(TComponentDiagramDoc.Create)
  else
    OpenDoc(TWareHouseDiagramDoc.Create);
end;

procedure TViewProductsBase0.actOpenDrawingExecute(Sender: TObject);
begin
  inherited;
  // Если компонент из теоретической базы, то и документацию открываем оттуда
  if IsFocusedNodeEquals(clChecked, 1) then
    OpenDoc(TComponentDrawingDoc.Create)
  else
    OpenDoc(TWareHouseDrawingDoc.Create);
end;

procedure TViewProductsBase0.actOpenImageExecute(Sender: TObject);
begin
  inherited;
  // Если компонент из теоретической базы, то и документацию открываем оттуда
  if IsFocusedNodeEquals(clChecked, 1) then
    OpenDoc(TComponentImageDoc.Create)
  else
    OpenDoc(TWareHouseImageDoc.Create);
end;

procedure TViewProductsBase0.actRefreshCourcesExecute(Sender: TObject);
begin
  inherited;
  try
    M.qProductsBase0.DollarCource := TMyCurrency.Create.GetCourses(2, Date);
    M.qProductsBase0.EuroCource := TMyCurrency.Create.GetCourses(3, Date);

    if M.qProductsBase0.FDQuery.State = dsBrowse then
      MyApplyBestFit;
  except
    TDialog.Create.ErrorMessageDialog('Курсы валют не обновлены');
  end;
  UpdateView;
end;

procedure TViewProductsBase0.ApplyGridSort;
begin
  GridSort.Add(TSortVariant.Create(clValue, [clValue]));
  GridSort.Add(TSortVariant.Create(clIDProducer, [clIDProducer, clValue]));
  GridSort.Add(TSortVariant.Create(clLoadDate, [clLoadDate, clValue]));
  ApplySort(clValue, soAscending);
end;

procedure TViewProductsBase0.BeginUpdate;
begin
  // Отписываемся от событий о смене кол-ва
  if UpdateCount = 0 then
  begin
    FCountEvents.Clear;
    // W.DataSet.DisableControls;
  end;

  inherited;
end;

procedure TViewProductsBase0.UpdateBarComboText(AdxBarCombo: TdxBarCombo;
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

procedure TViewProductsBase0.clDatasheetGetDisplayText
  (Sender: TcxTreeListColumn; ANode: TcxTreeListNode; var Value: string);
begin
  inherited;
  if not Value.IsEmpty then
    Value := TPath.GetFileNameWithoutExtension(Value);
end;

procedure TViewProductsBase0.clDescriptionPropertiesInitPopup(Sender: TObject);
begin
  inherited;
  Assert(FfrmDescriptionPopup <> nil);
  // Привязываем выпадающую форму к данным
  FfrmDescriptionPopup.DescriptionW := W;
end;

procedure TViewProductsBase0.CreateCountEvents;
begin
  // Подписываемся на события чтобы отслеживать кол-во
  TNotifyEventWrap.Create(W.AfterOpen, DoAfterOpen, FCountEvents);

  TNotifyEventWrap.Create(W.AfterPostM, DoAfterPost, FCountEvents);

  TNotifyEventWrap.Create(W.AfterDelete, DoAfterDelete, FCountEvents);

  UpdateProductCount;
end;

procedure TViewProductsBase0.cxbeiDollarChange(Sender: TObject);
var
  r: Double;
  S: string;
begin
  inherited;
  S := cxbeiDollar.EditValue;
  r := StrToFloatDef(S, 0);
  if (not S.IsEmpty and (r = 0)) or (M.qProductsBase0.DollarCource = r) then
    Exit;

  // Обновлям курс доллара
  M.qProductsBase0.DollarCource := r;
end;

procedure TViewProductsBase0.cxbeiDollarPropertiesValidate(Sender: TObject;
  var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
var
  X: Double;
begin
  inherited;
  if DisplayValue = '' then
    Exit;

  X := StrToFloatDef(DisplayValue, 0);
  if X > 0 then
    Exit;

  ErrorText := 'Редактируемое значение не является курсом валюты';
  Error := True;
end;

procedure TViewProductsBase0.cxbeiEuroChange(Sender: TObject);
var
  r: Double;
  S: string;
begin
  inherited;
  S := cxbeiEuro.EditValue;

  r := StrToFloatDef(S, 0);
  if ((not S.IsEmpty) and (r = 0)) or (M.qProductsBase0.EuroCource = r) then
    Exit;

  // Обновлям курс Евро
  M.qProductsBase0.EuroCource := r;
end;

procedure TViewProductsBase0.cxDBTreeListAfterSummary(Sender: TObject);
var
  AFooterSummaryItem: TcxTreeListSummaryItem;
  AValue: Variant;
begin
  inherited;
  AFooterSummaryItem := clSaleR.Summary.FooterSummaryItems.GetItemByKind(skSum);

  if AFooterSummaryItem = nil then
    Exit;

  AValue := cxDBTreeList.Summary.FooterSummaryValues[AFooterSummaryItem];

  cxbeiTotalR.EditValue := AValue;

end;

procedure TViewProductsBase0.cxDBTreeListBandHeaderClick
  (Sender: TcxCustomTreeList; ABand: TcxTreeListBand);
begin
  inherited;

  if ABand.VisibleColumnCount = 0 then
    Exit;

  ApplySort(ABand.VisibleColumns[0]);
  { }
end;

procedure TViewProductsBase0.cxDBTreeListColumnHeaderClick
  (Sender: TcxCustomTreeList; AColumn: TcxTreeListColumn);
begin
  inherited;
  ApplySort(AColumn);
end;

procedure TViewProductsBase0.cxDBTreeListCustomDrawDataCell
  (Sender: TcxCustomTreeList; ACanvas: TcxCanvas;
  AViewInfo: TcxTreeListEditCellViewInfo; var ADone: Boolean);
var
  AStyle: TcxStyle;
  IsClearAllSelection: Boolean;
  V: Variant;
begin
  inherited;

  // AStyle := nil;

  IsClearAllSelection := (AViewInfo.TreeList.SelectionCount = 0) and
    (not AViewInfo.Node.IsEditing);

  // Если снято всё выделение
  if IsClearAllSelection then
  begin
    AStyle := cxslOtherColumn;
  end
  else
  begin
    // Сфокусированная строка
    if (AViewInfo.Node.IsEditing and (AViewInfo.TreeList.SelectionCount = 0)) or
      ((AViewInfo.Node.Focused) and (AViewInfo.TreeList.SelectionCount = 1))
    then
    begin
      // Сфокусированный столбец
      if AViewInfo.Focused then
      begin
        AStyle := cxslFocusedColumn;
      end
      else
      begin
        // Несфокусированый столбец в сфокусированной строке
        AStyle := cxslSelectedColumn;
      end;
    end
    else if AViewInfo.Node.Selected then
    begin
      AStyle := cxslSelectedColumn2;
    end
    else
    begin
      AStyle := cxslOtherColumn;
    end;
  end;

  // Выделяем наименование, если оно есть в базе по компонентам
  if (AViewInfo.Column = clValue) and
    ((not AViewInfo.Focused) or IsClearAllSelection) then
  begin
    V := AViewInfo.Node.Values[clChecked.ItemIndex];
    if (not VarIsNull(V)) and (V = 1) then
      AStyle := cxslHighlited;
  end;

  // Выделяем цветом закупочную цену
  if ((AViewInfo.Column = clPriceR) or (AViewInfo.Column = clPriceD) or
    (AViewInfo.Column = clPriceE)) and
    ((not AViewInfo.Focused) or IsClearAllSelection) then
  begin
    V := AViewInfo.Node.Values[clIDCurrency.ItemIndex];
    if (not VarIsNull(V)) and (((V = 1) and (AViewInfo.Column = clPriceR)) or
      ((V = 2) and (AViewInfo.Column = clPriceD)) or
      ((V = 3) and (AViewInfo.Column = clPriceE))) then
      AStyle := cxslHighlited;
  end;

  if AStyle <> nil then
  begin
    ACanvas.Font.Color := AStyle.TextColor;
    ACanvas.FillRect(AViewInfo.BoundsRect, AStyle.Color);
  end;
end;

procedure TViewProductsBase0.cxDBTreeListEdited(Sender: TcxCustomTreeList;
  AColumn: TcxTreeListColumn);
var
  V: Variant;
begin
  inherited;
  if (AColumn <> clValue) or (VarToStrDef(AColumn.Value, '') = '') then
    Exit;

  V := Sender.FocusedNode.Values[clIsGroup.ItemIndex];

  if VarToStrDef(V, '') <> '1' then
    Exit;

  // Нужно сохранить запись в БД чтобы товар мог ссылаться на неё
  Sender.Post;
  // Мы просто завершаем транзакцию
  M.qProductsBase0.ApplyUpdates;

  UpdateView;
end;

procedure TViewProductsBase0.cxDBTreeListExpanded(Sender: TcxCustomTreeList;
  ANode: TcxTreeListNode);
begin
  inherited;
  if M.qProductsBase0.FDQuery.State = dsBrowse then
    MyApplyBestFit;
end;

procedure TViewProductsBase0.cxDBTreeListFocusedNodeChanged
  (Sender: TcxCustomTreeList; APrevFocusedNode, AFocusedNode: TcxTreeListNode);
begin
  inherited;
  {
    if AFocusedNode <> nil then
    begin
    UpdateAllBarComboText;
    end
    else
    begin
    // Отображаем ПУСТУЮ розничную наценку
    UpdateBarComboText(dxbcRetail, NULL);
    // Отображаем ПУСТУЮ оптовую наценку у текущей записи
    UpdateBarComboText(dxbcWholeSale, NULL);
    // Отображаем ПУСТУЮ минимальную оптовую наценку у текущей записи
    UpdateBarComboText(dxbcMinWholeSale, NULL);
    end;
  }
  UpdateView;
end;

procedure TViewProductsBase0.cxDBTreeListInitEditValue(Sender, AItem: TObject;
  AEdit: TcxCustomEdit; var AValue: Variant);

begin
  OnInitEditValue(Sender, AItem, AEdit, AValue)
end;

procedure TViewProductsBase0.cxDBTreeListIsGroupNode(Sender: TcxCustomTreeList;
  ANode: TcxTreeListNode; var IsGroup: Boolean);
var
  V: Variant;
begin
  inherited;
  V := ANode.Values[clIsGroup.ItemIndex];
  IsGroup := not VarIsNull(V) and (V = 1);
  { }
end;

procedure TViewProductsBase0.cxDBTreeListSelectionChanged(Sender: TObject);
begin
  inherited;

  if FPostSelectionChanged then
    Exit;

  PostMessage(Handle, WM_SELECTION_CHANGED, 0, 0);
  FPostSelectionChanged := True;
  UpdateView;
end;

procedure TViewProductsBase0.DoAfterDataChange(Sender: TObject);
begin
  UpdateView;
end;

procedure TViewProductsBase0.DoAfterDelete(Sender: TObject);
begin
  UpdateProductCount;
end;

procedure TViewProductsBase0.DoAfterOpen(Sender: TObject);
begin
  UpdateProductCount;
  UpdateView;
end;

procedure TViewProductsBase0.DoAfterOpenOrRefresh(Sender: TObject);
begin
  // Привязываем дерево к данным !!!
  W.DataSource.Enabled := True;

  PostFullCollapseMessage;
  PostMessage(Handle, WM_AFTER_OPEN_OR_REFRESH, 0, 0);
  ClearSelection;

  UpdateView;
end;

procedure TViewProductsBase0.DoAfterPost(Sender: TObject);
begin
  if FNeedResyncAfterPost then
  begin
    FNeedResyncAfterPost := False;
    M.qProductsBase0.FDQuery.Resync([rmExact, rmCenter]);
  end;

  UpdateProductCount;
  // MyApplyBestFit;
end;

procedure TViewProductsBase0.DoBeforeOpenOrRefresh(Sender: TObject);
begin
  W.DataSource.Enabled := False;
end;

procedure TViewProductsBase0.DoOnCourceChange(Sender: TObject);
begin
  if not(M.qProductsBase0.FDQuery.Active) or
    (M.qProductsBase0.FDQuery.RecordCount = 0) then
    Exit;

  FNeedResyncAfterPost := M.qProductsBase0.FDQuery.State in [dsEdit, dsInsert];
  if (not FNeedResyncAfterPost) and (not FResyncDataSetMessagePosted) then
  begin
    FResyncDataSetMessagePosted := True;
    PostMessage(Handle, WM_RESYNC_DATASET, 0, 0);
  end;
end;

procedure TViewProductsBase0.DoOnDollarCourceChange(Sender: TObject);
begin
  // Отображаем курс доллара в поле ввода
  cxbeiDollar.EditValue := M.qProductsBase0.DollarCource.ToString;
  DoOnCourceChange(Sender);
end;

procedure TViewProductsBase0.DoOnEuroCourceChange(Sender: TObject);
begin
  // Отображаем курс евро в поле ввода
  cxbeiEuro.EditValue := M.qProductsBase0.EuroCource.ToString;
  DoOnCourceChange(Sender);
end;

procedure TViewProductsBase0.DoOnDescriptionPopupHide(Sender: TObject);
begin
  UpdateView;
end;

procedure TViewProductsBase0.ClearSelectionAfterOpenOrRefresh
  (var Message: TMessage);
begin
  inherited;
  ClearSelection;
end;

procedure TViewProductsBase0.clIDProducerPropertiesNewLookupDisplayText
  (Sender: TObject; const AText: TCaption);
begin
  inherited;
  if AText = '' then
    Exit;

  // Ищем или добавляем такого производителя в справочнике производителей
  M.ProducersGroup.LocateOrAppend(AText, sWareHouseDefaultProducerType);
end;

procedure TViewProductsBase0.ConnectView;
begin
  cxDBTreeList.DataController.DataSource := W.DataSource;
end;

procedure TViewProductsBase0.DisconnectView;
begin
  cxDBTreeList.DataController.DataSource := nil;
end;

procedure TViewProductsBase0.DoAfterCommitUpdates(Sender: TObject);
begin
  UpdateView;
end;

procedure TViewProductsBase0.DoOnSelectionChange;
begin
  UpdateSelectedCount;
end;

procedure TViewProductsBase0.EndUpdate;
begin
  inherited;
  if UpdateCount = 0 then
  begin
    CreateCountEvents;
    // W.DataSet.EnableControls;
  end;
end;

procedure TViewProductsBase0.ExportToExcelDocument(const AFileName: String);
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

function TViewProductsBase0.GetNodeID(ANode: TcxDBTreeListNode)
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

function TViewProductsBase0.GetSelectedID: TArray<Integer>;
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

function TViewProductsBase0.GetW: TBaseProductsW;
begin
  Result := FM.qProductsBase0.BPW;
end;

procedure TViewProductsBase0.InitializeColumns;
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
    cxDBTreeList.Bands[i].Options.OnlyOwnColumns := True;
    // cxDBTreeList.Bands[i].Expandable := tlbeNotExpandable;

    for j := 0 to cxDBTreeList.Bands[i].ColumnCount - 1 do
    begin
      cxDBTreeList.Bands[i].Columns[j].Caption.MultiLine := True;
      cxDBTreeList.Bands[i].Columns[j].Caption.ShowEndEllipsis := False;

      AColumn := cxDBTreeList.Bands[i].Columns[j] as TcxDBTreeListColumn;
      if AColumn.DataBinding.FieldName <> '' then
      begin
        ASortVariant := GridSort.GetSortVariant(AColumn);
        AColumn.Options.Sorting := ASortVariant <> nil;
      end;
    end;
  end;

  Assert(FM <> nil);

  InitializeLookupColumn(clIDProducer, M.ProducersGroup.qProducers.W.DataSource,
    lsEditList, M.ProducersGroup.qProducers.W.Name.FieldName);

  // Прячем заголовок
  (clIDProducer.Properties as TcxLookupComboBoxProperties)
    .ListOptions.ShowHeader := False;
end;

procedure TViewProductsBase0.InternalRefreshData;
begin
  Assert(FM <> nil);
  W.RefreshQuery;
  cxDBTreeList.FullCollapse;
end;

function TViewProductsBase0.IsFocusedNodeEquals(AColumn: TcxDBTreeListColumn;
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

function TViewProductsBase0.IsViewOK: Boolean;
begin
  Result := True;
end;

procedure TViewProductsBase0.OnFullCollapse(var Message: TMessage);
begin
  cxDBTreeList.FullCollapse;
end;

procedure TViewProductsBase0.OnInitEditValue(Sender, AItem: TObject;
  AEdit: TcxCustomEdit; var AValue: Variant);
var
  AColumn: TcxDBTreeListColumn;
  AcxMaskEdit: TcxMaskEdit;
  S: string;
begin
  // В режиме вставки новой записи разрешаем редактирование цены
  if M.qProductsBase0.FDQuery.State = dsInsert then
    Exit;

  AColumn := AItem as TcxDBTreeListColumn;

  if FReadOnlyColumns.IndexOf(AColumn) < 0 then
    Exit;

  S := AEdit.ClassName;

  if not(AEdit is TcxMaskEdit) then
    Exit;

  AcxMaskEdit := AEdit as TcxMaskEdit;
  AcxMaskEdit.Properties.ReadOnly := True;
end;

procedure TViewProductsBase0.OpenDoc(ADocFieldInfo: TDocFieldInfo);
begin
  Application.Hint := '';
  TDocument.Open(Handle, ADocFieldInfo.Folder,
    M.qProductsBase0.FDQuery.FieldByName(ADocFieldInfo.FieldName).AsString,
    ADocFieldInfo.ErrorMessage, ADocFieldInfo.EmptyErrorMessage,
    sBodyTypesFilesExt);
end;

procedure TViewProductsBase0.PopupMenuPopup(Sender: TObject);
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

  actCopy.Visible := (FcxTreeListBandHeaderCellViewInfo = nil) and
    (FcxTreeListColumnHeaderCellViewInfo = nil);

  actCopyColumnHeader.Visible := (FcxTreeListBandHeaderCellViewInfo <> nil) or
    (FcxTreeListColumnHeaderCellViewInfo <> nil);
end;

procedure TViewProductsBase0.PostFullCollapseMessage;
begin
  PostMessage(Handle, WM_FULL_COLLAPSE, 0, 0);
end;

procedure TViewProductsBase0.ProcessResyncDataSetMessage(var Message: TMessage);
var
  ASelectionCount: Integer;
begin
  inherited;
  FResyncDataSetMessagePosted := False;

  if M.qProductsBase0.FDQuery.State <> dsBrowse then
    Exit;

  ASelectionCount := cxDBTreeList.SelectionCount;

  // Тут выделяется текущаяя запись
  M.qProductsBase0.FDQuery.Resync([ { rmExact, } rmCenter]);

  if ASelectionCount = 0 then
    cxDBTreeList.ClearSelection();

  UpdateView;
end;

procedure TViewProductsBase0.ProcessSelectionChanged(var Message: TMessage);
var
  ASelList: TList<Integer>;
  i: Integer;
  IsEqual: Boolean;
  SelArr: TArray<Integer>;
  V: Variant;
begin
  inherited;

  ASelList := TList<Integer>.Create;

  for i := 0 to cxDBTreeList.SelectionCount - 1 do
  begin
    V := cxDBTreeList.Selections[i].Values[clID.ItemIndex];
    if not VarIsNull(V) then
      ASelList.Add(V);
  end;
  SelArr := ASelList.ToArray;
  ASelList.Free;

  IsEqual := (Length(FSelArr) = Length(SelArr));
  if IsEqual then
    for i := Low(FSelArr) to High(FSelArr) do
    begin
      IsEqual := FSelArr[i] = SelArr[i];
      if not IsEqual then
        break;
    end;

  FSelArr := SelArr;

  if IsEqual then
  begin
    FPostSelectionChanged := False;
    Exit;
  end;

  DoOnSelectionChange;

  UpdateView;
  FPostSelectionChanged := False;
end;

procedure TViewProductsBase0.SetM(const Value: TBaseProductsViewModel);
begin
  if FM = Value then
    Exit;

  FEventList.Clear;

  FM := Value;

  if FM = nil then
    Exit;

  BeginUpdate;
  try
    cxDBTreeList.DataController.DataSource := W.DataSource;

    InitializeColumns;

    TNotifyEventWrap.Create(W.BeforeOpen, DoBeforeOpenOrRefresh, FEventList);
    TNotifyEventWrap.Create(W.BeforeRefresh, DoBeforeOpenOrRefresh, FEventList);

    TNotifyEventWrap.Create(W.AfterOpen, DoAfterOpenOrRefresh, FEventList);
    TNotifyEventWrap.Create(W.AfterRefresh, DoAfterOpenOrRefresh, FEventList);

    TNotifyEventWrap.Create(M.qProductsBase0.OnDollarCourceChange,
      DoOnDollarCourceChange, FEventList);

    TNotifyEventWrap.Create(M.qProductsBase0.OnEuroCourceChange,
      DoOnEuroCourceChange, FEventList);

    // подписываемся на события о смене количества и надбавки
    CreateCountEvents;

    // Просим монитор сообщать нам об изменении в БД
    TNotifyEventWrap.Create(M.qProductsBase0.Monitor.OnHaveAnyChanges,
      DoAfterDataChange, FEventList);

    TNotifyEventWrap.Create(M.qProductsBase0.AfterCommitUpdates,
      DoAfterCommitUpdates, FEventList);

    // Отображаем курс Доллара в поле ввода
    if M.qProductsBase0.DollarCource > 0 then
      cxbeiDollar.EditValue := M.qProductsBase0.DollarCource.ToString;

    // Отображаем курс Евро в поле ввода
    if M.qProductsBase0.EuroCource > 0 then
      cxbeiEuro.EditValue := M.qProductsBase0.EuroCource.ToString;
  finally
    EndUpdate;
  end;
  cxDBTreeList.FullCollapse;
  cxDBTreeList.ClearSelection();
  UpdateView;

  // Пытаемся обновить курсы валют
  if M.qProductsBase0.DollarCource = 0 then
    actRefreshCources.Execute;

  MyApplyBestFit;
end;

procedure TViewProductsBase0.TimerTimer(Sender: TObject);
begin
  inherited;
  cxbeiDate.EditValue := DateToStr(Date);
end;

procedure TViewProductsBase0.UpdateProductCount;
begin
  if (not StatusBar.Visible) or (StatusBar.Panels.Count = 0) then
    Exit;

  if M.NotGroupClone <> nil then
    // На выбранном складе или в результате поиска без учёта групп
    StatusBar.Panels[0].Text := Format('%d', [M.NotGroupClone.RecordCount]);
end;

procedure TViewProductsBase0.UpdateSelectedCount;
begin
  if (not StatusBar.Visible) or (StatusBar.Panels.Count = 0) then
    Exit;

  StatusBar.Panels[FSelectedCountPanelIndex].Text :=
    Format('%d', [cxDBTreeList.SelectionCount]);
end;

procedure TViewProductsBase0.UpdateView;
var
  OK: Boolean;
begin
  inherited;
  OK := (cxDBTreeList.DataController.DataSource <> nil) and (FM <> nil) and
    (M.qProductsBase0.FDQuery.Active) and IsViewOK and
    (cxDBTreeList.DataController.DataSet <> nil);

  actExportToExcelDocument.Enabled := OK and
    (cxDBTreeList.DataController.DataSet.RecordCount > 0);

  // Отображаем текущие курсы валют
  if M.qProductsBase0.DollarCource > 0 then
    cxbeiDollar.EditValue := M.qProductsBase0.DollarCource;

  if M.qProductsBase0.EuroCource > 0 then
    cxbeiEuro.EditValue := M.qProductsBase0.EuroCource;
end;

procedure TViewProductsBase0.UploadDoc(ADocFieldInfo: TDocFieldInfo);
var
  sourceFileName: string;
begin
  Application.Hint := '';
  // Открываем диалог выбора файла для загрузки
  if not TDialog.Create.ShowDialog(TMyOpenPictureDialog, ADocFieldInfo.Folder,
    '', sourceFileName) then
    Exit;

  M.qProductsBase0.LoadDocFile(sourceFileName, ADocFieldInfo);
end;

end.
