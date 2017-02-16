unit StoreHouseGroupUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, StoreHouseListQuery, ProductsBaseQuery, ProductsQuery,
  CustomComponentsQuery, QueryWithDataSourceUnit, BaseQuery, BaseEventsQuery,
  QueryWithMasterUnit, QueryGroupUnit;

type
  TStoreHouseGroup = class(TQueryGroup)
    qStoreHouseList: TQueryStoreHouseList;
    qProducts: TQueryProducts;
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TStoreHouseGroup.Create(AOwner: TComponent);
begin
  inherited;
  Main := qStoreHouseList;
  Detail := qProducts;
  qProducts.Master := qStoreHouseList;
end;

end.
