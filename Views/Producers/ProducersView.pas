unit ProducersView;

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
  cxGridDBBandedTableView, cxGrid, ProducersQuery, dxSkinsCore,
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
  SearchProducerTypesQuery, cxMemo, ProducersGroupUnit;

type
  TViewProducers = class(TfrmGrid)
    clID: TcxGridDBBandedColumn;
    actAdd: TAction;
    actDelete: TAction;
    dxbbAdd: TdxBarButton;
    dxbbDelete: TdxBarButton;
    actCommit: TAction;
    actRollback: TAction;
    dxbrbtnCommit: TdxBarButton;
    dxbrbtnRollback: TdxBarButton;
    dxbrsbtmExportImport: TdxBarSubItem;
    dxbrbtnExport: TdxBarButton;
    dxbrbtnImport: TdxBarButton;
    actExportToExcelDocument: TAction;
    actLoadFromExcelDocument: TAction;
    clProducerType: TcxGridDBBandedColumn;
    cxGridLevel2: TcxGridLevel;
    cxGridDBBandedTableView2: TcxGridDBBandedTableView;
    clName2: TcxGridDBBandedColumn;
    clProducts2: TcxGridDBBandedColumn;
    clCount2: TcxGridDBBandedColumn;
    clID2: TcxGridDBBandedColumn;
    clProducerTypeID: TcxGridDBBandedColumn;
    actAddType: TAction;
    dxBarButton1: TdxBarButton;
    procedure actAddExecute(Sender: TObject);
    procedure actAddTypeExecute(Sender: TObject);
    procedure actCommitExecute(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure actExportToExcelDocumentExecute(Sender: TObject);
    procedure actLoadFromExcelDocumentExecute(Sender: TObject);
    procedure actRollbackExecute(Sender: TObject);
    procedure cxGridDBBandedTableView2EditKeyDown(Sender: TcxCustomGridTableView;
        AItem: TcxCustomGridTableItem; AEdit: TcxCustomEdit; var Key: Word; Shift:
        TShiftState);
    procedure cxGridDBBandedTableViewEditKeyDown(Sender: TcxCustomGridTableView;
      AItem: TcxCustomGridTableItem; AEdit: TcxCustomEdit; var Key: Word;
      Shift: TShiftState);
    procedure StatusBarResize(Sender: TObject);
  private
    FProducersGroup: TProducersGroup;
    FQuerySearchProducerTypes: TQuerySearchProducerTypes;
    function GetQuerySearchProducerTypes: TQuerySearchProducerTypes;
    procedure MyInitializeComboBoxColumn;
    procedure SetProducersGroup(const Value: TProducersGroup);
    procedure UpdateTotalCount;
    { Private declarations }
  protected
    procedure DoAfterPost(Sender: TObject);
    procedure DoOnDataChange(Sender: TObject);
    property QuerySearchProducerTypes: TQuerySearchProducerTypes
      read GetQuerySearchProducerTypes;
  public
    procedure MyApplyBestFit; override;
    procedure UpdateView; override;
    property ProducersGroup: TProducersGroup read FProducersGroup write
        SetProducersGroup;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses NotifyEvents, RepositoryDataModule, DialogUnit,
  ProducersExcelDataModule, ImportErrorForm, CustomExcelTable, System.Math,
  SettingsController, System.IOUtils, ProjectConst, ProgressBarForm,
  SearchParameterValues, cxDropDownEdit;

procedure TViewProducers.actAddExecute(Sender: TObject);
var
  ARow: TcxGridMasterDataRow;
  AView: TcxGridDBBandedTableView;
begin
  ARow := GetRow(0) as TcxGridMasterDataRow;
  ARow.Expand(false);
  AView := GetDBBandedTableView(1);
  AView.DataController.Append;
  FocusColumnEditor(1, clName2.DataBinding.FieldName);
end;

procedure TViewProducers.actAddTypeExecute(Sender: TObject);
begin
  inherited;
  MainView.DataController.Append;
  FocusColumnEditor(0, clProducerType.DataBinding.FieldName);

  UpdateView;
end;

procedure TViewProducers.actCommitExecute(Sender: TObject);
begin
  cxGrid.BeginUpdate();
  try
    // Сохраняем изменения и завершаем транзакцию
    ProducersGroup.Commit;

    // Переносим фокус на первую выделенную запись
    FocusSelectedRecord;
  finally
    cxGrid.EndUpdate;
  end;

  // Помещаем фокус в центр грида
  PutInTheCenterFocusedRecord;

  // Обновляем представление
  UpdateView;
end;

procedure TViewProducers.actDeleteExecute(Sender: TObject);
var
  AView: TcxGridDBBandedTableView;
  S: string;
begin
  AView := FocusedTableView;
  if AView = nil then
    Exit;

  S := '';
  if AView.Level = cxGridLevel then
    S := 'Удалить тип';

  if AView.Level = cxGridLevel2 then
    S := 'Удалить производителя';

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

procedure TViewProducers.actExportToExcelDocumentExecute(Sender: TObject);
var
  AFileName: String;
begin
  AFileName := 'Производители';
  AFileName := TDialog.Create.SaveToExcelFile(AFileName);
  if AFileName = '' then
    Exit;

  ExportViewToExcel(MainView, AFileName,
    procedure(AView: TcxGridDBBandedTableView)
    begin
      AView.GetColumnByFieldName(ProducersGroup.qProducers.Cnt.FieldName).Visible := False;
    end);
end;

procedure TViewProducers.actLoadFromExcelDocumentExecute(Sender: TObject);
var
  AProducersExcelDM: TProducersExcelDM;
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

  AProducersExcelDM := TProducersExcelDM.Create(Self);
  try
    AProducersExcelDM.ExcelTable.ManufacturersDataSet :=
      ProducersGroup.qProducers.FDQuery;

    TfrmProgressBar.Process(AProducersExcelDM,
      procedure
      begin
        AProducersExcelDM.LoadExcelFile(AFileName);
      end, 'Загрузка данных о производителе', sRows);

    OK := AProducersExcelDM.ExcelTable.Errors.RecordCount = 0;

    if not OK then
    begin
      AfrmImportError := TfrmImportError.Create(Self);
      try
        AfrmImportError.ErrorTable := AProducersExcelDM.ExcelTable.Errors;
        OK := AfrmImportError.ShowModal = mrOk;
        if OK then
        begin
          if AfrmImportError.ContinueType = ctSkip then
          begin
            // Убираем записи с ошибками и предупреждениями
            AProducersExcelDM.ExcelTable.ExcludeErrors(etWarring);
          end
          else
          begin
            // Убираем все записи с ошибками
            AProducersExcelDM.ExcelTable.ExcludeErrors(etError);
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
        TfrmProgressBar.Process(AProducersExcelDM.ExcelTable,
          procedure
          begin
            ProducersGroup.InsertRecordList(AProducersExcelDM.ExcelTable);
          end, 'Сохранение данных о производителях в БД', sRecords);
      finally
        cxGrid.EndUpdate;
      end;
    end;
  finally
    FreeAndNil(AProducersExcelDM);
  end;
  UpdateView;

end;

procedure TViewProducers.actRollbackExecute(Sender: TObject);
begin
  cxGrid.BeginUpdate();
  try
    // Отменяем все сделанные изменения
    ProducersGroup.Rollback;

    // Переносим фокус на первую выделенную запись
    FocusSelectedRecord;
  finally
    cxGrid.EndUpdate;
  end;

  // Помещаем фокус в центр грида
  PutInTheCenterFocusedRecord;

  // Обновляем представление
  UpdateView;
end;

procedure TViewProducers.cxGridDBBandedTableView2EditKeyDown(Sender:
    TcxCustomGridTableView; AItem: TcxCustomGridTableItem; AEdit:
    TcxCustomEdit; var Key: Word; Shift: TShiftState);
begin
  inherited;
  if (Key = 13) and (AItem = clName2) then
    cxGridDBBandedTableView2.DataController.Post();
end;

procedure TViewProducers.cxGridDBBandedTableViewEditKeyDown
  (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
AEdit: TcxCustomEdit; var Key: Word; Shift: TShiftState);
begin
  if (Key = 13) and (AItem = clProducerType) then
    cxGridDBBandedTableView.DataController.Post();
end;

procedure TViewProducers.DoAfterPost(Sender: TObject);
begin
  MyInitializeComboBoxColumn;
end;

procedure TViewProducers.DoOnDataChange(Sender: TObject);
begin
  UpdateView;
end;

function TViewProducers.GetQuerySearchProducerTypes: TQuerySearchProducerTypes;
begin
  if FQuerySearchProducerTypes = nil then
    FQuerySearchProducerTypes := TQuerySearchProducerTypes.Create(Self);

  Result := FQuerySearchProducerTypes;
end;

procedure TViewProducers.MyApplyBestFit;
begin
  inherited;
  GetDBBandedTableView(1).ApplyBestFit(nil, True, True);
//  GridView(cxGridLevel2).ApplyBestFit(nil, True, True);
end;

procedure TViewProducers.MyInitializeComboBoxColumn;
begin
  // Ищем возможные значения типа производителя для выпадающего списка
  QuerySearchProducerTypes.RefreshQuery;

  // Инициализируем Combobox колонки
  InitializeComboBoxColumn(clProducerType, lsEditList,
    QuerySearchProducerTypes.ProducerType);
end;

procedure TViewProducers.SetProducersGroup(const Value: TProducersGroup);
begin
  if FProducersGroup <> Value then
  begin
    FProducersGroup := Value;
    if FProducersGroup <> nil then
    begin
      MainView.DataController.DataSource := FProducersGroup.qProducerTypes.DataSource;
      GridView(cxGridLevel2).DataController.DataSource := FProducersGroup.qProducers.DataSource;

      TNotifyEventWrap.Create(FProducersGroup.qProducers.OnDataChange, DoOnDataChange);

      // Подписываемся на событие о коммите
//      TNotifyEventWrap.Create(FProducersGroup.qProducers.AfterPost, DoAfterPost);

//      MyInitializeComboBoxColumn;
    end
    else
    begin
      MainView.DataController.DataSource := nil;
    end;

    PostMyApplyBestFitEvent;

    UpdateView;
  end;
end;

procedure TViewProducers.StatusBarResize(Sender: TObject);
const
  EmptyPanelIndex = 0;
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

procedure TViewProducers.UpdateTotalCount;
begin
  // Общее число компонентов на в БД
  StatusBar.Panels[1].Text := Format('Всего: %d',
    [ProducersGroup.qProducers.FDQuery.RecordCount]);
end;

procedure TViewProducers.UpdateView;
var
  AView: TcxGridDBBandedTableView;
  OK: Boolean;
begin
  AView := FocusedTableView;
  OK := (ProducersGroup <> nil)
    and (ProducersGroup.qProducerTypes.FDQuery.Active)
    and (ProducersGroup.qProducers.FDQuery.Active);

  actAdd.Enabled := OK and (AView <> nil) and (AView.Level = cxGridLevel);

  actDelete.Enabled := OK and (AView <> nil) and
    (AView.DataController.RecordCount > 0);

  actCommit.Enabled := OK and (ProducersGroup.Connection.InTransaction);

  actRollback.Enabled := actCommit.Enabled;

  actExportToExcelDocument.Enabled := OK and
    (ProducersGroup.qProducers.FDQuery.RecordCount > 0);

  UpdateTotalCount;
end;

end.
