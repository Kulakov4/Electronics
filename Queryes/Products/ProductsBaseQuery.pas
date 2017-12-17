unit ProductsBaseQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  ApplyQueryFrame, DocFieldInfo, SearchProductParameterValuesQuery,
  SearchProductQuery, QueryWithDataSourceUnit, CustomComponentsQuery,
  SearchComponentOrFamilyQuery, System.Generics.Collections,
  SearchStorehouseProduct, ProducersQuery, NotifyEvents,
  SearchComponentGroup, SearchFamily, ProducersGroupUnit;

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
    procedure FDQueryCalcFields(DataSet: TDataSet);
  private
    FNotGroupClone: TFDMemTable;
    FOnLocate: TNotifyEventsEx;
    FProducersGroup: TProducersGroup;
    FqSearchComponentGroup: TQuerySearchComponentGroup;
    FqSearchComponentOrFamily: TQuerySearchComponentOrFamily;
    FqSearchFamily: TQuerySearchFamily;
    FqSearchProduct: TQuerySearchProduct;
    FqSearchStorehouseProduct: TQuerySearchStorehouseProduct;
    FRate: Double;
    procedure DoAfterOpen(Sender: TObject);
    procedure DoBeforeOpen(Sender: TObject);
    function GetDatasheet: TField;
    function GetDescriptionID: TField;
    function GetDiagram: TField;
    function GetDrawing: TField;
    function GetIDComponentGroup: TField;
    function GetIDCurrency: TField;
    function GetIDProducer: TField;
    function GetImage: TField;
    function GetIsGroup: TField;
    function GetPrice: TField;
    function GetPriceD: TField;
    function GetPriceD1: TField;
    function GetPriceD2: TField;
    function GetPriceR: TField;
    function GetPriceR1: TField;
    function GetPriceR2: TField;
    function GetProductID: TField;
    function GetProducersGroup: TProducersGroup;
    function GetqSearchComponentGroup: TQuerySearchComponentGroup;
    function GetqSearchComponentOrFamily: TQuerySearchComponentOrFamily;
    function GetqSearchFamily: TQuerySearchFamily;
    function GetqSearchProduct: TQuerySearchProduct;
    function GetqSearchStorehouseProduct: TQuerySearchStorehouseProduct;
    function GetRate1: TField;
    function GetRate2: TField;
    function GetStorehouseId: TField;
    function GetValue: TField;
    procedure SetRate(const Value: Double);
    // TODO: SplitComponentName
    // function SplitComponentName(const S: string): TComponentNameParts;
    { Private declarations }
  protected
    FEnableCalc: Boolean;
    procedure ApplyDelete(ASender: TDataSet); override;
    procedure ApplyInsert(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure ApplyUpdate(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    function CreateClone(AIDComponentGroup: Integer): TFDMemTable;
    function GetExportFileName: string; virtual; abstract;
    function GetProcurementPrice: Variant;
    function LookupComponentGroup(const AComponentGroup: string): Variant;
    procedure OnDatasheetGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    property qSearchComponentGroup: TQuerySearchComponentGroup
      read GetqSearchComponentGroup;
    property qSearchComponentOrFamily: TQuerySearchComponentOrFamily
      read GetqSearchComponentOrFamily;
    property qSearchFamily: TQuerySearchFamily read GetqSearchFamily;
    property qSearchProduct: TQuerySearchProduct read GetqSearchProduct;
    property qSearchStorehouseProduct: TQuerySearchStorehouseProduct
      read GetqSearchStorehouseProduct;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AddCategory;
    procedure AddProduct(AIDComponentGroup: Integer);
    procedure ApplyUpdates; override;
    procedure CancelUpdates; override;
    procedure DeleteNode(AID: Integer);
    procedure DeleteNotUsedProducts(AProductIDS: TList<Integer>);
    procedure LoadDocFile(const AFileName: String;
      ADocFieldInfo: TDocFieldInfo);
    function LocateInComponents: Boolean;
    procedure TunePriceFields(const AFields: Array of TField);
    procedure UpdateRate(AID: Integer; RateField: TField; ARate: Double;
      AUpdatedIDList: TList<Integer>);
    property Datasheet: TField read GetDatasheet;
    property DescriptionID: TField read GetDescriptionID;
    property Diagram: TField read GetDiagram;
    property Drawing: TField read GetDrawing;
    property ExportFileName: string read GetExportFileName;
    property IDComponentGroup: TField read GetIDComponentGroup;
    property IDCurrency: TField read GetIDCurrency;
    property IDProducer: TField read GetIDProducer;
    property Image: TField read GetImage;
    property IsGroup: TField read GetIsGroup;
    property NotGroupClone: TFDMemTable read FNotGroupClone;
    property Price: TField read GetPrice;
    property PriceD: TField read GetPriceD;
    property PriceD1: TField read GetPriceD1;
    property PriceD2: TField read GetPriceD2;
    property PriceR: TField read GetPriceR;
    property PriceR1: TField read GetPriceR1;
    property PriceR2: TField read GetPriceR2;
    property ProductID: TField read GetProductID;
    property ProducersGroup: TProducersGroup read GetProducersGroup;
    property Rate: Double read FRate write SetRate;
    property Rate1: TField read GetRate1;
    property Rate2: TField read GetRate2;
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
  TNotifyEventWrap.Create(BeforeOpen, DoBeforeOpen, FEventList);

  // Будем сами обновлять запись
  FDQuery.OnUpdateRecord := DoOnQueryUpdateRecord;

  // Текущий курс доллара по отношению к рублю загружаем из хранилища настроек
  FRate := TSettings.Create.Rate;

  // По умолчанию мы не в режиме автоматических транзакций
  AutoTransaction := False;

  FEnableCalc := True;

  FNotGroupClone := AddClone('IsGroup=0');
end;

procedure TQueryProductsBase.AddCategory;
begin
  TryAppend;
  Value.AsString := 'Новая запись';
  IsGroup.AsInteger := 1;
end;

procedure TQueryProductsBase.AddProduct(AIDComponentGroup: Integer);
begin
  Assert(AIDComponentGroup > 0);
  // FDQuery.DisableControls;
  TryAppend;
  Value.AsString := 'Новая запись';
  IsGroup.AsInteger := 0;
  IDComponentGroup.AsInteger := AIDComponentGroup;
  // FDQuery.EnableControls;
end;

procedure TQueryProductsBase.ApplyDelete(ASender: TDataSet);
var
  AProductIDS: TList<Integer>;
begin
  Assert(ASender = FDQuery);

  // Список кодов продуктов которые мы удалили с текущего склада
  AProductIDS := TList<Integer>.Create;
  try

    // Если это группа
    if IsGroup.AsInteger = 1 then
    begin
      Assert(PK.Value > 0);
      // Ищем такую группу
      if qSearchComponentGroup.SearchByID(PK.Value) = 0 then
        Exit;

      // Группу удалять не надо. Надо удалить с текущего склада все компоненты этой группы
      // Ищем компоненты на текущем складе, которые принадлежат этой группе
      if qSearchStorehouseProduct.SearchByGroupID(StorehouseId.AsInteger,
        PK.Value) = 0 then
        Exit;

      // Удаляем с текущего склада все найденные компоненты относящиеся к группе
      while qSearchStorehouseProduct.FDQuery.RecordCount > 0 do
      begin
        // Запоминаем, что этот продукт мы удалили со склада
        if AProductIDS.IndexOf(qSearchStorehouseProduct.ProductID.AsInteger) < 0
        then
          AProductIDS.Add(qSearchStorehouseProduct.ProductID.AsInteger);

        qSearchStorehouseProduct.FDQuery.Delete;
      end;

      DeleteNotUsedProducts(AProductIDS);
    end
    else
    begin
      Assert(PK.Value < 0);
      if qSearchStorehouseProduct.SearchByID(-PK.Value) = 0 then
        Exit;

      AProductIDS.Add(ProductID.AsInteger);

      // Удаляем продукт со склада. Сам продукт не удаляем.
      qSearchStorehouseProduct.FDQuery.Delete;

      // Удаляем неиспользованные продукты
      DeleteNotUsedProducts(AProductIDS);
    end;
  finally
    FreeAndNil(AProductIDS);
  end;

  inherited;
end;

procedure TQueryProductsBase.ApplyInsert(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
var
  // AFieldHolder: TFieldHolder;
  ARH: TRecordHolder;
  // ARH2: TRecordHolder;
  ARHFamily: TRecordHolder;
  OK: Boolean;
  rc: Integer;
begin
  Assert(ASender = FDQuery);

  if Value.AsString.Trim.IsEmpty then
    raise Exception.Create('Необходимо задать наименование');

  Assert(not IsGroup.IsNull);

  // Если надо сохранить только группу
  if IsGroup.AsInteger = 1 then
  begin
    // Ищем такую группу компонентов в справочнике
    rc := qSearchComponentGroup.SearchByValue(Value.AsString);
    if rc = 0 then
    begin
      qSearchComponentGroup.Append(Value.AsString);
    end;

    // Заполняем первичный ключ
    FetchFields([PK.FieldName], [qSearchComponentGroup.PK.Value], ARequest,
      AAction, AOptions);
    // PK.Value := qSearchComponentGroup.PK.Value;
    Exit;
  end;

  // Если производитель задан
  if IDProducer.AsInteger > 0 then
  begin
    // Ищем производителя по коду
    OK := ProducersGroup.qProducers.LocateByPK(IDProducer.AsInteger);
    Assert(OK);

    rc := qSearchComponentOrFamily.SearchComponentWithProducer(Value.AsString,
      ProducersGroup.qProducers.Name.AsString);
  end
  else
  begin
    // Ищем в теоретической базе просто по наименованию
    rc := qSearchComponentOrFamily.SearchComponentWithProducer(Value.AsString);
    if rc > 0 then
    begin
      // Ищем в справочнике такого производителя
      OK := ProducersGroup.qProducers.Locate
        (qSearchComponentOrFamily.Producer.AsString);
      Assert(OK);
      // Заполняем производителя
      FetchFields([IDProducer.FieldName], [ProducersGroup.qProducers.PK.Value],
        ARequest, AAction, AOptions);
    end;
  end;

  ARH := TRecordHolder.Create(ASender);
  try
    // Если такой компонент найден в компонентой базе
    if rc > 0 then
    begin
      // Ищем соответствующее семейство компонентов
      rc := qSearchFamily.SearchByID
        (qSearchComponentOrFamily.ParentProductID.AsInteger);
      Assert(rc = 1);

      ARHFamily := TRecordHolder.Create(qSearchFamily.FDQuery);
      try
        // Обновляем пустые значения
        ARH.UpdateNullValues(ARHFamily);
        ARH.Put(ASender);
      finally
        FreeAndNil(ARHFamily)
      end;
    end;

    // Если производитель не задан
    if IDProducer.AsInteger = 0 then
    begin
      // Ищем такой компонент с таким именем на складе
      rc := qSearchProduct.SearchByValue(Value.AsString);
      if rc > 0 then
        // Заполняем производителя
        FetchFields([IDProducer.FieldName], [qSearchProduct.IDProducer.Value],
          ARequest, AAction, AOptions)
        // IDProducer.AsInteger := qSearchProduct.IDProducer.AsInteger
      else
        raise Exception.Create('Необходимо задать производителя');
    end
    else
    begin
      // Если производитель задан
      rc := qSearchProduct.SearchByValue(Value.AsString, IDProducer.AsInteger);
    end;

    // Если такого продукта ещё нет
    if rc = 0 then
    begin
      // Добавляем в базу сам продукт
      qSearchProduct.InsertRecord(ARH);
    end;

    ARH.Field[ProductID.FieldName] := qSearchProduct.PK.Value;

    // Заполняем код продукта
    FetchFields([ProductID.FieldName], [qSearchProduct.PK.Value], ARequest,
      AAction, AOptions);

    // ProductID.AsInteger := qSearchProduct.PK.Value;

    // Если такой продукт уже есть
    if rc > 0 then
    begin
      // Заполняем пустые поля значениями найденного компонента
      FetchNullValues(qSearchProduct.FDQuery, ARequest, AAction, AOptions,
        String.Format('%s->%s', [qSearchProduct.PK.FieldName,
        ProductID.FieldName]));
    end;

    // Готовимся вставить закупочную цену компонента
    if not VarIsNull(GetProcurementPrice) then
      ARH.Field[Price.FieldName] := GetProcurementPrice;

    // Помещаем наш компонент на склад
    if not qSearchStorehouseProduct.FDQuery.Active then
      qSearchStorehouseProduct.SearchByID(1);

    qSearchStorehouseProduct.InsertRecord(ARH);

    // Первичный ключ у нас - идентификатор связки "Продукт-склад" с отрицательным значением
    FetchFields([PK.FieldName], [-qSearchStorehouseProduct.PK.Value], ARequest,
      AAction, AOptions);
    // PK.Value := -qSearchStorehouseProduct.PK.Value;
  finally
    FreeAndNil(ARH);
  end;

  inherited;
end;

procedure TQueryProductsBase.ApplyUpdate(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
var
  ARH: TRecordHolder;
  V: Variant;
begin
  Assert(ASender = FDQuery);

  ARH := TRecordHolder.Create(ASender);
  try
    if IsGroup.AsInteger = 1 then
    begin
      Assert(PK.Value > 0);
      // Ищем такую группу
      if qSearchComponentGroup.SearchByID(PK.Value) = 0 then
        Exit;

      // Будем обновлять одно поле
      ARH.Clear;
      TFieldHolder.Create(ARH, qSearchComponentGroup.ComponentGroup.FieldName,
        Value.AsString);

      qSearchComponentGroup.UpdateRecord(ARH);

    end
    else
    begin
      Assert(PK.Value < 0);
      // Ищем по идентификатору связки склад-продукт
      qSearchStorehouseProduct.SearchByID(-PK.Value);

      V := GetProcurementPrice;
      if not VarIsNull(V) then
      begin
        ARH.Field[Price.FieldName] := V;

        FetchFields([Price.FieldName], [V], ARequest, AAction, AOptions);
      end;
      // Обновляем информацию о компоненте на складе
      qSearchStorehouseProduct.UpdateRecord(ARH);

      // Обновляем информацию о самом компоненте
      qSearchProduct.SearchByID(ProductID.AsInteger);
      qSearchProduct.UpdateRecord(ARH);
    end;
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
var
  V: Variant;
begin
  // отменяем все сделанные изменения на стороне клиента
  TryCancel;

  V := PK.Value;
  FDQuery.DisableControls;
  try
    FDQuery.Connection.Rollback;
    RefreshQuery;
    if not VarIsNull(V) then
      LocateByPK(V);
  finally
    FDQuery.EnableControls;
  end;

end;

function TQueryProductsBase.CreateClone(AIDComponentGroup: Integer)
  : TFDMemTable;
begin
  Assert(AIDComponentGroup > 0);
  Result := TFDMemTable.Create(Self);
  Result.CloneCursor(FDQuery);
  Result.Filter := Format('IDComponentGroup=%d', [AIDComponentGroup]);
  Result.Filtered := True;
end;

procedure TQueryProductsBase.DeleteNode(AID: Integer);
var
  AClone: TFDMemTable;
  OK: Boolean;
begin
  // FDQuery.DisableControls;
  try
    // Ищем запись которую надо удалить
    OK := LocateByPK(AID);
    Assert(OK);

    // Если нужно удалить группу
    if IsGroup.AsInteger = 1 then
    begin
      AClone := CreateClone(PK.AsInteger);
      try
        // Удаляем все компоненты группы
        while AClone.RecordCount > 0 do
          DeleteNode(AClone.FieldByName('ID').AsInteger);

      finally
        FreeAndNil(AClone);
      end;

      // Снова переходим на группу
      OK := LocateByPK(AID);
      Assert(OK);
    end;
    FDQuery.Delete;
  finally
    // FDQuery.EnableControls;
  end;
end;

procedure TQueryProductsBase.DeleteNotUsedProducts(AProductIDS: TList<Integer>);
var
  AProductID: Integer;
begin
  Assert(AProductIDS <> nil);

  for AProductID in AProductIDS do
  begin
    // Если подобных продуктов на складах больше нет
    if qSearchStorehouseProduct.SearchByProductID(AProductID) = 0 then
    begin
      // Удаляем продукт
      if qSearchProduct.SearchByID(AProductID) > 0 then
        qSearchProduct.FDQuery.Delete;
    end;
  end;
end;

procedure TQueryProductsBase.DoAfterOpen(Sender: TObject);
begin
  SetFieldsRequired(False);
  SetFieldsReadOnly(False);

  Datasheet.OnGetText := OnDatasheetGetText;
  Diagram.OnGetText := OnDatasheetGetText;
  Drawing.OnGetText := OnDatasheetGetText;
  Image.OnGetText := OnDatasheetGetText;
end;

procedure TQueryProductsBase.DoBeforeOpen(Sender: TObject);
begin;
  if FDQuery.FieldDefs.Count > 0 then
  begin
    FDQuery.FieldDefs.Clear;
    FDQuery.Fields.Clear;
  end;

  FDQuery.FieldDefs.Update;

  // Закупочная цена
  FDQuery.FieldDefs.Add('PriceR', ftFloat);
  FDQuery.FieldDefs.Add('PriceD', ftFloat);

  // Розничная цена
  FDQuery.FieldDefs.Add('PriceR1', ftFloat);
  FDQuery.FieldDefs.Add('PriceD1', ftFloat);

  // Оптовая цена
  FDQuery.FieldDefs.Add('PriceR2', ftFloat);
  FDQuery.FieldDefs.Add('PriceD2', ftFloat);

  CreateDefaultFields(False);
  TunePriceFields([PriceD, PriceR, PriceD1, PriceR1, PriceD2, PriceR2]);
end;

procedure TQueryProductsBase.FDQueryCalcFields(DataSet: TDataSet);
begin
  inherited;

  // Exit;
  if (not FEnableCalc) or (IDCurrency.AsInteger = 0) or (Price.IsNull) then
    Exit;

  if IDCurrency.AsInteger = 1 then
  begin
    // Если исходная цена была в рублях
    PriceR.Value := Price.Value;
    PriceD.Value := Price.Value / Rate;
  end;

  if IDCurrency.AsInteger = 2 then
  begin
    // Если исходная цена была в долларах
    PriceR.Value := Price.Value * Rate;
    PriceD.Value := Price.Value;
  end;

  // Розничная цена
  PriceR1.Value := PriceR.Value * Rate1.Value;
  PriceD1.Value := PriceD.Value * Rate1.Value;

  // Оптовая цена
  PriceR2.Value := PriceR.Value * Rate2.Value;
  PriceD2.Value := PriceD.Value * Rate2.Value;
end;

function TQueryProductsBase.GetDatasheet: TField;
begin
  Result := Field('Datasheet');
end;

function TQueryProductsBase.GetDescriptionID: TField;
begin
  Result := Field('DescriptionID');
end;

function TQueryProductsBase.GetDiagram: TField;
begin
  Result := Field('Diagram');
end;

function TQueryProductsBase.GetDrawing: TField;
begin
  Result := Field('Drawing');
end;

function TQueryProductsBase.GetIDComponentGroup: TField;
begin
  Result := Field('IDComponentGroup');
end;

function TQueryProductsBase.GetIDCurrency: TField;
begin
  Result := Field('IDCurrency');
end;

function TQueryProductsBase.GetIDProducer: TField;
begin
  Result := Field('IDProducer');
end;

function TQueryProductsBase.GetImage: TField;
begin
  Result := Field('Image');
end;

function TQueryProductsBase.GetIsGroup: TField;
begin
  Result := Field('IsGroup');
end;

function TQueryProductsBase.GetPrice: TField;
begin
  Result := Field('Price');
end;

function TQueryProductsBase.GetPriceD: TField;
begin
  Result := Field('PriceD');
end;

function TQueryProductsBase.GetPriceD1: TField;
begin
  Result := Field('PriceD1');
end;

function TQueryProductsBase.GetPriceD2: TField;
begin
  Result := Field('PriceD2');
end;

function TQueryProductsBase.GetPriceR: TField;
begin
  Result := Field('PriceR');
end;

function TQueryProductsBase.GetPriceR1: TField;
begin
  Result := Field('PriceR1');
end;

function TQueryProductsBase.GetPriceR2: TField;
begin
  Result := Field('PriceR2');
end;

function TQueryProductsBase.GetProcurementPrice: Variant;
begin
  Result := null;
  case IDCurrency.AsInteger of
    1:
      Result := PriceR.Value;
    2:
      Result := PriceD.Value
  end;
end;

function TQueryProductsBase.GetProductID: TField;
begin
  Result := Field('ProductID');
end;

function TQueryProductsBase.GetProducersGroup: TProducersGroup;
begin
  if FProducersGroup = nil then
  begin
    FProducersGroup := TProducersGroup.Create(Self);
    FProducersGroup.ReOpen;
  end;

  Result := FProducersGroup;
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

function TQueryProductsBase.GetqSearchComponentOrFamily
  : TQuerySearchComponentOrFamily;
begin
  if FqSearchComponentOrFamily = nil then
    FqSearchComponentOrFamily := TQuerySearchComponentOrFamily.Create(Self);

  Result := FqSearchComponentOrFamily;
end;

function TQueryProductsBase.GetqSearchFamily: TQuerySearchFamily;
begin
  if FqSearchFamily = nil then
    FqSearchFamily := TQuerySearchFamily.Create(Self);
  Result := FqSearchFamily;
end;

function TQueryProductsBase.GetqSearchProduct: TQuerySearchProduct;
begin
  if FqSearchProduct = nil then
    FqSearchProduct := TQuerySearchProduct.Create(Self);

  Result := FqSearchProduct;
end;

function TQueryProductsBase.GetqSearchStorehouseProduct
  : TQuerySearchStorehouseProduct;
begin
  if FqSearchStorehouseProduct = nil then
    FqSearchStorehouseProduct := TQuerySearchStorehouseProduct.Create(Self);
  Result := FqSearchStorehouseProduct;
end;

function TQueryProductsBase.GetRate1: TField;
begin
  Result := Field('Rate1');
end;

function TQueryProductsBase.GetRate2: TField;
begin
  Result := Field('Rate2');
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
  ABrowseState: Boolean;
  S: String;
begin
  if not AFileName.IsEmpty then
  begin
    // В БД храним путь до файла относительно папки с документацией
    S := GetRelativeFileName(AFileName, ADocFieldInfo.Folder);
    ABrowseState := FDQuery.State = dsBrowse;
    TryEdit;
    FDQuery.FieldByName(ADocFieldInfo.FieldName).AsString := S;
    if ABrowseState then
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
    OK := ProducersGroup.qProducers.LocateByPK(IDProducer.AsInteger);
    Assert(OK);

    rc := qSearchComponentOrFamily.SearchComponentWithProducer(Value.AsString,
      ProducersGroup.qProducers.Name.AsString);
  end;
  if rc > 0 then
  begin
    // Ищем соответствующее семейство компонентов
    rc := qSearchFamily.SearchByID
      (qSearchComponentOrFamily.ParentProductID.AsInteger);

  end;
  Result := rc > 0;

  if Result then
  begin
    m := qSearchFamily.CategoryIDList.AsString.Split([',']);
    Assert(Length(m) > 0);

    AIDCategory := String.ToInteger(m[0]);

    LR := TLocateObject.Create(AIDCategory, qSearchFamily.Value.AsString,
      qSearchComponentOrFamily.Value.AsString);
    try
      OnLocate.CallEventHandlers(LR);
    finally
      FreeAndNil(LR);
    end;

  end;
end;

function TQueryProductsBase.LookupComponentGroup(const AComponentGroup
  : string): Variant;
var
  AKeyFields: string;
  V: Variant;
begin
  AKeyFields := Format('%s;%s', [Value.FieldName, IsGroup.FieldName]);

  V := FDQuery.LookupEx(AKeyFields, VarArrayOf([AComponentGroup, 1]),
    PKFieldName, [lxoCaseInsensitive]);

  Result := V;
end;

procedure TQueryProductsBase.OnDatasheetGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if not Sender.AsString.IsEmpty then
    Text := TPath.GetFileNameWithoutExtension(Sender.AsString);
end;

procedure TQueryProductsBase.SetRate(const Value: Double);
begin
  if FRate <> Value then
  begin
    FRate := Value;
    TSettings.Create.Rate := FRate;
  end;
end;

procedure TQueryProductsBase.TunePriceFields(const AFields: Array of TField);
var
  I: Integer;
begin
  Assert(High(AFields) > 0);

  for I := Low(AFields) to High(AFields) do
  begin
    AFields[I].FieldKind := fkInternalCalc;
    (AFields[I] as TNumericField).DisplayFormat := '### ##0.00';
  end;
end;

procedure TQueryProductsBase.UpdateRate(AID: Integer; RateField: TField;
  ARate: Double; AUpdatedIDList: TList<Integer>);
var
  AClone: TFDMemTable;
  OK: Boolean;
begin
  Assert(AID <> 0);

  // Если запись с этим идентификатором уже обновляли
  if AUpdatedIDList.IndexOf(AID) >= 0 then
    Exit;

  OK := LocateByPK(AID);
  Assert(OK);

  // Если пытаемся применить коэффициент к группе
  if IsGroup.AsInteger = 1 then
  begin
    AClone := CreateClone(PK.AsInteger);
    try
      AClone.First;
      while not AClone.Eof do
      begin
        UpdateRate(AClone.FieldByName('ID').AsInteger, RateField, ARate,
          AUpdatedIDList);
        AClone.Next;
      end;
    finally
      FreeAndNil(AClone);
    end;

  end
  else
  begin
    TryEdit;
    RateField.Value := ARate;
    TryPost;
    AUpdatedIDList.Add(AID);
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
