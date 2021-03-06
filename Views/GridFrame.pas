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
  System.Generics.Collections, DragHelper, OrderQuery, GridSort,
  cxDataControllerConditionalFormattingRulesManagerDialog, dxBarBuiltInMenu,
  SelectionInt, dxDateRanges, DSWrap, NotifyEvents;

const
  WM_MY_APPLY_BEST_FIT = WM_USER + 109;
  WM_AfterKeyOrMouseDown = WM_USER + 55;

type
  TGridProcRef = reference to procedure(AView: TcxGridDBBandedTableView);
  // ������ �� �����
  TProcRef = reference to procedure();

  TSaveSelection = record
    ColumnIndex: Integer;
    IDArr: TArray<Integer>;
    FieldNames: TArray<String>;
    View: TcxGridDBBandedTableView;
  end;

  TfrmGrid = class(TFrame, ISelection)
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
    procedure cxGridDBBandedTableViewDataControllerDetailExpanded
      (ADataController: TcxCustomDataController; ARecordIndex: Integer);
    procedure cxGridEnter(Sender: TObject);
    procedure cxGridExit(Sender: TObject);
  strict private
    function GetHaveFocus: Boolean;
  private
    FAfterKeyOrMouseDownPosted: Boolean;
    FAfterOpenE: TNotifyEventWrap;
    FApplyBestFitForDetail: Boolean;
    FApplyBestFitMultiLine: Boolean;
    FApplyBestFitPosted: Boolean;
    FcxDataDetailCollapsingEvent: TcxDataDetailExpandingEvent;
    FcxDataDetailExpandingEvent: TcxDataDetailExpandingEvent;
    FDeleteMessages: TDictionary<TcxGridLevel, String>;
    FDSWrap: TDSWrap;
    FGridSort: TGridSort;
    FHaveFocus: Boolean;
    FLeftPos: Integer;
    FPostOnEnterFields: TList<String>;
    FStartDragLevel: TcxGridLevel;
    FStatusBarEmptyPanelIndex: Integer;
    FUpdateCount: Cardinal;
    FViewArr: TArray<TcxGridDBBandedTableView>;
    procedure DoAfterOpen(Sender: TObject);
    function GetMainView: TcxGridDBBandedTableView;
    function GetParentForm: TForm;
    procedure SetStatusBarEmptyPanelIndex(const Value: Integer);
    { Private declarations }
  protected
    FColumnsBarButtons: TGVColumnsBarButtons;
    FEventList: TObjectList;
    FHitTest: TcxCustomGridHitTest;
    procedure AfterKeyOrMouseDown(var Message: TMessage);
      message WM_AfterKeyOrMouseDown;
    procedure ApplyBestFitForColumn(AColumn: TcxGridDBBandedColumn); virtual;
    procedure ClearSelectionForClick; virtual;
    procedure CreateColumnsBarButtons; virtual;
    procedure CreateFilterForExport(AView,
      ASource: TcxGridDBBandedTableView); virtual;
    function CreateViewArr: TArray<TcxGridDBBandedTableView>; virtual;
    procedure DoCancelDetailExpanding(ADataController: TcxCustomDataController;
      ARecordIndex: Integer; var AAllow: Boolean);
    procedure DoCancelFocusRecord(Sender: TcxCustomGridTableView;
      ARecord: TcxCustomGridRecord; var AAllow: Boolean);
    procedure DoDeleteFromView(AView: TcxGridDBBandedTableView); virtual;
    procedure DoOnDetailExpanded(ADataController: TcxCustomDataController;
      ARecordIndex: Integer); virtual;
    procedure DoOnEditKeyDown(Sender: TcxCustomGridTableView;
      AItem: TcxCustomGridTableItem; AEdit: TcxCustomEdit; var Key: Word;
      Shift: TShiftState);
    procedure DoOnKeyOrMouseDown;
    procedure DoOnMyApplyBestFit(var Message: TMessage);
      message WM_MY_APPLY_BEST_FIT;
    function GetFocusedTableView: TcxGridDBBandedTableView;
    procedure InitColumns(AView: TcxGridDBBandedTableView); virtual;
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
    procedure OnGridRecordCellPopupMenu(AColumn: TcxGridDBBandedColumn;
      var AllowPopup: Boolean); virtual;
    procedure DoStatusBarResize(AEmptyPanelIndex: Integer);
    procedure InitView(AView: TcxGridDBBandedTableView); virtual;
    procedure InternalRefreshData; virtual;
    procedure MyDelete; virtual;
    procedure OnGridBandHeaderPopupMenu(ABand: TcxGridBand;
      var AllowPopup: Boolean); virtual;
    procedure OnGridColumnHeaderPopupMenu(AColumn: TcxGridDBBandedColumn;
      var AllowPopup: Boolean); virtual;
    procedure OnGridViewNoneHitTest(var AllowPopup: Boolean); virtual;
    procedure ProcessGridPopupMenu(ASenderMenu: TComponent;
      AHitTest: TcxCustomGridHitTest; X, Y: Integer;
      var AllowPopup: Boolean); virtual;
    function SameCol(AColumn1: TcxGridColumn;
      AColumn2: TcxGridDBBandedColumn): Boolean;
    procedure SetDSWrap(const Value: TDSWrap); virtual;
    property ViewArr: TArray<TcxGridDBBandedTableView> read FViewArr;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AfterConstruction; override;
    procedure ApplyBestFitFocusedBand; virtual;
    procedure ApplySort(Sender: TcxGridTableView; AColumn: TcxGridColumn);
    procedure BeginUpdate; virtual;
    function GetFocusedValue(const AFieldName: string): Variant;
    function GetSelectedValues(AColumn: TcxGridDBBandedColumn): TArray<Variant>;
        overload;
    function GetSelectedValues(AView: TcxGridDBBandedTableView; AColumnIndex:
        Integer): TArray<Variant>; overload;
    function GetSelectedValues(const AFieldName: string): TArray<Variant>; overload;
    function CalcBandHeight(ABand: TcxGridBand): Integer;
    procedure ChooseTopRecord(AView: TcxGridTableView; ARecordIndex: Integer);
    procedure ChooseTopRecord1(AView: TcxGridTableView; ARecordIndex: Integer);
    procedure ClearSelection; virtual;
    procedure ClearSort(AView: TcxGridTableView);
    procedure DisableCollapsingAndExpanding;
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
    procedure EnableCollapsingAndExpanding;
    procedure EndUpdate; virtual;
    procedure ExportViewToExcel(AView: TcxGridDBBandedTableView;
      AFileName: string; AGridProcRef: TGridProcRef = nil);
    procedure FocusColumnEditor(ALevel: Integer; AFieldName: string); overload;
    procedure FocusColumnEditor(AView: TcxGridDBBandedTableView;
      AFieldName: string); overload;
    procedure FocusFirstSelectedRow(AView: TcxGridDBBandedTableView);
    procedure FocusSelectedRecord(AView: TcxGridDBBandedTableView); overload;
    procedure FocusSelectedRecord; overload;
    procedure FocusTopLeft(const AFieldName: string); overload;
    procedure FocusTopLeft(AColumn: TcxGridBandedColumn); overload;
    procedure FocusTopLeft; overload;
    function GetColumns(AView: TcxGridDBBandedTableView)
      : TArray<TcxGridDBBandedColumn>;
    procedure PutInTheCenterFocusedRecord
      (AView: TcxGridDBBandedTableView); overload;
    function GetDBBandedTableView(ALevel: Cardinal): TcxGridDBBandedTableView;
    function GetRow(ALevel: Cardinal; ARowIndex: Integer = -1)
      : TcxCustomGridRow;
    function GetSameColumn(AView: TcxGridTableView; AColumn: TcxGridColumn)
      : TcxGridDBBandedColumn;
    function GetSelectedRowIndexes(AView: TcxGridDBBandedTableView;
      AReverse: Boolean): TArray<Integer>;
    function GetSelectedIntValues(AColumn: TcxGridDBBandedColumn)
      : TArray<Integer>; overload;
    function GetSelectedIntValues(AView: TcxGridDBBandedTableView;
      AColumnIndex: Integer): TArray<Integer>; overload;
    function GetSelectedRowIndexesForMove(AView: TcxGridDBBandedTableView;
      AUp: Boolean; var AArray: TArray<Integer>;
      var ATargetRowIndex: Integer): Boolean;
    procedure MyApplyBestFit; virtual;
    procedure PostMyApplyBestFitEvent;
    procedure UpdateColumnsMinWidth(AView: TcxGridDBBandedTableView);
    procedure UpdateView; virtual;
    function GridView(ALevel: TcxGridLevel): TcxGridDBBandedTableView;
    procedure InvertSortOrder(AColumn: TcxGridDBBandedColumn);
    function MyApplyBestFitForBand(ABand: TcxGridBand): Integer;
    procedure MyApplyBestFitForView(AView: TcxGridDBBandedTableView); virtual;
    procedure Place(AParent: TWinControl);
    procedure PostMyApplyBestFitEventForView(AView: TcxGridDBBandedTableView);
    procedure PutInTheCenterFocusedRecord; overload;
    function QueryInterface(const IID: TGUID; out Obj): HResult; override;
    procedure RefreshData;
    procedure RestoreSelection(ASaveSelection: TSaveSelection);
    function SaveSelection(AView: TcxGridDBBandedTableView;
      AColumnIndex: Integer): TSaveSelection;
    procedure SelectFocusedRecord(const AFieldName: String);
    procedure SetZeroBandWidth(AView: TcxGridDBBandedTableView);
    procedure TryClearSelection(X, Y: Integer);
    function Value(AView: TcxGridDBBandedTableView;
      AColumn: TcxGridDBBandedColumn; const ARowIndex: Integer): Variant;
    property ApplyBestFitForDetail: Boolean read FApplyBestFitForDetail
      write FApplyBestFitForDetail;
    property ApplyBestFitMultiLine: Boolean read FApplyBestFitMultiLine
      write FApplyBestFitMultiLine;
    property DeleteMessages: TDictionary<TcxGridLevel, String>
      read FDeleteMessages;
    property DSWrap: TDSWrap read FDSWrap write SetDSWrap;
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

  TGridViewClass = class of TfrmGrid;

