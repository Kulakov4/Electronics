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
  SearchStorehouseProduct, ProducersQuery, NotifyEvents,
  SearchComponentGroup;

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
  private
    FOnLocate: TNotifyEventsEx;
    FqProducers: TQueryProducers;
    FqSearchComponentGroup: TQuerySearchComponentGroup;
    FqSearchDaughterComponent: TQuerySearchDaughterComponent;
    FqSearchFamilyByID: TQuerySearchFamilyByID;
    FqSearchProduct: TQuerySearchProduct;
    FqSearchStorehouseProduct: TQuerySearchStorehouseProduct;
    procedure DoAfterOpen(Sender: TObject);
    function GetDescriptionID: TField;
    function GetIDComponentGroup: TField;
    function GetIDProducer: TField;
    function GetIsGroup: TField;
    function GetProductID: TField;
    function GetqProducers: TQueryProducers;
    function GetqSearchComponentGroup: TQuerySearchComponentGroup;
    function GetqSearchDaughterComponent: TQuerySearchDaughterComponent;
    function GetqSearchFamilyByID: TQuerySearchFamilyByID;
    function GetqSearchProduct: TQuerySearchProduct;
    function GetqSearchStorehouseProduct: TQuerySearchStorehouseProduct;
    function GetStorehouseId: TField;
    function GetValue: TField;
    // TODO: SplitComponentName
    // function SplitComponentName(const S: string): TComponentNameParts;
    { Private declarations }
  protected
    procedure ApplyDelete(ASender: TDataSet); override;
    procedure ApplyInsert(ASender: TDataSet); override;
    procedure ApplyUpdate(ASender: TDataSet); override;
    function GetExportFileName: string; virtual; abstract;
    property qSearchComponentGroup: TQuerySearchComponentGroup
      read GetqSearchComponentGroup;
    property qSearchDaughterComponent: TQuerySearchDaughterComponent
      read GetqSearchDaughterComponent;
    property qSearchFamilyByID: TQuerySearchFamilyByID
      read GetqSearchFamilyByID;
    property qSearchProduct: TQuerySearchProduct read GetqSearchProduct;
    property qSearchStorehouseProduct: TQuerySearchStorehouseProduct
      read GetqSearchStorehouseProduct;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AddCategory;
    procedure AddProduct(AIDComponentGroup: Integer);
    procedure ApplyUpdates; override;
    procedure CancelUpdates; override;
    procedure DeleteNode(AID: Integer);
    procedure DeleteNotUsedProducts(AProductIDS: TList<Integer>);
    procedure LoadDocFile(const AFileName: String;
      ADocFieldInfo: TDocFieldInfo);
    function LocateInComponents: Boolean;
    property DescriptionID: TField read GetDescriptionID;
    property ExportFileName: string read GetExportFileName;
    property IDComponentGroup: TField read GetIDComponentGroup;
    property IDProducer: TField read GetIDProducer;
    property IsGroup: TField read GetIsGroup;
    property ProductID: TField read GetProductID;
    property qProducers: TQueryProducers read GetqProducers;
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

procedure TQueryProductsBase.AddCategory;
begin
  TryAppend;
  Value.AsString := '����� ������';
  IsGroup.AsInteger := 1;
end;

procedure TQueryProductsBase.AddProduct(AIDComponentGroup: Integer);
begin
  Assert(AIDComponentGroup > 0);
  TryAppend;
  Value.AsString := '����� ������';
  IsGroup.AsInteger := 0;
  IDComponentGroup.AsInteger := AIDComponentGroup;
end;

procedure TQueryProductsBase.ApplyDelete(ASender: TDataSet);
var
  AProductIDS: TList<Integer>;
