unit ExtraChargeSimpleQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQueryExtraChargeSimple = class(TQueryBase)
  private
    function GetL: TField;
    function GetH: TField;
    function GetWholeSale: TField;
    { Private declarations }
  protected
  public
    function CheckBounds(AID: Integer; ARange: string; out ALow, AHight: Integer):
        string;
    function CheckBoundsByType(AIDExtraRangeType: Integer; ARange: string; out
        ALow, AHight: Integer): string;
    function CheckBoundsByPK(AID: Integer; ARange: string; out ALow, AHight:
        Integer): string;
    function SearchByID(AID: Integer; TestResult: Integer = -1): Integer;
    function SearchValueInRange(const AValue: Integer; AID: Integer): Integer;
    function SearchRangeInRange(ALow, AHight, AID: Integer): Integer;
    function SearchValueInRangeByType(const AValue: Integer; AIDExtraRangeType:
        Integer): Integer;
    property L: TField read GetL;
    property H: TField read GetH;
    property WholeSale: TField read GetWholeSale;
    { Public declarations }
  end;

implementation

uses
  StrHelper, ProjectConst;

{$R *.dfm}

function TQueryExtraChargeSimple.CheckBounds(AID: Integer; ARange: string; out
    ALow, AHight: Integer): string;
var
  m: TArray<String>;
  rc: Integer;
begin
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

  rc := SearchValueInRange(ALow, AID);
  if rc = 0 then
    rc := SearchValueInRange(AHight, AID);

  if rc > 0 then
  begin
    Result := Format('Диапазон %d-%d пересекается с диапазоном %d-%d',
      [ALow, AHight, L.AsInteger, H.AsInteger]);
    Exit;
  end;

  rc := SearchRangeInRange(ALow, AHight, AID);
  if rc > 0 then
  begin
    Result := Format('Диапазон %d-%d попадает в диапазон %d-%d',
      [L.AsInteger, H.AsInteger, ALow, AHight]);
    Exit;
  end;

  Result := '';
end;

function TQueryExtraChargeSimple.CheckBoundsByType(AIDExtraRangeType: Integer;
    ARange: string; out ALow, AHight: Integer): string;
var
  m: TArray<String>;
  rc: Integer;
begin
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

  rc := SearchValueInRangeByType(ALow, AIDExtraRangeType);
  if rc = 0 then
    rc := SearchValueInRangeByType(AHight, AIDExtraRangeType);

  if rc > 0 then
  begin
    Result := Format('Диапазон %d-%d пересекается с диапазоном %d-%d',
      [ALow, AHight, L.AsInteger, H.AsInteger]);
    Exit;
  end;

  rc := SearchRangeInRange(ALow, AHight, AIDExtraRangeType);
  if rc > 0 then
  begin
    Result := Format('Диапазон %d-%d попадает в диапазон %d-%d',
      [L.AsInteger, H.AsInteger, ALow, AHight]);
    Exit;
  end;

  Result := '';
end;

function TQueryExtraChargeSimple.CheckBoundsByPK(AID: Integer; ARange: string;
    out ALow, AHight: Integer): string;
var
  m: TArray<String>;
  rc: Integer;
begin
  Assert(AID > 0);
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

  rc := SearchValueInRange(ALow, AID);
  if rc = 0 then
    rc := SearchValueInRange(AHight, AID);

  if rc > 0 then
  begin
    Result := Format('Диапазон %d-%d пересекается с диапазоном %d-%d',
      [ALow, AHight, L.AsInteger, H.AsInteger]);
    Exit;
  end;

  rc := SearchRangeInRange(ALow, AHight, AID);
  if rc > 0 then
  begin
    Result := Format('Диапазон %d-%d попадает в диапазон %d-%d',
      [L.AsInteger, H.AsInteger, ALow, AHight]);
    Exit;
  end;

  Result := '';
end;

function TQueryExtraChargeSimple.GetL: TField;
begin
  Result := Field('L');
end;

function TQueryExtraChargeSimple.GetH: TField;
begin
  Result := Field('H');
end;

function TQueryExtraChargeSimple.GetWholeSale: TField;
begin
  Result := Field('WholeSale');
end;

function TQueryExtraChargeSimple.SearchByID(AID: Integer;
  TestResult: Integer = -1): Integer;
begin
  Assert(AID >= 0);

  // Меняем условие
  FDQuery.SQL.Text := Replace(FDQuery.SQL.Text, 'where ID=:ID', 'where');
  SetParamType('ID');

  // Ищем
  Result := Search(['ID'], [AID], TestResult);
end;

function TQueryExtraChargeSimple.SearchValueInRange(const AValue: Integer; AID:
    Integer): Integer;
begin
  // Меняем условие
  FDQuery.SQL.Text := Replace(FDQuery.SQL.Text,
    'where (:Value >= L) and (:Value <= H) and (id <> :id)', 'where ');
  SetParamType('Value');

  // Ищем
  Result := Search(['Value', 'id'], [AValue, AID]);
end;

function TQueryExtraChargeSimple.SearchRangeInRange(ALow, AHight, AID:
    Integer): Integer;
begin
  // Меняем условие
  FDQuery.SQL.Text := Replace(FDQuery.SQL.Text,
    'where (L >= :L) and (H <= :H) and (ID <> :ID)', 'where ');

  SetParamType('L');
  SetParamType('H');
  SetParamType('ID');

  // Ищем
  Result := Search(['L', 'H', 'ID'], [ALow, AHight, AID]);
end;

function TQueryExtraChargeSimple.SearchValueInRangeByType(const AValue:
    Integer; AIDExtraRangeType: Integer): Integer;
begin
  // Меняем условие
  FDQuery.SQL.Text := Replace(FDQuery.SQL.Text,
    'where (:Value >= L) and (:Value <= H) and (IDExtraChargeType = :IDExtraChargeType)', 'where ');
  SetParamType('Value');
  SetParamType('IDExtraChargeType');

  // Ищем
  Result := Search(['Value', 'IDExtraChargeType'], [AValue, AIDExtraRangeType]);
end;

end.
