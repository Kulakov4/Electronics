unit SearchCategoryQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, DSWrap;

type
  TSearchCategoryW = class(TDSWrap)
  private
    FExternalID: TFieldWrap;
    FID: TFieldWrap;
    FParentId: TFieldWrap;
    FValue: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    property ExternalID: TFieldWrap read FExternalID;
    property ID: TFieldWrap read FID;
    property ParentId: TFieldWrap read FParentId;
    property Value: TFieldWrap read FValue;
  end;

  TQuerySearchCategory = class(TQueryBase)
  private
    FW: TSearchCategoryW;
    function SearchByLevel(ALevel: Integer): Integer;
    function SearchSubCategories(const AParentID: Integer): Integer;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    function CalculateExternalId(ParentId, ALevel: Integer): string;
    function SearchByExternalID(const AExternalID: String): Integer;
    function SearchBySubgroup(const ASubgroup: String): Integer;
    function SearchByID(const AID: Integer; TestResult: Integer = -1): Integer;
    function SearchByParentAndValue(const AParentID: Integer; const AValue:
        String): Integer;
    function SearchDuplicate(const AID: Integer; TestResult: Integer = -1): Integer;
    property W: TSearchCategoryW read FW;
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

constructor TQuerySearchCategory.Create(AOwner: TComponent);
begin
  inherited;
  FW := TSearchCategoryW.Create(FDQuery);
end;

function TQuerySearchCategory.SearchByParentAndValue(const AParentID: Integer;
    const AValue: String): Integer;
begin
  Assert(AParentID > 0);
  Assert(not AValue.IsEmpty);

  Result := SearchEx([TParamRec.Create(W.ParentId.FullName, AParentID),
    TParamRec.Create(W.Value.FullName, AValue, ftWideString, True)]);
end;

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
      AIntegers.Add(W.ExternalID.F.AsString.Substring(2).ToInteger);
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

function TQuerySearchCategory.SearchByExternalID(const AExternalID
  : String): Integer;
begin
  Assert(not AExternalID.IsEmpty);

  Result := SearchEx([TParamRec.Create(W.ExternalID.FullName, AExternalID,
    ftWideString)]);
end;

function TQuerySearchCategory.SearchBySubgroup(const ASubgroup: String)
  : Integer;
var
  AStipulation: string;
  AParamName: string;
begin
  Assert(not ASubgroup.IsEmpty);

  AParamName := 'SubGroup';

  AStipulation := Format('instr('',''||:%s||'','', '',''||%s||'','') > 0',
    [AParamName, W.ExternalID.FullName]);

  // Меняем SQL запрос
  FDQuery.SQL.Text := ReplaceInSQL(SQL, AStipulation, 0);

  SetParamType(AParamName, ptInput, ftWideString);
  Result := Search([AParamName], [ASubgroup]);
end;

function TQuerySearchCategory.SearchByID(const AID: Integer;
  TestResult: Integer = -1): Integer;
begin
  Assert(AID > 0);

  Result := SearchEx([TParamRec.Create(W.ID.FullName, AID)], TestResult);
end;

function TQuerySearchCategory.SearchSubCategories(const AParentID
  : Integer): Integer;
begin
  Assert(AParentID > 0);

  Result := SearchEx([TParamRec.Create(W.ParentId.FullName, AParentID)]);
end;

function TQuerySearchCategory.SearchByLevel(ALevel: Integer): Integer;
var
  ALevelStr: string;
begin
  Assert(ALevel > 0);
  ALevelStr := Format('%.2d%%', [ALevel]);

  Result := SearchEx([TParamRec.Create(W.ExternalID.FullName, ALevelStr,
    ftWideString, False, 'like')]);
end;

function TQuerySearchCategory.SearchDuplicate(const AID: Integer; TestResult:
    Integer = -1): Integer;
var
  AStipulation: string;
begin
  Assert(AID > 0);

  AStipulation := Format('%s = (select %s from ProductCategories where %s = :%s)',
    [W.Value.FullName, W.Value.FieldName, W.ID.FieldName, W.ID.FieldName]);

  // Меняем SQL запрос
  FDQuery.SQL.Text := ReplaceInSQL(SQL, AStipulation, 0);

  SetParamType(W.ID.FieldName);
  Result := Search([W.ID.FieldName], [AID], TestResult);
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

constructor TSearchCategoryW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'pc.ID', '', True);
  FExternalID := TFieldWrap.Create(Self, 'pc.ExternalID');
  FParentId := TFieldWrap.Create(Self, 'pc.ParentId');
  FValue := TFieldWrap.Create(Self, 'pc.Value');
end;

end.
