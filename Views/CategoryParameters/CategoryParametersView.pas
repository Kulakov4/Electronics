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
  cxGridDBBandedTableView, cxGrid, CategoryParametersQuery, ParameterPosQuery,
  DragHelper, cxCheckBox, CategoryParametersQuery2,
  CategoryParametersGroupUnit, SearchParamSubParamQuery;

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
    procedure actUpExecute(Sender: TObject);
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
    procedure cxGridDBBandedTableViewDataControllerDetailExpanded
      (ADataController: TcxCustomDataController; ARecordIndex: Integer);
    procedure cxGridDBBandedTableViewFocusedRecordChanged
      (Sender: TcxCustomGridTableView;
      APrevFocusedRecord, AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
    procedure dxBarButton13Click(Sender: TObject);
    procedure dxBarButton14Click(Sender: TObject);
    procedure dxBarButton15Click(Sender: TObject);
    procedure dxBarButton16Click(Sender: TObject);
  private
    FCatParamsGroup: TCategoryParametersGroup;
    FLoading: Boolean;
    FQueryParameterPos: TQueryParameterPos;
    procedure AddParameter(APosID: Integer);
    procedure DoAfterUpdateData(Sender: TObject);
    function GetQueryParameterPos: TQueryParameterPos;
    procedure Move(AUp: Boolean);
    procedure SetCatParamsGroup(const Value: TCategoryParametersGroup);
    procedure SetPos(APosID: Integer);
    { Private declarations }
  protected
    procedure DoAfterLoad(Sender: TObject);
    procedure DoBeforeUpdateData(Sender: TObject);
    function GetFocusedTableView: TcxGridDBBandedTableView; override;
    procedure MyDelete; override;
    property QueryParameterPos: TQueryParameterPos read GetQueryParameterPos;
  public
    constructor Create(AOwner: TComponent); override;
    procedure BeginUpdate; override;
    function CheckAndSaveChanges: Integer;
    procedure EndUpdate; override;
    procedure UpdateView; override;
    property CatParamsGroup: TCategoryParametersGroup read FCatParamsGroup
      write SetCatParamsGroup;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses cxDropDownEdit, NotifyEvents, System.Generics.Collections, System.Math,
  DialogUnit, ProjectConst, ParametersForm, ParametersGroupUnit, DBRecordHolder,
  MaxCategoryParameterOrderQuery, SubParametersForm, SubParametersQuery2,
  ParamSubParamsQuery;

constructor TViewCategoryParameters.Create(AOwner: TComponent);
begin
  inherited;
  DeleteMessages.Add(cxGridLevel, sDoYouWantToDeleteCategoryParameter);
  DeleteMessages.Add(cxGridLevel2, sDoYouWantToDeleteCategorySubParameter);

  ApplyBestFitMultiLine := True;
end;

procedure TViewCategoryParameters.actAddSubParameterExecute(Sender: TObject);
var
  AfrmSubParameters: TfrmSubParameters;
  AID: Integer;
  AIDParameter: Integer;
  ARow: TcxGridMasterDataRow;
  fri: Integer;
  qSubParameters: TQuerySubParameters2;
  S: String;
begin
  inherited;
  S := '';
  fri := 0;
  // �������� ������������� ������ ���������-��������
  AID := Value(MainView, clID, MainView.Controller.FocusedRowIndex);
  AIDParameter := Value(MainView, clIDParameter,
    MainView.Controller.FocusedRowIndex);

  qSubParameters := TQuerySubParameters2.Create(Self);
  AfrmSubParameters := TfrmSubParameters.Create(nil);
  try
    AfrmSubParameters.ViewSubParameters.CheckedMode := True;
    // ��������� � SQL ������ ���� � ��������
    qSubParameters.OpenWithChecked(AIDParameter,
      CatParamsGroup.qCategoryParameters.ParentValue);

    AfrmSubParameters.ViewSubParameters.QuerySubParameters := qSubParameters;
    if AfrmSubParameters.ShowModal = mrOK then
    begin
      fri := MainView.Controller.FocusedRowIndex;
      // �������� �������������� ���������� ��������� �������������
      S := qSubParameters.GetCheckedValues(qSubParameters.PKFieldName);
    end;
  finally
    FreeAndNil(AfrmSubParameters);
    FreeAndNil(qSubParameters);
  end;

  if not S.IsEmpty then
  begin
    cxGridDBBandedTableView2.OptionsView.HeaderAutoHeight := False;
    CatParamsGroup.AddOrDeleteSubParameters(AID, S);
    // ������������ � ��� ������, ������� ���� �������������
    MainView.Controller.FocusedRowIndex := fri;

    ARow := GetRow(0) as TcxGridMasterDataRow;
    ARow.Expand(True);
    // MyApplyBestFitForView
    // (ARow.ActiveDetailGridView as TcxGridDBBandedTableView);
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
  DisableCollapsingAndExpanding;
  CatParamsGroup.ApplyUpdates;
  EnableCollapsingAndExpanding;
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
  Move(False);
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

procedure TViewCategoryParameters.actUpExecute(Sender: TObject);
begin
  inherited;
  Move(True);
end;

procedure TViewCategoryParameters.AddParameter(APosID: Integer);
var
  AfrmParameters: TfrmParameters;
  AParamsGrp: TParametersGroup;
  AParamIDList: string;
begin
  inherited;
  AParamIDList := '';

  AParamsGrp := TParametersGroup.Create(Self);
  try
    // ����������� �� ����������� ������� �� ����� ���������
    AParamsGrp.ProductCategoryIDValue :=
      CatParamsGroup.qCategoryParameters.ParentValue;
    AParamsGrp.ReOpen;
    AfrmParameters := TfrmParameters.Create(Self);
    try
      AfrmParameters.ViewParameters.ParametersGroup := AParamsGrp;
      AfrmParameters.ViewSubParameters.QuerySubParameters :=
        AParamsGrp.qSubParameters2;
      AfrmParameters.ViewParameters.CheckedMode := True;
      if AfrmParameters.ShowModal = mrOK then
        AParamIDList := Format(',%s,',
          [AParamsGrp.qMainParameters.GetCheckedValues
          (AParamsGrp.qMainParameters.PKFieldName)]);
    finally
      FreeAndNil(AfrmParameters);
    end;
  finally
    FreeAndNil(AParamsGrp);
  end;

  if not AParamIDList.IsEmpty then
    CatParamsGroup.AddOrDeleteParameters(AParamIDList, APosID);

  UpdateView;
end;

procedure TViewCategoryParameters.BeginUpdate;
begin
  inherited;
  // DisableCollapsingAndExpanding;
end;

function TViewCategoryParameters.CheckAndSaveChanges: Integer;
begin
  Result := 0;
  {
    if QueryCategoryParameters = nil then
    Exit;

    // ���� ���� ������������ ���������
    if QueryCategoryParameters.HaveAnyChanges then
    begin
    Result := TDialog.Create.SaveDataDialog;
    case Result of
    IDYes:
    actApplyUpdates.Execute;
    IDNO:
    actCancelUpdates.Execute;
    end;
    end;
  }
end;

procedure TViewCategoryParameters.cxGridDBBandedTableView2KeyDown
  (Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;
  PostMessage(Handle, WM_AfterKeyOrMouseDown, 0, 0);
end;

procedure TViewCategoryParameters.cxGridDBBandedTableView2MouseDown
  (Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  PostMessage(Handle, WM_AfterKeyOrMouseDown, 0, 0);
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

procedure TViewCategoryParameters.
  cxGridDBBandedTableViewDataControllerDetailExpanded(ADataController
  : TcxCustomDataController; ARecordIndex: Integer);
var
  AcxGridMasterDataRow: TcxGridMasterDataRow;
  AView: TcxGridDBBandedTableView;
begin
  inherited;
  if FLoading then
    Exit;

  if ARecordIndex < 0 then
    Exit;

  AcxGridMasterDataRow := cxGridDBBandedTableView.ViewData.Records[ARecordIndex]
    as TcxGridMasterDataRow;

  AView := AcxGridMasterDataRow.ActiveDetailGridView as
    TcxGridDBBandedTableView;

  // if AView.DataController.RecordCount > 0 then
  // PostMyApplyBestFitEventForView(AView);

  MyApplyBestFitForView(AView);
end;

procedure TViewCategoryParameters.cxGridDBBandedTableViewEditValueChanged
  (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem);
begin
  inherited;
  if AItem = clPosID then
    cxGridDBBandedTableView.DataController.Post();
end;

procedure TViewCategoryParameters.cxGridDBBandedTableViewFocusedRecordChanged
  (Sender: TcxCustomGridTableView; APrevFocusedRecord, AFocusedRecord
  : TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
begin
  inherited;;
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

procedure TViewCategoryParameters.DoAfterLoad(Sender: TObject);
begin
  MainView.ViewData.Collapse(True);
end;

procedure TViewCategoryParameters.DoAfterUpdateData(Sender: TObject);
begin
  // dsParameters.DataSet := FCatParamsGroup.qCatParams;
  // dsSubParameters.DataSet := FCatParamsGroup.qCatSubParams;
//  EndUpdate;
  UpdateView;
  // MainView.ViewData.Collapse(True);
  FLoading := False;
end;

procedure TViewCategoryParameters.DoBeforeUpdateData(Sender: TObject);
begin
  // ����� ������, ������������ � ����� ����� ������� �����������
//  BeginUpdate;
  // dsParameters.DataSet := nil;
  // dsSubParameters.DataSet := nil;
  FLoading := True;
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

procedure TViewCategoryParameters.EndUpdate;
begin
  inherited;
  // EnableCollapsingAndExpanding;
end;

function TViewCategoryParameters.GetFocusedTableView: TcxGridDBBandedTableView;
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

function TViewCategoryParameters.GetQueryParameterPos: TQueryParameterPos;
begin
  if FQueryParameterPos = nil then
  begin
    FQueryParameterPos := TQueryParameterPos.Create(Self);
    FQueryParameterPos.RefreshQuery;
  end;
  Result := FQueryParameterPos;
end;

procedure TViewCategoryParameters.Move(AUp: Boolean);
var
  AID: Integer;
  m: TList<Integer>;
  i: Integer;
  AOrder: Integer;
  L: TList<TRecOrder>;
begin
  inherited;

  MainView.BeginSortingUpdate;
  try
    m := TList<Integer>.Create;
    try
      if MainView.Controller.SelectedRowCount > 0 then
      begin
        for i := 0 to MainView.Controller.SelectedRowCount - 1 do
        begin
          m.Add(MainView.Controller.SelectedRows[i].Index);
        end;
      end
      else
        m.Add(MainView.Controller.FocusedRow.Index);

      m.Sort;
      // ���������� ��� ������� � ������ ����������
      Assert(m.Last - m.First + 1 = m.Count);

      // ������ ������ c ������� ����� �������� ��������
      if AUp then
        i := m.First - 1
      else
      begin
        m.Reverse;
        i := m.First + 1;
      end;

      if (i < 0) or (i >= MainView.ViewData.RowCount) then
        Exit;

      AID := Value(MainView, clID, i);
      AOrder := Value(MainView, clOrder, i);

      // ���� ��������� ������������ ������� � ������ ����� ������
      if Value(MainView, clPosID, i) <> Value(MainView, clPosID, m.First) then
        Exit;

      // ���� ��������� ������ � ��������� ������������ ������ ������
      if Value(MainView, clPosID, m.First) <> Value(MainView, clPosID, m.Last)
      then
        Exit;

      L := TList<TRecOrder>.Create;
      try
        // ������ ������� ������ �� ���������������
        L.Add(TRecOrder.Create(AID, -AOrder));
        // ������� ��������� ������
        for i in m do
        begin
          L.Add(TRecOrder.Create(Value(MainView, clID, i), AOrder));
          AOrder := Value(MainView, clOrder, i);
        end;
        L.Add(TRecOrder.Create(AID, AOrder));
        // QueryCategoryParameters.Move(L);
      finally
        FreeAndNil(L);
      end;
    finally
      FreeAndNil(m);
    end;
  finally
    MainView.EndSortingUpdate;
    UpdateView;
  end;
end;

procedure TViewCategoryParameters.MyDelete;
var
  APKValues: TList<Variant>;
  AView: TcxGridDBBandedTableView;
  i: Integer;
  S: string;
begin

  Assert(DeleteMessages <> nil);

  AView := FocusedTableView;
  if AView = nil then
    Exit;

  if not DeleteMessages.ContainsKey(AView.Level as TcxGridLevel) then
    S := '������� ������?'
  else
    S := DeleteMessages[AView.Level as TcxGridLevel];

  if (TDialog.Create.DeleteRecordsDialog(S)) and
    (AView.DataController.RecordCount > 0) then
  begin
    // ProcessWithCancelDetailExpanding(AView.MasterGridView,
    // procedure()
    // Var
    // i: Integer;
    // begin
    APKValues := TList<Variant>.Create;
    try
      // �������� �������������� ��� �������, ������� ���� �������
      for i := 0 to AView.Controller.SelectedRowCount - 1 do
      begin
        APKValues.Add(AView.Controller.SelectedRecords[i].Values[clID.Index]);
      end;
      // ���� ������� ��������
      if AView.Level = cxGridLevel then
        CatParamsGroup.DeleteParameters(APKValues.ToArray);
      if AView.Level = cxGridLevel2 then
        CatParamsGroup.DeleteSubParameters(APKValues.ToArray);
    finally
      FreeAndNil(APKValues)
    end;

    // end);
    {
      if (AView.DataController.RecordCount = 0) and (AView.MasterGridRecord <> nil)
      then
      begin
      AView.MasterGridRecord.Collapse(False);
      end;
    }
  end;

  UpdateView;

end;

procedure TViewCategoryParameters.SetCatParamsGroup
  (const Value: TCategoryParametersGroup);
begin
  if FCatParamsGroup = Value then
    Exit;

  FCatParamsGroup := Value;

  // ������������ �� ������ �����������
  FEventList.Clear;

  if FCatParamsGroup <> nil then
  begin
    dsParameters.DataSet := FCatParamsGroup.qCatParams;
    dsSubParameters.DataSet := FCatParamsGroup.qCatSubParams;

    InitializeLookupColumn(clPosID, QueryParameterPos.DataSource, lsFixedList,
      QueryParameterPos.Pos.FieldName);

    // (clIsAttribute.Properties as TcxCheckBoxProperties).ImmediatePost := True;

    TNotifyEventWrap.Create(FCatParamsGroup.BeforeUpdateData,
      DoBeforeUpdateData, FEventList);

    TNotifyEventWrap.Create(FCatParamsGroup.AfterUpdateData, DoAfterUpdateData,
      FEventList);

    TNotifyEventWrap.Create(FCatParamsGroup.qCategoryParameters.AfterLoad,
      DoAfterLoad, FEventList);

    UpdateView;
    MainView.ViewData.Collapse(True);
    MyApplyBestFit
    // PostMyApplyBestFitEvent;
  end;
end;

procedure TViewCategoryParameters.SetPos(APosID: Integer);
var
  i: Integer;
begin
  MainView.BeginSortingUpdate;
  try
    for i := 0 to MainView.Controller.SelectedRowCount - 1 do
    begin
      // ����������, ����� ������ � �� ����� �� ��
      MainView.Controller.SelectedRows[i].Focused := True;
      // QueryCategoryParameters.SetPos(APosID);
    end;
  finally
    MainView.EndSortingUpdate;
  end;
  UpdateView;
end;

procedure TViewCategoryParameters.UpdateView;
var
  AView: TcxGridDBBandedTableView;
  OK: Boolean;
begin
  AView := FocusedTableView;

  OK := (FCatParamsGroup <> nil) and FCatParamsGroup.IsAllQuerysActive;

  actPosBegin.Enabled := OK and (MainView.Controller.SelectedRowCount > 0) and
    (MainView.DataController.RecordCount > 0);
  actPosCenter.Enabled := actPosBegin.Enabled;
  actPosEnd.Enabled := actPosBegin.Enabled;

  actApplyUpdates.Enabled := OK and FCatParamsGroup.qCategoryParameters.
    HaveAnyChanges;
  actCancelUpdates.Enabled := actApplyUpdates.Enabled;

  // ������� ��������� ������ ���� ���-�� ��������
  actDeleteEx.Enabled := OK and (AView <> nil) and
    (AView.Controller.SelectedRowCount > 0);

  actAddToBegin.Enabled := OK and not FCatParamsGroup.qCategoryParameters.
    HaveAnyChanges;
  actAddToCenter.Enabled := actAddToBegin.Enabled;
  actAddToEnd.Enabled := actAddToBegin.Enabled;

  actUp.Enabled := OK and not FCatParamsGroup.qCategoryParameters.HaveInserted;
  actDown.Enabled := actUp.Enabled;
end;

end.
