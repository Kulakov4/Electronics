unit BodyOptionsQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQueryBodyOptions = class(TQueryBase)
  private
    function GetOption: TField;
    { Private declarations }
  public
    function LocateOrAppend(const AOption: string): Boolean;
    property Option: TField read GetOption;
    { Public declarations }
  end;

implementation

{$R *.dfm}

function TQueryBodyOptions.GetOption: TField;
begin
  Result := Field('Option');
end;

function TQueryBodyOptions.LocateOrAppend(const AOption: string): Boolean;
begin
  Assert(not AOption.IsEmpty);

  Result := LocateByField( Option.FieldName, AOption, [lxoCaseInsensitive] );
  if Result then Exit;

  TryAppend;
  Option.AsString := AOption;
  TryPost;
end;

end.
