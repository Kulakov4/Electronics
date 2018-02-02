unit SearchParamDefSubParamQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQuerySearchParamDefSubParam = class(TQueryBase)
  private
    function GetIsDefault: TField;
    function GetName: TField;
    function GetParameterType: TField;
    function GetParamSubParamID: TField;
    function GetTableName: TField;
    function GetTranslation: TField;
    function GetValue: TField;
    function GetValueT: TField;
    { Private declarations }
  public
    function SearchByID(AParameterID: Integer): Integer;
    property IsDefault: TField read GetIsDefault;
    property Name: TField read GetName;
    property ParameterType: TField read GetParameterType;
    property ParamSubParamID: TField read GetParamSubParamID;
    property TableName: TField read GetTableName;
    property Translation: TField read GetTranslation;
    property Value: TField read GetValue;
    property ValueT: TField read GetValueT;
    { Public declarations }
  end;

var
  QuerySearchParamDefSubParam: TQuerySearchParamDefSubParam;

implementation

{$R *.dfm}

function TQuerySearchParamDefSubParam.GetIsDefault: TField;
begin
  Result := Field('IsDefault');
end;

function TQuerySearchParamDefSubParam.GetName: TField;
begin
  Result := Field('Name');
end;

function TQuerySearchParamDefSubParam.GetParameterType: TField;
begin
  Result := Field('ParameterType');
end;

function TQuerySearchParamDefSubParam.GetParamSubParamID: TField;
begin
  Result := Field('ParamSubParamID');
end;

function TQuerySearchParamDefSubParam.GetTableName: TField;
begin
  Result := Field('TableName');
end;

function TQuerySearchParamDefSubParam.GetTranslation: TField;
begin
  Result := Field('Translation');
end;

function TQuerySearchParamDefSubParam.GetValue: TField;
begin
  Result := Field('Value');
end;

function TQuerySearchParamDefSubParam.GetValueT: TField;
begin
  Result := Field('ValueT');
end;

function TQuerySearchParamDefSubParam.SearchByID(AParameterID: Integer):
    Integer;
begin
  Assert(AParameterID > 0);
  Result := Search(['ID'], [AParameterID]);
end;

end.
