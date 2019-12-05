unit ProductsQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  System.Generics.Collections, ProductsBaseQuery,
  StoreHouseProductsCountQuery, RepositoryDataModule, cxGridDBBandedTableView,
  DBRecordHolder, ApplyQueryFrame, ProductsExcelDataModule, NotifyEvents,
  CheckDuplicateInterface, CustomExcelTable;

type
  TQueryProducts = class(TQueryProductsBase, ICheckDuplicate)
  strict private
    function HaveDuplicate(AExcelTable: TCustomExcelTable): Boolean; stdcall;
  private
    FNeedDecTotalCount: Boolean;
    FNeedUpdateCount: Boolean;
    FqStoreHouseProductsCount: TQueryStoreHouseProductsCount;
    FTotalCount: Integer;
    class var FObjectCount: Integer;
    procedure DoAfterInsert(Sender: TObject);
    procedure DoAfterOpen(Sender: TObject);
    procedure DoAfterCancelUpdates(Sender: TObject);
    // TODO: DoBeforeOpen
    // procedure DoBeforeOpen(Sender: TObject);
    function GetqStoreHouseProductsCount: TQueryStoreHouseProductsCount;
    function GetStoreHouseName: string;
    function GetTotalCount: Integer;
    { Private declarations }
  protected
    procedure DoAfterDelete(Sender: TObject);
    procedure DoAfterPost(Sender: TObject);
    procedure DoBeforeDelete(Sender: TObject);
    function GetExportFileName: string; override;
    property qStoreHouseProductsCount: TQueryStoreHouseProductsCount
      read GetqStoreHouseProductsCount;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AfterConstruction; override;
    procedure LoadDataFromExcelTable(AExcelTable: TProductsExcelTable);
    procedure AppendRows(AValues: TList<String>;
      const AProducers: TList<String>); overload;
    function SearchByID(AIDArray: TArray<Integer>): Integer;
    function SearchForBasket: Integer;
    property StoreHouseName: string read GetStoreHouseName;
    property TotalCount: Integer read GetTotalCount;
    { Public declarations }
  end;

implementation

uses System.Generics.Defaults, System.Types, System.StrUtils, System.Math,
  ParameterValuesUnit, StoreHouseListQuery, IDTempTableQuery, StrHelper,
  BaseQuery, ProducersGroupUnit2;

{$R *.dfm}
{ TfrmQueryStoreHouseComponents }

constructor TQueryProducts.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Inc(FObjectCount);
  Name := Format('QueryProducts_%d', [FObjectCount]);

  W.Name := 'QueryProductsWrap';

  // FDQuery.AutoCalcFields := False;

  FNeedUpdateCount := True;

  DetailParameterName := W.StorehouseId.FieldName;

  TNotifyEventWrap.Create(AfterCancelUpdates, DoAfterCancelUpdates,
    W.EventList);

  TNotifyEventWrap.Create(W.AfterInsert, DoAfterInsert, W.EventList);
  TNotifyEventWrap.Create(W.AfterOpen, DoAfterOpen, W.EventList);
  TNotifyEventWrap.Create(W.AfterPostM, DoAfterPost, W.EventList);
  TNotifyEventWrap.Create(W.BeforeDelete, DoBeforeDelete, W.EventList);
  TNotifyEventWrap.Create(W.AfterDelete, DoAfterDelete, W.EventList);
end;

procedure TQueryProducts.AfterConstruction;
var
  ANewSQL: string;
  AStipulation: string;
begin
  // Сохраняем первоначальный SQL
  inherited;

  // Добавляем в SQL запрос условие - кол-во > 0
  AStipulation := Format('%s > 0', [W.Amount.FullName]);
  ANewSQL := ReplaceInSQL(SQL, AStipulation, 100);
  ANewSQL := ReplaceInSQL(ANewSQL, AStipulation, 101);

  // Добавляем в SQL запрос параметр - идентификатор склада
  FDQuery.SQL.Text := ReplaceInSQL(ANewSQL,
    Format('%s = :%s', [W.StorehouseId.FullName, W.StorehouseId.FieldName]), 0);
  SetParamType(W.StorehouseId.FieldName);

  W.ApplyAmountFilter;
