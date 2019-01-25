unit ProductsBaseQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  ApplyQueryFrame, DocFieldInfo, SearchProductParameterValuesQuery,
  SearchProductQuery, QueryWithDataSourceUnit, CustomComponentsQuery,
  SearchComponentOrFamilyQuery, System.Generics.Collections,
  SearchStorehouseProduct, ProducersQuery, NotifyEvents,
  SearchComponentGroup, SearchFamily, ProducersGroupUnit2, ExtraChargeQuery2,
  ExtraChargeGroupUnit, DSWrap;

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

  TProductW = class(TDSWrap)
  private
    FAmount: TFieldWrap;
    FID: TFieldWrap;
    FBarcode: TFieldWrap;
    FBatchNumber: TFieldWrap;
    FChecked: TFieldWrap;
    FCustomsDeclarationNumber: TFieldWrap;
    FDatasheet: TFieldWrap;
    FDescriptionID: TFieldWrap;
    FDiagram: TFieldWrap;
    FDocumentNumber: TFieldWrap;
    FDollar: TFieldWrap;
    FDrawing: TFieldWrap;
    FEuro: TFieldWrap;
    FIDComponentGroup: TFieldWrap;
    FIDCurrency: TFieldWrap;
    FIDExtraCharge: TFieldWrap;
    FIDExtraChargeType: TFieldWrap;
    FIDProducer: TFieldWrap;
    FImage: TFieldWrap;
    FIsGroup: TFieldWrap;
    FLoadDate: TFieldWrap;
    FMinWholeSale: TFieldWrap;
    FOriginCountry: TFieldWrap;
    FOriginCountryCode: TFieldWrap;
    FPackagePins: TFieldWrap;
    FPackaging: TFieldWrap;
    FPrice: TFieldWrap;
    FPriceD: TFieldWrap;
    FPriceD1: TFieldWrap;
    FPriceD2: TFieldWrap;
    FPriceE: TFieldWrap;
    FPriceE1: TFieldWrap;
    FPriceE2: TFieldWrap;
    FPriceR: TFieldWrap;
    FPriceR1: TFieldWrap;
    FPriceR2: TFieldWrap;
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
    FWholesale: TFieldWrap;
    procedure DoAfterOpen(Sender: TObject);
  protected
    function CheckRecord(ADollarCource: Double;
      const AEuroCource: Double): String;
    procedure OnDatasheetGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    procedure AddCategory;
    procedure AddProduct(AIDComponentGroup: Integer);
    function LookupComponentGroup(const AComponentGroup: string): Variant;
    property Amount: TFieldWrap read FAmount;
    property ID: TFieldWrap read FID;
    property Barcode: TFieldWrap read FBarcode;
    property BatchNumber: TFieldWrap read FBatchNumber;
    property Checked: TFieldWrap read FChecked;
    property CustomsDeclarationNumber: TFieldWrap
      read FCustomsDeclarationNumber;
    property Datasheet: TFieldWrap read FDatasheet;
    property DescriptionID: TFieldWrap read FDescriptionID;
    property Diagram: TFieldWrap read FDiagram;
    property DocumentNumber: TFieldWrap read FDocumentNumber;
    property Dollar: TFieldWrap read FDollar;
    property Drawing: TFieldWrap read FDrawing;
    property Euro: TFieldWrap read FEuro;
    property IDComponentGroup: TFieldWrap read FIDComponentGroup;
    property IDCurrency: TFieldWrap read FIDCurrency;
    property IDExtraCharge: TFieldWrap read FIDExtraCharge;
    property IDExtraChargeType: TFieldWrap read FIDExtraChargeType;
    property IDProducer: TFieldWrap read FIDProducer;
    property Image: TFieldWrap read FImage;
    property IsGroup: TFieldWrap read FIsGroup;
    property LoadDate: TFieldWrap read FLoadDate;
    property MinWholeSale: TFieldWrap read FMinWholeSale;
    property OriginCountry: TFieldWrap read FOriginCountry;
    property OriginCountryCode: TFieldWrap read FOriginCountryCode;
    property PackagePins: TFieldWrap read FPackagePins;
    property Packaging: TFieldWrap read FPackaging;
    property Price: TFieldWrap read FPrice;
    property PriceD: TFieldWrap read FPriceD;
    property PriceD1: TFieldWrap read FPriceD1;
    property PriceD2: TFieldWrap read FPriceD2;
    property PriceE: TFieldWrap read FPriceE;
    property PriceE1: TFieldWrap read FPriceE1;
    property PriceE2: TFieldWrap read FPriceE2;
    property PriceR: TFieldWrap read FPriceR;
    property PriceR1: TFieldWrap read FPriceR1;
    property PriceR2: TFieldWrap read FPriceR2;
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
    property Wholesale: TFieldWrap read FWholesale;
  end;

  TQueryProductsBase = class(TQueryWithDataSource)
    procedure DataSourceDataChange(Sender: TObject; Field: TField);
    procedure FDQueryAfterApplyUpdates(DataSet: TFDDataSet; AErrors: Integer);
    procedure FDQueryCalcFields(DataSet: TDataSet);
  private
    FBasket: TFDMemTable;
    FCalcStatus: Integer;
    FDataChange: Boolean;
    FNotGroupClone: TFDMemTable;
    FOnLocate: TNotifyEventsEx;
    FProducersGroup: TProducersGroup2;
    FqSearchComponentGroup: TQuerySearchComponentGroup;
    FqSearchComponentOrFamily: TQuerySearchComponentOrFamily;
    FqSearchFamily: TQuerySearchFamily;
    FqSearchProduct: TQuerySearchProduct;
    FqSearchStorehouseProduct: TQuerySearchStorehouseProduct;
    FDollarCource: Double;
    FEuroCource: Double;
    FOnDollarCourceChange: TNotifyEventsEx;
    FOnEuroCourceChange: TNotifyEventsEx;
    FExtraChargeGroup: TExtraChargeGroup;
    FOnCommitUpdatePosted: Boolean;
    FW: TProductW;
    procedure DoBeforeOpen(Sender: TObject);
    function GetProducersGroup: TProducersGroup2;
    function GetExtraChargeGroup: TExtraChargeGroup;
    function GetqSearchComponentGroup: TQuerySearchComponentGroup;
    function GetqSearchComponentOrFamily: TQuerySearchComponentOrFamily;
    function GetqSearchFamily: TQuerySearchFamily;
    function GetqSearchProduct: TQuerySearchProduct;
    function GetqSearchStorehouseProduct: TQuerySearchStorehouseProduct;
    procedure SetDollarCource(const Value: Double);
    procedure SetEuroCource(const Value: Double);
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
    procedure DisableCalc;
    procedure DoBeforePost(Sender: TObject); virtual;
    procedure DoOnCommitUpdates(var Message: TMessage);
      message WM_OnCommitUpdates;
    procedure EnableCalc;
    function GetExportFileName: string; virtual; abstract;
    function GetHaveAnyChanges: Boolean; override;
    property qSearchComponentGroup: TQuerySearchComponentGroup
      read GetqSearchComponentGroup;
    property qSearchComponentOrFamily: TQuerySearchComponentOrFamily
      read GetqSearchComponentOrFamily;
    property qSearchFamily: TQuerySearchFamily read GetqSearchFamily;
    property qSearchProduct: TQuerySearchProduct read GetqSearchProduct;
    property qSearchStorehouseProduct: TQuerySearchStorehouseProduct
      read GetqSearchStorehouseProduct;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ApplyUpdates; override;
    procedure CancelUpdates; override;
    procedure ClearInternalCalcFields;
    procedure DeleteNode(AID: Integer);
    procedure DeleteNotUsedProducts(AProductIDS: TList<Integer>);
    procedure LoadDocFile(const AFileName: String;
      ADocFieldInfo: TDocFieldInfo);
    function LocateInComponents: Boolean;
    procedure SaveExtraCharge;
    procedure TunePriceFields(const AFields: Array of TField);
    procedure UpdateFieldValue(AID: Integer; AFields: TArray<TField>;
      AValues: TArray<Variant>; AUpdatedIDList: TList<Integer>);
    property ExportFileName: string read GetExportFileName;
    property NotGroupClone: TFDMemTable read FNotGroupClone;
    property ProducersGroup: TProducersGroup2 read GetProducersGroup;
    property DollarCource: Double read FDollarCource write SetDollarCource;
    property EuroCource: Double read FEuroCource write SetEuroCource;
    property OnDollarCourceChange: TNotifyEventsEx read FOnDollarCourceChange;
    property OnEuroCourceChange: TNotifyEventsEx read FOnEuroCourceChange;
    property Basket: TFDMemTable read FBasket;
    property ExtraChargeGroup: TExtraChargeGroup read GetExtraChargeGroup;
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
  ParameterValuesUnit, StrHelper, System.StrUtils;

