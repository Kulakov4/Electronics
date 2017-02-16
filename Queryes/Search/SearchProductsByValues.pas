unit SearchProductsByValues;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AbstractSearchByValues,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQuerySearchProductsByValues = class(TQueryAbstractSearchByValues)
  private
    { Private declarations }
  public
    function Search(const AComponentNames: string): Integer; overload; override;
    { Public declarations }
  end;

implementation

{$R *.dfm}

function TQuerySearchProductsByValues.Search(const AComponentNames: string):
    Integer;
begin
  Assert(not AComponentNames.IsEmpty);
  Result := Search(['Value'], [AComponentNames]);
end;

end.
