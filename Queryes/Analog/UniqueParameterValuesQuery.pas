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
    function SearchEx(AProductCategoryID, AParameterId: Integer): Integer;
        reintroduce;
    property Value: TField read GetValue;
    { Public declarations }
  end;

var
  QueryUniqueParameterValues: TQueryUniqueParameterValues;

implementation

{$R *.dfm}

function TQueryUniqueParameterValues.GetValue: TField;
begin
  Result := Field('Value');
end;

function TQueryUniqueParameterValues.SearchEx(AProductCategoryID, AParameterId:
    Integer): Integer;
begin
  Assert(AProductCategoryID > 0);
  Assert(AParameterId > 0);

  Result := Search(['ProductCategoryId', 'ParameterId'],
    [AProductCategoryID, AParameterId]);
end;

end.
