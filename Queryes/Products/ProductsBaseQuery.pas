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
  ExtraChargeGroupUnit;

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
    procedure FDQueryCalcFields(DataSet: TDataSet);
  private
    FCalcStatus: Integer;
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
    procedure DoAfterOpen(Sender: TObject);
    procedure DoBeforeOpen(Sender: TObject);
    function GetAmount: TField;
    function GetBarcode: TField;
    function GetBatchNumber: TField;
    function GetChecked: TField;
    function GetCustomsDeclarationNumber: TField;
    function GetDatasheet: TField;
    function GetDescriptionID: TField;
    function GetLoadDate: TField;
    function GetDiagram: TField;
    function GetDocumentNumber: TField;
    function GetMinWholeSale: TField;
    function GetDrawing: TField;
    function GetIDComponentGroup: TField;
    function GetIDCurrency: TField;
    function GetIDExtraCharge: TField;
    function GetIDProducer: TField;
    function GetImage: TField;
    function GetIsGroup: TField;
    function GetPrice: TField;
    function GetEuro: TField;
    function GetDollar: TField;
    function GetOriginCountry: TField;
    function GetOriginCountryCode: TField;
    function GetPackagePins: TField;
    function GetPackaging: TField;
    function GetPriceD: TField;
    function GetPriceD1: TField;
    function GetPriceD2: TField;
    function GetPriceE: TField;
    function GetPriceE1: TField;
    function GetPriceE2: TField;
    function GetPriceR: TField;
    function GetPriceR1: TField;
    function GetPriceR2: TField;
    function GetProductID: TField;
    function GetProducersGroup: TProducersGroup2;
    function GetExtraChargeGroup: TExtraChargeGroup;
    function GetIDExtraChargeType: TField;
    function GetqSearchComponentGroup: TQuerySearchComponentGroup;
    function GetqSearchComponentOrFamily: TQuerySearchComponentOrFamily;
    function GetqSearchFamily: TQuerySearchFamily;
    function GetqSearchProduct: TQuerySearchProduct;
    function GetqSearchStorehouseProduct: TQuerySearchStorehouseProduct;
    function GetReleaseDate: TField;
    function GetRetail: TField;
    function GetSaleCount: TField;
    function GetSaleR: TField;
    function GetSaleD: TField;
    function GetSaleE: TField;
    function GetSeller: TField;
    function GetStorage: TField;
    function GetStoragePlace: TField;
    function GetStorehouseId: TField;
    function GetValue: TField;
    function GetWholesale: TField;
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
    function CheckRecord: String;
    procedure DisableCalc;
    procedure DoBeforePost(Sender: TObject); virtual;
    procedure EnableCalc;
    function GetExportFileName: string; virtual; abstract;
    function LookupComponentGroup(const AComponentGroup: string): Variant;
    procedure OnDatasheetGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
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
    procedure AddCategory;
    procedure AddProduct(AIDComponentGroup: Integer);
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
    property Amount: TField read GetAmount;
    property Barcode: TField read GetBarcode;
    property BatchNumber: TField read GetBatchNumber;
    property Checked: TField read GetChecked;
    property CustomsDeclarationNumber: TField read GetCustomsDeclarationNumber;
    property Datasheet: TField read GetDatasheet;
    property DescriptionID: TField read GetDescriptionID;
    property LoadDate: TField read GetLoadDate;
    property Diagram: TField read GetDiagram;
    property DocumentNumber: TField read GetDocumentNumber;
    property Drawing: TField read GetDrawing;
    property ExportFileName: string read GetExportFileName;
    property IDComponentGroup: TField read GetIDComponentGroup;
    property IDCurrency: TField read GetIDCurrency;
    property IDProducer: TField read GetIDProducer;
    property Image: TField read GetImage;
    property IsGroup: TField read GetIsGroup;
    property NotGroupClone: TFDMemTable read FNotGroupClone;
    property Price: TField read GetPrice;
    property PriceD: TField read GetPriceD;
    property PriceD1: TField read GetPriceD1;
    property PriceD2: TField read GetPriceD2;
    property PriceR: TField read GetPriceR;
    property PriceR1: TField read GetPriceR1;
    property PriceR2: TField read GetPriceR2;
    property ProductID: TField read GetProductID;
    property ProducersGroup: TProducersGroup2 read GetProducersGroup;
    property DollarCource: Double read FDollarCource write SetDollarCource;
    property EuroCource: Double read FEuroCource write SetEuroCource;
    property IDExtraCharge: TField read GetIDExtraCharge;
    property Euro: TField read GetEuro;
    property Dollar: TField read GetDollar;
    property OnDollarCourceChange: TNotifyEventsEx read FOnDollarCourceChange;
    property OnEuroCourceChange: TNotifyEventsEx read FOnEuroCourceChange;
    property MinWholeSale: TField read GetMinWholeSale;
    property OriginCountry: TField read GetOriginCountry;
    property OriginCountryCode: TField read GetOriginCountryCode;
    property PackagePins: TField read GetPackagePins;
    property Packaging: TField read GetPackaging;
    property PriceE: TField read GetPriceE;
    property PriceE1: TField read GetPriceE1;
    property PriceE2: TField read GetPriceE2;
    property ExtraChargeGroup: TExtraChargeGroup read GetExtraChargeGroup;
    property IDExtraChargeType: TField read GetIDExtraChargeType;
    property ReleaseDate: TField read GetReleaseDate;
    property Retail: TField read GetRetail;
    property SaleCount: TField read GetSaleCount;
    property SaleR: TField read GetSaleR;
    property SaleD: TField read GetSaleD;
    property SaleE: TField read GetSaleE;
    property Seller: TField read GetSeller;
    property Storage: TField read GetStorage;
    property StoragePlace: TField read GetStoragePlace;
    property StorehouseId: TField read GetStorehouseId;
    property Value: TField read GetValue;
    property Wholesale: TField read GetWholesale;
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
  TNotifyEventWrap.Create(BeforeOpen, DoBeforeOpen, FEventList);
  TNotifyEventWrap.Create(BeforePost, DoBeforePost, FEventList);

  // ����� ���� ��������� ������
  FDQuery.OnUpdateRecord := DoOnQueryUpdateRecord;

  // ������� ���� ������� �� ��������� � ����� ��������� �� ��������� ��������
  // FDollarCource := TSettings.Create.DollarCource;

  // �� ��������� �� �� � ������ �������������� ����������
  AutoTransaction := False;

  FCalcStatus := 0;

  FNotGroupClone := AddClone('IsGroup=0');

  FOnDollarCourceChange := TNotifyEventsEx.Create(Self);
  FOnEuroCourceChange := TNotifyEventsEx.Create(Self);
