unit ProductParametersQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, DSWrap;

type
  TProductParametersW = class(TDSWrap)
  private
    FParamSubParamID: TFieldWrap;
    FID: TFieldWrap;
    FParentProductID: TFieldWrap;
    FProductID: TFieldWrap;
    FValue: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    procedure ApplyFilter(AProductID: Integer; const AParamSubParamID: Integer);
    property ParamSubParamID: TFieldWrap read FParamSubParamID;
    property ID: TFieldWrap read FID;
    property ParentProductID: TFieldWrap read FParentProductID;
    property ProductID: TFieldWrap read FProductID;
    property Value: TFieldWrap read FValue;
  end;

  TQueryProductParameters = class(TQueryBase)
  private
    FW: TProductParametersW;
    { Private declarations }
  protected
  public
    constructor Create(AOwner: TComponent); override;
    property W: TProductParametersW read FW;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TQueryProductParameters.Create(AOwner: TComponent);
begin
  inherited;
  DetailParameterName := 'ProductCategoryId';
  FW := TProductParametersW.Create(FDQuery);
end;

constructor TProductParametersW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'pv.ID', '', True);
  FParamSubParamID := TFieldWrap.Create(Self, 'pv.ParamSubParamID');
  FParentProductID := TFieldWrap.Create(Self, 'p.ParentProductId');
  FProductID := TFieldWrap.Create(Self, 'pv.ProductId');
  FValue := TFieldWrap.Create(Self, 'pv.Value');
end;

procedure TProductParametersW.ApplyFilter(AProductID: Integer; const
    AParamSubParamID: Integer);
begin
  Assert(AProductID > 0);
  Assert(AParamSubParamID > 0);

  DataSet.Filter := Format('(%s=%d) and (%s=%d)',
    [ProductID.FieldName, AProductID, ParamSubParamID.FieldName, AParamSubParamID]);
  DataSet.Filtered := True;
end;

end.
