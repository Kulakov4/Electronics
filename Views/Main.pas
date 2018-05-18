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
  System.UITypes, System.Types, System.Contnrs, NotifyEvents, DataModule2,
  System.Actions, Vcl.ActnList, dxSkinsCore, dxSkinsDefaultPainters, GridFrame,
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
  BaseEventsQuery;

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
    procedure OnTreeListCanFocusNode(Sender: TcxCustomTreeList; ANode:
        TcxTreeListNode; var Allow: Boolean);
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
  ProductsBaseQuery, DescriptionsGroupUnit, RecursiveTreeView,
  RecursiveTreeQuery, TreeExcelDataModule, BindDocUnit, DialogUnit2,
  LoadFromExcelFileHelper, SearchCategoryQuery, CustomErrorForm,
  ExtraChargeForm, ExceptionHelper, System.StrUtils;

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
  DM2.qStoreHouseList.TryPost;

  Value := InputBox(sDatabase, sPleaseWrite, '');
  if Value <> '' then
  begin
    DM2.qStoreHouseList.LocateOrAppend(Value);
    clStorehouseListTitle.ApplyBestFit();
  end;
end;

procedure TfrmMain.actDeleteStorehouseExecute(Sender: TObject);
begin
  DM2.qStoreHouseList.TryPost;
  if DM2.qStoreHouseList.FDQuery.RecordCount > 0 then
  begin
    if TDialog.Create.DeleteRecordsDialog(sDoYouWantToDelete) then
    begin
      DM2.qStoreHouseList.FDQuery.Delete;
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
    DM2.qStoreHouseList.TryPost;
    Value := InputBox(sDatabase, sPleaseWrite,
      DM2.qStoreHouseList.Title.AsString);
    if (Value <> '') then
    begin
      DM2.qStoreHouseList.TryEdit;
      DM2.qStoreHouseList.Title.AsString := Value;
      DM2.qStoreHouseList.TryPost;
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
//  DM2.SaveAll;
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

  FViewTreeList.BeginUpdate;
  try
    DM2.CreateOrOpenDataBase;
    // ������������ �������� �������
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
    DM2.BodyTypesGroup.ReOpen;
    frmBodyTypes := TfrmBodyTypes.Create(Self);
    frmBodyTypes.ViewBodyTypes.BodyTypesGroup := DM2.BodyTypesGroup;
  end;

  frmBodyTypes.Show;
end;

procedure TfrmMain.actShowDescriptionsExecute(Sender: TObject);
begin
  if frmDescriptions = nil then
  begin
    DM2.DescriptionsGroup.ReOpen;
    frmDescriptions := TfrmDescriptions.Create(Self);
    frmDescriptions.ViewDescriptions.DescriptionsGroup := DM2.DescriptionsGroup;
  end;

  frmDescriptions.Show;
end;

procedure TfrmMain.actShowExtraChargeExecute(Sender: TObject);
begin
  if frmExtraCharge = nil then
  begin
    DM2.qExtraCharge.RefreshQuery;
    frmExtraCharge := TfrmExtraCharge.Create(Self);
    frmExtraCharge.ViewExtraCharge.qExtraCharge := DM2.qExtraCharge;
  end;

  frmExtraCharge.Show;
end;

procedure TfrmMain.actShowProducersExecute(Sender: TObject);
begin
  if frmProducers = nil then
  begin
    DM2.ProducersGroup.ReOpen;
    frmProducers := TfrmProducers.Create(Self);
    frmProducers.ViewProducers.ProducersGroup := DM2.ProducersGroup;
  end;

  frmProducers.Show;
end;

procedure TfrmMain.actShowParametersExecute(Sender: TObject);
begin
  if frmParameters = nil then
  begin
    DM2.ParametersGroup.ReOpen;
    frmParameters := TfrmParameters.Create(Self);
    frmParameters.ViewParameters.ParametersGrp := DM2.ParametersGroup;
    frmParameters.ViewSubParameters.QuerySubParameters :=
      DM2.ParametersGroup.qSubParameters;
  end;

  frmParameters.Show;
end;

procedure TfrmMain.ApplicationEventsException(Sender: TObject; E: Exception);
var
  Msg: string;
begin
  Msg := IfThen(MyExceptionMessage.IsEmpty, E.Message, MyExceptionMessage );
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
end;

