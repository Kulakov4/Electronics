unit ProductsBaseQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  ApplyQueryFrame, DocFieldInfo, SearchMainComponent2, StoreHouseListQuery,
  SearchProductParameterValuesQuery, CustomComponentsQuery,
  SearchDaughterComponentQuery, SearchMainComponentByID;

type
  TComponentNameParts = record
    Name: String;
    Number: cardinal;
    Ending: String;
  end;

  TQueryProductsBase = class(TQueryCustomComponents)
    qStoreHouseProducts: TfrmApplyQuery;
  private
    FQuerySearchDaughterComponent: TQuerySearchDaughterComponent;
    FQuerySearchMainComponent2: TQuerySearchMainComponent2;
    FQuerySearchMainComponentByID: TQuerySearchMainComponentByID;
    procedure DoAfterOpen(Sender: TObject);
    procedure DoBeforeOpen(Sender: TObject);
    function GetComponentFamily: String;
    function GetProductID: TField;
    function GetQuerySearchDaughterComponent: TQuerySearchDaughterComponent;
    function GetQuerySearchMainComponent2: TQuerySearchMainComponent2;
    function GetQuerySearchMainComponentByID: TQuerySearchMainComponentByID;
    function GetStorehouseId: TField;
    function SplitComponentName(const S: string): TComponentNameParts;
    { Private declarations }
  protected
    procedure ApplyDelete(ASender: TDataSet); override;
    procedure ApplyInsert(ASender: TDataSet); override;
    procedure ApplyUpdate(ASender: TDataSet); override;
    property QuerySearchDaughterComponent: TQuerySearchDaughterComponent
      read GetQuerySearchDaughterComponent;
    property QuerySearchMainComponent2: TQuerySearchMainComponent2
      read GetQuerySearchMainComponent2;
    property QuerySearchMainComponentByID: TQuerySearchMainComponentByID
      read GetQuerySearchMainComponentByID;
  public
    constructor Create(AOwner: TComponent); override;
    procedure ApplyUpdates; override;
    procedure CancelUpdates; override;
    procedure LoadDocFile(const AFileName: String;
      ADocFieldInfo: TDocFieldInfo);
    property ProductID: TField read GetProductID;
    property StorehouseId: TField read GetStorehouseId;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses System.Generics.Collections, LostComponentsQuery, DBRecordHolder,
  System.IOUtils, SettingsController, RepositoryDataModule, NotifyEvents,
  ParameterValuesUnit, StrHelper, System.StrUtils;

constructor TQueryProductsBase.Create(AOwner: TComponent);
begin
  inherited;

  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, FEventList);
  TNotifyEventWrap.Create(BeforeOpen, DoBeforeOpen, FEventList);

  // Будем сами обновлять запись
  FDQuery.OnUpdateRecord := DoOnQueryUpdateRecord;

  // По умолчанию мы не в режиме автоматических транзакций
  AutoTransaction := False;
end;

procedure TQueryProductsBase.ApplyDelete(ASender: TDataSet);
begin
  Assert(PKValue > 0);
  // Удаляем продукт со склада. Сам продукт не удаляем.
  qStoreHouseProducts.DeleteRecord(PKValue);

  // удалить компоненты которых нет ни на складе ни в дереве категорий
  // DeleteLostComponents;

  inherited;
end;

procedure TQueryProductsBase.ApplyInsert(ASender: TDataSet);
var
  AComponentFamily: String;
  AFieldHolder: TFieldHolder;
  APK: TField;
  AProductID: TField;
  ARH: TRecordHolder;
  ARH2: TRecordHolder;
  AValue: TField;
  rc: Integer;
  // ASenderField: TField;
