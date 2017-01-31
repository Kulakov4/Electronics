unit ComponentsView;

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
  cxGridCustomView, cxGrid, ComponentsMasterDetailUnit, cxGridCustomPopupMenu,
  cxGridPopupMenu, Vcl.Menus, ExcelDataModule, ComponentsBaseMasterDetailUnit,
  DocFieldInfo, ProgressBarForm, System.Contnrs, CustomExcelTable, NotifyEvents,
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
  System.Generics.Collections, CustomComponentsQuery,
  cxTextEdit, cxBlobEdit;

{$WARN UNIT_PLATFORM OFF}

type
  TViewComponents = class(TViewComponentsBase)
    dxbrsbtmAdd: TdxBarSubItem;
    dxbrbtnAddMain: TdxBarButton;
    dxbrbtnAddDetail: TdxBarButton;
    dxbrsbtmDelete: TdxBarSubItem;
    dxbrbtnDeleteMain: TdxBarButton;
    dxbrbtnDeleteFromAllCategories: TdxBarButton;
    dxbrbtnApply: TdxBarButton;
    dxbsiLoad: TdxBarSubItem;
    dxbrbtnPasteFromBuffer: TdxBarButton;
    actLoadFromExcelDocument: TAction;
    actShowParametricTable: TAction;
    dxbrbtnPasteFromExcel: TdxBarButton;
    dxbrbtnParametricTable: TdxBarButton;
    dxbb1: TdxBarButton;
    dxbrsbtmLoad: TdxBarSubItem;
    dxbbLoadSpecifications: TdxBarButton;
    dxbrbtnLoadImages: TdxBarButton;
    dxbrbtnLoadSchemes: TdxBarButton;
    dxbrbtnLoadDrawings: TdxBarButton;
    actLoadBodyTypes: TAction;
    dxbrbtnLoadBodyTypes: TdxBarButton;
    dxbrbtnLoadRecommendedReplacement: TdxBarButton;
    dxbrbtnLoadTemp: TdxBarButton;
    dxbbParametricTable: TdxBarButton;
    dxbbSettings: TdxBarButton;
    dxBarSubItem1: TdxBarSubItem;
    dxBarSubItem2: TdxBarSubItem;
    actLoadFromExcelFolder: TAction;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    dxBarButton3: TdxBarButton;
    actLoadParametricTable: TAction;
    dxBarButton4: TdxBarButton;
    procedure actLoadBodyTypesExecute(Sender: TObject);
    procedure actLoadFromExcelDocumentExecute(Sender: TObject);
    procedure actLoadFromExcelFolderExecute(Sender: TObject);
    procedure actLoadParametricTableExecute(Sender: TObject);
    procedure actLoadStatusExecute(Sender: TObject);
    procedure actShowParametricTableExecute(Sender: TObject);
    procedure cxGridDBBandedTableViewSelectionChanged
      (Sender: TcxCustomGridTableView);
    procedure StatusBarResize(Sender: TObject);
  private
    FCountEvents: TObjectList;
    FOnLoadBodyTypesEvent: TNotifyEventsEx;
    FOnLoadParametricTable: TNotifyEventsEx;
    FOnShowParametricTableEvent: TNotifyEventsEx;
    procedure DoOnUpdateDetailCount(Sender: TObject);
    procedure DoOnUpdateMainComponentCount(Sender: TObject);
    function GetComponentsMasterDetail: TComponentsMasterDetail;
    procedure LoadFromExcelFolder;
    procedure SetComponentsMasterDetail(const Value: TComponentsMasterDetail);
    procedure UpdateSelectedCount;
    procedure UpdateTotalComponentCount;
    { Private declarations }
  protected
    procedure CreateCountEvents;
    // TODO: LoadFromDirectory
    // function LoadFromDirectory(ADocFieldInfo: TDocFieldInfo): Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BeginUpdate; override;
    procedure EndUpdate; override;
    procedure UpdateView; override;
    property ComponentsMasterDetail: TComponentsMasterDetail
      read GetComponentsMasterDetail write SetComponentsMasterDetail;
    property OnShowParametricTableEvent: TNotifyEventsEx
      read FOnShowParametricTableEvent;
    property OnLoadBodyTypesEvent: TNotifyEventsEx read FOnLoadBodyTypesEvent;
    property OnLoadParametricTable: TNotifyEventsEx read FOnLoadParametricTable;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses RepositoryDataModule, ComponentsExcelDataModule, ImportErrorForm,
  DialogUnit, SplashXP, Vcl.Clipbrd, SettingsController,
  Vcl.FileCtrl, System.IOUtils, System.Types, ProgressInfo, System.Math,
  ErrorTable, FireDAC.Comp.DataSet, ImportProcessForm, ProjectConst;

constructor TViewComponents.Create(AOwner: TComponent);
begin
  inherited;

  FCountEvents := TObjectList.Create;

  // Событие о загрузке корпусных данных
  FOnLoadBodyTypesEvent := TNotifyEventsEx.Create(Self);

  // Событие о отображении формы с параметрической таблицей
  FOnShowParametricTableEvent := TNotifyEventsEx.Create(Self);

  // Событие о загрузке данных в параметрическую таблицу
  FOnLoadParametricTable := TNotifyEventsEx.Create(Self);
