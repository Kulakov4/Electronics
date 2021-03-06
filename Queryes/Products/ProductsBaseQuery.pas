unit ProductsBaseQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, ApplyQueryFrame, DocFieldInfo,
  SearchProductParameterValuesQuery, SearchProductQuery, CustomComponentsQuery,
  SearchComponentOrFamilyQuery, System.Generics.Collections,
  SearchStorehouseProduct, ProducersQuery, NotifyEvents, SearchComponentGroup,
  SearchFamily, ProducersGroupUnit2, ExtraChargeQuery2,  DSWrap, DescriptionsQueryWrap, BaseEventsQuery, StoreHouseListQuery, HRTimer,
  ProductsBaseQuery0;

const
  WM_OnCommitUpdates = WM_USER + 169;

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

  TProductW = class(TBaseProductsW)
  private
    FBarcode: TFieldWrap;
    FBatchNumber: TFieldWrap;
    FChecked: TFieldWrap;
    FCustomsDeclarationNumber: TFieldWrap;
    FDocumentNumber: TFieldWrap;
    FDollar: TFieldWrap;
    FEuro: TFieldWrap;
    FIDComponentGroup: TFieldWrap;
    FIDCurrency: TFieldWrap;
    FIDExtraCharge: TFieldWrap;
    FIDExtraChargeType: TFieldWrap;
    FIDProducer: TFieldWrap;
    FLoadDate: TFieldWrap;
    FMinWholeSale: TFieldWrap;
    FOriginCountry: TFieldWrap;
    FOriginCountryCode: TFieldWrap;
    FPackagePins: TFieldWrap;
    FPackaging: TFieldWrap;
    FPrice: TFieldWrap;
    FCalcPriceR: TFieldWrap;
    FMarkup: TFieldWrap;
    FProductID: TFieldWrap;
    FReleaseDate: TFieldWrap;
    FRetail: TFieldWrap;
    FSaleCount: TFieldWrap;
    FSaleD: TFieldWrap;
    FSaleE: TFieldWrap;
    FSaleR: TFieldWrap;
    FSeller: TFieldWrap;
    FStorage: TFieldWrap;
    FStoragePlace: TFieldWrap;
    FStorehouseId: TFieldWrap;
    FValue: TFieldWrap;
    FWholeSale: TFieldWrap;
  protected
    function CheckInsertingRecord: String;
    function CheckEditingRecord: String; virtual;
    function GetStorehouseProductVirtualID(AID: Integer): Integer;
    procedure InitFields; override;
    procedure OnDatasheetGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
  public const
    VirtualIDOffset = -100000;
    constructor Create(AOwner: TComponent); override;
    procedure AddCategory;
    procedure AddProduct(AIDComponentGroup: Integer);
    procedure ApplySaleCountFilter;
    procedure ApplyAmountFilter;
    procedure CheckSaleCount;
    function LookupComponentGroup(const AComponentGroup: string): Variant;
    procedure SetSaleCount(ASaleCount: Double);
    function GetStorehouseProductID(AVirtualID: Integer): Integer;
    procedure SetInternalCalc(const AFields: Array of TField);
    property Barcode: TFieldWrap read FBarcode;
    property BatchNumber: TFieldWrap read FBatchNumber;
    property Checked: TFieldWrap read FChecked;
    property CustomsDeclarationNumber: TFieldWrap
      read FCustomsDeclarationNumber;
    property DocumentNumber: TFieldWrap read FDocumentNumber;
    property Dollar: TFieldWrap read FDollar;
    property Euro: TFieldWrap read FEuro;
    property IDComponentGroup: TFieldWrap read FIDComponentGroup;
    property IDCurrency: TFieldWrap read FIDCurrency;
    property IDExtraCharge: TFieldWrap read FIDExtraCharge;
    property IDExtraChargeType: TFieldWrap read FIDExtraChargeType;
    property IDProducer: TFieldWrap read FIDProducer;
    property LoadDate: TFieldWrap read FLoadDate;
    property MinWholeSale: TFieldWrap read FMinWholeSale;
    property OriginCountry: TFieldWrap read FOriginCountry;
    property OriginCountryCode: TFieldWrap read FOriginCountryCode;
    property PackagePins: TFieldWrap read FPackagePins;
    property Packaging: TFieldWrap read FPackaging;
    property Price: TFieldWrap read FPrice;
    property CalcPriceR: TFieldWrap read FCalcPriceR;
    property Markup: TFieldWrap read FMarkup;
    property ProductID: TFieldWrap read FProductID;
    property ReleaseDate: TFieldWrap read FReleaseDate;
    property Retail: TFieldWrap read FRetail;
    property SaleCount: TFieldWrap read FSaleCount;
    property SaleD: TFieldWrap read FSaleD;
    property SaleE: TFieldWrap read FSaleE;
    property SaleR: TFieldWrap read FSaleR;
    property Seller: TFieldWrap read FSeller;
    property Storage: TFieldWrap read FStorage;
    property StoragePlace: TFieldWrap read FStoragePlace;
    property StorehouseId: TFieldWrap read FStorehouseId;
    property Value: TFieldWrap read FValue;
    property WholeSale: TFieldWrap read FWholeSale;
  end;

  TQueryProductsBase = class(TQryProductsBase0)
    procedure DataSourceDataChange(Sender: TObject; Field: TField);
    procedure FDQueryCalcFields(DataSet: TDataSet);
  private
    FAutoSaveFieldNameList: TList<String>;
    FBasket: TFDMemTable;
    FBasketW: TProductW;
    FCalcDic: TDictionary<Integer, Double>;
    FCalcExecCount: Integer;
    FCalcStatus: Integer;
    FCalcTimer: THRTimer;
    FDataChange: Boolean;
    FOnLocate: TNotifyEventsEx;
    FqSearchComponentGroup: TQuerySearchComponentGroup;
    FqSearchComponentOrFamily: TQuerySearchComponentOrFamily;
    FqSearchFamily: TQuerySearchFamily;
    FqSearchProduct: TQuerySearchProduct;
    FqSearchStorehouseProduct: TQuerySearchStorehouseProduct;
    FHRTimer: THRTimer;
    FID: Integer;
    FOnCommitUpdatePosted: Boolean;
    FProducersGroup: TProducersGroup2;
    FW: TProductW;

  class var
    FOnRubToDollarChange: TNotifyEventsEx;
    FRubToDollar: Boolean;
    procedure SetFieldValuesBeforePost;
    procedure DoAfterApplyUpdates(Sender: TObject);
    procedure DoAfterClose(Sender: TObject);
    procedure DoAfterInsert(Sender: TObject);
    procedure DoAfterOpen(Sender: TObject);
    procedure DoBeforeOpen(Sender: TObject);
    function GetqSearchComponentGroup: TQuerySearchComponentGroup;
    function GetqSearchComponentOrFamily: TQuerySearchComponentOrFamily;
    function GetqSearchFamily: TQuerySearchFamily;
    function GetqSearchProduct: TQuerySearchProduct;
    function GetqSearchStorehouseProduct: TQuerySearchStorehouseProduct;
    class procedure SetRubToDollar(const Value: Boolean); static;
    // TODO: SplitComponentName
    // function SplitComponentName(const S: string): TComponentNameParts;
    { Private declarations }
  protected
    procedure ApplyDelete(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure ApplyInsert(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure ApplyUpdate(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    function CreateDSWrap: TDSWrap; override;
    procedure DisableCalc;
    procedure DoBeforePost(Sender: TObject); virtual;
    procedure DoOnCalcFields; virtual;
    procedure DoOnCommitUpdates(var Message: TMessage);
      message WM_OnCommitUpdates;
    procedure EnableCalc;
    function GetDollarCource: Double; virtual;
    function GetEuroCource: Double; virtual;
    function GetHaveAnyChanges: Boolean; override;
    procedure InitFieldDefs; virtual;
    property CalcStatus: Integer read FCalcStatus;
    property ProducersGroup: TProducersGroup2 read FProducersGroup;
    property qSearchComponentGroup: TQuerySearchComponentGroup
      read GetqSearchComponentGroup;
    property qSearchComponentOrFamily: TQuerySearchComponentOrFamily
      read GetqSearchComponentOrFamily;
    property qSearchFamily: TQuerySearchFamily read GetqSearchFamily;
    property qSearchProduct: TQuerySearchProduct read GetqSearchProduct;
    property qSearchStorehouseProduct: TQuerySearchStorehouseProduct
      read GetqSearchStorehouseProduct;
  public
    constructor Create(AOwner: TComponent; AProducersGroup: TProducersGroup2);
      reintroduce; virtual;
    destructor Destroy; override;
    procedure ApplyMinWholeSale(AMinWholeSale: Double);
    procedure ApplyUpdates; override;
    procedure CancelUpdates; override;
    procedure ClearInternalCalcFields;
    procedure DeleteFromBasket(APKArray: TArray<Integer>);
    procedure DeleteNode(AID: Integer);
    procedure DeleteNotUsedProducts(AProductIDS: TList<Integer>);
    function HaveInsertedProducts: Boolean;
    function LocateInComponents: Boolean;
    procedure SaveExtraCharge(AIDExtraCharge: Integer; AWholeSale: Double);
    class procedure UpdateSaleCount(ASourceProductQry: TQueryProductsBase;
      AArray: TArray<TQueryProductsBase>); static;
    procedure UpdateFieldValue(AID: Integer; AFields: TArray<TField>;
      AValues: TArray<Variant>; AUpdatedIDList: TList<Integer>);
    class procedure UpdateAmount(ASourceProductQry: TQryProductsBase0;
      AArray: TArray<TQueryProductsBase>); static;
    property Basket: TFDMemTable read FBasket;
    property BasketW: TProductW read FBasketW;
    property CalcExecCount: Integer read FCalcExecCount write FCalcExecCount;
    class property OnRubToDollarChange: TNotifyEventsEx
      read FOnRubToDollarChange;
    class property RubToDollar: Boolean read FRubToDollar write SetRubToDollar;
    property W: TProductW read FW;
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
  ParameterValuesUnit, StrHelper, System.StrUtils, ProjectConst, System.Math,
  CurrencyUnit;

constructor TQueryProductsBase.Create(AOwner: TComponent;
  AProducersGroup: TProducersGroup2);
begin
  inherited Create(AOwner);
  Assert(AProducersGroup <> nil);
  FProducersGroup := AProducersGroup;

  FW := FDSWrap as TProductW;
  FOnLocate := TNotifyEventsEx.Create(Self);

  TNotifyEventWrap.Create(AfterApplyUpdates, DoAfterApplyUpdates,
    FDSWrap.EventList);
  TNotifyEventWrap.Create(W.AfterClose, DoAfterClose, W.EventList);
  TNotifyEventWrap.Create(W.AfterInsert, DoAfterInsert, W.EventList);
  TNotifyEventWrap.Create(W.AfterOpen, DoAfterOpen, W.EventList);
  TNotifyEventWrap.Create(W.BeforeOpen, DoBeforeOpen, W.EventList);
  TNotifyEventWrap.Create(W.BeforePost, DoBeforePost, W.EventList);

  // ������������ ������� � ��������� ������
  W.DataSource.OnDataChange := DataSourceDataChange;

  // ����� ���� ��������� ������
  FDQuery.OnUpdateRecord := DoOnQueryUpdateRecord;

  // ����� ���������� ��� ���������
  FDQuery.CachedUpdates := True;
  // FDQuery.UpdateOptions.AutoIncFields := W.PKFieldName;
  FDQuery.UpdateOptions.KeyFields := W.PKFieldName;

  FCalcStatus := 0;

  if FOnRubToDollarChange = nil then
  begin
    FOnRubToDollarChange := TNotifyEventsEx.Create(Self);
  end;

  FAutoSaveFieldNameList := TList<String>.Create;
  FAutoSaveFieldNameList.Add(W.SaleCount.FieldName.ToUpper);

  FHRTimer := THRTimer.Create(False);
  FCalcTimer := THRTimer.Create(True);
  FCalcDic := TDictionary<Integer, Double>.Create;

  FBasket := W.AddClone(Format('%s > 0', [W.SaleCount.FieldName]));
  FBasketW := TProductW.Create(FBasket);
end;

destructor TQueryProductsBase.Destroy;
begin
  if FBasket <> nil then
    W.DropClone(FBasket);

  FBasket := nil;

  // FreeAndNil(FOnDollarCourceChange);
  // FreeAndNil(FOnEuroCourceChange);

  FreeAndNil(FAutoSaveFieldNameList);

  FreeAndNil(FOnLocate);

  FreeAndNil(FHRTimer);
  FreeAndNil(FCalcTimer);
  FreeAndNil(FCalcDic);
  inherited;
end;

procedure TQueryProductsBase.ApplyDelete(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
var
  AProductIDS: TList<Integer>;
begin
  Assert(ASender = FDQuery);

  // ������ ����� ��������� ������� �� ������� � �������� ������
  AProductIDS := TList<Integer>.Create;
  try

    // ���� ��� ������
    if W.IsGroup.F.AsInteger = 1 then
    begin
      Assert(W.PK.Value > 0);
      // ���� ����� ������
      if qSearchComponentGroup.SearchByID(W.PK.Value) = 0 then
        Exit;

      // ������ ������� �� ����. ���� ������� � �������� ������ ��� ���������� ���� ������
      // ���� ���������� �� ������� ������, ������� ����������� ���� ������
      if qSearchStorehouseProduct.SearchByGroupID(W.StorehouseId.F.AsInteger,
        W.PK.Value) = 0 then
        Exit;

      // ������� � �������� ������ ��� ��������� ���������� ����������� � ������
      while qSearchStorehouseProduct.FDQuery.RecordCount > 0 do
      begin
        // ����������, ��� ���� ������� �� ������� �� ������
        if AProductIDS.IndexOf
          (qSearchStorehouseProduct.W.ProductID.F.AsInteger) < 0 then
          AProductIDS.Add(qSearchStorehouseProduct.W.ProductID.F.AsInteger);

        qSearchStorehouseProduct.FDQuery.Delete;
      end;

      // DeleteNotUsedProducts(AProductIDS);
    end
    else
    begin
      Assert(W.PK.Value < W.VirtualIDOffset);
      if qSearchStorehouseProduct.SearchByID
        (W.GetStorehouseProductID(W.PK.Value)) = 0 then
        Exit;

      AProductIDS.Add(W.ProductID.F.AsInteger);

      // ������� ������� �� ������. ��� ������� �� �������.
      qSearchStorehouseProduct.FDQuery.Delete;

      // ������� ���������������� ��������
      // DeleteNotUsedProducts(AProductIDS);
    end;
  finally
    FreeAndNil(AProductIDS);
  end;

  inherited;
end;

procedure TQueryProductsBase.ApplyInsert(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
var
  ARH: TRecordHolder;
  rc: Integer;
begin
  Assert(ASender = FDQuery);

  // ���� ���� ��������� ������ ������
  if W.IsGroup.F.AsInteger = 1 then
  begin
    // ���� ����� ������ ����������� � �����������
    rc := qSearchComponentGroup.SearchByValue(W.Value.F.AsString);
    if rc = 0 then
      qSearchComponentGroup.Append(W.Value.F.AsString);

    // ��������� ��������� ����
    FetchFields([W.PK.FieldName], [qSearchComponentGroup.W.PK.Value], ARequest,
      AAction, AOptions);
    // PK.Value := qSearchComponentGroup.PK.Value;
    Exit;
  end;

  ARH := TRecordHolder.Create(ASender);
  try
    // ���� ������ �������� ��� ���
    if W.ProductID.F.IsNull then
    begin
      // ��������� � ���� ��� �������
      qSearchProduct.W.InsertRecord(ARH);
      // ���������� ��� ��������
      ARH.Field[W.ProductID.FieldName] := qSearchProduct.W.PK.Value;
    end;

    // �������� ��� ��������� �� �����
    if not qSearchStorehouseProduct.FDQuery.Active then
      qSearchStorehouseProduct.SearchByID(1);

    qSearchStorehouseProduct.W.InsertRecord(ARH);

    // ��������� ���� � ��� - ������������� ������ "�������-�����" � ������������� ���������
    // ���������� ��������� ����
    ARH.Field[W.PK.FieldName] := W.GetStorehouseProductVirtualID
      (qSearchStorehouseProduct.W.PK.Value);

    FetchFields(ARH, ARequest, AAction, AOptions);
  finally
    FreeAndNil(ARH);
  end;

  inherited;
end;

procedure TQueryProductsBase.ApplyMinWholeSale(AMinWholeSale: Double);
var
  AClone: TFDMemTable;
  AProductW: TProductW;
  ARecNo: Integer;
begin
  Assert(AMinWholeSale >= 0);
  Assert(FDQuery.CachedUpdates);

  AClone := W.AddClone('');
  try
    AProductW := TProductW.Create(AClone);
    AClone.FilterChanges := [rtInserted];
    AClone.Filter := Format('%s=0', [W.IsGroup.FieldName]);
    AClone.Filtered := True;
    AClone.First;
    ARecNo := AClone.RecNo;
    while not AClone.Eof do
    begin
      AProductW.TryEdit;
      AProductW.MinWholeSale.F.AsFloat := AMinWholeSale;
      AProductW.TryPost;

      AClone.RecNo := ARecNo;
      // �� ������ ����������� �������� ������ ��� ����������
      // Assert(ARecNo = AClone.RecNo);

      AClone.Next;
      ARecNo := AClone.RecNo;
    end;
  finally
    W.DropClone(AClone);
  end;
end;

procedure TQueryProductsBase.ApplyUpdate(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
var
  ARH: TRecordHolder;
begin
  Assert(ASender = FDQuery);

  ARH := TRecordHolder.Create(ASender);
  try
    if W.IsGroup.F.AsInteger = 1 then
    begin
      Assert(W.PK.Value > 0);
      // ���� ����� ������
      if qSearchComponentGroup.SearchByID(W.PK.Value) = 0 then
        Exit;

      // ����� ��������� ���� ����
      ARH.Clear;
      TFieldHolder.Create(ARH, qSearchComponentGroup.W.ComponentGroup.FieldName,
        W.Value.F.AsString);

      qSearchComponentGroup.W.UpdateRecord(ARH);
    end
    else
    begin
      Assert(W.PK.Value < 0);
      // ���� �� �������������� ������ �����-�������
      qSearchStorehouseProduct.SearchByID(W.GetStorehouseProductID(W.PK.Value));

      // ��������� ���������� � ���������� �� ������
      qSearchStorehouseProduct.W.UpdateRecord(ARH);

      // ��������� ���������� � ����� ����������
      qSearchProduct.SearchByID(W.ProductID.F.AsInteger);
      qSearchProduct.W.UpdateRecord(ARH);
    end;
  finally
    FreeAndNil(ARH);
  end;

  inherited;
end;

procedure TQueryProductsBase.ApplyUpdates;
begin
  Assert(FDQuery.CachedUpdates);
  // �������� �� �������� ������������� � ������ ����� � ���������� ��� ��������!!!
  // Assert(not FDQuery.Connection.InTransaction);

  W.TryPost;

  // ���� ������ ���������
  if (not FDQuery.Connection.InTransaction) and (FDQuery.ChangeCount = 0) then
  begin
    FDataChange := False;
    Exit;
  end;

  // ���� � ���� ���������� �� ���� ������
  if FDQuery.ApplyUpdates() = 0 then
  begin
    FDQuery.CommitUpdates;

    // �������� �� �������� ������������� � ������ ����� � ���������� ��� ��������!!!
    if FDQuery.Connection.InTransaction then
      FDQuery.Connection.Commit;

    FDataChange := False;

    Assert(not FDQuery.UpdatesPending);
    Assert(FDQuery.ChangeCount = 0);

    // �������� ���� ��� CommitUpdates ���������!
    TryCallAfterCommitUpdatesEvent;
  end;
end;

procedure TQueryProductsBase.CancelUpdates;
begin
  Assert(FDQuery.CachedUpdates);
  // Assert(not FDQuery.Connection.InTransaction);
  FDataChange := False;

  // �������� ��������� ��������� � ������� ������ �� ������� �������
  W.TryCancel;

  // ���� � ������ ������� ���� ��� ���������
  if (FDQuery.ChangeCount = 0) and (not FDQuery.Connection.InTransaction) then
    Exit;

  W.SaveBookmark;
  FDQuery.DisableControls;
  try
    // ��� �������� ���������� ������ ���� ��������� � �������� ���� �� ����
    inherited;

    // ���� ���������� ��-���� ���� ������
    if FDQuery.Connection.InTransaction then
    begin
      FDQuery.Connection.Rollback;
      W.RefreshQuery;
    end;

    FProducersGroup.ReOpen;

    W.RestoreBookmark;
  finally
    FDQuery.EnableControls;
  end;
end;

procedure TQueryProductsBase.SetFieldValuesBeforePost;
var
  rc: Integer;
begin
  // ���� ������������� �����
  if W.IDProducer.F.AsInteger > 0 then
  begin
    // ���� ������������� �� ����
    FProducersGroup.qProducers.W.LocateByPK(W.IDProducer.F.AsInteger, True);

    // ���� ��������� � ������������� ���� ������
    rc := qSearchComponentOrFamily.SearchComponentWithProducer
      (W.Value.F.AsString, FProducersGroup.qProducers.W.Name.F.AsString);
  end
  else
  begin
    // ���� � ������������� ���� ������ �� ������������
    rc := qSearchComponentOrFamily.SearchComponentWithProducer
      (W.Value.F.AsString);
    if rc > 0 then
    begin
      // ���� � ����������� ������ �������������
      FProducersGroup.qProducers.Locate
        (qSearchComponentOrFamily.W.Producer.F.AsString, True);

      // ��������� ���� "��� �������������"
      W.IDProducer.F.Value := FProducersGroup.qProducers.W.PK.Value;
    end;
  end;

  // ����������, ���� �� ���� ��������� � ������������� ����
  W.Checked.F.AsInteger := IfThen(rc > 0, 1, 0);

  // ���� ����� ��������� ������ � ����������� ����
  if rc > 0 then
  begin
    // ���� ��������������� ��������� �����������
    qSearchFamily.SearchByID(qSearchComponentOrFamily.W.ParentProductID.F.
      AsInteger, 1);

    // ��������� ������ ���� �� ���������� ����������
    UpdateFields([W.Datasheet.F, W.Diagram.F, W.Drawing.F, W.Image.F,
      W.DescriptionID.F, W.DescriptionComponentName.F, W.Description.F],
      [qSearchFamily.W.Datasheet.F.Value, qSearchFamily.W.Diagram.F.Value,
      qSearchFamily.W.Drawing.F.Value, qSearchFamily.W.Image.F.Value,
      qSearchFamily.W.DescriptionID.F.Value,
      qSearchFamily.W.DescriptionComponentName.F.Value,
      qSearchFamily.W.Description.F.Value], True);
  end;
end;

procedure TQueryProductsBase.ClearInternalCalcFields;
var
  AClone: TFDMemTable;
  ACloneW: TProductW;
  ARecNo: Integer;
begin
  Assert(not HaveAnyNotCommitedChanges);

  AClone := W.AddClone('');
  ACloneW := TProductW.Create(AClone);
  try
    // ��������� �� ��������������
    // AClone.IndexFieldNames := ACloneW.ID.FieldName + ':D';
    AClone.First;
    while not AClone.Eof do
    begin
      if ACloneW.IsGroup.F.AsInteger = 0 then
      begin
        ACloneW.TryEdit;
        ACloneW.IDExtraCharge.F.Clear; // - �������� � ��
        ACloneW.IDExtraChargeType.F.Clear; // - �������� � ��
        ACloneW.WholeSale.F.Clear; // ������� ������� - �������� � ��
        ACloneW.SaleCount.F.Clear; // ���-�� ������ - �������� � ��
        ARecNo := ACloneW.DataSet.RecNo;
        ACloneW.TryPost;
        ACloneW.DataSet.RecNo := ARecNo;

        // ��������� � ��
        ApplyUpdates;
      end;
      AClone.Next;
    end;
  finally
    W.DropClone(AClone);
  end;
end;

function TQueryProductsBase.CreateDSWrap: TDSWrap;
begin
  Result := TProductW.Create(FDQuery);
end;

procedure TQueryProductsBase.DataSourceDataChange(Sender: TObject;
  Field: TField);
var
  ADS: TDataSource;
begin
  inherited;
  Assert(FDQuery.CachedUpdates);
  Assert(FAutoSaveFieldNameList <> nil);
  Assert(FAutoSaveFieldNameList.Count > 0);

  // ���� ��� ���� ������������� ���������
  if (FDQuery.ChangeCount > 0) or (FDataChange) then
    Exit;

  ADS := Sender as TDataSource;

  // ���� ������ ���������� �������������� ��� �������
  if (ADS.DataSet.State in [dsInsert, dsEdit]) and (Field <> nil) then
  begin
    // ���� ���������� ������ ����������� ���� ��� ���� ���-�� ������
    if (Field.FieldKind = fkCalculated) or (Field.FieldKind = fkInternalCalc) or
      (FAutoSaveFieldNameList.IndexOf(Field.FieldName.ToUpper) >= 0) then
    begin
      if (FAutoSaveFieldNameList.IndexOf(Field.FieldName.ToUpper) >= 0) and
        (not FOnCommitUpdatePosted) then
      begin
        FOnCommitUpdatePosted := True;
        PostMessage(Handle, WM_OnCommitUpdates, 0, 0);
      end;
      // FDQuery.CommitUpdates;
    end
    else
      FDataChange := True; // ���������� �����-�� ������ ����
  end;
end;

procedure TQueryProductsBase.DeleteFromBasket(APKArray: TArray<Integer>);
var
  APK: Integer;
begin
  Assert(Length(APKArray) > 0);

  FDQuery.DisableControls;
  try
    for APK in APKArray do
    begin
      BasketW.LocateByPK(APK);
      BasketW.SetSaleCount(0);
    end;

    ApplyUpdates;
  finally
    FDQuery.EnableControls;
  end;
end;

procedure TQueryProductsBase.DeleteNode(AID: Integer);
var
  AClone: TFDMemTable;
begin
  // FDQuery.DisableControls;
  try
    // ���� ������ ������� ���� �������
    if not W.LocateByPK(AID) then
      Exit; // �������� ������ ������� ������ � ��������� ������

    // ���� ����� ������� ������
    if W.IsGroup.F.AsInteger = 1 then
    begin
      AClone := W.AddClone(Format('%s=%d', [W.IDComponentGroup.FieldName,
        W.PK.AsInteger]));
      try
        // ������� ��� ���������� ������
        while AClone.RecordCount > 0 do
          DeleteNode(AClone.FieldByName('ID').AsInteger);

      finally
        W.DropClone(AClone);
      end;

      // ����� ��������� �� ������
      W.LocateByPK(AID, True);
    end;
    FDQuery.Delete;
  finally
    // FDQuery.EnableControls;
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
    if qSearchStorehouseProduct.SearchByProductID(AProductID) = 0 then
    begin
      // ������� �������
      if qSearchProduct.SearchByID(AProductID) > 0 then
        qSearchProduct.FDQuery.Delete;
    end;
  end;
end;

procedure TQueryProductsBase.DisableCalc;
begin
  Inc(FCalcStatus);
end;

procedure TQueryProductsBase.DoAfterApplyUpdates(Sender: TObject);
begin
  FDataChange := False;
end;

procedure TQueryProductsBase.DoAfterClose(Sender: TObject);
begin
  // This forces "description" field to become of UInt32 data type.
  // Kind of a hole / bug in FireDAC.
  FDQuery.UpdateOptions.AutoIncFields := '';
end;

procedure TQueryProductsBase.DoAfterInsert(Sender: TObject);
begin
  Inc(FID);
  W.ID.F.AsInteger := -FID;
end;

procedure TQueryProductsBase.DoAfterOpen(Sender: TObject);
begin
  // This forces "description" field to become of UInt32 data type.
  // Kind of a hole / bug in FireDAC.
  FDQuery.UpdateOptions.AutoIncFields := W.PKFieldName;
end;

procedure TQueryProductsBase.DoBeforeOpen(Sender: TObject);
begin;
  InitFieldDefs;
  W.CreateDefaultFields(False);
  W.InitFields;
  FDataChange := False;
end;

procedure TQueryProductsBase.DoBeforePost(Sender: TObject);
var
  AErrorMessage: String;
  // rc: Integer;
begin
  if FDQuery.State = dsEdit then
  begin
    // ��������� ��� ���� ���-�� ������ <= ���� ���-��
    AErrorMessage := W.CheckEditingRecord;
    if not AErrorMessage.IsEmpty then
    begin
      W.SaleCount.F.Value := W.SaleCount.F.OldValue;
      raise Exception.Create(AErrorMessage);
    end;

    // ������� ��������� �������� ����� �� ������������� ����
    SetFieldValuesBeforePost;
  end;

  // ���� �� ���������� ������� ����� ������
  if not(FDQuery.State in [dsInsert]) then
    Exit;

  Assert(not W.IsGroup.F.IsNull);

  // ��� ������, ���� ��������� �� ����
  if W.IsGroup.F.AsInteger = 1 then
    Exit;

  // ��������� ������ �� ������� ������
  AErrorMessage := W.CheckInsertingRecord;
  if not AErrorMessage.IsEmpty then
    raise Exception.Create(AErrorMessage);

  // ��������� ���� ��������, ���� ��� ������
  if W.LoadDate.F.IsNull then
    W.LoadDate.F.AsString := FormatDateTime('dd.mm.yyyy', Date);;

  // �������� ���� ������� �� ���� ��������
  if (W.Dollar.F.IsNull) then
    try
      W.Dollar.F.AsFloat := TMyCurrency.Create.GetCourses(2,
        W.LoadDate.F.AsDateTime);
    except
      ; // � ������ ������, ��������� ���� ������
    end;

  // �������� ���� ���� �� ���� ��������
  if (W.Euro.F.IsNull) then
    try
      W.Euro.F.AsFloat := TMyCurrency.Create.GetCourses(3,
        W.LoadDate.F.AsDateTime);;
    except
      ; // � ������ ������, ��������� ���� ������
    end;

  // ������� ��������� �������� ����� �� ������������� ����
  SetFieldValuesBeforePost;

  // ������������ �� ������ ������������� �� ������������
  (*
    // ���� ������������� �� �����
    if W.IDProducer.F.IsNull or (W.IDProducer.F.AsInteger = 0) then
    begin
    // ���� ����� ��������� � ����� ������ �� ������
    rc := qSearchProduct.SearchByValue(W.Value.F.AsString);
    if rc > 0 then
    // ��������� ��� �������������
    W.IDProducer.F.Value := qSearchProduct.W.IDProducer.F.Value
    else
    raise Exception.Create('���������� ������ �������������');
    end;
  *)
  // ���� ����� ������� � ��� �� ��������������
  // ���� ����� ������� ��� ����
  if qSearchProduct.SearchByValue(W.Value.F.AsString,
    W.IDProducer.F.AsInteger) > 0 then
  begin
    // ��������� ������ ���� �� ���������� ��������
    UpdateFields([W.Datasheet.F, W.Diagram.F, W.Drawing.F, W.Image.F,
      W.DescriptionID.F, W.ProductID.F], [qSearchProduct.W.Datasheet.F.Value,
      qSearchProduct.W.Diagram.F.Value, qSearchProduct.W.Drawing.F.Value,
      qSearchProduct.W.Image.F.Value, qSearchProduct.W.DescriptionID.F.Value,
      qSearchProduct.W.PK.Value], True);
  end;

  // ���� ��� ������ ����� - ������ �� �������������
  if not W.IDCurrency.F.IsNull then
    Exit;

  // ��������� ���� ������� ����������� �����
  DisableCalc;
  try
    // ���� ��������� ���������� ���� � ������
    if not W.PriceR.F.IsNull then
    begin
      W.Price.F.Value := W.PriceR.F.Value;
      W.IDCurrency.F.AsInteger := 1;
    end;

    // ���� ��������� ���������� ���� � ��������
    if not W.PriceD.F.IsNull then
    begin
      W.Price.F.Value := W.PriceD.F.Value;
      W.IDCurrency.F.AsInteger := 2;
    end;

    // ���� ��������� ���������� ���� � ����
    if not W.PriceE.F.IsNull then
    begin
      W.Price.F.Value := W.PriceE.F.Value;
      W.IDCurrency.F.AsInteger := 3;
    end;

  finally
    // ���� ������������� ������, �� ��������� �������������� ����������� �����
    EnableCalc;
  end;
end;

procedure TQueryProductsBase.DoOnCalcFields;
var
  ADCource: Double;
  APriceR: Double;
  AWholeSale: Double;
begin
  inherited;

  if (FCalcStatus > 0) or (W.IDCurrency.F.AsInteger = 0) or (W.Price.F.IsNull)
  then
    Exit;
  // ������������ � ������ �������
  ADCource := GetDollarCource;

  APriceR := 0;
  // ���� ���������� ���� ���� � ������
  if W.IDCurrency.F.AsInteger = 1 then
  begin
    // *************************************************************************
    // ���������� ����
    // *************************************************************************
    W.PriceR.F.Value := W.Price.F.Value;

    // ����������� ���������� ���� � �������� �� ����� �� ������ �������
    if W.Dollar.F.AsFloat > 0 then
      W.PriceD.F.Value := W.Price.F.AsFloat / W.Dollar.F.AsFloat
    else
      W.PriceD.F.Value := NULL;

    // ����������� ���������� ���� � ���� �� ����� �� ������ �������
    if W.Euro.F.AsFloat > 0 then
      W.PriceE.F.Value := W.Price.F.AsFloat / W.Euro.F.AsFloat
    else
      W.PriceE.F.Value := NULL;

    // ���������� ���� � ������. ��� ��������� ���� �������� ����� RubToDollar
    APriceR := W.PriceR.F.AsFloat;

    // *************************************************************************
    // ��������� ����
    // *************************************************************************
    // ���� ���� ������� ����� � �� ����� ����������� ���������� ���� �� ������ �����
    if RubToDollar and (ADCource > 0) and (W.Dollar.F.AsFloat > 0) and
      (ADCource > W.Dollar.F.AsFloat) then
      // ���������� ���� � �������� �� ������ ������� ��������� � ����� �� ������������ �����
      APriceR := W.PriceD.F.Value * ADCource;
  end;

  // ���� �������� ���� ���� � ��������
  if W.IDCurrency.F.AsInteger = 2 then
  begin
    // ����������� ���� � ������ �� ����� ������� �� ������ �������
    if W.Dollar.F.AsFloat > 0 then
      W.PriceR.F.Value := W.Price.F.Value * W.Dollar.F.AsFloat
    else
      W.PriceR.F.Value := NULL;

    W.PriceD.F.Value := W.Price.F.Value;

    if (W.Dollar.F.AsFloat > 0) and (W.Euro.F.AsFloat > 0) then
      W.PriceE.F.Value := W.Price.F.Value * W.Dollar.F.AsFloat /
        W.Euro.F.AsFloat
    else
      W.PriceE.F.Value := NULL;

    // ���������� ���� � ������.
    APriceR := W.PriceR.F.AsFloat;
  end;

  // ���� �������� ���� ���� � ����
  if W.IDCurrency.F.AsInteger = 3 then
  begin
    // ����������� ���� � ������ �� ����� ���� �� ������ �������
    if W.Euro.F.AsFloat > 0 then
      W.PriceR.F.Value := W.Price.F.Value * W.Euro.F.AsFloat
    else
      W.PriceR.F.Value := NULL;

    if (W.Dollar.F.AsFloat > 0) and (W.Euro.F.AsFloat > 0) then
      W.PriceD.F.Value := W.Price.F.Value * W.Euro.F.AsFloat /
        W.Dollar.F.AsFloat
    else
      W.PriceD.F.Value := NULL;

    W.PriceE.F.Value := W.Price.F.Value;

    // ���������� ���� � ������.
    APriceR := W.PriceR.F.AsFloat;
  end;

  // ���������� ���������� ���� � ������ � ������ ���������� ��������� ����� �������
  W.CalcPriceR.F.AsFloat := APriceR;

  // ��������� ���� � ������
  W.PriceR1.F.Value := APriceR * (1 + W.Retail.F.Value / 100);
  // ��������� ���� � ��������
  W.PriceD1.F.Value := W.PriceD.F.Value * (1 + W.Retail.F.Value / 100);
  // ��������� ���� � ����
  W.PriceE1.F.Value := W.PriceE.F.Value * (1 + W.Retail.F.Value / 100);

  AWholeSale := W.WholeSale.F.AsFloat;

  // ���� ������� ������� �� ������ ���� ����������� ������� �������
  if AWholeSale = 0 then
    // ���� ����������� ������� ������� ������
    if not W.MinWholeSale.F.IsNull then
      AWholeSale := W.MinWholeSale.F.Value;

  // ���� ������� ������� ���������
  if AWholeSale > 0 then
  begin
    // ������� ���� � ������
    W.PriceR2.F.Value := APriceR * (1 + AWholeSale / 100);
    // ������� ���� � ��������
    W.PriceD2.F.Value := W.PriceD.F.Value * (1 + AWholeSale / 100);
    // ������� ���� � ����
    W.PriceE2.F.Value := W.PriceE.F.Value * (1 + AWholeSale / 100);
  end
  else
  begin
    W.PriceR2.F.Value := NULL;
    W.PriceD2.F.Value := NULL;
    W.PriceE2.F.Value := NULL;
  end;

  // ���� ������� ���������� ������
  if W.SaleCount.F.AsFloat > 0 then
  begin
    if (W.SaleCount.F.AsFloat <= 1) or (AWholeSale = 0) then
    begin
      // ���������� ������� 1 ��. - ���������� ��������� ����
      W.SaleR.F.Value := W.PriceR1.F.Value;
      W.SaleD.F.Value := W.PriceD1.F.Value;
      W.SaleE.F.Value := W.PriceE1.F.Value;
      // ����������, ��� ��������� ���� - ��� ��������� ����
      W.Markup.F.Value := W.Retail.F.Value;
    end
    else
    begin
      // ����� - ������� ����
      W.SaleR.F.Value := W.PriceR2.F.AsFloat * W.SaleCount.F.AsFloat;
      W.SaleD.F.Value := W.PriceD2.F.AsFloat * W.SaleCount.F.AsFloat;
      W.SaleE.F.Value := W.PriceE2.F.AsFloat * W.SaleCount.F.AsFloat;
      // ����������, ��� ��������� ���� - ��� ������� ����
      W.Markup.F.Value := AWholeSale;
    end;
  end
  else
  begin
    W.SaleR.F.Value := NULL;
    W.SaleD.F.Value := NULL;
    W.SaleE.F.Value := NULL;
  end;
end;

procedure TQueryProductsBase.DoOnCommitUpdates(var Message: TMessage);
begin
  inherited;
  // ���� ���������� ������ ����������� ���� ��� ���������� ������, �� ��������� ��������� ��������� �����!
  FOnCommitUpdatePosted := False;
  ApplyUpdates;
end;

procedure TQueryProductsBase.EnableCalc;
begin
  Assert(FCalcStatus > 0);
  Dec(FCalcStatus);
  if FCalcStatus = 0 then
    FDQueryCalcFields(FDQuery);
end;

procedure TQueryProductsBase.FDQueryCalcFields(DataSet: TDataSet);
begin
  inherited;
  DoOnCalcFields;
end;

function TQueryProductsBase.GetDollarCource: Double;
begin
  Result := 1;
  // ���� ����� ���� �� ����������� ����
  if DollarCource > 0 then
    Result := DollarCource
  else
    // ���� �������� ���� �� ���� �������
    if W.Dollar.F.AsFloat > 0 then
      Result := W.Dollar.F.AsFloat;
end;

function TQueryProductsBase.GetEuroCource: Double;
begin
  Result := 1;
  if EuroCource > 0 then
    Result := EuroCource
  else
    // ���� �������� ���� �� ���� �������
    if W.Euro.F.AsFloat > 0 then
      Result := W.Euro.F.AsFloat;
end;

// ����-�� ��������� �� ����������� � ��
function TQueryProductsBase.GetHaveAnyChanges: Boolean;
begin
  // � ��� ��� ��������� ���������� �� ������� �������
  Assert(FDQuery.CachedUpdates);

  Result := (FDQuery.ChangeCount > 0) or (FDataChange);
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

function TQueryProductsBase.GetqSearchComponentOrFamily
  : TQuerySearchComponentOrFamily;
begin
  if FqSearchComponentOrFamily = nil then
    FqSearchComponentOrFamily := TQuerySearchComponentOrFamily.Create(Self);

  Result := FqSearchComponentOrFamily;
end;

function TQueryProductsBase.GetqSearchFamily: TQuerySearchFamily;
begin
  if FqSearchFamily = nil then
    FqSearchFamily := TQuerySearchFamily.Create(Self);
  Result := FqSearchFamily;
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

function TQueryProductsBase.HaveInsertedProducts: Boolean;
var
  AClone: TFDMemTable;
begin
  Assert(FDQuery.CachedUpdates);
  AClone := W.AddClone('');
  try
    AClone.FilterChanges := [rtInserted];
    AClone.Filter := Format('%s=0', [W.IsGroup.FieldName]);
    AClone.Filtered := True;
    Result := AClone.RecordCount > 0;
  finally
    W.DropClone(AClone);
  end;
end;

procedure TQueryProductsBase.InitFieldDefs;
begin
  if FDQuery.FieldDefs.Count > 0 then
  begin
    FDQuery.FieldDefs.Clear;
    FDQuery.Fields.Clear;
  end;
  FDQuery.FieldDefs.Update;

  // ��������� ���� � ������ � ������ �������� �� ���� ����� �������
  FDQuery.FieldDefs.Add(W.CalcPriceR.FieldName, ftFloat);

  // ������� ������� ������������ ��� �������
  FDQuery.FieldDefs.Add(W.Markup.FieldName, ftFloat);

  // ���������� ����
  FDQuery.FieldDefs.Add(W.PriceR.FieldName, ftFloat);
  FDQuery.FieldDefs.Add(W.PriceD.FieldName, ftFloat);
  FDQuery.FieldDefs.Add(W.PriceE.FieldName, ftFloat);

  // ��������� ����
  FDQuery.FieldDefs.Add(W.PriceR1.FieldName, ftFloat);
  FDQuery.FieldDefs.Add(W.PriceD1.FieldName, ftFloat);
  FDQuery.FieldDefs.Add(W.PriceE1.FieldName, ftFloat);

  // ������� ����
  FDQuery.FieldDefs.Add(W.PriceR2.FieldName, ftFloat);
  FDQuery.FieldDefs.Add(W.PriceD2.FieldName, ftFloat);
  FDQuery.FieldDefs.Add(W.PriceE2.FieldName, ftFloat);

  // ��������� ����
  FDQuery.FieldDefs.Add(W.SaleR.FieldName, ftFloat);
  FDQuery.FieldDefs.Add(W.SaleD.FieldName, ftFloat);
  FDQuery.FieldDefs.Add(W.SaleE.FieldName, ftFloat);
end;

function TQueryProductsBase.LocateInComponents: Boolean;
var
  AIDCategory: Integer;
  rc: Integer;
  LR: TLocateObject;
  m: TArray<String>;
begin
  rc := 0;
  // ���� ������������� �����
  if W.IDProducer.F.AsInteger > 0 then
  begin
    // ���� ������������� �� ����
    FProducersGroup.qProducers.W.LocateByPK(W.IDProducer.F.AsInteger, True);

    rc := qSearchComponentOrFamily.SearchComponentWithProducer
      (W.Value.F.AsString, FProducersGroup.qProducers.W.Name.F.AsString);
  end;
  if rc > 0 then
  begin
    // ���� ��������������� ��������� �����������
    rc := qSearchFamily.SearchByID
      (qSearchComponentOrFamily.W.ParentProductID.F.AsInteger);

  end;
  Result := rc > 0;

  if Result then
  begin
    m := qSearchFamily.W.CategoryIDList.F.AsString.Split([',']);
    Assert(Length(m) > 0);

    AIDCategory := String.ToInteger(m[0]);

    LR := TLocateObject.Create(AIDCategory, qSearchFamily.W.Value.F.AsString,
      qSearchComponentOrFamily.W.Value.F.AsString);
    try
      OnLocate.CallEventHandlers(LR);
    finally
      FreeAndNil(LR);
    end;

  end;
end;

procedure TQueryProductsBase.SaveExtraCharge(AIDExtraCharge: Integer;
    AWholeSale: Double);
begin
//  Assert(ExtraChargeGroup.qExtraCharge2.FDQuery.RecordCount > 0);
  W.TryEdit;
  W.IDExtraCharge.F.AsInteger := AIDExtraCharge;
   (*ExtraChargeGroup.qExtraCharge2.W.PK.AsInteger;*)

  // ������ ������� ������� �������
  W.WholeSale.F.Value := AWholeSale;(*ExtraChargeGroup.qExtraCharge2.W.WholeSale.F.Value;*)
  W.TryPost;
end;

class procedure TQueryProductsBase.SetRubToDollar(const Value: Boolean);
begin
  if FRubToDollar = Value then
    Exit;

  FRubToDollar := Value;
  FOnRubToDollarChange.CallEventHandlers(nil);
end;

class procedure TQueryProductsBase.UpdateSaleCount(ASourceProductQry
  : TQueryProductsBase; AArray: TArray<TQueryProductsBase>);
var
  AFDUpdateRecordTypes: TFDUpdateRecordTypes;
  AFieldName: string;
  AFieldValues: TDictionary<String, Variant>;
  AFiltered: Boolean;
  AQryProductsBase: TQueryProductsBase;
  F: TField;
begin
  // �������� � ������ !!!
  AFDUpdateRecordTypes := ASourceProductQry.Basket.FilterChanges;
  AFiltered := ASourceProductQry.Basket.Filtered;

  // ������������ ���������� � ������� ������
  ASourceProductQry.Basket.FilterChanges := [rtModified];
  ASourceProductQry.Basket.Filtered := False;
  ASourceProductQry.Basket.First;

  AFieldValues := TDictionary<String, Variant>.Create;
  try
    while not ASourceProductQry.Basket.Eof do
    begin
      // ������� ������ ������������ �����
      AFieldValues.Clear;
      // ���� �� ���� ����� �������
      for F in ASourceProductQry.Basket.Fields do
      begin
        // ���� � ������� ���������� �����-�� ����
        if (F.FieldKind = fkData) and (F.OldValue <> F.Value) then
          AFieldValues.Add(F.FieldName, F.Value);
      end;

      // ���� � ������� ���������� ���� ���� ����
      if AFieldValues.Count > 0 then
      begin
        for AQryProductsBase in AArray do
        begin
          AQryProductsBase.Basket.Filtered := False;
          if AQryProductsBase.BasketW.LocateByPK
            (ASourceProductQry.BasketW.PK.AsInteger) then
          begin
            AQryProductsBase.BasketW.TryEdit;
            for AFieldName in AFieldValues.Keys do
              AQryProductsBase.BasketW.Field(AFieldName).Value :=
                AFieldValues[AFieldName];
            AQryProductsBase.BasketW.TryPost;
          end;
        end;
      end;

      ASourceProductQry.Basket.Next;
    end;
  finally
    FreeAndNil(AFieldValues);
  end;

  // ������������ �������� �� ������� ������
  ASourceProductQry.Basket.FilterChanges := [rtDeleted];
  ASourceProductQry.Basket.First;
  while not ASourceProductQry.Basket.Eof do
  begin
    for AQryProductsBase in AArray do
    begin
      AQryProductsBase.Basket.Filtered := False;
      if AQryProductsBase.BasketW.LocateByPK
        (ASourceProductQry.BasketW.PK.AsInteger) then
        AQryProductsBase.BasketW.SetSaleCount(0);
    end;
    ASourceProductQry.Basket.Next;
  end;

  // ������������ ����������� � ������� ������
  ASourceProductQry.Basket.FilterChanges := [rtInserted];
  ASourceProductQry.Basket.First;
  while not ASourceProductQry.Basket.Eof do
  begin
    for AQryProductsBase in AArray do
    begin
      AQryProductsBase.Basket.Filtered := False;
      if AQryProductsBase.BasketW.LocateByPK
        (ASourceProductQry.BasketW.PK.AsInteger) then
        AQryProductsBase.BasketW.SetSaleCount
          (ASourceProductQry.BasketW.SaleCount.F.AsFloat);
    end;
    ASourceProductQry.Basket.Next;
  end;

  ASourceProductQry.Basket.Filtered := AFiltered;
  ASourceProductQry.Basket.FilterChanges := AFDUpdateRecordTypes;

  for AQryProductsBase in AArray do
  begin
    // ���������� ������� �� �������
    AQryProductsBase.Basket.Filtered := True;
    // ������� ��� ���������, �� �������� �� �� ������
    AQryProductsBase.FDQuery.CommitUpdates;
  end;
end;

procedure TQueryProductsBase.UpdateFieldValue(AID: Integer;
  AFields: TArray<TField>; AValues: TArray<Variant>;
  AUpdatedIDList: TList<Integer>);
var
  AClone: TFDMemTable;
  I: Integer;
begin
  Assert(AID <> 0);

  Assert(Length(AFields) > 0);
  Assert(Length(AFields) = Length(AValues));

  // ���� ������ � ���� ��������������� ��� ���������
  if AUpdatedIDList.IndexOf(AID) >= 0 then
    Exit;

  W.LocateByPK(AID, True);

  // ���� �������� ��������� ����������� � ������
  if W.IsGroup.F.AsInteger = 1 then
  begin
    AClone := W.AddClone(Format('%s=%d', [W.IDComponentGroup.FieldName,
      W.PK.AsInteger]));
    try
      AClone.First;
      while not AClone.Eof do
      begin
        UpdateFieldValue(AClone.FieldByName('ID').AsInteger, AFields, AValues,
          AUpdatedIDList);
        AClone.Next;
      end;
    finally
      W.DropClone(AClone);
    end;
  end
  else
  begin
    W.TryEdit;
    for I := Low(AFields) to High(AFields) do
      AFields[I].Value := AValues[I];
    W.TryPost;

    AUpdatedIDList.Add(AID);
  end;
end;

class procedure TQueryProductsBase.UpdateAmount(ASourceProductQry
  : TQryProductsBase0; AArray: TArray<TQueryProductsBase>);
var
  AClone: TFDMemTable;
  AQryProductsBase: TQueryProductsBase;
  Wr: TBaseProductsW;
begin
  // �������� � ������ !!!
  AClone := ASourceProductQry.Wrap.AddClone('');
  Wr := TBaseProductsW.Create(AClone);
  try
    // ������������ ���������� � ����� ������
    AClone.FilterChanges := [rtModified];
    AClone.Filtered := False;
    AClone.First;
    while not AClone.Eof do
    begin
      // ���� � ��������� ���������� ���-��
      if Wr.Amount.F.OldValue <> Wr.Amount.F.Value then
      begin
        for AQryProductsBase in AArray do
        begin
          AQryProductsBase.Basket.Filtered := False;
          if AQryProductsBase.BasketW.LocateByPK
            (Wr.PK.AsInteger) then
          begin
            AQryProductsBase.BasketW.TryEdit;
            AQryProductsBase.BasketW.Amount.F.Value :=
              Wr.Amount.F.Value;
            AQryProductsBase.BasketW.TryPost;
          end;
        end;
      end;

      AClone.Next;
    end;

    for AQryProductsBase in AArray do
    begin
      // ���������� ������� �� �������
      AQryProductsBase.Basket.Filtered := True;
      // ������� ��� ���������, �� �������� �� �� ������
      AQryProductsBase.FDQuery.CommitUpdates;
    end;
  finally
    ASourceProductQry.Wrap.DropClone(AClone);
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

constructor TProductW.Create(AOwner: TComponent);
begin
  inherited;
  FBarcode := TFieldWrap.Create(Self, 'Barcode');
  FBatchNumber := TFieldWrap.Create(Self, 'BatchNumber');
  FChecked := TFieldWrap.Create(Self, 'Checked');
  FCustomsDeclarationNumber := TFieldWrap.Create(Self,
    'CustomsDeclarationNumber');
  FDocumentNumber := TFieldWrap.Create(Self, 'DocumentNumber');
  FDollar := TFieldWrap.Create(Self, 'Dollar');
  FEuro := TFieldWrap.Create(Self, 'Euro');
  FIDComponentGroup := TFieldWrap.Create(Self, 'IDComponentGroup');
  FIDCurrency := TFieldWrap.Create(Self, 'IDCurrency');
  FIDExtraCharge := TFieldWrap.Create(Self, 'IDExtraCharge');
  FIDExtraChargeType := TFieldWrap.Create(Self, 'IDExtraChargeType');
  FIDProducer := TFieldWrap.Create(Self, 'IDProducer');
  FLoadDate := TFieldWrap.Create(Self, 'LoadDate');
  FMinWholeSale := TFieldWrap.Create(Self, 'MinWholeSale');
  FOriginCountry := TFieldWrap.Create(Self, 'OriginCountry');
  FOriginCountryCode := TFieldWrap.Create(Self, 'OriginCountryCode');
  FPackagePins := TFieldWrap.Create(Self, 'PackagePins');
  FPackaging := TFieldWrap.Create(Self, 'Packaging');
  FPrice := TFieldWrap.Create(Self, 'Price');
  FProductID := TFieldWrap.Create(Self, 'ProductID');
  FReleaseDate := TFieldWrap.Create(Self, 'ReleaseDate');
  FRetail := TFieldWrap.Create(Self, 'Retail');
  FSaleCount := TFieldWrap.Create(Self, 'SaleCount');
  FSaleD := TFieldWrap.Create(Self, 'SaleD');
  FSaleE := TFieldWrap.Create(Self, 'SaleE');
  FSaleR := TFieldWrap.Create(Self, 'SaleR');
  FSeller := TFieldWrap.Create(Self, 'Seller');
  FStorage := TFieldWrap.Create(Self, 'Storage');
  FStoragePlace := TFieldWrap.Create(Self, 'StoragePlace');
  FStorehouseId := TFieldWrap.Create(Self, 'StorehouseId');
  FValue := TFieldWrap.Create(Self, 'p.Value');
  FWholeSale := TFieldWrap.Create(Self, 'WholeSale');
  FCalcPriceR := TFieldWrap.Create(Self, 'CalcPriceR');
  FMarkup := TFieldWrap.Create(Self, 'Markup');
end;

procedure TProductW.AddCategory;
begin
  TryAppend;
  Value.F.AsString := '����� ������';
  IsGroup.F.AsInteger := 1;
end;

procedure TProductW.AddProduct(AIDComponentGroup: Integer);
begin
  Assert(AIDComponentGroup > 0);

  TryAppend;
  Value.F.AsString := '����� ������';
  IsGroup.F.AsInteger := 0;
  IDComponentGroup.F.AsInteger := AIDComponentGroup;
end;

procedure TProductW.ApplySaleCountFilter;
begin
  DataSet.Filter := Format('%s > 0', [SaleCount.FieldName]);
  DataSet.Filtered := True;
end;

procedure TProductW.ApplyAmountFilter;
begin
  DataSet.Filter := Format('(%s = 1) or (%s > 0)',
    [IsGroup.FieldName, Amount.FieldName]);
  DataSet.Filtered := True;
end;

function TProductW.CheckInsertingRecord: String;
var
  k: Integer;
begin
  Result := '';

  Assert(not IsGroup.F.IsNull);

  if Value.F.AsString.Trim.IsEmpty then
  begin
    Result := '���������� ������ ������������';
    Exit;
  end;

  // ��� ������ ������ ���� ��������� ������ ������������
  if IsGroup.F.AsInteger = 1 then
    Exit;

  if IDProducer.F.IsNull or (IDProducer.F.AsInteger = 0) then
  begin
    Result := '���������� ������ �������������';
    Exit;
  end;

  if Amount.F.IsNull then
  begin
    Result := '���������� ������ ����������';
    Exit;
  end;

  if Amount.F.AsInteger = 0 then
  begin
    Result := '���������� �� ����� ���� ����� ����';
    Exit;
  end;

  k := 0;
  if (not PriceR.F.IsNull) then
    Inc(k);

  if (not PriceD.F.IsNull) then
    Inc(k);

  if (not PriceE.F.IsNull) then
    Inc(k);

  if k = 0 then
  begin
    Result := '�� ������ ���������� ����';
    Exit;
  end;

  if k > 1 then
  begin
    Result := '���������� ���� ������ ���� ������ ���� ���';
    Exit;
  end;
end;

function TProductW.CheckEditingRecord: String;
begin
  Result := '';

  if SaleCount.F.AsFloat > Amount.F.AsFloat then
  begin
    Result := sIsNotEnoughProductAmount;
    Exit;
  end;
end;

procedure TProductW.CheckSaleCount;
begin
  if SaleCount.F.AsFloat > Amount.F.AsFloat then
    raise Exception.Create(sIsNotEnoughProductAmount);
end;

procedure TProductW.InitFields;
begin
  inherited;

  SetDisplayFormat([SaleR.F, SaleD.F, SaleE.F]);

  SetInternalCalc([Markup.F, CalcPriceR.F, PriceD.F, PriceR.F, PriceE.F,
    PriceD1.F, PriceR1.F, PriceE1.F, PriceD2.F, PriceR2.F, PriceE2.F, SaleR.F,
    SaleD.F, SaleE.F]);
end;

function TProductW.LookupComponentGroup(const AComponentGroup: string): Variant;
var
  AKeyFields: string;
  V: Variant;
begin
  AKeyFields := Format('%s;%s', [Value.FieldName, IsGroup.FieldName]);

  V := FDDataSet.LookupEx(AKeyFields, VarArrayOf([AComponentGroup, 1]),
    PKFieldName, [lxoCaseInsensitive]);

  Result := V;
end;

procedure TProductW.OnDatasheetGetText(Sender: TField; var Text: String;
  DisplayText: Boolean);
begin
  if not Sender.AsString.IsEmpty then
    Text := TPath.GetFileNameWithoutExtension(Sender.AsString);
end;

procedure TProductW.SetSaleCount(ASaleCount: Double);
begin
  Assert(DataSet.RecordCount > 0);
  CheckSaleCount;

  TryEdit;
  if ASaleCount > 0 then
    SaleCount.F.Value := ASaleCount
  else
    SaleCount.F.Value := NULL;
  TryPost;
end;

function TProductW.GetStorehouseProductID(AVirtualID: Integer): Integer;
begin
  // Assert(FVirtualIDOffset < 0);
  Assert(AVirtualID < VirtualIDOffset);
  Result := (AVirtualID * -1) + VirtualIDOffset;
end;

function TProductW.GetStorehouseProductVirtualID(AID: Integer): Integer;
begin
  // Assert(FVirtualIDOffset < 0);
  Assert(AID > 0);
  Result := (AID * -1) + VirtualIDOffset;
end;

procedure TProductW.SetInternalCalc(const AFields: Array of TField);
var
  I: Integer;
begin
  Assert(High(AFields) > 0);

  for I := Low(AFields) to High(AFields) do
  begin
    AFields[I].FieldKind := fkInternalCalc;
  end;
end;

end.
