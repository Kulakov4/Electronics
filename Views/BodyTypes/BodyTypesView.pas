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
  BodyTypesGroupUnit, DragHelper, HRTimer, cxContainer, cxTextEdit, cxDBEdit,
  Vcl.Grids, Vcl.DBGrids, System.Generics.Collections, GridSort,
  CustomErrorForm, NaturalSort, DocFieldInfo;

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
    procedure actAddBodyExecute(Sender: TObject);
    procedure actAddExecute(Sender: TObject);
    procedure actCommitExecute(Sender: TObject);
    procedure actExportToExcelDocumentExecute(Sender: TObject);
    procedure actLoadFromExcelDocumentExecute(Sender: TObject);
    procedure actLoadImageExecute(Sender: TObject);
    procedure actLoadLandPatternExecute(Sender: TObject);
    procedure actLoadOutlineDrawingExecute(Sender: TObject);
    procedure actOpenImageExecute(Sender: TObject);
    procedure actOpenLandPatternExecute(Sender: TObject);
    procedure actRollbackExecute(Sender: TObject);
    procedure actSettingsExecute(Sender: TObject);
    procedure actOpenOutlineDrawingExecute(Sender: TObject);
    procedure actShowDuplicateExecute(Sender: TObject);
    procedure clOutlineDrawingGetDataText(Sender: TcxCustomGridTableItem;
      ARecordIndex: Integer; var AText: string);
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
    procedure cxGridDBBandedTableViewDataControllerDetailExpanded
      (ADataController: TcxCustomDataController; ARecordIndex: Integer);
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
  private
    FBodyTypesGroup: TBodyTypesGroup;
    FDragAndDropInfo: TDragAndDropInfo;
    FHRTimer: THRTimer;
    FNaturalStringComparer: TNaturalStringComparer;
    procedure DoAfterDataChange(Sender: TObject);
    function GetProducerDisplayText: string;
    procedure SetBodyTypesGroup(const Value: TBodyTypesGroup);
    procedure UpdateTotalCount;
    { Private declarations }
  protected
    procedure CreateColumnsBarButtons; override;
    function GetFocusedTableView: TcxGridDBBandedTableView; override;
    procedure OpenDoc(ADocFieldInfo: TDocFieldInfo);
    procedure UploadDoc(ADocFieldInfo: TDocFieldInfo);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure UpdateView; override;
    property BodyTypesGroup: TBodyTypesGroup read FBodyTypesGroup
      write SetBodyTypesGroup;
    property ProducerDisplayText: string read GetProducerDisplayText;
    { Public declarations }
  end;

implementation

uses BodyTypesExcelDataModule, ImportErrorForm, DialogUnit,
  RepositoryDataModule, NotifyEvents, ColumnsBarButtonsHelper, CustomExcelTable,
  OpenDocumentUnit, ProjectConst, SettingsController, PathSettingsForm,
  System.Math, System.IOUtils, ProgressBarForm, DialogUnit2,
  BodyTypesSimpleQuery, ProducersForm, dxCore, LoadFromExcelFileHelper;

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

  DeleteMessages.Add(cxGridLevel, 'Удалить тип корпуса?');
  DeleteMessages.Add(cxGridLevel2, 'Удалить корпус?');
end;

destructor TViewBodyTypes.Destroy;
begin
  FreeAndNil(FDragAndDropInfo);
  inherited;
end;

procedure TViewBodyTypes.actAddBodyExecute(Sender: TObject);
var
  ARow: TcxGridMasterDataRow;
  AView: TcxGridDBBandedTableView;
begin
  // Сначала сохраняем вид корпуса
  BodyTypesGroup.qBodyKinds.TryPost;

  ARow := GetRow(0) as TcxGridMasterDataRow;
  ARow.Expand(false);
  AView := GetDBBandedTableView(1);
  AView.Controller.ClearSelection;
  AView.DataController.Append;
  FocusColumnEditor(1, clBody.DataBinding.FieldName);

  UpdateView;

end;

procedure TViewBodyTypes.actAddExecute(Sender: TObject);
begin
  MainView.DataController.Append;
  FocusColumnEditor(0, clBody.DataBinding.FieldName);

  UpdateView;

