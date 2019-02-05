unit BillContentQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, QueryWithDataSourceUnit,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, DSWrap;

type
  TBillContentW = class(TDSWrap)
  private
    FBillID: TFieldWrap;
    FID: TFieldWrap;
    FSaleCount: TFieldWrap;
    FStoreHouseProductID: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AddContent(ABillID, AStoreHouseProductID, ASaleCount: Integer);
    property BillID: TFieldWrap read FBillID;
    property ID: TFieldWrap read FID;
    property SaleCount: TFieldWrap read FSaleCount;
    property StoreHouseProductID: TFieldWrap read FStoreHouseProductID;
  end;

  TQueryBillContent = class(TQueryWithDataSource)
  private
    FW: TBillContentW;
    { Private declarations }
  protected
    function CreateDSWrap: TDSWrap; override;
  public
    constructor Create(AOwner: TComponent); override;
    property W: TBillContentW read FW;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TQueryBillContent.Create(AOwner: TComponent);
begin
  inherited;
  FW := FDSWrap as TBillContentW;
end;

function TQueryBillContent.CreateDSWrap: TDSWrap;
begin
  Result := TBillContentW.Create(FDQuery);
end;

constructor TBillContentW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'ID', '', True);
  FBillID := TFieldWrap.Create(Self, 'BillID');
  FSaleCount := TFieldWrap.Create(Self, 'SaleCount');
  FStoreHouseProductID := TFieldWrap.Create(Self, 'StoreHouseProductID');
end;

procedure TBillContentW.AddContent(ABillID, AStoreHouseProductID, ASaleCount:
    Integer);
begin
  Assert(ABillID > 0);
  Assert(AStoreHouseProductID > 0);
  Assert(ASaleCount > 0);

  TryAppend;
  try
    BillID.F.AsInteger := ABillID;
    StoreHouseProductID.F.AsInteger := AStoreHouseProductID;
    SaleCount.F.Value := ASaleCount;
    TryPost;
  except
    TryCancel;
    raise;
  end;
end;

end.
