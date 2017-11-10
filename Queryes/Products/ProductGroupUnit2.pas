unit ProductGroupUnit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ProductBaseGroupUnit2, Vcl.ExtCtrls,
  BaseQuery, BaseEventsQuery, QueryWithMasterUnit, QueryWithDataSourceUnit,
  StoreHouseListQuery, ProductsBaseQuery, ProductsQuery;

type
  TProductGroup = class(TProductBaseGroup)
    qStoreHouseList: TQueryStoreHouseList;
    qProducts: TQueryProducts;
  private
    { Private declarations }
  protected
    function GetqProductsBase: TQueryProductsBase; override;
  public
    constructor Create(AOwner: TComponent); override;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TProductGroup.Create(AOwner: TComponent);
begin
  inherited;
  Main := qStoreHouseList;
  Detail := qProducts;

  // Запросы связаны отношением главный-подчинённый
  qProducts.Master := qStoreHouseList;
end;

function TProductGroup.GetqProductsBase: TQueryProductsBase;
begin
  Result := qProducts;
end;

end.
