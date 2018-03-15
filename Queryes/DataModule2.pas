unit DataModule2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  RepositoryDataModule, System.Contnrs, System.Generics.Collections,
  BaseQuery, QueryGroupUnit, ModCheckDatabase, SettingsController, VersionQuery,
  ProjectConst, BaseEventsQuery, QueryWithMasterUnit, QueryWithDataSourceUnit,
  TreeListQuery, DescriptionsGroupUnit, BodyTypesGroupUnit, ProducersGroupUnit,
  ParametersGroupUnit, BaseComponentsGroupUnit, ComponentsExGroupUnit,
  ComponentsGroupUnit, ComponentsSearchGroupUnit,
  ChildCategoriesQuery, ProductsBaseQuery, ProductsQuery,
  StoreHouseListQuery, ProductsSearchQuery, CategoryParametersQuery2,
  CategoryParametersGroupUnit, NotifyEvents;

type
  TDM2 = class(TForm)
    qVersion: TQueryVersion;
    qTreeList: TQueryTreeList;
    qChildCategories: TQueryChildCategories;
    qProducts: TQueryProducts;
    qStoreHouseList: TQueryStoreHouseList;
    qProductsSearch: TQueryProductsSearch;
  private
    FBodyTypesGroup: TBodyTypesGroup;
    FCategoryParametersGroup: TCategoryParametersGroup;
    FComponentsExGroup: TComponentsExGroup;
    FComponentsGroup: TComponentsGroup;
    FComponentsSearchGroup: TComponentsSearchGroup;
    FDataSetList: TList<TQueryBase>;
    FDescriptionsGroup: TDescriptionsGroup;
    FEventList: TObjectList;
    FParametersGroup: TParametersGroup;
    FProducersGroup: TProducersGroup;
    FQueryGroups: TList<TQueryGroup>;
    FTreeListAfterFirstOpen: TNotifyEventWrap;
    // FRecommendedReplacement: TRecommendedReplacementThread;
    // FTempThread: TTempThread;
    procedure CloseConnection;
    procedure DoOnCategoryParametersApplyUpdates(Sender: TObject);
    procedure DoAfterComponentsCommit(Sender: TObject);
    procedure DoAfterParametersCommit(Sender: TObject);
    procedure DoAfterProducerCommit(Sender: TObject);
    procedure DoAfterStoreHousePost(Sender: TObject);
    procedure DoOnParamOrderChange(Sender: TObject);
    function GetBodyTypesGroup: TBodyTypesGroup;
    function GetCategoryParametersGroup: TCategoryParametersGroup;
    function GetComponentsExGroup: TComponentsExGroup;
    function GetComponentsGroup: TComponentsGroup;
    function GetComponentsSearchGroup: TComponentsSearchGroup;
    function GetDescriptionsGroup: TDescriptionsGroup;
    function GetParametersGroup: TParametersGroup;
    function GetProducersGroup: TProducersGroup;
    procedure InitDataSetValues;
    procedure OpenConnection;
    { Private declarations }
  protected
    procedure DoAfterTreeListFirstOpen(Sender: TObject);
    procedure DoBeforeTreeListClose(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CreateOrOpenDataBase;
    function HaveAnyChanges: Boolean;
    procedure SaveAll;
    property BodyTypesGroup: TBodyTypesGroup read GetBodyTypesGroup;
    property CategoryParametersGroup: TCategoryParametersGroup read
        GetCategoryParametersGroup;
    property ComponentsExGroup: TComponentsExGroup read GetComponentsExGroup;
    property ComponentsGroup: TComponentsGroup read GetComponentsGroup;
    property ComponentsSearchGroup: TComponentsSearchGroup read
        GetComponentsSearchGroup;
    property DescriptionsGroup: TDescriptionsGroup read GetDescriptionsGroup;
    property ParametersGroup: TParametersGroup read GetParametersGroup;
    property ProducersGroup: TProducersGroup read GetProducersGroup;
    { Public declarations }
  end;

var
  DM2: TDM2;

implementation

{$R *.dfm}

uses System.IOUtils, DragHelper, Data.DB;

constructor TDM2.Create(AOwner: TComponent);
begin
  Assert(DMRepository <> nil);
  Assert(not DMRepository.dbConnection.Connected);
  inherited;
  Assert(not DMRepository.dbConnection.Connected);

  FEventList := TObjectList.Create;

  // СОздаём список наборов данных, кторые будем открывать
  FDataSetList := TList<TQueryBase>.Create;

  with FDataSetList do
  begin
    Add(qTreeList);
    Add(BodyTypesGroup.qBodyKinds); // Виды корпусов
    Add(BodyTypesGroup.qBodyTypes2); // Типы корпусов
    Add(ProducersGroup.qProducerTypes); // Типы производителей
    Add(ProducersGroup.qProducers); // Производители
    Add(qProductsSearch);
    // Поиск на складе и редактирование найденного
    // Add(FProductGroup.qComponentGroups); // группы компонентов на складе
    Add(qStoreHouseList); // Склады - главное
    // Add(FProductGroup.qProducts); // Содержимое текущего склада
    Add(ComponentsSearchGroup.qFamilySearch);
    // Поиск среди компонентов (главное)
    Add(ComponentsSearchGroup.qComponentsSearch);
    // Поиск среди компонентов (подчинённое)
    // вкладка параметры - список параметров
    Add(CategoryParametersGroup.qCategoryParameters);
  end;
  // Для компонентов указываем откуда брать производителя и корпус
//  ComponentsGroup.Producers := ProducersGroup.qProducers;
//  ComponentsSearchGroup.Producers := ProducersGroup.qProducers;
//  ComponentsExGroup.Producers := ProducersGroup.qProducers;

  FTreeListAfterFirstOpen := TNotifyEventWrap.Create(qTreeList.AfterOpen, DoAfterTreeListFirstOpen);
  TNotifyEventWrap.Create(qTreeList.BeforeClose, DoBeforeTreeListClose, FEventList);

  // Связываем запросы отношением главный-подчинённый
  qChildCategories.Master := qTreeList;
  qProducts.Master := qStoreHouseList;

  // Сначала обновим детали, чтобы при обновлении мастера знать сколько у него дочерних
  ComponentsGroup.qComponents.Master := qTreeList;
  ComponentsGroup.qFamily.Master := qTreeList;

  // Сначала обновим детали, чтобы при обновлении мастера знать сколько у него дочерних
  ComponentsExGroup.qComponentsEx.Master := qTreeList;
  ComponentsExGroup.qFamilyEx.Master := qTreeList;

  CategoryParametersGroup.qCategoryParameters.Master := qTreeList;

  // Список групп
  FQueryGroups := TList<TQueryGroup>.Create;
  FQueryGroups.Add(ComponentsGroup);
  FQueryGroups.Add(ComponentsExGroup);
  FQueryGroups.Add(ComponentsSearchGroup);

  TNotifyEventWrap.Create(ParametersGroup.AfterCommit, DoAfterParametersCommit,
    FEventList);

  TNotifyEventWrap.Create(CategoryParametersGroup.qCategoryParameters.On_ApplyUpdates, DoOnCategoryParametersApplyUpdates,
    FEventList);

  TNotifyEventWrap.Create(ComponentsGroup.AfterCommit, DoAfterComponentsCommit,
    FEventList);


  // Чтобы производители у продуктов на складе обновлялись вместе с обновлением
  // справочника производителей
  TNotifyEventWrap.Create(ProducersGroup.qProducers.AfterCommit,
    DoAfterProducerCommit, FEventList);

  // Чтобы выпадающий список складов обновлялся вместе со списком складов
  TNotifyEventWrap.Create(qStoreHouseList.AfterPost, DoAfterStoreHousePost,
    FEventList);

  // Пробы при перетаскивании бэндов в параметрической таблице менялся порядок параметров
  TNotifyEventWrap.Create(ComponentsExGroup.OnParamOrderChange,
    DoOnParamOrderChange, FEventList);
end;

destructor TDM2.Destroy;
begin
  CloseConnection;
  FreeAndNil(FEventList);
  FreeAndNil(FDataSetList);
  FreeAndNil(FQueryGroups);
  inherited;
end;


{ закрытие датасетов }
procedure TDM2.CloseConnection;
var
  I: Integer;
begin
  // Это событие не срабатывает, потому что csDestroying in ComponentState
  DoBeforeTreeListClose(qTreeList.FDQuery);

  for I := FDataSetList.Count - 1 downto 0 do
    FDataSetList[I].FDQuery.Close;

  qTreeList.FDQuery.Close;

  // Закрываем соединение с БД
  DMRepository.dbConnection.Close;
end;

procedure TDM2.CreateOrOpenDataBase;
var
  ADatabaseFileName: string;
  AEmptyDatabaseFileName: string;
begin
  ADatabaseFileName := TPath.Combine(TSettings.Create.databasePath,
    sDefaultDatabaseFileName);

  // если файл с бд не существует, скопировать из директории
  if not TFile.Exists(ADatabaseFileName) then
  begin
    // определяемся с именем файла "пустой" базы данных
    AEmptyDatabaseFileName :=
      TPath.Combine(TPath.GetDirectoryName(Application.ExeName),
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

procedure TDM2.DoOnCategoryParametersApplyUpdates(Sender: TObject);
begin
  // Произошли изменения в таблице параметров для категорий
  // Будем обновлять параметрическую таблицу
  ComponentsExGroup.TryRefresh;
end;

procedure TDM2.DoAfterComponentsCommit(Sender: TObject);
begin
  // Произошли изменения в таблице компонентов
  // Будем обновлять параметрическую таблицу
  ComponentsExGroup.TryRefresh;
end;

procedure TDM2.DoAfterParametersCommit(Sender: TObject);
begin
  // Применили изменения в параметрах - надо обновить параметры для категории
  CategoryParametersGroup.qCategoryParameters.RefreshQuery;
end;

procedure TDM2.DoAfterProducerCommit(Sender: TObject);
begin
  // Произощёл коммит в справочнике производителей

  // Просим обновить данные о производителях в других местах
  qProductsSearch.ProducersGroup.ReOpen;
  qProducts.ProducersGroup.ReOpen;
  DescriptionsGroup.qProducers.RefreshQuery;


  ComponentsGroup.Producers.RefreshQuery;
  ComponentsSearchGroup.Producers.RefreshQuery;
end;

procedure TDM2.DoAfterStoreHousePost(Sender: TObject);
begin
  // Произошло сохранение скалада
  // Обновляем выпадающий список складов
  qProductsSearch.qStoreHouseList.RefreshQuery;
end;

procedure TDM2.DoAfterTreeListFirstOpen(Sender: TObject);
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
  qTreeList.LocateByPK(ACategoryID);
end;

procedure TDM2.DoBeforeTreeListClose(Sender: TObject);
begin
  Assert(qTreeList.FDQuery.Active);

  if qTreeList.FDQuery.RecordCount = 0 then
    Exit;

  TSettings.Create.CategoryID := qTreeList.PK.AsInteger;
end;

procedure TDM2.DoOnParamOrderChange(Sender: TObject);
begin
  CategoryParametersGroup.RefreshData;
end;

function TDM2.GetBodyTypesGroup: TBodyTypesGroup;
begin
  if FBodyTypesGroup = nil then
    FBodyTypesGroup := TBodyTypesGroup.Create(Self);

  Result := FBodyTypesGroup;
end;

function TDM2.GetCategoryParametersGroup: TCategoryParametersGroup;
begin
  if FCategoryParametersGroup = nil then
    FCategoryParametersGroup := TCategoryParametersGroup.Create(Self);

  Result := FCategoryParametersGroup;
end;

function TDM2.GetComponentsExGroup: TComponentsExGroup;
begin
  if FComponentsExGroup = nil then
    FComponentsExGroup := TComponentsExGroup.Create(Self);

  Result := FComponentsExGroup;
end;

function TDM2.GetComponentsGroup: TComponentsGroup;
begin
  if FComponentsGroup = nil then
    FComponentsGroup := TComponentsGroup.Create(Self);

  Result := FComponentsGroup;
end;

function TDM2.GetComponentsSearchGroup: TComponentsSearchGroup;
begin
  if FComponentsSearchGroup = nil then
    FComponentsSearchGroup := TComponentsSearchGroup.Create(Self);
  Result := FComponentsSearchGroup;
end;

function TDM2.GetDescriptionsGroup: TDescriptionsGroup;
begin
  if FDescriptionsGroup = nil then
    FDescriptionsGroup := TDescriptionsGroup.Create(Self);

  Result := FDescriptionsGroup;
end;

function TDM2.GetParametersGroup: TParametersGroup;
begin
  if FParametersGroup = nil then
    FParametersGroup := TParametersGroup.Create(Self);

  Result := FParametersGroup;
end;

function TDM2.GetProducersGroup: TProducersGroup;
begin
  if FProducersGroup = nil then
    FProducersGroup := TProducersGroup.Create(Self);

  Result := FProducersGroup;
end;

function TDM2.HaveAnyChanges: Boolean;
var
  I: Integer;
begin
  Result := False;
  if not DMRepository.dbConnection.Connected then
    Exit;

  Result := False;
  for I := 0 to FDataSetList.Count - 1 do
  begin
    Result := FDataSetList[I].HaveAnyChanges;
    if Result then
      Exit;
  end;

  for I := 0 to FQueryGroups.Count - 1 do
  begin
    Result := FQueryGroups[I].Main.HaveAnyChanges or
      FQueryGroups[I].Detail.HaveAnyChanges;
    if Result then
      Exit;
  end;
end;

{ Заполнение БД необходимыми полями }
procedure TDM2.InitDataSetValues;
begin
  // Добавляем корень дерева
  qTreeList.AddRoot;

  // Инициализируем список полей
  // qFieldTypes.InitDataSetValues;
end;

{ открытие датасетов }
procedure TDM2.OpenConnection;
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
    qVersion.RefreshQuery;
    if qVersion.Version.AsInteger <> DBVersion then
    begin
      AErrorMessage := Format('Неверная версия базы данных (надо %d, имеем %d)',
        [DBVersion, qVersion.Version.AsInteger]);
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

  for I := 0 to FDataSetList.Count - 1 do
  begin
    FDataSetList[I].FDQuery.Open;
  end;

  // Отписываемся от события
  Assert(FTreeListAfterFirstOpen <> nil);
  FreeAndNil(FTreeListAfterFirstOpen);


  InitDataSetValues();
end;

{ сохранить всё }
procedure TDM2.SaveAll;
var
  I: Integer;
begin
  // Сохраняем изменения сделанные в категориях компонентов
  for I := 0 to FDataSetList.Count - 1 do
    FDataSetList[I].TryPost;

  // Если работали в рамках транзакции, то сохраняем
  if FDataSetList[0].FDQuery.Connection.InTransaction then
    FDataSetList[0].FDQuery.Connection.Commit;

end;

end.