begin
  Assert(ASender = FDQuery);

  // ������ ����� ��������� ������� �� ������� � �������� ������
  AProductIDS := TList<Integer>.Create;
  try

    // ���� ��� ������
    if IsGroup.AsInteger = 1 then
    begin
      Assert(PK.Value > 0);
      // ���� ����� ������
      if qSearchComponentGroup.SearchByID(PK.Value) = 0 then
        Exit;

      // ������ ������� �� ����. ���� ������� � �������� ������ ��� ���������� ���� ������
      // ���� ���������� �� ������� ������, ������� ����������� ���� ������
      if qSearchStorehouseProduct.SearchByGroupID(StorehouseId.AsInteger,
        PK.Value) = 0 then
        Exit;

      // ������� � �������� ������ ��� ��������� ���������� ����������� � ������
      while qSearchStorehouseProduct.FDQuery.RecordCount > 0 do
      begin
        // ����������, ��� ���� ������� �� ������� �� ������
        if AProductIDS.IndexOf(qSearchStorehouseProduct.ProductID.AsInteger) < 0 then
          AProductIDS.Add(qSearchStorehouseProduct.ProductID.AsInteger);

        qSearchStorehouseProduct.FDQuery.Delete;
      end;

      DeleteNotUsedProducts(AProductIDS);
    end
    else
    begin
      Assert(PK.Value < 0);
      if qSearchStorehouseProduct.SearchByID(-PK.Value) = 0 then
        Exit;

      AProductIDS.Add(ProductID.AsInteger);

      // ������� ������� �� ������. ��� ������� �� �������.
      qSearchStorehouseProduct.FDQuery.Delete;

      // ������� ���������������� ��������
      DeleteNotUsedProducts(AProductIDS);
    end;
  finally
    FreeAndNil(AProductIDS);
  end;

  inherited;
end;

procedure TQueryProductsBase.ApplyInsert(ASender: TDataSet);
var
  AFieldHolder: TFieldHolder;
  ARH: TRecordHolder;
  ARH2: TRecordHolder;
  ARHFamily: TRecordHolder;
  OK: Boolean;
  rc: Integer;
begin
  Assert(ASender = FDQuery);

  if Value.AsString.Trim.IsEmpty then
    raise Exception.Create('���������� ������ ������������');

  // ���� ���� ��������� ������ ������
  if IsGroup.AsInteger = 1 then
  begin
    // ���� ����� ������ ����������� � �����������
    rc := qSearchComponentGroup.SearchByValue(Value.AsString);
    if rc = 0 then
      qSearchComponentGroup.Append(Value.AsString);

    // ��������� ��������� ����
    PK.Value := qSearchComponentGroup.PK.Value;
    Exit;
  end;

  // ���� ������������� �����
  if IDProducer.AsInteger > 0 then
  begin
    // ���� ������������� �� ����
    OK := qProducers.LocateByPK(IDProducer.AsInteger);
    Assert(OK);

    rc := qSearchDaughterComponent.Search(Value.AsString,
      qProducers.Name.AsString);
  end
  else
  begin
    // ���� � ������������� ���� ������ �� ������������
    rc := qSearchDaughterComponent.Search(Value.AsString);
    if rc > 0 then
    begin
      // ���� � ����������� ������ �������������
      qProducers.LocateOrAppend(qSearchDaughterComponent.Producer.AsString);
      // ��������� �������������
      IDProducer.AsInteger := qProducers.PK.Value;
    end;
  end;

  ARH := TRecordHolder.Create(ASender);
  try
    // ���� ����� ��������� ������ � ����������� ����
    if rc > 0 then
    begin
      // ���� ��������������� ��������� �����������
      rc := qSearchFamilyByID.Search
        (qSearchDaughterComponent.ParentProductID.AsInteger);
      Assert(rc = 1);

      ARHFamily := TRecordHolder.Create(qSearchFamilyByID.FDQuery);
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
        qSearchFamilyByID.Field(ADocFieldInfo.FieldName).AsString;
        end;
        // ��������� ������ �� ������� ��������
        ADescriptionID.AsInteger :=
        qSearchFamilyByID.DescriptionID.AsInteger;
      }
    end;

    // ���� ������������� �� �����
    if IDProducer.AsInteger = 0 then
    begin
      // ���� ����� ��������� � ����� ������ �� ������
      rc := qSearchProduct.SearchByValue(Value.AsString);
      if rc > 0 then
        // ��������� �������������
        IDProducer.AsInteger := qSearchProduct.IDProducer.AsInteger
      else
        raise Exception.Create('���������� ������ �������������');
    end
    else
    begin
      // ���� ������������� �����
      rc := qSearchProduct.SearchByValue(Value.AsString, IDProducer.AsInteger);
    end;

    // ���� ������ �������� ��� ���
    if rc = 0 then
    begin
      // ��������� � ���� ��� �������
      qSearchProduct.InsertRecord(ARH);

      ARH.Field[ProductID.FieldName] := qSearchProduct.PK.Value;
      ProductID.AsInteger := qSearchProduct.PK.Value;
    end
    else
    begin
      // ���� ����� ������� ��� ����
      // ���������� ��������� ��������� ����
      ARH.Field[ProductID.FieldName] := qSearchProduct.PK.Value;
      ProductID.AsInteger := qSearchProduct.PK.Value;

      // ���������� ���� ��������� ����������
      ARH2 := TRecordHolder.Create(qSearchProduct.FDQuery);
      try
        // ��� ������ ���� ��������� ���������� �� ���������� ��������
        ARH.UpdateNullValues(ARH2);
        ARH.Put(ASender);

        ARH.Field['ID'] := ARH.Field[ProductID.FieldName];
        // ��������� �������, ���� �� � ��� ���-�� ��������
        qSearchProduct.UpdateRecord(ARH);
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
    if not qSearchStorehouseProduct.FDQuery.Active then
      qSearchStorehouseProduct.SearchByID(1);

    qSearchStorehouseProduct.InsertRecord(ARH);

    // ��������� ���� � ��� - ������������� ������ "�������-�����" � ������������� ���������
    PK.Value := -qSearchStorehouseProduct.PK.Value;

    // ��������� ��� ��������
    ProductID.AsInteger := ARH.Field[ProductID.FieldName];
  finally
    FreeAndNil(ARH);
  end;

  inherited;
