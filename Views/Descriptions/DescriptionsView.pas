unit DescriptionsView;

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
  cxGridDBBandedTableView, cxGrid, DescriptionsMasterDetailUnit,
  cxDBLookupComboBox, Vcl.Grids, Vcl.DBGrids, ColumnsBarButtonsHelper,
  cxGridDBTableView, dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
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
  dxSkinXmas2008Blue, dxSkinscxPCPainter, dxSkinsdxBarPainter;

const
  WM_AFTER_SET_NEW_VALUE = WM_USER + 11;

type
  TViewDescriptions = class(TfrmGrid)
    cxGridLevel2: TcxGridLevel;
    cxGridDBBandedTableView2: TcxGridDBBandedTableView;
    clComponentType: TcxGridDBBandedColumn;
    clID2: TcxGridDBBandedColumn;
    clComponentName: TcxGridDBBandedColumn;
    clDescription: TcxGridDBBandedColumn;
    clID: TcxGridDBBandedColumn;
    dxbrbtnAdd: TdxBarButton;
    clIDComponentType: TcxGridDBBandedColumn;
    dxbrbtnAddDescription: TdxBarButton;
    actAddType: TAction;
    actAddDescription: TAction;
    actDelete: TAction;
    dxbrbtnDelete: TdxBarButton;
    dxbrbtnLoad: TdxBarButton;
    actLoadFromExcelDocument: TAction;
    actCommit: TAction;
    dxbrbtnApplyUpdates: TdxBarButton;
    actRollback: TAction;
    dxbrbtnRollback: TdxBarButton;
    actShowDublicate: TAction;
    dxbrbtnShowDublicate: TdxBarButton;
    clIDManufacturer: TcxGridDBBandedColumn;
    dxbrsbtmExportImport: TdxBarSubItem;
    actExportToExcelDocument: TAction;
    dxbrbtnExportToExcelDocument: TdxBarButton;
    dxbrbtn1: TdxBarButton;
    procedure actAddDescriptionExecute(Sender: TObject);
    procedure actAddTypeExecute(Sender: TObject);
    procedure actCommitExecute(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure actExportToExcelDocumentExecute(Sender: TObject);
    procedure actLoadFromExcelDocumentExecute(Sender: TObject);
    procedure actRollbackExecute(Sender: TObject);
    procedure actShowDublicateExecute(Sender: TObject);
    procedure clIDComponentTypePropertiesNewLookupDisplayText(Sender: TObject;
      const AText: TCaption);
    procedure clIDComponentTypePropertiesEditValueChanged(Sender: TObject);
    procedure clIDComponentTypePropertiesCloseUp(Sender: TObject);
    procedure clIDManufacturerPropertiesNewLookupDisplayText(Sender: TObject;
      const AText: TCaption);
    procedure cxGridDBBandedTableViewDataControllerSummaryAfterSummary
      (ASender: TcxDataSummary);
    procedure StatusBarResize(Sender: TObject);
  private
    FDescriptionsMasterDetail: TDescriptionsMasterDetail;
    FEditValueChanged: Boolean;
    FNewValue: string;
    procedure DoAfterDataChange(Sender: TObject);
    procedure SetDescriptionsMasterDetail(const Value
      : TDescriptionsMasterDetail);
    procedure UpdateTotalCount;
    { Private declarations }
  protected
    procedure AfterSetNewValue(var Message: TMessage);
      message WM_AFTER_SET_NEW_VALUE;
    procedure CreateColumnsBarButtons; override;
    procedure CreateFilterForExport(AView,
      ASource: TcxGridDBBandedTableView); override;
    function GetFocusedTableView: TcxGridDBBandedTableView; override;
  public
    procedure UpdateView; override;
    property DescriptionsMasterDetail: TDescriptionsMasterDetail
      read FDescriptionsMasterDetail write SetDescriptionsMasterDetail;
    { Public declarations }
  end;

implementation

uses
  DescriptionsExcelDataModule, DialogUnit, ImportErrorForm, NotifyEvents,
  cxGridExportLink, CustomExcelTable, System.Math, SettingsController,
  System.IOUtils, ProjectConst, ProgressBarForm;

{$R *.dfm}

var
  b: Boolean = false;

procedure TViewDescriptions.actAddDescriptionExecute(Sender: TObject);
var
  ARow: TcxGridMasterDataRow;
  AView: TcxGridDBBandedTableView;
begin
  ARow := GetRow(0) as TcxGridMasterDataRow;
  ARow.Expand(false);
  AView := GetDBBandedTableView(1);
  AView.DataController.Append;
  FocusColumnEditor(1, clComponentName.DataBinding.FieldName);

  UpdateView;
end;

procedure TViewDescriptions.actAddTypeExecute(Sender: TObject);
begin
  MainView.DataController.Append;
  FocusColumnEditor(0, clComponentType.DataBinding.FieldName);

  UpdateView;
end;

procedure TViewDescriptions.actCommitExecute(Sender: TObject);
begin
  cxGrid.BeginUpdate();
  try
    // ��������� ��������� � ��������� ����������
    DescriptionsMasterDetail.Commit;

    // �������� ����� ����������
    // DescriptionsMasterDetail.Connection.StartTransaction;

    // ��������� ����� �� ������ ���������� ������
    FocusSelectedRecord(MainView);
  finally
    cxGrid.EndUpdate;
  end;

  // �������� ����� � ����� �����
  PutInTheCenterFocusedRecord(MainView);

  // ��������� �������������
  UpdateView;
end;

procedure TViewDescriptions.actDeleteExecute(Sender: TObject);
var
  AView: TcxGridDBBandedTableView;
  S: string;
begin
  AView := FocusedTableView;
  if AView = nil then
    Exit;

  S := '';
  if AView.Level = cxGridLevel then
    S := '������� ���';

  if AView.Level = cxGridLevel2 then
    S := '������� ��������';

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

procedure TViewDescriptions.actExportToExcelDocumentExecute(Sender: TObject);
var
  AFileName: String;
begin
  AFileName := '������� ��������';
  AFileName := TDialog.Create.SaveToExcelFile(AFileName);
  if AFileName = '' then
    Exit;

  ExportViewToExcel(cxGridDBBandedTableView2, AFileName);
end;

procedure TViewDescriptions.actLoadFromExcelDocumentExecute(Sender: TObject);
var
  ADescriptionsExcelDM: TDescriptionsExcelDM;
  AFileName: string;
  AfrmImportError: TfrmImportError;
  OK: Boolean;
begin
  AFileName := TDialog.Create.OpenExcelFile
    (TSettings.Create.LastFolderForExcelFile);

  if AFileName.IsEmpty then
    Exit; // ���������� �� ������ �����

  // ��������� ��� ����� � ����������
  TSettings.Create.LastFolderForExcelFile := TPath.GetDirectoryName(AFileName);

  ADescriptionsExcelDM := TDescriptionsExcelDM.Create(Self);
  try
    ADescriptionsExcelDM.ExcelTable.DescriptionsDataSet :=
      DescriptionsMasterDetail.qDescriptionsDetail.FDQuery;

    TfrmProgressBar.Process(ADescriptionsExcelDM,
      procedure
      begin
        ADescriptionsExcelDM.LoadExcelFile(AFileName);
      end, '�������� ������� �������� �� Excel ���������', sRows);

    OK := ADescriptionsExcelDM.ExcelTable.Errors.RecordCount = 0;

    if not OK then
    begin
      AfrmImportError := TfrmImportError.Create(Self);
      try
        AfrmImportError.ErrorTable := ADescriptionsExcelDM.ExcelTable.Errors;
        OK := AfrmImportError.ShowModal = mrOk;
        if OK then
        begin
          if AfrmImportError.ContinueType = ctSkip then
          begin
            // ������� ������ � �������� � ����������������
            ADescriptionsExcelDM.ExcelTable.ExcludeErrors(etWarring);
          end
          else
          begin
            // ������� ������ � ��������
            ADescriptionsExcelDM.ExcelTable.ExcludeErrors(etError);

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
        TfrmProgressBar.Process(ADescriptionsExcelDM.ExcelTable,
          procedure
          begin
            DescriptionsMasterDetail.InsertRecordList
              (ADescriptionsExcelDM.ExcelTable);
          end, '���������� ������� �������� � ��', sRecords);
      finally
        cxGrid.EndUpdate;
      end;
    end;
  finally
    FreeAndNil(ADescriptionsExcelDM);
  end;
  UpdateView;

end;

procedure TViewDescriptions.actRollbackExecute(Sender: TObject);
begin
  cxGrid.BeginUpdate();
  try
    // �������� ��� ��������� ���������
    DescriptionsMasterDetail.Rollback;

    // �������� ����� ����������
    // DescriptionsMasterDetail.Connection.StartTransaction;

    // ��������� ����� �� ������ ���������� ������
    FocusSelectedRecord(MainView);
  finally
    cxGrid.EndUpdate;
  end;

  // �������� ����� � ����� �����
  PutInTheCenterFocusedRecord(MainView);

  // ��������� �������������
  UpdateView;
end;

procedure TViewDescriptions.actShowDublicateExecute(Sender: TObject);
var
  d: Boolean;
begin
  d := not DescriptionsMasterDetail.qDescriptionsDetail.ShowDublicate;
  cxGrid.BeginUpdate();
  try
    DescriptionsMasterDetail.qDescriptionsDetail.TryPost;
    DescriptionsMasterDetail.qDescriptionsMaster.TryPost;
    DescriptionsMasterDetail.qDescriptionsDetail.ShowDublicate := d;
    DescriptionsMasterDetail.qDescriptionsMaster.ShowDublicate := d;

    // ��������� ����� �� ������ ���������� ������
    FocusSelectedRecord(MainView);
  finally
    cxGrid.EndUpdate;
  end;

  actShowDublicate.Checked := d;
  if actShowDublicate.Checked then
    actShowDublicate.Caption := '�������� ��'
  else
    actShowDublicate.Caption := '�������� ���������';

  // �������� ����� � ����� �����
  PutInTheCenterFocusedRecord(MainView);

  // ��������� �������������
  UpdateView;
end;

procedure TViewDescriptions.AfterSetNewValue(var Message: TMessage);
var
  ADetailID: Integer;
  ARow: TcxGridMasterDataRow;
  AMasterID: Integer;
begin
  inherited;

  // ��������� ����� ��� ��������
  DescriptionsMasterDetail.qDescriptionsMaster.LocateOrAppend(FNewValue);
  FNewValue := '';

  AMasterID := DescriptionsMasterDetail.qDescriptionsMaster.PKValue;
  ADetailID := Message.WParam;

  // ���� ��������
  DescriptionsMasterDetail.qDescriptionsDetail.LocateByPK(ADetailID);
  DescriptionsMasterDetail.qDescriptionsDetail.TryEdit;
  DescriptionsMasterDetail.qDescriptionsDetail.IDComponentType.AsInteger :=
    AMasterID;
  DescriptionsMasterDetail.qDescriptionsDetail.TryPost;

  ARow := GetRow(0) as TcxGridMasterDataRow;
  Assert(ARow <> nil);

  ARow.Expand(false);
  FocusColumnEditor(1, clIDComponentType.DataBinding.FieldName);
end;

procedure TViewDescriptions.clIDComponentTypePropertiesCloseUp(Sender: TObject);
// var
// AColumn: TcxGridDBBandedColumn;
begin
  inherited;
  if FEditValueChanged then
  begin
    FEditValueChanged := false;
    cxGridDBBandedTableView2.DataController.Post();
  end
end;

procedure TViewDescriptions.clIDComponentTypePropertiesEditValueChanged
  (Sender: TObject);
var
  ADetailID: Integer;
  AMasterID: Integer;
begin
  if not FNewValue.IsEmpty then
  begin
    ADetailID := DescriptionsMasterDetail.qDescriptionsDetail.PKValue;
    AMasterID := DescriptionsMasterDetail.qDescriptionsMaster.PKValue;

    // ���������� ���� ������ �������� �������� �����
    DescriptionsMasterDetail.qDescriptionsDetail.IDComponentType.AsInteger :=
      AMasterID;
    DescriptionsMasterDetail.qDescriptionsDetail.TryPost;

    // �������� ��������� � ��� ��� �������� �������� ����� ���� ����� ��������
    PostMessage(Handle, WM_AFTER_SET_NEW_VALUE, ADetailID, 0);
  end
  else
    FEditValueChanged := True;
end;

procedure TViewDescriptions.clIDComponentTypePropertiesNewLookupDisplayText
  (Sender: TObject; const AText: TCaption);
begin
  FNewValue := AText;
  // if b then
  // Exit;

  // b := True;
  // DescriptionsMasterDetail.qDescriptionsMaster.AddNewValue(AText);
  // b := False;
end;

procedure TViewDescriptions.clIDManufacturerPropertiesNewLookupDisplayText
  (Sender: TObject; const AText: TCaption);
begin
  inherited;
  FDescriptionsMasterDetail.qManufacturers2.AddNewValue(AText);
end;

procedure TViewDescriptions.CreateColumnsBarButtons;
begin
  FColumnsBarButtons := TColumnsBarButtons.Create(Self,
    dxbrsbtmColumnsCustomization, cxGridDBBandedTableView2);
end;

procedure TViewDescriptions.CreateFilterForExport(AView,
  ASource: TcxGridDBBandedTableView);
var
  AColumn: TcxGridDBBandedColumn;
  AIDtypeList: string;
  AOperatorKind: TcxFilterOperatorKind;
  F: TcxFilterCriteriaItem;
  I: Integer;
  r: TcxFilterCriteriaItemList;
  a: array of string;
  Arr: Variant;
  X: Integer;
begin
  F := cxGridDBBandedTableView.DataController.Filter.FindItemByItemLink
    (clComponentType);
  if F <> nil then
  begin
    AIDtypeList := '';
    SetLength(a, cxGridDBBandedTableView.ViewData.RowCount);

    Arr := VarArrayCreate([0, cxGridDBBandedTableView.ViewData.RowCount],
      varInteger);
    for I := 0 to cxGridDBBandedTableView.ViewData.RowCount - 1 do
    begin
      X := cxGridDBBandedTableView.ViewData.Rows[I].Values[clID.Index];
      VarArrayPut(Arr, X, [I]);
    end;

    // S := F.Value;
    r := AView.DataController.Filter.Root;
    AOperatorKind := foInList;
    AColumn := AView.GetColumnByFieldName
      (clIDComponentType.DataBinding.FieldName);
    AView.DataController.Filter.AddItem(r, AColumn, AOperatorKind, Arr,
      '������');
    AView.DataController.Filter.Active := True;
  end;
end;

procedure TViewDescriptions.
  cxGridDBBandedTableViewDataControllerSummaryAfterSummary
  (ASender: TcxDataSummary);
var
  AIndex: Integer;
  S: string;
begin
  inherited;
  AIndex := MainView.DataController.Summary.FooterSummaryItems.IndexOfItemLink
    (clComponentType);
  S := VarToStrDef(MainView.DataController.Summary.FooterSummaryValues
    [AIndex], '---');
  StatusBar.Panels[0].Text := S;
end;

procedure TViewDescriptions.DoAfterDataChange(Sender: TObject);
begin
  UpdateView;
end;

function TViewDescriptions.GetFocusedTableView: TcxGridDBBandedTableView;
begin
  Result := inherited;

  // ���� �� ������ ������� � ������
  if (Result = nil) then
  begin
    Result := GetDBBandedTableView(1);
    if (Result <> nil) and (not Result.Focused) then
      Result := nil;
  end;
end;

procedure TViewDescriptions.SetDescriptionsMasterDetail
  (const Value: TDescriptionsMasterDetail);
var
  P: TcxLookupComboBoxProperties;
begin
  FDescriptionsMasterDetail := Value;

  if FDescriptionsMasterDetail <> nil then
  begin
    // ����������� ������������� � ������
    // DBGrid1.DataSource := FDescriptionsMasterDetail.qDescriptionsMaster.
    // DataSource;

    cxGridDBBandedTableView.DataController.DataSource :=
      FDescriptionsMasterDetail.qDescriptionsMaster.DataSource;
    cxGridDBBandedTableView2.DataController.DataSource :=
      FDescriptionsMasterDetail.qDescriptionsDetail.DataSource;

    P := clIDComponentType.Properties as TcxLookupComboBoxProperties;
    P.ListSource := FDescriptionsMasterDetail.qDescriptionsMaster.DataSource;
    P.ListFieldNames := 'ComponentType';
    P.KeyFieldNames := 'ID';

    P := clIDManufacturer.Properties as TcxLookupComboBoxProperties;
    P.ListSource := FDescriptionsMasterDetail.qManufacturers2.DataSource;
    P.ListFieldNames := 'Name';
    P.KeyFieldNames := 'ID';


    // cxGrid1DBTableView1.DataController.DataSource :=
    // FDescriptionsMasterDetail.qDescriptionsDetail.DataSource;
    // cxGrid1DBTableView1.Assign(cxGridDBBandedTableView2);

    TNotifyEventWrap.Create(FDescriptionsMasterDetail.AfterDataChange,
      DoAfterDataChange, FEventList);
    TNotifyEventWrap.Create(FDescriptionsMasterDetail.qDescriptionsMaster.
      AfterOpen, DoAfterDataChange, FEventList);
    TNotifyEventWrap.Create(FDescriptionsMasterDetail.qDescriptionsDetail.
      AfterOpen, DoAfterDataChange, FEventList);

    // ����� �������� � ������ ����������
    // ���������� �������� ���� ����������
    // FDescriptionsMasterDetail.Connection.StartTransaction;
  end;
  UpdateView;
end;

procedure TViewDescriptions.StatusBarResize(Sender: TObject);
const
  EmptyPanelIndex = 1;
var
  I: Integer;
  X: Integer;
begin
  X := StatusBar.ClientWidth;
  for I := 0 to StatusBar.Panels.Count - 1 do
  begin
    if I <> EmptyPanelIndex then
    begin
      Dec(X, StatusBar.Panels[I].Width);
    end;
  end;
  X := IfThen(X >= 0, X, 0);
  StatusBar.Panels[EmptyPanelIndex].Width := X;
end;

procedure TViewDescriptions.UpdateTotalCount;
begin
  // ����� ����� ����������� �� � ��
  StatusBar.Panels[2].Text := Format('�����: %d',
    [DescriptionsMasterDetail.qDescriptionsDetail.FDQuery.RecordCount]);
end;

procedure TViewDescriptions.UpdateView;
var
  AView: TcxGridDBBandedTableView;
  OK: Boolean;
begin
  AView := FocusedTableView;
  OK := (DescriptionsMasterDetail <> nil) and (AView <> nil);

  actAddType.Enabled := OK and
    (DescriptionsMasterDetail.qDescriptionsMaster.FDQuery.Active) and
    (not DescriptionsMasterDetail.qDescriptionsMaster.ShowDublicate) and
    (AView.Level = cxGridLevel);

  actAddDescription.Enabled := OK and
    (DescriptionsMasterDetail.qDescriptionsDetail.FDQuery.Active) and
    (not DescriptionsMasterDetail.qDescriptionsMaster.ShowDublicate) and
    ((AView.Level = cxGridLevel) or (AView.Level = cxGridLevel2));

  actDelete.Enabled := OK and (AView.DataController.RecordCount > 0);

  actCommit.Enabled := OK and
    (DescriptionsMasterDetail.Connection.InTransaction);

  actRollback.Enabled := actCommit.Enabled;

  actLoadFromExcelDocument.Enabled := (DescriptionsMasterDetail <> nil) and
    (not DescriptionsMasterDetail.qDescriptionsMaster.ShowDublicate);

  actExportToExcelDocument.Enabled := (DescriptionsMasterDetail <> nil) and
    (not DescriptionsMasterDetail.qDescriptionsMaster.ShowDublicate) and
    (DescriptionsMasterDetail.qDescriptionsDetail.FDQuery.RecordCount > 0);

  UpdateTotalCount;
end;

end.
