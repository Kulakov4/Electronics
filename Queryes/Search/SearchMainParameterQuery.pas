unit SearchMainParameterQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, SearchQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQuerySearchMainParameter = class(TQuerySearch)
  private
    function GetID: TField;
    { Private declarations }
  public
    function Search(const ATableName: String): Integer; overload;
    property ID: TField read GetID;
    { Public declarations }
  end;

implementation

{$R *.dfm}

function TQuerySearchMainParameter.GetID: TField;
begin
  Result := FDQuery.FieldByName('ID');
end;

function TQuerySearchMainParameter.Search(const ATableName: String): Integer;
begin
  Assert(not ATableName.IsEmpty);

  Result := Search(['TableName'], [ATableName]);
end;

end.
