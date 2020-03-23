unit DataModule;

interface

uses
  System.Classes, System.Contnrs, BaseQuery, System.Generics.Collections,
  TreeListQuery, BodyTypesGroupUnit2, NotifyEvents, VersionQuery,
  ProducersGroupUnit2, ProductsSearchQuery, StoreHouseListQuery,
  ComponentsSearchGroupUnit2, CategoryParametersGroupUnit2,
  ChildCategoriesQuery, ProductsQuery, ComponentsExGroupUnit2,
  ComponentsGroupUnit2, ParametersGroupUnit2, DescriptionsGroupUnit2,
  SubParametersQuery2, ExtraChargeGroupUnit, BillQuery, BillContentQuerySimple,
  ProductsBaseQuery, ExcelDataModule, ParametricErrorTable,
  SearchParameterQuery, ParamSubParamsQuery, SearchParamDefSubParamQuery,
  FieldInfoUnit, SearchCategoryQuery, SearchDaughterCategoriesQuery,
  BillInterface, BillContentQry, ProductsSearchViewModel, ProductsViewModel,
  BillContentViewModel;

type
  TLoadExcelFileHeaderResult = (ID_OK, ID_Cancel, ID_ParametricTableNotFound,
    ID_NoParameterForLoad);

  // ������ �� ����� �������������� ������ �������
  TShowErrorDialogRef = reference to function(AParametricErrorTable
    : TParametricErrorTable): Boolean;

  TDM = class(TObject)
  private
    class var Instance: TDM;

  var
    FAfterAddBill: TNotifyEventsEx;
    FBillContentViewModel: TBillContentViewModel;
    FBodyTypesGroup: TBodyTypesGroup2;
    FCategoryParametersGroup: TCategoryParametersGroup2;
    FComponent: TComponent;
    FComponentsExGroup: TComponentsExGroup2;
    FComponentsGroup: TComponentsGroup2;
    FComponentsSearchGroup: TComponentsSearchGroup2;
    FDescriptionsGroup: TDescriptionsGroup2;
    FEventList: TObjectList;
    FExtraChargeGroup: TExtraChargeGroup;
    FParametersGroup: TParametersGroup2;
    FProducersGroup: TProducersGroup2;
    FProductsBasketViewModel: TProductsViewModel;
    FProductsSearchViewModel: TProductsSearchViewModel;
    FProductsViewModel: TProductsViewModel;
    FqBillContentSimple: TQueryBillContentSimple;
    FqChildCategories: TQueryChildCategories;
    FqBill: TQryBill;
    FqParamSubParams: TQueryParamSubParams;
    FqSearchCategory: TQuerySearchCategory;
    FqSearchDaughterCategories: TQuerySearchDaughterCategories;
    FqSearchParamDefSubParam: TQuerySearchParamDefSubParam;
    FqSearchParameter: TQuerySearchParameter;
    FqStoreHouseList: TQueryStoreHouseList;
    FqSubParameters: TQuerySubParameters2;
    FqTreeList: TQueryTreeList;
    FqVersion: TQueryVersion;
    FRefreshQList: TList;
    procedure DoAfterBillContentApplyUpdates(Sender: TObject);
    procedure DoAfterProducerCommit(Sender: TObject);
    procedure DoAfterStoreHousePost(Sender: TObject);
    procedure DoBeforeBasketApplyUpdates(Sender: TObject);
    procedure DoBeforeRepDMDestroy(Sender: TObject);
    procedure DoBeforeProductsApplyUpdates(Sender: TObject);
    procedure DoBeforeProductsSearchApplyUpdates(Sender: TObject);
    procedure DoOnCategoryParametersApplyUpdates(Sender: TObject);
    procedure DoOnParamOrderChange(Sender: TObject);
    function GetAfterAddBill: TNotifyEventsEx;
    function GetBillContentViewModel: TBillContentViewModel;
    function GetBodyTypesGroup: TBodyTypesGroup2;
    function GetCategoryParametersGroup: TCategoryParametersGroup2;
    function GetComponentsExGroup: TComponentsExGroup2;
    function GetComponentsGroup: TComponentsGroup2;
    function GetComponentsSearchGroup: TComponentsSearchGroup2;
    function GetDescriptionsGroup: TDescriptionsGroup2;
    function GetExtraChargeGroup: TExtraChargeGroup;
    function GetNFFieldName(AStringTreeNodeID: Integer): string;
    function GetParametersGroup: TParametersGroup2;
    function GetProducersGroup: TProducersGroup2;
    function GetProductsBasketViewModel: TProductsViewModel;
    function GetProductsSearchViewModel: TProductsSearchViewModel;
    function GetProductsViewModel: TProductsViewModel;
    function GetqBillContentSimple: TQueryBillContentSimple;
    function GetqChildCategories: TQueryChildCategories;
    function GetqBill: TQryBill;
    function GetqParamSubParams: TQueryParamSubParams;
    function GetqSearchCategory: TQuerySearchCategory;
    function GetqSearchDaughterCategories: TQuerySearchDaughterCategories;
    function GetqSearchParamDefSubParam: TQuerySearchParamDefSubParam;
    function GetqSearchParameter: TQuerySearchParameter;
    function GetqStoreHouseList: TQueryStoreHouseList;
    function GetqSubParameters: TQuerySubParameters2;
    function GetqTreeList: TQueryTreeList;
    function GetqVersion: TQueryVersion;
    function InternalLoadExcelFileHeaderEx(ARootTreeNode: TStringTreeNode;
      AParametricErrorTable: TParametricErrorTable): TArray<Integer>;
  protected
    procedure DoAfterChildCategoriesPostOrDelete(Sender: TObject);
    procedure DoAfterCommit(Sender: TObject);
    procedure DoAfterTreeListFirstOpen(Sender: TObject);
    procedure DoBeforeCommit(Sender: TObject);
    property qParamSubParams: TQueryParamSubParams read GetqParamSubParams;
    property qSearchParamDefSubParam: TQuerySearchParamDefSubParam
      read GetqSearchParamDefSubParam;
    property qSearchParameter: TQuerySearchParameter read GetqSearchParameter;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddBill(AQryProducts: TQueryProductsBase; ABillInt: IBill);
    class function Created: Boolean;
    function LoadExcelFileHeader(ARootTreeNode: TStringTreeNode;
      AFieldsInfo: TFieldsInfo; AShowErrorDialogRef: TShowErrorDialogRef)
      : TLoadExcelFileHeaderResult;
    class function NewInstance: TObject; override;
    property AfterAddBill: TNotifyEventsEx read GetAfterAddBill;
    property BillContentViewModel: TBillContentViewModel
      read GetBillContentViewModel;
    property BodyTypesGroup: TBodyTypesGroup2 read GetBodyTypesGroup;
    property CategoryParametersGroup: TCategoryParametersGroup2
      read GetCategoryParametersGroup;
    property ComponentsExGroup: TComponentsExGroup2 read GetComponentsExGroup;
    property ComponentsGroup: TComponentsGroup2 read GetComponentsGroup;
    property ComponentsSearchGroup: TComponentsSearchGroup2
      read GetComponentsSearchGroup;
    property DescriptionsGroup: TDescriptionsGroup2 read GetDescriptionsGroup;
    property ExtraChargeGroup: TExtraChargeGroup read GetExtraChargeGroup;
    property ParametersGroup: TParametersGroup2 read GetParametersGroup;
    property ProducersGroup: TProducersGroup2 read GetProducersGroup;
    property ProductsBasketViewModel: TProductsViewModel
      read GetProductsBasketViewModel;
    property ProductsSearchViewModel: TProductsSearchViewModel
      read GetProductsSearchViewModel;
    property ProductsViewModel: TProductsViewModel read GetProductsViewModel;
    property qBillContentSimple: TQueryBillContentSimple
      read GetqBillContentSimple;
    property qChildCategories: TQueryChildCategories read GetqChildCategories;
    property qBill: TQryBill read GetqBill;
    property qSearchCategory: TQuerySearchCategory read GetqSearchCategory;
    property qSearchDaughterCategories: TQuerySearchDaughterCategories
      read GetqSearchDaughterCategories;
    property qStoreHouseList: TQueryStoreHouseList read GetqStoreHouseList;
    property qSubParameters: TQuerySubParameters2 read GetqSubParameters;
    property qTreeList: TQueryTreeList read GetqTreeList;
    property qVersion: TQueryVersion read GetqVersion;
  end;

