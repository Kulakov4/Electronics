unit ProductsBaseQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  ApplyQueryFrame, DocFieldInfo, StoreHouseListQuery,
  SearchProductParameterValuesQuery, SearchFamilyByID,
  SearchProductQuery, QueryWithDataSourceUnit, CustomComponentsQuery,
  SearchDaughterComponentQuery, System.Generics.Collections,
  SearchStorehouseProductByID, ProducersQuery, NotifyEvents;

type
  TComponentNameParts = record
    Name: String;
    Number: cardinal;
    Ending: String;
  end;

  TLocateRec = record
    IDCategory: Integer;
    FamilyName: String;
    ComponentName: String;
  end;

  TQueryProductsBase = class(TQueryWithDataSource)
    qStoreHouseProducts: TfrmApplyQuery;
    qProducts: TfrmApplyQuery;
  private
    FOnLocate: TNotifyEventsEx;
    FQueryProducers: TQueryProducers;
    FQuerySearchDaughterComponent: TQuerySearchDaughterComponent;
    FQuerySearchFamilyByID: TQuerySearchFamilyByID;
    FQuerySearchProduct: TQuerySearchProduct;
    FQuerySearchStorehouseProductByID: TQuerySearchStorehouseProductByID;
    procedure DoAfterOpen(Sender: TObject);
    function GetComponentGroup: TField;
    function GetDescriptionID: TField;
    function GetIDProducer: TField;
    function GetProductID: TField;
    function GetQueryProducers: TQueryProducers;
    function GetQuerySearchDaughterComponent: TQuerySearchDaughterComponent;
    function GetQuerySearchFamilyByID: TQuerySearchFamilyByID;
    function GetQuerySearchProduct: TQuerySearchProduct;
    function GetQuerySearchStorehouseProductByID
      : TQuerySearchStorehouseProductByID;
    function GetStorehouseId: TField;
    function GetValue: TField;
    function SplitComponentName(const S: string): TComponentNameParts;
    { Private declarations }
  protected
    procedure ApplyDelete(ASender: TDataSet); override;
    procedure ApplyInsert(ASender: TDataSet); override;
    procedure ApplyUpdate(ASender: TDataSet); override;
    function GetExportFileName: string; virtual; abstract;
    property QuerySearchDaughterComponent: TQuerySearchDaughterComponent
      read GetQuerySearchDaughterComponent;
    property QuerySearchFamilyByID: TQuerySearchFamilyByID
      read GetQuerySearchFamilyByID;
    property QuerySearchProduct: TQuerySearchProduct read GetQuerySearchProduct;
    property QuerySearchStorehouseProductByID: TQuerySearchStorehouseProductByID
      read GetQuerySearchStorehouseProductByID;
  public
    constructor Create(AOwner: TComponent); override;
    procedure ApplyUpdates; override;
    procedure CancelUpdates; override;
    procedure LoadDocFile(const AFileName: String;
      ADocFieldInfo: TDocFieldInfo);
    function LocateInComponents: Boolean;
    property ComponentGroup: TField read GetComponentGroup;
    property DescriptionID: TField read GetDescriptionID;
    property ExportFileName: string read GetExportFileName;
    property IDProducer: TField read GetIDProducer;
    property ProductID: TField read GetProductID;
    property QueryProducers: TQueryProducers read GetQueryProducers;
    property StorehouseId: TField read GetStorehouseId;
    property Value: TField read GetValue;
    property OnLocate: TNotifyEventsEx read FOnLocate;
    { Public declarations }
  end;

  TLocateObject = class(TObject)
  private
    FComponentName: string;
    FFamilyName: string;
    FIDCategory: Integer;
  public
    constructor Create(const AIDCategory: Integer;
      const AFamilyName, AComponentName: string);
    property ComponentName: string read FComponentName;
    property FamilyName: string read FFamilyName;
    property IDCategory: Integer read FIDCategory;
  end;

implementation

{$R *.dfm}

uses DBRecordHolder, System.IOUtils, SettingsController, RepositoryDataModule,
  ParameterValuesUnit, StrHelper, System.StrUtils;

constructor TQueryProductsBase.Create(AOwner: TComponent);
begin
  inherited;
  FOnLocate := TNotifyEventsEx.Create(Self);

  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, FEventList);

  // ����� ���� ��������� ������
  FDQuery.OnUpdateRecord := DoOnQueryUpdateRecord;

  // �� ��������� �� �� � ������ �������������� ����������
  AutoTransaction := False;
