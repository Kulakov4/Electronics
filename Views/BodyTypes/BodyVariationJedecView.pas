unit BodyVariationJedecView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, GridView, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinBlack,
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
  dxSkinXmas2008Blue, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, cxNavigator, Data.DB, cxDBData, dxSkinsdxBarPainter,
  cxGridCustomPopupMenu, cxGridPopupMenu, Vcl.Menus, System.Actions,
  Vcl.ActnList, dxBar, cxClasses, Vcl.ComCtrls, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridBandedTableView,
  cxGridDBBandedTableView, cxGrid, BodyVariationJedecQuery,
  BodyVariationsJedecQuery, JEDECQuery, cxDBLookupComboBox, GridFrame,
  NotifyEvents, cxButtonEdit, RepositoryDataModule,
  cxDataControllerConditionalFormattingRulesManagerDialog, dxBarBuiltInMenu;

type
  TViewBodyVariationJEDEC = class(TfrmGrid)
    DataSource: TDataSource;
    clIDJEDEC: TcxGridDBBandedColumn;
    dsJEDEC: TDataSource;
    actOK: TAction;
    actCancel: TAction;
    dxBarButton2: TdxBarButton;
    dxBarButton3: TdxBarButton;
    actAdd: TAction;
    dxBarButton1: TdxBarButton;
    dxBarButton4: TdxBarButton;
    clJEDEC: TcxGridDBBandedColumn;
    actOpenJEDEC: TAction;
    actLoadJEDEC: TAction;
    actOpenAll: TAction;
    dxBarButton5: TdxBarButton;
    N2: TMenuItem;
    procedure actAddExecute(Sender: TObject);
    procedure actOKExecute(Sender: TObject);
    procedure actCancelExecute(Sender: TObject);
    procedure actLoadJEDECExecute(Sender: TObject);
    procedure actOpenAllExecute(Sender: TObject);
    procedure actOpenJEDECExecute(Sender: TObject);
  private
    FOnOK: TNotifyEventsEx;
    FOnCancel: TNotifyEventsEx;
    FqBodyVariationsJedec: TQueryBodyVariationsJedec;
    function GetJEDECList: string;
    function GetqBodyVariationsJedec: TQueryBodyVariationsJedec;
    { Private declarations }
  protected
    procedure DoOnHaveAnyChange(Sender: TObject);
    procedure OpenJEDEC(const AFileName: string);
    procedure UploadJEDEC;
    property qBodyVariationsJedec: TQueryBodyVariationsJedec
      read GetqBodyVariationsJedec;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init(const AIDBodyVariations: string; qJEDEC: TQueryJEDEC);
    procedure UpdateView; override;
    property JEDECList: string read GetJEDECList;
    property OnOK: TNotifyEventsEx read FOnOK;
    property OnCancel: TNotifyEventsEx read FOnCancel;
    { Public declarations }
  end;

implementation

uses
  System.StrUtils, SettingsController, OpenDocumentUnit, ProjectConst,
  OpenJedecUnit, DialogUnit;

{$R *.dfm}

constructor TViewBodyVariationJEDEC.Create(AOwner: TComponent);
begin
  inherited;
  FOnOK := TNotifyEventsEx.Create(Self);
  FOnCancel := TNotifyEventsEx.Create(Self);
end;

destructor TViewBodyVariationJEDEC.Destroy;
begin
  FreeAndNil(FOnOK);
  FreeAndNil(FOnCancel);

  if Assigned(FqBodyVariationsJedec) then
    FreeAndNil(FqBodyVariationsJedec);

  inherited;
end;

procedure TViewBodyVariationJEDEC.actAddExecute(Sender: TObject);
begin
  inherited;
  MainView.Controller.ClearSelection;
  MainView.DataController.Append;
  FocusColumnEditor(0, clIDJEDEC.DataBinding.FieldName);

  UpdateView;
end;

procedure TViewBodyVariationJEDEC.actOKExecute(Sender: TObject);
begin
  inherited;
  qBodyVariationsJedec.ApplyUpdates;
  FOnOK.CallEventHandlers(Self);
end;

procedure TViewBodyVariationJEDEC.actCancelExecute(Sender: TObject);
begin
  inherited;
  qBodyVariationsJedec.CancelUpdates;
  FOnCancel.CallEventHandlers(Self);
end;

