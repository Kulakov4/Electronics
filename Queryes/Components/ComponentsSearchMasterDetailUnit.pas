unit ComponentsSearchMasterDetailUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Comp.Client, Vcl.ExtCtrls,
  ComponentsSearchQuery, ComponentsDetailsSearchQuery, MasterDetailFrame,
  ComponentsBaseMasterDetailUnit, ComponentsBaseDetailQuery,
  CustomComponentsQuery, SearchComponentsByValues, MainComponentsQuery,
  QueryWithDataSourceUnit, BaseQuery, BaseEventsQuery, QueryWithMasterUnit,
  SearchComponentsByValuesLike;

type
  TComponentsSearchMasterDetail = class(TComponentsBaseMasterDetail)
    qComponentsSearch: TQueryComponentsSearch;
    qComponentsDetailsSearch: TQueryComponentsDetailsSearch;
  private
    FQuerySearchComponentsByValues: TQuerySearchComponentsByValues;
    FQuerySearchComponentsByValuesLike: TQuerySearchComponentsByValuesLike;
    function GetQuerySearchComponentsByValues: TQuerySearchComponentsByValues;
    function GetQuerySearchComponentsByValuesLike
      : TQuerySearchComponentsByValuesLike;
    { Private declarations }
  protected
    property QuerySearchComponentsByValues: TQuerySearchComponentsByValues
      read GetQuerySearchComponentsByValues;
    property QuerySearchComponentsByValuesLike
      : TQuerySearchComponentsByValuesLike
      read GetQuerySearchComponentsByValuesLike;
  public
    constructor Create(AOwner: TComponent); override;
    procedure ApplyUpdates; override;
    procedure ClearSearchResult;
    procedure Search(ALike: Boolean);
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses SearchInterfaceUnit, RepositoryDataModule, SearchComponentsByValuesBase;

constructor TComponentsSearchMasterDetail.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Main := qComponentsSearch;
  Detail := qComponentsDetailsSearch;
end;

procedure TComponentsSearchMasterDetail.ApplyUpdates;
begin
  // Если находимся в режиме отображения найденных записей
  if qComponentsSearch.Mode = RecordsMode then
  begin
    Inherited;
  end;
end;

procedure TComponentsSearchMasterDetail.ClearSearchResult;
begin
  qComponentsDetailsSearch.ClearSearchResult;
  qComponentsSearch.ClearSearchResult;
end;

function TComponentsSearchMasterDetail.GetQuerySearchComponentsByValues
  : TQuerySearchComponentsByValues;
begin
  if FQuerySearchComponentsByValues = nil then
    FQuerySearchComponentsByValues :=
      TQuerySearchComponentsByValues.Create(Self);

  Result := FQuerySearchComponentsByValues;
end;

function TComponentsSearchMasterDetail.GetQuerySearchComponentsByValuesLike
  : TQuerySearchComponentsByValuesLike;
begin
  if FQuerySearchComponentsByValuesLike = nil then
    FQuerySearchComponentsByValuesLike :=
      TQuerySearchComponentsByValuesLike.Create(Self);

  Result := FQuerySearchComponentsByValuesLike;
end;

procedure TComponentsSearchMasterDetail.Search(ALike: Boolean);
var
  ASearchQuery: TQuerySearchComponentsByValuesBase;
  s: string;
  sDetail: string;
  sParent: string;
  sParent2: string;
begin
  // Получаем список значений по которым будем осуществлять поиск
  s := qComponentsSearch.GetFieldValues(qComponentsSearch.Value.FieldName)
    .Trim([',']).ToUpper;

  { необходимо получить все идентификаторы которые есть по значениям. Далее, определить что это, обычная или родительская запись
    и запомнить эти идентификаторы }

  if ALike then
    ASearchQuery := QuerySearchComponentsByValuesLike
  else
    ASearchQuery := QuerySearchComponentsByValues;

  ASearchQuery.Search(s);

  // Фильтруем - оставляем только главные компоненты
  ASearchQuery.FDQuery.Filter := 'ParentProductId = NULL';
  ASearchQuery.FDQuery.Filtered := True;

  s := ASearchQuery.GetFieldValues('ID').Trim([',']);
  sParent := s;

  // Фильтруем - оставляем только дочерние компоненты
  ASearchQuery.FDQuery.Filter := 'ParentProductId <> NULL';
  ASearchQuery.FDQuery.Filtered := True;

  sParent2 := ASearchQuery.GetFieldValues('ParentProductId')
    .Trim([',']);
  sDetail := ASearchQuery.GetFieldValues('Id').Trim([',']);

  if not sParent2.IsEmpty then
    sParent := Format('%s,%s', [sParent, sParent2]);

  qComponentsDetailsSearch.Search(s, sDetail);
  qComponentsSearch.Search(sParent);
end;

end.
