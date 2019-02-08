unit SearchDaughterCategoriesQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  SearchCategoriesPathQuery;

type
  TQuerySearchDaughterCategories = class(TQueryBase)
  private
    FW: TSearchCategoriesPathW;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    function SearchEx(ACategoryID: Integer): Integer;
    property W: TSearchCategoriesPathW read FW;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TQuerySearchDaughterCategories.Create(AOwner: TComponent);
begin
  inherited;
  FW := TSearchCategoriesPathW.Create(FDQuery);
end;

function TQuerySearchDaughterCategories.SearchEx(ACategoryID: Integer): Integer;
begin
  Assert(ACategoryID > 0);

  Result := Search([W.ID.FieldName], [ACategoryID])
end;

end.
