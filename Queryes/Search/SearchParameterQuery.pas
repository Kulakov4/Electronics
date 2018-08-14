unit SearchParameterQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQuerySearchParameter = class(TQueryBase)
    FDUpdateSQL: TFDUpdateSQL;
    procedure FDQueryAfterOpen(DataSet: TDataSet);
  private
    function GetCodeLetters: TField;
    function GetDefinition: TField;
    function GetIDParameterKind: TField;
    function GetIDParameterType: TField;
    function GetIsCustomParameter: TField;
    function GetMeasuringUnit: TField;
    function GetOrder: TField;
    function GetParamSubParamID: TField;
    function GetTableName: TField;
    function GetValue: TField;
    function GetValueT: TField;
    { Private declarations }
  public
    function SearchByTableName(const ATableName: String; AIsCustomParameter: Boolean)
      : Integer; overload;
    function SearchByTableName(const ATableName: String): Integer; overload;
    function SearchByID(AID: Integer; ATestResult: Boolean = False): Integer;
        overload;
    procedure SearchOrAppend(const ATableName: String; AIsCustomParameter: Boolean);
    property CodeLetters: TField read GetCodeLetters;
    property Definition: TField read GetDefinition;
    property IDParameterKind: TField read GetIDParameterKind;
    property IDParameterType: TField read GetIDParameterType;
    property IsCustomParameter: TField read GetIsCustomParameter;
    property MeasuringUnit: TField read GetMeasuringUnit;
    property Order: TField read GetOrder;
    property ParamSubParamID: TField read GetParamSubParamID;
    property TableName: TField read GetTableName;
    property Value: TField read GetValue;
    property ValueT: TField read GetValueT;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses ProjectConst, StrHelper, System.Math;

procedure TQuerySearchParameter.FDQueryAfterOpen(DataSet: TDataSet);
begin
  inherited;
  SetFieldsRequired(False);
end;

function TQuerySearchParameter.GetCodeLetters: TField;
begin
  Result := Field('CodeLetters');
end;

function TQuerySearchParameter.GetDefinition: TField;
begin
  Result := Field('Definition');
end;

function TQuerySearchParameter.GetIDParameterKind: TField;
begin
  Result := Field('IDParameterKind');
end;

function TQuerySearchParameter.GetIDParameterType: TField;
begin
  Result := Field('IDParameterType');
end;

function TQuerySearchParameter.GetIsCustomParameter: TField;
begin
  Result := Field('IsCustomParameter');
end;

function TQuerySearchParameter.GetMeasuringUnit: TField;
begin
  Result := Field('MeasuringUnit');
end;

function TQuerySearchParameter.GetOrder: TField;
begin
  Result := Field('Order');
end;

function TQuerySearchParameter.GetParamSubParamID: TField;
begin
  Result := Field('ParamSubParamID');
end;

function TQuerySearchParameter.GetTableName: TField;
begin
  Result := Field('TableName');
end;

function TQuerySearchParameter.GetValue: TField;
begin
  Result := Field('Value');
end;

function TQuerySearchParameter.GetValueT: TField;
begin
  Result := Field('ValueT');
end;

function TQuerySearchParameter.SearchByTableName(const ATableName: String;
  AIsCustomParameter: Boolean): Integer;
var
  ACondition: string;
begin
  Assert(not ATableName.IsEmpty);

  // Ìåíÿåì óñëîâèå
  ACondition := 'where upper(TableName) = upper(:TableName) and IsCustomParameter=:IsCustomParameter';
  FDQuery.SQL.Text := Replace(FDQuery.SQL.Text, ACondition, 'where');
  SetParamType('TableName', ptInput, ftWideString);
  SetParamType('IsCustomParameter');

  // Èùåì
  Result := Search(['TableName', 'IsCustomParameter'], [ATableName, IfThen(AIsCustomParameter, 1, 0)]);
end;

function TQuerySearchParameter.SearchByTableName(const ATableName: String):
    Integer;
var
  ACondition: string;
begin
  Assert(not ATableName.IsEmpty);

  // Ìåíÿåì óñëîâèå
  ACondition := 'where upper(TableName) = upper(:TableName)';
  FDQuery.SQL.Text := Replace(FDQuery.SQL.Text, ACondition, 'where');
  SetParamType('TableName', ptInput, ftWideString);

  // Èùåì
  Result := Search(['TableName'], [ATableName]);
end;

function TQuerySearchParameter.SearchByID(AID: Integer; ATestResult: Boolean =
    False): Integer;
var
  ACondition: string;
begin
  Assert(AID > 0);

  // Ìåíÿåì óñëîâèå
  ACondition := 'where p.ID = :ID';
  FDQuery.SQL.Text := Replace(FDQuery.SQL.Text, ACondition, 'where');
  SetParamType('ID');

  // Èùåì
  Result := Search(['ID'], [AID]);

  if ATestResult then
    Assert(Result = 1);
end;

procedure TQuerySearchParameter.SearchOrAppend(const ATableName: String;
    AIsCustomParameter: Boolean);
var
  k: Integer;
begin
  k := SearchByTableName(ATableName, AIsCustomParameter);
  if k = 0 then
  begin
    TryAppend;
    TableName.AsString := ATableName;
    IsCustomParameter.AsBoolean := AIsCustomParameter;
    TryPost;
    Assert(PK.AsInteger > 0);
  end;
end;

end.
