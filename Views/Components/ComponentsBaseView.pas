unit ComponentsBaseView;

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
  cxButtonEdit, cxGridCustomPopupMenu, cxGridPopupMenu, Vcl.Menus,
  System.Generics.Collections, dxSkinsCore, dxSkinBlack,
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
  dxSkinXmas2008Blue, dxSkinscxPCPainter, dxSkinsdxBarPainter,
  CustomComponentsQuery, cxTextEdit, cxBlobEdit, cxRichEdit,
  DescriptionPopupForm, DocFieldInfo, OpenDocumentUnit, ProjectConst,
  cxDataControllerConditionalFormattingRulesManagerDialog, dxBarBuiltInMenu,
  System.Contnrs, BaseComponentsGroupUnit2, DSWrap;

const
  // WM_ON_DETAIL_EXPANDED = WM_USER + 57;
  WM_UPDATE_DETAIL_COLUMNS_WIDTH = WM_USER + 58;

type
  TColBtn = class(TObject)
  private
    FCol: TcxGridDBBandedColumn;
    FLoadAction: TAction;
    FOpenAction: TAction;
  public
    constructor Create(ACol: TcxGridDBBandedColumn;
      AOpenAction, ALoadAction: TAction);
    property Col: TcxGridDBBandedColumn read FCol;
    property LoadAction: TAction read FLoadAction;
    property OpenAction: TAction read FOpenAction;
  end;

  TColInfo = class(TObject)
  private
    FBandCaption: String;
    FBandIndex: Integer;
    FFieldWrap: TFieldWrap;
  public
    constructor Create(AFieldWrap: TFieldWrap; ABandIndex: Integer;
      ABandCaption: String = '');
    property BandCaption: String read FBandCaption;
    property BandIndex: Integer read FBandIndex;
    property FieldWrap: TFieldWrap read FFieldWrap;
  end;

  TViewComponentsBase = class(TfrmGrid)
    cxerlSubGroup: TcxEditRepositoryLabel;
    cxerpiSubGroup: TcxEditRepositoryPopupItem;
    actSettings: TAction;
    actPasteComponents: TAction;
    N3: TMenuItem;
    actPasteProducer: TAction;
    N4: TMenuItem;
    actPastePackagePins: TAction;
    N5: TMenuItem;
    actPasteFamily: TAction;
    N2: TMenuItem;
    actOpenDatasheet: TAction;
    actLoadDatasheet: TAction;
    actOpenDiagram: TAction;
    actLoadDiagram: TAction;
    actOpenImage: TAction;
    actLoadImage: TAction;
    actOpenDrawing: TAction;
    actLoadDrawing: TAction;
    cxGridLevel2: TcxGridLevel;
    cxGridDBBandedTableView2: TcxGridDBBandedTableView;
    actCommit: TAction;
    actRollback: TAction;
    cxertiValue: TcxEditRepositoryTextItem;
    cxertiValueRO: TcxEditRepositoryTextItem;
    cxFieldValueWithExpand: TcxEditRepositoryButtonItem;
    cxFieldValueWithExpandRO: TcxEditRepositoryButtonItem;
    actDeleteFromAllCategories: TAction;
    cxEditRepository1: TcxEditRepository;
    actAddFamily: TAction;
    actAddComponent: TAction;
    procedure actAddComponentExecute(Sender: TObject);
    procedure actAddFamilyExecute(Sender: TObject);
    procedure actCommitExecute(Sender: TObject);
    procedure actDeleteFromAllCategoriesExecute(Sender: TObject);
    procedure actLoadDatasheetExecute(Sender: TObject);
    procedure actLoadDiagramExecute(Sender: TObject);
    procedure actLoadDrawingExecute(Sender: TObject);
    procedure actLoadImageExecute(Sender: TObject);
    procedure actOpenDatasheetExecute(Sender: TObject);
    procedure actOpenDiagramExecute(Sender: TObject);
    procedure actOpenDrawingExecute(Sender: TObject);
    procedure actOpenImageExecute(Sender: TObject);
    procedure actPasteComponentsExecute(Sender: TObject);
    procedure actPastePackagePinsExecute(Sender: TObject);
    procedure actPasteFamilyExecute(Sender: TObject);
    procedure actPasteProducerExecute(Sender: TObject);
    procedure actRollbackExecute(Sender: TObject);
    procedure actSettingsExecute(Sender: TObject);
    procedure clSubGroup2GetProperties(Sender: TcxCustomGridTableItem;
      ARecord: TcxCustomGridRecord; var AProperties: TcxCustomEditProperties);
    procedure clSubGroupGetProperties(Sender: TcxCustomGridTableItem;
      ARecord: TcxCustomGridRecord; var AProperties: TcxCustomEditProperties);
    procedure cxerpiSubGroup_PropertiesCloseUp(Sender: TObject);
    procedure cxerpiSubGroup_PropertiesInitPopup(Sender: TObject);
    procedure clBodyIdPropertiesNewLookupDisplayText(Sender: TObject;
      const AText: TCaption);
    procedure clDatasheetGetDataText(Sender: TcxCustomGridTableItem;
      ARecordIndex: Integer; var AText: string);
    procedure cxGridDBBandedTableViewColumnHeaderClick(Sender: TcxGridTableView;
      AColumn: TcxGridColumn);
    procedure clDescriptionPropertiesInitPopup(Sender: TObject);
    procedure clValue2GetProperties(Sender: TcxCustomGridTableItem;
      ARecord: TcxCustomGridRecord; var AProperties: TcxCustomEditProperties);
    procedure clValue2GetPropertiesForEdit(Sender: TcxCustomGridTableItem;
      ARecord: TcxCustomGridRecord; var AProperties: TcxCustomEditProperties);
    procedure clValueGetProperties(Sender: TcxCustomGridTableItem;
      ARecord: TcxCustomGridRecord; var AProperties: TcxCustomEditProperties);
    procedure clValueGetPropertiesForEdit(Sender: TcxCustomGridTableItem;
      ARecord: TcxCustomGridRecord; var AProperties: TcxCustomEditProperties);
    procedure cxGridDBBandedTableViewSelectionChanged
      (Sender: TcxCustomGridTableView);
    procedure cxFieldValueWithExpandPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure cxGridDBBandedTableView2CellClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure cxGridDBBandedTableView2EditKeyDown
      (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
      AEdit: TcxCustomEdit; var Key: Word; Shift: TShiftState);
    procedure cxGridDBBandedTableView2LeftPosChanged(Sender: TObject);
    procedure cxGridDBBandedTableViewBandSizeChanged
      (Sender: TcxGridBandedTableView; ABand: TcxGridBand);
    procedure cxGridDBBandedTableViewCellClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure cxGridDBBandedTableViewColumnSizeChanged(Sender: TcxGridTableView;
      AColumn: TcxGridColumn);
    procedure cxGridDBBandedTableViewEditKeyUp(Sender: TcxCustomGridTableView;
      AItem: TcxCustomGridTableItem; AEdit: TcxCustomEdit; var Key: Word;
      Shift: TShiftState);
    procedure cxGridDBBandedTableViewEditValueChanged
      (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem);
    procedure cxGridDBBandedTableViewLeftPosChanged(Sender: TObject);
    procedure cxGridDBBandedTableViewDataControllerDetailExpanded
      (ADataController: TcxCustomDataController; ARecordIndex: Integer);
  private
    FBaseCompGrp: TBaseComponentsGroup2;
    FCountEvents: TObjectList;
    FDeleteFromAllCategories: Boolean;
    FEditingValue: Variant;
    FfrmDescriptionPopup: TfrmDescriptionPopup;
    FfrmSubgroupListPopup: TfrmSubgroupListPopup;
    FIsSyncScrollbars: Boolean;
    FMessageUpdateDetailColumnsPosted: Boolean;
    FNeedApplyBestFit: Boolean;
    FqSubGroups: TfrmQuerySubGroups;
    procedure DoAfterCommit(Sender: TObject);
    procedure DoOnDescriptionPopupHide(Sender: TObject);
    procedure DoOnUpdateComponentsCount(Sender: TObject);
    procedure DoOnUpdateFamilyCount(Sender: TObject);
    function GetclID: TcxGridDBBandedColumn;
    function GetclID2: TcxGridDBBandedColumn;
    function GetclValue: TcxGridDBBandedColumn;
    function GetclProducer: TcxGridDBBandedColumn;
    function GetclSubGroup: TcxGridDBBandedColumn;
    function GetclDescription: TcxGridDBBandedColumn;
    function GetclDatasheet: TcxGridDBBandedColumn;
    function GetclImage: TcxGridDBBandedColumn;
    function GetclDiagram: TcxGridDBBandedColumn;
    function GetclDrawing: TcxGridDBBandedColumn;
    function GetclPackagePins: TcxGridDBBandedColumn;
    function GetclValue2: TcxGridDBBandedColumn;
    function GetFocusedQuery: TQueryCustomComponents;
    function GetfrmSubgroupListPopup: TfrmSubgroupListPopup;
    function GetProducerDisplayText: string;
    function GetqSubGroups: TfrmQuerySubGroups;
    procedure SetBaseCompGrp(const Value: TBaseComponentsGroup2);
    procedure SyncScrollbarPositions;
    procedure UpdateSelectedCount;
    procedure UpdateSelectedValues(AView: TcxGridDBBandedTableView);
    procedure UpdateTotalComponentCount;
    { Private declarations }
  protected
    procedure CreateCountEvents;
    procedure ClearCountEvents;
    function CreateColInfoArray: TArray<TColInfo>; virtual;
    procedure CreateColumnsBarButtons; override;
    function CreateViewArr: TArray<TcxGridDBBandedTableView>; override;
    procedure Create_Columns;
    procedure DoAfterLoadData; virtual;
    procedure DoAfterOpenOrRefresh(Sender: TObject);
    procedure DoBeforeOpenOrRefresh(Sender: TObject);
    procedure DoOnHaveAnyChanges(Sender: TObject);
    procedure DoOnMasterDetailChange; virtual;
    procedure DoOnUpdateColumnsWidth(var Message: TMessage);
      message WM_UPDATE_DETAIL_COLUMNS_WIDTH;
    function ExpandDetail: TcxGridDBBandedTableView;
    procedure InitBands;
    procedure InitColumns; virtual;
    procedure InitView(AView: TcxGridDBBandedTableView); override;
    procedure InternalRefreshData; override;
    procedure MyDelete; override;
    procedure MyInitializeComboBoxColumn;
    procedure OnGridRecordCellPopupMenu(AColumn: TcxGridDBBandedColumn;
      var AllowPopup: Boolean); override;
    procedure OpenDoc(ADocFieldInfo: TDocFieldInfo);
    procedure PostMessageUpdateDetailColumnsWidth;
    procedure UpdateDetailColumnsWidth;
    procedure UploadDoc(ADocFieldInfo: TDocFieldInfo);
    property FocusedQuery: TQueryCustomComponents read GetFocusedQuery;
    property frmSubgroupListPopup: TfrmSubgroupListPopup
      read GetfrmSubgroupListPopup;
    property qSubGroups: TfrmQuerySubGroups read GetqSubGroups;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BeginUpdate; override;
    function CheckAndSaveChanges: Integer;
    procedure EndUpdate; override;
    procedure TryApplyBestFit;
    procedure UpdateView; override;
    property BaseCompGrp: TBaseComponentsGroup2 read FBaseCompGrp
      write SetBaseCompGrp;
    property clID: TcxGridDBBandedColumn read GetclID;
    property clID2: TcxGridDBBandedColumn read GetclID2;
    property clValue: TcxGridDBBandedColumn read GetclValue;
    property clProducer: TcxGridDBBandedColumn read GetclProducer;
    property clSubGroup: TcxGridDBBandedColumn read GetclSubGroup;
    property clDescription: TcxGridDBBandedColumn read GetclDescription;
    property clDatasheet: TcxGridDBBandedColumn read GetclDatasheet;
    property clImage: TcxGridDBBandedColumn read GetclImage;
    property clDiagram: TcxGridDBBandedColumn read GetclDiagram;
    property clDrawing: TcxGridDBBandedColumn read GetclDrawing;
    property clPackagePins: TcxGridDBBandedColumn read GetclPackagePins;
    property clValue2: TcxGridDBBandedColumn read GetclValue2;
    property ProducerDisplayText: string read GetProducerDisplayText;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses GridExtension, dxCore, System.Math, System.StrUtils, cxDataUtils,
  System.IOUtils, Winapi.ShellAPI, RepositoryDataModule, System.UITypes,
  ColumnsBarButtonsHelper, DialogUnit, Vcl.Clipbrd, PathSettingsForm,
  ClipboardUnit, DefaultParameters, ProducersQuery, cxGridDBDataDefinitions,
  GridSort;

