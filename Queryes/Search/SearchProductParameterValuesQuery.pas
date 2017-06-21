unit SearchProductParameterValuesQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQuerySearchProductParameterValues = class(TQueryBase)
  private
    function GetValue: TField;
    function GetProductID: TField;
    function GetParameterID: TField;
    { Private declarations }
  protected
  public
    procedure AppendValue(AValue: Variant);
    procedure EditValue(AValue: Variant);
    function Search(AIDParameter, AIDProduct: Integer): Integer; overload;
    property Value: TField read GetValue;
    property ProductID: TField read GetProductID;
    property ParameterID: TField read GetParameterID;
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TQuerySearchProductParameterValues.AppendValue(AValue: Variant);
begin
  Assert(not VarIsNull(AValue));

  FDQuery.Append;
  ParameterID.Value := FDQuery.ParamByName('ParameterId').Value;
  ProductID.Value := FDQuery.ParamByName('ProductID').Value;
  Value.Value := AValue;
  FDQuery.Post;
end;

procedure TQuerySearchProductParameterValues.EditValue(AValue: Variant);
var
  S: string;
begin
  Assert(not VarIsNull(AValue));
  Assert(FDQuery.RecordCount > 0);
  // Если старое значение не равно новому
  if Value.Value <> AValue then
  begin
    S := VarToStr(AValue);
    // Пустую строку в БД не сохраняем
    Assert(not S.IsEmpty);
    FDQuery.Edit;
    Value.Value := AValue;
    FDQuery.Post;
  end;
end;

function TQuerySearchProductParameterValues.GetValue: TField;
begin
  Result := Field('Value');
end;

function TQuerySearchProductParameterValues.GetProductID: TField;
begin
  Result := Field('ProductID');
end;

function TQuerySearchProductParameterValues.GetParameterID: TField;
begin
  Result := Field('ParameterID');
end;

function TQuerySearchProductParameterValues.Search(AIDParameter,
  AIDProduct: Integer): Integer;
begin
  Assert(AIDParameter > 0);
  Assert(AIDProduct > 0);

  Result := Search(['ParameterId', 'ProductID'], [AIDParameter, AIDProduct]);
end;

end.
