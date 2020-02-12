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
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDeactivate(Sender: TObject);
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
    FViewEventList: TObjectList;
    FViewParametricTable: TViewParametricTable;
    FViewProducts: TViewProducts2;
    FViewProductsBasket: TViewProductsBasket;
    FViewProductsSearch: TViewProductsSearch2;
    FViewStoreHouse: TViewStoreHouse;
    FViewTreeList: TViewTreeList;
    FWriteProgress: TTotalProgress;
    procedure DoAfterAddBill(Sender: TObject);
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
    procedure DoOnStoreHouseListChange(Sender: TObject);
    procedure DoOnTotalReadProgress(ASender: TObject);
    procedure DoOnViewStoreHouseCanFocusRecord(Sender: TObject);
    function GetQueryMonitor: TQueryMonitor;
    function GetViewComponentsFocused: Boolean;
    procedure LoadDocFromExcelDocument;
    function LoadExcelFileHeader(const AFileName: String;
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
    procedure FocusViewComponents;
    procedure TryFocusViewComponents;
    property QueryMonitor: TQueryMonitor read GetQueryMonitor;
    property ViewComponentsFocused: Boolean read GetViewComponentsFocused;
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
  Vcl.FileCtrl, SearchDescriptionsQuery, TableWithProgress, GridViewForm2,
  TreeListQuery, AutoBindingDocForm, AutoBindingDescriptionForm,
  FireDAC.Comp.Client, AutoBinding, AllFamilyQuery, ProducersForm,
  ProductsBaseQuery, RecursiveTreeView,
  RecursiveTreeQuery, TreeExcelDataModule, BindDocUnit, DialogUnit2,
  LoadFromExcelFileHelper, SearchCategoryQuery, CustomErrorForm,
  ExtraChargeForm, ExceptionHelper, System.StrUtils, DataModule,
  FireDAC.Comp.DataSet, ComponentsGroupUnit2, ComponentsExcelDataModule,
  StrHelper, ParametricErrorTable, ParametricTableErrorForm, ErrorType,
  LoadParametricForm, VersionQuery, DataBaseUnit, LoadParametricData,
  LoadParametricTable, GridViewForm, CategoryGridView;

{$R *.dfm}

constructor TfrmMain.Create(AOwner: TComponent);
begin
  Application.HintHidePause := 10000;
  inherited Create(AOwner);
  FHintWindowEx := THintWindowEx.Create(Self);
  FQuerySearchCategoriesPath := TQuerySearchCategoriesPath.Create(Self);
  Application.ModalPopupMode := pmAuto;
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

  // ���� ���� �� ���� ������ �� ���������
  if AOldDataBasePath = ANewDataBasePath then
    Exit;

  cxpcMain.ActivePage := nil;
  cxpcComp2.ActivePage := nil;
  cxpcCompGroupRight.ActivePage := nil;
  cxpcWareHouse2.ActivePage := nil;

  // ������������ �� ���� ������� ������������
  FViewEventList.Clear;

  // ���������� ��� �������������
  if FViewComponents <> nil then
    FreeAndNil(FViewComponents);

  if FViewParametricTable <> nil then
    FreeAndNil(FViewParametricTable);

  if FViewTreeList <> nil then
    FreeAndNil(FViewTreeList);

  if FViewComponentsSearch <> nil then
    FreeAndNil(FViewComponentsSearch);

  if FViewStoreHouse <> nil then
    FreeAndNil(FViewStoreHouse);

  if FViewProducts <> nil then
    FreeAndNil(FViewProducts);

  if FViewProductsSearch <> nil then
    FreeAndNil(FViewProductsSearch);

  if not TDataBase.OpenDBConnection(DMRepository.dbConnection,
    TSettings.Create.databasePath, TSettings.Create.DBMigrationFolder,
    TPath.GetDirectoryName(Application.ExeName)) then
    Exit;

  Application.ProcessMessages;

  // ��������� ����������� ������ "��������� ��"
  DoOnHaveAnyChanges(nil);

  cxpcMain.ActivePage := cxtshComp;
  cxpcComp2.ActivePage := cxtshCompGroup;

  // ������������ �������� �������
  if TDM.Create.qTreeList.FDQuery.Active then
    DoOnProductCategoriesChange(nil);
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
  // ������������ �� ���� �������
  FreeAndNil(FEventList);
  FreeAndNil(FViewEventList);
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
  // ��������� ���� � �� �� ��������
  databasePath := TSettings.Create.databasePath;

  for I := 0 to 3 do
  begin
    // ���� ���� �� ���� ������ ������ ��� �� ������������
    if (databasePath = '') or (not TDirectory.Exists(databasePath)) then
    // ���� ���������� �� ����������
    begin
      MR := ShowSettingsEditor;
      Result := MR = mrOk;
      if not Result then
        Exit;

      // ����� ��������� ���� � �� �� ��������
      databasePath := TSettings.Create.databasePath;
    end
    else
      Break; // ������ ������� �� ���������
  end;

  // ��� ��� ������� ��������� ��� �� ��
  Result := (databasePath <> '') and (TDirectory.Exists(databasePath));
end;

procedure TfrmMain.cxpcCompGroupRightPageChanging(Sender: TObject;
  NewPage: TcxTabSheet; var AllowChange: Boolean);
var
  ADialogResult: Integer;
begin
  if not FLoadComplete then
    Exit;

  // ���� ������ �� ������� ���������
  if cxpcCompGroupRight.ActivePage = cxtsCategory then
  begin
    TDM.Create.qChildCategories.RemoveClient;
  end;

  // ���� ������ �� ������� ����������
  if cxpcCompGroupRight.ActivePage = cxtsCategoryComponents then
  begin
    // ���� ����� ��������� ���������
    if FViewComponents.actCommit.Enabled then
    begin
      ADialogResult := TDialog.Create.SaveDataDialog;
      case ADialogResult of
        idCancel:
          AllowChange := False;
        idyes:
          FViewComponents.actCommit.Execute;
        idno:
          FViewComponents.actCommit.Execute;
      end;
    end;

    if AllowChange then
      TDM.Create.ComponentsGroup.RemoveClient
    else
      Exit;
  end;

  // ���� ������ �� ������� ���������
  if cxpcCompGroupRight.ActivePage = cxtsCategoryParameters then
  begin
    // ���� ����� ��������� ���������
    if FViewCategoryParameters.actApplyUpdates.Enabled then
    begin
      ADialogResult := TDialog.Create.SaveDataDialog;
      case ADialogResult of
        idCancel:
          AllowChange := False;
        idyes:
          FViewCategoryParameters.actApplyUpdates.Execute;
        idno:
          FViewCategoryParameters.actCancelUpdates.Execute;
      end;
    end;

    if AllowChange then
      TDM.Create.CategoryParametersGroup.RemoveClient
    else
      Exit;
  end;

  // ���� ������ � ������� "��������������� �������"
  if (cxpcCompGroupRight.ActivePage = cxtsParametricTable) and
    (NewPage <> cxtsParametricTable) then
  begin
    if ViewParametricTable.actCommit.Enabled then
    begin
      ADialogResult := TDialog.Create.SaveDataDialog;
      case ADialogResult of
        idCancel:
          AllowChange := False;
        idyes:
          ViewParametricTable.actCommit.Execute;
        idno:
          ViewParametricTable.actCommit.Execute;
      end;
    end;

    if not AllowChange then
      Exit;

    TDM.Create.ComponentsExGroup.RemoveClient;
    if FViewParametricTable <> nil then
      ViewParametricTable.Lock;
  end;

  // ���� ��������� �� ������� ���������
  if NewPage = cxtsCategory then
  begin
    TDM.Create.qChildCategories.AddClient;

    if FViewChildCategories = nil then
    begin
      FViewChildCategories := TViewChildCategories.Create(Self);
      FViewChildCategories.Place(cxtsCategory);

      // ����������� ������������ � ������ (�������������� ������)
      ViewChildCategories.qChildCategories := TDM.Create.qChildCategories;
    end;
    ViewChildCategories.MainView.ApplyBestFit;
  end;

  // ���� ��������� �� ������� ����������
  if NewPage = cxtsCategoryComponents then
  begin
    TDM.Create.ComponentsGroup.AddClient;

    if FViewComponents = nil then
    begin
      FViewComponents := TViewComponents.Create(Self);
      FViewComponents.Place(cxtsCategoryComponents);

      // ����������� ������������� � ������
      ViewComponents.ComponentsGroup := TDM.Create.ComponentsGroup;

      // ������������� �� ������� � ����������� ��������������� �������
      TNotifyEventWrap.Create(ViewComponents.OnShowParametricTableEvent,
        DoOnShowParametricTable, FViewEventList);
    end;

    ViewComponents.TryApplyBestFit;
    ViewComponents.FocusTopLeftEx;
  end;

  // ���� ��������� �� ������� ���������
  if NewPage = cxtsCategoryParameters then
  begin
    TDM.Create.CategoryParametersGroup.AddClient;

    if FViewCategoryParameters = nil then
    begin
      FViewCategoryParameters := TViewCategoryParameters.Create(Self);
      FViewCategoryParameters.Place(cxtsCategoryParameters);

      // ��������� � ���� ������
      ViewCategoryParameters.CatParamsGroup :=
        TDM.Create.CategoryParametersGroup;
    end;
    ViewCategoryParameters.MyApplyBestFit;
    ViewCategoryParameters.FocusTopLeftEx;
  end;

  // ���� ��������� �� ������� "��������������� �������"
  if NewPage = cxtsParametricTable then
  begin
    // �������� � ���, ��� ���� ������ ����������� � ��� ���� ��������������
    TDM.Create.ComponentsExGroup.AddClient;

    if FViewParametricTable = nil then
    begin
      FViewParametricTable := TViewParametricTable.Create(Self);
      FViewParametricTable.Place(cxtsParametricTable);
      ViewParametricTable.ComponentsExGroup := TDM.Create.ComponentsExGroup;

      // ������������� ����� ������ ��������� �� �������
      TNotifyEventWrap.Create(TDM.Create.ComponentsExGroup.qComponentsEx.
        OnLocate, DoOnComponentLocate, FViewEventList);
    end
    else
      ViewParametricTable.Unlock;

    ViewParametricTable.FocusTopLeftEx;
  end;

end;

procedure TfrmMain.cxpcComp2PageChanging(Sender: TObject; NewPage: TcxTabSheet;
  var AllowChange: Boolean);
begin
  if not FLoadComplete then
    Exit;

  // ���� ��������� �� ������� "�� �������"
  if NewPage = cxtshCompGroup then
  begin
    TDM.Create.qTreeList.AddClient;
    TDM.Create.qTreeList.FDQuery.First;

    if FViewTreeList = nil then
    begin
      // ������ ����� � ������� ���������
      FViewTreeList := TViewTreeList.Create(Self);
      ViewTreeList.Parent := pnlCompGroupLeft;
      ViewTreeList.Align := alClient;
      ViewTreeList.qTreeList := TDM.Create.qTreeList;
      ViewTreeList.ExpandRoot;

      // ������������� ���������� �������
      ViewTreeList.cxDBTreeList.OnCanFocusNode := OnTreeListCanFocusNode;

      TNotifyEventWrap.Create(TDM.Create.qTreeList.W.AfterSmartRefresh,
        DoAfterTreeListSmartRefresh, FViewEventList);

      TNotifyEventWrap.Create(TDM.Create.qTreeList.W.AfterScrollM,
        DoOnProductCategoriesChange, FViewEventList);

      TNotifyEventWrap.Create(TDM.Create.qTreeList.W.AfterOpen,
        DoOnProductCategoriesChange, FViewEventList);
    end;

    if FcxpcCompGroupRightActivePage <> nil then
      cxpcCompGroupRight.ActivePage := FcxpcCompGroupRightActivePage
    else
      cxpcCompGroupRight.ActivePage := cxtsCategory;
  end;

  // ���� ������ �� ������� "�� �������"
  if cxpcComp2.ActivePage = cxtshCompGroup then
  begin
    TDM.Create.qTreeList.RemoveClient;
    FcxpcCompGroupRightActivePage := cxpcCompGroupRight.ActivePage;
    cxpcCompGroupRight.ActivePage := nil;
  end;

  // ���� ��������� �� ������� �����
  if NewPage = cxtshCompSearch then
  begin
    TDM.Create.ComponentsSearchGroup.AddClient;

    if FViewComponentsSearch = nil then
    begin
      // ������ ������������� ������ �����������
      FViewComponentsSearch := TViewComponentsSearch.Create(Self);
      FViewComponentsSearch.Place(cxtshCompSearch);

      // ����������� ������������� � ������
      ViewComponentsSearch.ComponentsSearchGroup :=
        TDM.Create.ComponentsSearchGroup;

      // ������������� �� ������� ����� ��������� ��������� ���������
      TNotifyEventWrap.Create(TDM.Create.ComponentsSearchGroup.OnOpenCategory,
        DoOnOpenCategory, FViewEventList);
    end;

    ViewComponentsSearch.TryApplyBestFit;
  end;

  // ���� ������ �� ������� �����
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

  UpdateCaption;
end;

procedure TfrmMain.cxpcMainPageChanging(Sender: TObject; NewPage: TcxTabSheet;
  var AllowChange: Boolean);
begin
  // ���� ������� �� ������� ����������
  if NewPage = cxtshComp then
    if cxpcComp2.ActivePage = nil then
      cxpcComp2.ActivePage := cxtshCompGroup;

  // ���� ������� �� ������� ������
  if NewPage = cxtshWareHouse then
    if cxpcWareHouse2.ActivePage = nil then
      cxpcWareHouse2.ActivePage := cxtshWareHouse2;
end;

procedure TfrmMain.cxpcWareHouse2PageChanging(Sender: TObject;
  NewPage: TcxTabSheet; var AllowChange: Boolean);
begin
  if not FLoadComplete then
    Exit;

  // ���� ��������� �� ������� ������
  if NewPage = cxtshWareHouse2 then
  begin
    TDM.Create.qStoreHouseList.AddClient;
    TDM.Create.qProducts.AddClient;

    TNotifyEventWrap.Create(TDM.Create.qProducts.W.AfterRefresh,
      DoOnStoreHouseListChange, FViewEventList);

    TNotifyEventWrap.Create(TDM.Create.qProducts.W.AfterOpen,
      DoOnStoreHouseListChange, FViewEventList);

    // ����������� ������ ������� � ������
    if FViewStoreHouse = nil then
    begin
      FViewStoreHouse := TViewStoreHouse.Create(Self);
      FViewStoreHouse.Place(pnlStoreHouseLeft);
      FViewStoreHouse.qStoreHouseList := TDM.Create.qStoreHouseList;

      TNotifyEventWrap.Create(FViewStoreHouse.OnCanFocusRecord,
        DoOnViewStoreHouseCanFocusRecord, FViewEventList);
    end;

    // ����������� ������������� ����������� ������ � ������
    if FViewProducts = nil then
    begin
      FViewProducts := TViewProducts2.Create(Self);
      FViewProducts.Parent := pnlStoreHouseRight;
      FViewProducts.Align := alClient;

      ViewProducts.qProducts := TDM.Create.qProducts;

      // ������������� ����� ������ ��������� � ��������������� �������
      TNotifyEventWrap.Create(TDM.Create.qProducts.OnLocate, DoOnProductLocate,
        FViewEventList);
    end;
    ViewProducts.MyApplyBestFit;
  end;

  // ���� ������ �� ������� ������
  if cxpcWareHouse2.ActivePage = cxtshWareHouse2 then
  begin
    TDM.Create.qProducts.RemoveClient;
    TDM.Create.qStoreHouseList.RemoveClient;
  end;

  // ���� ��������� �� ������� �������
  if NewPage = cxtshBasket then
  begin
    // ��������� ���������� �������
    TDM.Create.qProductsBasket.SearchForBasket;

    if FViewProductsBasket = nil then
    begin
      FViewProductsBasket := TViewProductsBasket.Create(Self);
      FViewProductsBasket.Parent := cxtshBasket;
      FViewProductsBasket.Align := alClient;
      ViewProductsBasket.qProducts := TDM.Create.qProductsBasket;
    end;
  end;

  // ���� ��������� �� ������� �����
  if NewPage = cxtshBill then
  begin
    TDM.Create.qBill.AddClient;
    // TDM.Create.qBillContent2.AddClient;

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

  // ���� ������ �� ������� �����
  if cxpcWareHouse2.ActivePage = cxtshBill then
  begin
    // TDM.Create.qBillContent2.RemoveClient;
    TDM.Create.qBill.RemoveClient;
  end;

  // ���� ��������� �� ������� �����
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
        DoOnProductLocate, FViewEventList);
    end;
  end;
