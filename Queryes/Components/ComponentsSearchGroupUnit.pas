unit ComponentsSearchGroupUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Comp.Client, Vcl.ExtCtrls, CustomComponentsQuery,
  QueryWithDataSourceUnit, BaseQuery, BaseEventsQuery, QueryWithMasterUnit,
  BaseFamilyQuery, BaseComponentsQuery, FamilySearchQuery,
  ComponentsSearchQuery, BaseComponentsGroupUnit, SearchComponentOrFamilyQuery;

type
  TComponentsSearchGroup = class(TBaseComponentsGroup)
  private
    FqComponentsSearch: TQueryComponentsSearch;
    FqFamilySearch: TQueryFamilySearch;
    FqSearchComponentOrFamily: TQuerySearchComponentOrFamily;
    function GetqComponentsSearch: TQueryComponentsSearch;
    function GetqFamilySearch: TQueryFamilySearch;
    function GetqSearchComponentOrFamily: TQuerySearchComponentOrFamily;
    property qSearchComponentOrFamily: TQuerySearchComponentOrFamily read
        GetqSearchComponentOrFamily;
    { Private declarations }
  protected
  public
    constructor Create(AOwner: TComponent); override;
    function ApplyUpdates: Boolean; override;
    procedure ClearSearchResult;
    procedure Search(ALike: Boolean);
    property qComponentsSearch: TQueryComponentsSearch read GetqComponentsSearch;
    property qFamilySearch: TQueryFamilySearch read GetqFamilySearch;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses SearchInterfaceUnit, RepositoryDataModule;

constructor TComponentsSearchGroup.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  // ������� ����� ��������� ����������, ����� ��� �������� ��������� ����� ������� � ���� ���������
  // ���������� � ��������� �� ������� ��� �������-���������� ������� ��� ��� �������� ���������
  QList.Add(qComponentsSearch);
  QList.Add(qFamilySearch);
end;

function TComponentsSearchGroup.ApplyUpdates: Boolean;
begin
  // ���� ��������� � ������ ����������� ��������� �������
  if qFamilySearch.Mode = RecordsMode then
  begin
    Result := Inherited;
  end
  else
    Result := True;
end;

procedure TComponentsSearchGroup.ClearSearchResult;
begin
  qComponentsSearch.ClearSearchResult;
  qFamilySearch.ClearSearchResult;
end;

function TComponentsSearchGroup.GetqComponentsSearch: TQueryComponentsSearch;
begin
  if FqComponentsSearch = nil then
    FqComponentsSearch := TQueryComponentsSearch.Create(Self);

  Result := FqComponentsSearch;
end;

function TComponentsSearchGroup.GetqFamilySearch: TQueryFamilySearch;
begin
  if FqFamilySearch = nil then
    FqFamilySearch := TQueryFamilySearch.Create(Self);
  Result := FqFamilySearch;
end;

function TComponentsSearchGroup.GetqSearchComponentOrFamily:
    TQuerySearchComponentOrFamily;
begin
  if FqSearchComponentOrFamily = nil then
    FqSearchComponentOrFamily := TQuerySearchComponentOrFamily.Create(Self);

  Result := FqSearchComponentOrFamily;
end;

procedure TComponentsSearchGroup.Search(ALike: Boolean);
var
  s: string;
  sDetail: string;
  sParent: string;
  sParent2: string;
begin
  qFamilySearch.TryPost;
  // �������� ������ �������� �� ������� ����� ������������ �����
  s := qFamilySearch.GetFieldValues(qFamilySearch.Value.FieldName)
    .Trim([',']).ToUpper;

  if S.IsEmpty then
    Exit;


  { ���������� �������� ��� �������������� ������� ���� �� ���������. �����, ���������� ��� ���, ������� ��� ������������ ������
    � ��������� ��� �������������� }

  if ALike then
    qSearchComponentOrFamily.SearchByValueLike(s)
  else
    qSearchComponentOrFamily.SearchByValues(s);

  // ��������� - ��������� ������ ������� ����������
  qSearchComponentOrFamily.FDQuery.Filter := 'ParentProductId = NULL';
  qSearchComponentOrFamily.FDQuery.Filtered := True;

  s := qSearchComponentOrFamily.GetFieldValues('ID').Trim([',']);
  sParent := s;

  // ��������� - ��������� ������ �������� ����������
  qSearchComponentOrFamily.FDQuery.Filter := 'ParentProductId <> NULL';
  qSearchComponentOrFamily.FDQuery.Filtered := True;

  sParent2 := qSearchComponentOrFamily.GetFieldValues('ParentProductId').Trim([',']);
  sDetail := qSearchComponentOrFamily.GetFieldValues('Id').Trim([',']);

  if not sParent2.IsEmpty then
    sParent := Format('%s,%s', [sParent, sParent2]);

  qComponentsSearch.Search(s, sDetail);
  qFamilySearch.Search(sParent);
end;

end.
