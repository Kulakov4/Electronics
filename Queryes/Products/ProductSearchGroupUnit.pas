unit ProductSearchGroupUnit;

interface

uses
  ProductBaseGroupUnit, System.Classes, ProductsBaseQuery, ProductsSearchQuery;

type
  TProductSearchGroup = class(TProductBaseGroup)
  private
    function GetqProductsSearch: TQueryProductsSearch;
  protected
    function CreateProductQuery: TQueryProductsBase; override;
  public
    property qProductsSearch: TQueryProductsSearch read GetqProductsSearch;
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

end.