end;

procedure TQueryProductsBase.ApplyDelete(ASender: TDataSet);
var
  AProductID: TField;
begin
  Assert(PKValue > 0);

  AProductID := ASender.FieldByName(ProductID.FieldName);

  // ������� ������� �� ������. ��� ������� �� �������.
  qStoreHouseProducts.DeleteRecord(PKValue);

  // ���� �������� ��������� �� ������ ������ ���
  if QuerySearchStorehouseProductByID.Search(AProductID.AsInteger) = 0 then
  begin
    // ������� �������
    qProducts.DeleteRecord(AProductID.AsInteger);
  end;

  inherited;
end;

procedure TQueryProductsBase.ApplyInsert(ASender: TDataSet);
var
  AFieldHolder: TFieldHolder;
  APK: TField;
  AIDProducer: TField;
  AProductID: TField;
  ARH: TRecordHolder;
  ARH2: TRecordHolder;
  ARHFamily: TRecordHolder;
  AValue: TField;
  OK: Boolean;
  rc: Integer;
begin
  AValue := ASender.FieldByName(Value.FieldName);
  if AValue.AsString.Trim.IsEmpty then
    raise Exception.Create('���������� ������ ������������ ����������');
  APK := ASender.FieldByName(PKFieldName);
  AProductID := ASender.FieldByName(ProductID.FieldName);
  AIDProducer := ASender.FieldByName(IDProducer.FieldName);

  // ���� ������������� �����
  if AIDProducer.AsInteger > 0 then
  begin
    // ���� ������������� �� ����
    OK := QueryProducers.LocateByPK(AIDProducer.AsInteger);
    Assert(OK);

    rc := QuerySearchDaughterComponent.Search(AValue.AsString,
      QueryProducers.Name.AsString);
  end
  else
  begin
    // ���� � ������������� ���� ������ �� ������������
    rc := QuerySearchDaughterComponent.Search(AValue.AsString);
    if rc > 0 then
    begin
      // ���� � ����������� ������ �������������
      QueryProducers.LocateOrAppend
        (QuerySearchDaughterComponent.Producer.AsString);
      // ��������� �������������
      AIDProducer.AsInteger := QueryProducers.PKValue;
    end;
  end;

  ARH := TRecordHolder.Create(ASender);
  try
    // ���� ����� ��������� ������ � ����������� ����
    if rc > 0 then
    begin
      // ���� ��������������� ��������� �����������
      rc := QuerySearchFamilyByID.Search
        (QuerySearchDaughterComponent.ParentProductID.AsInteger);
      Assert(rc = 1);

      ARHFamily := TRecordHolder.Create(QuerySearchFamilyByID.FDQuery);
      try
        // ��������� ������ ��������
        ARH.UpdateNullValues(ARHFamily);
        ARH.Put(ASender);
      finally
        FreeAndNil(ARHFamily)
      end;

      {
        // ��������� ����� ������������ ���, ��� ��������� � ���������
        for ADocFieldInfo in FDocFieldInfos do
        begin
        ASender.FieldByName(ADocFieldInfo.FieldName).AsString :=
        QuerySearchFamilyByID.Field(ADocFieldInfo.FieldName).AsString;
        end;
        // ��������� ������ �� ������� ��������
        ADescriptionID.AsInteger :=
        QuerySearchFamilyByID.DescriptionID.AsInteger;
      }
    end;

    // ���� ������������� �� �����
    if AIDProducer.AsInteger = 0 then
    begin
      // ���� ����� ��������� � ����� ������ �� ������
      rc := QuerySearchProduct.Search(AValue.AsString);
      if rc > 0 then
        // ��������� �������������
        AIDProducer.AsInteger := QuerySearchProduct.IDProducer.AsInteger
      else
        raise Exception.Create('���������� ������ �������������');
    end
    else
    begin
      // ���� ������������� �����
      rc := QuerySearchProduct.Search(AValue.AsString, AIDProducer.AsInteger);
    end;

    // ���� ������ �������� ��� ���
    if rc = 0 then
    begin
      // ��������� � ���� ��� �������
      qProducts.InsertRecord(ARH);

      ARH.Field[ProductID.FieldName] := qProducts.PKValue;
      AProductID.AsInteger := qProducts.PKValue;
    end
    else
    begin
      // ���� ����� ������� ��� ����
      // ���������� ��������� ��������� ����
      ARH.Field[ProductID.FieldName] := QuerySearchProduct.PKValue;
      AProductID.AsInteger := QuerySearchProduct.PKValue;

      // ���������� ���� ��������� ����������
      ARH2 := TRecordHolder.Create(QuerySearchProduct.FDQuery);
      try
        // ��� ������ ���� ��������� ���������� �� ���������� ��������
        ARH.UpdateNullValues(ARH2);
        ARH.Put(ASender);

        ARH.Field['ID'] := ARH.Field[ProductID.FieldName];
        // ��������� �������, ���� �� � �� ���-�� ��������
        qProducts.UpdateRecord(ARH);
      finally
        FreeAndNil(ARH2);
      end;
    end;

    // ��� ���������� �� ������ ���� ������
    Assert(not VarIsNull(ARH.Field[ProductID.FieldName]));
    // ��� ������ �� ������ ���� ������
    Assert(not VarIsNull(ARH.Field[StorehouseId.FieldName]));

    // ���� ID ��������� �� �����
    AFieldHolder := ARH.Find('ID');
    FreeAndNil(AFieldHolder);

    // �������� ��� ��������� �� �����
    qStoreHouseProducts.InsertRecord(ARH);
    Assert(qStoreHouseProducts.PKValue > 0);

    // ��������� ���� � ��� - ������������� ������ "�������-�����"
    APK.AsInteger := qStoreHouseProducts.PKValue;

    // ��������� ��� ��������
    AProductID.AsInteger := ARH.Field[ProductID.FieldName];
  finally
    FreeAndNil(ARH);
  end;

  inherited;
