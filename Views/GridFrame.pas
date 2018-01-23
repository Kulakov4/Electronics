unit GridFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB,
  cxDBData, cxGridLevel, cxClasses, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, dxBar, ColumnsBarButtonsHelper,
  cxGridBandedTableView, cxGridDBBandedTableView, System.Actions, Vcl.ActnList,
  System.Contnrs, Vcl.ComCtrls, Vcl.Menus, cxGridCustomPopupMenu,
  cxGridPopupMenu, dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
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
  dxSkinXmas2008Blue, dxSkinscxPCPainter, dxSkinsdxBarPainter, cxDropDownEdit,
  BaseQuery, System.Generics.Collections, DragHelper, OrderQuery, GridSort;

const
  WM_MY_APPLY_BEST_FIT = WM_USER + 109;
  WM_AfterKeyOrMouseDown = WM_USER + 55;

type
  TGridProcRef = reference to procedure(AView: TcxGridDBBandedTableView);
  // Ссылка на метод
  TProcRef = reference to procedure();

  TfrmGrid = class(TFrame)
    cxGridLevel: TcxGridLevel;
    cxGrid: TcxGrid;
    dxBarManager: TdxBarManager;
    dxbrMain: TdxBar;
    dxbsColumns: TdxBarSubItem;
    cxGridDBBandedTableView: TcxGridDBBandedTableView;
    ActionList: TActionList;
    StatusBar: TStatusBar;
    actCopyToClipboard: TAction;
    pmGrid: TPopupMenu;
    N1: TMenuItem;
    cxGridPopupMenu: TcxGridPopupMenu;
    actDeleteEx: TAction;
    procedure actCopyToClipboardExecute(Sender: TObject);
    procedure actDeleteExExecute(Sender: TObject);
    procedure cxGridDBBandedTableViewCustomDrawColumnHeader
      (Sender: TcxGridTableView; ACanvas: TcxCanvas;
      AViewInfo: TcxGridColumnHeaderViewInfo; var ADone: Boolean);
    procedure cxGridDBBandedTableViewEditKeyDown(Sender: TcxCustomGridTableView;
      AItem: TcxCustomGridTableItem; AEdit: TcxCustomEdit; var Key: Word;
      Shift: TShiftState);
    procedure cxGridDBBandedTableViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cxGridDBBandedTableViewMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure cxGridPopupMenuPopup(ASenderMenu: TComponent;
      AHitTest: TcxCustomGridHitTest; X, Y: Integer; var AllowPopup: Boolean);
    procedure StatusBarResize(Sender: TObject);
    procedure cxGridDBBandedTableViewStylesGetHeaderStyle
      (Sender: TcxGridTableView; AColumn: TcxGridColumn; var AStyle: TcxStyle);
  private
    FApplyBestFitMultiLine: Boolean;
    FApplyBestFitPosted: Boolean;
    FDeleteMessages: TDictionary<TcxGridLevel, String>;
    FGridSort: TGridSort;
    FPostOnEnterFields: TList<String>;
    FSortSL: TList<String>;
    FStartDragLevel: TcxGridLevel;
    FStatusBarEmptyPanelIndex: Integer;
    FUpdateCount: Cardinal;
    function GetMainView: TcxGridDBBandedTableView;
    function GetParentForm: TForm;
    procedure SetStatusBarEmptyPanelIndex(const Value: Integer);
    { Private declarations }
  protected
    FColumnsBarButtons: TGVColumnsBarButtons;
    FEventList: TObjectList;
    procedure AfterKeyOrMouseDown(var Message: TMessage);
      message WM_AfterKeyOrMouseDown;
    procedure CreateColumnsBarButtons; virtual;
    procedure CreateFilterForExport(AView,
      ASource: TcxGridDBBandedTableView); virtual;
    procedure DoCancelDetailExpanding(ADataController: TcxCustomDataController;
      ARecordIndex: Integer; var AAllow: Boolean);
    procedure DoOnEditKeyDown(Sender: TcxCustomGridTableView;
      AItem: TcxCustomGridTableItem; AEdit: TcxCustomEdit; var Key: Word;
      Shift: TShiftState);
    procedure DoOnMyApplyBestFit(var Message: TMessage);
      message WM_MY_APPLY_BEST_FIT;
    function GetFocusedTableView: TcxGridDBBandedTableView; virtual;
    procedure InitializeLookupColumn(AColumn: TcxGridDBBandedColumn;
      ADataSource: TDataSource; ADropDownListStyle: TcxEditDropDownListStyle;
      const AListFieldNames: string;
      const AKeyFieldNames: string = 'ID'); overload;
    procedure InitializeComboBoxColumn(AColumn: TcxGridDBBandedColumn;
      ADropDownListStyle: TcxEditDropDownListStyle; AField: TField); overload;
    procedure InitializeComboBoxColumn(AView: TcxGridDBBandedTableView;
      AFieldName: string; ADropDownListStyle: TcxEditDropDownListStyle;
      AField: TField); overload;
    procedure InitializeLookupColumn(AView: TcxGridDBBandedTableView;
      const AFieldName: string; ADataSource: TDataSource;
      ADropDownListStyle: TcxEditDropDownListStyle;
      const AListFieldNames: string;
      const AKeyFieldNames: string = 'ID'); overload;
    procedure OnGridPopupMenuPopup(AColumn: TcxGridDBBandedColumn); virtual;
    procedure DoStatusBarResize(AEmptyPanelIndex: Integer);
    procedure InternalRefreshData; virtual;
    procedure MyDelete; virtual;
    function SameCol(AColumn1: TcxGridColumn;
      AColumn2: TcxGridDBBandedColumn): Boolean;
    property SortSL: TList<String> read FSortSL;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AfterConstruction; override;
    procedure ApplyBestFitFocusedBand; virtual;
    procedure ApplySort(Sender: TcxGridTableView; AColumn: TcxGridColumn);
    procedure BeginUpdate; virtual;
    procedure ChooseTopRecord(AView: TcxGridTableView; ARecordIndex: Integer);
    procedure ChooseTopRecord1(AView: TcxGridTableView; ARecordIndex: Integer);
    procedure ProcessWithCancelDetailExpanding(AView: TcxCustomGridView;
      AProcRef: TProcRef);
    procedure ClearSort(AView: TcxGridTableView);
    procedure DoDragDrop(AcxGridSite: TcxGridSite;
      ADragAndDropInfo: TDragAndDropInfo; AQueryOrder: TQueryOrder;
      X, Y: Integer);
    procedure DoDragOver(AcxGridSite: TcxGridSite; X, Y: Integer;
      var Accept: Boolean);
    procedure DoOnCustomDrawColumnHeader(AViewInfo: TcxGridColumnHeaderViewInfo;
      ACanvas: TcxCanvas);
    procedure DoOnGetHeaderStyle(AColumn: TcxGridColumn; var AStyle: TcxStyle);
    procedure DoOnStartDrag(AcxGridSite: TcxGridSite;
      ADragAndDropInfo: TDragAndDropInfo);
    procedure EndUpdate; virtual;
    procedure ExportViewToExcel(AView: TcxGridDBBandedTableView;
      AFileName: string; AGridProcRef: TGridProcRef = nil);
    procedure FocusColumnEditor(ALevel: Integer; AFieldName: string); overload;
    procedure FocusColumnEditor(AView: TcxGridDBBandedTableView;
      AFieldName: string); overload;
    procedure FocusSelectedRecord(AView: TcxGridDBBandedTableView); overload;
    procedure FocusSelectedRecord; overload;
    procedure PutInTheCenterFocusedRecord
      (AView: TcxGridDBBandedTableView); overload;
    function GetDBBandedTableView(ALevel: Cardinal): TcxGridDBBandedTableView;
    function GetRow(ALevel: Cardinal; ARowIndex: Integer = -1)
      : TcxCustomGridRow;
    function GetSameColumn(AView: TcxGridTableView; AColumn: TcxGridColumn)
      : TcxGridDBBandedColumn;
    procedure LocateAndFocus(AMaster, ADetail: TQueryBase; ADetailID: Integer;
      const AMasterKeyFieldName, AFocusedColumnFieldName: string);
    procedure MyApplyBestFit; virtual;
    procedure PostMyApplyBestFitEvent;
    procedure UpdateColumnsMinWidth(AView: TcxGridDBBandedTableView);
    procedure UpdateView; virtual;
    function GridView(ALevel: TcxGridLevel): TcxGridDBBandedTableView;
    procedure InvertSortOrder(AColumn: TcxGridDBBandedColumn);
    procedure MyApplyBestFitForView(AView: TcxGridDBBandedTableView);
    procedure PutInTheCenterFocusedRecord; overload;
    procedure RefreshData;
    function Value(AView: TcxGridDBBandedTableView;
      AColumn: TcxGridDBBandedColumn; const ARowIndex: Integer): Variant;
    property ApplyBestFitMultiLine: Boolean read FApplyBestFitMultiLine
      write FApplyBestFitMultiLine;
    property DeleteMessages: TDictionary<TcxGridLevel, String>
      read FDeleteMessages;
    property FocusedTableView: TcxGridDBBandedTableView
      read GetFocusedTableView;
    property GridSort: TGridSort read FGridSort;
    property MainView: TcxGridDBBandedTableView read GetMainView;
    property ParentForm: TForm read GetParentForm;
    property PostOnEnterFields: TList<String> read FPostOnEnterFields;
    property StatusBarEmptyPanelIndex: Integer read FStatusBarEmptyPanelIndex
      write SetStatusBarEmptyPanelIndex;
    property UpdateCount: Cardinal read FUpdateCount;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses RepositoryDataModule, System.Math, cxDBLookupComboBox, cxGridExportLink,
  dxCore, DialogUnit, StrHelper;

