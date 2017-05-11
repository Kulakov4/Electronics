unit Main;

interface

{$WARN UNIT_PLATFORM OFF}

uses
  Windows, Messages, SysUtils, Variants, Graphics, Controls, Forms,
  Dialogs, dxSkinsdxBarPainter, dxBar, cxClasses,
  Menus, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxCustomData, cxStyles, cxTL, cxTLdxBarBuiltInMenu, dxSkinscxPCPainter,
  cxPCdxBarPopupMenu, cxPC, cxSplitter, StdCtrls, cxButtons, cxInplaceContainer,
  cxTLData, cxDBTL, ExtCtrls, dxSkinsdxStatusBarPainter, dxStatusBar,
  cxFilter, cxData, cxDataStorage, cxEdit, cxDBData, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxMaskEdit, ComCtrls, dxtree, dxdbtree, dxBarBuiltInMenu,
  cxTextEdit, cxBlobEdit, cxLabel, cxMemo, cxNavigator, RootForm,
  StorehouseView,
  System.UITypes, System.Types,
  System.Contnrs, NotifyEvents, DataModule, System.Actions, Vcl.ActnList,
  dxSkinsCore, dxSkinsDefaultPainters, GridFrame, ComponentsBaseView,
  ComponentsView, ComponentsSearchView, ParametersForCategoriesView,
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
  ProductsSearchView, ProductsBaseView, ProductsView, StoreHouseInfoView,
  ComponentsTabSheetView, ProductsTabSheetView;

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
    pmLeftTreeList: TPopupMenu;
    mniAddRecord: TMenuItem;
    mniRenameRecord: TMenuItem;
    mniDeleteRecord: TMenuItem;
    dxbrMainBar2: TdxBar;
    dxbrbtnSettings: TdxBarButton;
    cxpcLeft: TcxPageControl;
    cxtsComponents: TcxTabSheet;
    cxtsStorehouses: TcxTabSheet;
    ActionList: TActionList;
    actShowManufacturers: TAction;
    actShowDescriptions: TAction;
    actShowParameters: TAction;
    actShowBodyTypes: TAction;
    actShowBodyTypes2: TAction;
    dxBarButton2: TdxBarButton;
    actShowBodyTypes3: TAction;
    actSelectDataBasePath: TAction;
    actSaveAll: TAction;
    dxBarButton4: TdxBarButton;
    actExit: TAction;
    actDeleteTreeNode: TAction;
    actRenameTreeNode: TAction;
    actAddTreeNode: TAction;
    actLoadBodyTypes: TAction;
    actExportTreeToExcelDocument: TAction;
    Excel1: TMenuItem;
    actLoadTreeFromExcelDocument: TAction;
    Excel2: TMenuItem;
    dxBarButton10: TdxBarButton;
    dbtlCategories: TcxDBTreeList;
    clValue: TcxDBTreeListColumn;
    clId: TcxDBTreeListColumn;
    clParentId: TcxDBTreeListColumn;
    clOrder: TcxDBTreeListColumn;
    cxpcRight: TcxPageControl;
    cxspltrMain: TcxSplitter;
    cxtsRComponents: TcxTabSheet;
    cxtsRStorehouses: TcxTabSheet;
    CxGridStorehouseList: TcxGrid;
    tvStorehouseList: TcxGridDBTableView;
    clStorehouseListTitle: TcxGridDBColumn;
    glStorehouseList: TcxGridLevel;
    ComponentsFrame: TComponentsFrame;
    ProductsFrame: TProductsFrame;
    procedure actAddTreeNodeExecute(Sender: TObject);
    procedure actDeleteTreeNodeExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actExportTreeToExcelDocumentExecute(Sender: TObject);
    procedure actLoadBodyTypesExecute(Sender: TObject);
    procedure actLoadTreeFromExcelDocumentExecute(Sender: TObject);
    procedure actRenameTreeNodeExecute(Sender: TObject);
    procedure actSaveAllExecute(Sender: TObject);
    procedure actSelectDataBasePathExecute(Sender: TObject);
    procedure actShowBodyTypes2Execute(Sender: TObject);
    procedure actShowBodyTypes3Execute(Sender: TObject);
    procedure actShowBodyTypesExecute(Sender: TObject);
    procedure actShowDescriptionsExecute(Sender: TObject);
    procedure actShowManufacturersExecute(Sender: TObject);
    procedure actShowParametersExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure dbtlCategoriesDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure dbtlCategoriesDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure dbtlCategoriesStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure btnFocusRootClick(Sender: TObject);
    procedure cxpcLeftChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure dbtlCategoriesClick(Sender: TObject);
    procedure dbtlCategoriesCollapsed(Sender: TcxCustomTreeList;
      ANode: TcxTreeListNode);
    procedure dbtlCategoriesExpanded(Sender: TcxCustomTreeList;
      ANode: TcxTreeListNode);
    procedure tlLeftControlMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure dbtlCategoriesCanFocusNode(Sender: TcxCustomTreeList;
      ANode: TcxTreeListNode; var Allow: Boolean);
    procedure cxtsComponentsShow(Sender: TObject);
    procedure cxtsStorehousesShow(Sender: TObject);
    procedure ViewComponentsactOpenDatasheetExecute(Sender: TObject);
  private
    FCategoryPath: string;
    FEventList: TObjectList;
    FOnProductCategoriesChange: TNotifyEventWrap;
    FQuerySearchCategoriesPath: TQuerySearchCategoriesPath;
    FSelectedId: Integer;
    procedure DoBeforeParametricTableFormClose(Sender: TObject);
    procedure DoOnComponentLocate(Sender: TObject);
    procedure DoOnProductCategoriesChange(Sender: TObject);
    procedure DoOnShowParametricTable(Sender: TObject);
    function GetLevel(ANode: TcxTreeListNode): Integer;
    procedure ShowParametricTable;
    function ShowSettingsEditor: Integer;
    procedure UpdateCaption;
    { Private declarations }
  protected
    procedure DoOnProductLocate(Sender: TObject);
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
  ParametersForm, SettingsController, BodyTypesTreeForm,
  BodyTypesGridQuery, ReportsForm, ReportQuery, ParametricExcelDataModule,
  ComponentBodyTypesExcelDataModule, ParametricTableForm, BodyTypesForm,
  ProjectConst, PathSettingsForm, ImportErrorForm, ErrorForm,
  cxGridDBBandedTableView, System.IOUtils, SearchMainParameterQuery,
  ImportProcessForm, SearchDaughterParameterQuery, ProgressInfo,
  ProgressBarForm, BodyTypesQuery, Vcl.FileCtrl, SearchDescriptionsQuery,
  SearchSubCategoriesQuery, SearchComponentCategoryQuery2, TableWithProgress,
  GridViewForm, TreeListQuery, AutoBindingDocForm, AutoBindingDescriptionForm,
  FireDAC.Comp.Client, AutoBinding, AllFamilyQuery, ProducersForm,
  SearchFamilyByID, ProductsBaseQuery, DescriptionsGroupUnit,
  RecursiveTreeView, RecursiveTreeQuery, TreeExcelDataModule, BindDocUnit,
  DialogUnit2;