implementation

{$R *.dfm}

uses RepositoryDataModule, System.Math, cxDBLookupComboBox, cxGridExportLink,
  dxCore, DialogUnit, StrHelper, System.Types, TextRectHelper,
  DBLookupComboBoxHelper, FormsHelper, ProjectConst;

constructor TfrmGrid.Create(AOwner: TComponent);
begin
  inherited;
  FColumnsBarButtons := nil;
  FUpdateCount := 0;
  FEventList := TObjectList.Create;
  FStatusBarEmptyPanelIndex := -1;

  // ������ ����� ��� �������������� ������� Enter - ����������
  FPostOnEnterFields := TList<String>.Create;
  FGridSort := TGridSort.Create;

  FDeleteMessages := TDictionary<TcxGridLevel, String>.Create;
  FApplyBestFitForDetail := False;

  TFormsHelper.SetFont(Self, BaseFontSize);
end;

destructor TfrmGrid.Destroy;
begin
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
var
  AView: TcxGridDBBandedTableView;
begin
  inherited;

  // ������ ������ �������������
  FViewArr := CreateViewArr;

  // �������������� �������������
  for AView in FViewArr do
    InitView(AView);

  CreateColumnsBarButtons;
end;

procedure TfrmGrid.AfterKeyOrMouseDown(var Message: TMessage);
begin
  UpdateView;
  FAfterKeyOrMouseDownPosted := False;
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

procedure TfrmGrid.ApplyBestFitForColumn(AColumn: TcxGridDBBandedColumn);
begin
  try
    AColumn.ApplyBestFit(True);
  except
    ;
  end;
end;

procedure TfrmGrid.ApplySort(Sender: TcxGridTableView; AColumn: TcxGridColumn);
var
  AColSortOrder: TdxSortOrder;
  ASortOrder: TdxSortOrder;
  ASortVariant: TSortVariant;
  Col: TcxGridDBBandedColumn;
  S: string;
begin
  inherited;

  ASortVariant := FGridSort.GetSortVariant(AColumn);

  // ���� ��� ������ �� ���� ������ ��� ��������� ����������
  if ASortVariant = nil then
    Exit;

  if (AColumn.SortOrder = soAscending) then
    ASortOrder := soDescending
  else
    ASortOrder := soAscending;

  Sender.BeginSortingUpdate;
  try
    // �������� ����������
    ClearSort(Sender);

    // ��������� ����������
    for S in ASortVariant.SortedFieldNames do
    begin
      Col := (Sender as TcxGridDBBandedTableView).GetColumnByFieldName(S);
      Assert(Col <> nil);
      AColSortOrder := ASortOrder;

      // ��������� ����������
      Col.SortOrder := AColSortOrder;
    end;

  finally
    Sender.EndSortingUpdate;
  end;
end;

procedure TfrmGrid.BeginUpdate;
begin
  Inc(FUpdateCount);
  if FUpdateCount = 1 then
    DisableCollapsingAndExpanding;

  cxGrid.BeginUpdate();
end;

