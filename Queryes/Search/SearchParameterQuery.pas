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
    function GetIsCustomParameter: TField;
    function GetParentParameter: TField;
    function GetTableName: TField;
    function GetValue: TField;
    { Private declarations }
  public
    procedure AppendDaughter(const AValue: String);
    function SearchDaughter(const AValue: String; AParentID: Integer): Integer;
        overload;
    function SearchMain(const ATableName: String; AIsCustomParameter: Boolean)
      : Integer; overload;
    function SearchMain(const ATableName: String): Integer; overload;
    procedure SearchMainOrAppend(const ATableName: String; AIsCustomParameter:
        Boolean = False);
    property IsCustomParameter: TField read GetIsCustomParameter;
    property ParentParameter: TField read GetParentParameter;
    property TableName: TField read GetTableName;
    property Value: TField read GetValue;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses ProjectConst, StrHelper, System.Math;

procedure TQuerySearchParameter.AppendDaughter(const AValue: String);
var
  AParentParameter: Integer;
begin
  Assert(not AValue.IsEmpty);
  AParentParameter := FDQuery.ParamByName('ParentParameter').AsInteger;
  Assert(AParentParameter > 0);

  FDQuery.Append;
  Value.AsString := AValue;
  ParentParameter.AsInteger := AParentParameter;
  FDQuery.Post;
end;

procedure TQuerySearchParameter.FDQueryAfterOpen(DataSet: TDataSet);
begin
  inherited;
  SetFieldsRequired(False);
end;

function TQuerySearchParameter.GetIsCustomParameter: TField;
begin
  Result := Field('IsCustomParameter');
end;

function TQuerySearchParameter.GetParentParameter: TField;
begin
  Result := Field('ParentParameter');
end;

function TQuerySearchParameter.GetTableName: TField;
begin
  Result := Field('TableName');
end;

function TQuerySearchParameter.GetValue: TField;
begin
  Result := Field('Value');
end;

function TQuerySearchParameter.SearchDaughter(const AValue: String; AParentID:
    Integer): Integer;
var
  ACondition: string;
begin
  Assert(not AValue.IsEmpty);
  Assert(AParentID > 0);

  // Ìåíÿåì óñëîâèå
  ACondition := 'where upper(Value) = upper(:Value) and ParentParameter = :ParentParameter';
  FDQuery.SQL.Text := Replace(FDQuery.SQL.Text, ACondition, 'where');
  SetParamType('Value', ptInput, ftString);
  SetParamType('ParentParameter');

  // Èùåì
  Result := Search(['Value', 'ParentParameter'], [AValue, AParentID]);
end;

function TQuerySearchParameter.SearchMain(const ATableName: String;
  AIsCustomParameter: Boolean): Integer;
var
  ACondition: string;
begin
  Assert(not ATableName.IsEmpty);

  // Ìåíÿåì óñëîâèå
  ACondition := 'where upper(TableName) = upper(:TableName) and ParentParameter is null and IsCustomParameter=:IsCustomParameter';
  FDQuery.SQL.Text := Replace(FDQuery.SQL.Text, ACondition, 'where');
  SetParamType('TableName', ptInput, ftString);
  SetParamType('IsCustomParameter');

  // Èùåì
  Result := Search(['TableName', 'IsCustomParameter'], [ATableName, IfThen(AIsCustomParameter, 1, 0)]);
end;

function TQuerySearchParameter.SearchMain(const ATableName: String):
    Integer;
var
  ACondition: string;
begin
  Assert(not ATableName.IsEmpty);

  // Ìåíÿåì óñëîâèå
  ACondition := 'where upper(TableName) = upper(:TableName) and ParentParameter is null';
  FDQuery.SQL.Text := Replace(FDQuery.SQL.Text, ACondition, 'where');
  SetParamType('TableName', ptInput, ftString);

  // Èùåì
  Result := Search(['TableName'], [ATableName]);
end;

procedure TQuerySearchParameter.SearchMainOrAppend(const ATableName:
    String; AIsCustomParameter: Boolean = False);
var
  k: Integer;
begin
  k := SearchMain(ATableName, AIsCustomParameter);
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
