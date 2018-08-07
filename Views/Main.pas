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
  StoreHouseInfoView, ComponentsTabSheetView, ProductsTabSheetView,
  Vcl.AppEvnts, HintWindowEx, ProtectUnit, TreeListView, System.SysUtils,
  BaseEventsQuery, cxDataControllerConditionalFormattingRulesManagerDialog;

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
    cxpcLeft: TcxPageControl;
    cxtsComponents: TcxTabSheet;
    cxtsStorehouses: TcxTabSheet;
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
    cxpcRight: TcxPageControl;
    cxspltrMain: TcxSplitter;
    cxtsRComponents: TcxTabSheet;
    cxtsRStorehouses: TcxTabSheet;
    CxGridStorehouseList: TcxGrid;
    tvStorehouseList: TcxGridDBTableView;
    clStorehouseListTitle: TcxGridDBColumn;
    glStorehouseList: TcxGridLevel;
    pmLeftStoreHouse: TPopupMenu;
    actAddStorehouse: TAction;
    actDeleteStorehouse: TAction;
    actRenameStorehouse: TAction;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    actShowExtraCharge: TAction;
    dxBarButton1: TdxBarButton;
    ApplicationEvents: TApplicationEvents;
    procedure actAddStorehouseExecute(Sender: TObject);
    procedure actDeleteStorehouseExecute(Sender: TObject);
    procedure actDeleteStorehouseUpdate(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actRenameStorehouseExecute(Sender: TObject);
    procedure actRenameStorehouseUpdate(Sender: TObject);
    procedure actSaveAllExecute(Sender: TObject);
    procedure actSelectDataBasePathExecute(Sender: TObject);
    procedure actShowBodyTypes2Execute(Sender: TObject);
    procedure actShowBodyTypes3Execute(Sender: TObject);
    procedure actShowDescriptionsExecute(Sender: TObject);
    procedure actShowExtraChargeExecute(Sender: TObject);
    procedure actShowProducersExecute(Sender: TObject);
    procedure actShowParametersExecute(Sender: TObject);
    procedure ApplicationEventsException(Sender: TObject; E: Exception);
    procedure ApplicationEventsHint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure dbtlCategoriesDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure dbtlCategoriesDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure btnFocusRootClick(Sender: TObject);
    procedure cxpcLeftChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure OnTreeListCanFocusNode(Sender: TcxCustomTreeList;
      ANode: TcxTreeListNode; var Allow: Boolean);
    procedure cxtsComponentsShow(Sender: TObject);
    procedure cxtsStorehousesShow(Sender: TObject);
    procedure ViewComponentsactOpenDatasheetExecute(Sender: TObject);
  private
    FCategoryPath: string;
    FComponentsFrame: TComponentsFrame;
    FEventList: TObjectList;
    FHintWindowEx: THintWindowEx;
    FOnProductCategoriesChange: TNotifyEventWrap;
    FProductsFrame: TProductsFrame;
    FQuerySearchCategoriesPath: TQuerySearchCategoriesPath;
    FViewTreeList: TViewTreeList;
    procedure DoAfterTreeListSmartRefresh(Sender: TObject);
    procedure DoBeforeParametricTableActivate(Sender: TObject);
    procedure DoBeforeParametricTableDeactivate(Sender: TObject);
    procedure DoOnComponentLocate(Sender: TObject);
    procedure DoOnProductCategoriesChange(Sender: TObject);
    procedure DoOnShowParametricTable(Sender: TObject);
    function GetQueryMonitor: TQueryMonitor;
    procedure ShowParametricTable;
    function ShowSettingsEditor: Integer;
    procedure UpdateCaption;
    { Private declarations }
  protected
    procedure DoOnHaveAnyChanges(Sender: TObject);
    procedure DoOnOpenCategory(Sender: TObject);
    procedure DoOnProductLocate(Sender: TObject);
    property ComponentsFrame: TComponentsFrame read FComponentsFrame;
    property ProductsFrame: TProductsFrame read FProductsFrame;
    property QueryMonitor: TQueryMonitor read GetQueryMonitor;
    property ViewTreeList: TViewTreeList read FViewTreeList;
  public
    constructor Create(AOwner: TComponent); override;
    function CheckDataBasePath: Boolean;
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
  System.IOUtils, ImportProcessForm, ProgressInfo, ProgressBarForm,
  Vcl.FileCtrl, SearchDescriptionsQuery, TableWithProgress, GridViewForm,
  TreeListQuery, AutoBindingDocForm, AutoBindingDescriptionForm,
  FireDAC.Comp.Client, AutoBinding, AllFamilyQuery, ProducersForm,
  ProductsBaseQuery, RecursiveTreeView,
  RecursiveTreeQuery, TreeExcelDataModule, BindDocUnit, DialogUnit2,
  LoadFromExcelFileHelper, SearchCategoryQuery, CustomErrorForm,
  ExtraChargeForm, ExceptionHelper, System.StrUtils, DataModule;

{$R *.dfm}

constructor TfrmMain.Create(AOwner: TComponent);
begin
  Application.HintHidePause := 10000;
  inherited Create(AOwner);
  FHintWindowEx := THintWindowEx.Create(Self);
  FQuerySearchCategoriesPath := TQuerySearchCategoriesPath.Create(Self);
end;

procedure TfrmMain.actAddStorehouseExecute(Sender: TObject);
var
  Value: string;
begin
  TDM.Create.qStoreHouseList.TryPost;

  Value := InputBox(sDatabase, sPleaseWrite, '');
  if Value <> '' then
  begin
    TDM.Create.qStoreHouseList.LocateOrAppend(Value);
    clStorehouseListTitle.ApplyBestFit();
  end;
end;

procedure TfrmMain.actDeleteStorehouseExecute(Sender: TObject);
begin
  TDM.Create.qStoreHouseList.TryPost;
  if TDM.Create.qStoreHouseList.FDQuery.RecordCount > 0 then
  begin
    if TDialog.Create.DeleteRecordsDialog(sDoYouWantToDelete) then
    begin
      TDM.Create.qStoreHouseList.FDQuery.Delete;
    end;
  end;
end;

procedure TfrmMain.actDeleteStorehouseUpdate(Sender: TObject);
begin
  actDeleteStorehouse.Enabled := tvStorehouseList.DataController.
    RecordCount > 0;
end;

procedure TfrmMain.actExitExecute(Sender: TObject);
begin
  Close
end;

procedure TfrmMain.actRenameStorehouseExecute(Sender: TObject);
var
  Value: string;
begin
  if tvStorehouseList.Controller.SelectedRecordCount > 0 then
  begin
    TDM.Create.qStoreHouseList.TryPost;
    Value := InputBox(sDatabase, sPleaseWrite,
      TDM.Create.qStoreHouseList.Title.AsString);
    if (Value <> '') then
    begin
      TDM.Create.qStoreHouseList.TryEdit;
      TDM.Create.qStoreHouseList.Title.AsString := Value;
      TDM.Create.qStoreHouseList.TryPost;
      clStorehouseListTitle.ApplyBestFit();
    end;
  end;
end;

procedure TfrmMain.actRenameStorehouseUpdate(Sender: TObject);
begin
  actRenameStorehouse.Enabled := tvStorehouseList.DataController.
    RecordCount > 0;
end;

procedure TfrmMain.actSaveAllExecute(Sender: TObject);
begin
  QueryMonitor.ApplyUpdates;
  // DM2.SaveAll;
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
  if frmExtraCharge = nil then
  begin
    TDM.Create.qExtraCharge.RefreshQuery;
    frmExtraCharge := TfrmExtraCharge.Create(Self);
    frmExtraCharge.ViewExtraCharge.qExtraCharge := TDM.Create.qExtraCharge;
  end;

  frmExtraCharge.Show;
end;

procedure TfrmMain.actShowProducersExecute(Sender: TObject);
begin
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
  if frmParameters = nil then
  begin
    TDM.Create.ParametersGroup.ReOpen;
    frmParameters := TfrmParameters.Create(Self);
    frmParameters.ViewParameters.ParametersGrp := TDM.Create.ParametersGroup;
    frmParameters.ViewSubParameters.QuerySubParameters :=
      TDM.Create.ParametersGroup.qSubParameters;
  end;

  frmParameters.Show;
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
  TDM.Create.qTreeList.LocateToRoot;
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

procedure TfrmMain.cxpcLeftChange(Sender: TObject);
begin
  ProductsFrame.ViewProducts2.CheckAndSaveChanges;
  ProductsFrame.ViewProductsSearch2.CheckAndSaveChanges;
  ComponentsFrame.ViewComponents.CheckAndSaveChanges;
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
  cxpcLeft.ActivePage := cxtsStorehouses;
  // Переключаемся на вкладку поиск на складе
  ProductsFrame.cxpcStorehouse.ActivePage := ProductsFrame.tsStorehouseSearch;

  BringToFront;
  ProductsFrame.ViewProductsSearch2.FocusValueColumn;
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

  cxpcRight.Properties.HideTabs := True;
  cxpcLeft.ActivePage := cxtsComponents;

  // Создаём фрейм с компонентами
  FComponentsFrame := TComponentsFrame.Create(Self);
  ComponentsFrame.Parent := cxtsRComponents;
  ComponentsFrame.Align := alClient;

  // Создаём фрейм со складом
  FProductsFrame := TProductsFrame.Create(Self);
  ProductsFrame.Parent := cxtsRStorehouses;
  ProductsFrame.Align := alClient;

  // Создаём фрейм с деревом категорий
  FViewTreeList := TViewTreeList.Create(Self);
  ViewTreeList.Parent := cxtsComponents;
  ViewTreeList.Align := alClient;
  // Устанавливаем обработчик события
  ViewTreeList.cxDBTreeList.OnCanFocusNode := OnTreeListCanFocusNode;

  ComponentsFrame.cxpcComponents.ActivePage := ComponentsFrame.cxtsCategory;
  ProductsFrame.cxpcStorehouse.ActivePage := ProductsFrame.tsStorehouseProducts;

  Assert(not DMRepository.dbConnection.Connected);

  inherited;

  Self.WindowState := wsNormal;

  // Подписываемся на события
  FEventList := TObjectList.Create;

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

      // Подписываемся чтобы искать компонент на складах
      TNotifyEventWrap.Create(TDM.Create.ComponentsExGroup.qComponentsEx.
        OnLocate, DoOnComponentLocate, FEventList);

      // Подписываемся чтобы искать компонент в параметрической таблице
      TNotifyEventWrap.Create(TDM.Create.qProducts.OnLocate, DoOnProductLocate,
        FEventList);
      TNotifyEventWrap.Create(TDM.Create.qProductsSearch.OnLocate,
        DoOnProductLocate, FEventList);

      // Привязываем представления к данным
      ComponentsFrame.ViewComponents.ComponentsGroup :=
        TDM.Create.ComponentsGroup;

      // Подписываемся на событие о отображении параметрической таблицы
      TNotifyEventWrap.Create
        (ComponentsFrame.ViewComponents.OnShowParametricTableEvent,
        DoOnShowParametricTable, FEventList);

      ComponentsFrame.ViewComponentsSearch.ComponentsSearchGroup :=
        TDM.Create.ComponentsSearchGroup;

      // Подписываемся на событие чтобы открывать найденную категорию
      TNotifyEventWrap.Create(TDM.Create.ComponentsSearchGroup.OnOpenCategory,
        DoOnOpenCategory, FEventList);

      // Параметры в виде списка
      ComponentsFrame.ViewCategoryParameters.CatParamsGroup :=
        TDM.Create.CategoryParametersGroup;

      ComponentsFrame.ViewParametricTable.ComponentsExGroup :=
        TDM.Create.ComponentsExGroup;

      // Привязываем список складов к данным
      tvStorehouseList.DataController.DataSource :=
        TDM.Create.qStoreHouseList.DataSource;

      clStorehouseListTitle.ApplyBestFit();

      // Привязываем информацию о складе к данным
      ProductsFrame.ViewStorehouseInfo.QueryStoreHouseList :=
        TDM.Create.qStoreHouseList;

      // Привязываем текущий склад к данным
      ProductsFrame.ViewProducts2.qProducts := TDM.Create.qProducts;

      // Привязываем поиск по складам к данным
      ProductsFrame.ViewProductsSearch2.qProductsSearch :=
        TDM.Create.qProductsSearch;


      // ViewStoreHouse.StoreHouseGroup := DM2.StoreHouseGroup;
      // ViewStoreHouse.QueryProductsSearch := DM2.qProductsSearch;

      // привязываем дерево катогорий к данным
      // AClone := DM2.qTreeList.AddClone('');
      // DM2.qTreeList.DataSource.DataSet := AClone;

      ViewTreeList.qTreeList := TDM.Create.qTreeList;

      TNotifyEventWrap.Create(TDM.Create.qTreeList.AfterSmartRefresh,
        DoAfterTreeListSmartRefresh, FEventList);

      // Привязываем подкатегории к данным (функциональная группа)
      ComponentsFrame.ViewChildCategories.qChildCategories :=
        TDM.Create.qChildCategories;

      {
        ComponentsFrame.tvFunctionalGroup.DataController.DataSource :=
        DM2.qChildCategories.DataSource;
      }
      FOnProductCategoriesChange := TNotifyEventWrap.Create
        (TDM.Create.qTreeList.AfterScroll, DoOnProductCategoriesChange,
        FEventList);

      // Искусственно вызываем событие
      DoOnProductCategoriesChange(nil);

    end;
  end;

  // OK := OK and TProtect.Create.Check;
  (*
    if not OK then
    begin
    Application.ShowMainForm := False;
    Application.Terminate; // завершаем работу приложения
    end;
  *)
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
  ComponentsFrame.cxtsCategoryComponents.Enabled :=
    not TDM.Create.qTreeList.IsRootFocused;

  Assert(TDM.Create.qTreeList.PK.AsInteger > 0);
  Assert(FQuerySearchCategoriesPath <> nil);
  FCategoryPath := FQuerySearchCategoriesPath.GetFullPath
    (TDM.Create.qTreeList.PK.AsInteger);

  UpdateCaption;

end;

procedure TfrmMain.DoOnProductLocate(Sender: TObject);
var
  LO: TLocateObject;
begin
  LO := (Sender as TLocateObject);

  if not TDM.Create.qTreeList.LocateByPK(LO.IDCategory) then
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
  Allow := (ComponentsFrame.ViewComponents.CheckAndSaveChanges <> IDCancel) and
    (ComponentsFrame.ViewCategoryParameters.CheckAndSaveChanges <> IDCancel);
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

procedure TfrmMain.cxtsComponentsShow(Sender: TObject);
begin
  // Справа активизируем вкладку "Компоненты"
  cxpcRight.ActivePage := cxtsRComponents;
end;

procedure TfrmMain.cxtsStorehousesShow(Sender: TObject);
begin
  // Справа активизируем вкладку "Склады"
  cxpcRight.ActivePage := cxtsRStorehouses;
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
  rc := TSearchSubCategories.Search(TDM.Create.qTreeList.PK.Value);
  // Если у нашей категории есть подкатегории
  if rc > 0 then
    ACategoryPath := TDM.Create.qTreeList.Value.AsString
  else
  begin
    // Если в цепочке категорий мы последнее звено
    ACategoryPath := FQuerySearchCategoriesPath.GetLastTreeNodes
      (TDM.Create.qTreeList.PK.Value, 2, '-');
  end;
  frmParametricTable.CategoryPath := ACategoryPath;
end;

procedure TfrmMain.DoBeforeParametricTableDeactivate(Sender: TObject);
begin
  TDM.Create.ComponentsExGroup.DecClient;
end;

procedure TfrmMain.DoOnHaveAnyChanges(Sender: TObject);
begin
  actSaveAll.Enabled := QueryMonitor.HaveAnyChanges;
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
  AFamilyCaption := TDM.Create.ComponentsSearchGroup.qFamilySearch.
    Value.AsString;
  ASubGroup := TDM.Create.ComponentsSearchGroup.qFamilySearch.subGroup.AsString;
  Assert(not ASubGroup.IsEmpty);
  // Получаем первую - главную категорию семейства
  I := ASubGroup.IndexOf(',');
  if I = -1 then
    I := ASubGroup.Length;

  AExternalID := ASubGroup.Substring(0, I);
  TDM.Create.qTreeList.LocateByExternalID(AExternalID);

  // Ждём, пока группа компонентов обновит свои данные!
  Application.ProcessMessages;

  TDM.Create.ComponentsGroup.qFamily.LocateValue(AFamilyCaption);

  // Переключаемся на вкладку "Компоненты"
  ComponentsFrame.cxpcComponents.ActivePage :=
    ComponentsFrame.cxtsCategoryComponents;
  ComponentsFrame.ViewComponents.cxGrid.SetFocus;
  // Application.ProcessMessages;

  ComponentsFrame.ViewComponents.MainView.Controller.FocusedRow.
    Selected := True;

  ComponentsFrame.ViewComponents.MainView.GetColumnByFieldName
    (ComponentsFrame.ViewComponents.clValue.DataBinding.FieldName)
    .Selected := True;
end;

function TfrmMain.GetQueryMonitor: TQueryMonitor;
begin
  Result := TDM.Create.qTreeList.Monitor;
end;

procedure TfrmMain.UpdateCaption;
var
  AFS: TFormatSettings;
  S: string;
begin
  if (TDM.Created) and (TDM.Create.qTreeList.FDQuery.RecordCount > 0) then
  begin
    if not TDM.Create.qTreeList.IsRootFocused and not FCategoryPath.IsEmpty then
    begin
      S := MinimizeName(FCategoryPath, Canvas, Width - 200);
      S := S.Trim(['\']).Replace('\', '-');

    end
    else
      S := TDM.Create.qTreeList.Value.AsString;

    AFS.DecimalSeparator := '.';
    Caption := Format('%s %0.1f - %s',
      [sMainFormCaption, ProgramVersion, S], AFS);
  end;
end;

procedure TfrmMain.ViewComponentsactOpenDatasheetExecute(Sender: TObject);
begin
  ComponentsFrame.ViewComponents.actOpenDatasheetExecute(Sender);
end;

initialization

  ;

finalization

  ;

end.
