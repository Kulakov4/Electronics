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
  cxGridDBBandedTableView, cxGrid, DescriptionsGroupUnit,
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
  dxSkinXmas2008Blue, dxSkinscxPCPainter, dxSkinsdxBarPainter, HRTimer,
  DragHelper;

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
    clIDProducer: TcxGridDBBandedColumn;
    dxbrsbtmExportImport: TdxBarSubItem;
    actExportToExcelDocument: TAction;
    dxbrbtnExportToExcelDocument: TdxBarButton;
    dxbrbtn1: TdxBarButton;
    clOrder: TcxGridDBBandedColumn;
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
    procedure cxGridDBBandedTableViewDragDrop(Sender, Source: TObject; X, Y:
        Integer);
    procedure cxGridDBBandedTableViewDragOver(Sender, Source: TObject; X, Y:
        Integer; State: TDragState; var Accept: Boolean);
    procedure cxGridDBBandedTableViewStartDrag(Sender: TObject; var DragObject:
        TDragObject);
  private
    FDescriptionsGroup: TDescriptionsGroup;
    FDropDrag: TDropDrag;
    FEditValueChanged: Boolean;
    FHRTimer: THRTimer;
    FNewValue: string;
    FStartDrag: TStartDrag;
    FStartDragLevel: TcxGridLevel;
    procedure DoAfterDataChange(Sender: TObject);
    procedure SetDescriptionsGroup(const Value: TDescriptionsGroup);
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
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure UpdateView; override;
    property DescriptionsGroup: TDescriptionsGroup read FDescriptionsGroup
      write SetDescriptionsGroup;
    { Public declarations }
  end;

implementation

uses
  DescriptionsExcelDataModule, DialogUnit, ImportErrorForm, NotifyEvents,
  cxGridExportLink, CustomExcelTable, System.Math, SettingsController,
  System.IOUtils, ProjectConst, ProgressBarForm, cxDropDownEdit;

{$R *.dfm}

var
  b: Boolean = false;

constructor TViewDescriptions.Create(AOwner: TComponent);
begin
  inherited;
  StatusBarEmptyPanelIndex := 1;
  FStartDrag := TStartDrag.Create;
  FDropDrag := TDropDrag.Create;

  PostOnEnterFields.Add(clComponentType.DataBinding.FieldName);
end;

destructor TViewDescriptions.Destroy;
begin
  FreeAndNil(FStartDrag);
  FreeAndNil(FDropDrag);
  inherited;
end;

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
    DescriptionsGroup.Commit;

    // �������� ����� ����������
    // DescriptionsGroup.Connection.StartTransaction;

    // ��������� ����� �� ������ ���������� ������
    FocusSelectedRecord;
  finally
    cxGrid.EndUpdate;
  end;

  // �������� ����� � ����� �����
  PutInTheCenterFocusedRecord;

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
      DescriptionsGroup.qDescriptions.FDQuery;

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
            DescriptionsGroup.InsertRecordList(ADescriptionsExcelDM.ExcelTable);
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
    DescriptionsGroup.Rollback;

    // �������� ����� ����������
    // DescriptionsGroup.Connection.StartTransaction;

    // ��������� ����� �� ������ ���������� ������
    FocusSelectedRecord;
  finally
    cxGrid.EndUpdate;
  end;

  // �������� ����� � ����� �����
  PutInTheCenterFocusedRecord;

  // ��������� �������������
  UpdateView;
end;

procedure TViewDescriptions.actShowDublicateExecute(Sender: TObject);
var
  d: Boolean;
begin
  d := not DescriptionsGroup.qDescriptions.ShowDublicate;
  cxGrid.BeginUpdate();
  try
    DescriptionsGroup.qDescriptions.TryPost;
    DescriptionsGroup.qDescriptionTypes.TryPost;

    DescriptionsGroup.qDescriptions.ShowDublicate := d;
    DescriptionsGroup.qDescriptionTypes.ShowDublicate := d;

    // ��������� ����� �� ������ ���������� ������
    FocusSelectedRecord();
  finally
    cxGrid.EndUpdate;
  end;

  actShowDublicate.Checked := d;

  // �������� ����� � ����� �����
  PutInTheCenterFocusedRecord();

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
  DescriptionsGroup.qDescriptionTypes.LocateOrAppend(FNewValue);
  FNewValue := '';

  AMasterID := DescriptionsGroup.qDescriptionTypes.PKValue;
  ADetailID := Message.WParam;

  // ���� ��������
  DescriptionsGroup.qDescriptions.LocateByPK(ADetailID);
  DescriptionsGroup.qDescriptions.TryEdit;
  DescriptionsGroup.qDescriptions.IDComponentType.AsInteger := AMasterID;
  DescriptionsGroup.qDescriptions.TryPost;

  ARow := GetRow(0) as TcxGridMasterDataRow;
  Assert(ARow <> nil);

  ARow.Expand(false);
  FocusColumnEditor(1, clIDComponentType.DataBinding.FieldName);
