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
  RepositoryDataModule, System.Generics.Collections, dxCalloutPopup,
  Vcl.ExtCtrls, Vcl.StdCtrls, cxButtons, BillInterface;

type
  TViewBill = class(TfrmGrid, IBill)
    dxBarButton1: TdxBarButton;
    actShip: TAction;
    dxbbShip: TdxBarButton;
    dxBarManagerBar1: TdxBar;
    cxbeiPeriodComboBox: TcxBarEditItem;
    cxbeiBeginDate: TcxBarEditItem;
    cxbeiEndDate: TcxBarEditItem;
    dxbmbPeriod: TdxBar;
    dxBarButton3: TdxBarButton;
    actApplyCustomFilter: TAction;
    cxbeiShippedComboBox: TcxBarEditItem;
    actEdit: TAction;
    dxBarButton4: TdxBarButton;
    dxCalloutPopup: TdxCalloutPopup;
    PopupPanel: TPanel;
    DateTimePicker: TDateTimePicker;
    cxPopupBtnOK: TcxButton;
    Label1: TLabel;
    actExportToExcelDocument: TAction;
    dxBarButton2: TdxBarButton;
    procedure actApplyCustomFilterExecute(Sender: TObject);
    procedure actEditExecute(Sender: TObject);
    procedure actExportToExcelDocumentExecute(Sender: TObject);
    procedure actShipExecute(Sender: TObject);
    procedure cxbeiBeginDateChange(Sender: TObject);
    procedure cxbeiPeriodComboBoxPropertiesEditValueChanged(Sender: TObject);
    procedure cxbeiEndDateChange(Sender: TObject);
    procedure cxbeiShippedComboBoxPropertiesEditValueChanged(Sender: TObject);
    procedure OnNumberGetDisplayText(Sender: TcxCustomGridTableItem;
      ARecord: TcxCustomGridRecord; var AText: string);
    procedure cxGridDBBandedTableViewEditing(Sender: TcxCustomGridTableView;
      AItem: TcxCustomGridTableItem; var AAllow: Boolean);
    procedure cxGridDBBandedTableViewSelectionChanged
      (Sender: TcxCustomGridTableView);
    procedure cxPopupBtnOKClick(Sender: TObject);
    procedure dxCalloutPopupHide(Sender: TObject);
    procedure dxCalloutPopupShow(Sender: TObject);
  strict private
    function GetBillDate: TDate;
    function GetBillID: Integer;
    function GetBillNumber: Integer;
    function GetBillNumberStr: String;
    function GetBillWidth: Integer;
    function GetDollarCource: Double;
    function GetEuroCource: Double;
    function GetShipmentDate: TDate;
  private
    FqBill: TQryBill;

  const
    KeyFolder: String = 'Bill';
    // FReadOnlyFieldList: TList<String>;
    function GetclBillDate: TcxGridDBBandedColumn;
    // FReadOnlyFieldList: TList<String>;
    function GetclID: TcxGridDBBandedColumn;
    function GetclNumber: TcxGridDBBandedColumn;
    function GetclDollar: TcxGridDBBandedColumn;
    function GetclEuro: TcxGridDBBandedColumn;
    function GetclWidth: TcxGridDBBandedColumn;
    function GetclShipmentDate: TcxGridDBBandedColumn;
    function GetW: TBillW;
    procedure SetqBill(const Value: TQryBill);
    { Private declarations }
  protected
    procedure MyDelete; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SelectFocusedBill;
    procedure UpdateView; override;
    property clBillDate: TcxGridDBBandedColumn read GetclBillDate;
    property clID: TcxGridDBBandedColumn read GetclID;
    property clNumber: TcxGridDBBandedColumn read GetclNumber;
    property clDollar: TcxGridDBBandedColumn read GetclDollar;
    property clEuro: TcxGridDBBandedColumn read GetclEuro;
    property clWidth: TcxGridDBBandedColumn read GetclWidth;
    property clShipmentDate: TcxGridDBBandedColumn read GetclShipmentDate;
    property qBill: TQryBill read FqBill write SetqBill;
    property W: TBillW read GetW;
    { Public declarations }
  end;

implementation

uses
  GridSort, CreateBillForm, InsertEditMode, BillContentExportView,
  BillContentExportQuery, DialogUnit, SettingsController, System.IOUtils,
  BillContentExportForm;

{$R *.dfm}