constructor TViewComponentsBase.Create(AOwner: TComponent);
var
  AView: TcxGridDBBandedTableView;
begin
  inherited;
  // Форма с кодами категорий
  cxerpiSubGroup.Properties.PopupControl := frmSubgroupListPopup;

  FCountEvents := TObjectList.Create;

  StatusBarEmptyPanelIndex := 3;

  DeleteMessages.Add(cxGridLevel, sDoYouWantToDeleteFamily);
  DeleteMessages.Add(cxGridLevel2, sDoYouWantToDeleteComponent);
  ApplyBestFitForDetail := False;

  // Чтобы убрать значки своравчивания/разворачивания слева от записи грида
  // Создаём новое представление своего типа
  AView := cxGrid.CreateView(TcxGridDBBandedTableViewWithoutExpand)
    as TcxGridDBBandedTableView;

  // Копируем в новое представление все события
  AView.Assign(cxGridDBBandedTableView);

  // Новое представление будет отображаться на первом уровне
  cxGridLevel.GridView := AView;

  cxGridDBBandedTableView.Free;
end;

destructor TViewComponentsBase.Destroy;
begin
  FreeAndNil(FCountEvents);
  inherited;
end;

procedure TViewComponentsBase.actAddComponentExecute(Sender: TObject);
var
  AView: TcxGridDBBandedTableView;
begin
  // Сначала сохраняем семейство компонентов
  BaseCompGrp.qBaseFamily.W.TryPost;

  // Разворачиваем представление 2-го уровня
  AView := ExpandDetail;

  // Сначала добавляем запись, потом разворачиваем
  AView.DataController.Append;

  FocusColumnEditor(AView, BaseCompGrp.qBaseComponents.W.Value.FieldName);

  UpdateView;
end;

procedure TViewComponentsBase.actAddFamilyExecute(Sender: TObject);
var
  AView: TcxGridDBBandedTableView;
begin
  AView := GetDBBandedTableView(0);
  AView.Focused := True;

  AView.DataController.Append;

  FocusColumnEditor(AView, BaseCompGrp.qBaseFamily.W.Value.FieldName);

  UpdateView;
end;

procedure TViewComponentsBase.actCommitExecute(Sender: TObject);
begin
  inherited;
  BaseCompGrp.Commit;
  UpdateView;
end;

procedure TViewComponentsBase.actDeleteFromAllCategoriesExecute
  (Sender: TObject);
