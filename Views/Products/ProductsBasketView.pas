unit ProductsBasketView;

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
  cxInplaceContainer, cxDBTL, cxTLData, ProductsQuery, ProductsBaseQuery;

type
  TViewProductsBasket = class(TViewProductsBase2)
    dxBarButton1: TdxBarButton;
    actBasketDelete: TAction;
    actBasketClear: TAction;
    dxBarButton2: TdxBarButton;
    procedure actBasketClearExecute(Sender: TObject);
    procedure actBasketDeleteExecute(Sender: TObject);
  private
    function GetqProducts: TQueryProducts;
    procedure SetqProducts(const Value: TQueryProducts);
    { Private declarations }
  protected
    function GetW: TProductW; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure UpdateView; override;
    property qProducts: TQueryProducts read GetqProducts write SetqProducts;
    { Public declarations }
  end;

implementation

uses
  NotifyEvents, DialogUnit, Data.DB;

{$R *.dfm}

constructor TViewProductsBasket.Create(AOwner: TComponent);
begin
  inherited;
  Name := 'ViewProductsBasket';
end;

procedure TViewProductsBasket.actBasketClearExecute(Sender: TObject);
var
  Arr: TArray<Integer>;
begin
  if not TDialog.Create.ClearBasketDialog then
    Exit;

  Arr := W.ID.AsIntArray;

  // ���������� ��������� cxDBTreeList �� ������!!!
  W.DataSource.Enabled := False;
  try
    qProducts.DeleteFromBasket(Arr);
  finally
    W.DataSource.Enabled := True;
  end;
end;

procedure TViewProductsBasket.actBasketDeleteExecute(Sender: TObject);
begin
  inherited;

  BeginUpdate;
  try
    qProducts.DeleteFromBasket(GetSelectedID);
  finally
    EndUpdate;
  end;
end;

function TViewProductsBasket.GetqProducts: TQueryProducts;
begin
  Result := qProductsBase as TQueryProducts;
end;

function TViewProductsBasket.GetW: TProductW;
begin
{
  if FProductW = nil then
  begin
    Assert(qProductsBase <> nil);
    FProductW := TProductW.Create(qProductsBase.Basket);
  end;
}
  Result := qProducts.W;
end;

procedure TViewProductsBasket.SetqProducts(const Value: TQueryProducts);
begin
  if qProductsBase = Value then
    Exit;

  // ������������ �� �������
  FEventList.Clear;

  qProductsBase := Value;

  MyApplyBestFit;
end;

procedure TViewProductsBasket.UpdateView;
var
  OK: Boolean;
begin
  inherited;
  OK := (cxDBTreeList.DataController.DataSource <> nil) and
    (qProductsBase <> nil) and (qProductsBase.FDQuery.Active);

  actBasketDelete.Enabled := OK and (cxDBTreeList.FocusedNode <> nil) and
    (cxDBTreeList.SelectionCount > 0) and
    (cxDBTreeList.DataController.DataSet.RecordCount > 0);

  actBasketClear.Enabled := actBasketDelete.Enabled
end;

end.