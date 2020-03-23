unit ProductsSearchViewModel;

interface

uses
  BaseProductsViewModel1, ProductsBaseQuery0, ProductsSearchQuery,
  StoreHouseListInterface, StoreHouseListQuery;

type
  TProductsSearchViewModel = class(TBaseProductsViewModel1)
  private
    FqStoreHouseList: TQueryStoreHouseList;
    function GetqProductsSearch: TQueryProductsSearch;
    function GetqStoreHouseList: TQueryStoreHouseList;
  protected
    function CreateProductsQuery: TQryProductsBase0; override;
    function GetExportFileName: string; override;
  public
    property qProductsSearch: TQueryProductsSearch read GetqProductsSearch;
    property qStoreHouseList: TQueryStoreHouseList read GetqStoreHouseList;
  end;

implementation

uses
  System.SysUtils;

function TProductsSearchViewModel.CreateProductsQuery: TQryProductsBase0;
begin
  Result := TQueryProductsSearch.Create(Self, ProducersGroup);
end;

function TProductsSearchViewModel.GetExportFileName: string;
begin
  Result := Format('Поиск %s.xls', [FormatDateTime('dd.mm.yyyy', Date)]);
  Assert(not Result.IsEmpty);
end;

function TProductsSearchViewModel.GetqProductsSearch: TQueryProductsSearch;
begin
  Result := qProductsBase0 as TQueryProductsSearch;
end;

function TProductsSearchViewModel.GetqStoreHouseList: TQueryStoreHouseList;
begin
  if FqStoreHouseList = nil then
  begin
    FqStoreHouseList := TQueryStoreHouseList.Create(Self);
    FqStoreHouseList.FDQuery.Open;
  end;
  Result := FqStoreHouseList;
end;

end.