begin
  inherited;
  FDeleteFromAllCategories := True;
  try
    MyDelete;
  finally
    FDeleteFromAllCategories := False;
  end;
end;

procedure TViewComponentsBase.actLoadDatasheetExecute(Sender: TObject);
begin
  UploadDoc(TComponentDatasheetDoc.Create);
end;

procedure TViewComponentsBase.actLoadDiagramExecute(Sender: TObject);
begin
  UploadDoc(TComponentDiagramDoc.Create);
end;

procedure TViewComponentsBase.actLoadDrawingExecute(Sender: TObject);
begin
  UploadDoc(TComponentDrawingDoc.Create);
end;

procedure TViewComponentsBase.actLoadImageExecute(Sender: TObject);
begin
  UploadDoc(TComponentImageDoc.Create);
end;

procedure TViewComponentsBase.actOpenDatasheetExecute(Sender: TObject);
begin
  OpenDoc(TComponentDatasheetDoc.Create);
end;

procedure TViewComponentsBase.actOpenDiagramExecute(Sender: TObject);
begin
  OpenDoc(TComponentDiagramDoc.Create);
end;

procedure TViewComponentsBase.actOpenDrawingExecute(Sender: TObject);
begin
  OpenDoc(TComponentDrawingDoc.Create);
end;

procedure TViewComponentsBase.actOpenImageExecute(Sender: TObject);
begin
  OpenDoc(TComponentImageDoc.Create);
end;

procedure TViewComponentsBase.actPasteComponentsExecute(Sender: TObject);
var
  // AColumn: TcxGridDBBandedColumn;
  ARow: TcxMyGridMasterDataRow;
  AView: TcxGridDBBandedTableView;
  m: TArray<String>;
begin
  m := TClb.Create.GetRowsAsArray;
  if Length(m) = 0 then
    Exit;

  // Сначала сохраняем семейство компонентов
  BaseCompGrp.qBaseFamily.W.TryPost;

  ARow := GetRow(0) as TcxMyGridMasterDataRow;
  Assert(ARow <> nil);

  AView := GetDBBandedTableView(1);

  ARow.MyExpand(False);

  AView.Focused := True;

  // Просим добавить дочерние компоненты
  BaseCompGrp.qBaseComponents.W.AppendRows
    (BaseCompGrp.qBaseComponents.W.Value.FieldName, m);

  UpdateView;

end;

procedure TViewComponentsBase.actPastePackagePinsExecute(Sender: TObject);
var
  AID: Integer;
  AIDList: TArray<Integer>;
  m: TArray<String>;
begin
  m := TClb.Create.GetRowsAsArray;
  if (Length(m) = 0) or (GetFocusedQuery = nil) then
    Exit;

  AIDList := GetSelectedIntValues(FocusedTableView, clID.Index);

  for AID in AIDList do
    GetFocusedQuery.W.SetPackagePins(AID, m[0]);

  UpdateView;
end;

procedure TViewComponentsBase.actPasteFamilyExecute(Sender: TObject);
var
  m: TArray<String>;
begin
  m := TClb.Create.GetRowsAsArray;
  if Length(m) = 0 then
    Exit;

  // Просим добавить родительские компоненты
  BaseCompGrp.qBaseFamily.W.AppendRows
    (BaseCompGrp.qBaseFamily.W.Value.FieldName, m);

  PutInTheCenterFocusedRecord(MainView);

  UpdateView;
end;

procedure TViewComponentsBase.actPasteProducerExecute(Sender: TObject);
var
  AID: Integer;
  AIDList: TArray<Integer>;
  AProducer: string;
  m: TArray<String>;
begin
  m := TClb.Create.GetRowsAsArray;
  if (Length(m) = 0) or (GetFocusedQuery = nil) then
    Exit;

  AProducer := m[0].Trim;

  Assert(BaseCompGrp.Producers <> nil);
  Assert(BaseCompGrp.Producers.FDQuery.Active);

  // Вставлять можно только то, что есть в справочнике
  if not BaseCompGrp.Producers.Locate(AProducer) then
  begin
    TDialog.Create.ProducerNotFound(AProducer);
    Exit;
  end;

  Assert(clID.Index = clID2.Index);
  AIDList := GetSelectedIntValues(FocusedTableView, clID.Index);

  BeginUpdate;
  try
    for AID in AIDList do
      GetFocusedQuery.W.SetProducer(AID, AProducer);
  finally
    EndUpdate;
  end;

  UpdateView;
end;

procedure TViewComponentsBase.actRollbackExecute(Sender: TObject);
begin
  inherited;
  BeginUpdate();
  try
    BaseCompGrp.Rollback;
  finally
    EndUpdate;
  end;

  UpdateView;
end;

procedure TViewComponentsBase.actSettingsExecute(Sender: TObject);
var
  frmPathSettings: TfrmPathSettings;
begin
  frmPathSettings := TfrmPathSettings.Create(Self);
  try
    frmPathSettings.cxPageControl.ActivePage := frmPathSettings.cxtshComponents;
    frmPathSettings.ShowModal;
  finally
    FreeAndNil(frmPathSettings);
  end;
end;

procedure TViewComponentsBase.BeginUpdate;
begin
  // Отписываемся от событий о смене кол-ва
  if UpdateCount = 0 then
    ClearCountEvents;

  inherited;
end;

function TViewComponentsBase.CheckAndSaveChanges: Integer;
begin
  Result := 0;
  if FBaseCompGrp = nil then
    Exit;

  UpdateView;

  // Если есть несохранённые изменения
  if BaseCompGrp.HaveAnyChanges then
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

procedure TViewComponentsBase.clBodyIdPropertiesNewLookupDisplayText
  (Sender: TObject; const AText: TCaption);
begin
  inherited;
  // DM.BodyTypesMasterDetail.qBodyTypes2.AddNewValue(AText);
end;

procedure TViewComponentsBase.clDatasheetGetDataText
  (Sender: TcxCustomGridTableItem; ARecordIndex: Integer; var AText: string);
begin
  inherited;
  if not AText.IsEmpty then
    AText := TPath.GetFileNameWithoutExtension(AText);
end;

procedure TViewComponentsBase.clDescriptionPropertiesInitPopup(Sender: TObject);
begin
  inherited;
  Assert(FfrmDescriptionPopup <> nil);
  // Привязываем выпадающую форму к данным
  FfrmDescriptionPopup.DescriptionW := BaseCompGrp.qBaseFamily.W;
end;

procedure TViewComponentsBase.clSubGroup2GetProperties
  (Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
  var AProperties: TcxCustomEditProperties);
begin
  AProperties := cxerlSubGroup.Properties;
end;

procedure TViewComponentsBase.clSubGroupGetProperties
  (Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
  var AProperties: TcxCustomEditProperties);
begin
  if ARecord = nil then
    Exit;

  AProperties := cxerpiSubGroup.Properties;
end;

procedure TViewComponentsBase.CreateCountEvents;
begin
  // Подписываемся на события чтобы отслеживать кол-во

  Assert(FCountEvents.Count = 0);

  TNotifyEventWrap.Create(BaseCompGrp.qBaseFamily.W.AfterPostM,
    DoOnUpdateFamilyCount, FCountEvents);

  TNotifyEventWrap.Create(BaseCompGrp.qBaseFamily.W.AfterOpen,
    DoOnUpdateFamilyCount, FCountEvents);

  TNotifyEventWrap.Create(BaseCompGrp.qBaseFamily.W.AfterDelete,
    DoOnUpdateFamilyCount, FCountEvents);

  TNotifyEventWrap.Create(BaseCompGrp.qBaseComponents.W.AfterPostM,
    DoOnUpdateComponentsCount, FCountEvents);

  TNotifyEventWrap.Create(BaseCompGrp.qBaseComponents.W.AfterOpen,
    DoOnUpdateComponentsCount, FEventList);

  TNotifyEventWrap.Create(BaseCompGrp.qBaseComponents.W.AfterDelete,
    DoOnUpdateComponentsCount, FCountEvents);

  DoOnUpdateComponentsCount(nil);
  DoOnUpdateFamilyCount(nil);
  UpdateTotalComponentCount;
