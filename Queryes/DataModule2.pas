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
  ComponentsGroupUnit, ComponentsSearchGroupUnit, CategoryParametersQuery,
  ChildCategoriesQuery, ProductsBaseQuery, ProductsQuery,
  StoreHouseListQuery, ProductsSearchQuery;

type
  TDM2 = class(TForm)
    qVersion: TQueryVersion;
    qTreeList: TQueryTreeList;
    DescriptionsGroup: TDescriptionsGroup;
    BodyTypesGroup: TBodyTypesGroup;
    ProducersGroup: TProducersGroup;
    ParametersGroup: TParametersGroup;
    ComponentsExGroup: TComponentsExGroup;
    ComponentsGroup: TComponentsGroup;
    ComponentsSearchGroup: TComponentsSearchGroup;
    qCategoryParameters: TQueryCategoryParameters;
    qChildCategories: TQueryChildCategories;
    qProducts: TQueryProducts;
    qStoreHouseList: TQueryStoreHouseList;
    qProductsSearch: TQueryProductsSearch;
  private
    FDataSetList: TList<TQueryBase>;
    FEventList: TObjectList;
    FQueryGroups: TList<TQueryGroup>;
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

uses System.IOUtils, NotifyEvents, DragHelper;

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
    // ����� ����� ����������� (����������)
    // ������� ��������� - ������ ����������
    Add(qCategoryParameters);
  end;
  // ��� ����������� ��������� ������ ����� ������������� � ������
  ComponentsGroup.Producers := ProducersGroup.qProducers;
  ComponentsSearchGroup.Producers := ProducersGroup.qProducers;
  ComponentsExGroup.Producers := ProducersGroup.qProducers;

  // ��������� ������� ���������� �������-����������
  qChildCategories.Master := qTreeList;
  qProducts.Master := qStoreHouseList;

  // ������� ������� ������, ����� ��� ���������� ������� ����� ������� � ���� ��������
  ComponentsGroup.qComponents.Master := qTreeList;
  ComponentsGroup.qFamily.Master := qTreeList;

  // ������� ������� ������, ����� ��� ���������� ������� ����� ������� � ���� ��������
  ComponentsExGroup.qComponentsEx.Master := qTreeList;
  ComponentsExGroup.qFamilyEx.Master := qTreeList;

  qCategoryParameters.Master := qTreeList;

  // ������ �����
  FQueryGroups := TList<TQueryGroup>.Create;
  FQueryGroups.Add(ComponentsGroup);
  FQueryGroups.Add(ComponentsExGroup);
  FQueryGroups.Add(ComponentsSearchGroup);

  TNotifyEventWrap.Create(ParametersGroup.AfterCommit, DoAfterParametersCommit,
    FEventList);

  TNotifyEventWrap.Create(qCategoryParameters.On_ApplyUpdates, DoOnCategoryParametersApplyUpdates,
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
  FreeAndNil(FEventList);
  FreeAndNil(FDataSetList);
  FreeAndNil(FQueryGroups);
  inherited;
end;

{ �������� ��������� }
procedure TDM2.CloseConnection;
var
  I: Integer;
begin
  for I := FDataSetList.Count - 1 downto 0 do
    FDataSetList[I].FDQuery.Close;

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
  qCategoryParameters.RefreshQuery;
end;

procedure TDM2.DoAfterProducerCommit(Sender: TObject);
begin
  // ��������� ������ � ����������� ��������������

  // ������ �������� ������ � �������������� � ������ ������
  qProductsSearch.qProducers.RefreshQuery;
  qProducts.qProducers.RefreshQuery;
end;

procedure TDM2.DoAfterStoreHousePost(Sender: TObject);
begin
  // ��������� ���������� �������
  // ��������� ���������� ������ �������
  qProductsSearch.qStoreHouseList.RefreshQuery;
end;

procedure TDM2.DoOnParamOrderChange(Sender: TObject);
var
  L: TList<TRecOrder>;
begin
  L := Sender as TList<TRecOrder>;
  qCategoryParameters.Move(L);
  qCategoryParameters.ApplyUpdates;
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
