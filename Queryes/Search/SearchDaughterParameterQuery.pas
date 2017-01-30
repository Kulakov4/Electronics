unit SearchDaughterParameterQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, SearchQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQuerySearchDaughterParameter = class(TQuerySearch)
  private
    function GetID: TField;
    { Private declarations }
  public
    procedure Append(const AValue: String);
    function Search(const AValue: String; AParentID: Integer): Integer; overload;
    property ID: TField read GetID;
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TQuerySearchDaughterParameter.Append(const AValue: String);
var
  AParentParameter: Integer;
begin
  Assert(not AValue.IsEmpty);
  AParentParameter := FDQuery.ParamByName('ParentParameter').AsInteger;
  Assert(AParentParameter > 0);
  FDQuery.Append;
  FDQuery.FieldByName('Value').AsString := AValue;
  FDQuery.FieldByName('ParentParameter').AsInteger := AParentParameter;
  FDQuery.Post;
end;

function TQuerySearchDaughterParameter.GetID: TField;
begin
  Result := FDQuery.FieldByName('ID');
end;

function TQuerySearchDaughterParameter.Search(const AValue: String; AParentID:
    Integer): Integer;
begin
  Assert(not AValue.IsEmpty);
  Assert(AParentID > 0);

  Result := Search(['Value', 'ParentParameter'], [AValue, AParentID]);
end;

end.
