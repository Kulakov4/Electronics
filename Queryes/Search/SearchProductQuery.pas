unit SearchProductQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQuerySearchProduct = class(TQueryBase)
  private
    { Private declarations }
  public
    function Search(const AValue: string; const AIDProducer: Integer): Integer;
        overload;
    { Public declarations }
  end;

implementation

{$R *.dfm}

function TQuerySearchProduct.Search(const AValue: string; const AIDProducer:
    Integer): Integer;
begin
  Assert(not AValue.IsEmpty);
  Assert(AIDProducer > 0);

  Result := Search(['Value', 'IDProducer'], [AValue, AIDProducer]);
end;

end.