end;

procedure TViewBodyTypes.actCommitExecute(Sender: TObject);
begin
  // Мы просто завершаем транзакцию
  //cxGrid.BeginUpdate();
  // try
  // Сохраняем изменения и завершаем транзакцию
  BodyTypesGroup.Commit;

  // Начинаем новую транзакцию
  // BodyTypesGroup.Connection.StartTransaction;

  // Переносим фокус на первую выделенную запись
  // FocusSelectedRecord(MainView);
  // finally
  // cxGrid.EndUpdate;
  // end;

  // Помещаем фокус в центр грида
  // PutInTheCenterFocusedRecord(MainView);

  // Обновляем представление
  UpdateView;
end;

procedure TViewBodyTypes.actExportToExcelDocumentExecute(Sender: TObject);
var
  AFileName: String;
  Q: TQueryBodyTypesSimple;
begin
  Q := TQueryBodyTypesSimple.Create(Self);
  try
    Q.RefreshQuery;

    cxGridDBBandedTableView2.DataController.DataSource := Q.DataSource;
    try
      if not TDialog.Create.ShowDialog(TExcelFileSaveDialog, '',
        'Типы корпусов', AFileName) then
        Exit;

      ExportViewToExcel(cxGridDBBandedTableView2, AFileName,
        procedure(AView: TcxGridDBBandedTableView)
        begin
          AView.GetColumnByFieldName(clVariations.DataBinding.FieldName).Caption
            := 'Вариант корпуса';
          AView.GetColumnByFieldName(clIDBodyKind.DataBinding.FieldName)
            .Visible := True;
          AView.GetColumnByFieldName(clIDBodyKind.DataBinding.FieldName)
            .Options.CellMerging := True;
          AView.ApplyBestFit();
        end);
    finally
      cxGridDBBandedTableView2.DataController.DataSource :=
        BodyTypesGroup.qBodyTypes2.DataSource;
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
  // OK: Boolean;
begin
  // Выбираем производителя
  if not TfrmProducers.TakeProducer(AProducerID, AProducer) then
    Exit;

  if not TOpenExcelDialog.SelectInLastFolder(AFileName, Handle) then
    Exit;

  BeginUpdate;
  try
    TLoad.Create.LoadAndProcess(AFileName, TBodyTypesExcelDM, TfrmCustomError,
      procedure(ASender: TObject)
      begin
        BodyTypesGroup.LoadDataFromExcelTable(ASender as TBodyTypesExcelTable,
          AProducerID);
      end);
  finally
    MainView.ViewData.Collapse(True);
    EndUpdate;
  end;
  UpdateView;
end;

procedure TViewBodyTypes.actLoadImageExecute(Sender: TObject);
begin
  inherited;
  UploadDoc(TBodyTypeImageDoc.Create);
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

procedure TViewBodyTypes.actOpenLandPatternExecute(Sender: TObject);
begin
  inherited;
  OpenDoc(TLandPattern.Create);
end;

procedure TViewBodyTypes.actRollbackExecute(Sender: TObject);
begin
  cxGrid.BeginUpdate();
  try
    // Отменяем все сделанные изменения
    BodyTypesGroup.Rollback;

    MainView.ViewData.Collapse(True);
  finally
    cxGrid.EndUpdate;
  end;

  // Обновляем представление
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

procedure TViewBodyTypes.actShowDuplicateExecute(Sender: TObject);
var
  d: Boolean;
begin
  d := not BodyTypesGroup.qBodyTypes2.ShowDuplicate;
  cxGrid.BeginUpdate();
  try
    BodyTypesGroup.qBodyTypes2.TryPost;
    BodyTypesGroup.qBodyKinds.TryPost;

    BodyTypesGroup.qBodyTypes2.ShowDuplicate := d;
    BodyTypesGroup.qBodyKinds.ShowDuplicate := d;

    // Переносим фокус на первую выделенную запись
    FocusSelectedRecord();
  finally
    cxGrid.EndUpdate;
  end;

  actShowDuplicate.Checked := d;

  // Помещаем фокус в центр грида
  PutInTheCenterFocusedRecord();

  // Обновляем представление
  UpdateView;

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
/// /// Загружаем все возможные варианты корпуса для открытого типа корпуса
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
/// / Загружаем все возможные варианты корпуса для открытого типа корпуса
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
    // Сортируем естественной сортировкой
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
  PostMessage(Handle, WM_AfterKeyOrMouseDown, 0, 0);
  DoOnEditKeyDown(Sender, AItem, AEdit, Key, Shift);
