unit SearchProductParameterValuesQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, DSWrap;

type
  TParameterValuesW = class(TDSWrap)
  private
    FParamSubParamID: TFieldWrap;
    FProductID: TFieldWrap;
    FValue: TFieldWrap;
    FID: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    procedure EditValue(AValue: Variant);
    property ParamSubParamID: TFieldWrap read FParamSubParamID;
    property ProductID: TFieldWrap read FProductID;
    property Value: TFieldWrap read FValue;
    property ID: TFieldWrap read FID;
  end;

  TQuerySearchProductParameterValues = class(TQueryBase)
  private
    FW: TParameterValuesW;
    { Private declarations }
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure AppendValue(AValue: Variant);
    function Search(AParamSubParamID, AIDProduct: Integer): Integer; overload;
    property W: TParameterValuesW read FW;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TQuerySearchProductParameterValues.Create(AOwner: TComponent);
begin
  inherited;
  FW := TParameterValuesW.Create(FDQuery);
end;

procedure TQuerySearchProductParameterValues.AppendValue(AValue: Variant);
begin
  Assert(not VarIsNull(AValue));
  Assert(FDQuery.ParamByName(W.ParamSubParamID.FieldName).AsInteger > 0);
  Assert(FDQuery.ParamByName(W.ProductID.FieldName).AsInteger > 0);

  W.TryAppend;
  W.ParamSubParamID.F.Value := FDQuery.ParamByName
    (W.ParamSubParamID.FieldName).Value;
  W.ProductID.F.Value := FDQuery.ParamByName(W.ProductID.FieldName).Value;
  W.Value.F.Value := AValue;
  W.TryPost;
end;

function TQuerySearchProductParameterValues.Search(AParamSubParamID,
  AIDProduct: Integer): Integer;
begin
  Assert(AParamSubParamID > 0);
  Assert(AIDProduct > 0);

  Result := Search([W.ParamSubParamID.FieldName, W.ProductID.FieldName],
    [AParamSubParamID, AIDProduct]);
end;

constructor TParameterValuesW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'ID', '', True);
  FParamSubParamID := TFieldWrap.Create(Self, 'ParamSubParamID');
  FProductID := TFieldWrap.Create(Self, 'ProductID');
  FValue := TFieldWrap.Create(Self, 'Value');
end;

procedure TParameterValuesW.EditValue(AValue: Variant);
var
  S: string;
begin
  Assert(not VarIsNull(AValue));
  Assert(DataSet.RecordCount > 0);
  // Если старое значение не равно новому
  if Value.F.Value <> AValue then
  begin
    S := VarToStr(AValue);
    // Пустую строку в БД не сохраняем
    Assert(not S.IsEmpty);
    TryEdit;
    Value.F.Value := AValue;
    TryPost;
  end;
end;

end.