end;

destructor TViewComponents.Destroy;
begin
  FreeAndNil(FCountEvents);
  inherited;
end;

procedure TViewComponents.actLoadBodyTypesExecute(Sender: TObject);
begin
  // Извещаем о том, что нужно загрузить корпусные данные
  FOnLoadBodyTypesEvent.CallEventHandlers(Self);
  // FBodyTypesLoad.Load;
end;

procedure TViewComponents.actLoadFromExcelDocumentExecute(Sender: TObject);
var
  AComponentsExcelDM: TComponentsExcelDM;
  AFileName: string;
  AfrmImportError: TfrmImportError;
  OK: Boolean;
begin
  AFileName := TDialog.Create.OpenExcelFile
    (TSettings.Create.LastFolderForComponentsLoad);

  if AFileName.IsEmpty then
    Exit; // отказались от выбора файла

  // Сохраняем эту папку в настройках
  TSettings.Create.LastFolderForComponentsLoad :=
    TPath.GetDirectoryName(AFileName);

  AComponentsExcelDM := TComponentsExcelDM.Create(Self);
  try
    // Первый этап - загружаем данные из Excel файла
    TfrmProgressBar.Process(AComponentsExcelDM,
      procedure
      begin
        AComponentsExcelDM.LoadExcelFile(AFileName);
      end, 'Загрузка компонентов из Excel документа');

    // Второй этап - отображаем окно с ошибками
    OK := AComponentsExcelDM.ExcelTable.Errors.RecordCount = 0;

    if not OK then
    begin
      AfrmImportError := TfrmImportError.Create(Self);
      try
        AfrmImportError.ErrorTable := AComponentsExcelDM.ExcelTable.Errors;
        OK := AfrmImportError.ShowModal = mrOk;
        if OK then
        begin
          if AfrmImportError.ContinueType = ctSkip then
          begin
            // Убираем записи с ошибками и предупреждениями
            AComponentsExcelDM.ExcelTable.ExcludeErrors(etWarring);
          end
          else
          begin
            // Убираем записи с ошибками
            AComponentsExcelDM.ExcelTable.ExcludeErrors(etError);
          end;
        end;

      finally
        FreeAndNil(AfrmImportError);
      end;
    end;

    // Третий этап - сохраняем в базе данных
    if OK then
    begin
      BeginUpdate;
      try
        TfrmProgressBar.Process(AComponentsExcelDM.ExcelTable,
          procedure
          begin
            ComponentsMasterDetail.InsertRecordList
              (AComponentsExcelDM.ExcelTable);
          end, 'Сохранение компонентов в БД');
      finally
        EndUpdate;
      end;
    end;
  finally
    FreeAndNil(AComponentsExcelDM);
  end;
  UpdateView;
end;

procedure TViewComponents.actLoadFromExcelFolderExecute(Sender: TObject);
begin
  LoadFromExcelFolder;
end;

procedure TViewComponents.actLoadParametricTableExecute(Sender: TObject);
begin
  // Извещаем о необходимости загрузить данные параметрической таблицы
  FOnLoadParametricTable.CallEventHandlers(Self);
end;

procedure TViewComponents.actLoadStatusExecute(Sender: TObject);
begin
  inherited;;
end;

procedure TViewComponents.actShowParametricTableExecute(Sender: TObject);
begin
  CheckAndSaveChanges;

  FOnShowParametricTableEvent.CallEventHandlers(Self);

  UpdateView;
end;

procedure TViewComponents.DoOnUpdateDetailCount(Sender: TObject);
begin
  // Выводим кол-во дочерних наименований
  StatusBar.Panels[1].Text :=
    Format('%d', [ComponentsMasterDetail.qComponentsDetail.FDQuery.
    RecordCount]);
end;

procedure TViewComponents.DoOnUpdateMainComponentCount(Sender: TObject);
begin
  if ComponentsMasterDetail.qComponents.FDQuery.State = dsBrowse then
  begin
    // Выводим кол-во родительских наименований
    StatusBar.Panels[0].Text :=
      Format('%d', [ComponentsMasterDetail.qComponents.FDQuery.RecordCount]);

    // UpdateTotalComponentCount;
  end;
end;

procedure TViewComponents.BeginUpdate;
begin
  // Отписываемся от событий о смене кол-ва
  if FUpdateCount = 0 then
    FCountEvents.Clear;

  inherited;
end;

procedure TViewComponents.CreateCountEvents;
begin
  // Подписываемся на события чтобы отслеживать кол-во
  TNotifyEventWrap.Create(ComponentsMasterDetail.qComponents.AfterPost,
    DoOnUpdateMainComponentCount, FCountEvents);

  TNotifyEventWrap.Create(ComponentsMasterDetail.qComponents.AfterOpen,
    DoOnUpdateMainComponentCount, FCountEvents);

  TNotifyEventWrap.Create(ComponentsMasterDetail.qComponents.AfterDelete,
    DoOnUpdateMainComponentCount, FCountEvents);

  TNotifyEventWrap.Create(ComponentsMasterDetail.qComponentsDetail.AfterPost,
    DoOnUpdateDetailCount);

  TNotifyEventWrap.Create(ComponentsMasterDetail.qComponentsDetail.AfterOpen,
    DoOnUpdateDetailCount);

  TNotifyEventWrap.Create(ComponentsMasterDetail.qComponentsDetail.AfterDelete,
    DoOnUpdateDetailCount);

  DoOnUpdateDetailCount(nil);
  DoOnUpdateMainComponentCount(nil);
  UpdateTotalComponentCount;
