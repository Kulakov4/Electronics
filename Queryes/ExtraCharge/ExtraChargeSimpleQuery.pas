unit ExtraChargeSimpleQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, DSWrap;

type
  TExtraChargeSimpleW = class(TDSWrap)
  private
    FH: TFieldWrap;
    FID: TFieldWrap;
    FIDExtraChargeType: TFieldWrap;
    FL: TFieldWrap;
    FWholeSale: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    property H: TFieldWrap read FH;
    property ID: TFieldWrap read FID;
    property IDExtraChargeType: TFieldWrap read FIDExtraChargeType;
    property L: TFieldWrap read FL;
    property WholeSale: TFieldWrap read FWholeSale;
  end;

  TQueryExtraChargeSimple = class(TQueryBase)
  private
    FW: TExtraChargeSimpleW;
    { Private declarations }
  protected
  public
    constructor Create(AOwner: TComponent); override;
    function CheckBounds(AID, AIDExtraRangeType: Integer; ARange: string;
      out ALow, AHight: Integer): string;
    function SearchByID(AID: Integer; TestResult: Integer = -1): Integer;
    function SearchValueInRange(const AValue: Integer;
      AIDExtraRangeType, AID: Integer): Integer;
    property W: TExtraChargeSimpleW read FW;
    { Public declarations }
  end;

implementation

uses
  StrHelper, ProjectConst;

{$R *.dfm}

constructor TQueryExtraChargeSimple.Create(AOwner: TComponent);
begin
  inherited;
  FW := TExtraChargeSimpleW.Create(FDQuery);
end;

function TQueryExtraChargeSimple.CheckBounds(AID, AIDExtraRangeType: Integer;
  ARange: string; out ALow, AHight: Integer): string;
var
  m: TArray<String>;
  rc: Integer;
begin
  Assert(AIDExtraRangeType > 0);
  Assert(not ARange.IsEmpty);

  Result := sExtraChargeRangeError;
  m := ARange.Split(['-']);

  if Length(m) <> 2 then
    Exit;

  ALow := StrToIntDef(m[0], 0);
  AHight := StrToIntDef(m[1], 0);
  if (ALow = 0) or (AHight = 0) then
    Exit;

  if AHight <= ALow then
  begin
    Result := sExtraChargeRangeError2;
    Exit;
  end;

  rc := SearchValueInRange(ALow, AIDExtraRangeType, AID);
  if rc = 0 then
    rc := SearchValueInRange(AHight, AIDExtraRangeType, AID);

  if rc > 0 then
  begin
    Result := Format('Диапазон %d-%d пересекается с диапазоном %d-%d',
      [ALow, AHight, W.L.F.AsInteger, W.H.F.AsInteger]);
    Exit;
  end;

  Result := '';
end;

function TQueryExtraChargeSimple.SearchByID(AID: Integer;
  TestResult: Integer = -1): Integer;
begin
  Assert(AID >= 0);

  // Ищем
  Result := SearchEx([TParamRec.Create(W.ID.FullName, AID)], TestResult);
end;

function TQueryExtraChargeSimple.SearchValueInRange(const AValue: Integer;
  AIDExtraRangeType, AID: Integer): Integer;
var
  AStipulation: string;
  S1: string;
  S2: string;
  S3: string;
  S4: string;
  AValueParamName: string;
begin
  Assert(AID >= 0);
  Assert(AIDExtraRangeType >= 0);

  AValueParamName := 'Value';

  S1 := Format(':%s >= %s', [AValueParamName, W.L.FieldName]);
  S2 := Format(':%s <= %s', [AValueParamName, W.H.FieldName]);
  S3 := Format('%s = :%s', [W.IDExtraChargeType.FieldName,
    W.IDExtraChargeType.FieldName]);
  S4 := Format('%s <> :%s', [W.PK.FieldName, W.PK.FieldName]);

  AStipulation := Format('(%s) and (%s) and (%s) and (%s)', [S1, S2, S3, S4]);

  // Меняем SQL запрос
  FDQuery.SQL.Text := ReplaceInSQL(SQL, AStipulation, 0);

  SetParamType(AValueParamName);
  SetParamType(W.IDExtraChargeType.FieldName);
  SetParamType(W.PK.FieldName);

  // Ищем
  Result := Search([AValueParamName, W.IDExtraChargeType.FieldName,
    W.PK.FieldName], [AValue, AIDExtraRangeType, AID]);
end;

constructor TExtraChargeSimpleW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'ID', '', True);
  FH := TFieldWrap.Create(Self, 'H');
  FL := TFieldWrap.Create(Self, 'L');
  FIDExtraChargeType := TFieldWrap.Create(Self, 'IDExtraChargeType');
  FWholeSale := TFieldWrap.Create(Self, 'WholeSale');
end;

end.
