unit DataModule;

interface

uses
  System.Classes, System.Contnrs, BaseQuery, System.Generics.Collections,
  TreeListQuery, BodyTypesGroupUnit2, NotifyEvents, VersionQuery,
  ProducersGroupUnit2, ProductsSearchQuery, StoreHouseListQuery,
  ComponentsSearchGroupUnit2, CategoryParametersGroupUnit2,
  ChildCategoriesQuery, ProductsQuery, ComponentsExGroupUnit2,
  ComponentsGroupUnit2, ParametersGroupUnit2, DescriptionsGroupUnit2,
  SubParametersQuery2, ExtraChargeGroupUnit, BillQuery, BillContentQuery;

type
  TDM = class(TObject)
  private
    class var Instance: TDM;

  var
    FBodyTypesGroup: TBodyTypesGroup2;
    FCategoryParametersGroup: TCategoryParametersGroup2;
    FComponent: TComponent;
    FComponentsExGroup: TComponentsExGroup2;
    FComponentsGroup: TComponentsGroup2;
    FComponentsSearchGroup: TComponentsSearchGroup2;
    FDataSetList: TList<TQueryBase>;
    FDescriptionsGroup: TDescriptionsGroup2;
    FEventList: TObjectList;
    FExtraChargeGroup: TExtraChargeGroup;
    FParametersGroup: TParametersGroup2;
    FProducersGroup: TProducersGroup2;
    FqBillContent: TQueryBillContent;
    FqChildCategories: TQueryChildCategories;
    FqProducts: TQueryProducts;
    FqProductsBasket: TQueryProducts;
    FqProductsSearch: TQueryProductsSearch;
    FQryBill: TQryBill;
    FqStoreHouseList: TQueryStoreHouseList;
    FqSubParameters: TQuerySubParameters2;
    FqTreeList: TQueryTreeList;
    FqVersion: TQueryVersion;
    FRefreshQList: TList;
    procedure CloseConnection;
    procedure DoAfterProducerCommit(Sender: TObject);
    procedure DoAfterStoreHousePost(Sender: TObject);
    procedure DoOnCategoryParametersApplyUpdates(Sender: TObject);
    procedure DoOnParamOrderChange(Sender: TObject);
    function GetBodyTypesGroup: TBodyTypesGroup2;
    function GetCategoryParametersGroup: TCategoryParametersGroup2;
    function GetComponentsExGroup: TComponentsExGroup2;
    function GetComponentsGroup: TComponentsGroup2;
    function GetComponentsSearchGroup: TComponentsSearchGroup2;
    function GetDescriptionsGroup: TDescriptionsGroup2;
    function GetExtraChargeGroup: TExtraChargeGroup;
    function GetParametersGroup: TParametersGroup2;
    function GetProducersGroup: TProducersGroup2;
    function GetqBillContent: TQueryBillContent;
    function GetqChildCategories: TQueryChildCategories;
    function GetqProducts: TQueryProducts;
    function GetqProductsBasket: TQueryProducts;
    function GetqProductsSearch: TQueryProductsSearch;
    function GetQryBill: TQryBill;
    function GetqStoreHouseList: TQueryStoreHouseList;
    function GetqSubParameters: TQuerySubParameters2;
    function GetqTreeList: TQueryTreeList;
    function GetqVersion: TQueryVersion;
    procedure OpenConnection;
  protected
    procedure DoAfterChildCategoriesPostOrDelete(Sender: TObject);
    procedure DoAfterCommit(Sender: TObject);
    procedure DoAfterTreeListFirstOpen(Sender: TObject);
    procedure DoBeforeCommit(Sender: TObject);
    procedure DoBeforeTreeListClose(Sender: TObject);
  public
    constructor Create;
    destructor Destroy; override;
    class function Created: Boolean;
    procedure CreateOrOpenDataBase(const AExeName: String);
    class function NewInstance: TObject; override;
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
    property qBillContent: TQueryBillContent read GetqBillContent;
    property qChildCategories: TQueryChildCategories read GetqChildCategories;
    property qProducts: TQueryProducts read GetqProducts;
    property qProductsBasket: TQueryProducts read GetqProductsBasket;
    property qProductsSearch: TQueryProductsSearch read GetqProductsSearch;
    property QryBill: TQryBill read GetQryBill;
    property qStoreHouseList: TQueryStoreHouseList read GetqStoreHouseList;
    property qSubParameters: TQuerySubParameters2 read GetqSubParameters;
    property qTreeList: TQueryTreeList read GetqTreeList;
    property qVersion: TQueryVersion read GetqVersion;
  end;

