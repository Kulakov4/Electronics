unit SearchFamilyParamValuesQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQueryFamilyParamValues = class(TQueryBase)
  private
    function GetValue: TField;
    { Private declarations }
  protected
  public
    function SearchEx(AFamilyID, AParameterID: Integer): Integer;
    property Value: TField read GetValue;
    { Public declarations }
  end;

implementation

{$R *.dfm}

function TQueryFamilyParamValues.GetValue: TField;
begin
  Result := Field('Value');
end;

function TQueryFamilyParamValues.SearchEx(AFamilyID, AParameterID: Integer):
    Integer;
begin
  Assert(AFamilyID > 0);
  Assert(AParameterID > 0);

  Result := Search(['ParameterID', 'parentProductid'], [AParameterID, AFamilyID]);
end;

end.