implementation

uses
  RepositoryDataModule, SettingsController, System.SysUtils, System.IOUtils,
  ProjectConst, FireDAC.Comp.Client, FireDAC.Comp.DataSet,
  SearchInterfaceUnit, ClearStorehouseProductsQuery, StrHelper,
  ParametricExcelDataModule, DefaultParameters, System.Types, InsertEditMode,
  System.Math;

var
  SingletonList: TObjectList;

constructor TDM.Create;
begin
  // ���� ������������� ��� ���������
  if FComponent <> nil then
    Exit;

  FComponent := TComponent.Create(nil);

  TNotifyEventWrap.Create(DMRepository.BeforeDestroy, DoBeforeRepDMDestroy,
    FEventList);

  FEventList := TObjectList.Create;
  FRefreshQList := TList.Create;

  Assert(not qTreeList.FDQuery.Active);
  TNotifyEventWrap.Create(qTreeList.W.AfterOpen, DoAfterTreeListFirstOpen,
    FEventList);

  // ��������� ������� ���������� �������-����������
  qChildCategories.Master := qTreeList;
  CategoryParametersGroup.qCategoryParameters.Master := qTreeList;
  // ������� ������� ����������, ����� ��� ���������� ��������� ����� ������� � ���� ���������
  ComponentsGroup.qComponents.Master := qTreeList;
  ComponentsGroup.qFamily.Master := qTreeList;
  // ������� ������� ����������, ����� ��� ���������� ��������� ����� ������� � ���� ���������
  ComponentsExGroup.qComponentsEx.Master := qTreeList;
  ComponentsExGroup.qFamilyEx.Master := qTreeList;

  // qBillContent.Master := qBill;

  // ��� �������������� �������� ��������� ����� ����� ��������� ������
  TNotifyEventWrap.Create(qChildCategories.W.AfterPostM,
    DoAfterChildCategoriesPostOrDelete, FEventList);
  TNotifyEventWrap.Create(qChildCategories.W.AfterDelete,
    DoAfterChildCategoriesPostOrDelete, FEventList);

  TNotifyEventWrap.Create(DMRepository.BeforeCommit, DoBeforeCommit,
    FEventList);

  TNotifyEventWrap.Create(DMRepository.AfterCommit, DoAfterCommit, FEventList);

  TNotifyEventWrap.Create(CategoryParametersGroup.qCategoryParameters.
    On_ApplyUpdates, DoOnCategoryParametersApplyUpdates, FEventList);

  // ����� ������������� � ��������� �� ������ ����������� ������ � �����������
  // ����������� ��������������
  TNotifyEventWrap.Create(ProducersGroup.qProducers.AfterCommit,
    DoAfterProducerCommit, FEventList);

  // ����� ���������� ������ ������� ���������� ������ �� ������� �������
  TNotifyEventWrap.Create(qStoreHouseList.W.AfterPostM, DoAfterStoreHousePost,
    FEventList);

  // ����� ��� �������������� ������ � ��������������� ������� ������� ������� ����������
  TNotifyEventWrap.Create(ComponentsExGroup.OnParamOrderChange,
    DoOnParamOrderChange, FEventList);
