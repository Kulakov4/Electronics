unit ParametersView;

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
  cxGridDBBandedTableView, cxGrid, ParametersGroupUnit2,
  cxDBLookupComboBox, cxBlobEdit, FireDAC.Comp.Client, cxTextEdit,
  HRTimer, DragHelper, ParametersExcelDataModule, dxSkinsCore,
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
  dxSkinXmas2008Blue, dxSkinscxPCPainter, dxSkinsdxBarPainter, cxBarEditItem,
  cxCheckBox, cxDataControllerConditionalFormattingRulesManagerDialog,
  dxBarBuiltInMenu;

const
  WM_AFTER_SET_NEW_VALUE = WM_USER + 12;
  WM_AFTER_EDIT_VALUE_CHANGED = WM_USER + 13;

type
  TViewParameters = class(TfrmGrid)
    actAddParameterType: TAction;
    clID: TcxGridDBBandedColumn;
    clParameterType: TcxGridDBBandedColumn;
    cxGridLevel2: TcxGridLevel;
    cxGridDBBandedTableView2: TcxGridDBBandedTableView;
    clID2: TcxGridDBBandedColumn;
    clValue2: TcxGridDBBandedColumn;
    clValueT: TcxGridDBBandedColumn;
    clIDParameterType: TcxGridDBBandedColumn;
    actAddMainParameter: TAction;
    dxbbAddType: TdxBarButton;
    dxbbAddMainParameter: TdxBarButton;
    clOrder: TcxGridDBBandedColumn;
    clCodeLetters: TcxGridDBBandedColumn;
    clMeasuringUnit: TcxGridDBBandedColumn;
    clTableName: TcxGridDBBandedColumn;
    clDefinition: TcxGridDBBandedColumn;
    dxbrbtnDelete: TdxBarButton;
    actLoadFromExcelDocument: TAction;
    actLoadFromExcelSheet: TAction;
    dxbrsbtmExportImport: TdxBarSubItem;
    dxbrbtnLoadFromExcelDocument: TdxBarButton;
    dxbrbtnLoadFromExcelSheet: TdxBarButton;
    actExportToExcelDocument: TAction;
    dxbrbtnExportToExcel: TdxBarButton;
    dxbrbtnCommit: TdxBarButton;
    cxGridLevel3: TcxGridLevel;
    cxGridDBBandedTableView3: TcxGridDBBandedTableView;
    clID3: TcxGridDBBandedColumn;
    clIdParameter: TcxGridDBBandedColumn;
    actAddSubParameter: TAction;
    dxbrbtnAddSubParameter: TdxBarButton;
    actCommit: TAction;
    actRollback: TAction;
    dxbrbtnRollBack: TdxBarButton;
    dxbrSearch: TdxBar;
    dxbbSearch: TdxBarButton;
    actSearch: TAction;
    cxbeiSearch: TcxBarEditItem;
    clOrd: TcxGridDBBandedColumn;
    actShowDuplicate: TAction;
    dxBarManagerBar1: TdxBar;
    dxBarButton1: TdxBarButton;
    actFilterByTableName: TAction;
    dxBarButton2: TdxBarButton;
    clChecked: TcxGridDBBandedColumn;
    clIDParameterKind: TcxGridDBBandedColumn;
    clIDSubParameter: TcxGridDBBandedColumn;
    clTranslation: TcxGridDBBandedColumn;
    clChecked3: TcxGridDBBandedColumn;
    dxBarButton3: TdxBarButton;
    procedure actAddMainParameterExecute(Sender: TObject);
    procedure actAddParameterTypeExecute(Sender: TObject);
    procedure actAddSubParameterExecute(Sender: TObject);
    procedure actCommitExecute(Sender: TObject);
    procedure actExportToExcelDocumentExecute(Sender: TObject);
    procedure actFilterByTableNameExecute(Sender: TObject);
    procedure actLoadFromExcelDocumentExecute(Sender: TObject);
    procedure actLoadFromExcelSheetExecute(Sender: TObject);
    procedure actRollbackExecute(Sender: TObject);
    procedure actSearchExecute(Sender: TObject);
    procedure actShowDuplicateExecute(Sender: TObject);
    procedure cxGridDBBandedTableViewDataControllerDetailExpanded
      (ADataController: TcxCustomDataController; ARecordIndex: Integer);
    procedure clIDParameterTypePropertiesNewLookupDisplayText(Sender: TObject;
      const AText: TCaption);
    procedure clIDParameterTypePropertiesEditValueChanged(Sender: TObject);
    procedure clIDParameterTypePropertiesCloseUp(Sender: TObject);
    procedure cxGridDBBandedTableView2DragDrop(Sender, Source: TObject;
      X, Y: Integer);
    procedure cxGridDBBandedTableView2DragOver(Sender, Source: TObject;
      X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure cxGridDBBandedTableView2EditKeyDown
      (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
      AEdit: TcxCustomEdit; var Key: Word; Shift: TShiftState);
    procedure cxGridDBBandedTableView2StartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure cxGridDBBandedTableView2TcxGridDBDataControllerTcxDataSummaryFooterSummaryItems0GetText
      (Sender: TcxDataSummaryItem; const AValue: Variant; AIsFooter: Boolean;
      var AText: string);
    procedure cxGridDBBandedTableView3EditKeyDown
      (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
      AEdit: TcxCustomEdit; var Key: Word; Shift: TShiftState);
    procedure cxGridDBBandedTableViewDataControllerSummaryAfterSummary
      (ASender: TcxDataSummary);
    procedure cxGridDBBandedTableView2DataControllerSummaryAfterSummary
      (ASender: TcxDataSummary);
    procedure cxbeiSearchPropertiesValidate(Sender: TObject;
      var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
    procedure cxbeiSearchPropertiesEditValueChanged(Sender: TObject);
    procedure cxGridDBBandedTableViewDragDrop(Sender, Source: TObject;
      X, Y: Integer);
    procedure cxGridDBBandedTableViewDragOver(Sender, Source: TObject;
      X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure cxGridDBBandedTableViewStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure clIDSubParameterPropertiesCloseUp(Sender: TObject);
    procedure cxGridDBBandedTableView3KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cxGridDBBandedTableView3MouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure cxGridDBBandedTableViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cxGridDBBandedTableViewMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    FCheckedMode: Boolean;
    FParameterTypesDI: TDragAndDropInfo;
    FEditValueChanged: Boolean;
    FExpandedRecordIndex: Integer;
    FHRTimer: THRTimer;
    FNewValue: string;
    FParametersGrp: TParametersGroup2;
    FParametersDI: TDragAndDropInfo;

  const
    FolderKey: String = 'Parameters';
    procedure LoadDataFromExcelTable(AData: TParametersExcelTable);
    procedure SetCheckedMode(const Value: Boolean);
    procedure SetParametersGrp(const Value: TParametersGroup2);
    procedure UpdateAutoTransaction;
    procedure UpdateTotalCount;
    { Private declarations }
  protected
    procedure AfterSetNewValue(var Message: TMessage);
      message WM_AFTER_SET_NEW_VALUE;
    procedure CreateColumnsBarButtons; override;
    procedure CreateFilterForExport(AView,
      ASource: TcxGridDBBandedTableView); override;
    procedure DoAfterEditValueChanged(var Message: TMessage);
      message WM_AFTER_EDIT_VALUE_CHANGED;
    procedure DoOnHaveAnyChanges(Sender: TObject);
    function GetFocusedTableView: TcxGridDBBandedTableView; override;
    procedure LoadFromExcel(AFileName: string);
    procedure LocateAndFocus(AParameterID: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CheckAndSaveChanges: Integer;
    procedure CommitOrPost;
    procedure MyApplyBestFit; override;
    procedure Search(const AName: string);
    procedure UpdateView; override;
    property CheckedMode: Boolean read FCheckedMode write SetCheckedMode;
    property ParametersGrp: TParametersGroup2 read FParametersGrp
      write SetParametersGrp;
    { Public declarations }
  end;

implementation

{$R *.dfm}

Uses NotifyEvents, DialogUnit, ImportErrorForm, ColumnsBarButtonsHelper,
  CustomExcelTable, RepositoryDataModule, System.Generics.Collections,
  System.Math, SettingsController, System.IOUtils, ProjectConst,
  System.StrUtils, BaseQuery, ProgressBarForm, cxDropDownEdit, CustomErrorForm,
  LoadFromExcelFileHelper, DialogUnit2;

constructor TViewParameters.Create(AOwner: TComponent);
begin
  inherited;
  // clCodeLetters.Caption := clCodeLetters.Caption.Replace(' ', #13#10);
  // clMeasuringUnit.Caption := clMeasuringUnit.Caption.Replace(' ', #13#10);
  ApplyBestFitMultiLine := True;

  FExpandedRecordIndex := -1;

  FParameterTypesDI := TDragAndDropInfo.Create(clID, clOrd);
  FParametersDI := TDragAndDropInfo.Create(clID2, clOrder);

  // Имитируем выключение режима "галочки"
  FCheckedMode := True;
  CheckedMode := False;
  StatusBarEmptyPanelIndex := 1;

  PostOnEnterFields.Add(clParameterType.DataBinding.FieldName);
  PostOnEnterFields.Add(clValue2.DataBinding.FieldName);
  PostOnEnterFields.Add(clIDParameterType.DataBinding.FieldName);
  PostOnEnterFields.Add(clIDSubParameter.DataBinding.FieldName);

  DeleteMessages.Add(cxGridLevel, 'Удалить тип?');
  DeleteMessages.Add(cxGridLevel2, 'Удалить параметр?');
  DeleteMessages.Add(cxGridLevel3, 'Удалить подпараметр?');
end;

destructor TViewParameters.Destroy;
begin
  FreeAndNil(FParametersDI);
  FreeAndNil(FParameterTypesDI);
  inherited;
end;

procedure TViewParameters.actAddMainParameterExecute(Sender: TObject);
var
  ARow: TcxGridMasterDataRow;
  AView: TcxGridDBBandedTableView;
begin
  // Сначала сохраняем тип параметра
  FParametersGrp.qParameterTypes.TryPost;

  ARow := GetRow(0) as TcxGridMasterDataRow;
  ARow.Expand(False);
  AView := GetDBBandedTableView(1);
  AView.Controller.ClearSelection;
  AView.DataController.Append;
  FocusColumnEditor(1, clValue2.DataBinding.FieldName);

  UpdateView;
end;

procedure TViewParameters.actAddParameterTypeExecute(Sender: TObject);
begin
  MainView.Controller.ClearSelection;
  MainView.DataController.Append;
  FocusColumnEditor(0, clParameterType.DataBinding.FieldName);

  UpdateView;
end;

procedure TViewParameters.actAddSubParameterExecute(Sender: TObject);
var
  ARow: TcxGridMasterDataRow;
  AView: TcxGridDBBandedTableView;
begin
  FParametersGrp.qParameters.TryPost;

  ARow := GetRow(1) as TcxGridMasterDataRow;
  if ARow <> nil then
  begin
    AView := GetDBBandedTableView(2);

    // Чтобы можно было раскрыть, надо чтобы была хотя-бы одна запись

    FParametersGrp.qParamSubParams.IDSubParameter.Required := False;
    // Тут контроллер сам заполнит IdParameter
    AView.DataController.Append;
    AView.DataController.Post;
    FParametersGrp.qParamSubParams.IDSubParameter.Required := True;

    // Во время ракрытия произойдёт неявный Post
    // Поле IdSubParameter останется пустым!!
    ARow.Expand(False);

    AView.DataController.DeleteFocused;

    AView.DataController.Append;

    FocusColumnEditor(2, clIDSubParameter.DataBinding.FieldName);
  end;
  UpdateView;
end;

procedure TViewParameters.actCommitExecute(Sender: TObject);
begin
  FParametersGrp.Commit;

  // Обновляем представление
  UpdateView;
end;

procedure TViewParameters.actExportToExcelDocumentExecute(Sender: TObject);
var
  AFileName: String;
begin
  Application.Hint := '';
  if not TDialog.Create.ShowDialog(TExcelFileSaveDialog,
    TSettings.Create.GetFolderFoExcelFile(FolderKey), 'Параметры', AFileName)
  then
    Exit;

  ExportViewToExcel(cxGridDBBandedTableView2, AFileName);
end;

procedure TViewParameters.actFilterByTableNameExecute(Sender: TObject);
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
    ParametersGrp.qSubParameters.TryPost;

    // Фильтруем параметры по табличному имени
    ParametersGrp.qParameters.TableNameFilter := S;
    // Фильтруем типы параметров по табличному имени
    ParametersGrp.qParameterTypes.TableNameFilter := S;
  finally
    cxGrid.EndUpdate;
  end;

  if actFilterByTableName.Checked then
    MainView.ViewData.Expand(True)
  else
    LocateAndFocus(AID);

  // Обновляем представление
  UpdateView;
end;

procedure TViewParameters.actLoadFromExcelDocumentExecute(Sender: TObject);
var
  AFileName: string;
begin
  Application.Hint := '';
  if TOpenExcelDialog.SelectInFolder(AFileName, Handle, FolderKey) then
    LoadFromExcel(AFileName);
end;

procedure TViewParameters.actLoadFromExcelSheetExecute(Sender: TObject);
begin
  Application.Hint := '';
  LoadFromExcel('');
end;

procedure TViewParameters.actRollbackExecute(Sender: TObject);
begin
  cxGrid.BeginUpdate();
  try
    // Отменяем все сделанные изменения
    FParametersGrp.Rollback;

    // Начинаем новую транзакцию
    // FParametersGrp.Connection.StartTransaction;

    // Переносим фокус на первую выделенную запись
    FocusSelectedRecord(MainView);
  finally
    cxGrid.EndUpdate;
  end;

  // Помещаем фокус в центр грида
  PutInTheCenterFocusedRecord(MainView);

  // Обновляем представление
  UpdateView;
end;

procedure TViewParameters.actSearchExecute(Sender: TObject);
var
  S: string;
begin
  // S := cxbeiSearch.CurEditValue;
  S := cxbeiSearch.EditValue;
  Search(S);
end;

procedure TViewParameters.actShowDuplicateExecute(Sender: TObject);
var
  AID: Variant;
  d: Boolean;
begin
  Application.Hint := '';
  AID := ParametersGrp.qParameters.PK.Value;

  d := not ParametersGrp.qParameters.ShowDuplicate;
  actShowDuplicate.Checked := d;

  cxGrid.BeginUpdate();
  try
    ParametersGrp.qParameterTypes.TryPost;
    ParametersGrp.qParameters.TryPost;
    ParametersGrp.qSubParameters.TryPost;
    ParametersGrp.qParameterTypes.ShowDuplicate := d;
    ParametersGrp.qParameters.ShowDuplicate := d;
  finally
    cxGrid.EndUpdate;
  end;

  if actShowDuplicate.Checked then
    LocateAndFocus(AID)
  else
    // нажимаем кнопку "Показать все" - сделай отображение типов в свёрнутом виде.
    MainView.ViewData.Collapse(True);

  // Обновляем представление
  UpdateView;

end;

procedure TViewParameters.AfterSetNewValue(var Message: TMessage);
var
  ADetailID: Integer;
  ARow: TcxGridMasterDataRow;
  AMasterID: Integer;
begin
  inherited;
  // Добавляем новый тип параметра
  FParametersGrp.qParameterTypes.LocateOrAppend(FNewValue);
  FNewValue := '';

  AMasterID := FParametersGrp.qParameterTypes.PK.AsInteger;
  ADetailID := Message.WParam;

  // Ищем параметр
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

function TViewParameters.CheckAndSaveChanges: Integer;
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

procedure TViewParameters.clIDParameterTypePropertiesCloseUp(Sender: TObject);
begin
  inherited;
  if FEditValueChanged then
  begin
    FEditValueChanged := False;
    cxGridDBBandedTableView2.DataController.Post();
  end
end;

procedure TViewParameters.clIDParameterTypePropertiesEditValueChanged
  (Sender: TObject);
var
  ADetailID: Integer;
  AMasterID: Integer;
begin
  if not FNewValue.IsEmpty then
  begin
    ADetailID := FParametersGrp.qParameters.PK.AsInteger;
    AMasterID := FParametersGrp.qParameterTypes.PK.AsInteger;

    // Возвращаем пока старое значение внешнего ключа
    FParametersGrp.qParameters.IDParameterType.AsInteger := AMasterID;
    FParametersGrp.qParameters.TryPost;

    // Посылаем сообщение о том что значение внешнего ключа надо будет изменить
    PostMessage(Handle, WM_AFTER_SET_NEW_VALUE, ADetailID, 0);
  end
  else
    FEditValueChanged := True;
end;

procedure TViewParameters.clIDParameterTypePropertiesNewLookupDisplayText
  (Sender: TObject; const AText: TCaption);
begin
  inherited;
  FNewValue := AText;
end;

procedure TViewParameters.clIDSubParameterPropertiesCloseUp(Sender: TObject);
begin
  inherited;
  FParametersGrp.qParamSubParams.TryPost;
end;

procedure TViewParameters.CommitOrPost;
begin
  // actCommit может быть Disabled!!!
  UpdateView;

  if CheckedMode then // В этом случае транзакция не начата
    ParametersGrp.TryPost
  else
    actCommit.Execute; // завершаем транзакцию
end;

procedure TViewParameters.CreateColumnsBarButtons;
begin
  FColumnsBarButtons := TGVColumnsBarButtons.Create(Self, dxbsColumns,
    cxGridDBBandedTableView2);
end;

procedure TViewParameters.CreateFilterForExport(AView,
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

procedure TViewParameters.cxbeiSearchPropertiesEditValueChanged
  (Sender: TObject);
begin
  UpdateView;
  actSearch.Execute;
end;

procedure TViewParameters.cxbeiSearchPropertiesValidate(Sender: TObject;
  var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
begin
  inherited;
  cxbeiSearch.EditValue := DisplayValue;
end;

procedure TViewParameters.
  cxGridDBBandedTableView2DataControllerSummaryAfterSummary
  (ASender: TcxDataSummary);
{ var
  AColumn: TcxGridDBBandedColumn;
  AIndex: Integer;
  AView: TcxGridDBBandedTableView;
  S: string;
}
begin
  inherited;
  {
    AView := GetDBBandedTableView(1);
    AColumn := AView.GetColumnByFieldName(clValue2.DataBinding.FieldName);
    AIndex := AView.DataController.Summary.FooterSummaryItems.IndexOfItemLink(AColumn);
    S := VarToStrDef(AView.DataController.Summary.FooterSummaryValues[AIndex], '---');
    StatusBar.Panels[1].Text := S;
  }
end;

procedure TViewParameters.cxGridDBBandedTableView2DragDrop(Sender,
  Source: TObject; X, Y: Integer);
var
  time: Double;
begin
  // Таймер должны были запустить
  Assert(FHRTimer <> nil);
  time := FHRTimer.ReadTimer;
  // Таймер больше не нужен
  FreeAndNil(FHRTimer);

  // Если это было случайное перемещение, то ничего не делаем
  if time < DragDropTimeOut then
    Exit;

  DoDragDrop(Sender as TcxGridSite, FParametersDI,
    FParametersGrp.qParameters, X, Y);
end;

procedure TViewParameters.cxGridDBBandedTableView2DragOver(Sender,
  Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  DoDragOver(Sender as TcxGridSite, X, Y, Accept);
end;

procedure TViewParameters.cxGridDBBandedTableView2EditKeyDown
  (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
  AEdit: TcxCustomEdit; var Key: Word; Shift: TShiftState);
begin
  inherited;
  PostMessage(Handle, WM_AfterKeyOrMouseDown, 0, 0);
  DoOnEditKeyDown(Sender, AItem, AEdit, Key, Shift);
end;

procedure TViewParameters.cxGridDBBandedTableView2StartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
  inherited;
  DoOnStartDrag(Sender as TcxGridSite, FParametersDI);

  // Запускаем таймер чтобы рассчитать время переноса записей
  FHRTimer := THRTimer.Create(True);
end;

procedure TViewParameters.
  cxGridDBBandedTableView2TcxGridDBDataControllerTcxDataSummaryFooterSummaryItems0GetText
  (Sender: TcxDataSummaryItem; const AValue: Variant; AIsFooter: Boolean;
  var AText: string);
begin
  AText := AValue;
end;

procedure TViewParameters.cxGridDBBandedTableView3EditKeyDown
  (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
  AEdit: TcxCustomEdit; var Key: Word; Shift: TShiftState);
begin
  inherited;
  PostMessage(Handle, WM_AfterKeyOrMouseDown, 0, 0);
  DoOnEditKeyDown(Sender, AItem, AEdit, Key, Shift);
end;

procedure TViewParameters.cxGridDBBandedTableView3KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  inherited;
  PostMessage(Handle, WM_AfterKeyOrMouseDown, 0, 0);
end;

procedure TViewParameters.cxGridDBBandedTableView3MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  PostMessage(Handle, WM_AfterKeyOrMouseDown, 0, 0);
end;

procedure TViewParameters.cxGridDBBandedTableViewDataControllerDetailExpanded
  (ADataController: TcxCustomDataController; ARecordIndex: Integer);
var
  AcxGridMasterDataRow: TcxGridMasterDataRow;
  AView: TcxGridDBBandedTableView;
begin
  inherited;
  FExpandedRecordIndex := ARecordIndex;

  if ARecordIndex < 0 then
    Exit;

  AcxGridMasterDataRow := cxGridDBBandedTableView.ViewData.Records[ARecordIndex]
    as TcxGridMasterDataRow;

  AView := AcxGridMasterDataRow.ActiveDetailGridView as
    TcxGridDBBandedTableView;

  MyApplyBestFitForView(AView);
end;

procedure TViewParameters.
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

procedure TViewParameters.cxGridDBBandedTableViewDragDrop(Sender,
  Source: TObject; X, Y: Integer);
var
  time: Double;
begin
  // Таймер должны были запустить
  Assert(FHRTimer <> nil);
  time := FHRTimer.ReadTimer;
  // Таймер больше не нужен
  FreeAndNil(FHRTimer);

  // Если это было случайное перемещение, то ничего не делаем
  if time < DragDropTimeOut then
    Exit;

  DoDragDrop(Sender as TcxGridSite, FParameterTypesDI,
    FParametersGrp.qParameterTypes, X, Y);
end;

procedure TViewParameters.cxGridDBBandedTableViewDragOver(Sender,
  Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  DoDragOver(Sender as TcxGridSite, X, Y, Accept);
end;

procedure TViewParameters.cxGridDBBandedTableViewKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  inherited;
  PostMessage(Handle, WM_AfterKeyOrMouseDown, 0, 0);
end;

procedure TViewParameters.cxGridDBBandedTableViewMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  PostMessage(Handle, WM_AfterKeyOrMouseDown, 0, 0);
end;

procedure TViewParameters.cxGridDBBandedTableViewStartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
  inherited;

  DoOnStartDrag(Sender as TcxGridSite, FParameterTypesDI);

  // Запускаем таймер чтобы рассчитать время переноса записей
  FHRTimer := THRTimer.Create(True);
end;

procedure TViewParameters.DoAfterEditValueChanged(var Message: TMessage);
begin
  TQueryBase(Message.WParam).TryPost;
end;

procedure TViewParameters.DoOnHaveAnyChanges(Sender: TObject);
begin
  UpdateView;
end;

function TViewParameters.GetFocusedTableView: TcxGridDBBandedTableView;
begin
  Result := inherited;

  // Если не первый уровень в фокусе
  if (Result = nil) then
  begin
    Result := GetDBBandedTableView(1);
    if (Result <> nil) and (not Result.Focused) then
      Result := nil;
  end;

  // Если не второй уровень в фокусе
  if (Result = nil) then
  begin
    Result := GetDBBandedTableView(2);
    if (Result <> nil) and (not Result.Focused) then
      Result := nil;
  end;
end;

procedure TViewParameters.LoadDataFromExcelTable(AData: TParametersExcelTable);
begin
  cxGridDBBandedTableView.BeginUpdate();
  try
    TfrmProgressBar.Process(AData,
      procedure(ASender: TObject)
      begin
        ParametersGrp.LoadDataFromExcelTable(AData);
      end, 'Обновление параметров в БД', sRecords);

  finally
    cxGridDBBandedTableView.EndUpdate;
  end;
end;

procedure TViewParameters.LoadFromExcel(AFileName: string);
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
        (ASender as TParametersExcelTable).ParametersInt := ParametersGrp.qParameters;
      end);
  finally
    EndUpdate;
  end;
  UpdateView;
end;

procedure TViewParameters.LocateAndFocus(AParameterID: Integer);
var
  ARow: TcxGridMasterDataRow;
  AView: TcxGridDBBandedTableView;
begin
  // Переходим на параметр и его тип
  ParametersGrp.LocateAll(AParameterID);

  // Запись о типе - в цент
  PutInTheCenterFocusedRecord(MainView);

  // Разворачиваем запись
  ARow := MainView.Controller.FocusedRow as TcxGridMasterDataRow;
  Assert(ARow <> nil);
  ARow.Expand(False);

  AView := ARow.ActiveDetailGridView as TcxGridDBBandedTableView;

  // Фокусируем его
  AView.Focused := True;
  // Запись о параметре - в центр
  PutInTheCenterFocusedRecord(AView);

  // Выделяем строку и столбец
  AView.ViewData.Records[AView.Controller.FocusedRecordIndex].Selected := True;
  AView.Columns[clValue2.Index].Selected := True;
end;

procedure TViewParameters.MyApplyBestFit;
var
  ARow, r: TcxGridMasterDataRow;
  AView: TcxGridDBBandedTableView;
  I: Integer;
begin
  Exit;
  ARow := nil;

  // если мы точно знаем какую строку сейчас раскрыли
  if FExpandedRecordIndex >= 0 then
  begin
    I := MainView.DataController.GetRowIndexByRecordIndex
      (FExpandedRecordIndex, False);
    ARow := GetRow(0, I) as TcxGridMasterDataRow;
  end
  else
  begin
    for I := 0 to MainView.ViewData.RowCount - 1 do
    begin
      r := GetRow(0, I) as TcxGridMasterDataRow;
      if (ARow.Expanded) and (ARow.Visible) then
      begin
        ARow := r;
        Break;
      end;
    end;
  end;

  if ARow <> nil then
  begin
    // Спускаемся на уровень ниже
    AView := ARow.ActiveDetailGridView as TcxGridDBBandedTableView;

    MyApplyBestFitForView(AView);
    {
      AView.BeginBestFitUpdate;
      try
      AView.ApplyBestFit(nil, True, True);
      finally
      AView.EndBestFitUpdate;
      end;
    }
    // изменяем минимальные размеры всех колонок
    UpdateColumnsMinWidth(AView);
  end;
end;

procedure TViewParameters.Search(const AName: string);
var
  AColumn: TcxGridDBBandedColumn;
  ARow: TcxGridMasterDataRow;
  AView: TcxGridDBBandedTableView;
  List: TList<String>;
  S: string;
begin
  Assert(not AName.IsEmpty);
  S := AName;

  // Будем искать по табличному имени (либо по названию категории)
  AColumn := clTableName;

  List := ParametersGrp.Find(AColumn.DataBinding.FieldName, S);
  try
    // сначала ищем на первом уровне (по названию категории)
    if (List.Count > 0) and
      (MainView.DataController.Search.Locate(clParameterType.Index, List[0],
      True)) then
    begin
      // Затем ищем на втором уровне (по табличному имени)
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

procedure TViewParameters.SetCheckedMode(const Value: Boolean);
begin
  if FCheckedMode = Value then
    Exit;

  FCheckedMode := Value;
  clChecked.Visible := FCheckedMode;
  clChecked.VisibleForCustomization := clOrder.Visible;

  clChecked3.Visible := FCheckedMode;
  clChecked3.VisibleForCustomization := clOrder.Visible;

  if ParametersGrp <> nil then
  begin
    UpdateAutoTransaction;
  end;
end;

procedure TViewParameters.SetParametersGrp(const Value: TParametersGroup2);
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
    cxGridDBBandedTableView3.DataController.DataSource :=
      FParametersGrp.qParamSubParams.DataSource;

    InitializeLookupColumn(clIDParameterType,
      FParametersGrp.qParameterTypes.DataSource, lsEditList,
      FParametersGrp.qParameterTypes.ParameterType.FieldName);

    InitializeLookupColumn(clIDParameterKind,
      FParametersGrp.qParameterKinds.DataSource, lsEditFixedList,
      FParametersGrp.qParameterKinds.ParameterKind.FieldName);

    InitializeLookupColumn(clIDSubParameter,
      FParametersGrp.qSubParameters.DataSource, lsEditFixedList,
      FParametersGrp.qSubParameters.Name.FieldName);

    // Пусть монитор сообщает нам обо всех изменениях в БД
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

procedure TViewParameters.UpdateAutoTransaction;
begin
  ParametersGrp.qParameterTypes.AutoTransaction := FCheckedMode;
  ParametersGrp.qParameters.AutoTransaction := FCheckedMode;
  ParametersGrp.qParamSubParams.AutoTransaction := FCheckedMode;
end;

procedure TViewParameters.UpdateTotalCount;
begin
  // Общее число компонентов на в БД
  StatusBar.Panels[StatusBar.Panels.Count - 1].Text :=
    Format('Всего: %d', [ParametersGrp.qParameters.FDQuery.RecordCount]);
end;

procedure TViewParameters.UpdateView;
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
    (FParametersGrp.qParameters.FDQuery.Active) and
    (FParametersGrp.qParamSubParams.FDQuery.Active);

  actAddParameterType.Enabled := OK and (AView <> nil) and
    (AView.Level = cxGridLevel);

  actAddMainParameter.Enabled := OK and (AView <> nil) and
    ((AView.Level = cxGridLevel) or (AView.Level = cxGridLevel2));

  actAddSubParameter.Enabled := OK and (AView <> nil) and
    (((AView.Level = cxGridLevel2)) or (AView.Level = cxGridLevel3));

  // Удалять разрешаем только если что-то выделено
  actDeleteEx.Enabled := OK and (AView <> nil) and
    (AView.Controller.SelectedRowCount > 0);

  actLoadFromExcelDocument.Enabled := OK;

  actLoadFromExcelSheet.Enabled := OK;

  actExportToExcelDocument.Enabled := OK and
    (FParametersGrp.qParameters.FDQuery.RecordCount > 0);

  actCommit.Enabled := OK and FParametersGrp.HaveAnyChanges;

  actRollback.Enabled := actCommit.Enabled;

  actFilterByTableName.Enabled := OK and (AView <> nil) and
    (AView.Level = cxGridLevel2) and ((AView.ViewData.RecordCount > 0) or
    not FParametersGrp.qParameters.TableNameFilter.IsEmpty);

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

  actFilterByTableName.Caption := IfThen(actFilterByTableName.Checked,
    'Снять фильтр', S);

  actShowDuplicate.Enabled := OK and
    (actShowDuplicate.Checked or
    (FParametersGrp.qParameters.FDQuery.RecordCount > 0));
  actShowDuplicate.Caption := IfThen(actShowDuplicate.Checked, 'Показать всё',
    'Все дубликаты');

  UpdateTotalCount;
end;

end.