constructor TfrmGrid.Create(AOwner: TComponent);
begin
  inherited;
  FUpdateCount := 0;
  FEventList := TObjectList.Create;
  FStatusBarEmptyPanelIndex := -1;

  // Список полей при редактировании которых Enter - сохранение
  FPostOnEnterFields := TList<String>.Create;
  FGridSort := TGridSort.Create;

  FDeleteMessages := TDictionary<TcxGridLevel, String>.Create;
  FSortSL := TList<String>.Create;
end;

destructor TfrmGrid.Destroy;
begin
  FreeAndNil(FSortSL);
  FreeAndNil(FPostOnEnterFields);
  FreeAndNil(FEventList);
  FreeAndNil(FGridSort);
  FreeAndNil(FDeleteMessages);
  inherited;
end;

procedure TfrmGrid.actCopyToClipboardExecute(Sender: TObject);
var
  AView: TcxGridDBBandedTableView;
begin
  AView := GetFocusedTableView;
  if AView <> nil then
    AView.CopyToClipboard(False);
end;

procedure TfrmGrid.actDeleteExExecute(Sender: TObject);
begin
  MyDelete;
end;

procedure TfrmGrid.AfterConstruction;
begin
  inherited;
  CreateColumnsBarButtons;
end;

procedure TfrmGrid.AfterKeyOrMouseDown(var Message: TMessage);
begin
  UpdateView;
