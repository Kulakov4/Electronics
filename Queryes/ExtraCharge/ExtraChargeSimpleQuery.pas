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
    function GetIDExtraChargeType: TField;
    function GetWholeSale: TField;
    { Private declarations }
  protected
  public
    function CheckBounds(AID, AIDExtraRangeType: Integer; ARange: string; out ALow,
        AHight: Integer): string;
    function SearchByID(AID: Integer; TestResult: Integer = -1): Integer;
    function SearchValueInRange(const AValue: Integer; AIDExtraRangeType, AID:
        Integer): Integer;
    property L: TField read GetL;
    property H: TField read GetH;
    property IDExtraChargeType: TField read GetIDExtraChargeType;
    property WholeSale: TField read GetWholeSale;
    { Public declarations }
  end;

implementation

uses
  StrHelper, ProjectConst;

{$R *.dfm}

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
      [ALow, AHight, L.AsInteger, H.AsInteger]);
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

function TQueryExtraChargeSimple.GetIDExtraChargeType: TField;
begin
  Result := Field('IDExtraChargeType');
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

function TQueryExtraChargeSimple.SearchValueInRange(const AValue: Integer;
    AIDExtraRangeType, AID: Integer): Integer;
begin
  // Меняем условие
  FDQuery.SQL.Text := Replace(FDQuery.SQL.Text,
    'where (:Value >= L) and (:Value <= H) and ' +
    '(IDExtraChargeType = :IDExtraChargeType) and (ID <> :ID)', 'where ');
  SetParamType('Value');
  SetParamType('IDExtraChargeType');
  SetParamType('ID');

  // Ищем
  Result := Search(['Value', 'IDExtraChargeType', 'ID'],
    [AValue, AIDExtraRangeType, AID]);
end;

end.
