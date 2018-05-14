unit SearchComponentParamSubParamsQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQuerySearchComponentParamSubParams = class(TQueryBase)
  private
    { Private declarations }
  public
    function SearchEx(AComponentID, AParamSubParamID: Integer): Integer;
    { Public declarations }
  end;

var
  QuerySearchComponentParamSubParams: TQuerySearchComponentParamSubParams;

implementation

{$R *.dfm}

function TQuerySearchComponentParamSubParams.SearchEx(AComponentID,
    AParamSubParamID: Integer): Integer;
begin
  Assert(AComponentID > 0);
  Assert(AParamSubParamID > 0);

  Result := Search(['ProductID', 'ParamSubParamId'], [AComponentID, AParamSubParamID]);
end;

end.