end;

procedure TfrmGrid.ApplyBestFitFocusedBand;
var
  AColumn: TcxGridDBBandedColumn;
begin
  AColumn := (MainView.Controller.FocusedColumn as TcxGridDBBandedColumn);

  MainView.BeginBestFitUpdate;
  try
    AColumn.Position.Band.ApplyBestFit();
  finally
    MainView.EndBestFitUpdate;
  end;
end;

procedure TfrmGrid.ApplySort(Sender: TcxGridTableView; AColumn: TcxGridColumn);
var
  ASortOrder: TdxSortOrder;
  ASortVariant: TSortVariant;
  Col: TcxGridDBBandedColumn;
  S: string;
begin
  inherited;

  ASortVariant := FGridSort.GetSortVariant(AColumn);

  // Если при щелчке по этой колоке нет вариантов сортировки
  if ASortVariant = nil then
    Exit;

  if (AColumn.SortOrder = soAscending) then
    ASortOrder := soDescending
  else
    ASortOrder := soAscending;

  Sender.BeginSortingUpdate;
  try
    // Очистили сортировку
    ClearSort(Sender);

    // Применяем сортировку
    for S in ASortVariant.SortedFieldNames do
    begin
      Col := (Sender as TcxGridDBBandedTableView).GetColumnByFieldName(S);
      Assert(Col <> nil);
      Col.SortOrder := ASortOrder;
    end;

  finally
    Sender.EndSortingUpdate;
  end;
end;

procedure TfrmGrid.BeginUpdate;
begin
  Inc(FUpdateCount);
  cxGrid.BeginUpdate();
end;

// Подбирает верхнюю запись так, чтобы нужная нам стала полностью видимой
procedure TfrmGrid.ChooseTopRecord(AView: TcxGridTableView;
  ARecordIndex: Integer);
var
  ARowIndex: Integer;
  Cnt: Integer;
  i: Integer;
  LastVisibleRecIndex: Integer;
  t: Integer;
begin
  Assert(AView <> nil);
  Assert(ARecordIndex >= 0);

  // Получаем номер строки по номеру записи в БД
  ARowIndex := AView.DataController.GetRowIndexByRecordIndex
    (ARecordIndex, False);

  t := AView.Controller.TopRecordIndex;
  Cnt := AView.ViewInfo.RecordsViewInfo.VisibleCount;
  LastVisibleRecIndex := t - 1 + Cnt;

  i := 0;
  // Пока текущая запись видна не полностью
  while (i < 50) and (ARowIndex > t) and (ARowIndex > LastVisibleRecIndex) do
  begin
    // Сдвигаем вверх на одну запись
    AView.Controller.TopRecordIndex := t + 1;

    t := AView.Controller.TopRecordIndex;
    Cnt := AView.ViewInfo.RecordsViewInfo.VisibleCount;
    LastVisibleRecIndex := t - 1 + Cnt;

    Inc(i); // Увеличиваем кол-во попыток
  end;

end;

// Подбирает верхнюю запись так, чтобы нужная нам стала полностью видимой
procedure TfrmGrid.ChooseTopRecord1(AView: TcxGridTableView;
  ARecordIndex: Integer);
var
  Cnt: Integer;
  i: Integer;
  LastVisibleRecIndex: Integer;
  t: Integer;
begin
  Assert(AView <> nil);
  Assert(ARecordIndex >= 0);

  t := AView.Controller.TopRecordIndex;
  Cnt := AView.ViewInfo.RecordsViewInfo.VisibleCount;
  LastVisibleRecIndex := t - 1 + Cnt;

  i := 0;
  // Пока текущая запись видна не полностью
  while (i < 50) and (ARecordIndex > t) and
    (ARecordIndex >= LastVisibleRecIndex) do
  begin
    // Сдвигаем вверх на одну запись
    AView.Controller.TopRecordIndex := t + 1;

    t := AView.Controller.TopRecordIndex;
    Cnt := AView.ViewInfo.RecordsViewInfo.VisibleCount;
    LastVisibleRecIndex := t - 1 + Cnt;

    Inc(i); // Увеличиваем кол-во попыток
  end;
end;

procedure TfrmGrid.ProcessWithCancelDetailExpanding(AView: TcxCustomGridView;
  AProcRef: TProcRef);
Var
  E: TcxDataDetailExpandingEvent;
begin
  Assert(Assigned(AProcRef));
  if AView = nil then
  begin
    AProcRef;
    Exit;
  end;

  E := AView.DataController.OnDetailExpanding;
  try
    AView.DataController.OnDetailExpanding := DoCancelDetailExpanding;
    AProcRef;
  finally
    AView.DataController.OnDetailExpanding := E;
  end;
end;

procedure TfrmGrid.ClearSort(AView: TcxGridTableView);
var
  i: Integer;
begin
  Assert(AView <> nil);

  for i := 0 to AView.ColumnCount - 1 do
    AView.Columns[i].SortOrder := soNone;
end;

procedure TfrmGrid.CreateColumnsBarButtons;
begin
  if (cxGridDBBandedTableView.ItemCount > 0) and (FColumnsBarButtons = nil) then
    FColumnsBarButtons := TGVColumnsBarButtons.Create(Self, dxbsColumns,
      cxGridDBBandedTableView);
