unit CategoryParametersView;

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
  cxGridDBBandedTableView, cxGrid, ParameterPosQuery, DragHelper, cxCheckBox,
  CategoryParametersQuery2, CategoryParametersGroupUnit2,
  SearchParamSubParamQuery, Vcl.Grids, Vcl.DBGrids,
  cxDataControllerConditionalFormattingRulesManagerDialog, dxBarBuiltInMenu,
  dxDateRanges;

type
  TViewCategoryParameters = class(TfrmGrid)
    clValue: TcxGridDBBandedColumn;
    clTableName: TcxGridDBBandedColumn;
    clID: TcxGridDBBandedColumn;
    clPosID: TcxGridDBBandedColumn;
    clOrder: TcxGridDBBandedColumn;
    clValueT: TcxGridDBBandedColumn;
    actPosBegin: TAction;
    actPosEnd: TAction;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    actPosCenter: TAction;
    dxBarButton3: TdxBarButton;
    actUp: TAction;
    actDown: TAction;
    dxBarButton4: TdxBarButton;
    dxBarButton5: TdxBarButton;
    cxStyleRepository: TcxStyleRepository;
    cxStyleBegin: TcxStyle;
    cxStyleEnd: TcxStyle;
    actApplyUpdates: TAction;
    dxBarButton6: TdxBarButton;
    actCancelUpdates: TAction;
    dxBarButton7: TdxBarButton;
    clParameterType: TcxGridDBBandedColumn;
    dxBarButton8: TdxBarButton;
    actAddToBegin: TAction;
    actAddToCenter: TAction;
    actAddToEnd: TAction;
    dxBarSubItem1: TdxBarSubItem;
    dxBarButton9: TdxBarButton;
    dxBarButton11: TdxBarButton;
    dxBarButton12: TdxBarButton;
    clIsAttribute: TcxGridDBBandedColumn;
    dsParameters: TDataSource;
    dsSubParameters: TDataSource;
    cxGridLevel2: TcxGridLevel;
    cxGridDBBandedTableView2: TcxGridDBBandedTableView;
    clID2: TcxGridDBBandedColumn;
    clIDParent: TcxGridDBBandedColumn;
    clName: TcxGridDBBandedColumn;
    clTranslation: TcxGridDBBandedColumn;
    clIsAttribute2: TcxGridDBBandedColumn;
    clPosID2: TcxGridDBBandedColumn;
    clOrd2: TcxGridDBBandedColumn;
    actAddSubParameter: TAction;
    dxBarButton10: TdxBarButton;
    clIDParameter: TcxGridDBBandedColumn;
    dxBarButton13: TdxBarButton;
    dxBarButton14: TdxBarButton;
    dxBarManagerBar1: TdxBar;
    dxBarButton15: TdxBarButton;
    dxBarButton16: TdxBarButton;
    dxBarButton17: TdxBarButton;
    dxBarButton18: TdxBarButton;
    clVID: TcxGridDBBandedColumn;
    dxBarButton19: TdxBarButton;
    dxBarButton20: TdxBarButton;
    dxBarButton21: TdxBarButton;
    dxBarButton22: TdxBarButton;
    actRefresh: TAction;
    dxBarButton23: TdxBarButton;
    procedure actAddSubParameterExecute(Sender: TObject);
    procedure actAddToBeginExecute(Sender: TObject);
    procedure actAddToCenterExecute(Sender: TObject);
    procedure actAddToEndExecute(Sender: TObject);
    procedure actApplyUpdatesExecute(Sender: TObject);
    procedure actCancelUpdatesExecute(Sender: TObject);
    procedure actDownExecute(Sender: TObject);
    procedure actPosBeginExecute(Sender: TObject);
    procedure actPosCenterExecute(Sender: TObject);
    procedure actPosEndExecute(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
    procedure actUpExecute(Sender: TObject);
    procedure cxGridDBBandedTableView2Editing(Sender: TcxCustomGridTableView;
      AItem: TcxCustomGridTableItem; var AAllow: Boolean);
    procedure cxGridDBBandedTableView2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cxGridDBBandedTableView2MouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure cxGridDBBandedTableViewEditValueChanged
      (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem);
    procedure cxGridDBBandedTableViewStylesGetContentStyle
      (Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
      AItem: TcxCustomGridTableItem; var AStyle: TcxStyle);
    procedure cxGridDBBandedTableView2StylesGetContentStyle
      (Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
      AItem: TcxCustomGridTableItem; var AStyle: TcxStyle);
    procedure cxGridDBBandedTableViewEditing(Sender: TcxCustomGridTableView;
      AItem: TcxCustomGridTableItem; var AAllow: Boolean);
    procedure cxGridDBBandedTableViewSelectionChanged
      (Sender: TcxCustomGridTableView);
    procedure cxGridFocusedViewChanged(Sender: TcxCustomGrid;
      APrevFocusedView, AFocusedView: TcxCustomGridView);
    procedure dxBarButton13Click(Sender: TObject);
    procedure dxBarButton14Click(Sender: TObject);
    procedure dxBarButton15Click(Sender: TObject);
    procedure dxBarButton16Click(Sender: TObject);
    procedure dxBarButton17Click(Sender: TObject);
    procedure dxBarButton18Click(Sender: TObject);
    procedure dxBarButton19Click(Sender: TObject);
    procedure dxBarButton20Click(Sender: TObject);
    procedure dxBarButton21Click(Sender: TObject);
    procedure dxBarButton23Click(Sender: TObject);
  private
    FCatParamsGroup: TCategoryParametersGroup2;
    FQueryParameterPos: TQueryParameterPos;
    procedure AddParameter(APosID: Integer);
    procedure DoAfterUpdateData(Sender: TObject);
    function GetQueryParameterPos: TQueryParameterPos;
    procedure MoveParameter(AUp: Boolean);
    procedure MoveSubParameter(AUp: Boolean);
    procedure SetCatParamsGroup(const Value: TCategoryParametersGroup2);
    procedure SetPos(APosID: Integer);
    { Private declarations }
  protected
    function CreateViewArr: TArray<TcxGridDBBandedTableView>; override;
    procedure DoBeforeUpdateData(Sender: TObject);
    procedure DoDeleteFromView(AView: TcxGridDBBandedTableView); override;
    procedure DoOnDetailExpanded(ADataController: TcxCustomDataController;
      ARecordIndex: Integer); override;
    procedure DoOnIsAttributeChange(Sender: TObject);
    procedure InitView(AView: TcxGridDBBandedTableView); override;
    property QueryParameterPos: TQueryParameterPos read GetQueryParameterPos;
  public
    constructor Create(AOwner: TComponent); override;
    function CheckAndSaveChanges: Integer;
    procedure FocusTopLeftEx;
    procedure UpdateView; override;
    property CatParamsGroup: TCategoryParametersGroup2 read FCatParamsGroup
      write SetCatParamsGroup;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses cxDropDownEdit, NotifyEvents, System.Generics.Collections, System.Math,
  DialogUnit, ProjectConst, ParametersForm, ParametersGroupUnit2,
  DBRecordHolder,
  MaxCategoryParameterOrderQuery, SubParametersForm, SubParametersQuery2,
  ParamSubParamsQuery, cxDBLookupComboBox;

constructor TViewCategoryParameters.Create(AOwner: TComponent);
begin
  inherited;
  DeleteMessages.Add(cxGridLevel, sDoYouWantToDeleteCategoryParameter);
  DeleteMessages.Add(cxGridLevel2, sDoYouWantToDeleteCategorySubParameter);

  ApplyBestFitMultiLine := True;
  ApplyBestFitForDetail := True;
  // dxBarManagerBar1.Visible := False;
end;

procedure TViewCategoryParameters.actAddSubParameterExecute(Sender: TObject);
var
  AID: Integer;
  AIDParameter: Integer;
  ARow: TcxGridMasterDataRow;
  fri: Integer;
  S: String;
begin
  inherited;
  S := '';

  // �������� ������������� ������ ���������-��������
  FocusFirstSelectedRow(MainView);
  AID := Value(MainView, clID, MainView.Controller.FocusedRowIndex);
  AIDParameter := Value(MainView, clIDParameter,
    MainView.Controller.FocusedRowIndex);

  // �������� ���������� ��������� ������������
  if TfrmSubParameters.GetCheckedID(AIDParameter,
    CatParamsGroup.qCategoryParameters.ParentValue, S) then
  begin
    fri := MainView.Controller.FocusedRowIndex;
    // cxGridDBBandedTableView2.OptionsView.HeaderAutoHeight := False;
    CatParamsGroup.AddOrDeleteSubParameters(AID, S);
    // ������������ � ��� ������, ������� ���� �������������
    MainView.Controller.FocusedRowIndex := fri;

    ARow := GetRow(0) as TcxGridMasterDataRow;
    ARow.Expand(True);
  end;
  UpdateView;
end;

procedure TViewCategoryParameters.actAddToBeginExecute(Sender: TObject);
begin
  AddParameter(0);
end;

procedure TViewCategoryParameters.actAddToCenterExecute(Sender: TObject);
begin
  inherited;
  AddParameter(1);
end;

procedure TViewCategoryParameters.actAddToEndExecute(Sender: TObject);
begin
  inherited;
  AddParameter(2);
end;

procedure TViewCategoryParameters.actApplyUpdatesExecute(Sender: TObject);
begin
  inherited;
  CatParamsGroup.ApplyUpdates;
  UpdateView;
end;

procedure TViewCategoryParameters.actCancelUpdatesExecute(Sender: TObject);
begin
  inherited;
  CatParamsGroup.CancelUpdates;
  UpdateView;
end;

procedure TViewCategoryParameters.actDownExecute(Sender: TObject);
begin
  inherited;
  if FocusedTableView = MainView then
    MoveParameter(False)
  else
    MoveSubParameter(False);
end;

procedure TViewCategoryParameters.actPosBeginExecute(Sender: TObject);
begin
  inherited;
  // ���������� ��������� "� ������"
  SetPos(0);
end;

procedure TViewCategoryParameters.actPosCenterExecute(Sender: TObject);
begin
  inherited;
  // ���������� ��������� "� ��������"
  SetPos(1);
end;

procedure TViewCategoryParameters.actPosEndExecute(Sender: TObject);
begin
  inherited;
  // ���������� ��������� "� �����"
  SetPos(2);
end;

procedure TViewCategoryParameters.actRefreshExecute(Sender: TObject);
begin
  inherited;
  CatParamsGroup.RefreshData;
end;

procedure TViewCategoryParameters.actUpExecute(Sender: TObject);
begin
  inherited;
  if FocusedTableView = MainView then
    MoveParameter(True)
  else
    MoveSubParameter(True);
end;

procedure TViewCategoryParameters.AddParameter(APosID: Integer);
var
  AfrmParameters: TfrmParameters;
  AParamsGrp: TParametersGroup2;
  AParamIDList: string;
  AqSubParameters: TQuerySubParameters2;
begin
  inherited;
  AParamIDList := '';

  AParamsGrp := TParametersGroup2.Create(Self);
  AqSubParameters := TQuerySubParameters2.Create(Self);
  try
    // ����������� �� ����������� ������� �� ����� ���������
    AParamsGrp.ProductCategoryIDValue :=
      CatParamsGroup.qCategoryParameters.ParentValue;

    AParamsGrp.ReOpen;
    AqSubParameters.FDQuery.Open;

    AfrmParameters := TfrmParameters.Create(Self);
    try
      AfrmParameters.ViewParameters.ParametersGrp := AParamsGrp;
      AfrmParameters.ViewSubParameters.QuerySubParameters := AqSubParameters;
      AfrmParameters.ViewParameters.CheckedMode := True;
      if AfrmParameters.ShowModal = mrOK then
        AParamIDList := Format(',%s,',
          [AParamsGrp.qParameters.GetCheckedValues
          (AParamsGrp.qParameters.W.PKFieldName)]);
    finally
      FreeAndNil(AfrmParameters);
    end;
  finally
    FreeAndNil(AParamsGrp);
    FreeAndNil(AqSubParameters);
  end;

  if not AParamIDList.IsEmpty then
  begin
    CatParamsGroup.AddOrDeleteParameters(AParamIDList, APosID);
    MyApplyBestFitForView(MainView);
  end;

  UpdateView;
end;

function TViewCategoryParameters.CheckAndSaveChanges: Integer;
begin
  Result := 0;

  if FCatParamsGroup = nil then
    Exit;

  // ���� ���� ������������� ���������
  if CatParamsGroup.HaveAnyChanges then
  begin
    Result := TDialog.Create.SaveDataDialog;
    case Result of
      IDYes:
        actApplyUpdates.Execute;
      IDNO:
        actCancelUpdates.Execute;
    end;
  end;

end;

function TViewCategoryParameters.CreateViewArr
  : TArray<TcxGridDBBandedTableView>;
begin
  Result := [MainView, cxGridDBBandedTableView2];
end;

procedure TViewCategoryParameters.cxGridDBBandedTableView2Editing
  (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
  var AAllow: Boolean);
begin
  inherited;
  AAllow := False;
end;

procedure TViewCategoryParameters.cxGridDBBandedTableView2KeyDown
  (Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;
  DoOnKeyOrMouseDown;
end;

procedure TViewCategoryParameters.cxGridDBBandedTableView2MouseDown
  (Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  DoOnKeyOrMouseDown;
end;

procedure TViewCategoryParameters.cxGridDBBandedTableView2StylesGetContentStyle
  (Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
  AItem: TcxCustomGridTableItem; var AStyle: TcxStyle);
var
  APosID: Integer;
  V: Variant;
begin
  inherited;
  if (ARecord = nil) or (AItem = nil) or (not ARecord.IsData) then
    Exit;
  // �������� �������� ������������
  V := ARecord.Values[clPosID2.Index];
  if VarIsNull(V) then
    Exit;

  APosID := V;
  case APosID of
    0:
      AStyle := cxStyleBegin;
    2:
      AStyle := cxStyleEnd;
  end;
end;

procedure TViewCategoryParameters.cxGridDBBandedTableViewEditing
  (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
  var AAllow: Boolean);
begin
  inherited;
  beep;
end;

procedure TViewCategoryParameters.cxGridDBBandedTableViewEditValueChanged
  (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem);
begin
  inherited;
  if AItem = clPosID then
    cxGridDBBandedTableView.DataController.Post();
end;

procedure TViewCategoryParameters.cxGridDBBandedTableViewSelectionChanged
  (Sender: TcxCustomGridTableView);
begin
  inherited;
  UpdateView;
end;

procedure TViewCategoryParameters.cxGridDBBandedTableViewStylesGetContentStyle
  (Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
  AItem: TcxCustomGridTableItem; var AStyle: TcxStyle);
var
  APosID: Integer;
  V: Variant;
begin
  inherited;
  if (ARecord = nil) or (AItem = nil) or (not ARecord.IsData) then
    Exit;
  // �������� �������� ������������
  V := ARecord.Values[clPosID.Index];
  if VarIsNull(V) then
    Exit;

  APosID := V;
  case APosID of
    0:
      AStyle := cxStyleBegin;
    2:
      AStyle := cxStyleEnd;
  end;
end;

procedure TViewCategoryParameters.cxGridFocusedViewChanged
  (Sender: TcxCustomGrid; APrevFocusedView, AFocusedView: TcxCustomGridView);
begin
  inherited;
  (APrevFocusedView as TcxGridDBBandedTableView).Controller.ClearSelection;
end;

procedure TViewCategoryParameters.DoAfterUpdateData(Sender: TObject);
begin
  if CatParamsGroup.FullUpdate then
  begin
    EndUpdate;
    FocusTopLeft;
    UpdateView;

    // CatParamsGroup.qCatParams.ID.AsInteger;
  end;
  MainView.DataController.DataModeController.SyncMode := True;
end;

procedure TViewCategoryParameters.DoBeforeUpdateData(Sender: TObject);
begin
  if CatParamsGroup.FullUpdate then
  begin
    MainView.Controller.ClearSelection;
    BeginUpdate;
  end;
  MainView.DataController.DataModeController.SyncMode := False;
end;

procedure TViewCategoryParameters.DoDeleteFromView
  (AView: TcxGridDBBandedTableView);
var
  AColumn: TcxGridDBBandedColumn;
  APKValues: TArray<Integer>;
begin
  if AView = MainView then
    AColumn := clID
  else
    AColumn := clID2;

  APKValues := GetSelectedIntValues(AView, AColumn.Index);

  // ���� ������� ��������
  if AView.Level = cxGridLevel then
    CatParamsGroup.DeleteParameters(APKValues);
  if AView.Level = cxGridLevel2 then
    CatParamsGroup.DeleteSubParameters(APKValues);
end;

procedure TViewCategoryParameters.DoOnDetailExpanded(ADataController
  : TcxCustomDataController; ARecordIndex: Integer);
begin
  if (FCatParamsGroup <> nil) and FCatParamsGroup.DataLoading then
    Exit;

  inherited;
end;

procedure TViewCategoryParameters.DoOnIsAttributeChange(Sender: TObject);
begin
  UpdateView;
end;

procedure TViewCategoryParameters.dxBarButton13Click(Sender: TObject);
begin
  inherited;
  DisableCollapsingAndExpanding;
end;

procedure TViewCategoryParameters.dxBarButton14Click(Sender: TObject);
begin
  inherited;
  EnableCollapsingAndExpanding;
end;

procedure TViewCategoryParameters.dxBarButton15Click(Sender: TObject);
begin
  inherited;
  BeginUpdate;
end;

procedure TViewCategoryParameters.dxBarButton16Click(Sender: TObject);
begin
  inherited;
  EndUpdate;
end;

procedure TViewCategoryParameters.dxBarButton17Click(Sender: TObject);
begin
  inherited;
  MainView.BeginBestFitUpdate;
end;

procedure TViewCategoryParameters.dxBarButton18Click(Sender: TObject);
begin
  inherited;
  MainView.EndBestFitUpdate;
end;

procedure TViewCategoryParameters.dxBarButton19Click(Sender: TObject);
begin
  inherited;
  ShowMessage(BoolToStr(CatParamsGroup.qCatParams.ReadOnly, True));
end;

procedure TViewCategoryParameters.dxBarButton20Click(Sender: TObject);
begin
  inherited;
  MainView.DataController.DataModeController.SyncMode := False;
end;

procedure TViewCategoryParameters.dxBarButton21Click(Sender: TObject);
begin
  inherited;
  MainView.DataController.DataModeController.SyncMode := True;
end;

procedure TViewCategoryParameters.dxBarButton23Click(Sender: TObject);
begin
  inherited;
  FocusTopLeft;
end;

procedure TViewCategoryParameters.FocusTopLeftEx;
begin
  MainView.ViewData.Collapse(True);
  FocusTopLeft;
end;

function TViewCategoryParameters.GetQueryParameterPos: TQueryParameterPos;
begin
  if FQueryParameterPos = nil then
  begin
    FQueryParameterPos := TQueryParameterPos.Create(Self);
    FQueryParameterPos.FDQuery.Open;
  end;
  Result := FQueryParameterPos;
end;

procedure TViewCategoryParameters.InitView(AView: TcxGridDBBandedTableView);
begin
  inherited;
  // ������ � ������������� � ��� �� ����� ��������������� � �������� ������ ������
  // AView.DataController.DataModeController.SyncMode := False;
  AView.OptionsView.HeaderAutoHeight := True;
end;

procedure TViewCategoryParameters.MoveParameter(AUp: Boolean);
var
  m: TArray<Integer>;
  ARowIndex: Integer;
  ATargetRowIndex: Integer;
  AView: TcxGridDBBandedTableView;
  IDList: TList<Integer>;
  SS: TSaveSelection;
begin
  inherited;
  AView := FocusedTableView;
  Assert(AView = MainView);

  // AView.Controller.SelectedRowCount

  if not GetSelectedRowIndexesForMove(AView, AUp, m, ATargetRowIndex) then
    Exit;

  // ���� ����� ��� ����������� � ������ �������
  if Value(AView, clPosID, m[high(m)]) <> Value(AView, clPosID, ATargetRowIndex)
  then
    Exit;

  // ���� ���������� ������ �� ������ ��������
  if Value(AView, clPosID, m[high(m)]) <> Value(AView, clPosID, m[0]) then
    Exit;

  // � ���� ����� ��� ������� ��� ��������� ��������� ��������!
  IDList := TList<Integer>.Create;
  try
    for ARowIndex in m do
    begin
      IDList.Add(Value(AView, clID, ARowIndex));
    end;

    // MainView.DataController.DataModeController.SyncMode := False;

    // ��������� ��������� ���������� �������
    SS := SaveSelection(AView, clID2.Index);

    // �������� ����������� ����������
    CatParamsGroup.MoveParameters(IDList.ToArray,
      Value(AView, clID, ATargetRowIndex), AUp);

    // ��������������� ��������� ���������� �������
    RestoreSelection(SS);

    // MainView.DataController.DataModeController.SyncMode := True;

  finally
    FreeAndNil(IDList);
  end;
  UpdateView;
end;

procedure TViewCategoryParameters.MoveSubParameter(AUp: Boolean);
var
  m: TArray<Integer>;
  ARowIndex: Integer;
  ATargetRowIndex: Integer;
  AView: TcxGridDBBandedTableView;
  IDList: TList<Integer>;
  SS: TSaveSelection;
begin
  inherited;
  AView := FocusedTableView;

  Assert(AView.Level = cxGridLevel2);
  if not GetSelectedRowIndexesForMove(AView, AUp, m, ATargetRowIndex) then
    Exit;

  // � ���� ����� ��� ������� ��� ��������� ��������� ��������!
  IDList := TList<Integer>.Create;
  try
    for ARowIndex in m do
    begin
      IDList.Add(Value(AView, clID2, ARowIndex));
    end;

    // MainView.DataController.DataModeController.SyncMode := False;

    // ��������� ��������� ���������� �������
    SS := SaveSelection(AView, clID2.Index);

    // ������ ������� � ������ ������
    CatParamsGroup.MoveSubParameters(IDList.ToArray,
      Value(AView, clID2, ATargetRowIndex), AUp);

    // ������-�� ������ ������������� ����� ���������� ������ � ���� ������ ������ ��� ���������!!!
    SS.View := GetDBBandedTableView(1);

    // ��������������� ��������� ���������� �������
    RestoreSelection(SS);
  finally
    FreeAndNil(IDList);
  end;
  UpdateView;
end;

procedure TViewCategoryParameters.SetCatParamsGroup
  (const Value: TCategoryParametersGroup2);
begin
  if FCatParamsGroup = Value then
    Exit;

  FCatParamsGroup := Value;

  // ������������ �� ������ �����������
  FEventList.Clear;

  if FCatParamsGroup <> nil then
  begin
    BeginUpdate;
    try
      dsParameters.DataSet := FCatParamsGroup.qCatParams;
      dsSubParameters.DataSet := FCatParamsGroup.qCatSubParams;

      InitializeLookupColumn(clPosID, QueryParameterPos.W.DataSource,
        lsFixedList, QueryParameterPos.W.Pos.FieldName);

      (clPosID.Properties as TcxLookupComboBoxProperties).ReadOnly := True;

      // (clIsAttribute.Properties as TcxCheckBoxProperties).ImmediatePost := True;

    finally
      EndUpdate;
    end;
    MainView.ViewData.Collapse(True);
    MyApplyBestFit;

    TNotifyEventWrap.Create(FCatParamsGroup.BeforeUpdateData,
      DoBeforeUpdateData, FEventList);

    TNotifyEventWrap.Create(FCatParamsGroup.AfterUpdateData, DoAfterUpdateData,
      FEventList);

    TNotifyEventWrap.Create(FCatParamsGroup.OnIsAttributeChange,
      DoOnIsAttributeChange, FEventList);

    UpdateView;
  end;
end;

procedure TViewCategoryParameters.SetPos(APosID: Integer);
var
  AColumn: TcxGridDBBandedColumn;
  AView: TcxGridDBBandedTableView;
  // i: Integer;
begin
  AView := FocusedTableView;
  Assert(AView <> nil);
  AColumn := AView.GetColumnByFieldName(clID.DataBinding.FieldName);

  // AView.BeginSortingUpdate;
  // try
  CatParamsGroup.SetPos(GetSelectedIntValues(AColumn),
    AView = MainView, APosID);
  // finally
  // AView.EndSortingUpdate;
  // end;
  UpdateView;
end;

procedure TViewCategoryParameters.UpdateView;
var
  AView: TcxGridDBBandedTableView;
  OK: Boolean;
begin
  AView := FocusedTableView;

  if AView <> nil then
    FocusFirstSelectedRow(AView);

  OK := (AView <> nil) and (FCatParamsGroup <> nil) and
    FCatParamsGroup.IsAllQuerysActive;

  actPosBegin.Enabled := OK and (AView = MainView) and
    (AView.Controller.SelectedRowCount > 0) and
    (AView.DataController.RecordCount > 0);
  actPosCenter.Enabled := actPosBegin.Enabled;
  actPosEnd.Enabled := actPosBegin.Enabled;

  actApplyUpdates.Enabled := OK and FCatParamsGroup.qCategoryParameters.
    HaveAnyChanges;
  actCancelUpdates.Enabled := actApplyUpdates.Enabled;

  // ������� ��������� ������ ���� ���-�� ��������
  actDeleteEx.Enabled := OK and (AView.Controller.SelectedRowCount > 0);

  actAddToBegin.Enabled := OK and not FCatParamsGroup.qCategoryParameters.
    HaveAnyChanges;
  actAddToCenter.Enabled := actAddToBegin.Enabled;
  actAddToEnd.Enabled := actAddToBegin.Enabled;

  // ���� �� ������� �� ���� �������� (����, �������� ���������),
  // ������ "�������� �����������" - ������ ���� �� �������.
  actAddSubParameter.Enabled := OK and
    (not FCatParamsGroup.qCategoryParameters.HaveAnyChanges) and
    (((AView = MainView) and (MainView.Controller.SelectedRowCount = 1)) or
    (AView <> MainView));

  actUp.Enabled := OK and not FCatParamsGroup.qCategoryParameters.HaveInserted;
  actDown.Enabled := actUp.Enabled;
end;

end.
