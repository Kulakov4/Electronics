unit SearchComponentGroup;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQuerySearchComponentGroup = class(TQueryBase)
  private
    function GetComponentGroup: TField;
    { Private declarations }
  public
    procedure Append(const AComponentGroup: string);
    function Search(const AComponentGroup: string): Integer; overload;
    property ComponentGroup: TField read GetComponentGroup;
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TQuerySearchComponentGroup.Append(const AComponentGroup: string);
begin
  Assert(not AComponentGroup.IsEmpty);
  TryAppend;
  ComponentGroup.Value := AComponentGroup;
  TryPost;
end;

function TQuerySearchComponentGroup.GetComponentGroup: TField;
begin
  Result := Field('ComponentGroup');
end;

function TQuerySearchComponentGroup.Search(const AComponentGroup
  : string): Integer;
begin
  Assert(not AComponentGroup.IsEmpty);
  Result := Search(['ComponentGroup'], [AComponentGroup]);
end;

end.
