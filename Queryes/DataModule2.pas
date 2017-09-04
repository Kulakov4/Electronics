unit DataModule2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  RepositoryDataModule, System.Contnrs, ProductGroupUnit,
  ProductSearchGroupUnit, System.Generics.Collections, BaseQuery, QueryGroupUnit,
  ModCheckDatabase, SettingsController, VersionQuery, ProjectConst,
  BaseEventsQuery, QueryWithMasterUnit, QueryWithDataSourceUnit, TreeListQuery,
  DescriptionsGroupUnit, BodyTypesGroupUnit, ProducersGroupUnit,
  ParametersGroupUnit, BaseComponentsGroupUnit, ComponentsExGroupUnit,
  ComponentsGroupUnit, ComponentsSearchGroupUnit, CategoryParametersQuery,
  ChildCategoriesQuery;

type
  TDM2 = class(TForm)
    qVersion: TQueryVersion;
    qTreeList: TQueryTreeList;
    DescriptionsGroup: TDescriptionsGroup;
    BodyTypesGroup: TBodyTypesGroup;
    ProducersGroup: TProducersGroup;
    ParametersGroup: TParametersGroup;
    ComponentsExGroup: TComponentsExGroup;
    ComponentsGroup: TComponentsGroup;
    ComponentsSearchGroup: TComponentsSearchGroup;
    qCategoryParameters: TQueryCategoryParameters;
    qChildCategories: TQueryChildCategories;
  private
    FDataSetList: TList<TQueryBase>;
    FEventList: TObjectList;
    FProductGroup: TProductGroup;
    FProductSearchGroup: TProductSearchGroup;
    FQueryGroups: TList<TQueryGroup>;
    // FRecommendedReplacement: TRecommendedReplacementThread;
    // FTempThread: TTempThread;
    procedure CloseConnection;
    procedure DoAfterParametersCommit(Sender: TObject);
    procedure DoAfterProducerCommit(Sender: TObject);
    procedure DoAfterStoreHousePost(Sender: TObject);
    procedure DoOnParamOrderChange(Sender: TObject);
    procedure InitDataSetValues;
    procedure OpenConnection;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CreateOrOpenDataBase;
    function HaveAnyChanges: Boolean;
    procedure SaveAll;
    property ProductGroup: TProductGroup read FProductGroup;
    property ProductSearchGroup: TProductSearchGroup read FProductSearchGroup;
    { Public declarations }
  end;

var
  DM2: TDM2;

implementation

{$R *.dfm}

uses System.IOUtils, NotifyEvents, DragHelper;