end;

destructor TQueryProductsBase.Destroy;
begin
  FreeAndNil(FOnDollarCourceChange);
  FreeAndNil(FOnEuroCourceChange);

  DropClone(FNotGroupClone);
  FNotGroupClone := nil;

  FreeAndNil(FOnLocate);
  inherited;
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
  // FDQuery.DisableControls;
  TryAppend;
  Value.AsString := '����� ������';
  IsGroup.AsInteger := 0;
  IDComponentGroup.AsInteger := AIDComponentGroup;
  // FDQuery.EnableControls;
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

procedure TQueryProductsBase.ApplyInsert(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
var
  // AErrorMessage: String;
  ARH: TRecordHolder;
  rc: Integer;
begin
  Assert(ASender = FDQuery);

  // ��� ��� ���������, �� �� ��������� ���������
  {
    AErrorMessage := CheckRecord;
    if not AErrorMessage.IsEmpty then
    begin
    AAction := eaFail;
    raise Exception.Create(AErrorMessage);
    end;
  }
  // ���� ���� ��������� ������ ������
  if IsGroup.AsInteger = 1 then
  begin
    // ���� ����� ������ ����������� � �����������
    rc := qSearchComponentGroup.SearchByValue(Value.AsString);
    if rc = 0 then
      qSearchComponentGroup.Append(Value.AsString);

    // ��������� ��������� ����
    FetchFields([PK.FieldName], [qSearchComponentGroup.PK.Value], ARequest,
      AAction, AOptions);
    // PK.Value := qSearchComponentGroup.PK.Value;
    Exit;
  end;

  ARH := TRecordHolder.Create(ASender);
  try
    // ���� ������ �������� ��� ���
    if ProductID.IsNull then
    begin
      // ��������� � ���� ��� �������
      qSearchProduct.InsertRecord(ARH);
      // ���������� ��� ��������
      ARH.Field[ProductID.FieldName] := qSearchProduct.PK.Value;
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

  SaveBookmark;
  FDQuery.DisableControls;
  try
    FDQuery.Connection.Rollback;
    // ���������� ��� �� �� � ����������
    Assert(not FDQuery.Connection.InTransaction);
    RefreshQuery;
    ProducersGroup.ReOpen;

    RestoreBookmark;
  finally
    FDQuery.EnableControls;
  end;

end;

function TQueryProductsBase.CheckRecord: String;
var
  k: Integer;
begin
  Result := '';

  Assert(not IsGroup.IsNull);

  if Value.AsString.Trim.IsEmpty then
  begin
    Result := '���������� ������ ������������';
    Exit;
  end;

  // ��� ������ ������ ���� ��������� ������ ������������
  if IsGroup.AsInteger = 1 then
    Exit;

  if Amount.IsNull then
  begin
    Result := '���������� ������ ����������';
    Exit;
  end;

  if Amount.AsInteger = 0 then
  begin
    Result := '���������� �� ����� ���� ����� ����';
    Exit;
  end;

  k := 0;
  if (not PriceR.IsNull) then
    Inc(k);

  if (not PriceD.IsNull) then
    Inc(k);

  if (not PriceE.IsNull) then
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

  if (Dollar.IsNull) and (DollarCource = 0) then
  begin
    Result := '�� ����� ���� �������';
    Exit;
  end;

  if (Euro.IsNull) and (EuroCource = 0) then
  begin
    Result := '�� ����� ���� ����';
    Exit;
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
      TryEdit;
      IDExtraCharge.Clear;
      IDExtraChargeType.Clear;
      Wholesale.Clear; // ������� �������
      SaleCount.Clear; // ���-�� ������
      TryPost;

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

procedure TQueryProductsBase.DeleteNode(AID: Integer);
var
  AClone: TFDMemTable;
begin
  // FDQuery.DisableControls;
  try
    // ���� ������ ������� ���� �������
    LocateByPK(AID, True);

    // ���� ����� ������� ������
    if IsGroup.AsInteger = 1 then
    begin
      AClone := AddClone(Format('%s=%d', [IDComponentGroup.FieldName,
        PK.AsInteger]));
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

procedure TQueryProductsBase.DoAfterOpen(Sender: TObject);
begin
  SetFieldsRequired(False);
  SetFieldsReadOnly(False);

  Datasheet.OnGetText := OnDatasheetGetText;
  Diagram.OnGetText := OnDatasheetGetText;
  Drawing.OnGetText := OnDatasheetGetText;
  Image.OnGetText := OnDatasheetGetText;
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
  FDQuery.FieldDefs.Add('IDExtraCharge', ftInteger);
  FDQuery.FieldDefs.Add('IDExtraChargeType', ftInteger);

  // ������� ������� �������
  FDQuery.FieldDefs.Add('wholesale', ftFloat);
  // ������� ��������� �������
  // FDQuery.FieldDefs.Add('Retail', ftInteger);

  // ���������� ����
  FDQuery.FieldDefs.Add('PriceR', ftFloat);
  FDQuery.FieldDefs.Add('PriceD', ftFloat);
  FDQuery.FieldDefs.Add('PriceE', ftFloat);

  // ��������� ����
  FDQuery.FieldDefs.Add('PriceR1', ftFloat);
  FDQuery.FieldDefs.Add('PriceD1', ftFloat);
  FDQuery.FieldDefs.Add('PriceE1', ftFloat);

  // ������� ����
  FDQuery.FieldDefs.Add('PriceR2', ftFloat);
  FDQuery.FieldDefs.Add('PriceD2', ftFloat);
  FDQuery.FieldDefs.Add('PriceE2', ftFloat);

  // ���������� �������
  FDQuery.FieldDefs.Add('SaleCount', ftFloat);
  // ��������� ����
  FDQuery.FieldDefs.Add('SaleR', ftFloat);
  FDQuery.FieldDefs.Add('SaleD', ftFloat);
  FDQuery.FieldDefs.Add('SaleE', ftFloat);

  CreateDefaultFields(False);

  // ��������� ����������� ����
  IDExtraCharge.FieldKind := fkInternalCalc;
  IDExtraChargeType.FieldKind := fkInternalCalc;
  Wholesale.FieldKind := fkInternalCalc;
  SaleCount.FieldKind := fkInternalCalc;
  // Retail.FieldKind := fkInternalCalc;

  TunePriceFields([PriceD, PriceR, PriceE, PriceD1, PriceR1, PriceE1, PriceD2,
    PriceR2, PriceE2, SaleR, SaleD, SaleE]);
end;

procedure TQueryProductsBase.DoBeforePost(Sender: TObject);
var
  AErrorMessage: String;
  rc: Integer;
begin
  // ���� �� ���������� ������� ����� ������
  if not(FDQuery.State in [dsInsert]) then
    Exit;

  Assert(not IsGroup.IsNull);

  // ��� ������, ���� ��������� �� ����
  if IsGroup.AsInteger = 1 then
    Exit;

  // ��������� ������ �� ������� ������
  AErrorMessage := CheckRecord;
  if not AErrorMessage.IsEmpty then
    raise Exception.Create(AErrorMessage);

  // �������� ���� �������
  if (Dollar.IsNull) and (DollarCource > 0) then
    Dollar.AsFloat := DollarCource;

  // ������� ���� ����
  if (Euro.IsNull) and (EuroCource > 0) then
    Euro.AsFloat := EuroCource;

  // ��������� ���� ��������, ���� ��� ������
  if LoadDate.IsNull then
    LoadDate.AsString := FormatDateTime('dd.mm.yyyy', Date);;

  // ���� ������������� �����
  if IDProducer.AsInteger > 0 then
  begin
    // ���� ������������� �� ����
    ProducersGroup.qProducers.LocateByPK(IDProducer.AsInteger, True);

    // ���� ��������� � ������������� ���� ������
    rc := qSearchComponentOrFamily.SearchComponentWithProducer(Value.AsString,
      ProducersGroup.qProducers.Name.AsString);
  end
  else
  begin
    // ���� � ������������� ���� ������ �� ������������
    rc := qSearchComponentOrFamily.SearchComponentWithProducer(Value.AsString);
    if rc > 0 then
    begin
      // ���� � ����������� ������ �������������
      ProducersGroup.qProducers.Locate
        (qSearchComponentOrFamily.Producer.AsString, True);

      // ��������� ���� "��� �������������"
      IDProducer.Value := ProducersGroup.qProducers.PK.Value;
    end;
  end;

  // ���� ����� ��������� ������ � ����������� ����
  if rc > 0 then
  begin
    // ����������, ��� ���� ��������� ���� � ������������� ����
    Checked.AsInteger := 1;
    // ���� ��������������� ��������� �����������
    qSearchFamily.SearchByID(qSearchComponentOrFamily.ParentProductID.
      AsInteger, 1);

    // ��������� ������ ���� �� ���������� ����������
    UpdateFields([Datasheet, Diagram, Drawing, Image, DescriptionID],
      [qSearchFamily.Datasheet.Value, qSearchFamily.Diagram.Value,
      qSearchFamily.Drawing.Value, qSearchFamily.Image.Value,
      qSearchFamily.DescriptionID.Value], True);
  end;

  // ���� ������������� �� �����
  if IDProducer.IsNull or (IDProducer.AsInteger = 0) then
  begin
    // ���� ����� ��������� � ����� ������ �� ������
    rc := qSearchProduct.SearchByValue(Value.AsString);
    if rc > 0 then
      // ��������� ��� �������������
      IDProducer.Value := qSearchProduct.IDProducer.Value
    else
      raise Exception.Create('���������� ������ �������������');
  end;

  // ���� ����� ������� � ��� �� ��������������
  // ���� ����� ������� ��� ����
  if qSearchProduct.SearchByValue(Value.AsString, IDProducer.AsInteger) > 0 then
  begin
    // ��������� ������ ���� �� ���������� ��������
    UpdateFields([Datasheet, Diagram, Drawing, Image, DescriptionID, ProductID],
      [qSearchProduct.Datasheet.Value, qSearchProduct.Diagram.Value,
      qSearchProduct.Drawing.Value, qSearchProduct.Image.Value,
      qSearchProduct.DescriptionID.Value, qSearchProduct.PK.Value], True);
  end;

  // ���� ��� ������ ����� - ������ �� �������������
  if not IDCurrency.IsNull then
    Exit;

  // ��������� ���� ������� ����������� �����
  DisableCalc;
  try
    // ���� ��������� ���������� ���� � ������
    if not PriceR.IsNull then
    begin
      Price.Value := PriceR.Value;
      IDCurrency.AsInteger := 1;
    end;

    // ���� ��������� ���������� ���� � ��������
    if not PriceD.IsNull then
    begin
      Price.Value := PriceD.Value;
      IDCurrency.AsInteger := 2;
    end;

    // ���� ��������� ���������� ���� � ����
    if not PriceE.IsNull then
    begin
      Price.Value := PriceE.Value;
      IDCurrency.AsInteger := 3;
    end;

  finally
    // ���� ������������� ������, �� ��������� �������������� ����������� �����
    EnableCalc;
  end;
end;

procedure TQueryProductsBase.EnableCalc;
begin
  Assert(FCalcStatus > 0);
  Dec(FCalcStatus);
  if FCalcStatus = 0 then
    FDQueryCalcFields(FDQuery);
end;

procedure TQueryProductsBase.FDQueryCalcFields(DataSet: TDataSet);
var
  ADCource: Double;
  AECource: Double;
  AWholeSale: Double;
begin
  inherited;

  if (FCalcStatus > 0) or (IDCurrency.AsInteger = 0) or (Price.IsNull) then
    Exit;

  // ������������ � ������ �������
  ADCource := 0;
  // ���� ����� ���� �� ����������� ����
  if DollarCource > 0 then
    ADCource := DollarCource
  else
    // ���� �������� ���� �� ���� �������
    if Dollar.AsFloat > 0 then
      ADCource := Dollar.AsFloat;

  // ������������ � ������ ����
  AECource := 0;
  if EuroCource > 0 then
    AECource := EuroCource
  else
    // ���� �������� ���� �� ���� �������
    if Euro.AsFloat > 0 then
      AECource := Euro.AsFloat;

  // ���� �������� ���� ���� � ������
  if IDCurrency.AsInteger = 1 then
  begin
    PriceR.Value := Price.Value;

    if ADCource > 0 then
      PriceD.Value := Price.Value / ADCource
    else
      PriceD.Value := null;

    if AECource > 0 then
      PriceE.Value := Price.Value / AECource
    else
      PriceE.Value := null;
  end;

  // ���� �������� ���� ���� � ��������
  if IDCurrency.AsInteger = 2 then
  begin
    if ADCource > 0 then
      PriceR.Value := Price.Value * ADCource
    else
      PriceR.Value := null;

    PriceD.Value := Price.Value;

    if (ADCource > 0) and (AECource > 0) then
      PriceE.Value := Price.Value * ADCource / AECource
    else
      PriceE.Value := null;
  end;

  // ���� �������� ���� ���� � ����
  if IDCurrency.AsInteger = 3 then
  begin
    if AECource > 0 then
      PriceR.Value := Price.Value * AECource
    else
      PriceR.Value := null;

    if (ADCource > 0) and (AECource > 0) then
      PriceD.Value := Price.Value * AECource / ADCource
    else
      PriceD.Value := null;

    PriceE.Value := Price.Value;
  end;

  // ��������� ����
  PriceR1.Value := PriceR.Value * (1 + Retail.Value / 100);
  PriceD1.Value := PriceD.Value * (1 + Retail.Value / 100);
  PriceE1.Value := PriceE.Value * (1 + Retail.Value / 100);

  AWholeSale := Wholesale.AsFloat;

  // ���� ������� ������� �� ������ ���� ����������� ������� �������
  if AWholeSale = 0 then
    AWholeSale := MinWholeSale.Value;

  // ������� ����
  PriceR2.Value := PriceR.Value * (1 + AWholeSale / 100);
  PriceD2.Value := PriceD.Value * (1 + AWholeSale / 100);
  PriceE2.Value := PriceE.Value * (1 + AWholeSale / 100);

  // ���� ������� ���������� ������
  if SaleCount.AsFloat > 0 then
  begin
    if SaleCount.AsFloat <= 1 then
    begin
      // ���������� ������� 1 ��. - ���������� ��������� ����
      SaleR.Value := PriceR1.Value;
      SaleD.Value := PriceD1.Value;
      SaleE.Value := PriceE1.Value;
    end
    else
    begin
      // ����� - ������� ����
      SaleR.Value := PriceR2.AsFloat * SaleCount.AsFloat;
      SaleD.Value := PriceD2.AsFloat * SaleCount.AsFloat;
      SaleE.Value := PriceE2.AsFloat * SaleCount.AsFloat;
    end;
  end
  else
  begin
    SaleR.Value := NULL;
    SaleD.Value := NULL;
    SaleE.Value := NULL;
  end;
end;

function TQueryProductsBase.GetAmount: TField;
begin
  Result := Field('Amount');
end;

function TQueryProductsBase.GetBarcode: TField;
begin
  Result := Field('Barcode');
end;

function TQueryProductsBase.GetBatchNumber: TField;
begin
  Result := Field('BatchNumber');
end;

function TQueryProductsBase.GetChecked: TField;
begin
  Result := Field('Checked');
end;

function TQueryProductsBase.GetCustomsDeclarationNumber: TField;
begin
  Result := Field('CustomsDeclarationNumber');
end;

function TQueryProductsBase.GetDatasheet: TField;
begin
  Result := Field('Datasheet');
end;

function TQueryProductsBase.GetDescriptionID: TField;
begin
  Result := Field('DescriptionID');
end;

function TQueryProductsBase.GetLoadDate: TField;
begin
  Result := Field('LoadDate');
end;

function TQueryProductsBase.GetDiagram: TField;
begin
  Result := Field('Diagram');
end;

function TQueryProductsBase.GetDocumentNumber: TField;
begin
  Result := Field('DocumentNumber');
end;

function TQueryProductsBase.GetMinWholeSale: TField;
begin
  Result := Field('MinWholeSale');
end;

function TQueryProductsBase.GetDrawing: TField;
begin
  Result := Field('Drawing');
end;

function TQueryProductsBase.GetIDComponentGroup: TField;
begin
  Result := Field('IDComponentGroup');
end;

function TQueryProductsBase.GetIDCurrency: TField;
begin
  Result := Field('IDCurrency');
end;

function TQueryProductsBase.GetIDExtraCharge: TField;
begin
  Result := Field('IDExtraCharge');
end;

function TQueryProductsBase.GetIDProducer: TField;
begin
  Result := Field('IDProducer');
end;

function TQueryProductsBase.GetImage: TField;
begin
  Result := Field('Image');
end;

function TQueryProductsBase.GetIsGroup: TField;
begin
  Result := Field('IsGroup');
end;

function TQueryProductsBase.GetPrice: TField;
begin
  Result := Field('Price');
end;

function TQueryProductsBase.GetEuro: TField;
begin
  Result := Field('Euro');
end;

function TQueryProductsBase.GetDollar: TField;
begin
  Result := Field('Dollar');
end;

function TQueryProductsBase.GetOriginCountry: TField;
begin
  Result := Field('OriginCountry');
end;

function TQueryProductsBase.GetOriginCountryCode: TField;
begin
  Result := Field('OriginCountryCode');
end;

function TQueryProductsBase.GetPackagePins: TField;
begin
  Result := Field('PackagePins');
end;

function TQueryProductsBase.GetPackaging: TField;
begin
  Result := Field('Packaging');
end;

function TQueryProductsBase.GetPriceD: TField;
begin
  Result := Field('PriceD');
end;

function TQueryProductsBase.GetPriceD1: TField;
begin
  Result := Field('PriceD1');
end;

function TQueryProductsBase.GetPriceD2: TField;
begin
  Result := Field('PriceD2');
end;

function TQueryProductsBase.GetPriceE: TField;
begin
  Result := Field('PriceE');
end;

function TQueryProductsBase.GetPriceE1: TField;
begin
  Result := Field('PriceE1');
end;

function TQueryProductsBase.GetPriceE2: TField;
begin
  Result := Field('PriceE2');
end;

function TQueryProductsBase.GetPriceR: TField;
begin
  Result := Field('PriceR');
end;

function TQueryProductsBase.GetPriceR1: TField;
begin
  Result := Field('PriceR1');
end;

function TQueryProductsBase.GetPriceR2: TField;
begin
  Result := Field('PriceR2');
end;

function TQueryProductsBase.GetProductID: TField;
begin
  Result := Field('ProductID');
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

function TQueryProductsBase.GetIDExtraChargeType: TField;
begin
  Result := Field('IDExtraChargeType');
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

function TQueryProductsBase.GetReleaseDate: TField;
begin
  Result := Field('ReleaseDate');
end;

function TQueryProductsBase.GetRetail: TField;
begin
  Result := Field('Retail');
end;

function TQueryProductsBase.GetSaleCount: TField;
begin
  Result := Field('SaleCount');
end;

function TQueryProductsBase.GetSaleR: TField;
begin
  Result := Field('SaleR');
end;

function TQueryProductsBase.GetSaleD: TField;
begin
  Result := Field('SaleD');
end;

function TQueryProductsBase.GetSaleE: TField;
begin
  Result := Field('SaleE');
end;

function TQueryProductsBase.GetSeller: TField;
begin
  Result := Field('Seller');
end;

function TQueryProductsBase.GetStorage: TField;
begin
  Result := Field('Storage');
end;

function TQueryProductsBase.GetStoragePlace: TField;
begin
  Result := Field('StoragePlace');
end;

function TQueryProductsBase.GetStorehouseId: TField;
begin
  Result := Field('StorehouseId');
end;

function TQueryProductsBase.GetValue: TField;
begin
  Result := Field('Value');
end;

function TQueryProductsBase.GetWholesale: TField;
begin
  Result := Field('WholeSale');
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
  if IDProducer.AsInteger > 0 then
  begin
    // ���� ������������� �� ����
    ProducersGroup.qProducers.LocateByPK(IDProducer.AsInteger, True);

    rc := qSearchComponentOrFamily.SearchComponentWithProducer(Value.AsString,
      ProducersGroup.qProducers.Name.AsString);
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

function TQueryProductsBase.LookupComponentGroup(const AComponentGroup
  : string): Variant;
var
  AKeyFields: string;
  V: Variant;
begin
  AKeyFields := Format('%s;%s', [Value.FieldName, IsGroup.FieldName]);

  V := FDQuery.LookupEx(AKeyFields, VarArrayOf([AComponentGroup, 1]),
    PKFieldName, [lxoCaseInsensitive]);

  Result := V;
end;

procedure TQueryProductsBase.OnDatasheetGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if not Sender.AsString.IsEmpty then
    Text := TPath.GetFileNameWithoutExtension(Sender.AsString);
end;

procedure TQueryProductsBase.SaveExtraCharge;
begin
  Assert(ExtraChargeGroup.qExtraCharge2.FDQuery.RecordCount > 0);
  TryEdit;
  IDExtraCharge.AsInteger := ExtraChargeGroup.qExtraCharge2.PK.AsInteger;
  // ������ ������� ������� �������
  Wholesale.Value := ExtraChargeGroup.qExtraCharge2.Wholesale.Value;
  TryPost;
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
  if IsGroup.AsInteger = 1 then
  begin
    AClone := AddClone(Format('%s=%d', [IDComponentGroup.FieldName,
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

end.
