unit DataModule;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.UI.Intf, FireDAC.VCLUI.Wait, FireDAC.Stan.Intf, FireDAC.Comp.UI,
  TreeListQuery, ChildCategoriesQuery, BodyTypesGroupUnit, BodyTypesTreeQuery,
  DescriptionsGroupUnit, Manufacturers2Query, ParametersGroupUnit,
  ComponentsExGroupUnit, System.Contnrs, System.Generics.Collections,
  ComponentsGroupUnit, BodyTypesQuery, ComponentsSearchGroupUnit,
  ParametersForCategoriesGroupUnit, StoreHouseGroupUnit, ProductsBaseQuery,
  ProductsSearchQuery, StoreHouseListQuery, CustomComponentsQuery, BaseQuery,
  QueryWithDataSourceUnit, BaseEventsQuery, QueryWithMasterUnit,
  QueryGroupUnit, BaseComponentsGroupUnit;

type
  TDM = class(TForm)
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    qTreeList: TQueryTreeList;
    qChildCategories: TQueryChildCategories;
    qBodyTypesTree: TQueryBodyTypesTree;
    qManufacturers2: TQueryManufacturers2;
    qProductsSearch: TQueryProductsSearch;
    qBodyTypes: TQueryBodyTypes;
    qStoreHouseList: TQueryStoreHouseList;
    BodyTypesGroup: TBodyTypesGroup;
    StoreHouseGroup: TStoreHouseGroup;
    ComponentsSearchGroup: TComponentsSearchGroup;
    ParametersForCategoriesGroup: TParametersForCategoriesGroup;
    ComponentsGroup: TComponentsGroup;
    ComponentsExGroup: TComponentsExGroup;
    ParametersGroup: TParametersGroup;
    DescriptionsGroup: TDescriptionsGroup;
  private
    FDataSetList: TList<TQueryBase>;
    FEventList: TObjectList;
    FQueryGroups: TList<TQueryGroup>;
    // FRecommendedReplacement: TRecommendedReplacementThread;
    // FTempThread: TTempThread;
    procedure CloseConnection;
    procedure DoAfterBodyTypesTreePostOrDelete(Sender: TObject);
    procedure DoAfterParametersCommit(Sender: TObject);
    procedure DoAfterParamForCategoriesPost(Sender: TObject);
    procedure InitDataSetValues;
    procedure OpenConnection;
    { Private declarations }
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure CreateOrOpenDataBase;
    function HaveAnyChanges: Boolean;
    procedure SaveAll;
    { Public declarations }
  end;

var
  DM: TDM;

implementation

{$R *.dfm}

uses SettingsController, System.IOUtils, RepositoryDataModule, NotifyEvents,
  ModCheckDatabase, ProjectConst;

constructor TDM.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  // FRecommendedReplacement := TRecommendedReplacementThread.Create(Self);
  // FTempThread := TTempThread.Create(Self);

  FEventList := TObjectList.Create;

  // ��������� ������ ��������� � ��� �������, � ������� �� ���� ���������
  FDataSetList := TList<TQueryBase>.Create;
  with FDataSetList do
  begin
    Add(qTreeList);
    Add(BodyTypesGroup.qBodyKinds); // ���� ��������
    Add(BodyTypesGroup.qBodyTypes2); // ���� ��������
    Add(qBodyTypesTree); // ���� ��������
    Add(qManufacturers2); // �������������
    Add(qProductsSearch); // ����� �� ������ � �������������� ����������
    Add(qStoreHouseList); // ������ (���������� ������)
    Add(StoreHouseGroup.qStoreHouseList); // ������ - �������
//    Add(StoreHouseGroup.qProducts); // ���������� �������� ������
    Add(ComponentsSearchGroup.qFamilySearch);
    // ����� ����� ����������� (�������)
    Add(ComponentsSearchGroup.qComponentsSearch);
    // ����� ����� ����������� (����������)

    // ������� ��������� - �������
    Add(ParametersForCategoriesGroup.qParameterTypes);
    // ������� ��������� - ����������
    Add(ParametersForCategoriesGroup.qParametersDetail);

    Add(qBodyTypes); // ���������� ������ ��������
  end;

  qProductsSearch.QueryStoreHouseList := qStoreHouseList;

  // ��� ����������� ��������� ������ ����� ������������� � ������

  ComponentsGroup.Manufacturers := qManufacturers2;
  ComponentsGroup.BodyTypes := qBodyTypes;
  ComponentsSearchGroup.Manufacturers := qManufacturers2;
  ComponentsSearchGroup.BodyTypes := qBodyTypes;
  ComponentsExGroup.Manufacturers := qManufacturers2;
  ComponentsExGroup.BodyTypes := qBodyTypes;

  // ��������� ������� ���������� �������-����������
  qChildCategories.Master := qTreeList;

  // ������� ������� ������, ����� ��� ���������� ������� ����� ������� � ���� ��������
  ComponentsGroup.qComponents.Master := qTreeList;
  ComponentsGroup.qFamily.Master := qTreeList;

  // ������� ������� ������, ����� ��� ���������� ������� ����� ������� � ���� ��������
  ComponentsExGroup.qComponentsEx.Master := qTreeList;
  ComponentsExGroup.qFamilyEx.Master := qTreeList;

  ParametersForCategoriesGroup.qParametersDetail.Master := qTreeList;
  // qCategoryParameters.Master := qTreeList;

  TNotifyEventWrap.Create(ParametersForCategoriesGroup.qParametersDetail.
    AfterPost, DoAfterParamForCategoriesPost, FEventList);

  // ������ �������-����������
  FQueryGroups := TList<TQueryGroup>.Create;
  FQueryGroups.Add(ComponentsGroup);
  FQueryGroups.Add(ComponentsExGroup);
  FQueryGroups.Add(ComponentsSearchGroup);
  FQueryGroups.Add(StoreHouseGroup);
  FQueryGroups.Add(ParametersForCategoriesGroup);

  TNotifyEventWrap.Create(ParametersGroup.AfterCommit,
    DoAfterParametersCommit, FEventList);

  // ����� ������� ������������ � ������������� �����������
  // ����������� ������ � ���������� ����������� ��������
  TNotifyEventWrap.Create(qBodyTypesTree.AfterPost,
    DoAfterBodyTypesTreePostOrDelete, FEventList);
  TNotifyEventWrap.Create(qBodyTypesTree.AfterDelete,
    DoAfterBodyTypesTreePostOrDelete, FEventList);