constructor TViewBill.Create(AOwner: TComponent);
begin
  inherited;
  DeleteMessages.Add(cxGridLevel, 'Вы действительно хотите отменить счёт?');

  dxbmbPeriod.Visible := False;

  // FReadOnlyFieldList := TList<String>.Create;
  // cxbeiBeginDate.EditValue := DateToStr(Date - 30);
  // cxbeiEndDate.EditValue := DateToStr(Date);
end;

destructor TViewBill.Destroy;
begin
  // FreeAndNil(FReadOnlyFieldList);
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

procedure TViewBill.actEditExecute(Sender: TObject);
var
  AfrmCreateBill: TFrmCreateBill;
begin
  inherited;
  AfrmCreateBill := TFrmCreateBill.Create(qBill);
  try
    if AfrmCreateBill.ShowModal = mrOK then
      // Сохраняем изменения в счёте
      qBill.W.Save(EditMode, AfrmCreateBill);
  finally
    FreeAndNil(AfrmCreateBill);
  end;
end;

procedure TViewBill.actExportToExcelDocumentExecute(Sender: TObject);
var
  AFileName: String;
//  AFrmBillContentExport: TFrmBillContentExport;
  AInitialFileName: string;
  AItemIndex: Integer;
  AProperties: TcxComboBoxProperties;
  AValue: string;
  qBillContentExport: TQueryBillContentExport;
  AViewBillContentExport: TViewBillContentExport;
  D1: TDate;
  D2: TDate;
  S1: string;
  S2: string;
  // x: Integer;
begin
  inherited;

  Application.Hint := '';
{
  qBillContentExport := TQueryBillContentExport.Create(Self);
  AFrmBillContentExport := TFrmBillContentExport.Create(Self);
  try
    qBillContentExport.W.TryOpen;

    // AFrmBillContentExport.ViewBillContentExport.Font.Assign(Fonf);
    AFrmBillContentExport.ViewBillContentExport.QueryBillContentExport :=
      qBillContentExport;
    AFrmBillContentExport.ShowModal;
  finally
    AFrmBillContentExport.Free;
    qBillContentExport.Free;
  end;

  Exit;
}
  D2 := Date;
  D1 := Date;

  AProperties := TcxComboBoxProperties(cxbeiPeriodComboBox.Properties);
  AValue := VarToStr(cxbeiPeriodComboBox.EditValue);
  AItemIndex := AProperties.Items.IndexOf(AValue);
  case AItemIndex of
    0:
      begin
        // Произвольный период
        S1 := VarToStrDef(cxbeiBeginDate.EditValue, '');
        S2 := VarToStrDef(cxbeiEndDate.EditValue, '');

        if (S1 = '') or (S2 = '') then
          raise Exception.Create('Не задан диапазон дат');

        D1 := StrToDate(S1);
        D2 := StrToDate(S2);
        if D1 > D2 then
        begin
          D2 := StrToDate(S1);
          D1 := StrToDate(S2);
        end;
      end;
    1:
      D1 := Date; // За сегодня
    2:
      D1 := Date - 7; // За 7 дней
    3:
      D1 := Date - 30; // За 30 дней
    4:
      D1 := Date - 365; // За 365 дней
  end;

  if D1 = D2 then
    AInitialFileName := Format('Счета %s.xlsx',
      [FormatDateTime('dd.mm.yyyy', D1)])
  else
    AInitialFileName := Format('Счета %s-%s.xlsx',
      [FormatDateTime('dd.mm.yyyy', D1), FormatDateTime('dd.mm.yyyy', D2)]);

  if not TDialog.Create.ShowDialog(TExcelFileSaveDialog,
    TSettings.Create.GetFolderFoExcelFile(KeyFolder), AInitialFileName,
    AFileName) then
    Exit;

  // Сохраняем этот путь в настройках
  TSettings.Create.SetFolderForExcelFile(KeyFolder,
    TPath.GetDirectoryName(AFileName));

  qBillContentExport := TQueryBillContentExport.Create(Self);
  AViewBillContentExport := TViewBillContentExport.Create(Self);
  try
    // Фильтруем по периоду
    qBillContentExport.SearchByPeriod(D1, D2);
    // Фильтруем по виду отгрузки
    AProperties := TcxComboBoxProperties(cxbeiShippedComboBox.Properties);
    AValue := VarToStr(cxbeiShippedComboBox.EditValue);
    AItemIndex := AProperties.Items.IndexOf(AValue);
    case AItemIndex of
      0:
        qBillContentExport.FDQuery.Filtered := False;
      1:
        qBillContentExport.ExportW.ApplyShipmentFilter; // Отгруженные
      2:
        qBillContentExport.ExportW.ApplyNotShipmentFilter; // Неотгруженные
    end;

    AViewBillContentExport.Font.Assign(Font);
    qBillContentExport.W.TryOpen;

    AViewBillContentExport.QueryBillContentExport := qBillContentExport;
    AViewBillContentExport.ExportToExcelDocument(AFileName);
  finally
    FreeAndNil(AViewBillContentExport);
    FreeAndNil(qBillContentExport);
  end;
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

