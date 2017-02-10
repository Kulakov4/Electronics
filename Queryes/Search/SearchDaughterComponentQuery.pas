unit SearchDaughterComponentQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQuerySearchDaughterComponent = class(TQueryBase)
  private
    function GetParentProductID: TField;
    { Private declarations }
  protected
  public
    function Search(const AComponentName: string): Integer; overload;
    property ParentProductID: TField read GetParentProductID;
    { Public declarations }
  end;

implementation

{$R *.dfm}

function TQuerySearchDaughterComponent.GetParentProductID: TField;
begin
  Result := Field('ParentProductID');
end;

function TQuerySearchDaughterComponent.Search(const AComponentName : string): Integer;
begin
  Assert(not AComponentName.IsEmpty);
  Result := Search(['ComponentName'], [AComponentName]);
end;

end.