end;

{ �������� ��������� }
procedure TDM.CloseConnection;
var
  I: Integer;
begin
  for I := FDataSetList.Count - 1 downto 0 do
    FDataSetList[I].FDQuery.Close;

  // ��������� ���������� � ��
  DMRepository.dbConnection.Close;
end;

procedure TDM.CreateOrOpenDataBase;
var
  databaseFileName: string;
begin
  databaseFileName := TPath.Combine(TSettings.Create.databasePath,
    sDefaultDatabaseFileName);

  // ���� ���� � �� �� ����������, ����������� �� ����������
  if not TFile.Exists(databaseFileName) then
    TFile.Copy(ChangeFileExt(Application.ExeName, '.db'), databaseFileName);

  // ��������� ������ ���������� � ��
  if DMRepository.dbConnection.Connected then
    CloseConnection;

  // ������ ���� �� ���� ������
  DMRepository.dbConnection.Params.Database := databaseFileName; // ���� �� ��

  // ��������� ����� ���������� � ��
  OpenConnection();
end;

procedure TDM.DoAfterBodyTypesTreePostOrDelete(Sender: TObject);
begin
  qBodyTypes.RefreshQuery;
end;

procedure TDM.DoAfterParametersCommit(Sender: TObject);
begin
  // ��������� ��������� � ���������� - ���� �������� ��������� ��� ���������
  ParametersForCategoriesGroup.qParameterTypes.RefreshQuery;
end;

procedure TDM.DoAfterParamForCategoriesPost(Sender: TObject);
begin
  // ��������� ��������� � ���������� ��� ���������
  ComponentsExGroup.UpdateData;
end;

function TDM.HaveAnyChanges: Boolean;
var
  I: Integer;
begin
  Result := False;
  if not DMRepository.dbConnection.Connected then
    Exit;

  Result := False;
  for I := 0 to FDataSetList.Count - 1 do
  begin
    Result := FDataSetList[I].HaveAnyChanges;
    if Result then
      Exit;
  end;

  for I := 0 to FQueryGroups.Count - 1 do
  begin
    Result := FQueryGroups[I].Main.HaveAnyChanges or FQueryGroups[I].Detail.HaveAnyChanges;
    if Result then
      Exit;
  end;
end;

{ ���������� �� ������������ ������ }
procedure TDM.InitDataSetValues;
begin
  // ��������� ������ ������
  qTreeList.AddRoot;

  // �������������� ������ �����
  // qFieldTypes.InitDataSetValues;
end;

{ �������� ��������� }
procedure TDM.OpenConnection;
var
  I: Integer;
begin
  // ��������� ��������� ��
  TDBMigration.UpdateDatabaseStructure(DMRepository.dbConnection,
    TSettings.Create.DBMigrationFolder);

  // ������������� ���������� � ��
  DMRepository.dbConnection.Open();

  for I := 0 to FDataSetList.Count - 1 do
  begin
    FDataSetList[I].FDQuery.Open;
  end;

  InitDataSetValues();
end;

{ ��������� �� }
procedure TDM.SaveAll;
var
  I: Integer;
begin
  // ��������� ��������� ��������� � ���������� �����������
  for I := 0 to FDataSetList.Count - 1 do
    FDataSetList[I].TryPost;
  {
    for I := 0 to FQuerysGroups.Count - 1 do
    begin
    FQuerysGroups[I].ApplyUpdates;
    end;
  }
  // ���� �������� � ������ ����������, �� ���������
  if FDataSetList[0].FDQuery.Connection.InTransaction then
    FDataSetList[0].FDQuery.Connection.Commit;

end;

end.
