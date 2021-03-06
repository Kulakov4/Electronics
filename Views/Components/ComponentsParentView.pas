unit ComponentsParentView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, GridFrame,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB,
  cxDBData, System.Actions, Vcl.ActnList, dxBar, cxClasses, Vcl.ComCtrls,
  cxGridLevel, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridBandedTableView, cxGridDBBandedTableView, cxGrid, NotifyEvents,
  cxEditRepositoryItems, cxExtEditRepositoryItems, SubGroupsQuery,
  SubGroupListPopupForm, cxLabel, cxDBLookupComboBox, cxDropDownEdit,
  cxButtonEdit, cxGridCustomPopupMenu, cxGridPopupMenu, Vcl.Menus, Vcl.StdCtrls,
  DocFieldInfo, dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
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
  dxSkinXmas2008Blue, dxSkinscxPCPainter, dxSkinsdxBarPainter,
  System.Generics.Collections, BaseComponentsGroupUnit2,
  cxDataControllerConditionalFormattingRulesManagerDialog, dxBarBuiltInMenu;

const
  WM_ON_DETAIL_EXPANDED = WM_USER + 57;
  WM_UPDATE_DETAIL_COLUMNS_WIDTH = WM_USER + 58;

type
  TViewComponentsParent = class(TfrmGrid)
    cxGridDBBandedTableView2: TcxGridDBBandedTableView;
    actDeleteFromAllCategories: TAction;
    actAddFamily: TAction;
    actAddComponent: TAction;
    actCommit: TAction;
    cxerComponents: TcxEditRepository;
    cxFieldValueWithExpand: TcxEditRepositoryButtonItem;
    cxFieldValueWithExpandRO: TcxEditRepositoryButtonItem;
    cxertiValue: TcxEditRepositoryTextItem;
    cxertiValueRO: TcxEditRepositoryTextItem;
    clID: TcxGridDBBandedColumn;
    clValue: TcxGridDBBandedColumn;
    clID2: TcxGridDBBandedColumn;
    clValue2: TcxGridDBBandedColumn;
    actRollback: TAction;
    cxGridLevel2: TcxGridLevel;
    procedure actAddFamilyExecute(Sender: TObject);
    procedure actDeleteFromAllCategoriesExecute(Sender: TObject);
    procedure actAddComponentExecute(Sender: TObject);
    procedure actCommitExecute(Sender: TObject);
    procedure actRollbackExecute(Sender: TObject);
    procedure clValue2GetProperties(Sender: TcxCustomGridTableItem;
      ARecord: TcxCustomGridRecord; var AProperties: TcxCustomEditProperties);
    procedure clValue2GetPropertiesForEdit(Sender: TcxCustomGridTableItem;
      ARecord: TcxCustomGridRecord; var AProperties: TcxCustomEditProperties);
    procedure clValueGetProperties(Sender: TcxCustomGridTableItem;
      ARecord: TcxCustomGridRecord; var AProperties: TcxCustomEditProperties);
    procedure clValueGetPropertiesForEdit(Sender: TcxCustomGridTableItem;
      ARecord: TcxCustomGridRecord; var AProperties: TcxCustomEditProperties);
    procedure cxGridDBBandedTableView2CellClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure cxGridDBBandedTableViewBandSizeChanged
      (Sender: TcxGridBandedTableView; ABand: TcxGridBand);
    procedure cxGridDBBandedTableViewCellClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure cxGridDBBandedTableViewColumnSizeChanged(Sender: TcxGridTableView;
      AColumn: TcxGridColumn);
    procedure cxGridDBBandedTableViewDataControllerCompare(ADataController
      : TcxCustomDataController; ARecordIndex1, ARecordIndex2,
      AItemIndex: Integer; const V1, V2: Variant; var Compare: Integer);
    procedure cxGridDBBandedTableViewDataControllerDetailExpanded
      (ADataController: TcxCustomDataController; ARecordIndex: Integer);
    procedure cxGridDBBandedTableViewEditKeyUp(Sender: TcxCustomGridTableView;
      AItem: TcxCustomGridTableItem; AEdit: TcxCustomEdit; var Key: Word;
      Shift: TShiftState);
    procedure cxGridDBBandedTableViewEditValueChanged
      (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem);
    procedure cxGridDBBandedTableViewLeftPosChanged(Sender: TObject);
    procedure cxFieldValueWithExpandPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure cxGridDBBandedTableView2EditKeyDown
      (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
      AEdit: TcxCustomEdit; var Key: Word; Shift: TShiftState);
    procedure cxGridDBBandedTableViewEditKeyDown(Sender: TcxCustomGridTableView;
      AItem: TcxCustomGridTableItem; AEdit: TcxCustomEdit; var Key: Word;
      Shift: TShiftState);
  private
    FBaseCompGrp: TBaseComponentsGroup2;
    FDeleteFromAllCategories: Boolean;
    FEditingValue: Variant;
    FIsSyncScrollbars: Boolean;
    FMessageUpdateDetailColumnsPosted: Boolean;
    FOnDetailExpandedPosted: Boolean;
    FQuerySubGroups: TfrmQuerySubGroups;
    function GetQuerySubGroups: TfrmQuerySubGroups;
    procedure PostMessageUpdateDetailColumnsWidth;
    procedure SetBaseCompGrp(const Value: TBaseComponentsGroup2);
    procedure SyncScrollbarPositions;
    procedure UpdateSelectedValues(AView: TcxGridDBBandedTableView);
    { Private declarations }
  protected
    procedure ApplyBestFitForColumn(AColumn: TcxGridDBBandedColumn); override;
    function ExpandDetail: TcxGridDBBandedTableView;
    procedure CollapseDetail;
    procedure CreateColumnsBarButtons; override;
    function CreateViewArr: TArray<TcxGridDBBandedTableView>; override;
    procedure DoAfterLoadData; virtual;
    procedure DoAfterOpenOrRefresh(Sender: TObject);
    procedure DoBeforeOpenOrRefresh(Sender: TObject);
    procedure DoOnHaveAnyChanges(Sender: TObject);
    procedure DoOnMasterDetailChange; virtual;
    procedure DoOnUpdateColumnsWidth(var Message: TMessage);
      message WM_UPDATE_DETAIL_COLUMNS_WIDTH;
    procedure MyDelete; override;
    procedure OnDetailExpandedProcess(var Message: TMessage);
      message WM_ON_DETAIL_EXPANDED;
    procedure UpdateDetailColumnsWidth;
    property QuerySubGroups: TfrmQuerySubGroups read GetQuerySubGroups;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AfterConstruction; override;
    procedure ApplyBestFitFocusedBand; override;
    function CheckAndSaveChanges: Integer;
    procedure MyApplyBestFitForView(AView: TcxGridDBBandedTableView); override;
    procedure UpdateView; override;
    property BaseCompGrp: TBaseComponentsGroup2 read FBaseCompGrp write
        SetBaseCompGrp;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses GridExtension, dxCore, System.Math, System.StrUtils, cxDataUtils,
  System.IOUtils, Winapi.ShellAPI, RepositoryDataModule, System.UITypes,
  ColumnsBarButtonsHelper, DialogUnit, SettingsController, OpenDocumentUnit,
  ProjectConst;

