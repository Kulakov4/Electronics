unit BillContentQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, QueryWithDataSourceUnit,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQueryBillContent = class(TQueryWithDataSource)
  private
    function GetBillID: TField;
    function GetStoreHouseProductID: TField;
    function GetSaleCount: TField;
    { Private declarations }
  public
    property BillID: TField read GetBillID;
    property StoreHouseProductID: TField read GetStoreHouseProductID;
    property SaleCount: TField read GetSaleCount;
    { Public declarations }
  end;

implementation

{$R *.dfm}

function TQueryBillContent.GetBillID: TField;
begin
  Result := Field('BillID');
end;

function TQueryBillContent.GetStoreHouseProductID: TField;
begin
  Result := Field('StoreHouseProductID');
end;

function TQueryBillContent.GetSaleCount: TField;
begin
  Result := Field('SaleCount');
end;

end.