function TfrmGrid.CalcBandHeight(ABand: TcxGridBand): Integer;
const
  MAGIC = 10;
var
  ABandHeight: Integer;
  ABandWidth: Integer;
  ACanvas: TCanvas;
  R: TRect;
begin
  Assert(ABand <> nil);

  ACanvas := ABand.GridView.ViewInfo.Canvas.Canvas;

  ABandWidth := ABand.GridView.ViewInfo.HeaderViewInfo.BandsViewInfo.Items
    [ABand.VisibleIndex].Width;

  ABandHeight := ACanvas.TextHeight(ABand.Caption);

  R := TTextRect.Calc(ACanvas, ABand.Caption,
    Rect(0, 0, ABandWidth, ABandHeight));

  Result := MAGIC + R.Height;
end;

// ��������� ������� ������ ���, ����� ������ ��� ����� ��������� �������
procedure TfrmGrid.ChooseTopRecord(AView: TcxGridTableView;
  ARecordIndex: Integer);
var
  ARowIndex: Integer;
  Cnt: Integer;
  i: Integer;
  LastVisibleRecIndex: Integer;
  T: Integer;
begin
  Assert(AView <> nil);
  Assert(ARecordIndex >= 0);

  // �������� ����� ������ �� ������ ������ � ��
  ARowIndex := AView.DataController.GetRowIndexByRecordIndex
    (ARecordIndex, False);

  T := AView.Controller.TopRecordIndex;
  Cnt := AView.ViewInfo.RecordsViewInfo.VisibleCount;
  LastVisibleRecIndex := T - 1 + Cnt;

  i := 0;
  // ���� ������� ������ ����� �� ���������
  while (i < 50) and (ARowIndex > T) and (ARowIndex > LastVisibleRecIndex) do
  begin
    // �������� ����� �� ���� ������
    AView.Controller.TopRecordIndex := T + 1;

    T := AView.Controller.TopRecordIndex;
    Cnt := AView.ViewInfo.RecordsViewInfo.VisibleCount;
    LastVisibleRecIndex := T - 1 + Cnt;

    Inc(i); // ����������� ���-�� �������
  end;

end;

// ��������� ������� ������ ���, ����� ������ ��� ����� ��������� �������
procedure TfrmGrid.ChooseTopRecord1(AView: TcxGridTableView;
  ARecordIndex: Integer);
var
  Cnt: Integer;
  i: Integer;
  LastVisibleRecIndex: Integer;
  T: Integer;
begin
  Assert(AView <> nil);
  Assert(ARecordIndex >= 0);

  T := AView.Controller.TopRecordIndex;
  Cnt := AView.ViewInfo.RecordsViewInfo.VisibleCount;
  LastVisibleRecIndex := T - 1 + Cnt;

  i := 0;
  // ���� ������� ������ ����� �� ���������
  while (i < 50) and (ARecordIndex > T) and
    (ARecordIndex >= LastVisibleRecIndex) do
  begin
    // �������� ����� �� ���� ������
    AView.Controller.TopRecordIndex := T + 1;

    T := AView.Controller.TopRecordIndex;
    Cnt := AView.ViewInfo.RecordsViewInfo.VisibleCount;
    LastVisibleRecIndex := T - 1 + Cnt;

    Inc(i); // ����������� ���-�� �������
  end;
end;

procedure TfrmGrid.ClearSelection;
var
  AcxGridMasterDataRow: TcxGridMasterDataRow;
  AView: TcxGridTableView;
  i: Integer;
begin
  MainView.Controller.ClearSelection;
  MainView.Controller.EditingController.HideEdit(False);

  if (MainView.ViewData.RowCount > 0) and
    (MainView.ViewData.Rows[0] is TcxGridMasterDataRow) then
  begin
    for i := 0 to MainView.ViewData.RowCount - 1 do
    begin
      AcxGridMasterDataRow := MainView.ViewData.Rows[i] as TcxGridMasterDataRow;
      AView := AcxGridMasterDataRow.ActiveDetailGridView as TcxGridTableView;
      if AView <> nil then
      begin
        AView.Controller.ClearSelection;
        AView.Controller.EditingController.HideEdit(False);
      end;
    end;
  end;

  UpdateView;
end;

procedure TfrmGrid.ClearSelectionForClick;
begin
  ClearSelection;
end;

function TfrmGrid.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;
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

function TfrmGrid.CreateViewArr: TArray<TcxGridDBBandedTableView>;
begin
  Result := [MainView];
end;

procedure TfrmGrid.cxGridDBBandedTableViewCustomDrawColumnHeader
  (Sender: TcxGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridColumnHeaderViewInfo; var ADone: Boolean);
begin
  DoOnCustomDrawColumnHeader(AViewInfo, ACanvas);
end;

procedure TfrmGrid.cxGridDBBandedTableViewDataControllerDetailExpanded
  (ADataController: TcxCustomDataController; ARecordIndex: Integer);
begin
  inherited;
  DoOnDetailExpanded(ADataController, ARecordIndex);
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
  DoOnKeyOrMouseDown;
end;

procedure TfrmGrid.cxGridDBBandedTableViewMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  TryClearSelection(X, Y);
  DoOnKeyOrMouseDown;
end;

procedure TfrmGrid.cxGridDBBandedTableViewStylesGetHeaderStyle
  (Sender: TcxGridTableView; AColumn: TcxGridColumn; var AStyle: TcxStyle);
begin
  DoOnGetHeaderStyle(AColumn, AStyle);
end;

procedure TfrmGrid.cxGridEnter(Sender: TObject);
begin
  FHaveFocus := True;
end;

procedure TfrmGrid.cxGridExit(Sender: TObject);
begin
  FHaveFocus := False;
end;

procedure TfrmGrid.cxGridPopupMenuPopup(ASenderMenu: TComponent;
  AHitTest: TcxCustomGridHitTest; X, Y: Integer; var AllowPopup: Boolean);
begin
  inherited;
  ProcessGridPopupMenu(ASenderMenu, AHitTest, X, Y, AllowPopup);
end;

procedure TfrmGrid.DisableCollapsingAndExpanding;
begin
  Assert(not Assigned(FcxDataDetailCollapsingEvent));
  Assert(not Assigned(FcxDataDetailExpandingEvent));

  // ��������� ����������� � ������������� ������
  FcxDataDetailCollapsingEvent := MainView.DataController.OnDetailCollapsing;
  FcxDataDetailExpandingEvent := MainView.DataController.OnDetailExpanding;
  MainView.DataController.OnDetailExpanding := DoCancelDetailExpanding;
  MainView.DataController.OnDetailCollapsing := DoCancelDetailExpanding;
  // MainView.OnCanFocusRecord := DoCancelFocusRecord;