end;

procedure TQueryProducts.LoadDataFromExcelTable(AExcelTable
  : TProductsExcelTable);
var
  AExcelField: TField;
  AField: TField;
  AIDComponentGroup: Integer;
  V: Variant;
begin
  // ****************************************************************************
  // Снача добавим все группы компонентов и производителей и сохраним в БД
  // ****************************************************************************

  // Чтобы при изменении любого поля не происходил пересчёт автовычисляемых полей
  DisableCalc;
  AExcelTable.First;
  while not AExcelTable.Eof do
  begin
    // 1) Ищем такую группу компонентов на текущем складе
    V := W.LookupComponentGroup(AExcelTable.ComponentGroup.AsString);
    if VarIsNull(V) then
    begin
      FDQuery.Append;
      W.IsGroup.F.AsInteger := 1; // Будем добавлять группу
      W.Value.F.AsString := AExcelTable.ComponentGroup.AsString;
      FDQuery.Post;
    end;

    // 2) Ищем или добавляем такого производителя в справочнике производителей
    ProducersGroup.LocateOrAppend(AExcelTable.Producer.AsString, sWareHouseDefaultProducerType);

    AExcelTable.Next;
  end;
  EnableCalc;

  // Сохраняем изменения в БД чтобы ссылаться на эту группу!!!
  FDQuery.Connection.StartTransaction;
  FDQuery.ApplyUpdates();
  FDQuery.CommitUpdates;

  try
    AExcelTable.First;
    AExcelTable.CallOnProcessEvent;
    while not AExcelTable.Eof do
    begin
      // Чтобы при изменении любого поля не происходил пересчёт автовычисляемых полей
      DisableCalc;
      try
        // 1) Ищем такую группу компонентов на текущем складе
        V := W.LookupComponentGroup(AExcelTable.ComponentGroup.AsString);
        if VarIsNull(V) then
        begin
          FDQuery.Append;
          W.IsGroup.F.AsInteger := 1; // Будем добавлять группу
          W.Value.F.AsString := AExcelTable.ComponentGroup.AsString;
          FDQuery.Post;
          // Сохраняем изменения в БД чтобы ссылаться на эту группу!!!
          ApplyUpdates;
          AIDComponentGroup := W.PK.Value;
        end
        else
          AIDComponentGroup := V;

        // 2) Ищем или добавляем такого производителя в справочнике производителей
        ProducersGroup.LocateOrAppend(AExcelTable.Producer.AsString, 'Склад');

        // Добавляем товар на склад
        FDQuery.Append;

        // Заполняем все поля записи о товаре на складе значаниями из Excel таблицы
        for AExcelField in AExcelTable.Fields do
        begin
          AField := FDQuery.FindField(AExcelField.FieldName);
          if AField <> nil then
            AField.Value := AExcelField.Value;
        end;

        // Дополнительно заполняем
        W.IDProducer.F.AsInteger := ProducersGroup.qProducers.W.PK.Value;
        W.IDComponentGroup.F.AsInteger := AIDComponentGroup;
        W.IsGroup.F.AsInteger := 0;

        // Если цена задана в рублях
        if not AExcelTable.PriceR.IsNull then
        begin
          // Тип валюты - рубли
          W.IDCurrency.F.AsInteger := 1;
          W.Price.F.Value := AExcelTable.PriceR.Value;
        end;

        // Если цена задана в долларах
        if not AExcelTable.PriceD.IsNull then
        begin
          // Тип валюты - доллар
          W.IDCurrency.F.AsInteger := 2;
          W.Price.F.Value := AExcelTable.PriceD.Value;
        end;

        // Если цена задана в евро
        if not AExcelTable.PriceE.IsNull then
        begin
          // Тип валюты - евро
          W.IDCurrency.F.AsInteger := 3;
          W.Price.F.Value := AExcelTable.PriceE.Value;
        end;

        // Дата загрузки должна заполняться при загрузке
        Assert(not W.LoadDate.F.IsNull);

        // Курс Доллара должен заполняться при загрузке
        Assert(not W.Dollar.F.IsNull);

        // Курс Евро должен заполняться при загрузке
        Assert(not W.Euro.F.IsNull);

        FDQuery.Post;

      finally
        FDQuery.Edit;
        // Разрешаем обновиться автовычисляемым полям
        EnableCalc;
        FDQuery.Post;
      end;

      AExcelTable.Next;
      AExcelTable.CallOnProcessEvent;
    end;
  finally
    FNeedUpdateCount := True;
  end;
