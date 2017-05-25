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
  Vcl.Grids, Vcl.DBGrids;

type
  TViewBodyTypes = class(TfrmGrid)
    actAdd: TAction;
    actDelete: TAction;
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
    procedure actAddBodyExecute(Sender: TObject);
    procedure actAddExecute(Sender: TObject);
    procedure actCommitExecute(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure actExportToExcelDocumentExecute(Sender: TObject);
    procedure actLoadFromExcelDocumentExecute(Sender: TObject);
    procedure actOpenImageExecute(Sender: TObject);
    procedure actOpenLandPatternExecute(Sender: TObject);
    procedure actRollbackExecute(Sender: TObject);
    procedure actSettingsExecute(Sender: TObject);
    procedure actOpenOutlineDrawingExecute(Sender: TObject);
    procedure clOutlineDrawingGetDataText(Sender: TcxCustomGridTableItem;
        ARecordIndex: Integer; var AText: string);
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
  private
    FBodyTypesGroup: TBodyTypesGroup;
    FDragAndDropInfo: TDragAndDropInfo;
    FHRTimer: THRTimer;
    procedure DoAfterDataChange(Sender: TObject);
    procedure SetBodyTypesGroup(const Value: TBodyTypesGroup);
    procedure UpdateTotalCount;
    { Private declarations }
  protected
    procedure CreateColumnsBarButtons; override;
    function GetFocusedTableView: TcxGridDBBandedTableView; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure UpdateView; override;
    property BodyTypesGroup: TBodyTypesGroup read FBodyTypesGroup
      write SetBodyTypesGroup;
    { Public declarations }
  end;

implementation

uses BodyTypesExcelDataModule, ImportErrorForm, DialogUnit,
  RepositoryDataModule, NotifyEvents, ColumnsBarButtonsHelper, CustomExcelTable,
  OpenDocumentUnit, ProjectConst, SettingsController, PathSettingsForm,
  System.Math, System.IOUtils, ProgressBarForm, ErrorForm, DialogUnit2,
  BodyTypesSimpleQuery, ProducersForm;

{$R *.dfm}

constructor TViewBodyTypes.Create(AOwner: TComponent);
begin
  inherited;
  StatusBarEmptyPanelIndex := 1;

  FDragAndDropInfo := TDragAndDropInfo.Create(clID, clOrd);

  PostOnEnterFields.Add(clBodyKind.DataBinding.FieldName);
  PostOnEnterFields.Add(clBody.DataBinding.FieldName);
  PostOnEnterFields.Add(clBodyData.DataBinding.FieldName);
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
  cxGrid.BeginUpdate();
  try
    // Сохраняем изменения и завершаем транзакцию
    BodyTypesGroup.Commit;

    // Начинаем новую транзакцию
    // BodyTypesGroup.Connection.StartTransaction;

    // Переносим фокус на первую выделенную запись
    FocusSelectedRecord(MainView);
  finally
    cxGrid.EndUpdate;
  end;

  // Помещаем фокус в центр грида
  PutInTheCenterFocusedRecord(MainView);

  // Обновляем представление
  UpdateView;
end;

procedure TViewBodyTypes.actDeleteExecute(Sender: TObject);
var
  AView: TcxGridDBBandedTableView;
  S: string;
begin
  AView := FocusedTableView;
  if AView = nil then
    Exit;

  S := '';
  if AView.Level = cxGridLevel then
    S := 'Удалить тип корпуса';

  if AView.Level = cxGridLevel2 then
    S := 'Удалить корпус';

  if (S <> '') and (TDialog.Create.DeleteRecordsDialog(S)) and
    (AView.DataController.RecordCount > 0) then
  begin
    if AView.Controller.SelectedRowCount > 0 then
      AView.DataController.DeleteSelection
    else
      AView.DataController.DeleteFocused;

    if (AView.DataController.RecordCount = 0) and (AView.MasterGridRecord <> nil)
    then
    begin
      AView.MasterGridRecord.Collapse(false);
    end;

  end;

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

      AFileName := 'Типы корпусов';
      AFileName := TDialog.Create.SaveToExcelFile(AFileName);
      if AFileName = '' then
        Exit;

      // clIDBodyKind.Visible := True;
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
  ABodyTypesExcelDM: TBodyTypesExcelDM;
  AFileName: string;
  AfrmError: TfrmError;
  AProducer: string;
  AProducerID: Integer;
  OK: Boolean;
begin
  // Выбираем производителя
  if not TfrmProducers.TakeProducer(AProducerID, AProducer) then
    Exit;

  if not TOpenExcelDialog.SelectInLastFolder(AFileName) then
    Exit;

  ABodyTypesExcelDM := TBodyTypesExcelDM.Create(Self);
  try
    // ABodyTypesExcelDM.ExcelTable.BodyVariationsDataSet :=
    // BodyTypesGroup.qBodyTypes2.FDQuery;

    TfrmProgressBar.Process(ABodyTypesExcelDM,
      procedure
      begin
        ABodyTypesExcelDM.LoadExcelFile(AFileName);
      end, 'Загрузка корпусных данных', sRows);

    OK := ABodyTypesExcelDM.ExcelTable.Errors.RecordCount = 0;

    // Если в ходе загрузки данных произошли ошибки (поле не заполнено)
    if not OK then
    begin
      AfrmError := TfrmError.Create(Self);
      try
        AfrmError.ErrorTable := ABodyTypesExcelDM.ExcelTable.Errors;
        // Показываем ошибки
        OK := AfrmError.ShowModal = mrOk;
        ABodyTypesExcelDM.ExcelTable.ExcludeErrors(etError);
      finally
        FreeAndNil(AfrmError);
      end;
    end;

    if OK then
    begin
      cxGrid.BeginUpdate;
      try
        TfrmProgressBar.Process(ABodyTypesExcelDM.ExcelTable,
          procedure
          begin
            BodyTypesGroup.InsertRecordList(ABodyTypesExcelDM.ExcelTable, AProducerID);
          end, 'Сохранение корпусных данных в БД', sRecords);
      finally
        MainView.ViewData.Collapse(True);
        cxGrid.EndUpdate;
      end;
    end;
  finally
    FreeAndNil(ABodyTypesExcelDM);
  end;

  UpdateView;
end;

procedure TViewBodyTypes.actOpenImageExecute(Sender: TObject);
begin
  inherited;
  TDocument.Open(Handle, TSettings.Create.BodyTypesImageFolder,
    BodyTypesGroup.qBodyTypes2.Image.AsString,
    'Файл %s не найден', 'Изображение не задано', sBodyTypesFilesExt);
end;

procedure TViewBodyTypes.actOpenLandPatternExecute(Sender: TObject);
begin
  inherited;
  TDocument.Open(Handle, TSettings.Create.BodyTypesLandPatternFolder,
    BodyTypesGroup.qBodyTypes2.LandPattern.AsString,
    'Файл %s не найден','Чертёж посадочной площадки не задан', sBodyTypesFilesExt);
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
  TDocument.Open(Handle, TSettings.Create.BodyTypesOutlineDrawingFolder,
    BodyTypesGroup.qBodyTypes2.OutlineDrawing.AsString,
    'Файл %s не найден', 'Чертёж корпуса не задан', sBodyTypesFilesExt);
end;

procedure TViewBodyTypes.clOutlineDrawingGetDataText(Sender:
    TcxCustomGridTableItem; ARecordIndex: Integer; var AText: string);
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
  FColumnsBarButtons := TColumnsBarButtons.Create(Self,
    dxbrsbtmColumnsCustomization, cxGridDBBandedTableView2);
end;

procedure TViewBodyTypes.cxGridDBBandedTableView2EditKeyDown
  (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
AEdit: TcxCustomEdit; var Key: Word; Shift: TShiftState);
begin
  inherited;
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
end;

procedure TViewBodyTypes.
  cxGridDBBandedTableViewDataControllerSummaryAfterSummary
  (ASender: TcxDataSummary);
var
  AIndex: Integer;
  S: string;
begin
  inherited;

  AIndex := MainView.DataController.Summary.FooterSummaryItems.
    IndexOfItemLink(clBodyKind);

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

  actDelete.Enabled := (BodyTypesGroup <> nil) and (AView <> nil) and
    (AView.DataController.RecordCount > 0);

  actLoadFromExcelDocument.Enabled := (BodyTypesGroup <> nil);

  actExportToExcelDocument.Enabled := (BodyTypesGroup <> nil) and
    (BodyTypesGroup.qBodyTypes2.FDQuery.RecordCount > 0);

  actCommit.Enabled := (BodyTypesGroup <> nil) and
    (BodyTypesGroup.Connection.InTransaction);

  actRollback.Enabled := actCommit.Enabled;

  UpdateTotalCount;
end;

end.
