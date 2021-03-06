unit BodyTypesView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, GridFrame, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB, cxDBData,
  cxGridCustomPopupMenu, cxGridPopupMenu, Vcl.Menus, System.Actions,
  Vcl.ActnList, dxBar, cxClasses, Vcl.ComCtrls, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridBandedTableView,
  cxGridDBBandedTableView, cxGrid, BodyTypesQuery2,
  cxDBLookupComboBox, cxDropDownEdit, Vcl.ExtCtrls, cxButtonEdit, dxSkinsCore,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMetropolis, dxSkinMetropolisDark, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinOffice2013DarkGray,
  dxSkinOffice2013LightGray, dxSkinOffice2013White, dxSkinOffice2016Colorful,
  dxSkinOffice2016Dark, dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic,
  dxSkinSharp, dxSkinSharpPlus, dxSkinSilver, dxSkinSpringTime, dxSkinStardust,
  dxSkinSummer2008, dxSkinTheAsphaltWorld, dxSkinsDefaultPainters,
  dxSkinValentine, dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, dxSkinscxPCPainter, dxSkinsdxBarPainter,
  DragHelper, HRTimer, cxContainer, cxTextEdit, cxDBEdit,
  Vcl.Grids, Vcl.DBGrids, System.Generics.Collections, GridSort,
  CustomErrorForm, NaturalSort, DocFieldInfo, cxEditRepositoryItems,
  JEDECPopupForm, BodyVariationsJedecQuery, BodyTypesGroupUnit2,
  cxDataControllerConditionalFormattingRulesManagerDialog, dxBarBuiltInMenu,
  cxBarEditItem, cxColorComboBox, dxColorDialog, cxLocalization, dxDateRanges;

const
  WM_SEARCH_EDIT_ENTER = WM_USER + 13;

