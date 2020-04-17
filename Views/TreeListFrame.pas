unit TreeListFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxCustomData, cxStyles, cxTL,
  cxTLdxBarBuiltInMenu, dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
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
  dxSkinXmas2008Blue, cxInplaceContainer, cxTLData, cxDBTL, dxSkinsdxBarPainter,
  cxClasses, dxBar, System.Actions, Vcl.ActnList, cxGridDBBandedTableView,
  Data.DB, cxDropDownEdit, cxDBLookupComboBox, System.Generics.Collections,
  Vcl.Menus, GridSort, cxGridTableView, ColumnsBarButtonsHelper, System.Contnrs,
  Vcl.ComCtrls, dxCore,
  cxDataControllerConditionalFormattingRulesManagerDialog, SelectionInt;

const
  WM_SELECTION_CHANGED = WM_USER + 600;

type
  TfrmTreeList = class(TFrame, ISelection)
    cxDBTreeList: TcxDBTreeList;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    ActionList: TActionList;
    PopupMenu: TPopupMenu;
    actCopy: TAction;
    N1: TMenuItem;
    dxbsColumns: TdxBarSubItem;
    StatusBar: TStatusBar;
    procedure actCopyExecute(Sender: TObject);
    procedure cxDBTreeListCustomDrawDataCell(Sender: TcxCustomTreeList;
      ACanvas: TcxCanvas; AViewInfo: TcxTreeListEditCellViewInfo;
      var ADone: Boolean);
    procedure cxDBTreeListEdited(Sender: TcxCustomTreeList;
      AColumn: TcxTreeListColumn);
    procedure cxDBTreeListEditing(Sender: TcxCustomTreeList;
      AColumn: TcxTreeListColumn; var Allow: Boolean);
    procedure cxDBTreeListEnter(Sender: TObject);
    procedure cxDBTreeListExit(Sender: TObject);
    procedure cxDBTreeListFocusedColumnChanged(Sender: TcxCustomTreeList;
      APrevFocusedColumn, AFocusedColumn: TcxTreeListColumn);
    procedure cxDBTreeListFocusedNodeChanged(Sender: TcxCustomTreeList;
      APrevFocusedNode, AFocusedNode: TcxTreeListNode);
    procedure cxDBTreeListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

    procedure cxDBTreeListMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure cxDBTreeListStylesGetBandHeaderStyle(Sender: TcxCustomTreeList;
      ABand: TcxTreeListBand; var AStyle: TcxStyle);
    procedure StatusBarResize(Sender: TObject);
  strict private
    function GetHaveFocus: Boolean;
  private
    FBlockEvents: Integer;
    FGridSort: TGridSort;
    FHaveFocus: Boolean;
    // TODO: FPostOnEnterFields
    // FPostOnEnterFields: TList<String>;
    FSortVariant: TSortVariant;
    FStatusBarEmptyPanelIndex: Integer;
    FUpdateCount: Cardinal;
    procedure SetStatusBarEmptyPanelIndex(const Value: Integer);
    { Private declarations }
  protected
    FEnableClearSelection: Boolean;
    FColumnsBarButtons: TTLColumnsBarButtons;
    FEventList: TObjectList;
    FPostSelectionChanged: Boolean;
    procedure CreateColumnsBarButtons; virtual;
    procedure DoStatusBarResize(AEmptyPanelIndex: Integer);
    procedure InitializeColumns; virtual;
    procedure InitializeLookupColumn(AColumn: TcxDBTreeListColumn;
      ADataSource: TDataSource; ADropDownListStyle: TcxEditDropDownListStyle;
      const AListFieldNames: string;
      const AKeyFieldNames: string = 'ID'); overload;
    procedure InternalApplySort(ASortedColumns: TArray < TPair <
      TcxDBTreeListColumn, TdxSortOrder >> );
    procedure InternalRefreshData; virtual;
    function IsSyncToDataSet: Boolean; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AfterConstruction; override;
    procedure ApplySort(AColumn: TcxTreeListColumn;
      AdxSortOrder: TdxSortOrder = soNone);
    procedure BeginBlockEvents;
    procedure BeginUpdate; virtual;
    procedure ClearSelection;
    procedure ClearSort;
    procedure DoOnGetHeaderStyle(ABand: TcxTreeListBand; var AStyle: TcxStyle);
    procedure EndBlockEvents;
    procedure EndUpdate; virtual;
    function FocusedNodeValue(AcxDBTreeListColumn: TcxDBTreeListColumn)
      : Variant;
    procedure FocusFirstNode;
    function GetSelectedValues(const AFieldName: String): TArray<Variant>;
    procedure MyApplyBestFit; overload;
    procedure MyApplyBestFit(ABand: TcxTreeListBand); overload;
    procedure RefreshData;
    procedure UpdateView; virtual;
    property GridSort: TGridSort read FGridSort;
    // TODO: PostOnEnterFields
    // property PostOnEnterFields: TList<String> read FPostOnEnterFields;
    property StatusBarEmptyPanelIndex: Integer read FStatusBarEmptyPanelIndex
      write SetStatusBarEmptyPanelIndex;
    property UpdateCount: Cardinal read FUpdateCount;
    { Public declarations }
  end;