end;

procedure TViewDescriptions.clIDComponentTypePropertiesCloseUp(Sender: TObject);
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
    ADetailID := DescriptionsGroup.qDescriptions.PKValue;
    AMasterID := DescriptionsGroup.qDescriptionTypes.PKValue;

    // ���������� ���� ������ �������� �������� �����
    DescriptionsGroup.qDescriptions.IDComponentType.AsInteger := AMasterID;
    DescriptionsGroup.qDescriptions.TryPost;

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
  // DescriptionsGroup.qDescriptionsMaster.AddNewValue(AText);
  // b := False;
end;

procedure TViewDescriptions.clIDManufacturerPropertiesNewLookupDisplayText
  (Sender: TObject; const AText: TCaption);
begin
  inherited;
  FDescriptionsGroup.qProducers.AddNewValue(AText);
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

procedure TViewDescriptions.cxGridDBBandedTableViewDragDrop(Sender, Source:
    TObject; X, Y: Integer);
var
  AcxCustomGridHitTest: TcxCustomGridHitTest;
  AcxGridDBBandedTableView: TcxGridDBBandedTableView;
  AcxGridRecordCellHitTest: TcxGridRecordCellHitTest;
  AcxGridViewNoneHitTest: TcxGridViewNoneHitTest;
  time: Double;
begin
  // ������ ������ ���� ���������
  Assert(FHRTimer <> nil);
  time := FHRTimer.ReadTimer;
  // ������ ������ �� �����
  FreeAndNil(FHRTimer);

  // ���� ��� ���� ��������� �����������, �� ������ �� ������
  if time < 500 then
    Exit;

  AcxGridDBBandedTableView := nil;

  cxGrid.BeginUpdate();
  try
    // ���������� ����� ��������
    AcxCustomGridHitTest := (Sender as TcxGridSite).ViewInfo.GetHitTest(X, Y);

    if AcxCustomGridHitTest is TcxGridRecordCellHitTest then
    begin
      AcxGridRecordCellHitTest :=
        AcxCustomGridHitTest as TcxGridRecordCellHitTest;
      AcxGridDBBandedTableView := AcxGridRecordCellHitTest.GridView as
        TcxGridDBBandedTableView;

      // ���������� ������� � ����� ��������
      FDropDrag.OrderValue := AcxGridRecordCellHitTest.GridRecord.Values
        [clOrder.Index];

      // ���������� ��� ��������� � ����� ��������
      FDropDrag.Key := AcxGridRecordCellHitTest.GridRecord.Values[clID2.Index];
    end;

    if AcxCustomGridHitTest is TcxGridViewNoneHitTest then
    begin
      AcxGridViewNoneHitTest := AcxCustomGridHitTest as TcxGridViewNoneHitTest;
      AcxGridDBBandedTableView := AcxGridViewNoneHitTest.GridView as
        TcxGridDBBandedTableView;

      FDropDrag.Key := 0;
      FDropDrag.OrderValue := 0;
    end;

    if AcxGridDBBandedTableView <> nil then
    begin
      FDescriptionsGroup.qDescriptionTypes.MoveDSRecord(FStartDrag, FDropDrag);
    end;
  finally
    cxGrid.EndUpdate;
  end;

  GetDBBandedTableView(1).Focused := True;
  UpdateView;

end;

