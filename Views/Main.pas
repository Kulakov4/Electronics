unit Main;

interface

{$WARN UNIT_PLATFORM OFF}

uses
  Windows, Messages, Variants, Graphics, Controls, Forms,
  Dialogs, dxSkinsdxBarPainter, dxBar, cxClasses,
  Menus, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxCustomData, cxStyles, cxTL, cxTLdxBarBuiltInMenu, dxSkinscxPCPainter,
  cxPCdxBarPopupMenu, cxPC, cxSplitter, StdCtrls, cxButtons, cxInplaceContainer,
  cxTLData, cxDBTL, ExtCtrls, dxSkinsdxStatusBarPainter, dxStatusBar,
  cxFilter, cxData, cxDataStorage, cxEdit, cxDBData, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxMaskEdit, ComCtrls, dxtree, dxdbtree, dxBarBuiltInMenu,
  cxTextEdit, cxBlobEdit, cxLabel, cxMemo, cxNavigator, RootForm,
  System.UITypes, System.Types, System.Contnrs, NotifyEvents, System.Actions,
  Vcl.ActnList, dxSkinsCore, dxSkinsDefaultPainters, GridFrame,
  ComponentsBaseView, ComponentsView, ComponentsSearchView,
  ComponentsParentView, ParametricTableView, CustomExcelTable,
  ExcelDataModule, ParameterValuesUnit, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
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
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVisualStudio2013Blue,
  dxSkinVisualStudio2013Dark, dxSkinVisualStudio2013Light, dxSkinVS2010,
  dxSkinWhiteprint, dxSkinXmas2008Blue, DocFieldInfo,
  System.Generics.Collections, CustomErrorTable, Data.DB, System.Classes,
  SearchCategoriesPathQuery, FieldInfoUnit, CategoryParametersView,
  StoreHouseInfoView, ProductsTabSheetView,
  Vcl.AppEvnts, HintWindowEx, ProtectUnit, TreeListView, System.SysUtils,
  BaseEventsQuery, cxDataControllerConditionalFormattingRulesManagerDialog,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  ChildCategoriesView, StoreHouseListView, ProductsBasketView,
  ProductsSearchView2, ProductsView2, BillListView, BillContentView,
  Vcl.ToolWin, CompFrameUnit, ComponentTypeSetUnit, ProgressBarForm3,
  ProgressInfo;

type
  TfrmMain = class(TfrmRoot)
    bmMain: TdxBarManager;
    dxbrMainBar1: TdxBar;
    dxBarSubItem1: TdxBarSubItem;
    dxbrsbtm1: TdxBarSubItem;
    dxbbOptions: TdxBarButton;
    dxbrsprtr1: TdxBarSeparator;
    dxbrbtn2: TdxBarButton;
    dxbrbtn3: TdxBarButton;
    dxbrbtn5: TdxBarButton;
    dxbrbtn6: TdxBarButton;
    dxbrbtn7: TdxBarButton;
    sbMain: TdxStatusBar;
    dxbrMainBar2: TdxBar;
    dxbrbtnSettings: TdxBarButton;
    ActionList: TActionList;
    actShowProducers: TAction;
    actShowDescriptions: TAction;
    actShowParameters: TAction;
    actShowBodyTypes2: TAction;
    dxBarButton2: TdxBarButton;
    actShowBodyTypes3: TAction;
    actSelectDataBasePath: TAction;
    actSaveAll: TAction;
    dxBarButton4: TdxBarButton;
    actExit: TAction;
    actLoadBodyTypes: TAction;
    dxBarButton10: TdxBarButton;
    actShowExtraCharge: TAction;
    dxBarButton1: TdxBarButton;
    ApplicationEvents: TApplicationEvents;
    actComponentsTab: TAction;
    cxpcMain: TcxPageControl;
    cxtshComp: TcxTabSheet;
    cxtshWareHouse: TcxTabSheet;
    cxpcComp2: TcxPageControl;
    cxtshCompGroup: TcxTabSheet;
    cxtshCompSearch: TcxTabSheet;
    cxpcWareHouse2: TcxPageControl;
    cxtshWareHouse2: TcxTabSheet;
    cxtshBasket: TcxTabSheet;
    cxtshBill: TcxTabSheet;
    cxtshSearch: TcxTabSheet;
    pnlCompGroupLeft: TPanel;
    cxspltrMain: TcxSplitter;
    pnlCompGroupRight: TPanel;
    cxpcCompGroupRight: TcxPageControl;
    cxtsCategory: TcxTabSheet;
    cxtsCategoryComponents: TcxTabSheet;
    cxtsCategoryParameters: TcxTabSheet;
    cxtsParametricTable: TcxTabSheet;
    pnlStoreHouseLeft: TPanel;
    cxSplitterStoreHouse: TcxSplitter;
    pnlStoreHouseRight: TPanel;
    pnlBillLeft: TPanel;
    cxSplitter1: TcxSplitter;
    pnlBillCenter: TPanel;
    pnlLoad: TPanel;
    actTest: TAction;
    procedure actComponentsTabExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actSaveAllExecute(Sender: TObject);
    procedure actSelectDataBasePathExecute(Sender: TObject);
    procedure actShowBodyTypes2Execute(Sender: TObject);
    procedure actShowBodyTypes3Execute(Sender: TObject);
    procedure actShowDescriptionsExecute(Sender: TObject);
    procedure actShowExtraChargeExecute(Sender: TObject);
    procedure actShowProducersExecute(Sender: TObject);
    procedure actShowParametersExecute(Sender: TObject);
    procedure actTestExecute(Sender: TObject);
    procedure ApplicationEventsException(Sender: TObject; E: Exception);
    procedure ApplicationEventsHint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure dbtlCategoriesDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure dbtlCategoriesDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure btnFocusRootClick(Sender: TObject);
    procedure cxpcCompGroupRightPageChanging(Sender: TObject;
      NewPage: TcxTabSheet; var AllowChange: Boolean);
    procedure cxpcComp2PageChanging(Sender: TObject; NewPage: TcxTabSheet;
      var AllowChange: Boolean);
    procedure cxpcMainChange(Sender: TObject);
    procedure cxpcMainPageChanging(Sender: TObject; NewPage: TcxTabSheet;
      var AllowChange: Boolean);
    procedure cxpcWareHouse2PageChanging(Sender: TObject; NewPage: TcxTabSheet;
      var AllowChange: Boolean);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure OnTreeListCanFocusNode(Sender: TcxCustomTreeList;
      ANode: TcxTreeListNode; var Allow: Boolean);
    procedure ViewComponentsactOpenDatasheetExecute(Sender: TObject);
  private
    FCategoryPath: string;
    // FComponentsFrame: TComponentsFrame;
    FcxpcCompGroupRightActivePage: TcxTabSheet;
    FEventList: TObjectList;
    FfrmComp: TfrmComp;
    FfrmProgressBar: TfrmProgressBar3;
    FHintWindowEx: THintWindowEx;
    FLoadComplete: Boolean;
    FQuerySearchCategoriesPath: TQuerySearchCategoriesPath;
    FViewBill: TViewBill;
    FViewBillContent: TViewBillContent;
    FViewCategoryParameters: TViewCategoryParameters;
    FViewChildCategories: TViewChildCategories;
    FViewComponents: TViewComponents;
    FViewComponentsSearch: TViewComponentsSearch;
    FViewParametricTable: TViewParametricTable;
    FViewProducts: TViewProducts2;
    FViewProductsBasket: TViewProductsBasket;
    FViewProductsSearch: TViewProductsSearch2;
    FViewStoreHouse: TViewStoreHouse;
    FViewTreeList: TViewTreeList;
    FWriteProgress: TTotalProgress;
    procedure DoAfterLoadSheet(ASender: TObject);
    procedure DoAfterTreeListSmartRefresh(Sender: TObject);
    procedure DoBeforeParametricTableActivate(Sender: TObject);
    procedure DoBeforeParametricTableDeactivate(Sender: TObject);
    procedure DoOnAutoBindingDescription(Sender: TObject);
    procedure DoOnAutoBindingDoc(Sender: TObject);
    procedure DoOnComponentLocate(Sender: TObject);
    procedure DoOnLoadCompFromExcelDocument(Sender: TObject);
    procedure DoOnLoadCompFromExcelFolder(Sender: TObject);
    procedure DoOnLoadParametricData(Sender: TObject);
    procedure DoOnLoadParametricTable(Sender: TObject);
    procedure DoOnProductCategoriesChange(Sender: TObject);
    procedure DoOnShowParametricTable(Sender: TObject);
    procedure DoOnTotalReadProgress(ASender: TObject);
    procedure DoOnViewStoreHouseCanFocusRecord(Sender: TObject);
    function GetQueryMonitor: TQueryMonitor;
    procedure LoadDocFromExcelDocument;
    function LoadExcelFileHeader(var AFileName: String;
      AFieldsInfo: TFieldsInfo): Boolean;
    procedure LoadParametricData(AComponentTypeSet: TComponentTypeSet);
    procedure ShowParametricTable;
    function ShowSettingsEditor: Integer;
    procedure TryUpdateAnalizeStatistic(API: TProgressInfo);
    procedure TryUpdateWrite0Statistic(API: TProgressInfo);
    procedure TryUpdateWriteStatistic(API: TProgressInfo);
    procedure UpdateCaption;
    { Private declarations }
  protected
    procedure DoOnHaveAnyChanges(Sender: TObject);
    procedure DoOnOpenCategory(Sender: TObject);
    procedure DoOnProductLocate(Sender: TObject);
    property QueryMonitor: TQueryMonitor read GetQueryMonitor;
    property ViewTreeList: TViewTreeList read FViewTreeList;
  public
    constructor Create(AOwner: TComponent); override;
    function CheckDataBasePath: Boolean;
    property ViewBill: TViewBill read FViewBill;
    property ViewBillContent: TViewBillContent read FViewBillContent;
    property ViewCategoryParameters: TViewCategoryParameters
      read FViewCategoryParameters;
    property ViewChildCategories: TViewChildCategories
      read FViewChildCategories;
    property ViewComponents: TViewComponents read FViewComponents;
    property ViewComponentsSearch: TViewComponentsSearch
      read FViewComponentsSearch;
    property ViewParametricTable: TViewParametricTable
      read FViewParametricTable;
    property ViewProducts: TViewProducts2 read FViewProducts;
    property ViewProductsBasket: TViewProductsBasket read FViewProductsBasket;
    property ViewProductsSearch: TViewProductsSearch2 read FViewProductsSearch;
    property ViewStoreHouse: TViewStoreHouse read FViewStoreHouse;
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  Winapi.ShellAPI, RepositoryDataModule, DialogUnit, DescriptionsForm,
  ParametersForm, SettingsController, ReportsForm, ReportQuery,
  ParametricExcelDataModule, ParametricTableForm, BodyTypesForm, ProjectConst,
  PathSettingsForm, ImportErrorForm, cxGridDBBandedTableView,
  System.IOUtils, ImportProcessForm, ProgressBarForm,
  Vcl.FileCtrl, SearchDescriptionsQuery, TableWithProgress, GridViewForm,
  TreeListQuery, AutoBindingDocForm, AutoBindingDescriptionForm,
  FireDAC.Comp.Client, AutoBinding, AllFamilyQuery, ProducersForm,
  ProductsBaseQuery, RecursiveTreeView,
  RecursiveTreeQuery, TreeExcelDataModule, BindDocUnit, DialogUnit2,
  LoadFromExcelFileHelper, SearchCategoryQuery, CustomErrorForm,
  ExtraChargeForm, ExceptionHelper, System.StrUtils, DataModule,
  FireDAC.Comp.DataSet, ComponentsGroupUnit2, ComponentsExcelDataModule,
  StrHelper, ParametricErrorTable, ParametricTableErrorForm, ErrorType;

