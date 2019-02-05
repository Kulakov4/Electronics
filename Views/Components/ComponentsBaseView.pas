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
  ComponentsParentView, System.Generics.Collections, dxSkinsCore, dxSkinBlack,
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
  cxDataControllerConditionalFormattingRulesManagerDialog, dxBarBuiltInMenu;

type
  TViewComponentsBase = class(TViewComponentsParent)
    clSubGroup: TcxGridDBBandedColumn;
    clDatasheet: TcxGridDBBandedColumn;
    clDiagram: TcxGridDBBandedColumn;
    clDrawing: TcxGridDBBandedColumn;
    clImage: TcxGridDBBandedColumn;
    clParentProductId: TcxGridDBBandedColumn;
    cxerlSubGroup: TcxEditRepositoryLabel;
    cxerpiSubGroup: TcxEditRepositoryPopupItem;
    clSubGroup2: TcxGridDBBandedColumn;
    clDatasheet2: TcxGridDBBandedColumn;
    clDiagram2: TcxGridDBBandedColumn;
    clDrawing2: TcxGridDBBandedColumn;
    clImage2: TcxGridDBBandedColumn;
    clParentProductId2: TcxGridDBBandedColumn;
    actSettings: TAction;
    actPasteComponents: TAction;
    N3: TMenuItem;
    actPasteProducer: TAction;
    N4: TMenuItem;
    actPastePackagePins: TAction;
    N5: TMenuItem;
    actPasteFamily: TAction;
    N2: TMenuItem;
    clProducer: TcxGridDBBandedColumn;
    clProducer2: TcxGridDBBandedColumn;
    clPackagePins: TcxGridDBBandedColumn;
    clPackagePins2: TcxGridDBBandedColumn;
    clDescription: TcxGridDBBandedColumn;
    clDescription2: TcxGridDBBandedColumn;
    actOpenDatasheet: TAction;
    actLoadDatasheet: TAction;
    actOpenDiagram: TAction;
    actLoadDiagram: TAction;
    actOpenImage: TAction;
    actLoadImage: TAction;
    actOpenDrawing: TAction;
    actLoadDrawing: TAction;
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
  private
    FfrmDescriptionPopup: TfrmDescriptionPopup;
    FfrmSubgroupListPopup: TfrmSubgroupListPopup;
    FqSubGroups: TfrmQuerySubGroups;
    procedure DoAfterCommit(Sender: TObject);
    procedure DoOnDescriptionPopupHide(Sender: TObject);
    function GetFocusedQuery: TQueryCustomComponents;
    function GetfrmSubgroupListPopup: TfrmSubgroupListPopup;
    function GetProducerDisplayText: string;
    function GetqSubGroups: TfrmQuerySubGroups;
    procedure MyInitializeComboBoxColumn;
    { Private declarations }
  protected
    procedure DoOnMasterDetailChange; override;
    procedure InternalRefreshData; override;
    procedure OnGridRecordCellPopupMenu(AColumn: TcxGridDBBandedColumn;
      var AllowPopup: Boolean); override;
    procedure OpenDoc(ADocFieldInfo: TDocFieldInfo);
    procedure UploadDoc(ADocFieldInfo: TDocFieldInfo);
    property FocusedQuery: TQueryCustomComponents read GetFocusedQuery;
    property frmSubgroupListPopup: TfrmSubgroupListPopup
      read GetfrmSubgroupListPopup;
    property qSubGroups: TfrmQuerySubGroups read GetqSubGroups;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
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
  AcxPopupEditproperties: TcxPopupEditproperties;
begin
  inherited;
  // Форма с кодами категорий
  cxerpiSubGroup.Properties.PopupControl := frmSubgroupListPopup;

  // Всплывающая форма с кратким описанием
  FfrmDescriptionPopup := TfrmDescriptionPopup.Create(Self);
  AcxPopupEditproperties := clDescription.Properties as TcxPopupEditproperties;
  AcxPopupEditproperties.PopupControl := FfrmDescriptionPopup;

  TNotifyEventWrap.Create(FfrmDescriptionPopup.OnHide, DoOnDescriptionPopupHide,
    FEventList);

  GridSort.Add(TSortVariant.Create(clValue, [clValue]));
  GridSort.Add(TSortVariant.Create(clProducer, [clProducer, clValue]));
end;