end;

destructor TDM.Destroy;
begin
  FreeAndNil(FComponent);

  FreeAndNil(FEventList);
  FreeAndNil(FRefreshQList);
  inherited;
end;

procedure TDM.AddBill(AQryProducts: TQueryProductsBase; ABillInt: IBill);
var
  ABillID: Integer;
  AStoreHouseProductID: Integer;
begin
  Assert(AQryProducts <> nil);
  Assert(AQryProducts.BasketW <> nil);

  qBill.W.TryOpen;

  // ��������� ����� ����
  ABillID := qBill.W.Save(InsertMode, ABillInt);
  try
    AQryProducts.BasketW.DataSet.DisableControls;
    try
      AQryProducts.BasketW.DataSet.First;
      while not AQryProducts.BasketW.DataSet.Eof do
      begin
        // �� ������ ������ ���� ����������� ���������� ������
        AQryProducts.BasketW.CheckSaleCount;

        // ������������� ����� �����-����� � ��� �������������
        AStoreHouseProductID := AQryProducts.BasketW.GetStorehouseProductID
          (AQryProducts.BasketW.ID.F.AsInteger);

        // ��������� ����� � �����
        qBillContentSimple.W.AddContent(ABillID, AStoreHouseProductID,
          AQryProducts.BasketW.SaleCount.F.Value,
          AQryProducts.BasketW.CalcPriceR.F.Value,
          AQryProducts.BasketW.Retail.F.Value,
          ifThen(AQryProducts.BasketW.WholeSale.F.AsFloat > 0,
          AQryProducts.BasketW.WholeSale.F.AsFloat,
          AQryProducts.BasketW.MinWholeSale.F.AsFloat),
          AQryProducts.BasketW.Markup.F.Value);

        // ��� ����� �������� �� ������� !!!
        AQryProducts.BasketW.SetSaleCount(0);

        AQryProducts.BasketW.DataSet.First;
      end;
    finally
      AQryProducts.BasketW.DataSet.EnableControls;
    end;
    AQryProducts.ApplyUpdates;

    // ������ ������� ��������� ������
    BillContentViewModel.qBillContent.LoadContent(ABillID);

    // ���� ��� �������� ����� ���� ������� ���� ��������
    if ABillInt.ShipmentDate > 0 then
    begin
      // ������ ���� �������� � ��������� ��������
      qBill.W.Save(EditMode, ABillInt);
    end;

    // �������� ����, ��� ���� ��� ��������
    AfterAddBill.CallEventHandlers(Self);
  except
    // ������� ����������� ����
    qBill.W.LocateByPKAndDelete(ABillID);
    raise;
  end;

end;

class function TDM.Created: Boolean;
begin
  Result := SingletonList.Count > 0;
end;

procedure TDM.DoAfterBillContentApplyUpdates(Sender: TObject);
var
  AList: TList<TQueryProductsBase>;
