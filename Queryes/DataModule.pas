unit DataModule;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.UI.Intf, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Intf, FireDAC.Comp.UI, DataModuleFrame, TreeListQuery,
  ChildCategoriesQuery, MasterDetailFrame, BodyTypesMasterDetailUnit,
  BodyTypesTreeQuery, DescriptionsMasterDetailUnit, Manufacturers2Query,
  ParametersMasterDetailUnit, ComponentsBaseMasterDetailUnit,
  ComponentsExMasterDetailUnit, System.Contnrs, System.Generics.Collections,
  ComponentsMasterDetailUnit, BodyTypesQuery, ComponentsSearchMasterDetailUnit,
  ParametersForCategoriesMasterDetailUnit, StoreHouseMasterDetailUnit,
  ProductsBaseQuery, ProductsSearchQuery, StoreHouseListQuery;

type
  TDM = class(TForm)
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    qTreeList: TQueryTreeList;
    qChildCategories: TQueryChildCategories;
    BodyTypesMasterDetail: TBodyTypesMasterDetail;
    qBodyTypesTree: TQueryBodyTypesTree;
    qManufacturers2: TQueryManufacturers2;
    ParametersMasterDetail2: TParametersMasterDetail2;
    ComponentsExMasterDetail: TComponentsExMasterDetail;
    ComponentsSearchMasterDetail: TComponentsSearchMasterDetail;
    ParametersForCategoriesMasterDetail: TParametersForCategoriesMasterDetail;
    qProductsSearch: TQueryProductsSearch;
    ComponentsMasterDetail: TComponentsMasterDetail;
    DescriptionsMasterDetail: TDescriptionsMasterDetail;
    qBodyTypes: TQueryBodyTypes;
    StoreHouseMasterDetail: TStoreHouseMasterDetail;
    qStoreHouseList: TQueryStoreHouseList;
  private
    FDataSetList: TList<TfrmDataModule>;
    FEventList: TObjectList;
    FMasterDetailList: TList<TfrmMasterDetail>;
    // FRecommendedReplacement: TRecommendedReplacementThread;
    // FTempThread: TTempThread;
    procedure CloseConnection;
    procedure DeleteLostComponents;
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
  ModCheckDatabase, LostComponentsQuery, ProjectConst;

constructor TDM.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  // FRecommendedReplacement := TRecommendedReplacementThread.Create(Self);
  // FTempThread := TTempThread.Create(Self);

  FEventList := TObjectList.Create;

  // ��������� ������ ��������� � ��� �������, � ������� �� ���� ���������
  FDataSetList := TList<TfrmDataModule>.Create;
  with FDataSetList do
  begin
    Add(qTreeList);
    Add(BodyTypesMasterDetail.qBodyKinds); // ���� ��������
    Add(BodyTypesMasterDetail.qBodyTypes2); // ���� ��������
    Add(qBodyTypesTree); // ���� ��������
    Add(qManufacturers2); // �������������
    Add(qProductsSearch); // ����� �� ������ � �������������� ����������
    Add(qStoreHouseList); // ������ (���������� ������)
    Add(StoreHouseMasterDetail.qStoreHouseList); // ������ - �������
    Add(StoreHouseMasterDetail.qProducts); // ���������� �������� ������
    Add(ComponentsSearchMasterDetail.qComponentsSearch);
    // ����� ����� ����������� (�������)
    Add(ComponentsSearchMasterDetail.qComponentsDetailsSearch);
    // ����� ����� ����������� (����������)

    // ������� ��������� - �������
    Add(ParametersForCategoriesMasterDetail.qParameterTypes);
    // ������� ��������� - ����������
    Add(ParametersForCategoriesMasterDetail.qParametersDetail);

    Add(qBodyTypes); // ���������� ������ ��������
  end;

  qProductsSearch.QueryStoreHouseList := qStoreHouseList;

  // ��� ����������� ��������� ������ ����� ������������� � ������

  ComponentsMasterDetail.Manufacturers := qManufacturers2;
  ComponentsMasterDetail.BodyTypes := qBodyTypes;
  ComponentsSearchMasterDetail.Manufacturers := qManufacturers2;
  ComponentsSearchMasterDetail.BodyTypes := qBodyTypes;
  ComponentsExMasterDetail.Manufacturers := qManufacturers2;
  ComponentsExMasterDetail.BodyTypes := qBodyTypes;

  // ��������� ������� ���������� �������-����������
  qChildCategories.Master := qTreeList;

  // ������� ������� ������, ����� ��� ���������� ������� ����� ������� � ���� ��������
  ComponentsMasterDetail.qComponentsDetail.Master := qTreeList;
  ComponentsMasterDetail.qComponents.Master := qTreeList;

  // ������� ������� ������, ����� ��� ���������� ������� ����� ������� � ���� ��������
  ComponentsExMasterDetail.qComponentsDetailEx.Master := qTreeList;
  ComponentsExMasterDetail.qComponentsEx.Master := qTreeList;

  ParametersForCategoriesMasterDetail.qParametersDetail.Master := qTreeList;
  // qCategoryParameters.Master := qTreeList;

  TNotifyEventWrap.Create(ParametersForCategoriesMasterDetail.qParametersDetail.
    AfterPost, DoAfterParamForCategoriesPost, FEventList);

  // ������ �������-����������
  FMasterDetailList := TList<TfrmMasterDetail>.Create;
  FMasterDetailList.Add(ComponentsMasterDetail);
  FMasterDetailList.Add(ComponentsExMasterDetail);
  FMasterDetailList.Add(ComponentsSearchMasterDetail);
  FMasterDetailList.Add(StoreHouseMasterDetail);
  FMasterDetailList.Add(ParametersForCategoriesMasterDetail);

  TNotifyEventWrap.Create(ParametersMasterDetail2.AfterCommit,
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

// ������� "����������" ����������.
// ������ ��� ��������, ���� ��� �����������
procedure TDM.DeleteLostComponents;
var
  AQuery: TDeleteLostComponentsQuery;
begin
  Assert(DMRepository.dbConnection.Connected);

  AQuery := TDeleteLostComponentsQuery.Create(Self);
  try
    AQuery.Connection := DMRepository.dbConnection;
    AQuery.ExecSQL;
  finally
    FreeAndNil(AQuery);
  end;
end;

procedure TDM.DoAfterBodyTypesTreePostOrDelete(Sender: TObject);
begin
  qBodyTypes.RefreshQuery;
end;

procedure TDM.DoAfterParametersCommit(Sender: TObject);
begin
  // ��������� ��������� � ���������� - ���� �������� ��������� ��� ���������
  ParametersForCategoriesMasterDetail.qParameterTypes.RefreshQuery;
end;

procedure TDM.DoAfterParamForCategoriesPost(Sender: TObject);
begin
  // ��������� ��������� � ���������� ��� ���������
  ComponentsExMasterDetail.UpdateData;
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

  for I := 0 to FMasterDetailList.Count - 1 do
  begin
    Result := FMasterDetailList[I].Main.HaveAnyChanges or FMasterDetailList[I]
      .Detail.HaveAnyChanges;
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

  // ������� "����������" ����������
  DeleteLostComponents;
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
    for I := 0 to FMasterDetailList.Count - 1 do
    begin
    FMasterDetailList[I].ApplyUpdates;
    end;
  }
  // ���� �������� � ������ ����������, �� ���������
  if FDataSetList[0].FDQuery.Connection.InTransaction then
    FDataSetList[0].FDQuery.Connection.Commit;

end;

end.