{$R *.dfm}

constructor TfrmMain.Create(AOwner: TComponent);
begin
  Application.HintHidePause := 10000;
  inherited Create(AOwner);
  FHintWindowEx := THintWindowEx.Create(Self);
  FQuerySearchCategoriesPath := TQuerySearchCategoriesPath.Create(Self);
end;

procedure TfrmMain.actComponentsTabExecute(Sender: TObject);
begin
  // beep;
end;

procedure TfrmMain.actExitExecute(Sender: TObject);
begin
  Close
end;

procedure TfrmMain.actSaveAllExecute(Sender: TObject);
begin
  QueryMonitor.ApplyUpdates;
end;

procedure TfrmMain.actSelectDataBasePathExecute(Sender: TObject);
var
  ANewDataBasePath: string;
  AOldDataBasePath: string;
begin
  AOldDataBasePath := TSettings.Create.databasePath;
  if not ShowSettingsEditor = mrOk then
    Exit;

  ANewDataBasePath := TSettings.Create.databasePath;

  // Если путь до базы данных не изменился
  if AOldDataBasePath = ANewDataBasePath then
    Exit;

  FViewTreeList.BeginUpdate;
  try
    TDM.Create.CreateOrOpenDataBase(Application.ExeName);
    // Искусственно вызываем событие
    DoOnProductCategoriesChange(nil);
  finally
    FViewTreeList.EndUpdate;
    FViewTreeList.ExpandRoot;
  end;
end;

procedure TfrmMain.actShowBodyTypes2Execute(Sender: TObject);
// var
// AQueryBodyTypesGrid: TQueryBodyTypesGrid;
begin
  {
    AQueryBodyTypesGrid := TQueryBodyTypesGrid.Create(Self);
    try
    AQueryBodyTypesGrid.FDQuery.Open();

    frmBodyTypesGrid := TfrmBodyTypesGrid.Create(Self);
    frmBodyTypesGrid.ViewBodyTypesGrid.QueryBodyTypesGrid :=
    AQueryBodyTypesGrid;

    frmBodyTypesGrid.ShowModal;
    FreeAndNil(frmBodyTypesGrid);
    finally
    FreeAndNil(AQueryBodyTypesGrid);
    end;
  }
end;

procedure TfrmMain.actShowBodyTypes3Execute(Sender: TObject);
begin
  Application.Hint := '';
  if frmBodyTypes = nil then
  begin
    TDM.Create.BodyTypesGroup.ReOpen;
    frmBodyTypes := TfrmBodyTypes.Create(Self);
    frmBodyTypes.ViewBodyTypes.BodyTypesGroup := TDM.Create.BodyTypesGroup;
  end;

  frmBodyTypes.Show;
end;

procedure TfrmMain.actShowDescriptionsExecute(Sender: TObject);
begin
  Application.Hint := '';
  if frmDescriptions = nil then
  begin
    TDM.Create.DescriptionsGroup.ReOpen;
    frmDescriptions := TfrmDescriptions.Create(Self);
    frmDescriptions.ViewDescriptions.DescriptionsGroup :=
      TDM.Create.DescriptionsGroup;
  end;

  frmDescriptions.Show;
end;

procedure TfrmMain.actShowExtraChargeExecute(Sender: TObject);
begin
  Application.Hint := '';
  if frmExtraCharge = nil then
  begin
    TDM.Create.ExtraChargeGroup.ReOpen;
    frmExtraCharge := TfrmExtraCharge.Create(Self);
    frmExtraCharge.ViewExtraCharge.ExtraChargeGroup :=
      TDM.Create.ExtraChargeGroup;
  end;

  frmExtraCharge.Show;
end;