procedure TViewDescriptions.cxGridDBBandedTableViewDragOver(Sender, Source:
    TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
var
  AcxGridRecordCellHitTest: TcxGridRecordCellHitTest;
  AcxGridSite: TcxGridSite;
  AcxGridViewNoneHitTest: TcxGridViewNoneHitTest;
  HT: TcxCustomGridHitTest;
begin
  Accept := False;

  AcxGridSite := Sender as TcxGridSite;
  HT := AcxGridSite.ViewInfo.GetHitTest(X, Y);

  // ���� ������������� �� ������ GridView
  if HT is TcxGridViewNoneHitTest then
  begin
    AcxGridViewNoneHitTest := HT as TcxGridViewNoneHitTest;

    Accept := AcxGridViewNoneHitTest.GridView.Level = FStartDragLevel;
  end;

  // ���� ������������� �� ������ GridView
  if HT is TcxGridRecordCellHitTest then
  begin
    AcxGridRecordCellHitTest := HT as TcxGridRecordCellHitTest;

    Accept := (AcxGridRecordCellHitTest.GridView.Level = FStartDragLevel) and
      (AcxGridRecordCellHitTest.GridRecord.RecordIndex <>
      AcxGridSite.GridView.DataController.FocusedRecordIndex);
  end
end;

procedure TViewDescriptions.cxGridDBBandedTableViewStartDrag(Sender: TObject;
    var DragObject: TDragObject);
var
  I: Integer;
begin
  with (Sender as TcxGridSite).GridView as TcxGridDBBandedTableView do
  begin
    FStartDragLevel := Level as TcxGridLevel;
    Assert(Controller.SelectedRowCount > 0);

    if VarIsNull(Controller.SelectedRows[0].Values[clOrder.Index]) then
      Exit;

    // ���������� ����������� ������� ������ ������� ������ ����������
    FStartDrag.MinOrderValue := Controller.SelectedRows[0].Values
      [clOrder.Index];

    // ���������� ������������ ������� ������ ������� ������ ����������
    FStartDrag.MaxOrderValue := Controller.SelectedRows
      [Controller.SelectedRecordCount - 1].Values[clOrder.Index];

    SetLength(FStartDrag.Keys, Controller.SelectedRowCount);
    for I := 0 to Controller.SelectedRowCount - 1 do
    begin
      FStartDrag.Keys[I] := Controller.SelectedRecords[I].Values[clID2.Index];
    end;

  end;

  // ��������� ������ ����� ���������� ����� �������� �������
  FHRTimer := THRTimer.Create(True);
end;

procedure TViewDescriptions.DoAfterDataChange(Sender: TObject);
begin
//  UpdateView;
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

procedure TViewDescriptions.SetDescriptionsGroup(const Value
  : TDescriptionsGroup);
begin
  FDescriptionsGroup := Value;

  if FDescriptionsGroup <> nil then
  begin
    // ����������� ������������� � ������
    // DBGrid1.DataSource := FDescriptionsGroup.qDescriptionTypes.
    // DataSource;

    cxGridDBBandedTableView.DataController.DataSource :=
      FDescriptionsGroup.qDescriptionTypes.DataSource;
    cxGridDBBandedTableView2.DataController.DataSource :=
      FDescriptionsGroup.qDescriptions.DataSource;

    InitializeLookupColumn(clIDComponentType,
      FDescriptionsGroup.qDescriptionTypes.DataSource, lsEditList,
      FDescriptionsGroup.qDescriptionTypes.ComponentType.FieldName);

    InitializeLookupColumn(clIDProducer,
      FDescriptionsGroup.qProducers.DataSource, lsEditList,
      FDescriptionsGroup.qProducers.Name.FieldName);

    TNotifyEventWrap.Create(FDescriptionsGroup.AfterDataChange,
      DoAfterDataChange, FEventList);
    TNotifyEventWrap.Create(FDescriptionsGroup.qDescriptionTypes.AfterOpen,
      DoAfterDataChange, FEventList);
    TNotifyEventWrap.Create(FDescriptionsGroup.qDescriptions.AfterOpen,
      DoAfterDataChange, FEventList);
  end;
  UpdateView;
end;

procedure TViewDescriptions.UpdateTotalCount;
begin
  // ����� ����� ����������� �� � ��
  StatusBar.Panels[StatusBar.Panels.Count - 1].Text := Format('�����: %d',
    [DescriptionsGroup.qDescriptions.FDQuery.RecordCount]);
end;

procedure TViewDescriptions.UpdateView;
var
  AView: TcxGridDBBandedTableView;
  OK: Boolean;
begin
  AView := FocusedTableView;
  OK := (DescriptionsGroup <> nil) and (AView <> nil);

  actAddType.Enabled := OK and
    (DescriptionsGroup.qDescriptionTypes.FDQuery.Active) and
    (not DescriptionsGroup.qDescriptionTypes.ShowDublicate) and
    (AView.Level = cxGridLevel);

  actAddDescription.Enabled := OK and
    (DescriptionsGroup.qDescriptions.FDQuery.Active) and
    (not DescriptionsGroup.qDescriptionTypes.ShowDublicate) and
    ((AView.Level = cxGridLevel) or (AView.Level = cxGridLevel2));

  actDelete.Enabled := OK and (AView.DataController.RecordCount > 0);

  actCommit.Enabled := OK and (DescriptionsGroup.Connection.InTransaction);

  actRollback.Enabled := actCommit.Enabled;

  actLoadFromExcelDocument.Enabled := (DescriptionsGroup <> nil) and
    (not DescriptionsGroup.qDescriptionTypes.ShowDublicate);

  actExportToExcelDocument.Enabled := (DescriptionsGroup <> nil) and
    (not DescriptionsGroup.qDescriptionTypes.ShowDublicate) and
    (DescriptionsGroup.qDescriptions.FDQuery.RecordCount > 0);

  if actShowDublicate.Checked then
    actShowDublicate.Caption := '�������� ��'
  else
    actShowDublicate.Caption := '�������� ���������';

  UpdateTotalCount;
end;

end.