end;

procedure TfrmGrid.CreateFilterForExport(AView,
  ASource: TcxGridDBBandedTableView);
begin
  AView.DataController.Filter.Assign(ASource.DataController.Filter);
end;

procedure TfrmGrid.cxGridDBBandedTableViewCustomDrawColumnHeader
  (Sender: TcxGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridColumnHeaderViewInfo; var ADone: Boolean);
begin
  DoOnCustomDrawColumnHeader(AViewInfo, ACanvas);
end;

procedure TfrmGrid.cxGridDBBandedTableViewEditKeyDown
  (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
  AEdit: TcxCustomEdit; var Key: Word; Shift: TShiftState);
begin
  DoOnEditKeyDown(Sender, AItem, AEdit, Key, Shift);
end;

procedure TfrmGrid.cxGridDBBandedTableViewKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  PostMessage(Handle, WM_AfterKeyOrMouseDown, 0, 0);
end;

procedure TfrmGrid.cxGridDBBandedTableViewMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  PostMessage(Handle, WM_AfterKeyOrMouseDown, 0, 0);
end;

procedure TfrmGrid.cxGridDBBandedTableViewStylesGetHeaderStyle
  (Sender: TcxGridTableView; AColumn: TcxGridColumn; var AStyle: TcxStyle);
begin
  DoOnGetHeaderStyle(AColumn, AStyle);
end;

procedure TfrmGrid.cxGridPopupMenuPopup(ASenderMenu: TComponent;
  AHitTest: TcxCustomGridHitTest; X, Y: Integer; var AllowPopup: Boolean);
var
  AColumn: TcxGridDBBandedColumn;
  AcxGridRecordCellHitTest: TcxGridRecordCellHitTest;
begin
  inherited;
  AColumn := nil;

  if (AHitTest is TcxGridRecordCellHitTest) then
  begin
    AcxGridRecordCellHitTest := (AHitTest as TcxGridRecordCellHitTest);
    if AcxGridRecordCellHitTest.Item is TcxGridDBBandedColumn then
    begin
      AColumn := AcxGridRecordCellHitTest.Item as TcxGridDBBandedColumn;
    end;
  end;

  OnGridPopupMenuPopup(AColumn);
end;

procedure TfrmGrid.DoCancelDetailExpanding(ADataController
  : TcxCustomDataController; ARecordIndex: Integer; var AAllow: Boolean);
begin
  AAllow := False;
end;

procedure TfrmGrid.MyDelete;
var
  AView: TcxGridDBBandedTableView;
  S: string;
begin
  Assert(FDeleteMessages <> nil);

  AView := FocusedTableView;
  if AView = nil then
    Exit;

  if not FDeleteMessages.ContainsKey(AView.Level as TcxGridLevel) then
    S := 'Удалить запись?'
  else
    S := FDeleteMessages[AView.Level as TcxGridLevel];

  if (TDialog.Create.DeleteRecordsDialog(S)) and
    (AView.DataController.RecordCount > 0) then
  begin
    ProcessWithCancelDetailExpanding(AView.MasterGridView,
      procedure()
      begin
        if AView.Controller.SelectedRowCount > 0 then
          AView.DataController.DeleteSelection
        else
          AView.DataController.DeleteFocused;
      end);

    if (AView.DataController.RecordCount = 0) and (AView.MasterGridRecord <> nil)
    then
    begin
      AView.MasterGridRecord.Collapse(False);
    end;

  end;

  UpdateView;

end;

procedure TfrmGrid.DoOnEditKeyDown(Sender: TcxCustomGridTableView;
AItem: TcxCustomGridTableItem; AEdit: TcxCustomEdit; var Key: Word;
Shift: TShiftState);
var
  AColumn: TcxGridDBBandedColumn;
begin
  AColumn := AItem as TcxGridDBBandedColumn;

  if (Key = 13) and (FPostOnEnterFields.IndexOf(AColumn.DataBinding.FieldName)
    >= 0) then
  begin
    cxGridDBBandedTableView.DataController.Post();
    UpdateView;
  end;
end;

procedure TfrmGrid.DoOnMyApplyBestFit(var Message: TMessage);
begin
  inherited;
  Assert(FApplyBestFitPosted);

  MyApplyBestFit;

  MainView.EndBestFitUpdate;
  FApplyBestFitPosted := False;
end;

procedure TfrmGrid.EndUpdate;
begin
  cxGrid.EndUpdate;
  Dec(FUpdateCount)
end;

procedure TfrmGrid.ExportViewToExcel(AView: TcxGridDBBandedTableView;
AFileName: string; AGridProcRef: TGridProcRef = nil);
var
  Grid: TcxGrid;
  Level: TcxGridLevel;
  GridView: TcxGridDBBandedTableView;
begin
  Assert(not AFileName.IsEmpty);

  Grid := TcxGrid.Create(Self);
  Level := Grid.Levels.Add;
  GridView := Grid.CreateView(TcxGridDBBandedTableView)
    as TcxGridDBBandedTableView;
  GridView.DataController.DataSource := AView.DataController.DataSource;
  GridView.Assign(AView);
  GridView.OptionsView.Footer := False; // Футер экспортировать не будем

  // Фильтруем так-же как у образца
  CreateFilterForExport(GridView, AView);

  // Делаем скрытый грид такой-же по размерам как и наш
  Grid.Width := cxGrid.Width;
  Grid.Height := cxGrid.Height;
  // Выставляем тот-же шрифт
  Grid.Font.Assign(Font);

  Level.GridView := GridView;

  if Assigned(AGridProcRef) then
    AGridProcRef(GridView);

  // Выставляем оптимальную ширину колонок
  GridView.ApplyBestFit();

  // Экспортируем в Excel
  ExportGridToExcel(AFileName, Grid);

  FreeAndNil(GridView);
  FreeAndNil(Grid);