end;

procedure TfrmGrid.DoAfterOpen(Sender: TObject);
begin
  MainView.DataController.CreateAllItems(True);
  InitColumns(MainView);

  // ���� ���� �������� �� ������� - ������������!
  if Assigned(FAfterOpenE) then
    FreeAndNil(FAfterOpenE);
end;

procedure TfrmGrid.DoCancelDetailExpanding(ADataController
  : TcxCustomDataController; ARecordIndex: Integer; var AAllow: Boolean);
begin
  AAllow := False;
end;

procedure TfrmGrid.DoCancelFocusRecord(Sender: TcxCustomGridTableView;
  ARecord: TcxCustomGridRecord; var AAllow: Boolean);
begin
  AAllow := False;
end;

procedure TfrmGrid.DoDeleteFromView(AView: TcxGridDBBandedTableView);
begin
  AView.BeginUpdate();
  DisableCollapsingAndExpanding;
  try
    try
      if AView.Controller.SelectedRowCount > 0 then
      begin
        AView.DataController.DeleteSelection
      end
      else
        AView.DataController.DeleteFocused;
    except
      On E: Exception do
        TDialog.Create.ErrorMessageDialog(E.Message);
    end;
  finally
    EnableCollapsingAndExpanding;
    AView.EndUpdate;
  end;

  if (AView.DataController.RecordCount = 0) and (AView.MasterGridRecord <> nil)
  then
  begin
    AView.MasterGridRecord.Collapse(False);
  end;

end;

procedure TfrmGrid.MyDelete;
var
  AView: TcxGridDBBandedTableView;
  S: string;
begin
  Application.Hint := '';
  Assert(FDeleteMessages <> nil);

  AView := FocusedTableView;
  if AView = nil then
    Exit;

  if not FDeleteMessages.ContainsKey(AView.Level as TcxGridLevel) then
    S := '������� ������?'
  else
    S := FDeleteMessages[AView.Level as TcxGridLevel];

  if (TDialog.Create.DeleteRecordsDialog(S)) and
    (AView.DataController.RecordCount > 0) then
  begin
    DoDeleteFromView(AView);
  end;

  UpdateView;

end;

procedure TfrmGrid.DoOnEditKeyDown(Sender: TcxCustomGridTableView;
  AItem: TcxCustomGridTableItem; AEdit: TcxCustomEdit; var Key: Word;
  Shift: TShiftState);
var
  AColumn: TcxGridDBBandedColumn;
begin
  DoOnKeyOrMouseDown;

  AColumn := AItem as TcxGridDBBandedColumn;

  if (Key = 13) and (FPostOnEnterFields.IndexOf(AColumn.DataBinding.FieldName)
    >= 0) then
  begin
    cxGridDBBandedTableView.DataController.Post();
    UpdateView;
  end;
end;

procedure TfrmGrid.DoOnMyApplyBestFit(var Message: TMessage);
var
  AView: TcxGridDBBandedTableView;
begin
  inherited;

  AView := TcxGridDBBandedTableView(Message.WParam);
  Assert(AView <> nil);

  Assert(FApplyBestFitPosted);

  MyApplyBestFitForView(AView);

  AView.EndBestFitUpdate;
  FApplyBestFitPosted := False;
end;

procedure TfrmGrid.EndUpdate;
begin
  Assert(FUpdateCount > 0);
  cxGrid.EndUpdate;
  Dec(FUpdateCount);
  if FUpdateCount = 0 then
    EnableCollapsingAndExpanding;
end;

procedure TfrmGrid.ExportViewToExcel(AView: TcxGridDBBandedTableView;
  AFileName: string; AGridProcRef: TGridProcRef = nil);
var
  Grid: TcxGrid;
  Level: TcxGridLevel;
  GridView: TcxGridDBBandedTableView;
  p: Integer;
  S: string;
begin
  Assert(not AFileName.IsEmpty);

  Grid := TcxGrid.Create(Self);
  Level := Grid.Levels.Add;
  GridView := Grid.CreateView(TcxGridDBBandedTableView)
    as TcxGridDBBandedTableView;
  GridView.DataController.DataSource := AView.DataController.DataSource;
  GridView.Assign(AView);
  GridView.OptionsView.Footer := False; // ����� �������������� �� �����

  // ��������� ���-�� ��� � �������
  CreateFilterForExport(GridView, AView);

  // ������ ������� ���� �����-�� �� �������� ��� � ���
  Grid.Width := cxGrid.Width;
  Grid.Height := cxGrid.Height;
  // ���������� ���-�� �����
  Grid.Font.Assign(Font);

  Level.GridView := GridView;

  if Assigned(AGridProcRef) then
    AGridProcRef(GridView);

  // ���������� ����������� ������ �������
  MyApplyBestFitForView(GridView);
  // GridView.ApplyBestFit();

  // ���� ��� ����� �������� �����, �� �� ��� ����� ����� ������ ���� ����������� �����
  p := AFileName.LastIndexOf('.');
  if (p > 0) then
  begin
    S := AFileName.Substring(p).ToLower;
    if S.Substring(0, 4) <> '.xls' then
      AFileName := AFileName + '.xls';
  end;

  // ������������ � Excel
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

    // ������ ������������� ��������
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

        if not(AcxGridDBBandedTableView.ViewData.Rows[i] is TcxGridMasterDataRow)
        then
          Exit;

        AcxGridMasterDataRow := GetDBBandedTableView(ALevel - 1).ViewData.Rows
          [i] as TcxGridMasterDataRow;
        // ���������� �� �������� �������
        Result := AcxGridMasterDataRow.ActiveDetailGridView as
          TcxGridDBBandedTableView;
      end;
  else
    raise Exception.Create('������� ������ ���� �� 0 �� 2');
  end;
end;

function TfrmGrid.GetFocusedTableView: TcxGridDBBandedTableView;
begin
  Result := GetDBBandedTableView(0);
  if (Result <> nil) and (not Result.Focused) then
    Result := nil;

  // ���� �� ������ ������� � ������, � ���� ��� ���� �������������
  if (Result = nil) and (Length(FViewArr) > 1) then
  begin
    Result := GetDBBandedTableView(1);
    if (Result <> nil) and (not Result.Focused) then
      Result := nil;
  end;
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
begin
  Assert(AColumn <> nil);

  AColumn.PropertiesClass := TcxLookupComboBoxProperties;
  TDBLCB.InitProp(AColumn.Properties as TcxLookupComboBoxProperties,
    ADataSource, AKeyFieldNames, AListFieldNames, ADropDownListStyle);
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

  // ��������� ���������� ������ ���������� �� �������
  AcxComboBoxProperties.Items.Clear;
  AField.DataSet.First;
  while not AField.DataSet.Eof do
  begin
    AcxComboBoxProperties.Items.Add(AField.AsString);
    AField.DataSet.Next;
  end;
