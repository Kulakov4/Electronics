unit BillQuery2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, QueryWithDataSourceUnit,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, DSWrap, BillQuery;

type
  TBillW2 = class(TBillW)
  private
    FStorehouseId: TParamWrap;
  public
    constructor Create(AOwner: TComponent); override;
    property StorehouseId: TParamWrap read FStorehouseId;
  end;

  TQryBill2 = class(TQueryWithDataSource)
  private
    FW: TBillW2;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    procedure SearchByStoreHouse(AStoreHouseID: Integer);
    property W: TBillW2 read FW;
    { Public declarations }
  end;

implementation

uses
  BaseQuery;

{$R *.dfm}

constructor TQryBill2.Create(AOwner: TComponent);
begin
  inherited;
  FW := TBillW2.Create(FDQuery);
end;

procedure TQryBill2.SearchByStoreHouse(AStoreHouseID: Integer);
begin
  Assert(AStoreHouseID > 0);
  SearchEx([ TParamRec.Create(W.StorehouseId.FullName, AStoreHouseID) ]);
end;

constructor TBillW2.Create(AOwner: TComponent);
begin
  inherited;
  // Параметр SQL запроса
  FStorehouseId := TParamWrap.Create(Self, 'bc.StorehouseId');
end;

end.
