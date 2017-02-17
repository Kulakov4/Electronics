unit ComponentsSearchView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ComponentsBaseView, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData,
  cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB, cxDBData,
  cxLabel, cxDBLookupComboBox, cxDropDownEdit, cxButtonEdit,
  cxEditRepositoryItems, cxExtEditRepositoryItems, System.Actions, Vcl.ActnList,
  dxBar, cxClasses, Vcl.ComCtrls, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridBandedTableView, cxGridDBBandedTableView,
  cxGridCustomView, cxGrid, ComponentsSearchGroupUnit,
  cxGridCustomPopupMenu, cxGridPopupMenu, Vcl.Menus, dxSkinsCore, dxSkinBlack,
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
  dxSkinXmas2008Blue, dxSkinscxPCPainter, dxSkinsdxBarPainter, cxTextEdit,
  cxBlobEdit;

type
  TViewComponentsSearch = class(TViewComponentsBase)
    dxbrbtnSearch: TdxBarButton;
    actSearch: TAction;
    actClear: TAction;
    actPasteFromBuffer: TAction;
    dxbbClear: TdxBarButton;
    dxbbDeleteFromAllCategories: TdxBarButton;
    dxbbSave: TdxBarButton;
    dxbbPasteFromBuffer: TdxBarButton;
    dxBarButton2: TdxBarButton;
    procedure actClearExecute(Sender: TObject);
    procedure actPasteFromBufferExecute(Sender: TObject);
    procedure actSearchExecute(Sender: TObject);
    procedure clValueGetProperties(Sender: TcxCustomGridTableItem;
      ARecord: TcxCustomGridRecord; var AProperties: TcxCustomEditProperties);
    procedure cxFieldValueWithExpandPropertiesChange(Sender: TObject);
    procedure cxGridDBBandedTableViewEditKeyDown(Sender: TcxCustomGridTableView;
      AItem: TcxCustomGridTableItem; AEdit: TcxCustomEdit; var Key: Word;
      Shift: TShiftState);
  private
    function GetComponentsSearchGroup: TComponentsSearchGroup;
    procedure Search(ALike: Boolean);
    procedure SetComponentsSearchGroup(const Value: TComponentsSearchGroup);
    { Private declarations }
  protected
    procedure OnGridPopupMenuPopup(AColumn: TcxGridDbBandedColumn); override;
  public
    procedure UpdateView; override;
    property ComponentsSearchGroup: TComponentsSearchGroup read
        GetComponentsSearchGroup write SetComponentsSearchGroup;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses SearchInterfaceUnit, ClipboardUnit;

procedure TViewComponentsSearch.actClearExecute(Sender: TObject);
begin
  if CheckAndSaveChanges <> IDCANCEL then
  begin
    MainView.BeginUpdate();
    try
      ComponentsSearchGroup.ClearSearchResult;
      UpdateView;
    finally
      MainView.EndUpdate;
    end;

    FocusColumnEditor(0, 'Value');
  end;
end;

procedure TViewComponentsSearch.actPasteFromBufferExecute(Sender: TObject);
begin
  MainView.BeginUpdate();
  try
    ComponentsSearchGroup.qFamilySearch.AppendRows
      (ComponentsSearchGroup.qFamilySearch.Value.FieldName,
      TClb.Create.GetRowsAsArray);
    UpdateView;
  finally
    MainView.EndUpdate;
  end;
  PostApplyBestFit;
end;

procedure TViewComponentsSearch.actSearchExecute(Sender: TObject);
begin
  Search(False);
end;

procedure TViewComponentsSearch.clValueGetProperties
  (Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
  var AProperties: TcxCustomEditProperties);
begin
  if ComponentsSearchGroup.qFamilySearch.Mode = RecordsMode then
    inherited
  else
    AProperties := cxertiValue.Properties;
end;

procedure TViewComponentsSearch.cxFieldValueWithExpandPropertiesChange
  (Sender: TObject);
var
  S: string;
begin
  inherited;
  S := (Sender as TcxButtonEdit).EditText;
  actClear.Enabled := ComponentsSearchGroup.qFamilySearch.
    IsClearEnabled or not S.IsEmpty;
  actSearch.Enabled := ComponentsSearchGroup.qFamilySearch.
    IsSearchEnabled or not S.IsEmpty;
end;

procedure TViewComponentsSearch.cxGridDBBandedTableViewEditKeyDown
  (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
  AEdit: TcxCustomEdit; var Key: Word; Shift: TShiftState);
var
  AColumn: TcxGridDbBandedColumn;
begin
  inherited;
  AColumn := AItem as TcxGridDbBandedColumn;
  if (Key = 13) and
    (AColumn.DataBinding.FieldName = clValue.DataBinding.FieldName) then
  begin
    Search(True);
  end;
end;

function TViewComponentsSearch.GetComponentsSearchGroup: TComponentsSearchGroup;
begin
  Result := BaseComponentsGroup as TComponentsSearchGroup;
end;

procedure TViewComponentsSearch.OnGridPopupMenuPopup
  (AColumn: TcxGridDbBandedColumn);
begin
  inherited;

  // ��������� ��������� ����� ������ � ������ ������
  actPasteFamily.Visible := actPasteFamily.Visible and
    (ComponentsSearchGroup.qFamilySearch.Mode = SearchMode);
  actPasteFamily.Caption := '�������� �� ������ ������';

  actPasteComponents.Visible := False;
end;

procedure TViewComponentsSearch.Search(ALike: Boolean);
begin
  MainView.BeginUpdate(lsimPending);
  try
    ComponentsSearchGroup.Search(ALike);
    UpdateView;

    MainView.ViewData.Collapse(True);
  finally
    MainView.EndUpdate;
  end;
  FocusColumnEditor(0, 'Value');
  PostApplyBestFit;
end;

procedure TViewComponentsSearch.SetComponentsSearchGroup(const Value:
    TComponentsSearchGroup);
begin
  if BaseComponentsGroup <> Value then
  begin
    BaseComponentsGroup := Value;

    // ��������� �������������
    UpdateView;
  end;
end;

procedure TViewComponentsSearch.UpdateView;
begin
  actClear.Enabled := ComponentsSearchGroup.qFamilySearch.
    IsClearEnabled;
  actSearch.Enabled := ComponentsSearchGroup.qFamilySearch.
    IsSearchEnabled;

  actCommit.Enabled := ComponentsSearchGroup.Connection.InTransaction and
    (ComponentsSearchGroup.qFamilySearch.Mode = RecordsMode);

  actRollback.Enabled := actCommit.Enabled;

  actDeleteFromAllCategories.Enabled :=
    (ComponentsSearchGroup.qFamilySearch.Mode = RecordsMode) and
    (ComponentsSearchGroup.qFamilySearch.FDQuery.RecordCount > 0);

  actPasteFromBuffer.Enabled := ComponentsSearchGroup.qFamilySearch.
    Mode = SearchMode;
  MainView.OptionsData.Appending :=
    ComponentsSearchGroup.qFamilySearch.Mode = SearchMode;
  MainView.OptionsData.Inserting :=
    ComponentsSearchGroup.qFamilySearch.Mode = SearchMode;
end;

end.
