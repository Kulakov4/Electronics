unit ExtraChargeSimpleQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQueryExtraChargeSimple = class(TQueryBase)
  private
    function GetL: TField;
    function GetH: TField;
    function GetWholeSale: TField;
    { Private declarations }
  public
    function SearchByID(AID: Integer; TestResult: Integer = -1): Integer;
    property L: TField read GetL;
    property H: TField read GetH;
    property WholeSale: TField read GetWholeSale;
    { Public declarations }
  end;

implementation

uses
  StrHelper;

{$R *.dfm}

function TQueryExtraChargeSimple.GetL: TField;
begin
  Result := Field('L');
end;

function TQueryExtraChargeSimple.GetH: TField;
begin
  Result := Field('H');
end;

function TQueryExtraChargeSimple.GetWholeSale: TField;
begin
  Result := Field('WholeSale');
end;

function TQueryExtraChargeSimple.SearchByID(AID: Integer; TestResult: Integer
    = -1): Integer;
begin
  Assert(AID >= 0);

  // Меняем условие
  FDQuery.SQL.Text := Replace(FDQuery.SQL.Text, 'where ID=:ID', 'where');
  SetParamType('ID');

  // Ищем
  Result := Search(['ID'], [AID], TestResult);
end;

end.
