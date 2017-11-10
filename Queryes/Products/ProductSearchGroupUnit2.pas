unit ProductSearchGroupUnit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ProductBaseGroupUnit2, Vcl.ExtCtrls,
  BaseQuery, BaseEventsQuery, QueryWithMasterUnit, QueryWithDataSourceUnit,
  ProductsBaseQuery, ProductsSearchQuery;

type
  TProductSearchGroup = class(TProductBaseGroup)
    qProductsSearch: TQueryProductsSearch;
  private
    { Private declarations }
  protected
    function GetqProductsBase: TQueryProductsBase; override;
  public
    constructor Create(AOwner: TComponent); override;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TProductSearchGroup.Create(AOwner: TComponent);
begin
  inherited;
  Main := qProductsSearch;

end;

function TProductSearchGroup.GetqProductsBase: TQueryProductsBase;
begin
  Result := qProductsSearch;
end;

end.
