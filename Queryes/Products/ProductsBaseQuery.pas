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
  SearchStorehouseProductByID, ProducersQuery;

type
  TComponentNameParts = record
    Name: String;
    Number: cardinal;
    Ending: String;
  end;

  TQueryProductsBase = class(TQueryWithDataSource)
    qStoreHouseProducts: TfrmApplyQuery;
    qProducts: TfrmApplyQuery;
  private
    FQueryProducers: TQueryProducers;
    FQuerySearchDaughterComponent: TQuerySearchDaughterComponent;
    FQuerySearchFamilytByID: TQuerySearchFamilyByID;
    FQuerySearchProduct: TQuerySearchProduct;
    FQuerySearchStorehouseProductByID: TQuerySearchStorehouseProductByID;
    procedure DoAfterOpen(Sender: TObject);
// TODO: GetComponentFamily
//  function GetComponentFamily: String;
    function GetComponentGroup: TField;
    function GetDescriptionID: TField;
    function GetIDProducer: TField;
    function GetProductID: TField;
    function GetQueryProducers: TQueryProducers;
    function GetQuerySearchDaughterComponent: TQuerySearchDaughterComponent;
    function GetQuerySearchFamilytByID: TQuerySearchFamilyByID;
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
    property QuerySearchDaughterComponent: TQuerySearchDaughterComponent
      read GetQuerySearchDaughterComponent;
    property QuerySearchFamilytByID: TQuerySearchFamilyByID read
        GetQuerySearchFamilytByID;
    property QuerySearchProduct: TQuerySearchProduct read GetQuerySearchProduct;
    property QuerySearchStorehouseProductByID: TQuerySearchStorehouseProductByID
      read GetQuerySearchStorehouseProductByID;
  public
    constructor Create(AOwner: TComponent); override;
    procedure ApplyUpdates; override;
    procedure CancelUpdates; override;
    procedure LoadDocFile(const AFileName: String;
      ADocFieldInfo: TDocFieldInfo);
    property ComponentGroup: TField read GetComponentGroup;
    property DescriptionID: TField read GetDescriptionID;
    property IDProducer: TField read GetIDProducer;
    property ProductID: TField read GetProductID;
    property QueryProducers: TQueryProducers read GetQueryProducers;
    property StorehouseId: TField read GetStorehouseId;
    property Value: TField read GetValue;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses DBRecordHolder, System.IOUtils, SettingsController, RepositoryDataModule,
  NotifyEvents, ParameterValuesUnit, StrHelper, System.StrUtils;

constructor TQueryProductsBase.Create(AOwner: TComponent);
begin
  inherited;
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
      rc := QuerySearchFamilytByID.Search
        (QuerySearchDaughterComponent.ParentProductID.AsInteger);
      Assert(rc = 1);

      ARHFamily := TRecordHolder.Create(QuerySearchFamilytByID.FDQuery);
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
        QuerySearchFamilytByID.Field(ADocFieldInfo.FieldName).AsString;
        end;
        // ��������� ������ �� ������� ��������
        ADescriptionID.AsInteger :=
        QuerySearchFamilytByID.DescriptionID.AsInteger;
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
    if rc = 0
    then
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
var
  AField: TField;
begin
  for AField in FDQuery.Fields do
  begin
    AField.ReadOnly := False;
    AField.Required := False;
  end;
end;

// TODO: GetComponentFamily
//function TQueryProductsBase.GetComponentFamily: String;
//var
//ComponentNameParts: TComponentNameParts;
//begin
//Assert(not Value.AsString.IsEmpty);
//Result := Value.AsString;
//
//// ��������� ��� ���������� �� �����
//ComponentNameParts := SplitComponentName(Value.AsString);
//
//Result := IfThen(ComponentNameParts.Number = 0, ComponentNameParts.Name,
//  Format('%s%d', [ComponentNameParts.Name, ComponentNameParts.Number]))
//end;

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

function TQueryProductsBase.GetQuerySearchFamilytByID: TQuerySearchFamilyByID;
begin
  if FQuerySearchFamilytByID = nil then
    FQuerySearchFamilytByID := TQuerySearchFamilyByID.Create(Self);
  Result := FQuerySearchFamilytByID;
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

end.
