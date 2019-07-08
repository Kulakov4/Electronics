unit ProductsTabSheetView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMetropolis,
  dxSkinMetropolisDark, dxSkinMoneyTwins, dxSkinOffice2007Black,
  dxSkinOffice2007Blue, dxSkinOffice2007Green, dxSkinOffice2007Pink,
  dxSkinOffice2007Silver, dxSkinOffice2010Black, dxSkinOffice2010Blue,
  dxSkinOffice2010Silver, dxSkinOffice2013DarkGray, dxSkinOffice2013LightGray,
  dxSkinOffice2013White, dxSkinOffice2016Colorful, dxSkinOffice2016Dark,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinsDefaultPainters, dxSkinValentine,
  dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, dxSkinscxPCPainter, dxBarBuiltInMenu, GridFrame,
  StoreHouseInfoView, cxPC, dxSkinsdxBarPainter, System.Actions, Vcl.ActnList,
  cxClasses, dxBar, TreeListFrame, ProductsBaseView2, ProductsView2,
  ProductsSearchView2, cxTL, cxStyles, ProductsBasketView;

type
  TProductsFrame = class(TFrame)
    cxpcStorehouse: TcxPageControl;
    tsStorehouseInfo: TcxTabSheet;
    tsStorehouseProducts: TcxTabSheet;
    tsStorehouseSearch: TcxTabSheet;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    ActionList: TActionList;
    dxBarSubItem1: TdxBarSubItem;
    dxBarSubItem2: TdxBarSubItem;
    actLoadFromExcelDocument: TAction;
    dxBarButton1: TdxBarButton;
    dxBarSubItem3: TdxBarSubItem;
    actBindDescriptions: TAction;
    dxBarButton2: TdxBarButton;
    tsBasket: TcxTabSheet;
    procedure actBindDescriptionsExecute(Sender: TObject);
    procedure actLoadFromExcelDocumentExecute(Sender: TObject);
    procedure cxpcStorehousePageChanging(Sender: TObject; NewPage: TcxTabSheet;
      var AllowChange: Boolean);
    procedure tsBasketShow(Sender: TObject);
    procedure tsStorehouseInfoShow(Sender: TObject);
    procedure tsStorehouseProductsShow(Sender: TObject);
    procedure tsStorehouseSearchShow(Sender: TObject);
  private const
    FolderKey: String = 'Products';

  var
    FViewProducts: TViewProducts2;
    FViewProductsBasket: TViewProductsBasket;
    FViewProductsSearch: TViewProductsSearch2;
    FViewStorehouseInfo: TViewStorehouseInfo;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    property ViewProducts: TViewProducts2 read FViewProducts;
    property ViewProductsBasket: TViewProductsBasket read FViewProductsBasket;
    property ViewProductsSearch: TViewProductsSearch2 read FViewProductsSearch;
    property ViewStorehouseInfo: TViewStorehouseInfo read FViewStorehouseInfo;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses RepositoryDataModule, DialogUnit2, System.IOUtils, DialogUnit,
  StoreHouseListQuery, AutoBinding, DataModule;

constructor TProductsFrame.Create(AOwner: TComponent);
begin
  inherited;
  cxpcStorehouse.ActivePage := tsStorehouseInfo;

  FViewStorehouseInfo := TViewStorehouseInfo.Create(Self);
  FViewStorehouseInfo.Parent := tsStorehouseInfo;
  FViewStorehouseInfo.Align := alClient;

  FViewProducts := TViewProducts2.Create(Self);
  FViewProducts.Parent := tsStorehouseProducts;
  FViewProducts.Align := alClient;

  FViewProductsSearch := TViewProductsSearch2.Create(Self);
  FViewProductsSearch.Parent := tsStorehouseSearch;
  FViewProductsSearch.Align := alClient;

  FViewProductsBasket := TViewProductsBasket.Create(Self);
  FViewProductsBasket.Parent := tsBasket;
  FViewProductsBasket.Align := alClient;
end;

procedure TProductsFrame.actBindDescriptionsExecute(Sender: TObject);
begin
  TAutoBind.BindProductDescriptions;
  // ������� ������ � ������� ���������
  ViewProducts.RefreshData;
end;

procedure TProductsFrame.actLoadFromExcelDocumentExecute(Sender: TObject);
var
  AFileName: String;
  // m: TArray<String>;
  // qStoreHouseList: TQueryStoreHouseList;
  // S: string;
