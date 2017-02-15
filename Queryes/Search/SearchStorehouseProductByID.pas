unit SearchStorehouseProductByID;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQuerySearchStorehouseProductByID = class(TQueryBase)
  private
    { Private declarations }
  public
    function Search(AProductID: Integer): Integer; overload;
    { Public declarations }
  end;

implementation

{$R *.dfm}

function TQuerySearchStorehouseProductByID.Search(AProductID: Integer): Integer;
begin
  Assert(AProductID > 0);
  Result := Search(['ProductID'], [AProductID]);
end;

end.
