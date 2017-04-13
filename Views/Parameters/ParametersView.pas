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
    actDelete: TAction;
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
    actShowDublicate: TAction;
    dxBarManagerBar1: TdxBar;
    dxBarButton1: TdxBarButton;
    actFilterByTableName: TAction;
    dxBarButton2: TdxBarButton;
    clChecked: TcxGridDBBandedColumn;
    procedure actAddMainParameterExecute(Sender: TObject);
    procedure actAddParameterTypeExecute(Sender: TObject);
    procedure actAddSubParameterExecute(Sender: TObject);
    procedure actCommitExecute(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure actExportToExcelDocumentExecute(Sender: TObject);
    procedure actFilterByTableNameExecute(Sender: TObject);
    procedure actLoadFromExcelDocumentExecute(Sender: TObject);
    procedure actLoadFromExcelSheetExecute(Sender: TObject);
    procedure actRollbackExecute(Sender: TObject);
    procedure actSearchExecute(Sender: TObject);
    procedure actShowDublicateExecute(Sender: TObject);
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
    procedure cxGridDBBandedTableViewEditKeyDown(Sender: TcxCustomGridTableView;
      AItem: TcxCustomGridTableItem; AEdit: TcxCustomEdit; var Key: Word;
      Shift: TShiftState);
    procedure cxGridDBBandedTableViewDataControllerSummaryAfterSummary
      (ASender: TcxDataSummary);
    procedure cxGridDBBandedTableView2DataControllerSummaryAfterSummary
      (ASender: TcxDataSummary);
    procedure StatusBarResize(Sender: TObject);
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
    FDropDrag: TDropDrag;
    FEditValueChanged: Boolean;
    FExpandedRecordIndex: Integer;
    FHRTimer: THRTimer;
    FNewValue: string;
    FParametersGroup: TParametersGroup;
    FStartDrag: TStartDrag;
    FStartDragLevel: TcxGridLevel;
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
  System.StrUtils, BaseQuery, ProgressBarForm, cxDropDownEdit;

constructor TViewParameters.Create(AOwner: TComponent);
begin
  inherited;
  FExpandedRecordIndex := -1;
  FStartDrag := TStartDrag.Create;
  FDropDrag := TDropDrag.Create;

  // Имитируем выключение режима "галочки"
  FCheckedMode := True;
  CheckedMode := False;
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
    FocusSelectedRecord(MainView);
  finally
    cxGrid.EndUpdate;
  end;

  // Помещаем фокус в центр грида
  PutInTheCenterFocusedRecord(MainView);

  // Обновляем представление
  UpdateView;
end;

procedure TViewParameters.actDeleteExecute(Sender: TObject);
var
  AView: TcxGridDBBandedTableView;
  S: string;
begin
  AView := FocusedTableView;
  if AView = nil then
    Exit;

  S := '';
  if AView.Level = cxGridLevel then
    S := 'Удалить тип';

  if AView.Level = cxGridLevel2 then
    S := 'Удалить параметр';

  if AView.Level = cxGridLevel3 then
    S := 'Удалить подпараметр';

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
      AView.MasterGridRecord.Collapse(False);
    end;
  end;

  UpdateView;
end;

procedure TViewParameters.actExportToExcelDocumentExecute(Sender: TObject);
var
  AFileName: String;
begin
  AFileName := 'Параметры';
  AFileName := TDialog.Create.SaveToExcelFile(AFileName);
  if AFileName = '' then
    Exit;

  ExportViewToExcel(cxGridDBBandedTableView2, AFileName);
end;

procedure TViewParameters.actFilterByTableNameExecute(Sender: TObject);
var
  // AColumn: TcxGridDBBandedColumn;
  // AcxGridMasterDataRow: TcxGridMasterDataRow;
  AID: Integer;
  // AView: TcxGridDBBandedTableView;
  S: string;
begin
  actFilterByTableName.Checked := not actFilterByTableName.Checked;
  AID := ParametersGroup.qMainParameters.PKValue;

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
  {


    if ParametersGroup.qMainParameters.LocateByPK(AID) then
    begin
    // Ищем Категорию нашего параметра
    if ParametersGroup.qParameterTypes.LocateByPK
    (ParametersGroup.qMainParameters.IDParameterType.AsInteger) then
    begin
    // Получаем строку в гриде
    AcxGridMasterDataRow := GetRow(0) as TcxGridMasterDataRow;

    if actFilterByTableName.Checked then
    MainView.ViewData.Expand(True)
    else
    AcxGridMasterDataRow.Expand(false);

    // Получаем дочернее представление
    AView := GetDBBandedTableView(1);
    // Фокусируем его
    AView.Focused := True;
    PutInTheCenterFocusedRecord(AView);

    AColumn := AView.GetColumnByFieldName('TableName');
    // Site обеспечивает доступ к элементам размещённым на cxGrid
    AView.Site.SetFocus;
    // Показываем редактор для колонки
    AView.Controller.EditingController.ShowEdit(AColumn);
    end;
    end;
    { }
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

procedure TViewParameters.actShowDublicateExecute(Sender: TObject);
var
  AID: Integer;
  d: Boolean;
begin
  // if ParametersGroup.qMainParameters.FDQuery.RecordCount > 0 then
  AID := ParametersGroup.qMainParameters.PKValue;

  d := not ParametersGroup.qMainParameters.ShowDublicate;
  actShowDublicate.Checked := d;

  cxGrid.BeginUpdate();
  try
    ParametersGroup.qParameterTypes.TryPost;
    ParametersGroup.qMainParameters.TryPost;
    ParametersGroup.qSubParameters.TryPost;
    ParametersGroup.qParameterTypes.ShowDublicate := d;
    ParametersGroup.qMainParameters.ShowDublicate := d;
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

  AMasterID := FParametersGroup.qParameterTypes.PKValue;
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
    ADetailID := FParametersGroup.qMainParameters.PKValue;
    AMasterID := FParametersGroup.qParameterTypes.PKValue;

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
  FColumnsBarButtons := TColumnsBarButtons.Create(Self,
    dxbrsbtmColumnsCustomization, cxGridDBBandedTableView2);
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
  AcxCustomGridHitTest: TcxCustomGridHitTest;
  AcxGridDBBandedTableView: TcxGridDBBandedTableView;
  AcxGridRecordCellHitTest: TcxGridRecordCellHitTest;
  AcxGridViewNoneHitTest: TcxGridViewNoneHitTest;
  time: Double;
begin
  // Таймер должны были запустить
  Assert(FHRTimer <> nil);
  time := FHRTimer.ReadTimer;
  // Таймер больше не нужен
  FreeAndNil(FHRTimer);

  // Если это было случайное перемещение, то ничего не делаем
  if time < 500 then
    Exit;

  AcxGridDBBandedTableView := nil;

  cxGrid.BeginUpdate();
  try
    // Определяем точку переноса
    AcxCustomGridHitTest := (Sender as TcxGridSite).ViewInfo.GetHitTest(X, Y);

    if AcxCustomGridHitTest is TcxGridRecordCellHitTest then
    begin
      AcxGridRecordCellHitTest :=
        AcxCustomGridHitTest as TcxGridRecordCellHitTest;
      AcxGridDBBandedTableView := AcxGridRecordCellHitTest.GridView as
        TcxGridDBBandedTableView;

      // определяем порядок в точке переноса
      FDropDrag.OrderValue := AcxGridRecordCellHitTest.GridRecord.Values
        [clOrder.Index];

      // определяем код параметра в точке переноса
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
      FParametersGroup.qMainParameters.MoveDSRecord(FStartDrag, FDropDrag);
    end;
  finally
    cxGrid.EndUpdate;
  end;

  GetDBBandedTableView(1).Focused := True;
end;

procedure TViewParameters.cxGridDBBandedTableView2DragOver(Sender,
  Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
var
  AcxGridRecordCellHitTest: TcxGridRecordCellHitTest;
  AcxGridSite: TcxGridSite;
  AcxGridViewNoneHitTest: TcxGridViewNoneHitTest;
  HT: TcxCustomGridHitTest;
begin
  Accept := False;

  AcxGridSite := Sender as TcxGridSite;
  HT := AcxGridSite.ViewInfo.GetHitTest(X, Y);

  // Если перетаскиваем на пустой GridView
  if HT is TcxGridViewNoneHitTest then
  begin
    AcxGridViewNoneHitTest := HT as TcxGridViewNoneHitTest;

    Accept := AcxGridViewNoneHitTest.GridView.Level = FStartDragLevel;
  end;

  // Если перетаскиваем на ячейку GridView
  if HT is TcxGridRecordCellHitTest then
  begin
    AcxGridRecordCellHitTest := HT as TcxGridRecordCellHitTest;

    Accept := (AcxGridRecordCellHitTest.GridView.Level = FStartDragLevel) and
      (AcxGridRecordCellHitTest.GridRecord.RecordIndex <>
      AcxGridSite.GridView.DataController.FocusedRecordIndex);
  end

end;

procedure TViewParameters.cxGridDBBandedTableView2EditKeyDown
  (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
  AEdit: TcxCustomEdit; var Key: Word; Shift: TShiftState);
var
  AColumn: TcxGridDBBandedColumn;
  S: string;
begin
  inherited;
  AColumn := AItem as TcxGridDBBandedColumn;
  S := Format(',%s,', [AColumn.DataBinding.FieldName.ToLower]);

  if (Key = 13) and (',value,idparametertype,'.IndexOf(S) >= 0) then
    cxGridDBBandedTableView2.DataController.Post();
end;

procedure TViewParameters.cxGridDBBandedTableView2StartDrag(Sender: TObject;
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

    // запоминаем минимальный порядок записи которую начали переносить
    FStartDrag.MinOrderValue := Controller.SelectedRows[0].Values
      [clOrder.Index];

    // запоминаем максимальный порядок записи которую начали переносить
    FStartDrag.MaxOrderValue := Controller.SelectedRows
      [Controller.SelectedRecordCount - 1].Values[clOrder.Index];

    SetLength(FStartDrag.Keys, Controller.SelectedRowCount);
    for I := 0 to Controller.SelectedRowCount - 1 do
    begin
      FStartDrag.Keys[I] := Controller.SelectedRecords[I].Values[clID2.Index];
    end;

  end;

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
var
  AColumn: TcxGridDBBandedColumn;
  S: string;
begin
  inherited;
  AColumn := AItem as TcxGridDBBandedColumn;
  S := Format(',%s,', [AColumn.DataBinding.FieldName.ToLower]);

  if (Key = 13) and (',value,'.IndexOf(S) >= 0) then
    cxGridDBBandedTableView3.DataController.Post();
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
  AcxCustomGridHitTest: TcxCustomGridHitTest;
  AcxGridDBBandedTableView: TcxGridDBBandedTableView;
  AcxGridRecordCellHitTest: TcxGridRecordCellHitTest;
  AcxGridViewNoneHitTest: TcxGridViewNoneHitTest;
  time: Double;
begin
  // Таймер должны были запустить
  Assert(FHRTimer <> nil);
  time := FHRTimer.ReadTimer;
  // Таймер больше не нужен
  FreeAndNil(FHRTimer);

  // Если это было случайное перемещение, то ничего не делаем
  if time < 500 then
    Exit;

  AcxGridDBBandedTableView := nil;

  cxGrid.BeginUpdate();
  try
    // Определяем точку переноса
    AcxCustomGridHitTest := (Sender as TcxGridSite).ViewInfo.GetHitTest(X, Y);

    // Перенос на ячейку грида
    if AcxCustomGridHitTest is TcxGridRecordCellHitTest then
    begin
      AcxGridRecordCellHitTest :=
        AcxCustomGridHitTest as TcxGridRecordCellHitTest;
      AcxGridDBBandedTableView := AcxGridRecordCellHitTest.GridView as
        TcxGridDBBandedTableView;

      // определяем порядок в точке переноса
      FDropDrag.OrderValue := AcxGridRecordCellHitTest.GridRecord.Values
        [clOrd.Index];

      // определяем код параметра в точке переноса
      FDropDrag.Key := AcxGridRecordCellHitTest.GridRecord.Values[clID.Index];
    end;

    // Перенос на пустое место
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
      FParametersGroup.qParameterTypes.MoveDSRecord(FStartDrag, FDropDrag);
    end;

  finally
    cxGrid.EndUpdate;
  end;
end;

procedure TViewParameters.cxGridDBBandedTableViewDragOver(Sender,
  Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
var
  AcxGridRecordCellHitTest: TcxGridRecordCellHitTest;
  AcxGridSite: TcxGridSite;
  AcxGridViewNoneHitTest: TcxGridViewNoneHitTest;
  HT: TcxCustomGridHitTest;
begin
  Accept := False;

  AcxGridSite := Sender as TcxGridSite;
  HT := AcxGridSite.ViewInfo.GetHitTest(X, Y);

  // Если перетаскиваем на пустой GridView
  if HT is TcxGridViewNoneHitTest then
  begin
    AcxGridViewNoneHitTest := HT as TcxGridViewNoneHitTest;

    Accept := AcxGridViewNoneHitTest.GridView.Level = FStartDragLevel;
  end;

  // Если перетаскиваем на ячейку GridView
  if HT is TcxGridRecordCellHitTest then
  begin
    AcxGridRecordCellHitTest := HT as TcxGridRecordCellHitTest;

    Accept := (AcxGridRecordCellHitTest.GridView.Level = FStartDragLevel) and
      (AcxGridRecordCellHitTest.GridRecord.RecordIndex <>
      AcxGridSite.GridView.DataController.FocusedRecordIndex);
  end

end;

procedure TViewParameters.cxGridDBBandedTableViewEditKeyDown
  (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
  AEdit: TcxCustomEdit; var Key: Word; Shift: TShiftState);
begin
  inherited;
  if (Key = 13) and (AItem = clParameterType) then
    cxGridDBBandedTableView.DataController.Post();
end;

procedure TViewParameters.cxGridDBBandedTableViewStartDrag(Sender: TObject;
  var DragObject: TDragObject);
var
  I: Integer;
begin
  inherited;
  with (Sender as TcxGridSite).GridView as TcxGridDBBandedTableView do
  begin
    FStartDragLevel := Level as TcxGridLevel;
    Assert(Controller.SelectedRowCount > 0);

    if VarIsNull(Controller.SelectedRows[0].Values[clOrd.Index]) then
      Exit;

    // запоминаем минимальный порядок записи которую начали переносить
    FStartDrag.MinOrderValue := Controller.SelectedRows[0].Values[clOrd.Index];

    // запоминаем максимальный порядок записи которую начали переносить
    FStartDrag.MaxOrderValue := Controller.SelectedRows
      [Controller.SelectedRecordCount - 1].Values[clOrd.Index];

    SetLength(FStartDrag.Keys, Controller.SelectedRowCount);
    for I := 0 to Controller.SelectedRowCount - 1 do
    begin
      FStartDrag.Keys[I] := Controller.SelectedRecords[I].Values[clID.Index];
    end;

    // Запускаем таймер чтобы рассчитать время переноса записей
    FHRTimer := THRTimer.Create(True);
  end;
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
      procedure
      begin
        ParametersGroup.InsertList(AList);
      end, 'Обновление параметров в БД', sRecords);

  finally
    cxGridDBBandedTableView.EndUpdate;
  end;
end;

procedure TViewParameters.LoadFromExcel(AFileName: string);
var
  AfrmImportError: TfrmImportError;
  AParametersExcelDM: TParametersExcelDM;
  OK: Boolean;
begin
  AParametersExcelDM := TParametersExcelDM.Create(Self);
  try
    AParametersExcelDM.ExcelTable.ParametersDataSet :=
      ParametersGroup.qMainParameters.FDQuery;

    TfrmProgressBar.Process(AParametersExcelDM,
      procedure
      begin
        if not AFileName.IsEmpty then
          AParametersExcelDM.LoadExcelFile(AFileName)
        else
          AParametersExcelDM.LoadFromActiveSheet;
      end, 'Загрузка параметров из Excel документа', sRows);

    OK := AParametersExcelDM.ExcelTable.Errors.RecordCount = 0;

    if not OK then
    begin
      AfrmImportError := TfrmImportError.Create(Self);
      try
        AfrmImportError.ErrorTable := AParametersExcelDM.ExcelTable.Errors;
        OK := AfrmImportError.ShowModal = mrOk;

        // Если будем пропускать ошибки
        if AfrmImportError.ContinueType = ctSkip then
        begin
          // исключаем предупреждения и ошибки
          AParametersExcelDM.ExcelTable.ExcludeErrors(etWarring);
        end
        else
        begin
          // Исключаем только ошибки
          AParametersExcelDM.ExcelTable.ExcludeErrors(etError);
        end;
      finally
        FreeAndNil(AfrmImportError);
      end;
    end;

    if OK then
    begin
      InsertParametersList(AParametersExcelDM.ExcelTable);
    end;

  finally
    FreeAndNil(AParametersExcelDM);
  end;

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

procedure TViewParameters.StatusBarResize(Sender: TObject);
const
  EmptyPanelIndex = 1;
var
  I: Integer;
  X: Integer;
begin
  X := StatusBar.ClientWidth;
  for I := 0 to StatusBar.Panels.Count - 1 do
  begin
    if I <> EmptyPanelIndex then
    begin
      Dec(X, StatusBar.Panels[I].Width);
    end;
  end;
  X := IfThen(X >= 0, X, 0);
  StatusBar.Panels[EmptyPanelIndex].Width := X;
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
  StatusBar.Panels[2].Text := Format('Всего: %d',
    [ParametersGroup.qMainParameters.FDQuery.RecordCount]);
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

  actDelete.Enabled := OK and (AView <> nil) and
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

  actShowDublicate.Enabled := OK and
    (actShowDublicate.Checked or
    (FParametersGroup.qMainParameters.FDQuery.RecordCount > 0));
  actShowDublicate.Caption := IfThen(actShowDublicate.Checked, 'Показать всё',
    'Всё дубликаты');

  UpdateTotalCount;
end;

end.