begin
  AList := TList<TQueryProductsBase>.Create;
  try

    if (FProductsViewModel <> nil) and
      (ProductsViewModel.qProducts.FDQuery.Active) then
      AList.Add(ProductsViewModel.qProducts);

    if (FProductsSearchViewModel <> nil) and
      (ProductsSearchViewModel.qProductsSearch.FDQuery.Active) then
      AList.Add(ProductsSearchViewModel.qProductsSearch);

    // ��������� ���������� ������ � ������ ������� ������
    if AList.Count > 0 then
      TQueryProductsBase.UpdateAmount(BillContentViewModel.qBillContent,
        AList.ToArray);
  finally
    FreeAndNil(AList);
  end;
end;

procedure TDM.DoAfterChildCategoriesPostOrDelete(Sender: TObject);
begin
  // ��������� ������ � ���������� AfterScroll
  qTreeList.W.SmartRefresh;
end;

procedure TDM.DoAfterCommit(Sender: TObject);
var
  I: Integer;
begin
  if FRefreshQList.Count = 0 then
    Exit;

  I := FRefreshQList.IndexOf(ParametersGroup);
  if I >= 0 then
  begin
    CategoryParametersGroup.qCategoryParameters.W.SmartRefresh;
    FRefreshQList.Delete(I);
  end;

  I := FRefreshQList.IndexOf(ComponentsGroup);
  if I >= 0 then
  begin
    ComponentsExGroup.TryRefresh;
    FRefreshQList.Delete(I);
  end;

  Assert(FRefreshQList.Count = 0);
end;

procedure TDM.DoAfterProducerCommit(Sender: TObject);
begin
  // ��������� ������ � ����������� ��������������

  // ������ �������� ������ � �������������� � ������ ������
  if FProductsSearchViewModel <> nil then
    ProductsSearchViewModel.ProducersGroup.ReOpen;

  if FProductsViewModel <> nil then
    ProductsViewModel.ProducersGroup.ReOpen;

  if FDescriptionsGroup <> nil then
    DescriptionsGroup.qProducers.W.RefreshQuery;

  if FComponentsGroup <> nil then
    FComponentsGroup.Producers.W.RefreshQuery;

  if FComponentsSearchGroup <> nil then
    ComponentsSearchGroup.Producers.W.RefreshQuery;
end;

procedure TDM.DoAfterStoreHousePost(Sender: TObject);
begin
  // ��������� ���������� �������
  // ��������� ���������� ������ �������
  ProductsSearchViewModel.qStoreHouseList.W.RefreshQuery;
end;

procedure TDM.DoAfterTreeListFirstOpen(Sender: TObject);
var
  ACategoryID: Integer;
begin
  Assert(qTreeList.FDQuery.Active);

  ACategoryID := TSettings.Create.CategoryID;
  // ���� � ���������� �� ����������� ��������� �������� ���������
  // ���� ��������� �������� ��������� ���������
  if (ACategoryID = 0) or (not TSettings.Create.LoadLastCategory) then
    Exit;

  // �������� ������� �� ��-�� ������
  qTreeList.W.LocateByPK(ACategoryID);
end;

procedure TDM.DoBeforeBasketApplyUpdates(Sender: TObject);
var
  AList: TList<TQueryProductsBase>;
begin
  AList := TList<TQueryProductsBase>.Create;
  try

    if (FProductsViewModel <> nil) and
      (FProductsViewModel.qProducts.FDQuery.Active) then
      AList.Add(FProductsViewModel.qProducts);

    if (ProductsSearchViewModel <> nil) and
      (ProductsSearchViewModel.qProductsSearch.FDQuery.Active) then
      AList.Add(ProductsSearchViewModel.qProductsSearch);

    // ��������� ������� ������ ������� ������
    if AList.Count > 0 then
      TQueryProductsBase.UpdateSaleCount(ProductsBasketViewModel.qProducts,
        AList.ToArray);
  finally
    FreeAndNil(AList);
  end;
end;

procedure TDM.DoBeforeCommit(Sender: TObject);
begin
  // ��������� ��������� � ���������� - ���� �������� ��������� ��� ���������
  if ParametersGroup.HaveAnyChanges then
    FRefreshQList.Add(ParametersGroup);

  // ��������� ��������� � ������� �����������
  // ����� ��������� ��������������� �������
  if ComponentsGroup.HaveAnyChanges then
    FRefreshQList.Add(ComponentsGroup);
end;

procedure TDM.DoBeforeRepDMDestroy(Sender: TObject);
begin
  if not DMRepository.dbConnection.Connected then
    Exit;
  // ������ ������� ��������� ����� ������
  TQryClearStoreHouseProducts.ExecSQL;

  if qTreeList.FDQuery.RecordCount = 0 then
    Exit;

  TSettings.Create.CategoryID := qTreeList.W.PK.AsInteger;
