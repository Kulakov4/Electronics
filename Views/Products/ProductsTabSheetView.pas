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
  dxSkinXmas2008Blue, dxSkinscxPCPainter, dxBarBuiltInMenu, ProductsSearchView,
  GridFrame, ProductsBaseView, ProductsView, StoreHouseInfoView, cxPC,
  dxSkinsdxBarPainter, System.Actions, Vcl.ActnList, cxClasses, dxBar,
  TreeListFrame, ProductsBaseView2, ProductsView2, ProductsSearchView2;

type
  TProductsFrame = class(TFrame)
    cxpcStorehouse: TcxPageControl;
    tsStorehouseInfo: TcxTabSheet;
    ViewStorehouseInfo: TViewStorehouseInfo;
    tsStorehouseProducts: TcxTabSheet;
    tsStorehouseSearch: TcxTabSheet;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    ActionList: TActionList;
    dxBarSubItem1: TdxBarSubItem;
    dxBarSubItem2: TdxBarSubItem;
    actLoadFromExcelDocument: TAction;
    dxBarButton1: TdxBarButton;
    ViewProducts2: TViewProducts2;
    ViewProductsSearch2: TViewProductsSearch2;
    procedure actLoadFromExcelDocumentExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses RepositoryDataModule, DialogUnit2, System.IOUtils, DialogUnit,
  StoreHouseListQuery;

procedure TProductsFrame.actLoadFromExcelDocumentExecute(Sender: TObject);
var
  AFileName: String;
//  m: TArray<String>;
//  qStoreHouseList: TQueryStoreHouseList;
//  S: string;
begin
  // Открываем диалог выбора excel файла из последнего места
  if not TOpenExcelDialog.SelectInLastFolder(AFileName) then
    Exit;

  ViewProducts2.LoadFromExcelDocument(AFileName);
//  S := TPath.GetFileNameWithoutExtension(AFileName);

//  m := S.Split([' ']);
//  if Length(m) <= 1 then
//    TDialog.Create.ErrorMessageDialog('Имя файла не содержит пробел');

  // Всё что до пробела - сокращённое название склада
//  S := m[0];

  // Ищем склад с таким сокращением
  // qStoreHouseList := ViewProductsBase2.ProductBaseGroup.qProducts.Master as TQueryStoreHouseList;

  // Переходим на нужный склад
  // if qStoreHouseList.LocateByAbbreviation(S) then
  // ViewProducts.LoadFromExcelDocument(AFileName)
  // else
  // TDialog.Create.ErrorMessageDialog
  // (Format('Склад с сокращённым названием "%s" не найден', [S]));
end;

end.