{$R *.dfm}

constructor TfrmMain.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FQuerySearchCategoriesPath := TQuerySearchCategoriesPath.Create(Self);
end;

procedure TfrmMain.actAddTreeNodeExecute(Sender: TObject);
var
  value: string;
begin
  DM.qTreeList.TryPost;

  value := InputBox(sDatabase, sPleaseWrite, '');

  if value <> '' then
  begin
    DM.qTreeList.FDQuery.DisableControls;
    try
      DM.qTreeList.AddChildCategory(value,
        GetLevel(dbtlCategories.FocusedNode));
    finally
      DM.qTreeList.FDQuery.EnableControls;
    end;
  end;
end;

procedure TfrmMain.actDeleteTreeNodeExecute(Sender: TObject);
begin
  DM.qTreeList.TryPost;
  if TDialog.Create.DeleteRecordsDialog(sDoYouWantToDelete) then
  begin
    DM.qTreeList.FDQuery.Delete;
    DM.qTreeList.FDQuery.Refresh;
  end;
end;

procedure TfrmMain.actExitExecute(Sender: TObject);
begin
  Close
end;

procedure TfrmMain.actExportTreeToExcelDocumentExecute(Sender: TObject);
var
  AQueryRecursiveTree: TQueryRecursiveTree;
  AViewRecursiveTree: TViewRecursiveTree;
