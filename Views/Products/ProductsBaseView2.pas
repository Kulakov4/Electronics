unit ProductsBaseView2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, TreeListFrame, cxGraphics, cxControls,
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
  dxSkinXmas2008Blue, dxSkinsdxBarPainter, System.Actions, Vcl.ActnList,
  cxClasses, dxBar, cxInplaceContainer, cxTLData, cxDBTL,
  cxMaskEdit, cxDBLookupComboBox, cxDropDownEdit, cxBarEditItem, Data.DB,
  cxCalc, DocFieldInfo, cxButtonEdit, Vcl.Menus, cxEdit, Vcl.ComCtrls,
  System.Contnrs, DescriptionPopupForm, ProductsBaseQuery;

type
  TViewProductsBase2 = class(TfrmTreeList)
    actCommit: TAction;
    actRollback: TAction;
    actExportToExcelDocument: TAction;
    actOpenInParametricTable: TAction;
    actAddCategory: TAction;
    clID: TcxDBTreeListColumn;
    clIsGroup: TcxDBTreeListColumn;
    clIDComponentGroup: TcxDBTreeListColumn;
    clValue: TcxDBTreeListColumn;
    clIDProducer: TcxDBTreeListColumn;
    clDescription: TcxDBTreeListColumn;
    clDatasheet: TcxDBTreeListColumn;
    clDiagram: TcxDBTreeListColumn;
    clDrawing: TcxDBTreeListColumn;
    clImage: TcxDBTreeListColumn;
    clPackagePins: TcxDBTreeListColumn;
    clYYYY: TcxDBTreeListColumn;
    clMM: TcxDBTreeListColumn;
    clWW: TcxDBTreeListColumn;
    clAmount: TcxDBTreeListColumn;
    clPackaging: TcxDBTreeListColumn;
    clPriceR2: TcxDBTreeListColumn;
    clPriceD2: TcxDBTreeListColumn;
    clPriceR1: TcxDBTreeListColumn;
    clPriceD1: TcxDBTreeListColumn;
    clPriceR: TcxDBTreeListColumn;
    clPriceD: TcxDBTreeListColumn;
    clOriginCountryCode: TcxDBTreeListColumn;
    clOriginCountry: TcxDBTreeListColumn;
    clBatchNumber: TcxDBTreeListColumn;
    clCustomsDeclarationNumber: TcxDBTreeListColumn;
    clStorage: TcxDBTreeListColumn;
    clStoragePlace: TcxDBTreeListColumn;
    clSeller: TcxDBTreeListColumn;
    clDocumentNumber: TcxDBTreeListColumn;
    clBarcode: TcxDBTreeListColumn;
    actAddComponent: TAction;
    actDelete: TAction;
    dxBarManagerBar2: TdxBar;
    dxbcRate1: TdxBarCombo;
    dxbcRate2: TdxBarCombo;
    cxbeiRate: TcxBarEditItem;
    actOpenDatasheet: TAction;
    actLoadDatasheet: TAction;
    actOpenImage: TAction;
    actLoadImage: TAction;
    actOpenDiagram: TAction;
    actLoadDiagram: TAction;
    actOpenDrawing: TAction;
    actLoadDrawing: TAction;
    cxStyleRepository1: TcxStyleRepository;
    cxStyle1: TcxStyle;
    cxNormalStyle: TcxStyle;
    clIDCurrency: TcxDBTreeListColumn;
    clChecked: TcxDBTreeListColumn;
    procedure actAddCategoryExecute(Sender: TObject);
    procedure actAddComponentExecute(Sender: TObject);
    procedure actCommitExecute(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure actExportToExcelDocumentExecute(Sender: TObject);
    procedure actLoadDatasheetExecute(Sender: TObject);
    procedure actLoadDiagramExecute(Sender: TObject);
    procedure actLoadDrawingExecute(Sender: TObject);
    procedure actLoadImageExecute(Sender: TObject);
    procedure actOpenDatasheetExecute(Sender: TObject);
    procedure actOpenDiagramExecute(Sender: TObject);
    procedure actOpenDrawingExecute(Sender: TObject);
    procedure actOpenImageExecute(Sender: TObject);
    procedure actOpenInParametricTableExecute(Sender: TObject);
    procedure actRollbackExecute(Sender: TObject);
    procedure clDatasheetGetDisplayText(Sender: TcxTreeListColumn;
      ANode: TcxTreeListNode; var Value: string);
    procedure cxbeiRateChange(Sender: TObject);
    procedure cxDBTreeListBandHeaderClick(Sender: TcxCustomTreeList;
      ABand: TcxTreeListBand);
    procedure cxDBTreeListCustomDrawDataCell(Sender: TcxCustomTreeList;
      ACanvas: TcxCanvas; AViewInfo: TcxTreeListEditCellViewInfo;
      var ADone: Boolean);
    procedure cxDBTreeListIsGroupNode(Sender: TcxCustomTreeList;
      ANode: TcxTreeListNode; var IsGroup: Boolean);
    procedure cxDBTreeListFocusedNodeChanged(Sender: TcxCustomTreeList;
      APrevFocusedNode, AFocusedNode: TcxTreeListNode);
    procedure cxDBTreeListInitEditValue(Sender, AItem: TObject;
      AEdit: TcxCustomEdit; var AValue: Variant);
    procedure cxDBTreeListSelectionChanged(Sender: TObject);
    procedure dxbcRate2Change(Sender: TObject);
    procedure dxbcRate1Change(Sender: TObject);
    procedure dxbcRate1DrawItem(Sender: TdxBarCustomCombo; AIndex: Integer;
      ARect: TRect; AState: TOwnerDrawState);
    procedure clDescriptionPropertiesInitPopup(Sender: TObject);
  private
    FCountEvents: TObjectList;
    FfrmDescriptionPopup: TfrmDescriptionPopup;
    FqProductsBase: TQueryProductsBase;
    procedure DoAfterDelete(Sender: TObject);
    procedure DoAfterLoad(Sender: TObject);
    procedure DoAfterOpen(Sender: TObject);
    procedure DoAfterPost(Sender: TObject);
    procedure DoOnDescriptionPopupHide(Sender: TObject);
    procedure SetqProductsBase(const Value: TQueryProductsBase);
    procedure UpdateSelectedCount;
    { Private declarations }
  protected
    FSelectedCountPanelIndex: Integer;
    procedure BindRate(ARateField: TField; AdxBarCombo: TdxBarCombo);
    procedure CreateCountEvents;
    procedure DoAfterScroll(Sender: TObject);
    procedure InitializeColumns; override;
    procedure InternalRefreshData; override;
    function IsSyncToDataSet: Boolean; override;
    procedure OpenDoc(ADocFieldInfo: TDocFieldInfo);
    function Per�entToRate(APer�ent: Double): Double;
    function RateToPer�ent(ARate: Double): Double;
    // TODO: SortList
    // function SortList(AList: TList<TProductRecord>; ASortMode: Integer)
    // : TList<TProductRecord>;
    procedure UpdateProductCount; virtual;
    procedure UpdateRate(const ARate: Double; RateField: TField);
    procedure UploadDoc(ADocFieldInfo: TDocFieldInfo);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BeginUpdate; override;
    function CheckAndSaveChanges: Integer;
    procedure EndUpdate; override;
    function IsFocusedNodeEquals(AColumn: TcxDBTreeListColumn; AValue: Variant):
        Boolean;
    procedure UpdateView; override;
    property qProductsBase: TQueryProductsBase read FqProductsBase
      write SetqProductsBase;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses DialogUnit, RepositoryDataModule, NotifyEvents, System.IOUtils,
  SettingsController, Winapi.Shellapi, System.Generics.Collections,
  System.StrUtils, GridSort, cxTLExportLink, OpenDocumentUnit, ProjectConst;

constructor TViewProductsBase2.Create(AOwner: TComponent);
var
  AcxPopupEditproperties: TcxPopupEditproperties;
begin
  inherited;
  // ������ ����� ��� �������������� ������� Enter - ����������
  PostOnEnterFields.Add(clPriceR.DataBinding.FieldName);
  PostOnEnterFields.Add(clPriceD.DataBinding.FieldName);

  // ��� ���������� ���-�� ���������� �������
  FSelectedCountPanelIndex := 1;

  // ����� ������ �����������
  StatusBarEmptyPanelIndex := 2;

  GridSort.Add(TSortVariant.Create(clValue, [clValue]));
  GridSort.Add(TSortVariant.Create(clIDProducer, [clIDProducer, clValue]));

  FCountEvents := TObjectList.Create;

  // ����������� ����� � ������� ���������
  FfrmDescriptionPopup := TfrmDescriptionPopup.Create(Self);
  AcxPopupEditproperties := clDescription.Properties as TcxPopupEditproperties;
  AcxPopupEditproperties.PopupControl := FfrmDescriptionPopup;
  // ������� ����� ���������� �������
  AcxPopupEditproperties.OnInitPopup := clDescriptionPropertiesInitPopup;
  TNotifyEventWrap.Create(FfrmDescriptionPopup.OnHide,
    DoOnDescriptionPopupHide);

end;

destructor TViewProductsBase2.Destroy;
begin
  inherited;
  FreeAndNil(FCountEvents);
end;

procedure TViewProductsBase2.actAddCategoryExecute(Sender: TObject);
begin
  inherited;
  qProductsBase.AddCategory;

  cxDBTreeList.ApplyBestFit;
  cxDBTreeList.SetFocus;

  // ��������� ������� � ����� ��������������
  clValue.Editing := True;
end;

procedure TViewProductsBase2.actAddComponentExecute(Sender: TObject);
var
  AID: Integer;
begin
  inherited;

  // BeginBlockEvents;
  try

    cxDBTreeList.Post;

    if cxDBTreeList.FocusedNode.IsGroupNode then
      AID := FocusedNodeValue(clID)
    else
    begin
      Assert(cxDBTreeList.FocusedNode.Parent <> nil);
      AID := cxDBTreeList.FocusedNode.Parent.Values[clID.ItemIndex];
    end;

    qProductsBase.AddProduct(AID);

    cxDBTreeList.ApplyBestFit;
    cxDBTreeList.SetFocus;

    // ��������� ������� � ����� ��������������
    clValue.Editing := True;
  finally
    // EndBlockEvents;
  end;
end;

procedure TViewProductsBase2.actCommitExecute(Sender: TObject);
begin
  inherited;
  // �� ������ ��������� ����������
  FqProductsBase.ApplyUpdates;
  UpdateView;
end;

procedure TViewProductsBase2.actDeleteExecute(Sender: TObject);
var
  AID: Integer;
  AIDS: TList<Integer>;
  i: Integer;
  S: string;
begin
  inherited;
  if cxDBTreeList.SelectionCount = 0 then
    Exit;

  if cxDBTreeList.Selections[0].IsGroupNode then
    S := '������� ������ ����������� � �������� ������?'
  else
    S := Format('������� %s?', [IfThen(cxDBTreeList.SelectionCount = 1,
      '���������', '����������')]);

  if not(TDialog.Create.DeleteRecordsDialog(S)) then
    Exit;

  AIDS := TList<Integer>.Create;
  try
    // ��������� ������ ��������������� �����, ������� ����� �������
    for i := 0 to cxDBTreeList.SelectionCount - 1 do
    begin
      AIDS.Add(cxDBTreeList.Selections[i].Values[clID.ItemIndex]);
    end;

    cxDBTreeList.BeginUpdate;
    try
      for AID in AIDS do
        qProductsBase.DeleteNode(AID);
      // ��� ������-�� �� ��������
      // cxDBTreeList.DataController.DeleteFocused;
    finally
      cxDBTreeList.EndUpdate;
    end;

  finally
    FreeAndNil(AIDS);
  end;
  UpdateView;
end;

procedure TViewProductsBase2.actExportToExcelDocumentExecute(Sender: TObject);
var
  AFileName: String;
begin
  inherited;

  if not TDialog.Create.ShowDialog(TExcelFileSaveDialog, '',
    qProductsBase.ExportFileName, AFileName) then
    Exit;

  cxExportTLToExcel(AFileName, cxDBTreeList, True, True, True, 'xls');

  // ��� ���� ������� �����-�� ��������� �������������
  {
    ExportViewToExcel(MainView, AFileName,
    procedure(AView: TcxGridDBBandedTableView)
    begin
    AView.Bands[0].FixedKind := fkNone;
    end);
  }
end;

procedure TViewProductsBase2.actLoadDatasheetExecute(Sender: TObject);
begin
  inherited;
  // ���� ��������� �� ������������� ����, �� � ������������ ��������� ������
  if IsFocusedNodeEquals(clChecked, 1) then
    UploadDoc(TComponentDatasheetDoc.Create)
  else
    UploadDoc(TWareHouseDatasheetDoc.Create);
end;

procedure TViewProductsBase2.actLoadDiagramExecute(Sender: TObject);
begin
  inherited;
  // ���� ��������� �� ������������� ����, �� � ������������ ��������� ������
  if IsFocusedNodeEquals(clChecked, 1) then
    UploadDoc(TComponentDiagramDoc.Create)
  else
    UploadDoc(TWareHouseDiagramDoc.Create);
end;

procedure TViewProductsBase2.actLoadDrawingExecute(Sender: TObject);
begin
  inherited;
  // ���� ��������� �� ������������� ����, �� � ������������ ��������� ������
  if IsFocusedNodeEquals(clChecked, 1) then
    UploadDoc(TComponentDrawingDoc.Create)
  else
    UploadDoc(TWareHouseDrawingDoc.Create);
end;

procedure TViewProductsBase2.actLoadImageExecute(Sender: TObject);
begin
  inherited;
  // ���� ��������� �� ������������� ����, �� � ������������ ��������� ������
  if IsFocusedNodeEquals(clChecked, 1) then
    UploadDoc(TComponentImageDoc.Create)
  else
    UploadDoc(TWareHouseImageDoc.Create);
end;

procedure TViewProductsBase2.actOpenDatasheetExecute(Sender: TObject);
begin
  inherited;
  OpenDoc(TWareHouseDatasheetDoc.Create);
end;

procedure TViewProductsBase2.actOpenDiagramExecute(Sender: TObject);
begin
  inherited;
  OpenDoc(TWareHouseDiagramDoc.Create);
end;

procedure TViewProductsBase2.actOpenDrawingExecute(Sender: TObject);
begin
  inherited;
  OpenDoc(TWareHouseDrawingDoc.Create);
end;

procedure TViewProductsBase2.actOpenImageExecute(Sender: TObject);
begin
  inherited;

  OpenDoc(TWareHouseImageDoc.Create);
end;

procedure TViewProductsBase2.actOpenInParametricTableExecute(Sender: TObject);
begin
  inherited;
  Assert(qProductsBase.FDQuery.RecordCount > 0);

  if qProductsBase.Value.AsString.Trim.IsEmpty then
  begin
    TDialog.Create.ErrorMessageDialog('�� ������ ������������');
    Exit;
  end;

  if qProductsBase.IDProducer.AsInteger = 0 then
  begin
    TDialog.Create.ErrorMessageDialog('�� ����� �������������');
    Exit;
  end;

  if not qProductsBase.LocateInComponents then
  begin
    TDialog.Create.ErrorMessageDialog
      (Format('��������� %s �� ������ � ������������� ����',
      [qProductsBase.Value.AsString]));
    Exit;
  end;

end;

procedure TViewProductsBase2.actRollbackExecute(Sender: TObject);
begin
  inherited;
  cxDBTreeList.BeginUpdate;
  try
    qProductsBase.CancelUpdates;
    cxDBTreeList.FullCollapse;
  finally
    cxDBTreeList.EndUpdate;
  end;
  UpdateView;
end;

procedure TViewProductsBase2.BeginUpdate;
begin
  // ������������ �� ������� � ����� ���-��
  if FUpdateCount = 0 then
    FCountEvents.Clear;

  inherited;
end;

procedure TViewProductsBase2.BindRate(ARateField: TField;
  AdxBarCombo: TdxBarCombo);
var
  r: Double;
begin
  r := RateToPer�ent(ARateField.AsFloat);
  if r = 0 then
  begin
    AdxBarCombo.Text := '';
  end
  else
  begin
    AdxBarCombo.Tag := 1;
    AdxBarCombo.Text := Format('%8.2f', [r]);
    AdxBarCombo.Tag := 0;
  end;
end;

function TViewProductsBase2.CheckAndSaveChanges: Integer;
begin
  Result := 0;
  if qProductsBase = nil then
    Exit;

  if qProductsBase.HaveAnyChanges then
  begin
    Result := TDialog.Create.SaveDataDialog;
    case Result of
      IDYES:
        actCommit.Execute;
      IDNO:
        begin
          actRollback.Execute;
        end;
    end;
  end;
end;

procedure TViewProductsBase2.clDatasheetGetDisplayText
  (Sender: TcxTreeListColumn; ANode: TcxTreeListNode; var Value: string);
begin
  inherited;
  if not Value.IsEmpty then
    Value := TPath.GetFileNameWithoutExtension(Value);
end;

procedure TViewProductsBase2.clDescriptionPropertiesInitPopup(Sender: TObject);
begin
  inherited;
  Assert(FfrmDescriptionPopup <> nil);
  // ����������� ���������� ����� � ������
  FfrmDescriptionPopup.Query := qProductsBase;
end;

procedure TViewProductsBase2.CreateCountEvents;
begin
  // ������������� �� ������� ����� ����������� ���-��
  TNotifyEventWrap.Create(qProductsBase.AfterOpen, DoAfterOpen, FCountEvents);

  TNotifyEventWrap.Create(qProductsBase.AfterPost, DoAfterPost, FCountEvents);

  TNotifyEventWrap.Create(qProductsBase.AfterDelete, DoAfterDelete,
    FCountEvents);

  // ����� ����������� ��������
  TNotifyEventWrap.Create(FqProductsBase.AfterScroll, DoAfterScroll,
    FCountEvents);

  UpdateProductCount;
end;

procedure TViewProductsBase2.cxbeiRateChange(Sender: TObject);
var
  r: Double;
  S: string;
begin
  inherited;
  S := cxbeiRate.EditValue;
  r := StrToFloatDef(S, 0);
  if (r = 0) or (FqProductsBase.Rate = r) then
    Exit;

  // �������� ���� �������
  FqProductsBase.Rate := r;
  if (FqProductsBase.FDQuery.Active) and (FqProductsBase.FDQuery.RecordCount > 0)
  then
    FqProductsBase.FDQuery.Resync([rmExact, rmCenter]);
end;

procedure TViewProductsBase2.cxDBTreeListBandHeaderClick
  (Sender: TcxCustomTreeList; ABand: TcxTreeListBand);
begin
  inherited;

  if ABand.VisibleColumnCount = 0 then
    Exit;

  ApplySort(ABand.VisibleColumns[0]);
  { }
end;

procedure TViewProductsBase2.cxDBTreeListCustomDrawDataCell
  (Sender: TcxCustomTreeList; ACanvas: TcxCanvas;
  AViewInfo: TcxTreeListEditCellViewInfo; var ADone: Boolean);
var
  V: Variant;
begin
  inherited;

  if (AViewInfo.Selected) and (AViewInfo.Column = cxDBTreeList.FocusedColumn)
  then
    Exit;

  if (AViewInfo.Column <> clPriceR) and (AViewInfo.Column <> clPriceD) and
    (AViewInfo.Column <> clValue) then
    Exit;

  if AViewInfo.Column = clValue then
  begin
    V := AViewInfo.Node.Values[clChecked.ItemIndex];
    if VarIsNull(V) then
      Exit;

    if V = 1 then
    begin
      // ����� ������ �� ������
      ACanvas.Font.Color := clBlack;
      ACanvas.FillRect(AViewInfo.BoundsRect, $00F5DEC9);
    end;
    Exit;
  end;

  V := AViewInfo.Node.Values[clIDCurrency.ItemIndex];
  if VarIsNull(V) then
    Exit;

  if ((V = 1) and (AViewInfo.Column = clPriceR)) or
    ((V = 2) and (AViewInfo.Column = clPriceD)) then
  begin
    // ����� ������ �� ������
    ACanvas.Font.Color := clBlack;
    ACanvas.FillRect(AViewInfo.BoundsRect, $00F5DEC9);
  end;
  { }
end;

procedure TViewProductsBase2.cxDBTreeListFocusedNodeChanged
  (Sender: TcxCustomTreeList; APrevFocusedNode, AFocusedNode: TcxTreeListNode);
begin
  inherited;
  UpdateView;
  { }
end;

procedure TViewProductsBase2.cxDBTreeListInitEditValue(Sender, AItem: TObject;
  AEdit: TcxCustomEdit; var AValue: Variant);
var
  AcxDBTreeListColumn: TcxDBTreeListColumn;
  AcxMaskEdit: TcxMaskEdit;
  // S: string;
begin
  inherited;
  // � ������ ������� ����� ������ ��������� �������������� ����
  if qProductsBase.FDQuery.State = dsInsert then
    Exit;

  AcxDBTreeListColumn := AItem as TcxDBTreeListColumn;

  if not AcxDBTreeListColumn.DataBinding.Field.FieldName.StartsWith('Price')
  then
    Exit;

  if not(AEdit is TcxMaskEdit) then
    Exit;

  AcxMaskEdit := AEdit as TcxMaskEdit;
  AcxMaskEdit.Properties.ReadOnly := True;
  { }
end;

procedure TViewProductsBase2.cxDBTreeListIsGroupNode(Sender: TcxCustomTreeList;
  ANode: TcxTreeListNode; var IsGroup: Boolean);
var
  V: Variant;
begin
  inherited;
  V := ANode.Values[clIsGroup.ItemIndex];
  IsGroup := not VarIsNull(V) and (V = 1);
  { }
end;

procedure TViewProductsBase2.cxDBTreeListSelectionChanged(Sender: TObject);
begin
  inherited;
  UpdateSelectedCount;
end;

procedure TViewProductsBase2.DoAfterDelete(Sender: TObject);
begin
  UpdateProductCount;
end;

procedure TViewProductsBase2.DoAfterLoad(Sender: TObject);
begin
  UpdateView;
  cxDBTreeList.FullCollapse;
  // cxDBTreeList.ApplyBestFit;
end;

procedure TViewProductsBase2.DoAfterOpen(Sender: TObject);
begin
  UpdateProductCount;
  UpdateView;
end;

procedure TViewProductsBase2.DoAfterPost(Sender: TObject);
begin
  UpdateProductCount;
end;

procedure TViewProductsBase2.DoAfterScroll(Sender: TObject);
begin
  BindRate(FqProductsBase.Rate1, dxbcRate1);
  BindRate(FqProductsBase.Rate2, dxbcRate2);
end;

procedure TViewProductsBase2.DoOnDescriptionPopupHide(Sender: TObject);
begin
  UpdateView;
end;

procedure TViewProductsBase2.dxbcRate2Change(Sender: TObject);
var
  r: Double;
begin
  inherited;
  if (Sender as TComponent).Tag = 1 then
    Exit;

  r := StrToFloatDef(dxbcRate2.Text, 0);
  if r = 0 then
    Exit;

  UpdateRate(Per�entToRate(r), FqProductsBase.Rate2);
end;

procedure TViewProductsBase2.dxbcRate1Change(Sender: TObject);
var
  r: Double;
begin
  inherited;
  if (Sender as TComponent).Tag = 1 then
    Exit;

  r := StrToFloatDef(dxbcRate1.Text, 0);
  if r = 0 then
    Exit;

  UpdateRate(Per�entToRate(r), FqProductsBase.Rate1);
end;

const
  clClickedColor = clRed;

procedure TViewProductsBase2.dxbcRate1DrawItem(Sender: TdxBarCustomCombo;
  AIndex: Integer; ARect: TRect; AState: TOwnerDrawState);
var
  S: string;
begin
  inherited;

  if odSelected in AState then
  begin
    Brush.Color := clClickedColor;
    Font.Color := clHighlightText;
  end
  else
  begin
    Brush.Color := clWindow;
    Font.Color := clWindowText;
  end;

  Sender.Canvas.FillRect(ARect);
  if odFocused in AState then
    DrawFocusRect(Sender.Canvas.Handle, ARect);

  if AIndex >= 0 then
    S := Sender.Items[AIndex]
  else
    S := Sender.Text;
  if S <> '' then
    S := S + '%';

  Sender.Canvas.TextOut(ARect.Left + 2, ARect.Top + 2, S);
end;

procedure TViewProductsBase2.EndUpdate;
begin
  inherited;
  if FUpdateCount = 0 then
    CreateCountEvents;
end;

procedure TViewProductsBase2.InitializeColumns;
var
  i: Integer;
begin
  for i := 0 to cxDBTreeList.ColumnCount - 1 do
  begin
    cxDBTreeList.Columns[i].MinWidth := 100;
  end;

  Assert(FqProductsBase <> nil);

  InitializeLookupColumn(clIDProducer,
    FqProductsBase.ProducersGroup.qProducers.DataSource, lsEditFixedList,
    FqProductsBase.ProducersGroup.qProducers.Name.FieldName);
end;

procedure TViewProductsBase2.InternalRefreshData;
begin
  Assert(qProductsBase <> nil);
  qProductsBase.RefreshQuery;
  cxDBTreeList.FullCollapse;
end;

function TViewProductsBase2.IsFocusedNodeEquals(AColumn: TcxDBTreeListColumn;
    AValue: Variant): Boolean;
var
  ANode: TcxTreeListNode;
  V: Variant;
begin
  Assert(AColumn <> nil);
  Assert(not VarIsNull(AValue));

  Result := False;
  ANode := cxDBTreeList.FocusedNode;
  if ANode = nil then
    Exit;

  V := ANode.Values[AColumn.ItemIndex];
  Result := not VarIsNull(V) and (V = AValue);
end;

function TViewProductsBase2.IsSyncToDataSet: Boolean;
var
  S1: string;
  S2: string;
  V1: Variant;
  V2: Variant;
begin
  Result := inherited and (qProductsBase <> nil);
  if not Result then
    Exit;

  V1 := cxDBTreeList.FocusedNode.Values[clValue.ItemIndex];
  V2 := qProductsBase.Value.Value;

  Result := VarIsNull(V1) and VarIsNull(V2);
  if not Result then
    Exit;
  S1 := V1;
  S2 := V2;
  Result := S1 = S2;
end;

procedure TViewProductsBase2.OpenDoc(ADocFieldInfo: TDocFieldInfo);
begin
  Application.Hint := '';
  TDocument.Open(Handle, ADocFieldInfo.Folder,
    FqProductsBase.FDQuery.FieldByName(ADocFieldInfo.FieldName).AsString,
    ADocFieldInfo.ErrorMessage, ADocFieldInfo.EmptyErrorMessage,
    sBodyTypesFilesExt);
end;

function TViewProductsBase2.Per�entToRate(APer�ent: Double): Double;
begin
  Result := 1 + APer�ent / 100
end;

function TViewProductsBase2.RateToPer�ent(ARate: Double): Double;
begin
  if ARate <= 0 then
  begin
    Result := 0;
    Exit;
  end;

  if ARate > 1 then
  begin
    Result := (ARate - 1) * 100;
  end
  else
  begin
    Result := (1 - ARate) * -100
  end;

end;

procedure TViewProductsBase2.SetqProductsBase(const Value: TQueryProductsBase);
begin
  if FqProductsBase = Value then
    Exit;

  FqProductsBase := Value;

  if FqProductsBase = nil then
    Exit;

  cxDBTreeList.DataController.DataSource := FqProductsBase.DataSource;

  InitializeColumns;

  TNotifyEventWrap.Create(FqProductsBase.AfterLoad, DoAfterLoad, FEventList);

  // ������������� �� ������� � ����� ���������� � ��������
  CreateCountEvents;

  UpdateView;
end;

procedure TViewProductsBase2.UpdateProductCount;
begin
  // �� ��������� ������ ��� � ���������� ������ ��� ����� �����
  StatusBar.Panels[0].Text :=
    Format('%d', [qProductsBase.NotGroupClone.RecordCount]);
end;

procedure TViewProductsBase2.UpdateRate(const ARate: Double; RateField: TField);
var
  ANode: TcxDBTreeListNode;
  AUpdatedIDList: TList<Integer>;
  i: Integer;
begin
  AUpdatedIDList := TList<Integer>.Create;
  FqProductsBase.FDQuery.DisableControls;
  try
    for i := 0 to cxDBTreeList.SelectionCount - 1 do
    begin
      ANode := cxDBTreeList.Selections[i] as TcxDBTreeListNode;
      // if ANode.IsGroupNode then
      // Continue;

      FqProductsBase.UpdateRate(ANode.Values[clID.ItemIndex], RateField, ARate,
        AUpdatedIDList);
    end;
  finally
    FqProductsBase.FDQuery.EnableControls;
    FreeAndNil(AUpdatedIDList);
  end;
end;

procedure TViewProductsBase2.UpdateSelectedCount;
begin
  StatusBar.Panels[FSelectedCountPanelIndex].Text :=
    Format('%d', [cxDBTreeList.SelectionCount]);
end;

procedure TViewProductsBase2.UpdateView;
var
  OK: Boolean;
begin
  inherited;
  OK := (qProductsBase <> nil) and (qProductsBase.FDQuery.Active) and
    (qProductsBase.Master <> nil) and (qProductsBase.Master.FDQuery.Active) and
    (qProductsBase.Master.FDQuery.RecordCount > 0);

  actCommit.Enabled := OK and qProductsBase.HaveAnyChanges;
  actRollback.Enabled := actCommit.Enabled;
  actExportToExcelDocument.Enabled := OK and
    (cxDBTreeList.DataController.DataSet.RecordCount > 0);
  actOpenInParametricTable.Enabled := OK and
    (cxDBTreeList.DataController.DataSet.RecordCount > 0);

  actAddCategory.Enabled := OK;

  actAddComponent.Enabled := OK and (cxDBTreeList.FocusedNode <> nil);

  actDelete.Enabled := OK and (cxDBTreeList.FocusedNode <> nil) and
    (cxDBTreeList.DataController.DataSet.RecordCount > 0);

  cxbeiRate.EditValue := qProductsBase.Rate;
end;

procedure TViewProductsBase2.UploadDoc(ADocFieldInfo: TDocFieldInfo);
var
  sourceFileName: string;
begin
  Application.Hint := '';
  // ��������� ������ ������ ����� ��� ��������
  if not TDialog.Create.ShowDialog(TMyOpenPictureDialog, ADocFieldInfo.Folder,
    '', sourceFileName) then
    Exit;

  FqProductsBase.LoadDocFile(sourceFileName, ADocFieldInfo);
end;

end.
