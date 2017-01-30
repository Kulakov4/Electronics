unit SearchMainComponent;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, SearchQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQuerySearchMainComponent = class(TQuerySearch)
  private
    function GetID: TField;
    function GetSubGroup: TField;
    { Private declarations }
  public
    function Search(const AComponentName: string): Integer; overload;
    property ID: TField read GetID;
    property SubGroup: TField read GetSubGroup;
    { Public declarations }
  end;

implementation

{$R *.dfm}

function TQuerySearchMainComponent.GetID: TField;
begin
  Result := FDQuery.FieldByName('ID');
end;

function TQuerySearchMainComponent.GetSubGroup: TField;
begin
  Result := FDQuery.FieldByName('SubGroup');
end;

function TQuerySearchMainComponent.Search(const AComponentName: string):
    Integer;
begin
  Assert(not AComponentName.IsEmpty);
  Result := Search(['vValue'], [AComponentName]);
end;

end.