end;

procedure TDM.DoBeforeProductsApplyUpdates(Sender: TObject);
begin
  if (FProductsSearchViewModel <> nil) and
    (FProductsSearchViewModel.qProductsSearch.FDQuery.Active) then
    // ��������� ������� ������ ������� ������
    TQueryProductsBase.UpdateSaleCount(ProductsViewModel.qProducts,
      [ProductsSearchViewModel.qProductsSearch]);
end;

procedure TDM.DoBeforeProductsSearchApplyUpdates(Sender: TObject);
begin
  if (FProductsViewModel <> nil) and
    (FProductsViewModel.qProducts.FDQuery.Active) and
    (FProductsSearchViewModel.qProductsSearch.ProductSearchW.Mode = RecordsMode)
  then
    // ��������� ������� ������ ������� ������
    TQueryProductsBase.UpdateSaleCount(FProductsSearchViewModel.qProductsSearch,
      [FProductsViewModel.qProducts]);
end;

procedure TDM.DoOnCategoryParametersApplyUpdates(Sender: TObject);
begin
  // ��������� ��������� � ������� ���������� ��� ���������
  // ����� ��������� ��������������� �������
  ComponentsExGroup.TryRefresh;
end;

procedure TDM.DoOnParamOrderChange(Sender: TObject);
begin
  CategoryParametersGroup.RefreshData;
end;

function TDM.GetAfterAddBill: TNotifyEventsEx;
begin
  if FAfterAddBill = nil then
    FAfterAddBill := TNotifyEventsEx.Create(Self);

  Result := FAfterAddBill;
end;

function TDM.GetBillContentViewModel: TBillContentViewModel;
begin
  if FBillContentViewModel = nil then
  begin
    FBillContentViewModel := TBillContentViewModel.Create(FComponent);
    TNotifyEventWrap.Create
      (FBillContentViewModel.qBillContent.AfterApplyUpdates,
      DoAfterBillContentApplyUpdates, FEventList);
  end;

  Result := FBillContentViewModel;
end;

function TDM.GetBodyTypesGroup: TBodyTypesGroup2;
begin
  if FBodyTypesGroup = nil then
  begin
    Assert(FComponent <> nil);
    FBodyTypesGroup := TBodyTypesGroup2.Create(FComponent);
  end;

  Result := FBodyTypesGroup;
end;

function TDM.GetCategoryParametersGroup: TCategoryParametersGroup2;
begin
  if FCategoryParametersGroup = nil then
    FCategoryParametersGroup := TCategoryParametersGroup2.Create(FComponent);

  Result := FCategoryParametersGroup;
end;

function TDM.GetComponentsExGroup: TComponentsExGroup2;
begin
  if FComponentsExGroup = nil then
    FComponentsExGroup := TComponentsExGroup2.Create(FComponent);

  Result := FComponentsExGroup;
end;

function TDM.GetComponentsGroup: TComponentsGroup2;
begin
  if FComponentsGroup = nil then
    FComponentsGroup := TComponentsGroup2.Create(FComponent);

  Result := FComponentsGroup;
end;

function TDM.GetComponentsSearchGroup: TComponentsSearchGroup2;
begin
  if FComponentsSearchGroup = nil then
    FComponentsSearchGroup := TComponentsSearchGroup2.Create(FComponent);

  Result := FComponentsSearchGroup;
end;

function TDM.GetDescriptionsGroup: TDescriptionsGroup2;
begin
  if FDescriptionsGroup = nil then
    FDescriptionsGroup := TDescriptionsGroup2.Create(FComponent);

  Result := FDescriptionsGroup;
end;

function TDM.GetExtraChargeGroup: TExtraChargeGroup;
begin
  if FExtraChargeGroup = nil then
    FExtraChargeGroup := TExtraChargeGroup.Create(FComponent);

  Result := FExtraChargeGroup;
end;

function TDM.GetNFFieldName(AStringTreeNodeID: Integer): string;
begin
  Assert(AStringTreeNodeID > 0);
  Result := Format('NotFoundParam%d', [AStringTreeNodeID]);
end;

function TDM.GetParametersGroup: TParametersGroup2;
begin
  if FParametersGroup = nil then
    FParametersGroup := TParametersGroup2.Create(FComponent);

  Result := FParametersGroup;
end;

function TDM.GetProducersGroup: TProducersGroup2;
begin
  if FProducersGroup = nil then
    FProducersGroup := TProducersGroup2.Create(FComponent);
  Result := FProducersGroup;
end;

function TDM.GetProductsBasketViewModel: TProductsViewModel;
begin
  if FProductsBasketViewModel = nil then
  begin
    FProductsBasketViewModel := TProductsViewModel.Create(FComponent);
    TNotifyEventWrap.Create
      (FProductsBasketViewModel.qProducts.BeforeApplyUpdates,
      DoBeforeBasketApplyUpdates, FEventList);
  end;

  Result := FProductsBasketViewModel;