end;

procedure TQueryProductsBase.ApplyUpdate(ASender: TDataSet);
var
  ARH: TRecordHolder;
begin
  ARH := TRecordHolder.Create(ASender);
  try
    // ��������� ���������� � ���������� �� ������
    qStoreHouseProducts.UpdateRecord(ARH);

    // ��������� ���������� � ����� ����������
    ARH.Field['ID'] := ARH.Field[ProductID.FieldName];
    qProducts.UpdateRecord(ARH);
  finally
    FreeAndNil(ARH);
  end;

  inherited;
end;

procedure TQueryProductsBase.ApplyUpdates;
begin
  TryPost;
  FDQuery.Connection.Commit;
end;

procedure TQueryProductsBase.CancelUpdates;
begin
  // �������� ��� ��������� ��������� �� ������� �������
  TryCancel;
  FDQuery.Connection.Rollback;
  RefreshQuery;
end;

procedure TQueryProductsBase.DoAfterOpen(Sender: TObject);
begin
  SetFieldsRequired(False);
  SetFieldsReadOnly(False);
end;

// TODO: GetComponentFamily
// function TQueryProductsBase.GetComponentFamily: String;
// var
// ComponentNameParts: TComponentNameParts;
// begin
// Assert(not Value.AsString.IsEmpty);
// Result := Value.AsString;
//
/// / ��������� ��� ���������� �� �����
// ComponentNameParts := SplitComponentName(Value.AsString);
//
// Result := IfThen(ComponentNameParts.Number = 0, ComponentNameParts.Name,
// Format('%s%d', [ComponentNameParts.Name, ComponentNameParts.Number]))
// end;

function TQueryProductsBase.GetComponentGroup: TField;
begin
  Result := Field('ComponentGroup');
end;

function TQueryProductsBase.GetDescriptionID: TField;
begin
  Result := Field('DescriptionID');
end;

function TQueryProductsBase.GetIDProducer: TField;
begin
  Result := Field('IDProducer');
end;

function TQueryProductsBase.GetProductID: TField;
begin
  Result := Field('ProductID');
end;

function TQueryProductsBase.GetQueryProducers: TQueryProducers;
begin
  if FQueryProducers = nil then
  begin
    FQueryProducers := TQueryProducers.Create(Self);
    FQueryProducers.TryOpen;
  end;

  Result := FQueryProducers;
end;

function TQueryProductsBase.GetQuerySearchDaughterComponent
  : TQuerySearchDaughterComponent;
begin
  if FQuerySearchDaughterComponent = nil then
    FQuerySearchDaughterComponent := TQuerySearchDaughterComponent.Create(Self);
  Result := FQuerySearchDaughterComponent;
end;