end;

procedure TQueryProductsBase.ApplyUpdate(ASender: TDataSet);
var
  ARH: TRecordHolder;
begin
  Assert(ASender = FDQuery);

  ARH := TRecordHolder.Create(ASender);
  try
    if IsGroup.AsInteger = 1 then
    begin
      Assert(PK.Value > 0);
      // ���� ����� ������
      if qSearchComponentGroup.SearchByID(PK.Value) = 0 then
        Exit;

      // ����� ��������� ���� ����
      ARH.Clear;
      TFieldHolder.Create(ARH, qSearchComponentGroup.ComponentGroup.FieldName,
        Value.AsString);

      qSearchComponentGroup.UpdateRecord(ARH);

    end
    else
    begin
      Assert(PK.Value < 0);
      // ���� �� �������������� ������ �����-�������
      qSearchStorehouseProduct.SearchByID(-PK.Value);
      // ��������� ���������� � ���������� �� ������
      qSearchStorehouseProduct.UpdateRecord(ARH);

      // ��������� ���������� � ����� ����������
      qSearchProduct.SearchByID(ProductID.AsInteger);
      qSearchProduct.UpdateRecord(ARH);
    end;
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

procedure TQueryProductsBase.DeleteNode(AID: Integer);
var
  AClone: TFDMemTable;
  OK: Boolean;
begin
//  FDQuery.DisableControls;
  try
    // ���� ������ ������� ���� �������
    OK := LocateByPK(AID);
    Assert(OK);

    // ���� ����� ������� ������
    if IsGroup.AsInteger = 1 then
    begin
      AClone := TFDMemTable.Create(Self);
      try
        AClone.CloneCursor(FDQuery);
        AClone.Filter := Format('IDComponentGroup=%d', [PK.AsInteger]);
        AClone.Filtered := True;

        // ������� ��� ���������� ������
        while AClone.RecordCount > 0 do
          DeleteNode(AClone.FieldByName('ID').AsInteger);

      finally
        FreeAndNil(AClone);
      end;

        // ����� ��������� �� ������
      OK := LocateByPK(AID);
      Assert(OK);
    end;
    FDQuery.Delete;
  finally
//    FDQuery.EnableControls;
  end;
end;

procedure TQueryProductsBase.DeleteNotUsedProducts(AProductIDS: TList<Integer>);
var
  AProductID: Integer;
begin
  Assert(AProductIDS <> nil);

  for AProductID in AProductIDS do
  begin
    // ���� �������� ��������� �� ������� ������ ���
    if qSearchStorehouseProduct.SearchByProductID(AProductID) = 0
    then
    begin
      // ������� �������
      if qSearchProduct.SearchByID(AProductID) > 0 then
        qSearchProduct.FDQuery.Delete;
    end;
  end;
end;

procedure TQueryProductsBase.DoAfterOpen(Sender: TObject);
begin
  SetFieldsRequired(False);
  SetFieldsReadOnly(False);
end;

function TQueryProductsBase.GetDescriptionID: TField;
begin
  Result := Field('DescriptionID');
