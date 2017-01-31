unit SearchSubCategoriesQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQuerySearchSubCategories = class(TQueryBase)
  private
    { Private declarations }
  public
    function Search(const AParentID: Integer): Integer; overload;
    { Public declarations }
  end;

  TSearchSubCategories = class(TObject)
  private
  public
    class function Search(const AParentID: Integer): Integer; static;
  end;

implementation

{$R *.dfm}

function TQuerySearchSubCategories.Search(const AParentID: Integer): Integer;
begin
  Assert(AParentID > 0);

  Result := Search(['ParentID'], [AParentID]);
end;

class function TSearchSubCategories.Search(const AParentID: Integer): Integer;
var
  AQuerySearchSubCategories: TQuerySearchSubCategories;
begin
  AQuerySearchSubCategories := TQuerySearchSubCategories.Create(nil);
  try
    Result := AQuerySearchSubCategories.Search(AParentID);
  finally
    FreeAndNil(AQuerySearchSubCategories)
  end;
end;

end.