end;

procedure TfrmMain.DoOnComponentLocate(Sender: TObject);
var
  l: TList<String>;
begin
  // ������ � ���� ��������������, ������� �� ���������� ������ �� ������
  Assert(Sender <> nil);
  l := Sender as TList<String>;
  Assert(l.Count > 0);

  TDM.Create.qProductsSearch.Search(l);

  // ������������� �� ������� ������
  cxpcMain.ActivePage := cxtshWareHouse;

  // ������������� �� ������� ����� �� ������
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
      idyes:
        QueryMonitor.ApplyUpdates;
      idno:
        QueryMonitor.CancelUpdates;
      idCancel:
        Action := caNone;
    end;
  end;

  // TDM.Create.

  inherited;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  // ������ ������ �����������
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

  // ������ ������� �����
  FEventList := TObjectList.Create;
  // ������ ������� �������������
  FViewEventList := TObjectList.Create;

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

  // ��������� ��� ���� �� ���� ������ ����������

  try
    if not CheckDataBasePath then
      raise EAbort.Create('CheckDataBasePath');

    Assert(DMRepository <> nil);
    // ���� ��� ���������� � �� ������ ���� �������
    Assert(not DMRepository.dbConnection.Connected);

    // ��������� ���������� � ����� ������
    if not TDataBase.OpenDBConnection(DMRepository.dbConnection,
      TSettings.Create.databasePath, TSettings.Create.DBMigrationFolder,
      TPath.GetDirectoryName(Application.ExeName)) then
      raise EAbort.Create('OpenDBConnection');

    // ��������� ����������� ������ "��������� ��"
    DoOnHaveAnyChanges(nil);
    TNotifyEventWrap.Create(QueryMonitor.OnHaveAnyChanges, DoOnHaveAnyChanges);

    TNotifyEventWrap.Create(TDM.Create.AfterAddBill, DoAfterAddBill);

    FLoadComplete := True;

    cxpcMain.ActivePage := cxtshComp;
    cxpcComp2.ActivePage := cxtshCompGroup;

    // ������������ �������� �������
    if TDM.Create.qTreeList.FDQuery.Active then
      DoOnProductCategoriesChange(nil);

  except
    Application.ShowMainForm := False;
    Application.Terminate; // ��������� ������ ����������
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
var
  AExternalID: string;