constructor TViewComponentsParent.Create(AOwner: TComponent);
begin
  inherited;
  DeleteMessages.Add(cxGridLevel, sDoYouWantToDeleteFamily);
  DeleteMessages.Add(cxGridLevel2, sDoYouWantToDeleteComponent);
  ApplyBestFitForDetail := False;
end;

procedure TViewComponentsParent.actAddFamilyExecute(Sender: TObject);
var
  AView: TcxGridDBBandedTableView;
begin
  AView := GetDBBandedTableView(0);
  AView.Focused := True;

  AView.DataController.Append;

  FocusColumnEditor(AView, BaseCompGrp.qBaseFamily.W.Value.FieldName);

  UpdateView;
end;

procedure TViewComponentsParent.actDeleteFromAllCategoriesExecute
  (Sender: TObject);
begin
  FDeleteFromAllCategories := True;
  try
    MyDelete;
  finally
    FDeleteFromAllCategories := False;
  end;
end;

procedure TViewComponentsParent.actAddComponentExecute(Sender: TObject);
var
  AView: TcxGridDBBandedTableView;
begin
  // ������� ��������� ��������� �����������
  BaseCompGrp.qBaseFamily.W.TryPost;

  // ������������� ������������� 2-�� ������
  AView := ExpandDetail;

  // ������� ��������� ������, ����� �������������
  AView.DataController.Append;

  FocusColumnEditor(AView, BaseCompGrp.qBaseComponents.W.Value.
    FieldName);

  UpdateView;
