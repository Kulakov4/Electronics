unit JEDECQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQueryJEDEC = class(TQueryBase)
  private
    function GetJEDEC: TField;
    { Private declarations }
  public
    function LocateOrAppend(const AJedec: string): Boolean;
    property JEDEC: TField read GetJEDEC;
    { Public declarations }
  end;

implementation

{$R *.dfm}

function TQueryJEDEC.GetJEDEC: TField;
begin
  Result := Field('JEDEC');
end;

function TQueryJEDEC.LocateOrAppend(const AJedec: string): Boolean;
begin
  Assert(not AJedec.IsEmpty);

  Result := LocateByField( JEDEC.FieldName, AJedec, [lxoCaseInsensitive] );
  if Result then Exit;

  TryAppend;
  JEDEC.AsString := AJedec;
  TryPost;
end;

end.
