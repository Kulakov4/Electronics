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
  cxGridDBBandedTableView, cxGrid, ParametersGroupUnit,
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
  cxCheckBox;

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
    clParentParameter: TcxGridDBBandedColumn;
    clValue3: TcxGridDBBandedColumn;
    clValueT3: TcxGridDBBandedColumn;
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
  private
    FCheckedMode: Boolean;
    FParameterTypesDI: TDragAndDropInfo;
    FEditValueChanged: Boolean;
    FExpandedRecordIndex: Integer;
    FHRTimer: THRTimer;
    FNewValue: string;
    FParametersGroup: TParametersGroup;
    FParametersDI: TDragAndDropInfo;
    procedure InsertParametersList(AList: TParametersExcelTable);
    procedure SetCheckedMode(const Value: Boolean);
    procedure SetParametersGroup(const Value: TParametersGroup);
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
    procedure DoOnDataChange(Sender: TObject);
    function GetFocusedTableView: TcxGridDBBandedTableView; override;
    procedure LoadFromExcel(AFileName: string);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure MyApplyBestFit; override;
    procedure UpdateView; override;
    property CheckedMode: Boolean read FCheckedMode write SetCheckedMode;
    property ParametersGroup: TParametersGroup read FParametersGroup
      write SetParametersGroup;
    { Public declarations }
  end;

implementation

{$R *.dfm}

Uses NotifyEvents, DialogUnit, ImportErrorForm, ColumnsBarButtonsHelper,
  CustomExcelTable, RepositoryDataModule, System.Generics.Collections,
  System.Math, SettingsController, System.IOUtils, ProjectConst,
  System.StrUtils, BaseQuery, ProgressBarForm, cxDropDownEdit, CustomErrorForm,
  LoadFromExcelFileHelper;

constructor TViewParameters.Create(AOwner: TComponent);
begin
  inherited;
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
  PostOnEnterFields.Add(clValue3.DataBinding.FieldName);

  DeleteMessages.Add(cxGridLevel, 'Удалить тип?');
  DeleteMessages.Add(cxGridLevel2, 'Удалить параметр?');
  DeleteMessages.Add(cxGridLevel3, 'Удалить подпараметр?');
end;

destructor TViewParameters.Destroy;
begin
  FreeAndNil(FParameterTypesDI);
  inherited;
end;

procedure TViewParameters.actAddMainParameterExecute(Sender: TObject);
var
  ARow: TcxGridMasterDataRow;
  AView: TcxGridDBBandedTableView;
begin
  // Сначала сохраняем тип параметра
  FParametersGroup.qParameterTypes.TryPost;

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
  FParametersGroup.qMainParameters.TryPost;

  ARow := GetRow(1) as TcxGridMasterDataRow;
  if ARow <> nil then
  begin
    AView := GetDBBandedTableView(2);
    AView.DataController.Append;
    {
      FParametersGroup.qSubParameters.TryAppend;
      FParametersGroup.qSubParameters.ParentParameter.AsInteger :=
      FParametersGroup.qMainParameters.PKValue;
    }
    // Application.ProcessMessages;

    // for I := 0 to FParametersGroup.qSubParameters.FDQuery.FieldCount - 1 do
    // ro := FParametersGroup.qSubParameters.FDQuery.Fields[i].ReadOnly;

    FParametersGroup.qSubParameters.Value.AsString := 'Новое наименование';
    ARow.Expand(False);
    // AView := GetDBBandedTableView(2);
    AView.Controller.ClearSelection;
    FParametersGroup.qSubParameters.TryEdit;
    // FParametersGroup.qSubParameters.Value.AsString := '';
    // AView.DataController.Append;
    FocusColumnEditor(2, clValue3.DataBinding.FieldName);
  end;
  UpdateView;
end;

