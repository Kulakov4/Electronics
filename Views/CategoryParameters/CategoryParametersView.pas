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
  CategoryParametersQuery2, CategoryParametersGroupUnit,
  SearchParamSubParamQuery, Vcl.Grids, Vcl.DBGrids;

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
    DBGrid: TDBGrid;
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
    procedure dxBarButton17Click(Sender: TObject);
    procedure dxBarButton18Click(Sender: TObject);
  private
    FCatParamsGroup: TCategoryParametersGroup;
    FLoading: Boolean;
    FQueryParameterPos: TQueryParameterPos;
    procedure AddParameter(APosID: Integer);
    procedure DoAfterUpdateData(Sender: TObject);
    function GetQueryParameterPos: TQueryParameterPos;
    procedure MoveParameter(AUp: Boolean);
    procedure MoveSubParameter(AUp: Boolean);
    procedure SetCatParamsGroup(const Value: TCategoryParametersGroup);
    procedure SetPos(APosID: Integer);
    { Private declarations }
  protected
    procedure DoAfterLoad(Sender: TObject);
    procedure DoBeforeUpdateData(Sender: TObject);
    procedure DoDeleteFromView(AView: TcxGridDBBandedTableView); override;
    function GetFocusedTableView: TcxGridDBBandedTableView; override;
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
  // Получаем идентификатор связки сатегория-параметр
  AID := Value(MainView, clID, MainView.Controller.FocusedRowIndex);
  AIDParameter := Value(MainView, clIDParameter,
    MainView.Controller.FocusedRowIndex);

  qSubParameters := TQuerySubParameters2.Create(Self);
  AfrmSubParameters := TfrmSubParameters.Create(nil);
  try
    AfrmSubParameters.ViewSubParameters.CheckedMode := True;
    // Добавляем в SQL запрос поле с галочкой
    qSubParameters.OpenWithChecked(AIDParameter,
      CatParamsGroup.qCategoryParameters.ParentValue);

    AfrmSubParameters.ViewSubParameters.QuerySubParameters := qSubParameters;
    if AfrmSubParameters.ShowModal = mrOK then
    begin
      fri := MainView.Controller.FocusedRowIndex;
      // Получаем идентификаторы отмеченных галочками подпараметров
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
    // Возвращаемся к той записи, которая была сфокусирована
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
  // DisableCollapsingAndExpanding;
  CatParamsGroup.ApplyUpdates;
  // EnableCollapsingAndExpanding;
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
  // Установить положение "в начале"
  SetPos(0);
end;

procedure TViewCategoryParameters.actPosCenterExecute(Sender: TObject);
begin
  inherited;
  // Установить положение "в середине"
  SetPos(1);
end;

procedure TViewCategoryParameters.actPosEndExecute(Sender: TObject);
begin
  inherited;
  // Установить положение "в конце"
  SetPos(2);
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
  AParamsGrp: TParametersGroup;
  AParamIDList: string;
begin
  inherited;
  AParamIDList := '';

  AParamsGrp := TParametersGroup.Create(Self);
  try
    // Настраиваем на отображение галочек из нашей категории
    AParamsGrp.ProductCategoryIDValue :=
      CatParamsGroup.qCategoryParameters.ParentValue;
    AParamsGrp.ReOpen;
    AfrmParameters := TfrmParameters.Create(Self);
    try
      AfrmParameters.ViewParameters.ParametersGrp := AParamsGrp;
      AfrmParameters.ViewSubParameters.QuerySubParameters :=
        AParamsGrp.qSubParameters;
      AfrmParameters.ViewParameters.CheckedMode := True;
      if AfrmParameters.ShowModal = mrOK then
        AParamIDList := Format(',%s,',
          [AParamsGrp.qParameters.GetCheckedValues
          (AParamsGrp.qParameters.PKFieldName)]);
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

    // Если есть несохранённые изменения
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
  // Получаем значение расположения
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
  // Получаем значение расположения
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
  // EndUpdate;
  UpdateView;
  // MainView.ViewData.Collapse(True);
  FLoading := False;
end;

procedure TViewCategoryParameters.DoBeforeUpdateData(Sender: TObject);
begin
  // Набор данных, отображаемый в гриде будет вручную загружаться
  // BeginUpdate;
  // dsParameters.DataSet := nil;
  // dsSubParameters.DataSet := nil;
  FLoading := True;
end;

procedure TViewCategoryParameters.DoDeleteFromView
  (AView: TcxGridDBBandedTableView);
var
  AColumn: TcxGridDBBandedColumn;
  APKValues: TList<Variant>;
  i: Integer;
begin
  APKValues := TList<Variant>.Create;
  try
    AColumn := AView.GetColumnByFieldName(clID.DataBinding.FieldName);
    Assert(AColumn <> nil);

    // Получаем идентификаторы тех записей, которые надо удалить
    for i := 0 to AView.Controller.SelectedRowCount - 1 do
    begin
      APKValues.Add(AView.Controller.SelectedRows[i].Values[AColumn.Index]);
    end;

    // Если удаляем параметр
    if AView.Level = cxGridLevel then
      CatParamsGroup.DeleteParameters(APKValues.ToArray);
    if AView.Level = cxGridLevel2 then
      CatParamsGroup.DeleteSubParameters(APKValues.ToArray);

  finally
    FreeAndNil(APKValues)
  end;
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

