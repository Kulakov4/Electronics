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
    procedure DoAfterInsert(Sender: TObject);
    procedure DoAfterOpen(Sender: TObject);
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
    procedure LoadDataFromExcelTable(AExcelTable: TProductsExcelTable);
    procedure AppendRows(AValues: TList<String>;
      const AProducers: TList<String>); overload;
    function SearchByID(AIDArray: TArray<Integer>): Integer;
    property StoreHouseName: string read GetStoreHouseName;
    property TotalCount: Integer read GetTotalCount;
    { Public declarations }
  end;

implementation

uses System.Generics.Defaults, System.Types, System.StrUtils, System.Math,
  ParameterValuesUnit, StoreHouseListQuery, IDTempTableQuery, StrHelper;

{$R *.dfm}
{ TfrmQueryStoreHouseComponents }

constructor TQueryProducts.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FNeedUpdateCount := True;

  DetailParameterName := 'vStoreHouseID';
  TNotifyEventWrap.Create(AfterInsert, DoAfterInsert, FEventList);
  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, FEventList);
  TNotifyEventWrap.Create(AfterPost, DoAfterPost, FEventList);
  TNotifyEventWrap.Create(BeforeDelete, DoBeforeDelete, FEventList);
  TNotifyEventWrap.Create(AfterDelete, DoAfterDelete, FEventList);
end;

procedure TQueryProducts.LoadDataFromExcelTable(AExcelTable
  : TProductsExcelTable);
var
  AExcelField: TField;
  AField: TField;
  AIDComponentGroup: Integer;
  V: Variant;
begin
  try
    AExcelTable.First;
    AExcelTable.CallOnProcessEvent;
    while not AExcelTable.Eof do
    begin
      // 1) Ищем такую группу компонентов на текущем складе
      V := LookupComponentGroup(AExcelTable.ComponentGroup.AsString);
      if VarIsNull(V) then
      begin
        FDQuery.Append;
        IsGroup.AsInteger := 1; // Будем добавлять группу
        Value.AsString := AExcelTable.ComponentGroup.AsString;
        FDQuery.Post;
        AIDComponentGroup := PK.Value;
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
      IDProducer.AsInteger := ProducersGroup.qProducers.PK.Value;
      IDComponentGroup.AsInteger := AIDComponentGroup;
      IsGroup.AsInteger := 0;

      // Если цена задана в рублях
      if not AExcelTable.PriceR.IsNull then
      begin
        // Тип валюты - рубли
        IDCurrency.AsInteger := 1;
        Price.Value := AExcelTable.PriceR.Value;
      end;

      // Если цена задана в долларах
      if not AExcelTable.PriceD.IsNull then
      begin
        // Тип валюты - доллар
        IDCurrency.AsInteger := 2;
        Price.Value := AExcelTable.PriceD.Value;
      end;

      // Если цена задана в евро
      if not AExcelTable.PriceE.IsNull then
      begin
        // Тип валюты - евро
        IDCurrency.AsInteger := 3;
        Price.Value := AExcelTable.PriceE.Value;
      end;

      // Дата загрузки должна заполняться при загрузке
      Assert(not LoadDate.IsNull);

      // Курс Доллара должен заполняться при загрузке
      Assert(not Dollar.IsNull);

      // Курс Евро должен заполняться при загрузке
      Assert(not Euro.IsNull);

      FDQuery.Post;

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

    TryAppend;
    Value.AsString := AValues[I];
    IDProducer.AsInteger := ProducersGroup.qProducers.PK.Value;
    TryPost;
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

  AKeyFields := Format('%s;%s', [IsGroup.FieldName, Value.FieldName]);
  V := FDQuery.LookupEx(AKeyFields,
    VarArrayOf([1, AProductsExcelTable.ComponentGroup.Value]), PKFieldName);

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

  AIDProducer := ProducersGroup.qProducers.PK.AsInteger;

  // Ищем на складе
  AKeyFields := Format('%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s',
    [IsGroup.FieldName, IDComponentGroup.FieldName, Value.FieldName,
    IDProducer.FieldName, PackagePins.FieldName, ReleaseDate.FieldName,
    Amount.FieldName, Packaging.FieldName, Price.FieldName,
    OriginCountryCode.FieldName, OriginCountry.FieldName, BatchNumber.FieldName,
    CustomsDeclarationNumber.FieldName, Storage.FieldName,
    StoragePlace.FieldName, Seller.FieldName, DocumentNumber.FieldName,
    Barcode.FieldName]);

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
    AProductsExcelTable.Barcode.AsString]), PKFieldName);

  Result := not VarIsNull(V);
