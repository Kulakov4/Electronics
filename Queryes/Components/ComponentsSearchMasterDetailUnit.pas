unit ComponentsSearchMasterDetailUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Comp.Client, Vcl.ExtCtrls,
  ComponentsSearchQuery, ComponentsDetailsSearchQuery, MasterDetailFrame,
  ComponentsBaseMasterDetailUnit, ComponentsBaseDetailQuery,
  CustomComponentsQuery, SearchComponentsByValues, MainComponentsQuery,
  QueryWithDataSourceUnit, BaseQuery;

type
  TComponentsSearchMasterDetail = class(TComponentsBaseMasterDetail)
    qComponentsSearch: TQueryComponentsSearch;
    qComponentsDetailsSearch: TQueryComponentsDetailsSearch;
  private
    FQuerySearchComponentsByValues: TQuerySearchComponentsByValues;
    function GetQuerySearchComponentsByValues: TQuerySearchComponentsByValues;
    { Private declarations }
  protected
    property QuerySearchComponentsByValues: TQuerySearchComponentsByValues read
        GetQuerySearchComponentsByValues;
  public
    constructor Create(AOwner: TComponent); override;
    procedure ApplyUpdates; override;
    procedure ClearSearchResult;
    procedure Search;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses SearchInterfaceUnit, RepositoryDataModule;

constructor TComponentsSearchMasterDetail.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Main := qComponentsSearch;
  Detail := qComponentsDetailsSearch;
end;

procedure TComponentsSearchMasterDetail.ApplyUpdates;
begin
  // ���� ��������� � ������ ����������� ��������� �������
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

function TComponentsSearchMasterDetail.GetQuerySearchComponentsByValues:
    TQuerySearchComponentsByValues;
begin
  if FQuerySearchComponentsByValues = nil then
    FQuerySearchComponentsByValues := TQuerySearchComponentsByValues.Create(Self);

  Result := FQuerySearchComponentsByValues;
end;

procedure TComponentsSearchMasterDetail.Search;
var
  s: string;
  sDetail: string;
  sParent: string;
  sParent2: string;
begin
  // �������� ������ �������� �� ������� ����� ������������ �����
  s := qComponentsSearch.GetFieldValues(qComponentsSearch.Value.FieldName).Trim([',']);

  { ���������� �������� ��� �������������� ������� ���� �� ���������. �����, ���������� ��� ���, ������� ��� ������������ ������
    � ��������� ��� �������������� }

  QuerySearchComponentsByValues.Search(s);


  // ��������� - ��������� ������ ������� ����������
  QuerySearchComponentsByValues.FDQuery.Filter := 'ParentProductId = NULL';
  QuerySearchComponentsByValues.FDQuery.Filtered := True;

  s := QuerySearchComponentsByValues.GetFieldValues('ID').Trim([',']);
  sParent := s;

  // ��������� - ��������� ������ �������� ����������
  QuerySearchComponentsByValues.FDQuery.Filter := 'ParentProductId <> NULL';
  QuerySearchComponentsByValues.FDQuery.Filtered := True;

  sParent2 := QuerySearchComponentsByValues.GetFieldValues('ParentProductId').Trim([',']);
  sDetail := QuerySearchComponentsByValues.GetFieldValues('Id').Trim([',']);

  if not sParent2.IsEmpty then
    sParent := Format('%s,%s', [sParent, sParent2]);

  qComponentsDetailsSearch.Search(s, sDetail);
  qComponentsSearch.Search(sParent);
end;

end.
