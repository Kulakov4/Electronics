unit ProductBaseGroupUnit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, QueryGroupUnit, Vcl.ExtCtrls,
  ProductsBaseQuery;

type
  TProductBaseGroup = class(TQueryGroup)
  private
    { Private declarations }
  protected
    function GetqProductsBase: TQueryProductsBase; virtual; abstract;
  public
    property qProductsBase: TQueryProductsBase read GetqProductsBase;
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
