unit ProducersView;

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
  cxGridDBBandedTableView, cxGrid, ProducersQuery, dxSkinsCore,
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
  dxSkinXmas2008Blue, dxSkinscxPCPainter, dxSkinsdxBarPainter,
  SearchProducerTypesQuery, cxMemo, ProducersGroupUnit2, cxDBLookupComboBox,
  DragHelper, HRTimer, ColumnsBarButtonsHelper, System.Generics.Collections,
  cxDataControllerConditionalFormattingRulesManagerDialog, dxBarBuiltInMenu;

const
  WM_AFTER_SET_NEW_VALUE = WM_USER + 18;

type
  TViewProducers = class(TfrmGrid)
    clID: TcxGridDBBandedColumn;
    actAdd: TAction;
    dxbbAdd: TdxBarButton;
    dxbbDelete: TdxBarButton;
    actCommit: TAction;
    actRollback: TAction;
    dxbrbtnCommit: TdxBarButton;
    dxbrbtnRollback: TdxBarButton;
    dxbrsbtmExportImport: TdxBarSubItem;
    dxbrbtnExport: TdxBarButton;
    dxbrbtnImport: TdxBarButton;
    actExportToExcelDocument: TAction;
    actLoadFromExcelDocument: TAction;
    clProducerType: TcxGridDBBandedColumn;
    cxGridLevel2: TcxGridLevel;
    cxGridDBBandedTableView2: TcxGridDBBandedTableView;
    clName2: TcxGridDBBandedColumn;
    clProducts2: TcxGridDBBandedColumn;
    clCount2: TcxGridDBBandedColumn;
    clID2: TcxGridDBBandedColumn;
    clProducerTypeID: TcxGridDBBandedColumn;
    actAddType: TAction;
    dxBarButton1: TdxBarButton;
    clOrder: TcxGridDBBandedColumn;
    procedure actAddExecute(Sender: TObject);
    procedure actAddTypeExecute(Sender: TObject);
    procedure actCommitExecute(Sender: TObject);
    procedure actExportToExcelDocumentExecute(Sender: TObject);
    procedure actLoadFromExcelDocumentExecute(Sender: TObject);
    procedure actRollbackExecute(Sender: TObject);
    procedure cxGridDBBandedTableView2EditKeyDown
      (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
      AEdit: TcxCustomEdit; var Key: Word; Shift: TShiftState);
    procedure cxGridDBBandedTableViewDataControllerSummaryAfterSummary
      (ASender: TcxDataSummary);
    procedure clProducerTypeIDPropertiesCloseUp(Sender: TObject);
    procedure clProducerTypeIDPropertiesEditValueChanged(Sender: TObject);
    procedure clProducerTypeIDPropertiesNewLookupDisplayText(Sender: TObject;
      const AText: TCaption);
    procedure cxGridDBBandedTableViewDragDrop(Sender, Source: TObject;
      X, Y: Integer);
    procedure cxGridDBBandedTableViewDragOver(Sender, Source: TObject;
      X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure cxGridDBBandedTableViewStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure cxGridDBBandedTableViewDataControllerDetailExpanded
      (ADataController: TcxCustomDataController; ARecordIndex: Integer);
    procedure cxGridDBBandedTableView2StylesGetHeaderStyle
      (Sender: TcxGridTableView; AColumn: TcxGridColumn; var AStyle: TcxStyle);
  private
    FDragAndDropInfo: TDragAndDropInfo;
    FEditValueChanged: Boolean;
    FHRTimer: THRTimer;
    FNewValue: string;
    FProducersGroup: TProducersGroup2;
    FQuerySearchProducerTypes: TQuerySearchProducerTypes;

  const
    FolderKey = 'Producers';
    function GetQuerySearchProducerTypes: TQuerySearchProducerTypes;
    procedure MyInitializeComboBoxColumn;
    procedure SetProducersGroup(const Value: TProducersGroup2);
    procedure UpdateTotalCount;
    { Private declarations }
  protected
    procedure AfterSetNewValue(var Message: TMessage);
      message WM_AFTER_SET_NEW_VALUE;
    procedure CreateColumnsBarButtons; override;
    procedure DoAfterPost(Sender: TObject);
    procedure DoOnHaveAnyChanges(Sender: TObject);
    function GetFocusedTableView: TcxGridDBBandedTableView; override;
    procedure LoadFromExcel(const AFileName: String);
    property QuerySearchProducerTypes: TQuerySearchProducerTypes
      read GetQuerySearchProducerTypes;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Locate(const AProducer: string);
    procedure UpdateView; override;
    property ProducersGroup: TProducersGroup2 read FProducersGroup
      write SetProducersGroup;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses NotifyEvents, RepositoryDataModule, DialogUnit,
  ProducersExcelDataModule, ImportErrorForm, CustomExcelTable, System.Math,
  SettingsController, System.IOUtils, ProjectConst, ProgressBarForm,
  cxDropDownEdit, DialogUnit2, CustomErrorForm, LoadFromExcelFileHelper;

constructor TViewProducers.Create(AOwner: TComponent);
begin
  inherited;
  StatusBarEmptyPanelIndex := 1;

  FDragAndDropInfo := TDragAndDropInfo.Create(clID, clOrder);

  PostOnEnterFields.Add(clProducerType.DataBinding.FieldName);
  PostOnEnterFields.Add(clName2.DataBinding.FieldName);

  DeleteMessages.Add(cxGridLevel, 'Удалить тип?');
  DeleteMessages.Add(cxGridLevel2, 'Удалить производителя?');
end;

destructor TViewProducers.Destroy;
begin
  FreeAndNil(FDragAndDropInfo);
  inherited;
end;

procedure TViewProducers.actAddExecute(Sender: TObject);
var
  ARow: TcxGridMasterDataRow;
  AView: TcxGridDBBandedTableView;
begin
  ARow := GetRow(0) as TcxGridMasterDataRow;
  ARow.Expand(false);
  AView := GetDBBandedTableView(1);
  AView.DataController.Append;
  FocusColumnEditor(1, clName2.DataBinding.FieldName);
end;

procedure TViewProducers.actAddTypeExecute(Sender: TObject);
begin
  inherited;
  MainView.Controller.ClearSelection;
  MainView.DataController.Append;
  // MainView.Controller.FocusedRow.Selected := True;
  FocusColumnEditor(0, clProducerType.DataBinding.FieldName);

  UpdateView;
end;

procedure TViewProducers.actCommitExecute(Sender: TObject);
begin
  ProducersGroup.Commit;
  UpdateView;
end;

procedure TViewProducers.actExportToExcelDocumentExecute(Sender: TObject);
var
  AFileName: String;
begin
  Application.Hint := '';
  if not TDialog.Create.ShowDialog(TExcelFileSaveDialog,
    TSettings.Create.GetFolderFoExcelFile(FolderKey), 'Производители', AFileName)
  then
    Exit;

  ExportViewToExcel(cxGridDBBandedTableView2, AFileName,
    procedure(AView: TcxGridDBBandedTableView)
    var
      AColumn: TcxGridDBBandedColumn;
    begin
      AColumn := AView.GetColumnByFieldName
        (ProducersGroup.qProducers.Cnt.FieldName);
      if AColumn <> nil then
        AColumn.Visible := false;
    end);
end;

procedure TViewProducers.actLoadFromExcelDocumentExecute(Sender: TObject);
var
  AFileName: string;
begin
  Application.Hint := '';
  if not TOpenExcelDialog.SelectInFolder(AFileName, Handle, FolderKey) then
    Exit;

  LoadFromExcel(AFileName);
end;

procedure TViewProducers.actRollbackExecute(Sender: TObject);
begin
  cxGrid.BeginUpdate();
  try
    // Отменяем все сделанные изменения
    ProducersGroup.Rollback;

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

procedure TViewProducers.AfterSetNewValue(var Message: TMessage);
var
  ADetailID: Integer;
  ARow: TcxGridMasterDataRow;
  AMasterID: Integer;
begin
  inherited;

  // Добавляем новый тип описания
  ProducersGroup.qProducerTypes.LocateOrAppend(FNewValue);
  FNewValue := '';

  AMasterID := ProducersGroup.qProducerTypes.PK.AsInteger;
  ADetailID := Message.WParam;

  // Ищем параметр
  ProducersGroup.qProducers.LocateByPK(ADetailID);
  ProducersGroup.qProducers.TryEdit;
  ProducersGroup.qProducers.ProducerTypeID.AsInteger := AMasterID;
  ProducersGroup.qProducers.TryPost;

  ARow := GetRow(0) as TcxGridMasterDataRow;
  Assert(ARow <> nil);

  ARow.Expand(false);
  FocusColumnEditor(1, clProducerTypeID.DataBinding.FieldName);
end;

procedure TViewProducers.clProducerTypeIDPropertiesCloseUp(Sender: TObject);
begin
  inherited;
  if FEditValueChanged then
  begin
    FEditValueChanged := false;
    cxGridDBBandedTableView2.DataController.Post();
  end
end;

procedure TViewProducers.clProducerTypeIDPropertiesEditValueChanged
  (Sender: TObject);
var
  ADetailID: Integer;
  AMasterID: Integer;
begin
  if not FNewValue.IsEmpty then
  begin
    ADetailID := ProducersGroup.qProducers.PK.AsInteger;
    AMasterID := ProducersGroup.qProducerTypes.PK.AsInteger;

    // Возвращаем пока старое значение внешнего ключа
    ProducersGroup.qProducers.ProducerTypeID.AsInteger := AMasterID;
    ProducersGroup.qProducers.TryPost;

    // Посылаем сообщение о том что значение внешнего ключа надо будет изменить
    PostMessage(Handle, WM_AFTER_SET_NEW_VALUE, ADetailID, 0);
  end
  else
    FEditValueChanged := True;
end;

procedure TViewProducers.clProducerTypeIDPropertiesNewLookupDisplayText
  (Sender: TObject; const AText: TCaption);
begin
  inherited;
  FNewValue := AText;

end;

procedure TViewProducers.CreateColumnsBarButtons;
begin
  FColumnsBarButtons := TGVColumnsBarButtons.Create(Self, dxbsColumns,
    cxGridDBBandedTableView2);
end;

procedure TViewProducers.cxGridDBBandedTableView2EditKeyDown
  (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
AEdit: TcxCustomEdit; var Key: Word; Shift: TShiftState);
begin
  inherited;
  PostMessage(Handle, WM_AfterKeyOrMouseDown, 0, 0);
  DoOnEditKeyDown(Sender, AItem, AEdit, Key, Shift);
end;

procedure TViewProducers.cxGridDBBandedTableView2StylesGetHeaderStyle
  (Sender: TcxGridTableView; AColumn: TcxGridColumn; var AStyle: TcxStyle);
begin
  inherited;
  DoOnGetHeaderStyle(AColumn, AStyle);
end;

procedure TViewProducers.cxGridDBBandedTableViewDataControllerDetailExpanded
  (ADataController: TcxCustomDataController; ARecordIndex: Integer);
var
  AcxGridMasterDataRow: TcxGridMasterDataRow;
begin
  inherited;
  if ARecordIndex < 0 then
    Exit;

  AcxGridMasterDataRow := cxGridDBBandedTableView.ViewData.Records[ARecordIndex]
    as TcxGridMasterDataRow;
  (AcxGridMasterDataRow.ActiveDetailGridView as TcxGridDBBandedTableView)
    .ApplyBestFit();
end;

procedure TViewProducers.
  cxGridDBBandedTableViewDataControllerSummaryAfterSummary
  (ASender: TcxDataSummary);
var
  AIndex: Integer;
  S: string;
begin
  inherited;
  AIndex := MainView.DataController.Summary.FooterSummaryItems.IndexOfItemLink
    (clProducerType);
  S := VarToStrDef(MainView.DataController.Summary.FooterSummaryValues
    [AIndex], '---');
  StatusBar.Panels[0].Text := S;
end;

procedure TViewProducers.cxGridDBBandedTableViewDragDrop(Sender,
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
    FProducersGroup.qProducerTypes, X, Y);
end;

procedure TViewProducers.cxGridDBBandedTableViewDragOver(Sender,
  Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  inherited;
  DoDragOver(Sender as TcxGridSite, X, Y, Accept);
end;

procedure TViewProducers.cxGridDBBandedTableViewStartDrag(Sender: TObject;
var DragObject: TDragObject);
begin
  inherited;
  DoOnStartDrag(Sender as TcxGridSite, FDragAndDropInfo);

  // Запускаем таймер чтобы рассчитать время переноса записей
  FHRTimer := THRTimer.Create(True);

end;

procedure TViewProducers.DoAfterPost(Sender: TObject);
begin
  MyInitializeComboBoxColumn;
end;

procedure TViewProducers.DoOnHaveAnyChanges(Sender: TObject);
begin
  UpdateView;
end;

function TViewProducers.GetFocusedTableView: TcxGridDBBandedTableView;
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

function TViewProducers.GetQuerySearchProducerTypes: TQuerySearchProducerTypes;
begin
  if FQuerySearchProducerTypes = nil then
    FQuerySearchProducerTypes := TQuerySearchProducerTypes.Create(Self);

  Result := FQuerySearchProducerTypes;
end;

procedure TViewProducers.LoadFromExcel(const AFileName: String);
begin
  BeginUpdate;
  try
    TLoad.Create.LoadAndProcess(AFileName, TProducersExcelDM, TfrmImportError,
      procedure(ASender: TObject)
      begin
        ProducersGroup.LoadDataFromExcelTable(ASender as TProducersExcelTable);
      end,
      procedure(ASender: TObject)
      begin
        (ASender as TProducersExcelTable).ProducerInt :=
          ProducersGroup.qProducers;
      end);
  finally
    EndUpdate;
  end;

  UpdateView;
end;

procedure TViewProducers.Locate(const AProducer: string);
var
  List: TList<String>;
  ARow: TcxGridMasterDataRow;
  AView: TcxGridDBBandedTableView;
begin
  BeginUpdate;
  // Ищет производителя в гриде
  List := ProducersGroup.Find(clName2.DataBinding.FieldName, AProducer);
  try
    // сначала ищем на первом уровне (по названию категории)
    if (List.Count > 0) and
      (MainView.DataController.Search.Locate(clProducerType.Index, List[0],
      True)) then
    begin
      // Затем ищем на втором уровне (по наименованию производителя)
      if List.Count > 1 then
      begin
        ARow := GetRow(0) as TcxGridMasterDataRow;
        ARow.Expand(false);
        AView := GetDBBandedTableView(1);
        AView.Focused := True;
        AView.DataController.Search.Locate(clName2.Index, List[1], True);
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

procedure TViewProducers.MyInitializeComboBoxColumn;
begin
  // Ищем возможные значения типа производителя для выпадающего списка
  QuerySearchProducerTypes.RefreshQuery;

  // Инициализируем Combobox колонки
  InitializeComboBoxColumn(clProducerType, lsEditList,
    QuerySearchProducerTypes.ProducerType);
end;

procedure TViewProducers.SetProducersGroup(const Value: TProducersGroup2);
begin
  if FProducersGroup <> Value then
  begin
    FProducersGroup := Value;
    if FProducersGroup <> nil then
    begin
      MainView.DataController.DataSource :=
        FProducersGroup.qProducerTypes.DataSource;
      GridView(cxGridLevel2).DataController.DataSource :=
        FProducersGroup.qProducers.DataSource;

      TNotifyEventWrap.Create
        (FProducersGroup.qProducers.Monitor.OnHaveAnyChanges,
        DoOnHaveAnyChanges, FEventList);

      TNotifyEventWrap.Create(FProducersGroup.qProducerTypes.AfterOpen,
        DoOnHaveAnyChanges, FEventList);

      TNotifyEventWrap.Create(FProducersGroup.qProducers.AfterOpen,
        DoOnHaveAnyChanges, FEventList);

      InitializeLookupColumn(clProducerTypeID,
        FProducersGroup.qProducerTypes.DataSource, lsEditList,
        FProducersGroup.qProducerTypes.ProducerType.FieldName);

      MainView.ViewData.Collapse(True);
    end
    else
    begin
      MainView.DataController.DataSource := nil;
    end;

    PostMyApplyBestFitEventForView(cxGridDBBandedTableView2);

    UpdateView;
  end;
end;

procedure TViewProducers.UpdateTotalCount;
begin
  // Общее число компонентов на в БД
  StatusBar.Panels[StatusBar.Panels.Count - 1].Text :=
    Format('Всего: %d', [ProducersGroup.qProducers.FDQuery.RecordCount]);
end;

procedure TViewProducers.UpdateView;
var
  AView: TcxGridDBBandedTableView;
  OK: Boolean;
begin
  AView := FocusedTableView;
  OK := (ProducersGroup <> nil) and
    (ProducersGroup.qProducerTypes.FDQuery.Active) and
    (ProducersGroup.qProducers.FDQuery.Active);

  actAdd.Enabled := OK and (AView <> nil) and
    (MainView.DataController.RecordCount > 0);
  actAddType.Enabled := OK and (AView <> nil) and (AView.Level = cxGridLevel);

  // Удалять разрешаем только если что-то выделено
  actDeleteEx.Enabled := OK and (AView <> nil) and
    (AView.Controller.SelectedRowCount > 0);;

  actCommit.Enabled := OK and (ProducersGroup.HaveAnyChanges);

  actRollback.Enabled := actCommit.Enabled;

  actExportToExcelDocument.Enabled := OK and
    (ProducersGroup.qProducers.FDQuery.RecordCount > 0);

  UpdateTotalCount;
end;

end.
