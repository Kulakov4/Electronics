unit SearchDetailComponentQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQuerySearchDetailComponent = class(TQueryBase)
  private
    { Private declarations }
  public
    function Search(AParentID: Integer; const AComponentName: string): Integer;
        overload;
    { Public declarations }
  end;


implementation

{$R *.dfm}

function TQuerySearchDetailComponent.Search(AParentID: Integer; const
    AComponentName: string): Integer;
begin
  Assert(AParentID > 0);
  Assert(not AComponentName.IsEmpty);
  Result := Search(['ParentProductID', 'Value'], [AParentID, AComponentName]);
end;

end.