procedure TViewBill.cxbeiShippedComboBoxPropertiesEditValueChanged
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
var
  ABottomRight: TPoint;
  ATopLeft: TPoint;
  R: TRect;
begin
  inherited;

  R := dxbrMain.Control.GetItemRect(dxbbShip.Links[0].Control);

  ATopLeft := ScreenToClient(dxbrMain.Control.ClientToScreen(R.TopLeft));
  ABottomRight := ScreenToClient(dxbrMain.Control.ClientToScreen
    (R.BottomRight));

  SetFocus;

  dxCalloutPopup.Popup(Self, Rect(ATopLeft, ABottomRight));
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

procedure TViewBill.OnNumberGetDisplayText(Sender: TcxCustomGridTableItem;
  ARecord: TcxCustomGridRecord; var AText: string);
var
  ANumber: Integer;
  S: string;
begin
  if VarIsNull(ARecord.Values[clNumber.Index]) then
    Exit;
  if VarIsNull(ARecord.Values[clWidth.Index]) then
    Exit;

  ANumber := ARecord.Values[clNumber.Index];

  S := '%.' + VarToStrDef(ARecord.Values[clWidth.Index], '0') + 'd';
  AText := Format(S, [ANumber]);
end;

procedure TViewBill.cxGridDBBandedTableViewEditing
  (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
  var AAllow: Boolean);
// var
// ACol: TcxGridDBBandedColumn;
begin
  inherited;
  AAllow := False;
  // ACol := AItem as TcxGridDBBandedColumn;
  // AAllow := FReadOnlyFieldList.IndexOf(ACol.DataBinding.FieldName.ToUpper) = -1;
end;

procedure TViewBill.cxGridDBBandedTableViewSelectionChanged
  (Sender: TcxCustomGridTableView);
begin
  inherited;
  if FqBill = nil then
    Exit;

  W.BillContent.LoadContent(GetBillID, Self);
end;

procedure TViewBill.cxPopupBtnOKClick(Sender: TObject);
begin
  inherited;
  dxCalloutPopup.Close;
  if DateTimePicker.Date <= 0 then
    Exit;

  qBill.W.Ship(DateTimePicker.Date);
  UpdateView;
end;

procedure TViewBill.dxCalloutPopupHide(Sender: TObject);
begin
  inherited;
  UpdateView;
end;

procedure TViewBill.dxCalloutPopupShow(Sender: TObject);
begin
  inherited;
  DateTimePicker.Date := Date;
end;

function TViewBill.GetBillDate: TDate;
var
  ARow: TcxCustomGridRow;
begin
  Result := 0;
  if MainView.Controller.SelectedRowCount > 0 then
  begin
    ARow := MainView.Controller.SelectedRows[0];
    Result := ARow.Values[clBillDate.Index];
  end
end;

function TViewBill.GetBillID: Integer;
var
  ARow: TcxCustomGridRow;
begin
  Result := 0;
  if MainView.Controller.SelectedRowCount > 0 then
  begin
    ARow := MainView.Controller.SelectedRows[0];
    Result := ARow.Values[clID.Index];
  end
end;

function TViewBill.GetBillNumber: Integer;
var
  ARow: TcxCustomGridRow;
begin
  Result := 0;
  if MainView.Controller.SelectedRowCount > 0 then
  begin
    ARow := MainView.Controller.SelectedRows[0];
    Result := ARow.Values[clNumber.Index];
  end
end;

function TViewBill.GetBillNumberStr: String;
var
  ARow: TcxCustomGridRow;
  W: Integer;
begin
  Result := '';
  if MainView.Controller.SelectedRowCount > 0 then
  begin
    ARow := MainView.Controller.SelectedRows[0];
    W := ARow.Values[clWidth.Index];
    Result := Format('%.' + W.ToString + 'd', [GetBillNumber]);
  end
end;

function TViewBill.GetBillWidth: Integer;
var
  ARow: TcxCustomGridRow;