end;

procedure TfrmGrid.FocusColumnEditor(ALevel: Integer; AFieldName: string);
var
  AView: TcxGridDBBandedTableView;
begin
  AView := GetDBBandedTableView(ALevel);
  FocusColumnEditor(AView, AFieldName);
end;

procedure TfrmGrid.FocusSelectedRecord(AView: TcxGridDBBandedTableView);
begin
  Assert(AView <> nil);
  if AView.Controller.SelectedRowCount > 0 then
    AView.Controller.SelectedRows[0].Focused := True;
end;

procedure TfrmGrid.FocusSelectedRecord;
var
  AView: TcxGridDBBandedTableView;
begin
  AView := FocusedTableView;
  if AView <> nil then
    FocusSelectedRecord(AView);
end;

procedure TfrmGrid.PutInTheCenterFocusedRecord(AView: TcxGridDBBandedTableView);
var
  ATopRecordIndex: Integer;
  Cnt: Integer;
begin
  Assert(AView <> nil);
  if AView.Controller.FocusedRecordIndex >= 0 then
  begin
    Cnt := AView.ViewInfo.RecordsViewInfo.VisibleCount;

    // Похоже представление невидимо
    if Cnt = 0 then
      Exit;

    ATopRecordIndex := AView.Controller.FocusedRecordIndex -
      Round((Cnt + 1) / 2);
    AView.Controller.TopRecordIndex := ATopRecordIndex;
  end;
end;

function TfrmGrid.GetDBBandedTableView(ALevel: Cardinal)
  : TcxGridDBBandedTableView;
var
  AcxGridDBBandedTableView: TcxGridDBBandedTableView;
  AcxGridMasterDataRow: TcxGridMasterDataRow;
  i: Integer;
begin
  Result := nil;
  Assert(ALevel < 3);

  case ALevel of
    0:
      Result := cxGrid.Levels[0].GridView as TcxGridDBBandedTableView;
    1, 2:
      begin
        AcxGridDBBandedTableView := GetDBBandedTableView(ALevel - 1);
        if AcxGridDBBandedTableView = nil then
          Exit;

        i := AcxGridDBBandedTableView.DataController.FocusedRowIndex;
        if i < 0 then
          Exit;

        AcxGridMasterDataRow := GetDBBandedTableView(ALevel - 1).ViewData.Rows
          [i] as TcxGridMasterDataRow;
        // Спускаемся на дочерний уровень
        Result := AcxGridMasterDataRow.ActiveDetailGridView as
          TcxGridDBBandedTableView;
      end;
  else
    raise Exception.Create('Уровень должен быть от 0 до 2');
  end;
end;

function TfrmGrid.GetFocusedTableView: TcxGridDBBandedTableView;
begin
  Result := GetDBBandedTableView(0);
  if (Result <> nil) and (not Result.Focused) then
    Result := nil;
  {
    // Если не первый уровень в фокусе
    if (Result = nil) and (cxGrid.Levels.Count > 1) then
    begin
    Result := GetDBBandedTableView(1);
    if (Result <> nil) and (not Result.Focused) then
    Result := nil;
    end;
  }
end;

function TfrmGrid.GetMainView: TcxGridDBBandedTableView;
begin
  Result := cxGridLevel.GridView as TcxGridDBBandedTableView;
end;

function TfrmGrid.GetRow(ALevel: Cardinal; ARowIndex: Integer = -1)
  : TcxCustomGridRow;
var
  AcxGridDBBandedTableView: TcxGridDBBandedTableView;
  i: Integer;
begin
  Result := nil;
  AcxGridDBBandedTableView := GetDBBandedTableView(ALevel);
  i := IfThen(ARowIndex = -1,
    AcxGridDBBandedTableView.DataController.FocusedRowIndex, ARowIndex);
  if i >= 0 then
    Result := AcxGridDBBandedTableView.ViewData.Rows[i];
end;

procedure TfrmGrid.InitializeLookupColumn(AColumn: TcxGridDBBandedColumn;
ADataSource: TDataSource; ADropDownListStyle: TcxEditDropDownListStyle;
const AListFieldNames: string; const AKeyFieldNames: string = 'ID');
var
  AcxLookupComboBoxProperties: TcxLookupComboBoxProperties;
begin
  Assert(AColumn <> nil);
  Assert(ADataSource <> nil);
  Assert(not AListFieldNames.IsEmpty);
  Assert(not AKeyFieldNames.IsEmpty);

  Assert(AColumn <> nil);

  AColumn.PropertiesClass := TcxLookupComboBoxProperties;
  AcxLookupComboBoxProperties :=
    AColumn.Properties as TcxLookupComboBoxProperties;
  AcxLookupComboBoxProperties.ListSource := ADataSource;
  AcxLookupComboBoxProperties.ListFieldNames := AListFieldNames;
  AcxLookupComboBoxProperties.KeyFieldNames := AKeyFieldNames;
  AcxLookupComboBoxProperties.DropDownListStyle := ADropDownListStyle;
end;

