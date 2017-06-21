unit SearchComponentsByValues;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  AbstractSearchByValues;

type
  TQuerySearchComponentsByValues = class(TQueryAbstractSearchByValues)
  private
    function GetParentProductID: TField;
    { Private declarations }
  public
    function Search(const AComponentNames: string): Integer; overload; override;
    property ParentProductID: TField read GetParentProductID;
    { Public declarations }
  end;

implementation

{$R *.dfm}

function TQuerySearchComponentsByValues.GetParentProductID: TField;
begin
  Result := Field('ParentProductID');
end;

function TQuerySearchComponentsByValues.Search(const AComponentNames
  : string): Integer;
begin
  Assert(not AComponentNames.IsEmpty);
  Result := Search(['Value'], [AComponentNames]);
end;

end.
