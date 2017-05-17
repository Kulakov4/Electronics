unit BodiesQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQueryBodies = class(TQueryBase)
    FDUpdateSQL: TFDUpdateSQL;
  private
    function GetBody: TField;
    function GetIDBodyKind: TField;
    { Private declarations }
  public
    procedure LocateOrAppend(const ABody: string; AIDBodyKind: Integer);
    property Body: TField read GetBody;
    property IDBodyKind: TField read GetIDBodyKind;
    { Public declarations }
  end;

implementation

{$R *.dfm}

function TQueryBodies.GetBody: TField;
begin
  Result := Field('Body');
end;

function TQueryBodies.GetIDBodyKind: TField;
begin
  Result := Field('IDBodyKind');
end;

procedure TQueryBodies.LocateOrAppend(const ABody: string; AIDBodyKind:
    Integer);
var
  AFieldNames: string;
begin
  Assert(not ABody.IsEmpty);
  Assert(AIDBodyKind > 0);

  AFieldNames := Format('%s;%s', [IDBodyKind.FieldName, Body.FieldName]);

  if not FDQuery.LocateEx(AFieldNames, VarArrayOf([AIDBodyKind, ABody]),
    [lxoCaseInsensitive]) then
  begin
    TryAppend;
    Body.Value := ABody;
    IDBodyKind.Value := AIDBodyKind;
    TryPost;
  end;
end;

end.
