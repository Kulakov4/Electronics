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
    qFamilySearch: TQueryFamilySearch;
    qComponentsSearch: TQueryComponentsSearch;
  private
    FqSearchComponentOrFamily: TQuerySearchComponentOrFamily;
    function GetqSearchComponentOrFamily: TQuerySearchComponentOrFamily;
    property qSearchComponentOrFamily: TQuerySearchComponentOrFamily read
        GetqSearchComponentOrFamily;
    { Private declarations }
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure ApplyUpdates; override;
    procedure ClearSearchResult;
    procedure Search(ALike: Boolean);
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses SearchInterfaceUnit, RepositoryDataModule;

constructor TComponentsSearchGroup.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Main := qFamilySearch;
  Detail := qComponentsSearch;
end;

procedure TComponentsSearchGroup.ApplyUpdates;
begin
  // Если находимся в режиме отображения найденных записей
  if qFamilySearch.Mode = RecordsMode then
  begin
    Inherited;
  end;
end;

procedure TComponentsSearchGroup.ClearSearchResult;
begin
  qComponentsSearch.ClearSearchResult;
  qFamilySearch.ClearSearchResult;
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
  // Получаем список значений по которым будем осуществлять поиск
  s := qFamilySearch.GetFieldValues(qFamilySearch.Value.FieldName)
    .Trim([',']).ToUpper;

  if S.IsEmpty then
    Exit;


  { необходимо получить все идентификаторы которые есть по значениям. Далее, определить что это, обычная или родительская запись
    и запомнить эти идентификаторы }

  if ALike then
    qSearchComponentOrFamily.SearchByValueLike(s)
  else
    qSearchComponentOrFamily.SearchByValues(s);

  // Фильтруем - оставляем только главные компоненты
  qSearchComponentOrFamily.FDQuery.Filter := 'ParentProductId = NULL';
  qSearchComponentOrFamily.FDQuery.Filtered := True;

  s := qSearchComponentOrFamily.GetFieldValues('ID').Trim([',']);
  sParent := s;

  // Фильтруем - оставляем только дочерние компоненты
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