begin
  Result := 0;
  if MainView.Controller.SelectedRowCount > 0 then
  begin
    ARow := MainView.Controller.SelectedRows[0];
    Result := ARow.Values[clWidth.Index];
  end
end;

function TViewBill.GetclBillDate: TcxGridDBBandedColumn;
begin
  Result := MainView.GetColumnByFieldName(W.BillDate.FieldName);
  Assert(Result <> nil);
end;

function TViewBill.GetclID: TcxGridDBBandedColumn;
begin
  Result := MainView.GetColumnByFieldName(W.ID.FieldName);
  Assert(Result <> nil);
end;

function TViewBill.GetclNumber: TcxGridDBBandedColumn;
begin
  Result := MainView.GetColumnByFieldName(W.Number.FieldName);
  Assert(Result <> nil);
end;

function TViewBill.GetclDollar: TcxGridDBBandedColumn;
begin
  Result := MainView.GetColumnByFieldName(W.Dollar.FieldName);
  Assert(Result <> nil);
end;

function TViewBill.GetclEuro: TcxGridDBBandedColumn;
begin
  Result := MainView.GetColumnByFieldName(W.Euro.FieldName);
  Assert(Result <> nil);
end;

function TViewBill.GetclWidth: TcxGridDBBandedColumn;
begin
  Result := MainView.GetColumnByFieldName(W.Width.FieldName);
  Assert(Result <> nil);
end;

function TViewBill.GetclShipmentDate: TcxGridDBBandedColumn;
begin
  Result := MainView.GetColumnByFieldName(W.ShipmentDate.FieldName);
  Assert(Result <> nil);
end;

function TViewBill.GetDollarCource: Double;
var
  ARow: TcxCustomGridRow;
begin
  Result := 0;
  if MainView.Controller.SelectedRowCount > 0 then
  begin
    ARow := MainView.Controller.SelectedRows[0];
    Result := ARow.Values[clDollar.Index];
  end
end;

function TViewBill.GetEuroCource: Double;
var
  ARow: TcxCustomGridRow;
begin
  Result := 0;
  if MainView.Controller.SelectedRowCount > 0 then
  begin
    ARow := MainView.Controller.SelectedRows[0];
    Result := ARow.Values[clEuro.Index];
  end
end;

function TViewBill.GetShipmentDate: TDate;
var
  ARow: TcxCustomGridRow;
begin
  Result := 0;
  if MainView.Controller.SelectedRowCount > 0 then
  begin
    ARow := MainView.Controller.SelectedRows[0];
    if not VarIsNull(ARow.Values[clShipmentDate.Index]) then
      Result := ARow.Values[clShipmentDate.Index];
  end
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
//  Assert(MainView.Controller.SelectedRowCount = 1);

//  if W.ShipmentDate.F.IsNull then
//    ADeleteMessage := 'Вы действительно хотите отменить счёт?'
//  else
//    ADeleteMessage :=
//      'Вы действительно хотите отменить счёт и вернуть товар на склад?';


  ADeleteMessage := 'Действительно удалить выделенные счёта?';
  DeleteMessages.Clear;
  DeleteMessages.Add(cxGridLevel, ADeleteMessage);

  inherited;
end;

procedure TViewBill.SelectFocusedBill;
begin
  ClearSelection;
  SelectFocusedRecord(W.Number.FieldName);
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
  {
    FReadOnlyFieldList.Clear;
    FReadOnlyFieldList.Add(W.Number.FieldName.ToUpper);
    FReadOnlyFieldList.Add(W.BillDate.FieldName.ToUpper);
    //  FReadOnlyFieldList.Add(W.ShipmentDate.FieldName.ToUpper);
    FReadOnlyFieldList.Add(W.Dollar.FieldName.ToUpper);
    FReadOnlyFieldList.Add(W.Euro.FieldName.ToUpper);
  }
  clNumber.OnGetDisplayText := OnNumberGetDisplayText;

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
    (AView.Controller.SelectedRowCount > 0);

  actShip.Enabled := OK and (AView <> nil) and
    (AView.Controller.SelectedRowCount = 1) and (W.ShipmentDate.F.IsNull);

  actEdit.Enabled := OK and (AView <> nil) and
    (AView.Controller.SelectedRowCount = 1);

  actApplyCustomFilter.Enabled := not VarIsNull(cxbeiBeginDate.EditValue) and
    not VarIsNull(cxbeiEndDate.EditValue);

  actExportToExcelDocument.Enabled := OK and (AView <> nil) and
    (AView.ViewData.RowCount > 0);
end;

end.
