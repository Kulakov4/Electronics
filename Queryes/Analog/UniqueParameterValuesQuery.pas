unit UniqueParameterValuesQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQueryUniqueParameterValues = class(TQueryBase)
  private
    function GetValue: TField;
    { Private declarations }
  public
    function SearchEx(AProductCategoryID, AParamSubParamID: Integer): Integer;
        reintroduce;
    property Value: TField read GetValue;
    { Public declarations }
  end;

implementation

{$R *.dfm}

function TQueryUniqueParameterValues.GetValue: TField;
begin
  Result := Field('Value');
end;

function TQueryUniqueParameterValues.SearchEx(AProductCategoryID,
    AParamSubParamID: Integer): Integer;
begin
  Assert(AProductCategoryID > 0);
  Assert(AParamSubParamID > 0);

  Result := Search(['ProductCategoryId', 'ParamSubParamId'],
    [AProductCategoryID, AParamSubParamID]);
end;

end.
