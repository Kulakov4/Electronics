unit SearchCategoryQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQuerySearchCategory = class(TQueryBase)
  private
    function GetExternalID: TField;
    function GetParentID: TField;
    { Private declarations }
  public
    function CalculateExternalId(ParentId, ALevel: Integer): string;
    function SearchByExternalID(const AExternalID: String): Integer;
    function SearchBySubgroup(const ASubgroup: String): Integer;
    function SearchByID(const AID: Integer; TestResult: Integer = -1): Integer;
    function SearchDuplicate(const AID: Integer;
      TestResult: Integer = -1): Integer;
    function SearchSubCategories(const AParentID: Integer): Integer;
    function SearchByParentAndValue(const AParentID: Integer;
      const AValue: String): Integer;
    function SearchByLevel(ALevel: Integer): Integer;
    property ExternalID: TField read GetExternalID;
    property ParentId: TField read GetParentID;
    { Public declarations }
  end;

type
  TSearchSubCategories = class(TObject)
  private
  public
    class function Search(const AParentID: Integer): Integer; static;
  end;

implementation

{$R *.dfm}

uses StrHelper, System.Generics.Collections;

function TQuerySearchCategory.CalculateExternalId(ParentId,
  ALevel: Integer): string;
var
  AID: Integer;
  AInteger: Integer;
  AIntegers: TList<Integer>;
begin
  SearchByLevel(ALevel);

  // Список целых чисел
  AIntegers := TList<Integer>.Create;
  try
    FDQuery.First;
    while not FDQuery.Eof do
    begin
      // Получаем номер без уровня
      AIntegers.Add(ExternalID.AsString.Substring(2).ToInteger);
      FDQuery.Next;
    end;

    AIntegers.Sort;
    AID := 1;
    for AInteger in AIntegers do
    begin
      if AInteger <> AID then
        Break;
      Inc(AID);
    end;
  finally
    FreeAndNil(AIntegers);
  end;

  Result := Format('%.2d%.3d', [ALevel, AID]);
end;

function TQuerySearchCategory.GetExternalID: TField;
begin
  Result := Field('ExternalID');
end;

function TQuerySearchCategory.GetParentID: TField;
begin
  Result := Field('ParentID');
end;

function TQuerySearchCategory.SearchByExternalID(const AExternalID
  : String): Integer;
var
  ACondition: string;
begin
  Assert(not AExternalID.IsEmpty);
  ACondition := 'where pc.ExternalId = :ExternalId';
  FDQuery.SQL.Text := Replace(FDQuery.SQL.Text, ACondition, 'where');
  SetParamType('ExternalId', ptInput, ftWideString);

  Result := Search(['ExternalId'], [AExternalID]);
end;

function TQuerySearchCategory.SearchBySubgroup(const ASubgroup: String)
  : Integer;
var
  ACondition: string;
begin
  Assert(not ASubgroup.IsEmpty);

  ACondition :=
    'where instr('',''||:SubGroup||'','', '',''||ExternalID||'','') > 0';
  FDQuery.SQL.Text := Replace(FDQuery.SQL.Text, ACondition, 'where');
  SetParamType('SubGroup', ptInput, ftWideString);

  Result := Search(['SubGroup'], [ASubgroup]);
end;

function TQuerySearchCategory.SearchByID(const AID: Integer;
  TestResult: Integer = -1): Integer;
begin
  Assert(AID > 0);

  FDQuery.SQL.Text := Replace(FDQuery.SQL.Text, 'where pc.ID = :ID', 'where');
  SetParamType('ID');

  Result := Search(['ID'], [AID], TestResult);
end;

function TQuerySearchCategory.SearchDuplicate(const AID: Integer;
  TestResult: Integer = -1): Integer;
begin
  Assert(AID > 0);

  FDQuery.SQL.Text := Replace(FDQuery.SQL.Text,
    'where value = (select value from ProductCategories where ID = :ID)',
    'where');
  SetParamType('ID');

  Result := Search(['ID'], [AID], TestResult);
end;

function TQuerySearchCategory.SearchSubCategories(const AParentID
  : Integer): Integer;
begin
  Assert(AParentID > 0);

  FDQuery.SQL.Text := Replace(FDQuery.SQL.Text,
    'where ParentID = :ParentID', 'where');
  SetParamType('ParentID');

  Result := Search(['ParentID'], [AParentID]);
end;

function TQuerySearchCategory.SearchByParentAndValue(const AParentID: Integer;
  const AValue: String): Integer;
begin
  Assert(AParentID > 0);
  Assert(not AValue.IsEmpty);

  FDQuery.SQL.Text := Replace(FDQuery.SQL.Text,
    'where ParentID = :ParentID and Upper(Value) = Upper(:Value)', 'where');
  SetParamType('ParentID');
  SetParamType('Value', ptInput, ftWideString);

  Result := Search(['ParentID', 'Value'], [AParentID, AValue]);
end;

function TQuerySearchCategory.SearchByLevel(ALevel: Integer): Integer;
var
  ALevelStr: string;
begin
  Assert(ALevel > 0);
  ALevelStr := Format('%.2d%%', [ALevel]);

  FDQuery.SQL.Text := Replace(FDQuery.SQL.Text,
    'where ExternalID like :ExternalID', 'where');
  SetParamType('ExternalID', ptInput, ftWideString);

  Result := Search(['ExternalID'], [ALevelStr]);
end;

class function TSearchSubCategories.Search(const AParentID: Integer): Integer;
var
  qSearchSubCategory: TQuerySearchCategory;
begin
  qSearchSubCategory := TQuerySearchCategory.Create(nil);
  try
    Result := qSearchSubCategory.SearchSubCategories(AParentID);
  finally
    FreeAndNil(qSearchSubCategory)
  end;
end;

end.