end;

procedure TfrmGrid.MyApplyBestFit;
begin
  MyApplyBestFitForView(MainView);
end;

procedure TfrmGrid.PostMyApplyBestFitEvent;
begin
  PostMyApplyBestFitEventForView(MainView);
end;

procedure TfrmGrid.UpdateColumnsMinWidth(AView: TcxGridDBBandedTableView);
var
  AColumn: TcxGridDBBandedColumn;
  i: Integer;
  RealColumnWidth: Integer;
begin
  // �������� ����������� ������� ���� �������
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

procedure TfrmGrid.OnGridRecordCellPopupMenu(AColumn: TcxGridDBBandedColumn;
  var AllowPopup: Boolean);
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
  V: Variant;

begin
  Assert(AcxGridSite <> nil);
  Assert(ADragAndDropInfo <> nil);

  AcxGridDBBandedTableView := nil;

  // ���������� ����� ��������
  AcxCustomGridHitTest := AcxGridSite.ViewInfo.GetHitTest(X, Y);

  if AcxCustomGridHitTest is TcxGridRecordCellHitTest then
  begin
    AcxGridRecordCellHitTest :=
      AcxCustomGridHitTest as TcxGridRecordCellHitTest;
    AcxGridDBBandedTableView := AcxGridRecordCellHitTest.GridView as
      TcxGridDBBandedTableView;

    V := AcxGridRecordCellHitTest.GridRecord.Values
      [ADragAndDropInfo.OrderColumn.Index];

    // ������� "�������" ������ ��������� ����� �����!
    Assert(not VarIsNull(V));

    // ���������� ������� � ����� ��������
    ADragAndDropInfo.DropDrag.OrderValue := V;

    // ���������� ��� ������ � ����� ��������
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

  // ���� ������������� �� ������ GridView
  if HT is TcxGridViewNoneHitTest then
  begin
    AcxGridViewNoneHitTest := HT as TcxGridViewNoneHitTest;

    Accept := AcxGridViewNoneHitTest.GridView.Level = FStartDragLevel;
  end;

  // ���� ������������� �� ������ GridView
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

procedure TfrmGrid.DoOnDetailExpanded(ADataController: TcxCustomDataController;
  ARecordIndex: Integer);
var
  AcxGridMasterDataRow: TcxGridMasterDataRow;
  ARowIndex: Integer;
  AView: TcxGridDBBandedTableView;
begin
  if (not ApplyBestFitForDetail) or (ARecordIndex < 0) then
    Exit;

  ARowIndex := ADataController.GetRowIndexByRecordIndex(ARecordIndex, False);

  AcxGridMasterDataRow := cxGridDBBandedTableView.ViewData.Rows[ARowIndex]
    as TcxGridMasterDataRow;

  AView := AcxGridMasterDataRow.ActiveDetailGridView as
    TcxGridDBBandedTableView;

  MyApplyBestFitForView(AView);
  ChooseTopRecord(MainView, ARecordIndex);
end;

procedure TfrmGrid.DoOnGetHeaderStyle(AColumn: TcxGridColumn;
  var AStyle: TcxStyle);
begin
  if AColumn = nil then
    Exit;

  if AColumn.SortIndex = 0 then
    AStyle := DMRepository.cxHeaderStyle;
end;

procedure TfrmGrid.DoOnKeyOrMouseDown;
begin
  if not FAfterKeyOrMouseDownPosted then
  begin
    FAfterKeyOrMouseDownPosted := True;
    PostMessage(Handle, WM_AfterKeyOrMouseDown, 0, 0);
  end;
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
    // ���������� � ������ ������ ������ �������
    FStartDragLevel := Level as TcxGridLevel;
    Assert(Controller.SelectedRowCount > 0);

    if VarIsNull(Controller.SelectedRows[0].Values[ADragAndDropInfo.OrderColumn.
      Index]) then
      Exit;

    // ���������� ����������� ������� ������ ������� ������ ����������
    ADragAndDropInfo.StartDrag.MinOrderValue := Controller.SelectedRows[0]
      .Values[ADragAndDropInfo.OrderColumn.Index];

    // ���������� ������������ ������� ������ ������� ������ ����������
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

procedure TfrmGrid.EnableCollapsingAndExpanding;
begin
  // ��������� ����������� � ������������� ������
  MainView.DataController.OnDetailCollapsing := FcxDataDetailCollapsingEvent;
  MainView.DataController.OnDetailExpanding := FcxDataDetailExpandingEvent;

  FcxDataDetailCollapsingEvent := nil;
  FcxDataDetailExpandingEvent := nil;
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

  // Site ������������ ������ � ��������� ����������� �� cxGrid
  if AView.Site.Parent <> nil then
    AView.Site.SetFocus;

  // ���������� �������� ��� �������
  AView.Controller.EditingController.ShowEdit(AColumn);
end;

procedure TfrmGrid.FocusFirstSelectedRow(AView: TcxGridDBBandedTableView);
begin
  Assert(AView <> nil);
  Assert(AView.Controller <> nil);

  if AView.Controller.SelectedRowCount = 0 then
    Exit;

  AView.Controller.SelectedRows[0].Focused := True;
end;

procedure TfrmGrid.FocusTopLeft(const AFieldName: string);
var
  AColumn: TcxGridDBBandedColumn;
begin
  AColumn := MainView.GetColumnByFieldName(AFieldName);
  FocusTopLeft(AColumn);
end;

procedure TfrmGrid.FocusTopLeft(AColumn: TcxGridBandedColumn);
begin
  Assert(AColumn <> nil);
  if AColumn.GridView.ViewData.RowCount = 0 then
    Exit;

  MainView.Controller.ClearSelection;
  MainView.Controller.TopRowIndex := 0;
  MainView.Controller.LeftPos := 0;
  MainView.ViewData.Rows[0].Focused := True;
  if AColumn <> nil then
    AColumn.Focused := True;
end;

procedure TfrmGrid.FocusTopLeft;
var
  AColumn: TcxGridBandedColumn;
begin
  if MainView.VisibleColumnCount = 0 then
    Exit;
  AColumn := MainView.VisibleColumns[0];
  FocusTopLeft(AColumn);
end;

function TfrmGrid.GetColumns(AView: TcxGridDBBandedTableView)
  : TArray<TcxGridDBBandedColumn>;
var
  i: Integer;
  L: TList<TcxGridDBBandedColumn>;
