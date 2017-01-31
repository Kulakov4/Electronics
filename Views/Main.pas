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
  SearchCategoriesPathQuery;

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
    pnlMain: TPanel;
    pnlList: TPanel;
    cxspltrMain: TcxSplitter;
    cxpgcntrlMain: TcxPageControl;
    tsFunctionalGroup: TcxTabSheet;
    tsComponents: TcxTabSheet;
    cxtsDatabase: TcxTabSheet;
    pmLeftTreeList: TPopupMenu;
    mniAddRecord: TMenuItem;
    mniRenameRecord: TMenuItem;
    mniDeleteRecord: TMenuItem;
    tvFunctionalGroup: TcxGridDBTableView;
    glFunctionalGroup: TcxGridLevel;
    cxgrdFunctionalGroup: TcxGrid;
    dxbrMainBar2: TdxBar;
    dxbrbtnSettings: TdxBarButton;
    clFunctionalGroupId: TcxGridDBColumn;
    clFunctionalGroupValue: TcxGridDBColumn;
    clFunctionalGroupExternalId: TcxGridDBColumn;
    clFunctionalGroupOrder: TcxGridDBColumn;
    clFunctionalGroupParentExternalId: TcxGridDBColumn;
    cxPageControl1: TcxPageControl;
    tsStructure: TcxTabSheet;
    tsStorehouse: TcxTabSheet;
    ViewStoreHouse: TViewStoreHouse;
    tlLeftControl: TcxDBTreeList;
    clValue: TcxDBTreeListColumn;
    clId: TcxDBTreeListColumn;
    clParentId: TcxDBTreeListColumn;
    clOrder: TcxDBTreeListColumn;
    ActionList: TActionList;
    actShowManufacturers: TAction;
    ViewComponents: TViewComponents;
    cxtsParametersForCategories: TcxTabSheet;
    ViewParametersForCategories: TViewParametersForCategories;
    cxtsParametricTable: TcxTabSheet;
    ViewParametricTable: TViewParametricTable;
    ViewComponentsSearch: TViewComponentsSearch;
    actShowDescriptions: TAction;
    actShowParameters: TAction;
    actShowBodyTypes: TAction;
    actShowBodyTypes2: TAction;
    dxBarButton2: TdxBarButton;
    actShowBodyTypes3: TAction;
    actReport: TAction;
    dxbrb: TdxBarButton;
    actSelectDataBasePath: TAction;
    actSaveAll: TAction;
    dxBarButton4: TdxBarButton;
    actExit: TAction;
    actAutoBinding: TAction;
    dxBarButton1: TdxBarButton;
    actDeleteTreeNode: TAction;
    actRenameTreeNode: TAction;
    actAddTreeNode: TAction;
    dxBarSubItem2: TdxBarSubItem;
    actLoadBodyTypes: TAction;
    dxBarButton3: TdxBarButton;
    actLoadParametricTable: TAction;
    dxBarButton5: TdxBarButton;
    dxBarSubItem3: TdxBarSubItem;
    dxBarSubItem4: TdxBarSubItem;
    actLoadFromExcelFolder: TAction;
    dxBarButton6: TdxBarButton;
    procedure actAddTreeNodeExecute(Sender: TObject);
    procedure actAutoBindingExecute(Sender: TObject);
    procedure actDeleteTreeNodeExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actLoadBodyTypesExecute(Sender: TObject);
    procedure actLoadFromExcelFolderExecute(Sender: TObject);
    procedure actLoadParametricTableExecute(Sender: TObject);
    procedure actRenameTreeNodeExecute(Sender: TObject);
    procedure actReportExecute(Sender: TObject);
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
    procedure tlLeftControlDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure tlLeftControlDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure tlLeftControlStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure btnFocusRootClick(Sender: TObject);
    procedure cxPageControl1Change(Sender: TObject);
    procedure cxpgcntrlMainPageChanging(Sender: TObject; NewPage: TcxTabSheet;
      var AllowChange: Boolean);
    procedure cxtsParametricTableShow(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tlLeftControlClick(Sender: TObject);
    procedure tlLeftControlCollapsed(Sender: TcxCustomTreeList;
      ANode: TcxTreeListNode);
    procedure tlLeftControlExpanded(Sender: TcxCustomTreeList;
      ANode: TcxTreeListNode);
    procedure tlLeftControlMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure tlLeftControlCanFocusNode(Sender: TcxCustomTreeList;
      ANode: TcxTreeListNode; var Allow: Boolean);
    procedure tsComponentsShow(Sender: TObject);
  private
    F1: Boolean;
    FCategoryPath: string;
    FEventList: TObjectList;
    FOnProductCategoriesChange: TNotifyEventWrap;
    FQuerySearchCategoriesPath: TQuerySearchCategoriesPath;
    FSelectedId: Integer;
    procedure DoBeforeParametricTableFormClose(Sender: TObject);
    procedure DoOnLoadBodyTypes(Sender: TObject);
    procedure DoOnProductCategoriesChange(Sender: TObject);
    procedure DoOnShowParametricTable(Sender: TObject);
    procedure DoOnLoadParametricTable(Sender: TObject);
    function GetLevel(ANode: TcxTreeListNode): Integer;
    function ShowSettingsEditor: Integer;
    procedure UpdateCaption;
    { Private declarations }
  protected
    function LoadFromDirectory(ADocFieldInfos: TList<TDocFieldInfo>;
      const AIDCategory: Integer): Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    function CheckDataBasePath: Boolean;
    { Public declarations }
  end;

type
  TParametricErrorTable = class(TCustomErrorTable)
  private
    function GetDescription: TField;
    function GetError: TField;
    function GetParameterName: TField;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AddErrorMessage(const AParameterName: string; AMessage: string);
    property Description: TField read GetDescription;
    property Error: TField read GetError;
    property ParameterName: TField read GetParameterName;
  end;

var
  frmMain: TfrmMain;

implementation

uses
  Winapi.ShellAPI, RepositoryDataModule,
  DialogUnit, DescriptionsForm, ParametersForm, ManufacturersForm,
  SettingsController, BodyTypesTreeForm, BodyTypesGridQuery, ReportsForm,
  ReportQuery, RecommendedReplacementExcelDataModule,
  ComponentBodyTypesExcelDataModule, ParametricTableForm,
  BodyTypesMasterDetailUnit, DescriptionsMasterDetailUnit,
  ParametersMasterDetailUnit, ComponentsExMasterDetailUnit,
  ComponentsMasterDetailUnit, ComponentsSearchMasterDetailUnit,
  ParametersForCategoriesMasterDetailUnit, StoreHouseMasterDetailUnit,
  BodyTypesForm, ProjectConst, PathSettingsForm, AutoBindingForm,
  ImportErrorForm, SplashXP, ComponentsBaseMasterDetailUnit, ErrorForm,
  cxGridDBBandedTableView, System.IOUtils, FieldInfoUnit,
  SearchMainParameterQuery, ImportProcessForm, SearchDaughterParameterQuery,
  ProgressInfo, ProgressBarForm, ExcelFileLoader, BodyTypesQuery, Vcl.FileCtrl,
  SearchDescriptionsQuery, SearchSubCategoriesQuery,
  SearchComponentCategoryQuery2;

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
      DM.qTreeList.AddChildCategory(value, GetLevel(tlLeftControl.FocusedNode));
    finally
      DM.qTreeList.FDQuery.EnableControls;
    end;
  end;
end;

procedure TfrmMain.actAutoBindingExecute(Sender: TObject);
var
  frmAutoBinding: TfrmAutoBinding;
  MR: Integer;
begin
  frmAutoBinding := TfrmAutoBinding.Create(Self);
  try
    MR := frmAutoBinding.ShowModal;
    case MR of
      mrAll:
        LoadFromDirectory(frmAutoBinding.Docs, 1);
      mrOk:
        LoadFromDirectory(frmAutoBinding.Docs, DM.qTreeList.PKValue);
    end;
  finally
    FreeAndNil(frmAutoBinding);
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
    TExcelData.Load(AFileName, AComponentBodyTypesExcelDM);

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
      TExcelData.Save(AComponentBodyTypesExcelDM.ExcelTable,
        procedure(AExcelTable: TCustomExcelTable)
        begin
          ViewComponents.ComponentsMasterDetail.LoadBodyList
            (AComponentBodyTypesExcelDM.ExcelTable);
        end);
    end;

  finally
    FreeAndNil(AComponentBodyTypesExcelDM);
  end;

  // Обновляем запрос использующийся для поиска в справочнике корпусов
  DM.qBodyTypes.RefreshQuery;

  ViewComponents.ComponentsMasterDetail.ReOpen;
end;

procedure TfrmMain.actLoadFromExcelFolderExecute(Sender: TObject);
begin
  ViewComponents.actLoadFromExcelFolder.Execute;
end;

procedure TfrmMain.actLoadParametricTableExecute(Sender: TObject);
var
  AExcelDM: TExcelDM;
  AFieldName: String;
  AFieldsInfo: TList<TFieldInfo>;
  AFileName: string;
  AfrmImportProcess: TfrmImportProcess;
  AParameterExcelDM2: TParameterExcelDM2;
  AParametricErrorTable: TParametricErrorTable;
  // AQuerySearchComponentCategory2: TQuerySearchComponentCategory2;
  AQuerySearchDaughterParameter: TQuerySearchDaughterParameter;
  AQuerySearchMainParameter: TQuerySearchMainParameter;
  ARootTreeNode: TStringTreeNode;
  AStringTreeNode: TStringTreeNode;
  AStringTreeNode2: TStringTreeNode;
  I: Integer;
  nf: Boolean;
  OK: Boolean;
  rc: Integer;
begin
  AFileName := TDialog.Create.OpenExcelFile
    (TSettings.Create.ParametricDataFolder);

  if AFileName.IsEmpty then
    Exit; // отказались от выбора файла

  // Сохраняем эту папку в настройках
  TSettings.Create.ParametricDataFolder := TPath.GetDirectoryName(AFileName);

  // Описания полей excel файла
  AFieldsInfo := TList<TFieldInfo>.Create;
  try
    AParametricErrorTable := TParametricErrorTable.Create(Self);
    try

      AExcelDM := TExcelDM.Create(Self);
      try
        // Загружаем описания полей Excel файла
        ARootTreeNode := AExcelDM.LoadExcelFileHeader(AFileName);
        AQuerySearchMainParameter := TQuerySearchMainParameter.Create(Self);
        AQuerySearchDaughterParameter :=
          TQuerySearchDaughterParameter.Create(Self);
        try
          I := 0;

          // Цикл по всем заголовкам таблицы
          for AStringTreeNode in ARootTreeNode.Childs do
          begin
            AFieldName := '';
            nf := AStringTreeNode.value.ToUpper = 'Part'.ToUpper;

            if not nf then
            begin
              // Нужно найти такой параметр
              rc := AQuerySearchMainParameter.Search(AStringTreeNode.value);
              if rc = 0 then
                AParametricErrorTable.AddErrorMessage(AStringTreeNode.value,
                  'Параметр не найден');
              if rc > 1 then
                AParametricErrorTable.AddErrorMessage(AStringTreeNode.value,
                  Format('Параметр найден %d раз', [rc]));

              // Если нашли ровно один параметр в справочнике
              if rc = 1 then
              begin

                if AStringTreeNode.Childs.Count > 0 then
                begin
                  for AStringTreeNode2 in AStringTreeNode.Childs do
                  begin
                    rc := AQuerySearchDaughterParameter.Search
                      (AStringTreeNode2.value,
                      AQuerySearchMainParameter.ID.AsInteger);
                    if rc > 1 then
                    begin
                      AParametricErrorTable.AddErrorMessage
                        (AStringTreeNode2.value,
                        Format('Подпараметр найден %d раз', [rc]));
                    end
                    else
                    begin
                      // Если такого дочернего параметра мы не нашли
                      if rc = 0 then
                      begin
                        AQuerySearchDaughterParameter.Append
                          (AStringTreeNode2.value);
                      end;
                      // Создаём описание поля связанного с подпараметром
                      AFieldName := TParameterExcelTable2.GetFieldNameByIDParam
                        (AQuerySearchDaughterParameter.ID.AsInteger)
                    end;
                  end;
                end
                else
                begin
                  // Если у нашего параметра нет дочерних параметров
                  // Создаём описание поля связанного с параметром
                  AFieldName := TParameterExcelTable2.GetFieldNameByIDParam
                    (AQuerySearchMainParameter.ID.AsInteger)
                end;
              end
              else
              begin
                nf := true;
              end;
            end;

            if nf then
            begin
              // Создаём описание поля не связанного с параметром
              AFieldName := Format('NotFoundParam_%d', [I]);
              Inc(I);
            end;

            AFieldsInfo.Add(TFieldInfo.Create(AFieldName));
          end;

        finally
          FreeAndNil(AQuerySearchMainParameter);
          FreeAndNil(AQuerySearchDaughterParameter);
        end;

      finally
        FreeAndNil(AExcelDM);
      end;

      if AFieldsInfo.Count = 0 then
      begin
        TDialog.Create.ParametricTableNotFound;
        Exit;
      end;

      OK := AParametricErrorTable.RecordCount = 0;
      if not OK then
      begin
        AfrmImportProcess := TfrmImportProcess.Create(Self);
        try
          AfrmImportProcess.Done := true;
          AfrmImportProcess.ErrorTable := AParametricErrorTable;
          // Показываем что мы собираемся привязывать
          OK := AfrmImportProcess.ShowModal = mrOk;
        finally
          FreeAndNil(AfrmImportProcess);
        end;

      end;
    finally
      FreeAndNil(AParametricErrorTable)
    end;

    if OK then
    begin
      AParameterExcelDM2 := TParameterExcelDM2.Create(Self, AFieldsInfo);
      try
        // Загружаем данные из Excel файла
        TExcelData.Load(AFileName, AParameterExcelDM2);

        // Если в ходе загрузки данных произошли ошибки (компонент не найден)
        if AParameterExcelDM2.ExcelTable.Errors.RecordCount > 0 then
        begin
          AfrmImportProcess := TfrmImportProcess.Create(Self);
          try
            AfrmImportProcess.Done := true;
            AfrmImportProcess.ErrorTable :=
              AParameterExcelDM2.ExcelTable.Errors;
            // Показываем ошибки
            OK := AfrmImportProcess.ShowModal = mrOk;
            AParameterExcelDM2.ExcelTable.ExcludeErrors(etError);
          finally
            FreeAndNil(AfrmImportProcess);
          end;

        end;

        if OK then
        begin
          // Сохраняем данные в БД
          TExcelData.Save(AParameterExcelDM2.ExcelTable,
            procedure(AExcelTable: TCustomExcelTable)
            begin
              TParameterValues.LoadParameterValues
                (AParameterExcelDM2.ExcelTable, true);
            end);
        end;

      finally
        FreeAndNil(AParameterExcelDM2);
      end;
    end;
  finally
    FreeAndNil(AFieldsInfo);
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

procedure TfrmMain.actReportExecute(Sender: TObject);
var
  AQueryReports: TQueryReports;
  frmReports: TfrmReports;
begin
  frmReports := TfrmReports.Create(Self);
  try
    AQueryReports := TQueryReports.Create(Self);
    try
      AQueryReports.RefreshQuery;

      frmReports.ViewReports.QueryReports := AQueryReports;

      frmReports.ShowModal;
    finally
      FreeAndNil(AQueryReports);
    end;
  finally
    FreeAndNil(frmReports);
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
      tlLeftControl.BeginUpdate;
      try
        DM.CreateOrOpenDataBase;
        // Искусственно вызываем событие
        DoOnProductCategoriesChange(nil);
      finally
        try
          tlLeftControl.EndUpdate;
          tlLeftControl.FocusedNode.Expand(False);
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
    frmBodyTypes.ViewBodyTypes.BodyTypesMasterDetail :=
      DM.BodyTypesMasterDetail;
  end;

  DM.BodyTypesMasterDetail.ReOpen;
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
    frmDescriptions := TfrmDescriptions.Create(Self);
    frmDescriptions.ViewDescriptions.DescriptionsMasterDetail :=
      DM.DescriptionsMasterDetail;
    DM.DescriptionsMasterDetail.ReOpen;
  end;

  frmDescriptions.Show;

end;

procedure TfrmMain.actShowManufacturersExecute(Sender: TObject);
begin
  if frmManufacturers = nil then
  begin
    frmManufacturers := TfrmManufacturers.Create(Self);
    frmManufacturers.ViewManufacturers.QueryManufacturers := DM.qManufacturers2;
  end;

  DM.qManufacturers2.RefreshQuery;
  frmManufacturers.Show;
end;

procedure TfrmMain.actShowParametersExecute(Sender: TObject);
begin
  if frmParameters = nil then
  begin
    frmParameters := TfrmParameters.Create(Self);
    frmParameters.ViewParameters.ParametersMasterDetail :=
      DM.ParametersMasterDetail2;
    DM.ParametersMasterDetail2.ReOpen;
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
      Break; // путь ОК больше попыток не требуется
  end;

  // Дав три попытки проверяем что всё ок
  Result := (databasePath <> '') and (TDirectory.Exists(databasePath));
end;

procedure TfrmMain.cxPageControl1Change(Sender: TObject);
begin
  ViewStoreHouse.ViewProducts.CheckAndSaveChanges;
  ViewStoreHouse.ViewProductsSearch.CheckAndSaveChanges;
  ViewComponents.CheckAndSaveChanges;
end;

procedure TfrmMain.cxpgcntrlMainPageChanging(Sender: TObject;
NewPage: TcxTabSheet; var AllowChange: Boolean);
begin
  if DM = nil then
    Exit;

  // если переходим на вкладку "Содержимое базы данных"
  if (cxpgcntrlMain.ActivePage <> cxtsDatabase) and (NewPage = cxtsDatabase)
  then
  begin
    ViewComponentsSearch.ApplyBestFitEx;
  end;

  // если переходим на вкладку "Параметрическая таблица"
  if (cxpgcntrlMain.ActivePage <> cxtsParametricTable) and
    (NewPage = cxtsParametricTable) then
  begin
    // сообщаем о том, что этот запрос понадобится и его надо разблокировать
    DM.ComponentsExMasterDetail.AddClient;
  end;

  if (cxpgcntrlMain.ActivePage = cxtsParametricTable) and
    (NewPage <> cxtsParametricTable) then
  begin
    DM.ComponentsExMasterDetail.DecClient;
  end;

end;

procedure TfrmMain.cxtsParametricTableShow(Sender: TObject);
begin
  // ViewParametricTable.MyApplyBestFit;
end;

procedure TfrmMain.DoBeforeParametricTableFormClose(Sender: TObject);
begin
  // отвязываем данные к представлению
  frmParametricTable.ViewParametricTable.ComponentsBaseMasterDetail := nil;

  // предупреждаем, что нам больше не требуются данные этого запроса
  DM.ComponentsExMasterDetail.DecClient;
  frmParametricTable := nil;
end;

procedure TfrmMain.DoOnLoadBodyTypes(Sender: TObject);
begin
  actLoadBodyTypes.Execute;
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
  cxpgcntrlMain.ActivePageIndex := 0;
  cxPageControl1.ActivePageIndex := 0;

  // Создаём модуль репозитория
  if DMRepository = nil then
    DMRepository := TDMRepository.Create(Self);
  // Сами создаём модуль данных
  // datamoduleMain := TdatamoduleMain.Create(Self);
  DM := TDM.Create(Self);

  inherited;

  // DM.ComponentsExMasterDetail.qComponentsEx.Name := 'qComponentsEx';
  // DM.ComponentsExMasterDetail.qComponentsEx.Lock := True;
  // // Блокируем обновление
  // DM.ComponentsExMasterDetail.qComponentsDetailEx.Lock := True;
  // // Блокируем обновление

  Self.WindowState := wsNormal;

  // Подписываемся на события
  FEventList := TObjectList.Create;

  // Проверяем что путь до базы данных корректный
  OK := CheckDataBasePath;
  if OK then
  begin
    // Создаём или открываем базу данных
    try
      DM.CreateOrOpenDataBase;
    except
      on e: Exception do
        TDialog.Create.ErrorMessageDialog(e.Message);
    end;
    OK := DMRepository.dbConnection.Connected;

    if OK then
    begin
      // Привязываем представления к данным
      ViewComponents.ComponentsMasterDetail := DM.ComponentsMasterDetail;

      // Подписываемся на событие о загрузке корпусных данных
      TNotifyEventWrap.Create(ViewComponents.OnLoadBodyTypesEvent,
        DoOnLoadBodyTypes, FEventList);
      // Подписываемся на событие о отображении параметрической таблицы
      TNotifyEventWrap.Create(ViewComponents.OnShowParametricTableEvent,
        DoOnShowParametricTable, FEventList);
      // Подписываемся на событие о загрузке данных параметрической таблицы
      TNotifyEventWrap.Create(ViewComponents.OnLoadParametricTable,
        DoOnLoadParametricTable, FEventList);

      ViewComponentsSearch.ComponentsSearchMasterDetail :=
        DM.ComponentsSearchMasterDetail;

      ViewParametersForCategories.ParametersForCategoriesMasterDetail :=
        DM.ParametersForCategoriesMasterDetail;

      ViewParametricTable.ComponentsBaseMasterDetail :=
        DM.ComponentsExMasterDetail;

      ViewStoreHouse.StoreHouseMasterDetail := DM.StoreHouseMasterDetail;
      ViewStoreHouse.QueryProductsSearch := DM.qProductsSearch;

      // привязываем дерево катогорий к данным
      tlLeftControl.DataController.DataSource := DM.qTreeList.DataSource;

      // Привязываем подкатегории к данным (функциональная группа)
      tvFunctionalGroup.DataController.DataSource :=
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
    (tlLeftControl.FocusedNode <> nil) then
    tlLeftControl.FocusedNode.Expand(False);
end;

procedure TfrmMain.DoOnProductCategoriesChange(Sender: TObject);
begin
  tsComponents.Enabled := not DM.qTreeList.IsRootFocused;

  Assert(DM.qTreeList.PKValue > 0);
  FCategoryPath := FQuerySearchCategoriesPath.GetFullPath(DM.qTreeList.PKValue);

  UpdateCaption;

end;

procedure TfrmMain.DoOnShowParametricTable(Sender: TObject);
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
    frmParametricTable.ViewParametricTable.ComponentsBaseMasterDetail :=
      DM.ComponentsExMasterDetail;

    // предупреждаем, что нам потребуются данные этого запроса
    DM.ComponentsExMasterDetail.AddClient;
  end;

  frmParametricTable.Show;

end;

procedure TfrmMain.DoOnLoadParametricTable(Sender: TObject);
begin
  actLoadParametricTable.Execute;
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

function TfrmMain.LoadFromDirectory(ADocFieldInfos: TList<TDocFieldInfo>;
const AIDCategory: Integer): Boolean;
var
  AAbsentDocTable: TAbsentDocTable;
  AcxGridDBBandedColumn: TcxGridDBBandedColumn;
  AfrmError: TfrmError;
  AfrmImportError: TfrmImportError;
  ALoadDocTable: TLoadDocTable;
  AQuerySearchDescriptions: TQuerySearchDescriptions;
begin
  Result := False;

  // Привязываем компоненты к кратким описаниям
  AQuerySearchDescriptions := TQuerySearchDescriptions.Create(Self);
  try
    AQuerySearchDescriptions.FDQuery.Open;
    // Если после исключения ошибок осталось что привязывать
    if AQuerySearchDescriptions.FDQuery.RecordCount > 0 then
    begin
      AQuerySearchDescriptions.Process(
        procedure
        begin
          AQuerySearchDescriptions.UpdateComponentDescriptions
        end, 'Выполняем привязку кратких описаний');
    end;
  finally
    FreeAndNil(AQuerySearchDescriptions);
  end;

  // Просим создать привязки между файлами и компонентами
  ALoadDocTable := ViewComponents.ComponentsMasterDetail.LoadDocFiles
    (ADocFieldInfos, AIDCategory);
  try
    // Если есть что привязывать
    if ALoadDocTable.RecordCount > 0 then
    begin
      AfrmImportError := TfrmImportError.Create(Self);
      try
        AfrmImportError.Caption := 'Ошибки привязки файлов';
        AfrmImportError.ErrorTable := ALoadDocTable;
        // Показываем что мы собираемся привязывать
        if AfrmImportError.ShowModal = mrOk then
        begin
          // Если выбрали "Пропустить существующие файлы"
          if AfrmImportError.ContinueType = ctSkip then
            ALoadDocTable.SkipErrorAndWarrings;

          if AfrmImportError.ContinueType = ctAll then
            ALoadDocTable.SkipError;

          // Если после исключения ошибок осталось что привязывать
          if ALoadDocTable.RecordCount > 0 then
          begin
            ALoadDocTable.Process(
              procedure
              begin
                ViewComponents.ComponentsMasterDetail.LinkToDocFiles
                  (ALoadDocTable)
              end, 'Выполняем привязку');

            // Выполняем привязку
            // ViewComponents.ComponentsMasterDetail.LinkToDocFiles
            // (ALoadDocTable);
            Result := true;
          end;
        end;
      finally
        FreeAndNil(AfrmImportError);
      end;

    end
    else
    begin
      TDialog.Create.ComponentsDocFilesNotFound;
    end;
  finally
    FreeAndNil(ALoadDocTable);
  end;

  // Проверяем на отсутсвующие файлы
  AAbsentDocTable := ViewComponents.ComponentsMasterDetail.CheckAbsentDocFiles
    (ADocFieldInfos, AIDCategory);
  try
    // Если есть компоненты для которых отсутствует документация
    if AAbsentDocTable.RecordCount > 0 then
    begin
      AfrmError := TfrmError.Create(Self);
      try
        AfrmError.ErrorTable := AAbsentDocTable;
        AcxGridDBBandedColumn := AfrmError.ViewImportError.MainView.
          GetColumnByFieldName(AAbsentDocTable.Folder.FieldName);
        Assert(AcxGridDBBandedColumn <> nil);
        AcxGridDBBandedColumn.GroupIndex := 0;
        AcxGridDBBandedColumn.Visible := False;
        // Показываем ошибки
        AfrmError.ShowModal;
      finally
        FreeAndNil(AfrmError);
      end;
    end;
  finally
    FreeAndNil(ALoadDocTable);
  end;

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

procedure TfrmMain.tlLeftControlCanFocusNode(Sender: TcxCustomTreeList;
ANode: TcxTreeListNode; var Allow: Boolean);
begin
  Allow := ViewComponents.CheckAndSaveChanges <> IDCancel;
end;

procedure TfrmMain.tlLeftControlClick(Sender: TObject);
begin
  tlLeftControl.ApplyBestFit;
end;

procedure TfrmMain.tlLeftControlCollapsed(Sender: TcxCustomTreeList;
ANode: TcxTreeListNode);
begin
  tlLeftControl.ApplyBestFit;
  /// todo: придумать как обработать правильно
  tlLeftControl.OptionsView.ScrollBars := ssBoth;
end;

procedure TfrmMain.tlLeftControlDragDrop(Sender, Source: TObject;
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

procedure TfrmMain.tlLeftControlDragOver(Sender, Source: TObject; X, Y: Integer;
State: TDragState; var Accept: Boolean);
begin
  Accept := true;
end;

procedure TfrmMain.tlLeftControlExpanded(Sender: TcxCustomTreeList;
ANode: TcxTreeListNode);
var
  vOldWidth: Integer;
begin
  vOldWidth := tlLeftControl.Columns[0].DisplayWidth;
  tlLeftControl.Columns[0].ApplyBestFit;
  // tlLeftControl.ApplyBestFit;
  if tlLeftControl.Columns[0].DisplayWidth < vOldWidth then
  // при раскрытии убедиться что ширина не станет меньше чем была
  begin
    Application.ProcessMessages;
    tlLeftControl.Columns[0].DisplayWidth := vOldWidth;
    tlLeftControl.Columns[0].Width := vOldWidth;
    tlLeftControl.Columns[0].MinWidth := vOldWidth;
  end;
  tlLeftControl.OptionsView.ScrollBars := ssBoth;
end;

procedure TfrmMain.tlLeftControlMouseDown(Sender: TObject; Button: TMouseButton;
Shift: TShiftState; X, Y: Integer);
begin
  pmLeftTreeList.Items[1].Enabled := true;
  pmLeftTreeList.Items[2].Enabled := true;
  with TcxTreeList(Sender) do
  begin
    OptionsData.Editing := true;
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

procedure TfrmMain.tlLeftControlStartDrag(Sender: TObject;
var DragObject: TDragObject);
begin
  FSelectedId := tlLeftControl.FocusedNode.Values[1];
end;

procedure TfrmMain.tsComponentsShow(Sender: TObject);
begin
  if Not F1 then
  begin
    ViewComponents.PostApplyBestFit;
    F1 := true;
  end;
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

constructor TParametricErrorTable.Create(AOwner: TComponent);
begin
  inherited;
  FieldDefs.Add('ParameterName', ftString, 100);
  FieldDefs.Add('Error', ftString, 50);
  FieldDefs.Add('Description', ftString, 150);
  CreateDataSet;

  Open;

  ParameterName.DisplayLabel := 'Параметр';
  Description.DisplayLabel := 'Описание';
  Error.DisplayLabel := 'Вид ошибки';
end;

function TParametricErrorTable.GetDescription: TField;
begin
  Result := FieldByName('Description');
end;

function TParametricErrorTable.GetError: TField;
begin
  Result := FieldByName('Error');
end;

function TParametricErrorTable.GetParameterName: TField;
begin
  Result := FieldByName('ParameterName');
end;

procedure TParametricErrorTable.AddErrorMessage(const AParameterName: string;
AMessage: string);
begin
  Assert(Active);

  if not(State in [dsEdit, dsInsert]) then
    Append;

  ParameterName.AsString := AParameterName;
  Error.AsString := ErrorMessage;
  Description.AsString := AMessage;
  Post;
end;

end.
