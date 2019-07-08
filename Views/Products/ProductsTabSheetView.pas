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
  // Обновим данные в текущей категории
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
      ('Нет информации о текущем складе.'#13#10'Действие отменено');
    Exit;
  end;

  // Открываем диалог выбора excel файла из последнего места
  if not TOpenExcelDialog.SelectInFolder(AFileName, Handle, FolderKey) then
    Exit;

  ViewProducts.LoadFromExcelDocument(AFileName);
  // S := TPath.GetFileNameWithoutExtension(AFileName);

  // m := S.Split([' ']);
  // if Length(m) <= 1 then
  // TDialog.Create.ErrorMessageDialog('Имя файла не содержит пробел');

  // Всё что до пробела - сокращённое название склада
  // S := m[0];

  // Ищем склад с таким сокращением
  // qStoreHouseList := ViewProductsBase2.ProductBaseGroup.qProducts.Master as TQueryStoreHouseList;

  // Переходим на нужный склад
  // if qStoreHouseList.LocateByAbbreviation(S) then
  // ViewProducts.LoadFromExcelDocument(AFileName)
  // else
  // TDialog.Create.ErrorMessageDialog
  // (Format('Склад с сокращённым названием "%s" не найден', [S]));
end;

procedure TProductsFrame.cxpcStorehousePageChanging(Sender: TObject;
  NewPage: TcxTabSheet; var AllowChange: Boolean);
begin
  Exit;
  {
    // Если уходим с вкладки "Товары"
    if cxpcStorehouse.ActivePage = tsStorehouseProducts then
    ViewProducts.cxDBTreeList.DataController.DataSource.Enabled := False;
    // ViewProducts.BeginUpdate;

    // Если переходим на вкладку "Товары"
    if (NewPage = tsStorehouseProducts) and (ViewProducts <> nil) and
    (ViewProducts.cxDBTreeList.DataController.DataSource <> nil) then
    ViewProducts.cxDBTreeList.DataController.DataSource.Enabled := True;
    // ViewProducts.EndUpdate;

    // Если уходим с вкладки "Корзина"
    if (cxpcStorehouse.ActivePage = tsBasket) and (ViewProductsBasket <> nil) and
    (ViewProductsBasket.cxDBTreeList.DataController.DataSource <> nil) then
    ViewProductsBasket.cxDBTreeList.DataController.DataSource.Enabled := False;
    // ViewProductsBasket.BeginUpdate;

    // Если переходим на вкладку "Корзина"
    if (NewPage = tsBasket) and (ViewProductsBasket <> nil) and
    (ViewProductsBasket.cxDBTreeList.DataController.DataSource <> nil) then
    ViewProductsBasket.cxDBTreeList.DataController.DataSource.Enabled := True;
  }
end;

procedure TProductsFrame.tsBasketShow(Sender: TObject);
begin
  // Привязываем текущий склад к данным
  if ViewProductsBasket.qProducts = nil then
    ViewProductsBasket.qProducts := TDM.Create.qProductsBasket;

  TDM.Create.qProductsBasket.SearchForBasket;
  ViewProductsBasket.MyApplyBestFit;
end;

procedure TProductsFrame.tsStorehouseInfoShow(Sender: TObject);
begin
  // Привязываем информацию о складе к данным
  if ViewStorehouseInfo.qStoreHouseList = nil then
    ViewStorehouseInfo.qStoreHouseList := TDM.Create.qStoreHouseList;

  TDM.Create.qStoreHouseList.W.TryOpen;
end;

procedure TProductsFrame.tsStorehouseProductsShow(Sender: TObject);
begin
  // Привязываем текущий склад к данным
  if ViewProducts.qProducts = nil then
    ViewProducts.qProducts := TDM.Create.qProducts;

  TDM.Create.qStoreHouseList.W.TryOpen;
  // TDM.Create.qProducts.W.TryOpen;
end;

procedure TProductsFrame.tsStorehouseSearchShow(Sender: TObject);
begin
  // Привязываем поиск по складам к данным
  if ViewProductsSearch.qProductsSearch = nil then
    ViewProductsSearch.qProductsSearch := TDM.Create.qProductsSearch;

  TDM.Create.qProductsSearch.W.TryOpen;
end;

end.
