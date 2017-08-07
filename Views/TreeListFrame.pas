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
  Vcl.Menus, GridSort, cxGridTableView;

type
  TfrmTreeList = class(TFrame)
    cxDBTreeList: TcxDBTreeList;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    ActionList: TActionList;
    PopupMenu: TPopupMenu;
    actCopy: TAction;
    N1: TMenuItem;
    procedure actCopyExecute(Sender: TObject);
    procedure cxDBTreeListCustomDrawDataCell(Sender: TcxCustomTreeList; ACanvas:
        TcxCanvas; AViewInfo: TcxTreeListEditCellViewInfo; var ADone: Boolean);
    procedure cxDBTreeListEdited(Sender: TcxCustomTreeList; AColumn:
        TcxTreeListColumn);
    procedure cxDBTreeListStylesGetBandHeaderStyle(Sender: TcxCustomTreeList;
      ABand: TcxTreeListBand; var AStyle: TcxStyle);
  private
    FGridSort: TGridSort;
    FPostOnEnterFields: TList<String>;
    { Private declarations }
  protected
    procedure InitializeColumns; virtual;
    procedure InitializeComboBoxColumn(AColumn: TcxDBTreeListColumn;
        ADropDownListStyle: TcxEditDropDownListStyle; AField: TField); overload;
    procedure InitializeLookupColumn(AColumn: TcxDBTreeListColumn; ADataSource:
        TDataSource; ADropDownListStyle: TcxEditDropDownListStyle; const
        AListFieldNames: string; const AKeyFieldNames: string = 'ID'); overload;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ApplySort(AColumn: TcxTreeListColumn);
    procedure ClearSort;
    procedure DoOnGetHeaderStyle(ABand: TcxTreeListBand; var AStyle: TcxStyle);
    function FocusedNodeValue(AcxDBTreeListColumn: TcxDBTreeListColumn): Variant;
    procedure UpdateView; virtual;
    property GridSort: TGridSort read FGridSort;
    property PostOnEnterFields: TList<String> read FPostOnEnterFields;
    { Public declarations }
  end;

implementation

uses dxCore, RepositoryDataModule, Vcl.Clipbrd;

{$R *.dfm}

constructor TfrmTreeList.Create(AOwner: TComponent);
begin
  inherited;
  // ������ ����� ��� �������������� ������� Enter - ����������
  FPostOnEnterFields := TList<String>.Create;

  FGridSort := TGridSort.Create;
  cxDBTreeList.Styles.OnGetBandHeaderStyle := cxDBTreeListStylesGetBandHeaderStyle;
end;

destructor TfrmTreeList.Destroy;
begin
  FreeAndNil(FPostOnEnterFields);
  FreeAndNil(FGridSort);
  inherited;
end;

procedure TfrmTreeList.actCopyExecute(Sender: TObject);
var
  I: Integer;
  AText: string;
begin
//  cxDBTreeList.OptionsView.Headers := False;
//  cxDBTreeList.CopySelectedToClipboard;
//  cxDBTreeList.OptionsView.Headers := True;

  AText := '';
  for I := 0 to cxDBTreeList.SelectionCount - 1 do
  begin
    if I > 0 then
      AText := AText + #13#10;
    AText := AText +   cxDBTreeList.FocusedColumn.DisplayTexts[ cxDBTreeList.Selections[i] ];
  end;
  ClipBoard.AsText := AText
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

  // ���� ��� ������ �� ���� ������ ��� ��������� ����������
  if ASortVariant = nil then
    Exit;

  if (AColumn.SortOrder = soAscending) then
    ASortOrder := soDescending
  else
    ASortOrder := soAscending;

  cxDBTreeList.BeginUpdate;
  try
    // �������� ����������
    ClearSort();

    // ��������� ����������
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

procedure TfrmTreeList.ClearSort;
var
  i: Integer;
begin
  for i := 0 to cxDBTreeList.ColumnCount - 1 do
    cxDBTreeList.Columns[i].SortOrder := soNone;
end;

procedure TfrmTreeList.cxDBTreeListCustomDrawDataCell(Sender:
    TcxCustomTreeList; ACanvas: TcxCanvas; AViewInfo:
    TcxTreeListEditCellViewInfo; var ADone: Boolean);
begin
  if AViewInfo.Selected then
  begin
    if (AViewInfo.Column = cxDBTreeList.FocusedColumn) then
    begin
      // ����� ����� �� ������
      ACanvas.Font.Color := clHighlightText;
      ACanvas.FillRect(AViewInfo.BoundsRect, clHighlight);
    end
    else
    begin
      // ����� ������ �� ������
      ACanvas.Font.Color := clBlack;
      ACanvas.FillRect(AViewInfo.BoundsRect, clWhite);
    end;
  end;
end;

procedure TfrmTreeList.cxDBTreeListEdited(Sender: TcxCustomTreeList; AColumn:
    TcxTreeListColumn);
begin
  // ���� ��������� �������������� ������
  if (Sender.FocusedNode <> nil) and (Sender.FocusedNode.IsGroupNode) then
    Sender.Post
  else
  begin
    if FPostOnEnterFields.IndexOf( (AColumn as TcxDBTreeListColumn).DataBinding.FieldName ) >= 0 then
      Sender.Post
  end;

  UpdateView;
end;

procedure TfrmTreeList.cxDBTreeListStylesGetBandHeaderStyle(
  Sender: TcxCustomTreeList; ABand: TcxTreeListBand; var AStyle: TcxStyle);
begin
  DoOnGetHeaderStyle(ABand, AStyle);
end;

procedure TfrmTreeList.DoOnGetHeaderStyle(ABand: TcxTreeListBand; var AStyle:
    TcxStyle);
begin
  if ABand = nil then
    Exit;

  if ABand.VisibleColumnCount = 0 then
    Exit;

  if ABand.VisibleColumns[0].SortIndex = 0 then
    AStyle := DMRepository.cxHeaderStyle;
end;

function TfrmTreeList.FocusedNodeValue(AcxDBTreeListColumn:
    TcxDBTreeListColumn): Variant;
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

  // ��������� ���������� ������ ���������� �� �������
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

procedure TfrmTreeList.UpdateView;
begin
end;

end.
