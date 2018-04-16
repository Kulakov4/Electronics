unit ProductsView2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ProductsBaseView2, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxCustomData, cxStyles,
  cxTL, cxMaskEdit, cxDBLookupComboBox, cxButtonEdit, cxTLdxBarBuiltInMenu,
  dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMetropolis, dxSkinMetropolisDark, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinOffice2013DarkGray,
  dxSkinOffice2013LightGray, dxSkinOffice2013White, dxSkinOffice2016Colorful,
  dxSkinOffice2016Dark, dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic,
  dxSkinSharp, dxSkinSharpPlus, dxSkinSilver, dxSkinSpringTime, dxSkinStardust,
  dxSkinSummer2008, dxSkinTheAsphaltWorld, dxSkinsDefaultPainters,
  dxSkinValentine, dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, dxSkinsdxBarPainter, cxCalc, System.Actions, Vcl.ActnList,
  cxBarEditItem, dxBar, cxClasses, cxInplaceContainer, cxDBTL, cxTLData,
  System.Generics.collections, FieldInfoUnit, ProductsExcelDataModule,
  Vcl.Menus, Vcl.ComCtrls, System.Contnrs, ProgressBarForm2, ExcelDataModule,
  cxDropDownEdit, ProductsQuery, cxTextEdit, Vcl.ExtCtrls,
  cxDBExtLookupComboBox, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator,
  Data.DB, cxDBData, cxGridCustomTableView, cxGridTableView,
  cxGridBandedTableView, cxGridDBBandedTableView, cxGridCustomView, cxGrid,
  cxCalendar;

