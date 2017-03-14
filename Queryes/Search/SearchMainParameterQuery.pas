unit SearchMainParameterQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQuerySearchMainParameter = class(TQueryBase)
    FDUpdateSQL: TFDUpdateSQL;
    procedure FDQueryAfterOpen(DataSet: TDataSet);
  private
    function GetIsCustomParameter: TField;
    function GetTableName: TField;
    { Private declarations }
  public
    function Search(const ATableName: String; AIsCustomParameter: Boolean):
        Integer; overload;
    function Search(const ATableName: String): Integer; overload;
    procedure SearchOrAppend(const ATableName: String; AIsCustomParameter: Boolean
        = False);
    property IsCustomParameter: TField read GetIsCustomParameter;
    property TableName: TField read GetTableName;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses ProjectConst;

procedure TQuerySearchMainParameter.FDQueryAfterOpen(DataSet: TDataSet);
begin
  inherited;
  SetFieldsRequired(False);
end;

function TQuerySearchMainParameter.GetIsCustomParameter: TField;
begin
  Result := Field('IsCustomParameter');
end;

function TQuerySearchMainParameter.GetTableName: TField;
begin
  Result := Field('TableName');
end;

function TQuerySearchMainParameter.Search(const ATableName: String;
    AIsCustomParameter: Boolean): Integer;
begin
  Assert(not ATableName.IsEmpty);

  Result := Search(['TableName'], [ATableName]);
  if Result > 0 then
  begin
    FDQuery.Filter := Format('IsCustomParameter=%s', [BoolToStr(AIsCustomParameter)]);
    FDQuery.Filtered := True;
    Result := FDQuery.RecordCount;
  end;
end;

function TQuerySearchMainParameter.Search(const ATableName: String): Integer;
begin
  Assert(not ATableName.IsEmpty);

  FDQuery.Filtered := False;
  FDQuery.Filter := '';
  Result := Search(['TableName'], [ATableName]);
end;

procedure TQuerySearchMainParameter.SearchOrAppend(const ATableName: String;
    AIsCustomParameter: Boolean = False);
var
  k: Integer;
begin
  k := Search(ATableName, AIsCustomParameter);
  if k = 0 then
  begin
    TryAppend;
    TableName.AsString := ATableName;
    IsCustomParameter.AsBoolean := AIsCustomParameter;
    TryPost;
    Assert(PKValue > 0);
  end;
end;

end.
