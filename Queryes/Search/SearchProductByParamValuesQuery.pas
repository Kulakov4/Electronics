unit SearchProductByParamValuesQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, StrHelper;

type
  TqSearchProductByParamValues = class(TQueryBase)
  private
    function GetProductId: TField;
    { Private declarations }
  public
    function GetSQL(AParamSubParamID: Integer; const AParamValues: String): String;
    procedure Execute(AProductCategoryId: Integer);
    property ProductId: TField read GetProductId;
    { Public declarations }
  end;

implementation

{$R *.dfm}

function TqSearchProductByParamValues.GetProductId: TField;
begin
  Result := Field('ProductId');
end;

function TqSearchProductByParamValues.GetSQL(AParamSubParamID: Integer; const
    AParamValues: String): String;
begin
  Assert(AParamSubParamID > 0);
  Assert(not AParamValues.IsEmpty);

  Result := Replace(FDQuery.SQL.Text, AParamSubParamID.ToString, '(0)');
  Result := Replace(Result, AParamSubParamID.ToString, '(1)');
  Result := Replace(Result, Format('(%s)', [AParamValues]), '(2)');
end;

procedure TqSearchProductByParamValues.Execute(AProductCategoryId: Integer);
begin
  Assert(AProductCategoryId > 0);
  FDQuery.ParamByName('ProductCategoryId').Value := AProductCategoryId;
  FDQuery.ExecSQL;
end;

end.
