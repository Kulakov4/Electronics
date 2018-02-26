unit DataModule2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  RepositoryDataModule, System.Contnrs, System.Generics.Collections,
  BaseQuery, QueryGroupUnit, ModCheckDatabase, SettingsController, VersionQuery,
  ProjectConst, BaseEventsQuery, QueryWithMasterUnit, QueryWithDataSourceUnit,
  TreeListQuery, DescriptionsGroupUnit, BodyTypesGroupUnit, ProducersGroupUnit,
  ParametersGroupUnit, BaseComponentsGroupUnit, ComponentsExGroupUnit,
  ComponentsGroupUnit, ComponentsSearchGroupUnit,
  ChildCategoriesQuery, ProductsBaseQuery, ProductsQuery,
  StoreHouseListQuery, ProductsSearchQuery, CategoryParametersQuery2,
  CategoryParametersGroupUnit, NotifyEvents;

type
  TDM2 = class(TForm)
    qVersion: TQueryVersion;
    qTreeList: TQueryTreeList;
    BodyTypesGroup: TBodyTypesGroup;
    ProducersGroup: TProducersGroup;
    ComponentsExGroup: TComponentsExGroup;
    ComponentsGroup: TComponentsGroup;
    ComponentsSearchGroup: TComponentsSearchGroup;
    qChildCategories: TQueryChildCategories;
    qProducts: TQueryProducts;
    qStoreHouseList: TQueryStoreHouseList;
    qProductsSearch: TQueryProductsSearch;
    DescriptionsGroup: TDescriptionsGroup;
    ParametersGroup: TParametersGroup;
    CategoryParametersGroup: TCategoryParametersGroup;
  private
    FDataSetList: TList<TQueryBase>;
    FEventList: TObjectList;
    FQueryGroups: TList<TQueryGroup>;
    FTreeListAfterFirstOpen: TNotifyEventWrap;
    // FRecommendedReplacement: TRecommendedReplacementThread;
    // FTempThread: TTempThread;
    procedure CloseConnection;
    procedure DoOnCategoryParametersApplyUpdates(Sender: TObject);
    procedure DoAfterComponentsCommit(Sender: TObject);
    procedure DoAfterParametersCommit(Sender: TObject);
    procedure DoAfterProducerCommit(Sender: TObject);
    procedure DoAfterStoreHousePost(Sender: TObject);
    procedure DoOnParamOrderChange(Sender: TObject);
    procedure InitDataSetValues;
    procedure OpenConnection;
    { Private declarations }
  protected
    procedure DoAfterTreeListFirstOpen(Sender: TObject);
    procedure DoBeforeTreeListClose(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CreateOrOpenDataBase;
    function HaveAnyChanges: Boolean;
    procedure SaveAll;
    { Public declarations }
  end;

var
  DM2: TDM2;

implementation

{$R *.dfm}

uses System.IOUtils, DragHelper, Data.DB;

constructor TDM2.Create(AOwner: TComponent);
begin
  Assert(DMRepository <> nil);
  Assert(not DMRepository.dbConnection.Connected);
  inherited;
  Assert(not DMRepository.dbConnection.Connected);

  FEventList := TObjectList.Create;

  // ������ ������ ������� ������, ������ ����� ���������
  FDataSetList := TList<TQueryBase>.Create;

  with FDataSetList do
  begin
    Add(qTreeList);
    Add(BodyTypesGroup.qBodyKinds); // ���� ��������
    Add(BodyTypesGroup.qBodyTypes2); // ���� ��������
    Add(ProducersGroup.qProducerTypes); // ���� ��������������
    Add(ProducersGroup.qProducers); // �������������
    Add(qProductsSearch);
    // ����� �� ������ � �������������� ����������
    // Add(FProductGroup.qComponentGroups); // ������ ����������� �� ������
    Add(qStoreHouseList); // ������ - �������
    // Add(FProductGroup.qProducts); // ���������� �������� ������
    Add(ComponentsSearchGroup.qFamilySearch);
    // ����� ����� ����������� (�������)
    Add(ComponentsSearchGroup.qComponentsSearch);
    // ����� ����� ����������� (�����������)
    // ������� ��������� - ������ ����������
    Add(CategoryParametersGroup.qCategoryParameters);
  end;
  // ��� ����������� ��������� ������ ����� ������������� � ������
//  ComponentsGroup.Producers := ProducersGroup.qProducers;
//  ComponentsSearchGroup.Producers := ProducersGroup.qProducers;
//  ComponentsExGroup.Producers := ProducersGroup.qProducers;

  FTreeListAfterFirstOpen := TNotifyEventWrap.Create(qTreeList.AfterOpen, DoAfterTreeListFirstOpen);
  TNotifyEventWrap.Create(qTreeList.BeforeClose, DoBeforeTreeListClose, FEventList);

  // ��������� ������� ���������� �������-�����������
  qChildCategories.Master := qTreeList;
  qProducts.Master := qStoreHouseList;

  // ������� ������� ������, ����� ��� ���������� ������� ����� ������� � ���� ��������
  ComponentsGroup.qComponents.Master := qTreeList;
  ComponentsGroup.qFamily.Master := qTreeList;

  // ������� ������� ������, ����� ��� ���������� ������� ����� ������� � ���� ��������
  ComponentsExGroup.qComponentsEx.Master := qTreeList;
  ComponentsExGroup.qFamilyEx.Master := qTreeList;

  CategoryParametersGroup.qCategoryParameters.Master := qTreeList;

  // ������ �����
  FQueryGroups := TList<TQueryGroup>.Create;
  FQueryGroups.Add(ComponentsGroup);
  FQueryGroups.Add(ComponentsExGroup);
  FQueryGroups.Add(ComponentsSearchGroup);

  TNotifyEventWrap.Create(ParametersGroup.AfterCommit, DoAfterParametersCommit,
    FEventList);

  TNotifyEventWrap.Create(CategoryParametersGroup.qCategoryParameters.On_ApplyUpdates, DoOnCategoryParametersApplyUpdates,
    FEventList);

  TNotifyEventWrap.Create(ComponentsGroup.AfterCommit, DoAfterComponentsCommit,
    FEventList);


  // ����� ������������� � ��������� �� ������ ����������� ������ � �����������
  // ����������� ��������������
  TNotifyEventWrap.Create(ProducersGroup.qProducers.AfterCommit,
    DoAfterProducerCommit, FEventList);

  // ����� ���������� ������ ������� ���������� ������ �� ������� �������
  TNotifyEventWrap.Create(qStoreHouseList.AfterPost, DoAfterStoreHousePost,
    FEventList);

  // ����� ��� �������������� ������ � ��������������� ������� ������� ������� ����������
  TNotifyEventWrap.Create(ComponentsExGroup.OnParamOrderChange,
    DoOnParamOrderChange, FEventList);
end;

destructor TDM2.Destroy;
begin
  CloseConnection;
  FreeAndNil(FEventList);
  FreeAndNil(FDataSetList);
  FreeAndNil(FQueryGroups);
  inherited;
end;


{ �������� ��������� }
procedure TDM2.CloseConnection;
var
  BC: TDataSetNotifyEvent;
  I: Integer;
begin
  // ��� ������� �� �����������, ������ ��� csDestroying in ComponentState
  DoBeforeTreeListClose(qTreeList.FDQuery);

  for I := FDataSetList.Count - 1 downto 0 do
    FDataSetList[I].FDQuery.Close;

  qTreeList.FDQuery.Close;

  // ��������� ���������� � ��
  DMRepository.dbConnection.Close;
end;

procedure TDM2.CreateOrOpenDataBase;
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

procedure TDM2.DoOnCategoryParametersApplyUpdates(Sender: TObject);
begin
  // ��������� ��������� � ������� ���������� ��� ���������
  // ����� ��������� ��������������� �������
  ComponentsExGroup.TryRefresh;
end;

procedure TDM2.DoAfterComponentsCommit(Sender: TObject);
begin
  // ��������� ��������� � ������� �����������
  // ����� ��������� ��������������� �������
  ComponentsExGroup.TryRefresh;
end;

procedure TDM2.DoAfterParametersCommit(Sender: TObject);
begin
  // ��������� ��������� � ���������� - ���� �������� ��������� ��� ���������
  CategoryParametersGroup.qCategoryParameters.RefreshQuery;
end;

procedure TDM2.DoAfterProducerCommit(Sender: TObject);
begin
  // ��������� ������ � ����������� ��������������

  // ������ �������� ������ � �������������� � ������ ������
  qProductsSearch.ProducersGroup.ReOpen;
  qProducts.ProducersGroup.ReOpen;
  DescriptionsGroup.qProducers.RefreshQuery;


  ComponentsGroup.Producers.RefreshQuery;
  ComponentsSearchGroup.Producers.RefreshQuery;
end;

procedure TDM2.DoAfterStoreHousePost(Sender: TObject);
begin
  // ��������� ���������� �������
  // ��������� ���������� ������ �������
  qProductsSearch.qStoreHouseList.RefreshQuery;
end;

procedure TDM2.DoAfterTreeListFirstOpen(Sender: TObject);
var
  ACategoryID: Integer;
begin
  Assert(qTreeList.FDQuery.Active);


  ACategoryID := TSettings.Create.CategoryID;
  // ���� � ���������� �� ����������� ��������� �������� ���������
  // ���� ��������� �������� ��������� ���������
  if (ACategoryID = 0) or (not TSettings.Create.LoadLastCategory) then
    Exit;

  // �������� ������� �� ��-�� ������
  qTreeList.LocateByPK(ACategoryID);
end;

procedure TDM2.DoBeforeTreeListClose(Sender: TObject);
begin
  Assert(qTreeList.FDQuery.Active);

  if qTreeList.FDQuery.RecordCount = 0 then
    Exit;

  TSettings.Create.CategoryID := qTreeList.PK.AsInteger;
end;

procedure TDM2.DoOnParamOrderChange(Sender: TObject);
begin
  CategoryParametersGroup.RefreshData;
end;

function TDM2.HaveAnyChanges: Boolean;
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
procedure TDM2.InitDataSetValues;
begin
  // ��������� ������ ������
  qTreeList.AddRoot;

  // �������������� ������ �����
  // qFieldTypes.InitDataSetValues;
end;

{ �������� ��������� }
procedure TDM2.OpenConnection;
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

  // ������������ �� �������
  Assert(FTreeListAfterFirstOpen <> nil);
  FreeAndNil(FTreeListAfterFirstOpen);


  InitDataSetValues();
end;

{ ��������� �� }
procedure TDM2.SaveAll;
var
  I: Integer;
begin
  // ��������� ��������� ��������� � ���������� �����������
  for I := 0 to FDataSetList.Count - 1 do
    FDataSetList[I].TryPost;

  // ���� �������� � ������ ����������, �� ���������
  if FDataSetList[0].FDQuery.Connection.InTransaction then
    FDataSetList[0].FDQuery.Connection.Commit;

end;

end.