begin
  APK := ASender.FieldByName(PKFieldName);
  AProductID := ASender.FieldByName(ProductID.FieldName);
  AValue := ASender.FieldByName(Value.FieldName);

  ARH := TRecordHolder.Create(ASender);
  try

    // Если такого компонента ещё нет
    if QuerySearchDaughterComponent.Search(ASender.FieldByName(Value.FieldName)
      .AsString) = 0 then
    begin
      // 1) надо вычислить к какому семейству он относится
      AComponentFamily := GetComponentFamily;
      // 2) Надо поискать такое семейство
      if QuerySearchMainComponent2.Search(AComponentFamily) = 0 then
      begin
        // нет ни такого семейства, ни такого компонента
        // Надо добавить и семейство, и компонент
        ARH.Field[Value.FieldName] := AComponentFamily;

        // Добавляем в базу семейство компонентов
        qProducts.InsertRecord(ARH);

        ARH.Field[Value.FieldName] := AValue.Value;
        ARH.Field['ParentProductID'] := qProducts.PKValue;

      end
      else
      begin
        // Такое семейство в базе уже есть
        ARH.Field['ParentProductID'] := QuerySearchMainComponent2.PKValue;
      end;

      // Добавляем в базу сам компонент
      qProducts.InsertRecord(ARH);

      ARH.Field[ProductID.FieldName] := qProducts.PKValue;
      AProductID.AsInteger := qProducts.PKValue;

      // Обрабатываем значения параметров
      UpdateParamValue(ProductID.FieldName, ASender);

    end
    else
    begin
      // Если такой компонент уже есть
      // Запоминаем найденный первичный ключ
      ARH.Field[ProductID.FieldName] := QuerySearchDaughterComponent.PKValue;
      AProductID.AsInteger := QuerySearchDaughterComponent.PKValue;

      // Ищем семейство найденного компонента
      rc := QuerySearchMainComponentByID.Search
        (QuerySearchDaughterComponent.ParentProductID.AsInteger);
      Assert(rc = 1);

      // Запоминаем поля семейства компонента
      ARH2 := TRecordHolder.Create(QuerySearchMainComponentByID.FDQuery);
      try
        // Все пустые поля заполняем значениями из семейства
        ARH.UpdateNullValues(ARH2);
        ARH.Put(ASender);
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

    // Обрабатываем обновление значений параметров
    UpdateParamValue(ProductID.FieldName, ASender);

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
    AField.ReadOnly := False;
end;

procedure TQueryProductsBase.DoBeforeOpen(Sender: TObject);
begin
  // Заполняем код параметра "Производитель"
  FDQuery.ParamByName('ProducerParameterID').AsInteger :=
    TParameterValues.ProducerParameterID;

  FDQuery.ParamByName('PackagePinsParameterID').AsInteger :=
    TParameterValues.PackagePinsParameterID;

  FDQuery.ParamByName('DatasheetParameterID').AsInteger :=
    TParameterValues.DatasheetParameterID;

  FDQuery.ParamByName('DiagramParameterID').AsInteger :=
    TParameterValues.DiagramParameterID;

  FDQuery.ParamByName('DrawingParameterID').AsInteger :=
    TParameterValues.DrawingParameterID;

  FDQuery.ParamByName('ImageParameterID').AsInteger :=
    TParameterValues.ImageParameterID;
end;

function TQueryProductsBase.GetComponentFamily: String;
var
  ComponentNameParts: TComponentNameParts;
begin
  Assert(not Value.AsString.IsEmpty);
  Result := Value.AsString;

  // Разделяем имя компонента на части
  ComponentNameParts := SplitComponentName(Value.AsString);

  Result := IfThen(ComponentNameParts.Number = 0, ComponentNameParts.Name,
    Format('%s%d', [ComponentNameParts.Name, ComponentNameParts.Number]))
end;

function TQueryProductsBase.GetProductID: TField;
begin
  Result := Field('ProductID');
end;

function TQueryProductsBase.GetQuerySearchDaughterComponent
  : TQuerySearchDaughterComponent;
begin
  if FQuerySearchDaughterComponent = nil then
    FQuerySearchDaughterComponent := TQuerySearchDaughterComponent.Create(Self);

  Result := FQuerySearchDaughterComponent;
end;

function TQueryProductsBase.GetQuerySearchMainComponent2
  : TQuerySearchMainComponent2;
begin
  if FQuerySearchMainComponent2 = nil then
    FQuerySearchMainComponent2 := TQuerySearchMainComponent2.Create(Self);
  Result := FQuerySearchMainComponent2;
end;

function TQueryProductsBase.GetQuerySearchMainComponentByID
  : TQuerySearchMainComponentByID;
begin
  if FQuerySearchMainComponentByID = nil then
    FQuerySearchMainComponentByID := TQuerySearchMainComponentByID.Create(Self);
  Result := FQuerySearchMainComponentByID;
end;

function TQueryProductsBase.GetStorehouseId: TField;
begin
  Result := Field('StorehouseId');
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
