unit ProductSearchGroupUnit;

interface

uses
  ProductBaseGroupUnit, System.Classes, ProductsBaseQuery, ProductsSearchQuery,
  StoreHouseListQuery;

type
  TProductSearchGroup = class(TProductBaseGroup)
  private
    FqStoreHouseList: TQueryStoreHouseList;
    function GetqProductsSearch: TQueryProductsSearch;
    function GetqStoreHouseList: TQueryStoreHouseList;
  protected
    function CreateProductQuery: TQueryProductsBase; override;
  public
    property qProductsSearch: TQueryProductsSearch read GetqProductsSearch;
    property qStoreHouseList: TQueryStoreHouseList read GetqStoreHouseList;
  end;

implementation

function TProductSearchGroup.CreateProductQuery: TQueryProductsBase;
begin
  Result := TQueryProductsSearch.Create(Self);
end;

function TProductSearchGroup.GetqProductsSearch: TQueryProductsSearch;
begin
  Result := qProductsBase as TQueryProductsSearch;
end;

function TProductSearchGroup.GetqStoreHouseList: TQueryStoreHouseList;
begin
  if FqStoreHouseList = nil then
  begin
    FqStoreHouseList := TQueryStoreHouseList.Create(Self);
    FqStoreHouseList.FDQuery.Open;
  end;

  Result := FqStoreHouseList;
end;

end.