procedure TViewParameters.actCommitExecute(Sender: TObject);
begin
  cxGrid.BeginUpdate();
  try
    // СОхраняем все сделанные изменения
    FParametersGroup.Commit;

    // FParametersGroup.Connection.StartTransaction;

    // Переносим фокус на первую выделенную запись
    FocusSelectedRecord();
  finally
    cxGrid.EndUpdate;
  end;

  // Помещаем фокус в центр грида
  PutInTheCenterFocusedRecord();

  // Обновляем представление
  UpdateView;
end;

procedure TViewParameters.actExportToExcelDocumentExecute(Sender: TObject);
var
  AFileName: String;
begin
  if not TDialog.Create.SaveToExcelFile('Параметры', AFileName) then
    Exit;

  ExportViewToExcel(cxGridDBBandedTableView2, AFileName);
end;

procedure TViewParameters.actFilterByTableNameExecute(Sender: TObject);
var
  AID: Variant;
  S: string;
begin
  actFilterByTableName.Checked := not actFilterByTableName.Checked;
  AID := ParametersGroup.qMainParameters.PK.Value;

  S := IfThen(actFilterByTableName.Checked,
    ParametersGroup.qMainParameters.TableName.AsString, '');
  cxGrid.BeginUpdate();
  try
    ParametersGroup.qParameterTypes.TryPost;
    ParametersGroup.qMainParameters.TryPost;
    ParametersGroup.qSubParameters.TryPost;

    // Фильтруем параметры по табличному имени
    ParametersGroup.qMainParameters.TableNameFilter := S;
    // Фильтруем типы параметров по табличному имени
    ParametersGroup.qParameterTypes.TableNameFilter := S;
  finally
    cxGrid.EndUpdate;
  end;

  // Ищем тот же параметр
  LocateAndFocus(ParametersGroup.qParameterTypes,
    ParametersGroup.qMainParameters, AID,
    ParametersGroup.qMainParameters.IDParameterType.FieldName,
    ParametersGroup.qMainParameters.TableName.FieldName);

  if actFilterByTableName.Checked then
    MainView.ViewData.Expand(True);

  // Обновляем представление
  UpdateView;
end;

procedure TViewParameters.actLoadFromExcelDocumentExecute(Sender: TObject);
var
  AFileName: string;
begin
  AFileName := TDialog.Create.OpenExcelFile
    (TSettings.Create.LastFolderForExcelFile);
  if not AFileName.IsEmpty then
  begin
    // Сохраняем эту папку в настройках
    TSettings.Create.LastFolderForExcelFile :=
      TPath.GetDirectoryName(AFileName);

    LoadFromExcel(AFileName);
  end;
end;

procedure TViewParameters.actLoadFromExcelSheetExecute(Sender: TObject);
begin
  LoadFromExcel('');
end;

procedure TViewParameters.actRollbackExecute(Sender: TObject);
begin
  cxGrid.BeginUpdate();
  try
    // Отменяем все сделанные изменения
    FParametersGroup.Rollback;

    // Начинаем новую транзакцию
    // FParametersGroup.Connection.StartTransaction;

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
  AColumn: TcxGridDBBandedColumn;
  ARow: TcxGridMasterDataRow;
  AView: TcxGridDBBandedTableView;
  List: TList<String>;
  S: string;
begin
  S := cxbeiSearch.CurEditValue;
  S := cxbeiSearch.EditValue;

  // Будем искать по табличному имени (либо по названию категории)
  AColumn := clTableName;

  List := ParametersGroup.Find(AColumn.DataBinding.FieldName, S);
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

procedure TViewParameters.actShowDuplicateExecute(Sender: TObject);
var
  AID: Variant;
  d: Boolean;
