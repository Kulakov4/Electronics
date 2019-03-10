unit BillListView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
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
  cxGridBandedTableView, cxGridDBBandedTableView, cxGrid, BillQuery;

type
  TViewBill = class(TfrmGrid)
    dxBarButton1: TdxBarButton;
  private
    FqBill: TQryBill;
    function GetclBillDate: TcxGridDBBandedColumn;
    function GetW: TBillW;
    procedure SetqBill(const Value: TQryBill);
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    procedure UpdateView; override;
    property clBillDate: TcxGridDBBandedColumn read GetclBillDate;
    property qBill: TQryBill read FqBill write SetqBill;
    property W: TBillW read GetW;
    { Public declarations }
  end;

implementation

uses
  GridSort;

{$R *.dfm}

constructor TViewBill.Create(AOwner: TComponent);
begin
  inherited;
  DeleteMessages.Add(cxGridLevel, 'Вы действительно хотите отменить счёт?');
end;

function TViewBill.GetclBillDate: TcxGridDBBandedColumn;
begin
  Result := MainView.GetColumnByFieldName(W.BillDate.FieldName);
  Assert(Result <> nil);
end;

function TViewBill.GetW: TBillW;
begin
  Assert(FqBill <> nil);
  Result := FqBill.W;
end;

procedure TViewBill.SetqBill(const Value: TQryBill);
begin
  if FqBill = Value then
    Exit;

  FqBill := Value;

  if FqBill = nil then
    Exit;

  MainView.DataController.DataSource := FqBill.W.DataSource;
  MainView.DataController.CreateAllItems(True);

  MainView.OptionsBehavior.ImmediateEditor := False;
  MainView.OptionsSelection.CellMultiSelect := False;
  MainView.OptionsSelection.MultiSelect := False;
  MainView.OptionsSelection.CellSelect := False;

  MainView.OptionsSelection.UnselectFocusedRecordOnExit := False;
  MainView.OptionsSelection.HideSelection := False;

  MainView.OptionsView.ColumnAutoWidth := False;

  GridSort.Add(TSortVariant.Create(clBillDate, [clBillDate]));

  ApplySort(MainView, clBillDate);
  ApplySort(MainView, clBillDate);

  // Фокусируем верхнюю запись в гриде
  FocusTopLeft(W.Number.FieldName);

  UpdateView;

  PostMyApplyBestFitEvent;
end;

procedure TViewBill.UpdateView;
var
  AView: TcxGridDBBandedTableView;
  OK: Boolean;
begin
  OK := (qBill <> nil) and (qBill.FDQuery.Active);
  AView := FocusedTableView;

  // Выделено и не отгружено
  actDeleteEx.Enabled := OK and (AView <> nil) and
    (AView.Controller.SelectedRowCount > 0) and (W.ShipmentDate.F.IsNull);
end;

end.
