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
  SearchStorehouseProductByID, ProducersQuery, NotifyEvents,
  SearchComponentGroup;

type
  TComponentNameParts = record
    Name: String;
    Number: cardinal;
    Ending: String;
  end;

  TLocateRec = record
    IDCategory: Integer;
    FamilyName: String;
    ComponentName: String;
  end;

  TQueryProductsBase = class(TQueryWithDataSource)
    qStoreHouseProducts: TfrmApplyQuery;
    qProducts: TfrmApplyQuery;
  private
    FOnLocate: TNotifyEventsEx;
    FqProducers: TQueryProducers;
    FqSearchComponentGroup: TQuerySearchComponentGroup;
    FqSearchDaughterComponent: TQuerySearchDaughterComponent;
    FqSearchFamilyByID: TQuerySearchFamilyByID;
    FqSearchProduct: TQuerySearchProduct;
    FqSearchStorehouseProductByID: TQuerySearchStorehouseProductByID;
    procedure DoAfterOpen(Sender: TObject);
    function GetDescriptionID: TField;
    function GetIDParent: TField;
    function GetIDProducer: TField;
    function GetIsGroup: TField;
    function GetProductID: TField;
    function GetqProducers: TQueryProducers;
    function GetqSearchComponentGroup: TQuerySearchComponentGroup;
    function GetqSearchDaughterComponent: TQuerySearchDaughterComponent;
    function GetqSearchFamilyByID: TQuerySearchFamilyByID;
    function GetqSearchProduct: TQuerySearchProduct;
    function GetqSearchStorehouseProductByID: TQuerySearchStorehouseProductByID;
    function GetStorehouseId: TField;
    function GetValue: TField;
    // TODO: SplitComponentName
    // function SplitComponentName(const S: string): TComponentNameParts;
    { Private declarations }
  protected
    procedure ApplyDelete(ASender: TDataSet); override;
    procedure ApplyInsert(ASender: TDataSet); override;
    procedure ApplyUpdate(ASender: TDataSet); override;
    function GetExportFileName: string; virtual; abstract;
    property qSearchComponentGroup: TQuerySearchComponentGroup
      read GetqSearchComponentGroup;
    property qSearchDaughterComponent: TQuerySearchDaughterComponent
      read GetqSearchDaughterComponent;
    property qSearchFamilyByID: TQuerySearchFamilyByID
      read GetqSearchFamilyByID;
    property qSearchProduct: TQuerySearchProduct read GetqSearchProduct;
    property qSearchStorehouseProductByID: TQuerySearchStorehouseProductByID
      read GetqSearchStorehouseProductByID;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AddCategory;
    procedure ApplyUpdates; override;
    procedure CancelUpdates; override;
    procedure LoadDocFile(const AFileName: String;
      ADocFieldInfo: TDocFieldInfo);
    function LocateInComponents: Boolean;
    property DescriptionID: TField read GetDescriptionID;
    property ExportFileName: string read GetExportFileName;
    property IDParent: TField read GetIDParent;
    property IDProducer: TField read GetIDProducer;
    property IsGroup: TField read GetIsGroup;
    property ProductID: TField read GetProductID;
    property qProducers: TQueryProducers read GetqProducers;
    property StorehouseId: TField read GetStorehouseId;
    property Value: TField read GetValue;
    property OnLocate: TNotifyEventsEx read FOnLocate;
    { Public declarations }
  end;

  TLocateObject = class(TObject)
  private
    FComponentName: string;
    FFamilyName: string;
    FIDCategory: Integer;
  public
    constructor Create(const AIDCategory: Integer;
      const AFamilyName, AComponentName: string);
    property ComponentName: string read FComponentName;
    property FamilyName: string read FFamilyName;
    property IDCategory: Integer read FIDCategory;
  end;

implementation

{$R *.dfm}

uses DBRecordHolder, System.IOUtils, SettingsController, RepositoryDataModule,
  ParameterValuesUnit, StrHelper, System.StrUtils;

constructor TQueryProductsBase.Create(AOwner: TComponent);
begin
  inherited;
  FOnLocate := TNotifyEventsEx.Create(Self);

  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, FEventList);

  // Будем сами обновлять запись
  FDQuery.OnUpdateRecord := DoOnQueryUpdateRecord;

  // По умолчанию мы не в режиме автоматических транзакций
  AutoTransaction := False;
end;

procedure TQueryProductsBase.AddCategory;
begin
  TryAppend;
  Value.AsString := 'Новая запись';
  IsGroup.AsInteger := 1;
end;

procedure TQueryProductsBase.ApplyDelete(ASender: TDataSet);
var
  AProductID: TField;
