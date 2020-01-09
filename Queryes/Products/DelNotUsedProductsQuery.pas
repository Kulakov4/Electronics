unit DelNotUsedProductsQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQueryDelNotUsedProducts2 = class(TQueryBase)
  private
    { Private declarations }
  public
    class procedure Delete(AProducerID: Integer); static;
    { Public declarations }
  end;

implementation

{$R *.dfm}

class procedure TQueryDelNotUsedProducts2.Delete(AProducerID: Integer);
var
  Q: TQueryDelNotUsedProducts2;
begin
  Assert(AProducerID > 0);
  Q := TQueryDelNotUsedProducts2.Create(Nil);
  try
    Q.FDQuery.ExecSQL('', [AProducerID])
  finally
    FreeAndNil(Q);
  end;
end;

end.
