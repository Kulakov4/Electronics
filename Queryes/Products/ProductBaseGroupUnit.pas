unit ProductBaseGroupUnit;

interface

uses
  QueryGroupUnit3, ProductsBaseQuery, System.Classes, ComponentGroupsQuery;

type
  TProductBaseGroup = class(TQueryGroup3)
  private
    FqComponentGroups: TQueryComponentGroups;
    FqProductsBase: TQueryProductsBase;
  protected
    function CreateProductQuery: TQueryProductsBase; virtual; abstract;
  public
    constructor Create(AOwner: TComponent); override;
    property qComponentGroups: TQueryComponentGroups read FqComponentGroups;
    property qProductsBase: TQueryProductsBase read FqProductsBase;
  end;

implementation

constructor TProductBaseGroup.Create(AOwner: TComponent);
begin
  inherited;
  FqComponentGroups := TQueryComponentGroups.Create(Self);
  FQueries.Add(FqComponentGroups);
  FqProductsBase := CreateProductQuery;
  FQueries.Add(FqProductsBase);
end;

end.
