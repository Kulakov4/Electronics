unit SearchProductByParamValuesQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, StrHelper,
  DSWrap;

type
  TSearchProductByParamValuesW = class(TDSWrap)
  private
    FFamilyID: TFieldWrap;
    FProductId: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    property FamilyID: TFieldWrap read FFamilyID;
    property ProductId: TFieldWrap read FProductId;
  end;

  TqSearchProductByParamValues = class(TQueryBase)
  private
    FW: TSearchProductByParamValuesW;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    procedure Execute(AProductCategoryId: Integer);
    function GetSQL(AParamSubParamID: Integer; const AParamValues: String): String;
    property W: TSearchProductByParamValuesW read FW;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TqSearchProductByParamValues.Create(AOwner: TComponent);
begin
  inherited;
  FW := TSearchProductByParamValuesW.Create(FDQuery);
end;

function TqSearchProductByParamValues.GetSQL(AParamSubParamID: Integer; const
    AParamValues: String): String;
begin
  Assert(AParamSubParamID > 0);
  Assert(not AParamValues.IsEmpty);

  Result := FDQuery.SQL.Text.Replace('(0)', AParamSubParamID.ToString);
  Result := Result.Replace('(1)', AParamSubParamID.ToString);
  Result := Result.Replace('(2)', Format('(%s)', [AParamValues]));
end;

procedure TqSearchProductByParamValues.Execute(AProductCategoryId: Integer);
begin
  Assert(AProductCategoryId > 0);
  FDQuery.ParamByName('ProductCategoryId').Value := AProductCategoryId;
  FDQuery.ExecSQL;
end;

constructor TSearchProductByParamValuesW.Create(AOwner: TComponent);
begin
  inherited;
  FFamilyID := TFieldWrap.Create(Self, 'FamilyID');
  FProductId := TFieldWrap.Create(Self, 'ProductId');
end;

end.
