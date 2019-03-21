unit BillContentView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ProductsBaseView2, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxCustomData, cxStyles,
  cxTL, cxMaskEdit, cxDBLookupComboBox, cxDropDownEdit, cxButtonEdit,
  cxTLdxBarBuiltInMenu, cxDataControllerConditionalFormattingRulesManagerDialog,
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
  dxSkinXmas2008Blue, cxDBExtLookupComboBox, Vcl.Menus, System.Actions,
  Vcl.ActnList, dxBar, cxBarEditItem, cxClasses, Vcl.ComCtrls,
  cxInplaceContainer, cxDBTL, cxTLData, BillContentQuery, ProductsBaseQuery,
  cxCurrencyEdit, cxCalendar, Vcl.ExtCtrls;

type
  TViewBillContent = class(TViewProductsBase2)
    dxBarButton1: TdxBarButton;
    procedure cxDBTreeListEditing(Sender: TcxCustomTreeList;
      AColumn: TcxTreeListColumn; var Allow: Boolean);
  private
    function GetqBillContent: TQryBillContent;
    procedure SetqBillContent(const Value: TQryBillContent);
    { Private declarations }
  protected
    function GetW: TProductW; override;
    procedure InitializeColumns; override;
  public
    property qBillContent: TQryBillContent read GetqBillContent
      write SetqBillContent;
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TViewBillContent.cxDBTreeListEditing(Sender: TcxCustomTreeList;
  AColumn: TcxTreeListColumn; var Allow: Boolean);
begin
  inherited;

  Allow := (qBillContent <> nil) and (qBillContent.AllowEdit) and
    (AColumn = clSaleCount);
end;

function TViewBillContent.GetqBillContent: TQryBillContent;
begin
  Result := qProductsBase as TQryBillContent;
end;

function TViewBillContent.GetW: TProductW;
begin
  Result := qBillContent.W;
end;

procedure TViewBillContent.InitializeColumns;
begin
  inherited;

  Assert(qBillContent <> nil);

  InitializeLookupColumn(clStorehouseId, qBillContent.qStoreHouseList.W.DataSource,
    lsEditFixedList, qBillContent.qStoreHouseList.W.Abbreviation.FieldName);
end;

procedure TViewBillContent.SetqBillContent(const Value: TQryBillContent);
begin
  if qProductsBase = Value then
    Exit;

  // Отписываемся от событий
  FEventList.Clear;

  qProductsBase := Value;

end;

end.
