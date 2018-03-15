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
    { Private declarations }
  public
    function SearchByExternalID(const AExternalID: String): Integer;
    function SearchBySubgroup(const ASubgroup: String): Integer;
    function SearchByID(const AID: Integer; TestResult: Integer = -1): Integer;
    function SearchSubCategories(const AParentID: Integer): Integer;
    property ExternalID: TField read GetExternalID;
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

uses StrHelper;

function TQuerySearchCategory.GetExternalID: TField;
begin
  Result := Field('ExternalID');
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

function TQuerySearchCategory.SearchByID(const AID: Integer; TestResult:
    Integer = -1): Integer;
begin
  Assert(AID > 0);

  FDQuery.SQL.Text := Replace(FDQuery.SQL.Text, 'where pc.ID = :ID', 'where');
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
