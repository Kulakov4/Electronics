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
  CustomComponentsQuery, SearchParameterValues, cxTextEdit, cxBlobEdit,
  cxRichEdit, DescriptionPopupForm;

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
    procedure clManufacturerIdPropertiesNewLookupDisplayText(Sender: TObject;
      const AText: TCaption);
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
    FqSearchParameterValues: TQuerySearchParameterValues;
    FqSubGroups: TfrmQuerySubGroups;
    procedure DoAfterCommit(Sender: TObject);
    procedure DoOnDescriptionPopupHide(Sender: TObject);
    function GetFocusedQuery: TQueryCustomComponents;
    function GetfrmSubgroupListPopup: TfrmSubgroupListPopup;
    function GetqSearchParameterValues: TQuerySearchParameterValues;
    function GetqSubGroups: TfrmQuerySubGroups;
    procedure MyInitializeComboBoxColumn;
    { Private declarations }
  protected
    procedure DoOnMasterDetailChange; override;
    procedure InternalRefreshData; override;
    procedure OnGridPopupMenuPopup(AColumn: TcxGridDBBandedColumn); override;
    property FocusedQuery: TQueryCustomComponents read GetFocusedQuery;
    property frmSubgroupListPopup: TfrmSubgroupListPopup
      read GetfrmSubgroupListPopup;
    property qSearchParameterValues: TQuerySearchParameterValues
      read GetqSearchParameterValues;
    property qSubGroups: TfrmQuerySubGroups read GetqSubGroups;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
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
  // ����� � ������ ���������
  cxerpiSubGroup.Properties.PopupControl := frmSubgroupListPopup;

  // ����������� ����� � ������� ���������
  FfrmDescriptionPopup := TfrmDescriptionPopup.Create(Self);
  AcxPopupEditproperties := clDescription.Properties as TcxPopupEditproperties;
  AcxPopupEditproperties.PopupControl := FfrmDescriptionPopup;

  TNotifyEventWrap.Create(FfrmDescriptionPopup.OnHide, DoOnDescriptionPopupHide);

  GridSort.Add(TSortVariant.Create(clValue, [clValue]));
  GridSort.Add(TSortVariant.Create(clProducer, [clProducer, clValue]));

end;

destructor TViewComponentsBase.Destroy;
begin
  inherited;
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

  // ������� ��������� ������������ ���������
  BaseComponentsGroup.Main.TryPost;

  ARow := GetRow(0) as TcxMyGridMasterDataRow;
  Assert(ARow <> nil);

  AView := GetDBBandedTableView(1);

  ARow.MyExpand(False);

  AView.Focused := True;

  // ������ �������� �������� ����������
  BaseComponentsGroup.QueryBaseComponents.AppendRows
    (BaseComponentsGroup.QueryBaseComponents.Value.FieldName, m);

  UpdateView;

end;

procedure TViewComponentsBase.actPastePackagePinsExecute(Sender: TObject);
var
  AID: Integer;
  AIDList: TList<Integer>;
  m: TArray<String>;
begin
  m := TClb.Create.GetRowsAsArray;
  if (Length(m) = 0) or (GetFocusedQuery = nil) then
    Exit;

  AIDList := GetSelectedIDs;
  try
    for AID in AIDList do
      GetFocusedQuery.SetPackagePins(AID, m[0]);
  finally
    FreeAndNil(AIDList);
  end;

  UpdateView;
end;

procedure TViewComponentsBase.actPasteFamilyExecute(Sender: TObject);
var
  m: TArray<String>;
begin
  m := TClb.Create.GetRowsAsArray;
  if Length(m) = 0 then
    Exit;

  // ������ �������� ������������ ����������
  BaseComponentsGroup.QueryBaseFamily.AppendRows
    (BaseComponentsGroup.QueryBaseFamily.Value.FieldName, m);

  PutInTheCenterFocusedRecord(MainView);

  UpdateView;
end;

procedure TViewComponentsBase.actPasteProducerExecute(Sender: TObject);
var
  AID: Integer;
  AIDList: TList<Integer>;
  m: TArray<String>;
begin
  m := TClb.Create.GetRowsAsArray;
  if (Length(m) = 0) or (GetFocusedQuery = nil) then
    Exit;

  AIDList := GetSelectedIDs;
  try
    BeginUpdate;
    try
      for AID in AIDList do
        GetFocusedQuery.SetProducer(AID, m[0]);
    finally
      EndUpdate;
    end;
  finally
    FreeAndNil(AIDList);
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
  // ����������� ���������� ����� � ������
  FfrmDescriptionPopup.Query := BaseComponentsGroup.QueryBaseFamily;
end;

procedure TViewComponentsBase.clManufacturerIdPropertiesNewLookupDisplayText
  (Sender: TObject; const AText: TCaption);
begin
  inherited;
  if AText <> '' then
  begin
    if (not BaseComponentsGroup.Producers.Locate(AText)) and
      (TDialog.Create.AddManufacturerDialog(AText)) then
    begin
      BaseComponentsGroup.Producers.AddNewValue(AText);
    end;
  end;
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

  with BaseComponentsGroup.Main.FDQuery do
  begin
    if FieldByName('SubGroup').AsString <> ParamValue then
    begin
      DisableControls;
      try
        Edit;
        FieldByName('SubGroup').AsString := ParamValue;
        Post;
      finally
        EnableControls;
      end;
    end;
  end;

  UpdateView;
end;

procedure TViewComponentsBase.cxerpiSubGroup_PropertiesInitPopup
  (Sender: TObject);
var
  AMainExternalID: string;
  S: string;
begin
  S := BaseComponentsGroup.QueryBaseFamily.SubGroup.AsString;

  // ������� ��� ������� �� ������. ������ �������� ������ ����� � �������
  S := S.Replace(' ', '', [rfReplaceAll]);

  Assert(S.Length > 0);
  AMainExternalID := BaseComponentsGroup.QueryBaseFamily.CategoryExternalID;

  qSubGroups.Load(AMainExternalID, Format(',%s,', [S]));
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
  // �������������� ���������� �������
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
    // ������������� �� ������� � �������
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

function TViewComponentsBase.GetqSearchParameterValues
  : TQuerySearchParameterValues;
begin
  if FqSearchParameterValues = nil then
    FqSearchParameterValues := TQuerySearchParameterValues.Create(Self);

  Result := FqSearchParameterValues;
end;

function TViewComponentsBase.GetqSubGroups: TfrmQuerySubGroups;
begin
  if FqSubGroups = nil then
  begin
    FqSubGroups := TfrmQuerySubGroups.Create(Self);
    FqSubGroups.FDQuery.Connection :=
      BaseComponentsGroup.Main.FDQuery.Connection;
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
  // ���� ��������� �������� ������������� ��� ����������� ������
  qSearchParameterValues.Search(TDefaultParameters.ProducerParameterID);

  // �������������� Combobox �������
  InitializeComboBoxColumn(MainView, clProducer.DataBinding.FieldName,
    lsEditList, qSearchParameterValues.Value);
  {
    // ���� ��������� �������� �������� ��� ����������� ������
    qSearchParameterValues.Search(TDefaultParameters.PackagePinsParameterID);

    InitializeComboBoxColumn(MainView, clPackagePins.DataBinding.FieldName,
    lsEditList, qSearchParameterValues.Value);
  }
end;

procedure TViewComponentsBase.OnGridPopupMenuPopup
  (AColumn: TcxGridDBBandedColumn);
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

end.
