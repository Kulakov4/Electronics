unit UniqueParameterValuesQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, DSWrap;

type
  TUniqueParameterValuesW = class(TDSWrap)
  private
    FValue: TFieldWrap;
    FParamSubParamId: TFieldWrap;
    FProductCategoryId: TParamWrap;
  public
    constructor Create(AOwner: TComponent); override;
    property Value: TFieldWrap read FValue;
    property ParamSubParamId: TFieldWrap read FParamSubParamId;
    property ProductCategoryId: TParamWrap read FProductCategoryId;
  end;

  TQueryUniqueParameterValues = class(TQueryBase)
  private
    FW: TUniqueParameterValuesW;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    function SearchEx(AProductCategoryID, AParamSubParamID: Integer): Integer;
      reintroduce;
    property W: TUniqueParameterValuesW read FW;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TQueryUniqueParameterValues.Create(AOwner: TComponent);
begin
  inherited;
  FW := TUniqueParameterValuesW.Create(FDQuery);
end;

function TQueryUniqueParameterValues.SearchEx(AProductCategoryID,
  AParamSubParamID: Integer): Integer;
begin
  Assert(AProductCategoryID > 0);
  Assert(AParamSubParamID > 0);

  Result := Search([W.ProductCategoryId.FieldName, W.ParamSubParamId.FieldName],
    [AProductCategoryID, AParamSubParamID]);
end;

constructor TUniqueParameterValuesW.Create(AOwner: TComponent);
begin
  inherited;
  FParamSubParamId := TFieldWrap.Create(Self, 'pv.ParamSubParamId', '', True);
  FValue := TFieldWrap.Create(Self, 'pv.Value');

  FProductCategoryId := TParamWrap.Create(Self, 'ppc.ProductCategoryId');
end;

end.
