unit DataModule;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.UI.Intf, FireDAC.VCLUI.Wait, FireDAC.Stan.Intf, FireDAC.Comp.UI,
  TreeListQuery, ChildCategoriesQuery, BodyTypesGroupUnit, BodyTypesTreeQuery,
  DescriptionsGroupUnit, Manufacturers2Query, ParametersGroupUnit,
  ComponentsExGroupUnit, System.Contnrs, System.Generics.Collections,
  ComponentsGroupUnit, BodyTypesQuery, ComponentsSearchGroupUnit,
  ParametersForCategoriesGroupUnit, StoreHouseGroupUnit, ProductsBaseQuery,
  ProductsSearchQuery, StoreHouseListQuery, CustomComponentsQuery, BaseQuery,
  QueryWithDataSourceUnit, BaseEventsQuery, QueryWithMasterUnit,
  QueryGroupUnit, BaseComponentsGroupUnit;

type
  TDM = class(TForm)
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    qTreeList: TQueryTreeList;
    qChildCategories: TQueryChildCategories;
    qBodyTypesTree: TQueryBodyTypesTree;
    qManufacturers2: TQueryManufacturers2;
    qProductsSearch: TQueryProductsSearch;
    qBodyTypes: TQueryBodyTypes;
    qStoreHouseList: TQueryStoreHouseList;
    BodyTypesGroup: TBodyTypesGroup;
    StoreHouseGroup: TStoreHouseGroup;
    ComponentsSearchGroup: TComponentsSearchGroup;
    ParametersForCategoriesGroup: TParametersForCategoriesGroup;
    ComponentsGroup: TComponentsGroup;
    ComponentsExGroup: TComponentsExGroup;
    ParametersGroup: TParametersGroup;
    DescriptionsGroup: TDescriptionsGroup;
  private
    FDataSetList: TList<TQueryBase>;
    FEventList: TObjectList;
    FQueryGroups: TList<TQueryGroup>;
    // FRecommendedReplacement: TRecommendedReplacementThread;
    // FTempThread: TTempThread;
    procedure CloseConnection;
    procedure DoAfterBodyTypesTreePostOrDelete(Sender: TObject);
    procedure DoAfterParametersCommit(Sender: TObject);
    procedure DoAfterParamForCategoriesPost(Sender: TObject);
    procedure InitDataSetValues;
    procedure OpenConnection;
    { Private declarations }
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure CreateOrOpenDataBase;
    function HaveAnyChanges: Boolean;
    procedure SaveAll;
    { Public declarations }
  end;

var
  DM: TDM;

implementation

{$R *.dfm}

uses SettingsController, System.IOUtils, RepositoryDataModule, NotifyEvents,
  ModCheckDatabase, ProjectConst;

constructor TDM.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  // FRecommendedReplacement := TRecommendedReplacementThread.Create(Self);
  // FTempThread := TTempThread.Create(Self);

  FEventList := TObjectList.Create;

  // Заполняем список датасетов в том порядке, в котором их надо открывать
  FDataSetList := TList<TQueryBase>.Create;
  with FDataSetList do
  begin
    Add(qTreeList);
    Add(BodyTypesGroup.qBodyKinds); // Виды корпусов
    Add(BodyTypesGroup.qBodyTypes2); // Типы корпусов
    Add(qBodyTypesTree); // Типы корпусов
    Add(qManufacturers2); // Производители
    Add(qProductsSearch); // Поиск на складе и редактирование найденного
    Add(qStoreHouseList); // Склады (выпадающий список)
    Add(StoreHouseGroup.qStoreHouseList); // Склады - главное