begin
  AQueryRecursiveTree := TQueryRecursiveTree.Create(Self);
  AViewRecursiveTree := TViewRecursiveTree.Create(Self);
  try
    AQueryRecursiveTree.RefreshQuery;
    AViewRecursiveTree.QueryRecursiveTree := AQueryRecursiveTree;
    AViewRecursiveTree.actExportToExcelDocument.Execute;
  finally
    FreeAndNil(AViewRecursiveTree);
    FreeAndNil(AQueryRecursiveTree);
  end;
end;

procedure TfrmMain.actLoadBodyTypesExecute(Sender: TObject);
var
  AComponentBodyTypesExcelDM: TComponentBodyTypesExcelDM;
  AFileName: string;
  AfrmImportError: TfrmImportError;
  OK: Boolean;
begin
  AFileName := TDialog.Create.OpenExcelFile
    (TSettings.Create.LastFolderForExcelFile);

  if AFileName.IsEmpty then
    Exit; // отказались от выбора файла

  // Сохраняем эту папку в настройках
  TSettings.Create.LastFolderForExcelFile := TPath.GetDirectoryName(AFileName);

  AComponentBodyTypesExcelDM := TComponentBodyTypesExcelDM.Create(Self);
  try
    // Этот запрос будет использоваться для поиска корпусов
    DM.qBodyTypes.RefreshQuery;
    AComponentBodyTypesExcelDM.BodyTypesDataSet := DM.qBodyTypes.FDQuery;

    // Загружаем данные из excel файла
    TfrmProgressBar.Process(AComponentBodyTypesExcelDM,
      procedure
      begin
        AComponentBodyTypesExcelDM.LoadExcelFile(AFileName);
      end, 'Загрузка корпусных данных', sRows);

    OK := AComponentBodyTypesExcelDM.ExcelTable.Errors.RecordCount = 0;

    if not OK then
    begin
      AfrmImportError := TfrmImportError.Create(Self);
      try
        AfrmImportError.ErrorTable :=
          AComponentBodyTypesExcelDM.ExcelTable.Errors;
        OK := AfrmImportError.ShowModal = mrOk;

        if OK then
        begin
          case AfrmImportError.ContinueType of
            // Исключаем все ошибки
            ctAll:
              AComponentBodyTypesExcelDM.ExcelTable.ExcludeErrors(etError);
            // Исключаем все ошибки и предупреждения
            ctSkip:
              AComponentBodyTypesExcelDM.ExcelTable.ExcludeErrors(etWarring);
          end;
        end;
      finally
        FreeAndNil(AfrmImportError);
      end;
    end;

    if OK then
    begin
      // Сохраняем данные в БД
      TfrmProgressBar.Process(AComponentBodyTypesExcelDM.ExcelTable,
        procedure
        begin
          DM.ComponentsGroup.LoadBodyList
            (AComponentBodyTypesExcelDM.ExcelTable);
        end, 'Сохранение корпусных данных в БД', sRecords);
    end;

  finally
    FreeAndNil(AComponentBodyTypesExcelDM);
  end;

  // Обновляем запрос использующийся для поиска в справочнике корпусов
  DM.qBodyTypes.RefreshQuery;

  DM.ComponentsGroup.ReOpen;
end;

procedure TfrmMain.actLoadTreeFromExcelDocumentExecute(Sender: TObject);
var
  AFileName: string;
  AfrmGridView: TfrmGridView;
  AQueryRecursiveTree: TQueryRecursiveTree;
  ATreeExcelDM: TTreeExcelDM;
  OK: Boolean;
