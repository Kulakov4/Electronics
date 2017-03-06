unit ProductsBaseQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  ApplyQueryFrame, DocFieldInfo, StoreHouseListQuery,
  SearchProductParameterValuesQuery, SearchFamilyByID,
  SearchProductQuery, QueryWithDataSourceUnit, CustomComponentsQuery,
  SearchDaughterComponentQuery, System.Generics.Collections,
  SearchStorehouseProductByID, ProducersQuery;

type
  TComponentNameParts = record
    Name: String;
    Number: cardinal;
    Ending: String;
  end;

  TQueryProductsBase = class(TQueryWithDataSource)
    qStoreHouseProducts: TfrmApplyQuery;
    qProducts: TfrmApplyQuery;
  private
    FQueryProducers: TQueryProducers;
    FQuerySearchDaughterComponent: TQuerySearchDaughterComponent;
    FQuerySearchFamilytByID: TQuerySearchFamilyByID;
    FQuerySearchProduct: TQuerySearchProduct;
    FQuerySearchStorehouseProductByID: TQuerySearchStorehouseProductByID;
    procedure DoAfterOpen(Sender: TObject);
// TODO: GetComponentFamily
//  function GetComponentFamily: String;
    function GetComponentGroup: TField;
    function GetDescriptionID: TField;
    function GetIDProducer: TField;
    function GetProductID: TField;
    function GetQueryProducers: TQueryProducers;
    function GetQuerySearchDaughterComponent: TQuerySearchDaughterComponent;
    function GetQuerySearchFamilytByID: TQuerySearchFamilyByID;
    function GetQuerySearchProduct: TQuerySearchProduct;
    function GetQuerySearchStorehouseProductByID
      : TQuerySearchStorehouseProductByID;
    function GetStorehouseId: TField;
    function GetValue: TField;
    function SplitComponentName(const S: string): TComponentNameParts;
    { Private declarations }
  protected
    procedure ApplyDelete(ASender: TDataSet); override;
    procedure ApplyInsert(ASender: TDataSet); override;
    procedure ApplyUpdate(ASender: TDataSet); override;
    property QuerySearchDaughterComponent: TQuerySearchDaughterComponent
      read GetQuerySearchDaughterComponent;
    property QuerySearchFamilytByID: TQuerySearchFamilyByID read
        GetQuerySearchFamilytByID;
    property QuerySearchProduct: TQuerySearchProduct read GetQuerySearchProduct;
    property QuerySearchStorehouseProductByID: TQuerySearchStorehouseProductByID
      read GetQuerySearchStorehouseProductByID;
  public
    constructor Create(AOwner: TComponent); override;
    procedure ApplyUpdates; override;
    procedure CancelUpdates; override;
    procedure LoadDocFile(const AFileName: String;
      ADocFieldInfo: TDocFieldInfo);
    property ComponentGroup: TField read GetComponentGroup;
    property DescriptionID: TField read GetDescriptionID;
    property IDProducer: TField read GetIDProducer;
    property ProductID: TField read GetProductID;
    property QueryProducers: TQueryProducers read GetQueryProducers;
    property StorehouseId: TField read GetStorehouseId;
    property Value: TField read GetValue;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses DBRecordHolder, System.IOUtils, SettingsController, RepositoryDataModule,
  NotifyEvents, ParameterValuesUnit, StrHelper, System.StrUtils;

constructor TQueryProductsBase.Create(AOwner: TComponent);
begin
  inherited;
  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, FEventList);

  // Будем сами обновлять запись
  FDQuery.OnUpdateRecord := DoOnQueryUpdateRecord;

  // По умолчанию мы не в режиме автоматических транзакций
  AutoTransaction := False;
end;

procedure TQueryProductsBase.ApplyDelete(ASender: TDataSet);
var
  AProductID: TField;
begin
  Assert(PKValue > 0);

  AProductID := ASender.FieldByName(ProductID.FieldName);

  // Удаляем продукт со склада. Сам продукт не удаляем.
  qStoreHouseProducts.DeleteRecord(PKValue);

  // Если подобных продуктов на складе больше нет
  if QuerySearchStorehouseProductByID.Search(AProductID.AsInteger) = 0 then
  begin
    // Удаляем продукт
    qProducts.DeleteRecord(AProductID.AsInteger);
  end;

  inherited;
end;

procedure TQueryProductsBase.ApplyInsert(ASender: TDataSet);
var
  AFieldHolder: TFieldHolder;
  APK: TField;
  AIDProducer: TField;
  AProductID: TField;
  ARH: TRecordHolder;
  ARH2: TRecordHolder;
  ARHFamily: TRecordHolder;
  AValue: TField;
  OK: Boolean;
  rc: Integer;
