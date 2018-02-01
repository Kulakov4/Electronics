unit SearchParameterSubParameterQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQuerySearchParameterSubParameter = class(TQueryBase)
  private
    function GetParamSubParamID: TField;
    { Private declarations }
  public
    function SearchByID(AParameterID: Integer): Integer;
    property ParamSubParamID: TField read GetParamSubParamID;
    { Public declarations }
  end;

var
  QuerySearchParameterSubParameter: TQuerySearchParameterSubParameter;

implementation

{$R *.dfm}

function TQuerySearchParameterSubParameter.GetParamSubParamID: TField;
begin
  Result := Field('ParamSubParamID');
end;

function TQuerySearchParameterSubParameter.SearchByID(AParameterID: Integer):
    Integer;
begin
  Assert(AParameterID > 0);
  Result := Search(['ID'], [AParameterID]);
end;

end.
