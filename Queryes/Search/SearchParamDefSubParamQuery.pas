unit SearchParamDefSubParamQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, DSWrap;

type
  TParamDefSubParamW = class(TDSWrap)
  private
    FID: TFieldWrap;
    FIDSubParameter: TFieldWrap;
    FIsDefault: TFieldWrap;
    FName: TFieldWrap;
    FParameterType: TFieldWrap;
    FParamSubParamID: TFieldWrap;
    FTableName: TFieldWrap;
    FTranslation: TFieldWrap;
    FValue: TFieldWrap;
    FValueT: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    property ID: TFieldWrap read FID;
    property IDSubParameter: TFieldWrap read FIDSubParameter;
    property IsDefault: TFieldWrap read FIsDefault;
    property Name: TFieldWrap read FName;
    property ParameterType: TFieldWrap read FParameterType;
    property ParamSubParamID: TFieldWrap read FParamSubParamID;
    property TableName: TFieldWrap read FTableName;
    property Translation: TFieldWrap read FTranslation;
    property Value: TFieldWrap read FValue;
    property ValueT: TFieldWrap read FValueT;
  end;

  TQuerySearchParamDefSubParam = class(TQueryBase)
  private
    FW: TParamDefSubParamW;
    { Private declarations }
  protected
  public
    constructor Create(AOwner: TComponent); override;
    function SearchByID(AParameterID: Integer;
      TestResult: Integer = -1): Integer;
    property W: TParamDefSubParamW read FW;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TQuerySearchParamDefSubParam.Create(AOwner: TComponent);
begin
  inherited;
  FW := TParamDefSubParamW.Create(FDQuery);
end;

function TQuerySearchParamDefSubParam.SearchByID(AParameterID: Integer;
  TestResult: Integer = -1): Integer;
begin
  Assert(AParameterID > 0);

  Result := SearchEx([TParamRec.Create(W.ID.FullName, AParameterID)],
    TestResult);
end;

constructor TParamDefSubParamW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'p.ID', '', True);
  FIDSubParameter := TFieldWrap.Create(Self, 'IDSubParameter');
  FIsDefault := TFieldWrap.Create(Self, 'IsDefault');
  FName := TFieldWrap.Create(Self, 'Name');
  FParameterType := TFieldWrap.Create(Self, 'ParameterType');
  FParamSubParamID := TFieldWrap.Create(Self, 'ParamSubParamID');
  FTableName := TFieldWrap.Create(Self, 'TableName');
  FTranslation := TFieldWrap.Create(Self, 'Translation');
  FValue := TFieldWrap.Create(Self, 'Value', 'Наименование');
  FValueT := TFieldWrap.Create(Self, 'ValueT');
end;

end.