end;

procedure TViewComponentsBase.ClearCountEvents;
begin
  // Отписываемся от событий чтобы отслеживать кол-во
  FCountEvents.Clear;
end;

procedure TViewComponentsBase.clValue2GetProperties
  (Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
  var AProperties: TcxCustomEditProperties);
begin
  if ARecord = nil then
    Exit;

  // В режиме просмотра - доступ только для чтения
  AProperties := cxertiValueRO.Properties
end;

procedure TViewComponentsBase.clValue2GetPropertiesForEdit
  (Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
  var AProperties: TcxCustomEditProperties);
var
  AReadOnly: Boolean;
  V: Variant;
begin
  if ARecord = nil then
    Exit;

  V := ARecord.Values[clID2.Index];

  // В режиме редактирования - доступ в зависимости от состояния
  AReadOnly := (not VarIsNull(V)) and
    (not BaseCompGrp.qBaseComponents.W.IsRecordModifed(V));

  if AReadOnly then
    AProperties := cxertiValueRO.Properties
  else
    AProperties := cxertiValue.Properties
end;

procedure TViewComponentsBase.clValueGetProperties
  (Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
  var AProperties: TcxCustomEditProperties);
var
  AID: Integer;
  HavDetails: Boolean;
  V: Variant;
begin
  if ARecord = nil then
    Exit;

  HavDetails := False;
  if BaseCompGrp <> nil then
  begin
    V := ARecord.Values[clID.Index];
    if not VarIsNull(V) then
    begin
      AID := V;
      HavDetails := BaseCompGrp.qBaseComponents.Exists(AID);
    end;
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

procedure TViewComponentsBase.clValueGetPropertiesForEdit
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

  // Получаем значение первичного ключа
  V := ARecord.Values[clID.Index];
  if not VarIsNull(V) then
  begin
    AID := V;
    // Смотрим, есть ли у семейства компоненты
    HavDetails := BaseCompGrp.qBaseComponents.Exists(AID);

    // Только для чтения те записи, которые не модифицировались
    AReadOnly := not BaseCompGrp.qBaseFamily.W.IsRecordModifed(AID);
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

function TViewComponentsBase.CreateColInfoArray: TArray<TColInfo>;
Var
  W: TCustomComponentsW;
begin
  W := BaseCompGrp.qBaseFamily.W;
  Result := [TColInfo.Create(W.ID, 0), TColInfo.Create(W.Value, 0),
    TColInfo.Create(W.Producer, 1), TColInfo.Create(W.SubGroup, 1),
    TColInfo.Create(W.DescriptionComponentName, 1), TColInfo.Create(W.Datasheet,
    1), TColInfo.Create(W.Diagram, 1), TColInfo.Create(W.Drawing, 1),
    TColInfo.Create(W.Image, 1), TColInfo.Create(W.PackagePins, 1)]
end;

procedure TViewComponentsBase.CreateColumnsBarButtons;
begin
  // Меню будем создавать только после создания всех колонок
end;

function TViewComponentsBase.CreateViewArr: TArray<TcxGridDBBandedTableView>;
begin
  Result := [MainView, cxGridDBBandedTableView2];
end;

procedure TViewComponentsBase.Create_Columns;
var
  // ABand: TcxGridBand;
  ACol: TcxGridDBBandedColumn;
  AColInfo: TColInfo;
  Arr: TArray<TColInfo>;
  AView: TcxGridDBBandedTableView;
begin
  if (MainView.ColumnCount > 1) then
    Exit;

  Arr := CreateColInfoArray;

  for AColInfo in Arr do
  begin
    for AView in ViewArr do
    begin
      ACol := AView.CreateColumn;
      ACol.Visible := AColInfo.FieldWrap.DisplayLabel <> '';
      ACol.VisibleForCustomization := ACol.Visible;
      ACol.Caption := AColInfo.FieldWrap.DisplayLabel;
      ACol.DataBinding.FieldName := AColInfo.FieldWrap.FieldName;

      // Если такого бэнда не существует
      while AView.Bands.Count <= AColInfo.BandIndex do
        { ABand := } AView.Bands.Add;

      if AColInfo.BandCaption <> '' then
        AView.Bands[AColInfo.BandIndex].Caption := AColInfo.BandCaption;

      ACol.Position.BandIndex := AColInfo.BandIndex;
    end;
  end;

  InitColumns;
  InitBands;
end;

procedure TViewComponentsBase.cxerpiSubGroup_PropertiesCloseUp(Sender: TObject);
var
  ParamValue: string;
begin
  Assert(qSubGroups.FDQuery.Active);
  ParamValue := qSubGroups.W.ExternalID.AllValues(',');

  if BaseCompGrp.qBaseFamily.W.SubGroup.F.AsString = ParamValue then
    Exit;

  BaseCompGrp.qBaseFamily.FDQuery.DisableControls;
  try
    BaseCompGrp.qBaseFamily.W.TryEdit;
    BaseCompGrp.qBaseFamily.W.SubGroup.F.AsString := ParamValue;
    BaseCompGrp.qBaseFamily.W.TryPost;
  finally
    BaseCompGrp.qBaseFamily.FDQuery.EnableControls;
  end;

  UpdateView;
end;

procedure TViewComponentsBase.cxerpiSubGroup_PropertiesInitPopup
  (Sender: TObject);
var
  AMainExternalID: string;
  S: string;
begin
  S := BaseCompGrp.qBaseFamily.W.SubGroup.F.AsString;

  // Удаляем все пробелы из строки. Должны остаться только цифры и запятые
  S := S.Replace(' ', '', [rfReplaceAll]);

  Assert(S.Length > 0);
  AMainExternalID := BaseCompGrp.qBaseFamily.CategoryExternalID;

  qSubGroups.Search(AMainExternalID, Format(',%s,', [S]));
  frmSubgroupListPopup.QuerySubGroups := qSubGroups;
end;

procedure TViewComponentsBase.cxFieldValueWithExpandPropertiesButtonClick
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