begin
  cxtsCategoryComponents.Enabled := not TDM.Create.qTreeList.W.IsRootFocused;

  Assert(TDM.Create.qTreeList.W.PK.AsInteger > 0);
  Assert(FQuerySearchCategoriesPath <> nil);
  FCategoryPath := FQuerySearchCategoriesPath.GetFullPath
    (TDM.Create.qTreeList.W.PK.AsInteger);

  if (not FCategoryPath.IsEmpty) then
    FCategoryPath := FCategoryPath + Format(' (%s)',
      [TDM.Create.qTreeList.W.ExternalID.F.AsString]);

  UpdateCaption;

  AExternalID := ' ' + TDM.Create.qTreeList.W.ExternalID.F.AsString;
  if AExternalID.TrimRight(['0']) = ' ' then
    AExternalID := '';

  cxtsCategory.Caption := Format('���������� �������������� ������%s',
    [AExternalID]);
end;

procedure TfrmMain.DoOnProductLocate(Sender: TObject);
var
  LO: TLocateObject;
begin
  LO := (Sender as TLocateObject);

  if not TDM.Create.qTreeList.W.LocateByPK(LO.IDCategory) then
  begin
    TDialog.Create.ErrorMessageDialog(Format('��������� � ����� %d �� �������',
      [LO.IDCategory]));
    Exit;
  end;

  // ���������� ���� � ��������������� ��������
  ShowParametricTable;
  // ��������� �� ���������
  frmParametricTable.ViewParametricTable.FilterByFamily(LO.FamilyName);
  // ��������� ��������� �� ����������
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
    // ������ ���� � ��������������� ��������
    frmParametricTable := TfrmParametricTable.Create(Self);

    // ������������� �� ������� ����� ��������� ����
    TNotifyEventWrap.Create(frmParametricTable.OnActivate,
      DoBeforeParametricTableActivate, FEventList);

    TNotifyEventWrap.Create(frmParametricTable.OnDeactivate,
      DoBeforeParametricTableDeactivate, FEventList);

    // ����������� ������ � �������������
    frmParametricTable.ViewParametricTable.ComponentsExGroup :=
      TDM.Create.ComponentsExGroup;
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
    idCancel)) and ((ViewCategoryParameters = nil) or
    (ViewCategoryParameters.CheckAndSaveChanges <> idCancel));
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