begin
  L := TList<TcxGridDBBandedColumn>.Create;
  try
    // ���� �� ���� ��������
    for i := 0 to AView.ColumnCount - 1 do
    begin
      L.Add(AView.Columns[i]);
    end;
    Result := L.ToArray;
  finally
    FreeAndNil(L);
  end;
end;

function TfrmGrid.GetHaveFocus: Boolean;
begin
  Result := FHaveFocus;
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

function TfrmGrid.GetSelectedRowIndexes(AView: TcxGridDBBandedTableView;
  AReverse: Boolean): TArray<Integer>;
var
  i: Integer;
  m: TList<Integer>;
begin
  Result := nil;
  Assert(AView <> nil);

  m := TList<Integer>.Create;
  try
    if AView.Controller.SelectedRowCount > 0 then
    begin
      for i := 0 to AView.Controller.SelectedRowCount - 1 do
      begin
        m.Add(AView.Controller.SelectedRows[i].Index);
      end;
    end
    else
      m.Add(AView.Controller.FocusedRow.Index);

    m.Sort;
    // ���������� ��� ������� � ������ ����������
    Assert(m.Last - m.First + 1 = m.Count);

    if AReverse then
      m.Reverse;

    // ������ ������ �� ������ ������
    Result := m.ToArray;
  finally
    FreeAndNil(m);
  end;
end;

function TfrmGrid.GetSelectedIntValues(AColumn: TcxGridDBBandedColumn)
  : TArray<Integer>;
begin
  Assert(AColumn <> nil);
  Result := GetSelectedIntValues(AColumn.GridView as TcxGridDBBandedTableView,
    AColumn.Index);
end;

function TfrmGrid.GetSelectedIntValues(AView: TcxGridDBBandedTableView;
  AColumnIndex: Integer): TArray<Integer>;
var
  i: Integer;
  L: TList<Integer>;
begin
  Assert(AView <> nil);

  L := TList<Integer>.Create;
  try
    for i := 0 to AView.Controller.SelectedRowCount - 1 do
    begin
      L.Add(AView.Controller.SelectedRows[i].Values[AColumnIndex]);
    end;
    Result := L.ToArray;
  finally
    FreeAndNil(L);
  end;
end;

procedure TfrmGrid.InitColumns(AView: TcxGridDBBandedTableView);
begin
  // TODO -cMM: TfrmGrid.InitColumns default body inserted
end;

function TfrmGrid.GetSelectedRowIndexesForMove(AView: TcxGridDBBandedTableView;
  AUp: Boolean; var AArray: TArray<Integer>;
  var ATargetRowIndex: Integer): Boolean;
begin
  AArray := GetSelectedRowIndexes(AView, not AUp);

  // ������ ������ c ������� ����� �������� ��������
  if AUp then
    ATargetRowIndex := AArray[0] - 1
  else
    ATargetRowIndex := AArray[0] + 1;

  // �������, ��� ������� ����������� ������� ��������
  Result := (ATargetRowIndex >= 0) and
    (ATargetRowIndex < AView.ViewData.RowCount);
end;

procedure TfrmGrid.InitView(AView: TcxGridDBBandedTableView);
begin
  AView.OptionsBehavior.ImmediateEditor := True;
  AView.OptionsView.FocusRect := False;
  // AView.Styles.Inactive := DMRepository.cxInactiveStyle;
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

function TfrmGrid.MyApplyBestFitForBand(ABand: TcxGridBand): Integer;
const
  MAGIC = 20; // 12;
var
  ABandHeight: Integer;
  ABandRect: TRect;
  ABandWidth: Integer;
  ACanvas: TCanvas;
  ACaption: string;
  AColumn: TcxGridDBBandedColumn;
  AIsBandViewInfoExist: Boolean;
  j: Integer;
begin
  Assert(ABand <> nil);
  // ������������ ��� �������� ������ ���!!!
  Assert(ABand.ChildBandCount = 0);
  Result := 0;

  AIsBandViewInfoExist := ABand.GridView.ViewInfo.HeaderViewInfo.BandsViewInfo.
    Count > ABand.VisibleIndex;

  if not AIsBandViewInfoExist then
  begin
    // ����� ���� �� �������� ��������� ����������� ������,
    // �.�. ��� ��������� ����� ������� ��� ����� ������ ��������� �������
    Exit;
  end;

  // ������ ����� ����� ����������� �������������
  ABand.Width := 0;

  // ���� �� ���� ��������
  for j := 0 to ABand.ColumnCount - 1 do
  begin
    AColumn := ABand.Columns[j] as TcxGridDBBandedColumn;
    if not AColumn.Visible then
      Continue;

    ACaption := AColumn.Caption;

    if not ACaption.Trim.IsEmpty then
    begin
      // � ������ ������ �� �����
      AColumn.Caption := GetWords(AColumn.Caption);
    end;
    ApplyBestFitForColumn(AColumn);

    // ���������� ������ ���������
    AColumn.Caption := ACaption;
  end;

  // ���� ��������� ������ �� ������������
  if not ABand.GridView.OptionsView.BandHeaders then
    Exit;

  AIsBandViewInfoExist := ABand.GridView.ViewInfo.HeaderViewInfo.BandsViewInfo.
    Count > ABand.VisibleIndex;

  // ���� ���������� � ������ ������ ��������
  if AIsBandViewInfoExist then
  begin
    ACanvas := ABand.GridView.ViewInfo.Canvas.Canvas;
    // ��������� ����������� ������ �����
    ABandRect := TTextRect.Calc(ACanvas, ABand.Caption);
    // �������� �������� ������ �����
    ABandWidth := ABand.GridView.ViewInfo.HeaderViewInfo.BandsViewInfo.Items
      [ABand.VisibleIndex].Width;

    // ���� ������ ������ ����� �� ����������, ��� ���������� ������ �������� ����� ��� ���������
    if ABandWidth < (ABandRect.Width + MAGIC) then
    begin
      ABand.Width := ABandRect.Width + MAGIC;
      ABandWidth := ABand.GridView.ViewInfo.HeaderViewInfo.BandsViewInfo.Items
        [ABand.VisibleIndex].Width;

      Assert(ABandWidth >= ABandRect.Width);
    end;

    // ���������, ����� ������ ���� ������ �����, ���� �������� ���������� ��� ������
    ABandHeight := CalcBandHeight(ABand);
    Result := ABandHeight;
  end;

end;

procedure TfrmGrid.MyApplyBestFitForView(AView: TcxGridDBBandedTableView);
const
  MAGIC = 12;
