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
  cxMemo, ProducersGroupUnit2, cxDBLookupComboBox, DragHelper, HRTimer,
  ColumnsBarButtonsHelper, System.Generics.Collections,
  cxDataControllerConditionalFormattingRulesManagerDialog, dxBarBuiltInMenu;

const
  WM_AFTER_SET_NEW_VALUE = WM_USER + 18;

type
  TViewProducers = class(TfrmGrid)
    clID: TcxGridDBBandedColumn;
    actAdd: TAction;
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
    clOrder: TcxGridDBBandedColumn;
    actRefresh: TAction;
    procedure actAddExecute(Sender: TObject);
    procedure actAddTypeExecute(Sender: TObject);
    procedure actCommitExecute(Sender: TObject);
    procedure actExportToExcelDocumentExecute(Sender: TObject);
    procedure actLoadFromExcelDocumentExecute(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
    procedure actRollbackExecute(Sender: TObject);
    procedure cxGridDBBandedTableView2EditKeyDown
      (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
      AEdit: TcxCustomEdit; var Key: Word; Shift: TShiftState);
    procedure cxGridDBBandedTableViewDataControllerSummaryAfterSummary
      (ASender: TcxDataSummary);
    procedure clProducerTypeIDPropertiesCloseUp(Sender: TObject);
    procedure clProducerTypeIDPropertiesEditValueChanged(Sender: TObject);
    procedure clProducerTypeIDPropertiesNewLookupDisplayText(Sender: TObject;
      const AText: TCaption);
    procedure cxGridDBBandedTableViewDragDrop(Sender, Source: TObject;
      X, Y: Integer);
    procedure cxGridDBBandedTableViewDragOver(Sender, Source: TObject;
      X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure cxGridDBBandedTableViewStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure cxGridDBBandedTableView2StylesGetHeaderStyle
      (Sender: TcxGridTableView; AColumn: TcxGridColumn; var AStyle: TcxStyle);
    procedure cxGridDBBandedTableViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cxGridDBBandedTableViewMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    FDragAndDropInfo: TDragAndDropInfo;
    FEditValueChanged: Boolean;
    FHRTimer: THRTimer;
    FNewValue: string;
    FProducersGroup: TProducersGroup2;

  const
    FolderKey = 'Producers';
    procedure SetProducersGroup(const Value: TProducersGroup2);
    procedure UpdateTotalCount;
    { Private declarations }
  protected
    procedure AfterSetNewValue(var Message: TMessage);
      message WM_AFTER_SET_NEW_VALUE;
    procedure CreateColumnsBarButtons; override;
    function CreateViewArr: TArray<TcxGridDBBandedTableView>; override;
    procedure DoOnHaveAnyChanges(Sender: TObject);
    procedure LoadFromExcel(const AFileName: String);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Locate(const AProducer: string);
    procedure UpdateView; override;
    property ProducersGroup: TProducersGroup2 read FProducersGroup
      write SetProducersGroup;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses NotifyEvents, RepositoryDataModule, DialogUnit,
  ProducersExcelDataModule, ImportErrorForm, CustomExcelTable, System.Math,
  SettingsController, System.IOUtils, ProjectConst, ProgressBarForm,
  cxDropDownEdit, DialogUnit2, CustomErrorForm, LoadFromExcelFileHelper;

constructor TViewProducers.Create(AOwner: TComponent);
begin
  inherited;
  StatusBarEmptyPanelIndex := 1;

  FDragAndDropInfo := TDragAndDropInfo.Create(clID, clOrder);

  PostOnEnterFields.Add(clProducerType.DataBinding.FieldName);
  PostOnEnterFields.Add(clName2.DataBinding.FieldName);

  DeleteMessages.Add(cxGridLevel, '������� ���?');
  DeleteMessages.Add(cxGridLevel2, '������� �������������?');
  ApplyBestFitForDetail := True;
end;

destructor TViewProducers.Destroy;
begin
  FreeAndNil(FDragAndDropInfo);
  inherited;
end;

procedure TViewProducers.actAddExecute(Sender: TObject);
var
  ARow: TcxGridMasterDataRow;
  AView: TcxGridDBBandedTableView;
begin
  ARow := GetRow(0) as TcxGridMasterDataRow;
  ARow.Expand(false);
  AView := GetDBBandedTableView(1);
  AView.DataController.Append;
  FocusColumnEditor(1, ProducersGroup.qProducers.W.Name.FieldName);
end;

procedure TViewProducers.actAddTypeExecute(Sender: TObject);
begin
  inherited;
  MainView.Controller.ClearSelection;
  MainView.DataController.Append;
  FocusColumnEditor(0, ProducersGroup.qProducerTypes.W.ProducerType.FieldName);

  UpdateView;
end;

procedure TViewProducers.actCommitExecute(Sender: TObject);
begin
  ProducersGroup.Commit;
  UpdateView;
end;

procedure TViewProducers.actExportToExcelDocumentExecute(Sender: TObject);
var
  AFileName: String;
begin
  Application.Hint := '';
  if not TDialog.Create.ShowDialog(TExcelFileSaveDialog,
    TSettings.Create.GetFolderFoExcelFile(FolderKey), '�������������', AFileName)
  then
    Exit;

  ExportViewToExcel(cxGridDBBandedTableView2, AFileName,
    procedure(AView: TcxGridDBBandedTableView)
    var
      AColumn: TcxGridDBBandedColumn;
    begin
      AColumn := AView.GetColumnByFieldName
        (ProducersGroup.qProducers.W.Cnt.FieldName);
      if AColumn <> nil then
        AColumn.Visible := false;
    end);
end;

procedure TViewProducers.actLoadFromExcelDocumentExecute(Sender: TObject);
var
  AFileName: string;
begin
  Application.Hint := '';
  if not TOpenExcelDialog.SelectInFolder(AFileName, Handle, FolderKey) then
    Exit;

  LoadFromExcel(AFileName);
end;

procedure TViewProducers.actRefreshExecute(Sender: TObject);
begin
  inherited;
  ProducersGroup.RefreshData;
end;

procedure TViewProducers.actRollbackExecute(Sender: TObject);
begin
  cxGrid.BeginUpdate();
  try
    // �������� ��� ��������� ���������
    ProducersGroup.Rollback;

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

procedure TViewProducers.AfterSetNewValue(var Message: TMessage);
var
  ADetailID: Integer;
  ARow: TcxGridMasterDataRow;
  AMasterID: Integer;
begin
  inherited;

  // ��������� ����� ��� ��������
  ProducersGroup.qProducerTypes.LocateOrAppend(FNewValue);
  FNewValue := '';

  AMasterID := ProducersGroup.qProducerTypes.W.PK.AsInteger;
  ADetailID := Message.WParam;

  // ���� ��������
  ProducersGroup.qProducers.W.LocateByPK(ADetailID);
  ProducersGroup.qProducers.W.TryEdit;
  ProducersGroup.qProducers.W.ProducerTypeID.F.AsInteger := AMasterID;
  ProducersGroup.qProducers.W.TryPost;

  ARow := GetRow(0) as TcxGridMasterDataRow;
  Assert(ARow <> nil);

  ARow.Expand(false);
  FocusColumnEditor(1, ProducersGroup.qProducers.W.ProducerTypeID.FieldName);
end;

procedure TViewProducers.clProducerTypeIDPropertiesCloseUp(Sender: TObject);
begin
  inherited;
  if FEditValueChanged then
  begin
    FEditValueChanged := false;
    cxGridDBBandedTableView2.DataController.Post();
  end
end;

procedure TViewProducers.clProducerTypeIDPropertiesEditValueChanged
  (Sender: TObject);
var
  ADetailID: Integer;
  AMasterID: Integer;
begin
  if not FNewValue.IsEmpty then
  begin
    ADetailID := ProducersGroup.qProducers.W.PK.AsInteger;
    AMasterID := ProducersGroup.qProducerTypes.W.PK.AsInteger;

    // ���������� ���� ������ �������� �������� �����
    ProducersGroup.qProducers.W.ProducerTypeID.F.AsInteger := AMasterID;
    ProducersGroup.qProducers.W.TryPost;

    // �������� ��������� � ��� ��� �������� �������� ����� ���� ����� ��������
    PostMessage(Handle, WM_AFTER_SET_NEW_VALUE, ADetailID, 0);
  end
  else
    FEditValueChanged := True;
end;

procedure TViewProducers.clProducerTypeIDPropertiesNewLookupDisplayText
  (Sender: TObject; const AText: TCaption);
begin
  inherited;
  FNewValue := AText;

end;

procedure TViewProducers.CreateColumnsBarButtons;
begin
  FColumnsBarButtons := TGVColumnsBarButtons.Create(Self, dxbsColumns,
    cxGridDBBandedTableView2);
end;

function TViewProducers.CreateViewArr: TArray<TcxGridDBBandedTableView>;
begin
  Result := [MainView, cxGridDBBandedTableView2];
end;

procedure TViewProducers.cxGridDBBandedTableView2EditKeyDown
  (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
AEdit: TcxCustomEdit; var Key: Word; Shift: TShiftState);
begin
  inherited;
  DoOnEditKeyDown(Sender, AItem, AEdit, Key, Shift);
end;

procedure TViewProducers.cxGridDBBandedTableView2StylesGetHeaderStyle
  (Sender: TcxGridTableView; AColumn: TcxGridColumn; var AStyle: TcxStyle);
begin
  inherited;
  DoOnGetHeaderStyle(AColumn, AStyle);
end;

procedure TViewProducers.
  cxGridDBBandedTableViewDataControllerSummaryAfterSummary
  (ASender: TcxDataSummary);
var
  AIndex: Integer;
  S: string;
begin
  inherited;
  AIndex := MainView.DataController.Summary.FooterSummaryItems.IndexOfItemLink
    (clProducerType);
  S := VarToStrDef(MainView.DataController.Summary.FooterSummaryValues
    [AIndex], '---');
  StatusBar.Panels[0].Text := S;
end;

procedure TViewProducers.cxGridDBBandedTableViewDragDrop(Sender,
  Source: TObject; X, Y: Integer);
var
  time: Double;
begin
  // ������ ������ ���� ���������
  Assert(FHRTimer <> nil);
  time := FHRTimer.ReadTimer;
  // ������ ������ �� �����
  FreeAndNil(FHRTimer);

  // ���� ��� ���� ��������� �����������, �� ������ �� ������
  if time < DragDropTimeOut then
    Exit;

  DoDragDrop(Sender as TcxGridSite, FDragAndDropInfo,
    FProducersGroup.qProducerTypes, X, Y);
end;

procedure TViewProducers.cxGridDBBandedTableViewDragOver(Sender,
  Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  inherited;
  DoDragOver(Sender as TcxGridSite, X, Y, Accept);
end;

procedure TViewProducers.cxGridDBBandedTableViewKeyDown(Sender: TObject;
var Key: Word; Shift: TShiftState);
begin
  inherited;
  DoOnKeyOrMouseDown;
end;

procedure TViewProducers.cxGridDBBandedTableViewMouseDown(Sender: TObject;
Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  DoOnKeyOrMouseDown;
end;

procedure TViewProducers.cxGridDBBandedTableViewStartDrag(Sender: TObject;
var DragObject: TDragObject);
begin
  inherited;
  DoOnStartDrag(Sender as TcxGridSite, FDragAndDropInfo);

  // ��������� ������ ����� ���������� ����� �������� �������
  FHRTimer := THRTimer.Create(True);

end;

procedure TViewProducers.DoOnHaveAnyChanges(Sender: TObject);
begin
  UpdateView;
end;

procedure TViewProducers.LoadFromExcel(const AFileName: String);
begin
  BeginUpdate;
  try
    TLoad.Create.LoadAndProcess(AFileName, TProducersExcelDM, TfrmImportError,
      procedure(ASender: TObject)
      begin
        ProducersGroup.LoadDataFromExcelTable(ASender as TProducersExcelTable);
      end,
      procedure(ASender: TObject)
      begin
        (ASender as TProducersExcelTable).ProducerInt :=
          ProducersGroup.qProducers;
      end);
  finally
    EndUpdate;
  end;

  UpdateView;

end;

// ���� ������������� � �����
procedure TViewProducers.Locate(const AProducer: string);
var
  Arr: TArray<String>;
  ARow: TcxGridMasterDataRow;
  AView: TcxGridDBBandedTableView;
begin
  BeginUpdate;
  try
    Arr := ProducersGroup.Find(AProducer);
  finally
    EndUpdate;
  end;

  // ������� ���� �� ������ ������ (�� �������� ���������)
  if (Length(Arr) > 0) and
    (MainView.DataController.Search.Locate(clProducerType.Index, Arr[0], True,
    True)) then
  begin
    // ����� ���� �� ������ ������ (�� ������������ �������������)
    if Length(Arr) > 1 then
    begin
      ARow := GetRow(0) as TcxGridMasterDataRow;
      ARow.Expand(false);
      AView := GetDBBandedTableView(1);
      AView.Focused := True;
      AView.DataController.Search.Locate(clName2.Index, Arr[1], True, True);
      PutInTheCenterFocusedRecord(AView);
    end
    else
      PutInTheCenterFocusedRecord(MainView);
  end;
end;

procedure TViewProducers.SetProducersGroup(const Value: TProducersGroup2);
begin
  if FProducersGroup <> Value then
  begin
    FProducersGroup := Value;
    if FProducersGroup <> nil then
    begin
      MainView.DataController.DataSource :=
        FProducersGroup.qProducerTypes.W.DataSource;
      GridView(cxGridLevel2).DataController.DataSource :=
        FProducersGroup.qProducers.W.DataSource;

      TNotifyEventWrap.Create
        (FProducersGroup.qProducers.Monitor.OnHaveAnyChanges,
        DoOnHaveAnyChanges, FEventList);

      TNotifyEventWrap.Create(FProducersGroup.qProducerTypes.W.AfterOpen,
        DoOnHaveAnyChanges, FEventList);

      TNotifyEventWrap.Create(FProducersGroup.qProducers.W.AfterOpen,
        DoOnHaveAnyChanges, FEventList);

      InitializeLookupColumn(clProducerTypeID,
        FProducersGroup.qProducerTypes.W.DataSource, lsEditList,
        FProducersGroup.qProducerTypes.W.ProducerType.FieldName);

      MainView.ViewData.Collapse(True);
    end
    else
    begin
      MainView.DataController.DataSource := nil;
    end;

    PostMyApplyBestFitEventForView(cxGridDBBandedTableView2);

    UpdateView;
  end;
end;

procedure TViewProducers.UpdateTotalCount;
begin
  // ����� ����� ����������� �� � ��
  StatusBar.Panels[StatusBar.Panels.Count - 1].Text :=
    Format('�����: %d', [ProducersGroup.qProducers.FDQuery.RecordCount]);
end;

procedure TViewProducers.UpdateView;
var
  AView: TcxGridDBBandedTableView;
  OK: Boolean;
begin
  AView := FocusedTableView;
  OK := (ProducersGroup <> nil) and
    (ProducersGroup.qProducerTypes.FDQuery.Active) and
    (ProducersGroup.qProducers.FDQuery.Active);

  actAdd.Enabled := OK and (AView <> nil) and
    (MainView.Controller.SelectedRowCount = 1);

  actAddType.Enabled := OK and (AView <> nil) and (AView.Level = cxGridLevel);

  // ������� ��������� ������ ���� ���-�� ��������
  actDeleteEx.Enabled := OK and (AView <> nil) and
    (AView.Controller.SelectedRowCount > 0);;

  actCommit.Enabled := OK and (ProducersGroup.HaveAnyChanges);

  actRollback.Enabled := actCommit.Enabled;

  actExportToExcelDocument.Enabled := OK and
    (AView.ViewData.RowCount > 0);

  UpdateTotalCount;
end;

end.
