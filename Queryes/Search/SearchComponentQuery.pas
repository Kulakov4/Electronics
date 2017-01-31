unit SearchComponentQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQuerySearchComponent = class(TQueryBase)
  private
    function GetParentProductID: TField;
    { Private declarations }
  public
    function Search(const AComponentName: string): Integer; overload;
    property ParentProductID: TField read GetParentProductID;
    { Public declarations }
  end;

implementation

{$R *.dfm}

function TQuerySearchComponent.GetParentProductID: TField;
begin
  Result := Field('ParentProductID');
end;

function TQuerySearchComponent.Search(const AComponentName: string): Integer;
begin
  Assert(not AComponentName.IsEmpty);
  Result := Search(['vValue'], [AComponentName]);
end;

end.