constructor TQueryProductsBase.Create(AOwner: TComponent);
begin
  inherited;
  FW := TProductW.Create(FDQuery);
  FOnLocate := TNotifyEventsEx.Create(Self);

  TNotifyEventWrap.Create(BeforeOpen, DoBeforeOpen, FEventList);
  TNotifyEventWrap.Create(BeforePost, DoBeforePost, FEventList);

  // ����� ���� ��������� ������
  FDQuery.OnUpdateRecord := DoOnQueryUpdateRecord;

  // ������� ���� ������� �� ��������� � ����� ��������� �� ��������� ��������
  // FDollarCource := TSettings.Create.DollarCource;

  // �� ��������� �� �� � ������ �������������� ����������
  // AutoTransaction := False;

  // ����� ���������� ��� ���������
  FDQuery.CachedUpdates := True;
  FDQuery.UpdateOptions.AutoIncFields := PKFieldName;
  FDQuery.UpdateOptions.KeyFields := PKFieldName;

  FCalcStatus := 0;

  FNotGroupClone := AddClone('IsGroup=0');

  FOnDollarCourceChange := TNotifyEventsEx.Create(Self);
  FOnEuroCourceChange := TNotifyEventsEx.Create(Self);

  FBasket := AddClone('SaleCount > 0');
