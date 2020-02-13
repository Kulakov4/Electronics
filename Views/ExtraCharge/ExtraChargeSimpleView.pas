unit ExtraChargeSimpleView;

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
  cxGridBandedTableView, cxGridDBBandedTableView, cxGrid, ExtraChargeQuery2,
  dxDateRanges, cxDropDownEdit, NotifyEvents;

type
  TViewExtraChargeSimple = class(TfrmGrid)
    procedure cxGridDBBandedTableViewCellClick(Sender: TcxCustomGridTableView;
        ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton; AShift:
        TShiftState; var AHandled: Boolean);
  private
    FOnClosePopup: TNotifyEventsEx;
    FqExtraCharge: TQueryExtraCharge2;
    function GetPopupWindow: TcxCustomEditPopupWindow;
    procedure SetqExtraCharge(const Value: TQueryExtraCharge2);
    { Private declarations }
  protected
    procedure InitView(AView: TcxGridDBBandedTableView); override;
    property PopupWindow: TcxCustomEditPopupWindow read GetPopupWindow;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property qExtraCharge: TQueryExtraCharge2 read FqExtraCharge
      write SetqExtraCharge;
    property OnClosePopup: TNotifyEventsEx read FOnClosePopup;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TViewExtraChargeSimple.Create(AOwner: TComponent);
begin
  inherited;
  FOnClosePopup := TNotifyEventsEx.Create(Self);

end;

destructor TViewExtraChargeSimple.Destroy;
begin
  FreeAndNil(FOnClosePopup);
  inherited;
end;

procedure TViewExtraChargeSimple.cxGridDBBandedTableViewCellClick(Sender:
    TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
    AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  inherited;
  PopupWindow.CloseUp;
  FOnClosePopup.CallEventHandlers(Self);
end;

function TViewExtraChargeSimple.GetPopupWindow: TcxCustomEditPopupWindow;
var
  PopupWindow: TCustomForm;
begin
  PopupWindow := GetParentForm(Self);
  Result := PopupWindow as TcxCustomEditPopupWindow;
end;

procedure TViewExtraChargeSimple.InitView(AView: TcxGridDBBandedTableView);
begin
  AView.OptionsBehavior.ImmediateEditor := False;
  AView.OptionsView.FocusRect := False;
  AView.OptionsSelection.MultiSelect := False;
  AView.OptionsSelection.CellMultiSelect := False;
  AView.OptionsSelection.CellSelect := False;
  // AView.Styles.Inactive := DMRepository.cxInactiveStyle;
end;

procedure TViewExtraChargeSimple.SetqExtraCharge(const Value
  : TQueryExtraCharge2);
begin
  if FqExtraCharge = Value then
    Exit;

  FqExtraCharge := Value;

  if FqExtraCharge = nil then
  begin
    MainView.DataController.DataSource := nil;
    Exit;
  end;

  MainView.DataController.DataSource := qExtraCharge.W.DataSource;
  MainView.DataController.KeyFieldNames := qExtraCharge.W.PKFieldName;
  MainView.DataController.CreateAllItems();
  MyApplyBestFit;
end;

end.