procedure TViewCategoryParameters.EndUpdate;
begin
  inherited;
  // EnableCollapsingAndExpanding;
end;

function TViewCategoryParameters.GetFocusedTableView: TcxGridDBBandedTableView;
begin
  Result := inherited;

  // Если не первый уровень в фокусе
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

procedure TViewCategoryParameters.MoveParameter(AUp: Boolean);
var
  m: TArray<Integer>;
  i: Integer;
  ARowIndex: Integer;
  AView: TcxGridDBBandedTableView;
  IDList: TList<Integer>;
begin
  inherited;
  AView := FocusedTableView;
  Assert(AView = MainView);

  if not GetSelectedRowIndexesForMove(AView, AUp, m, i) then
    Exit;

  // Если место для перемещения в другой области
  if Value(AView, clPosID, m[high(m)]) <> Value(AView, clPosID, i) then
    Exit;

  // Если перемещаем записи из разных областей
  if Value(AView, clPosID, m[high(m)]) <> Value(AView, clPosID, m[0]) then
    Exit;

  // В этой точке уже понятно что изменение положения возможно!
  IDList := TList<Integer>.Create;
  try
    for ARowIndex in m do
    begin
      IDList.Add(Value(AView, clID, ARowIndex));
    end;

    AView.BeginSortingUpdate;
    try
      // Вызываем перемешение параметров
      CatParamsGroup.MoveParameters(IDList, Value(AView, clID, i), AUp);
    finally
      AView.EndSortingUpdate;
    end;

  finally
    FreeAndNil(IDList);
  end;
end;

procedure TViewCategoryParameters.MoveSubParameter(AUp: Boolean);
var
  m: TArray<Integer>;
  i: Integer;
  ARowIndex: Integer;
  AView: TcxGridDBBandedTableView;
  IDList: TList<Integer>;
begin
  inherited;
  AView := FocusedTableView;
  Assert(AView.Level = cxGridLevel2);
  if not GetSelectedRowIndexesForMove(AView, AUp, m, i) then
    Exit;

  // В этой точке уже понятно что изменение положения возможно!
  IDList := TList<Integer>.Create;
  try
    for ARowIndex in m do
    begin
      IDList.Add(Value(AView, clID2, ARowIndex));
    end;

    // MainView.BeginSortingUpdate;
    // cxGridDBBandedTableView2.BeginSortingUpdate;
    // AView.BeginSortingUpdate;
    // try
    // Вызываем перемешение параметров
    CatParamsGroup.MoveSubParameters(IDList, Value(AView, clID2, i), AUp);
    // finally
    // AView.EndSortingUpdate;
    // cxGridDBBandedTableView2.EndSortingUpdate;
    // MainView.EndSortingUpdate;
    // end;

  finally
    FreeAndNil(IDList);
  end;

  UpdateView;
end;

procedure TViewCategoryParameters.SetCatParamsGroup
  (const Value: TCategoryParametersGroup);
begin
  if FCatParamsGroup = Value then
    Exit;

  FCatParamsGroup := Value;

  // Отписываемся от старых подписчиков
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
    MyApplyBestFit;
    // PostMyApplyBestFitEvent;

    DBGrid.DataSource := CatParamsGroup.qCategoryParameters.DataSource;
  end;
end;

procedure TViewCategoryParameters.SetPos(APosID: Integer);
var
  AColumn: TcxGridDBBandedColumn;
  AView: TcxGridDBBandedTableView;
//  i: Integer;
begin
  AView := FocusedTableView;
  Assert(AView <> nil);
  AColumn := AView.GetColumnByFieldName(clID.DataBinding.FieldName);

//  AView.BeginSortingUpdate;
//  try
    CatParamsGroup.SetPos(GetSelectedIntValues(AColumn), AView = MainView, APosID);
//  finally
//    AView.EndSortingUpdate;
//  end;
  UpdateView;
end;

procedure TViewCategoryParameters.UpdateView;
var
  AView: TcxGridDBBandedTableView;
  OK: Boolean;
begin
  AView := FocusedTableView;

  OK := (FCatParamsGroup <> nil) and FCatParamsGroup.IsAllQuerysActive;

  actPosBegin.Enabled := OK and (AView <> nil) and
    (AView.Controller.SelectedRowCount > 0) and
    (AView.DataController.RecordCount > 0);
  actPosCenter.Enabled := actPosBegin.Enabled;
  actPosEnd.Enabled := actPosBegin.Enabled;

  actApplyUpdates.Enabled := OK and FCatParamsGroup.qCategoryParameters.
    HaveAnyChanges;
  actCancelUpdates.Enabled := actApplyUpdates.Enabled;

  // Удалять разрешаем только если что-то выделено
  actDeleteEx.Enabled := OK and (AView <> nil) and
    (AView.Controller.SelectedRowCount > 0);

  actAddToBegin.Enabled := OK and not FCatParamsGroup.qCategoryParameters.
    HaveAnyChanges;
  actAddToCenter.Enabled := actAddToBegin.Enabled;
  actAddToEnd.Enabled := actAddToBegin.Enabled;

  actAddSubParameter.Enabled := OK and
    (not FCatParamsGroup.qCategoryParameters.HaveAnyChanges) and
    (MainView.DataController.RowCount > 0);

  actUp.Enabled := OK and not FCatParamsGroup.qCategoryParameters.HaveInserted;
  actDown.Enabled := actUp.Enabled;
end;

end.
