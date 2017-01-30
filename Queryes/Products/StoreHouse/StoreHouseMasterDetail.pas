unit StoreHouseMasterDetail;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, MasterDetailFrame, Vcl.ExtCtrls,
  ProductsQuery, DataModuleFrame, StoreHouseListQuery,
  ProductsBaseQuery;

type
  TfrmStoreHouseMasterDetail = class(TfrmMasterDetail)
    qStoreHouseList: TfrmQueryStoreHouseList;
    qProducts: TQueryProducts;
  private
    { Private declarations }
  protected
  public
    constructor Create(AOwner: TComponent); override;
    { Public declarations }
  end;

implementation

uses System.Math;

{$R *.dfm}

constructor TfrmStoreHouseMasterDetail.Create(AOwner: TComponent);
begin
  inherited;
  Main := qStoreHouseList;
  Detail := qProducts;

  // Связываем их отношением главный подчинённый
  qProducts.Master := qStoreHouseList;
end;

end.
