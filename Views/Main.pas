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
  StoreHouseInfoView, ComponentsTabSheetView, ProductsTabSheetView;

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
    pmLeftStoreHouse: TPopupMenu;
    actAddStorehouse: TAction;
    actDeleteStorehouse: TAction;
    actRenameStorehouse: TAction;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    procedure actAddStorehouseExecute(Sender: TObject);
    procedure actAddTreeNodeExecute(Sender: TObject);
    procedure actDeleteStorehouseExecute(Sender: TObject);
    procedure actDeleteStorehouseUpdate(Sender: TObject);
    procedure actDeleteTreeNodeExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actExportTreeToExcelDocumentExecute(Sender: TObject);
    procedure actLoadTreeFromExcelDocumentExecute(Sender: TObject);
    procedure actRenameStorehouseExecute(Sender: TObject);
    procedure actRenameStorehouseUpdate(Sender: TObject);
    procedure actRenameTreeNodeExecute(Sender: TObject);
    procedure actSaveAllExecute(Sender: TObject);
    procedure actSelectDataBasePathExecute(Sender: TObject);
    procedure actShowBodyTypes2Execute(Sender: TObject);
    procedure actShowBodyTypes3Execute(Sender: TObject);
    procedure actShowDescriptionsExecute(Sender: TObject);
    procedure actShowProducersExecute(Sender: TObject);
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
  ParametersForm, SettingsController, ReportsForm, ReportQuery,
  ParametricExcelDataModule, ParametricTableForm, BodyTypesForm, ProjectConst,
  PathSettingsForm, ImportErrorForm, ErrorForm, cxGridDBBandedTableView,
  System.IOUtils, ImportProcessForm, ProgressInfo, ProgressBarForm,
  Vcl.FileCtrl, SearchDescriptionsQuery, TableWithProgress, GridViewForm,
  TreeListQuery, AutoBindingDocForm, AutoBindingDescriptionForm,
  FireDAC.Comp.Client, AutoBinding, AllFamilyQuery, ProducersForm,
  ProductsBaseQuery, DescriptionsGroupUnit, RecursiveTreeView,
  RecursiveTreeQuery, TreeExcelDataModule, BindDocUnit, DialogUnit2,
  LoadFromExcelFileHelper, SearchCategoryQuery;

{$R *.dfm}

constructor TfrmMain.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FQuerySearchCategoriesPath := TQuerySearchCategoriesPath.Create(Self);
end;

procedure TfrmMain.actAddStorehouseExecute(Sender: TObject);
var
  Value: string;
begin
  DM2.ProductGroup.qStoreHouseList.TryPost;

  Value := InputBox(sDatabase, sPleaseWrite, '');
  if Value <> '' then
  begin
    DM2.ProductGroup.qStoreHouseList.LocateOrAppend(Value);
    clStorehouseListTitle.ApplyBestFit();
  end;
end;

procedure TfrmMain.actAddTreeNodeExecute(Sender: TObject);
var
  Value: string;
begin
  DM2.qTreeList.TryPost;

  Value := InputBox(sDatabase, sPleaseWrite, '');

  if Value <> '' then
  begin
    DM2.qTreeList.FDQuery.DisableControls;
    try
      DM2.qTreeList.AddChildCategory(Value,
        GetLevel(dbtlCategories.FocusedNode));
    finally
      DM2.qTreeList.FDQuery.EnableControls;
    end;
  end;
end;

procedure TfrmMain.actDeleteStorehouseExecute(Sender: TObject);
begin
  DM2.ProductGroup.qStoreHouseList.TryPost;
  if DM2.ProductGroup.qStoreHouseList.FDQuery.RecordCount > 0 then
  begin
    if TDialog.Create.DeleteRecordsDialog(sDoYouWantToDelete) then
    begin
      DM2.ProductGroup.qStoreHouseList.FDQuery.Delete;
    end;
  end;
end;

procedure TfrmMain.actDeleteStorehouseUpdate(Sender: TObject);
begin
  actDeleteStorehouse.Enabled := tvStorehouseList.DataController.
    RecordCount > 0;
end;

procedure TfrmMain.actDeleteTreeNodeExecute(Sender: TObject);
begin
  DM2.qTreeList.TryPost;
  if TDialog.Create.DeleteRecordsDialog(sDoYouWantToDelete) then
  begin
    DM2.qTreeList.FDQuery.Delete;
    DM2.qTreeList.FDQuery.Refresh;
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

procedure TfrmMain.actLoadTreeFromExcelDocumentExecute(Sender: TObject);
var
  AFileName: string;
  AfrmGridView: TfrmGridView;
  AQueryRecursiveTree: TQueryRecursiveTree;
  // ATreeExcelDM: TTreeExcelDM;
  OK: Boolean;
