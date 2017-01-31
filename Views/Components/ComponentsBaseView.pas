unit ComponentsBaseView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, GridFrame,
  cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB, cxDBData, System.Actions,
  Vcl.ActnList, dxBar, cxClasses, Vcl.ComCtrls, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridBandedTableView,
  cxGridDBBandedTableView, cxGrid, ComponentsBaseMasterDetailUnit,
  NotifyEvents, cxEditRepositoryItems, cxExtEditRepositoryItems, SubGroupsQuery,
  SubGroupListPopupForm, cxLabel,
  cxDBLookupComboBox, cxDropDownEdit, cxButtonEdit, cxGridCustomPopupMenu,
  cxGridPopupMenu, Vcl.Menus, ComponentsParentView, System.Generics.Collections,
  dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
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
  CustomComponentsQuery, SearchBodyType, SearchParameterValues,
  cxTextEdit, cxBlobEdit;

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
    actPasteAsSubComponents: TAction;
    N3: TMenuItem;
    actPasteProducer: TAction;
    N4: TMenuItem;
    actPastePackagePins: TAction;
    N5: TMenuItem;
    actPasteMainComponents: TAction;
    N2: TMenuItem;
    clProducer: TcxGridDBBandedColumn;
    clProducer2: TcxGridDBBandedColumn;
    clPackagePins: TcxGridDBBandedColumn;
    clPackagePins2: TcxGridDBBandedColumn;
    clDescription: TcxGridDBBandedColumn;
    clDescription2: TcxGridDBBandedColumn;
    procedure actCommitExecute(Sender: TObject);
    procedure actPasteAsSubComponentsExecute(Sender: TObject);
    procedure actPastePackagePinsExecute(Sender: TObject);
    procedure actPasteMainComponentsExecute(Sender: TObject);
    procedure actPasteProducerExecute(Sender: TObject);
    procedure actSettingsExecute(Sender: TObject);
    procedure clSubGroup2GetProperties(Sender: TcxCustomGridTableItem;
      ARecord: TcxCustomGridRecord; var AProperties: TcxCustomEditProperties);
    procedure clSubGroupGetProperties(Sender: TcxCustomGridTableItem;
      ARecord: TcxCustomGridRecord; var AProperties: TcxCustomEditProperties);
    procedure cxerpiSubGroup_PropertiesCloseUp(Sender: TObject);
    procedure cxerpiSubGroup_PropertiesInitPopup(Sender: TObject);
    procedure cxGridPopupMenuPopup(ASenderMenu: TComponent;
      AHitTest: TcxCustomGridHitTest; X, Y: Integer; var AllowPopup: Boolean);
    procedure clManufacturerIdPropertiesNewLookupDisplayText(Sender: TObject;
      const AText: TCaption);
    procedure clBodyIdPropertiesNewLookupDisplayText(Sender: TObject;
      const AText: TCaption);
    procedure cxGridPopupMenuPopupMenus0Popup(ASenderMenu: TComponent;
      AHitTest: TcxCustomGridHitTest; X, Y: Integer);
  private
    FQuerySearchBodyType: TQuerySearchBodyType;
    FQuerySearchParameterValues: TQuerySearchParameterValues;
    FQuerySubGroups: TfrmQuerySubGroups;
    function GetFocusedQuery: TQueryCustomComponents;
    function GetQuerySearchBodyType: TQuerySearchBodyType;
    function GetQuerySearchParameterValues: TQuerySearchParameterValues;
    function GetQuerySubGroups: TfrmQuerySubGroups;
    procedure MyInitializeComboBoxColumn;
    { Private declarations }
  protected
    procedure DoOnMasterDetailChange; override;
    procedure OnGridPopupMenuPopup(AColumn: TcxGridDBBandedColumn); virtual;
    property QuerySearchBodyType: TQuerySearchBodyType
      read GetQuerySearchBodyType;
    property QuerySearchParameterValues: TQuerySearchParameterValues
      read GetQuerySearchParameterValues;
    property QuerySubGroups: TfrmQuerySubGroups read GetQuerySubGroups;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property FocusedQuery: TQueryCustomComponents read GetFocusedQuery;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses GridExtension, dxCore, System.Math, System.StrUtils,
  cxDataUtils, System.IOUtils, Winapi.ShellAPI, ComponentsDetailQuery,
  RepositoryDataModule, System.UITypes, ComponentsBaseDetailQuery,
  ColumnsBarButtonsHelper, DialogUnit, Vcl.Clipbrd, PathSettingsForm,
  ClipboardUnit, ParameterValuesUnit;