procedure TfrmGrid.InitializeComboBoxColumn(AColumn: TcxGridDBBandedColumn;
ADropDownListStyle: TcxEditDropDownListStyle; AField: TField);
var
  AcxComboBoxProperties: TcxComboBoxProperties;
begin
  Assert(AColumn <> nil);

  AColumn.PropertiesClass := TcxComboBoxProperties;
  AcxComboBoxProperties := AColumn.Properties as TcxComboBoxProperties;
  AcxComboBoxProperties.DropDownListStyle := ADropDownListStyle;

  // Заполняем выпадающий список значениями из запроса
  AcxComboBoxProperties.Items.Clear;
  AField.DataSet.First;
  while not AField.DataSet.Eof do
  begin
    AcxComboBoxProperties.Items.Add(AField.AsString);
    AField.DataSet.Next;
  end;
end;

procedure TfrmGrid.LocateAndFocus(AMaster, ADetail: TQueryBase;
ADetailID: Integer; const AMasterKeyFieldName, AFocusedColumnFieldName: string);
var
  AView: TcxGridDBBandedTableView;
begin
  Assert(AMaster <> nil);
  Assert(ADetail <> nil);
  Assert(ADetailID > 0);
  Assert(not AMasterKeyFieldName.IsEmpty);
  Assert(not AFocusedColumnFieldName.IsEmpty);

  // Ищем запись в дочернем наборе данных
  if ADetail.LocateByPK(ADetailID) then
  begin
    // Ищем соответсвующую запись в главном наборе данных
    if AMaster.LocateByPK(ADetail.Field(AMasterKeyFieldName).Value) then
    begin
      // Получаем строку в гриде
      // AcxGridMasterDataRow := GetRow(0) as TcxGridMasterDataRow;
      // Раскрываем эту строку
      MainView.ViewData.Expand(False);

      // Получаем дочернее представление
      AView := GetDBBandedTableView(1);

      if (ParentForm <> nil) and (ParentForm.Visible) then
      begin
        try
          // Фокусируем его
          AView.Focused := True;
          PutInTheCenterFocusedRecord(AView);

          FocusColumnEditor(AView, AFocusedColumnFieldName);
        except
          ; // Иногда возникает ошибка
        end;
      end;
    end;
  end;

end;

procedure TfrmGrid.MyApplyBestFit;
begin
  MyApplyBestFitForView(MainView);
end;

procedure TfrmGrid.PostMyApplyBestFitEvent;
begin
  // Уже послали такое сообщение
  if FApplyBestFitPosted then
    Exit;

  FApplyBestFitPosted := True;
  MainView.BeginBestFitUpdate;
  PostMessage(Handle, WM_MY_APPLY_BEST_FIT, 0, 0);
end;

procedure TfrmGrid.UpdateColumnsMinWidth(AView: TcxGridDBBandedTableView);
var
  AColumn: TcxGridDBBandedColumn;
  i: Integer;
  RealColumnWidth: Integer;
begin
  // изменяем минимальные размеры всех колонок
  for i := 0 to AView.ColumnCount - 1 do
  begin
    AColumn := AView.Columns[i];

    if AColumn.VisibleIndex >= 0 then
    begin
      RealColumnWidth := AView.ViewInfo.HeaderViewInfo.Items
        [AColumn.VisibleIndex].Width;

      if AColumn.MinWidth < RealColumnWidth then
        AColumn.MinWidth := RealColumnWidth;
    end;
  end;
end;

procedure TfrmGrid.UpdateView;
begin
end;

function TfrmGrid.GridView(ALevel: TcxGridLevel): TcxGridDBBandedTableView;
begin
  Assert(ALevel <> nil);
  Result := ALevel.GridView as TcxGridDBBandedTableView;
end;

procedure TfrmGrid.InitializeComboBoxColumn(AView: TcxGridDBBandedTableView;
AFieldName: string; ADropDownListStyle: TcxEditDropDownListStyle;
AField: TField);
begin
  Assert(AView <> nil);
  Assert(not AFieldName.IsEmpty);

  InitializeComboBoxColumn(AView.GetColumnByFieldName(AFieldName),
    ADropDownListStyle, AField);
end;

procedure TfrmGrid.InitializeLookupColumn(AView: TcxGridDBBandedTableView;
const AFieldName: string; ADataSource: TDataSource;
ADropDownListStyle: TcxEditDropDownListStyle; const AListFieldNames: string;
const AKeyFieldNames: string = 'ID');
begin
  Assert(AView <> nil);
  Assert(not AFieldName.IsEmpty);

  InitializeLookupColumn(AView.GetColumnByFieldName(AFieldName), ADataSource,
    ADropDownListStyle, AListFieldNames, AKeyFieldNames);
end;

procedure TfrmGrid.OnGridPopupMenuPopup(AColumn: TcxGridDBBandedColumn);
begin
end;

procedure TfrmGrid.PutInTheCenterFocusedRecord;
var
  AView: TcxGridDBBandedTableView;
begin
  AView := FocusedTableView;
  if AView <> nil then
    PutInTheCenterFocusedRecord(AView);
end;

procedure TfrmGrid.DoStatusBarResize(AEmptyPanelIndex: Integer);
var
  i: Integer;
  X: Integer;
begin
  Assert(AEmptyPanelIndex >= 0);
  Assert(AEmptyPanelIndex < StatusBar.Panels.Count);

  X := StatusBar.ClientWidth;
  for i := 0 to StatusBar.Panels.Count - 1 do
  begin
    if i <> AEmptyPanelIndex then
    begin
      Dec(X, StatusBar.Panels[i].Width);
    end;
  end;
  X := IfThen(X >= 0, X, 0);
  StatusBar.Panels[AEmptyPanelIndex].Width := X;