procedure TfrmMain.DoAfterAddBill(Sender: TObject);
begin
  // ������������� �� ������� ������
  cxpcMain.ActivePage := cxtshWareHouse;
  // ������������� �� ������� �����
  cxpcWareHouse2.ActivePage := cxtshBill;
  // ������ ����� ��������� ������������� ���� ������
  Assert(ViewBill <> nil);
  ViewBill.SelectFocusedBill;
end;

procedure TfrmMain.DoAfterLoadSheet(ASender: TObject);
var
  A: TArray<Integer>;
  AFamily: Boolean;
  AfrmError: TfrmCustomError;
  AfrmGridView: TfrmGridView;
  AParametricExcelTable: TParametricExcelTable;
  E: TExcelDMEvent;
  ne: TNotifyEventR;
  OK: Boolean;
begin
  E := ASender as TExcelDMEvent;

  AParametricExcelTable := E.ExcelTable as TParametricExcelTable;

  // ���� �������� �������� ������
  if FWriteProgress.PIList.Count = 0 then
    FWriteProgress.Assign(E.TotalProgress);

  OK := E.ExcelTable.Errors.RecordCount = 0;
  // ���� � ���� �������� ������ ��������� ������ (��������� �� ������)
  if not OK then
  begin
    FfrmProgressBar.Hide;
    AfrmError := TfrmCustomError.Create(nil);
    try
      AfrmError.ViewGridEx.DataSet := E.ExcelTable.Errors;
      // ���������� ������
      OK := AfrmError.ShowModal = mrOk;
      if OK then
      begin
        if AfrmError.ContinueType = ctSkip then
          // ������� ������ � �������� � ����������������
          E.ExcelTable.ExcludeErrors(etWarring)
        else
          // ������� ������ � ��������
          E.ExcelTable.ExcludeErrors(etError);
      end;
    finally
      FreeAndNil(AfrmError);
    end;
  end;

  // ���� �� ������������� �������� ��������� ������
  E.Terminate := not OK;

  if not OK then
    Exit;

  // ���� ��������� ��������� ��������������� ������� ��� ��������
  AFamily := AParametricExcelTable.ComponentTypeSet = [ctFamily];

  // ����� ������� ������� ����� �������� ��� ����������� ���������
  if (E.SheetIndex = 1) and (AFamily) then
  begin
    // ������ ���� ����-�� ���� ���������, � ������� ����� ��������� ���������
    Assert(AParametricExcelTable.ProductCategoriesMemTbl.RecordCount >= 1);

    FfrmProgressBar.Hide;

    // ���������� ���� � �����������
    AfrmGridView := TfrmGridView.Create(Self, '��������� ���������',
      [mmbContinue, mmbCancel]);
    try
      AfrmGridView.GridViewClass := TViewCategory;
      (AfrmGridView.GridView as TViewCategory).ProductCategoriesMemTbl :=
        AParametricExcelTable.ProductCategoriesMemTbl;

      // ���������� ��������� � ������� ����� ��������� ���������
      OK := AfrmGridView.ShowModal = mrOk;
    finally
      FreeAndNil(AfrmGridView);
    end;

    // �������� �������������� ��������� ���������
    A := AParametricExcelTable.ProductCategoriesMemTbl.GetChecked;

    // ���� �� ������������� �������� ��������� ������
    E.Terminate := not OK or (Length(A) = 0);

    if Length(A) = 0 then
      TDialog.Create.ErrorMessageDialog('�� ���� ��������� �� �������');

    if E.Terminate then
      Exit;

    FfrmProgressBar.Show;

    // 1 ��������� ��������� � ���������
    E.ExcelTable.Process(
      procedure(ASender: TObject)
      begin
        TParameterValues.LoadParameters(A,
          E.ExcelTable as TParametricExcelTable);
      end,

    // ���������� �������
      procedure(ASender: TObject)
      Var
        API: TProgressInfo;
      begin
        API := ASender as TProgressInfo;
        TryUpdateWrite0Statistic(API);
      end);
  end;

  // 2 ��������� �������� ����������

  // ������������� �� �������
  ne := TNotifyEventR.Create(E.ExcelTable.OnProgress,
    procedure(ASender: TObject)
    Var
      API: TProgressInfo;
    begin
      API := ASender as TProgressInfo;
      // ���������� �������� ������ �����
      FWriteProgress.PIList[E.SheetIndex - 1].Assign(API);
      // ��������� ����� �������� ������
      FWriteProgress.UpdateTotalProgress;

      TryUpdateWriteStatistic(FWriteProgress.TotalProgress);
    end);
  try
    // ��������� �������� �������� ����������
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

  // ��� ���� ������, ����-�� � ������� ��������� ������������
  rc := TSearchSubCategories.Search(TDM.Create.qTreeList.W.PK.Value);
  // ���� � ����� ��������� ���� ������������
  if rc > 0 then
    ACategoryPath := TDM.Create.qTreeList.W.Value.F.AsString
  else
  begin
    // ���� � ������� ��������� �� ��������� �����
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
    // � ��������� ��������� ����� ������ ���� ������� ������� "�� �������"
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
    // ������� ������ � ������� ���������
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
    // � ��������� ��������� ����� ������ ���� ������� ������� "�� �������"
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

      // ���� ����������� ������� ���������
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
    Exit; // ���������� �� ������ �����

  // ��������� ��� ����� � ����������
  TSettings.Create.LastFolderForComponentsLoad :=
    TPath.GetDirectoryName(AFileName);

  S := TPath.GetFileNameWithoutExtension(AFileName);

  m := S.Split([' ']);
  if Length(m) = 0 then
  begin
    TDialog.Create.FileNameNotContainCategoryID;
    Exit;
  end;

  try
    // ��������� ��� ������ ����� �������� ������������� ��� ���������
    m[0].ToInteger;
  except
    TDialog.Create.FileNameNotContainCategoryID;
    Exit;
  end;

  TDM.Create.qTreeList.W.TryOpen;

  // ��������� � ������ ��������� �� ����������� ���������
  if not TDM.Create.qTreeList.W.LocateByExternalID(m[0]) then
  begin
    TDialog.Create.ErrorMessageDialog(Format('��������� %s �� �������',
      [m[0]]));
    Exit;
  end;

  Assert(not AFileName.IsEmpty);
  Assert(not AProducer.IsEmpty);

  if ViewComponents <> nil then
    ViewComponents.BeginUpdate;

  TDM.Create.ComponentsGroup.AddClient;
  try
    TLoad.Create.LoadAndProcess(AFileName, TComponentsExcelDM, TfrmImportError,
      procedure(ASender: TObject)
      begin
        TDM.Create.ComponentsGroup.LoadDataFromExcelTable
          (ASender as TComponentsExcelTable, AProducer);
      end,
      procedure(ASender: TObject)
      begin
        with ASender as TComponentsExcelTable do
        begin
          Producer := AProducer;
          SaveAllActionCaption := sSaveAllActionCaption;
          SkipAllActionCaption := sSkipAllActionCaption;
        end;
      end);
  finally
    TDM.Create.ComponentsGroup.RemoveClient;

    if ViewComponents <> nil then
      ViewComponents.EndUpdate;

    // ��������� �� ������� "���������� ������ �����������"
    TryFocusViewComponents;
  end;

