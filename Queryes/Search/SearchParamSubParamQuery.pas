unit SearchParamSubParamQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQuerySearchParamSubParam = class(TQueryBase)
  private
    function GetIDParameter: TField;
    function GetIDSubParameter: TField;
    function GetIsDefault: TField;
    function GetName: TField;
    function GetParameterType: TField;
    function GetTableName: TField;
    function GetTranslation: TField;
    function GetValue: TField;
    function GetValueT: TField;
    { Private declarations }
  protected
  public
    function SearchByID(const AParamSubParamID: Integer; TestResult: Integer = -1):
        Integer;
    property IDParameter: TField read GetIDParameter;
    property IDSubParameter: TField read GetIDSubParameter;
    property IsDefault: TField read GetIsDefault;
    property Name: TField read GetName;
    property ParameterType: TField read GetParameterType;
    property TableName: TField read GetTableName;
    property Translation: TField read GetTranslation;
    property Value: TField read GetValue;
    property ValueT: TField read GetValueT;
    { Public declarations }
  end;

implementation

{$R *.dfm}

function TQuerySearchParamSubParam.GetIDParameter: TField;
begin
  Result := Field('IDParameter');
end;

function TQuerySearchParamSubParam.GetIDSubParameter: TField;
begin
  Result := Field('IdSubParameter');
end;

function TQuerySearchParamSubParam.GetIsDefault: TField;
begin
  Result := Field('IsDefault');
end;

function TQuerySearchParamSubParam.GetName: TField;
begin
  Result := Field('Name');
end;

function TQuerySearchParamSubParam.GetParameterType: TField;
begin
  Result := Field('ParameterType');
end;

function TQuerySearchParamSubParam.GetTableName: TField;
begin
  Result := Field('TableName');
end;

function TQuerySearchParamSubParam.GetTranslation: TField;
begin
  Result := Field('Translation');
end;

function TQuerySearchParamSubParam.GetValue: TField;
begin
  Result := Field('Value');
end;

function TQuerySearchParamSubParam.GetValueT: TField;
begin
  Result := Field('ValueT');
end;

function TQuerySearchParamSubParam.SearchByID(const AParamSubParamID: Integer;
    TestResult: Integer = -1): Integer;
begin
  Assert(AParamSubParamID > 0);
  Result := Search(['ID'], [AParamSubParamID], TestResult);
end;

end.
