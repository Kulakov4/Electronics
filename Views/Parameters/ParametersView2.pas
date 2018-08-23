unit ParametersView2;

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
  dxSkinXmas2008Blue, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit,
  cxNavigator, cxDataControllerConditionalFormattingRulesManagerDialog, Data.DB,
  cxDBData, dxBarBuiltInMenu, cxGridCustomPopupMenu, cxGridPopupMenu, Vcl.Menus,
  System.Actions, Vcl.ActnList, dxBar, cxClasses, Vcl.ComCtrls, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridBandedTableView, cxGridDBBandedTableView, cxGrid, ParametersGroupUnit2,
  NotifyEvents, ParametersExcelDataModule, cxTextEdit, cxBarEditItem,
  DragHelper, HRTimer, cxBlobEdit, cxDBLookupComboBox;

const
  // ����� ���������� ����� ����� ��� ���������
  WM_NEED_CHANGE_PARAMETER_TYPE = WM_USER + 12;

type
  TViewParameters2 = class(TfrmGrid)
    clID: TcxGridDBBandedColumn;
    clParameterType: TcxGridDBBandedColumn;
    clOrd: TcxGridDBBandedColumn;
    cxGridLevel2: TcxGridLevel;
    cxGridDBBandedTableView2: TcxGridDBBandedTableView;
    clID2: TcxGridDBBandedColumn;
    clOrder: TcxGridDBBandedColumn;
    clChecked: TcxGridDBBandedColumn;
    clValue: TcxGridDBBandedColumn;
    clCodeLetters: TcxGridDBBandedColumn;
    clMeasuringUnit: TcxGridDBBandedColumn;
    clTableName: TcxGridDBBandedColumn;
    clValueT: TcxGridDBBandedColumn;
    clDefinition: TcxGridDBBandedColumn;
    clIDParameterType: TcxGridDBBandedColumn;
    clIDParameterKind: TcxGridDBBandedColumn;
    actAddParameterType: TAction;
    actAddParameter: TAction;
    actCommit: TAction;
    actRollback: TAction;
    actFilterByTableName: TAction;
    actRefresh: TAction;
    dxBarButton1: TdxBarButton;
    actLoadFromExcelDocument: TAction;
    actLoadFromExcelSheet: TAction;
    actSearch: TAction;
    dxBarManagerBar1: TdxBar;
    cxbeiSearch: TcxBarEditItem;
    dxBarButton2: TdxBarButton;
    actShowDuplicate: TAction;
    actExportToExcelDocument: TAction;
    dxBarButton3: TdxBarButton;
    dxBarButton4: TdxBarButton;
    dxBarButton5: TdxBarButton;
    dxBarSubItem1: TdxBarSubItem;
    dxBarButton6: TdxBarButton;
    dxBarButton7: TdxBarButton;
    dxBarButton8: TdxBarButton;
    dxBarButton9: TdxBarButton;
    dxBarButton10: TdxBarButton;
    dxBarManagerBar2: TdxBar;
    dxBarButton11: TdxBarButton;
    dxBarButton12: TdxBarButton;
    dxBarManagerBar3: TdxBar;
    dxBarButton13: TdxBarButton;
    actDisableControls: TAction;
    actEnableControls: TAction;
    actReopen: TAction;
    dxBarButton14: TdxBarButton;
    dxBarButton15: TdxBarButton;
    actCheckDetailView: TAction;
    dxBarButton16: TdxBarButton;
    actApplyBestFit: TAction;
    dxBarButton17: TdxBarButton;
    procedure actAddParameterExecute(Sender: TObject);
    procedure actAddParameterTypeExecute(Sender: TObject);
    procedure actApplyBestFitExecute(Sender: TObject);
    procedure actCheckDetailViewExecute(Sender: TObject);
    procedure actCommitExecute(Sender: TObject);
    procedure actDisableControlsExecute(Sender: TObject);
    procedure actEnableControlsExecute(Sender: TObject);
    procedure actExportToExcelDocumentExecute(Sender: TObject);
    procedure actFilterByTableNameExecute(Sender: TObject);
    procedure actLoadFromExcelDocumentExecute(Sender: TObject);
    procedure actLoadFromExcelSheetExecute(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
    procedure actReopenExecute(Sender: TObject);
    procedure actRollbackExecute(Sender: TObject);
    procedure actSearchExecute(Sender: TObject);
    procedure actShowDuplicateExecute(Sender: TObject);
    procedure cxbeiSearchPropertiesEditValueChanged(Sender: TObject);
    procedure cxbeiSearchPropertiesValidate(Sender: TObject;
      var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
    procedure cxGridDBBandedTableView2DragDrop(Sender, Source: TObject; X, Y:
        Integer);
    procedure cxGridDBBandedTableView2DragOver(Sender, Source: TObject; X, Y:
        Integer; State: TDragState; var Accept: Boolean);
    procedure cxGridDBBandedTableView2StartDrag(Sender: TObject; var DragObject:
        TDragObject);
    procedure cxGridDBBandedTableViewDragDrop(Sender, Source: TObject; X, Y:
        Integer);
    procedure cxGridDBBandedTableViewDragOver(Sender, Source: TObject; X, Y:
        Integer; State: TDragState; var Accept: Boolean);
    procedure cxGridDBBandedTableViewStartDrag(Sender: TObject; var DragObject:
        TDragObject);
    procedure cxGridDBBandedTableViewDataControllerDetailExpanded(
      ADataController: TcxCustomDataController; ARecordIndex: Integer);
    procedure clIDParameterTypePropertiesNewLookupDisplayText(Sender: TObject;
      const AText: TCaption);
    procedure clIDParameterTypePropertiesEditValueChanged(Sender: TObject);
    procedure clIDParameterTypePropertiesCloseUp(Sender: TObject);
  private
    FCheckedMode: Boolean;
    FDetailView: TcxGridDBBandedTableView;
    FHRTimer: THRTimer;
    FNewParameterType: string;
    FParametersDI: TDragAndDropInfo;
    FParametersGrp: TParametersGroup2;
    FParameterTypesDI: TDragAndDropInfo;
  const
    FolderKey: String = 'Parameters';
    procedure LoadDataFromExcelTable(AData: TParametersExcelTable);
    procedure SetCheckedMode(const Value: Boolean);
    procedure SetParametersGrp(const Value: TParametersGroup2);
    procedure UpdateAutoTransaction;
    procedure UpdateTotalCount;
    { Private declarations }
  protected
    procedure ChangeParameterType(var Message: TMessage); message
        WM_NEED_CHANGE_PARAMETER_TYPE;
    procedure DoOnHaveAnyChanges(Sender: TObject);
    procedure LoadFromExcel(AFileName: string);
    procedure LocateAndFocus(AParameterID: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CheckAndSaveChanges: Integer;
    procedure CommitOrPost;
    procedure Search(const AName: string);
    procedure UpdateView; override;
    property CheckedMode: Boolean read FCheckedMode write SetCheckedMode;
    property ParametersGrp: TParametersGroup2 read FParametersGrp write
        SetParametersGrp;
    { Public declarations }
  end;

var
  ViewParameters2: TViewParameters2;

implementation

uses
  cxDropDownEdit, DialogUnit, System.Generics.Collections, System.StrUtils,
  DialogUnit2, LoadFromExcelFileHelper, ProgressBarForm, ProjectConst,
  ImportErrorForm, RepositoryDataModule, SettingsController, GridSort;

{$R *.dfm}

constructor TViewParameters2.Create(AOwner: TComponent);
begin
  inherited;
  // clCodeLetters.Caption := clCodeLetters.Caption.Replace(' ', #13#10);
  // clMeasuringUnit.Caption := clMeasuringUnit.Caption.Replace(' ', #13#10);
  ApplyBestFitMultiLine := True;

  FParameterTypesDI := TDragAndDropInfo.Create(clID, clOrd);
  FParametersDI := TDragAndDropInfo.Create(clID2, clOrder);

  // ��������� ���������� ������ "�������"
  FCheckedMode := True;
  CheckedMode := False;
  StatusBarEmptyPanelIndex := 1;

  PostOnEnterFields.Add(clParameterType.DataBinding.FieldName);
  PostOnEnterFields.Add(clValue.DataBinding.FieldName);
  PostOnEnterFields.Add(clIDParameterType.DataBinding.FieldName);

  DeleteMessages.Add(cxGridLevel, '������� ���?');
  DeleteMessages.Add(cxGridLevel2, '������� ��������?');

  FHRTimer := THRTimer.Create(False);

  GridSort.Add(TSortVariant.Create(clOrd, [clOrd]));
  GridSort.Add(TSortVariant.Create(clOrder, [clOrder]));

  // ��������� ����
  ApplySort(MainView, clOrd);

  // ��������� ��������� �� ������� �������
  ApplySort(cxGridDBBandedTableView2, clOrder);
end;

destructor TViewParameters2.Destroy;
begin
  FreeAndNil(FHRTimer);
  FreeAndNil(FParametersDI);
  FreeAndNil(FParameterTypesDI);
  inherited;
end;

procedure TViewParameters2.actAddParameterExecute(Sender: TObject);
var
  ARow: TcxGridMasterDataRow;
  AView: TcxGridDBBandedTableView;
begin
  inherited;
  // ������� ��������� ��� ���������
  FParametersGrp.qParameterTypes.TryPost;

  ARow := GetRow(0) as TcxGridMasterDataRow;
  ARow.Expand(False);
  AView := GetDBBandedTableView(1);
  AView.Controller.ClearSelection;
  AView.DataController.Append;
  FocusColumnEditor(1, clValue.DataBinding.FieldName);

  UpdateView;
end;

procedure TViewParameters2.actAddParameterTypeExecute(Sender: TObject);
begin
  inherited;
  MainView.Controller.ClearSelection;
  MainView.DataController.Append;
  FocusColumnEditor(0, clParameterType.DataBinding.FieldName);

  UpdateView;
end;

procedure TViewParameters2.actApplyBestFitExecute(Sender: TObject);
begin
  inherited;
  ShowMessage(IntToStr(FDetailView.ViewData.RowCount));
  MyApplyBestFitForView(FDetailView);
end;

procedure TViewParameters2.actCheckDetailViewExecute(Sender: TObject);
var
  AIsOK: Boolean;
begin
  inherited;
  if FDetailView = nil then
    Exit;

  AIsOK := FDetailView.ViewInfo.HeaderViewInfo.BandsViewInfo.Count > 0;
  ShowMessage(BoolToStr(AIsOK, True));
end;

procedure TViewParameters2.actCommitExecute(Sender: TObject);
begin
  inherited;
  FParametersGrp.Commit;

  // ��������� �������������
  UpdateView;
end;

procedure TViewParameters2.actDisableControlsExecute(Sender: TObject);
begin
  inherited;
  ParametersGrp.DisableControls;
end;

procedure TViewParameters2.actEnableControlsExecute(Sender: TObject);
begin
  inherited;
  ParametersGrp.EnableControls;
end;

procedure TViewParameters2.actExportToExcelDocumentExecute(Sender: TObject);
var
  AFileName: String;
begin
  inherited;

  Application.Hint := '';
  if not TDialog.Create.ShowDialog(TExcelFileSaveDialog,
    TSettings.Create.GetFolderFoExcelFile(FolderKey), '���������', AFileName)
  then
    Exit;

  ExportViewToExcel(cxGridDBBandedTableView2, AFileName);
end;

procedure TViewParameters2.actFilterByTableNameExecute(Sender: TObject);
var
  AID: Variant;
  S: string;
begin
  actFilterByTableName.Checked := not actFilterByTableName.Checked;
  AID := ParametersGrp.qParameters.PK.Value;

  S := IfThen(actFilterByTableName.Checked,
    ParametersGrp.qParameters.TableName.AsString, '');
  cxGrid.BeginUpdate();
  try
    ParametersGrp.qParameterTypes.TryPost;
    ParametersGrp.qParameters.TryPost;
//    ParametersGrp.qSubParameters.TryPost;

    // ��������� ��������� �� ���������� �����
    ParametersGrp.qParameters.TableNameFilter := S;
    // ��������� ���� ���������� �� ���������� �����
    ParametersGrp.qParameterTypes.TableNameFilter := S;
  finally
    cxGrid.EndUpdate;
  end;

  if actFilterByTableName.Checked then
    MainView.ViewData.Expand(True)
  else
    LocateAndFocus(AID);

  // ��������� �������������
  UpdateView;
end;

procedure TViewParameters2.actLoadFromExcelDocumentExecute(Sender: TObject);
var
  AFileName: string;
begin
  inherited;
  Application.Hint := '';
  if TOpenExcelDialog.SelectInFolder(AFileName, Handle, FolderKey) then
    LoadFromExcel(AFileName);
end;

procedure TViewParameters2.actLoadFromExcelSheetExecute(Sender: TObject);
begin
  inherited;
  Application.Hint := '';
  LoadFromExcel('');
end;

procedure TViewParameters2.actRefreshExecute(Sender: TObject);
begin
  inherited;
//  cxGrid.BeginUpdate();
//  try
//    FParametersGrp.XXX;
    FParametersGrp.RefreshData;
//  finally
//    cxGrid.EndUpdate;
//  end;
end;

procedure TViewParameters2.actReopenExecute(Sender: TObject);
begin
  inherited;
  ParametersGrp.ReOpen;
end;

procedure TViewParameters2.actRollbackExecute(Sender: TObject);
begin
  inherited;

  // ����� ������������ � �������� ������ ��������� ������
  DisableCollapsingAndExpanding;
  cxGrid.BeginUpdate();
  try
    // �������� ��� ��������� ���������
    FParametersGrp.Rollback;

    // ��������� ����� �� ������ ���������� ������
    FocusSelectedRecord(MainView);
  finally
    cxGrid.EndUpdate;
    EnableCollapsingAndExpanding;
  end;

  // �������� ����� � ����� �����
  PutInTheCenterFocusedRecord(MainView);

  // ��������� �������������
  UpdateView;
end;

procedure TViewParameters2.actSearchExecute(Sender: TObject);
var
  S: string;
begin
  inherited;
  S := cxbeiSearch.EditValue;
  Search(S);
end;

procedure TViewParameters2.actShowDuplicateExecute(Sender: TObject);
var
  AID: Variant;
  d: Boolean;
begin
  inherited;

  Application.Hint := '';
  AID := ParametersGrp.qParameters.PK.Value;

  d := not ParametersGrp.qParameters.ShowDuplicate;
  actShowDuplicate.Checked := d;

  cxGrid.BeginUpdate();
  try
    ParametersGrp.qParameterTypes.TryPost;
    ParametersGrp.qParameters.TryPost;
    ParametersGrp.qParameterTypes.ShowDuplicate := d;
    ParametersGrp.qParameters.ShowDuplicate := d;
  finally
    cxGrid.EndUpdate;
  end;

  if actShowDuplicate.Checked then
    LocateAndFocus(AID)
  else
    // �������� ������ "�������� ���" - ������ ����������� ����� � �������� ����.
    MainView.ViewData.Collapse(True);

  // ��������� �������������
  UpdateView;

end;

procedure TViewParameters2.ChangeParameterType(var Message: TMessage);
var
  ADetailID: Integer;
  ARow: TcxGridMasterDataRow;
  AMasterID: Integer;
begin
  inherited;
  Assert(not FNewParameterType.IsEmpty);
  // ��������� ����� ��� ���������
  FParametersGrp.qParameterTypes.LocateOrAppend(FNewParameterType);
  FNewParameterType := '';

  AMasterID := FParametersGrp.qParameterTypes.PK.AsInteger;
  ADetailID := Message.WParam;

  // ���� ��������
  FParametersGrp.qParameters.LocateByPK(ADetailID);
  FParametersGrp.qParameters.TryEdit;
  FParametersGrp.qParameters.IDParameterType.AsInteger := AMasterID;
  FParametersGrp.qParameters.TryPost;

  ARow := GetRow(0) as TcxGridMasterDataRow;
  Assert(ARow <> nil);

  // AView := GetDBBandedTableView(1);
  ARow.Expand(False);
  FocusColumnEditor(1, clIDParameterType.DataBinding.FieldName);
end;

function TViewParameters2.CheckAndSaveChanges: Integer;
begin
  UpdateView;
  Result := 0;
  if ParametersGrp = nil then
    Exit;

  if ParametersGrp.HaveAnyChanges then
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

procedure TViewParameters2.clIDParameterTypePropertiesCloseUp(Sender: TObject);
begin
  inherited;
  cxGridDBBandedTableView2.DataController.Post();
end;

procedure TViewParameters2.clIDParameterTypePropertiesEditValueChanged(
  Sender: TObject);
var
  ADetailID: Integer;
  AMasterID: Integer;
begin
  if not FNewParameterType.IsEmpty then
  begin
    ADetailID := FParametersGrp.qParameters.PK.AsInteger;
    AMasterID := FParametersGrp.qParameterTypes.PK.AsInteger;

    // ���������� ���� ������ �������� �������� �����
    FParametersGrp.qParameters.IDParameterType.AsInteger := AMasterID;
    FParametersGrp.qParameters.TryPost;

    // �������� ��������� � ��� ��� �������� �������� ����� ���� ����� ��������
    PostMessage(Handle, WM_NEED_CHANGE_PARAMETER_TYPE, ADetailID, 0);
  end
  else
  ;
//    FEditValueChanged := True;

end;

procedure TViewParameters2.clIDParameterTypePropertiesNewLookupDisplayText(
  Sender: TObject; const AText: TCaption);
begin
  inherited;
  FNewParameterType := AText;
end;

procedure TViewParameters2.CommitOrPost;
begin
  // actCommit ����� ���� Disabled!!!
  UpdateView;

  if CheckedMode then // � ���� ������ ���������� �� ������
    ParametersGrp.TryPost
  else
    actCommit.Execute; // ��������� ����������
end;

procedure TViewParameters2.cxbeiSearchPropertiesEditValueChanged(
  Sender: TObject);
begin
  inherited;
  UpdateView;
  actSearch.Execute;
end;

procedure TViewParameters2.cxbeiSearchPropertiesValidate(Sender: TObject;
  var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
begin
  inherited;
  cxbeiSearch.EditValue := DisplayValue;
end;

procedure TViewParameters2.cxGridDBBandedTableView2DragDrop(Sender, Source:
    TObject; X, Y: Integer);
var
  time: Double;
begin
  inherited;
  // ������ ������ ���� ���������
  Assert(FHRTimer <> nil);
  time := FHRTimer.ReadTimer;

  // ���� ��� ���� ��������� �����������, �� ������ �� ������
  if time < DragDropTimeOut then
    Exit;

  DoDragDrop(Sender as TcxGridSite, FParametersDI,
    FParametersGrp.qParameters, X, Y);
end;

procedure TViewParameters2.cxGridDBBandedTableView2DragOver(Sender, Source:
    TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  inherited;
  DoDragOver(Sender as TcxGridSite, X, Y, Accept);
end;

procedure TViewParameters2.cxGridDBBandedTableView2StartDrag(Sender: TObject;
    var DragObject: TDragObject);
begin
  inherited;
  DoOnStartDrag(Sender as TcxGridSite, FParametersDI);

  // ��������� ������ ����� ���������� ����� �������� �������
  FHRTimer.StartTimer
end;

procedure TViewParameters2.cxGridDBBandedTableViewDataControllerDetailExpanded(
  ADataController: TcxCustomDataController; ARecordIndex: Integer);
var
  AcxGridMasterDataRow: TcxGridMasterDataRow;
  ARowIndex: Integer;
  AView: TcxGridDBBandedTableView;
begin
  inherited;

  if ARecordIndex < 0 then
    Exit;

  ARowIndex := ADataController.GetRowIndexByRecordIndex(ARecordIndex, False);

  AcxGridMasterDataRow := cxGridDBBandedTableView.ViewData.Rows[ARowIndex]
    as TcxGridMasterDataRow;

  AView := AcxGridMasterDataRow.ActiveDetailGridView as
    TcxGridDBBandedTableView;

  MyApplyBestFitForView(AView);
end;

procedure TViewParameters2.cxGridDBBandedTableViewDragDrop(Sender, Source:
    TObject; X, Y: Integer);
var
  time: Double;
begin
  // ������ ������ ���� ���������
  Assert(FHRTimer <> nil);
  time := FHRTimer.ReadTimer;

  // ���� ��� ���� ��������� �����������, �� ������ �� ������
  if time < DragDropTimeOut then
    Exit;

  DoDragDrop(Sender as TcxGridSite, FParameterTypesDI,
    FParametersGrp.qParameterTypes, X, Y);
end;

procedure TViewParameters2.cxGridDBBandedTableViewDragOver(Sender, Source:
    TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  inherited;
  DoDragOver(Sender as TcxGridSite, X, Y, Accept);
end;

procedure TViewParameters2.cxGridDBBandedTableViewStartDrag(Sender: TObject;
    var DragObject: TDragObject);
begin
  inherited;

  DoOnStartDrag(Sender as TcxGridSite, FParameterTypesDI);

  // ��������� ������ ����� ���������� ����� �������� �������
  FHRTimer.StartTimer;
end;

procedure TViewParameters2.DoOnHaveAnyChanges(Sender: TObject);
begin
  UpdateView;
end;

procedure TViewParameters2.LoadDataFromExcelTable(AData: TParametersExcelTable);
begin
  cxGridDBBandedTableView.BeginUpdate();
  try
    TfrmProgressBar.Process(AData,
      procedure(ASender: TObject)
      begin
        ParametersGrp.LoadDataFromExcelTable(AData);
      end, '���������� ���������� � ��', sRecords);

  finally
    cxGridDBBandedTableView.EndUpdate;
  end;
end;

procedure TViewParameters2.LoadFromExcel(AFileName: string);
begin
  BeginUpdate;
  try
    TLoad.Create.LoadAndProcess(AFileName, TParametersExcelDM, TfrmImportError,
      procedure(ASender: TObject)
      begin
        LoadDataFromExcelTable(ASender as TParametersExcelTable)
      end,
      procedure(ASender: TObject)
      begin
        (ASender as TParametersExcelTable).ParametersGroupInt := ParametersGrp;
      end);
  finally
    EndUpdate;
  end;
  UpdateView;
end;

procedure TViewParameters2.LocateAndFocus(AParameterID: Integer);
var
  ARow: TcxGridMasterDataRow;
  AView: TcxGridDBBandedTableView;
begin
  // ��������� �� �������� � ��� ���
  if not ParametersGrp.LocateAll(AParameterID) then
    Exit; // ���� ����� �������� �� ����� ��� ������� �������� �������

  // ������ � ���� - � ����
  PutInTheCenterFocusedRecord(MainView);

  // ������������� ������
  ARow := MainView.Controller.FocusedRow as TcxGridMasterDataRow;
  Assert(ARow <> nil);
  ARow.Expand(False);

  AView := ARow.ActiveDetailGridView as TcxGridDBBandedTableView;

  // ���������� ���
  AView.Focused := True;
  // ������ � ��������� - � �����
  PutInTheCenterFocusedRecord(AView);

  // �������� ������ � �������
  AView.ViewData.Records[AView.Controller.FocusedRecordIndex].Selected := True;
  AView.Columns[clValue.Index].Selected := True;
end;

procedure TViewParameters2.Search(const AName: string);
var
  AColumn: TcxGridDBBandedColumn;
  ARow: TcxGridMasterDataRow;
  AView: TcxGridDBBandedTableView;
  List: TList<String>;
  S: string;
begin
  Assert(not AName.IsEmpty);
  S := AName;

  // ����� ������ �� ���������� ����� (���� �� �������� ���������)
  AColumn := clTableName;

  List := ParametersGrp.Find(AColumn.DataBinding.FieldName, S);
  try
    // ������� ���� �� ������ ������ (�� �������� ���������)
    if (List.Count > 0) and
      (MainView.DataController.Search.Locate(clParameterType.Index, List[0],
      True)) then
    begin
      // ����� ���� �� ������ ������ (�� ���������� �����)
      if List.Count > 1 then
      begin
        ARow := GetRow(0) as TcxGridMasterDataRow;
        ARow.Expand(False);
        AView := GetDBBandedTableView(1);
        AView.Focused := True;
        AView.DataController.Search.Locate(AColumn.Index, List[1], True);
        PutInTheCenterFocusedRecord(AView);
      end
      else
        PutInTheCenterFocusedRecord(MainView);
    end;
  finally
    FreeAndNil(List);
  end;

  UpdateView;
end;

procedure TViewParameters2.SetCheckedMode(const Value: Boolean);
begin
  if FCheckedMode = Value then
    Exit;

  FCheckedMode := Value;
  clChecked.Visible := FCheckedMode;
  clChecked.VisibleForCustomization := clOrder.Visible;

  if ParametersGrp <> nil then
  begin
    UpdateAutoTransaction;
  end;
end;

procedure TViewParameters2.SetParametersGrp(const Value: TParametersGroup2);
begin
  if FParametersGrp = Value then
    Exit;

  FParametersGrp := Value;
  FEventList.Clear;

  if FParametersGrp <> nil then
  begin
    cxGridDBBandedTableView.DataController.DataSource :=
      FParametersGrp.qParameterTypes.DataSource;
    cxGridDBBandedTableView2.DataController.DataSource :=
      FParametersGrp.qParameters.DataSource;

    InitializeLookupColumn(clIDParameterType,
      FParametersGrp.qParameterTypes.DataSource, lsEditList,
      FParametersGrp.qParameterTypes.ParameterType.FieldName);

    InitializeLookupColumn(clIDParameterKind,
      FParametersGrp.qParameterKinds.DataSource, lsEditFixedList,
      FParametersGrp.qParameterKinds.ParameterKind.FieldName);

    // ����� ������� �������� ��� ��� ���� ���������� � ��
    TNotifyEventWrap.Create
      (FParametersGrp.qParameterTypes.Monitor.OnHaveAnyChanges,
      DoOnHaveAnyChanges, FEventList);

    TNotifyEventWrap.Create(FParametersGrp.qParameterTypes.AfterOpen,
      DoOnHaveAnyChanges, FEventList);

    TNotifyEventWrap.Create(FParametersGrp.qParameters.AfterOpen,
      DoOnHaveAnyChanges, FEventList);

    UpdateAutoTransaction;
  end;

  UpdateView;
end;

procedure TViewParameters2.UpdateAutoTransaction;
begin
  ParametersGrp.qParameterTypes.AutoTransaction := FCheckedMode;
  ParametersGrp.qParameters.AutoTransaction := FCheckedMode;
end;

procedure TViewParameters2.UpdateTotalCount;
begin
  // ����� ����� ����������
  StatusBar.Panels[StatusBar.Panels.Count - 1].Text :=
    Format('�����: %d', [ParametersGrp.qParameters.FDQuery.RecordCount]);
end;

procedure TViewParameters2.UpdateView;
var
  AColumn: TcxGridDBBandedColumn;
  AView: TcxGridDBBandedTableView;
  OK: Boolean;
  S: string;
  V: Variant;
begin
  AView := FocusedTableView;
  OK := (FParametersGrp <> nil) and
    (FParametersGrp.qParameterTypes.FDQuery.Active) and
    (FParametersGrp.qParameters.FDQuery.Active);

  actAddParameterType.Enabled := OK and (AView <> nil) and
    (AView.Level = cxGridLevel);

  actAddParameter.Enabled := OK and (AView <> nil) and
    ((AView.Level = cxGridLevel) or (AView.Level = cxGridLevel2));

  // ������� ��������� ������ ���� ���-�� ��������
  actDeleteEx.Enabled := OK and (AView <> nil) and
    (AView.Controller.SelectedRowCount > 0);

  // ���� � ��� ���� ���� ������ �� ����������, ��� ������� ������
  if (actFilterByTableName.Checked or actShowDuplicate.Checked) and
    (AView = MainView) then
    actDeleteEx.Enabled := False;

  actLoadFromExcelDocument.Enabled := OK;

  actLoadFromExcelSheet.Enabled := OK;

  actExportToExcelDocument.Enabled := OK and
    (FParametersGrp.qParameters.FDQuery.RecordCount > 0);

  actCommit.Enabled := OK and FParametersGrp.HaveAnyChanges;

  actRollback.Enabled := actCommit.Enabled;

  actFilterByTableName.Enabled := OK and
    ((not FParametersGrp.qParameters.TableNameFilter.IsEmpty) or
    ((AView <> nil) and (AView.Level = cxGridLevel2) and
    (AView.ViewData.RowCount > 0)));

  S := '';

  if OK and (AView <> nil) and (AView.Level = cxGridLevel2) and
    (AView.ViewData.RecordCount > 0) then
  begin
    AColumn := AView.GetColumnByFieldName(clTableName.DataBinding.FieldName);
    if (AColumn <> nil) and (AView.Controller.FocusedRow <> nil) then
    begin
      V := AView.Controller.FocusedRow.Values[AColumn.Index];
      if not VarIsNull(V) then
        S := String.Format('�������� %s', [V]);
    end;
  end;

  if S.IsEmpty then
    S := '��������';

  actFilterByTableName.Caption := IfThen(actFilterByTableName.Checked,
    '����� ������', S);

  actShowDuplicate.Enabled := OK and
    (actShowDuplicate.Checked or
    (FParametersGrp.qParameters.FDQuery.RecordCount > 0));
  actShowDuplicate.Caption := IfThen(actShowDuplicate.Checked, '�������� ��',
    '��� ���������');

  UpdateTotalCount;
end;

end.