end;

procedure TfrmMain.DoOnLoadCompFromExcelFolder(Sender: TObject);
var
  AComponentsGroup2: TComponentsGroup2;
  AFileName: string;
  AFileNames: TList<String>;
  AFolderName: string;
  AProducer: String;
  AProducerID: Integer;
  ATreeListID: Integer;
  AutomaticLoadErrorTable: TAutomaticLoadErrorTable;
  I: Integer;
  m: TStringDynArray;
  S: string;
begin
  Application.Hint := '';
  // �������� �������������
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
      AutomaticLoadErrorTable.W.LocateOrAppendData(S, NULL, '', '', '');
    end;
    AutomaticLoadErrorTable.First;

    if frmImportProcess <> nil then
      FreeAndNil(frmImportProcess);

    frmImportProcess := TfrmImportProcess.Create(Self);
    frmImportProcess.Caption := '�������� �����������';
    frmImportProcess.ViewGridEx.DataSet := AutomaticLoadErrorTable;
    frmImportProcess.ViewGridEx.ApplyBestFitOnUpdateData := True;
    // ���������� �����
    frmImportProcess.Show;

    Application.ProcessMessages;

    if ViewComponents <> nil then
      ViewComponents.BeginUpdate;
    try
      AComponentsGroup2 := TComponentsGroup2.Create(Self);
      try
        ATreeListID := AComponentsGroup2.LoadFromExcelFolder(AFileNames,
          AutomaticLoadErrorTable, AProducer);
      finally
        FreeAndNil(AComponentsGroup2);
        // ��������� ������� �����
        frmImportProcess.Done := True;
      end;

      TDM.Create.qTreeList.W.TryOpen;

      // �������� � ������ ��������� ����������� ���������
      TDM.Create.qTreeList.W.LocateByPK(ATreeListID, True);
    finally
      if ViewComponents <> nil then
        ViewComponents.EndUpdate;
      // ��������� �� ������� "���������� ������ �����������"
      TryFocusViewComponents;
    end;

  finally
    FreeAndNil(AFileNames);
  end;
