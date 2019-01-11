unit BillQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, QueryWithDataSourceUnit,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQryBill = class(TQueryWithDataSource)
  private
    function GetNumber: TField;
    function GetBillDate: TField;
    function GetShipmentDate: TField;
    function GetDollar: TField;
    function GetEuro: TField;
    { Private declarations }
  public
    property Number: TField read GetNumber;
    property BillDate: TField read GetBillDate;
    property ShipmentDate: TField read GetShipmentDate;
    property Dollar: TField read GetDollar;
    property Euro: TField read GetEuro;
    { Public declarations }
  end;

implementation

{$R *.dfm}

function TQryBill.GetNumber: TField;
begin
  Result := Field('Number');
end;

function TQryBill.GetBillDate: TField;
begin
  Result := Field('BillDate');
end;

function TQryBill.GetShipmentDate: TField;
begin
  Result := Field('ShipmentDate');
end;

function TQryBill.GetDollar: TField;
begin
  Result := Field('Dollar');
end;

function TQryBill.GetEuro: TField;
begin
  Result := Field('Euro');
end;

end.
