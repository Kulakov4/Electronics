unit DataModule2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  RepositoryDataModule, System.Contnrs, ProductGroupUnit,
  ProductSearchGroupUnit, System.Generics.Collections, BaseQuery, QueryGroupUnit,
  ModCheckDatabase, SettingsController, VersionQuery, ProjectConst,
  BaseEventsQuery, QueryWithMasterUnit, QueryWithDataSourceUnit, TreeListQuery,
  DescriptionsGroupUnit, BodyTypesGroupUnit, ProducersGroupUnit,
  ParametersGroupUnit, BaseComponentsGroupUnit, ComponentsExGroupUnit,
  ComponentsGroupUnit, ComponentsSearchGroupUnit, CategoryParametersQuery,
  ChildCategoriesQuery;

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
  private
    FDataSetList: TList<TQueryBase>;
    FEventList: TObjectList;
    FProductGroup: TProductGroup;
    FProductSearchGroup: TProductSearchGroup;
    FQueryGroups: TList<TQueryGroup>;
    // FRecommendedReplacement: TRecommendedReplacementThread;
    // FTempThread: TTempThread;
    procedure CloseConnection;
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
    property ProductGroup: TProductGroup read FProductGroup;
    property ProductSearchGroup: TProductSearchGroup read FProductSearchGroup;
    { Public declarations }
  end;

var
  DM2: TDM2;

implementation

{$R *.dfm}

uses System.IOUtils, NotifyEvents, DragHelper;

constructor TDM2.Create(AOwner: TComponent);
begin
  Application.MessageBox('4', '�������');
  Assert(DMRepository <> nil);
  Assert(not DMRepository.dbConnection.Connected);
  Application.MessageBox('5', '�������');
  inherited;
  Application.MessageBox('6', '�������');
  Assert(not DMRepository.dbConnection.Connected);

  FEventList := TObjectList.Create;
  Application.MessageBox('7', '�������');

  // ������ �������� - ���������� ������
  FProductGroup := TProductGroup.Create(Self);
  Application.MessageBox('8', '�������');
  // ������ �������� - ����� �� �������
  FProductSearchGroup := TProductSearchGroup.Create(Self);
  Application.MessageBox('9', '�������');

  // ������ ������ ������� ������, ������ ����� ���������
  FDataSetList := TList<TQueryBase>.Create;

  Application.MessageBox('10', '�������');
  with FDataSetList do
  begin
    Add(qTreeList);
    Add(BodyTypesGroup.qBodyKinds); // ���� ��������
    Add(BodyTypesGroup.qBodyTypes2); // ���� ��������
    Add(ProducersGroup.qProducerTypes); // ���� ��������������
    Add(ProducersGroup.qProducers); // �������������
    Add(FProductSearchGroup.qProductsSearch);
    // ����� �� ������ � �������������� ����������
    // Add(FProductGroup.qComponentGroups); // ������ ����������� �� ������
    Add(FProductGroup.qStoreHouseList); // ������ - �������
    // Add(FProductGroup.qProducts); // ���������� �������� ������
    Add(ComponentsSearchGroup.qFamilySearch);
    // ����� ����� ����������� (�������)
    Add(ComponentsSearchGroup.qComponentsSearch);
    // ����� ����� ����������� (����������)
    // ������� ��������� - ������ ����������
    Add(qCategoryParameters);
  end;
  Application.MessageBox('11', '�������');
  // ��� ����������� ��������� ������ ����� ������������� � ������
  ComponentsGroup.Producers := ProducersGroup.qProducers;
  ComponentsSearchGroup.Producers := ProducersGroup.qProducers;
  ComponentsExGroup.Producers := ProducersGroup.qProducers;

  Application.MessageBox('12', '�������');
  // ��������� ������� ���������� �������-����������
  qChildCategories.Master := qTreeList;

  // ������� ������� ������, ����� ��� ���������� ������� ����� ������� � ���� ��������
  ComponentsGroup.qComponents.Master := qTreeList;
  ComponentsGroup.qFamily.Master := qTreeList;

  Application.MessageBox('13', '�������');
  // ������� ������� ������, ����� ��� ���������� ������� ����� ������� � ���� ��������
  ComponentsExGroup.qComponentsEx.Master := qTreeList;
  ComponentsExGroup.qFamilyEx.Master := qTreeList;

  Application.MessageBox('14', '�������');
  qCategoryParameters.Master := qTreeList;

  Application.MessageBox('15', '�������');

  // ������ �����
  FQueryGroups := TList<TQueryGroup>.Create;
  FQueryGroups.Add(ComponentsGroup);
  FQueryGroups.Add(ComponentsExGroup);
  FQueryGroups.Add(ComponentsSearchGroup);

  Application.MessageBox('16', '�������');

  TNotifyEventWrap.Create(ParametersGroup.AfterCommit, DoAfterParametersCommit,
    FEventList);

  // ����� ������������� � ��������� �� ������ ����������� ������ � �����������
  // ����������� ��������������
  TNotifyEventWrap.Create(ProducersGroup.qProducers.AfterCommit,
    DoAfterProducerCommit, FEventList);

  // ����� ���������� ������ ������� ���������� ������ �� ������� �������
  TNotifyEventWrap.Create(FProductGroup.qStoreHouseList.AfterPost,
    DoAfterStoreHousePost, FEventList);

  // ����� ��� �������������� ������ � ��������������� ������� ������� ������� ����������
  TNotifyEventWrap.Create(ComponentsExGroup.OnParamOrderChange,
    DoOnParamOrderChange, FEventList);

  Application.MessageBox('17', '�������');
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

procedure TDM2.DoAfterParametersCommit(Sender: TObject);
begin
// ��������� ��������� � ���������� - ���� �������� ��������� ��� ���������
  qCategoryParameters.RefreshQuery;
end;

procedure TDM2.DoAfterProducerCommit(Sender: TObject);
begin
  // ��������� ������ � ����������� ��������������

  // ������ �������� ������ � �������������� � ������ ������
  FProductSearchGroup.qProductsSearch.qProducers.RefreshQuery;
  FProductGroup.qProducts.qProducers.RefreshQuery;
end;

procedure TDM2.DoAfterStoreHousePost(Sender: TObject);
begin
  // ��������� ���������� �������
  // ��������� ���������� ������ �������
  FProductSearchGroup.qProductsSearch.qStoreHouseList.RefreshQuery;
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