end;

procedure TQueryProducts.DoAfterDelete(Sender: TObject);
begin
  // Если завершилось удаление записи о продукте и общее кол-во известно и не нуждается в обновлении
  if FNeedDecTotalCount and (not FNeedUpdateCount) then
  begin
    FNeedDecTotalCount := False;
    Assert(FTotalCount > 0);
    Dec(FTotalCount);
  end;
end;

procedure TQueryProducts.DoAfterInsert(Sender: TObject);
begin
  // Заполняем код склада
  StorehouseId.AsInteger := ParentValue;
end;

procedure TQueryProducts.DoAfterOpen(Sender: TObject);
begin
  FNeedUpdateCount := True;
  FNeedDecTotalCount := False;
  // FDQuery.FieldByName('Amount').OnGetText := HideNullGetText;
  // FDQuery.FieldByName('Price').OnGetText := HideNullGetTex
end;

procedure TQueryProducts.DoAfterPost(Sender: TObject);
begin
  // Если завершилось добавление записи и общее кол-во известно и не нуждается в обновлении
  if (OldState = dsInsert) and (not FNeedUpdateCount) then
    Inc(FTotalCount);
end;

procedure TQueryProducts.DoBeforeDelete(Sender: TObject);
begin
  FNeedDecTotalCount := not IsGroup.IsNull and (IsGroup.AsInteger = 0);
end;

function TQueryProducts.GetExportFileName: string;
var
  AQueryStoreHouseList: TQueryStoreHouseList;
begin
  Assert(Master <> nil);
  AQueryStoreHouseList := Master as TQueryStoreHouseList;
  Assert(AQueryStoreHouseList.FDQuery.RecordCount > 0);
  Result := Format('%s %s.xls', [AQueryStoreHouseList.Abbreviation.AsString,
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
  Result := AQueryStoreHouseList.Title.AsString;
end;

function TQueryProducts.GetTotalCount: Integer;
begin
  if FNeedUpdateCount then
  begin
    qStoreHouseProductsCount.FDQuery.Close;
    qStoreHouseProductsCount.FDQuery.Open;
    FTotalCount := qStoreHouseProductsCount.Count;
    FNeedUpdateCount := False;
  end;
  Result := FTotalCount;
end;

function TQueryProducts.SearchByID(AIDArray: TArray<Integer>): Integer;
var
  ASQL: string;
  ATempTable: TQueryIDTempTable;
  I: Integer;
begin
  Assert(Length(AIDArray) > 0);

  ATempTable := TQueryIDTempTable.Create(nil);
  try
    for I := Low(AIDArray) to High(AIDArray) do
    begin
      ATempTable.TryAppend;
      ATempTable.ID.AsInteger := AIDArray[I];
      ATempTable.TryPost;
    end;

    // ASQL := Replace(FDQuery.SQL.Text, 'Id in (-6)', 'StorehouseId = :vStorehouseId');

    ASQL := Replace(FDQuery.SQL.Text, Format('Id in (%s)',
      [ATempTable.FDQuery.SQL.Text]), 'StorehouseId = :vStorehouseId');
  finally
    FreeAndNil(ATempTable);
  end;

  // V := FDQuery.Params.ParamByName(DetailParameterName).Value;

  FDQuery.SQL.Text := ASQL;
  RefreshQuery;
  Result := FDQuery.RecordCount;

  // Result := Search([DetailParameterName], [V]);
end;

end.