function TQueryProductsBase.GetQuerySearchFamilyByID: TQuerySearchFamilyByID;
begin
  if FQuerySearchFamilyByID = nil then
    FQuerySearchFamilyByID := TQuerySearchFamilyByID.Create(Self);
  Result := FQuerySearchFamilyByID;
end;

function TQueryProductsBase.GetQuerySearchProduct: TQuerySearchProduct;
begin
  if FQuerySearchProduct = nil then
    FQuerySearchProduct := TQuerySearchProduct.Create(Self);

  Result := FQuerySearchProduct;
end;

function TQueryProductsBase.GetQuerySearchStorehouseProductByID
  : TQuerySearchStorehouseProductByID;
begin
  if FQuerySearchStorehouseProductByID = nil then
    FQuerySearchStorehouseProductByID :=
      TQuerySearchStorehouseProductByID.Create(Self);
  Result := FQuerySearchStorehouseProductByID;
end;

function TQueryProductsBase.GetStorehouseId: TField;
begin
  Result := Field('StorehouseId');
end;

function TQueryProductsBase.GetValue: TField;
begin
  Result := Field('Value');
end;

procedure TQueryProductsBase.LoadDocFile(const AFileName: String;
  ADocFieldInfo: TDocFieldInfo);
var
  S: String;
begin
  if not AFileName.IsEmpty then
  begin
    // � �� ������ ���� �� ����� ������������ ����� � �������������
    S := GetRelativeFileName(AFileName, ADocFieldInfo.Folder);
    TryEdit;
    FDQuery.FieldByName(ADocFieldInfo.FieldName).AsString := S;
    TryPost;
  end;
end;

function TQueryProductsBase.LocateInComponents: Boolean;
var
  AIDCategory: Integer;
  OK: Boolean;
  rc: Integer;
  LR: TLocateObject;
  m: TArray<String>;
begin
  rc := 0;
  // ���� ������������� �����
  if IDProducer.AsInteger > 0 then
  begin
    // ���� ������������� �� ����
    OK := QueryProducers.LocateByPK(IDProducer.AsInteger);
    Assert(OK);

    rc := QuerySearchDaughterComponent.Search(Value.AsString,
      QueryProducers.Name.AsString);
  end;
  if rc > 0 then
  begin
    // ���� ��������������� ��������� �����������
    rc := QuerySearchFamilyByID.Search
      (QuerySearchDaughterComponent.ParentProductID.AsInteger);

  end;
  Result := rc > 0;

  if Result then
  begin
    m := QuerySearchFamilyByID.CategoryIDList.AsString.Split([',']);
    Assert(Length(m) > 0);

    AIDCategory := String.ToInteger(m[0]);

    LR := TLocateObject.Create(AIDCategory,
      QuerySearchFamilyByID.Value.AsString,
      QuerySearchDaughterComponent.Value.AsString);
    try
      OnLocate.CallEventHandlers(LR);
    finally
      FreeAndNil(LR);
    end;

  end;
end;

function TQueryProductsBase.SplitComponentName(const S: string)
  : TComponentNameParts;
var
  Count: Integer;
  StartIndex: Integer;
begin
  // ������������ ��� ��������� ���������� � �����, �� �������� ������� �����
  Result.Name := S;
  Result.Number := 0;
  Result.Ending := '';

  Count := 1;

  // ���� � ������ ������ �� ������� �����
  while S.IndexOfAny(['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'], 0,
    Count) = -1 do
  begin
    Inc(Count);

    // ���� � ������ ������ ��� ����
    if Count > S.Length then
      Exit;
  end;

  Result.Name := S.Substring(0, Count - 1);
  StartIndex := Count - 1;

  // ���� � ������ ������� �����
  while S.IndexOfAny(['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'],
    StartIndex) = StartIndex do
    Inc(StartIndex);

  Dec(StartIndex);

  // ���� ����� ����-�� ���� �����
  if StartIndex >= Count then
  begin
    Result.Number := StrToInt(S.Substring(Count - 1, StartIndex - Count));
    Result.Ending := S.Substring(StartIndex + 1);
  end;
end;

constructor TLocateObject.Create(const AIDCategory: Integer;
  const AFamilyName, AComponentName: string);
begin
  inherited Create;
  Assert(AIDCategory > 0);
  Assert(not AFamilyName.IsEmpty);
  Assert(not AComponentName.IsEmpty);

  FIDCategory := AIDCategory;
  FFamilyName := AFamilyName;
  FComponentName := AComponentName;
end;

end.