end;

procedure TViewComponentsParent.actCommitExecute(Sender: TObject);
begin
  BaseCompGrp.Commit;
  UpdateView;
end;

procedure TViewComponentsParent.actRollbackExecute(Sender: TObject);
begin
  cxGrid.BeginUpdate();
  try
    BaseCompGrp.Rollback;
  finally
    cxGrid.EndUpdate;
  end;

  UpdateView;
end;

function TViewComponentsParent.ExpandDetail: TcxGridDBBandedTableView;
var
  ARow: TcxMyGridMasterDataRow;
begin
  ARow := MainView.Controller.FocusedRow as TcxMyGridMasterDataRow;
  Assert(ARow <> nil);

  Result := ARow.ActiveDetailGridView as TcxGridDBBandedTableView;

  ARow.MyExpand(False);
  Result.Focused := True;
end;

procedure TViewComponentsParent.AfterConstruction;
var
  ACol: TcxGridDBBandedColumn;
  AColIndex: Integer;
  AView: TcxGridDBBandedTableView;
  i: Integer;
begin

  // ����� ������ ������ �������������/�������������� ����� �� �����
  // ������ ����� ������������� ������ ����
  AView := cxGrid.CreateView(TcxGridDBBandedTableViewWithoutExpand)
    as TcxGridDBBandedTableView;

  // �������� � ����� ������������� ��� �������
  AView.Assign(cxGridDBBandedTableView);

  // ACol := cxGridDBBandedTableView.GetColumnByFieldName('Producer');

  // ����� ����������� ��������� ����� �������.
  // �� ��� ������-�� �� �� ����� ������
  for i := 0 to cxGridDBBandedTableView.ColumnCount - 1 do
  begin
    ACol := cxGridDBBandedTableView.Columns[i];
    AColIndex := IfThen(ACol.Position.ColIndex >= 0, ACol.Position.ColIndex,
      ACol.Index);
    AView.Columns[ACol.Index].Position.ColIndex := AColIndex;
  end;

  // ����� ������������� ����� ������������ �� ������ ������
  cxGridLevel.GridView := AView;

  cxGridPopupMenu.PopupMenus[0].GridView := AView;

  PostOnEnterFields.Add(clValue.DataBinding.FieldName);
  PostOnEnterFields.Add(clValue2.DataBinding.FieldName);

  inherited;
end;

procedure TViewComponentsParent.cxGridDBBandedTableViewDataControllerCompare
  (ADataController: TcxCustomDataController; ARecordIndex1, ARecordIndex2,
  AItemIndex: Integer; const V1, V2: Variant; var Compare: Integer);
begin
  inherited;
  // ����� �� ���????
  {
    if AItemIndex = 1 then
    begin
    if VarIsNull(V1) and not(VarIsNull(V2)) then
    Compare := -1;
    if VarIsNull(V2) and not(VarIsNull(V1)) then
    Compare := 1;
    if VarIsNull(V1) and VarIsNull(V2) then
    Compare := 0;
    if not(VarIsNull(V1) or VarIsNull(V2)) then
    begin
    if V1 > V2 then
    Compare := -1;
    if V1 < V2 then
    Compare := 1;
    if V1 = V2 then
    Compare := 0;
    end;
    end
    else
    begin
    case VarCompareValue(V1, V2) of
    vrEqual:
    Compare := 0;
    vrLessThan:
    Compare := -1;
    vrGreaterThan:
    Compare := 1;
    else
    Compare := 0;
    end;
    end;

    if MainView.Columns[AItemIndex].SortOrder = soAscending then
    Compare := Compare * (-1); // ������������� ������� ��� �������������
  }
end;

procedure TViewComponentsParent.
  cxGridDBBandedTableViewDataControllerDetailExpanded(ADataController
  : TcxCustomDataController; ARecordIndex: Integer);
begin
  inherited;
  ChooseTopRecord(MainView, ARecordIndex);

  if FOnDetailExpandedPosted then
    Exit;

  FOnDetailExpandedPosted := True;
  PostMessage(Handle, WM_ON_DETAIL_EXPANDED, 0, 0);
