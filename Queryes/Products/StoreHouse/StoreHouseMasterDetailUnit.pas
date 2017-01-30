unit StoreHouseMasterDetailUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, MasterDetailFrame, Vcl.ExtCtrls,
  DataModuleFrame, StoreHouseListQuery, ProductsBaseQuery, ProductsQuery,
  CustomComponentsQuery;

type
  TStoreHouseMasterDetail = class(TfrmMasterDetail)
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

constructor TStoreHouseMasterDetail.Create(AOwner: TComponent);
begin
  inherited;
  Main := qStoreHouseList;
  Detail := qProducts;
  qProducts.Master := qStoreHouseList;
end;

end.