implementation

uses
  RepositoryDataModule, SettingsController, System.SysUtils, System.IOUtils,
  ProjectConst, ModCheckDatabase;

var
  SingletonList: TObjectList;

constructor TDM.Create;
begin
  // Если инициализация уже произошла
  if FComponent <> nil then
    Exit;

  FComponent := TComponent.Create(nil);

  Assert(DMRepository <> nil);
  Assert(not DMRepository.dbConnection.Connected);

  FEventList := TObjectList.Create;
  FRefreshQList := TList.Create;

  // СОздаём список наборов данных, кторые будем открывать
  FDataSetList := TList<TQueryBase>.Create;

  with FDataSetList do
  begin
    // Add(qTreeList);

//    Add(BodyTypesGroup.qBodyKinds); // Виды корпусов
//    Add(BodyTypesGroup.qBodyTypes2); // Типы корпусов

//    Add(ProducersGroup.qProducerTypes); // Типы производителей
//    Add(ProducersGroup.qProducers); // Производители

    // Поиск на складе и редактирование найденного
    // Add(qProductsSearch);

    // Add(qStoreHouseList); // Склады - главное

    // Поиск среди семейств
//    Add(ComponentsSearchGroup.qFamilySearch);

    // Поиск среди компонентов (подчинённое)
//    Add(ComponentsSearchGroup.qComponentsSearch);

    // вкладка параметры - список параметров
  //  Add(CategoryParametersGroup.qCategoryParameters);
  end;
  // Для компонентов указываем откуда брать производителя и корпус
  // ComponentsGroup.Producers := ProducersGroup.qProducers;
  // ComponentsSearchGroup.Producers := ProducersGroup.qProducers;
  // ComponentsExGroup.Producers := ProducersGroup.qProducers;

  Assert(not qTreeList.FDQuery.Active);
  TNotifyEventWrap.Create(qTreeList.W.AfterOpen,
    DoAfterTreeListFirstOpen, FEventList);

  TNotifyEventWrap.Create(qTreeList.W.BeforeClose, DoBeforeTreeListClose,
    FEventList);

  // Связываем запросы отношением главный-подчинённый
  qChildCategories.Master := qTreeList;

  // При редактировании дочерней категории нужно будет обновлять дерево
  TNotifyEventWrap.Create(qChildCategories.W.AfterPostM,
    DoAfterChildCategoriesPostOrDelete, FEventList);
  TNotifyEventWrap.Create(qChildCategories.W.AfterDelete,
    DoAfterChildCategoriesPostOrDelete, FEventList);

  qProducts.Master := qStoreHouseList;

  // Сначала обновим компоненты, чтобы при обновлении семейства знать сколько у него компонент
  ComponentsGroup.qComponents.Master := qTreeList;
  ComponentsGroup.qFamily.Master := qTreeList;

  // Сначала обновим компоненты, чтобы при обновлении семейства знать сколько у него компонент
  ComponentsExGroup.qComponentsEx.Master := qTreeList;
  ComponentsExGroup.qFamilyEx.Master := qTreeList;

  CategoryParametersGroup.qCategoryParameters.Master := qTreeList;

  TNotifyEventWrap.Create(DMRepository.BeforeCommit, DoBeforeCommit,
    FEventList);

  TNotifyEventWrap.Create(DMRepository.AfterCommit, DoAfterCommit, FEventList);

  TNotifyEventWrap.Create(CategoryParametersGroup.qCategoryParameters.
    On_ApplyUpdates, DoOnCategoryParametersApplyUpdates, FEventList);

  // Чтобы производители у продуктов на складе обновлялись вместе с обновлением
  // справочника производителей
  TNotifyEventWrap.Create(ProducersGroup.qProducers.AfterCommit,
    DoAfterProducerCommit, FEventList);

  // Чтобы выпадающий список складов обновлялся вместе со списком складов
  TNotifyEventWrap.Create(qStoreHouseList.W.AfterPostM, DoAfterStoreHousePost,
    FEventList);

  // Пробы при перетаскивании бэндов в параметрической таблице менялся порядок параметров
  TNotifyEventWrap.Create(ComponentsExGroup.OnParamOrderChange,
    DoOnParamOrderChange, FEventList);
