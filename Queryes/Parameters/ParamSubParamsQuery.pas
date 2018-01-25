unit ParamSubParamsQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, QueryWithDataSourceUnit,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQueryParamSubParams = class(TQueryWithDataSource)
    FDUpdateSQL: TFDUpdateSQL;
  private
    function GetName: TField;
    { Private declarations }
  public
    property Name: TField read GetName;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses RepositoryDataModule;

function TQueryParamSubParams.GetName: TField;
begin
  Result := Field('Name');
end;

end.