procedure TfrmMain.btnFocusRootClick(Sender: TObject);
begin
  DM2.qTreeList.LocateToRoot;
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
  // ������ � ���� ��������������, ������� �� ���������� ������ �� ������
  Assert(Sender <> nil);
  l := Sender as TList<String>;
  Assert(l.Count > 0);

  DM2.qProductsSearch.Search(l);

  // ������������� �� ������� ������
  cxpcLeft.ActivePage := cxtsStorehouses;
  // ������������� �� ������� ����� �� ������
  ProductsFrame.cxpcStorehouse.ActivePage := ProductsFrame.tsStorehouseSearch;

  BringToFront;
  ProductsFrame.ViewProductsSearch2.FocusValueColumn;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if QueryMonitor.HaveAnyChanges then
  begin
    case TDialog.Create.SaveDataDialog of
      IDYES:
        QueryMonitor.ApplyUpdates;
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

  // ������ ����� � ������������
  FComponentsFrame := TComponentsFrame.Create(Self);
  ComponentsFrame.Parent := cxtsRComponents;
  ComponentsFrame.Align := alClient;

  // ������ ����� �� �������
  FProductsFrame := TProductsFrame.Create(Self);
  ProductsFrame.Parent := cxtsRStorehouses;
  ProductsFrame.Align := alClient;

  // ������ ����� � ������� ���������
  FViewTreeList := TViewTreeList.Create(Self);
  ViewTreeList.Parent := cxtsComponents;
  ViewTreeList.Align := alClient;
  // ������������� ���������� �������
  ViewTreeList.cxDBTreeList.OnCanFocusNode := OnTreeListCanFocusNode;

//  Application.OnHint := ApplicationEventsHint;

  ComponentsFrame.cxpcComponents.ActivePage := ComponentsFrame.cxtsCategory;
  ProductsFrame.cxpcStorehouse.ActivePage := ProductsFrame.tsStorehouseProducts;

  // ������ ������ �����������
  if DMRepository = nil then
    DMRepository := TDMRepository.Create(Self);
  Assert(not DMRepository.dbConnection.Connected);
  Assert(DM2 = nil);
  // ���� ������ ������ ������
  DM2 := TDM2.Create(Self);

  Assert(not DMRepository.dbConnection.Connected);

  inherited;

  Self.WindowState := wsNormal;

  // ������������� �� �������
  FEventList := TObjectList.Create;

  // ��������� ��� ���� �� ���� ������ ����������
  OK := CheckDataBasePath;
  if OK then
  begin
    // ���� ��� ���������� � �� ������ ���� �������
    Assert(not DMRepository.dbConnection.Connected);
    repeat

      try
        // ������ ��� ��������� ���� ������
        DM2.CreateOrOpenDataBase;
      except
        on e: Exception do
        begin
          TDialog.Create.ErrorMessageDialog(e.Message);
          // ����� ���������� ������� ����� � ��

          OK := ShowSettingsEditor = mrOk;
        end;
      end;

    until (DMRepository.dbConnection.Connected) or (not OK);

    if OK then
    begin
      // ��������� ����������� ������ "��������� ��"
      DoOnHaveAnyChanges(nil);
      TNotifyEventWrap.Create( QueryMonitor.OnHaveAnyChanges, DoOnHaveAnyChanges );

      // ������������� ����� ������ ��������� �� �������
      TNotifyEventWrap.Create(DM2.ComponentsExGroup.qComponentsEx.OnLocate,
        DoOnComponentLocate, FEventList);

      // ������������� ����� ������ ��������� � ��������������� �������
      TNotifyEventWrap.Create(DM2.qProducts.OnLocate, DoOnProductLocate, FEventList);
      TNotifyEventWrap.Create(DM2.qProductsSearch.OnLocate, DoOnProductLocate, FEventList);

      // ����������� ������������� � ������
      ComponentsFrame.ViewComponents.ComponentsGroup := DM2.ComponentsGroup;

      // ������������� �� ������� � ����������� ��������������� �������
      TNotifyEventWrap.Create
        (ComponentsFrame.ViewComponents.OnShowParametricTableEvent,
        DoOnShowParametricTable, FEventList);

      ComponentsFrame.ViewComponentsSearch.ComponentsSearchGroup :=
        DM2.ComponentsSearchGroup;

      // ��������� � ���� ������
      ComponentsFrame.ViewCategoryParameters.CatParamsGroup :=
        DM2.CategoryParametersGroup;

      ComponentsFrame.ViewParametricTable.ComponentsExGroup :=
        DM2.ComponentsExGroup;

      // ����������� ������ ������� � ������
      tvStorehouseList.DataController.DataSource :=
        DM2.qStoreHouseList.DataSource;
      clStorehouseListTitle.ApplyBestFit();
      // ����������� ���������� � ������ � ������
      ProductsFrame.ViewStorehouseInfo.QueryStoreHouseList :=
        DM2.qStoreHouseList;
      // ����������� ������� ����� � ������
      ProductsFrame.ViewProducts2.qProducts := DM2.qProducts;
      // ����������� ����� �� ������� � ������
      ProductsFrame.ViewProductsSearch2.qProductsSearch := DM2.qProductsSearch;

      // ViewStoreHouse.StoreHouseGroup := DM2.StoreHouseGroup;
      // ViewStoreHouse.QueryProductsSearch := DM2.qProductsSearch;

      // ����������� ������ ��������� � ������
      // AClone := DM2.qTreeList.AddClone('');
      // DM2.qTreeList.DataSource.DataSet := AClone;

      ViewTreeList.qTreeList := DM2.qTreeList;
      TNotifyEventWrap.Create(DM2.qTreeList.AfterSmartRefresh,
        DoAfterTreeListSmartRefresh, FEventList);

      // ����������� ������������ � ������ (�������������� ������)
      ComponentsFrame.ViewChildCategories.qChildCategories :=
        DM2.qChildCategories;
      {
        ComponentsFrame.tvFunctionalGroup.DataController.DataSource :=
        DM2.qChildCategories.DataSource;
      }
      FOnProductCategoriesChange := TNotifyEventWrap.Create
        (DM2.qTreeList.AfterScroll, DoOnProductCategoriesChange, FEventList);

      // ������������ �������� �������
      DoOnProductCategoriesChange(nil);

    end;
  end;

  // OK := OK and TProtect.Create.Check;

  if not OK then
  begin
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
begin
  ComponentsFrame.cxtsCategoryComponents.Enabled :=
    not DM2.qTreeList.IsRootFocused;

  Assert(DM2.qTreeList.PK.AsInteger > 0);
  Assert(FQuerySearchCategoriesPath <> nil);
  FCategoryPath := FQuerySearchCategoriesPath.GetFullPath
    (DM2.qTreeList.PK.AsInteger);

  UpdateCaption;

