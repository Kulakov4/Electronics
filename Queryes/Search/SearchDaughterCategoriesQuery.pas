unit SearchDaughterCategoriesQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQuerySearchDaughterCategories = class(TQueryBase)
  private
    { Private declarations }
  public
    function SearchEx(ACategoryID: Integer): Integer;
    { Public declarations }
  end;

var
  QuerySearchDaughterCategories: TQuerySearchDaughterCategories;

implementation

{$R *.dfm}

function TQuerySearchDaughterCategories.SearchEx(ACategoryID: Integer): Integer;
begin
  Assert(ACategoryID > 0);

  Result := Search(['ID'], [ACategoryID])
end;

end.