end;

procedure TViewComponentsParent.ApplyBestFitFocusedBand;
begin
  inherited;
  UpdateDetailColumnsWidth;
end;

procedure TViewComponentsParent.ApplyBestFitForColumn
  (AColumn: TcxGridDBBandedColumn);
begin
  inherited;
  // ����������� ������ ������� ������������, ��� ���� ����� ������ ������
  if AColumn.DataBinding.FieldName = clValue.DataBinding.FieldName then
    AColumn.Width := AColumn.Width + 35;
end;

function TViewComponentsParent.CheckAndSaveChanges: Integer;
begin
  Result := 0;
  if FBaseCompGrp = nil then
    Exit;

  UpdateView;

  // ���� ���� ������������� ���������
  if BaseCompGrp.HaveAnyChanges then
  begin
    Result := TDialog.Create.SaveDataDialog;
    case Result of
      IDYes:
        actCommit.Execute;
      IDNO:
        actRollback.Execute;
    end;
  end;
end;

procedure TViewComponentsParent.clValue2GetProperties
  (Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
  var AProperties: TcxCustomEditProperties);
begin
  if ARecord = nil then
    Exit;

  // � ������ ��������� - ������ ������ ��� ������
  AProperties := cxertiValueRO.Properties
end;

procedure TViewComponentsParent.clValue2GetPropertiesForEdit
  (Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
  var AProperties: TcxCustomEditProperties);
var
  AReadOnly: Boolean;
  V: Variant;
begin
  if ARecord = nil then
    Exit;

  V := ARecord.Values[0];

  // � ������ �������������� - ������ � ����������� �� ���������
  AReadOnly := (not VarIsNull(V)) and
    (not BaseCompGrp.qBaseComponents.W.IsRecordModifed(V));

  if AReadOnly then
    AProperties := cxertiValueRO.Properties
  else
    AProperties := cxertiValue.Properties
end;

procedure TViewComponentsParent.clValueGetProperties
  (Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
  var AProperties: TcxCustomEditProperties);
var
  AID: Integer;
  HavDetails: Boolean;
  V: Variant;
begin
  if ARecord = nil then
    Exit;

  HavDetails := False;
  if BaseCompGrp <> nil then
  begin
    V := ARecord.Values[0];
    if not VarIsNull(V) then
    begin
      AID := V;
      HavDetails := BaseCompGrp.qBaseComponents.Exists(AID);
    end;
  end;

  if HavDetails then
  begin
    AProperties := cxFieldValueWithExpandRO.Properties
  end
  else
  begin
    AProperties := cxertiValueRO.Properties
  end;

end;

procedure TViewComponentsParent.clValueGetPropertiesForEdit
  (Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
  var AProperties: TcxCustomEditProperties);
var
  AID: Integer;
  AReadOnly: Boolean;
  HavDetails: Boolean;
  V: Variant;
begin
  if ARecord = nil then
    Exit;

  AReadOnly := False;
  HavDetails := False;

  // �������� �������� ���������� �����
  V := ARecord.Values[clID.Index];
  if not VarIsNull(V) then
  begin
    AID := V;
    // �������, ���� �� � ��������� ����������
    HavDetails := BaseCompGrp.qBaseComponents.Exists(AID);

    // ������ ��� ������ �� ������, ������� �� ����������������
    AReadOnly := not BaseCompGrp.qBaseFamily.W.IsRecordModifed(AID);
  end;

  if HavDetails then
  begin
    if AReadOnly then
      AProperties := cxFieldValueWithExpandRO.Properties
    else
      AProperties := cxFieldValueWithExpand.Properties
  end
  else
  begin
    if AReadOnly then
      AProperties := cxertiValueRO.Properties
    else
      AProperties := cxertiValue.Properties;
  end;

end;

procedure TViewComponentsParent.CollapseDetail;
var
  ARow: TcxMyGridMasterDataRow;
  // AView: TcxGridDBBandedTableView;
begin
  ARow := MainView.Controller.FocusedRow as TcxMyGridMasterDataRow;
  // ARow := GetRow(0) as TcxMyGridMasterDataRow;
  Assert(ARow <> nil);

  // AView := ARow.ActiveDetailGridView as TcxGridDBBandedTableView;
  ARow.MyCollapse(False);