procedure TViewBodyVariationJEDEC.actLoadJEDECExecute(Sender: TObject);
begin
  inherited;
  UploadJEDEC();
end;

procedure TViewBodyVariationJEDEC.actOpenAllExecute(Sender: TObject);

var
  AJedec: string;
  m: TArray<String>;
begin
  inherited;
  m := qBodyVariationsJedec.GetFieldValues(qBodyVariationsJedec.JEDEC.FieldName,
    ',').Trim([',']).Split([',']);

  for AJedec in m do
  begin
    TJEDECDocument.OpenJEDEC(Handle, AJedec);
  end;
end;

procedure TViewBodyVariationJEDEC.actOpenJEDECExecute(Sender: TObject);
begin
  inherited;
  TJEDECDocument.OpenJEDEC(Handle, qBodyVariationsJedec.JEDEC.AsString);
end;

procedure TViewBodyVariationJEDEC.DoOnHaveAnyChange(Sender: TObject);
begin
  UpdateView;
end;

function TViewBodyVariationJEDEC.GetJEDECList: string;
// var
// i: Integer;
// S: String;
begin
  Result := qBodyVariationsJedec.GetFieldValues
    (qBodyVariationsJedec.JEDEC.FieldName, '; ').Trim([';', ' ']);
  {
    S := '';
    for i := 0 to MainView.DataController.RowCount - 1 do
    begin
    S := S + IfThen(not S.IsEmpty, '; ', '');
    S := S + VarToStr( MainView.ViewData.Rows[i].DisplayTexts[clIDJEDEC.Index] );
    end;

    Result := S;
  }
end;

function TViewBodyVariationJEDEC.GetqBodyVariationsJedec
  : TQueryBodyVariationsJedec;
begin
  if FqBodyVariationsJedec = nil then
  begin
    FqBodyVariationsJedec := TQueryBodyVariationsJedec.Create(nil);
  end;
  Result := FqBodyVariationsJedec;
end;

procedure TViewBodyVariationJEDEC.Init(const AIDBodyVariations: string;
  qJEDEC: TQueryJEDEC);
begin
  Assert(qJEDEC <> nil);
  Assert(not AIDBodyVariations.IsEmpty);

  FEventList.Clear;

  dsJEDEC.DataSet := qJEDEC.FDQuery;
  DataSource.DataSet := qBodyVariationsJedec.FDQuery;

  qBodyVariationsJedec.SearchByIDBodyVariations(AIDBodyVariations);
  TNotifyEventWrap.Create(qBodyVariationsJedec.Monitor.OnHaveAnyChanges,
    DoOnHaveAnyChange, FEventList);
  UpdateView;
end;

procedure TViewBodyVariationJEDEC.OpenJEDEC(const AFileName: string);
var
  AFolders: string;
begin
  Application.Hint := '';
  // Формируем папки, в которых мы будем искать наш файл
  AFolders := TSettings.Create.BodyTypesJEDECFolder;

  TDocument.Open(Handle, AFolders, AFileName, 'JEDEC файл %s не найден',
    'Не задан файл JEDEC', sBodyTypesFilesExt);
end;

procedure TViewBodyVariationJEDEC.UpdateView;
var
  OK: Boolean;
begin
  OK := (FqBodyVariationsJedec <> nil) and
    (FqBodyVariationsJedec.FDQuery.Active);
  actOK.Enabled := OK;
  actCancel.Enabled := OK and qBodyVariationsJedec.HaveAnyChanges;
  actOpenAll.Enabled := OK and (MainView.DataController.RowCount > 0);
  actAdd.Enabled := OK;
  actDeleteEx.Enabled := OK and (MainView.Controller.SelectedRowCount > 0)
end;

procedure TViewBodyVariationJEDEC.UploadJEDEC;
var
  // AProducer: string;
  S: String;
  AFileName: string;
begin
  Application.Hint := '';
  Assert(FqBodyVariationsJedec <> nil);

  // Файл должен лежать в каталоге = производителю
  // AProducer := ProducerDisplayText;

  S := TSettings.Create.BodyTypesJEDECFolder;

  // Открываем диалог выбора файла для загрузки
  if not TDialog.Create.ShowDialog(TMyOpenPictureDialog, S, '', AFileName) then
    Exit;

  FqBodyVariationsJedec.LoadJEDEC(AFileName);
end;

end.