begin
  if not TOpenExcelDialog.SelectInLastFolder(AFileName) then
    Exit;

  AQueryRecursiveTree := TQueryRecursiveTree.Create(Self);
  try
    AQueryRecursiveTree.RefreshQuery;
    TLoad.Create.LoadAndProcess(AFileName, TTreeExcelDM, TfrmError,
      procedure(ASender: TObject)
      begin
        AQueryRecursiveTree.LoadRecords(ASender as TTreeExcelTable);
      end);

    // �������� ����������� ���������
    AQueryRecursiveTree.HideNotAdded;
    // ���� ���� ���������, ������� ���� ���������
    if AQueryRecursiveTree.FDQuery.RecordCount > 0 then
    begin
      AfrmGridView := TfrmGridView.Create(Self);
      try
        AfrmGridView.Caption := '����������� ���������';
        AfrmGridView.DataSet := AQueryRecursiveTree.FDQuery;
        AfrmGridView.ShowModal;
      finally
        FreeAndNil(AfrmGridView);
      end;
    end;

    AQueryRecursiveTree.HideNotDeleted;
    // ���� ���� ���������, ������� ���� �������
    if AQueryRecursiveTree.FDQuery.RecordCount > 0 then
    begin
      AfrmGridView := TfrmGridView.Create(Self);
      try
        AfrmGridView.Caption := '�������� ���������';
        AfrmGridView.cxbtnOK.Caption := '�������';
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

  // ������������ ������ �� ��
  dbtlCategories.BeginUpdate;
  try
    DM2.qTreeList.RefreshQuery;
  finally
    dbtlCategories.EndUpdate;
    dbtlCategories.FocusedNode.Expand(False);
  end;
end;

procedure TfrmMain.actRenameStorehouseExecute(Sender: TObject);
var
  Value: string;
begin
  if tvStorehouseList.Controller.SelectedRecordCount > 0 then
  begin
    DM2.ProductGroup.qStoreHouseList.TryPost;
    Value := InputBox(sDatabase, sPleaseWrite,
      DM2.ProductGroup.qStoreHouseList.Title.AsString);
    if (Value <> '') then
    begin
      DM2.ProductGroup.qStoreHouseList.TryEdit;
      DM2.ProductGroup.qStoreHouseList.Title.AsString := Value;
      DM2.ProductGroup.qStoreHouseList.TryPost;
      clStorehouseListTitle.ApplyBestFit();
    end;
  end;
end;

procedure TfrmMain.actRenameStorehouseUpdate(Sender: TObject);
begin
  actRenameStorehouse.Enabled := tvStorehouseList.DataController.
    RecordCount > 0;
end;

procedure TfrmMain.actRenameTreeNodeExecute(Sender: TObject);
var
  Value: string;
begin
  DM2.qTreeList.TryPost;

  Value := InputBox(sDatabase, sPleaseWrite, DM2.qTreeList.Value.AsString);
  if (Value <> '') and
    (DM2.qTreeList.CheckPossibility(DM2.qTreeList.FDQuery.FieldByName('ParentId')
    .AsInteger, Value)) then
  begin
    DM2.qTreeList.TryEdit;
    DM2.qTreeList.Value.AsString := Value;
    DM2.qTreeList.TryPost;
  end;

end;

procedure TfrmMain.actSaveAllExecute(Sender: TObject);
begin
  DM2.SaveAll;
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

    // ���� ���� �� ���� ������ ���������
    if AOldDataBasePath <> ANewDataBasePath then
    begin
      dbtlCategories.BeginUpdate;
      try
        DM2.CreateOrOpenDataBase;
        // ������������ �������� �������
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
    frmParameters.ViewParameters.ParametersGroup := DM2.ParametersGroup;
  end;

  frmParameters.Show;

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

procedure TfrmMain.DoBeforeParametricTableFormClose(Sender: TObject);
begin
  // ���������� ������ � �������������
  frmParametricTable.ViewParametricTable.ComponentsExGroup := nil;

  // �������������, ��� ��� ������ �� ��������� ������ ����� �������
  DM2.ComponentsExGroup.DecClient;
  frmParametricTable := nil;
end;

procedure TfrmMain.DoOnComponentLocate(Sender: TObject);
var
  l: TList<String>;
