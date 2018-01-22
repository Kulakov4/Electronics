unit ParameterKindsQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, QueryWithDataSourceUnit,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQueryParameterKinds = class(TQueryWithDataSource)
  private
    function GetParameterKind: TField;
    { Private declarations }
  public
    property ParameterKind: TField read GetParameterKind;
    { Public declarations }
  end;

implementation

{$R *.dfm}

function TQueryParameterKinds.GetParameterKind: TField;
begin
  Result := Field('ParameterKind');
end;

end.
