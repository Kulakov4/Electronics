unit ProductsViewModel;

interface

uses
  BaseProductsViewModel1, ProductsBaseQuery0, ProductsInterface,
  StoreHouseListInterface, ProductsQuery, StoreHouseListQuery;

type
  TProductsViewModel = class(TBaseProductsViewModel1, IProducts)
  strict private
    procedure FreeInt;
    procedure LoadContent(AStoreHouseID: Integer; AStorehouseListInt:
        IStorehouseList);
  private
    FqStoreHouseList: TQueryStoreHouseList;
    FStorehouseListInt: IStorehouseList;
    function GetqProducts: TQueryProducts;
    function GetqStoreHouseList: TQueryStoreHouseList;
    function GetStoreHouseName: string;
  protected
    function CreateProductsQuery: TQryProductsBase0; override;
    function GetExportFileName: string; override;
  public
    property qProducts: TQueryProducts read GetqProducts;
    property qStoreHouseList: TQueryStoreHouseList read GetqStoreHouseList;
    property StorehouseListInt: IStorehouseList read FStorehouseListInt;
    property StoreHouseName: string read GetStoreHouseName;
  end;

implementation

uses
  System.SysUtils;

function TProductsViewModel.CreateProductsQuery: TQryProductsBase0;
begin
  Result := TQueryProducts.Create(Self, ProducersGroup);
end;

procedure TProductsViewModel.FreeInt;
begin
  FStorehouseListInt := nil;
end;

function TProductsViewModel.GetExportFileName: string;
begin
  Assert(Assigned(FStorehouseListInt));

  Result := Format('%s %s.xls', [FStorehouseListInt.StoreHouseTitle,
    FormatDateTime('dd.mm.yyyy', Date)]);
  Assert(not Result.IsEmpty);
end;

function TProductsViewModel.GetqProducts: TQueryProducts;
begin
  Result := qProductsBase0 as TQueryProducts;
end;

function TProductsViewModel.GetqStoreHouseList: TQueryStoreHouseList;
begin
  if FqStoreHouseList = nil then
  begin
    FqStoreHouseList := TQueryStoreHouseList.Create(Self);
    FqStoreHouseList.FDQuery.Open;
  end;
  Result := FqStoreHouseList;
end;

function TProductsViewModel.GetStoreHouseName: string;
begin
  Assert(Assigned(FStorehouseListInt));

  Result := FStorehouseListInt.StoreHouseTitle;
end;

procedure TProductsViewModel.LoadContent(AStoreHouseID: Integer;
    AStorehouseListInt: IStorehouseList);
begin
  Assert(AStorehouseListInt <> nil);
  FStorehouseListInt := AStorehouseListInt;

  qProducts.LoadContent(AStoreHouseID)
end;

end.