procedure TfrmMain.actShowProducersExecute(Sender: TObject);
begin
  Application.Hint := '';
  if frmProducers = nil then
  begin
    TDM.Create.ProducersGroup.ReOpen;
    frmProducers := TfrmProducers.Create(Self);
    frmProducers.ViewProducers.ProducersGroup := TDM.Create.ProducersGroup;
  end;

  frmProducers.Show;
end;

procedure TfrmMain.actShowParametersExecute(Sender: TObject);
begin
  Application.Hint := '';
  if frmParameters = nil then
  begin
    TDM.Create.ParametersGroup.ReOpen;
    TDM.Create.qSubParameters.W.RefreshQuery;

    frmParameters := TfrmParameters.Create(Self);
    frmParameters.ViewParameters.ParametersGrp := TDM.Create.ParametersGroup;
    frmParameters.ViewSubParameters.QuerySubParameters :=
      TDM.Create.qSubParameters;
  end;

  frmParameters.Show;
end;

procedure TfrmMain.actTestExecute(Sender: TObject);
begin
  beep;
end;

procedure TfrmMain.ApplicationEventsException(Sender: TObject; E: Exception);
var
  Msg: string;
begin
  Msg := IfThen(MyExceptionMessage.IsEmpty, E.Message, MyExceptionMessage);
  MyExceptionMessage := '';
  TDialog.Create.ErrorMessageDialog(Msg);
end;

procedure TfrmMain.ApplicationEventsHint(Sender: TObject);
begin
  FHintWindowEx.DoActivateHint(Application.Hint)
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  // Отписываемся от всех событий
  FreeAndNil(FEventList);
end;

procedure TfrmMain.btnFocusRootClick(Sender: TObject);
begin
  TDM.Create.qTreeList.W.LocateToRoot;
end;

function TfrmMain.CheckDataBasePath: Boolean;
var
  databasePath: string;
  I: Integer;
  MR: Integer;
begin
  // Считываем путь к БД из настроек
  databasePath := TSettings.Create.databasePath;

  for I := 0 to 3 do
  begin
    // Если путь до базы данных пустой или не существующий
    if (databasePath = '') or (not TDirectory.Exists(databasePath)) then
    // если директория не существует
    begin
      MR := ShowSettingsEditor;
      Result := MR = mrOk;
      if not Result then
        Exit;

      // Снова считываем путь к БД из настроек
      databasePath := TSettings.Create.databasePath;
    end
    else
      Break; // больше попыток не требуется
  end;

  // Дав три попытки проверяем что всё ок
  Result := (databasePath <> '') and (TDirectory.Exists(databasePath));
end;

procedure TfrmMain.cxpcCompGroupRightPageChanging(Sender: TObject;
  NewPage: TcxTabSheet; var AllowChange: Boolean);
begin
  if not FLoadComplete then
    Exit;

  // Если переходим на вкладку категория
  if NewPage = cxtsCategory then
  begin
    TDM.Create.qChildCategories.AddClient;

    if FViewChildCategories = nil then
    begin
      FViewChildCategories := TViewChildCategories.Create(Self);
      FViewChildCategories.Place(cxtsCategory);

      // Привязываем подкатегории к данным (функциональная группа)
      ViewChildCategories.qChildCategories := TDM.Create.qChildCategories;
    end;
    ViewChildCategories.MainView.ApplyBestFit;
  end;

  // Если уходим со вкладки Категория
  if cxpcCompGroupRight.ActivePage = cxtsCategory then
  begin
    TDM.Create.qChildCategories.RemoveClient;
  end;

  // Если переходим на вкладку Содержимое
  if NewPage = cxtsCategoryComponents then
  begin
    TDM.Create.ComponentsGroup.AddClient;

    if FViewComponents = nil then
    begin
      FViewComponents := TViewComponents.Create(Self);
      FViewComponents.Place(cxtsCategoryComponents);

      // Привязываем представления к данным
      ViewComponents.ComponentsGroup := TDM.Create.ComponentsGroup;

      // Подписываемся на событие о отображении параметрической таблицы
      TNotifyEventWrap.Create(ViewComponents.OnShowParametricTableEvent,
        DoOnShowParametricTable, FEventList);
    end;

    ViewComponents.PostMyApplyBestFitEvent;
  end;

  // Если уходим со вкладки Содержимое
  if cxpcCompGroupRight.ActivePage = cxtsCategoryComponents then
  begin
    TDM.Create.ComponentsGroup.RemoveClient;
  end;

  // Если переходим на вкладку Параметры
  if NewPage = cxtsCategoryParameters then
  begin
    TDM.Create.CategoryParametersGroup.AddClient;

    if FViewCategoryParameters = nil then
    begin
      FViewCategoryParameters := TViewCategoryParameters.Create(Self);
      FViewCategoryParameters.Place(cxtsCategoryParameters);

      // Параметры в виде списка
      ViewCategoryParameters.CatParamsGroup :=
        TDM.Create.CategoryParametersGroup;
    end;
    ViewCategoryParameters.MyApplyBestFit;
  end;

  // Если уходим со вкладки Параметры
  if cxpcCompGroupRight.ActivePage = cxtsCategoryParameters then
  begin
    TDM.Create.CategoryParametersGroup.RemoveClient;
  end;

  // если переходим на вкладку "Параметрическая таблица"
  if NewPage = cxtsParametricTable then
  begin
    // сообщаем о том, что этот запрос понадобится и его надо разблокировать
    TDM.Create.ComponentsExGroup.AddClient;

    if FViewParametricTable = nil then
    begin
      FViewParametricTable := TViewParametricTable.Create(Self);
      FViewParametricTable.Place(cxtsParametricTable);
      ViewParametricTable.ComponentsExGroup := TDM.Create.ComponentsExGroup;

      // Подписываемся чтобы искать компонент на складах
      TNotifyEventWrap.Create(TDM.Create.ComponentsExGroup.qComponentsEx.
        OnLocate, DoOnComponentLocate, FEventList);
    end
    else
      ViewParametricTable.Unlock;
  end;

  // если уходим с вкладки "Параметрическая таблица"
  if (cxpcCompGroupRight.ActivePage = cxtsParametricTable) and
    (NewPage <> cxtsParametricTable) then
  begin
    TDM.Create.ComponentsExGroup.RemoveClient;

    if FViewParametricTable <> nil then
      ViewParametricTable.Lock;
  end;

end;

procedure TfrmMain.cxpcComp2PageChanging(Sender: TObject; NewPage: TcxTabSheet;
  var AllowChange: Boolean);