end;

procedure TfrmMain.DoOnLoadParametricData(Sender: TObject);
begin
  Application.Hint := '';
  // ����� ��������� ��������������� ������ ��� ����������� (�� ��������)
  LoadParametricData([ctComponent]);
end;

procedure TfrmMain.DoOnLoadParametricTable(Sender: TObject);
begin
  Application.Hint := '';
  // ����� ��������� ��������������� ������ ��� �������� �����������
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
  // �������� ������ - ������� ��������� ���������
  I := ASubGroup.IndexOf(',');
  if I = -1 then
    I := ASubGroup.Length;

  AExternalID := ASubGroup.Substring(0, I);
  TDM.Create.qTreeList.W.LocateByExternalID(AExternalID);

  // ���, ���� ������ ����������� ������� ���� ������!
  Application.ProcessMessages;

  TDM.Create.ComponentsGroup.AddClient;
  try
    // ���� ������ ��� ���������
    TDM.Create.ComponentsGroup.qFamily.FamilyW.Value.Locate(AFamilyCaption,
      [lxoCaseInsensitive]);

    // ������������� �� ������� "����������"
    cxpcMain.ActivePage := cxtshComp;

    // ������������� �� ������� "�� �������"
    cxpcComp2.ActivePage := cxtshCompGroup;

    // ������������� �� ������� "���������� ������ �����������"
    cxpcCompGroupRight.ActivePage := cxtsCategoryComponents;

    // ���
    Application.ProcessMessages;

    Assert(ViewComponents <> nil);

    ViewComponents.cxGrid.SetFocus;

    // �������� ��������������� ������
    ViewComponents.SelectFocusedRecord
      (TDM.Create.ComponentsGroup.qFamily.FamilyW.Value.FieldName);
  finally
    TDM.Create.ComponentsGroup.RemoveClient;
  end;
