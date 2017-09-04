unit ProductBaseGroupUnit;

interface

uses
  QueryGroupUnit3, ProductsBaseQuery, System.Classes;

type
  TProductBaseGroup = class(TQueryGroup3)
  private
    FqProductsBase: TQueryProductsBase;
  protected
    function CreateProductQuery: TQueryProductsBase; virtual; abstract;
  public
    constructor Create(AOwner: TComponent); override;
    property qProductsBase: TQueryProductsBase read FqProductsBase;
  end;

implementation

constructor TProductBaseGroup.Create(AOwner: TComponent);
begin
  inherited;
  FqProductsBase := CreateProductQuery;
  FQueries.Add(FqProductsBase);
end;

end.
