unit ClearStorehouseProductsQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseFDQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, RepositoryDataModule;

type
  TQryClearStoreHouseProducts = class(TQryBase)
  private
    { Private declarations }
  public
    class procedure ExecSQL; static;
    { Public declarations }
  end;

implementation

{$R *.dfm}

class procedure TQryClearStoreHouseProducts.ExecSQL;
var
  Q: TQryClearStoreHouseProducts;
begin
  Q := TQryClearStoreHouseProducts.Create(nil);
  try
    Assert(DMRepository <> nil);
    Q.FDQuery.ExecSQL;
  finally
    FreeAndNil(Q);
  end;
end;

end.