end;

procedure TViewComponentsParent.CreateColumnsBarButtons;
begin
  FColumnsBarButtons := TGVColumnsBarButtonsEx.Create(Self, dxbsColumns,
    MainView, cxGridDBBandedTableView2);
end;

function TViewComponentsParent.CreateViewArr: TArray<TcxGridDBBandedTableView>;
begin
  Result := [MainView, cxGridDBBandedTableView2];
end;

procedure TViewComponentsParent.cxFieldValueWithExpandPropertiesButtonClick
  (Sender: TObject; AButtonIndex: Integer);
var
  ASender, AParent: TComponent;
  AGridSite: TcxGridSite;
  ACustomGridView: TcxCustomGridView;
begin
  ASender := Sender as TComponent;
  AParent := ASender.GetParentComponent;
  AGridSite := AParent as TcxGridSite;
  if AGridSite <> nil then
  begin
    ACustomGridView := AGridSite.GridView;
    with (ACustomGridView as TcxGridTableView).Controller do
    begin
      if (FocusedRow as TcxMyGridMasterDataRow).Expanded then
      // ���� ��� ��� �������� - ��������
      begin
        (FocusedRow as TcxMyGridMasterDataRow).MyCollapse(True);
      end
      else // ����� - ����������
      begin
        (FocusedRow as TcxMyGridMasterDataRow).MyExpand(True);
      end;
    end;
  end;
end;