begin
  // if (DM.qTreeList.FDQuery.RecordCount > 0) and not TDialog.Create.ClearTreeDialog
  // then
  // Exit;

  AFileName := TDialog.Create.OpenExcelFile
    (TSettings.Create.LastFolderForExcelFile);

  if AFileName.IsEmpty then
    Exit;

  TSettings.Create.LastFolderForExcelFile := AFileName;
  AQueryRecursiveTree := TQueryRecursiveTree.Create(Self);
  try
    ATreeExcelDM := TTreeExcelDM.Create(Self);
    try
      TfrmProgressBar.Process(ATreeExcelDM,
        procedure
        begin
          ATreeExcelDM.LoadExcelFile(AFileName);
        end, 'Загрузка категорий из Excel документа', sRows);

      AQueryRecursiveTree.RefreshQuery;
      TfrmProgressBar.Process(ATreeExcelDM.ExcelTable,
        procedure
        begin
          AQueryRecursiveTree.LoadRecords(ATreeExcelDM.ExcelTable);
        end, 'Сохранение категорий в БД', sRecords);
    finally
      FreeAndNil(ATreeExcelDM);
    end;

    // Получаем добавленные категории
    AQueryRecursiveTree.HideNotAdded;
    // Если есть категории, которые были добавлены
    if AQueryRecursiveTree.FDQuery.RecordCount > 0 then
    begin
      AfrmGridView := TfrmGridView.Create(Self);
      try
        AfrmGridView.Caption := 'Добавленные категории';
        AfrmGridView.DataSet := AQueryRecursiveTree.FDQuery;
        AfrmGridView.ShowModal;
      finally
        FreeAndNil(AfrmGridView);
      end;
    end;

    AQueryRecursiveTree.HideNotDeleted;
    // Если есть категории, которые надо удалить
    if AQueryRecursiveTree.FDQuery.RecordCount > 0 then
    begin
      AfrmGridView := TfrmGridView.Create(Self);
      try
        AfrmGridView.Caption := 'Удаление категорий';
        AfrmGridView.cxbtnOK.Caption := 'Удалить';
        AfrmGridView.DataSet := AQueryRecursiveTree.FDQuery;
        OK := AfrmGridView.ShowModal = mrOk;
      finally
        FreeAndNil(AfrmGridView);
      end;

      if OK then
        AQueryRecursiveTree.DeleteAll;
    end;

  finally
    FreeAndNil(AQueryRecursiveTree);
  end;

  // Перечитываем дерево из БД
  dbtlCategories.BeginUpdate;
  try
    DM.qTreeList.RefreshQuery;
  finally
    dbtlCategories.EndUpdate;
    dbtlCategories.FocusedNode.Expand(False);
  end;
end;

procedure TfrmMain.actRenameTreeNodeExecute(Sender: TObject);
var
  value: string;
begin
  DM.qTreeList.TryPost;

  value := InputBox(sDatabase, sPleaseWrite, DM.qTreeList.value.AsString);
  if (value <> '') and
    (DM.qTreeList.CheckPossibility(DM.qTreeList.FDQuery.FieldByName('ParentId')
    .AsInteger, value)) then
  begin
    DM.qTreeList.TryEdit;
    DM.qTreeList.value.AsString := value;
    DM.qTreeList.TryPost;
  end;

end;

procedure TfrmMain.actSaveAllExecute(Sender: TObject);
begin
  DM.SaveAll;
end;

procedure TfrmMain.actSelectDataBasePathExecute(Sender: TObject);
var
  ANewDataBasePath: string;
  AOldDataBasePath: string;
begin
  AOldDataBasePath := TSettings.Create.databasePath;
  if ShowSettingsEditor = mrOk then
  begin
    ANewDataBasePath := TSettings.Create.databasePath;

    // Если путь до базы данных изменился
    if AOldDataBasePath <> ANewDataBasePath then
    begin
      dbtlCategories.BeginUpdate;
      try
        DM.CreateOrOpenDataBase;
        // Искусственно вызываем событие
        DoOnProductCategoriesChange(nil);
      finally
        try
          dbtlCategories.EndUpdate;
          dbtlCategories.FocusedNode.Expand(False);
        finally
        end;
      end;
    end;
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
    frmBodyTypes := TfrmBodyTypes.Create(Self);
    frmBodyTypes.ViewBodyTypes.BodyTypesGroup := DM.BodyTypesGroup;
  end;

  DM.BodyTypesGroup.ReOpen;
  frmBodyTypes.Show;
end;

procedure TfrmMain.actShowBodyTypesExecute(Sender: TObject);
begin
  if frmBodyTypesTree = nil then
  begin
    frmBodyTypesTree := TfrmBodyTypesTree.Create(Self);
    frmBodyTypesTree.ViewBodyTypesTree.QueryBodyTypesTree := DM.qBodyTypesTree;
  end;

  DM.qBodyTypesTree.RefreshQuery;
  frmBodyTypesTree.Show;
  // Сворачиваем дерево корпусов
  frmBodyTypesTree.ViewBodyTypesTree.CollapseAll();

  {
    if frmBodyTypes = nil then
    begin
    frmBodyTypes := TfrmBodyTypes.Create(Self);
    frmBodyTypes.ViewBodyTypes.BodyTypesMasterDetail := DM.BodyTypesMasterDetail;
    end;

    frmBodyTypes.Show;
  }
