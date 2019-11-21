unit BillListView;

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
  cxGridBandedTableView, cxGridDBBandedTableView, cxGrid, BillQuery,
  cxDropDownEdit, dxDateTimeWheelPicker, cxBarEditItem, cxCalendar,
  RepositoryDataModule, System.Generics.Collections;

type
  TViewBill = class(TfrmGrid)
    dxBarButton1: TdxBarButton;
    actShip: TAction;
    dxBarButton2: TdxBarButton;
    dxBarManagerBar1: TdxBar;
    cxbeiPeriodComboBox: TcxBarEditItem;
    cxbeiBeginDate: TcxBarEditItem;
    cxbeiEndDate: TcxBarEditItem;
    dxbmbPeriod: TdxBar;
    dxBarButton3: TdxBarButton;
    actApplyCustomFilter: TAction;
    cxbeiShippedComboBox: TcxBarEditItem;
    cxGridDBBandedTableViewColumn1: TcxGridDBBandedColumn;
    procedure actApplyCustomFilterExecute(Sender: TObject);
    procedure actShipExecute(Sender: TObject);
    procedure cxbeiBeginDateChange(Sender: TObject);
    procedure cxbeiPeriodComboBoxPropertiesEditValueChanged(Sender: TObject);
    procedure cxbeiEndDateChange(Sender: TObject);
    procedure cxbeiShippedComboBoxPropertiesEditValueChanged(Sender: TObject);
    procedure cxGridDBBandedTableViewEditing(Sender: TcxCustomGridTableView; AItem:
        TcxCustomGridTableItem; var AAllow: Boolean);
  private
    FqBill: TQryBill;
    FReadOnlyFieldList: TList<String>;
    function GetclBillDate: TcxGridDBBandedColumn;
    function GetclNumber: TcxGridDBBandedColumn;
    function GetW: TBillW;
    procedure SetqBill(const Value: TQryBill);
    { Private declarations }
  protected
    procedure MyDelete; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure UpdateView; override;
    property clBillDate: TcxGridDBBandedColumn read GetclBillDate;
    property clNumber: TcxGridDBBandedColumn read GetclNumber;
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

  dxbmbPeriod.Visible := False;

  FReadOnlyFieldList := TList<String>.Create;
//  cxbeiBeginDate.EditValue := DateToStr(Date - 30);
//  cxbeiEndDate.EditValue := DateToStr(Date);
end;

destructor TViewBill.Destroy;
begin
  FreeAndNil(FReadOnlyFieldList);
  inherited;
end;

procedure TViewBill.actApplyCustomFilterExecute(Sender: TObject);
var
  D1: TDate;
  D2: TDate;
  S1: string;
  S2: string;
begin
  inherited;
  S1 := VarToStrDef(cxbeiBeginDate.EditValue, '');
  S2 := VarToStrDef(cxbeiEndDate.EditValue, '');

  if (S1 = '') or (S2 = '') then
    Exit;

  D1 := StrToDate(S1);
  D2 := StrToDate(S2);

  qBill.SearchByPeriod(D1, D2); // За произвольный период
end;

procedure TViewBill.cxbeiPeriodComboBoxPropertiesEditValueChanged
  (Sender: TObject);
var
  AcxComboBox: TcxComboBox;
begin
  inherited;

  if qBill = nil then
    Exit;

  AcxComboBox := Sender as TcxComboBox;
  // Сохраняем значение
  AcxComboBox.PostEditValue;
  dxbmbPeriod.Visible := AcxComboBox.ItemIndex = 0;

  case AcxComboBox.ItemIndex of
    1:
      qBill.SearchByPeriod(Date, Date); // Сегодня
    2:
      qBill.SearchByPeriod(Date - 7, Date); // За 7 дней
    3:
      qBill.SearchByPeriod(Date - 30, Date); // За 30 дней
    4:
      qBill.SearchByPeriod(Date - 365, Date); // За 365 дней
  end;
end;

procedure TViewBill.cxbeiShippedComboBoxPropertiesEditValueChanged(
  Sender: TObject);