end;

function TQueryProductsBase.GetIDComponentGroup: TField;
begin
  Result := Field('IDComponentGroup');
end;

function TQueryProductsBase.GetIDProducer: TField;
begin
  Result := Field('IDProducer');
end;

function TQueryProductsBase.GetIsGroup: TField;
begin
  Result := Field('IsGroup');
end;

function TQueryProductsBase.GetProductID: TField;
begin
  Result := Field('ProductID');
end;

function TQueryProductsBase.GetqProducers: TQueryProducers;
begin
  if FqProducers = nil then
  begin
    FqProducers := TQueryProducers.Create(Self);
    FqProducers.TryOpen;
  end;

  Result := FqProducers;
end;

function TQueryProductsBase.GetqSearchComponentGroup
  : TQuerySearchComponentGroup;
begin
  if FqSearchComponentGroup = nil then
  begin
    FqSearchComponentGroup := TQuerySearchComponentGroup.Create(Self);
  end;
  Result := FqSearchComponentGroup;
end;

function TQueryProductsBase.GetqSearchDaughterComponent
  : TQuerySearchDaughterComponent;
begin
  if FqSearchDaughterComponent = nil then
    FqSearchDaughterComponent := TQuerySearchDaughterComponent.Create(Self);
  Result := FqSearchDaughterComponent;
end;

function TQueryProductsBase.GetqSearchFamilyByID: TQuerySearchFamilyByID;
begin
  if FqSearchFamilyByID = nil then
    FqSearchFamilyByID := TQuerySearchFamilyByID.Create(Self);
  Result := FqSearchFamilyByID;
end;

function TQueryProductsBase.GetqSearchProduct: TQuerySearchProduct;
begin
  if FqSearchProduct = nil then
    FqSearchProduct := TQuerySearchProduct.Create(Self);

  Result := FqSearchProduct;
end;

function TQueryProductsBase.GetqSearchStorehouseProduct
  : TQuerySearchStorehouseProduct;
begin
  if FqSearchStorehouseProduct = nil then
    FqSearchStorehouseProduct := TQuerySearchStorehouseProduct.Create(Self);
  Result := FqSearchStorehouseProduct;
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
    OK := qProducers.LocateByPK(IDProducer.AsInteger);
    Assert(OK);

    rc := qSearchDaughterComponent.Search(Value.AsString,
      qProducers.Name.AsString);
  end;
  if rc > 0 then
  begin
    // ���� ��������������� ��������� �����������
    rc := qSearchFamilyByID.Search
      (qSearchDaughterComponent.ParentProductID.AsInteger);

  end;
  Result := rc > 0;

  if Result then
  begin
    m := qSearchFamilyByID.CategoryIDList.AsString.Split([',']);
    Assert(Length(m) > 0);

    AIDCategory := String.ToInteger(m[0]);

    LR := TLocateObject.Create(AIDCategory, qSearchFamilyByID.Value.AsString,
      qSearchDaughterComponent.Value.AsString);
    try
      OnLocate.CallEventHandlers(LR);
    finally
      FreeAndNil(LR);
    end;

  end;
end;

// TODO: SplitComponentName
// function TQueryProductsBase.SplitComponentName(const S: string)
// : TComponentNameParts;
// var
// Count: Integer;
// StartIndex: Integer;
// begin
/// / ������������ ��� ��������� ���������� � �����, �� �������� ������� �����
// Result.Name := S;
// Result.Number := 0;
// Result.Ending := '';
//
// Count := 1;
//
/// / ���� � ������ ������ �� ������� �����
// while S.IndexOfAny(['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'], 0,
// Count) = -1 do
// begin
// Inc(Count);
//
// // ���� � ������ ������ ��� ����
// if Count > S.Length then
// Exit;
// end;
//
// Result.Name := S.Substring(0, Count - 1);
// StartIndex := Count - 1;
//
/// / ���� � ������ ������� �����
// while S.IndexOfAny(['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'],
// StartIndex) = StartIndex do
// Inc(StartIndex);
//
// Dec(StartIndex);
//
/// / ���� ����� ����-�� ���� �����
// if StartIndex >= Count then
// begin
// Result.Number := StrToInt(S.Substring(Count - 1, StartIndex - Count));
// Result.Ending := S.Substring(StartIndex + 1);
// end;
// end;

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