end;

function TDM.GetProductsSearchViewModel: TProductsSearchViewModel;
begin
  if FProductsSearchViewModel = nil then
  begin
    FProductsSearchViewModel := TProductsSearchViewModel.Create(FComponent);
    TNotifyEventWrap.Create(FProductsSearchViewModel.qProductsSearch.
      BeforeApplyUpdates, DoBeforeProductsSearchApplyUpdates);
  end;

  Result := FProductsSearchViewModel;
end;

function TDM.GetProductsViewModel: TProductsViewModel;
begin
  if FProductsViewModel = nil then
  begin
    FProductsViewModel := TProductsViewModel.Create(FComponent);
    TNotifyEventWrap.Create(FProductsViewModel.qProducts.BeforeApplyUpdates,
      DoBeforeProductsApplyUpdates, FEventList);

  end;

  Result := FProductsViewModel;
end;

function TDM.GetqBillContentSimple: TQueryBillContentSimple;
begin
  if FqBillContentSimple = nil then
  begin
    FqBillContentSimple := TQueryBillContentSimple.Create(FComponent);
    FqBillContentSimple.FDQuery.Open;
  end;

  Result := FqBillContentSimple;
end;

function TDM.GetqChildCategories: TQueryChildCategories;
begin
  if FqChildCategories = nil then
    FqChildCategories := TQueryChildCategories.Create(FComponent);

  Result := FqChildCategories;
end;

function TDM.GetqBill: TQryBill;
begin
  if FqBill = nil then
  begin
    FqBill := TQryBill.Create(FComponent);
    FqBill.W.BillContent := BillContentViewModel.qBillContent;
  end;

  Result := FqBill;
end;

function TDM.GetqParamSubParams: TQueryParamSubParams;
begin
  if FqParamSubParams = nil then
    FqParamSubParams := TQueryParamSubParams.Create(FComponent);

  Result := FqParamSubParams;
end;

function TDM.GetqSearchCategory: TQuerySearchCategory;
begin
  if FqSearchCategory = nil then
    FqSearchCategory := TQuerySearchCategory.Create(FComponent);

  Result := FqSearchCategory;
end;

function TDM.GetqSearchDaughterCategories: TQuerySearchDaughterCategories;
begin
  if FqSearchDaughterCategories = nil then
    FqSearchDaughterCategories := TQuerySearchDaughterCategories.Create
      (FComponent);

  Result := FqSearchDaughterCategories;
end;

function TDM.GetqSearchParamDefSubParam: TQuerySearchParamDefSubParam;
begin
  if FqSearchParamDefSubParam = nil then
    FqSearchParamDefSubParam := TQuerySearchParamDefSubParam.Create(FComponent);

  Result := FqSearchParamDefSubParam;
end;

function TDM.GetqSearchParameter: TQuerySearchParameter;
begin
  if FqSearchParameter = nil then
    FqSearchParameter := TQuerySearchParameter.Create(FComponent);

  Result := FqSearchParameter;
end;

function TDM.GetqStoreHouseList: TQueryStoreHouseList;
begin
  if FqStoreHouseList = nil then
  begin
    FqStoreHouseList := TQueryStoreHouseList.Create(FComponent);
    FqStoreHouseList.W.ProductsInt := ProductsViewModel;
  end;
  Result := FqStoreHouseList;
end;

function TDM.GetqSubParameters: TQuerySubParameters2;
begin
  if FqSubParameters = nil then
    FqSubParameters := TQuerySubParameters2.Create(FComponent);
  Result := FqSubParameters;
end;

function TDM.GetqTreeList: TQueryTreeList;
begin
  if FqTreeList = nil then
    FqTreeList := TQueryTreeList.Create(FComponent);
  Result := FqTreeList;
end;

function TDM.GetqVersion: TQueryVersion;
begin
  if FqVersion = nil then
    FqVersion := TQueryVersion.Create(FComponent);

  Result := FqVersion;
end;

function TDM.LoadExcelFileHeader(ARootTreeNode: TStringTreeNode;
  AFieldsInfo: TFieldsInfo; AShowErrorDialogRef: TShowErrorDialogRef)
  : TLoadExcelFileHeaderResult;
var
  AFieldName: string;
  AParametricErrorTable: TParametricErrorTable;
  OK: Boolean;
  AIDArray: TArray<Integer>;
  AID: Integer;
  rc: Integer;
