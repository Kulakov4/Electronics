unit SearchProductParameterValuesQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, SearchQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQuerySearchProductParameterValues = class(TQuerySearch)
  private
    function GetValue: TField;
    function GetID: TField;
    function GetProductID: TField;
    function GetUnionParameterID: TField;
    { Private declarations }
  protected
  public
    procedure AppendValue(AValue: Variant);
    procedure EditValue(AValue: Variant);
    function Search(AIDParameter, AIDProduct: Integer): Integer; overload;
    property Value: TField read GetValue;
    property ID: TField read GetID;
    property ProductID: TField read GetProductID;
    property UnionParameterID: TField read GetUnionParameterID;
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TQuerySearchProductParameterValues.AppendValue(AValue: Variant);
begin
  Assert(not VarIsNull(AValue));

  FDQuery.Append;
  UnionParameterID.Value := FDQuery.ParamByName('ParameterId').Value;
  ProductID.Value := FDQuery.ParamByName('ProductID').Value;
  Value.Value := AValue;
  FDQuery.Post;
end;

procedure TQuerySearchProductParameterValues.EditValue(AValue: Variant);
begin
  Assert(not VarIsNull(AValue));
  Assert(FDQuery.RecordCount > 0);

  if Value.Value <> AValue then
  begin
    FDQuery.Edit;
    Value.Value := AValue;
    FDQuery.Post;
  end;
end;

function TQuerySearchProductParameterValues.GetValue: TField;
begin
  Result := FDQuery.FieldByName('Value');
end;

function TQuerySearchProductParameterValues.GetID: TField;
begin
  Result := FDQuery.FieldByName('ID');
end;

function TQuerySearchProductParameterValues.GetProductID: TField;
begin
  Result := FDQuery.FieldByName('ProductID');
end;

function TQuerySearchProductParameterValues.GetUnionParameterID: TField;
begin
  Result := FDQuery.FieldByName('UnionParameterID');
end;

function TQuerySearchProductParameterValues.Search(AIDParameter, AIDProduct:
    Integer): Integer;
begin
  Assert(AIDParameter > 0);
  Assert(AIDProduct > 0);

  Result := Search(['ParameterId', 'ProductID'], [AIDParameter, AIDProduct]);
end;

end.