end;

procedure TfrmMain.actShowDescriptionsExecute(Sender: TObject);
begin
  if frmDescriptions = nil then
  begin
    DM.DescriptionsGroup.ReOpen;
    frmDescriptions := TfrmDescriptions.Create(Self);
    frmDescriptions.ViewDescriptions.DescriptionsGroup := DM.DescriptionsGroup;
  end;

  frmDescriptions.Show;
end;

procedure TfrmMain.actShowManufacturersExecute(Sender: TObject);
begin
  if frmProducers = nil then
  begin
    frmProducers := TfrmProducers.Create(Self);
    frmProducers.ViewProducers.ProducersGroup := DM.ProducersGroup;
  end;

  DM.ProducersGroup.ReOpen;
  frmProducers.Show;
end;

procedure TfrmMain.actShowParametersExecute(Sender: TObject);
begin
  if frmParameters = nil then
  begin
    frmParameters := TfrmParameters.Create(Self);
    frmParameters.ViewParameters.ParametersGroup := DM.ParametersGroup;
    DM.ParametersGroup.ReOpen;
  end;

  frmParameters.Show;

end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  // Отписываемся от всех событий
  FreeAndNil(FEventList);
end;

procedure TfrmMain.btnFocusRootClick(Sender: TObject);
begin
  DM.qTreeList.LocateToRoot;
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
  ProductsFrame.ViewProducts.CheckAndSaveChanges;
  ProductsFrame.ViewProductsSearch.CheckAndSaveChanges;
  ComponentsFrame.ViewComponents.CheckAndSaveChanges;
end;

procedure TfrmMain.DoBeforeParametricTableFormClose(Sender: TObject);
begin
  // отвязываем данные к представлению
  frmParametricTable.ViewParametricTable.ComponentsExGroup := nil;

  // предупреждаем, что нам больше не требуются данные этого запроса
  DM.ComponentsExGroup.DecClient;
  frmParametricTable := nil;
end;

procedure TfrmMain.DoOnComponentLocate(Sender: TObject);
var
  l: TList<String>;
