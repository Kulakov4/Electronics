unit SearchProductCategoryByExternalID;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQuerySearchProductCategoryByExternalID = class(TQueryBase)
  private
    { Private declarations }
  public
    function Search(const AExternalId: string): Integer; overload;
    { Public declarations }
  end;


implementation

{$R *.dfm}

function TQuerySearchProductCategoryByExternalID.Search(const AExternalId: string): Integer;
begin
  Assert(not AExternalId.IsEmpty);
  Result := Search(['vExternalId'], [AExternalId]);
end;

end.
