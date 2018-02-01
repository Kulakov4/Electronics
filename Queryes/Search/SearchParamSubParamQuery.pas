unit SearchParamSubParamQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQuerySearchParamSubParam = class(TQueryBase)
  private
    { Private declarations }
  protected
  public
    function SearchByID(const AParamSubParamID: Integer): Integer;
    { Public declarations }
  end;

implementation

{$R *.dfm}

function TQuerySearchParamSubParam.SearchByID(const AParamSubParamID: Integer):
    Integer;
begin
  Assert(AParamSubParamID > 0);
  Result := Search(['ID'], [AParamSubParamID]);
end;

end.