constructor TViewComponentsBase.Create(AOwner: TComponent);
// var
// i: Integer;
begin
  inherited;
  {
    // ������ ���������� � �������� �����-�� ��� � �������
    for i := 3 to 6 do
    begin
    cxGridDBBandedTableView2.Columns[i].PropertiesClass := MainView.Columns[i]
    .PropertiesClass;
    cxGridDBBandedTableView2.Columns[i].Properties := MainView.Columns[i]
    .Properties;
    end;
  }
end;

destructor TViewComponentsBase.Destroy;
begin
  inherited;
end;

procedure TViewComponentsBase.actCommitExecute(Sender: TObject);
begin
  inherited;

  // ������ ��������� ���������� ������ �������
  MyInitializeComboBoxColumn;
end;

procedure TViewComponentsBase.actPasteAsSubComponentsExecute(Sender: TObject);
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
  ComponentsBaseMasterDetail.Main.TryPost;

  ARow := GetRow(0) as TcxMyGridMasterDataRow;
  Assert(ARow <> nil);

  AView := GetDBBandedTableView(1);

  ARow.MyExpand(False);

  AView.Focused := True;

  // ������ �������� �������� ����������
  ComponentsBaseMasterDetail.DetailComponentsQuery.AppendRows
    (ComponentsBaseMasterDetail.DetailComponentsQuery.Value.FieldName, m);

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
  {
    // ������� ���������� ����� ����� ��� �������
    if QuerySearchBodyType.Search(m[0]) = 0 then
    begin
    TDialog.Create.BodyNotFoundDialog(m[0]);
    Exit;
    end;
  }

  AIDList := GetSelectedIDs;
  try
    for AID in AIDList do
      GetFocusedQuery.SetPackagePins(AID, m[0]);
  finally
    FreeAndNil(AIDList);
  end;

  UpdateView;
end;

procedure TViewComponentsBase.actPasteMainComponentsExecute(Sender: TObject);
var
  m: TArray<String>;
begin
  m := TClb.Create.GetRowsAsArray;
  if Length(m) = 0 then
    Exit;

  // ������ �������� ������������ ����������
  ComponentsBaseMasterDetail.MainComponentsQuery.AppendRows
    (ComponentsBaseMasterDetail.MainComponentsQuery.Value.FieldName, m);

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
  {
    if (not ComponentsBaseMasterDetail.Manufacturers.Locate(m[0])) then
    begin
    // ���� ������������ ���������� �������� ������ ������������� � ����������
    if TDialog.Create.AddManufacturerDialog(m[0]) then
    ComponentsBaseMasterDetail.Manufacturers.AddNewValue(m[0])
    else
    Exit;
    end;
  }

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

procedure TViewComponentsBase.clManufacturerIdPropertiesNewLookupDisplayText
  (Sender: TObject; const AText: TCaption);
begin
  inherited;
  if AText <> '' then
  begin
    if (not ComponentsBaseMasterDetail.Manufacturers.Locate(AText)) and
      (TDialog.Create.AddManufacturerDialog(AText)) then
    begin
      ComponentsBaseMasterDetail.Manufacturers.AddNewValue(AText);
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
  Assert(QuerySubGroups.FDQuery.Active);
  ParamValue := QuerySubGroups.GetFieldValues('ExternalID', ',').Trim([',']);

  with ComponentsBaseMasterDetail.Main.FDQuery do
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
  S := ComponentsBaseMasterDetail.Main.FDQuery.FieldByName('SubGroup').AsString;

  // ������� ��� ������� �� ������. ������ �������� ������ ����� � �������
  S := S.Replace(' ', '', [rfReplaceAll]);

  Assert(S.Length > 0);
  AMainExternalID := ComponentsBaseMasterDetail.Main.FDQuery.FieldByName
    ('CurCategoryExternalID').AsString;

  QuerySubGroups.Load(AMainExternalID, Format(',%s,', [S]));
  frmSubgroupListPopup.QuerySubGroups := QuerySubGroups;
end;

procedure TViewComponentsBase.cxGridPopupMenuPopup(ASenderMenu: TComponent;
  AHitTest: TcxCustomGridHitTest; X, Y: Integer; var AllowPopup: Boolean);
var
  AColumn: TcxGridDBBandedColumn;
  AcxGridRecordCellHitTest: TcxGridRecordCellHitTest;