implementation

uses RepositoryDataModule, Vcl.Clipbrd, System.Types, System.Math,
  StrHelper, TextRectHelper, DBLookupComboBoxHelper, FormsHelper, ProjectConst,
  cxTreeListHelper;

{$R *.dfm}

constructor TfrmTreeList.Create(AOwner: TComponent);
begin
  inherited;
  // Список полей при редактировании которых Enter - сохранение
  // FPostOnEnterFields := TList<String>.Create;
  FEventList := TObjectList.Create;

  FGridSort := TGridSort.Create;
  cxDBTreeList.Styles.OnGetBandHeaderStyle :=
    cxDBTreeListStylesGetBandHeaderStyle;

  FEnableClearSelection := True;
  TFormsHelper.SetFont(Self, BaseFontSize);
end;

destructor TfrmTreeList.Destroy;
begin
  // FreeAndNil(FPostOnEnterFields);
  FreeAndNil(FGridSort);
  FreeAndNil(FEventList);
  inherited;
end;

procedure TfrmTreeList.actCopyExecute(Sender: TObject);
var
  I: Integer;
  AText: string;
begin
  // cxDBTreeList.OptionsView.Headers := False;
  // cxDBTreeList.CopySelectedToClipboard;
  // cxDBTreeList.OptionsView.Headers := True;

  AText := '';
  for I := 0 to cxDBTreeList.SelectionCount - 1 do
  begin
    if I > 0 then
      AText := AText + #13#10;
    AText := AText + cxDBTreeList.FocusedColumn.DisplayTexts
      [cxDBTreeList.Selections[I]];
  end;
  ClipBoard.AsText := AText
end;

procedure TfrmTreeList.AfterConstruction;
begin
  inherited;
  CreateColumnsBarButtons;
end;

procedure TfrmTreeList.ApplySort(AColumn: TcxTreeListColumn;
  AdxSortOrder: TdxSortOrder = soNone);
var
  AColSortOrder: TdxSortOrder;
  ASortVariant: TSortVariant;
  Col: TcxDBTreeListColumn;
  L: TList<TPair<TcxDBTreeListColumn, TdxSortOrder>>;
  S: string;
begin
  inherited;

  ASortVariant := FGridSort.GetSortVariant(AColumn as TcxDBTreeListColumn);

  // Если при щелчке по этой колоке нет вариантов сортировки
  if ASortVariant = nil then
    Exit;

  L := TList < TPair < TcxDBTreeListColumn, TdxSortOrder >>.Create;
  try
    // Готовим данные для иной сортировки
    for S in ASortVariant.SortedFieldNames do
    begin
      Col := cxDBTreeList.GetColumnByFieldName(S);
      Assert(Col <> nil);

      // Если нужно произвести только реверс сортировки
      if (Col = AColumn) and (FSortVariant = ASortVariant) then
      begin
        if AdxSortOrder = soNone then
        begin
          if (AColumn.SortOrder = soAscending) then
            AColSortOrder := soDescending
          else
            AColSortOrder := soAscending;
        end
        else
          AColSortOrder := AdxSortOrder;
      end
      else
      begin
        // Если применили другой вариант сортировки
        if AdxSortOrder <> soNone then
        begin
          AColSortOrder := AdxSortOrder;
          AdxSortOrder := soNone;
        end
        else
          AColSortOrder := soAscending;
      end;
      L.Add(TPair<TcxDBTreeListColumn, TdxSortOrder>.Create(Col,
        AColSortOrder));
    end;
    FSortVariant := ASortVariant;

    InternalApplySort(L.ToArray);

  finally
    FreeAndNil(L)
  end;
end;

procedure TfrmTreeList.BeginBlockEvents;
begin
  Assert(FBlockEvents >= 0);
  Inc(FBlockEvents);
end;

procedure TfrmTreeList.BeginUpdate;
begin
  Inc(FUpdateCount);
  if FUpdateCount = 1 then
    cxDBTreeList.BeginUpdate();
end;

procedure TfrmTreeList.ClearSelection;
begin
  if not FEnableClearSelection then
    Exit;

  cxDBTreeList.ClearSelection();
  cxDBTreeList.CancelEdit;
  UpdateView;
end;

procedure TfrmTreeList.ClearSort;
var
  I: Integer;
