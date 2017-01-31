unit SearchComponentCategoryQuery2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQuerySearchComponentCategory2 = class(TQueryBase)
  private
    function GetProductCategoryID: TField;
    { Private declarations }
  public
    procedure DeleteAll;
    function Search(AIDComponent: Integer; const ASubGroup: String): Integer;
        overload;
    procedure SearchAndDelete(AIDComponent: Integer; const ASubGroup: String);
    property ProductCategoryID: TField read GetProductCategoryID;
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TQuerySearchComponentCategory2.DeleteAll;
begin
  Assert(FDQuery.Active);

  while not FDQuery.Eof do
    FDQuery.Delete;
end;

function TQuerySearchComponentCategory2.GetProductCategoryID: TField;
begin
  Result := Field('ProductCategoryID');
end;

function TQuerySearchComponentCategory2.Search(AIDComponent: Integer; const
    ASubGroup: String): Integer;
begin
  Assert(AIDComponent > 0);
//  Assert(not ASubGroup.IsEmpty);

  Result := Search(['ProductID', 'SubGroup'], [AIDComponent, ASubGroup]);
end;

procedure TQuerySearchComponentCategory2.SearchAndDelete(AIDComponent: Integer;
    const ASubGroup: String);
begin
  if Search(AIDComponent, ASubGroup) > 0 then
    DeleteAll;
end;

end.
