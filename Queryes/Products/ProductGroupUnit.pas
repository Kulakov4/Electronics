unit ProductGroupUnit;

interface

uses
  ProductBaseGroupUnit, ProductsBaseQuery, ProductsQuery, StoreHouseListQuery,
  System.Classes;

type
  TProductGroup = class(TProductBaseGroup)
  private
    FqStoreHouseList: TQueryStoreHouseList;
    function GetqProducts: TQueryProducts;
  protected
    function CreateProductQuery: TQueryProductsBase; override;
  public
    constructor Create(AOwner: TComponent); override;
    property qProducts: TQueryProducts read GetqProducts;
    property qStoreHouseList: TQueryStoreHouseList read FqStoreHouseList;
  end;

implementation

constructor TProductGroup.Create(AOwner: TComponent);
begin
  inherited;
  Assert(qProductsBase <> nil);
  FqStoreHouseList := TQueryStoreHouseList.Create(Self);

  // Добавляем запрос в список запросов
  FQueries.Insert(0, FqStoreHouseList);

  // Связываем компоненты и склады отношением главный/подчинённый
  qProducts.Master := FqStoreHouseList;
end;

function TProductGroup.CreateProductQuery: TQueryProductsBase;
begin
  Result := TQueryProducts.Create(Self);
end;

function TProductGroup.GetqProducts: TQueryProducts;
begin
  Result := qProductsBase as TQueryProducts;
end;

end.
