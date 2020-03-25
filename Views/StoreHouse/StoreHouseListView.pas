unit StoreHouseListView;

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
  cxGridBandedTableView, cxGridDBBandedTableView, cxGrid, StoreHouseListQuery,
  NotifyEvents, dxDateRanges, StoreHouseListInterface;

type
  TViewStoreHouse = class(TfrmGrid, IStorehouseList)
    actAddStorehouse: TAction;
    actRenameStorehouse: TAction;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    cxStyleRepository1: TcxStyleRepository;
    cxStyleInactive: TcxStyle;
    actStoreHouseInfo: TAction;
    N5: TMenuItem;
    procedure actAddStorehouseExecute(Sender: TObject);
    procedure actRenameStorehouseExecute(Sender: TObject);
    procedure actStoreHouseInfoExecute(Sender: TObject);
    procedure cxGridDBBandedTableViewCanFocusRecord
      (Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
      var AAllow: Boolean);
    procedure cxGridDBBandedTableViewEditValueChanged
      (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem);
    procedure cxGridDBBandedTableViewSelectionChanged
      (Sender: TcxCustomGridTableView);
  strict private
    function GetStoreHouseCount: Integer;
    function GetStoreHouseTitle: string;
  private
    FOnCanFocusRecord: TNotifyEventsEx;
    FPosting: Boolean;
    FqStoreHouseList: TQueryStoreHouseList;
    procedure DoBeforeMonitorApplyUpdates(Sender: TObject);
    function GetclAbbreviation: TcxGridDBBandedColumn;
    function GetclTitle: TcxGridDBBandedColumn;
    function GetclID: TcxGridDBBandedColumn;
    function GetStoreHouseID: Integer;
    function GetW: TStoreHouseListW;
    procedure SetqStoreHouseList(const Value: TQueryStoreHouseList);
    { Private declarations }
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure FreeInt;
    procedure UpdateView; override;
    property clAbbreviation: TcxGridDBBandedColumn read GetclAbbreviation;
    property clTitle: TcxGridDBBandedColumn read GetclTitle;
    property clID: TcxGridDBBandedColumn read GetclID;
    property qStoreHouseList: TQueryStoreHouseList read FqStoreHouseList
      write SetqStoreHouseList;
    property StoreHouseID: Integer read GetStoreHouseID;
    property W: TStoreHouseListW read GetW;
    property OnCanFocusRecord: TNotifyEventsEx read FOnCanFocusRecord;
    { Public declarations }
  end;

  TOnCanFocusRecord = class(TObject)
  private
    FAllow: Boolean;
  public
    property Allow: Boolean read FAllow write FAllow;
  end;

implementation

uses
  ProjectConst, StoreHouseForm;

{$R *.dfm}

constructor TViewStoreHouse.Create(AOwner: TComponent);
begin
  inherited;
  DeleteMessages.Add(cxGridLevel, 'Удалить склад?');

  FOnCanFocusRecord := TNotifyEventsEx.Create(Self);
end;

destructor TViewStoreHouse.Destroy;
begin
  inherited;
  FreeAndNil(FOnCanFocusRecord);
end;

procedure TViewStoreHouse.actAddStorehouseExecute(Sender: TObject);
begin
  MainView.OptionsSelection.CellSelect := True;
  MainView.Controller.ClearSelection;
  MainView.DataController.Append;
  FocusColumnEditor(0, W.Title.FieldName);

  UpdateView;
end;

procedure TViewStoreHouse.actRenameStorehouseExecute(Sender: TObject);
begin
  MainView.OptionsSelection.CellSelect := True;
  MainView.Controller.ClearSelection;
  MainView.DataController.Edit;
  FocusColumnEditor(0, W.Title.FieldName);

  UpdateView;
end;

procedure TViewStoreHouse.actStoreHouseInfoExecute(Sender: TObject);
var
  AfrmStoreHouse: TfrmStoreHouse;
begin
  inherited;
  if qStoreHouseList.HaveAnyChanges then
    qStoreHouseList.ApplyUpdates;
  Assert(not qStoreHouseList.HaveAnyChanges);
  Assert(not qStoreHouseList.FDQuery.CachedUpdates);
  AfrmStoreHouse := TfrmStoreHouse.Create(Self);
  qStoreHouseList.FDQuery.CachedUpdates := True;
  try
    AfrmStoreHouse.ViewStorehouseInfo.qStoreHouseList := qStoreHouseList;
    AfrmStoreHouse.ShowModal;
  finally
    qStoreHouseList.FDQuery.CachedUpdates := False;
    FreeAndNil(AfrmStoreHouse);
  end;
  UpdateView;
end;

procedure TViewStoreHouse.cxGridDBBandedTableViewCanFocusRecord
  (Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
  var AAllow: Boolean);
