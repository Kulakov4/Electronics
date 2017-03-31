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
  BodyTypesGroupUnit;

type
  TViewBodyTypes = class(TfrmGrid)
    actAdd: TAction;
    actDelete: TAction;
    clID: TcxGridDBBandedColumn;
    clBodyType: TcxGridDBBandedColumn;
    dxbbAdd: TdxBarButton;
    dxbbDelete: TdxBarButton;
    cxGridLevel2: TcxGridLevel;
    cxGridDBBandedTableView2: TcxGridDBBandedTableView;
    clID1: TcxGridDBBandedColumn;
    actAddBody: TAction;
    dxbbAddBody: TdxBarButton;
    clIDParentBodyType1: TcxGridDBBandedColumn;
    clID2: TcxGridDBBandedColumn;
    clIDParentBodyType2: TcxGridDBBandedColumn;
    actLoadFromExcelDocument: TAction;
    dxbrsbtmExportImport: TdxBarSubItem;
    dxbbLoadFromExcelDocument: TdxBarButton;
    actExportToExcelDocument: TAction;
    dxbrbtnExport: TdxBarButton;
    clID3: TcxGridDBBandedColumn;
    actCommit: TAction;
    actRollback: TAction;
    dxbrbtnCommit: TdxBarButton;
    dxbrbtnRollback: TdxBarButton;
    clIDBodyType: TcxGridDBBandedColumn;
    clOutlineDrawing: TcxGridDBBandedColumn;
    clLandPattern: TcxGridDBBandedColumn;
    clVariation: TcxGridDBBandedColumn;
    clImage: TcxGridDBBandedColumn;
    clBodyType1: TcxGridDBBandedColumn;
    clBodyType2: TcxGridDBBandedColumn;
    dxBarButton1: TdxBarButton;
    actSettings: TAction;
    procedure actAddBodyExecute(Sender: TObject);
    procedure actAddExecute(Sender: TObject);
    procedure actCommitExecute(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure actExportToExcelDocumentExecute(Sender: TObject);
    procedure actLoadFromExcelDocumentExecute(Sender: TObject);
    procedure actRollbackExecute(Sender: TObject);
    procedure actSettingsExecute(Sender: TObject);
    procedure cxGridDBBandedTableView2EditKeyDown
      (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
      AEdit: TcxCustomEdit; var Key: Word; Shift: TShiftState);
    procedure cxGridDBBandedTableViewEditKeyDown(Sender: TcxCustomGridTableView;
      AItem: TcxCustomGridTableItem; AEdit: TcxCustomEdit; var Key: Word;
      Shift: TShiftState);
    procedure StatusBarResize(Sender: TObject);
    procedure cxGridDBBandedTableViewDataControllerSummaryAfterSummary
      (ASender: TcxDataSummary);
    procedure clBodyType1PropertiesInitPopup(Sender: TObject);
    procedure clBodyType2PropertiesInitPopup(Sender: TObject);
    procedure clImagePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure clLandPatternPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure clOutlineDrawingPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
  private
    FBodyTypesGroup: TBodyTypesGroup;
    procedure DoAfterDataChange(Sender: TObject);
    procedure SetBodyTypesGroup(const Value: TBodyTypesGroup);
    procedure UpdateTotalCount;
    { Private declarations }
  protected
    procedure CreateColumnsBarButtons; override;
    function GetFocusedTableView: TcxGridDBBandedTableView; override;
  public
    procedure UpdateView; override;
    property BodyTypesGroup: TBodyTypesGroup read FBodyTypesGroup write
        SetBodyTypesGroup;
    { Public declarations }
  end;

implementation

uses BodyTypesExcelDataModule3, ImportErrorForm, DialogUnit,
  RepositoryDataModule, NotifyEvents, ColumnsBarButtonsHelper, CustomExcelTable,
  OpenDocumentUnit, ProjectConst, SettingsController, PathSettingsForm,
  System.Math, System.IOUtils, ProgressBarForm;

{$R *.dfm}

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
  FocusColumnEditor(1, clBodyType.DataBinding.FieldName);

  UpdateView;

end;

procedure TViewBodyTypes.actAddExecute(Sender: TObject);
begin
  MainView.DataController.Append;
  FocusColumnEditor(0, clBodyType.DataBinding.FieldName);

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
begin
  AFileName := 'Типы корпусов';
  AFileName := TDialog.Create.SaveToExcelFile(AFileName);
  if AFileName = '' then
    Exit;

  clIDParentBodyType1.Visible := True;
  ExportViewToExcel(cxGridDBBandedTableView2, AFileName);
  clIDParentBodyType1.Visible := false;
end;

procedure TViewBodyTypes.actLoadFromExcelDocumentExecute(Sender: TObject);
var
  ABodyTypesExcelDM: TBodyTypesExcelDM3;
  AFileName: string;
  AfrmImportError: TfrmImportError;
  OK: Boolean;
begin
  AFileName := TDialog.Create.OpenExcelFile
    (TSettings.Create.LastFolderForExcelFile);

  if AFileName.IsEmpty then
    Exit; // отказались от выбора файла

  // Сохраняем эту папку в настройках
  TSettings.Create.LastFolderForExcelFile := TPath.GetDirectoryName(AFileName);

  ABodyTypesExcelDM := TBodyTypesExcelDM3.Create(Self);
  try
    ABodyTypesExcelDM.ExcelTable.BodyVariationsDataSet :=
      BodyTypesGroup.qBodyTypes2.FDQuery;

    TfrmProgressBar.Process(ABodyTypesExcelDM,
      procedure
      begin
        ABodyTypesExcelDM.LoadExcelFile(AFileName);
      end, 'Загрузка корпусных данных', sRows);

    OK := ABodyTypesExcelDM.ExcelTable.Errors.RecordCount = 0;

    if not OK then
    begin
      AfrmImportError := TfrmImportError.Create(Self);
      try
        AfrmImportError.ErrorTable := ABodyTypesExcelDM.ExcelTable.Errors;
        OK := AfrmImportError.ShowModal = mrOk;
        if OK then
        begin
          if AfrmImportError.ContinueType = ctSkip then
          begin
            // Убираем записи с ошибками и предупреждениями
            ABodyTypesExcelDM.ExcelTable.ExcludeErrors(etWarring);
          end
          else
          begin
            // Убираем все записи с ошибками
            ABodyTypesExcelDM.ExcelTable.ExcludeErrors(etError);
          end;
        end;
      finally
        FreeAndNil(AfrmImportError);
      end;
    end;

    if OK then
    begin
      cxGrid.BeginUpdate;
      try
        TfrmProgressBar.Process(ABodyTypesExcelDM.ExcelTable,
          procedure
          begin
            BodyTypesGroup.InsertRecordList
              (ABodyTypesExcelDM.ExcelTable);
          end, 'Сохранение корпусных данных в БД', sRecords);
      finally
        cxGrid.EndUpdate;
      end;
    end;
  finally
    FreeAndNil(ABodyTypesExcelDM);
  end;
  UpdateView;

end;

procedure TViewBodyTypes.actRollbackExecute(Sender: TObject);
begin
  cxGrid.BeginUpdate();
  try
    // Отменяем все сделанные изменения
    BodyTypesGroup.Rollback;

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

procedure TViewBodyTypes.clBodyType1PropertiesInitPopup(Sender: TObject);
var
  AcxComboBox: TcxComboBox;
begin
  inherited;

  if BodyTypesGroup.qBodyTypes2.IDParentBodyType1.IsNull then
    Exit;

  // Загружаем все возможные варианты корпуса для открытого типа корпуса
  BodyTypesGroup.qBodyTypesBranch.Load
    (BodyTypesGroup.qBodyTypes2.IDParentBodyType1.Value);

  AcxComboBox := Sender as TcxComboBox;
  AcxComboBox.Properties.Items.Clear;

  BodyTypesGroup.qBodyTypesBranch.FDQuery.First;
  while not BodyTypesGroup.qBodyTypesBranch.FDQuery.Eof do
  begin
    AcxComboBox.Properties.Items.Add
      (BodyTypesGroup.qBodyTypesBranch.BodyType.AsString);
    BodyTypesGroup.qBodyTypesBranch.FDQuery.Next;
  end;
end;

procedure TViewBodyTypes.clBodyType2PropertiesInitPopup(Sender: TObject);
var
  AcxComboBox: TcxComboBox;
begin
  inherited;

  if BodyTypesGroup.qBodyTypes2.ID1.IsNull then
    Exit;

  // Загружаем все возможные варианты корпуса для открытого типа корпуса
  BodyTypesGroup.qBodyTypesBranch.Load
    (BodyTypesGroup.qBodyTypes2.ID1.Value);

  AcxComboBox := Sender as TcxComboBox;
  AcxComboBox.Properties.Items.Clear;

  BodyTypesGroup.qBodyTypesBranch.FDQuery.First;
  while not BodyTypesGroup.qBodyTypesBranch.FDQuery.Eof do
  begin
    AcxComboBox.Properties.Items.Add
      (BodyTypesGroup.qBodyTypesBranch.BodyType.AsString);
    BodyTypesGroup.qBodyTypesBranch.FDQuery.Next;
  end;

end;

procedure TViewBodyTypes.clImagePropertiesButtonClick(Sender: TObject;
AButtonIndex: Integer);
begin
  inherited;
  TDocument.Open(Handle, TSettings.Create.BodyTypesImageFolder,
    BodyTypesGroup.qBodyTypes2.Image.AsString,
    'Файл изображения корпуса с именем %s не найден',
    'Файл изображения корпуса не задан', sBodyTypesFilesExt);
end;

procedure TViewBodyTypes.clLandPatternPropertiesButtonClick(Sender: TObject;
AButtonIndex: Integer);
begin
  TDocument.Open(Handle, TSettings.Create.BodyTypesLandPatternFolder,
    BodyTypesGroup.qBodyTypes2.LandPattern.AsString,
    'Файл чертежа посадочной площадки корпуса с именем %s не найден',
    'Чертёж посадочной площадки корпуса не задан', sBodyTypesFilesExt);
end;

procedure TViewBodyTypes.clOutlineDrawingPropertiesButtonClick(Sender: TObject;
AButtonIndex: Integer);
begin
  inherited;
  TDocument.Open(Handle, TSettings.Create.BodyTypesOutlineDrawingFolder,
    BodyTypesGroup.qBodyTypes2.OutlineDrawing.AsString,
    'Файл чертежа корпуса с именем %s не найден', 'Чертёж корпуса не задан',
    sBodyTypesFilesExt);
end;

procedure TViewBodyTypes.CreateColumnsBarButtons;
begin
  FColumnsBarButtons := TColumnsBarButtons.Create(Self,
    dxbrsbtmColumnsCustomization, cxGridDBBandedTableView2);
end;

procedure TViewBodyTypes.cxGridDBBandedTableView2EditKeyDown
  (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
AEdit: TcxCustomEdit; var Key: Word; Shift: TShiftState);
var
  AColumn: TcxGridDBBandedColumn;
  S: string;
begin
  inherited;
  AColumn := AItem as TcxGridDBBandedColumn;
  S := Format(',%s,', [AColumn.DataBinding.FieldName.ToLower]);

  if (Key = 13) and (',BodyType,IDBodyKind,'.IndexOf(S) >= 0) then
    cxGridDBBandedTableView2.DataController.Post();
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
    (clBodyType);
  S := VarToStrDef(MainView.DataController.Summary.FooterSummaryValues
    [AIndex], '---');
  StatusBar.Panels[0].Text := S;
end;

procedure TViewBodyTypes.cxGridDBBandedTableViewEditKeyDown
  (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
AEdit: TcxCustomEdit; var Key: Word; Shift: TShiftState);
begin
  if (Key = 13) and (AItem = clBodyType) then
    cxGridDBBandedTableView.DataController.Post();
  // FBodyTypesGroup.qBodyKinds.TryPost;
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

      InitializeLookupColumn(clIDParentBodyType1,
        FBodyTypesGroup.qBodyKinds.DataSource, lsEditFixedList,
        FBodyTypesGroup.qBodyKinds.BodyType.FieldName);

      TNotifyEventWrap.Create(FBodyTypesGroup.qBodyKinds.AfterOpen,
        DoAfterDataChange, FEventList);
      TNotifyEventWrap.Create(FBodyTypesGroup.qBodyTypes2.AfterOpen,
        DoAfterDataChange, FEventList);
      TNotifyEventWrap.Create(FBodyTypesGroup.AfterDataChange,
        DoAfterDataChange, FEventList);
    end
    else
    begin
      MainView.DataController.DataSource := nil;
    end;

    // Будем работать в рамках транзакции
    // FBodyTypesGroup.Connection.StartTransaction;

    UpdateView;
  end;
end;

procedure TViewBodyTypes.StatusBarResize(Sender: TObject);
const
  EmptyPanelIndex = 1;
var
  I: Integer;
  x: Integer;
begin
  x := StatusBar.ClientWidth;
  for I := 0 to StatusBar.Panels.Count - 1 do
  begin
    if I <> EmptyPanelIndex then
    begin
      Dec(x, StatusBar.Panels[I].Width);
    end;
  end;
  x := IfThen(x >= 0, x, 0);
  StatusBar.Panels[EmptyPanelIndex].Width := x;
end;

procedure TViewBodyTypes.UpdateTotalCount;
begin
  // Общее число компонентов на в БД
  StatusBar.Panels[2].Text := Format('Всего: %d',
    [BodyTypesGroup.qBodyTypes2.FDQuery.RecordCount]);
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