begin
  // Массив с теми наименованиями, которые мы собираемся искать на складе
  Assert(Sender <> nil);
  l := Sender as TList<String>;
  Assert(l.Count > 0);

  DM.qProductsSearch.Search(l);

  // Переключаемся на вкладку склады
  cxpcLeft.ActivePage := cxtsStorehouses;
  // Переключаемся на вкладку поиск на складе
  ProductsFrame.cxpcStorehouse.ActivePage := ProductsFrame.tsStorehouseSearch;

  BringToFront;
  ProductsFrame.ViewProductsSearch.FocusValueColumn;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if DM.HaveAnyChanges then
  begin
    case TDialog.Create.SaveDataDialog of
      IDYES:
        DM.SaveAll;
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
  cxpcRight.Properties.HideTabs := True;
  cxpcLeft.ActivePage := cxtsComponents;
  ComponentsFrame.cxpcComponents.ActivePage := ComponentsFrame.cxtsCategory;

  // Создаём модуль репозитория
  if DMRepository = nil then
    DMRepository := TDMRepository.Create(Self);

  Assert(not DMRepository.dbConnection.Connected);

  // Сами создаём модуль данных
  DM := TDM.Create(Self);

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
        DM.CreateOrOpenDataBase;
      except
        on e: Exception do
        begin
          TDialog.Create.ErrorMessageDialog(e.Message);
          // Снова предлагаем выбрать папку с БД

          OK := ShowSettingsEditor = mrOk;
        end;
      end;

    until (DMRepository.dbConnection.Connected) or (not OK);

    if OK then
    begin
      // Подписываемся чтобы искать компонент на складах
      TNotifyEventWrap.Create(DM.ComponentsExGroup.qComponentsEx.OnLocate,
        DoOnComponentLocate);

      // Подписываемся чтобы искать компонент в параметрической таблице
      TNotifyEventWrap.Create(DM.StoreHouseGroup.qProducts.OnLocate,
        DoOnProductLocate);
      TNotifyEventWrap.Create(DM.qProductsSearch.OnLocate, DoOnProductLocate);

      // Привязываем представления к данным
      ComponentsFrame.ViewComponents.ComponentsGroup := DM.ComponentsGroup;

      // Подписываемся на событие о отображении параметрической таблицы
      TNotifyEventWrap.Create
        (ComponentsFrame.ViewComponents.OnShowParametricTableEvent,
        DoOnShowParametricTable, FEventList);

      ComponentsFrame.ViewComponentsSearch.ComponentsSearchGroup :=
        DM.ComponentsSearchGroup;

      // Параметры в виде категорий
      // FrameCategoryParameters.ViewParametersForCategories.
      // ParametersForCategoriesGroup := DM.ParametersForCategoriesGroup;

      // Параметры в виде списка
      ComponentsFrame.ViewCategoryParameters.QueryCategoryParameters :=
        DM.qCategoryParameters;

      ComponentsFrame.ViewParametricTable.ComponentsExGroup :=
        DM.ComponentsExGroup;

      // Привязываем список складов к данным
      tvStorehouseList.DataController.DataSource :=
        DM.StoreHouseGroup.qStoreHouseList.DataSource;
      clStorehouseListTitle.ApplyBestFit();
      // Привязываем информацию о складе к данным
      ProductsFrame.ViewStorehouseInfo.QueryStoreHouseList :=
        DM.StoreHouseGroup.qStoreHouseList;
      // Привязываем текущий склад к данным
      ProductsFrame.ViewProducts.QueryProducts := DM.StoreHouseGroup.qProducts;
      // Привязываем поиск по складам к данным
      ProductsFrame.ViewProductsSearch.QueryProductsSearch := DM.qProductsSearch;

      // ViewStoreHouse.StoreHouseGroup := DM.StoreHouseGroup;
      // ViewStoreHouse.QueryProductsSearch := DM.qProductsSearch;

      // привязываем дерево катогорий к данным
      dbtlCategories.DataController.DataSource := DM.qTreeList.DataSource;

      // Привязываем подкатегории к данным (функциональная группа)
      ComponentsFrame.tvFunctionalGroup.DataController.DataSource :=
        DM.qChildCategories.DataSource;

      FOnProductCategoriesChange := TNotifyEventWrap.Create
        (DM.qTreeList.AfterScroll, DoOnProductCategoriesChange, FEventList);

      // Искусственно вызываем событие
      DoOnProductCategoriesChange(nil);

    end;
  end;

  if not OK then
  begin
    Application.ShowMainForm := False;
    Application.Terminate; // завершаем работу приложения
  end;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  if (Enabled) and (DMRepository.dbConnection.Connected) and
    (dbtlCategories.FocusedNode <> nil) then
    dbtlCategories.FocusedNode.Expand(False);
end;

procedure TfrmMain.DoOnProductCategoriesChange(Sender: TObject);
begin
  ComponentsFrame.cxtsCategoryComponents.Enabled :=
    not DM.qTreeList.IsRootFocused;

  Assert(DM.qTreeList.PKValue > 0);
  FCategoryPath := FQuerySearchCategoriesPath.GetFullPath(DM.qTreeList.PKValue);

  UpdateCaption;

end;

procedure TfrmMain.DoOnProductLocate(Sender: TObject);
var
  LO: TLocateObject;
begin
  LO := (Sender as TLocateObject);

  if not DM.qTreeList.LocateByPK(LO.IDCategory) then
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

function TfrmMain.GetLevel(ANode: TcxTreeListNode): Integer;
begin
  Result := 1;
  if ANode.Parent <> nil then
    Result := Result + GetLevel(ANode.Parent);
end;

procedure TfrmMain.ShowParametricTable;
var
  ACategoryPath: string;
  rc: Integer;
begin
  if frmParametricTable = nil then
  begin

    // Нам надо узнать, есть-ли у текущей категории подкатегории
    rc := TSearchSubCategories.Search(DM.qTreeList.PKValue);
    // Если у нашей категории есть подкатегории
    if rc > 0 then
      ACategoryPath := DM.qTreeList.value.AsString
    else
    begin
      // Если в цепочке категорий мы последнее звено
      ACategoryPath := FQuerySearchCategoriesPath.GetLastTreeNodes
        (DM.qTreeList.PKValue, 2, '-');
    end;

    // Создаём окно с параметрической таблицей
    frmParametricTable := TfrmParametricTable.Create(Self);
    frmParametricTable.CategoryPath := ACategoryPath;

    // Подписываемся на событие перед закрытием окна
    TNotifyEventWrap.Create(frmParametricTable.BeforeClose,
      DoBeforeParametricTableFormClose, FEventList);

    // Привязываем данные к представлению
    frmParametricTable.ViewParametricTable.ComponentsExGroup :=
      DM.ComponentsExGroup;

    // предупреждаем, что нам потребуются данные этого запроса
    DM.ComponentsExGroup.AddClient;
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

