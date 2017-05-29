unit SubGroupListPopupForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, PopupForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB, cxDBData, cxGridLevel,
  cxClasses, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, SubGroupsQuery, System.Contnrs,
  cxEditRepositoryItems, cxExtEditRepositoryItems, TreeListQuery,
  System.Actions, Vcl.ActnList, dxBar, Vcl.ImgList, CategoriesTreePopupForm,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter,
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
  dxSkinSummer2008, dxSkinTheAsphaltWorld, dxSkinValentine,
  dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, System.ImageList;

const
  WM_ON_CLOSE_POPUP = WM_USER + 98;

type
  TfrmSubgroupListPopup = class(TfrmPopupForm)
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    cxGrid1DBTableView1Id: TcxGridDBColumn;
    cxGrid1DBTableView1Value: TcxGridDBColumn;
    cxGrid1DBTableView1ParentId: TcxGridDBColumn;
    cxGrid1DBTableView1ExternalId: TcxGridDBColumn;
    cxGrid1DBTableView1IsMain: TcxGridDBColumn;
    cxEditRepository: TcxEditRepository;
    cxEditRepositoryLabel: TcxEditRepositoryLabel;
    cxEditRepositoryPopupItem: TcxEditRepositoryPopupItem;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    ActionList: TActionList;
    actAdd: TAction;
    cxImageList: TcxImageList;
    actDelete: TAction;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    actOk: TAction;
    dxBarButton3: TdxBarButton;
    actEdit: TAction;
    dxBarButton4: TdxBarButton;
    procedure actAddExecute(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure actEditExecute(Sender: TObject);
    procedure actOkExecute(Sender: TObject);
    procedure cxGrid1DBTableView1ValueGetProperties
      (Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
      var AProperties: TcxCustomEditProperties);
    procedure FormShow(Sender: TObject);
    procedure cxEditRepositoryPopupItemPropertiesInitPopup(Sender: TObject);
  private
    FEventList: TObjectList;
    FfrmCategoriesTreePopup: TfrmCategoriesTreePopup;
    FQuerySubGroups: TfrmQuerySubGroups;
    FQueryTreeList: TQueryTreeList;
    procedure DoAfterInsert(Sender: TObject);
    procedure DoAfterScroll(Sender: TObject);
    procedure DoOnClosePopup(Sender: TObject);
    function GetfrmCategoriesTreePopup: TfrmCategoriesTreePopup;
    function GetQueryTreeList: TQueryTreeList;
    procedure SetQuerySubGroups(const Value: TfrmQuerySubGroups);
    procedure ShowPopupForm;
    procedure UpdateReadOnly;
    { Private declarations }
  protected
    procedure OnClosePopupProcess(var Message: TMessage); message WM_ON_CLOSE_POPUP;
    property frmCategoriesTreePopup: TfrmCategoriesTreePopup read
        GetfrmCategoriesTreePopup;
    property QueryTreeList: TQueryTreeList read GetQueryTreeList;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property QuerySubGroups: TfrmQuerySubGroups read FQuerySubGroups
      write SetQuerySubGroups;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses RepositoryDataModule, NotifyEvents, DialogUnit;

constructor TfrmSubgroupListPopup.Create(AOwner: TComponent);
begin
  inherited;
  FEventList := TObjectList.Create;
end;

destructor TfrmSubgroupListPopup.Destroy;
begin
  FreeAndNil(FEventList);
  inherited;
  // TODO -cMM: TfrmSubgroupListPopup.Destroy default body inserted
end;

procedure TfrmSubgroupListPopup.actAddExecute(Sender: TObject);
// var
// AColumn: TcxGridDBColumn;
begin
  cxGrid1DBTableView1.Focused := True;
  cxGrid1DBTableView1.DataController.Append;

  // AColumn := cxGrid1DBTableView1.GetColumnByFieldName('Value');
  // Site обеспечивает доступ к элементам размещённым на cxGrid
  // cxGrid1DBTableView1.Site.SetFocus;
  // Показываем редактор для колонки
  // cxGrid1DBTableView1.Controller.EditingController.ShowEdit(AColumn);
end;

procedure TfrmSubgroupListPopup.actDeleteExecute(Sender: TObject);
var
  S: string;
begin
  if QuerySubGroups.FDQuery.State = dsInsert then
  begin
    QuerySubGroups.FDQuery.Cancel;
    Exit;
  end;

  if cxGrid1DBTableView1.DataController.RecordCount > 0 then
  begin
    S := Format('Убрать компонент из категории «%s»?',
      [QuerySubGroups.FDQuery.FieldByName('ExternalID').AsString]);

    if TDialog.Create.DeleteRecordsDialog(S)
    then
    begin
      cxGrid1DBTableView1.Focused := True;
      cxGrid1DBTableView1.DataController.DeleteFocused;
    end;

  end;

end;

procedure TfrmSubgroupListPopup.actEditExecute(Sender: TObject);
begin
  ShowPopupForm;
end;

procedure TfrmSubgroupListPopup.actOkExecute(Sender: TObject);
begin
  PopupWindow.CloseUp;
end;

procedure TfrmSubgroupListPopup.cxEditRepositoryPopupItemPropertiesInitPopup
  (Sender: TObject);
begin
  inherited;
  // привязываем выпадающую форму к данным
  frmCategoriesTreePopup.QueryTreeList := QueryTreeList;
end;

procedure TfrmSubgroupListPopup.cxGrid1DBTableView1ValueGetProperties
  (Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
  var AProperties: TcxCustomEditProperties);
var
  IsMain: Boolean;
  V: Variant;
begin
  if ARecord = nil then
    Exit;

  V := ARecord.Values[cxGrid1DBTableView1IsMain.Index];

  IsMain := not VarIsNull(V) and (V = 1);
  if IsMain then
    AProperties := cxEditRepositoryLabel.Properties
  else
    AProperties := cxEditRepositoryPopupItem.Properties

end;

procedure TfrmSubgroupListPopup.DoAfterInsert(Sender: TObject);
begin
  UpdateReadOnly;

  ShowPopupForm;
end;

procedure TfrmSubgroupListPopup.DoAfterScroll(Sender: TObject);
begin
  UpdateReadOnly;
end;

procedure TfrmSubgroupListPopup.DoOnClosePopup(Sender: TObject);
begin
  PostMessage(Handle, WM_ON_CLOSE_POPUP, 0, 0);
end;

procedure TfrmSubgroupListPopup.FormShow(Sender: TObject);
begin
  inherited;
  UpdateReadOnly;

end;

function TfrmSubgroupListPopup.GetfrmCategoriesTreePopup:
    TfrmCategoriesTreePopup;
begin
  if FfrmCategoriesTreePopup = nil then
    FfrmCategoriesTreePopup := TfrmCategoriesTreePopup.Create(Self);
  Result := FfrmCategoriesTreePopup;
end;

function TfrmSubgroupListPopup.GetQueryTreeList: TQueryTreeList;
begin
  if FQueryTreeList = nil then
  begin
    FQueryTreeList := TQueryTreeList.Create(Self);
    FQueryTreeList.FDQuery.Connection := QuerySubGroups.FDQuery.Connection;
    FQueryTreeList.FDQuery.UpdateOptions.EnableDelete := False;
    FQueryTreeList.FDQuery.UpdateOptions.EnableInsert := False;
    FQueryTreeList.FDQuery.UpdateOptions.EnableUpdate := False;
    FQueryTreeList.FDQuery.Open;
  end;
  Result := FQueryTreeList;
end;

procedure TfrmSubgroupListPopup.OnClosePopupProcess(var Message: TMessage);
var
  AOldValue: string;
  ParamValue: string;
  S: string;
begin
  if QueryTreeList.FDQuery.RecordCount = 0 then
    Exit;

  S := QueryTreeList.FDQuery.FieldByName('ExternalID').AsString;

  ParamValue := QuerySubGroups.FDQuery.ParamByName('Value').AsString;

  if QuerySubGroups.FDQuery.State in [dsEdit, dsBrowse] then
  begin
    AOldValue := QuerySubGroups.FDQuery.FieldByName('ExternalID').AsString;
    ParamValue := ParamValue.Replace(AOldValue, S);
  end;

  if QuerySubGroups.FDQuery.State = dsInsert then
  begin
    ParamValue := Format('%s%s,', [ParamValue, S]);
  end;

  if QuerySubGroups.FDQuery.ParamByName('Value').AsString <> ParamValue then
  begin
    QuerySubGroups.Load(['Value'], [ParamValue]);
  end;
end;

procedure TfrmSubgroupListPopup.SetQuerySubGroups
  (const Value: TfrmQuerySubGroups);
begin
  if FQuerySubGroups <> Value then
  begin
    FQuerySubGroups := Value;
    FEventList.Clear;

    if FQuerySubGroups <> nil then
    begin
      // Привязываем вью к данным
      cxGrid1DBTableView1.DataController.DataSource :=
        FQuerySubGroups.DataSource;

      // Подписываемся на события
      TNotifyEventWrap.Create(FQuerySubGroups.AfterInsert, DoAfterInsert,
        FEventList);
      TNotifyEventWrap.Create(FQuerySubGroups.AfterScroll, DoAfterScroll,
        FEventList);
      TNotifyEventWrap.Create(FQuerySubGroups.AfterOpen, DoAfterScroll,
        FEventList);
      TNotifyEventWrap.Create(frmCategoriesTreePopup.OnClosePopup,
        DoOnClosePopup, FEventList);
      UpdateReadOnly;
    end;

  end;
end;

procedure TfrmSubgroupListPopup.ShowPopupForm;
var
  AColumn: TcxGridDBColumn;
begin
  AColumn := cxGrid1DBTableView1.GetColumnByFieldName('ExternalID');
  // Site обеспечивает доступ к элементам размещённым на cxGrid
  cxGrid1DBTableView1.Site.SetFocus;
  // Показываем редактор для колонки
  cxGrid1DBTableView1.Controller.EditingController.ShowEdit(AColumn);
end;

procedure TfrmSubgroupListPopup.UpdateReadOnly;
begin
  cxGrid1DBTableView1.OptionsData.Deleting := (QuerySubGroups <> nil) and
    not QuerySubGroups.IsRecordReadOnly;
  cxGrid1DBTableView1.OptionsData.Editing := cxGrid1DBTableView1.OptionsData.Deleting;
  actAdd.Enabled := (QuerySubGroups <> nil);
  actDelete.Enabled := (cxGrid1DBTableView1.DataController.RecordCount > 0) and cxGrid1DBTableView1.OptionsData.Editing;
  actEdit.Enabled := actDelete.Enabled;
end;

end.
