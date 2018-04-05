unit ExtraChargeView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
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
  cxGridDBBandedTableView, cxGrid, ExtraChargeQuery;

type
  TViewExtraCharge = class(TfrmGrid)
    clID: TcxGridDBBandedColumn;
    clRange: TcxGridDBBandedColumn;
    clWholeSale: TcxGridDBBandedColumn;
    actCommit: TAction;
    actRollback: TAction;
    actAdd: TAction;
    actExportToExcelDocument: TAction;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    dxBarButton3: TdxBarButton;
    dxBarButton4: TdxBarButton;
    dxBarSubItem1: TdxBarSubItem;
    dxBarButton5: TdxBarButton;
    procedure actAddExecute(Sender: TObject);
    procedure actCommitExecute(Sender: TObject);
    procedure actExportToExcelDocumentExecute(Sender: TObject);
    procedure actRollbackExecute(Sender: TObject);
  private
    FqExtraCharge: TQueryExtraCharge;
    procedure SetqExtraCharge(const Value: TQueryExtraCharge);
    procedure UpdateTotalCount;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    procedure UpdateView; override;
    property qExtraCharge: TQueryExtraCharge read FqExtraCharge write
        SetqExtraCharge;
    { Public declarations }
  end;

implementation

uses
  DialogUnit, RepositoryDataModule;

{$R *.dfm}

constructor TViewExtraCharge.Create(AOwner: TComponent);
begin
  inherited;
  StatusBarEmptyPanelIndex := 1;

  PostOnEnterFields.Add(clWholeSale.DataBinding.FieldName);

  DeleteMessages.Add(cxGridLevel, 'Удалить диапазон оптовой наценки?');

  UpdateView;
end;

procedure TViewExtraCharge.actAddExecute(Sender: TObject);
begin
  MainView.Controller.ClearSelection;
  MainView.DataController.Append;
  FocusColumnEditor(0, clRange.DataBinding.FieldName);

  UpdateView;
end;

procedure TViewExtraCharge.actCommitExecute(Sender: TObject);
begin
  inherited;
  qExtraCharge.ApplyUpdates;
end;

procedure TViewExtraCharge.actExportToExcelDocumentExecute(Sender: TObject);
var
  AFileName: String;
begin
  if not TDialog.Create.ShowDialog(TExcelFileSaveDialog, '', 'Таблица оптовой наценки',
    AFileName) then
    Exit;

  ExportViewToExcel(MainView, AFileName);
end;

procedure TViewExtraCharge.actRollbackExecute(Sender: TObject);
begin
  inherited;
  cxGrid.BeginUpdate();
  try
    // Отменяем все сделанные изменения
    qExtraCharge.CancelUpdates;

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

procedure TViewExtraCharge.SetqExtraCharge(const Value: TQueryExtraCharge);
begin
  if FqExtraCharge = Value then Exit;

  FqExtraCharge := Value;

  if FqExtraCharge = nil then Exit;

  MainView.DataController.DataSource := qExtraCharge.DataSource;
//  ApplyBestFitMultiLine := True;
  MyApplyBestFit;
  UpdateView;
end;

procedure TViewExtraCharge.UpdateTotalCount;
var
  S: string;
begin
  if qExtraCharge = nil then
    S := ''
  else
    S := Format('Всего: %d', [qExtraCharge.FDQuery.RecordCount]);

  // Общее число компонентов на в БД
  StatusBar.Panels[StatusBar.Panels.Count - 1].Text := S;
end;

procedure TViewExtraCharge.UpdateView;
var
  AView: TcxGridDBBandedTableView;
  OK: Boolean;
begin
  AView := FocusedTableView;
  OK := (qExtraCharge <> nil) and
    (qExtraCharge.FDQuery.Active);


  actAdd.Enabled := OK and (AView <> nil) and
    (MainView.DataController.RecordCount > 0);

  // Удалять разрешаем только если что-то выделено
  actDeleteEx.Enabled := OK and (AView <> nil) and
    (AView.Controller.SelectedRowCount > 0);;

  actCommit.Enabled := OK and (qExtraCharge.FDQuery.Connection.InTransaction);

  actRollback.Enabled := actCommit.Enabled;

  actExportToExcelDocument.Enabled := OK and
    (qExtraCharge.FDQuery.RecordCount > 0);

  UpdateTotalCount;
end;

end.
