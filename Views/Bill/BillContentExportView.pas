unit BillContentExportView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
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
  dxSkinXmas2008Blue, cxDBExtLookupComboBox, cxCalendar, cxCurrencyEdit,
  Vcl.ExtCtrls, Vcl.Menus, System.Actions, Vcl.ActnList, dxBar, cxBarEditItem,
  cxClasses, Vcl.ComCtrls, cxInplaceContainer, cxDBTL, cxTLData,
  BillContentExportQuery, ProductsBaseQuery;

type
  TViewBillContentExport = class(TViewProductsBase2)
    clBillNumber: TcxDBTreeListColumn;
    clBillDate: TcxDBTreeListColumn;
    clShipmentDate: TcxDBTreeListColumn;
  private
    function GetQueryBillContentExport: TQueryBillContentExport;
    procedure SetQueryBillContentExport(const Value: TQueryBillContentExport);
    { Private declarations }
  protected
    function CreateProductView: TViewProductsBase2; override;
    function GetW: TProductW; override;
  public
    property QueryBillContentExport: TQueryBillContentExport read
        GetQueryBillContentExport write SetQueryBillContentExport;
    { Public declarations }
  end;

implementation

{$R *.dfm}

function TViewBillContentExport.CreateProductView: TViewProductsBase2;
begin
  Result := TViewBillContentExport.Create(nil);
end;

function TViewBillContentExport.GetQueryBillContentExport:
    TQueryBillContentExport;
begin
  Result := qProductsBase as TQueryBillContentExport;
end;

function TViewBillContentExport.GetW: TProductW;
begin
  Result := QueryBillContentExport.W;
end;

procedure TViewBillContentExport.SetQueryBillContentExport(const Value:
    TQueryBillContentExport);
begin
  if qProductsBase = Value then
    Exit;

  // ������������ �� �������
  FEventList.Clear;

  qProductsBase := Value;
end;

end.
