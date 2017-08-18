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
  Vcl.ComCtrls;

type
  TfrmTreeList = class(TFrame)
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
    procedure cxDBTreeListMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure cxDBTreeListStylesGetBandHeaderStyle(Sender: TcxCustomTreeList;
      ABand: TcxTreeListBand; var AStyle: TcxStyle);
    procedure StatusBarResize(Sender: TObject);
  private
    FBlockEvents: Integer;
    FGridSort: TGridSort;
    FPostOnEnterFields: TList<String>;
    FStatusBarEmptyPanelIndex: Integer;
    procedure SetStatusBarEmptyPanelIndex(const Value: Integer);
    { Private declarations }
  protected
    FColumnsBarButtons: TTLColumnsBarButtons;
    FEventList: TObjectList;
    FUpdateCount: Cardinal;
    procedure CreateColumnsBarButtons; virtual;
    procedure DoStatusBarResize(AEmptyPanelIndex: Integer);
    procedure InitializeColumns; virtual;
    procedure InitializeComboBoxColumn(AColumn: TcxDBTreeListColumn;
      ADropDownListStyle: TcxEditDropDownListStyle; AField: TField); overload;
    procedure InitializeLookupColumn(AColumn: TcxDBTreeListColumn;
      ADataSource: TDataSource; ADropDownListStyle: TcxEditDropDownListStyle;
      const AListFieldNames: string;
      const AKeyFieldNames: string = 'ID'); overload;
    function IsSyncToDataSet: Boolean; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AfterConstruction; override;
    procedure ApplySort(AColumn: TcxTreeListColumn);
    procedure BeginBlockEvents;
    procedure BeginUpdate; virtual;
    procedure ClearSort;
    procedure DoOnGetHeaderStyle(ABand: TcxTreeListBand; var AStyle: TcxStyle);
    procedure EndBlockEvents;
    procedure EndUpdate; virtual;
    function FocusedNodeValue(AcxDBTreeListColumn: TcxDBTreeListColumn)
      : Variant;
    procedure UpdateView; virtual;
    property GridSort: TGridSort read FGridSort;
    property PostOnEnterFields: TList<String> read FPostOnEnterFields;
    property StatusBarEmptyPanelIndex: Integer read FStatusBarEmptyPanelIndex write
        SetStatusBarEmptyPanelIndex;
    { Public declarations }
  end;

implementation

uses dxCore, RepositoryDataModule, Vcl.Clipbrd, System.Types, System.Math;

{$R *.dfm}

constructor TfrmTreeList.Create(AOwner: TComponent);
begin
  inherited;
  // Список полей при редактировании которых Enter - сохранение
  FPostOnEnterFields := TList<String>.Create;
  FEventList := TObjectList.Create;

  FGridSort := TGridSort.Create;
  cxDBTreeList.Styles.OnGetBandHeaderStyle :=
    cxDBTreeListStylesGetBandHeaderStyle;
end;

destructor TfrmTreeList.Destroy;
begin
  FreeAndNil(FPostOnEnterFields);
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

procedure TfrmTreeList.ApplySort(AColumn: TcxTreeListColumn);
var
  ASortOrder: TdxSortOrder;
  ASortVariant: TSortVariant;
  Col: TcxDBTreeListColumn;
  S: string;
begin
  inherited;

  ASortVariant := FGridSort.GetSortVariant(AColumn as TcxDBTreeListColumn);

  // Если при щелчке по этой колоке нет вариантов сортировки
  if ASortVariant = nil then
    Exit;

  if (AColumn.SortOrder = soAscending) then
    ASortOrder := soDescending
  else
    ASortOrder := soAscending;

  cxDBTreeList.BeginUpdate;
  try
    // Очистили сортировку
    ClearSort();

    // Применяем сортировку
    for S in ASortVariant.SortedFieldNames do
    begin
      Col := cxDBTreeList.GetColumnByFieldName(S);
      Assert(Col <> nil);
      Col.SortOrder := ASortOrder;
    end;

  finally
    cxDBTreeList.EndUpdate;
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
  if (FBlockEvents > 0) or
    (not(cxDBTreeList.DataController.DataSet.State in [dsEdit, dsInsert])) then
    Exit;


  // Если в TreeList в фокуе одна запись а в датасете редактируется другая
  if not IsSyncToDataSet then
    Exit;

  // Если закончили редактирование группы
  if (Sender.FocusedNode <> nil) and (Sender.FocusedNode.IsGroupNode) then
    Sender.Post
  else
  begin
    if FPostOnEnterFields.IndexOf((AColumn as TcxDBTreeListColumn)
      .DataBinding.FieldName) >= 0 then
      Sender.Post
  end;

  UpdateView;
  { }
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

procedure TfrmTreeList.InitializeColumns;
begin

end;

procedure TfrmTreeList.InitializeComboBoxColumn(AColumn: TcxDBTreeListColumn;
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

procedure TfrmTreeList.InitializeLookupColumn(AColumn: TcxDBTreeListColumn;
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

function TfrmTreeList.IsSyncToDataSet: Boolean;
begin
  Result := cxDBTreeList.FocusedNode <> nil;
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