type
  TViewBodyTypes = class(TfrmGrid)
    actAdd: TAction;
    clID: TcxGridDBBandedColumn;
    clBodyKind: TcxGridDBBandedColumn;
    dxbbAdd: TdxBarButton;
    dxbbDelete: TdxBarButton;
    cxGridLevel2: TcxGridLevel;
    cxGridDBBandedTableView2: TcxGridDBBandedTableView;
    actAddBody: TAction;
    dxbbAddBody: TdxBarButton;
    actLoadFromExcelDocument: TAction;
    dxbrsbtmExportImport: TdxBarSubItem;
    dxbbLoadFromExcelDocument: TdxBarButton;
    actExportToExcelDocument: TAction;
    dxbrbtnExport: TdxBarButton;
    actCommit: TAction;
    actRollback: TAction;
    dxbrbtnCommit: TdxBarButton;
    dxbrbtnRollback: TdxBarButton;
    dxBarButton1: TdxBarButton;
    actSettings: TAction;
    clIDS: TcxGridDBBandedColumn;
    clIDBodyData: TcxGridDBBandedColumn;
    clOutlineDrawing: TcxGridDBBandedColumn;
    clLandPattern: TcxGridDBBandedColumn;
    clVariations: TcxGridDBBandedColumn;
    clImage: TcxGridDBBandedColumn;
    clIDBody: TcxGridDBBandedColumn;
    clIDProducer: TcxGridDBBandedColumn;
    clBodyData: TcxGridDBBandedColumn;
    clBody: TcxGridDBBandedColumn;
    clIDBodyKind: TcxGridDBBandedColumn;
    clOrd: TcxGridDBBandedColumn;
    actOpenOutlineDrawing: TAction;
    actOpenLandPattern: TAction;
    actOpenImage: TAction;
    actShowDuplicate: TAction;
    dxBarButton2: TdxBarButton;
    dxBarManagerBar1: TdxBar;
    actLoadOutlineDrawing: TAction;
    actLoadLandPattern: TAction;
    actLoadImage: TAction;
    clJEDEC: TcxGridDBBandedColumn;
    cxEditRepository: TcxEditRepository;
    cxerpiJEDEC: TcxEditRepositoryPopupItem;
    clOptions: TcxGridDBBandedColumn;
    dxBarButton3: TdxBarButton;
    actApplyBestFit: TAction;
    cxerbiJEDEC: TcxEditRepositoryButtonItem;
    actLoadJEDEC: TAction;
    actAddJEDECFile: TAction;
    N2: TMenuItem;
    JEDEC1: TMenuItem;
    actOpenJEDECAll: TAction;
    N3: TMenuItem;
    dxBarManagerBar2: TdxBar;
    cxbeiSearch: TcxBarEditItem;
    actSearch: TAction;
    dxBarButton4: TdxBarButton;
    clColor: TcxGridDBBandedColumn;
    actColor: TAction;
    dxColorDialog: TdxColorDialog;
    N4: TMenuItem;
    ColorDialog: TColorDialog;
    dxBarButton5: TdxBarButton;
    cxLocalizer: TcxLocalizer;
    procedure actAddBodyExecute(Sender: TObject);
    procedure actAddExecute(Sender: TObject);
    procedure actAddJEDECFileExecute(Sender: TObject);
    procedure actApplyBestFitExecute(Sender: TObject);
    procedure actColorExecute(Sender: TObject);
    procedure actCommitExecute(Sender: TObject);
    procedure actExportToExcelDocumentExecute(Sender: TObject);
    procedure actLoadFromExcelDocumentExecute(Sender: TObject);
    procedure actLoadImageExecute(Sender: TObject);
    procedure actLoadJEDECExecute(Sender: TObject);
    procedure actLoadLandPatternExecute(Sender: TObject);
    procedure actLoadOutlineDrawingExecute(Sender: TObject);
    procedure actOpenImageExecute(Sender: TObject);
    procedure actOpenJEDECAllExecute(Sender: TObject);
    procedure actOpenLandPatternExecute(Sender: TObject);
    procedure actRollbackExecute(Sender: TObject);
    procedure actSettingsExecute(Sender: TObject);
    procedure actOpenOutlineDrawingExecute(Sender: TObject);
    procedure actSearchExecute(Sender: TObject);
    procedure actShowDuplicateExecute(Sender: TObject);
    procedure clJEDECGetProperties(Sender: TcxCustomGridTableItem;
      ARecord: TcxCustomGridRecord; var AProperties: TcxCustomEditProperties);
    procedure clOutlineDrawingGetDataText(Sender: TcxCustomGridTableItem;
      ARecordIndex: Integer; var AText: string);
    procedure cxbeiSearchEnter(Sender: TObject);
    procedure cxGridDBBandedTableView2ColumnHeaderClick
      (Sender: TcxGridTableView; AColumn: TcxGridColumn);
    procedure cxGridDBBandedTableView2CustomDrawColumnHeader
      (Sender: TcxGridTableView; ACanvas: TcxCanvas;
      AViewInfo: TcxGridColumnHeaderViewInfo; var ADone: Boolean);
    procedure cxGridDBBandedTableViewDataControllerSummaryAfterSummary
      (ASender: TcxDataSummary);
    procedure cxGridDBBandedTableView2EditKeyDown
      (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
      AEdit: TcxCustomEdit; var Key: Word; Shift: TShiftState);
    procedure cxGridDBBandedTableView2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cxGridDBBandedTableView2MouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure cxGridDBBandedTableViewEditKeyDown(Sender: TcxCustomGridTableView;
      AItem: TcxCustomGridTableItem; AEdit: TcxCustomEdit; var Key: Word;
      Shift: TShiftState);
    procedure cxGridDBBandedTableViewDragDrop(Sender, Source: TObject;
      X, Y: Integer);
    procedure cxGridDBBandedTableViewDragOver(Sender, Source: TObject;
      X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure cxGridDBBandedTableViewStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure cxGridDBBandedTableView2StylesGetHeaderStyle
      (Sender: TcxGridTableView; AColumn: TcxGridColumn; var AStyle: TcxStyle);
    procedure cxGridDBBandedTableView2DataControllerCompare(ADataController
      : TcxCustomDataController; ARecordIndex1, ARecordIndex2,
      AItemIndex: Integer; const V1, V2: Variant; var Compare: Integer);
    procedure cxerpiJEDECPropertiesInitPopup(Sender: TObject);
    procedure cxerpiJEDECPropertiesCloseUp(Sender: TObject);
    procedure cxbeiSearchPropertiesChange(Sender: TObject);
    procedure cxbeiSearchPropertiesEditValueChanged(Sender: TObject);
    procedure cxGridDBBandedTableViewStylesGetContentStyle
      (Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
      AItem: TcxCustomGridTableItem; var AStyle: TcxStyle);
  private
    FBodyTypesGroup: TBodyTypesGroup2;
    FDragAndDropInfo: TDragAndDropInfo;
    FfrmJEDECPopup: TfrmJEDECPopup;
    FHRTimer: THRTimer;
    FNaturalStringComparer: TNaturalStringComparer;
    FSortSL: TList<String>;

  const
    FolderKey: String = 'BodyTypes';
    procedure DoAfterDataChange(Sender: TObject);
    function GetfrmJEDECPopup: TfrmJEDECPopup;
    function GetProducerDisplayText: string;
    procedure LocalizeDevExpress;
    procedure OnAfterSearchEditEnter(var Message: TMessage);
      message WM_SEARCH_EDIT_ENTER;
    procedure Search(ABodyVariation: String);
    procedure SetBodyTypesGroup(const Value: TBodyTypesGroup2);
    procedure UpdateTotalCount;
    { Private declarations }
  protected
    procedure CreateColumnsBarButtons; override;
    function CreateViewArr: TArray<TcxGridDBBandedTableView>; override;
    procedure LoadFromExcel(const AFileName: String; AProducerID: Integer);
    procedure OnGridRecordCellPopupMenu(AColumn: TcxGridDBBandedColumn;
      var AllowPopup: Boolean); override;
    procedure OpenDoc(ADocFieldInfo: TDocFieldInfo);
    procedure UploadDoc(ADocFieldInfo: TDocFieldInfo);
    procedure UploadJEDEC(Add: Boolean);
    property frmJEDECPopup: TfrmJEDECPopup read GetfrmJEDECPopup;
    property SortSL: TList<String> read FSortSL;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AfterConstruction; override;
    procedure ApplyBestFitJEDEC;
    procedure UpdateView; override;
    property BodyTypesGroup: TBodyTypesGroup2 read FBodyTypesGroup
      write SetBodyTypesGroup;
    property ProducerDisplayText: string read GetProducerDisplayText;
    { Public declarations }
  end;

implementation

uses BodyTypesExcelDataModule, ImportErrorForm, DialogUnit,
  RepositoryDataModule, NotifyEvents, ColumnsBarButtonsHelper, CustomExcelTable,
  OpenDocumentUnit, ProjectConst, SettingsController, PathSettingsForm,
  System.Math, System.IOUtils, ProgressBarForm, DialogUnit2,
  BodyTypesSimpleQuery, ProducersForm, dxCore, LoadFromExcelFileHelper,
  OpenJedecUnit, ExcelDataModule, cxMaskEdit;

{$R *.dfm}

constructor TViewBodyTypes.Create(AOwner: TComponent);
begin
  inherited;
  StatusBarEmptyPanelIndex := 1;

  FNaturalStringComparer := TNaturalStringComparer.Create;

  FDragAndDropInfo := TDragAndDropInfo.Create(clID, clOrd);

  PostOnEnterFields.Add(clBodyKind.DataBinding.FieldName);
  PostOnEnterFields.Add(clBody.DataBinding.FieldName);
  PostOnEnterFields.Add(clBodyData.DataBinding.FieldName);

  GridSort.Add(TSortVariant.Create(clBody, [clBody, clBodyData,
    clOutlineDrawing, clLandPattern]));
  GridSort.Add(TSortVariant.Create(clIDProducer, [clIDProducer, clBody,
    clBodyData, clOutlineDrawing, clLandPattern]));

  DeleteMessages.Add(cxGridLevel, '������� ��� �������?');
  DeleteMessages.Add(cxGridLevel2, '������� ������?');

  (cxerpiJEDEC.Properties as TcxPopupEditProperties).PopupControl :=
    frmJEDECPopup;

  ApplyBestFitForDetail := True;

  LocalizeDevExpress;
  FSortSL := TList<String>.Create;
end;

destructor TViewBodyTypes.Destroy;
begin
  FreeAndNil(FNaturalStringComparer);
  FreeAndNil(FDragAndDropInfo);
  FreeAndNil(FSortSL);
  inherited;
end;

procedure TViewBodyTypes.actAddBodyExecute(Sender: TObject);
var
  ARow: TcxGridMasterDataRow;
  AView: TcxGridDBBandedTableView;
begin
  // ������� ��������� ��� �������
  BodyTypesGroup.qBodyKinds.W.TryPost;

  ARow := GetRow(0) as TcxGridMasterDataRow;
  ARow.Expand(false);
  AView := GetDBBandedTableView(1);
  AView.Controller.ClearSelection;
  AView.DataController.Append;

  FocusColumnEditor(1, BodyTypesGroup.qBodyTypes2.W.Body.FieldName);

  UpdateView;

end;

procedure TViewBodyTypes.actAddExecute(Sender: TObject);
begin
  MainView.DataController.Append;
  FocusColumnEditor(0, BodyTypesGroup.qBodyTypes2.W.Body.FieldName);

  UpdateView;

end;

procedure TViewBodyTypes.actAddJEDECFileExecute(Sender: TObject);
begin
  inherited;
  UploadJEDEC(True);
end;

procedure TViewBodyTypes.actApplyBestFitExecute(Sender: TObject);
begin
  inherited;
  GetDBBandedTableView(1).GetColumnByFieldName(clJEDEC.DataBinding.FieldName)
    .ApplyBestFit();
end;

procedure TViewBodyTypes.actColorExecute(Sender: TObject);
var
  A: TArray<Integer>;
  AHex: string;
  ColorIndex: Char;
begin
  BodyTypesGroup.qBodyKindsColor.W.RefreshQuery;


  ColorDialog.CustomColors.Clear;
  ColorIndex := 'A';
  BodyTypesGroup.qBodyKindsColor.FDQuery.First;
  while not BodyTypesGroup.qBodyKindsColor.FDQuery.Eof do
  begin
    AHex := IntToHex(BodyTypesGroup.qBodyKindsColor.W.Color.F.AsInteger);
    ColorDialog.CustomColors.Add(Format('Color%s=%s', [ColorIndex, AHex]));
    BodyTypesGroup.qBodyKindsColor.FDQuery.Next;
    Inc(ColorIndex);
  end;

  ColorDialog.Color := BodyTypesGroup.qBodyKinds.W.Color.F.AsInteger;

  if not ColorDialog.Execute(Application.ActiveFormHandle) then
    Exit;

  A := GetSelectedIntValues(clID);
  BodyTypesGroup.qBodyKinds.W.ApplyColor(A, ColorDialog.Color);

  // ������ ��������� �� ������� ��������� �������������
  MainView.Controller.ClearSelection;
  MainView.Controller.EditingController.HideEdit(False);

end;

procedure TViewBodyTypes.actCommitExecute(Sender: TObject);
begin
  // �� ������ ��������� ����������
  // cxGrid.BeginUpdate();
  // try
  // ��������� ��������� � ��������� ����������
  BodyTypesGroup.Commit;

  // �������� ����� ����������
  // BodyTypesGroup.Connection.StartTransaction;

  // ��������� ����� �� ������ ���������� ������
  // FocusSelectedRecord(MainView);
  // finally
  // cxGrid.EndUpdate;
  // end;

  // �������� ����� � ����� �����
  // PutInTheCenterFocusedRecord(MainView);

  // ��������� �������������
  UpdateView;
end;

procedure TViewBodyTypes.actExportToExcelDocumentExecute(Sender: TObject);
var
  AFileName: String;
  Q: TQueryBodyTypesSimple;
begin
  Application.Hint := '';
  Q := TQueryBodyTypesSimple.Create(Self);
  try
    Q.FDQuery.Open;

    cxGridDBBandedTableView2.DataController.DataSource := Q.W.DataSource;
    try
      if not TDialog.Create.ShowDialog(TExcelFileSaveDialog,
        TSettings.Create.GetFolderFoExcelFile(FolderKey), '���� ��������',
        AFileName) then
        Exit;

      ExportViewToExcel(cxGridDBBandedTableView2, AFileName,
        procedure(AView: TcxGridDBBandedTableView)
        begin
          // ������������� ����� ��������� ��������
          AView.GetColumnByFieldName(clIDProducer.DataBinding.FieldName)
            .Position.ColIndex := 12;

          AView.GetColumnByFieldName(clVariations.DataBinding.FieldName).Caption
            := '������� �������';
          AView.GetColumnByFieldName(clIDBodyKind.DataBinding.FieldName)
            .Visible := True;
          AView.GetColumnByFieldName(clIDBodyKind.DataBinding.FieldName)
            .Options.CellMerging := True;
          AView.ApplyBestFit();
        end);
    finally
      cxGridDBBandedTableView2.DataController.DataSource :=
        BodyTypesGroup.qBodyTypes2.W.DataSource;
    end;
  finally
    FreeAndNil(Q);
  end;

  // clIDBodyKind.Visible := false;
end;

procedure TViewBodyTypes.actLoadFromExcelDocumentExecute(Sender: TObject);
var
  // ABodyTypesExcelDM: TBodyTypesExcelDM;
  AFileName: string;
  // AfrmError: TfrmError;
  AProducer: string;
  AProducerID: Integer;
  ARootTreeNode: TStringTreeNode;
  // OK: Boolean;
begin
  Application.Hint := '';
  // ������� ����� ����������� ������� excel ����
  if not TOpenExcelDialog.SelectInFolder(AFileName, Handle, FolderKey) then
    Exit;

  AProducerID := 0;

  // �������� ����� excel �����
  ARootTreeNode := TExcelDM.LoadExcelFileHeader(AFileName);
  try
    // ���� ����� ������� ��� ������� �������������
    // � �� ������ ������������� ����������
    if (ARootTreeNode.IndexOf(clIDProducer.Caption) = -1) and
      (not TfrmProducers.TakeProducer(AProducerID, AProducer)) then
      Exit;

    LoadFromExcel(AFileName, AProducerID);
  finally
    FreeAndNil(ARootTreeNode);
  end;
end;

procedure TViewBodyTypes.actLoadImageExecute(Sender: TObject);
begin
  inherited;
  UploadDoc(TBodyTypeImageDoc.Create);
end;

procedure TViewBodyTypes.actLoadJEDECExecute(Sender: TObject);
begin
  inherited;
  UploadJEDEC(false);
end;

procedure TViewBodyTypes.actLoadLandPatternExecute(Sender: TObject);
begin
  inherited;
  UploadDoc(TLandPattern.Create);
end;

procedure TViewBodyTypes.actLoadOutlineDrawingExecute(Sender: TObject);
begin
  UploadDoc(TOutlineDrawing.Create);
end;

procedure TViewBodyTypes.actOpenImageExecute(Sender: TObject);
begin
  inherited;
  OpenDoc(TBodyTypeImageDoc.Create);
end;

procedure TViewBodyTypes.actOpenJEDECAllExecute(Sender: TObject);
var
  AJedec: string;
  m: TArray<String>;
  S: String;
begin
  inherited;
  m := BodyTypesGroup.qBodyTypes2.W.JEDEC.F.AsString.Split([';']);
  for S in m do
  begin
    AJedec := S.Trim;
    TJEDECDocument.OpenJEDEC(Handle, AJedec);
  end;
end;

procedure TViewBodyTypes.actOpenLandPatternExecute(Sender: TObject);
begin
  inherited;
  OpenDoc(TLandPattern.Create);
end;

procedure TViewBodyTypes.actRollbackExecute(Sender: TObject);
begin
  cxGrid.BeginUpdate();
  try
    // �������� ��� ��������� ���������
    BodyTypesGroup.Rollback;

    MainView.ViewData.Collapse(True);
  finally
    cxGrid.EndUpdate;
  end;

  // ��������� �������������
  UpdateView;
end;

procedure TViewBodyTypes.actSettingsExecute(Sender: TObject);
var
  frmPathSettings: TfrmPathSettings;
begin
  frmPathSettings := TfrmPathSettings.Create(Self);
  try
    frmPathSettings.cxPageControl.ActivePage := frmPathSettings.cxtshBodyTypes;
    frmPathSettings.ShowModal;
  finally
    FreeAndNil(frmPathSettings);
  end;
end;

procedure TViewBodyTypes.actOpenOutlineDrawingExecute(Sender: TObject);
begin
  inherited;
  OpenDoc(TOutlineDrawing.Create);
end;

procedure TViewBodyTypes.actSearchExecute(Sender: TObject);
var
  S: String;
begin
  inherited;

  S := VarToStrDef(cxbeiSearch.EditValue, '');
  if S.IsEmpty then
    Exit;

  Search(S);
end;

procedure TViewBodyTypes.actShowDuplicateExecute(Sender: TObject);
begin
  Application.Hint := '';

  BodyTypesGroup.Re_Open(not actShowDuplicate.Checked);
  // ��������� ����� �� ������ ���������� ������
  // FocusSelectedRecord();
  // �������� ����� � ����� �����
  // PutInTheCenterFocusedRecord();

  actShowDuplicate.Checked := not actShowDuplicate.Checked;
  // ��������� �������������
  UpdateView;
end;

procedure TViewBodyTypes.AfterConstruction;
begin
  // cxGridPopupMenu.PopupMenus[0].GridView := MainView;
  // cxGridPopupMenu.PopupMenus[1].GridView := cxGridDBBandedTableView2;

  inherited;
end;

procedure TViewBodyTypes.ApplyBestFitJEDEC;
begin
  GetDBBandedTableView(1).GetColumnByFieldName(clJEDEC.DataBinding.FieldName)
    .ApplyBestFit();
end;

procedure TViewBodyTypes.clJEDECGetProperties(Sender: TcxCustomGridTableItem;
ARecord: TcxCustomGridRecord; var AProperties: TcxCustomEditProperties);
var
  AJedec: string;
  i: Integer;
begin
  inherited;
  if ARecord = nil then
    Exit;

  // �������� �������� ���������� �����
  AJedec := VarToStrDef(ARecord.Values[clJEDEC.Index], '');

  // ����, ��������� � ��� JEDEC ��� ��� �������
  i := AJedec.IndexOf(';');
  if i >= 0 then
    AProperties := cxerpiJEDEC.Properties
  else
    AProperties := cxerbiJEDEC.Properties
end;

procedure TViewBodyTypes.clOutlineDrawingGetDataText
  (Sender: TcxCustomGridTableItem; ARecordIndex: Integer; var AText: string);
begin
  inherited;
  if not AText.IsEmpty then
    AText := TPath.GetFileNameWithoutExtension(AText);
end;

// TODO: clBodyType2PropertiesInitPopup
/// / TODO: clBodyType1PropertiesInitPopup
/// /procedure TViewBodyTypes.clBodyType1PropertiesInitPopup(Sender: TObject);
/// /var
/// /AcxComboBox: TcxComboBox;
/// /begin
/// /inherited;
/// /
/// /if BodyTypesGroup.qBodyTypes2.IDParentBodyType1.IsNull then
/// /  Exit;
/// /
/// /// ��������� ��� ��������� �������� ������� ��� ��������� ���� �������
/// /BodyTypesGroup.qBodyTypesBranch.Load
/// /  (BodyTypesGroup.qBodyTypes2.IDParentBodyType1.Value);
/// /
/// /AcxComboBox := Sender as TcxComboBox;
/// /AcxComboBox.Properties.Items.Clear;
/// /
/// /BodyTypesGroup.qBodyTypesBranch.FDQuery.First;
/// /while not BodyTypesGroup.qBodyTypesBranch.FDQuery.Eof do
/// /begin
/// /  AcxComboBox.Properties.Items.Add
/// /    (BodyTypesGroup.qBodyTypesBranch.BodyType.AsString);
/// /  BodyTypesGroup.qBodyTypesBranch.FDQuery.Next;
/// /end;
/// /end;
//
// procedure TViewBodyTypes.clBodyType2PropertiesInitPopup(Sender: TObject);
// var
// AcxComboBox: TcxComboBox;
// begin
// inherited;
//
// if BodyTypesGroup.qBodyTypes2.ID1.IsNull then
// Exit;
//
/// / ��������� ��� ��������� �������� ������� ��� ��������� ���� �������
// BodyTypesGroup.qBodyTypesBranch.Load
// (BodyTypesGroup.qBodyTypes2.ID1.Value);
//
// AcxComboBox := Sender as TcxComboBox;
// AcxComboBox.Properties.Items.Clear;
//
// BodyTypesGroup.qBodyTypesBranch.FDQuery.First;
// while not BodyTypesGroup.qBodyTypesBranch.FDQuery.Eof do
// begin
// AcxComboBox.Properties.Items.Add
// (BodyTypesGroup.qBodyTypesBranch.BodyType.AsString);
// BodyTypesGroup.qBodyTypesBranch.FDQuery.Next;
// end;
//
// end;

procedure TViewBodyTypes.CreateColumnsBarButtons;
begin
  FColumnsBarButtons := TGVColumnsBarButtons.Create(Self, dxbsColumns,
    cxGridDBBandedTableView2);
end;

function TViewBodyTypes.CreateViewArr: TArray<TcxGridDBBandedTableView>;
begin
  Result := [MainView, cxGridDBBandedTableView2];
end;

procedure TViewBodyTypes.cxbeiSearchEnter(Sender: TObject);
begin
  inherited;
  if cxbeiSearch.StyleEdit <> nil then
  begin
    PostMessage(Handle, WM_SEARCH_EDIT_ENTER, 0, 0);
  end;
end;

procedure TViewBodyTypes.cxbeiSearchPropertiesChange(Sender: TObject);
begin
  inherited;
  actSearch.Enabled := not VarToStrDef(cxbeiSearch.CurEditValue, '').IsEmpty;
end;

procedure TViewBodyTypes.cxbeiSearchPropertiesEditValueChanged(Sender: TObject);
begin
  inherited;
  // ��������� ��, ��� �� ��� ���������������
  (Sender as TcxTextEdit).PostEditValue;
  actSearch.Execute;
end;

procedure TViewBodyTypes.cxerpiJEDECPropertiesCloseUp(Sender: TObject);
var
  AJedec: String;
begin
  inherited;
  Assert(FfrmJEDECPopup <> nil);

  if FfrmJEDECPopup.ModalResult <> mrOk then
    Exit;

  AJedec := FfrmJEDECPopup.ViewBodyVariationJEDEC.JEDECList;

  if AJedec = BodyTypesGroup.qBodyTypes2.W.JEDEC.F.AsString then
    Exit;

  BodyTypesGroup.qBodyTypes2.W.TryEdit;
  BodyTypesGroup.qBodyTypes2.W.JEDEC.F.AsString := AJedec;
  BodyTypesGroup.TryPost;
  ApplyBestFitJEDEC;
end;

procedure TViewBodyTypes.cxerpiJEDECPropertiesInitPopup(Sender: TObject);
begin
  inherited;
  frmJEDECPopup.ViewBodyVariationJEDEC.Init
    (BodyTypesGroup.qBodyTypes2.W.IDS.F.AsString.Trim([',']),
    BodyTypesGroup.qBodyTypes2.qJedec);
end;

procedure TViewBodyTypes.cxGridDBBandedTableView2ColumnHeaderClick
  (Sender: TcxGridTableView; AColumn: TcxGridColumn);
begin
  inherited;

  ApplySort(Sender, AColumn);
end;

procedure TViewBodyTypes.cxGridDBBandedTableView2CustomDrawColumnHeader
  (Sender: TcxGridTableView; ACanvas: TcxCanvas;
AViewInfo: TcxGridColumnHeaderViewInfo; var ADone: Boolean);
begin
  inherited;
  DoOnCustomDrawColumnHeader(AViewInfo, ACanvas);
end;

procedure TViewBodyTypes.cxGridDBBandedTableView2DataControllerCompare
  (ADataController: TcxCustomDataController; ARecordIndex1, ARecordIndex2,
  AItemIndex: Integer; const V1, V2: Variant; var Compare: Integer);
var
  S1: string;
  S2: string;
begin
  inherited;
  S1 := VarToWideStrDef(V1, '');
  S2 := VarToWideStrDef(V2, '');

  if (AItemIndex = clBody.Index) or (AItemIndex = clBodyData.Index) then
  begin
    if S1 = S2 then
    begin
      Compare := 0;
      Exit;
    end;

    SortSL.Clear;
    SortSL.Add(S1);
    SortSL.Add(S2);
    // ��������� ������������ �����������
    SortSL.Sort(FNaturalStringComparer);

    Compare := IfThen(SortSL[0] = S1, -1, 1);
  end
  else
    Compare := S1.CompareTo(S2);

end;

procedure TViewBodyTypes.cxGridDBBandedTableView2EditKeyDown
  (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
AEdit: TcxCustomEdit; var Key: Word; Shift: TShiftState);
begin
  inherited;
  DoOnEditKeyDown(Sender, AItem, AEdit, Key, Shift);
end;

procedure TViewBodyTypes.cxGridDBBandedTableView2KeyDown(Sender: TObject;
var Key: Word; Shift: TShiftState);
begin
  inherited;
  DoOnKeyOrMouseDown;
end;

procedure TViewBodyTypes.cxGridDBBandedTableView2MouseDown(Sender: TObject;
Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  DoOnKeyOrMouseDown;
end;

procedure TViewBodyTypes.cxGridDBBandedTableView2StylesGetHeaderStyle
  (Sender: TcxGridTableView; AColumn: TcxGridColumn; var AStyle: TcxStyle);
var
  AIDProducer: TcxGridDBBandedColumn;
  OK: Boolean;
begin
  inherited;
  if AColumn = nil then
    Exit;

  AIDProducer := GetSameColumn(Sender, clIDProducer);

  // ���� �������� ���������� �� �������������
  if (AIDProducer.SortIndex = 0) then
  begin
    OK := AColumn = AIDProducer;
  end
  else
  begin
    // ���� �������� ���������� �� ������������
    OK := (AColumn.SortIndex >= 0) and (SameCol(AColumn, clBody));
  end;

  if OK then
    AStyle := DMRepository.cxHeaderStyle;
end;

procedure TViewBodyTypes.
  cxGridDBBandedTableViewDataControllerSummaryAfterSummary
  (ASender: TcxDataSummary);
var
  AIndex: Integer;
  S: string;
begin
  inherited;

  AIndex := MainView.DataController.Summary.FooterSummaryItems.IndexOfItemLink
    (clBodyKind);

  if AIndex < 0 then
    S := ''
  else
    S := VarToStrDef(MainView.DataController.Summary.FooterSummaryValues
      [AIndex], '---');

  StatusBar.Panels[0].Text := S;
end;

procedure TViewBodyTypes.cxGridDBBandedTableViewDragDrop(Sender,
  Source: TObject; X, Y: Integer);
var
  time: Double;
begin
  inherited;
  // ������ ������ ���� ���������
  Assert(FHRTimer <> nil);
  time := FHRTimer.ReadTimer;
  // ������ ������ �� �����
  FreeAndNil(FHRTimer);

  // ���� ��� ���� ��������� �����������, �� ������ �� ������
  if time < DragDropTimeOut then
    Exit;

  DoDragDrop(Sender as TcxGridSite, FDragAndDropInfo,
    FBodyTypesGroup.qBodyKinds, X, Y);
end;

procedure TViewBodyTypes.cxGridDBBandedTableViewDragOver(Sender,
  Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  inherited;
  DoDragOver(Sender as TcxGridSite, X, Y, Accept);
end;

procedure TViewBodyTypes.cxGridDBBandedTableViewEditKeyDown
  (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
AEdit: TcxCustomEdit; var Key: Word; Shift: TShiftState);
begin
  inherited;;
end;

procedure TViewBodyTypes.cxGridDBBandedTableViewStartDrag(Sender: TObject;
var DragObject: TDragObject);
begin
  inherited;
  DoOnStartDrag(Sender as TcxGridSite, FDragAndDropInfo);

  // ��������� ������ ����� ���������� ����� �������� �������
  FHRTimer := THRTimer.Create(True);

end;

procedure TViewBodyTypes.cxGridDBBandedTableViewStylesGetContentStyle
  (Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
AItem: TcxCustomGridTableItem; var AStyle: TcxStyle);
begin
  inherited;
  if ARecord = nil then
    Exit;
  if AItem = nil then
    Exit; // ��� �������� ���� ������� ������, ���� ����������� ������ ��������
  if not ARecord.IsData then
    Exit;
  { ���� ����� ������� ������ ���� �������, �� ����� ��������� AItem
    if AItem.Index = TcxGridDBTableView(Sender).GetColumnByFieldName('���_�������_��_TDataSet').Index then
    if AItem.Index = dbgApartREGION_NAME.Index then

  }

  if not VarIsNull(ARecord.Values[clColor.Index]) then
  begin
    if not Assigned(AStyle) then
      AStyle := TcxStyle.Create(Sender);
    AStyle.Color := ARecord.Values[clColor.Index]; // ����������� ���
  end;
end;

procedure TViewBodyTypes.DoAfterDataChange(Sender: TObject);
begin
  UpdateView;
end;

function TViewBodyTypes.GetfrmJEDECPopup: TfrmJEDECPopup;
begin
  if FfrmJEDECPopup = nil then
  begin
    FfrmJEDECPopup := TfrmJEDECPopup.Create(Self);
  end;
  Result := FfrmJEDECPopup;
end;

function TViewBodyTypes.GetProducerDisplayText: string;
begin
  Result := GetDBBandedTableView(1).Controller.FocusedRecord.DisplayTexts
    [clIDProducer.Index];
end;

procedure TViewBodyTypes.LoadFromExcel(const AFileName: String;
AProducerID: Integer);
var
  AExcelDMClass: TExcelDMClass;
begin
  if AProducerID > 0 then
    AExcelDMClass := TBodyTypesExcelDM
  else
    AExcelDMClass := TBodyTypesExcelDM2;

  BeginUpdate;
  try
    TLoad.Create.LoadAndProcess(AFileName, AExcelDMClass, TfrmCustomError,
      procedure(ASender: TObject)
      begin
        BodyTypesGroup.LoadDataFromExcelTable(ASender as TBodyTypesExcelTable,
          AProducerID);
      end,
      procedure(ASender: TObject)
      begin
        if ASender is TBodyTypesExcelTable2 then
        begin
          (ASender as TBodyTypesExcelTable2).ProducerInt :=
            BodyTypesGroup.qProducers;
        end;
      end);
  finally
    MainView.ViewData.Collapse(True);
    EndUpdate;
  end;
  UpdateView;
end;

procedure TViewBodyTypes.LocalizeDevExpress;
var
  AFileName: string;
begin
  // ���������� �����������
  AFileName := TPath.Combine(ExtractFilePath(ParamStr(0)),
    sLocalizationFileName);
  if FileExists(AFileName) then
  begin
    cxLocalizer.FileName := AFileName;
    cxLocalizer.Active := True;
    cxLocalizer.Locale := 1049;
  end;
end;

procedure TViewBodyTypes.OnAfterSearchEditEnter(var Message: TMessage);
begin
  inherited;
  cxGrid.SetFocus;
  cxbeiSearch.StyleEdit := nil;
  cxbeiSearch.SetFocus();
end;

procedure TViewBodyTypes.OnGridRecordCellPopupMenu
  (AColumn: TcxGridDBBandedColumn; var AllowPopup: Boolean);
begin
  actAddJEDECFile.Visible := AColumn.DataBinding.FieldName = clJEDEC.
    DataBinding.FieldName;
  actOpenJEDECAll.Visible := actAddJEDECFile.Visible;
  actLoadJEDEC.Visible := actAddJEDECFile.Visible;

  actOpenJEDECAll.Enabled := not BodyTypesGroup.qBodyTypes2.W.JEDEC.F.
    AsString.IsEmpty;
end;

procedure TViewBodyTypes.OpenDoc(ADocFieldInfo: TDocFieldInfo);
var
  AFolders: string;
begin
  Application.Hint := '';
  // ��������� �����, � ������� �� ����� ������ ��� ����
  AFolders := '';
  if not ProducerDisplayText.IsEmpty then
    AFolders := TPath.Combine(ADocFieldInfo.Folder, ProducerDisplayText) + ';';

  AFolders := AFolders + ADocFieldInfo.Folder;

  TDocument.Open(Handle, AFolders, BodyTypesGroup.qBodyTypes2.W.Field
    (ADocFieldInfo.FieldName).AsString, ADocFieldInfo.ErrorMessage,
    ADocFieldInfo.EmptyErrorMessage, sBodyTypesFilesExt);
end;

procedure TViewBodyTypes.Search(ABodyVariation: String);
var
  ACol: TcxGridDBBandedColumn;
  AcxGridMasterDataRow: TcxGridMasterDataRow;
  AMaskEdit: TcxMaskEdit;
  ASelStart: Integer;
  AView: TcxGridDBBandedTableView;
  OK: Boolean;
  S: String;
begin
  // MainView.DataController.DataSource := nil;
  // cxGridDBBandedTableView2.DataController.DataSource := nil;

  OK := BodyTypesGroup.Search(ABodyVariation);

  // MainView.DataController.DataSource := BodyTypesGroup.qBodyKinds.W.DataSource;
  // cxGridDBBandedTableView2.DataController.DataSource :=
  // BodyTypesGroup.qBodyTypes2.W.DataSource;

  if OK then
  begin
    cxGrid.SetFocus;

    AcxGridMasterDataRow := MainView.ViewData.Rows
      [MainView.Controller.FocusedRowIndex] as TcxGridMasterDataRow;

    AcxGridMasterDataRow.Expand(True);
    if AcxGridMasterDataRow.ActiveDetailGridView <> nil then
    begin
      AView := AcxGridMasterDataRow.ActiveDetailGridView as
        TcxGridDBBandedTableView;
      AView.Focused := True;

      PutInTheCenterFocusedRecord(AView);

      ACol := AView.GetColumnByFieldName
        (BodyTypesGroup.qBodyTypes2.W.Variations.FieldName);

      S := VarToStrDef(AView.Controller.FocusedRow.Values[ACol.Index],
        '').ToUpper;

      ASelStart := S.IndexOf(ABodyVariation.ToUpper);
      if ASelStart >= 0 then
      begin
        AView.Site.SetFocus(); // ����� ������������� �����������
        AView.Controller.EditingController.ShowEdit(ACol);
        if AView.Controller.EditingController.Edit <> nil then
        begin
          AMaskEdit := AView.Controller.EditingController.Edit as TcxMaskEdit;
          AMaskEdit.SetSelection(ASelStart, ABodyVariation.Length);
          AMaskEdit.Properties.ReadOnly := True;
        end;
      end;
    end;
  end;

  if not OK then
    cxbeiSearch.StyleEdit := RepositoryDataModule.DMRepository.cxStyleNotFound
  else
    cxbeiSearch.StyleEdit := nil;
end;

procedure TViewBodyTypes.SetBodyTypesGroup(const Value: TBodyTypesGroup2);
begin
  if FBodyTypesGroup <> Value then
  begin
    FBodyTypesGroup := Value;
    if FBodyTypesGroup <> nil then
    begin
      MainView.DataController.DataSource :=
        FBodyTypesGroup.qBodyKinds.W.DataSource;
      cxGridDBBandedTableView2.DataController.DataSource :=
        FBodyTypesGroup.qBodyTypes2.W.DataSource;

      InitializeLookupColumn(clIDBodyKind,
        FBodyTypesGroup.qBodyKinds.W.DataSource, lsEditFixedList,
        FBodyTypesGroup.qBodyKinds.W.BodyKind.FieldName);

      FBodyTypesGroup.qProducers.W.RefreshQuery;

      InitializeLookupColumn(clIDProducer,
        FBodyTypesGroup.qProducers.W.DataSource, lsEditFixedList,
        FBodyTypesGroup.qProducers.W.Name.F.FieldName);

      TNotifyEventWrap.Create(FBodyTypesGroup.qBodyKinds.W.AfterOpen,
        DoAfterDataChange, FEventList);
      TNotifyEventWrap.Create(FBodyTypesGroup.qBodyTypes2.W.AfterOpen,
        DoAfterDataChange, FEventList);

      // ������ ������� �������� ��� �� ��������� � ��
      TNotifyEventWrap.Create
        (FBodyTypesGroup.qBodyKinds.Monitor.OnHaveAnyChanges, DoAfterDataChange,
        FEventList);

      MainView.ViewData.Collapse(True);
      ApplySort(cxGridDBBandedTableView2, clBody);
    end
    else
    begin
      MainView.DataController.DataSource := nil;
    end;

    UpdateView;
  end;
end;

procedure TViewBodyTypes.UpdateTotalCount;
begin
  // ����� ����� ����������� �� � ��
  StatusBar.Panels[StatusBar.Panels.Count - 1].Text :=
    Format('�����: %d', [BodyTypesGroup.qBodyTypes2.FDQuery.RecordCount]);
end;

procedure TViewBodyTypes.UpdateView;
var
  AView: TcxGridDBBandedTableView;
  OK: Boolean;
begin
  OK := (BodyTypesGroup <> nil) and (BodyTypesGroup.Active);

  AView := FocusedTableView;

  actAdd.Enabled := OK and (AView <> nil) and (AView.Level = cxGridLevel);

  actAddBody.Enabled := OK and (AView <> nil) and
    (((AView.Level = cxGridLevel) and (AView.DataController.RowCount > 0)) or
    (AView.Level = cxGridLevel2));

  // ������� ��������� ������ ���� ���-�� ��������
  actDeleteEx.Enabled := OK and (AView <> nil) and
    (AView.Controller.SelectedRowCount > 0);

  actLoadFromExcelDocument.Enabled := OK;

  actExportToExcelDocument.Enabled := OK and
    (MainView.DataController.RowCount > 0);

  actShowDuplicate.Enabled := OK and ((MainView.DataController.RowCount > 0) or
    actShowDuplicate.Checked);

  actCommit.Enabled := OK and (BodyTypesGroup.HaveAnyChanges);

  actRollback.Enabled := actCommit.Enabled;

  UpdateTotalCount;

  if actShowDuplicate.Checked then
    actShowDuplicate.Caption := '�������� ��'
  else
    actShowDuplicate.Caption := '�������� ���������';

  actColor.Enabled := OK and (AView.Level = cxGridLevel) and
    (AView.Controller.SelectedRowCount > 0);
end;

procedure TViewBodyTypes.UploadDoc(ADocFieldInfo: TDocFieldInfo);
var
  AProducer: string;
  S: String;
  sourceFileName: string;
begin
  Application.Hint := '';
  Assert(BodyTypesGroup <> nil);
  S := BodyTypesGroup.qBodyTypes2.W.Field(ADocFieldInfo.FieldName).AsString;

  // ���� ������ ������ � �������� = �������������
  AProducer := ProducerDisplayText;

  // ���� ���� ������������ ����� ��� ��� �����
  if S <> '' then
  begin
    // ��������� � �������� �������� �������������
    S := TPath.Combine(ADocFieldInfo.Folder, AProducer);
    // �������� ����� � ������� ����� ����� �������� ���� ������������
    // S := TPath.GetDirectoryName(S);
    // ���� ������ ���� ��� �� ����������
    if not TDirectory.Exists(S) then
      S := ADocFieldInfo.Folder;
  end
  else
    S := ADocFieldInfo.Folder;

  // ��������� ������ ������ ����� ��� ��������
  if not TDialog.Create.ShowDialog(TMyOpenPictureDialog, S, '', sourceFileName)
  then
    Exit;

  BodyTypesGroup.qBodyTypes2.LoadDocFile(sourceFileName, ADocFieldInfo);
  MyApplyBestFitForView(cxGridDBBandedTableView2);
end;

procedure TViewBodyTypes.UploadJEDEC(Add: Boolean);
var
  // AProducer: string;
  S: String;
  AFileName: string;
begin
  Application.Hint := '';
  Assert(BodyTypesGroup <> nil);

  // ���� ������ ������ � �������� = �������������
  // AProducer := ProducerDisplayText;

  S := TSettings.Create.BodyTypesJEDECFolder;

  // ��������� ������ ������ ����� ��� ��������
  if not TDialog.Create.ShowDialog(TMyOpenPictureDialog, S, '', AFileName) then
    Exit;

  BodyTypesGroup.qBodyTypes2.LoadJEDEC(AFileName, Add);
  ApplyBestFitJEDEC;
end;

end.