end;

procedure TfrmGrid.DoDragDrop(AcxGridSite: TcxGridSite;
ADragAndDropInfo: TDragAndDropInfo; AQueryOrder: TQueryOrder; X, Y: Integer);
var
  AcxCustomGridHitTest: TcxCustomGridHitTest;
  AcxGridDBBandedTableView: TcxGridDBBandedTableView;
  AcxGridRecordCellHitTest: TcxGridRecordCellHitTest;
  AcxGridViewNoneHitTest: TcxGridViewNoneHitTest;

begin
  Assert(AcxGridSite <> nil);
  Assert(ADragAndDropInfo <> nil);

  AcxGridDBBandedTableView := nil;

  // Определяем точку переноса
  AcxCustomGridHitTest := AcxGridSite.ViewInfo.GetHitTest(X, Y);

  if AcxCustomGridHitTest is TcxGridRecordCellHitTest then
  begin
    AcxGridRecordCellHitTest :=
      AcxCustomGridHitTest as TcxGridRecordCellHitTest;
    AcxGridDBBandedTableView := AcxGridRecordCellHitTest.GridView as
      TcxGridDBBandedTableView;

    // определяем порядок в точке переноса
    ADragAndDropInfo.DropDrag.OrderValue :=
      AcxGridRecordCellHitTest.GridRecord.Values
      [ADragAndDropInfo.OrderColumn.Index];

    // определяем код записи в точке переноса
    ADragAndDropInfo.DropDrag.Key := AcxGridRecordCellHitTest.GridRecord.Values
      [ADragAndDropInfo.KeyColumn.Index];
  end;

  if AcxCustomGridHitTest is TcxGridViewNoneHitTest then
  begin
    AcxGridViewNoneHitTest := AcxCustomGridHitTest as TcxGridViewNoneHitTest;
    AcxGridDBBandedTableView := AcxGridViewNoneHitTest.GridView as
      TcxGridDBBandedTableView;

    ADragAndDropInfo.DropDrag.Key := 0;
    ADragAndDropInfo.DropDrag.OrderValue := 0;
  end;

  if AcxGridDBBandedTableView <> nil then
  begin
    cxGrid.BeginUpdate();
    try
      AQueryOrder.MoveDSRecord(ADragAndDropInfo.StartDrag,
        ADragAndDropInfo.DropDrag);
    finally
      cxGrid.EndUpdate;
    end;
    UpdateView;
  end;
end;

procedure TfrmGrid.DoDragOver(AcxGridSite: TcxGridSite; X, Y: Integer;
var Accept: Boolean);
var
  AcxGridRecordCellHitTest: TcxGridRecordCellHitTest;
  AcxGridViewNoneHitTest: TcxGridViewNoneHitTest;
  HT: TcxCustomGridHitTest;
begin
  Assert(AcxGridSite <> nil);
  Assert(FStartDragLevel <> nil);

  Accept := False;

  HT := AcxGridSite.ViewInfo.GetHitTest(X, Y);

  // Если перетаскиваем на пустой GridView
  if HT is TcxGridViewNoneHitTest then
  begin
    AcxGridViewNoneHitTest := HT as TcxGridViewNoneHitTest;

    Accept := AcxGridViewNoneHitTest.GridView.Level = FStartDragLevel;
  end;

  // Если перетаскиваем на ячейку GridView
  if HT is TcxGridRecordCellHitTest then
  begin
    AcxGridRecordCellHitTest := HT as TcxGridRecordCellHitTest;

    Accept := (AcxGridRecordCellHitTest.GridView.Level = FStartDragLevel) and
      (AcxGridRecordCellHitTest.GridRecord.RecordIndex <>
      AcxGridSite.GridView.DataController.FocusedRecordIndex);
  end
end;

procedure TfrmGrid.DoOnCustomDrawColumnHeader
  (AViewInfo: TcxGridColumnHeaderViewInfo; ACanvas: TcxCanvas);
begin
  if AViewInfo.IsPressed then
  begin
    ACanvas.Brush.Color := DMRepository.cxHeaderStyle.Color XOR $FFFFFF;
    ACanvas.Font.Color := clBlack XOR $FFFFFF;
  end
end;

procedure TfrmGrid.DoOnGetHeaderStyle(AColumn: TcxGridColumn;
var AStyle: TcxStyle);
begin
  if AColumn = nil then
    Exit;

  if AColumn.SortIndex = 0 then
    AStyle := DMRepository.cxHeaderStyle;
end;

procedure TfrmGrid.DoOnStartDrag(AcxGridSite: TcxGridSite;
ADragAndDropInfo: TDragAndDropInfo);
var
  i: Integer;