end;

procedure TViewBodyTypes.cxGridDBBandedTableView2KeyDown(Sender: TObject;
var Key: Word; Shift: TShiftState);
begin
  inherited;
  PostMessage(Handle, WM_AfterKeyOrMouseDown, 0, 0);
end;

procedure TViewBodyTypes.cxGridDBBandedTableView2MouseDown(Sender: TObject;
Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  PostMessage(Handle, WM_AfterKeyOrMouseDown, 0, 0);
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

  // если включена сортировка по производителю
  if (AIDProducer.SortIndex = 0) then
  begin
    OK := AColumn = AIDProducer;
  end
  else
  begin
    // если включена сортировка по наименованию
    OK := (AColumn.SortIndex >= 0) and (SameCol(AColumn, clBody));
  end;

  if OK then
    AStyle := DMRepository.cxHeaderStyle;
end;

procedure TViewBodyTypes.cxGridDBBandedTableViewDataControllerDetailExpanded
  (ADataController: TcxCustomDataController; ARecordIndex: Integer);
var
  AcxGridMasterDataRow: TcxGridMasterDataRow;
begin
  if ARecordIndex < 0 then
    Exit;

  AcxGridMasterDataRow := cxGridDBBandedTableView.ViewData.Records[ARecordIndex]
    as TcxGridMasterDataRow;
  (AcxGridMasterDataRow.ActiveDetailGridView as TcxGridDBBandedTableView)
    .ApplyBestFit();

  ChooseTopRecord(MainView, ARecordIndex);
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
  // Таймер должны были запустить
  Assert(FHRTimer <> nil);
  time := FHRTimer.ReadTimer;
  // Таймер больше не нужен
  FreeAndNil(FHRTimer);

  // Если это было случайное перемещение, то ничего не делаем
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

  // Запускаем таймер чтобы рассчитать время переноса записей
  FHRTimer := THRTimer.Create(True);

end;

procedure TViewBodyTypes.DoAfterDataChange(Sender: TObject);
begin
  UpdateView;
end;

function TViewBodyTypes.GetFocusedTableView: TcxGridDBBandedTableView;
begin
  Result := inherited;

  // Если не первый уровень в фокусе
  if (Result = nil) then
  begin
    Result := GetDBBandedTableView(1);
    if (Result <> nil) and (not Result.Focused) then
      Result := nil;
  end;
end;

function TViewBodyTypes.GetProducerDisplayText: string;
begin
  Result := GetDBBandedTableView(1).Controller.FocusedRecord.DisplayTexts
    [clIDProducer.Index];
end;

procedure TViewBodyTypes.OpenDoc(ADocFieldInfo: TDocFieldInfo);
var
  AFolders: string;
begin
  Application.Hint := '';
  // Формируем папки, в которых мы будем искать наш файл
  AFolders := '';
  if not ProducerDisplayText.IsEmpty then
    AFolders := TPath.Combine(ADocFieldInfo.Folder, ProducerDisplayText) + ';';

  AFolders := AFolders + ADocFieldInfo.Folder;

  TDocument.Open(Handle, AFolders,
    BodyTypesGroup.qBodyTypes2.Field(ADocFieldInfo.FieldName).AsString,
    ADocFieldInfo.ErrorMessage, ADocFieldInfo.EmptyErrorMessage,
    sBodyTypesFilesExt);
end;

procedure TViewBodyTypes.SetBodyTypesGroup(const Value: TBodyTypesGroup);
begin
  if FBodyTypesGroup <> Value then
  begin
    FBodyTypesGroup := Value;
    if FBodyTypesGroup <> nil then
    begin
      MainView.DataController.DataSource :=
        FBodyTypesGroup.qBodyKinds.DataSource;
      cxGridDBBandedTableView2.DataController.DataSource :=
        FBodyTypesGroup.qBodyTypes2.DataSource;

      InitializeLookupColumn(clIDBodyKind,
        FBodyTypesGroup.qBodyKinds.DataSource, lsEditFixedList,
        FBodyTypesGroup.qBodyKinds.BodyKind.FieldName);

      FBodyTypesGroup.qProducers.RefreshQuery;

      InitializeLookupColumn(clIDProducer,
        FBodyTypesGroup.qProducers.DataSource, lsEditFixedList,
        FBodyTypesGroup.qProducers.Name.FieldName);

      TNotifyEventWrap.Create(FBodyTypesGroup.qBodyKinds.AfterOpen,
        DoAfterDataChange, FEventList);
      TNotifyEventWrap.Create(FBodyTypesGroup.qBodyTypes2.AfterOpen,
        DoAfterDataChange, FEventList);
      TNotifyEventWrap.Create(FBodyTypesGroup.AfterDataChange,
        DoAfterDataChange, FEventList);

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
  // Общее число компонентов на в БД
  StatusBar.Panels[StatusBar.Panels.Count - 1].Text :=
    Format('Всего: %d', [BodyTypesGroup.qBodyTypes2.FDQuery.RecordCount]);
end;

procedure TViewBodyTypes.UpdateView;
var
  AView: TcxGridDBBandedTableView;
begin
  AView := FocusedTableView;

  actAdd.Enabled := (BodyTypesGroup <> nil) and
    (BodyTypesGroup.qBodyKinds.FDQuery.Active) and (AView <> nil) and
    (AView.Level = cxGridLevel);

  actAddBody.Enabled := (BodyTypesGroup <> nil) and
    (BodyTypesGroup.qBodyTypes2.FDQuery.Active) and (AView <> nil) and
    (((AView.Level = cxGridLevel) and (AView.DataController.RecordCount > 0)) or
    (AView.Level = cxGridLevel2));

  // Удалять разрешаем только если что-то выделено
  actDeleteEx.Enabled := (BodyTypesGroup <> nil) and (AView <> nil) and
    (AView.Controller.SelectedRowCount > 0);

  actLoadFromExcelDocument.Enabled := (BodyTypesGroup <> nil);

  actExportToExcelDocument.Enabled := (BodyTypesGroup <> nil) and
    (BodyTypesGroup.qBodyTypes2.FDQuery.RecordCount > 0);

  actCommit.Enabled := (BodyTypesGroup <> nil) and
    (BodyTypesGroup.Connection.InTransaction);

  actRollback.Enabled := actCommit.Enabled;

  UpdateTotalCount;

  if actShowDuplicate.Checked then
    actShowDuplicate.Caption := 'Показать всё'
  else
    actShowDuplicate.Caption := 'Показать дубликаты';

end;

procedure TViewBodyTypes.UploadDoc(ADocFieldInfo: TDocFieldInfo);
var
  AProducer: string;
  S: String;
  sourceFileName: string;
begin
  Application.Hint := '';
  Assert(BodyTypesGroup <> nil);
  S := BodyTypesGroup.qBodyTypes2.Field(ADocFieldInfo.FieldName).AsString;

  // Файл должен лежать в каталоге = производителю
  AProducer := ProducerDisplayText;

  // Если файл документации ранее был уже задан
  if S <> '' then
  begin
    // Добавляем к каталогу название производителя
    S := TPath.Combine(ADocFieldInfo.Folder, AProducer);
    // Получаем папку в которой лежит ранее заданный файл документации
    // S := TPath.GetDirectoryName(S);
    // если такого пути уже не существует
    if not TDirectory.Exists(S) then
      S := ADocFieldInfo.Folder;
  end
  else
    S := ADocFieldInfo.Folder;

  // Открываем диалог выбора файла для загрузки
  if not TDialog.Create.ShowDialog(TMyOpenPictureDialog, S, '', sourceFileName)
  then
    Exit;

  BodyTypesGroup.qBodyTypes2.LoadDocFile(sourceFileName, ADocFieldInfo);
  MyApplyBestFit;
end;

end.