end;

procedure TfrmMain.DoOnStoreHouseListChange(Sender: TObject);
begin
  UpdateCaption;
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
  AOnCanFocusRecord.Allow := ViewProducts.CheckAndSaveChanges <> idCancel;
end;

procedure TfrmMain.FocusViewComponents;
begin
  cxpcMain.ActivePage := cxtshComp;
  cxpcComp2.ActivePage := cxtshCompGroup;
  cxpcCompGroupRight.ActivePage := cxtsCategoryComponents;
end;

procedure TfrmMain.FormActivate(Sender: TObject);
begin
  if (ViewProducts <> nil) and (cxpcMain.ActivePage = cxtshWareHouse) and
    (cxpcWareHouse2.ActivePage = cxtshWareHouse2) then
    ViewProducts.ConnectView;
end;

procedure TfrmMain.FormDeactivate(Sender: TObject);
begin
  if (ViewProducts <> nil) and (cxpcMain.ActivePage = cxtshWareHouse) and
    (cxpcWareHouse2.ActivePage = cxtshWareHouse2) then
    ViewProducts.DisconnectView;
end;

function TfrmMain.GetQueryMonitor: TQueryMonitor;
begin
  Result := TDM.Create.qTreeList.Monitor;
end;

function TfrmMain.GetViewComponentsFocused: Boolean;
begin
  Result := (ViewComponents <> nil) and (cxpcMain.ActivePage = cxtshComp) and
    (cxpcComp2.ActivePage = cxtshCompGroup) and
    (cxpcCompGroupRight.ActivePage = cxtsCategoryComponents);
end;

procedure TfrmMain.LoadDocFromExcelDocument;
var
  AFileName: string;
begin
  if not TDialog.Create.ShowDialog(TExcelFileOpenDialog,
    TSettings.Create.LastFolderForComponentsLoad, '', AFileName) then
    Exit;
  // ���������� �� ������ �����

  // ��������� ��� ����� � ����������
  TSettings.Create.LastFolderForComponentsLoad :=
    TPath.GetDirectoryName(AFileName);

  TBindDoc.LoadDocBindsFromExcelDocument(AFileName);
end;

function TfrmMain.LoadExcelFileHeader(const AFileName: String;
AFieldsInfo: TFieldsInfo): Boolean;
var
  ARootTreeNode: TStringTreeNode;
  R: TLoadExcelFileHeaderResult;
begin
  Assert(AFieldsInfo <> nil);
  Result := True;

  // �������� ����� excel �����
  ARootTreeNode := TExcelDM.LoadExcelFileHeader(AFileName);
  try
    R := TDM.Create.LoadExcelFileHeader(ARootTreeNode, AFieldsInfo,
      function(AParametricErrorTable: TParametricErrorTable): Boolean
      var
        AfrmParametricTableError: TfrmParametricTableError;
      begin
        AfrmParametricTableError := TfrmParametricTableError.Create(Self);
        try
          AfrmParametricTableError.ViewParametricTableError.DataSet :=
            AParametricErrorTable;
          // ���������� ��� �� ���������� �����������
          Result := AfrmParametricTableError.ShowModal = mrOk;
        finally
          FreeAndNil(AfrmParametricTableError);
        end;
      end);
  finally
    FreeAndNil(ARootTreeNode);
  end;

  case R of
    ID_ParametricTableNotFound:
      TDialog.Create.ParametricTableNotFound;
    ID_NoParameterForLoad:
      TDialog.Create.ErrorMessageDialog
        ('��� ����������, �������� ������� ����� ���������');
  end;
  Result := Result and (R = ID_OK);
end;

procedure TfrmMain.LoadParametricData(AComponentTypeSet: TComponentTypeSet);
var
  ACopyCommonValueToFamily: Boolean;
  AFieldsInfo: TFieldsInfo;
  AFileName: string;
  AfrmLoadParametric: TfrmLoadParametric;
  AParametricExcelDM: TParametricExcelDM;
  m: TArray<String>;