begin
  for I := 0 to cxDBTreeList.ColumnCount - 1 do
    cxDBTreeList.Columns[I].SortOrder := soNone;
end;

procedure TfrmTreeList.CreateColumnsBarButtons;
begin
  if (cxDBTreeList.ColumnCount > 0) and (FColumnsBarButtons = nil) then
    FColumnsBarButtons := TTLColumnsBarButtons.Create(Self, dxbsColumns,
      cxDBTreeList);
end;

procedure TfrmTreeList.cxDBTreeListCustomDrawDataCell(Sender: TcxCustomTreeList;
  ACanvas: TcxCanvas; AViewInfo: TcxTreeListEditCellViewInfo;
  var ADone: Boolean);
begin
  if FBlockEvents > 0 then
    Exit;

  if AViewInfo.Selected then
  begin
    if (AViewInfo.Column = cxDBTreeList.FocusedColumn) then
    begin
      // Пишем белым по синему
      ACanvas.Font.Color := clHighlightText;
      ACanvas.FillRect(AViewInfo.BoundsRect, clHighlight);
    end
    else
    begin
      // Пишем чёрным по белому
      ACanvas.Font.Color := clBlack;
      ACanvas.FillRect(AViewInfo.BoundsRect, clWhite);
    end;
  end;
  { }
end;

procedure TfrmTreeList.cxDBTreeListEdited(Sender: TcxCustomTreeList;
  AColumn: TcxTreeListColumn);
begin
  UpdateView;
end;

procedure TfrmTreeList.cxDBTreeListEditing(Sender: TcxCustomTreeList;
  AColumn: TcxTreeListColumn; var Allow: Boolean);
begin
  UpdateView;
end;

procedure TfrmTreeList.cxDBTreeListEnter(Sender: TObject);
begin
  FHaveFocus := True;
end;

procedure TfrmTreeList.cxDBTreeListExit(Sender: TObject);
begin
  FHaveFocus := False;
end;

procedure TfrmTreeList.cxDBTreeListFocusedColumnChanged
  (Sender: TcxCustomTreeList; APrevFocusedColumn, AFocusedColumn
  : TcxTreeListColumn);
begin
  UpdateView;
end;

procedure TfrmTreeList.cxDBTreeListFocusedNodeChanged(Sender: TcxCustomTreeList;
  APrevFocusedNode, AFocusedNode: TcxTreeListNode);
begin
  UpdateView;
end;

procedure TfrmTreeList.cxDBTreeListMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  HT: TcxTreeListHitTest;
begin
  HT := cxDBTreeList.HitTest;
  if HT.HitAtBackground then
    ClearSelection;
end;

procedure TfrmTreeList.cxDBTreeListMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  ANode: TcxTreeListNode;
begin
  if FBlockEvents > 0 then
    Exit;

  if not(ssLeft in Shift) then
    Exit;
  cxDBTreeList.HitTest.ReCalculate(Point(X, Y));

  if not(cxDBTreeList.HitTest.HitAtNode and (cxDBTreeList.HitTest.HitColumn <>
    nil)) then
    Exit;

  ANode := cxDBTreeList.HitTest.HitNode;

  ANode.Selected := True;

  if not FPostSelectionChanged then
  begin
    PostMessage(Handle, WM_SELECTION_CHANGED, 0, 0);
  end;
  { }
end;

procedure TfrmTreeList.cxDBTreeListStylesGetBandHeaderStyle
  (Sender: TcxCustomTreeList; ABand: TcxTreeListBand; var AStyle: TcxStyle);
begin
  DoOnGetHeaderStyle(ABand, AStyle);
end;

procedure TfrmTreeList.DoOnGetHeaderStyle(ABand: TcxTreeListBand;
  var AStyle: TcxStyle);
begin
  if ABand = nil then
    Exit;

  if ABand.VisibleColumnCount = 0 then
    Exit;

  if ABand.VisibleColumns[0].SortIndex = 0 then
    AStyle := DMRepository.cxHeaderStyle;
end;

procedure TfrmTreeList.DoStatusBarResize(AEmptyPanelIndex: Integer);
var
  I: Integer;
  X: Integer;
begin
  Assert(AEmptyPanelIndex >= 0);
  Assert(AEmptyPanelIndex < StatusBar.Panels.Count);

  X := StatusBar.ClientWidth;
  for I := 0 to StatusBar.Panels.Count - 1 do
  begin
    if I <> AEmptyPanelIndex then
    begin
      Dec(X, StatusBar.Panels[I].Width);
    end;
  end;
  X := IfThen(X >= 0, X, 0);
  StatusBar.Panels[AEmptyPanelIndex].Width := X;
end;