begin
  Assert(AcxGridSite <> nil);
  Assert(ADragAndDropInfo <> nil);

  with AcxGridSite.GridView as TcxGridDBBandedTableView do
  begin
    // Запоминаем с какого уровня начали перенос
    FStartDragLevel := Level as TcxGridLevel;
    Assert(Controller.SelectedRowCount > 0);

    if VarIsNull(Controller.SelectedRows[0].Values[ADragAndDropInfo.OrderColumn.
      Index]) then
      Exit;

    // запоминаем минимальный порядок записи которую начали переносить
    ADragAndDropInfo.StartDrag.MinOrderValue := Controller.SelectedRows[0]
      .Values[ADragAndDropInfo.OrderColumn.Index];

    // запоминаем максимальный порядок записи которую начали переносить
    ADragAndDropInfo.StartDrag.MaxOrderValue := Controller.SelectedRows
      [Controller.SelectedRecordCount - 1].Values
      [ADragAndDropInfo.OrderColumn.Index];

    SetLength(ADragAndDropInfo.StartDrag.Keys, Controller.SelectedRowCount);
    for i := 0 to Controller.SelectedRowCount - 1 do
    begin
      ADragAndDropInfo.StartDrag.Keys[i] := Controller.SelectedRecords[i].Values
        [ADragAndDropInfo.KeyColumn.Index];
    end;

  end;

end;

procedure TfrmGrid.FocusColumnEditor(AView: TcxGridDBBandedTableView;
AFieldName: string);
var
  AColumn: TcxGridDBBandedColumn;
begin
  Assert(AView <> nil);

  if (ParentForm = nil) or (not ParentForm.Visible) then
    Exit;

  AView.Focused := True;
  AColumn := AView.GetColumnByFieldName(AFieldName);

  // Site обеспечивает доступ к элементам размещённым на cxGrid
  if AView.Site.Parent <> nil then
    AView.Site.SetFocus;

  // Показываем редактор для колонки
  AView.Controller.EditingController.ShowEdit(AColumn);
end;

function TfrmGrid.GetParentForm: TForm;
var
  AWinControl: TWinControl;
begin
  Result := nil;

  AWinControl := Parent;
  while (AWinControl <> nil) and (not(AWinControl is TForm)) do
  begin
    AWinControl := AWinControl.Parent;
  end;

  if AWinControl <> nil then
    Result := AWinControl as TForm;
end;

function TfrmGrid.GetSameColumn(AView: TcxGridTableView; AColumn: TcxGridColumn)
  : TcxGridDBBandedColumn;
begin
  Assert(AView <> nil);
  Assert(AColumn <> nil);
  Result := (AView as TcxGridDBBandedTableView).GetColumnByFieldName
    ((AColumn as TcxGridDBBandedColumn).DataBinding.FieldName);
  Assert(Result <> nil);
end;

procedure TfrmGrid.InternalRefreshData;
begin
  // TODO -cMM: TfrmGrid.InternalRefreshData default body inserted
end;

procedure TfrmGrid.InvertSortOrder(AColumn: TcxGridDBBandedColumn);
begin
  Assert(AColumn <> nil);
  if AColumn.SortOrder = soAscending then
    AColumn.SortOrder := soDescending
  else
    AColumn.SortOrder := soAscending;
end;

procedure TfrmGrid.MyApplyBestFitForView(AView: TcxGridDBBandedTableView);
var
  ABandCaption: string;
  ACaption: String;
  AColumn: TcxGridDBBandedColumn;
  i: Integer;
begin
  Assert(AView <> nil);

  if ApplyBestFitMultiLine then
  begin
    if not FApplyBestFitPosted then
      AView.BeginBestFitUpdate;
    try

      for i := 0 to AView.VisibleColumnCount - 1 do
      begin
        AColumn := AView.VisibleColumns[i] as TcxGridDBBandedColumn;
        ACaption := AColumn.Caption;

        if AColumn.Position.Band <> nil then
          ABandCaption := AColumn.Position.Band.Caption
        else
          ABandCaption := '';

        AColumn.Caption :=
          GetWords(Format('%s %s', [AColumn.Caption, ABandCaption]));

        AColumn.ApplyBestFit();
        AColumn.Caption := ACaption;
      end;
    finally
      if not FApplyBestFitPosted then
        AView.EndBestFitUpdate;
    end;
  end
  else
    AView.ApplyBestFit(nil, True, True);

end;

procedure TfrmGrid.RefreshData;
begin
  BeginUpdate;
  try
    InternalRefreshData;
  finally
    EndUpdate;
  end;
end;

function TfrmGrid.SameCol(AColumn1: TcxGridColumn;
AColumn2: TcxGridDBBandedColumn): Boolean;
begin
  Result := (AColumn1 is TcxGridDBBandedColumn) and
    ((AColumn1 as TcxGridDBBandedColumn).DataBinding.FieldName = AColumn2.
    DataBinding.FieldName);
end;

procedure TfrmGrid.SetStatusBarEmptyPanelIndex(const Value: Integer);
begin
  if FStatusBarEmptyPanelIndex <> Value then
  begin
    if not(Value > 0) and (Value < StatusBar.Panels.Count) then
      raise Exception.Create('Неверный индекс панели состояния');

    FStatusBarEmptyPanelIndex := Value;
  end;
end;

procedure TfrmGrid.StatusBarResize(Sender: TObject);
begin
  if (FStatusBarEmptyPanelIndex >= 0) and
    (FStatusBarEmptyPanelIndex < StatusBar.Panels.Count) then
    DoStatusBarResize(FStatusBarEmptyPanelIndex);
end;

function TfrmGrid.Value(AView: TcxGridDBBandedTableView;
AColumn: TcxGridDBBandedColumn; const ARowIndex: Integer): Variant;
var
  V: Variant;
begin
  Assert(AView <> nil);
  Assert(AColumn <> nil);
  Assert(ARowIndex >= 0);

  V := AView.ViewData.Rows[ARowIndex].Values[AColumn.Index];
  Assert(not VarIsNull(V));
  Result := V;
end;

end.