end;

procedure TQueryProducts.AppendRows(AValues: TList<String>;
  const AProducers: TList<String>);
var
  I: Integer;
begin
  Assert(AValues <> nil);
  Assert(AProducers <> nil);
  Assert(AValues.Count = AProducers.Count);
  Assert(AValues.Count > 0);

  for I := 0 to AValues.Count - 1 do
  begin
    // Ищем такого производителя
    if not ProducersGroup.qProducers.Locate(AProducers[I]) then
      raise Exception.CreateFmt('Производитель "%s" не найден в справочнике',
        [AProducers[I]]);

    W.TryAppend;
    W.Value.F.AsString := AValues[I];
    W.IDProducer.F.AsInteger := ProducersGroup.qProducers.W.PK.Value;
    W.TryPost;
  end;
end;

function TQueryProducts.HaveDuplicate(AExcelTable: TCustomExcelTable): Boolean;
var
  AIDComponentGroup: Integer;
  AIDProducer: Integer;
  AKeyFields: string;
  AProductsExcelTable: TProductsExcelTable;
  V: Variant;
begin
  AProductsExcelTable := AExcelTable as TProductsExcelTable;

  // 1) Ищем группу компонентов на текущем складе

  AKeyFields := Format('%s;%s', [W.IsGroup.FieldName, W.Value.FieldName]);
  V := FDQuery.LookupEx(AKeyFields,
    VarArrayOf([1, AProductsExcelTable.ComponentGroup.Value]), W.PKFieldName);

  // Если такой группы компонентов на складе ещё не было
  Result := not VarIsNull(V);
  if not Result then
    Exit;

  AIDComponentGroup := V;

  // 2) Ищем производителя
  Result := ProducersGroup.qProducers.Locate
    (AProductsExcelTable.Producer.AsString);
  // Если такого производителя не было
  if not Result then
    Exit;

  AIDProducer := ProducersGroup.qProducers.W.PK.AsInteger;

  // Ищем на складе
  AKeyFields := Format('%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s',
    [W.IsGroup.FieldName, W.IDComponentGroup.FieldName, W.Value.FieldName,
    W.IDProducer.FieldName, W.PackagePins.FieldName, W.ReleaseDate.FieldName,
    W.Amount.FieldName, W.Packaging.FieldName, W.Price.FieldName,
    W.OriginCountryCode.FieldName, W.OriginCountry.FieldName,
    W.BatchNumber.FieldName, W.CustomsDeclarationNumber.FieldName,
    W.Storage.FieldName, W.StoragePlace.FieldName, W.Seller.FieldName,
    W.DocumentNumber.FieldName, W.Barcode.FieldName]);

  V := FDQuery.LookupEx(AKeyFields,
    VarArrayOf([0, AIDComponentGroup, AProductsExcelTable.Value.AsString,
    AIDProducer, AProductsExcelTable.PackagePins.AsString,
    AProductsExcelTable.ReleaseDate.AsString,
    AProductsExcelTable.Amount.AsInteger,
    AProductsExcelTable.Packaging.AsString, AProductsExcelTable.Price.AsFloat,
    AProductsExcelTable.OriginCountryCode.AsString,
    AProductsExcelTable.OriginCountry.AsString,
    AProductsExcelTable.BatchNumber.AsString,
    AProductsExcelTable.CustomsDeclarationNumber.AsString,
    AProductsExcelTable.Storage.AsString,
    AProductsExcelTable.StoragePlace.AsString,
    AProductsExcelTable.Seller.AsString,
    AProductsExcelTable.DocumentNumber.AsString,
    AProductsExcelTable.Barcode.AsString]), W.PKFieldName);

  Result := not VarIsNull(V);
end;