procedure TfrmTreeList.EndBlockEvents;
begin
  Assert(FBlockEvents > 0);
  Dec(FBlockEvents);
end;

procedure TfrmTreeList.EndUpdate;
begin
  Assert(FUpdateCount > 0);
  Dec(FUpdateCount);
  if FUpdateCount = 0 then
    cxDBTreeList.EndUpdate;

end;

function TfrmTreeList.FocusedNodeValue(AcxDBTreeListColumn
  : TcxDBTreeListColumn): Variant;
var
  ANode: TcxTreeListNode;
begin
  Assert(AcxDBTreeListColumn <> nil);
  ANode := cxDBTreeList.FocusedNode;
  Assert(ANode <> nil);
  Result := ANode.Values[AcxDBTreeListColumn.ItemIndex];
end;

procedure TfrmTreeList.FocusFirstNode;
var
  ANode: TcxTreeListNode;
begin
  cxDBTreeList.ClearSelection();
  ANode := cxDBTreeList.Root.getFirstChild;
  if ANode <> nil then
  begin
    ANode.Focused := True;
  end;
end;

function TfrmTreeList.GetHaveFocus: Boolean;
begin
  Result := FHaveFocus;
end;

function TfrmTreeList.GetSelectedValues(const AFieldName: String)
  : TArray<Variant>;
var
  AColumn: TcxDBTreeListColumn;
  AList: TList<Variant>;
  I: Integer;
begin
  Assert(not AFieldName.IsEmpty);
  AColumn := cxDBTreeList.GetColumnByFieldName(AFieldName);
  Assert(AColumn <> nil);

  AList := TList<Variant>.Create;
  try
    for I := 0 to cxDBTreeList.SelectionCount - 1 do
    begin
      AList.Add(cxDBTreeList.Selections[I].Values[AColumn.ItemIndex]);
    end;

    Result := AList.ToArray;
  finally
    FreeAndNil(AList);
  end;
end;

procedure TfrmTreeList.InitializeColumns;
begin

end;

procedure TfrmTreeList.InitializeLookupColumn(AColumn: TcxDBTreeListColumn;
  ADataSource: TDataSource; ADropDownListStyle: TcxEditDropDownListStyle;
  const AListFieldNames: string; const AKeyFieldNames: string = 'ID');
begin
  Assert(AColumn <> nil);
  AColumn.PropertiesClass := TcxLookupComboBoxProperties;

  TDBLCB.InitProp(AColumn.Properties as TcxLookupComboBoxProperties,
    ADataSource, AKeyFieldNames, AListFieldNames, ADropDownListStyle);
end;

procedure TfrmTreeList.InternalApplySort(ASortedColumns: TArray < TPair <
  TcxDBTreeListColumn, TdxSortOrder >> );
var
  APair: TPair<TcxDBTreeListColumn, TdxSortOrder>;
begin
  Assert(Length(ASortedColumns) > 0);

  cxDBTreeList.BeginUpdate;
  try
    // Очистили сортировку
    ClearSort();

    // Применяем сортировку
    for APair in ASortedColumns do
    begin
      APair.Key.SortOrder := APair.Value;
    end;

  finally
    cxDBTreeList.EndUpdate;
  end;
end;

procedure TfrmTreeList.InternalRefreshData;
begin
  // TODO -cMM: TfrmTreeList.InternalRefreshData default body inserted
end;

function TfrmTreeList.IsSyncToDataSet: Boolean;
begin
  Result := cxDBTreeList.FocusedNode <> nil;
end;

procedure TfrmTreeList.MyApplyBestFit;
begin
  TcxTreeListHelper.MyApplyBestFit(cxDBTreeList);
end;

procedure TfrmTreeList.MyApplyBestFit(ABand: TcxTreeListBand);
begin
  TcxTreeListHelper.MyApplyBestFit(ABand);
end;

procedure TfrmTreeList.RefreshData;
begin
  BeginUpdate;
  try
    InternalRefreshData;
  finally
    EndUpdate;
  end;
end;

procedure TfrmTreeList.SetStatusBarEmptyPanelIndex(const Value: Integer);
begin
  if FStatusBarEmptyPanelIndex <> Value then
  begin
    if not(Value > 0) and (Value < StatusBar.Panels.Count) then
      raise Exception.Create('Неверный индекс панели состояния');

    FStatusBarEmptyPanelIndex := Value;
  end;
end;

procedure TfrmTreeList.StatusBarResize(Sender: TObject);
begin
  if (FStatusBarEmptyPanelIndex >= 0) and
    (FStatusBarEmptyPanelIndex < StatusBar.Panels.Count) then
    DoStatusBarResize(FStatusBarEmptyPanelIndex);
end;

procedure TfrmTreeList.UpdateView;
begin
end;

end.