begin
  Assert(AFieldsInfo <> nil);

  // �������� ����� excel �����
  AParametricErrorTable := TParametricErrorTable.Create(nil);
  try
    AIDArray := InternalLoadExcelFileHeaderEx(ARootTreeNode,
      AParametricErrorTable);

    if Length(AIDArray) = 0 then
    begin
      Result := ID_ParametricTableNotFound;
      Exit;
    end;

    // ���� ���� ���������� ������
    if AParametricErrorTable.RecordCount > 0 then
    begin
      // ���� ���������� ������ �������������
      repeat
        // �������, ������� ������ �� ��������
        rc := AParametricErrorTable.RecordCount;

        // �������� �� ������, ��� ��� ���������
        AParametricErrorTable.W.FilterFixed;

        if not AShowErrorDialogRef(AParametricErrorTable) then
        begin
          Result := ID_Cancel;
          Exit;
        end;

        {
          OK := ShowErrorForm(AParametricErrorTable);
          // ���� ���������� �� ��������
          if not OK then
          Exit;
        }
        // ����� ��������� ��� ������
        AParametricErrorTable.Filtered := False;

        AIDArray := InternalLoadExcelFileHeaderEx(ARootTreeNode,
          AParametricErrorTable);

      until AParametricErrorTable.RecordCount = rc;
    end;
  finally
    FreeAndNil(AParametricErrorTable);
  end;

  OK := False;
  // ��� ���� ��������� ����� ������ �� ��������
  for AID in AIDArray do
  begin
    // ���� ���� ������� � �������
    if AID < 0 then
      AFieldName := GetNFFieldName(-AID)
    else
    begin
      AFieldName := TParametricExcelTable.GetFieldNameByParamSubParamID(AID);
      OK := True;
    end;

    AFieldsInfo.Add(TFieldInfo.Create(AFieldName));
  end;

  if not OK then
    Result := ID_NoParameterForLoad
  else
    Result := ID_OK;
  {
    TDialog.Create.ErrorMessageDialog
    ('��� ����������, �������� ������� ����� ���������');

    Result := OK; }
end;

function TDM.InternalLoadExcelFileHeaderEx(ARootTreeNode: TStringTreeNode;
  AParametricErrorTable: TParametricErrorTable): TArray<Integer>;

  function ProcessParamSearhResult(ACount: Integer;
    AStringTreeNode: TStringTreeNode;
    AParametricErrorTable: TParametricErrorTable): Boolean;
  begin
    Result := True;
    if ACount = 1 then
      Exit;

    if ACount = 0 then
    begin
      AParametricErrorTable.W.AddErrorMessage(AStringTreeNode.Value,
        '�������� �� ������', petParamNotFound, AStringTreeNode.ID);
    end
    else
    begin
      AParametricErrorTable.W.AddErrorMessage(AStringTreeNode.Value,
        Format('�������� ������ � ����������� ���������� %d %s',
        [ACount, NameForm(ACount, '���', '����', '���')]), petParamDuplicate,
        AStringTreeNode.ID);
    end;

    Result := False;
  end;

  function ProcessSubParamSearhResult(ACount: Integer;
    AStringTreeNode: TStringTreeNode;
    AParametricErrorTable: TParametricErrorTable): Boolean;
  begin
    Result := True;
    if ACount = 1 then
      Exit;

    if ACount = 0 then
    begin
      AParametricErrorTable.W.AddErrorMessage(AStringTreeNode.Value,
        '����������� �� ������', petSubParamNotFound, AStringTreeNode.ID);
    end;

    if ACount > 1 then
    begin
      AParametricErrorTable.W.AddErrorMessage(AStringTreeNode.Value,
        Format('����������� ������ � ����������� ������������� %d %s',
        [ACount, NameForm(ACount, '���', '����', '���')]), petSubParamDuplicate,
        AStringTreeNode.ID);
    end;

    Result := False;
  end;

  function CheckUniqueSubParam(AParamSubParamID: Integer;
    AIDList: TList<Integer>; AStringTreeNode: TStringTreeNode;
    AParametricErrorTable: TParametricErrorTable): Boolean;
  begin
    Assert(AParamSubParamID > 0);
    Result := True;

    // ���������, �� ��������� �� ����� ����������� �����
    if AIDList.IndexOf(AParamSubParamID) < 0 then
      Exit;

    AParametricErrorTable.W.AddErrorMessage(AStringTreeNode.Value,
      '�������� ����������� ����� ������ ����', petNotUnique,
      AStringTreeNode.ID);
    Result := False;
  end;

var
  AStringTreeNode: TStringTreeNode;
  AStringTreeNode2: TStringTreeNode;
  rc: Integer;
  AIDList: TList<Integer>;
  AParamSubParamID: Integer;
  FamilyNameCoumn: string;
  ParamIsOk: Boolean;
  prc: Integer;
  SubParamIsOk: Boolean;