begin
  // ������ � ���� ��������������, ������� �� ���������� ������ �� ������
  Assert(Sender <> nil);
  l := Sender as TList<String>;
  Assert(l.Count > 0);

  DM2.ProductSearchGroup.qProductsSearch.Search(l);

  // ������������� �� ������� ������
  cxpcLeft.ActivePage := cxtsStorehouses;
  // ������������� �� ������� ����� �� ������
  ProductsFrame.cxpcStorehouse.ActivePage := ProductsFrame.tsStorehouseSearch;

  BringToFront;
  ProductsFrame.ViewProductsSearch2.FocusValueColumn;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if DM2.HaveAnyChanges then
  begin
    case TDialog.Create.SaveDataDialog of
      IDYES:
        DM2.SaveAll;
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
//  Application.MessageBox('2', '�������');
  cxpcRight.Properties.HideTabs := True;
  cxpcLeft.ActivePage := cxtsComponents;
  ComponentsFrame.cxpcComponents.ActivePage := ComponentsFrame.cxtsCategory;
  ProductsFrame.cxpcStorehouse.ActivePage := ProductsFrame.tsStorehouseProducts;

  // ������ ������ �����������
  if DMRepository = nil then
    DMRepository := TDMRepository.Create(Self);
  Application.MessageBox('3', '�������');
  Assert(not DMRepository.dbConnection.Connected);
  Assert(DM2 = nil);
  // ���� ������ ������ ������
  DM2 := TDM2.Create(Self);
  Application.MessageBox('20', '�������');

  Assert(not DMRepository.dbConnection.Connected);

  inherited;

  Self.WindowState := wsNormal;

  // ������������� �� �������
  FEventList := TObjectList.Create;

  // ��������� ��� ���� �� ���� ������ ����������
  OK := CheckDataBasePath;
  Application.MessageBox('21', '�������');
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
      // ������������� ����� ������ ��������� �� �������
      TNotifyEventWrap.Create(DM2.ComponentsExGroup.qComponentsEx.OnLocate,
        DoOnComponentLocate);

      // ������������� ����� ������ ��������� � ��������������� �������
      TNotifyEventWrap.Create(DM2.ProductGroup.qProducts.OnLocate,
        DoOnProductLocate);
      TNotifyEventWrap.Create(DM2.ProductSearchGroup.qProductsSearch.OnLocate,
        DoOnProductLocate);

      // ����������� ������������� � ������
      ComponentsFrame.ViewComponents.ComponentsGroup := DM2.ComponentsGroup;

      // ������������� �� ������� � ����������� ��������������� �������
      TNotifyEventWrap.Create
        (ComponentsFrame.ViewComponents.OnShowParametricTableEvent,
        DoOnShowParametricTable, FEventList);

      ComponentsFrame.ViewComponentsSearch.ComponentsSearchGroup :=
        DM2.ComponentsSearchGroup;

      // ��������� � ���� ������
      ComponentsFrame.ViewCategoryParameters.QueryCategoryParameters :=
        DM2.qCategoryParameters;

      ComponentsFrame.ViewParametricTable.ComponentsExGroup :=
        DM2.ComponentsExGroup;

      // ����������� ������ ������� � ������
      tvStorehouseList.DataController.DataSource :=
        DM2.ProductGroup.qStoreHouseList.DataSource;
      clStorehouseListTitle.ApplyBestFit();
      // ����������� ���������� � ������ � ������
      ProductsFrame.ViewStorehouseInfo.QueryStoreHouseList :=
        DM2.ProductGroup.qStoreHouseList;
      // ����������� ������� ����� � ������
      ProductsFrame.ViewProducts2.ProductGroup := DM2.ProductGroup;
      // ����������� ����� �� ������� � ������
      ProductsFrame.ViewProductsSearch2.ProductSearchGroup :=
        DM2.ProductSearchGroup;

      // ViewStoreHouse.StoreHouseGroup := DM2.StoreHouseGroup;
      // ViewStoreHouse.QueryProductsSearch := DM2.qProductsSearch;

      // ����������� ������ ��������� � ������
      dbtlCategories.DataController.DataSource := DM2.qTreeList.DataSource;

      // ����������� ������������ � ������ (�������������� ������)
      ComponentsFrame.tvFunctionalGroup.DataController.DataSource :=
        DM2.qChildCategories.DataSource;

      FOnProductCategoriesChange := TNotifyEventWrap.Create
        (DM2.qTreeList.AfterScroll, DoOnProductCategoriesChange, FEventList);

      // ������������ �������� �������
      DoOnProductCategoriesChange(nil);

    end;
  end;

  if not OK then
  begin
    Application.ShowMainForm := False;
    Application.Terminate; // ��������� ������ ����������
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

    // ������ ���� � ��������������� ��������
    frmParametricTable := TfrmParametricTable.Create(Self);
    frmParametricTable.CategoryPath := ACategoryPath;

    // ������������� �� ������� ����� ��������� ����
    TNotifyEventWrap.Create(frmParametricTable.BeforeClose,
      DoBeforeParametricTableFormClose, FEventList);

    // ����������� ������ � �������������
    frmParametricTable.ViewParametricTable.ComponentsExGroup :=
      DM2.ComponentsExGroup;

    // �������������, ��� ��� ����������� ������ ����� �������
    DM2.ComponentsExGroup.AddClient;
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
  /// todo: ��������� ��� ���������� ���������
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
  // ��� ��������� ��������� ��� ������ �� ������ ������ ��� ����
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
      DM2.qTreeList.LocateToRoot;
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
      if DM2.qTreeList.
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
  // ������ ������������ ������� "����������"
  cxpcRight.ActivePage := cxtsRComponents;
end;

procedure TfrmMain.cxtsStorehousesShow(Sender: TObject);
begin
  // ������ ������������ ������� "������"
  cxpcRight.ActivePage := cxtsRStorehouses;
end;

procedure TfrmMain.UpdateCaption;
var
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

    Caption := Format('%s - %s', [sMainFormCaption, S]);
  end;
end;

procedure TfrmMain.ViewComponentsactOpenDatasheetExecute(Sender: TObject);
begin
  ComponentsFrame.ViewComponents.actOpenDatasheetExecute(Sender);
end;

end.