begin
  Assert(PK.Value > 0);

  AProductID := ASender.FieldByName(ProductID.FieldName);

  // Удаляем продукт со склада. Сам продукт не удаляем.
  qStoreHouseProducts.DeleteRecord(PK.Value);

  // Если подобных продуктов на складе больше нет
  if qSearchStorehouseProductByID.Search(AProductID.AsInteger) = 0 then
  begin
    // Удаляем продукт
    qProducts.DeleteRecord(AProductID.AsInteger);
  end;

  inherited;
end;

procedure TQueryProductsBase.ApplyInsert(ASender: TDataSet);
var
  AFieldHolder: TFieldHolder;
  ARH: TRecordHolder;
  ARH2: TRecordHolder;
  ARHFamily: TRecordHolder;
  OK: Boolean;
  rc: Integer;
begin
  Assert(ASender = FDQuery);

  if Value.AsString.Trim.IsEmpty then
    raise Exception.Create('Необходимо задать наименование');

  // Если надо сохранить только группу
  if IsGroup.AsInteger = 1 then
  begin
    // Ищем такую группу компонентов в справочнике
    rc := qSearchComponentGroup.Search(Value.AsString);
    if rc = 0 then
      qSearchComponentGroup.Append(Value.AsString);

    // Заполняем первичный ключ
    PK.Value := qSearchComponentGroup.PK.Value;
    Exit;
  end;

  // Если производитель задан
  if IDProducer.AsInteger > 0 then
  begin
    // Ищем производителя по коду
    OK := qProducers.LocateByPK(IDProducer.AsInteger);
    Assert(OK);

    rc := qSearchDaughterComponent.Search(Value.AsString,
      qProducers.Name.AsString);
  end
  else
  begin
    // Ищем в теоретической базе просто по наименованию
    rc := qSearchDaughterComponent.Search(Value.AsString);
    if rc > 0 then
    begin
      // Ищем в справочнике такого производителя
      qProducers.LocateOrAppend(qSearchDaughterComponent.Producer.AsString);
      // Заполняем производителя
      IDProducer.AsInteger := qProducers.PK.Value;
    end;
  end;

  ARH := TRecordHolder.Create(ASender);
  try
    // Если такой компонент найден в компонентой базе
    if rc > 0 then
    begin
      // Ищем соответствующее семейство компонентов
      rc := qSearchFamilyByID.Search
        (qSearchDaughterComponent.ParentProductID.AsInteger);
      Assert(rc = 1);

      ARHFamily := TRecordHolder.Create(qSearchFamilyByID.FDQuery);
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
        qSearchFamilyByID.Field(ADocFieldInfo.FieldName).AsString;
        end;
        // Заполняем ссылку на краткое описание
        ADescriptionID.AsInteger :=
        qSearchFamilyByID.DescriptionID.AsInteger;
      }
    end;

    // Если производитель не задан
    if IDProducer.AsInteger = 0 then
    begin
      // Ищем такой компонент с таким именем на складе
      rc := qSearchProduct.Search(Value.AsString);
      if rc > 0 then
        // Заполняем производителя
        IDProducer.AsInteger := qSearchProduct.IDProducer.AsInteger
      else
        raise Exception.Create('Необходимо задать производителя');
    end
    else
    begin
      // Если производитель задан
      rc := qSearchProduct.Search(Value.AsString, IDProducer.AsInteger);
    end;

    // Если такого продукта ещё нет
    if rc = 0 then
    begin
      // Добавляем в базу сам продукт
      qProducts.InsertRecord(ARH);

      ARH.Field[ProductID.FieldName] := qProducts.PKValue;
      ProductID.AsInteger := qProducts.PKValue;
    end
    else
    begin
      // Если такой продукт уже есть
      // Запоминаем найденный первичный ключ
      ARH.Field[ProductID.FieldName] := qSearchProduct.PK.Value;
      ProductID.AsInteger := qSearchProduct.PK.Value;

      // Запоминаем поля семейства компонента
      ARH2 := TRecordHolder.Create(qSearchProduct.FDQuery);
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
    PK.Value := qStoreHouseProducts.PKValue;

    // Заполняем код продукта
    ProductID.AsInteger := ARH.Field[ProductID.FieldName];
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
begin
  SetFieldsRequired(False);
  SetFieldsReadOnly(False);
end;

function TQueryProductsBase.GetDescriptionID: TField;
begin
  Result := Field('DescriptionID');
end;

function TQueryProductsBase.GetIDParent: TField;
begin
  Result := Field('IDParent');
end;

function TQueryProductsBase.GetIDProducer: TField;
begin
  Result := Field('IDProducer');
end;

function TQueryProductsBase.GetIsGroup: TField;
begin
  Result := Field('IsGroup');
end;