constructor TDM2.Create(AOwner: TComponent);
begin
  Application.MessageBox('4', 'Отладка');
  Assert(DMRepository <> nil);
  Assert(not DMRepository.dbConnection.Connected);
  Application.MessageBox('5', 'Отладка');
  inherited;
  Application.MessageBox('6', 'Отладка');
  Assert(not DMRepository.dbConnection.Connected);

  FEventList := TObjectList.Create;
  Application.MessageBox('7', 'Отладка');

  // Группа запросов - содержимое склада
  FProductGroup := TProductGroup.Create(Self);
  Application.MessageBox('8', 'Отладка');
  // Группа запросов - поиск по складам
  FProductSearchGroup := TProductSearchGroup.Create(Self);
  Application.MessageBox('9', 'Отладка');

  // СОздаём список наборов данных, кторые будем открывать
  FDataSetList := TList<TQueryBase>.Create;

  Application.MessageBox('10', 'Отладка');
  with FDataSetList do
  begin
    Add(qTreeList);
    Add(BodyTypesGroup.qBodyKinds); // Виды корпусов
    Add(BodyTypesGroup.qBodyTypes2); // Типы корпусов
    Add(ProducersGroup.qProducerTypes); // Типы производителей
    Add(ProducersGroup.qProducers); // Производители
    Add(FProductSearchGroup.qProductsSearch);
    // Поиск на складе и редактирование найденного
    // Add(FProductGroup.qComponentGroups); // группы компонентов на складе
    Add(FProductGroup.qStoreHouseList); // Склады - главное
    // Add(FProductGroup.qProducts); // Содержимое текущего склада
    Add(ComponentsSearchGroup.qFamilySearch);
    // Поиск среди компонентов (главное)
    Add(ComponentsSearchGroup.qComponentsSearch);
    // Поиск среди компонентов (подчинённое)
    // вкладка параметры - список параметров
    Add(qCategoryParameters);
  end;
  Application.MessageBox('11', 'Отладка');
  // Для компонентов указываем откуда брать производителя и корпус
  ComponentsGroup.Producers := ProducersGroup.qProducers;
  ComponentsSearchGroup.Producers := ProducersGroup.qProducers;
  ComponentsExGroup.Producers := ProducersGroup.qProducers;

  Application.MessageBox('12', 'Отладка');
  // Связываем запросы отношением главный-подчинённый
  qChildCategories.Master := qTreeList;

  // Сначала обновим детали, чтобы при обновлении мастера знать сколько у него дочерних
  ComponentsGroup.qComponents.Master := qTreeList;
  ComponentsGroup.qFamily.Master := qTreeList;

  Application.MessageBox('13', 'Отладка');
  // Сначала обновим детали, чтобы при обновлении мастера знать сколько у него дочерних
  ComponentsExGroup.qComponentsEx.Master := qTreeList;
  ComponentsExGroup.qFamilyEx.Master := qTreeList;

  Application.MessageBox('14', 'Отладка');
  qCategoryParameters.Master := qTreeList;

  Application.MessageBox('15', 'Отладка');

  // Список групп
  FQueryGroups := TList<TQueryGroup>.Create;
  FQueryGroups.Add(ComponentsGroup);
  FQueryGroups.Add(ComponentsExGroup);
  FQueryGroups.Add(ComponentsSearchGroup);

  Application.MessageBox('16', 'Отладка');

  TNotifyEventWrap.Create(ParametersGroup.AfterCommit, DoAfterParametersCommit,
    FEventList);

  // Чтобы производители у продуктов на складе обновлялись вместе с обновлением
  // справочника производителей
  TNotifyEventWrap.Create(ProducersGroup.qProducers.AfterCommit,
    DoAfterProducerCommit, FEventList);

  // Чтобы выпадающий список складов обновлялся вместе со списком складов
  TNotifyEventWrap.Create(FProductGroup.qStoreHouseList.AfterPost,
    DoAfterStoreHousePost, FEventList);

  // Пробы при перетаскивании бэндов в параметрической таблице менялся порядок параметров
  TNotifyEventWrap.Create(ComponentsExGroup.OnParamOrderChange,
    DoOnParamOrderChange, FEventList);

  Application.MessageBox('17', 'Отладка');
end;

destructor TDM2.Destroy;
begin
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
  for I := FDataSetList.Count - 1 downto 0 do
    FDataSetList[I].FDQuery.Close;

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

procedure TDM2.DoAfterParametersCommit(Sender: TObject);
begin
// Применили изменения в параметрах - надо обновить параметры для категории
  qCategoryParameters.RefreshQuery;
end;

procedure TDM2.DoAfterProducerCommit(Sender: TObject);
begin
  // Произощёл коммит в справочнике производителей

  // Просим обновить данные о производителях в других местах
  FProductSearchGroup.qProductsSearch.qProducers.RefreshQuery;
  FProductGroup.qProducts.qProducers.RefreshQuery;
end;

procedure TDM2.DoAfterStoreHousePost(Sender: TObject);
begin
  // Произошло сохранение скалада
  // Обновляем выпадающий список складов
  FProductSearchGroup.qProductsSearch.qStoreHouseList.RefreshQuery;
end;

procedure TDM2.DoOnParamOrderChange(Sender: TObject);
var
  L: TList<TRecOrder>;
begin
  L := Sender as TList<TRecOrder>;
  qCategoryParameters.Move(L);
  qCategoryParameters.ApplyUpdates;
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
      TSettings.Create.DBMigrationFolder);
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