begin
  AValue := ASender.FieldByName(Value.FieldName);
  if AValue.AsString.Trim.IsEmpty then
      raise Exception.Create('Необходимо задать наименование компонента');
  APK := ASender.FieldByName(PKFieldName);
  AProductID := ASender.FieldByName(ProductID.FieldName);
  AIDProducer := ASender.FieldByName(IDProducer.FieldName);

  // Если производитель задан
  if AIDProducer.AsInteger > 0 then
  begin
    // Ищем производителя по коду
    OK := QueryProducers.LocateByPK(AIDProducer.AsInteger);
    Assert(OK);

    rc := QuerySearchDaughterComponent.Search(AValue.AsString,
      QueryProducers.Name.AsString);
  end
  else
  begin
    // Ищем в теоретической базе просто по наименованию
    rc := QuerySearchDaughterComponent.Search(AValue.AsString);
    if rc > 0 then
    begin
      // Ищем в справочнике такого производителя
      QueryProducers.LocateOrAppend
        (QuerySearchDaughterComponent.Producer.AsString);
      // Заполняем производителя
      AIDProducer.AsInteger := QueryProducers.PKValue;
    end;
  end;

  ARH := TRecordHolder.Create(ASender);
  try
    // Если такой компонент найден в компонентой базе
    if rc > 0 then
    begin
      // Ищем соответствующее семейство компонентов
      rc := QuerySearchFamilytByID.Search
        (QuerySearchDaughterComponent.ParentProductID.AsInteger);
      Assert(rc = 1);

      ARHFamily := TRecordHolder.Create(QuerySearchFamilytByID.FDQuery);
      try
        // Обновляем пустые значения
        ARH.UpdateNullValues(ARHFamily);
        ARH.Put(ASender);
      finally
        FreeAndNil(ARHFamily)
      end;

      {
        // Заполняем файлы документации так, как заполнено у семейства
        for ADocFieldInfo in FDocFieldInfos do
        begin
        ASender.FieldByName(ADocFieldInfo.FieldName).AsString :=
        QuerySearchFamilytByID.Field(ADocFieldInfo.FieldName).AsString;
        end;
        // Заполняем ссылку на краткое описание
        ADescriptionID.AsInteger :=
        QuerySearchFamilytByID.DescriptionID.AsInteger;
      }
    end;

    // Если производитель не задан
    if AIDProducer.AsInteger = 0 then
    begin
      // Ищем такой компонент с таким именем на складе
      rc := QuerySearchProduct.Search(AValue.AsString);
      if rc > 0 then
        // Заполняем производителя
        AIDProducer.AsInteger := QuerySearchProduct.IDProducer.AsInteger
      else
        raise Exception.Create('Необходимо задать производителя');
    end
    else
    begin
      // Если производитель задан
      rc := QuerySearchProduct.Search(AValue.AsString, AIDProducer.AsInteger);
    end;

    // Если такого продукта ещё нет
    if rc = 0
    then
    begin
      // Добавляем в базу сам продукт
      qProducts.InsertRecord(ARH);

      ARH.Field[ProductID.FieldName] := qProducts.PKValue;
      AProductID.AsInteger := qProducts.PKValue;
    end
    else
    begin
      // Если такой продукт уже есть
      // Запоминаем найденный первичный ключ
      ARH.Field[ProductID.FieldName] := QuerySearchProduct.PKValue;
      AProductID.AsInteger := QuerySearchProduct.PKValue;

      // Запоминаем поля семейства компонента
      ARH2 := TRecordHolder.Create(QuerySearchProduct.FDQuery);
      try
        // Все пустые поля заполняем значениями из найденного продукта
        ARH.UpdateNullValues(ARH2);
        ARH.Put(ASender);

        ARH.Field['ID'] := ARH.Field[ProductID.FieldName];
        // Обновляем продукт, если мы в нём что-то изменили
        qProducts.UpdateRecord(ARH);
      finally
        FreeAndNil(ARH2);
      end;
    end;

    // Код компонента не должен быть пустым
    Assert(not VarIsNull(ARH.Field[ProductID.FieldName]));
    // Код склада не должен быть пустым
    Assert(not VarIsNull(ARH.Field[StorehouseId.FieldName]));

    // Поле ID заполнять не будем
    AFieldHolder := ARH.Find('ID');
    FreeAndNil(AFieldHolder);

    // Помещаем наш компонент на склад
    qStoreHouseProducts.InsertRecord(ARH);
    Assert(qStoreHouseProducts.PKValue > 0);

    // Первичный ключ у нас - идентификатор связки "Продукт-склад"
    APK.AsInteger := qStoreHouseProducts.PKValue;

    // Заполняем код продукта
    AProductID.AsInteger := ARH.Field[ProductID.FieldName];
  finally
    FreeAndNil(ARH);
  end;

  inherited;
end;

procedure TQueryProductsBase.ApplyUpdate(ASender: TDataSet);
var
  ARH: TRecordHolder;
begin
  ARH := TRecordHolder.Create(ASender);
  try
    // Обновляем информацию о компоненте на складе
    qStoreHouseProducts.UpdateRecord(ARH);

    // Обновляем информацию о самом компоненте
    ARH.Field['ID'] := ARH.Field[ProductID.FieldName];
    qProducts.UpdateRecord(ARH);
  finally
    FreeAndNil(ARH);
  end;

  inherited;