begin
  if not FLoadComplete then
    Exit;

  // Если переходим на вкладку "По группам"
  if NewPage = cxtshCompGroup then
  begin
    TDM.Create.qTreeList.AddClient;

    if FViewTreeList = nil then
    begin
      // Создаём фрейм с деревом категорий
      FViewTreeList := TViewTreeList.Create(Self);
      ViewTreeList.Parent := pnlCompGroupLeft;
      ViewTreeList.Align := alClient;
      ViewTreeList.qTreeList := TDM.Create.qTreeList;

      // Устанавливаем обработчик события
      ViewTreeList.cxDBTreeList.OnCanFocusNode := OnTreeListCanFocusNode;

      TNotifyEventWrap.Create(TDM.Create.qTreeList.W.AfterSmartRefresh,
        DoAfterTreeListSmartRefresh, FEventList);

      TNotifyEventWrap.Create(TDM.Create.qTreeList.W.AfterScrollM,
        DoOnProductCategoriesChange, FEventList);

      TNotifyEventWrap.Create(TDM.Create.qTreeList.W.AfterOpen,
        DoOnProductCategoriesChange, FEventList);
    end;

    if FcxpcCompGroupRightActivePage <> nil then
      cxpcCompGroupRight.ActivePage := FcxpcCompGroupRightActivePage
    else
      cxpcCompGroupRight.ActivePage := cxtsCategory;
  end;

  // Если уходим со вкладки "По группам"
  if cxpcComp2.ActivePage = cxtshCompGroup then
  begin
    TDM.Create.qTreeList.RemoveClient;
    FcxpcCompGroupRightActivePage := cxpcCompGroupRight.ActivePage;
    cxpcCompGroupRight.ActivePage := nil;
  end;

  // Если переходим на вкладку Поиск
  if NewPage = cxtshCompSearch then
  begin
    TDM.Create.ComponentsSearchGroup.AddClient;

    if FViewComponentsSearch = nil then
    begin
      // Создаём представление поиска компонентов
      FViewComponentsSearch := TViewComponentsSearch.Create(Self);
      FViewComponentsSearch.Place(cxtshCompSearch);

      // Привязываем представление к данным
      ViewComponentsSearch.ComponentsSearchGroup :=
        TDM.Create.ComponentsSearchGroup;

      // Подписываемся на событие чтобы открывать найденную категорию
      TNotifyEventWrap.Create(TDM.Create.ComponentsSearchGroup.OnOpenCategory,
        DoOnOpenCategory, FEventList);
    end;

    ViewComponentsSearch.MyApplyBestFit;
  end;

  // Если уходим со вкладки Поиск
  if cxpcComp2.ActivePage = cxtshCompSearch then
  begin
    TDM.Create.ComponentsSearchGroup.RemoveClient;
  end;
end;

procedure TfrmMain.cxpcMainChange(Sender: TObject);
begin
  if ViewComponents <> nil then
    ViewComponents.CheckAndSaveChanges;

  if ViewProducts <> nil then
    ViewProducts.CheckAndSaveChanges;

  if ViewProductsSearch <> nil then
    ViewProductsSearch.CheckAndSaveChanges;
end;

procedure TfrmMain.cxpcMainPageChanging(Sender: TObject; NewPage: TcxTabSheet;
  var AllowChange: Boolean);
begin
  // Если переход на вкладку Компоненты
  if NewPage = cxtshComp then
    if cxpcComp2.ActivePage = nil then
      cxpcComp2.ActivePage := cxtshCompGroup;

  // Если переход на вкладку Склады
  if NewPage = cxtshWareHouse then
    if cxpcWareHouse2.ActivePage = nil then
      cxpcWareHouse2.ActivePage := cxtshWareHouse2;
end;

procedure TfrmMain.cxpcWareHouse2PageChanging(Sender: TObject;
  NewPage: TcxTabSheet; var AllowChange: Boolean);
begin
  if not FLoadComplete then
    Exit;

  // Если переходим на вкладку склады
  if NewPage = cxtshWareHouse2 then
  begin
    TDM.Create.qStoreHouseList.AddClient;
    TDM.Create.qProducts.AddClient;

    // Привязываем список складов к данным
    if FViewStoreHouse = nil then
    begin
      FViewStoreHouse := TViewStoreHouse.Create(Self);
      FViewStoreHouse.Place(pnlStoreHouseLeft);
      FViewStoreHouse.qStoreHouseList := TDM.Create.qStoreHouseList;

      TNotifyEventWrap.Create(FViewStoreHouse.OnCanFocusRecord,
        DoOnViewStoreHouseCanFocusRecord, FEventList);
    end;

    // Привязываем представление содержимого склада к данным
    if FViewProducts = nil then
    begin
      FViewProducts := TViewProducts2.Create(Self);
      FViewProducts.Parent := pnlStoreHouseRight;
      FViewProducts.Align := alClient;

      ViewProducts.qProducts := TDM.Create.qProducts;

      // Подписываемся чтобы искать компонент в параметрической таблице
      TNotifyEventWrap.Create(TDM.Create.qProducts.OnLocate, DoOnProductLocate,
        FEventList);
    end;
  end;

  // Если уходим со вкладки Склады
  if cxpcWareHouse2.ActivePage = cxtshWareHouse2 then
  begin
    TDM.Create.qProducts.RemoveClient;
    TDM.Create.qStoreHouseList.RemoveClient;
  end;

  // Если переходим на вкладку корзина
  if NewPage = cxtshBasket then
  begin
    // Обновляем содержимое корзины
    TDM.Create.qProductsBasket.SearchForBasket;

    if FViewProductsBasket = nil then
    begin
      FViewProductsBasket := TViewProductsBasket.Create(Self);
      FViewProductsBasket.Parent := cxtshBasket;
      FViewProductsBasket.Align := alClient;
      ViewProductsBasket.qProducts := TDM.Create.qProductsBasket;
    end;
  end;

  // Если переходим на вкладку счета
  if NewPage = cxtshBill then
  begin
    TDM.Create.qBill.AddClient;
    TDM.Create.qBillContent2.AddClient;

    if FViewBill = nil then
    begin
      FViewBill := TViewBill.Create(Self);
      FViewBill.Place(pnlBillLeft);
      FViewBill.qBill := TDM.Create.qBill;
    end;

    if FViewBillContent = nil then
    begin
      FViewBillContent := TViewBillContent.Create(Self);
      FViewBillContent.Parent := pnlBillCenter;
      FViewBillContent.Align := alClient;
      FViewBillContent.qBillContent := TDM.Create.qBillContent2;
    end;
  end;

  // Если уходим со вкладки Счета
  if cxpcWareHouse2.ActivePage = cxtshBill then
  begin
    TDM.Create.qBillContent2.RemoveClient;
    TDM.Create.qBill.RemoveClient;
  end;

  // Если переходим на вкладку поиск
  if NewPage = cxtshSearch then
  begin
    TDM.Create.qProductsSearch.W.TryOpen;

    if FViewProductsSearch = nil then
    begin
      FViewProductsSearch := TViewProductsSearch2.Create(Self);
      FViewProductsSearch.Parent := cxtshSearch;
      FViewProductsSearch.Align := alClient;
      ViewProductsSearch.qProductsSearch := TDM.Create.qProductsSearch;

      TNotifyEventWrap.Create(TDM.Create.qProductsSearch.OnLocate,
        DoOnProductLocate, FEventList);
    end;
  end;
end;

procedure TfrmMain.DoOnComponentLocate(Sender: TObject);
var
  l: TList<String>;
begin
  // Массив с теми наименованиями, которые мы собираемся искать на складе
  Assert(Sender <> nil);
  l := Sender as TList<String>;
  Assert(l.Count > 0);

  TDM.Create.qProductsSearch.Search(l);

  // Переключаемся на вкладку склады
  cxpcMain.ActivePage := cxtshWareHouse;

  // Переключаемся на вкладку поиск на складе
  cxpcWareHouse2.ActivePage := cxtshSearch;

  BringToFront;
  ViewProductsSearch.FocusValueColumn;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if QueryMonitor = nil then
    Exit;

  if QueryMonitor.HaveAnyChanges then
  begin
    case TDialog.Create.SaveDataDialog of
      IDYES:
        QueryMonitor.ApplyUpdates;
      IDNo:
        QueryMonitor.CancelUpdates;
      IDCancel:
        Action := caNone;
    end;
  end;

  // TDM.Create.

  inherited;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  OK: Boolean;
