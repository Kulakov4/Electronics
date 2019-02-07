unit SearchFamilyParamValuesQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, DSWrap;

type
  TFamilyParamValuesW = class(TDSWrap)
  private
    FParamSubParamID: TParamWrap;
    FParentProductId: TParamWrap;
    FValue: TFieldWrap;
  protected
    property ParamSubParamID: TParamWrap read FParamSubParamID;
    property ParentProductId: TParamWrap read FParentProductId;
  public
    constructor Create(AOwner: TComponent); override;
    property Value: TFieldWrap read FValue;
  end;

  TQueryFamilyParamValues = class(TQueryBase)
  private
    FW: TFamilyParamValuesW;
    { Private declarations }
  protected
  public
    constructor Create(AOwner: TComponent); override;
    function SearchEx(AFamilyID, AParamSubParamID: Integer): Integer;
    property W: TFamilyParamValuesW read FW;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TQueryFamilyParamValues.Create(AOwner: TComponent);
begin
  inherited;
  FW := TFamilyParamValuesW.Create(FDQuery);
end;

function TQueryFamilyParamValues.SearchEx(AFamilyID, AParamSubParamID
  : Integer): Integer;
begin
  Assert(AFamilyID > 0);
  Assert(AParamSubParamID > 0);

  Result := Search([W.ParamSubParamID.FieldName, W.ParentProductId.FieldName],
    [AParamSubParamID, AFamilyID]);
end;

constructor TFamilyParamValuesW.Create(AOwner: TComponent);
begin
  inherited;
  FValue := TFieldWrap.Create(Self, 'Value');

  FParamSubParamID := TParamWrap.Create(Self, 'ParamSubParamID');
  FParentProductId := TParamWrap.Create(Self, 'ParentProductId');
end;

end.
