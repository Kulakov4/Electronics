unit DataModule;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.UI.Intf, FireDAC.VCLUI.Wait, FireDAC.Stan.Intf, FireDAC.Comp.UI,
  TreeListQuery, ChildCategoriesQuery, BodyTypesGroupUnit, BodyTypesTreeQuery,
  DescriptionsGroupUnit, ProducersQuery, ParametersGroupUnit,
  ComponentsExGroupUnit, System.Contnrs, System.Generics.Collections,
  ComponentsGroupUnit, BodyTypesQuery, ComponentsSearchGroupUnit,
  ParametersForCategoriesGroupUnit, StoreHouseGroupUnit, ProductsBaseQuery,
  ProductsSearchQuery, StoreHouseListQuery, CustomComponentsQuery, BaseQuery,
  QueryWithDataSourceUnit, BaseEventsQuery, QueryWithMasterUnit,
  QueryGroupUnit, BaseComponentsGroupUnit, VersionQuery, CategoryParametersQuery;

type
  TDM = class(TForm)
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    qTreeList: TQueryTreeList;
    qChildCategories: TQueryChildCategories;
    qBodyTypesTree: TQueryBodyTypesTree;
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
    qProducers: TQueryProducers;
    DescriptionsGroup: TDescriptionsGroup;
    qVersion: TQueryVersion;
    qCategoryParameters: TQueryCategoryParameters;
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
    procedure DoAfterStoreHousePost(Sender: TObject);
    procedure InitDataSetValues;
    procedure OpenConnection;
    { Private declarations }
  protected
    procedure DoAfterProducerCommit(Sender: TObject);
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
  Assert(not DMRepository.dbConnection.Connected);
  inherited Create(AOwner);
  Assert(not DMRepository.dbConnection.Connected);
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
    Add(qProducers); // �������������
    Add(qProductsSearch); // ����� �� ������ � �������������� ����������
    Add(qStoreHouseList); // ������ (���������� ������)
    Add(StoreHouseGroup.qStoreHouseList); // ������ - �������
    // Add(StoreHouseGroup.qProducts); // ���������� �������� ������
    Add(ComponentsSearchGroup.qFamilySearch);
    // ����� ����� ����������� (�������)
    Add(ComponentsSearchGroup.qComponentsSearch);
    // ����� ����� ����������� (����������)

    // ������� ��������� - �������
    Add(ParametersForCategoriesGroup.qParameterTypes);
    // ������� ��������� - ����������
    Add(ParametersForCategoriesGroup.qParametersDetail);
    // ������� ��������� - ������ ����������
    Add(qCategoryParameters);

    Add(qBodyTypes); // ���������� ������ ��������
  end;

  // ��� ����������� ������ �������
  qProductsSearch.QueryStoreHouseList := qStoreHouseList;

  // ��� ����������� ��������� ������ ����� ������������� � ������

  ComponentsGroup.Producers := qProducers;
  ComponentsGroup.BodyTypes := qBodyTypes;
  ComponentsSearchGroup.Producers := qProducers;
  ComponentsSearchGroup.BodyTypes := qBodyTypes;
  ComponentsExGroup.Producers := qProducers;
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
  qCategoryParameters.Master := qTreeList;
  // qCategoryParameters.Master := qTreeList;

  TNotifyEventWrap.Create(ParametersForCategoriesGroup.qParametersDetail.
    AfterPost, DoAfterParamForCategoriesPost, FEventList);

  // ������ �����
  FQueryGroups := TList<TQueryGroup>.Create;
  FQueryGroups.Add(ComponentsGroup);
  FQueryGroups.Add(ComponentsExGroup);
  FQueryGroups.Add(ComponentsSearchGroup);
  FQueryGroups.Add(StoreHouseGroup);
  FQueryGroups.Add(ParametersForCategoriesGroup);

  TNotifyEventWrap.Create(ParametersGroup.AfterCommit, DoAfterParametersCommit,
    FEventList);

  // ����� ������� ������������ � ������������� �����������
  // ����������� ������ � ���������� ����������� ��������
  TNotifyEventWrap.Create(qBodyTypesTree.AfterPost,
    DoAfterBodyTypesTreePostOrDelete, FEventList);
  TNotifyEventWrap.Create(qBodyTypesTree.AfterDelete,
    DoAfterBodyTypesTreePostOrDelete, FEventList);

  // ����� ������������� � ��������� �� ������ ����������� ������ � �����������
  // ����������� ��������������
  TNotifyEventWrap.Create(qProducers.AfterCommit, DoAfterProducerCommit,
    FEventList);

  // ����� ���������� ������ ������� ���������� ������ �� ������� �������
  TNotifyEventWrap.Create(StoreHouseGroup.qStoreHouseList.AfterPost,
    DoAfterStoreHousePost, FEventList);
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
  ADatabaseFileName: string;
  AEmptyDatabaseFileName: string;
