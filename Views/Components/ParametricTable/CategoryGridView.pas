unit CategoryGridView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, GridFrame, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
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
  dxSkinXmas2008Blue, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit,
  cxNavigator, cxDataControllerConditionalFormattingRulesManagerDialog, Data.DB,
  cxDBData, dxBarBuiltInMenu, cxGridCustomPopupMenu, cxGridPopupMenu, Vcl.Menus,
  System.Actions, Vcl.ActnList, dxBar, cxClasses, Vcl.ComCtrls, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridBandedTableView, cxGridDBBandedTableView, cxGrid,
  ProductCategoriesMemTable, cxCheckBox;

type
  TViewCategory = class(TfrmGrid)
  private
    FProductCategoriesMemTbl: TProductCategoriesMemTbl;
    function GetclChecked: TcxGridDBBandedColumn;
    procedure SetProductCategoriesMemTbl(const Value: TProductCategoriesMemTbl);
    { Private declarations }
  protected
    procedure InitColumns; virtual;
  public
    property clChecked: TcxGridDBBandedColumn read GetclChecked;
    property ProductCategoriesMemTbl: TProductCategoriesMemTbl
      read FProductCategoriesMemTbl write SetProductCategoriesMemTbl;
    { Public declarations }
  end;

implementation

{$R *.dfm}

function TViewCategory.GetclChecked: TcxGridDBBandedColumn;
begin
  Result := MainView.GetColumnByFieldName
    (ProductCategoriesMemTbl.W.Checked.FieldName);
end;

procedure TViewCategory.InitColumns;
begin
  MainView.OptionsView.ColumnAutoWidth := False;
  MainView.DataController.CreateAllItems(True);

  clChecked.PropertiesClass := TcxCheckBoxProperties;
  (clChecked.Properties as TcxCheckBoxProperties).ValueChecked := 1;
  (clChecked.Properties as TcxCheckBoxProperties).ValueUnchecked := 0;
  (clChecked.Properties as TcxCheckBoxProperties).ValueGrayed := NULL;

  MyApplyBestFit;
end;

procedure TViewCategory.SetProductCategoriesMemTbl
  (const Value: TProductCategoriesMemTbl);
begin
  if FProductCategoriesMemTbl = Value then
    Exit;

  FProductCategoriesMemTbl := Value;

  if FProductCategoriesMemTbl = nil then
  begin
    MainView.DataController.DataSource := nil;
    Exit;
  end;

  MainView.DataController.DataSource := FProductCategoriesMemTbl.W.DataSource;
  InitColumns;
end;

end.
