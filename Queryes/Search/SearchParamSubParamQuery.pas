unit SearchParamSubParamQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, DSWrap;

type
  TParamSubParamW = class(TDSWrap)
  private
    FID: TFieldWrap;
    FIDParameter: TFieldWrap;
    FIDSubParameter: TFieldWrap;
    FIsDefault: TFieldWrap;
    FName: TFieldWrap;
    FParameterType: TFieldWrap;
    FTableName: TFieldWrap;
    FTranslation: TFieldWrap;
    FValue: TFieldWrap;
    FValueT: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    property ID: TFieldWrap read FID;
    property IDParameter: TFieldWrap read FIDParameter;
    property IDSubParameter: TFieldWrap read FIDSubParameter;
    property IsDefault: TFieldWrap read FIsDefault;
    property Name: TFieldWrap read FName;
    property ParameterType: TFieldWrap read FParameterType;
    property TableName: TFieldWrap read FTableName;
    property Translation: TFieldWrap read FTranslation;
    property Value: TFieldWrap read FValue;
    property ValueT: TFieldWrap read FValueT;
  end;

  TQuerySearchParamSubParam = class(TQueryBase)
  private
    FW: TParamSubParamW;
    { Private declarations }
  protected
  public
    constructor Create(AOwner: TComponent); override;
    function SearchByID(const AParamSubParamID: Integer;
      TestResult: Integer = -1): Integer;
    property W: TParamSubParamW read FW;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TQuerySearchParamSubParam.Create(AOwner: TComponent);
begin
  inherited;
  FW := TParamSubParamW.Create(FDQuery);
end;

function TQuerySearchParamSubParam.SearchByID(const AParamSubParamID: Integer;
  TestResult: Integer = -1): Integer;
begin
  Assert(AParamSubParamID > 0);

  Result := SearchEx([TParamRec.Create(W.ID.FullName, AParamSubParamID)],
    TestResult);
end;

constructor TParamSubParamW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'psp.ID', '', True);
  FIDParameter := TFieldWrap.Create(Self, 'IDParameter');
  FIDSubParameter := TFieldWrap.Create(Self, 'IDSubParameter');
  FIsDefault := TFieldWrap.Create(Self, 'IsDefault');
  FName := TFieldWrap.Create(Self, 'Name');
  FParameterType := TFieldWrap.Create(Self, 'ParameterType');
  FTableName := TFieldWrap.Create(Self, 'TableName');
  FTranslation := TFieldWrap.Create(Self, 'Translation');
  FValue := TFieldWrap.Create(Self, 'Value', 'Наименование');
  FValueT := TFieldWrap.Create(Self, 'ValueT');
end;

end.