end;

destructor TQueryProductsBase.Destroy;
begin
  DropClone(FBasket);
  FBasket := nil;

  FreeAndNil(FOnDollarCourceChange);
  FreeAndNil(FOnEuroCourceChange);

  DropClone(FNotGroupClone);
  FNotGroupClone := nil;

  FreeAndNil(FOnLocate);
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
      Assert(PK.Value > 0);
      // ���� ����� ������
      if qSearchComponentGroup.SearchByID(PK.Value) = 0 then
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
        if AProductIDS.IndexOf(qSearchStorehouseProduct.ProductID.AsInteger) < 0
        then
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

      AProductIDS.Add(W.ProductID.F.AsInteger);

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
    FetchFields([PK.FieldName], [qSearchComponentGroup.PK.Value], ARequest,
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
      qSearchProduct.InsertRecord(ARH);
      // ���������� ��� ��������
      ARH.Field[W.ProductID.FieldName] := qSearchProduct.PK.Value;
    end;

    // �������� ��� ��������� �� �����
    if not qSearchStorehouseProduct.FDQuery.Active then
      qSearchStorehouseProduct.SearchByID(1);

    qSearchStorehouseProduct.InsertRecord(ARH);

    // ��������� ���� � ��� - ������������� ������ "�������-�����" � ������������� ���������
    // ���������� ��������� ����
    ARH.Field[PK.FieldName] := -qSearchStorehouseProduct.PK.Value;
    // FetchFields([PK.FieldName], [-qSearchStorehouseProduct.PK.Value], ARequest,
    // AAction, AOptions);

    FetchFields(ARH, ARequest, AAction, AOptions);
  finally
    FreeAndNil(ARH);
  end;

  inherited;
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
      Assert(PK.Value > 0);
      // ���� ����� ������
      if qSearchComponentGroup.SearchByID(PK.Value) = 0 then
        Exit;

      // ����� ��������� ���� ����
      ARH.Clear;
      TFieldHolder.Create(ARH, qSearchComponentGroup.W.ComponentGroup.FieldName,
        W.Value.F.AsString);

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
      qSearchProduct.SearchByID(W.ProductID.F.AsInteger);
      qSearchProduct.UpdateRecord(ARH);
    end;
  finally
    FreeAndNil(ARH);
  end;

  inherited;
end;

procedure TQueryProductsBase.ApplyUpdates;
begin
  Assert(FDQuery.CachedUpdates);
  Assert(not FDQuery.Connection.InTransaction);

  TryPost;
  // ��� ������ ���� ������������ ���������
  Assert(FDQuery.ChangeCount > 0);

  FDQuery.Connection.StartTransaction;

  FDQuery.ApplyUpdates();
  FDQuery.CommitUpdates;

  FDQuery.Connection.Commit;
  FDataChange := False;
end;

procedure TQueryProductsBase.CancelUpdates;
begin
  Assert(FDQuery.CachedUpdates);
  Assert(not FDQuery.Connection.InTransaction);
  FDataChange := False;

  // �������� ��������� ��������� � ������� ������ �� ������� �������
  TryCancel;

  // ���� � ������ ������� ���� ��� ���������
  if FDQuery.ChangeCount = 0 then
    Exit;

  SaveBookmark;
  FDQuery.DisableControls;
  try
    // ��� �������� ���������� ������ ���� ��������� � �������� ���� �� ����
    inherited;
    {
      FDQuery.Connection.Rollback;
      // ���������� ��� �� �� � ����������
      Assert(not FDQuery.Connection.InTransaction);
      RefreshQuery;
    }
    ProducersGroup.ReOpen;

    RestoreBookmark;
  finally
    FDQuery.EnableControls;
  end;
end;

procedure TQueryProductsBase.ClearInternalCalcFields;
var
  WasSave: Boolean;
begin
  WasSave := not HaveAnyNotCommitedChanges;
  FDQuery.DisableControls;
  try
    FDQuery.First;
    while not FDQuery.Eof do
    begin
      W.TryEdit;
      W.IDExtraCharge.F.Clear;
      W.IDExtraChargeType.F.Clear;
      W.Wholesale.F.Clear; // ������� �������
      W.SaleCount.F.Clear; // ���-�� ������
      W.TryPost;

      // ���� �� ������� � ��� �� ���� ���������
      if WasSave then
        // ������� ��������� � �� �� ������ ���������
        ApplyUpdates;

      FDQuery.Next;
    end;
  finally
    FDQuery.EnableControls;
  end;
end;

procedure TQueryProductsBase.DataSourceDataChange(Sender: TObject;
  Field: TField);
var
  ADS: TDataSource;
begin
  inherited;
  Assert(FDQuery.CachedUpdates);

  // ���� ��� ���� ������������ ���������
  if (FDQuery.ChangeCount > 0) or (FDataChange) then
    Exit;

  ADS := Sender as TDataSource;

  // ���� ������ ���������� �������������� ��� �������
  if (ADS.DataSet.State in [dsInsert, dsEdit]) and (Field <> nil) then
  begin
    // ���� ���������� ������ ���� ���-�� ������
    if Field.FieldName = W.SaleCount.FieldName then
    begin
      if not FOnCommitUpdatePosted then
      begin
        FOnCommitUpdatePosted := True;
        PostMessage(Handle, WM_OnCommitUpdates, 0, 0);
        beep;
      end;
      // FDQuery.CommitUpdates;
    end
    else
      FDataChange := True; // ���������� �����-�� ������ ����
  end;
end;

procedure TQueryProductsBase.DeleteNode(AID: Integer);
var
  AClone: TFDMemTable;
begin
  // FDQuery.DisableControls;
  try
    // ���� ������ ������� ���� �������
    LocateByPK(AID, True);

    // ���� ����� ������� ������
    if W.IsGroup.F.AsInteger = 1 then
    begin
      AClone := AddClone(Format('%s=%d', [W.IDComponentGroup.FieldName,
        W.PK.AsInteger]));
      try
        // ������� ��� ���������� ������
        while AClone.RecordCount > 0 do
          DeleteNode(AClone.FieldByName('ID').AsInteger);

      finally
        DropClone(AClone);
      end;

      // ����� ��������� �� ������
      LocateByPK(AID, True);
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

procedure TQueryProductsBase.DoBeforeOpen(Sender: TObject);
var
  S: string;
begin;
  if FDQuery.FieldDefs.Count > 0 then
  begin
    FDQuery.FieldDefs.Clear;
    FDQuery.Fields.Clear;
  end;

  S := FDQuery.SQL.Text;

  FDQuery.FieldDefs.Update;

  // ������ �� ��������� �������� ������� �������
  FDQuery.FieldDefs.Add(W.IDExtraCharge.FieldName, ftInteger);
  FDQuery.FieldDefs.Add(W.IDExtraChargeType.FieldName, ftInteger);

  // ������� ������� �������
  FDQuery.FieldDefs.Add(W.Wholesale.FieldName, ftFloat);
  // ������� ��������� �������
  // FDQuery.FieldDefs.Add('Retail', ftInteger);

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

  // ���������� �������
  FDQuery.FieldDefs.Add(W.SaleCount.FieldName, ftFloat);
  // ��������� ����
  FDQuery.FieldDefs.Add(W.SaleR.FieldName, ftFloat);
  FDQuery.FieldDefs.Add(W.SaleD.FieldName, ftFloat);
  FDQuery.FieldDefs.Add(W.SaleE.FieldName, ftFloat);

  CreateDefaultFields(False);

  // ��������� ����������� ����
  W.IDExtraCharge.F.FieldKind := fkInternalCalc;
  W.IDExtraChargeType.F.FieldKind := fkInternalCalc;
  W.Wholesale.F.FieldKind := fkInternalCalc;
  W.SaleCount.F.FieldKind := fkInternalCalc;
  // Retail.FieldKind := fkInternalCalc;

  TunePriceFields([W.PriceD.F, W.PriceR.F, W.PriceE.F, W.PriceD1.F, W.PriceR1.F,
    W.PriceE1.F, W.PriceD2.F, W.PriceR2.F, W.PriceE2.F, W.SaleR.F, W.SaleD.F,
    W.SaleE.F]);
end;

procedure TQueryProductsBase.DoBeforePost(Sender: TObject);
var
  AErrorMessage: String;
  rc: Integer;
begin
  // ���� �� ���������� ������� ����� ������
  if not(FDQuery.State in [dsInsert]) then
    Exit;

  Assert(not W.IsGroup.F.IsNull);

  // ��� ������, ���� ��������� �� ����
  if W.IsGroup.F.AsInteger = 1 then
    Exit;

  // ��������� ������ �� ������� ������
  AErrorMessage := W.CheckRecord(DollarCource, EuroCource);
  if not AErrorMessage.IsEmpty then
    raise Exception.Create(AErrorMessage);

  // �������� ���� �������
  if (W.Dollar.F.IsNull) and (DollarCource > 0) then
    W.Dollar.F.AsFloat := DollarCource;

  // ������� ���� ����
  if (W.Euro.F.IsNull) and (EuroCource > 0) then
    W.Euro.F.AsFloat := EuroCource;

  // ��������� ���� ��������, ���� ��� ������
  if W.LoadDate.F.IsNull then
    W.LoadDate.F.AsString := FormatDateTime('dd.mm.yyyy', Date);;

  // ���� ������������� �����
  if W.IDProducer.F.AsInteger > 0 then
  begin
    // ���� ������������� �� ����
    ProducersGroup.qProducers.LocateByPK(W.IDProducer.F.AsInteger, True);

    // ���� ��������� � ������������� ���� ������
    rc := qSearchComponentOrFamily.SearchComponentWithProducer
      (W.Value.F.AsString, ProducersGroup.qProducers.W.Name.F.AsString);
  end
  else
  begin
    // ���� � ������������� ���� ������ �� ������������
    rc := qSearchComponentOrFamily.SearchComponentWithProducer
      (W.Value.F.AsString);
    if rc > 0 then
    begin
      // ���� � ����������� ������ �������������
      ProducersGroup.qProducers.Locate
        (qSearchComponentOrFamily.Producer.AsString, True);

      // ��������� ���� "��� �������������"
      W.IDProducer.F.Value := ProducersGroup.qProducers.PK.Value;
    end;
  end;

  // ���� ����� ��������� ������ � ����������� ����
  if rc > 0 then
  begin
    // ����������, ��� ���� ��������� ���� � ������������� ����
    W.Checked.F.AsInteger := 1;
    // ���� ��������������� ��������� �����������
    qSearchFamily.SearchByID(qSearchComponentOrFamily.ParentProductID.
      AsInteger, 1);

    // ��������� ������ ���� �� ���������� ����������
    UpdateFields([W.Datasheet.F, W.Diagram.F, W.Drawing.F, W.Image.F,
      W.DescriptionID.F], [qSearchFamily.Datasheet.Value,
      qSearchFamily.Diagram.Value, qSearchFamily.Drawing.Value,
      qSearchFamily.Image.Value, qSearchFamily.DescriptionID.Value], True);
  end;

  // ���� ������������� �� �����
  if W.IDProducer.F.IsNull or (W.IDProducer.F.AsInteger = 0) then
  begin
    // ���� ����� ��������� � ����� ������ �� ������
    rc := qSearchProduct.SearchByValue(W.Value.F.AsString);
    if rc > 0 then
      // ��������� ��� �������������
      W.IDProducer.F.Value := qSearchProduct.IDProducer.Value
    else
      raise Exception.Create('���������� ������ �������������');
  end;

  // ���� ����� ������� � ��� �� ��������������
  // ���� ����� ������� ��� ����
  if qSearchProduct.SearchByValue(W.Value.F.AsString,
    W.IDProducer.F.AsInteger) > 0 then
  begin
    // ��������� ������ ���� �� ���������� ��������
    UpdateFields([W.Datasheet.F, W.Diagram.F, W.Drawing.F, W.Image.F,
      W.DescriptionID.F, W.ProductID.F], [qSearchProduct.Datasheet.Value,
      qSearchProduct.Diagram.Value, qSearchProduct.Drawing.Value,
      qSearchProduct.Image.Value, qSearchProduct.DescriptionID.Value,
      qSearchProduct.PK.Value], True);
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

procedure TQueryProductsBase.DoOnCommitUpdates(var Message: TMessage);
begin
  inherited;
  ApplyUpdates;
  FOnCommitUpdatePosted := False;
end;

procedure TQueryProductsBase.EnableCalc;
begin
  Assert(FCalcStatus > 0);
  Dec(FCalcStatus);
  if FCalcStatus = 0 then
    FDQueryCalcFields(FDQuery);
end;

procedure TQueryProductsBase.FDQueryAfterApplyUpdates(DataSet: TFDDataSet;
  AErrors: Integer);
begin
  inherited;
  FDataChange := False;
end;

procedure TQueryProductsBase.FDQueryCalcFields(DataSet: TDataSet);
var
  ADCource: Double;
  AECource: Double;
  AWholeSale: Double;
begin
  inherited;

  if (FCalcStatus > 0) or (W.IDCurrency.F.AsInteger = 0) or (W.Price.F.IsNull) then
    Exit;

  // ������������ � ������ �������
  ADCource := 0;
  // ���� ����� ���� �� ����������� ����
  if DollarCource > 0 then
    ADCource := DollarCource
  else
    // ���� �������� ���� �� ���� �������
    if W.Dollar.F.AsFloat > 0 then
      ADCource := W.Dollar.F.AsFloat;

  // ������������ � ������ ����
  AECource := 0;
  if EuroCource > 0 then
    AECource := EuroCource
  else
    // ���� �������� ���� �� ���� �������
    if W.Euro.F.AsFloat > 0 then
      AECource := W.Euro.F.AsFloat;

  // ���� �������� ���� ���� � ������
  if W.IDCurrency.F.AsInteger = 1 then
  begin
    W.PriceR.F.Value := W.Price.F.Value;

    if ADCource > 0 then
      W.PriceD.F.Value := W.Price.F.Value / ADCource
    else
      W.PriceD.F.Value := null;

    if AECource > 0 then
      W.PriceE.F.Value := W.Price.F.Value / AECource
    else
      W.PriceE.F.Value := null;
  end;

  // ���� �������� ���� ���� � ��������
  if W.IDCurrency.F.AsInteger = 2 then
  begin
    if ADCource > 0 then
      W.PriceR.F.Value := W.Price.F.Value * ADCource
    else
      W.PriceR.F.Value := null;

    W.PriceD.F.Value := W.Price.F.Value;

    if (ADCource > 0) and (AECource > 0) then
      W.PriceE.F.Value := W.Price.F.Value * ADCource / AECource
    else
      W.PriceE.F.Value := null;
  end;

  // ���� �������� ���� ���� � ����
  if W.IDCurrency.F.AsInteger = 3 then
  begin
    if AECource > 0 then
      W.PriceR.F.Value := W.Price.F.Value * AECource
    else
      W.PriceR.F.Value := null;

    if (ADCource > 0) and (AECource > 0) then
      W.PriceD.F.Value := W.Price.F.Value * AECource / ADCource
    else
      W.PriceD.F.Value := null;

    W.PriceE.F.Value := W.Price.F.Value;
  end;

  // ��������� ����
  W.PriceR1.F.Value := W.PriceR.F.Value * (1 + W.Retail.F.Value / 100);
  W.PriceD1.F.Value := W.PriceD.F.Value * (1 + W.Retail.F.Value / 100);
  W.PriceE1.F.Value := W.PriceE.F.Value * (1 + W.Retail.F.Value / 100);

  AWholeSale := W.Wholesale.F.AsFloat;

  // ���� ������� ������� �� ������ ���� ����������� ������� �������
  if AWholeSale = 0 then
    AWholeSale := W.MinWholeSale.F.Value;

  // ������� ����
  W.PriceR2.F.Value := W.PriceR.F.Value * (1 + AWholeSale / 100);
  W.PriceD2.F.Value := W.PriceD.F.Value * (1 + AWholeSale / 100);
  W.PriceE2.F.Value := W.PriceE.F.Value * (1 + AWholeSale / 100);

  // ���� ������� ���������� ������
  if W.SaleCount.F.AsFloat > 0 then
  begin
    if W.SaleCount.F.AsFloat <= 1 then
    begin
      // ���������� ������� 1 ��. - ���������� ��������� ����
      W.SaleR.F.Value := W.PriceR1.F.Value;
      W.SaleD.F.Value := W.PriceD1.F.Value;
      W.SaleE.F.Value := W.PriceE1.F.Value;
    end
    else
    begin
      // ����� - ������� ����
      W.SaleR.F.Value := W.PriceR2.F.AsFloat * W.SaleCount.F.AsFloat;
      W.SaleD.F.Value := W.PriceD2.F.AsFloat * W.SaleCount.F.AsFloat;
      W.SaleE.F.Value := W.PriceE2.F.AsFloat * W.SaleCount.F.AsFloat;
    end;
  end
  else
  begin
    W.SaleR.F.Value := null;
    W.SaleD.F.Value := null;
    W.SaleE.F.Value := null;
  end;
end;

function TQueryProductsBase.GetProducersGroup: TProducersGroup2;
begin
  if FProducersGroup = nil then
  begin
    FProducersGroup := TProducersGroup2.Create(Self);
    FProducersGroup.ReOpen;
  end;

  Result := FProducersGroup;
end;

function TQueryProductsBase.GetExtraChargeGroup: TExtraChargeGroup;
begin
  if FExtraChargeGroup = nil then
  begin
    FExtraChargeGroup := TExtraChargeGroup.Create(Self);
    FExtraChargeGroup.ReOpen;
  end;
  Result := FExtraChargeGroup;
end;

// ����-�� ��������� �� ���������� � ��
function TQueryProductsBase.GetHaveAnyChanges: Boolean;
begin
  // � ��� ��� ��������� ���������� �� ������� �������
  Assert(FDQuery.CachedUpdates);

  Result := FDataChange;
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

procedure TQueryProductsBase.LoadDocFile(const AFileName: String;
  ADocFieldInfo: TDocFieldInfo);
var
  ABrowseState: Boolean;
  S: String;
begin
  if not AFileName.IsEmpty then
  begin
    // � �� ������ ���� �� ����� ������������ ����� � �������������
    S := GetRelativeFileName(AFileName, ADocFieldInfo.Folder);
    ABrowseState := FDQuery.State = dsBrowse;
    TryEdit;
    FDQuery.FieldByName(ADocFieldInfo.FieldName).AsString := S;
    if ABrowseState then
      TryPost;
  end;
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
    ProducersGroup.qProducers.LocateByPK(W.IDProducer.F.AsInteger, True);

    rc := qSearchComponentOrFamily.SearchComponentWithProducer(W.Value.F.AsString,
      ProducersGroup.qProducers.W.Name.F.AsString);
  end;
  if rc > 0 then
  begin
    // ���� ��������������� ��������� �����������
    rc := qSearchFamily.SearchByID
      (qSearchComponentOrFamily.ParentProductID.AsInteger);

  end;
  Result := rc > 0;

  if Result then
  begin
    m := qSearchFamily.CategoryIDList.AsString.Split([',']);
    Assert(Length(m) > 0);

    AIDCategory := String.ToInteger(m[0]);

    LR := TLocateObject.Create(AIDCategory, qSearchFamily.Value.AsString,
      qSearchComponentOrFamily.Value.AsString);
    try
      OnLocate.CallEventHandlers(LR);
    finally
      FreeAndNil(LR);
    end;

  end;
end;

procedure TQueryProductsBase.SaveExtraCharge;
begin
  Assert(ExtraChargeGroup.qExtraCharge2.FDQuery.RecordCount > 0);
  W.TryEdit;
  W.IDExtraCharge.F.AsInteger := ExtraChargeGroup.qExtraCharge2.PK.AsInteger;
  // ������ ������� ������� �������
  W.Wholesale.F.Value := ExtraChargeGroup.qExtraCharge2.W.Wholesale.F.Value;
  W.TryPost;
end;

procedure TQueryProductsBase.SetDollarCource(const Value: Double);
begin
  if FDollarCource <> Value then
  begin
    FDollarCource := Value;
    FOnDollarCourceChange.CallEventHandlers(Self);
    // TSettings.Create.DollarCource := FDollarCource;
  end;
end;

procedure TQueryProductsBase.SetEuroCource(const Value: Double);
begin
  if FEuroCource <> Value then
  begin
    FEuroCource := Value;
    FOnEuroCourceChange.CallEventHandlers(Self);
    // TSettings.Create.EuroCource := FEuroCource;
  end;
end;

procedure TQueryProductsBase.TunePriceFields(const AFields: Array of TField);
var
  I: Integer;
begin
  Assert(High(AFields) > 0);

  for I := Low(AFields) to High(AFields) do
  begin
    AFields[I].FieldKind := fkInternalCalc;
    // (AFields[I] as TNumericField).DisplayFormat := '#.00';
    (AFields[I] as TNumericField).DisplayFormat := '###,##0.00';
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

  LocateByPK(AID, True);

  // ���� �������� ��������� ����������� � ������
  if W.IsGroup.F.AsInteger = 1 then
  begin
    AClone := AddClone(Format('%s=%d', [W.IDComponentGroup.FieldName,
      PK.AsInteger]));
    try
      AClone.First;
      while not AClone.Eof do
      begin
        UpdateFieldValue(AClone.FieldByName('ID').AsInteger, AFields, AValues,
          AUpdatedIDList);
        AClone.Next;
      end;
    finally
      DropClone(AClone);
    end;
  end
  else
  begin
    TryEdit;
    for I := Low(AFields) to High(AFields) do
      AFields[I].Value := AValues[I];
    TryPost;

    AUpdatedIDList.Add(AID);
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

constructor TProductW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'ID', '', True);
  FAmount := TFieldWrap.Create(Self, 'Amount');
  FBarcode := TFieldWrap.Create(Self, 'Barcode');
  FBatchNumber := TFieldWrap.Create(Self, 'BatchNumber');
  FChecked := TFieldWrap.Create(Self, 'Checked');
  FCustomsDeclarationNumber := TFieldWrap.Create(Self,
    'CustomsDeclarationNumber');
  FDatasheet := TFieldWrap.Create(Self, 'Datasheet');
  FDescriptionID := TFieldWrap.Create(Self, 'DescriptionID');
  FDiagram := TFieldWrap.Create(Self, 'Diagram');
  FDocumentNumber := TFieldWrap.Create(Self, 'DocumentNumber');
  FDollar := TFieldWrap.Create(Self, 'Dollar');
  FDrawing := TFieldWrap.Create(Self, 'Drawing');
  FEuro := TFieldWrap.Create(Self, 'Euro');
  FIDComponentGroup := TFieldWrap.Create(Self, 'IDComponentGroup');
  FIDCurrency := TFieldWrap.Create(Self, 'IDCurrency');
  FIDExtraCharge := TFieldWrap.Create(Self, 'IDExtraCharge');
  FIDExtraChargeType := TFieldWrap.Create(Self, 'IDExtraChargeType');
  FIDProducer := TFieldWrap.Create(Self, 'IDProducer');
  FImage := TFieldWrap.Create(Self, 'Image');
  FIsGroup := TFieldWrap.Create(Self, 'IsGroup');
  FLoadDate := TFieldWrap.Create(Self, 'LoadDate');
  FMinWholeSale := TFieldWrap.Create(Self, 'MinWholeSale');
  FOriginCountry := TFieldWrap.Create(Self, 'OriginCountry');
  FOriginCountryCode := TFieldWrap.Create(Self, 'OriginCountryCode');
  FPackagePins := TFieldWrap.Create(Self, 'PackagePins');
  FPackaging := TFieldWrap.Create(Self, 'Packaging');
  FPrice := TFieldWrap.Create(Self, 'Price');
  FPriceD := TFieldWrap.Create(Self, 'PriceD');
  FPriceD1 := TFieldWrap.Create(Self, 'PriceD1');
  FPriceD2 := TFieldWrap.Create(Self, 'PriceD2');
  FPriceE := TFieldWrap.Create(Self, 'PriceE');
  FPriceE1 := TFieldWrap.Create(Self, 'PriceE1');
  FPriceE2 := TFieldWrap.Create(Self, 'PriceE2');
  FPriceR := TFieldWrap.Create(Self, 'PriceR');
  FPriceR1 := TFieldWrap.Create(Self, 'PriceR1');
  FPriceR2 := TFieldWrap.Create(Self, 'PriceR2');
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
  FValue := TFieldWrap.Create(Self, 'Value');
  FWholesale := TFieldWrap.Create(Self, 'Wholesale');

  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, EventList);
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

function TProductW.CheckRecord(ADollarCource: Double;
  const AEuroCource: Double): String;
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

  if (Dollar.F.IsNull) and (ADollarCource = 0) then
  begin
    Result := '�� ����� ���� �������';
    Exit;
  end;

  if (Euro.F.IsNull) and (AEuroCource = 0) then
  begin
    Result := '�� ����� ���� ����';
    Exit;
  end;
end;

procedure TProductW.DoAfterOpen(Sender: TObject);
begin
  SetFieldsRequired(False);
  SetFieldsReadOnly(False);

  Datasheet.F.OnGetText := OnDatasheetGetText;
  Diagram.F.OnGetText := OnDatasheetGetText;
  Drawing.F.OnGetText := OnDatasheetGetText;
  Image.F.OnGetText := OnDatasheetGetText;
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

end.