begin
  Application.Hint := '';

  if ViewProducts.qProducts.Master.FDQuery.RecordCount = 0 then
  begin
    TDialog.Create.ErrorMessageDialog
      ('��� ���������� � ������� ������.'#13#10'�������� ��������');
    Exit;
  end;

  // ��������� ������ ������ excel ����� �� ���������� �����
  if not TOpenExcelDialog.SelectInFolder(AFileName, Handle, FolderKey) then
    Exit;

  ViewProducts.LoadFromExcelDocument(AFileName);
  // S := TPath.GetFileNameWithoutExtension(AFileName);

  // m := S.Split([' ']);
  // if Length(m) <= 1 then
  // TDialog.Create.ErrorMessageDialog('��� ����� �� �������� ������');

  // �� ��� �� ������� - ����������� �������� ������
  // S := m[0];

  // ���� ����� � ����� �����������
  // qStoreHouseList := ViewProductsBase2.ProductBaseGroup.qProducts.Master as TQueryStoreHouseList;

  // ��������� �� ������ �����
  // if qStoreHouseList.LocateByAbbreviation(S) then
  // ViewProducts.LoadFromExcelDocument(AFileName)
  // else
  // TDialog.Create.ErrorMessageDialog
  // (Format('����� � ����������� ��������� "%s" �� ������', [S]));
end;

procedure TProductsFrame.cxpcStorehousePageChanging(Sender: TObject;
  NewPage: TcxTabSheet; var AllowChange: Boolean);
begin
  Exit;
  {
    // ���� ������ � ������� "������"
    if cxpcStorehouse.ActivePage = tsStorehouseProducts then
    ViewProducts.cxDBTreeList.DataController.DataSource.Enabled := False;
    // ViewProducts.BeginUpdate;

    // ���� ��������� �� ������� "������"
    if (NewPage = tsStorehouseProducts) and (ViewProducts <> nil) and
    (ViewProducts.cxDBTreeList.DataController.DataSource <> nil) then
    ViewProducts.cxDBTreeList.DataController.DataSource.Enabled := True;
    // ViewProducts.EndUpdate;

    // ���� ������ � ������� "�������"
    if (cxpcStorehouse.ActivePage = tsBasket) and (ViewProductsBasket <> nil) and
    (ViewProductsBasket.cxDBTreeList.DataController.DataSource <> nil) then
    ViewProductsBasket.cxDBTreeList.DataController.DataSource.Enabled := False;
    // ViewProductsBasket.BeginUpdate;

    // ���� ��������� �� ������� "�������"
    if (NewPage = tsBasket) and (ViewProductsBasket <> nil) and
    (ViewProductsBasket.cxDBTreeList.DataController.DataSource <> nil) then
    ViewProductsBasket.cxDBTreeList.DataController.DataSource.Enabled := True;
  }
end;

procedure TProductsFrame.tsBasketShow(Sender: TObject);
begin
  // ����������� ������� ����� � ������
  if ViewProductsBasket.qProducts = nil then
    ViewProductsBasket.qProducts := TDM.Create.qProductsBasket;

  TDM.Create.qProductsBasket.SearchForBasket;
  ViewProductsBasket.MyApplyBestFit;
end;

procedure TProductsFrame.tsStorehouseInfoShow(Sender: TObject);
begin
  // ����������� ���������� � ������ � ������
  if ViewStorehouseInfo.qStoreHouseList = nil then
    ViewStorehouseInfo.qStoreHouseList := TDM.Create.qStoreHouseList;

  TDM.Create.qStoreHouseList.W.TryOpen;
end;

procedure TProductsFrame.tsStorehouseProductsShow(Sender: TObject);
begin
  // ����������� ������� ����� � ������
  if ViewProducts.qProducts = nil then
    ViewProducts.qProducts := TDM.Create.qProducts;

  TDM.Create.qStoreHouseList.W.TryOpen;
  // TDM.Create.qProducts.W.TryOpen;
end;

procedure TProductsFrame.tsStorehouseSearchShow(Sender: TObject);
begin
  // ����������� ����� �� ������� � ������
  if ViewProductsSearch.qProductsSearch = nil then
    ViewProductsSearch.qProductsSearch := TDM.Create.qProductsSearch;

  TDM.Create.qProductsSearch.W.TryOpen;
end;

end.
