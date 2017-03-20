unit VersionQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQueryVersion = class(TQueryBase)
  private
    function GetVersion: TField;
    { Private declarations }
  public
    property Version: TField read GetVersion;
    { Public declarations }
  end;

implementation

{$R *.dfm}

function TQueryVersion.GetVersion: TField;
begin
  Result := Field('Version');
end;

end.