procedure TViewComponentsBase.cxGridDBBandedTableView2CellClick
  (Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
  AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  inherited;
  UpdateDetailColumnsWidth;
end;

procedure TViewComponentsBase.cxGridDBBandedTableView2EditKeyDown
  (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
  AEdit: TcxCustomEdit; var Key: Word; Shift: TShiftState);
begin
  inherited;
  DoOnEditKeyDown(Sender, AItem, AEdit, Key, Shift);
end;

procedure TViewComponentsBase.cxGridDBBandedTableView2LeftPosChanged
  (Sender: TObject);
begin
  inherited;
  SyncScrollbarPositions;
end;

procedure TViewComponentsBase.cxGridDBBandedTableViewBandSizeChanged
  (Sender: TcxGridBandedTableView; ABand: TcxGridBand);
begin
  inherited;
  PostMessageUpdateDetailColumnsWidth;
end;

procedure TViewComponentsBase.cxGridDBBandedTableViewCellClick
  (Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
  AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  inherited;
  UpdateDetailColumnsWidth;
end;

procedure TViewComponentsBase.cxGridDBBandedTableViewColumnHeaderClick
  (Sender: TcxGridTableView; AColumn: TcxGridColumn);
begin
  inherited;
  ApplySort(Sender, AColumn);
end;

procedure TViewComponentsBase.cxGridDBBandedTableViewColumnSizeChanged
  (Sender: TcxGridTableView; AColumn: TcxGridColumn);
begin
  inherited;
  PostMessageUpdateDetailColumnsWidth;
end;

procedure TViewComponentsBase.
  cxGridDBBandedTableViewDataControllerDetailExpanded(ADataController
  : TcxCustomDataController; ARecordIndex: Integer);
begin
  inherited;
  UpdateDetailColumnsWidth;
end;

procedure TViewComponentsBase.cxGridDBBandedTableViewEditKeyUp
  (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
  AEdit: TcxCustomEdit; var Key: Word; Shift: TShiftState);
begin
  inherited;
  FEditingValue := AEdit.EditingValue;
end;

procedure TViewComponentsBase.cxGridDBBandedTableViewEditValueChanged
  (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem);
var
  AView: TcxGridDBBandedTableView;
begin
  inherited;
  AView := Sender as TcxGridDBBandedTableView;

  if AView.Controller.SelectedRecordCount <= 1 then
    Exit;

  if AView.DataController.DataSet.State <> dsEdit then
    Exit;

  // Это для того чтобы редактируемое в ячейке значение распространить на несколько выделенных записей
  UpdateSelectedValues(AView);
end;

procedure TViewComponentsBase.cxGridDBBandedTableViewLeftPosChanged
  (Sender: TObject);
begin
  inherited;
  SyncScrollbarPositions;
end;

procedure TViewComponentsBase.cxGridDBBandedTableViewSelectionChanged
  (Sender: TcxCustomGridTableView);
begin
  inherited;
  UpdateSelectedCount;
end;

procedure TViewComponentsBase.DoAfterCommit(Sender: TObject);
begin
  // Инициализируем выпадающие столбцы
  MyInitializeComboBoxColumn;
end;

procedure TViewComponentsBase.DoAfterLoadData;
begin
  PostMyApplyBestFitEvent;
  UpdateView;
end;

procedure TViewComponentsBase.DoAfterOpenOrRefresh(Sender: TObject);
begin
  EndUpdate;
  FIsSyncScrollbars := False;
  DoAfterLoadData;
  FNeedApplyBestFit := True;
end;

procedure TViewComponentsBase.DoBeforeOpenOrRefresh(Sender: TObject);
begin
  BeginUpdate;
end;

procedure TViewComponentsBase.DoOnDescriptionPopupHide(Sender: TObject);
begin
  UpdateView;
end;

procedure TViewComponentsBase.DoOnHaveAnyChanges(Sender: TObject);
begin
  UpdateView;
end;

procedure TViewComponentsBase.DoOnMasterDetailChange;
begin
  FNeedApplyBestFit := FBaseCompGrp <> nil;
  if FBaseCompGrp <> nil then
  begin
    // Привязываем представление к данным
    with MainView do
    begin
      DataController.DataSource := BaseCompGrp.qBaseFamily.W.DataSource;
      // DataController.CreateAllItems();

      OptionsView.ColumnAutoWidth := False;
    end;

    with cxGridDBBandedTableView2.DataController do
    begin
      DataSource := FBaseCompGrp.qBaseComponents.W.DataSource;
      KeyFieldNames := FBaseCompGrp.qBaseComponents.W.ID.FieldName;
      MasterKeyFieldNames := FBaseCompGrp.qBaseFamily.W.ID.FieldName;
      DetailKeyFieldNames := FBaseCompGrp.qBaseComponents.W.
        ParentProductID.FieldName;
    end;

    with cxGridDBBandedTableView2 do
    begin
      // DataController.CreateAllItems();
      OptionsBehavior.CopyCaptionsToClipboard := False;
      OptionsSelection.MultiSelect := True;
      OptionsSelection.CellMultiSelect := True;
      OptionsSelection.InvertSelect := False;
      OptionsView.ColumnAutoWidth := False;
      OptionsView.ScrollBars := TScrollStyle.ssVertical;
      OptionsView.GroupByBox := False;
      OptionsView.Header := False;
      OptionsView.BandHeaders := False;
    end;

    // Подписываемся на события
    if FBaseCompGrp.qBaseComponents.Master <> nil then
    begin
      // Компоненты у нас загружаются первыми
      TNotifyEventWrap.Create(FBaseCompGrp.qBaseComponents.W.BeforeOpen,
        DoBeforeOpenOrRefresh, FEventList);

      // Компоненты у нас загружаются первыми
      TNotifyEventWrap.Create(FBaseCompGrp.qBaseComponents.W.BeforeRefresh,
        DoBeforeOpenOrRefresh, FEventList);

      // Семейства у нас загружаются последними !!!
      TNotifyEventWrap.Create(FBaseCompGrp.qBaseFamily.W.AfterRefresh,
        DoAfterOpenOrRefresh, FEventList);

      // Семейства у нас загружаются последними !!!
      TNotifyEventWrap.Create(FBaseCompGrp.qBaseFamily.W.AfterOpen,
        DoAfterOpenOrRefresh, FEventList);

    end;

    Create_Columns;

    // Пусть нам монитор сообщает об изменениях в БД
    TNotifyEventWrap.Create
      (FBaseCompGrp.qBaseComponents.Monitor.OnHaveAnyChanges,
      DoOnHaveAnyChanges, FEventList);

    // Подписываемся на событие о коммите
    TNotifyEventWrap.Create(DMRepository.AfterCommit, DoAfterCommit,
      FEventList);
    MyInitializeComboBoxColumn;

    if GridSort.Count = 0 then
    begin
      // Настраиваем сортировку
      GridSort.Add(TSortVariant.Create(clValue, [clValue]));
      GridSort.Add(TSortVariant.Create(clProducer, [clProducer, clValue]));

      // Применяем сортировку по производителю
      ApplySort(MainView, clValue);
    end;

    // Подписываемся на сообщения об изменении кол-ва
    if UpdateCount = 0 then
      CreateCountEvents;

    // После того, как колоки созданы - создаём соответствующие пункты в меню
    FColumnsBarButtons := TGVColumnsBarButtonsEx.Create(Self, dxbsColumns,
      MainView, cxGridDBBandedTableView2);
  end;

  UpdateView;
  cxGridPopupMenu.PopupMenus.Items[0].GridView := MainView;
end;

procedure TViewComponentsBase.DoOnUpdateColumnsWidth(var Message: TMessage);
begin
  try
    UpdateDetailColumnsWidth;
  finally
    FMessageUpdateDetailColumnsPosted := False;
  end;
end;

procedure TViewComponentsBase.DoOnUpdateComponentsCount(Sender: TObject);
begin
  // Выводим кол-во компонентов
  StatusBar.Panels[1].Text :=
    Format('%d', [BaseCompGrp.qBaseComponents.FDQuery.RecordCount]);
end;

procedure TViewComponentsBase.DoOnUpdateFamilyCount(Sender: TObject);
begin
  Assert(BaseCompGrp <> nil);
  (*
    // Событие может прийти позже, после того как набор данных будет разрушен
    if BaseCompGrp = nil then
    begin
    beep;
    Exit;
    end;
  *)

  if BaseCompGrp.qBaseFamily.FDQuery.State = dsBrowse then
  begin
    // Выводим кол-во родительских наименований
    StatusBar.Panels[0].Text :=
      Format('%d', [BaseCompGrp.qBaseFamily.FDQuery.RecordCount]);

    UpdateTotalComponentCount;
  end;
end;

procedure TViewComponentsBase.EndUpdate;
begin
  inherited;
  if UpdateCount = 0 then
    CreateCountEvents;
end;

function TViewComponentsBase.ExpandDetail: TcxGridDBBandedTableView;
var
  ARow: TcxMyGridMasterDataRow;
begin
  ARow := MainView.Controller.FocusedRow as TcxMyGridMasterDataRow;
  Assert(ARow <> nil);

  Result := ARow.ActiveDetailGridView as TcxGridDBBandedTableView;

  ARow.MyExpand(False);
  Result.Focused := True;
end;

function TViewComponentsBase.GetclID: TcxGridDBBandedColumn;
begin
  Result := MainView.GetColumnByFieldName
    (FBaseCompGrp.qBaseFamily.W.ID.FieldName);
end;

function TViewComponentsBase.GetclID2: TcxGridDBBandedColumn;
begin
  Result := cxGridDBBandedTableView2.GetColumnByFieldName
    (FBaseCompGrp.qBaseComponents.W.ID.FieldName);
end;

function TViewComponentsBase.GetclValue: TcxGridDBBandedColumn;
begin
  Result := MainView.GetColumnByFieldName
    (FBaseCompGrp.qBaseFamily.W.Value.FieldName);
end;

function TViewComponentsBase.GetclProducer: TcxGridDBBandedColumn;
begin
  Result := MainView.GetColumnByFieldName
    (FBaseCompGrp.qBaseFamily.W.Producer.FieldName);
end;

function TViewComponentsBase.GetclSubGroup: TcxGridDBBandedColumn;
begin
  Result := MainView.GetColumnByFieldName
    (FBaseCompGrp.qBaseFamily.W.SubGroup.FieldName);
end;

function TViewComponentsBase.GetclDescription: TcxGridDBBandedColumn;
begin
  Result := MainView.GetColumnByFieldName
    (FBaseCompGrp.qBaseFamily.W.DescriptionComponentName.FieldName);
end;

function TViewComponentsBase.GetclDatasheet: TcxGridDBBandedColumn;
begin
  Result := MainView.GetColumnByFieldName
    (FBaseCompGrp.qBaseFamily.W.Datasheet.FieldName);
end;

function TViewComponentsBase.GetclImage: TcxGridDBBandedColumn;
begin
  Result := MainView.GetColumnByFieldName
    (FBaseCompGrp.qBaseFamily.W.Image.FieldName);
end;

function TViewComponentsBase.GetclDiagram: TcxGridDBBandedColumn;
begin
  Result := MainView.GetColumnByFieldName
    (FBaseCompGrp.qBaseFamily.W.Diagram.FieldName);
end;

function TViewComponentsBase.GetclDrawing: TcxGridDBBandedColumn;
begin
  Result := MainView.GetColumnByFieldName
    (FBaseCompGrp.qBaseFamily.W.Drawing.FieldName);
end;

function TViewComponentsBase.GetclPackagePins: TcxGridDBBandedColumn;
begin
  Result := MainView.GetColumnByFieldName
    (FBaseCompGrp.qBaseFamily.W.PackagePins.FieldName);
end;

function TViewComponentsBase.GetclValue2: TcxGridDBBandedColumn;
begin
  Result := cxGridDBBandedTableView2.GetColumnByFieldName
    (FBaseCompGrp.qBaseComponents.W.Value.FieldName);
end;

function TViewComponentsBase.GetFocusedQuery: TQueryCustomComponents;
var
  AView: TcxGridDBBandedTableView;
begin
  Result := nil;
  AView := GetFocusedTableView;
  if AView <> nil then
  begin
    if AView.Level = cxGridLevel then
      Result := BaseCompGrp.qBaseFamily;
    if AView.Level = cxGridLevel2 then
      Result := BaseCompGrp.qBaseComponents;
  end;
end;

function TViewComponentsBase.GetfrmSubgroupListPopup: TfrmSubgroupListPopup;
begin
  if FfrmSubgroupListPopup = nil then
    FfrmSubgroupListPopup := TfrmSubgroupListPopup.Create(Self);

  Result := FfrmSubgroupListPopup;
end;

function TViewComponentsBase.GetProducerDisplayText: string;
var
  AColumn: TcxGridDBBandedColumn;
  AView: TcxGridDBBandedTableView;
begin
  Result := '';
  AView := FocusedTableView;
  if AView = nil then
    Exit;

  AColumn := AView.GetColumnByFieldName(FocusedQuery.W.Producer.FieldName);
  Assert(AColumn <> nil);

  Result := AView.Controller.FocusedRecord.DisplayTexts[AColumn.Index];
end;

function TViewComponentsBase.GetqSubGroups: TfrmQuerySubGroups;
begin
  if FqSubGroups = nil then
  begin
    FqSubGroups := TfrmQuerySubGroups.Create(Self);
    FqSubGroups.FDQuery.Connection := BaseCompGrp.Connection;
  end;
  Result := FqSubGroups;
end;

procedure TViewComponentsBase.InitBands;
var
  ABand: TcxGridBand;
  AView: TcxGridDBBandedTableView;
  i: Integer;
begin
  Assert(Length(ViewArr) > 0);

  for AView in ViewArr do
  begin
    for i := 0 to AView.Bands.Count - 1 do
    begin
      ABand := AView.Bands[i];
      with ABand do
      begin
        Options.HoldOwnColumnsOnly := True;
        Options.Moving := False;
      end;
    end;
    AView.Bands[0].FixedKind := fkLeft;
  end;
end;

procedure TViewComponentsBase.InitColumns;
var
  ACol: TcxGridDBBandedColumn;
  AColBtn: TColBtn;
  AcxButtonEditProperties: TcxButtonEditProperties;
  Arr: TArray<TColBtn>;
  i: Integer;
begin
  with clValue do
  begin
    OnGetProperties := clValueGetProperties;
    OnGetPropertiesForEdit := clValueGetPropertiesForEdit;
    Options.ShowEditButtons := isebAlways;
    VisibleForCustomization := False;
  end;

  // Производитель
  clProducer.Position.BandIndex := 1;
  MyInitializeComboBoxColumn;

  if clSubGroup <> nil then
    // группа компонентов
    with clSubGroup do
    begin
      // Position.BandIndex := 1;
      PropertiesClass := TcxPopupEditproperties;
      OnGetProperties := clSubGroupGetProperties;
      Options.Sorting := False;
      Width := 100;
    end;

  // краткое описание
  with clDescription do
  begin
    // Всплывающая форма с кратким описанием
    if FfrmDescriptionPopup = nil then
      FfrmDescriptionPopup := TfrmDescriptionPopup.Create(Self);

    TNotifyEventWrap.Create(FfrmDescriptionPopup.OnHide,
      DoOnDescriptionPopupHide, FEventList);

    Assert(FfrmDescriptionPopup <> nil);
    // Position.BandIndex := 1;
    PropertiesClass := TcxPopupEditproperties;
    (Properties as TcxPopupEditproperties).OnInitPopup :=
      clDescriptionPropertiesInitPopup;
    (Properties as TcxPopupEditproperties).PopupControl := FfrmDescriptionPopup;
    MinWidth := 50;
    Options.Sorting := False;
  end;

  // спецификация, схема, чертёж, изображение
  Arr := [TColBtn.Create(clDatasheet, actOpenDatasheet, actLoadDatasheet),
    TColBtn.Create(clDiagram, actOpenDiagram, actLoadDiagram),
    TColBtn.Create(clDrawing, actOpenDrawing, actLoadDrawing),
    TColBtn.Create(clImage, actOpenImage, actLoadImage)];

  for AColBtn in Arr do
  begin
    with AColBtn.Col do
    begin
      // Position.BandIndex := 1;
      PropertiesClass := TcxButtonEditProperties;
      AcxButtonEditProperties := Properties as TcxButtonEditProperties;
      AcxButtonEditProperties.Buttons.Add;
      Assert(AcxButtonEditProperties.Buttons.Count = 2);
      AcxButtonEditProperties.Buttons[0].Action := AColBtn.OpenAction;
      AcxButtonEditProperties.Buttons[0].Kind := bkText;
      AcxButtonEditProperties.Buttons[1].Action := AColBtn.LoadAction;
      AcxButtonEditProperties.Buttons[1].Default := True;
      AcxButtonEditProperties.Buttons[1].Kind := bkEllipsis;
      OnGetDataText := clDatasheetGetDataText;
      Options.Sorting := False;
      Width := 100;
    end;
  end;

  if clPackagePins <> nil then
    with clPackagePins do
    begin
      // Position.BandIndex := 1;
      MinWidth := 120;
      Options.Sorting := False;
    end;

  with clValue2 do
  begin
    OnGetProperties := clValue2GetProperties;
    OnGetPropertiesForEdit := clValue2GetPropertiesForEdit;
    VisibleForCustomization := False;
  end;

  // Все колонки дочернего представления
  for i := 0 to cxGridDBBandedTableView2.ColumnCount - 1 do
  begin
    ACol := cxGridDBBandedTableView2.Columns[i];

    if ACol = clValue2 then
      Continue;

    // ACol.Position.BandIndex := 1;
    ACol.PropertiesClass := TcxTextEditProperties;
    (ACol.Properties as TcxTextEditProperties).ReadOnly := True;
  end;
end;

procedure TViewComponentsBase.InitView(AView: TcxGridDBBandedTableView);
begin
  inherited;
  AView.OptionsData.Deleting := False;
  AView.OptionsData.DeletingConfirmation := False;
  // AView.OptionsView.ExpandButtonsForEmptyDetails := False;
end;

procedure TViewComponentsBase.InternalRefreshData;
begin
  Assert(BaseCompGrp <> nil);
  BaseCompGrp.RefreshData;
  MainView.ViewData.Collapse(True);
end;

procedure TViewComponentsBase.MyDelete;
var
  AController: TcxGridBandedTableController;
  AView: TcxGridDBBandedTableView;
  fri: Integer;
  i: Integer;
  S: string;
  t: Integer;
  X: Integer;
begin
  AView := FocusedTableView;
  if AView = nil then
    Exit;

  if FDeleteFromAllCategories then
    S := sDoYouWantToDeleteFamilyFromAll
  else
    S := DeleteMessages[AView.Level as TcxGridLevel];

  if not TDialog.Create.DeleteRecordsDialog(S) then
    Exit;

  AController := AView.Controller;

  // если удалить всё
  if FDeleteFromAllCategories then
  begin
    if AController.SelectedRowCount > 0 then
    begin
      for i := 0 to AController.SelectedRowCount - 1 do
      begin
        X := AController.SelectedRows[i].Values[clID.Index];
        BaseCompGrp.FullDeleted.Add(X);
      end;
    end
    else
    begin
      X := AController.FocusedRecord.Values[clID.Index];
      BaseCompGrp.FullDeleted.Add(X);
    end;
  end;

  t := MainView.Controller.TopRecordIndex;
  fri := MainView.Controller.FocusedRowIndex;

  DisableCollapsingAndExpanding;
  try
    AController.DeleteSelection;
    // если удалили последнюю "дочернюю" запись
    if (AView.DataController.RecordCount = 0) and (AView.MasterGridRecord <> nil)
    then
    begin
      // Сворачиваем дочернее представление
      (AView.MasterGridRecord as TcxMyGridMasterDataRow).MyCollapse(False);
      MainView.Controller.TopRowIndex := t;
      MainView.Controller.FocusedRowIndex := fri;
    end;
  finally
    EnableCollapsingAndExpanding;
  end;

  UpdateView;
end;

procedure TViewComponentsBase.MyInitializeComboBoxColumn;
begin
  Assert(BaseCompGrp.Producers <> nil);
  BaseCompGrp.Producers.W.TryOpen;

  // Производителя выбираем ТОЛЬКО из списка
  InitializeComboBoxColumn(MainView, clProducer.DataBinding.FieldName,
    lsEditFixedList, BaseCompGrp.Producers.W.Name.F);
end;

procedure TViewComponentsBase.OnGridRecordCellPopupMenu
  (AColumn: TcxGridDBBandedColumn; var AllowPopup: Boolean);
Var
  AColumnIsValue: Boolean;
  IsText: Boolean;
begin
  IsText := Clipboard.HasFormat(CF_TEXT);

  AColumnIsValue := (AColumn <> nil) and
    (AColumn.DataBinding.FieldName = clValue.DataBinding.FieldName);

  actPasteFamily.Visible :=
    (AColumnIsValue and (AColumn.GridView.Level = cxGridLevel)) or
    (AColumn = nil);

  actPasteFamily.Enabled := actPasteFamily.Visible and IsText;

  actPasteComponents.Visible := AColumnIsValue;

  actPasteComponents.Enabled := actPasteComponents.Visible and IsText;

  actPasteProducer.Visible := (AColumn <> nil) and
    (AColumn.DataBinding.FieldName = clProducer.DataBinding.FieldName);
  actPasteProducer.Enabled := actPasteProducer.Visible and IsText;

  actPastePackagePins.Visible := (AColumn <> nil) and
    (AColumn.DataBinding.FieldName = clPackagePins.DataBinding.FieldName);
  actPastePackagePins.Enabled := actPastePackagePins.Visible and IsText;

  actCopyToClipboard.Visible := AColumn <> nil;
  actCopyToClipboard.Enabled := actCopyToClipboard.Visible

end;

procedure TViewComponentsBase.OpenDoc(ADocFieldInfo: TDocFieldInfo);
begin
  Application.Hint := '';
  TDocument.Open(Handle, ADocFieldInfo.Folder,
    BaseCompGrp.qBaseFamily.FDQuery.FieldByName(ADocFieldInfo.FieldName)
    .AsString, ADocFieldInfo.ErrorMessage, ADocFieldInfo.EmptyErrorMessage,
    sBodyTypesFilesExt);
end;

procedure TViewComponentsBase.PostMessageUpdateDetailColumnsWidth;
begin
  if FMessageUpdateDetailColumnsPosted then
    Exit;

  FMessageUpdateDetailColumnsPosted := True;
  PostMessage(Handle, WM_UPDATE_DETAIL_COLUMNS_WIDTH, 0, 0)
end;

procedure TViewComponentsBase.SetBaseCompGrp(const Value
  : TBaseComponentsGroup2);
begin
  if FBaseCompGrp = Value then
    Exit;

  FBaseCompGrp := Value;
  FEventList.Clear; // Отписываемся от старых событий
  DoOnMasterDetailChange;
end;

{ Синхронизировать положение скроллбаров }
procedure TViewComponentsBase.SyncScrollbarPositions;
var
  AcxGridDBBandedTableView: TcxGridDBBandedTableView;
  AcxGridMasterDataRow: TcxGridMasterDataRow;
  i, ALeftPos: Integer;
  AView: TcxGridBandedTableView;
begin
  // Если находимся в состоянии BeginUpdate
  if UpdateCount > 0 then
    Exit;

  if FIsSyncScrollbars then
    Exit;
  try
    FIsSyncScrollbars := True;
    AView := MainView;
    ALeftPos := AView.Controller.LeftPos;

    for i := 0 to AView.ViewData.RowCount - 1 do
    begin
      AcxGridMasterDataRow := GetRow(0, i) as TcxGridMasterDataRow;
      if AcxGridMasterDataRow.Expanded then
      begin
        AcxGridDBBandedTableView := AcxGridMasterDataRow.ActiveDetailGridView as
          TcxGridDBBandedTableView;

        if (AcxGridDBBandedTableView.Controller <> nil) and
          (AcxGridDBBandedTableView.Controller.LeftPos <> ALeftPos) then
          AcxGridDBBandedTableView.Controller.LeftPos := ALeftPos;
      end;
    end;
  finally
    FIsSyncScrollbars := False;
  end;
end;

procedure TViewComponentsBase.TryApplyBestFit;
begin
  if not FNeedApplyBestFit then
    Exit;

  FNeedApplyBestFit := False;
  MyApplyBestFit;
end;

procedure TViewComponentsBase.UpdateDetailColumnsWidth;
var
  ABand: TcxGridBand;
  ADetailColumn: TcxGridDBBandedColumn;
  AMainColumn: TcxGridDBBandedColumn;
  // dx: Integer;
  i: Integer;
  RealBandWidth: Integer;
  RealColumnWidth: Integer;
begin
  // Предполагаем, что количество видимых главных и дочерних колонок одинаковое
  Assert(MainView.VisibleColumnCount = cxGridDBBandedTableView2.
    VisibleColumnCount);

  cxGrid.BeginUpdate();
  // cxGridDBBandedTableView2.BeginBestFitUpdate;
  try


    // Большинство бэндов имеют ширину 0
    // Тогда их ширина подстроится под ширину колонок
    // Но есть и те, у которых задана минимальная ширина, чтобы влез их заголовок

    Assert(MainView.Bands.Count = cxGridDBBandedTableView2.Bands.Count);
    // Сначала выравниваем длину всех бэндов
    for i := 0 to MainView.Bands.Count - 1 do
    begin
      ABand := MainView.Bands[i];
      if (not ABand.Visible) or (ABand.VisibleIndex = 0)
      { or (ABand.Width = 0) }
      then
        Continue;

      // Если информация о том, сколько бэнд занимает на экране не доступна!
      if MainView.ViewInfo.HeaderViewInfo.BandsViewInfo.Count <= ABand.VisibleIndex
      then
        Continue;

      RealBandWidth := MainView.ViewInfo.HeaderViewInfo.BandsViewInfo.Items
        [ABand.VisibleIndex].Width;
      {
        if ABand.VisibleIndex = 0 then
        begin
        dx := ABand.Width - RealBandWidth;
        Dec(RealBandWidth, MainView.ViewInfo.FirstItemAdditionalWidth - dx);
        end;
      }
      cxGridDBBandedTableView2.Bands[i].Width := RealBandWidth;
      // cxGridDBBandedTableView2.Bands[i].Width := ABand.Width;
    end;

    // Потом изменяем размеры всех дочерних колонок
    for i := 0 to cxGridDBBandedTableView2.VisibleColumnCount - 1 do
    begin
      AMainColumn := MainView.VisibleColumns[i] as TcxGridDBBandedColumn;
      ADetailColumn := cxGridDBBandedTableView2.VisibleColumns[i]
        as TcxGridDBBandedColumn;

      Assert(AMainColumn.DataBinding.FieldName = ADetailColumn.DataBinding.
        FieldName);

      Assert(AMainColumn.VisibleIndex < MainView.ViewInfo.HeaderViewInfo.Count);

      RealColumnWidth := MainView.ViewInfo.HeaderViewInfo.Items
        [AMainColumn.VisibleIndex].Width;

      if AMainColumn.VisibleIndex = 0 then
        Dec(RealColumnWidth, MainView.ViewInfo.FirstItemAdditionalWidth);

      ADetailColumn.Width := RealColumnWidth;
    end;
  finally
    // cxGridDBBandedTableView2.EndBestFitUpdate;
    cxGrid.EndUpdate;
  end;
end;

procedure TViewComponentsBase.UpdateSelectedCount;
begin
  if UpdateCount = 0 then

    StatusBar.Panels[2].Text :=
      Format('%d', [MainView.DataController.GetSelectedCount]);
end;

procedure TViewComponentsBase.UpdateSelectedValues
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

procedure TViewComponentsBase.UpdateTotalComponentCount;
begin
  // Общее число компонентов на в БД
  StatusBar.Panels[4].Text := Format('Всего: %d', [BaseCompGrp.TotalCount]);
end;

procedure TViewComponentsBase.UpdateView;
var
  AView: TcxGridDBBandedTableView;
  Ok: Boolean;
  S: string;
begin
  Ok := BaseCompGrp <> nil;
  AView := FocusedTableView;

  // Удалить из всех категорий можно только родительский компонент
  actDeleteFromAllCategories.Enabled := Ok and (AView <> nil) and
    (AView.Level = cxGridLevel) and (AView.Controller.SelectedRowCount > 0);
  actDeleteFromAllCategories.Visible := actDeleteFromAllCategories.Enabled;

  // Удалять разрешаем только если что-то выделено
  actDeleteEx.Enabled := Ok and (AView <> nil) and
    (AView.Controller.SelectedRowCount > 0);

  actDeleteFromAllCategories.Enabled := actDeleteEx.Enabled;

  if Ok and (AView <> nil) and (AView.Level = cxGridLevel) then
  begin
    if (BaseCompGrp.qBaseFamily.Master <> nil) and
      ((BaseCompGrp.qBaseFamily.Master.FDQuery.Active)) then
    begin
      S := BaseCompGrp.qBaseFamily.Master.FDQuery.FieldByName('Value').AsString;
      actDeleteEx.Caption := Format('Удалить семейство из категории «%s»', [S]);
    end;
  end;

  if Ok and (AView <> nil) and (AView.Level = cxGridLevel2) then
  begin
    actDeleteEx.Caption := 'Удалить компонент из семейства';
  end;

  actAddFamily.Enabled := Ok and (AView <> nil);
  actAddComponent.Enabled := Ok and (AView <> nil);
  // and (AView.Level = tlComponentsDetails);

  actCommit.Enabled := Ok and BaseCompGrp.HaveAnyChanges;
  actRollback.Enabled := actCommit.Enabled;
end;

procedure TViewComponentsBase.UploadDoc(ADocFieldInfo: TDocFieldInfo);
var
  AProducer: string;
  APath: String;
  AFileName: string;
begin
  Application.Hint := '';
  // Файл должен лежать в каталоге = производителю
  AProducer := ProducerDisplayText;

  APath := BaseCompGrp.qBaseFamily.W.Field(ADocFieldInfo.FieldName).AsString;
  // Если файл документации ранее был уже задан
  if APath <> '' then
  begin
    // Получаем полный путь до файла
    APath := TPath.Combine(ADocFieldInfo.Folder, APath);
    // Получаем папку в которой лежит ранее заданный файл документации
    APath := TPath.GetDirectoryName(APath);
    // если такого пути уже не существует
  end
  else
    APath := TPath.Combine(ADocFieldInfo.Folder, AProducer);

  if not TDirectory.Exists(APath) then
    APath := ADocFieldInfo.Folder;

  // Открываем диалог выбора файла для загрузки
  if not TDialog.Create.ShowDialog(TMyOpenPictureDialog, APath, '', AFileName)
  then
    Exit;

  BaseCompGrp.LoadDocFile(AFileName, ADocFieldInfo);
  MyApplyBestFit;
end;

constructor TColBtn.Create(ACol: TcxGridDBBandedColumn;
  AOpenAction, ALoadAction: TAction);
begin
  FCol := ACol;
  FOpenAction := AOpenAction;
  FLoadAction := ALoadAction;
end;

constructor TColInfo.Create(AFieldWrap: TFieldWrap; ABandIndex: Integer;
  ABandCaption: String = '');
begin
  FFieldWrap := AFieldWrap;
  FBandIndex := ABandIndex;
  FBandCaption := ABandCaption;
end;

end.
