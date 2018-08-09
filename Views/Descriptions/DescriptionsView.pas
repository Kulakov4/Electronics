unit DescriptionsView;

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
  cxGridDBBandedTableView, cxGrid, DescriptionsGroupUnit2,
  cxDBLookupComboBox, Vcl.Grids, Vcl.DBGrids, ColumnsBarButtonsHelper,
  cxGridDBTableView, dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
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
  dxSkinXmas2008Blue, dxSkinscxPCPainter, dxSkinsdxBarPainter, HRTimer,
  DragHelper, dxCore, System.Generics.Collections,
  cxDataControllerConditionalFormattingRulesManagerDialog, dxBarBuiltInMenu;

const
  WM_AFTER_SET_NEW_VALUE = WM_USER + 11;

type
  TViewDescriptions = class(TfrmGrid)
    cxGridLevel2: TcxGridLevel;
    cxGridDBBandedTableView2: TcxGridDBBandedTableView;
    clComponentType: TcxGridDBBandedColumn;
    clID2: TcxGridDBBandedColumn;
    clComponentName: TcxGridDBBandedColumn;
    clDescription: TcxGridDBBandedColumn;
    clID: TcxGridDBBandedColumn;
    dxbrbtnAdd: TdxBarButton;
    clIDComponentType: TcxGridDBBandedColumn;
    dxbrbtnAddDescription: TdxBarButton;
    actAddType: TAction;
    actAddDescription: TAction;
    dxbrbtnDelete: TdxBarButton;
    dxbrbtnLoad: TdxBarButton;
    actLoadFromExcelDocument: TAction;
    actCommit: TAction;
    dxbrbtnApplyUpdates: TdxBarButton;
    actRollback: TAction;
    dxbrbtnRollback: TdxBarButton;
    actShowDuplicate: TAction;
    dxbrbtnShowDuplicate: TdxBarButton;
    clIDProducer: TcxGridDBBandedColumn;
    dxbrsbtmExportImport: TdxBarSubItem;
    actExportToExcelDocument: TAction;
    dxbrbtnExportToExcelDocument: TdxBarButton;
    dxbrbtn1: TdxBarButton;
    clOrder: TcxGridDBBandedColumn;
    procedure actAddDescriptionExecute(Sender: TObject);
    procedure actAddTypeExecute(Sender: TObject);
    procedure actCommitExecute(Sender: TObject);
    procedure actExportToExcelDocumentExecute(Sender: TObject);
    procedure actLoadFromExcelDocumentExecute(Sender: TObject);
    procedure actRollbackExecute(Sender: TObject);
    procedure actShowDuplicateExecute(Sender: TObject);
    procedure clIDComponentTypePropertiesNewLookupDisplayText(Sender: TObject;
      const AText: TCaption);
    procedure clIDComponentTypePropertiesEditValueChanged(Sender: TObject);
    procedure clIDComponentTypePropertiesCloseUp(Sender: TObject);
    procedure cxGridDBBandedTableView2ColumnHeaderClick
      (Sender: TcxGridTableView; AColumn: TcxGridColumn);
    procedure cxGridDBBandedTableView2CustomDrawColumnHeader
      (Sender: TcxGridTableView; ACanvas: TcxCanvas;
      AViewInfo: TcxGridColumnHeaderViewInfo; var ADone: Boolean);
    procedure cxGridDBBandedTableViewDataControllerSummaryAfterSummary
      (ASender: TcxDataSummary);
    procedure cxGridDBBandedTableViewDragDrop(Sender, Source: TObject;
      X, Y: Integer);
    procedure cxGridDBBandedTableViewDragOver(Sender, Source: TObject;
      X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure cxGridDBBandedTableViewStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure cxGridDBBandedTableView2DataControllerCompare(ADataController
      : TcxCustomDataController; ARecordIndex1, ARecordIndex2,
      AItemIndex: Integer; const V1, V2: Variant; var Compare: Integer);
    procedure cxGridDBBandedTableView2StylesGetHeaderStyle
      (Sender: TcxGridTableView; AColumn: TcxGridColumn; var AStyle: TcxStyle);
  private
    FDescriptionsGroup: TDescriptionsGroup2;
    FDragAndDropInfo: TDragAndDropInfo;
    FEditValueChanged: Boolean;
    FHRTimer: THRTimer;
    FNewValue: string;

  const
    FolderKey: String = 'Descriptions';
    procedure DoOnHaveAnyChanges(Sender: TObject);
    procedure SetDescriptionsGroup(const Value: TDescriptionsGroup2);
    procedure UpdateTotalCount;
    { Private declarations }
  protected
    procedure AfterSetNewValue(var Message: TMessage);
      message WM_AFTER_SET_NEW_VALUE;
    procedure CreateColumnsBarButtons; override;
    procedure CreateFilterForExport(AView,
      ASource: TcxGridDBBandedTableView); override;
    function GetFocusedTableView: TcxGridDBBandedTableView; override;
    procedure LoadFromExcel(const AFileName: String);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Locate(const AComponentName: string);
    procedure UpdateView; override;
    property DescriptionsGroup: TDescriptionsGroup2 read FDescriptionsGroup
      write SetDescriptionsGroup;
    { Public declarations }
  end;

implementation

uses
  DescriptionsExcelDataModule, DialogUnit, ImportErrorForm, NotifyEvents,
  cxGridExportLink, CustomExcelTable, System.Math, SettingsController,
  System.IOUtils, ProjectConst, ProgressBarForm, cxDropDownEdit,
  cxGridDBDataDefinitions, cxVariants, RepositoryDataModule, GridSort,
  CustomErrorForm, DialogUnit2, LoadFromExcelFileHelper;

{$R *.dfm}

var
  b: Boolean = false;

constructor TViewDescriptions.Create(AOwner: TComponent);
begin
  inherited;
  StatusBarEmptyPanelIndex := 1;

  FDragAndDropInfo := TDragAndDropInfo.Create(clID, clOrder);

  PostOnEnterFields.Add(clComponentType.DataBinding.FieldName);

  GridSort.Add(TSortVariant.Create(clComponentName, [clComponentName]));
  GridSort.Add(TSortVariant.Create(clIDProducer,
    [clIDProducer, clComponentName]));

  DeleteMessages.Add(cxGridLevel, 'Удалить тип?');
  DeleteMessages.Add(cxGridLevel2, 'Удалить описание?');
end;

destructor TViewDescriptions.Destroy;
begin
  FreeAndNil(FDragAndDropInfo);
  inherited;
end;

procedure TViewDescriptions.actAddDescriptionExecute(Sender: TObject);
var
  ARow: TcxGridMasterDataRow;
  AView: TcxGridDBBandedTableView;
begin
  ARow := GetRow(0) as TcxGridMasterDataRow;
  ARow.Expand(false);
  AView := GetDBBandedTableView(1);
  AView.DataController.Append;
  FocusColumnEditor(1, clComponentName.DataBinding.FieldName);

  UpdateView;
end;

procedure TViewDescriptions.actAddTypeExecute(Sender: TObject);
begin
  MainView.DataController.Append;
  FocusColumnEditor(0, clComponentType.DataBinding.FieldName);

  UpdateView;
end;

procedure TViewDescriptions.actCommitExecute(Sender: TObject);
begin
  // Мы просто завершаем транзакцию
  // cxGrid.BeginUpdate();
  // try
  // Сохраняем изменения и завершаем транзакцию
  DescriptionsGroup.Commit;

  // Начинаем новую транзакцию
  // DescriptionsGroup.Connection.StartTransaction;

  // Переносим фокус на первую выделенную запись
  // FocusSelectedRecord;
  // finally
  // cxGrid.EndUpdate;
  // end;

  // Помещаем фокус в центр грида
  // PutInTheCenterFocusedRecord;

  // Обновляем представление
  UpdateView;
end;

procedure TViewDescriptions.actExportToExcelDocumentExecute(Sender: TObject);
var
  AFileName: String;
begin
  Application.Hint := '';
  if not TDialog.Create.ShowDialog(TExcelFileSaveDialog,
    TSettings.Create.GetFolderFoExcelFile(FolderKey), 'Краткие описания',
    AFileName) then
    Exit;

  ExportViewToExcel(cxGridDBBandedTableView2, AFileName,
    procedure(AView: TcxGridDBBandedTableView)
    begin
      AView.OptionsView.ColumnAutoWidth := false;
      AView.OptionsView.CellAutoHeight := True;
    end);
end;

procedure TViewDescriptions.actLoadFromExcelDocumentExecute(Sender: TObject);
var
  AFileName: string;
begin
  Application.Hint := '';
  if not TOpenExcelDialog.SelectInFolder(AFileName, Handle, FolderKey) then
    Exit;

  LoadFromExcel(AFileName);
end;

procedure TViewDescriptions.actRollbackExecute(Sender: TObject);
begin
  cxGrid.BeginUpdate();
  try
    // Отменяем все сделанные изменения
    DescriptionsGroup.Rollback;

    // Начинаем новую транзакцию
    // DescriptionsGroup.Connection.StartTransaction;

    // Переносим фокус на первую выделенную запись
    FocusSelectedRecord;
  finally
    cxGrid.EndUpdate;
  end;

  // Помещаем фокус в центр грида
  PutInTheCenterFocusedRecord;

  // Обновляем представление
  UpdateView;
end;

procedure TViewDescriptions.actShowDuplicateExecute(Sender: TObject);
var
  d: Boolean;
begin
  Application.Hint := '';
  d := not DescriptionsGroup.qDescriptions.ShowDuplicate;
  cxGrid.BeginUpdate();
  try
    DescriptionsGroup.qDescriptions.TryPost;
    DescriptionsGroup.qDescriptionTypes.TryPost;

    DescriptionsGroup.qDescriptions.ShowDuplicate := d;
    DescriptionsGroup.qDescriptionTypes.ShowDuplicate := d;

    // Переносим фокус на первую выделенную запись
    FocusSelectedRecord();
  finally
    cxGrid.EndUpdate;
  end;

  actShowDuplicate.Checked := d;

  // Помещаем фокус в центр грида
  PutInTheCenterFocusedRecord();

  // Обновляем представление
  UpdateView;
end;

procedure TViewDescriptions.AfterSetNewValue(var Message: TMessage);
var
  ADetailID: Integer;
  ARow: TcxGridMasterDataRow;
  AMasterID: Integer;
begin
  inherited;

  // Добавляем новый тип описания
  DescriptionsGroup.qDescriptionTypes.LocateOrAppend(FNewValue);
  FNewValue := '';

  AMasterID := DescriptionsGroup.qDescriptionTypes.PK.AsInteger;
  ADetailID := Message.WParam;

  // Ищем параметр
  DescriptionsGroup.qDescriptions.LocateByPK(ADetailID);
  DescriptionsGroup.qDescriptions.TryEdit;
  DescriptionsGroup.qDescriptions.IDComponentType.AsInteger := AMasterID;
  DescriptionsGroup.qDescriptions.TryPost;

  ARow := GetRow(0) as TcxGridMasterDataRow;
  Assert(ARow <> nil);

  ARow.Expand(false);
  FocusColumnEditor(1, clIDComponentType.DataBinding.FieldName);
end;

procedure TViewDescriptions.clIDComponentTypePropertiesCloseUp(Sender: TObject);
begin
  inherited;
  if FEditValueChanged then
  begin
    FEditValueChanged := false;
    cxGridDBBandedTableView2.DataController.Post();
  end
end;

procedure TViewDescriptions.clIDComponentTypePropertiesEditValueChanged
  (Sender: TObject);
var
  ADetailID: Integer;
  AMasterID: Integer;
begin
  if not FNewValue.IsEmpty then
  begin
    ADetailID := DescriptionsGroup.qDescriptions.PK.AsInteger;
    AMasterID := DescriptionsGroup.qDescriptionTypes.PK.AsInteger;

    // Возвращаем пока старое значение внешнего ключа
    DescriptionsGroup.qDescriptions.IDComponentType.AsInteger := AMasterID;
    DescriptionsGroup.qDescriptions.TryPost;

    // Посылаем сообщение о том что значение внешнего ключа надо будет изменить
    PostMessage(Handle, WM_AFTER_SET_NEW_VALUE, ADetailID, 0);
  end
  else
    FEditValueChanged := True;
end;

procedure TViewDescriptions.clIDComponentTypePropertiesNewLookupDisplayText
  (Sender: TObject; const AText: TCaption);
begin
  FNewValue := AText;
  // if b then
  // Exit;

  // b := True;
  // DescriptionsGroup.qDescriptionsMaster.AddNewValue(AText);
  // b := False;
end;

procedure TViewDescriptions.CreateColumnsBarButtons;
begin
  FColumnsBarButtons := TGVColumnsBarButtons.Create(Self, dxbsColumns,
    cxGridDBBandedTableView2);
end;

procedure TViewDescriptions.CreateFilterForExport(AView,
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
    (clComponentType);
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
      (clIDComponentType.DataBinding.FieldName);
    AView.DataController.Filter.AddItem(r, AColumn, AOperatorKind, Arr,
      'Список');
    AView.DataController.Filter.Active := True;
  end;
end;

procedure TViewDescriptions.cxGridDBBandedTableView2ColumnHeaderClick
  (Sender: TcxGridTableView; AColumn: TcxGridColumn);
begin
  inherited;
  ApplySort(Sender, AColumn);
end;

procedure TViewDescriptions.cxGridDBBandedTableView2CustomDrawColumnHeader
  (Sender: TcxGridTableView; ACanvas: TcxCanvas;
AViewInfo: TcxGridColumnHeaderViewInfo; var ADone: Boolean);
begin
  inherited;
  DoOnCustomDrawColumnHeader(AViewInfo, ACanvas);
end;

procedure TViewDescriptions.cxGridDBBandedTableView2DataControllerCompare
  (ADataController: TcxCustomDataController; ARecordIndex1, ARecordIndex2,
  AItemIndex: Integer; const V1, V2: Variant; var Compare: Integer);
var
  AController: TcxGridDBDataController;
  AItem1: TcxCustomGridTableItem;
  IsStr: Boolean;
  S1: string;
  S2: string;
  Val1: Variant;
  Val2: Variant;
begin

  // inherited;
  AController := ADataController as TcxGridDBDataController;
  AItem1 := TcxGridDBDataController(ADataController)
    .GetItemByFieldName(clIDProducer.DataBinding.FieldName);

  IsStr := AItemIndex = AItem1.Index;
  if IsStr then
  begin
    try
      Val1 := AController.DisplayTexts[ARecordIndex1, AItem1.Index];
      Val2 := AController.DisplayTexts[ARecordIndex2, AItem1.Index];
    except
      Val1 := NULL;
      Val2 := NULL;
    end;
    IsStr := (not VarIsNull(Val1)) and (not VarIsNull(Val2));
  end;

  if IsStr then
  begin
    S1 := Val1;
    S2 := Val2;

    Compare := String.Compare(S1, S2);
    // Compare := VarCompare(VarAsType(Val1, varString), VarAsType(Val2, varString));
  end
  else

    Compare := VarCompare(V1, V2);
end;

procedure TViewDescriptions.cxGridDBBandedTableView2StylesGetHeaderStyle
  (Sender: TcxGridTableView; AColumn: TcxGridColumn; var AStyle: TcxStyle);
begin
  inherited;
  DoOnGetHeaderStyle(AColumn, AStyle);
end;

procedure TViewDescriptions.
  cxGridDBBandedTableViewDataControllerSummaryAfterSummary
  (ASender: TcxDataSummary);
var
  AIndex: Integer;
  S: string;
begin
  inherited;
  AIndex := MainView.DataController.Summary.FooterSummaryItems.IndexOfItemLink
    (clComponentType);
  S := VarToStrDef(MainView.DataController.Summary.FooterSummaryValues
    [AIndex], '---');
  StatusBar.Panels[0].Text := S;
end;

procedure TViewDescriptions.cxGridDBBandedTableViewDragDrop(Sender,
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

  DoDragDrop(Sender as TcxGridSite, FDragAndDropInfo,
    FDescriptionsGroup.qDescriptionTypes, X, Y);

  // GetDBBandedTableView(0).Focused := True;
end;

procedure TViewDescriptions.cxGridDBBandedTableViewDragOver(Sender,
  Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  inherited;
  DoDragOver(Sender as TcxGridSite, X, Y, Accept);
end;

procedure TViewDescriptions.cxGridDBBandedTableViewStartDrag(Sender: TObject;
var DragObject: TDragObject);
begin
  inherited;
  DoOnStartDrag(Sender as TcxGridSite, FDragAndDropInfo);

  // Запускаем таймер чтобы рассчитать время переноса записей
  FHRTimer := THRTimer.Create(True);
end;

procedure TViewDescriptions.DoOnHaveAnyChanges(Sender: TObject);
begin
  UpdateView;
end;

function TViewDescriptions.GetFocusedTableView: TcxGridDBBandedTableView;
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

procedure TViewDescriptions.LoadFromExcel(const AFileName: String);
begin
  BeginUpdate;
  try
    TLoad.Create.LoadAndProcess(AFileName, TDescriptionsExcelDM,
      TfrmImportError,
      procedure(ASender: TObject)
      begin
        DescriptionsGroup.LoadDataFromExcelTable
          (ASender as TDescriptionsExcelTable);
      end,
      procedure(ASender: TObject)
      begin
        (ASender as TDescriptionsExcelTable).DescriptionsDataSet :=
          DescriptionsGroup.qDescriptions.FDQuery;
        (ASender as TDescriptionsExcelTable).ProducersDataSet :=
          DescriptionsGroup.qProducers.FDQuery
      end);
  finally
    EndUpdate;
  end;
  UpdateView;
end;

procedure TViewDescriptions.Locate(const AComponentName: string);
var
  List: TList<String>;
  ARow: TcxGridMasterDataRow;
  AView: TcxGridDBBandedTableView;
begin
  BeginUpdate;
  // Ищет производителя в гриде
  List := DescriptionsGroup.Find(clComponentName.DataBinding.FieldName,
    AComponentName);
  try
    // сначала ищем на первом уровне (по названию категории)
    if (List.Count > 0) and
      (MainView.DataController.Search.Locate(clComponentType.Index, List[0],
      True)) then
    begin
      // Затем ищем на втором уровне (по наименованию компонента)
      if List.Count > 1 then
      begin
        ARow := GetRow(0) as TcxGridMasterDataRow;
        ARow.Expand(false);
        AView := GetDBBandedTableView(1);
        AView.Focused := True;
        AView.DataController.Search.Locate(clComponentName.Index,
          List[1], True);
        PutInTheCenterFocusedRecord(AView);
      end
      else
        PutInTheCenterFocusedRecord(MainView);
    end;
  finally
    FreeAndNil(List);
    EndUpdate;
  end;
end;

procedure TViewDescriptions.SetDescriptionsGroup(const Value
  : TDescriptionsGroup2);
begin
  FDescriptionsGroup := Value;

  if FDescriptionsGroup <> nil then
  begin
    // привязываем представление к данным
    cxGridDBBandedTableView.DataController.DataSource :=
      FDescriptionsGroup.qDescriptionTypes.DataSource;
    cxGridDBBandedTableView2.DataController.DataSource :=
      FDescriptionsGroup.qDescriptions.DataSource;

    InitializeLookupColumn(clIDComponentType,
      FDescriptionsGroup.qDescriptionTypes.DataSource, lsEditList,
      FDescriptionsGroup.qDescriptionTypes.ComponentType.FieldName);

    // Производителя выбираем ТОЛЬКО из списка
    InitializeLookupColumn(clIDProducer,
      FDescriptionsGroup.qProducers.DataSource, lsFixedList,
      FDescriptionsGroup.qProducers.Name.FieldName);

    // Пусть монитор сообщает нам об изменениях в БД
    TNotifyEventWrap.Create(FDescriptionsGroup.qDescriptions.Monitor.
      OnHaveAnyChanges, DoOnHaveAnyChanges, FEventList);

    TNotifyEventWrap.Create(FDescriptionsGroup.qDescriptionTypes.AfterOpen,
      DoOnHaveAnyChanges, FEventList);

    TNotifyEventWrap.Create(FDescriptionsGroup.qDescriptions.AfterOpen,
      DoOnHaveAnyChanges, FEventList);
  end;
  UpdateView;
end;

procedure TViewDescriptions.UpdateTotalCount;
begin
  // Общее число компонентов на в БД
  StatusBar.Panels[StatusBar.Panels.Count - 1].Text :=
    Format('Всего: %d', [DescriptionsGroup.qDescriptions.FDQuery.RecordCount]);
end;

procedure TViewDescriptions.UpdateView;
var
  AView: TcxGridDBBandedTableView;
  OK: Boolean;
begin
  AView := FocusedTableView;
  OK := (DescriptionsGroup <> nil) and (AView <> nil);

  actAddType.Enabled := OK and
    (DescriptionsGroup.qDescriptionTypes.FDQuery.Active) and
    (not DescriptionsGroup.qDescriptionTypes.ShowDuplicate) and
    (AView.Level = cxGridLevel);

  actAddDescription.Enabled := OK and
    (DescriptionsGroup.qDescriptions.FDQuery.Active) and
    (not DescriptionsGroup.qDescriptionTypes.ShowDuplicate) and
    ((AView.Level = cxGridLevel) or (AView.Level = cxGridLevel2));

  // Удалять разрешаем только если что-то выделено
  actDeleteEx.Enabled := OK and (AView.Controller.SelectedRowCount > 0);

  actCommit.Enabled := OK and DescriptionsGroup.HaveAnyChanges;

  actRollback.Enabled := actCommit.Enabled;

  actLoadFromExcelDocument.Enabled := (DescriptionsGroup <> nil) and
    (not DescriptionsGroup.qDescriptionTypes.ShowDuplicate);

  actExportToExcelDocument.Enabled := (DescriptionsGroup <> nil) and
    (not DescriptionsGroup.qDescriptionTypes.ShowDuplicate) and
    (DescriptionsGroup.qDescriptions.FDQuery.RecordCount > 0);

  if actShowDuplicate.Checked then
    actShowDuplicate.Caption := 'Показать всё'
  else
    actShowDuplicate.Caption := 'Показать дубликаты';

  UpdateTotalCount;
end;

end.
