unit BaseProductsViewModel1;

interface

uses
  BaseProductsViewModel, ProductsBaseQuery0, ProductsBaseQuery,
  ExtraChargeGroupUnit;

type
  TBaseProductsViewModel1 = class(TBaseProductsViewModel)
  private
    FExtraChargeGroup: TExtraChargeGroup;
    function GetExtraChargeGroup: TExtraChargeGroup;
    function GetqProductsBase: TQueryProductsBase;
  protected
    function CreateProductsQuery: TQryProductsBase0; override;
  public
    property ExtraChargeGroup: TExtraChargeGroup read GetExtraChargeGroup;
    property qProductsBase: TQueryProductsBase read GetqProductsBase;
  end;

implementation

function TBaseProductsViewModel1.CreateProductsQuery: TQryProductsBase0;
begin
  Result := TQueryProductsBase.Create(Self, ProducersGroup);
end;

function TBaseProductsViewModel1.GetExtraChargeGroup: TExtraChargeGroup;
begin
  if FExtraChargeGroup = nil then
  begin
    FExtraChargeGroup := TExtraChargeGroup.Create(Self);
    FExtraChargeGroup.ReOpen;
  end;
  Result := FExtraChargeGroup;
end;

function TBaseProductsViewModel1.GetqProductsBase: TQueryProductsBase;
begin
  Result := qProductsBase0 as TQueryProductsBase;
end;

end.