var
  ABand: TcxGridBand;
  // ABandCaption: string;
  ABandHeight: Integer;
  // ABandRect: TRect;
  // ABandWidth: Integer;
  // ACanvas: TCanvas;
  // ACaption: String;
  // AColumn: TcxGridDBBandedColumn;
  // AIsBandViewInfoExist: Boolean;
  AMaxBandHeight: Integer;
  i: Integer;
  // j: Integer;
begin
  Assert(AView <> nil);

  // �������������� ��� ���������� ������� �� ������������
  Assert(not AView.OptionsView.ColumnAutoWidth);
  if ApplyBestFitMultiLine then
  begin
    // �������������� ��� ������ ������ ������� ���������� � ������ ����������� �������� ���� � ���������
    Assert(AView.OptionsView.HeaderAutoHeight);

    // �� ����� ������� ����������� ������ ���� �� ������ ���� ������������!!!
    Assert(FUpdateCount = 0);

    if not FApplyBestFitPosted then
      AView.BeginBestFitUpdate;
    try
      SetZeroBandWidth(AView);

      // AIsBandViewInfoExist := AView.ViewInfo.HeaderViewInfo.
      // BandsViewInfo.Count > 0;

      AMaxBandHeight := 0;
      // ���� � ���������� ����� ���������� �����
      // if AView.OptionsView.BandHeaders then
      // begin
      // ACanvas := AView.ViewInfo.Canvas.Canvas;
      for i := 0 to AView.Bands.Count - 1 do
      begin
        ABand := AView.Bands[i];
        if not ABand.Visible then
          Continue;
        // ������������ ��� �������� ������ ���!!!
        Assert(ABand.ChildBandCount = 0);

        (*

          for j := 0 to ABand.ColumnCount - 1 do
          begin
          AColumn := ABand.Columns[j] as TcxGridDBBandedColumn;
          if not AColumn.Visible then
          Continue;

          ACaption := AColumn.Caption;

          // � ������ ������ �� �����
          AColumn.Caption := GetWords(AColumn.Caption);

          ApplyBestFitForColumn(AColumn);

          // ���������� ������ ���������
          AColumn.Caption := ACaption;
          end;

          // ���� ���������� � ������ ������ ��������
          if AIsBandViewInfoExist and
          (ABand.GridView.ViewInfo.HeaderViewInfo.BandsViewInfo.Count >
          ABand.VisibleIndex) then
          begin

          // ��������� ����������� ������ �����
          ABandRect := TTextRect.Calc(ACanvas, ABand.Caption);
          // �������� �������� ������ �����
          ABandWidth := ABand.GridView.ViewInfo.HeaderViewInfo.BandsViewInfo.
          Items[ABand.VisibleIndex].Width;

          // ���� ������ ������ ����� �� ����������, ��� ���������� ������ �������� ����� ��� ���������
          if ABandWidth < (ABandRect.Width + MAGIC) then
          begin
          ABand.Width := ABandRect.Width + MAGIC;
          ABandWidth := ABand.GridView.ViewInfo.HeaderViewInfo.BandsViewInfo.
          Items[ABand.VisibleIndex].Width;

          Assert(ABandWidth >= ABandRect.Width);
          end;

          // ���������, ����� ������ ���� ������ �����, ���� �������� ���������� ��� ������
          ABandHeight := CalcBandHeight(ABand);
        *)

        ABandHeight := MyApplyBestFitForBand(ABand);

        AMaxBandHeight := IfThen(ABandHeight > AMaxBandHeight, ABandHeight,
          AMaxBandHeight);
        // end;
        // end;

        if AMaxBandHeight > 0 then
          AView.OptionsView.BandHeaderHeight := AMaxBandHeight;
      end;

      if AView.Controller.LeftPos <> FLeftPos then
      begin
        try
          AView.Controller.LeftPos := FLeftPos;
        except
          ;
        end;
      end;

      {
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

        AColumn.ApplyBestFit(True);
        AColumn.Caption := ACaption;
        end;
      }
    finally
      if not FApplyBestFitPosted then
        AView.EndBestFitUpdate;
    end;
  end
  else
    AView.ApplyBestFit();

end;

procedure TfrmGrid.OnGridBandHeaderPopupMenu(ABand: TcxGridBand;
  var AllowPopup: Boolean);
begin
end;

procedure TfrmGrid.OnGridColumnHeaderPopupMenu(AColumn: TcxGridDBBandedColumn;
  var AllowPopup: Boolean);
begin
end;

procedure TfrmGrid.OnGridViewNoneHitTest(var AllowPopup: Boolean);
begin
end;

procedure TfrmGrid.Place(AParent: TWinControl);
begin
  Assert(AParent <> nil);
  Parent := AParent;
  Align := alClient;
end;

procedure TfrmGrid.PostMyApplyBestFitEventForView
  (AView: TcxGridDBBandedTableView);
begin
  Assert(AView <> nil);

  // ��� ������� ����� ���������
  if FApplyBestFitPosted then
    Exit;

  if not Visible then
    Exit;

  if Handle <= 0 then
    Exit;

  FApplyBestFitPosted := True;
  try
    AView.BeginBestFitUpdate;
    FLeftPos := AView.Controller.LeftPos;
    PostMessage(Handle, WM_MY_APPLY_BEST_FIT, NativeUInt(AView), 0);
  except
    FApplyBestFitPosted := False;
    ; // ���-�� ��������� � Handle
  end;
end;

procedure TfrmGrid.ProcessGridPopupMenu(ASenderMenu: TComponent;
  AHitTest: TcxCustomGridHitTest; X, Y: Integer; var AllowPopup: Boolean);
var
  AcxGridBandHeaderHitTest: TcxGridBandHeaderHitTest;
  AcxGridRecordCellHitTest: TcxGridRecordCellHitTest;
  AcxGridColumnHeaderHitTest: TcxGridColumnHeaderHitTest;
  S: string;
  // S: string;
begin
  inherited;

  // ���������� ���������� � ������
  FHitTest := AHitTest;

  S := AHitTest.ClassName;

  if AHitTest is TcxGridViewNoneHitTest then
  begin
    OnGridViewNoneHitTest(AllowPopup);
  end;

  if (AHitTest is TcxGridRecordCellHitTest) then
  begin
    AcxGridRecordCellHitTest := (AHitTest as TcxGridRecordCellHitTest);
    if AcxGridRecordCellHitTest.Item is TcxGridDBBandedColumn then
    begin
      OnGridRecordCellPopupMenu
        (AcxGridRecordCellHitTest.Item as TcxGridDBBandedColumn, AllowPopup);
    end;
  end;

  if (AHitTest is TcxGridColumnHeaderHitTest) then
  begin
    AcxGridColumnHeaderHitTest := (AHitTest as TcxGridColumnHeaderHitTest);
    OnGridColumnHeaderPopupMenu
      (AcxGridColumnHeaderHitTest.Column as TcxGridDBBandedColumn, AllowPopup);
  end;

  if (AHitTest is TcxGridBandHeaderHitTest) then
  begin
    AcxGridBandHeaderHitTest := (AHitTest as TcxGridBandHeaderHitTest);
    OnGridBandHeaderPopupMenu(AcxGridBandHeaderHitTest.Band, AllowPopup);
  end;

  Application.Hint := '';
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