begin
  ADatabaseFileName := TPath.Combine(TSettings.Create.databasePath,
    sDefaultDatabaseFileName);

  // ���� ���� � �� �� ����������, ����������� �� ����������
  if not TFile.Exists(ADatabaseFileName) then
  begin
    // ������������ � ������ ����� "������" ���� ������
    AEmptyDatabaseFileName :=
      TPath.Combine(TPath.GetDirectoryName(Application.ExeName),
      sEmptyDatabaseFileName);

    if not TFile.Exists(AEmptyDatabaseFileName) then
      raise Exception.Create(Format('�� ���� ������� ������ ���� ������.' +
        #13#10 + '�� ������ ���� %s', [sEmptyDatabaseFileName]));

    TFile.Copy(AEmptyDatabaseFileName, ADatabaseFileName);
  end;

  // ��������� ������ ���������� � ��
  if DMRepository.dbConnection.Connected then
    CloseConnection;

  // ������ ���� �� ���� ������
  DMRepository.dbConnection.Params.Database := ADatabaseFileName; // ���� �� ��

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

procedure TDM.DoAfterProducerCommit(Sender: TObject);
begin
  // ��������� ������ � ����������� ��������������

  // ������ �������� ������ � �������������� � ������ ������
  qProductsSearch.QueryProducers.RefreshQuery;
  StoreHouseGroup.qProducts.QueryProducers.RefreshQuery;
end;

procedure TDM.DoAfterStoreHousePost(Sender: TObject);
begin
  qStoreHouseList.RefreshQuery;
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
    Result := FQueryGroups[I].Main.HaveAnyChanges or
      FQueryGroups[I].Detail.HaveAnyChanges;
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
  AErrorMessage: string;
  I: Integer;
begin
  try
    // ��������� ��������� ��
    TDBMigration.UpdateDatabaseStructure(DMRepository.dbConnection,
      TSettings.Create.DBMigrationFolder);
  except
    // ��� ���������� ������ �� ��������� �����-�� ������
    on E: Exception do
    begin
      AErrorMessage :=
        Format('������ ��� ���������� ��������� ���� ������.'#13#10'%s',
        [E.Message]);
      raise Exception.Create(AErrorMessage);
    end;
  end;

  // ������������� ���������� � ��
  DMRepository.dbConnection.Open();

  AErrorMessage := '';
  try
    qVersion.RefreshQuery;
    if qVersion.Version.AsInteger <> DBVersion then
    begin
      AErrorMessage := Format('�������� ������ ���� ������ (���� %d, ����� %d)',
        [DBVersion, qVersion.Version.AsInteger]);
    end;
  except
    // ��� �������� ������ �� ��������� �����-�� ������
    on E: Exception do
    begin
      AErrorMessage := E.Message;
    end;
  end;

  if not AErrorMessage.IsEmpty then
  begin
    DMRepository.dbConnection.Close;
    raise Exception.Create(AErrorMessage);
  end;

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