end;

procedure TQueryProductsBase.ApplyUpdates;
begin
  TryPost;
  FDQuery.Connection.Commit;
end;

procedure TQueryProductsBase.CancelUpdates;
begin
  // отменяем все сделанные изменения на стороне клиента
  TryCancel;
  FDQuery.Connection.Rollback;
  RefreshQuery;
end;

procedure TQueryProductsBase.DoAfterOpen(Sender: TObject);
var
  AField: TField;
begin
  for AField in FDQuery.Fields do
  begin
    AField.ReadOnly := False;
    AField.Required := False;
  end;
end;

// TODO: GetComponentFamily
//function TQueryProductsBase.GetComponentFamily: String;
//var
//ComponentNameParts: TComponentNameParts;
//begin
//Assert(not Value.AsString.IsEmpty);
//Result := Value.AsString;
//
//// Разделяем имя компонента на части
//ComponentNameParts := SplitComponentName(Value.AsString);
//
//Result := IfThen(ComponentNameParts.Number = 0, ComponentNameParts.Name,
//  Format('%s%d', [ComponentNameParts.Name, ComponentNameParts.Number]))
//end;

function TQueryProductsBase.GetComponentGroup: TField;
begin
  Result := Field('ComponentGroup');
end;

function TQueryProductsBase.GetDescriptionID: TField;
begin
  Result := Field('DescriptionID');
end;

function TQueryProductsBase.GetIDProducer: TField;
begin
  Result := Field('IDProducer');
end;

function TQueryProductsBase.GetProductID: TField;
begin
  Result := Field('ProductID');
end;

function TQueryProductsBase.GetQueryProducers: TQueryProducers;
begin
  if FQueryProducers = nil then
  begin
    FQueryProducers := TQueryProducers.Create(Self);
    FQueryProducers.TryOpen;
  end;

  Result := FQueryProducers;
end;

function TQueryProductsBase.GetQuerySearchDaughterComponent
  : TQuerySearchDaughterComponent;
begin
  if FQuerySearchDaughterComponent = nil then
    FQuerySearchDaughterComponent := TQuerySearchDaughterComponent.Create(Self);
  Result := FQuerySearchDaughterComponent;
end;

function TQueryProductsBase.GetQuerySearchFamilytByID: TQuerySearchFamilyByID;
begin
  if FQuerySearchFamilytByID = nil then
    FQuerySearchFamilytByID := TQuerySearchFamilyByID.Create(Self);
  Result := FQuerySearchFamilytByID;
end;

function TQueryProductsBase.GetQuerySearchProduct: TQuerySearchProduct;
begin
  if FQuerySearchProduct = nil then
    FQuerySearchProduct := TQuerySearchProduct.Create(Self);

  Result := FQuerySearchProduct;
end;

function TQueryProductsBase.GetQuerySearchStorehouseProductByID
  : TQuerySearchStorehouseProductByID;
begin
  if FQuerySearchStorehouseProductByID = nil then
    FQuerySearchStorehouseProductByID :=
      TQuerySearchStorehouseProductByID.Create(Self);
  Result := FQuerySearchStorehouseProductByID;
end;

function TQueryProductsBase.GetStorehouseId: TField;
begin
  Result := Field('StorehouseId');
end;

function TQueryProductsBase.GetValue: TField;
begin
  Result := Field('Value');
end;

procedure TQueryProductsBase.LoadDocFile(const AFileName: String;
  ADocFieldInfo: TDocFieldInfo);
var
  S: String;
begin
  if not AFileName.IsEmpty then
  begin
    // В БД храним путь до файла относительно папки с документацией
    S := GetRelativeFileName(AFileName, ADocFieldInfo.Folder);
    TryEdit;
    FDQuery.FieldByName(ADocFieldInfo.FieldName).AsString := S;
    TryPost;
  end;
end;

function TQueryProductsBase.SplitComponentName(const S: string)
  : TComponentNameParts;
var
  Count: Integer;
  StartIndex: Integer;
begin
  // Предполагаем что компонент начинается с буквы, за которыми следуют цифры
  Result.Name := S;
  Result.Number := 0;
  Result.Ending := '';

  Count := 1;

  // Пока в начале строки не находим цифру
  while S.IndexOfAny(['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'], 0,
    Count) = -1 do
  begin
    Inc(Count);

    // Если в строке вообще нет цифр
    if Count > S.Length then
      Exit;
  end;

  Result.Name := S.Substring(0, Count - 1);
  StartIndex := Count - 1;

  // Пока в строке находим цифру
  while S.IndexOfAny(['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'],
    StartIndex) = StartIndex do
    Inc(StartIndex);

  Dec(StartIndex);

  // Если нашли хотя-бы одну цифру
  if StartIndex >= Count then
  begin
    Result.Number := StrToInt(S.Substring(Count - 1, StartIndex - Count));
    Result.Ending := S.Substring(StartIndex + 1);
  end;
end;

end.