begin
  // Создаём модуль репозитория
  Assert(DMRepository = nil);
  // if DMRepository = nil then
  DMRepository := TDMRepository.Create(Self);
  Assert(not DMRepository.dbConnection.Connected);

  cxpcMain.ActivePage := nil;

  cxpcComp2.ActivePage := nil;

  cxpcCompGroupRight.ActivePage := nil;

  cxpcWareHouse2.ActivePage := nil;

  Assert(not DMRepository.dbConnection.Connected);

  inherited;

  Self.WindowState := wsNormal;

  // Подписываемся на события
  FEventList := TObjectList.Create;

  FfrmComp := TfrmComp.Create(Self);
  FfrmComp.Parent := pnlLoad;
  FfrmComp.Align := alClient;
  TNotifyEventWrap.Create(FfrmComp.OnLoadCompFromExcelFolder,
    DoOnLoadCompFromExcelFolder, FEventList);
  TNotifyEventWrap.Create(FfrmComp.OnLoadCompFromExcelDocument,
    DoOnLoadCompFromExcelDocument, FEventList);
  TNotifyEventWrap.Create(FfrmComp.OnLoadParametricTable,
    DoOnLoadParametricTable, FEventList);
  TNotifyEventWrap.Create(FfrmComp.OnLoadParametricData, DoOnLoadParametricData,
    FEventList);
  TNotifyEventWrap.Create(FfrmComp.OnAutoBindingDoc, DoOnAutoBindingDoc,
    FEventList);
  TNotifyEventWrap.Create(FfrmComp.OnAutoBindingDescription,
    DoOnAutoBindingDescription, FEventList);

  // Проверяем что путь до базы данных корректный
  OK := CheckDataBasePath;

  if OK then
  begin
    // Пока ещё соединение с БД должно быть закрыто
    Assert(not DMRepository.dbConnection.Connected);
    repeat
      try
        // Создаём или открываем базу данных
        TDM.Create.CreateOrOpenDataBase(Application.ExeName);
        // DM2.CreateOrOpenDataBase;
      except
        on E: Exception do
        begin
          TDialog.Create.ErrorMessageDialog(E.Message);
          // Снова предлагаем выбрать папку с БД

          OK := ShowSettingsEditor = mrOk;
        end;
      end;

    until (DMRepository.dbConnection.Connected) or (not OK);

    if OK then
    begin
      // обновляем доступность кнопки "Сохранить всё"
      DoOnHaveAnyChanges(nil);
      TNotifyEventWrap.Create(QueryMonitor.OnHaveAnyChanges,
        DoOnHaveAnyChanges);

      FLoadComplete := True;

      cxpcMain.ActivePage := cxtshComp;
      cxpcComp2.ActivePage := cxtshCompGroup;

      // ComponentsFrame.cxpcComponents.ActivePage := ComponentsFrame.cxtsCategory;
      // ProductsFrame.cxpcStorehouse.ActivePage := ProductsFrame.tsStorehouseProducts;

      // Искусственно вызываем событие
      if TDM.Create.qTreeList.FDQuery.Active then
        DoOnProductCategoriesChange(nil);
    end;
  end;

  // OK := OK and TProtect.Create.Check;
  if not OK then
  begin
    Application.ShowMainForm := False;
    Application.Terminate; // завершаем работу приложения
  end;

end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  if (Enabled) and (FViewTreeList <> nil) and
    (DMRepository.dbConnection.Connected) and
    (ViewTreeList.cxDBTreeList.FocusedNode <> nil) then
    ViewTreeList.ExpandRoot;
end;

procedure TfrmMain.DoOnProductCategoriesChange(Sender: TObject);
begin
  cxtsCategoryComponents.Enabled := not TDM.Create.qTreeList.W.IsRootFocused;

  Assert(TDM.Create.qTreeList.W.PK.AsInteger > 0);
  Assert(FQuerySearchCategoriesPath <> nil);
  FCategoryPath := FQuerySearchCategoriesPath.GetFullPath
    (TDM.Create.qTreeList.W.PK.AsInteger);

  UpdateCaption;

end;

procedure TfrmMain.DoOnProductLocate(Sender: TObject);
var
  LO: TLocateObject;
begin
  LO := (Sender as TLocateObject);

  if not TDM.Create.qTreeList.W.LocateByPK(LO.IDCategory) then
  begin
    TDialog.Create.ErrorMessageDialog(Format('Категория с кодом %d не найдена',
      [LO.IDCategory]));
    Exit;
  end;

  // Отображаем окно с параметрической таблицей
  ShowParametricTable;
  // Фильтруем по семейству
  frmParametricTable.ViewParametricTable.FilterByFamily(LO.FamilyName);
  // Фильтруем семейство по компоненту
  frmParametricTable.ViewParametricTable.FilterByComponent(LO.ComponentName);
end;

procedure TfrmMain.DoOnShowParametricTable(Sender: TObject);
begin
  ShowParametricTable;
end;

procedure TfrmMain.FormResize(Sender: TObject);
begin
  UpdateCaption;
end;

procedure TfrmMain.ShowParametricTable;
begin
  if frmParametricTable = nil then
  begin
    {
      // Нам надо узнать, есть-ли у текущей категории подкатегории
      rc := TSearchSubCategories.Search(DM2.qTreeList.PK.Value);
      // Если у нашей категории есть подкатегории
      if rc > 0 then
      ACategoryPath := DM2.qTreeList.Value.AsString
      else
      begin
      // Если в цепочке категорий мы последнее звено
      ACategoryPath := FQuerySearchCategoriesPath.GetLastTreeNodes
      (DM2.qTreeList.PK.Value, 2, '-');
      end;
    }
    // Создаём окно с параметрической таблицей
    frmParametricTable := TfrmParametricTable.Create(Self);

    // Подписываемся на событие перед закрытием окна
    TNotifyEventWrap.Create(frmParametricTable.OnActivate,
      DoBeforeParametricTableActivate, FEventList);

    TNotifyEventWrap.Create(frmParametricTable.OnDeactivate,
      DoBeforeParametricTableDeactivate, FEventList);

    // Привязываем данные к представлению
    frmParametricTable.ViewParametricTable.ComponentsExGroup :=
      TDM.Create.ComponentsExGroup;

    // предупреждаем, что нам потребуются данные этого запроса
    // DM2.ComponentsExGroup.AddClient;
  end;

  frmParametricTable.Show;
end;

function TfrmMain.ShowSettingsEditor: Integer;
var
  frmSettings: TfrmPathSettings;
begin
  frmSettings := TfrmPathSettings.Create(nil);
  try
    Result := frmSettings.ShowModal;
  finally
    frmSettings.Free;
  end;
end;

procedure TfrmMain.OnTreeListCanFocusNode(Sender: TcxCustomTreeList;
  ANode: TcxTreeListNode; var Allow: Boolean);
begin
  Allow := ((ViewComponents = nil) or (ViewComponents.CheckAndSaveChanges <>
    IDCancel)) and ((ViewCategoryParameters = nil) or
    (ViewCategoryParameters.CheckAndSaveChanges <> IDCancel));
end;

procedure TfrmMain.dbtlCategoriesDragDrop(Sender, Source: TObject;
  X, Y: Integer);
var
  cn: string;
begin
  with TcxTreeList(Sender) do
  begin
    HitTest.ReCalculate(Point(X, Y));
    if HitTest.HitAtBackground then
    begin
      HitTest.HitTestItem := Root;
    end;
    cn := HitTest.HitTestItem.ClassName;
  end;
end;