procedure TfrmMain.dbtlCategoriesCanFocusNode(Sender: TcxCustomTreeList;
ANode: TcxTreeListNode; var Allow: Boolean);
begin
  Allow := (ComponentsFrame.ViewComponents.CheckAndSaveChanges <> IDCancel) and
    (ComponentsFrame.ViewCategoryParameters.CheckAndSaveChanges <> IDCancel);
end;

procedure TfrmMain.dbtlCategoriesClick(Sender: TObject);
begin
  dbtlCategories.ApplyBestFit;
end;

procedure TfrmMain.dbtlCategoriesCollapsed(Sender: TcxCustomTreeList;
ANode: TcxTreeListNode);
begin
  dbtlCategories.ApplyBestFit;
  /// todo: придумать как обработать правильно
  dbtlCategories.OptionsView.ScrollBars := ssBoth;
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

procedure TfrmMain.dbtlCategoriesExpanded(Sender: TcxCustomTreeList;
ANode: TcxTreeListNode);
var
  vOldWidth: Integer;
begin
  vOldWidth := dbtlCategories.Columns[0].DisplayWidth;
  dbtlCategories.Columns[0].ApplyBestFit;
  // tlLeftControl.ApplyBestFit;
  if dbtlCategories.Columns[0].DisplayWidth < vOldWidth then
  // при раскрытии убедиться что ширина не станет меньше чем была
  begin
    Application.ProcessMessages;
    dbtlCategories.Columns[0].DisplayWidth := vOldWidth;
    dbtlCategories.Columns[0].Width := vOldWidth;
    dbtlCategories.Columns[0].MinWidth := vOldWidth;
  end;
  dbtlCategories.OptionsView.ScrollBars := ssBoth;
end;

procedure TfrmMain.tlLeftControlMouseDown(Sender: TObject; Button: TMouseButton;
Shift: TShiftState; X, Y: Integer);
begin
  pmLeftTreeList.Items[1].Enabled := True;
  pmLeftTreeList.Items[2].Enabled := True;
  with TcxTreeList(Sender) do
  begin
    OptionsData.Editing := True;
    HitTest.ReCalculate(Point(X, Y));

    if HitTest.HitAtBackground then
    begin
      DM.qTreeList.LocateToRoot;
      // datamoduleMain.IsCurrentlyBusy := True;
      // datamoduleMain.qTreeList.Locate('Id', 1, []);
      // datamoduleMain.IsCurrentlyBusy := false;
      // datamoduleMain.qTreeList.AfterScroll(datamoduleMain.qTreeList);

      pmLeftTreeList.Items[1].Enabled := False;
      pmLeftTreeList.Items[2].Enabled := False;
      OptionsData.Editing := False;
    end;

    if HitTest.HitAtNode then
    begin
      if DM.qTreeList.
        IsRootFocused { datamoduleMain.qTreeList.FieldByName('Id').AsInteger = 1 }
      then
      begin
        pmLeftTreeList.Items[1].Enabled := False;
        pmLeftTreeList.Items[2].Enabled := False;
        OptionsData.Editing := False;
      end;
    end;
  end;
end;

procedure TfrmMain.dbtlCategoriesStartDrag(Sender: TObject;
var DragObject: TDragObject);
begin
  FSelectedId := dbtlCategories.FocusedNode.Values[1];
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

procedure TfrmMain.UpdateCaption;
var
  S: string;
begin
  if (DM <> nil) and (DM.qTreeList.FDQuery.RecordCount > 0) then
  begin
    if not DM.qTreeList.IsRootFocused and not FCategoryPath.IsEmpty then
    begin
      S := MinimizeName(FCategoryPath, Canvas, Width - 200);
      S := S.Trim(['\']).Replace('\', '-');

    end
    else
      S := DM.qTreeList.value.AsString;

    Caption := Format('%s - %s', [sMainFormCaption, S]);
  end;
end;

procedure TfrmMain.ViewComponentsactOpenDatasheetExecute(Sender: TObject);
begin
  ComponentsFrame.ViewComponents.actOpenDatasheetExecute(Sender);
end;

end.
