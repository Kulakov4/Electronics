unit SearchParameterQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, DSWrap;

type
  TSearchParameterW = class(TDSWrap)
  private
    FCodeLetters: TFieldWrap;
    FID: TFieldWrap;
    FDefinition: TFieldWrap;
    FIDParameterKind: TFieldWrap;
    FIDParameterType: TFieldWrap;
    FIsCustomParameter: TFieldWrap;
    FMeasuringUnit: TFieldWrap;
    FOrder: TFieldWrap;
    FParamSubParamID: TFieldWrap;
    FTableName: TFieldWrap;
    FValue: TFieldWrap;
    FValueT: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    property CodeLetters: TFieldWrap read FCodeLetters;
    property ID: TFieldWrap read FID;
    property Definition: TFieldWrap read FDefinition;
    property IDParameterKind: TFieldWrap read FIDParameterKind;
    property IDParameterType: TFieldWrap read FIDParameterType;
    property IsCustomParameter: TFieldWrap read FIsCustomParameter;
    property MeasuringUnit: TFieldWrap read FMeasuringUnit;
    property Order: TFieldWrap read FOrder;
    property ParamSubParamID: TFieldWrap read FParamSubParamID;
    property TableName: TFieldWrap read FTableName;
    property Value: TFieldWrap read FValue;
    property ValueT: TFieldWrap read FValueT;
  end;

  TQuerySearchParameter = class(TQueryBase)
    FDUpdateSQL: TFDUpdateSQL;
  private
    FW: TSearchParameterW;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    function SearchByTableName(const ATableName: String;
      AIsCustomParameter: Boolean): Integer; overload;
    function SearchByTableName(const ATableName: String): Integer; overload;
    function SearchByID(AID: Integer; ATestResult: Boolean = False)
      : Integer; overload;
    procedure SearchOrAppend(const ATableName: String;
      AIsCustomParameter: Boolean);
    property W: TSearchParameterW read FW;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses ProjectConst, StrHelper, System.Math;

constructor TQuerySearchParameter.Create(AOwner: TComponent);
begin
  inherited;
  FW := TSearchParameterW.Create(FDQuery);
  FDQuery.UpdateOptions.CheckRequired := False;
end;

function TQuerySearchParameter.SearchByTableName(const ATableName: String;
  AIsCustomParameter: Boolean): Integer;
begin
  Assert(not ATableName.IsEmpty);

  // »щем без учЄта регистра
  Result := SearchEx([TParamRec.Create(W.TableName.FullName, ATableName,
    ftWideString, True), TParamRec.Create(W.IsCustomParameter.FullName,
    IfThen(AIsCustomParameter, 1, 0))]);
end;

function TQuerySearchParameter.SearchByTableName(const ATableName
  : String): Integer;
begin
  Assert(not ATableName.IsEmpty);

  // »щем без учЄта регистра
  Result := SearchEx([TParamRec.Create(W.TableName.FullName, ATableName,
    ftWideString, True)]);
end;

function TQuerySearchParameter.SearchByID(AID: Integer;
  ATestResult: Boolean = False): Integer;
begin
  Assert(AID > 0);

  // »щем
  Result := SearchEx([TParamRec.Create(W.ID.FullName, AID)], IfThen(ATestResult, 1, -1));
end;

procedure TQuerySearchParameter.SearchOrAppend(const ATableName: String;
  AIsCustomParameter: Boolean);
var
  k: Integer;
begin
  k := SearchByTableName(ATableName, AIsCustomParameter);
  if k = 0 then
  begin
    W.TryAppend;
    W.TableName.F.AsString := ATableName;
    W.IsCustomParameter.F.AsBoolean := AIsCustomParameter;
    W.TryPost;
    Assert(W.PK.AsInteger > 0);
  end;
end;

constructor TSearchParameterW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'p.ID', '', True);
  FCodeLetters := TFieldWrap.Create(Self, 'CodeLetters');
  FDefinition := TFieldWrap.Create(Self, 'Definition');
  FIDParameterKind := TFieldWrap.Create(Self, 'IDParameterKind');
  FIDParameterType := TFieldWrap.Create(Self, 'IDParameterType');
  FIsCustomParameter := TFieldWrap.Create(Self, 'IsCustomParameter');
  FMeasuringUnit := TFieldWrap.Create(Self, 'MeasuringUnit');
  FOrder := TFieldWrap.Create(Self, 'Order');
  FParamSubParamID := TFieldWrap.Create(Self, 'ParamSubParamID');
  FTableName := TFieldWrap.Create(Self, 'TableName');
  FValue := TFieldWrap.Create(Self, 'Value');
  FValueT := TFieldWrap.Create(Self, 'ValueT');
end;

end.
