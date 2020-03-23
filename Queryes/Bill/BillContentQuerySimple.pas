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
    FSaleCount: TFieldWrap;
    FCalcPriceR: TFieldWrap;
    FRetail: TFieldWrap;
    FWholeSale: TFieldWrap;
    FStoreHouseProductID: TFieldWrap;
    FMarkup: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AddContent(ABillID, AStoreHouseProductID, ASaleCount: Integer;
        ACalcPriceR, ARetail, AWholeSale, AMarkup: Double);
    property BillID: TFieldWrap read FBillID;
    property ID: TFieldWrap read FID;
    property SaleCount: TFieldWrap read FSaleCount;
    property CalcPriceR: TFieldWrap read FCalcPriceR;
    property Retail: TFieldWrap read FRetail;
    property WholeSale: TFieldWrap read FWholeSale;
    property StoreHouseProductID: TFieldWrap read FStoreHouseProductID;
    property Markup: TFieldWrap read FMarkup;
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
  FCalcPriceR := TFieldWrap.Create(Self, 'CalcPriceR');
  FRetail := TFieldWrap.Create(Self, 'Retail');
  FWholeSale := TFieldWrap.Create(Self, 'WholeSale');
  FMarkup := TFieldWrap.Create(Self, 'Markup');
  FStoreHouseProductID := TFieldWrap.Create(Self, 'StoreHouseProductID');
end;

procedure TBillContentSimpleW.AddContent(ABillID, AStoreHouseProductID,
    ASaleCount: Integer; ACalcPriceR, ARetail, AWholeSale, AMarkup: Double);
begin
  Assert(ABillID > 0);
  Assert(AStoreHouseProductID > 0);
  Assert(ASaleCount > 0);

  TryAppend;
  try
    BillID.F.AsInteger := ABillID;
    StoreHouseProductID.F.AsInteger := AStoreHouseProductID;
    SaleCount.F.Value := ASaleCount;
    CalcPriceR.F.Value := ACalcPriceR;
    Retail.F.Value := ARetail;
    WholeSale.F.Value := AWholeSale;
    Markup.F.Value := AMarkup;
    TryPost;
  except
    TryCancel;
    raise;
  end;
end;

end.
