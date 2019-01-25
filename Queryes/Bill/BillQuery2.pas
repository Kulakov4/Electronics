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
  TQryBill2 = class(TQueryWithDataSource)
  private
    { Private declarations }
  public
    procedure SearchByBill(ABillID: Integer);
    { Public declarations }
  end;

  TBillW2 = class(TBillW)
  private
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses
  BaseQuery;

{$R *.dfm}

procedure TQryBill2.SearchByBill(ABillID: Integer);
begin
  Assert(ABillID > 0);
  SearchEx([ TParamRec.Create('StorehouseId', ABillID) ]);
end;

constructor TBillW2.Create(AOwner: TComponent);
begin
  inherited;

end;

end.
