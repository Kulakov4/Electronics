unit SubParametersView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, GridFrame, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
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
  dxSkinXmas2008Blue, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, cxNavigator, Data.DB, cxDBData, dxSkinsdxBarPainter,
  cxGridCustomPopupMenu, cxGridPopupMenu, Vcl.Menus, System.Actions,
  Vcl.ActnList, dxBar, cxClasses, Vcl.ComCtrls, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridBandedTableView,
  cxGridDBBandedTableView, cxGrid, SubParametersQuery,
  SubParametersExcelDataModule, SubParametersQuery2, cxCheckBox;

type
  TViewSubParameters = class(TfrmGrid)
    clID: TcxGridDBBandedColumn;
    clName: TcxGridDBBandedColumn;
    clTranslation: TcxGridDBBandedColumn;
    actCommit: TAction;
    actRollback: TAction;
    actExportToExcelDocument: TAction;
    actLoadFromExcelDocument: TAction;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    dxBarSubItem1: TdxBarSubItem;
    dxBarButton3: TdxBarButton;
    dxBarButton4: TdxBarButton;
    dxBarButton5: TdxBarButton;
    actAdd: TAction;
    dxBarButton6: TdxBarButton;
    clChecked: TcxGridDBBandedColumn;
    procedure actAddExecute(Sender: TObject);
    procedure actCommitExecute(Sender: TObject);
    procedure actExportToExcelDocumentExecute(Sender: TObject);
    procedure actLoadFromExcelDocumentExecute(Sender: TObject);
    procedure actRollbackExecute(Sender: TObject);
  private
    FQuerySubParameters: TQuerySubParameters2;
    function GetCheckedMode: Boolean;
    procedure LoadDataFromExcelTable(AExcelTable: TSubParametersExcelTable);
    procedure SetCheckedMode(const Value: Boolean);
    procedure SetQuerySubParameters(const Value: TQuerySubParameters2);
    procedure UpdateAutoTransaction;
    procedure UpdateTotalCount;
    { Private declarations }
  protected
    procedure LoadFromExcel(AFileName: string);
  public
    constructor Create(AOwner: TComponent); override;
    function CheckAndSaveChanges: Integer;
    procedure CommitOrPost;
    procedure UpdateView; override;
    property CheckedMode: Boolean read GetCheckedMode write SetCheckedMode;
    property QuerySubParameters: TQuerySubParameters2 read FQuerySubParameters
        write SetQuerySubParameters;
    { Public declarations }
  end;

implementation

uses
  GridSort, DialogUnit, DialogUnit2, LoadFromExcelFileHelper, ImportErrorForm,
  ProgressBarForm, ProjectConst;

{$R *.dfm}

constructor TViewSubParameters.Create(AOwner: TComponent);
begin
  inherited;
  ApplyBestFitMultiLine := True;

  StatusBarEmptyPanelIndex := 1;

  PostOnEnterFields.Add(clName.DataBinding.FieldName);
  PostOnEnterFields.Add(clTranslation.DataBinding.FieldName);

  GridSort.Add(TSortVariant.Create(clName, [clName]));
  ApplySort(MainView, clName);

  DeleteMessages.Add(cxGridLevel, 'Удалить подпараметр?');
//  clChecked.Visible := FCheckedMode;
end;

procedure TViewSubParameters.actAddExecute(Sender: TObject);
begin
  inherited;
  MainView.Controller.ClearSelection;
  MainView.DataController.Append;
  FocusColumnEditor(0, clName.DataBinding.FieldName);

  UpdateView;
end;

procedure TViewSubParameters.actCommitExecute(Sender: TObject);
begin
  inherited;
  FQuerySubParameters.ApplyUpdates;

  UpdateView;
end;

procedure TViewSubParameters.actExportToExcelDocumentExecute(Sender: TObject);
var
  AFileName: String;
begin
  if not TDialog.Create.ShowDialog(TExcelFileSaveDialog, '', 'Подпараметры',
    AFileName) then
    Exit;

  ExportViewToExcel(MainView, AFileName);
  UpdateView;
end;

procedure TViewSubParameters.actLoadFromExcelDocumentExecute(Sender: TObject);
var
  AFileName: string;
begin
  if not TOpenExcelDialog.SelectInLastFolder(AFileName, Handle) then
    Exit;

  LoadFromExcel(AFileName);