begin
  Assert(AParametricErrorTable <> nil);

  // �������� ���� ��� ����� ���������� ������� � ������������� �����������
  FamilyNameCoumn := ';PART;PART NUMBER;';

  // �������� ����� excel �����
  AIDList := TList<Integer>.Create;
  try
    // ���� �� ���� ���������� �������
    for AStringTreeNode in ARootTreeNode.Childs do
    begin
      // ���� ��� ������ ������� ������������
      if FamilyNameCoumn.IndexOf(';' + AStringTreeNode.Value.ToUpper + ';') >= 0
      then
      begin
        Assert(AStringTreeNode.Childs.Count = 0);
        AIDList.Add(-AStringTreeNode.ID);
        Continue;
      end;

      // ����, �������� ���� ���� ������ ��� ������� ��� ���������
      if AParametricErrorTable.W.LocateByID(AStringTreeNode.ID) then
      begin
        ParamIsOk := AParametricErrorTable.W.Fixed.F.AsBoolean;
        if ParamIsOk then
          qSearchParameter.SearchByID
            (AParametricErrorTable.W.ParameterID.F.AsInteger, True);
      end
      else
      begin
        // ���� ����� �������� � ����������� ����������
        prc := qSearchParameter.SearchByTableName
          (ReplaceNotKeyboadChars(AStringTreeNode.Value));
        ParamIsOk := ProcessParamSearhResult(prc, AStringTreeNode,
          AParametricErrorTable);
      end;

      // ���� �� ���� �������������
      if AStringTreeNode.Childs.Count > 0 then
      begin
        for AStringTreeNode2 in AStringTreeNode.Childs do
        begin
          // ���� � ����� ���������� �� �� � �������
          if not ParamIsOk then
          begin
            // ���� ������� � Excel-����� ����� ����������
            AIDList.Add(-AStringTreeNode2.ID);
            Continue;
          end;

          // ����, �������� ���� ���� ������ ��� ������� ��� ���������
          if AParametricErrorTable.W.LocateByID(AStringTreeNode2.ID) then
          begin
            SubParamIsOk := AParametricErrorTable.W.Fixed.F.AsBoolean;
            if SubParamIsOk then
              qSubParameters.SearchByID
                (AParametricErrorTable.W.ParameterID.F.AsInteger, True)
          end
          else
          begin
            // ���� ����� ����������� � ����������� �������������
            rc := qSubParameters.Search
              (ReplaceNotKeyboadChars(AStringTreeNode2.Value));
            SubParamIsOk := ProcessSubParamSearhResult(rc, AStringTreeNode2,
              AParametricErrorTable);
          end;

          // ���� � ����� ������������� �� �� ��������
          if not SubParamIsOk then
          begin
            // ���� ������� � Excel-����� ����� ����������
            AIDList.Add(-AStringTreeNode2.ID);
            Continue;
          end;

          // ����, ���� �� � ������ ��������� ����� �����������
          rc := qParamSubParams.SearchBySubParam
            (qSearchParameter.W.PK.AsInteger, qSubParameters.W.PK.AsInteger);
          Assert(rc <= 1);

          // ���� ����� ������� �������� � �������������
          if rc = 0 then
            qParamSubParams.W.AppendSubParameter
              (qSearchParameter.W.PK.AsInteger, qSubParameters.W.PK.AsInteger);

          // ���������� �������� ���� ���������� � �������������
          AParamSubParamID := qParamSubParams.W.PK.AsInteger;

          // ��������� ������ �� ����������� �� ������������
          if CheckUniqueSubParam(AParamSubParamID, AIDList, AStringTreeNode,
            AParametricErrorTable) then
            AIDList.Add(AParamSubParamID)
          else
            AIDList.Add(-AStringTreeNode2.ID);
        end;
      end
      else
      begin
        // ���� � ������ ��������� ��� �������������
        // ���� �������� ��� �� ������
        if not ParamIsOk then
        begin
          // ���� ������� � Excel-����� ����� ����������
          AIDList.Add(-AStringTreeNode.ID);
          Continue;
        end;

        // ���� ����������� "�� ���������" ��� ��������� ��� �������������
        qSearchParamDefSubParam.SearchByID(qSearchParameter.W.PK.AsInteger, 1);
        AParamSubParamID := qSearchParamDefSubParam.W.ParamSubParamID.
          F.AsInteger;

        // ���������, �� ��������� �� ����� ����������� �����
        if CheckUniqueSubParam(AParamSubParamID, AIDList, AStringTreeNode,
          AParametricErrorTable) then
          AIDList.Add(AParamSubParamID)
        else
          AIDList.Add(-AStringTreeNode.ID);
      end;
    end;

    Result := AIDList.ToArray;
  finally
    FreeAndNil(AIDList);
  end;
end;

class function TDM.NewInstance: TObject;
begin
  if not Assigned(Instance) then
  begin
    Instance := TDM(inherited NewInstance);
    SingletonList.Add(Instance);
  end;

  Result := Instance;
end;

initialization

SingletonList := TObjectList.Create(True);

finalization

FreeAndNil(SingletonList);

end.