type
  TViewProducts2 = class(TViewProductsBase2)
    dxBarSubItem1: TdxBarSubItem;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    dxBarButton3: TdxBarButton;
    dxBarButton4: TdxBarButton;
    dxBarButton5: TdxBarButton;
    dxBarButton6: TdxBarButton;
    dxBarSubItem2: TdxBarSubItem;
    dxBarButton9: TdxBarButton;
    Timer: TTimer;
    cxbeiDate: TcxBarEditItem;
    actColumnsAutoWidth2: TAction;
    dxBarButton7: TdxBarButton;
    actFullScreen: TAction;
    dxBarButton8: TdxBarButton;
    actFilterAndExportToExcelDocument: TAction;
    dxBarButton10: TdxBarButton;
    actShowStoreHouseID: TAction;
    procedure actColumnsAutoWidth2Execute(Sender: TObject);
    procedure actExportToExcelDocument2Execute(Sender: TObject);
    procedure actFilterAndExportToExcelDocumentExecute(Sender: TObject);
    procedure actFullScreenExecute(Sender: TObject);
    procedure actShowStoreHouseIDExecute(Sender: TObject);
    procedure cxBarEditItem1PropertiesValidate(Sender: TObject;
      var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
    procedure TimerTimer(Sender: TObject);
    procedure cxbeiWholeSalePropertiesCloseUp(Sender: TObject);
  private
    procedure DoBeforeLoad(ASender: TObject);
    function GetqProducts: TQueryProducts;
    procedure SetqProducts(const Value: TQueryProducts);
    { Private declarations }
  protected
    function CreateProductView: TViewProductsBase2; override;
    procedure UpdateProductCount; override;
  public
    procedure LoadFromExcelDocument(const AFileName: String);
    property qProducts: TQueryProducts read GetqProducts write SetqProducts;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses RepositoryDataModule, ProgressBarForm, ProjectConst, CustomExcelTable,
  NotifyEvents, ProgressInfo, LoadFromExcelFileHelper,
  CustomErrorForm, HttpUnit, ProductsViewForm, DialogUnit;

procedure TViewProducts2.actColumnsAutoWidth2Execute(Sender: TObject);
begin
  inherited;
  // cxDBTreeList.BeginUpdate;
  // try
  cxDBTreeList.Root.Expand(true);

  MyApplyBestFit;
  // cxDBTreeList.Root.Collapse(true);
  // finally
  // cxDBTreeList.EndUpdate;
  // end;
end;

procedure TViewProducts2.actExportToExcelDocument2Execute(Sender: TObject);
var
  AFileName: String;
  AViewProducts2: TViewProducts2;
begin
  inherited;
  if not TDialog.Create.ShowDialog(TExcelFileSaveDialog, '',
    qProductsBase.ExportFileName, AFileName) then
    Exit;

  AViewProducts2 := TViewProducts2.Create(nil);
  try
    AViewProducts2.qProducts := qProducts;
    AViewProducts2.ExportToExcelDocument(AFileName);
  finally
    FreeAndNil(AViewProducts2);
  end;
end;

procedure TViewProducts2.actFilterAndExportToExcelDocumentExecute
  (Sender: TObject);
var
  AFileName: String;
  AIDArray: TArray<Integer>;
  AQueryProducts: TQueryProducts;
  AViewProducts2: TViewProducts2;
  rc: Integer;
begin
  inherited;
  if not TDialog.Create.ShowDialog(TExcelFileSaveDialog, '',
    qProductsBase.ExportFileName, AFileName) then
    Exit;

  AIDArray := GetSelectedID;

  AQueryProducts := TQueryProducts.Create(nil);
  try
    rc := AQueryProducts.SearchByID(AIDArray);
    Assert(rc > 0);
    AViewProducts2 := TViewProducts2.Create(nil);
    try
      AViewProducts2.qProducts := AQueryProducts;
      AViewProducts2.ExportToExcelDocument(AFileName);
    finally
      FreeAndNil(AViewProducts2);
    end;
  finally
    FreeAndNil(AQueryProducts);
  end;
end;

procedure TViewProducts2.actFullScreenExecute(Sender: TObject);
begin
  inherited;
  if frmProducts = nil then
  begin
    frmProducts := TfrmProducts.Create(Self);
    frmProducts.ViewProducts2.qProducts := qProducts;
  end;
  frmProducts.Show;
end;

procedure TViewProducts2.actShowStoreHouseIDExecute(Sender: TObject);
var
  S: string;
begin
  inherited;
  S := qProducts.FDQuery.Params.ParamByName
    (qProducts.DetailParameterName).AsString;
  ShowMessage(S);
end;

function TViewProducts2.CreateProductView: TViewProductsBase2;
begin
  Result := TViewProducts2.Create(nil);
end;

procedure TViewProducts2.cxBarEditItem1PropertiesValidate(Sender: TObject;
  var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
var
  x: Double;
begin
  inherited;
  x := StrToFloatDef(DisplayValue, 0);
  if x > 0 then
    Exit;

  ErrorText := '������������� �������� �� �������� ������ ������';
  Error := true;
end;

procedure TViewProducts2.cxbeiWholeSalePropertiesCloseUp(Sender: TObject);
begin
  inherited;;
end;

procedure TViewProducts2.DoBeforeLoad(ASender: TObject);
begin
  UpdateView;
  { ��� ������ ������� ������ ��������� ������� ��������� � ������ ������ }
  if CheckAndSaveChanges = IDCANCEL then
    raise EAbort.Create('Cancel scroll');
end;

function TViewProducts2.GetqProducts: TQueryProducts;
begin
  Result := qProductsBase as TQueryProducts;
end;

procedure TViewProducts2.LoadFromExcelDocument(const AFileName: String);
var
  AExcelTable: TProductsExcelTable;
begin
  Assert(not AFileName.IsEmpty);

  BeginUpdate;
  try
    TLoad.Create.LoadAndProcess(AFileName, TProductsExcelDM, TfrmCustomError,
      procedure(ASender: TObject)
      begin
        qProducts.LoadDataFromExcelTable(ASender as TProductsExcelTable);
      end,
      procedure(ASender: TObject)
      begin
        AExcelTable := ASender as TProductsExcelTable;
        // �������������� ���� ������� � ����
        AExcelTable.DollarCource := qProducts.DollarCource;
        AExcelTable.EuroCource := qProducts.EuroCource;
        AExcelTable.CheckDuplicate := qProducts;
      end);
  finally
    cxDBTreeList.FullCollapse;
    EndUpdate;
  end;
end;

procedure TViewProducts2.SetqProducts(const Value: TQueryProducts);
begin
  if qProductsBase = Value then
    Exit;

  // ������������ �� �������
  FEventList.Clear;

  qProductsBase := Value;
  if qProductsBase <> nil then
  begin
    TNotifyEventWrap.Create(qProducts.BeforeLoad, DoBeforeLoad, FEventList);
  end;
end;

procedure TViewProducts2.TimerTimer(Sender: TObject);
begin
  inherited;
  cxbeiDate.EditValue := DateToStr(Date);
end;

procedure TViewProducts2.UpdateProductCount;
begin
  inherited;

  // ��������� ���������� ��������� �� ���� �������
  StatusBar.Panels[3].Text := Format('%d', [qProducts.TotalCount]);
end;

end.
