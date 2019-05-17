unit ParametersView2;

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
  dxSkinXmas2008Blue, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit,
  cxNavigator, cxDataControllerConditionalFormattingRulesManagerDialog, Data.DB,
  cxDBData, dxBarBuiltInMenu, cxGridCustomPopupMenu, cxGridPopupMenu, Vcl.Menus,
  System.Actions, Vcl.ActnList, dxBar, cxClasses, Vcl.ComCtrls, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridBandedTableView, cxGridDBBandedTableView, cxGrid, ParametersGroupUnit2,
  NotifyEvents, ParametersExcelDataModule, cxTextEdit, cxBarEditItem,
  DragHelper, HRTimer, cxBlobEdit, cxDBLookupComboBox, cxCheckBox;

const
  // Когда попытались вести новый тип параметра
  WM_NEED_CHANGE_PARAMETER_TYPE = WM_USER + 12;
  WM_SEARCH_EDIT_ENTER = WM_USER + 13;

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
    actExpand: TAction;
    dxBarButton1: TdxBarButton;
    actLoadFromExcelDocument: TAction;
    actLoadFromExcelSheet: TAction;
    actSearch: TAction;
    dxBarManagerBar1: TdxBar;
    cxbeiSearch: TcxBarEditItem;
    dxBarButton2: TdxBarButton;
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
    actDeleteParameterType: TAction;
    dxBarButton18: TdxBarButton;
    actClearSelection: TAction;
    dxBarButton19: TdxBarButton;
    dxBarButton20: TdxBarButton;
    actPaste: TAction;
    cxStyleRepository: TcxStyleRepository;
    cxStyleNotFound: TcxStyle;
    dxBarManagerBar4: TdxBar;
    dxbbClearFilter: TdxBarButton;
    dxbbAllDuplicate: TdxBarButton;
    dxbbDuplicate: TdxBarButton;
    actClearFilter: TAction;
    actAllDuplicate: TAction;
    actDuplicate: TAction;
    procedure actAddParameterExecute(Sender: TObject);
    procedure actAddParameterTypeExecute(Sender: TObject);
    procedure actAllDuplicateExecute(Sender: TObject);
    procedure actApplyBestFitExecute(Sender: TObject);
    procedure actCheckDetailViewExecute(Sender: TObject);
    procedure actClearFilterExecute(Sender: TObject);
    procedure actClearSelectionExecute(Sender: TObject);
    procedure actCommitExecute(Sender: TObject);
    procedure actDeleteParameterTypeExecute(Sender: TObject);
    procedure actDisableControlsExecute(Sender: TObject);
    procedure actDuplicateExecute(Sender: TObject);
    procedure actEnableControlsExecute(Sender: TObject);
    procedure actExportToExcelDocumentExecute(Sender: TObject);
    procedure actLoadFromExcelDocumentExecute(Sender: TObject);
    procedure actLoadFromExcelSheetExecute(Sender: TObject);
    procedure actExpandExecute(Sender: TObject);
    procedure actPasteExecute(Sender: TObject);
    procedure actReopenExecute(Sender: TObject);
    procedure actRollbackExecute(Sender: TObject);
    procedure actSearchExecute(Sender: TObject);
    procedure cxGridDBBandedTableView2DragDrop(Sender, Source: TObject;
      X, Y: Integer);
    procedure cxGridDBBandedTableView2DragOver(Sender, Source: TObject;
      X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure cxGridDBBandedTableView2StartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure cxGridDBBandedTableViewDragDrop(Sender, Source: TObject;
      X, Y: Integer);
    procedure cxGridDBBandedTableViewDragOver(Sender, Source: TObject;
      X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure cxGridDBBandedTableViewStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure clIDParameterTypePropertiesNewLookupDisplayText(Sender: TObject;
      const AText: TCaption);
    procedure clIDParameterTypePropertiesEditValueChanged(Sender: TObject);
    procedure clIDParameterTypePropertiesCloseUp(Sender: TObject);
    procedure cxGridDBBandedTableView2EditKeyDown
      (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
      AEdit: TcxCustomEdit; var Key: Word; Shift: TShiftState);
    procedure cxGridDBBandedTableView2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cxGridDBBandedTableView2MouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure clCheckedPropertiesEditValueChanged(Sender: TObject);
    procedure cxbeiSearchEnter(Sender: TObject);
    procedure cxbeiSearchPropertiesChange(Sender: TObject);
    procedure cxbeiSearchPropertiesEditValueChanged(Sender: TObject);
    procedure cxGridDBBandedTableViewDataControllerSummaryAfterSummary
      (ASender: TcxDataSummary);
    procedure cxGridDBBandedTableViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
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
    procedure OnAfterSearchEditEnter(var Message: TMessage);
      message WM_SEARCH_EDIT_ENTER;
    procedure SetCheckedMode(const Value: Boolean);
    procedure SetParametersGrp(const Value: TParametersGroup2);
    procedure UpdateAutoTransaction;
    procedure UpdateButtonDown;
    procedure UpdateTotalCount;
    { Private declarations }
  protected
    procedure ChangeParameterType(var Message: TMessage);
      message WM_NEED_CHANGE_PARAMETER_TYPE;
    procedure CreateColumnsBarButtons; override;
    procedure CreateFilterForExport(AView,
      ASource: TcxGridDBBandedTableView); override;
    function CreateViewArr: TArray<TcxGridDBBandedTableView>; override;
    procedure DoOnHaveAnyChanges(Sender: TObject);
    procedure LoadFromExcel(AFileName: string);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CheckAndSaveChanges: Integer;
    procedure CommitOrPost;
    function Search(const AName: string): Boolean;
    procedure UpdateView; override;
    property CheckedMode: Boolean read FCheckedMode write SetCheckedMode;
    property ParametersGrp: TParametersGroup2 read FParametersGrp
      write SetParametersGrp;
    { Public declarations }
  end;

var
  ViewParameters2: TViewParameters2;

implementation

uses
  cxDropDownEdit, DialogUnit, System.Generics.Collections, System.StrUtils,
  DialogUnit2, LoadFromExcelFileHelper, ProgressBarForm, ProjectConst,
  ImportErrorForm, RepositoryDataModule, SettingsController, GridSort,
  ColumnsBarButtonsHelper, ClipboardUnit;

{$R *.dfm}

constructor TViewParameters2.Create(AOwner: TComponent);
begin
  inherited;
  // clCodeLetters.Caption := clCodeLetters.Caption.Replace(' ', #13#10);
  // clMeasuringUnit.Caption := clMeasuringUnit.Caption.Replace(' ', #13#10);
  ApplyBestFitMultiLine := True;

  FParameterTypesDI := TDragAndDropInfo.Create(clID, clOrd);
  FParametersDI := TDragAndDropInfo.Create(clID2, clOrder);

  // Имитируем выключение режима "галочки"
  FCheckedMode := True;
  CheckedMode := False;
  StatusBarEmptyPanelIndex := 1;

  PostOnEnterFields.Add(clParameterType.DataBinding.FieldName);
  PostOnEnterFields.Add(clValue.DataBinding.FieldName);
  PostOnEnterFields.Add(clIDParameterType.DataBinding.FieldName);

  DeleteMessages.Add(cxGridLevel, 'Удалить тип?');
  DeleteMessages.Add(cxGridLevel2, 'Удалить параметр?');

  FHRTimer := THRTimer.Create(False);

  GridSort.Add(TSortVariant.Create(clOrd, [clOrd]));
  GridSort.Add(TSortVariant.Create(clOrder, [clOrder]));

  // Сортируем типы
  ApplySort(MainView, clOrd);

  // Сортируем параметры по столбцу порядок
  ApplySort(cxGridDBBandedTableView2, clOrder);
  ApplyBestFitForDetail := True;
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
  // Сначала сохраняем тип параметра
  FParametersGrp.qParameterTypes.W.TryPost;

  ARow := GetRow(0) as TcxGridMasterDataRow;
  ARow.Expand(False);
  AView := GetDBBandedTableView(1);
  AView.Controller.ClearSelection;
  AView.DataController.Append;

  FocusColumnEditor(1, ParametersGrp.qParameters.W.Value.FieldName);

  UpdateView;
end;

procedure TViewParameters2.actAddParameterTypeExecute(Sender: TObject);
begin
  inherited;
  MainView.Controller.ClearSelection;
  MainView.DataController.Append;

  FocusColumnEditor(0, ParametersGrp.qParameterTypes.W.ParameterType.FieldName);

  UpdateView;
end;

procedure TViewParameters2.actAllDuplicateExecute(Sender: TObject);
var
  OK: Boolean;
  SS: TSaveSelection;
begin
  inherited;
  Application.Hint := '';
  if actAllDuplicate.Checked then
    Exit;

  SS := SaveSelection(GetDBBandedTableView(1), clID2.Index);
  OK := ParametersGrp.ApplyAllDuplicateFilter;

  if OK then
  begin
    SS.View := GetDBBandedTableView(1);
    RestoreSelection(SS);
    actAllDuplicate.Checked := True;
  end
  else
  begin
    TDialog.Create.DuplicateNotFound;
    UpdateButtonDown;
  end;

  cxGrid.SetFocus;

  // Обновляем представление
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

procedure TViewParameters2.actClearFilterExecute(Sender: TObject);
var
  SS: TSaveSelection;
begin
  inherited;
  Application.Hint := '';
  if actClearFilter.Checked then
    Exit;

  actClearFilter.Checked := True;

  SS := SaveSelection(GetDBBandedTableView(1), clID2.Index);
  ParametersGrp.ClearFilter;

  // нажимаем кнопку "Без фильтра" - сделай отображение типов в свёрнутом виде.
  //  MainView.ViewData.Collapse(True);
  SS.View := GetDBBandedTableView(1);
  RestoreSelection(SS);
  cxGrid.SetFocus;
  MyApplyBestFitForView(SS.View);

  UpdateView;
end;

procedure TViewParameters2.actClearSelectionExecute(Sender: TObject);
var
  AView: TcxGridDBBandedTableView;
begin
  inherited;
  MainView.Controller.ClearSelection;
  MainView.Controller.EditingController.HideEdit(False);

  AView := GetDBBandedTableView(1);
  AView.Controller.EditingController.HideEdit(False);
  AView.Controller.ClearSelection;
end;

procedure TViewParameters2.actCommitExecute(Sender: TObject);
begin
  inherited;
  FParametersGrp.Commit;

  // Обновляем представление
  UpdateView;
end;

procedure TViewParameters2.actDeleteParameterTypeExecute(Sender: TObject);
begin
  inherited;
  ParametersGrp.DeleteParamType(ParametersGrp.qParameterTypes.W.PK.AsInteger);
end;

procedure TViewParameters2.actDisableControlsExecute(Sender: TObject);
begin
  inherited;
  ParametersGrp.DisableControls;
end;

procedure TViewParameters2.actDuplicateExecute(Sender: TObject);
var
  OK: Boolean;
  SS: TSaveSelection;
begin
  inherited;
  Application.Hint := '';
  if actDuplicate.Checked then
    Exit;

  SS := SaveSelection(GetDBBandedTableView(1), clID2.Index);
  OK := ParametersGrp.ApplyDuplicateFilter;

  if OK then
  begin
    MainView.ViewData.Expand(True);

    SS.View := GetDBBandedTableView(1);
    RestoreSelection(SS);

    actDuplicate.Checked := True;
  end
  else
  begin
    TDialog.Create.ParamDuplicateNotFound
      (ParametersGrp.qParameters.W.TableName.F.AsString);
    UpdateButtonDown;
  end;

  cxGrid.SetFocus;

  UpdateView;
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
    TSettings.Create.GetFolderFoExcelFile(FolderKey), 'Параметры', AFileName)
  then
    Exit;

  ExportViewToExcel(cxGridDBBandedTableView2, AFileName);
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

procedure TViewParameters2.actExpandExecute(Sender: TObject);
begin
  inherited;
  MainView.ViewData.Expand(True);
end;

procedure TViewParameters2.actPasteExecute(Sender: TObject);
begin
  inherited;
  cxbeiSearch.EditValue := TClb.Create.ConcatRows;
  UpdateView;
end;

procedure TViewParameters2.actReopenExecute(Sender: TObject);
begin
  inherited;
  ParametersGrp.ReOpen;
end;

procedure TViewParameters2.actRollbackExecute(Sender: TObject);
begin
  inherited;

  // После переоткрытия в дочернем наборе произойдёт скролл
  BeginUpdate();
  try
    // Отменяем все сделанные изменения
    FParametersGrp.Rollback;

    // Переносим фокус на первую выделенную запись
    FocusSelectedRecord(MainView);
  finally
    EndUpdate;
  end;

  // Помещаем фокус в центр грида
  PutInTheCenterFocusedRecord(MainView);

  // Обновляем представление
  UpdateView;
end;

procedure TViewParameters2.actSearchExecute(Sender: TObject);
var
  S: string;
begin
  inherited;
  S := VarToStrDef(cxbeiSearch.EditValue, '');
  if S.IsEmpty then
    Exit;

  Search(S);
end;

procedure TViewParameters2.ChangeParameterType(var Message: TMessage);
var
  ADetailID: Integer;
  ARow: TcxGridMasterDataRow;
  AMasterID: Integer;
begin
  inherited;
  Assert(not FNewParameterType.IsEmpty);
  // Добавляем новый тип параметра
  FParametersGrp.qParameterTypes.W.LocateOrAppend(FNewParameterType);
  FNewParameterType := '';

  AMasterID := FParametersGrp.qParameterTypes.W.PK.AsInteger;
  ADetailID := Message.WParam;

  // Ищем параметр
  FParametersGrp.qParameters.W.LocateByPK(ADetailID);
  FParametersGrp.qParameters.W.TryEdit;
  FParametersGrp.qParameters.W.IDParameterType.F.AsInteger := AMasterID;
  FParametersGrp.qParameters.W.TryPost;

  ARow := GetRow(0) as TcxGridMasterDataRow;
  Assert(ARow <> nil);

  // AView := GetDBBandedTableView(1);
  ARow.Expand(False);

  FocusColumnEditor(1, ParametersGrp.qParameters.W.IDParameterType.FieldName);
end;

function TViewParameters2.CheckAndSaveChanges: Integer;
begin
  UpdateView;
  Result := 0;
  if FParametersGrp = nil then
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

procedure TViewParameters2.clCheckedPropertiesEditValueChanged(Sender: TObject);
// var
// S: string;
begin
  inherited;
  // Просим CheckBox сразу же сделать сохранение в БД
  (Sender as TcxCheckBox).PostEditValue;
  cxGridDBBandedTableView2.DataController.Post;
  // DoOnKeyOrMouseDown;
end;

procedure TViewParameters2.clIDParameterTypePropertiesCloseUp(Sender: TObject);
begin
  inherited;
  cxGridDBBandedTableView2.DataController.Post();
end;

procedure TViewParameters2.clIDParameterTypePropertiesEditValueChanged
  (Sender: TObject);
var
  ADetailID: Integer;
  AMasterID: Integer;
begin
  if not FNewParameterType.IsEmpty then
  begin
    ADetailID := FParametersGrp.qParameters.W.PK.AsInteger;
    AMasterID := FParametersGrp.qParameterTypes.W.PK.AsInteger;

    // Возвращаем пока старое значение внешнего ключа
    FParametersGrp.qParameters.W.IDParameterType.F.AsInteger := AMasterID;
    FParametersGrp.qParameters.W.TryPost;

    // Посылаем сообщение о том что значение внешнего ключа надо будет изменить
    PostMessage(Handle, WM_NEED_CHANGE_PARAMETER_TYPE, ADetailID, 0);
  end
  else;
  // FEditValueChanged := True;

end;

procedure TViewParameters2.clIDParameterTypePropertiesNewLookupDisplayText
  (Sender: TObject; const AText: TCaption);
begin
  inherited;
  FNewParameterType := AText;
end;

procedure TViewParameters2.CommitOrPost;
begin
  // actCommit может быть Disabled!!!
  UpdateView;

  if CheckedMode then // В этом случае транзакция не начата
    ParametersGrp.TryPost
  else
    actCommit.Execute; // завершаем транзакцию
end;

procedure TViewParameters2.CreateColumnsBarButtons;
begin
  FColumnsBarButtons := TGVColumnsBarButtons.Create(Self, dxbsColumns,
    cxGridDBBandedTableView2);
end;

procedure TViewParameters2.CreateFilterForExport(AView,
  ASource: TcxGridDBBandedTableView);
var
  AColumn: TcxGridDBBandedColumn;
  AIDtypeList: string;
  AOperatorKind: TcxFilterOperatorKind;
  F: TcxFilterCriteriaItem;
  I: Integer;
  r: TcxFilterCriteriaItemList;
  Arr: Variant;
  X: Integer;
begin
  F := cxGridDBBandedTableView.DataController.Filter.FindItemByItemLink
    (clParameterType);
  if F <> nil then
  begin
    AIDtypeList := '';

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
      (clIDParameterType.DataBinding.FieldName);
    AView.DataController.Filter.AddItem(r, AColumn, AOperatorKind, Arr,
      'Список');
    AView.DataController.Filter.Active := True;
  end;
end;

function TViewParameters2.CreateViewArr: TArray<TcxGridDBBandedTableView>;
begin
  Result := [MainView, cxGridDBBandedTableView2];
end;

procedure TViewParameters2.cxbeiSearchEnter(Sender: TObject);
begin
  inherited;
  if cxbeiSearch.StyleEdit <> nil then
  begin
    PostMessage(Handle, WM_SEARCH_EDIT_ENTER, 0, 0);
  end;
end;

procedure TViewParameters2.cxbeiSearchPropertiesChange(Sender: TObject);
begin
  inherited;
  actSearch.Enabled := not VarToStrDef(cxbeiSearch.CurEditValue, '').IsEmpty;
end;

procedure TViewParameters2.cxbeiSearchPropertiesEditValueChanged
  (Sender: TObject);
begin
  inherited;
  // Сохраняем то, что мы там наредактировали
  (Sender as TcxTextEdit).PostEditValue;
  actSearch.Execute;
end;

procedure TViewParameters2.cxGridDBBandedTableView2DragDrop(Sender,
  Source: TObject; X, Y: Integer);
var
  time: Double;
begin
  inherited;
  // Таймер должны были запустить
  Assert(FHRTimer <> nil);
  time := FHRTimer.ReadTimer;

  // Если это было случайное перемещение, то ничего не делаем
  if time < DragDropTimeOut then
    Exit;

  DoDragDrop(Sender as TcxGridSite, FParametersDI,
    FParametersGrp.qParameters, X, Y);
end;

procedure TViewParameters2.cxGridDBBandedTableView2DragOver(Sender,
  Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  inherited;
  DoDragOver(Sender as TcxGridSite, X, Y, Accept);
end;

procedure TViewParameters2.cxGridDBBandedTableView2EditKeyDown
  (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
  AEdit: TcxCustomEdit; var Key: Word; Shift: TShiftState);
begin
  inherited;
  DoOnEditKeyDown(Sender, AItem, AEdit, Key, Shift);
end;

procedure TViewParameters2.cxGridDBBandedTableView2KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  inherited;
  DoOnKeyOrMouseDown;
  if Key = 27 then
    actClearSelection.Execute;
end;

procedure TViewParameters2.cxGridDBBandedTableView2MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  DoOnKeyOrMouseDown;
end;

procedure TViewParameters2.cxGridDBBandedTableView2StartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
  inherited;
  DoOnStartDrag(Sender as TcxGridSite, FParametersDI);

  // Запускаем таймер чтобы рассчитать время переноса записей
  FHRTimer.StartTimer
end;

procedure TViewParameters2.
  cxGridDBBandedTableViewDataControllerSummaryAfterSummary
  (ASender: TcxDataSummary);
var
  AIndex: Integer;
  S: string;
begin
  inherited;
  AIndex := MainView.DataController.Summary.FooterSummaryItems.IndexOfItemLink
    (clParameterType);
  S := VarToStrDef(MainView.DataController.Summary.FooterSummaryValues
    [AIndex], '---');
  StatusBar.Panels[0].Text := S;
end;

procedure TViewParameters2.cxGridDBBandedTableViewDragDrop(Sender,
  Source: TObject; X, Y: Integer);
var
  time: Double;
begin
  // Таймер должны были запустить
  Assert(FHRTimer <> nil);
  time := FHRTimer.ReadTimer;

  // Если это было случайное перемещение, то ничего не делаем
  if time < DragDropTimeOut then
    Exit;

  DoDragDrop(Sender as TcxGridSite, FParameterTypesDI,
    FParametersGrp.qParameterTypes, X, Y);
end;

procedure TViewParameters2.cxGridDBBandedTableViewDragOver(Sender,
  Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  inherited;
  DoDragOver(Sender as TcxGridSite, X, Y, Accept);
end;

procedure TViewParameters2.cxGridDBBandedTableViewKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Key = 27 then
    actClearSelection.Execute;
end;

procedure TViewParameters2.cxGridDBBandedTableViewStartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
  inherited;

  DoOnStartDrag(Sender as TcxGridSite, FParameterTypesDI);

  // Запускаем таймер чтобы рассчитать время переноса записей
  FHRTimer.StartTimer;
end;

procedure TViewParameters2.DoOnHaveAnyChanges(Sender: TObject);
begin
  UpdateView;
end;

procedure TViewParameters2.LoadDataFromExcelTable(AData: TParametersExcelTable);
begin
  BeginUpdate();
  try
    TfrmProgressBar.Process(AData,
      procedure(ASender: TObject)
      begin
        ParametersGrp.LoadDataFromExcelTable(AData);
      end, 'Обновление параметров в БД', sRecords);

  finally
    EndUpdate;
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

procedure TViewParameters2.OnAfterSearchEditEnter(var Message: TMessage);
begin
  inherited;
  cxGrid.SetFocus;
  cxbeiSearch.StyleEdit := nil;
  cxbeiSearch.SetFocus();
end;

function TViewParameters2.Search(const AName: string): Boolean;
var
  AColumn: TcxGridDBBandedColumn;
  ARow: TcxGridMasterDataRow;
  AView: TcxGridDBBandedTableView;
  Arr: TArray<String>;
  S: string;
begin
  Assert(not AName.IsEmpty);
  S := AName;

  // Будем искать по табличному имени (либо по названию категории)
  AColumn := clTableName;

  // Чтобы грид не разворачивался во время поиска
  BeginUpdate;
  try
    Arr := ParametersGrp.Find(AColumn.DataBinding.FieldName, S);
  finally
    EndUpdate;
  end;

  Result := False;

  // сначала ищем на первом уровне (по названию категории)
  if (Length(Arr) > 0) and
    (MainView.DataController.Search.Locate(clParameterType.Index, Arr[0], True))
  then
  begin
    // Затем ищем на втором уровне (по табличному имени)
    if Length(Arr) > 1 then
    begin
      ARow := GetRow(0) as TcxGridMasterDataRow;
      ARow.Expand(False);
      AView := GetDBBandedTableView(1);
      AView.Focused := True;
      Result := AView.DataController.Search.Locate(AColumn.Index, Arr[1], True);
      PutInTheCenterFocusedRecord(AView);
    end
    else
      PutInTheCenterFocusedRecord(MainView);
  end;

  if not Result then
    cxbeiSearch.StyleEdit := cxStyleNotFound
  else
    cxbeiSearch.StyleEdit := nil;

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
      FParametersGrp.qParameterTypes.W.DataSource;
    cxGridDBBandedTableView2.DataController.DataSource :=
      FParametersGrp.qParameters.W.DataSource;

    InitializeLookupColumn(clIDParameterType,
      FParametersGrp.qParameterTypes.W.DataSource, lsEditList,
      FParametersGrp.qParameterTypes.W.ParameterType.FieldName);

    InitializeLookupColumn(clIDParameterKind,
      FParametersGrp.qParameterKinds.W.DataSource, lsEditFixedList,
      FParametersGrp.qParameterKinds.W.ParameterKind.FieldName);

    // Пусть монитор сообщает нам обо всех изменениях в БД
    TNotifyEventWrap.Create
      (FParametersGrp.qParameterTypes.Monitor.OnHaveAnyChanges,
      DoOnHaveAnyChanges, FEventList);

    TNotifyEventWrap.Create(FParametersGrp.qParameterTypes.W.AfterOpen,
      DoOnHaveAnyChanges, FEventList);

    TNotifyEventWrap.Create(FParametersGrp.qParameters.W.AfterOpen,
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

procedure TViewParameters2.UpdateButtonDown;
begin
  dxbbClearFilter.Down := (dxbbClearFilter.Action as TAction).Checked;
  dxbbAllDuplicate.Down := (dxbbAllDuplicate.Action as TAction).Checked;
  dxbbDuplicate.Down := (dxbbDuplicate.Action as TAction).Checked;
end;

procedure TViewParameters2.UpdateTotalCount;
begin
  // Общее число параметров
  StatusBar.Panels[StatusBar.Panels.Count - 1].Text :=
    Format('Всего: %d', [ParametersGrp.qParameters.FDQuery.RecordCount]);
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

  // Удалять разрешаем только если что-то выделено
  actDeleteEx.Enabled := OK and (AView <> nil) and
    (AView.Controller.SelectedRowCount > 0);

  // Если у нас хоть один фильтр на параметрах, тип удалять нельзя
  if (actAllDuplicate.Checked or actDuplicate.Checked) and
    (AView = MainView) then
    actDeleteEx.Enabled := False;

  actLoadFromExcelDocument.Enabled := OK;

  actLoadFromExcelSheet.Enabled := OK;

  actExportToExcelDocument.Enabled := OK and
    (FParametersGrp.qParameters.FDQuery.RecordCount > 0);

  actCommit.Enabled := OK and FParametersGrp.HaveAnyChanges;

  actRollback.Enabled := actCommit.Enabled;

  actDuplicate.Enabled := OK and (AView <> nil) and (AView.Level = cxGridLevel2) and
    (AView.ViewData.RowCount > 0);


  S := '';

  if OK and (AView <> nil) and (AView.Level = cxGridLevel2) and
    (AView.ViewData.RecordCount > 0) then
  begin
    AColumn := AView.GetColumnByFieldName(clTableName.DataBinding.FieldName);
    if (AColumn <> nil) and (AView.Controller.FocusedRow <> nil) then
    begin
      V := AView.Controller.FocusedRow.Values[AColumn.Index];
      if not VarIsNull(V) then
        S := String.Format('Дубликат %s', [V]);
    end;
  end;

  if S.IsEmpty then
    S := 'Дубликат';

  actDuplicate.Caption := S;

  actClearFilter.Enabled := OK;

  actAllDuplicate.Enabled := OK;

  actSearch.Enabled := not VarToStrDef(cxbeiSearch.CurEditValue, '').IsEmpty;

  UpdateTotalCount;
end;

end.