end;

procedure TViewComponents.cxGridDBBandedTableViewSelectionChanged
  (Sender: TcxCustomGridTableView);
begin
  UpdateSelectedCount;
end;

procedure TViewComponents.EndUpdate;
begin
  inherited;
  if FUpdateCount = 0 then
    CreateCountEvents;
end;

function TViewComponents.GetComponentsMasterDetail: TComponentsMasterDetail;
begin
  Result := ComponentsBaseMasterDetail as TComponentsMasterDetail;
end;

procedure TViewComponents.LoadFromExcelFolder;
var
  AFileName: string;
  AFileNames: TList<String>;
  AFolderName: string;
  AutomaticLoadErrorTable: TAutomaticLoadErrorTable;
  i: Integer;
  m: TStringDynArray;
  S: string;
begin
  AFileName := TDialog.Create.OpenDialog(TExcelFilesFolderOpenDialog,
    TSettings.Create.LastFolderForComponentsLoad);
  if AFileName = '' then
    Exit;

  AFolderName := TPath.GetDirectoryName(AFileName);

  TSettings.Create.LastFolderForComponentsLoad := AFolderName;

  m := TDirectory.GetFiles(AFolderName,
    function(const Path: string; const SearchRec: TSearchRec): Boolean
    Var
      S: String;
    begin
      S := TPath.GetExtension(SearchRec.Name);
      Result := S.IndexOf('.xls') = 0;
    end);

  if Length(m) = 0 then
  begin
    TDialog.Create.ExcelFilesNotFoundDialog;
  end;

  AFileNames := TList<String>.Create();
  try
    for i := Low(m) to High(m) do
    begin
      AFileNames.Add(m[i]);
    end;

    AutomaticLoadErrorTable := TAutomaticLoadErrorTable.Create(Self);
    for AFileName in AFileNames do
    begin
      S := TPath.GetFileNameWithoutExtension(AFileName);
      AutomaticLoadErrorTable.LocateOrAppendData(S, '', '', '');
    end;
    AutomaticLoadErrorTable.First;

    if frmImportProcess <> nil then
      FreeAndNil(frmImportProcess);

    frmImportProcess := TfrmImportProcess.Create(Self);
    frmImportProcess.Caption := 'Загрузка компонентов';
    frmImportProcess.ErrorTable := AutomaticLoadErrorTable;
    // Показываем отчёт
    frmImportProcess.Show;

    Application.ProcessMessages;

    BeginUpdate; // Замораживаем представление
    try
      ComponentsMasterDetail.LoadFromExcelFolder(AFileNames,
        AutomaticLoadErrorTable);
    finally
      // Разрешаем закрыть форму
      frmImportProcess.Done := True;
      EndUpdate;
    end;
  finally
    FreeAndNil(AFileNames);
  end;

  UpdateView;
end;

procedure TViewComponents.SetComponentsMasterDetail
  (const Value: TComponentsMasterDetail);
begin
  if ComponentsBaseMasterDetail <> Value then
  begin
    ComponentsBaseMasterDetail := Value;

    if ComponentsBaseMasterDetail <> nil then
    begin
      if FUpdateCount = 0 then
        CreateCountEvents;
    end;
  end;
end;

procedure TViewComponents.StatusBarResize(Sender: TObject);
const
  EmptyPanelIndex = 3;
var
  i: Integer;
  x: Integer;
begin
  x := StatusBar.ClientWidth;
  for i := 0 to StatusBar.Panels.Count - 1 do
  begin
    if i <> EmptyPanelIndex then
    begin
      Dec(x, StatusBar.Panels[i].Width);
    end;
  end;
  x := IfThen(x >= 0, x, 0);
  StatusBar.Panels[EmptyPanelIndex].Width := x;
end;

procedure TViewComponents.UpdateSelectedCount;
begin
  if FUpdateCount = 0 then

    StatusBar.Panels[2].Text :=
      Format('%d', [MainView.DataController.GetSelectedCount]);
end;

procedure TViewComponents.UpdateTotalComponentCount;
begin
  // Общее число компонентов на в БД
  StatusBar.Panels[4].Text := Format('Всего: %d',
    [ComponentsMasterDetail.TotalCount]);
end;

procedure TViewComponents.UpdateView;
begin
  inherited;

  actLoadFromExcelDocument.Enabled := not actCommit.Enabled;
  actLoadFromExcelFolder.Enabled := not actCommit.Enabled;
  actLoadBodyTypes.Enabled := not actCommit.Enabled;

  dxbsiLoad.Enabled := not actCommit.Enabled;
end;

end.