end;

destructor TDM.Destroy;
begin
  FreeAndNil(FComponent);

  FreeAndNil(FEventList);
  FreeAndNil(FRefreshQList);
  FreeAndNil(FDataSetList);

  inherited;
end;

{ закрытие датасетов }
procedure TDM.CloseConnection;
var
  I: Integer;
begin
  // Это событие не срабатывает, потому что csDestroying in ComponentState
  if qTreeList.FDQuery.Active then
    DoBeforeTreeListClose(qTreeList.FDQuery);

  for I := FDataSetList.Count - 1 downto 0 do
    FDataSetList[I].FDQuery.Close;

  qTreeList.FDQuery.Close;

  // Закрываем соединение с БД
  DMRepository.dbConnection.Close;
end;

class function TDM.Created: Boolean;
begin
  Result := SingletonList.Count > 0;
end;

procedure TDM.CreateOrOpenDataBase(const AExeName: String);
var
  ADatabaseFileName: string;
  AEmptyDatabaseFileName: string;
begin
  Assert(not AExeName.IsEmpty);
  ADatabaseFileName := TPath.Combine(TSettings.Create.databasePath,
    sDefaultDatabaseFileName);

  // если файл с бд не существует, скопировать из директории
  if not TFile.Exists(ADatabaseFileName) then
  begin
    // определяемся с именем файла "пустой" базы данных
    AEmptyDatabaseFileName := TPath.Combine(TPath.GetDirectoryName(AExeName),
      sEmptyDatabaseFileName);

    if not TFile.Exists(AEmptyDatabaseFileName) then
      raise Exception.Create(Format('Не могу создать пустую базу данных.' +
        #13#10 + 'Не найден файл %s', [sEmptyDatabaseFileName]));

    TFile.Copy(AEmptyDatabaseFileName, ADatabaseFileName);
  end;

  // Закрываем старое соединение с БД
  if DMRepository.dbConnection.Connected then
    CloseConnection;

  // Меняем путь до базы данных
  DMRepository.dbConnection.Params.Database := ADatabaseFileName; // путь до БД

  // Открываем новое соединение с БД
  OpenConnection();
end;

procedure TDM.DoAfterChildCategoriesPostOrDelete(Sender: TObject);
begin
  // обновляем дерево с подавление AfterScroll
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
  // Произощёл коммит в справочнике производителей

  // Просим обновить данные о производителях в других местах
  qProductsSearch.ProducersGroup.ReOpen;
  qProducts.ProducersGroup.ReOpen;
  DescriptionsGroup.qProducers.W.RefreshQuery;

  ComponentsGroup.Producers.W.RefreshQuery;
  ComponentsSearchGroup.Producers.W.RefreshQuery;
end;

procedure TDM.DoAfterStoreHousePost(Sender: TObject);
begin
  // Произошло сохранение скалада
  // Обновляем выпадающий список складов
  qProductsSearch.qStoreHouseList.W.RefreshQuery;
end;

procedure TDM.DoAfterTreeListFirstOpen(Sender: TObject);
var
  ACategoryID: Integer;
begin
  Assert(qTreeList.FDQuery.Active);

  ACategoryID := TSettings.Create.CategoryID;
  // Если в настройках не сохранилась последняя открытая категория
  // Либо отключена загрузка последней категории
  if (ACategoryID = 0) or (not TSettings.Create.LoadLastCategory) then
    Exit;

  // Пытаемся перейти на ту-же запись
  qTreeList.W.LocateByPK(ACategoryID);
end;

procedure TDM.DoBeforeCommit(Sender: TObject);
begin
  // Применили изменения в параметрах - надо обновить параметры для категории
  if ParametersGroup.HaveAnyChanges then
    FRefreshQList.Add(ParametersGroup);

  // Произошли изменения в таблице компонентов
  // Будем обновлять параметрическую таблицу
  if ComponentsGroup.HaveAnyChanges then
    FRefreshQList.Add(ComponentsGroup);
end;

procedure TDM.DoBeforeTreeListClose(Sender: TObject);
begin
  if qTreeList.FDQuery.RecordCount = 0 then
    Exit;

  TSettings.Create.CategoryID := qTreeList.W.PK.AsInteger;
end;

procedure TDM.DoOnCategoryParametersApplyUpdates(Sender: TObject);
begin
  // Произошли изменения в таблице параметров для категорий
  // Будем обновлять параметрическую таблицу
  ComponentsExGroup.TryRefresh;
end;

procedure TDM.DoOnParamOrderChange(Sender: TObject);
begin
  CategoryParametersGroup.RefreshData;
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

function TDM.GetqBillContent: TQueryBillContent;
begin
  if FqBillContent = nil then
  begin
    FqBillContent := TQueryBillContent.Create(FComponent);
    FqBillContent.FDQuery.Open;
  end;

  Result := FqBillContent;
end;

function TDM.GetqChildCategories: TQueryChildCategories;
begin
  if FqChildCategories = nil then
    FqChildCategories := TQueryChildCategories.Create(FComponent);

  Result := FqChildCategories;
end;

function TDM.GetqProducts: TQueryProducts;
begin
  if FqProducts = nil then
    FqProducts := TQueryProducts.Create(FComponent);

  Result := FqProducts;
end;

function TDM.GetqProductsBasket: TQueryProducts;
begin
  if FqProductsBasket = nil then
    FqProductsBasket := TQueryProducts.Create(FComponent);

  Result := FqProductsBasket;
end;

function TDM.GetqProductsSearch: TQueryProductsSearch;
begin
  if FqProductsSearch = nil then
    FqProductsSearch := TQueryProductsSearch.Create(FComponent);

  Result := FqProductsSearch;
end;

function TDM.GetQryBill: TQryBill;
begin
  if FQryBill = nil then
  begin
    FQryBill := TQryBill.Create(FComponent);
    FQryBill.FDQuery.Open;
  end;

  Result := FQryBill;
end;

function TDM.GetqStoreHouseList: TQueryStoreHouseList;
begin
  if FqStoreHouseList = nil then
    FqStoreHouseList := TQueryStoreHouseList.Create(FComponent);
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

class function TDM.NewInstance: TObject;
begin
  if not Assigned(Instance) then
  begin
    Instance := TDM(inherited NewInstance);
    SingletonList.Add(Instance);
  end;

  Result := Instance;
end;

{ открытие датасетов }
procedure TDM.OpenConnection;
var
  AErrorMessage: string;
  I: Integer;
begin
  try
    // Обновляем структуру БД
    TDBMigration.UpdateDatabaseStructure(DMRepository.dbConnection,
      TSettings.Create.DBMigrationFolder, DBVersion);
  except
    // При обновлении версии БД произошла какая-то ошибка
    on E: Exception do
    begin
      AErrorMessage :=
        Format('Ошибка при обновлении структуры базы данных.'#13#10'%s',
        [E.Message]);
      raise Exception.Create(AErrorMessage);
    end;
  end;

  // Устанавливаем соединение с БД
  DMRepository.dbConnection.Open();

  AErrorMessage := '';
  try
    qVersion.W.RefreshQuery;
    if qVersion.W.Version.F.AsInteger <> DBVersion then
    begin
      AErrorMessage := Format('Неверная версия базы данных (надо %d, имеем %d)',
        [DBVersion, qVersion.W.Version.F.AsInteger]);
    end;
  except
    // При проверке версии БД произошла какая-то ошибка
    on E: Exception do
    begin
      AErrorMessage := E.Message;
    end;
  end;

  if not AErrorMessage.IsEmpty then
  begin
    DMRepository.dbConnection.Close;
    raise Exception.Create(AErrorMessage);
  end;

  if FDataSetList <> nil then
  begin
    for I := 0 to FDataSetList.Count - 1 do
    begin
      FDataSetList[I].FDQuery.Open;
    end;
  end;
end;

initialization

SingletonList := TObjectList.Create(True);

finalization

FreeAndNil(SingletonList);

end.