destructor TViewComponentsBase.Destroy;
begin
  inherited;
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
  BaseComponentsGroup.QueryBaseFamily.TryPost;

  ARow := GetRow(0) as TcxMyGridMasterDataRow;
  Assert(ARow <> nil);

  AView := GetDBBandedTableView(1);

  ARow.MyExpand(False);

  AView.Focused := True;

  // Просим добавить дочерние компоненты
  BaseComponentsGroup.QueryBaseComponents.W.AppendRows
    (BaseComponentsGroup.QueryBaseComponents.W.Value.FieldName, m);

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

  Assert(clID.Index = clID.Index);
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
  BaseComponentsGroup.QueryBaseFamily.W.AppendRows
    (BaseComponentsGroup.QueryBaseFamily.W.Value.FieldName, m);

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

  Assert(BaseComponentsGroup.Producers <> nil);
  Assert(BaseComponentsGroup.Producers.FDQuery.Active);

  // Вставлять можно только то, что есть в справочнике
  if not BaseComponentsGroup.Producers.Locate(AProducer) then
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
  FfrmDescriptionPopup.DescriptionW := BaseComponentsGroup.QueryBaseFamily.W;
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

procedure TViewComponentsBase.cxerpiSubGroup_PropertiesCloseUp(Sender: TObject);
var
  ParamValue: string;
begin
  Assert(qSubGroups.FDQuery.Active);
  ParamValue := qSubGroups.GetFieldValues('ExternalID', ',').Trim([',']);

  if BaseComponentsGroup.QueryBaseFamily.W.SubGroup.F.AsString = ParamValue then
    Exit;

  BaseComponentsGroup.QueryBaseFamily.FDQuery.DisableControls;
  try
    BaseComponentsGroup.QueryBaseFamily.W.TryEdit;
    BaseComponentsGroup.QueryBaseFamily.W.SubGroup.F.AsString := ParamValue;
    BaseComponentsGroup.QueryBaseFamily.W.TryPost;
  finally
    BaseComponentsGroup.QueryBaseFamily.FDQuery.EnableControls;
  end;

  UpdateView;
end;

procedure TViewComponentsBase.cxerpiSubGroup_PropertiesInitPopup
  (Sender: TObject);
var
  AMainExternalID: string;
  S: string;
begin
  S := BaseComponentsGroup.QueryBaseFamily.W.SubGroup.F.AsString;

  // Удаляем все пробелы из строки. Должны остаться только цифры и запятые
  S := S.Replace(' ', '', [rfReplaceAll]);

  Assert(S.Length > 0);
  AMainExternalID := BaseComponentsGroup.QueryBaseFamily.CategoryExternalID;

  qSubGroups.Search(AMainExternalID, Format(',%s,', [S]));
  frmSubgroupListPopup.QuerySubGroups := qSubGroups;
end;

procedure TViewComponentsBase.cxGridDBBandedTableViewColumnHeaderClick
  (Sender: TcxGridTableView; AColumn: TcxGridColumn);
begin
  inherited;
  ApplySort(Sender, AColumn);
end;

procedure TViewComponentsBase.DoAfterCommit(Sender: TObject);
begin
  // Инициализируем выпадающие столбцы
  MyInitializeComboBoxColumn;
end;

procedure TViewComponentsBase.DoOnDescriptionPopupHide(Sender: TObject);
begin
  UpdateView;
end;

procedure TViewComponentsBase.DoOnMasterDetailChange;
begin
  inherited;

  if BaseComponentsGroup <> nil then
  begin
    // Подписываемся на событие о коммите
    TNotifyEventWrap.Create(DMRepository.AfterCommit, DoAfterCommit,
      FEventList);
    MyInitializeComboBoxColumn;
  end;
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
      Result := BaseComponentsGroup.QueryBaseFamily;
    if AView.Level = cxGridLevel2 then
      Result := BaseComponentsGroup.QueryBaseComponents;
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
    FqSubGroups.FDQuery.Connection := BaseComponentsGroup.Connection;
  end;
  Result := FqSubGroups;
end;

procedure TViewComponentsBase.InternalRefreshData;
begin
  Assert(BaseComponentsGroup <> nil);
  BaseComponentsGroup.RefreshData;
  MainView.ViewData.Collapse(True);
end;

procedure TViewComponentsBase.MyInitializeComboBoxColumn;
begin
  Assert(BaseComponentsGroup.Producers <> nil);
  BaseComponentsGroup.Producers.TryOpen;

  // Производителя выбираем ТОЛЬКО из списка
  InitializeComboBoxColumn(MainView, clProducer.DataBinding.FieldName,
    lsEditFixedList, BaseComponentsGroup.Producers.W.Name.F);
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
    BaseComponentsGroup.QueryBaseFamily.FDQuery.FieldByName
    (ADocFieldInfo.FieldName).AsString, ADocFieldInfo.ErrorMessage,
    ADocFieldInfo.EmptyErrorMessage, sBodyTypesFilesExt);
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

  APath := BaseComponentsGroup.QueryBaseFamily.Field
    (ADocFieldInfo.FieldName).AsString;
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

  BaseComponentsGroup.LoadDocFile(AFileName, ADocFieldInfo);
  MyApplyBestFit;
end;

end.