//    Add(StoreHouseGroup.qProducts); // Содержимое текущего склада
    Add(ComponentsSearchGroup.qFamilySearch);
    // Поиск среди компонентов (главное)
    Add(ComponentsSearchGroup.qComponentsSearch);
    // Поиск среди компонентов (подчинённое)

    // вкладка параметры - главное
    Add(ParametersForCategoriesGroup.qParameterTypes);
    // вкладка параметры - подчинённое
    Add(ParametersForCategoriesGroup.qParametersDetail);

    Add(qBodyTypes); // Выпадающий список корпусов
  end;

  qProductsSearch.QueryStoreHouseList := qStoreHouseList;

  // Для компонентов указываем откуда брать производителя и корпус

  ComponentsGroup.Manufacturers := qManufacturers2;
  ComponentsGroup.BodyTypes := qBodyTypes;
  ComponentsSearchGroup.Manufacturers := qManufacturers2;
  ComponentsSearchGroup.BodyTypes := qBodyTypes;
  ComponentsExGroup.Manufacturers := qManufacturers2;
  ComponentsExGroup.BodyTypes := qBodyTypes;

  // Связываем запросы отношением главный-подчинённый
  qChildCategories.Master := qTreeList;

  // Сначала обновим детали, чтобы при обновлении мастера знать сколько у него дочерних
  ComponentsGroup.qComponents.Master := qTreeList;
  ComponentsGroup.qFamily.Master := qTreeList;

  // Сначала обновим детали, чтобы при обновлении мастера знать сколько у него дочерних
  ComponentsExGroup.qComponentsEx.Master := qTreeList;
  ComponentsExGroup.qFamilyEx.Master := qTreeList;

  ParametersForCategoriesGroup.qParametersDetail.Master := qTreeList;
  // qCategoryParameters.Master := qTreeList;

  TNotifyEventWrap.Create(ParametersForCategoriesGroup.qParametersDetail.
    AfterPost, DoAfterParamForCategoriesPost, FEventList);

  // Список главных-подчинённых
  FQueryGroups := TList<TQueryGroup>.Create;
  FQueryGroups.Add(ComponentsGroup);
  FQueryGroups.Add(ComponentsExGroup);
  FQueryGroups.Add(ComponentsSearchGroup);
  FQueryGroups.Add(StoreHouseGroup);
  FQueryGroups.Add(ParametersForCategoriesGroup);

  TNotifyEventWrap.Create(ParametersGroup.AfterCommit,
    DoAfterParametersCommit, FEventList);

  // Чтобы корпуса используемые в представлении компонентов
  // обновлялись вместе с изменением справочника корпусов
  TNotifyEventWrap.Create(qBodyTypesTree.AfterPost,
    DoAfterBodyTypesTreePostOrDelete, FEventList);
  TNotifyEventWrap.Create(qBodyTypesTree.AfterDelete,
    DoAfterBodyTypesTreePostOrDelete, FEventList);

end;

{ закрытие датасетов }
procedure TDM.CloseConnection;
var
  I: Integer;
begin
  for I := FDataSetList.Count - 1 downto 0 do
    FDataSetList[I].FDQuery.Close;

  // Закрываем соединение с БД
  DMRepository.dbConnection.Close;
end;

procedure TDM.CreateOrOpenDataBase;
var
  databaseFileName: string;
begin
  databaseFileName := TPath.Combine(TSettings.Create.databasePath,
    sDefaultDatabaseFileName);

  // если файл с бд не существует, скопировать из директории
  if not TFile.Exists(databaseFileName) then
    TFile.Copy(ChangeFileExt(Application.ExeName, '.db'), databaseFileName);

  // Закрываем старое соединение с БД
  if DMRepository.dbConnection.Connected then
    CloseConnection;

  // Меняем путь до базы данных
  DMRepository.dbConnection.Params.Database := databaseFileName; // путь до БД

  // Открываем новое соединение с БД
  OpenConnection();
end;

procedure TDM.DoAfterBodyTypesTreePostOrDelete(Sender: TObject);
begin
  qBodyTypes.RefreshQuery;
end;

procedure TDM.DoAfterParametersCommit(Sender: TObject);
begin
  // Применили изменения в параметрах - надо обновить параметры для категории
  ParametersForCategoriesGroup.qParameterTypes.RefreshQuery;
end;

procedure TDM.DoAfterParamForCategoriesPost(Sender: TObject);
begin
  // Произошли изменения в параметрах для категории
  ComponentsExGroup.UpdateData;
end;

function TDM.HaveAnyChanges: Boolean;
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
    Result := FQueryGroups[I].Main.HaveAnyChanges or FQueryGroups[I].Detail.HaveAnyChanges;
    if Result then
      Exit;
  end;
end;

{ Заполнение БД необходимыми полями }
procedure TDM.InitDataSetValues;
begin
  // Добавляем корень дерева
  qTreeList.AddRoot;

  // Инициализируем список полей
  // qFieldTypes.InitDataSetValues;
end;

{ открытие датасетов }
procedure TDM.OpenConnection;
var
  I: Integer;
begin
  // Обновляем структуру БД
  TDBMigration.UpdateDatabaseStructure(DMRepository.dbConnection,
    TSettings.Create.DBMigrationFolder);

  // Устанавливаем соединение с БД
  DMRepository.dbConnection.Open();

  for I := 0 to FDataSetList.Count - 1 do
  begin
    FDataSetList[I].FDQuery.Open;
  end;

  InitDataSetValues();
end;

{ сохранить всё }
procedure TDM.SaveAll;
var
  I: Integer;
begin
  // Сохраняем изменения сделанные в категориях компонентов
  for I := 0 to FDataSetList.Count - 1 do
    FDataSetList[I].TryPost;
  {
    for I := 0 to FQuerysGroups.Count - 1 do
    begin
    FQuerysGroups[I].ApplyUpdates;
    end;
  }
  // Если работали в рамках транзакции, то сохраняем
  if FDataSetList[0].FDQuery.Connection.InTransaction then
    FDataSetList[0].FDQuery.Connection.Commit;

end;

end.
