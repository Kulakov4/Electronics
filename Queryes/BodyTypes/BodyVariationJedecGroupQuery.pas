unit BodyVariationJedecGroupQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQueryBodyVariationJEDECGroup = class(TQueryBase)
  private
    function GetJEDEC: TField;
    { Private declarations }
  public
    function SearchByIDBodyVariations(AIDBodyVariations: string): Integer;
    property JEDEC: TField read GetJEDEC;
    { Public declarations }
  end;

implementation

uses
  StrHelper;

{$R *.dfm}

function TQueryBodyVariationJEDECGroup.GetJEDEC: TField;
begin
  Result := Field('JEDEC');
end;

function TQueryBodyVariationJEDECGroup.SearchByIDBodyVariations(
    AIDBodyVariations : string): Integer;
var
  I: Integer;

begin
  Assert(not AIDBodyVariations.IsEmpty);

  // Меняем в запросе условие
  FDQuery.SQL.Text := Replace(FDQuery.SQL.Text,
    Format('where IDBodyVariation in (%s)', [AIDBodyVariations]), 'where');

  // Ищем
  RefreshQuery;
end;

end.
