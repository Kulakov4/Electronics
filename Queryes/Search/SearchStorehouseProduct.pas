unit SearchStorehouseProduct;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQuerySearchStorehouseProduct = class(TQueryBase)
  private
    function GetProductID: TField;
    { Private declarations }
  public
    function SearchByGroupID(AStorehouseID, AIDComponentGroup: Integer): Integer;
    function SearchByID(AID: Integer): Integer;
    function SearchByProductID(AProductID: Integer): Integer;
    property ProductID: TField read GetProductID;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses StrHelper;

function TQuerySearchStorehouseProduct.GetProductID: TField;
begin
  Result := Field('ProductID');
end;

function TQuerySearchStorehouseProduct.SearchByGroupID(AStorehouseID,
    AIDComponentGroup: Integer): Integer;
begin
  Assert(AStorehouseID > 0);
  Assert(AIDComponentGroup > 0);

  // Меняем в запросе условие
  FDQuery.SQL.Text := Replace(FDQuery.SQL.Text, 'where (StorehouseID = :StorehouseID) and (IDComponentGroup=:IDComponentGroup)', 'where');
  SetParamType('StorehouseID');
  SetParamType('IDComponentGroup');

  // Ищем
  Result := Search(['StorehouseID', 'IDComponentGroup'], [AStorehouseID, AIDComponentGroup]);
end;

function TQuerySearchStorehouseProduct.SearchByID(AID: Integer): Integer;
begin
  Assert(AID > 0);

  // Меняем в запросе условие
  FDQuery.SQL.Text := Replace(FDQuery.SQL.Text, 'where ID=:ID', 'where');
  SetParamType('ID');

  // Ищем
  Result := Search(['ID'], [AID]);
end;

function TQuerySearchStorehouseProduct.SearchByProductID(AProductID: Integer):
    Integer;
begin
  Assert(AProductID > 0);

  // Меняем в запросе условие
  FDQuery.SQL.Text := Replace(FDQuery.SQL.Text, 'where ProductID = :ProductID', 'where');
  SetParamType('ProductID');

  // Ищем
  Result := Search(['ProductID'], [AProductID]);
end;

end.
