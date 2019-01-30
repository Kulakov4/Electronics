unit ComponentsSearchGroupUnit2;

interface

uses
  BaseComponentsGroupUnit2, NotifyEvents, System.Classes,
  ComponentsSearchQuery, FamilySearchQuery, SearchComponentOrFamilyQuery;

type
  TComponentsSearchGroup2 = class(TBaseComponentsGroup2)
  private
    FOnOpenCategory: TNotifyEventsEx;
    FqComponentsSearch: TQueryComponentsSearch;
    FqFamilySearch: TQueryFamilySearch;
    FqSearchComponentOrFamily: TQuerySearchComponentOrFamily;
    function GetqComponentsSearch: TQueryComponentsSearch;
    function GetqFamilySearch: TQueryFamilySearch;
    function GetqSearchComponentOrFamily: TQuerySearchComponentOrFamily;
    property qSearchComponentOrFamily: TQuerySearchComponentOrFamily read
        GetqSearchComponentOrFamily;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ApplyUpdates: Boolean; override;
    procedure ClearSearchResult;
    procedure OpenCategory;
    procedure Search(ALike: Boolean);
    property qComponentsSearch: TQueryComponentsSearch read GetqComponentsSearch;
    property qFamilySearch: TQueryFamilySearch read GetqFamilySearch;
    property OnOpenCategory: TNotifyEventsEx read FOnOpenCategory;
  end;

implementation

uses
  SearchInterfaceUnit, System.SysUtils;

constructor TComponentsSearchGroup2.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  // ������� ����� ��������� ����������, ����� ��� �������� ��������� ����� ������� � ���� ���������
  // ���������� � ��������� �� ������� ��� �������-���������� ������� ��� ��� �������� ���������
  QList.Add(qComponentsSearch);
  QList.Add(qFamilySearch);

  FOnOpenCategory := TNotifyEventsEx.Create(Self);
end;

destructor TComponentsSearchGroup2.Destroy;
begin
  FreeAndNil(FOnOpenCategory);
  inherited;
end;

function TComponentsSearchGroup2.ApplyUpdates: Boolean;
begin
  // ���� ��������� � ������ ����������� ��������� �������
  if qFamilySearch.FamilySearchW.Mode = RecordsMode then
  begin
    Result := Inherited;
  end
  else
    Result := True;
end;

procedure TComponentsSearchGroup2.ClearSearchResult;
begin
  qComponentsSearch.ClearSearchResult;
  qFamilySearch.ClearSearchResult;
end;

function TComponentsSearchGroup2.GetqComponentsSearch: TQueryComponentsSearch;
begin
  if FqComponentsSearch = nil then
    FqComponentsSearch := TQueryComponentsSearch.Create(Self);

  Result := FqComponentsSearch;
end;

function TComponentsSearchGroup2.GetqFamilySearch: TQueryFamilySearch;
begin
  if FqFamilySearch = nil then
    FqFamilySearch := TQueryFamilySearch.Create(Self);
  Result := FqFamilySearch;
end;

function TComponentsSearchGroup2.GetqSearchComponentOrFamily:
    TQuerySearchComponentOrFamily;
begin
  if FqSearchComponentOrFamily = nil then
    FqSearchComponentOrFamily := TQuerySearchComponentOrFamily.Create(Self);

  Result := FqSearchComponentOrFamily;
end;

procedure TComponentsSearchGroup2.OpenCategory;
begin
  FOnOpenCategory.CallEventHandlers(Self);
end;

procedure TComponentsSearchGroup2.Search(ALike: Boolean);
var
  s: string;
  sDetail: string;
  sParent: string;
  sParent2: string;
begin
  qFamilySearch.TryPost;
  // �������� ������ �������� �� ������� ����� ������������ �����
  s := qFamilySearch.GetFieldValues(qFamilySearch.W.Value.F.FieldName)
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
