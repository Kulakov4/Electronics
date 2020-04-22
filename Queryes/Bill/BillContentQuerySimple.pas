unit BillContentQuerySimple;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, DSWrap, BaseEventsQuery;

type
  TBillContentSimpleW = class(TDSWrap)
  private
    FBillID: TFieldWrap;
    FID: TFieldWrap;
    FPriceD: TFieldWrap;
    FPriceD1: TFieldWrap;
    FPriceD2: TFieldWrap;
    FPriceE: TFieldWrap;
    FPriceE1: TFieldWrap;
    FPriceE2: TFieldWrap;
    FPriceR: TFieldWrap;
    FPriceR1: TFieldWrap;
    FPriceR2: TFieldWrap;
    FSaleCount: TFieldWrap;
    FRetail: TFieldWrap;
    FSaleD: TFieldWrap;
    FSaleE: TFieldWrap;
    FSaleR: TFieldWrap;
    FWholeSale: TFieldWrap;
    FStoreHouseProductID: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AddContent(ABillID, AStoreHouseProductID, ASaleCount: Integer;
        ARetail, AWholeSale, APriceR, APriceD, APriceE, APriceR1, APriceD1,
        APriceE1, APriceR2, APriceD2, APriceE2, ASaleR, ASaleD, ASaleE: Double);
    property BillID: TFieldWrap read FBillID;
    property ID: TFieldWrap read FID;
    property PriceD: TFieldWrap read FPriceD;
    property PriceD1: TFieldWrap read FPriceD1;
    property PriceD2: TFieldWrap read FPriceD2;
    property PriceE: TFieldWrap read FPriceE;
    property PriceE1: TFieldWrap read FPriceE1;
    property PriceE2: TFieldWrap read FPriceE2;
    property PriceR: TFieldWrap read FPriceR;
    property PriceR1: TFieldWrap read FPriceR1;
    property PriceR2: TFieldWrap read FPriceR2;
    property SaleCount: TFieldWrap read FSaleCount;
    property Retail: TFieldWrap read FRetail;
    property SaleD: TFieldWrap read FSaleD;
    property SaleE: TFieldWrap read FSaleE;
    property SaleR: TFieldWrap read FSaleR;
    property WholeSale: TFieldWrap read FWholeSale;
    property StoreHouseProductID: TFieldWrap read FStoreHouseProductID;
  end;

  TQueryBillContentSimple = class(TQueryBaseEvents)
  private
    FW: TBillContentSimpleW;
    { Private declarations }
  protected
    function CreateDSWrap: TDSWrap; override;
  public
    constructor Create(AOwner: TComponent); override;
    function SearchByID(AID: Integer): Integer;
    property W: TBillContentSimpleW read FW;
    { Public declarations }
  end;

implementation

uses
  BaseQuery;

{$R *.dfm}

constructor TQueryBillContentSimple.Create(AOwner: TComponent);
begin
  inherited;
  FW := FDSWrap as TBillContentSimpleW;
end;

function TQueryBillContentSimple.CreateDSWrap: TDSWrap;
begin
  Result := TBillContentSimpleW.Create(FDQuery);
end;

function TQueryBillContentSimple.SearchByID(AID: Integer): Integer;
begin
  Assert(AID > 0);

  Result := SearchEx([TParamRec.Create(W.ID.FullName, AID)]);
end;

constructor TBillContentSimpleW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'ID', '', True);
  FBillID := TFieldWrap.Create(Self, 'BillID');
  FSaleCount := TFieldWrap.Create(Self, 'SaleCount');
  FRetail := TFieldWrap.Create(Self, 'Retail');
  FWholeSale := TFieldWrap.Create(Self, 'WholeSale');
  FPriceD := TFieldWrap.Create(Self, 'PriceD');
  FPriceD1 := TFieldWrap.Create(Self, 'PriceD1');
  FPriceD2 := TFieldWrap.Create(Self, 'PriceD2');
  FPriceE := TFieldWrap.Create(Self, 'PriceE');
  FPriceE1 := TFieldWrap.Create(Self, 'PriceE1');
  FPriceE2 := TFieldWrap.Create(Self, 'PriceE2');
  FPriceR := TFieldWrap.Create(Self, 'PriceR');
  FPriceR1 := TFieldWrap.Create(Self, 'PriceR1');
  FPriceR2 := TFieldWrap.Create(Self, 'PriceR2');

  FSaleR := TFieldWrap.Create(Self, 'SaleR', '₽');
  FSaleD := TFieldWrap.Create(Self, 'SaleD', '$');
  FSaleE := TFieldWrap.Create(Self, 'SaleE', '€');

  FStoreHouseProductID := TFieldWrap.Create(Self, 'StoreHouseProductID');
end;

procedure TBillContentSimpleW.AddContent(ABillID, AStoreHouseProductID,
    ASaleCount: Integer; ARetail, AWholeSale, APriceR, APriceD, APriceE,
    APriceR1, APriceD1, APriceE1, APriceR2, APriceD2, APriceE2, ASaleR, ASaleD,
    ASaleE: Double);
begin
  Assert(ABillID > 0);
  Assert(AStoreHouseProductID > 0);
  Assert(ASaleCount > 0);

  TryAppend;
  try
    BillID.F.AsInteger := ABillID;
    StoreHouseProductID.F.AsInteger := AStoreHouseProductID;
    SaleCount.F.Value := ASaleCount;
    Retail.F.Value := ARetail;
    WholeSale.F.Value := AWholeSale;

    PriceR.F.Value := APriceR;
    PriceD.F.Value := APriceD;
    PriceE.F.Value := APriceE;

    PriceR1.F.Value := APriceR1;
    PriceD1.F.Value := APriceD1;
    PriceE1.F.Value := APriceE1;

    PriceR2.F.Value := APriceR2;
    PriceD2.F.Value := APriceD2;
    PriceE2.F.Value := APriceE2;

    SaleR.F.Value := ASaleR;
    SaleD.F.Value := ASaleD;
    SaleE.F.Value := ASaleE;

    TryPost;
  except
    TryCancel;
    raise;
  end;
end;

end.