begin

  // ���� ��� �������� ��������������� ������
  if AComponentTypeSet = [ctComponent] then
    AfrmLoadParametric := TfrmLoadParametricData.Create(Self)
  else
    AfrmLoadParametric := TfrmLoadParametricTable.Create(Self);

  try
    // ���� ���������� �� ���������� ��������
    if AfrmLoadParametric.ShowModal <> mrOk then
      Exit;

    // ��������� ��� ����� � ����������
    TSettings.Create.ParametricDataFolder :=
      TPath.GetDirectoryName(AfrmLoadParametric.FileName);

    AFieldsInfo := TFieldsInfo.Create();
    try
      if not LoadExcelFileHeader(AfrmLoadParametric.FileName, AFieldsInfo) then
        Exit;

      if AfrmLoadParametric is TfrmLoadParametricTable then
      begin
        // � ������ ����� ����� - ��� ��������� � ������� ����� ��������� ���������
        AFileName := TPath.GetFileNameWithoutExtension
          (AfrmLoadParametric.FileName);

        m := AFileName.Split([' ']);
        if Length(m) = 1 then
        begin
          TDialog.Create.FileNameNotContainCategoryID;
          Exit;
        end;

        try
          // ��������� ��� ������ ����� �������� ������������� ��� ���������
          m[0].ToInteger;
        except
          TDialog.Create.FileNameNotContainCategoryID;
          Exit;
        end;

        // ����, ���� �� ��������� � ����� ������� �����
        if TDM.Create.qSearchCategory.SearchByExternalID(m[0]) = 0 then
        begin
          TDialog.Create.ErrorMessageDialog
            (Format('��������� � ��������������� %s �� �������', [m[0]]));
          Exit;
        end;

        // ���� ��� �������� ���������
        // rc := TDM.Create.qSearchDaughterCategories.SearchEx
        // (TDM.Create.qSearchCategory.W.ID.F.AsInteger);
        // Assert(rc > 0);
        ACopyCommonValueToFamily := False;
      end
      else
        ACopyCommonValueToFamily :=
          (AfrmLoadParametric as TfrmLoadParametricData)
          .CopyCommonValueToFamily;

      AParametricExcelDM := TParametricExcelDM.Create(Self, AFieldsInfo,
        AComponentTypeSet, AfrmLoadParametric.Replace,
        ACopyCommonValueToFamily);
      FWriteProgress := TTotalProgress.Create;
      FfrmProgressBar := TfrmProgressBar3.Create(Self);
      try
        TNotifyEventWrap.Create(AParametricExcelDM.AfterLoadSheet,
          DoAfterLoadSheet);
        TNotifyEventWrap.Create(AParametricExcelDM.OnTotalProgress,
          DoOnTotalReadProgress);

        FfrmProgressBar.Show;
        AParametricExcelDM.LoadExcelFile2(AfrmLoadParametric.FileName);

      finally
        FreeAndNil(AParametricExcelDM);
        FreeAndNil(FWriteProgress);
        FreeAndNil(FfrmProgressBar);
      end;
    finally
      FreeAndNil(AFieldsInfo);
    end;

    if AfrmLoadParametric is TfrmLoadParametricTable and
      ((AfrmLoadParametric as TfrmLoadParametricTable).LoadComponentGroup or
      (TDM.Create.qTreeList.W.ID.F.AsInteger = TDM.Create.qSearchCategory.W.ID.
      F.AsInteger)) then
    begin
      // ��������� �� ��������� � ������� ��������� �������� ����������
      TDM.Create.qTreeList.W.LocateByPK
        (TDM.Create.qSearchCategory.W.ID.F.AsInteger);

      // ��������� ��������� ��� ������� ���������
      TDM.Create.CategoryParametersGroup.RefreshData;

      // �������� �������� ��������������� �������
      TDM.Create.ComponentsExGroup.TryRefresh;

      // ���������� ��������������� ������� � ������������� ������
      if (AfrmLoadParametric as TfrmLoadParametricTable).ShowParametricTable
      then
        ShowParametricTable;
    end;
  finally
    FreeAndNil(AfrmLoadParametric);
  end;
end;

procedure TfrmMain.TryFocusViewComponents;
begin
  if ViewComponentsFocused then
    // ���������� ����� ������� ����
    ViewComponents.FocusTopLeftEx
  else
    // ��������� �� ������� "���������� ������ �����������"
    FocusViewComponents;

  Assert(ViewComponents <> nil);
  ViewComponents.UpdateView;
end;

procedure TfrmMain.TryUpdateAnalizeStatistic(API: TProgressInfo);
begin
  if (API.ProcessRecords mod OnWriteProcessEventRecordCount = 0) or
    (API.ProcessRecords = API.TotalRecords) then
    // ���������� �������� �������
    FfrmProgressBar.UpdateAnalizeStatistic(API);
end;

procedure TfrmMain.TryUpdateWrite0Statistic(API: TProgressInfo);
begin
  if (API.ProcessRecords mod OnWriteProcessEventRecordCount = 0) or
    (API.ProcessRecords = API.TotalRecords) then
    // ���������� ����� �������� ������
    FfrmProgressBar.UpdateWriteStatistic0(API);
end;

procedure TfrmMain.TryUpdateWriteStatistic(API: TProgressInfo);
begin
  if (API.ProcessRecords mod OnWriteProcessEventRecordCount = 0) or
    (API.ProcessRecords = API.TotalRecords) then
    // ���������� ����� �������� ������
    FfrmProgressBar.UpdateWriteStatistic(API);
end;

procedure TfrmMain.UpdateCaption;
var
  AFS: TFormatSettings;
  S: string;
begin
  if not TDM.Created then
    Exit;

  AFS.DecimalSeparator := '.';
  S := '';

  // ���� ������� ������� "����������"
  if (cxpcMain.ActivePage = cxtshComp) and
    (TDM.Create.qTreeList.FDQuery.RecordCount > 0) then
  begin
    if not TDM.Create.qTreeList.W.IsRootFocused and not FCategoryPath.IsEmpty
    then
    begin
      S := MinimizeName(FCategoryPath, Canvas, Width - 200);
      S := ' - ' + S.Trim(['\']).Replace('\', '-');
    end
    else
      S := ' - ' + TDM.Create.qTreeList.W.Value.F.AsString;
  end;

  // ���� ������� ������� "������"
  if (cxpcMain.ActivePage = cxtshWareHouse) and
    (TDM.Create.qProducts.StorehouseListInt <> nil) and
    not TDM.Create.qProducts.StorehouseListInt.StoreHouseTitle.IsEmpty then
  begin
    S := ' - ' + TDM.Create.qProducts.StorehouseListInt.StoreHouseTitle;
  end;

  // ������ ��������� �����
  Caption := Format('%s %0.1f%s', [sMainFormCaption, ProgramVersion, S], AFS);
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