procedure TfrmMain.dbtlCategoriesDragOver(Sender, Source: TObject;
  X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := True;
end;

procedure TfrmMain.DoAfterLoadSheet(ASender: TObject);
var
  A: TArray<Integer>;
  ADataOnly: Boolean;
  AfrmError: TfrmCustomError;
  AParametricExcelTable: TParametricExcelTable;
  E: TExcelDMEvent;
  ne: TNotifyEventR;
  OK: Boolean;
begin
  E := ASender as TExcelDMEvent;

  AParametricExcelTable := E.ExcelTable as TParametricExcelTable;

  // Надо обновить прогресс записи
  if FWriteProgress.PIList.Count = 0 then
    FWriteProgress.Assign(E.TotalProgress);

  OK := E.ExcelTable.Errors.RecordCount = 0;
  // Если в ходе загрузки данных произошли ошибки (компонент не найден)
  if not OK then
  begin
    FfrmProgressBar.Hide;
    AfrmError := TfrmCustomError.Create(nil);
    try
      AfrmError.ViewGridEx.DataSet := E.ExcelTable.Errors;
      // Показываем ошибки
      OK := AfrmError.ShowModal = mrOk;
      if OK then
      begin
        if AfrmError.ContinueType = ctSkip then
          // Убираем записи с ошибками и предупреждениями
          E.ExcelTable.ExcludeErrors(etWarring)
        else
          // Убираем записи с ошибками
          E.ExcelTable.ExcludeErrors(etError);
      end;
    finally
      FreeAndNil(AfrmError);
    end;
  end;

  // Надо ли останавливать загрузку остальных листов
  E.Terminate := not OK;

  if not OK then
    Exit;

  FfrmProgressBar.Show;

  // Если требуется загрузить только данные, но не сами параметры
  ADataOnly := AParametricExcelTable.ComponentTypeSet = [ctComponent];

  // Перед записью первого листа создадим все необходимые параметры
  if (E.SheetIndex = 1) and (not ADataOnly) then
  begin
    // Должна быть хотя-бы одна категория, в которую будем добавлять параметры
    Assert(TDM.Create.qSearchDaughterCategories.FDQuery.RecordCount >= 1);

    A := TDM.Create.qSearchDaughterCategories.W.ID.AsIntArray;

    // 1 Добавляем параметры в категорию
    E.ExcelTable.Process(
      procedure(ASender: TObject)
      begin
        TParameterValues.LoadParameters(A,
          E.ExcelTable as TParametricExcelTable);
      end,

    // Обработчик события
      procedure(ASender: TObject)
      Var
        API: TProgressInfo;
      begin
        API := ASender as TProgressInfo;
        TryUpdateWrite0Statistic(API);
      end);
  end;

  // 2 Сохраняем значения параметров

  // Подписываемся на событие
  ne := TNotifyEventR.Create(E.ExcelTable.OnProgress,
    procedure(ASender: TObject)
    Var
      API: TProgressInfo;
    begin
      API := ASender as TProgressInfo;
      // Запоминаем прогресс записи листа
      FWriteProgress.PIList[E.SheetIndex - 1].Assign(API);
      // Обновляем общий прогресс записи
      FWriteProgress.UpdateTotalProgress;

      TryUpdateWriteStatistic(FWriteProgress.TotalProgress);
    end);
  try
    // Выполняем загрузку значений параметров
    TParameterValues.LoadParameterValues(E.ExcelTable as TParametricExcelTable,

      procedure(ASender: TObject)
      Var
        API: TProgressInfo;
      begin
        API := ASender as TProgressInfo;
        TryUpdateAnalizeStatistic(API);
      end);

  finally
    FreeAndNil(ne);
  end;
end;

procedure TfrmMain.DoAfterTreeListSmartRefresh(Sender: TObject);
begin
  ViewTreeList.ExpandRoot;
end;

procedure TfrmMain.DoBeforeParametricTableActivate(Sender: TObject);
var
  ACategoryPath: string;
  rc: Integer;
begin
  TDM.Create.ComponentsExGroup.AddClient;

  // Нам надо узнать, есть-ли у текущей категории подкатегории
  rc := TSearchSubCategories.Search(TDM.Create.qTreeList.W.PK.Value);
  // Если у нашей категории есть подкатегории
  if rc > 0 then
    ACategoryPath := TDM.Create.qTreeList.W.Value.F.AsString
  else
  begin
    // Если в цепочке категорий мы последнее звено
    ACategoryPath := FQuerySearchCategoriesPath.GetLastTreeNodes
      (TDM.Create.qTreeList.W.PK.Value, 2, '-');
  end;
  frmParametricTable.CategoryPath := ACategoryPath;
end;

procedure TfrmMain.DoBeforeParametricTableDeactivate(Sender: TObject);
begin
  TDM.Create.ComponentsExGroup.RemoveClient;
end;

procedure TfrmMain.DoOnAutoBindingDescription(Sender: TObject);
var
  AIDCategory: Integer;
  frmAutoBindingDescriptions: TfrmAutoBindingDescriptions;
  MR: Integer;
begin
  Application.Hint := '';
  frmAutoBindingDescriptions := TfrmAutoBindingDescriptions.Create(Self);
  try
    // В выбранной категории можно только если выбрана вкладка "По группам"
    frmAutoBindingDescriptions.actCategory.Enabled :=
      cxpcComp2.ActivePage = cxtshCompGroup;

    MR := frmAutoBindingDescriptions.ShowModal;
    case MR of
      mrOk:
        AIDCategory := TDM.Create.qTreeList.W.ID.F.AsInteger;
      mrAll:
        AIDCategory := 0;
    else
      AIDCategory := -1;
    end;
  finally
    FreeAndNil(frmAutoBindingDescriptions);
  end;

  Application.Hint := '';
  Application.ProcessMessages;

  if MR <> mrCancel then
  begin
    TAutoBind.BindComponentDescriptions(AIDCategory);
    // Обновим данные в текущей категории
    if (ViewComponents <> nil) then
    begin
      TDM.Create.ComponentsGroup.AddClient;
      ViewComponents.RefreshData;
      TDM.Create.ComponentsGroup.RemoveClient;
    end;
  end;

end;

procedure TfrmMain.DoOnAutoBindingDoc(Sender: TObject);
var
  AFDQuery: TFDQuery;
  AQueryAllFamily: TQueryAllFamily;
  frmAutoBindingDoc: TfrmAutoBindingDoc;
  MR: Integer;
begin
  Application.Hint := '';
  AQueryAllFamily := nil;
  AFDQuery := nil;
  frmAutoBindingDoc := TfrmAutoBindingDoc.Create(Self);
  try
    // В выбранной категории можно только если выбрана вкладка "По группам"
    frmAutoBindingDoc.actCategory.Enabled :=
      cxpcComp2.ActivePage = cxtshCompGroup;

    MR := frmAutoBindingDoc.ShowModal;
    case MR of
      mrAll:
        begin
          AQueryAllFamily := TQueryAllFamily.Create(Self);
          AQueryAllFamily.FDQuery.Open;
          AFDQuery := AQueryAllFamily.FDQuery;
        end;
      mrOk:
        TDM.Create.ComponentsGroup.AddClient;
      // AFDQuery := ViewComponents.ComponentsGroup.qFamily.FDQuery;
      mrNo:
        LoadDocFromExcelDocument;
    end;

    if AFDQuery <> nil then
    begin
      TAutoBind.BindDocs(frmAutoBindingDoc.Docs, AFDQuery,
        frmAutoBindingDoc.cxrbNoRange.Checked,
        frmAutoBindingDoc.cxcbAbsentDoc.Checked);

      // Если привязывали текущую категорию
      if (MR = mrOk) then
      begin
        TDM.Create.ComponentsGroup.ReOpen;
        TDM.Create.ComponentsGroup.RemoveClient;
      end;
      {
        if AFDQuery = ViewComponents.ComponentsGroup.qFamily.FDQuery then
        begin
        ViewComponents.ComponentsGroup.ReOpen;
        end;
      }
    end;
  finally
    FreeAndNil(frmAutoBindingDoc);
    if AQueryAllFamily <> nil then
      FreeAndNil(AQueryAllFamily);
  end;
end;

procedure TfrmMain.DoOnHaveAnyChanges(Sender: TObject);
begin
  actSaveAll.Enabled := QueryMonitor.HaveAnyChanges;
end;

procedure TfrmMain.DoOnLoadCompFromExcelDocument(Sender: TObject);
var
  AComponentsGroup: TComponentsGroup2;
  AFileName: string;
  AProducer: String;
  AProducerID: Integer;
  m: TArray<String>;
  S: string;
begin
  Application.Hint := '';

  if not TfrmProducers.TakeProducer(AProducerID, AProducer) then
    Exit;

  if not TDialog.Create.ShowDialog(TExcelFileOpenDialog,
    TSettings.Create.LastFolderForComponentsLoad, '', AFileName) then
    Exit; // отказались от выбора файла

  // Сохраняем эту папку в настройках
  TSettings.Create.LastFolderForComponentsLoad :=
    TPath.GetDirectoryName(AFileName);

  S := TPath.GetFileNameWithoutExtension(AFileName);

  m := S.Split([' ']);
  if Length(m) = 0 then
  begin
    TDialog.Create.ErrorMessageDialog('Имя файла должно содержать пробел');
    Exit;
  end;

  try
    // Проверяем что первая часть содержит целочисленный код категории
    m[0].ToInteger;
  except
    TDialog.Create.ErrorMessageDialog
      ('В начале имени файла должен быть код категории');
    Exit;
  end;

  TDM.Create.qTreeList.W.TryOpen;

  // Переходим в дереве категорий на загружаемую категорию
  if not TDM.Create.qTreeList.W.LocateByExternalID(m[0]) then
  begin
    TDialog.Create.ErrorMessageDialog(Format('Категория %s не найдена',
      [m[0]]));
    Exit;
  end;

  Assert(not AFileName.IsEmpty);
  Assert(not AProducer.IsEmpty);

  AComponentsGroup := TComponentsGroup2.Create(Self);
  try
    AComponentsGroup.qFamily.Master := TDM.Create.qTreeList;
    AComponentsGroup.qComponents.Master := TDM.Create.qTreeList;

    AComponentsGroup.qFamily.Load;
    AComponentsGroup.qComponents.Load;

    TLoad.Create.LoadAndProcess(AFileName, TComponentsExcelDM, TfrmImportError,
      procedure(ASender: TObject)
      begin
        AComponentsGroup.LoadDataFromExcelTable
          (ASender as TComponentsExcelTable, AProducer);
      end);
  finally
    FreeAndNil(AComponentsGroup);
  end;

  {
    // Тут некоторые узлы почему-то разворачиваются
    MainView.ViewData.Collapse(True);

    FocusTopLeft(clValue.DataBinding.FieldName);

    UpdateView;
  }
end;

procedure TfrmMain.DoOnLoadCompFromExcelFolder(Sender: TObject);
var
  AComponentsGroup2: TComponentsGroup2;
  AFileName: string;
  AFileNames: TList<String>;
  AFolderName: string;
  AProducer: String;
  AProducerID: Integer;
  AutomaticLoadErrorTable: TAutomaticLoadErrorTable;
  I: Integer;
  m: TStringDynArray;
  S: string;
begin
  Application.Hint := '';
  // Выбираем производителя
  if not TfrmProducers.TakeProducer(AProducerID, AProducer) then
    Exit;

  if not TDialog.Create.ShowDialog(TExcelFilesFolderOpenDialog,
    TSettings.Create.LastFolderForComponentsLoad, '', AFileName) then
    Exit;

  AFolderName := TPath.GetDirectoryName(AFileName);

  TSettings.Create.LastFolderForComponentsLoad := AFolderName;

  Assert(not AFolderName.IsEmpty);
  Assert(not AProducer.IsEmpty);

  m := TDirectory.GetFiles(AFolderName,
    function(const Path: string; const SearchRec: TSearchRec): Boolean
    Var
      S: String;
    begin
      S := TPath.GetExtension(SearchRec.Name);
      Result := S.IndexOf('.xls') = 0;
    end);

  if Length(m) = 0 then
  begin
    TDialog.Create.ExcelFilesNotFoundDialog;
  end;

  AFileNames := TList<String>.Create();
  try
    for I := Low(m) to High(m) do
    begin
      AFileNames.Add(m[I]);
    end;

    AutomaticLoadErrorTable := TAutomaticLoadErrorTable.Create(Self);
    for AFileName in AFileNames do
    begin
      S := TPath.GetFileNameWithoutExtension(AFileName);
      AutomaticLoadErrorTable.LocateOrAppendData(S, NULL, '', '', '');
    end;
    AutomaticLoadErrorTable.First;

    if frmImportProcess <> nil then
      FreeAndNil(frmImportProcess);

    frmImportProcess := TfrmImportProcess.Create(Self);
    frmImportProcess.Caption := 'Загрузка компонентов';
    frmImportProcess.ViewGridEx.DataSet := AutomaticLoadErrorTable;
    frmImportProcess.ViewGridEx.ApplyBestFitOnUpdateData := True;
    // Показываем отчёт
    frmImportProcess.Show;

    Application.ProcessMessages;

    AComponentsGroup2 := TComponentsGroup2.Create(Self);
    try
      AComponentsGroup2.LoadFromExcelFolder(AFileNames, AutomaticLoadErrorTable,
        AProducer);
    finally
      FreeAndNil(AComponentsGroup2);
      // Разрешаем закрыть форму
      frmImportProcess.Done := True;
    end;
  finally
    FreeAndNil(AFileNames);
  end;
  {
    // Тут некоторые узлы почему-то разворачиваются
    MainView.ViewData.Collapse(True);
    FocusTopLeft(clValue.DataBinding.FieldName);

    UpdateView;
  }
end;

procedure TfrmMain.DoOnLoadParametricData(Sender: TObject);
begin
  Application.Hint := '';
  // будем загружать параметрические данные для компонентов (не семейств)
  LoadParametricData([ctComponent]);
end;

procedure TfrmMain.DoOnLoadParametricTable(Sender: TObject);
begin
  Application.Hint := '';
  // будем загружать параметрические данные для семейств компонентов
  LoadParametricData([ctFamily]);
end;

procedure TfrmMain.DoOnOpenCategory(Sender: TObject);
var
  AExternalID: string;
  AFamilyCaption: string;
  ASubGroup: string;
  I: Integer;
begin
  Assert(TDM.Create.ComponentsSearchGroup.qFamilySearch.FDQuery.
    RecordCount > 0);
  AFamilyCaption := TDM.Create.ComponentsSearchGroup.qFamilySearch.W.Value.
    F.AsString;
  ASubGroup := TDM.Create.ComponentsSearchGroup.qFamilySearch.W.subGroup.
    F.AsString;
  Assert(not ASubGroup.IsEmpty);
  // Получаем первую - главную категорию семейства
  I := ASubGroup.IndexOf(',');
  if I = -1 then
    I := ASubGroup.Length;

  AExternalID := ASubGroup.Substring(0, I);
  TDM.Create.qTreeList.W.LocateByExternalID(AExternalID);

  // Ждём, пока группа компонентов обновит свои данные!
  Application.ProcessMessages;

  TDM.Create.ComponentsGroup.qFamily.FamilyW.Value.Locate(AFamilyCaption,
    [lxoCaseInsensitive]);

  // Переключаемся на вкладку "Компоненты"
  cxpcCompGroupRight.ActivePage := cxtsCategoryComponents;
  ViewComponents.cxGrid.SetFocus;
  // Application.ProcessMessages;

  if ViewComponents.MainView.Controller.FocusedRow <> nil then
    ViewComponents.MainView.Controller.FocusedRow.Selected := True;

  ViewComponents.MainView.GetColumnByFieldName
    (ViewComponents.clValue.DataBinding.FieldName).Selected := True;
end;

procedure TfrmMain.DoOnTotalReadProgress(ASender: TObject);
var
  E: TExcelDMEvent;
begin
  Assert(FfrmProgressBar <> nil);
  E := ASender as TExcelDMEvent;
  FfrmProgressBar.UpdateReadStatistic(E.TotalProgress.TotalProgress);
end;

procedure TfrmMain.DoOnViewStoreHouseCanFocusRecord(Sender: TObject);
var
  AOnCanFocusRecord: TOnCanFocusRecord;
begin
  if ViewProducts = nil then
    Exit;

  AOnCanFocusRecord := Sender as TOnCanFocusRecord;
  AOnCanFocusRecord.Allow := ViewProducts.CheckAndSaveChanges <> IDCancel;
end;

function TfrmMain.GetQueryMonitor: TQueryMonitor;
begin
  Result := TDM.Create.qTreeList.Monitor;
end;

procedure TfrmMain.LoadDocFromExcelDocument;
var
  AFileName: string;
begin
  if not TDialog.Create.ShowDialog(TExcelFileOpenDialog,
    TSettings.Create.LastFolderForComponentsLoad, '', AFileName) then
    Exit;
  // отказались от выбора файла

  // Сохраняем эту папку в настройках
  TSettings.Create.LastFolderForComponentsLoad :=
    TPath.GetDirectoryName(AFileName);

  TBindDoc.LoadDocBindsFromExcelDocument(AFileName);
end;

function TfrmMain.LoadExcelFileHeader(var AFileName: String;
AFieldsInfo: TFieldsInfo): Boolean;
var
  ARootTreeNode: TStringTreeNode;
  R: TLoadExcelFileHeaderResult;
begin
  Result := False;
  Assert(AFieldsInfo <> nil);

  if not TDialog.Create.ShowDialog(TExcelFileOpenDialog,
    TSettings.Create.ParametricDataFolder, '', AFileName) then
    Exit;
  // отказались от выбора файла

  // Сохраняем эту папку в настройках
  TSettings.Create.ParametricDataFolder := TPath.GetDirectoryName(AFileName);

  // Описания полей excel файла
  ARootTreeNode := TExcelDM.LoadExcelFileHeader(AFileName);
  try
    // Result :=
    R := TDM.Create.LoadExcelFileHeader(ARootTreeNode, AFieldsInfo,
      function(AParametricErrorTable: TParametricErrorTable): Boolean
      var
        AfrmParametricTableError: TfrmParametricTableError;
      begin
        AfrmParametricTableError := TfrmParametricTableError.Create(Self);
        try
          // AfrmGridView.Caption := 'Ошибки среди параметров';
          AfrmParametricTableError.ViewParametricTableError.DataSet :=
            AParametricErrorTable;
          // Показываем что мы собираемся привязывать
          Result := AfrmParametricTableError.ShowModal = mrOk;
        finally
          FreeAndNil(AfrmParametricTableError);
        end;
      end);

    case R of
      ID_ParametricTableNotFound:
        TDialog.Create.ParametricTableNotFound;
      ID_NoParameterForLoad:
        TDialog.Create.ErrorMessageDialog
          ('Нет параметров, значения которых можно загрузить');
    end;
    Result := R = ID_OK;
  finally
    FreeAndNil(ARootTreeNode);
  end;
end;

procedure TfrmMain.LoadParametricData(AComponentTypeSet: TComponentTypeSet);
var
  ADataOnly: Boolean;
  AFieldsInfo: TFieldsInfo;
  AFileName: string;
  AFullFileName: string;
  AParametricExcelDM: TParametricExcelDM;
  m: TArray<String>;
  rc: Integer;
begin
  AFieldsInfo := TFieldsInfo.Create();
  try
    if not LoadExcelFileHeader(AFullFileName, AFieldsInfo) then
      Exit;

    // Если идёт загрузка только данных
    ADataOnly := AComponentTypeSet = [ctComponent];

    if not ADataOnly then
    begin
      // В начале имени файла - код категории в которую будем загружать параметры
      AFileName := TPath.GetFileNameWithoutExtension(AFullFileName);

      m := AFileName.Split([' ']);
      if Length(m) = 1 then
      begin
        TDialog.Create.ErrorMessageDialog('Имя файла должно содержать пробел');
        Exit;
      end;

      try
        // Проверяем что первая часть содержит целочисленный код категории
        m[0].ToInteger;
      except
        TDialog.Create.ErrorMessageDialog('Имя файла должно содержать пробел');
        Exit;
      end;

      // Ищем, есть ли категория с такми внешним кодом
      if TDM.Create.qSearchCategory.SearchByExternalID(m[0]) = 0 then
      begin
        TDialog.Create.ErrorMessageDialog
          (Format('Категория %s не найдена', [m[0]]));
        Exit;
      end;

      // Ищем все дочерние категории
      rc := TDM.Create.qSearchDaughterCategories.SearchEx
        (TDM.Create.qSearchCategory.W.ID.F.AsInteger);
      Assert(rc > 1);
    end;

    AParametricExcelDM := TParametricExcelDM.Create(Self, AFieldsInfo,
      AComponentTypeSet);
    FWriteProgress := TTotalProgress.Create;
    FfrmProgressBar := TfrmProgressBar3.Create(Self);
    try
      TNotifyEventWrap.Create(AParametricExcelDM.AfterLoadSheet,
        DoAfterLoadSheet);
      TNotifyEventWrap.Create(AParametricExcelDM.OnTotalProgress,
        DoOnTotalReadProgress);

      FfrmProgressBar.Show;
      AParametricExcelDM.LoadExcelFile2(AFullFileName);

      // Обновляем параметры для текущей категории
      TDM.Create.CategoryParametersGroup.RefreshData;
      // Пытаемся обновить параметрическую таблицу
      TDM.Create.ComponentsExGroup.TryRefresh;
    finally
      FreeAndNil(AParametricExcelDM);
      FreeAndNil(FWriteProgress);
      FreeAndNil(FfrmProgressBar);
    end;
  finally
    FreeAndNil(AFieldsInfo);
  end;

end;

procedure TfrmMain.TryUpdateAnalizeStatistic(API: TProgressInfo);
begin
  if (API.ProcessRecords mod OnWriteProcessEventRecordCount = 0) or
    (API.ProcessRecords = API.TotalRecords) then
    // Отображаем прогресс анализа
    FfrmProgressBar.UpdateAnalizeStatistic(API);
end;

procedure TfrmMain.TryUpdateWrite0Statistic(API: TProgressInfo);
begin
  if (API.ProcessRecords mod OnWriteProcessEventRecordCount = 0) or
    (API.ProcessRecords = API.TotalRecords) then
    // Отображаем общий прогресс записи
    FfrmProgressBar.UpdateWriteStatistic0(API);
end;

procedure TfrmMain.TryUpdateWriteStatistic(API: TProgressInfo);
begin
  if (API.ProcessRecords mod OnWriteProcessEventRecordCount = 0) or
    (API.ProcessRecords = API.TotalRecords) then
    // Отображаем общий прогресс записи
    FfrmProgressBar.UpdateWriteStatistic(API);
end;

procedure TfrmMain.UpdateCaption;
var
  AFS: TFormatSettings;
  S: string;
begin
  if (TDM.Created) and (TDM.Create.qTreeList.FDQuery.RecordCount > 0) then
  begin
    if not TDM.Create.qTreeList.W.IsRootFocused and not FCategoryPath.IsEmpty
    then
    begin
      S := MinimizeName(FCategoryPath, Canvas, Width - 200);
      S := S.Trim(['\']).Replace('\', '-');

    end
    else
      S := TDM.Create.qTreeList.W.Value.F.AsString;

    AFS.DecimalSeparator := '.';
    Caption := Format('%s %0.1f - %s',
      [sMainFormCaption, ProgramVersion, S], AFS);
  end;
end;

procedure TfrmMain.ViewComponentsactOpenDatasheetExecute(Sender: TObject);
begin
  ViewComponents.actOpenDatasheetExecute(Sender);
end;

initialization

  ;

finalization

  ;

end.