procedure TViewComponentsParent.cxGridDBBandedTableView2CellClick
  (Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
  AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  UpdateDetailColumnsWidth;
end;

procedure TViewComponentsParent.cxGridDBBandedTableView2EditKeyDown
  (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
  AEdit: TcxCustomEdit; var Key: Word; Shift: TShiftState);
begin
  DoOnEditKeyDown(Sender, AItem, AEdit, Key, Shift);
end;

procedure TViewComponentsParent.cxGridDBBandedTableViewBandSizeChanged
  (Sender: TcxGridBandedTableView; ABand: TcxGridBand);
begin
  PostMessageUpdateDetailColumnsWidth;
  // UpdateDetailColumnsWidth;
end;

procedure TViewComponentsParent.cxGridDBBandedTableViewCellClick
  (Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
  AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  inherited;
  UpdateDetailColumnsWidth;
end;

procedure TViewComponentsParent.cxGridDBBandedTableViewColumnSizeChanged
  (Sender: TcxGridTableView; AColumn: TcxGridColumn);
begin
  PostMessageUpdateDetailColumnsWidth;
  // UpdateDetailColumnsWidth;
end;

procedure TViewComponentsParent.cxGridDBBandedTableViewEditKeyDown
  (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
  AEdit: TcxCustomEdit; var Key: Word; Shift: TShiftState);
begin
  inherited;;
end;

procedure TViewComponentsParent.cxGridDBBandedTableViewEditKeyUp
  (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
  AEdit: TcxCustomEdit; var Key: Word; Shift: TShiftState);
begin
  FEditingValue := AEdit.EditingValue;
end;

procedure TViewComponentsParent.cxGridDBBandedTableViewEditValueChanged
  (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem);
var
  AView: TcxGridDBBandedTableView;
begin
  AView := Sender as TcxGridDBBandedTableView;
  if not Assigned(AView) then
    Exit;

  if AView.Controller.SelectedRecordCount <= 1 then
    Exit;

  if AView.DataController.DataSet.State <> dsEdit then
    Exit;

  UpdateSelectedValues(AView);

end;

procedure TViewComponentsParent.cxGridDBBandedTableViewLeftPosChanged
  (Sender: TObject);
begin
  SyncScrollbarPositions;
end;

procedure TViewComponentsParent.DoAfterLoadData;
begin
  PostMyApplyBestFitEvent;
  UpdateView;
end;

procedure TViewComponentsParent.DoAfterOpenOrRefresh(Sender: TObject);
begin
  EndUpdate;
  FIsSyncScrollbars := False;
  DoAfterLoadData;
end;

procedure TViewComponentsParent.DoBeforeOpenOrRefresh(Sender: TObject);
begin
  BeginUpdate;
end;

procedure TViewComponentsParent.DoOnHaveAnyChanges(Sender: TObject);
begin
  UpdateView;
end;

procedure TViewComponentsParent.DoOnMasterDetailChange;
begin
  if FBaseCompGrp <> nil then
  begin
    with MainView do
    begin
      DataController.DataSource :=  BaseCompGrp.qBaseFamily.W.DataSource;
      DataController.KeyFieldNames := BaseCompGrp.qBaseFamily.W.ID.FieldName;
      OptionsData.Deleting := False;
      OptionsData.DeletingConfirmation := False;
      OptionsData.Inserting := False;
      OptionsView.ColumnAutoWidth := False;
    end;


    cxGridDBBandedTableView2.DataController.DataSource :=
      FBaseCompGrp.qBaseComponents.W.DataSource;

    // ������������� �� �������
    if FBaseCompGrp.qBaseComponents.Master <> nil then
    begin
      // ���������� � ��� ����������� �������
      TNotifyEventWrap.Create(FBaseCompGrp.qBaseComponents.W.BeforeOpen,
        DoBeforeOpenOrRefresh, FEventList);

      TNotifyEventWrap.Create
        (FBaseCompGrp.qBaseComponents.W.BeforeRefresh,
        DoBeforeOpenOrRefresh, FEventList);

      TNotifyEventWrap.Create
        (FBaseCompGrp.qBaseComponents.W.AfterRefresh,
        DoAfterOpenOrRefresh, FEventList);

      TNotifyEventWrap.Create(FBaseCompGrp.qBaseComponents.W.AfterOpen,
        DoAfterOpenOrRefresh, FEventList);

    end;

    // ����� ��� ������� �������� �� ���������� � ��
    TNotifyEventWrap.Create(FBaseCompGrp.qBaseComponents.Monitor.
      OnHaveAnyChanges, DoOnHaveAnyChanges, FEventList);
  end;
  UpdateView;
  cxGridPopupMenu.PopupMenus.Items[0].GridView := MainView;
end;

procedure TViewComponentsParent.DoOnUpdateColumnsWidth(var Message: TMessage);
begin
  UpdateDetailColumnsWidth;
  FMessageUpdateDetailColumnsPosted := False;
end;

function TViewComponentsParent.GetQuerySubGroups: TfrmQuerySubGroups;
begin
  if FQuerySubGroups = nil then
  begin
    FQuerySubGroups := TfrmQuerySubGroups.Create(Self);
    FQuerySubGroups.FDQuery.Connection := BaseCompGrp.Connection;
  end;
  Result := FQuerySubGroups;
end;

procedure TViewComponentsParent.MyApplyBestFitForView
  (AView: TcxGridDBBandedTableView);
begin
  inherited;
  if AView = MainView then
    UpdateDetailColumnsWidth;
end;

procedure TViewComponentsParent.MyDelete;
var
  AController: TcxGridBandedTableController;
  AView: TcxGridDBBandedTableView;
  fri: Integer;
  i: Integer;
  S: string;
  t: Integer;
  X: Integer;
begin
  AView := FocusedTableView;
  if AView = nil then
    Exit;

  if FDeleteFromAllCategories then
    S := sDoYouWantToDeleteFamilyFromAll
  else
    S := DeleteMessages[AView.Level as TcxGridLevel];

  if not TDialog.Create.DeleteRecordsDialog(S) then
    Exit;

  AController := AView.Controller;

  // ���� ������� ��
  if FDeleteFromAllCategories then
  begin
    if AController.SelectedRowCount > 0 then
    begin
      for i := 0 to AController.SelectedRowCount - 1 do
      begin
        X := AController.SelectedRows[i].Values[clID.Index];
        BaseCompGrp.FullDeleted.Add(X);
      end;
    end
    else
    begin
      X := AController.FocusedRecord.Values[clID.Index];
      BaseCompGrp.FullDeleted.Add(X);
    end;
  end;

  t := MainView.Controller.TopRecordIndex;
  fri := MainView.Controller.FocusedRowIndex;

  DisableCollapsingAndExpanding;
  try
    AController.DeleteSelection;
    // ���� ������� ��������� "��������" ������
    if (AView.DataController.RecordCount = 0) and (AView.MasterGridRecord <> nil)
    then
    begin
      // ����������� �������� �������������
      (AView.MasterGridRecord as TcxMyGridMasterDataRow).MyCollapse(False);
      MainView.Controller.TopRowIndex := t;
      MainView.Controller.FocusedRowIndex := fri;
    end;
  finally
    EnableCollapsingAndExpanding;
  end;

  UpdateView;
end;

procedure TViewComponentsParent.OnDetailExpandedProcess(var Message: TMessage);
begin
  SyncScrollbarPositions;
  FOnDetailExpandedPosted := False;
end;

procedure TViewComponentsParent.PostMessageUpdateDetailColumnsWidth;
begin
  if FMessageUpdateDetailColumnsPosted then
    Exit;

  FMessageUpdateDetailColumnsPosted := True;
  PostMessage(Handle, WM_UPDATE_DETAIL_COLUMNS_WIDTH, 0, 0)

end;

procedure TViewComponentsParent.SetBaseCompGrp(const Value:
    TBaseComponentsGroup2);
begin
  if FBaseCompGrp <> Value then
  begin
    FBaseCompGrp := Value;

    FEventList.Clear; // ������������ �� ������ �������

    DoOnMasterDetailChange;
  end;
end;

{ ���������������� ��������� ����������� }
procedure TViewComponentsParent.SyncScrollbarPositions;
var
  AcxGridDBBandedTableView: TcxGridDBBandedTableView;
  AcxGridMasterDataRow: TcxGridMasterDataRow;
  i, ALeftPos: Integer;
  AView: TcxGridBandedTableView;
begin
  // ���� ��������� � ��������� BeginUpdate
  if UpdateCount > 0 then
    Exit;

  if FIsSyncScrollbars then
    Exit;
  try
    FIsSyncScrollbars := True;
    AView := MainView;
    ALeftPos := AView.Controller.LeftPos;

    for i := 0 to AView.ViewData.RowCount - 1 do
    begin
      AcxGridMasterDataRow := GetRow(0, i) as TcxGridMasterDataRow;
      if AcxGridMasterDataRow.Expanded then
      begin
        AcxGridDBBandedTableView := AcxGridMasterDataRow.ActiveDetailGridView as
          TcxGridDBBandedTableView;

        if (AcxGridDBBandedTableView.Controller <> nil) and
          (AcxGridDBBandedTableView.Controller.LeftPos <> ALeftPos) then
          AcxGridDBBandedTableView.Controller.LeftPos := ALeftPos;
      end;
    end;
  finally
    FIsSyncScrollbars := False;
  end;
end;

procedure TViewComponentsParent.UpdateDetailColumnsWidth;
var
  ABand: TcxGridBand;
  ADetailColumn: TcxGridDBBandedColumn;
  AMainColumn: TcxGridDBBandedColumn;
  // dx: Integer;
  i: Integer;
  RealBandWidth: Integer;
  RealColumnWidth: Integer;
begin
  // ������������, ��� ���������� ������� � �������� ������� ����������
  Assert(MainView.ColumnCount = cxGridDBBandedTableView2.ColumnCount);

  cxGrid.BeginUpdate();
  // cxGridDBBandedTableView2.BeginBestFitUpdate;
  try


    // ����������� ������ ����� ������ 0
    // ����� �� ������ ����������� ��� ������ �������
    // �� ���� � ��, � ������� ������ ����������� ������, ����� ���� �� ���������

    Assert(MainView.Bands.Count = cxGridDBBandedTableView2.Bands.Count);
    // ������� ����������� ����� ���� ������
    for i := 0 to MainView.Bands.Count - 1 do
    begin
      ABand := MainView.Bands[i];
      if (not ABand.Visible) or (ABand.VisibleIndex = 0)
      { or (ABand.Width = 0) }
      then
        Continue;

      // ���� ���������� � ���, ������� ���� �������� �� ������ �� ��������!
      if MainView.ViewInfo.HeaderViewInfo.BandsViewInfo.Count <= ABand.VisibleIndex
      then
        Continue;

      RealBandWidth := MainView.ViewInfo.HeaderViewInfo.BandsViewInfo.Items
        [ABand.VisibleIndex].Width;
      {
        if ABand.VisibleIndex = 0 then
        begin
        dx := ABand.Width - RealBandWidth;
        Dec(RealBandWidth, MainView.ViewInfo.FirstItemAdditionalWidth - dx);
        end;
      }
      cxGridDBBandedTableView2.Bands[i].Width := RealBandWidth;
      // cxGridDBBandedTableView2.Bands[i].Width := ABand.Width;
    end;

    // ����� �������� ������� ���� �������� �������
    for i := 0 to cxGridDBBandedTableView2.ColumnCount - 1 do
    begin
      AMainColumn := MainView.Columns[i];
      ADetailColumn := cxGridDBBandedTableView2.Columns[i];

      // ADetailColumn.Width := AMainColumn.Width;
      if AMainColumn.VisibleIndex >= 0 then
      begin
        Assert(AMainColumn.VisibleIndex <
          MainView.ViewInfo.HeaderViewInfo.Count);

        RealColumnWidth := MainView.ViewInfo.HeaderViewInfo.Items
          [AMainColumn.VisibleIndex].Width;

        if AMainColumn.VisibleIndex = 0 then
          Dec(RealColumnWidth, MainView.ViewInfo.FirstItemAdditionalWidth);

        ADetailColumn.Width := RealColumnWidth;
      end;
    end;

  finally
    // cxGridDBBandedTableView2.EndBestFitUpdate;
    cxGrid.EndUpdate;
  end;
end;

procedure TViewComponentsParent.UpdateSelectedValues
  (AView: TcxGridDBBandedTableView);
var
  i: Integer;
  Index: Integer;
  J: Integer;
  RowIndex: Integer;
begin
  AView.Controller.BeginUpdate();
  try
    for i := 0 to AView.Controller.SelectedRecordCount - 1 do
    // ��� ������ ������
    begin
      RowIndex := AView.Controller.SelectedRecords[i].Index;

      // ���� �� ���������� ��������
      for J := 0 to AView.Controller.SelectedColumnCount - 1 do
      // ��� ������� �������
      begin
        Index := AView.Controller.SelectedColumns[J].Index;
        AView.Controller.FocusRecord(RowIndex, False);
        if FEditingValue = null then
        begin
          AView.DataController.SetEditValue(Index, null, evsValue)
        end
        else
        begin
          try
            AView.DataController.SetEditValue(Index, FEditingValue, evsValue);
          except
            AView.DataController.SetEditValue(Index, null, evsValue);
          end;
        end;
      end;
    end;
  finally
    AView.Controller.EndUpdate;
  end;
end;

procedure TViewComponentsParent.UpdateView;
var
  AView: TcxGridDBBandedTableView;
  Ok: Boolean;
  S: string;
begin
  Ok := BaseCompGrp <> nil;
  AView := FocusedTableView;

  // ������� �� ���� ��������� ����� ������ ������������ ���������
  actDeleteFromAllCategories.Enabled := Ok and (AView <> nil) and
    (AView.Level = cxGridLevel) and (AView.Controller.SelectedRowCount > 0);
  actDeleteFromAllCategories.Visible := actDeleteFromAllCategories.Enabled;

  // ������� ��������� ������ ���� ���-�� ��������
  actDeleteEx.Enabled := Ok and (AView <> nil) and
    (AView.Controller.SelectedRowCount > 0);

  actDeleteFromAllCategories.Enabled := actDeleteEx.Enabled;

  if Ok and (AView <> nil) and (AView.Level = cxGridLevel) then
  begin
    if (BaseCompGrp.qBaseFamily.Master <> nil) and
      ((BaseCompGrp.qBaseFamily.Master.FDQuery.Active)) then
    begin
      S := BaseCompGrp.qBaseFamily.Master.FDQuery.FieldByName
        ('Value').AsString;
      actDeleteEx.Caption := Format('������� ��������� �� ��������� �%s�', [S]);
    end;
  end;

  if Ok and (AView <> nil) and (AView.Level = cxGridLevel2) then
  begin
    actDeleteEx.Caption := '������� ��������� �� ���������';
  end;

  actAddFamily.Enabled := Ok and (AView <> nil);
  actAddComponent.Enabled := Ok and (AView <> nil);
  // and (AView.Level = tlComponentsDetails);

  actCommit.Enabled := Ok and BaseCompGrp.HaveAnyChanges;
  actRollback.Enabled := actCommit.Enabled;
end;

end.