end;

procedure TViewSubParameters.actRollbackExecute(Sender: TObject);
begin
  cxGrid.BeginUpdate();
  try
    // Отменяем все сделанные изменения
    FQuerySubParameters.CancelUpdates;

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

function TViewSubParameters.CheckAndSaveChanges: Integer;
begin
  Result := 0;
  if QuerySubParameters = nil then
    Exit;

  UpdateView;

  if QuerySubParameters.HaveAnyChanges then
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

procedure TViewSubParameters.CommitOrPost;
begin
  UpdateView;

  if CheckedMode then // В этом случае транзакция не начата
    QuerySubParameters.TryPost
  else
    actCommit.Execute; // завершаем транзакцию
end;

function TViewSubParameters.GetCheckedMode: Boolean;
begin
  Result := clChecked.Visible;
end;

procedure TViewSubParameters.LoadDataFromExcelTable
  (AExcelTable: TSubParametersExcelTable);
begin

  cxGridDBBandedTableView.BeginUpdate();
  try
    TfrmProgressBar.Process(AExcelTable,
      procedure(ASender: TObject)
      begin
        FQuerySubParameters.LoadDataFromExcelTable(AExcelTable);
      end, 'Обновление подпараметров в БД', sRecords);

  finally
    cxGridDBBandedTableView.EndUpdate;
  end;
end;

procedure TViewSubParameters.LoadFromExcel(AFileName: string);
begin
  BeginUpdate;
  try
    TLoad.Create.LoadAndProcess(AFileName, TSubParametersExcelDM,
      TfrmImportError,
      procedure(ASender: TObject)
      begin
        LoadDataFromExcelTable(ASender as TSubParametersExcelTable)
      end,
      procedure(ASender: TObject)
      begin
        (ASender as TSubParametersExcelTable).SubParametersDataSet :=
          FQuerySubParameters.FDQuery;
      end);
  finally
    EndUpdate;
  end;
  MyApplyBestFitForView(MainView);
  UpdateView;
end;

procedure TViewSubParameters.SetCheckedMode(const Value: Boolean);
begin
  if clChecked.Visible = Value then
    Exit;

  clChecked.Visible := Value;
  clChecked.VisibleForCustomization := False;

  if QuerySubParameters <> nil then
  begin
    UpdateAutoTransaction;
  end;
end;

procedure TViewSubParameters.SetQuerySubParameters(const Value:
    TQuerySubParameters2);
begin
  if FQuerySubParameters = Value then
    Exit;

  FQuerySubParameters := Value;
  FEventList.Clear;

  if FQuerySubParameters = nil then
    Exit;

  MainView.DataController.DataSource := FQuerySubParameters.DataSource;
  MainView.DataController.KeyFieldNames := FQuerySubParameters.PKFieldName;

  CheckedMode := FQuerySubParameters.CheckedMode;

  MyApplyBestFit;
  UpdateAutoTransaction;
  UpdateView;
end;

procedure TViewSubParameters.UpdateAutoTransaction;
begin
  QuerySubParameters.AutoTransaction := CheckedMode;
end;

procedure TViewSubParameters.UpdateTotalCount;
begin
  Assert(FQuerySubParameters <> nil);
  // Общее число подпораметров
  StatusBar.Panels[StatusBar.Panels.Count - 1].Text :=
    Format('Всего: %d', [FQuerySubParameters.FDQuery.RecordCount]);
end;

procedure TViewSubParameters.UpdateView;
var
  AView: TcxGridDBBandedTableView;
  OK: Boolean;
begin
  AView := FocusedTableView;
  OK := (FQuerySubParameters <> nil) and (FQuerySubParameters.FDQuery.Active);

  actCommit.Enabled := OK and FQuerySubParameters.FDQuery.Connection.
    InTransaction;

  actRollback.Enabled := actCommit.Enabled;

  // Удалять разрешаем только если что-то выделено
  actDeleteEx.Enabled := OK and (AView <> nil) and
    (AView.Controller.SelectedRowCount > 0);

  actAdd.Enabled := OK and (AView <> nil) and (AView.Level = cxGridLevel);

  actLoadFromExcelDocument.Enabled := OK;

  actExportToExcelDocument.Enabled := OK and
    (MainView.DataController.RowCount > 0);

  UpdateTotalCount;
end;

end.
