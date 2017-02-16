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
  System.Generics.Collections, BaseComponentsGroupUnit;

const
  WM_OnApplyBestFit = WM_USER + 56;
  WM_ON_DETAIL_EXPANDED = WM_USER + 57;

type
  TViewComponentsParent = class(TfrmGrid)
    cxGridLevel2: TcxGridLevel;
    cxGridDBBandedTableView2: TcxGridDBBandedTableView;
    actDeleteFromAllCategories: TAction;
    actDelete: TAction;
    actAddComponent: TAction;
    actAddSubComponent: TAction;
    actCommit: TAction;
    actOpenDatasheet: TAction;
    actLoadDatasheet: TAction;
    actOpenImage: TAction;
    actLoadImage: TAction;
    actOpenDiagram: TAction;
    actLoadDiagram: TAction;
    actOpenDrawing: TAction;
    actLoadDrawing: TAction;
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
    procedure actAddComponentExecute(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure actDeleteFromAllCategoriesExecute(Sender: TObject);
    procedure actAddSubComponentExecute(Sender: TObject);
    procedure actCommitExecute(Sender: TObject);
    procedure actRollbackExecute(Sender: TObject);
    procedure actLoadDrawingExecute(Sender: TObject);
    procedure actLoadImageExecute(Sender: TObject);
    procedure actLoadDiagramExecute(Sender: TObject);
    procedure actLoadDatasheetExecute(Sender: TObject);
    procedure actOpenDrawingExecute(Sender: TObject);
    procedure actOpenImageExecute(Sender: TObject);
    procedure actOpenDiagramExecute(Sender: TObject);
    procedure actOpenDatasheetExecute(Sender: TObject);
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
    FBaseComponentsGroup: TBaseComponentsGroup;
    FEditingValue: Variant;
    FisCurrentlySyncing: Boolean;
    FOnDetailExpandedReceive: Boolean;
    FQuerySubGroups: TfrmQuerySubGroups;
    procedure AfterLoadData(Sender: TObject);
    procedure Delete(All: Boolean);
    function GetQuerySubGroups: TfrmQuerySubGroups;
    procedure SetBaseComponentsGroup(const Value: TBaseComponentsGroup);
    procedure SyncScrollbarPositions;
    procedure UpdateSelectedValues(AView: TcxGridDBBandedTableView);
    { Private declarations }
  protected
    procedure CreateColumnsBarButtons; override;
    procedure DoOnMasterDetailChange; virtual;
    function GetFocusedTableView: TcxGridDBBandedTableView; override;
    procedure OnApplyBestFit(var Message: TMessage); message WM_OnApplyBestFit;
    procedure OnDetailExpandedProcess(var Message: TMessage);
      message WM_ON_DETAIL_EXPANDED;
    procedure OpenDoc(ADocFieldInfo: TDocFieldInfo;
      const AErrorMessage, AEmptyErrorMessage: string);
    procedure UpdateDetailColumnsWidth;
    procedure UploadDoc(ADocFieldInfo: TDocFieldInfo);
    property QuerySubGroups: TfrmQuerySubGroups read GetQuerySubGroups;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AfterConstruction; override;
    procedure ApplyBestFitFocusedBand; override;
    procedure PostApplyBestFit;
    function CheckAndSaveChanges: Integer;
    function GetSelectedIDs: TList<Integer>;
    procedure UpdateView; override;
    property BaseComponentsGroup: TBaseComponentsGroup read FBaseComponentsGroup
        write SetBaseComponentsGroup;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses GridExtension, dxCore, System.Math, System.StrUtils, cxDataUtils,
  System.IOUtils, Winapi.ShellAPI, RepositoryDataModule, System.UITypes,
  ColumnsBarButtonsHelper, DialogUnit, SettingsController, OpenDocumentUnit,
  ProjectConst;

constructor TViewComponentsParent.Create(AOwner: TComponent);
var
  ACol: TcxGridDBBandedColumn;
  AColIndex: Integer;
  AView: TcxGridDBBandedTableView;
  i: Integer;
begin
  inherited;

  // Чтобы убрать значки своравчивания/разворачивания слева от грида
  // Создаём новое представление своего типа
  AView := cxGrid.CreateView(TcxGridDBBandedTableViewWithoutExpand)
    as TcxGridDBBandedTableView;

  // Копируем в новое представление все колонки
  AView.Assign(cxGridDBBandedTableView);

  // ACol := cxGridDBBandedTableView.GetColumnByFieldName('Producer');

  // После копирования создались новые колонки.
  // Но они почему-то не на своих местах
  for i := 0 to cxGridDBBandedTableView.ColumnCount - 1 do
  begin
    ACol := cxGridDBBandedTableView.Columns[i];
    AColIndex := IfThen(ACol.Position.ColIndex >= 0, ACol.Position.ColIndex,
      ACol.Index);
    AView.Columns[ACol.Index].Position.ColIndex := AColIndex;
  end;

  // Новое представление будет отображаться на первом уровне
  cxGridLevel.GridView := AView;

  cxGridPopupMenu.PopupMenus[0].GridView := AView;

  FOnDetailExpandedReceive := True;
end;

procedure TViewComponentsParent.actAddComponentExecute(Sender: TObject);
var
  AColumn: TcxGridDBBandedColumn;
  AView: TcxGridDBBandedTableView;
begin
  AView := GetDBBandedTableView(0);
  AView.Focused := True;

  AView.DataController.Append;

  AColumn := AView.GetColumnByFieldName('Value');
  // Site обеспечивает доступ к элементам размещённым на cxGrid
  AView.Site.SetFocus;
  // Показываем редактор для колонки
  AView.Controller.EditingController.ShowEdit(AColumn);

  UpdateView;
end;

procedure TViewComponentsParent.actDeleteExecute(Sender: TObject);
begin
  Delete(False);
end;

procedure TViewComponentsParent.actDeleteFromAllCategoriesExecute
  (Sender: TObject);
begin
  Delete(True);
end;

procedure TViewComponentsParent.actAddSubComponentExecute(Sender: TObject);
var
  AColumn: TcxGridDBBandedColumn;
  ARow: TcxMyGridMasterDataRow;
  AView: TcxGridDBBandedTableView;
begin
  // Сначала сохраняем родительский компонент
  BaseComponentsGroup.Main.TryPost;

  // начинаем транзакцию
  // if not BaseComponentsGroup.Connection.InTransaction then
  // BaseComponentsGroup.Connection.StartTransaction;

  ARow := GetRow(0) as TcxMyGridMasterDataRow;
  Assert(ARow <> nil);

  AView := GetDBBandedTableView(1);

  ARow.MyExpand(False);

  AView.Focused := True;

  // Сначала добавляем запись, потом разворачиваем
  AView.DataController.Append;

  AColumn := AView.GetColumnByFieldName('Value');
  // Site обеспечивает доступ к элементам размещённым на cxGrid
  AView.Site.SetFocus;
  // Показываем редактор для колонки
  AView.Controller.EditingController.ShowEdit(AColumn);
  UpdateView;
end;

procedure TViewComponentsParent.actCommitExecute(Sender: TObject);
begin
  cxGrid.BeginUpdate();
  try
    BaseComponentsGroup.Commit;
    // Почему-то при сохранении раскрываются детали
    MainView.ViewData.Collapse(True);
    // Переносим фокус на первую выделенную запись
    FocusSelectedRecord(MainView);
  finally
    cxGrid.EndUpdate;
  end;
  PutInTheCenterFocusedRecord(MainView);
  UpdateView;
end;

procedure TViewComponentsParent.actRollbackExecute(Sender: TObject);
begin
  cxGrid.BeginUpdate();
  try
    BaseComponentsGroup.Rollback;
  finally
    cxGrid.EndUpdate;
  end;

  UpdateView;
end;

procedure TViewComponentsParent.actLoadDrawingExecute(Sender: TObject);
begin
  UploadDoc(TDrawingDoc.Create);
end;

procedure TViewComponentsParent.actLoadImageExecute(Sender: TObject);
begin
  UploadDoc(TImageDoc.Create);
end;

procedure TViewComponentsParent.actLoadDiagramExecute(Sender: TObject);
begin
  UploadDoc(TDiagramDoc.Create);
end;

procedure TViewComponentsParent.actLoadDatasheetExecute(Sender: TObject);
begin
  UploadDoc(TDatasheetDoc.Create);
end;

procedure TViewComponentsParent.actOpenDrawingExecute(Sender: TObject);
begin
  OpenDoc(TDrawingDoc.Create, 'Файл чертежа с именем %s не найден',
    'Не задан чертёж');
end;

procedure TViewComponentsParent.actOpenImageExecute(Sender: TObject);
begin
  OpenDoc(TImageDoc.Create, 'Файл изображения с именем %s не найден',
    'Не задано изображение');
end;

procedure TViewComponentsParent.actOpenDiagramExecute(Sender: TObject);
begin
  OpenDoc(TDiagramDoc.Create, 'Файл схемы с именем %s не найден',
    'Не задана схема');
end;

procedure TViewComponentsParent.actOpenDatasheetExecute(Sender: TObject);
begin
  OpenDoc(TDatasheetDoc.Create, 'Файл спецификации с именем %s не найден',
    'не задана спецификация');
end;

procedure TViewComponentsParent.AfterConstruction;
begin
  inherited;
  // UpdateDetailColumnsWidth;
end;

procedure TViewComponentsParent.cxGridDBBandedTableViewDataControllerCompare
  (ADataController: TcxCustomDataController; ARecordIndex1, ARecordIndex2,
  AItemIndex: Integer; const V1, V2: Variant; var Compare: Integer);
begin
  inherited;
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
    Compare := Compare * (-1); // инвертировать порядок при необходимости
end;

procedure TViewComponentsParent.
  cxGridDBBandedTableViewDataControllerDetailExpanded(ADataController
  : TcxCustomDataController; ARecordIndex: Integer);
begin
  inherited;
  // Если предыдущее сообщение уже было обработано
  if FOnDetailExpandedReceive then
  begin
    FOnDetailExpandedReceive := False;
    PostMessage(Handle, WM_ON_DETAIL_EXPANDED, 0, 0);
  end;
end;

procedure TViewComponentsParent.AfterLoadData(Sender: TObject);
begin
  FisCurrentlySyncing := False;
  PostApplyBestFit;
  UpdateView;
end;

procedure TViewComponentsParent.ApplyBestFitFocusedBand;
begin
  inherited;
  UpdateDetailColumnsWidth;
end;

procedure TViewComponentsParent.PostApplyBestFit;
begin
  try
    if Visible and (Handle > 0) then
      PostMessage(Handle, WM_OnApplyBestFit, 0, 0);
  except
    ; // Что-то случается с Handle
  end;
end;

function TViewComponentsParent.CheckAndSaveChanges: Integer;
begin
  Result := 0;
  if BaseComponentsGroup = nil then
    Exit;

  // Если есть несохранённые изменения
  if BaseComponentsGroup.Main.HaveAnyChanges or
    BaseComponentsGroup.Detail.HaveAnyChanges then
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

  // В режиме просмотра - доступ только для чтения
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

  // В режиме редактирования - доступ в зависимости от состояния
  AReadOnly := (not VarIsNull(V)) and
    (not BaseComponentsGroup.Detail.IsModifed(V));

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

  HavDetails := True;
  V := ARecord.Values[0];
  if not VarIsNull(V) then
  begin
    AID := V;

    HavDetails := BaseComponentsGroup.QueryBaseComponents.Exists(AID);
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
  V := ARecord.Values[0];
  if not VarIsNull(V) then
  begin

    AID := V;

    HavDetails := BaseComponentsGroup.QueryBaseComponents.Exists(AID);

    // Только для чтения те записи, которые не модифицировались
    AReadOnly := not BaseComponentsGroup.Main.IsModifed(AID);
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

procedure TViewComponentsParent.CreateColumnsBarButtons;
begin
  FColumnsBarButtons := TColumnsBarButtonsEx.Create(Self,
    dxbrsbtmColumnsCustomization, MainView, cxGridDBBandedTableView2);
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
      // если уже был развёрнут - свернуть
      begin
        (FocusedRow as TcxMyGridMasterDataRow).MyCollapse(True);
      end
      else // иначе - развернуть
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
var
  AcxGridDBBandedColumn: TcxGridDBBandedColumn;
begin
  AcxGridDBBandedColumn := AItem as TcxGridDBBandedColumn;

  if (Key = 13) and (AcxGridDBBandedColumn.DataBinding.FieldName = clValue2.
    DataBinding.FieldName) then
    Sender.DataController.Post();
end;

procedure TViewComponentsParent.cxGridDBBandedTableViewBandSizeChanged
  (Sender: TcxGridBandedTableView; ABand: TcxGridBand);
begin
  // UpdateDetailBandsWidth;

  UpdateDetailColumnsWidth;
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
  UpdateDetailColumnsWidth;
end;

procedure TViewComponentsParent.cxGridDBBandedTableViewEditKeyDown
  (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
  AEdit: TcxCustomEdit; var Key: Word; Shift: TShiftState);
var
  AColumn: TcxGridDBBandedColumn;
begin
  AColumn := AItem as TcxGridDBBandedColumn;
  if (Key = 13) and
    (AColumn.DataBinding.FieldName = clValue.DataBinding.FieldName) then
  begin
    Sender.DataController.Post();
    UpdateView;
  end;
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

{ Удалить все выделенные записи }
procedure TViewComponentsParent.Delete(All: Boolean);
var
  AController: TcxGridBandedTableController;
  AcxGridMasterDataRow: TcxMyGridMasterDataRow;
  AFocusedView: TcxGridDBBandedTableView;
  i: Integer;
  S: string;
  X: Integer;
begin
  S := IfThen(All, sDoYouWantToDeleteComponentFromAll,
    sDoYouWantToDeleteComponent);

  if TDialog.Create.DeleteRecordsDialog(S) then
  begin
    AFocusedView := FocusedTableView;
    if AFocusedView <> nil then
    begin
      AController := AFocusedView.Controller;

      // если удалить всё
      if All then
      begin

        if AController.SelectedRowCount > 0 then
        begin
          for i := 0 to AController.SelectedRowCount - 1 do
          begin
            X := AController.SelectedRows[i].Values[clID.Index];
            BaseComponentsGroup.FullDeleted.Add(X);
          end;
        end
        else
        begin
          X := AController.FocusedRecord.Values[clID.Index];
          BaseComponentsGroup.FullDeleted.Add(X);
        end;
      end;

      BeginUpdate;
      try
        AController.DeleteSelection;
      finally
        EndUpdate
      end;

      // если удалили последнюю "дочернюю" запись
      if (AFocusedView.Level = cxGridLevel2) and
        (AFocusedView.DataController.RowCount = 0) then
      begin
        AcxGridMasterDataRow := AFocusedView.MasterGridRecord as
          TcxMyGridMasterDataRow;
        // Сворачиваем дочернее представление
        AcxGridMasterDataRow.MyCollapse(False);
      end;

      UpdateView;
    end;
  end;
end;

procedure TViewComponentsParent.DoOnMasterDetailChange;
begin
  if FBaseComponentsGroup <> nil then
  begin
    // Привязываем вью к данным
    MainView.DataController.DataSource :=
      BaseComponentsGroup.Main.DataSource;
    cxGridDBBandedTableView2.DataController.DataSource :=
      FBaseComponentsGroup.Detail.DataSource;

    // Подписываемся на события
    if FBaseComponentsGroup.Main.Master <> nil then
    begin
      // TNotifyEventWrap.Create(FBaseComponentsGroup.Main.Master.BeforeScrollI,
      // DoBeforeMasterScroll);
      TNotifyEventWrap.Create(FBaseComponentsGroup.Detail.AfterLoad,
        AfterLoadData);
    end;
  end;
  UpdateView;
  cxGridPopupMenu.PopupMenus.Items[0].GridView := MainView;
end;

function TViewComponentsParent.GetFocusedTableView: TcxGridDBBandedTableView;
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

function TViewComponentsParent.GetQuerySubGroups: TfrmQuerySubGroups;
begin
  if FQuerySubGroups = nil then
  begin
    FQuerySubGroups := TfrmQuerySubGroups.Create(Self);
    FQuerySubGroups.FDQuery.Connection :=
      BaseComponentsGroup.Main.FDQuery.Connection;
  end;
  Result := FQuerySubGroups;
end;

function TViewComponentsParent.GetSelectedIDs: TList<Integer>;
var
  AIDComponent: Integer;
  AView: TcxGridDBBandedTableView;
  i: Integer;
  V: Variant;
begin
  Result := TList<Integer>.Create;
  AView := FocusedTableView;
  if AView = nil then
    Exit;

  for i := 0 to AView.Controller.SelectedRowCount - 1 do
  begin
    V := AView.Controller.SelectedRows[i].Values[clID.Index];

    if VarIsNull(V) then
      Continue;

    AIDComponent := V;

    Result.Add(AIDComponent);
  end;

end;

procedure TViewComponentsParent.OnApplyBestFit(var Message: TMessage);
begin
  cxGrid.BeginUpdate();
  try
    MainView.ApplyBestFit();
  finally
    cxGrid.EndUpdate;
  end;
  UpdateDetailColumnsWidth;
end;

procedure TViewComponentsParent.OnDetailExpandedProcess(var Message: TMessage);
begin
  SyncScrollbarPositions;
  FOnDetailExpandedReceive := True;
end;

procedure TViewComponentsParent.OpenDoc(ADocFieldInfo: TDocFieldInfo;
  const AErrorMessage, AEmptyErrorMessage: string);
begin
  TDocument.Open(Handle, ADocFieldInfo.Folder,
    BaseComponentsGroup.Main.FDQuery.FieldByName(ADocFieldInfo.FieldName)
    .AsString, AErrorMessage, AEmptyErrorMessage, sBodyTypesFilesExt);
end;

procedure TViewComponentsParent.SetBaseComponentsGroup(const Value:
    TBaseComponentsGroup);
begin
  if FBaseComponentsGroup <> Value then
  begin
    FBaseComponentsGroup := Value;

    FEventList.Clear; // Отписываемся от старых событий

    DoOnMasterDetailChange;
  end;
end;

{ Синхронизировать положение скроллбаров }
procedure TViewComponentsParent.SyncScrollbarPositions;
var
  AcxGridDBBandedTableView: TcxGridDBBandedTableView;
  AcxGridMasterDataRow: TcxGridMasterDataRow;
  i, LeftPos: Integer;
  AView: TcxGridBandedTableView;
begin
  if FisCurrentlySyncing then
    Exit;
  try
    FisCurrentlySyncing := True;
    AView := MainView;
    LeftPos := AView.Controller.LeftPos;

    // cxGrid.BeginUpdate();
    try

      for i := 0 to AView.ViewData.RowCount - 1 do
      begin
        AcxGridMasterDataRow := GetRow(0, i) as TcxGridMasterDataRow;
        if AcxGridMasterDataRow.Expanded then
        begin
          AcxGridDBBandedTableView := AcxGridMasterDataRow.ActiveDetailGridView
            as TcxGridDBBandedTableView;
          AcxGridDBBandedTableView.Controller.LeftPos := LeftPos;
        end;
      end;
    finally
      // cxGrid.EndUpdate;
    end;
  finally
    FisCurrentlySyncing := False;
  end;
end;

procedure TViewComponentsParent.UpdateDetailColumnsWidth;
var
  ABand: TcxGridBand;
  ADetailColumn: TcxGridDBBandedColumn;
  AMainColumn: TcxGridDBBandedColumn;
  dx: Integer;
  i: Integer;
  RealBandWidth: Integer;
  RealColumnWidth: Integer;
begin
  cxGrid.BeginUpdate();
  try

    // Сначала выравниваем длину всех бэндов

    for i := 0 to cxGridDBBandedTableView2.Bands.Count - 1 do
    begin
      ABand := MainView.Bands[i];
      if ABand.VisibleIndex >= 0 then
      begin
        RealBandWidth := MainView.ViewInfo.HeaderViewInfo.BandsViewInfo.Items
          [ABand.VisibleIndex].Width;

        if ABand.VisibleIndex = 0 then
        begin
          dx := ABand.Width - RealBandWidth;
          Dec(RealBandWidth, MainView.ViewInfo.FirstItemAdditionalWidth - dx);
        end;

        cxGridDBBandedTableView2.Bands[i].Width := RealBandWidth;
      end;
    end;

    // Потом изменяем размеры всех дочерних колонок
    for i := 0 to cxGridDBBandedTableView2.ColumnCount - 1 do
    begin
      AMainColumn := MainView.Columns[i];
      ADetailColumn := cxGridDBBandedTableView2.Columns[i];

      // ADetailColumn.Width := AMainColumn.Width;
      if AMainColumn.VisibleIndex >= 0 then
      begin
        RealColumnWidth := MainView.ViewInfo.HeaderViewInfo.Items
          [AMainColumn.VisibleIndex].Width;

        if AMainColumn.VisibleIndex = 0 then
          Dec(RealColumnWidth, MainView.ViewInfo.FirstItemAdditionalWidth);

        ADetailColumn.Width := RealColumnWidth;
      end;
    end;

  finally
    cxGrid.EndUpdate;
  end;

  (*

    cxGrid.BeginUpdate();
    try
    for i := 0 to cxGridDBBandedTableView2.Bands.Count - 1 do
    begin
    cxGridDBBandedTableView2.Bands[i].Width := MainView.Bands[i].Width;
    end;

    for i := 0 to cxGridDBBandedTableView2.ColumnCount - 1 do
    // изменить размеры колонок у дочерней вью
    begin
    cxGridDBBandedTableView2.Columns[i].Width := MainView.Columns[i].Width;
    end;
    finally
    cxGrid.EndUpdate;
    end;

    (* *)
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
    // для каждой строки
    begin
      RowIndex := AView.Controller.SelectedRecords[i].Index;

      // Цикл по выделенным столбцам
      for J := 0 to AView.Controller.SelectedColumnCount - 1 do
      // для каждого столбца
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
  AFocusedView: TcxGridDBBandedTableView;
  Ok: Boolean;
  S: string;
begin
  Ok := BaseComponentsGroup <> nil;
  AFocusedView := FocusedTableView;

  // Удалить из всех категорий можно только родительский компонент
  actDeleteFromAllCategories.Enabled := Ok and (AFocusedView <> nil) and
    (AFocusedView.Level = cxGridLevel);
  actDeleteFromAllCategories.Visible := actDeleteFromAllCategories.Enabled;

  actDelete.Enabled := Ok and (AFocusedView <> nil) and
    (AFocusedView.DataController.RowCount > 0);

  if Ok and (AFocusedView <> nil) and (AFocusedView.Level = cxGridLevel) then
  begin
    if BaseComponentsGroup.Main.Master <> nil then
    begin
      S := BaseComponentsGroup.Main.Master.FDQuery.FieldByName
        ('Value').AsString;
      actDelete.Caption := Format('Удалить компонент из категории «%s»', [S]);
    end;
  end;

  if Ok and (AFocusedView <> nil) and (AFocusedView.Level = cxGridLevel2) then
  begin
    actDelete.Caption := 'Удалить дочерний компонент';
  end;

  actAddComponent.Enabled := Ok and (AFocusedView <> nil);
  actAddSubComponent.Enabled := Ok and (AFocusedView <> nil);
  // and (AFocusedView.Level = tlComponentsDetails);

  actCommit.Enabled := Ok and BaseComponentsGroup.Connection.
    InTransaction;
  actRollback.Enabled := actCommit.Enabled;
end;

procedure TViewComponentsParent.UploadDoc(ADocFieldInfo: TDocFieldInfo);
var
  S: String;
  sourceFileName: string;
begin
  S := BaseComponentsGroup.QueryBaseFamily.Field
    (ADocFieldInfo.FieldName).AsString;
  // Если файл документации ранее был уже задан
  if S <> '' then
  begin
    // Получаем полный путь до файла
    S := TPath.Combine(ADocFieldInfo.Folder, S);
    // Получаем папку в которой лежит ранее заданный файл документации
    S := TPath.GetDirectoryName(S);
    // если такого пути уже не существует
    if not TDirectory.Exists(S) then
      S := ADocFieldInfo.Folder;
  end
  else
    S := ADocFieldInfo.Folder;

  // Открываем диалог выбора файла для загрузки
  sourceFileName := TDialog.Create.OpenPictureDialog(S);
  if sourceFileName.IsEmpty then
    Exit;
  BaseComponentsGroup.LoadDocFile(sourceFileName, ADocFieldInfo);
  ApplyBestFitEx;
end;

end.