procedure TfrmGrid.RestoreSelection(ASaveSelection: TSaveSelection);
var
  ACol: TcxGridDBBandedColumn;
  AFieldName: string;
  AID: Integer;
begin
  ASaveSelection.View.Focused := True;

  // �������� ������, ������� ���� �������� �� ����� ����������
  for AID in ASaveSelection.IDArr do
  begin
    if ASaveSelection.View.DataController.Search.Locate
      (ASaveSelection.ColumnIndex, AID.ToString, False, False) then
      ASaveSelection.View.Controller.FocusedRow.Selected := True;
  end;
  for AFieldName in ASaveSelection.FieldNames do
  begin
    ACol := ASaveSelection.View.GetColumnByFieldName(AFieldName);
    if ACol <> nil then
      ACol.Selected := True;
  end;
end;

function TfrmGrid.SameCol(AColumn1: TcxGridColumn;
  AColumn2: TcxGridDBBandedColumn): Boolean;
begin
  Result := (AColumn1 is TcxGridDBBandedColumn) and
    ((AColumn1 as TcxGridDBBandedColumn).DataBinding.FieldName = AColumn2.
    DataBinding.FieldName);
end;

function TfrmGrid.SaveSelection(AView: TcxGridDBBandedTableView;
  AColumnIndex: Integer): TSaveSelection;
var
  AFieldNames: TList<String>;
  i: Integer;
begin
  Result.View := AView;
  Result.ColumnIndex := AColumnIndex;
  Result.IDArr := GetSelectedIntValues(AView, AColumnIndex);

  AFieldNames := TList<String>.Create;
  try
    for i := 0 to AView.ColumnCount - 1 do
    begin
      if AView.Columns[i].Selected then
        AFieldNames.Add(AView.Columns[i].DataBinding.FieldName);
    end;
    Result.FieldNames := AFieldNames.ToArray;
  finally
    FreeAndNil(AFieldNames);
  end;
end;

function TfrmGrid.GetFocusedValue(const AFieldName: string): Variant;
var
  AColumn: TcxGridDBBandedColumn;
begin
  Result := NULL;
  AColumn := MainView.GetColumnByFieldName(AFieldName);
  if (AColumn = nil) or (MainView.Controller.FocusedRow = nil) then
    Exit;

  Result := MainView.Controller.FocusedRow.Values[AColumn.Index];
end;

function TfrmGrid.GetSelectedValues(AColumn: TcxGridDBBandedColumn):
    TArray<Variant>;
begin
  Assert(AColumn <> nil);
  Result := GetSelectedValues(AColumn.GridView as TcxGridDBBandedTableView,
    AColumn.Index);
end;

function TfrmGrid.GetSelectedValues(AView: TcxGridDBBandedTableView;
    AColumnIndex: Integer): TArray<Variant>;
var
  i: Integer;
  L: TList<Variant>;
begin
  Assert(AView <> nil);

  L := TList<Variant>.Create;
  try
    for i := 0 to AView.Controller.SelectedRowCount - 1 do
    begin
      L.Add(AView.Controller.SelectedRows[i].Values[AColumnIndex]);
    end;
    Result := L.ToArray;
  finally
    FreeAndNil(L);
  end;
end;

function TfrmGrid.GetSelectedValues(const AFieldName: string): TArray<Variant>;
var
  AColumn: TcxGridDBBandedColumn;
begin
  Result := nil;
  Assert(not AFieldName.IsEmpty);
  AColumn := MainView.GetColumnByFieldName(AFieldName);
  if AColumn = nil then
    Exit;

  Result := GetSelectedValues(AColumn.GridView as TcxGridDBBandedTableView,
    AColumn.Index);
end;

procedure TfrmGrid.SelectFocusedRecord(const AFieldName: String);
begin
  if MainView.Controller.FocusedRow <> nil then
    MainView.Controller.FocusedRow.Selected := True;

  MainView.GetColumnByFieldName(AFieldName).Selected := True;
end;

procedure TfrmGrid.SetDSWrap(const Value: TDSWrap);
begin
  if FDSWrap = Value then
    Exit;

  FEventList.Clear;
  FDSWrap := Value;

  if FDSWrap = nil then
  begin
    MainView.DataController.DataSource := nil;
  end
  else
  begin
    MainView.DataController.DataSource := FDSWrap.DataSource;
    if FDSWrap.DataSet.Active then
    begin
      // ������ � �������������� �������
      DoAfterOpen(nil);
    end
    else
    begin
      FAfterOpenE := TNotifyEventWrap.Create(FDSWrap.AfterOpen, DoAfterOpen);
    end;
  end;
end;

procedure TfrmGrid.SetStatusBarEmptyPanelIndex(const Value: Integer);
begin
  if FStatusBarEmptyPanelIndex <> Value then
  begin
    if not(Value > 0) and (Value < StatusBar.Panels.Count) then
      raise Exception.Create('�������� ������ ������ ���������');

    FStatusBarEmptyPanelIndex := Value;
  end;
end;

procedure TfrmGrid.SetZeroBandWidth(AView: TcxGridDBBandedTableView);
var
  i: Integer;
begin
  // ��� ������ ������ (Width) ����� �������� 0.
  // ����� ��� ������ ����� ��������������� ����� ����� �������.
  // ���� ������ ����� �� ����, �� �� ��� ��������� �������
  for i := 0 to AView.Bands.Count - 1 do
    AView.Bands[i].Width := 0;
end;

procedure TfrmGrid.StatusBarResize(Sender: TObject);
begin
  if (FStatusBarEmptyPanelIndex >= 0) and
    (FStatusBarEmptyPanelIndex < StatusBar.Panels.Count) then
    DoStatusBarResize(FStatusBarEmptyPanelIndex);
end;

procedure TfrmGrid.TryClearSelection(X, Y: Integer);
var
  HT: TcxCustomGridHitTest;
begin
  if MainView = nil then
    Exit;

  HT := MainView.ViewInfo.GetHitTest(X, Y);
  if HT is TcxGridViewNoneHitTest then
    ClearSelectionForClick;
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