var
  AcxComboBox: TcxComboBox;
begin
  inherited;
  if qBill = nil then
    Exit;

  AcxComboBox := Sender as TcxComboBox;
  // Сохраняем значение
  AcxComboBox.PostEditValue;

  case AcxComboBox.ItemIndex of
    0:
      qBill.FDQuery.Filtered := False;
    1:
      qBill.W.ApplyShipmentFilter; // Отгруженные
    2:
      qBill.W.ApplyNotShipmentFilter; // Неотгруженные
  end;
end;

procedure TViewBill.actShipExecute(Sender: TObject);
begin
  inherited;
  qBill.W.Ship;
end;

procedure TViewBill.cxbeiBeginDateChange(Sender: TObject);
begin
  inherited;
  UpdateView;
end;

procedure TViewBill.cxbeiEndDateChange(Sender: TObject);
begin
  inherited;
  UpdateView;
end;

procedure TViewBill.cxGridDBBandedTableViewEditing(Sender:
    TcxCustomGridTableView; AItem: TcxCustomGridTableItem; var AAllow: Boolean);
var
  ACol: TcxGridDBBandedColumn;
begin
  inherited;
  ACol := AItem as TcxGridDBBandedColumn;

  AAllow := FReadOnlyFieldList.IndexOf(ACol.DataBinding.FieldName.ToUpper) = -1;
end;

function TViewBill.GetclBillDate: TcxGridDBBandedColumn;
begin
  Result := MainView.GetColumnByFieldName(W.BillDate.FieldName);
  Assert(Result <> nil);
end;

function TViewBill.GetclNumber: TcxGridDBBandedColumn;
begin
  Result := MainView.GetColumnByFieldName(W.Number.FieldName);
  Assert(Result <> nil);
end;

function TViewBill.GetW: TBillW;
begin
  Assert(FqBill <> nil);
  Result := FqBill.W;
end;

procedure TViewBill.MyDelete;
var
  ADeleteMessage: string;
begin
  Assert(MainView.Controller.SelectedRowCount = 1);

  if W.ShipmentDate.F.IsNull then
    ADeleteMessage := 'Вы действительно хотите отменить счёт?'
  else
    ADeleteMessage :=
      'Вы действительно хотите отменить счёт и вернуть товар на склад?';

  DeleteMessages.Clear;
  DeleteMessages.Add(cxGridLevel, ADeleteMessage);

  inherited;
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

  FReadOnlyFieldList.Clear;
  FReadOnlyFieldList.Add(W.Number.FieldName.ToUpper);
  FReadOnlyFieldList.Add(W.BillDate.FieldName.ToUpper);
//  FReadOnlyFieldList.Add(W.ShipmentDate.FieldName.ToUpper);
  FReadOnlyFieldList.Add(W.Dollar.FieldName.ToUpper);
  FReadOnlyFieldList.Add(W.Euro.FieldName.ToUpper);

{
  MainView.OptionsBehavior.ImmediateEditor := False;
  MainView.OptionsSelection.CellMultiSelect := False;
  MainView.OptionsSelection.MultiSelect := False;
  MainView.OptionsSelection.CellSelect := False;

  MainView.OptionsSelection.UnselectFocusedRecordOnExit := False;
  MainView.OptionsSelection.HideSelection := False;
}
  MainView.OptionsView.ColumnAutoWidth := False;

  GridSort.Add(TSortVariant.Create(clNumber, [clNumber]));

  ApplySort(MainView, clNumber);
  ApplySort(MainView, clNumber);

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

  // Выделено
  actDeleteEx.Enabled := OK and (AView <> nil) and
    (AView.Controller.SelectedRowCount = 1);

  actShip.Enabled := OK and (AView <> nil) and
    (AView.Controller.SelectedRowCount = 1) and (W.ShipmentDate.F.IsNull);

  actApplyCustomFilter.Enabled := not VarIsNull(cxbeiBeginDate.EditValue) and
    not VarIsNull(cxbeiEndDate.EditValue);
end;

end.