end;

procedure TfrmMain.DoOnProductLocate(Sender: TObject);
var
  LO: TLocateObject;
begin
  LO := (Sender as TLocateObject);

  if not DM2.qTreeList.LocateByPK(LO.IDCategory) then
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
    {
      // ��� ���� ������, ����-�� � ������� ��������� ������������
      rc := TSearchSubCategories.Search(DM2.qTreeList.PK.Value);
      // ���� � ����� ��������� ���� ������������
      if rc > 0 then
      ACategoryPath := DM2.qTreeList.Value.AsString
      else
      begin
      // ���� � ������� ��������� �� ��������� �����
      ACategoryPath := FQuerySearchCategoriesPath.GetLastTreeNodes
      (DM2.qTreeList.PK.Value, 2, '-');
      end;
    }
    // ������ ���� � ��������������� ��������
    frmParametricTable := TfrmParametricTable.Create(Self);

    // ������������� �� ������� ����� ��������� ����
    TNotifyEventWrap.Create(frmParametricTable.OnActivate,
      DoBeforeParametricTableActivate, FEventList);

    TNotifyEventWrap.Create(frmParametricTable.OnDeactivate,
      DoBeforeParametricTableDeactivate, FEventList);

    // ����������� ������ � �������������
    frmParametricTable.ViewParametricTable.ComponentsExGroup :=
      DM2.ComponentsExGroup;

    // �������������, ��� ��� ����������� ������ ����� �������
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

procedure TfrmMain.OnTreeListCanFocusNode(Sender: TcxCustomTreeList; ANode:
    TcxTreeListNode; var Allow: Boolean);
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
  // ������ ������������ ������� "����������"
  cxpcRight.ActivePage := cxtsRComponents;
end;

procedure TfrmMain.cxtsStorehousesShow(Sender: TObject);
begin
  // ������ ������������ ������� "������"
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
  DM2.ComponentsExGroup.AddClient;

  // ��� ���� ������, ����-�� � ������� ��������� ������������
  rc := TSearchSubCategories.Search(DM2.qTreeList.PK.Value);
  // ���� � ����� ��������� ���� ������������
  if rc > 0 then
    ACategoryPath := DM2.qTreeList.Value.AsString
  else
  begin
    // ���� � ������� ��������� �� ��������� �����
    ACategoryPath := FQuerySearchCategoriesPath.GetLastTreeNodes
      (DM2.qTreeList.PK.Value, 2, '-');
  end;
  frmParametricTable.CategoryPath := ACategoryPath;
end;

procedure TfrmMain.DoBeforeParametricTableDeactivate(Sender: TObject);
begin
  DM2.ComponentsExGroup.DecClient;
end;

procedure TfrmMain.DoOnHaveAnyChanges(Sender: TObject);
begin
  actSaveAll.Enabled := QueryMonitor.HaveAnyChanges;
end;

function TfrmMain.GetQueryMonitor: TQueryMonitor;
begin
  Result := nil;
  if DM2 <> nil then
    Result := DM2.qTreeList.Monitor;
end;

procedure TfrmMain.UpdateCaption;
var
  AFS: TFormatSettings;
  S: string;
begin
  if (DM2 <> nil) and (DM2.qTreeList.FDQuery.RecordCount > 0) then
  begin
    if not DM2.qTreeList.IsRootFocused and not FCategoryPath.IsEmpty then
    begin
      S := MinimizeName(FCategoryPath, Canvas, Width - 200);
      S := S.Trim(['\']).Replace('\', '-');

    end
    else
      S := DM2.qTreeList.Value.AsString;

    AFS.DecimalSeparator := '.';
    Caption := Format('%s %0.1f - %s',
      [sMainFormCaption, ProgramVersion, S], AFS);
  end;
end;

procedure TfrmMain.ViewComponentsactOpenDatasheetExecute(Sender: TObject);
begin
  ComponentsFrame.ViewComponents.actOpenDatasheetExecute(Sender);
end;

end.
