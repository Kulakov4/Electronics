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
    function GetqComponentsSearch: TQueryComponentsSearch;
    function GetqFamilySearch: TQueryFamilySearch;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ApplyUpdates: Boolean; override;
    procedure ClearSearchResult;
    procedure OpenCategory;
    procedure Search(ALike: Boolean);
    property qComponentsSearch: TQueryComponentsSearch
      read GetqComponentsSearch;
    property qFamilySearch: TQueryFamilySearch read GetqFamilySearch;
    property OnOpenCategory: TNotifyEventsEx read FOnOpenCategory;
  end;

implementation

uses
  SearchInterfaceUnit, System.SysUtils;

constructor TComponentsSearchGroup2.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  // Сначала будем открывать компоненты, чтобы при открытии семейства знать сколько у него компонент
  // Компоненты и семейства не связаны как главный-подчинённый главным для них является категория
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
  // Если находимся в режиме отображения найденных записей
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

procedure TComponentsSearchGroup2.OpenCategory;
begin
  FOnOpenCategory.CallEventHandlers(Self);
end;

procedure TComponentsSearchGroup2.Search(ALike: Boolean);
var
  AValues: TArray<String>;
begin
  qFamilySearch.W.TryPost;

  // Получаем список значений по которым будем осуществлять поиск
  AValues := qFamilySearch.W.Value.AllValues(',').ToUpper.Split([',']);

  if Length(AValues) = 0 then
    Exit;

  qComponentsSearch.SearchByValue(AValues, ALike);
  qFamilySearch.SearchByValue(AValues, ALike);
end;

end.