begin
  inherited;
  AColumn := nil;

  if (AHitTest is TcxGridRecordCellHitTest) then
  begin
    AcxGridRecordCellHitTest := (AHitTest as TcxGridRecordCellHitTest);
    if AcxGridRecordCellHitTest.Item is TcxGridDBBandedColumn then
    begin
      AColumn := AcxGridRecordCellHitTest.Item as TcxGridDBBandedColumn;
    end;
  end;

  OnGridPopupMenuPopup(AColumn);
end;

procedure TViewComponentsBase.cxGridPopupMenuPopupMenus0Popup
  (ASenderMenu: TComponent; AHitTest: TcxCustomGridHitTest; X, Y: Integer);
begin
  inherited;;
end;

procedure TViewComponentsBase.DoOnMasterDetailChange;
begin
  inherited;

  if ComponentsBaseMasterDetail <> nil then
  begin
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
      Result := ComponentsBaseMasterDetail.MainComponentsQuery;
    if AView.Level = cxGridLevel2 then
      Result := ComponentsBaseMasterDetail.DetailComponentsQuery;
  end;
end;

function TViewComponentsBase.GetQuerySearchBodyType: TQuerySearchBodyType;
begin
  if FQuerySearchBodyType = nil then
    FQuerySearchBodyType := TQuerySearchBodyType.Create(Self);

  Result := FQuerySearchBodyType;
end;

function TViewComponentsBase.GetQuerySearchParameterValues
  : TQuerySearchParameterValues;
begin
  if FQuerySearchParameterValues = nil then
    FQuerySearchParameterValues := TQuerySearchParameterValues.Create(Self);

  Result := FQuerySearchParameterValues;
end;

function TViewComponentsBase.GetQuerySubGroups: TfrmQuerySubGroups;
begin
  if FQuerySubGroups = nil then
  begin
    FQuerySubGroups := TfrmQuerySubGroups.Create(Self);
    FQuerySubGroups.FDQuery.Connection :=
      ComponentsBaseMasterDetail.Main.FDQuery.Connection;
  end;
  Result := FQuerySubGroups;
end;

procedure TViewComponentsBase.MyInitializeComboBoxColumn;
begin
  // ���� ��������� �������� ������������� ��� ����������� ������
  QuerySearchParameterValues.Search(TParameterValues.ProducerParameterID);

  // �������������� Combobox �������
  InitializeComboBoxColumn(MainView, clProducer.DataBinding.FieldName,
    lsEditList, QuerySearchParameterValues.Value);

  // ���� ��������� �������� �������� ��� ����������� ������
  QuerySearchParameterValues.Search(TParameterValues.PackagePinsParameterID);

  InitializeComboBoxColumn(MainView, clPackagePins.DataBinding.FieldName,
    lsEditList, QuerySearchParameterValues.Value);

end;

procedure TViewComponentsBase.OnGridPopupMenuPopup
  (AColumn: TcxGridDBBandedColumn);
Var
  Ok: Boolean;
begin
  Ok := Clipboard.HasFormat(CF_TEXT) and (AColumn <> nil);

  actPasteMainComponents.Enabled := Ok and
    (AColumn.GridView.Level = cxGridLevel) and
    (AColumn.DataBinding.FieldName = clValue.DataBinding.FieldName);

  actPasteAsSubComponents.Enabled := Ok and
    (AColumn.DataBinding.FieldName = clValue.DataBinding.FieldName);

  actPasteProducer.Enabled := Ok and
    (AColumn.DataBinding.FieldName = clProducer.DataBinding.FieldName);

  actPastePackagePins.Enabled := Ok and
    (AColumn.DataBinding.FieldName = clPackagePins.DataBinding.FieldName);

  Ok := (AColumn <> nil);

  actPasteMainComponents.Visible := Ok and
    (AColumn.GridView.Level = cxGridLevel) and
    (AColumn.DataBinding.FieldName = clValue.DataBinding.FieldName);

  actPasteAsSubComponents.Visible := Ok and
    (AColumn.DataBinding.FieldName = clValue.DataBinding.FieldName);

  actPasteProducer.Visible := Ok and
    (AColumn.DataBinding.FieldName = clProducer.DataBinding.FieldName);

  actPastePackagePins.Visible := Ok and
    (AColumn.DataBinding.FieldName = clPackagePins.DataBinding.FieldName);

end;

end.