begin
  AID := ParametersGroup.qMainParameters.PK.Value;

  d := not ParametersGroup.qMainParameters.ShowDuplicate;
  actShowDuplicate.Checked := d;

  cxGrid.BeginUpdate();
  try
    ParametersGroup.qParameterTypes.TryPost;
    ParametersGroup.qMainParameters.TryPost;
    ParametersGroup.qSubParameters.TryPost;
    ParametersGroup.qParameterTypes.ShowDuplicate := d;
    ParametersGroup.qMainParameters.ShowDuplicate := d;
  finally
    cxGrid.EndUpdate;
  end;

  // Ищем тот же параметр
  LocateAndFocus(ParametersGroup.qParameterTypes,
    ParametersGroup.qMainParameters, AID,
    ParametersGroup.qMainParameters.IDParameterType.FieldName,
    ParametersGroup.qMainParameters.TableName.FieldName);

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
  FParametersGroup.qParameterTypes.LocateOrAppend(FNewValue);
  FNewValue := '';

  AMasterID := FParametersGroup.qParameterTypes.PK.AsInteger;
  ADetailID := Message.WParam;

  // Ищем параметр
  FParametersGroup.qMainParameters.LocateByPK(ADetailID);
  FParametersGroup.qMainParameters.TryEdit;
  FParametersGroup.qMainParameters.IDParameterType.AsInteger := AMasterID;
  FParametersGroup.qMainParameters.TryPost;

  ARow := GetRow(0) as TcxGridMasterDataRow;
  Assert(ARow <> nil);

  // AView := GetDBBandedTableView(1);
  ARow.Expand(False);
  FocusColumnEditor(1, clIDParameterType.DataBinding.FieldName);
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
    ADetailID := FParametersGroup.qMainParameters.PK.AsInteger;
    AMasterID := FParametersGroup.qParameterTypes.PK.AsInteger;

    // Возвращаем пока старое значение внешнего ключа
    FParametersGroup.qMainParameters.IDParameterType.AsInteger := AMasterID;
    FParametersGroup.qMainParameters.TryPost;

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
  a: array of string;
  Arr: Variant;
  X: Integer;
begin
  F := cxGridDBBandedTableView.DataController.Filter.FindItemByItemLink
    (clParameterType);
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
      (clIDParameterType.DataBinding.FieldName);
    AView.DataController.Filter.AddItem(r, AColumn, AOperatorKind, Arr,
      'Список');
    AView.DataController.Filter.Active := True;
  end;
end;

procedure TViewParameters.cxbeiSearchPropertiesEditValueChanged
  (Sender: TObject);
begin
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
    FParametersGroup.qMainParameters, X, Y);
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

procedure TViewParameters.cxGridDBBandedTableViewDataControllerDetailExpanded
  (ADataController: TcxCustomDataController; ARecordIndex: Integer);
begin
  inherited;
  FExpandedRecordIndex := ARecordIndex;
  MyApplyBestFit;
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
    FParametersGroup.qParameterTypes, X, Y);
end;

