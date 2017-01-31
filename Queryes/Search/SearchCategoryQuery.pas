unit SearchCategoryQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQuerySearchCategory = class(TQueryBase)
  private
    { Private declarations }
  public
    function Search(ASubgroup: string): Integer; overload;
    { Public declarations }
  end;

var
  QuerySearchCategory: TQuerySearchCategory;

implementation

{$R *.dfm}

function TQuerySearchCategory.Search(ASubgroup: string): Integer;
begin
  Assert(not ASubgroup.IsEmpty);

  Result := Search( ['SubGroup'], [ASubGroup] );
end;

end.