function TQueryProductsBase.GetProductID: TField;
begin
  Result := Field('ProductID');
end;

function TQueryProductsBase.GetqProducers: TQueryProducers;
begin
  if FqProducers = nil then
  begin
    FqProducers := TQueryProducers.Create(Self);
    FqProducers.TryOpen;
  end;

  Result := FqProducers;
end;

function TQueryProductsBase.GetqSearchComponentGroup
  : TQuerySearchComponentGroup;
begin
  if FqSearchComponentGroup = nil then
  begin
    FqSearchComponentGroup := TQuerySearchComponentGroup.Create(Self);
  end;
  Result := FqSearchComponentGroup;
end;

function TQueryProductsBase.GetqSearchDaughterComponent
  : TQuerySearchDaughterComponent;
begin
  if FqSearchDaughterComponent = nil then
    FqSearchDaughterComponent := TQuerySearchDaughterComponent.Create(Self);
  Result := FqSearchDaughterComponent;
end;

function TQueryProductsBase.GetqSearchFamilyByID: TQuerySearchFamilyByID;
begin
  if FqSearchFamilyByID = nil then
    FqSearchFamilyByID := TQuerySearchFamilyByID.Create(Self);
  Result := FqSearchFamilyByID;
end;

function TQueryProductsBase.GetqSearchProduct: TQuerySearchProduct;
begin
  if FqSearchProduct = nil then
    FqSearchProduct := TQuerySearchProduct.Create(Self);

  Result := FqSearchProduct;
end;

function TQueryProductsBase.GetqSearchStorehouseProductByID
  : TQuerySearchStorehouseProductByID;
begin
  if FqSearchStorehouseProductByID = nil then
    FqSearchStorehouseProductByID :=
      TQuerySearchStorehouseProductByID.Create(Self);
  Result := FqSearchStorehouseProductByID;
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

function TQueryProductsBase.LocateInComponents: Boolean;
var
  AIDCategory: Integer;
  OK: Boolean;
  rc: Integer;
  LR: TLocateObject;
  m: TArray<String>;
begin
  rc := 0;
  // Если производитель задан
  if IDProducer.AsInteger > 0 then
  begin
    // Ищем производителя по коду
    OK := qProducers.LocateByPK(IDProducer.AsInteger);
    Assert(OK);

    rc := qSearchDaughterComponent.Search(Value.AsString,
      qProducers.Name.AsString);
  end;
  if rc > 0 then
  begin
    // Ищем соответствующее семейство компонентов
    rc := qSearchFamilyByID.Search
      (qSearchDaughterComponent.ParentProductID.AsInteger);

  end;
  Result := rc > 0;

  if Result then
  begin
    m := qSearchFamilyByID.CategoryIDList.AsString.Split([',']);
    Assert(Length(m) > 0);

    AIDCategory := String.ToInteger(m[0]);

    LR := TLocateObject.Create(AIDCategory, qSearchFamilyByID.Value.AsString,
      qSearchDaughterComponent.Value.AsString);
    try
      OnLocate.CallEventHandlers(LR);
    finally
      FreeAndNil(LR);
    end;

  end;
end;

// TODO: SplitComponentName
// function TQueryProductsBase.SplitComponentName(const S: string)
// : TComponentNameParts;
// var
// Count: Integer;
// StartIndex: Integer;
// begin
/// / Предполагаем что компонент начинается с буквы, за которыми следуют цифры
// Result.Name := S;
// Result.Number := 0;
// Result.Ending := '';
//
// Count := 1;
//
/// / Пока в начале строки не находим цифру
// while S.IndexOfAny(['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'], 0,
// Count) = -1 do
// begin
// Inc(Count);
//
// // Если в строке вообще нет цифр
// if Count > S.Length then
// Exit;
// end;
//
// Result.Name := S.Substring(0, Count - 1);
// StartIndex := Count - 1;
//
/// / Пока в строке находим цифру
// while S.IndexOfAny(['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'],
// StartIndex) = StartIndex do
// Inc(StartIndex);
//
// Dec(StartIndex);
//
/// / Если нашли хотя-бы одну цифру
// if StartIndex >= Count then
// begin
// Result.Number := StrToInt(S.Substring(Count - 1, StartIndex - Count));
// Result.Ending := S.Substring(StartIndex + 1);
// end;
// end;

constructor TLocateObject.Create(const AIDCategory: Integer;
  const AFamilyName, AComponentName: string);
begin
  inherited Create;
  Assert(AIDCategory > 0);
  Assert(not AFamilyName.IsEmpty);
  Assert(not AComponentName.IsEmpty);

  FIDCategory := AIDCategory;
  FFamilyName := AFamilyName;
  FComponentName := AComponentName;
end;

end.