var
  AOnCanFocusRecord: TOnCanFocusRecord;
begin
  inherited;
  AOnCanFocusRecord := TOnCanFocusRecord.Create;
  try
    FOnCanFocusRecord.CallEventHandlers(AOnCanFocusRecord);
    AAllow := AOnCanFocusRecord.Allow;
  finally
    FreeAndNil(AOnCanFocusRecord);
  end;
end;

procedure TViewStoreHouse.cxGridDBBandedTableViewEditValueChanged
  (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem);
begin
  inherited;
  if FPosting then
    Exit;

  if VarToStrDef(MainView.Controller.EditingController.Edit.EditingValue, '') <> ''
  then
    MainView.DataController.Post()
  else
    MainView.DataController.Cancel;

  MainView.OptionsSelection.CellSelect := False;
  UpdateView;
end;

procedure TViewStoreHouse.cxGridDBBandedTableViewSelectionChanged
  (Sender: TcxCustomGridTableView);
begin
  inherited;
  if FqStoreHouseList = nil then
    Exit;

  W.ProductsInt.LoadContent(GetStoreHouseID, Self);
end;

procedure TViewStoreHouse.DoBeforeMonitorApplyUpdates(Sender: TObject);
begin
  if MainView.Controller.EditingItem = nil then
    Exit;

  FPosting := True;
  try
    // Если в настоящий момент происходит редактирование
    if VarToStrDef(MainView.Controller.EditingController.Edit.EditingValue, '')
      <> '' then
      MainView.DataController.Post()
    else
      MainView.DataController.Cancel;

    MainView.OptionsSelection.CellSelect := False;
    UpdateView;

  finally
    FPosting := False;
  end;
end;

procedure TViewStoreHouse.FreeInt;
begin
  W.ProductsInt.FreeInt;
end;

function TViewStoreHouse.GetclAbbreviation: TcxGridDBBandedColumn;
begin
  Result := MainView.GetColumnByFieldName(W.Abbreviation.FieldName);
end;

function TViewStoreHouse.GetclTitle: TcxGridDBBandedColumn;
begin
  Result := MainView.GetColumnByFieldName(W.Title.FieldName);
end;

function TViewStoreHouse.GetclID: TcxGridDBBandedColumn;
begin
  Result := MainView.GetColumnByFieldName(W.ID.FieldName);
end;

function TViewStoreHouse.GetStoreHouseCount: Integer;
begin
  Result := MainView.ViewData.RowCount;
end;

function TViewStoreHouse.GetStoreHouseID: Integer;
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

function TViewStoreHouse.GetStoreHouseTitle: string;
var
  ARow: TcxCustomGridRow;
begin
  Result := '';
  if MainView.Controller.SelectedRowCount > 0 then
  begin
    ARow := MainView.Controller.SelectedRows[0];
    Result := ARow.Values[clTitle.Index];
  end
end;

function TViewStoreHouse.GetW: TStoreHouseListW;
begin
  Result := FqStoreHouseList.W;
end;

procedure TViewStoreHouse.SetqStoreHouseList(const Value: TQueryStoreHouseList);
begin
  if FqStoreHouseList = Value then
    Exit;

  FEventList.Clear;
  FqStoreHouseList := Value;

  if FqStoreHouseList = nil then
    Exit;

  MainView.DataController.DataSource := FqStoreHouseList.W.DataSource;
  MainView.DataController.CreateAllItems(True);

  MainView.OptionsBehavior.ImmediateEditor := False;
  // MainView.OptionsSelection.CellMultiSelect := False;
  // MainView.OptionsSelection.MultiSelect := False;
  // MainView.OptionsSelection.CellSelect := False;

  // MainView.OptionsSelection.UnselectFocusedRecordOnExit := False;
  // MainView.OptionsSelection.HideSelection := False;

  // if MainView.Controller.FocusedRow <> nil then
  // MainView.Controller.FocusedRow.Selected := True;

  TNotifyEventWrap.Create(qStoreHouseList.Monitor.BeforeApplyUpdates,
    DoBeforeMonitorApplyUpdates, FEventList);

  clAbbreviation.Visible := False;
  MainView.ApplyBestFit;
end;

procedure TViewStoreHouse.UpdateView;
var
  OK: Boolean;
begin
  OK := (qStoreHouseList <> nil) and (qStoreHouseList.FDQuery.Active);

  actAddStorehouse.Enabled := OK;

  actDeleteEx.Enabled := OK and (MainView.Controller.SelectedRowCount > 0);

  actRenameStorehouse.Enabled := OK and
    (MainView.Controller.SelectedRowCount = 1);

  actStoreHouseInfo.Enabled := OK and
    (MainView.Controller.SelectedRowCount = 1);
end;

end.