procedure TQueryProducts.DoAfterDelete(Sender: TObject);
begin
  // Если завершилось удаление записи о продукте и общее кол-во известно и не нуждается в обновлении
  if FNeedDecTotalCount and (not FNeedUpdateCount) then
  begin
    FNeedDecTotalCount := false;
    Assert(FTotalCount > 0);
    Dec(FTotalCount);
  end;
end;

procedure TQueryProducts.DoAfterInsert(Sender: TObject);
begin
  // Заполняем код склада
  W.StorehouseId.F.AsInteger := ParentValue;
end;

procedure TQueryProducts.DoAfterOpen(Sender: TObject);
begin
  FNeedUpdateCount := True;
  FNeedDecTotalCount := false;
end;

procedure TQueryProducts.DoAfterPost(Sender: TObject);
begin
  // Если завершилось добавление записи и общее кол-во известно и не нуждается в обновлении
  if (W.BeforePostState = dsInsert) and (not FNeedUpdateCount) then
    Inc(FTotalCount);
end;

procedure TQueryProducts.DoAfterCancelUpdates(Sender: TObject);
begin
  FNeedUpdateCount := True;
end;

procedure TQueryProducts.DoBeforeDelete(Sender: TObject);
begin
  FNeedDecTotalCount := (not FNeedUpdateCount) and (not W.IsGroup.F.IsNull) and
    (W.IsGroup.F.AsInteger = 0);
end;

function TQueryProducts.GetExportFileName: string;
var
  AQueryStoreHouseList: TQueryStoreHouseList;
begin
  Assert(Master <> nil);
  AQueryStoreHouseList := Master as TQueryStoreHouseList;
  Assert(AQueryStoreHouseList.FDQuery.RecordCount > 0);
  Result := Format('%s %s.xls', [AQueryStoreHouseList.W.Title.F.AsString,
    FormatDateTime('dd.mm.yyyy', Date)]);
  Assert(not Result.IsEmpty);
end;

function TQueryProducts.GetqStoreHouseProductsCount
  : TQueryStoreHouseProductsCount;
begin
  if FqStoreHouseProductsCount = nil then
  begin
    FqStoreHouseProductsCount := TQueryStoreHouseProductsCount.Create(Self);
    FqStoreHouseProductsCount.FDQuery.Connection := FDQuery.Connection;
  end;
  Result := FqStoreHouseProductsCount;
end;

function TQueryProducts.GetStoreHouseName: string;
var
  AQueryStoreHouseList: TQueryStoreHouseList;
begin
  Assert(Master <> nil);
  AQueryStoreHouseList := Master as TQueryStoreHouseList;
  Result := AQueryStoreHouseList.W.Title.F.AsString;
end;

function TQueryProducts.GetTotalCount: Integer;
begin
  if FNeedUpdateCount then
  begin
    qStoreHouseProductsCount.FDQuery.Close;
    qStoreHouseProductsCount.FDQuery.Open;
    FTotalCount := qStoreHouseProductsCount.Count;
    FNeedUpdateCount := false;
  end;
  Result := FTotalCount;
end;

function TQueryProducts.SearchByID(AIDArray: TArray<Integer>): Integer;
var
  ATempTable: TQueryIDTempTable;
  I: Integer;
begin
  Assert(Length(AIDArray) > 0);

  ATempTable := TQueryIDTempTable.Create(nil);
  try
    for I := Low(AIDArray) to High(AIDArray) do
    begin
      ATempTable.W.TryAppend;
      ATempTable.W.ID.F.AsInteger := AIDArray[I];
      ATempTable.W.TryPost;
    end;

    FDQuery.SQL.Text := ReplaceInSQL(SQL,
      Format('%s in (%s)', [W.ID.FullName, ATempTable.FDQuery.SQL.Text]), 0);
  finally
    FreeAndNil(ATempTable);
  end;

  W.RefreshQuery;
  Result := FDQuery.RecordCount;
end;

function TQueryProducts.SearchForBasket: Integer;
begin
  Result := SearchEx([TParamRec.Create(W.SaleCount.FullName, 0, ftFloat,
    false, '>')]);
  W.ApplySaleCountFilter;
end;

end.
