unit BillContentViewModel;

interface

uses
  BaseProductsViewModel, ProductsBaseQuery0, BillContentInterface, BillInterface,
  BillContentQry, StoreHouseListQuery;

type
  TBillContentViewModel = class(TBaseProductsViewModel)
  private
    FBill: IBill;
    FqStoreHouseList: TQueryStoreHouseList;
    function GetqBillContent: TQueryBillContent;
    function GetqStoreHouseList: TQueryStoreHouseList;
  protected
    function CreateProductsQuery: TQryProductsBase0; override;
    function GetExportFileName: string; override;
  public
    procedure CloseContent;
    procedure LoadContent(ABillID: Integer; ABill: IBill);
    property qBillContent: TQueryBillContent read GetqBillContent;
    property qStoreHouseList: TQueryStoreHouseList read GetqStoreHouseList;
  end;

implementation

uses
  System.SysUtils;

procedure TBillContentViewModel.CloseContent;
begin
  FBill := nil;
end;

function TBillContentViewModel.CreateProductsQuery: TQryProductsBase0;
begin
  Result := TQueryBillContent.Create(Self);
end;

function TBillContentViewModel.GetExportFileName: string;
begin
  Assert(FBill <> nil);
  Assert(FBill.BillNumber > 0);

  Result := Format('Ñ÷¸ò ¹%s îò %s.xlsx', [FBill.BillNumberStr,
    FormatDateTime('dd.mm.yyyy', FBill.BillDate)]);
  Assert(not Result.IsEmpty);
end;

function TBillContentViewModel.GetqBillContent: TQueryBillContent;
begin
  Result := qProductsBase0 as TQueryBillContent;
end;

function TBillContentViewModel.GetqStoreHouseList: TQueryStoreHouseList;
begin
  if FqStoreHouseList = nil then
  begin
    FqStoreHouseList := TQueryStoreHouseList.Create(Self);
    FqStoreHouseList.FDQuery.Open;
  end;

  Result := FqStoreHouseList;
end;

procedure TBillContentViewModel.LoadContent(ABillID: Integer; ABill: IBill);
begin
  Assert(ABill <> nil);
  FBill := ABill;

  qBillContent.LoadContent(ABillID);
end;

end.