procedure TViewParameters.cxGridDBBandedTableViewDragOver(Sender,
  Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  DoDragOver(Sender as TcxGridSite, X, Y, Accept);
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

procedure TViewParameters.DoOnDataChange(Sender: TObject);
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

procedure TViewParameters.InsertParametersList(AList: TParametersExcelTable);
begin
  cxGridDBBandedTableView.BeginUpdate();
  try
    TfrmProgressBar.Process(AList,
      procedure(ASender: TObject)
      begin
        ParametersGroup.InsertList(AList);
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
        InsertParametersList(ASender as TParametersExcelTable)
      end,
      procedure(ASender: TObject)
      begin
        (ASender as TParametersExcelTable).ParametersDataSet :=
          ParametersGroup.qMainParameters.FDQuery;
      end);
  finally
    EndUpdate;
  end;
  UpdateView;
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

    AView.BeginBestFitUpdate;
    try
      AView.ApplyBestFit(nil, True, True);
    finally
      AView.EndBestFitUpdate;
    end;

    // изменяем минимальные размеры всех колонок
    UpdateColumnsMinWidth(AView);
  end;
end;

procedure TViewParameters.SetCheckedMode(const Value: Boolean);
begin
  if FCheckedMode = Value then
    Exit;

  FCheckedMode := Value;
  clChecked.Visible := FCheckedMode;
  clChecked.VisibleForCustomization := clOrder.Visible;

  if ParametersGroup <> nil then
  begin
    UpdateAutoTransaction;
  end;
end;

procedure TViewParameters.SetParametersGroup(const Value: TParametersGroup);
begin
  if FParametersGroup <> Value then
  begin
    FParametersGroup := Value;
    FEventList.Clear;

    if FParametersGroup <> nil then
    begin
      cxGridDBBandedTableView.DataController.DataSource :=
        FParametersGroup.qParameterTypes.DataSource;
      cxGridDBBandedTableView2.DataController.DataSource :=
        FParametersGroup.qMainParameters.DataSource;
      cxGridDBBandedTableView3.DataController.DataSource :=
        FParametersGroup.qSubParameters.DataSource;

      InitializeLookupColumn(clIDParameterType,
        FParametersGroup.qParameterTypes.DataSource, lsEditList,
        FParametersGroup.qParameterTypes.ParameterType.FieldName);

      TNotifyEventWrap.Create(FParametersGroup.AfterDataChange, DoOnDataChange,
        FEventList);
      TNotifyEventWrap.Create(FParametersGroup.qParameterTypes.AfterOpen,
        DoOnDataChange, FEventList);
      TNotifyEventWrap.Create(FParametersGroup.qMainParameters.AfterOpen,
        DoOnDataChange, FEventList);
      TNotifyEventWrap.Create(FParametersGroup.qSubParameters.AfterOpen,
        DoOnDataChange, FEventList);

      UpdateAutoTransaction;
    end;

    UpdateView;
  end;
end;

procedure TViewParameters.UpdateAutoTransaction;
begin
  ParametersGroup.qParameterTypes.AutoTransaction := FCheckedMode;
  ParametersGroup.qMainParameters.AutoTransaction := FCheckedMode;
  ParametersGroup.qSubParameters.AutoTransaction := FCheckedMode;
end;

procedure TViewParameters.UpdateTotalCount;
begin
  // Общее число компонентов на в БД
  StatusBar.Panels[StatusBar.Panels.Count - 1].Text :=
    Format('Всего: %d', [ParametersGroup.qMainParameters.FDQuery.RecordCount]);
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
  OK := (FParametersGroup <> nil) and
    (FParametersGroup.qParameterTypes.FDQuery.Active) and
    (FParametersGroup.qMainParameters.FDQuery.Active) and
    (FParametersGroup.qSubParameters.FDQuery.Active);

  actAddParameterType.Enabled := OK and (AView <> nil) and
    (AView.Level = cxGridLevel);

  actAddMainParameter.Enabled := OK and (AView <> nil) and
    ((AView.Level = cxGridLevel) or (AView.Level = cxGridLevel2));

  actAddSubParameter.Enabled := OK and (AView <> nil) and
    (((AView.Level = cxGridLevel2)) or (AView.Level = cxGridLevel3));

  actDeleteEx.Enabled := OK and (AView <> nil) and
    (AView.DataController.RecordCount > 0);

  actLoadFromExcelDocument.Enabled := OK;

  actLoadFromExcelSheet.Enabled := OK;

  actExportToExcelDocument.Enabled := OK and
    (FParametersGroup.qMainParameters.FDQuery.RecordCount > 0);

  actCommit.Enabled := OK and FParametersGroup.Connection.InTransaction;

  actRollback.Enabled := actCommit.Enabled;

  actFilterByTableName.Enabled := OK and (AView <> nil) and
    (AView.Level = cxGridLevel2) and ((AView.ViewData.RecordCount > 0) or
    not FParametersGroup.qMainParameters.TableNameFilter.IsEmpty);

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
    (FParametersGroup.qMainParameters.FDQuery.RecordCount > 0));
  actShowDuplicate.Caption := IfThen(actShowDuplicate.Checked, 'Показать всё',
    'Все дубликаты');

  UpdateTotalCount;
end;

end.
