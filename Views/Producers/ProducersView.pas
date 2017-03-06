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
  dxSkinXmas2008Blue, dxSkinscxPCPainter, dxSkinsdxBarPainter;

type
  TViewProducers = class(TfrmGrid)
    clID: TcxGridDBBandedColumn;
    clName: TcxGridDBBandedColumn;
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
    clProducts: TcxGridDBBandedColumn;
    procedure actAddExecute(Sender: TObject);
    procedure actCommitExecute(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure actExportToExcelDocumentExecute(Sender: TObject);
    procedure actLoadFromExcelDocumentExecute(Sender: TObject);
    procedure actRollbackExecute(Sender: TObject);
    procedure cxGridDBBandedTableViewEditKeyDown(Sender: TcxCustomGridTableView;
      AItem: TcxCustomGridTableItem; AEdit: TcxCustomEdit; var Key: Word;
      Shift: TShiftState);
    procedure StatusBarResize(Sender: TObject);
  private
    FQueryProducers: TQueryProducers;
    procedure SetQueryProducers(const Value: TQueryProducers);
    procedure UpdateTotalCount;
    { Private declarations }
  protected
    procedure DoOnDataChange(Sender: TObject);
  public
    procedure UpdateView; override;
    property QueryProducers: TQueryProducers read FQueryProducers write
        SetQueryProducers;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses NotifyEvents, RepositoryDataModule, DialogUnit,
  ManufacturersExcelDataModule, ImportErrorForm, CustomExcelTable, System.Math,
  SettingsController, System.IOUtils, ProjectConst, ProgressBarForm;

procedure TViewProducers.actAddExecute(Sender: TObject);
begin
  MainView.DataController.Append;
  FocusColumnEditor(0, clName.DataBinding.FieldName);

  UpdateView;
end;

procedure TViewProducers.actCommitExecute(Sender: TObject);
begin
  cxGrid.BeginUpdate();
  try
    // Сохраняем все сделанные изменения
    QueryProducers.ApplyUpdates;

    // Начинаем новую транзакцию
    // FQueryProducers.FDQuery.Connection.StartTransaction;

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
      AView.MasterGridRecord.Collapse(False);
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

  ExportViewToExcel(MainView, AFileName);
end;

procedure TViewProducers.actLoadFromExcelDocumentExecute(Sender: TObject);
var
  AManufacturersExcelDM: TManufacturersExcelDM;
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

  AManufacturersExcelDM := TManufacturersExcelDM.Create(Self);
  try
    AManufacturersExcelDM.ExcelTable.ManufacturersDataSet :=
      QueryProducers.FDQuery;

    TfrmProgressBar.Process(AManufacturersExcelDM,
      procedure
      begin
        AManufacturersExcelDM.LoadExcelFile(AFileName);
      end, 'Загрузка данных о производителе', sRows);

    OK := AManufacturersExcelDM.ExcelTable.Errors.RecordCount = 0;

    if not OK then
    begin
      AfrmImportError := TfrmImportError.Create(Self);
      try
        AfrmImportError.ErrorTable := AManufacturersExcelDM.ExcelTable.Errors;
        OK := AfrmImportError.ShowModal = mrOk;
        if OK then
        begin
          if AfrmImportError.ContinueType = ctSkip then
          begin
            // Убираем записи с ошибками и предупреждениями
            AManufacturersExcelDM.ExcelTable.ExcludeErrors(etWarring);
          end
          else
          begin
            // Убираем все записи с ошибками
            AManufacturersExcelDM.ExcelTable.ExcludeErrors(etError);
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
        TfrmProgressBar.Process(AManufacturersExcelDM.ExcelTable,
          procedure
          begin
            QueryProducers.InsertRecordList
              (AManufacturersExcelDM.ExcelTable);
          end, 'Сохранение данных о производителях в БД', sRecords);
      finally
        cxGrid.EndUpdate;
      end;
    end;
  finally
    FreeAndNil(AManufacturersExcelDM);
  end;
  UpdateView;

end;

procedure TViewProducers.actRollbackExecute(Sender: TObject);
begin
  cxGrid.BeginUpdate();
  try
    // Отменяем все сделанные изменения
    QueryProducers.CancelUpdates;

    // Начинаем новую транзакцию
    // FQueryProducers.FDQuery.Connection.StartTransaction;

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

procedure TViewProducers.cxGridDBBandedTableViewEditKeyDown
  (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
AEdit: TcxCustomEdit; var Key: Word; Shift: TShiftState);
begin
  if (Key = 13) and (AItem = clName) then
    cxGridDBBandedTableView.DataController.Post();
end;

procedure TViewProducers.DoOnDataChange(Sender: TObject);
begin
  UpdateView;
end;

procedure TViewProducers.SetQueryProducers(const Value: TQueryProducers);
begin
  if FQueryProducers <> Value then
  begin
    FQueryProducers := Value;
    if FQueryProducers <> nil then
    begin
      MainView.DataController.DataSource := FQueryProducers.DataSource;

      TNotifyEventWrap.Create(FQueryProducers.OnDataChange, DoOnDataChange);
    end
    else
    begin
      MainView.DataController.DataSource := nil;
    end;

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
    [QueryProducers.FDQuery.RecordCount]);
end;

procedure TViewProducers.UpdateView;
var
  AView: TcxGridDBBandedTableView;
  OK: Boolean;
begin
  AView := FocusedTableView;
  OK := (QueryProducers <> nil) and (QueryProducers.FDQuery.Active);

  actAdd.Enabled := OK and (AView <> nil) and (AView.Level = cxGridLevel);

  actDelete.Enabled := OK and (AView <> nil) and
    (AView.DataController.RecordCount > 0);

  actCommit.Enabled := OK and
    (QueryProducers.FDQuery.Connection.InTransaction);

  actRollback.Enabled := actCommit.Enabled;

  actExportToExcelDocument.Enabled := OK and
    (QueryProducers.FDQuery.RecordCount > 0);

  UpdateTotalCount;
end;

end.
