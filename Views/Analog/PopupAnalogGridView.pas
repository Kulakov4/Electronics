unit PopupAnalogGridView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, GridViewEx, cxGraphics, cxControls,
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
  dxSkinXmas2008Blue, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, cxNavigator, Data.DB, cxDBData, dxSkinsdxBarPainter,
  Vcl.ExtCtrls, System.ImageList, Vcl.ImgList, cxGridCustomPopupMenu,
  cxGridPopupMenu, Vcl.Menus, System.Actions, Vcl.ActnList, dxBar, cxClasses,
  Vcl.ComCtrls, cxGridLevel, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridBandedTableView, cxGridDBBandedTableView, cxGrid,
  cxDataControllerConditionalFormattingRulesManagerDialog, dxBarBuiltInMenu,
  cxImageList, dxDateRanges, AnalogQueryes;

type
  TViewGridPopupAnalog = class(TViewGridEx)
  private
    function GetclChecked: TcxGridDBBandedColumn;
    function GetclValue: TcxGridDBBandedColumn;
    function GetW: TParameterValuesTableW;
    procedure SetW(const Value: TParameterValuesTableW);
    { Private declarations }
  protected
    procedure InitColumns(AView: TcxGridDBBandedTableView); override;
  public
    property clChecked: TcxGridDBBandedColumn read GetclChecked;
    property clValue: TcxGridDBBandedColumn read GetclValue;
    property W: TParameterValuesTableW read GetW write SetW;
    { Public declarations }
  end;

implementation

uses
  cxCheckBox, cxLabel;

{$R *.dfm}

function TViewGridPopupAnalog.GetclChecked: TcxGridDBBandedColumn;
begin
  Result := MainView.GetColumnByFieldName(W.Checked.FieldName);
end;

function TViewGridPopupAnalog.GetclValue: TcxGridDBBandedColumn;
begin
  Result := MainView.GetColumnByFieldName(W.Value.FieldName);
end;

function TViewGridPopupAnalog.GetW: TParameterValuesTableW;
begin
  Result := DSWrap as TParameterValuesTableW;
end;

procedure TViewGridPopupAnalog.InitColumns(AView: TcxGridDBBandedTableView);
var
  AcxCheckBoxProperties: TcxCheckBoxProperties;
begin
  inherited;
  clChecked.PropertiesClass := TcxCheckBoxProperties;
  AcxCheckBoxProperties := clChecked.Properties as TcxCheckBoxProperties;
  AcxCheckBoxProperties.ValueChecked := 1;
  AcxCheckBoxProperties.ValueUnchecked := 0;
  AcxCheckBoxProperties.ImmediatePost := True;

  clValue.PropertiesClass := TcxLabelProperties;
end;

procedure TViewGridPopupAnalog.SetW(const Value: TParameterValuesTableW);
begin
  if DSWrap = Value then
    Exit;

  DSWrap := Value;
end;

end.
