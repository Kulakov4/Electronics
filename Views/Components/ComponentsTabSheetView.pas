unit ComponentsTabSheetView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
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
  dxSkinXmas2008Blue, dxSkinscxPCPainter, dxBarBuiltInMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB,
  cxDBData, cxMemo, ParametricTableView, ComponentsSearchView,
  CategoryParametersView, GridFrame, ComponentsParentView, ComponentsBaseView,
  ComponentsView, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxClasses, cxGridCustomView, cxGrid, cxPC,
  dxSkinsdxBarPainter, dxBar, System.Actions, Vcl.ActnList, FieldInfoUnit,
  System.Generics.Collections, CustomErrorTable, ExcelDataModule,
  ProgressBarForm3, ProgressInfo, Vcl.AppEvnts, HintWindowEx, Vcl.StdCtrls,
  DataModule, ParametricErrorTable, ParametricTableErrorForm,
  SubParametersQuery2, ParamSubParamsQuery, SearchParamDefSubParamQuery,
  SearchParameterQuery, ComponentTypeSetUnit, ChildCategoriesView,
  SearchCategoryQuery, SearchDaughterCategoriesQuery;

type
  TFieldsInfo = class(TList<TFieldInfo>)
  public
    function Find(const AFieldName: string): TFieldInfo;
  end;

  TComponentsFrame = class(TFrame)
    cxpcComponents: TcxPageControl;
    cxtsCategory: TcxTabSheet;
    cxtsCategoryComponents: TcxTabSheet;
    cxtsCategoryParameters: TcxTabSheet;
    cxtsComponentsSearch: TcxTabSheet;
    cxtsParametricTable: TcxTabSheet;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    ActionList: TActionList;
    dxBarSubItem1: TdxBarSubItem;
    dxBarSubItem2: TdxBarSubItem;
    dxBarSubItem3: TdxBarSubItem;
    actLoadFromExcelFolder: TAction;
    dxBarButton1: TdxBarButton;
    actLoadFromExcelDocument: TAction;
    actLoadParametricTable: TAction;
    dxBarButton2: TdxBarButton;
    dxBarButton3: TdxBarButton;
    actReport: TAction;
    dxBarButton4: TdxBarButton;
    dxBarSubItem4: TdxBarSubItem;
    actAutoBindingDoc: TAction;
    dxBarButton5: TdxBarButton;
    actAutoBindingDescriptions: TAction;
    dxBarButton6: TdxBarButton;
    actLoadParametricData: TAction;
    dxBarSubItem5: TdxBarSubItem;
    dxBarButton8: TdxBarButton;
    actLoadParametricTableRange: TAction;
    dxBarButton7: TdxBarButton;
    procedure actAutoBindingDescriptionsExecute(Sender: TObject);
    procedure actAutoBindingDocExecute(Sender: TObject);
    procedure actLoadFromExcelDocumentExecute(Sender: TObject);
    procedure actLoadFromExcelFolderExecute(Sender: TObject);
    procedure actLoadParametricDataExecute(Sender: TObject);
    procedure actLoadParametricTableExecute(Sender: TObject);
    procedure actLoadParametricTableRangeExecute(Sender: TObject);
    procedure actReportExecute(Sender: TObject);
    procedure cxpcComponentsPageChanging(Sender: TObject; NewPage: TcxTabSheet;
      var AllowChange: Boolean);
  private
    FfrmProgressBar: TfrmProgressBar3;
    FqParamSubParams: TQueryParamSubParams;
    FqSearchCategory: TQuerySearchCategory;
    FqSearchDaughterCategories: TQuerySearchDaughterCategories;
    FqSearchParamDefSubParam: TQuerySearchParamDefSubParam;
    FqSearchParameter: TQuerySearchParameter;
    FqSubParameters: TQuerySubParameters2;
    FViewCategoryParameters: TViewCategoryParameters;
    FViewChildCategories: TViewChildCategories;
    FViewComponents: TViewComponents;
    FViewComponentsSearch: TViewComponentsSearch;
    FViewParametricTable: TViewParametricTable;
    FWriteProgress: TTotalProgress;
    procedure DoAfterLoadSheet(ASender: TObject);
    procedure DoOnTotalReadProgress(ASender: TObject);
    procedure DoOnTotalReadProgressSelected(ASender: TObject);
    function GetNFFieldName(AStringTreeNodeID: Integer): string;
    function GetqParamSubParams: TQueryParamSubParams;
    function GetqSearchCategory: TQuerySearchCategory;
    function GetqSearchDaughterCategories: TQuerySearchDaughterCategories;
    function GetqSearchParamDefSubParam: TQuerySearchParamDefSubParam;
    function GetqSearchParameter: TQuerySearchParameter;
    function GetqSubParameters: TQuerySubParameters2;
    procedure LoadDocFromExcelDocument;
    function LoadExcelFileHeader(var AFileName: String;
      AFieldsInfo: TFieldsInfo): Boolean;
    function InternalLoadExcelFileHeader(ARootTreeNode: TStringTreeNode;
      AFieldsInfo: TFieldsInfo): Boolean;
    function InternalLoadExcelFileHeaderEx(ARootTreeNode: TStringTreeNode;
      AParametricErrorTable: TParametricErrorTable): TArray<Integer>;
    procedure LoadParametricData(AComponentTypeSet: TComponentTypeSet);
    procedure LoadParametricDataFromActiveSheet;
    procedure TryUpdateWrite0Statistic(API: TProgressInfo);
    procedure TryUpdateWriteStatistic(API: TProgressInfo);
    procedure TryUpdateAnalizeStatistic(API: TProgressInfo);
    { Private declarations }
  protected
    property qParamSubParams: TQueryParamSubParams read GetqParamSubParams;
    property qSearchCategory: TQuerySearchCategory read GetqSearchCategory;
    property qSearchParamDefSubParam: TQuerySearchParamDefSubParam
      read GetqSearchParamDefSubParam;
    property qSearchParameter: TQuerySearchParameter read GetqSearchParameter;
    property qSubParameters: TQuerySubParameters2 read GetqSubParameters;
  public
    constructor Create(AOwner: TComponent); override;
    property qSearchDaughterCategories: TQuerySearchDaughterCategories
      read GetqSearchDaughterCategories;
    property ViewCategoryParameters: TViewCategoryParameters
      read FViewCategoryParameters;
    property ViewChildCategories: TViewChildCategories
      read FViewChildCategories;
    property ViewComponents: TViewComponents read FViewComponents;
    property ViewComponentsSearch: TViewComponentsSearch
      read FViewComponentsSearch;
    property ViewParametricTable: TViewParametricTable
      read FViewParametricTable;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses RepositoryDataModule, SettingsController, ProducersForm, DialogUnit,
  System.IOUtils, TreeListQuery, ParametricExcelDataModule,
  ProgressBarForm, ProjectConst, CustomExcelTable, ParameterValuesUnit,
  GridViewForm, ReportQuery, ReportsForm, FireDAC.Comp.Client, AllFamilyQuery,
  AutoBindingDocForm, AutoBinding, AutoBindingDescriptionForm, BindDocUnit,
  NotifyEvents, CustomErrorForm, StrHelper, ErrorType;

constructor TComponentsFrame.Create(AOwner: TComponent);
begin
  inherited;
  cxpcComponents.ActivePage := nil;

  FViewChildCategories := TViewChildCategories.Create(Self);
  FViewChildCategories.Place(cxtsCategory);

  FViewComponents := TViewComponents.Create(Self);
  FViewComponents.Place(cxtsCategoryComponents);

  FViewComponentsSearch := TViewComponentsSearch.Create(Self);
  FViewComponentsSearch.Place(cxtsComponentsSearch);

  FViewCategoryParameters := TViewCategoryParameters.Create(Self);
  FViewCategoryParameters.Place(cxtsCategoryParameters);

  FViewParametricTable := TViewParametricTable.Create(Self);
  FViewParametricTable.Place(cxtsParametricTable);
end;

procedure TComponentsFrame.actAutoBindingDescriptionsExecute(Sender: TObject);
var
  AIDCategory: Integer;
  frmAutoBindingDescriptions: TfrmAutoBindingDescriptions;
  MR: Integer;
begin
  Application.Hint := '';
  frmAutoBindingDescriptions := TfrmAutoBindingDescriptions.Create(Self);
  try
    MR := frmAutoBindingDescriptions.ShowModal;
    case MR of
      mrOk:
        AIDCategory := ViewComponents.ComponentsGroup.qFamily.ParentValue;
      mrAll:
        AIDCategory := 0;
    else
      AIDCategory := -1;
    end;
  finally
    FreeAndNil(frmAutoBindingDescriptions);
  end;

  if MR <> mrCancel then
  begin
    TAutoBind.BindComponentDescriptions(AIDCategory);
    // Обновим данные в текущей категории
    ViewComponents.RefreshData;
  end;

end;

procedure TComponentsFrame.actAutoBindingDocExecute(Sender: TObject);
var
  AFDQuery: TFDQuery;
  AQueryAllFamily: TQueryAllFamily;
  frmAutoBindingDoc: TfrmAutoBindingDoc;
  MR: Integer;
begin
  Application.Hint := '';
  AQueryAllFamily := nil;
  AFDQuery := nil;
  frmAutoBindingDoc := TfrmAutoBindingDoc.Create(Self);
  try
    MR := frmAutoBindingDoc.ShowModal;
    case MR of
      mrAll:
        begin
          AQueryAllFamily := TQueryAllFamily.Create(Self);
          AQueryAllFamily.FDQuery.Open;
          AFDQuery := AQueryAllFamily.FDQuery;
        end;
      mrOk:
        AFDQuery := ViewComponents.ComponentsGroup.qFamily.FDQuery;
      mrNo:
        LoadDocFromExcelDocument;
    end;

    if AFDQuery <> nil then
    begin
      TAutoBind.BindDocs(frmAutoBindingDoc.Docs, AFDQuery,
        frmAutoBindingDoc.cxrbNoRange.Checked,
        frmAutoBindingDoc.cxcbAbsentDoc.Checked);

      // Если привязывали текущую категорию
      if AFDQuery = ViewComponents.ComponentsGroup.qFamily.FDQuery then
      begin
        ViewComponents.ComponentsGroup.ReOpen;
      end;

    end;
  finally
    FreeAndNil(frmAutoBindingDoc);
    if AQueryAllFamily <> nil then
      FreeAndNil(AQueryAllFamily);
  end;
end;

procedure TComponentsFrame.actLoadFromExcelDocumentExecute(Sender: TObject);
var
  AFileName: string;
  AProducer: String;
  AProducerID: Integer;
  m: TArray<String>;
  qTreeList: TQueryTreeList;
  S: string;
begin
  Application.Hint := '';

  if not TfrmProducers.TakeProducer(AProducerID, AProducer) then
    Exit;

  if not TDialog.Create.ShowDialog(TExcelFileOpenDialog,
    TSettings.Create.LastFolderForComponentsLoad, '', AFileName) then
    Exit; // отказались от выбора файла

  // Сохраняем эту папку в настройках
  TSettings.Create.LastFolderForComponentsLoad :=
    TPath.GetDirectoryName(AFileName);

  S := TPath.GetFileNameWithoutExtension(AFileName);

  m := S.Split([' ']);
  if Length(m) = 0 then
  begin
    TDialog.Create.ErrorMessageDialog('Имя файла должно содержать пробел');
    Exit;
  end;

  try
    // Проверяем что первая часть содержит целочисленный код категории
    m[0].ToInteger;
  except
    TDialog.Create.ErrorMessageDialog
      ('В начале имени файла должен быть код категории');
    Exit;
  end;

  qTreeList := (ViewComponents.ComponentsGroup.qFamily.Master as
    TQueryTreeList);

  // Переходим в дереве категорий на загружаемую категорию
  if not qTreeList.W.LocateByExternalID(m[0]) then
  begin
    TDialog.Create.ErrorMessageDialog(Format('Категория %s не найдена',
      [m[0]]));
    Exit;
  end;

  ViewComponents.LoadFromExcelDocument(AFileName, AProducer);

end;

procedure TComponentsFrame.actLoadFromExcelFolderExecute(Sender: TObject);
var
  AFileName: string;
  AFolderName: string;
  AProducer: String;
  AProducerID: Integer;
begin
  Application.Hint := '';
  // Выбираем производителя
  if not TfrmProducers.TakeProducer(AProducerID, AProducer) then
    Exit;

  if not TDialog.Create.ShowDialog(TExcelFilesFolderOpenDialog,
    TSettings.Create.LastFolderForComponentsLoad, '', AFileName) then
    Exit;

  AFolderName := TPath.GetDirectoryName(AFileName);

  TSettings.Create.LastFolderForComponentsLoad := AFolderName;

  ViewComponents.LoadFromExcelFolder(AFolderName, AProducer);
end;

procedure TComponentsFrame.actLoadParametricDataExecute(Sender: TObject);
begin
  Application.Hint := '';
  // будем загружать параметрические данные для компонентов (не семейств)
  LoadParametricData([ctComponent]);
end;

procedure TComponentsFrame.actLoadParametricTableExecute(Sender: TObject);
begin
  Application.Hint := '';
  // будем загружать параметрические данные для семейств компонентов
  LoadParametricData([ctFamily]);
end;

procedure TComponentsFrame.actLoadParametricTableRangeExecute(Sender: TObject);
begin
  Application.Hint := '';
  // будем загружать параметрические данные для семейств компонентов
  LoadParametricDataFromActiveSheet;
end;

procedure TComponentsFrame.actReportExecute(Sender: TObject);
var
  AQueryReports: TQueryReports;
  frmReports: TfrmReports;
begin
  Application.Hint := '';
  frmReports := TfrmReports.Create(Self);
  try
    AQueryReports := TQueryReports.Create(Self);
    try
      AQueryReports.FDQuery.Open;

      frmReports.ViewReports.QueryReports := AQueryReports;

      frmReports.ShowModal;
    finally
      FreeAndNil(AQueryReports);
    end;
  finally
    FreeAndNil(frmReports);
  end;

end;

// var
// HECount: Integer = 0;

procedure TComponentsFrame.cxpcComponentsPageChanging(Sender: TObject;
  NewPage: TcxTabSheet; var AllowChange: Boolean);
begin
  if ViewParametricTable = nil then
    Exit;

  // Если переходим на вкладку категория
  if NewPage = cxtsCategory then
  begin
    TDM.Create.qChildCategories.AddClient;

    // Привязываем подкатегории к данным (функциональная группа)
    ViewChildCategories.qChildCategories := TDM.Create.qChildCategories;

    ViewChildCategories.MainView.ApplyBestFit;
  end;

  // Если уходим со вкладки Категория
  if cxpcComponents.ActivePage = cxtsCategory then
  begin
    TDM.Create.qChildCategories.RemoveClient;
  end;

  // Если переходим на вкладку Содержимое
  if NewPage = cxtsCategoryComponents then
  begin
    TDM.Create.ComponentsGroup.AddClient;

    // Привязываем представления к данным
    ViewComponents.ComponentsGroup := TDM.Create.ComponentsGroup;

    ViewComponents.PostMyApplyBestFitEvent;
  end;

  // Если уходим со вкладки Содержимое
  if cxpcComponents.ActivePage = cxtsCategoryComponents then
  begin
    TDM.Create.ComponentsGroup.RemoveClient;
  end;

  // Если переходим на вкладку Параметры
  if NewPage = cxtsCategoryParameters then
  begin
    TDM.Create.CategoryParametersGroup.AddClient;

    // Параметры в виде списка
    ViewCategoryParameters.CatParamsGroup := TDM.Create.CategoryParametersGroup;

    ViewCategoryParameters.MyApplyBestFit;
  end;

  // Если уходим со вкладки Параметры
  if cxpcComponents.ActivePage = cxtsCategoryParameters then
  begin
    TDM.Create.CategoryParametersGroup.RemoveClient;
  end;

  // Если переходим на вкладку Поиск
  if NewPage = cxtsComponentsSearch then
  begin
    TDM.Create.ComponentsSearchGroup.AddClient;

    // Привязываем представление к данным
    ViewComponentsSearch.ComponentsSearchGroup :=
      TDM.Create.ComponentsSearchGroup;

    ViewComponentsSearch.MyApplyBestFit;
  end;

  // Если уходим со вкладки Поиск
  if cxpcComponents.ActivePage = cxtsComponentsSearch then
  begin
    TDM.Create.ComponentsSearchGroup.RemoveClient;
  end;

  // если переходим на вкладку "Параметрическая таблица"
  if (cxpcComponents.ActivePage <> cxtsParametricTable) and
    (NewPage = cxtsParametricTable) then
  begin
    ViewParametricTable.Unlock;

    // сообщаем о том, что этот запрос понадобится и его надо разблокировать
    if ViewParametricTable.ComponentsExGroup <> nil then
      ViewParametricTable.ComponentsExGroup.AddClient;
  end;

  // если уходим с вкладки "Параметрическая таблица"
  if (cxpcComponents.ActivePage = cxtsParametricTable) and
    (NewPage <> cxtsParametricTable) then
  begin
    if ViewParametricTable.ComponentsExGroup <> nil then
      ViewParametricTable.ComponentsExGroup.RemoveClient;

    ViewParametricTable.Lock;
  end;
end;

procedure TComponentsFrame.DoAfterLoadSheet(ASender: TObject);
var
  A: TArray<Integer>;
  ADataOnly: Boolean;
  AfrmError: TfrmCustomError;
  AParametricExcelTable: TParametricExcelTable;
  e: TExcelDMEvent;
  ne: TNotifyEventR;
  OK: Boolean;
begin
  e := ASender as TExcelDMEvent;

  AParametricExcelTable := e.ExcelTable as TParametricExcelTable;

  // Надо обновить прогресс записи
  if FWriteProgress.PIList.Count = 0 then
    FWriteProgress.Assign(e.TotalProgress);

  OK := e.ExcelTable.Errors.RecordCount = 0;
  // Если в ходе загрузки данных произошли ошибки (компонент не найден)
  if not OK then
  begin
    FfrmProgressBar.Hide;
    AfrmError := TfrmCustomError.Create(nil);
    try
      AfrmError.ViewGridEx.DataSet := e.ExcelTable.Errors;
      // Показываем ошибки
      OK := AfrmError.ShowModal = mrOk;
      if OK then
      begin
        if AfrmError.ContinueType = ctSkip then
          // Убираем записи с ошибками и предупреждениями
          e.ExcelTable.ExcludeErrors(etWarring)
        else
          // Убираем записи с ошибками
          e.ExcelTable.ExcludeErrors(etError);
      end;
    finally
      FreeAndNil(AfrmError);
    end;
  end;

  // Надо ли останавливать загрузку остальных листов
  e.Terminate := not OK;

  if not OK then
    Exit;

  FfrmProgressBar.Show;

  // Если требуется загрузить только данные, но не сами параметры
  ADataOnly := AParametricExcelTable.ComponentTypeSet = [ctComponent];

  // Перед записью первого листа создадим все необходимые параметры
  if (e.SheetIndex = 1) and (not ADataOnly) then
  begin
    // Должна быть хотя-бы одна категория, в которую будем добавлять параметры
    Assert(qSearchDaughterCategories.FDQuery.RecordCount >= 1);

    A := qSearchDaughterCategories.W.ID.AsIntArray;

    // 1 Добавляем параметры в категорию
    e.ExcelTable.Process(
      procedure(ASender: TObject)
      begin
        TParameterValues.LoadParameters(A,
          e.ExcelTable as TParametricExcelTable);
      end,

    // Обработчик события
      procedure(ASender: TObject)
      Var
        API: TProgressInfo;
      begin
        API := ASender as TProgressInfo;
        TryUpdateWrite0Statistic(API);
      end);
  end;

  // 2 Сохраняем значения параметров

  // Подписываемся на событие
  ne := TNotifyEventR.Create(e.ExcelTable.OnProgress,
    procedure(ASender: TObject)
    Var
      API: TProgressInfo;
    begin
      API := ASender as TProgressInfo;
      // Запоминаем прогресс записи листа
      FWriteProgress.PIList[e.SheetIndex - 1].Assign(API);
      // Обновляем общий прогресс записи
      FWriteProgress.UpdateTotalProgress;

      TryUpdateWriteStatistic(FWriteProgress.TotalProgress);
    end);
  try
    // Выполняем загрузку значений параметров
    TParameterValues.LoadParameterValues(e.ExcelTable as TParametricExcelTable,

      procedure(ASender: TObject)
      Var
        API: TProgressInfo;
      begin
        API := ASender as TProgressInfo;
        TryUpdateAnalizeStatistic(API);
      end);

  finally
    FreeAndNil(ne);
  end;
end;

procedure TComponentsFrame.DoOnTotalReadProgress(ASender: TObject);
var
  e: TExcelDMEvent;
begin
  Assert(FfrmProgressBar <> nil);
  e := ASender as TExcelDMEvent;
  FfrmProgressBar.UpdateReadStatistic(e.TotalProgress.TotalProgress);
end;

procedure TComponentsFrame.DoOnTotalReadProgressSelected(ASender: TObject);
var
  API: TProgressInfo;
begin
  Assert(FfrmProgressBar <> nil);
  API := ASender as TProgressInfo;
  FfrmProgressBar.UpdateReadStatistic(API);
end;

function TComponentsFrame.GetNFFieldName(AStringTreeNodeID: Integer): string;
begin
  Assert(AStringTreeNodeID > 0);
  Result := Format('NotFoundParam%d', [AStringTreeNodeID]);
end;

function TComponentsFrame.GetqParamSubParams: TQueryParamSubParams;
begin
  if FqParamSubParams = nil then
    FqParamSubParams := TQueryParamSubParams.Create(Self);

  Result := FqParamSubParams;
end;

function TComponentsFrame.GetqSearchCategory: TQuerySearchCategory;
begin
  if FqSearchCategory = nil then
    FqSearchCategory := TQuerySearchCategory.Create(Self);

  Result := FqSearchCategory;
end;

function TComponentsFrame.GetqSearchDaughterCategories
  : TQuerySearchDaughterCategories;
begin
  if FqSearchDaughterCategories = nil then
    FqSearchDaughterCategories := TQuerySearchDaughterCategories.Create(Self);

  Result := FqSearchDaughterCategories;
end;

function TComponentsFrame.GetqSearchParamDefSubParam
  : TQuerySearchParamDefSubParam;
begin
  if FqSearchParamDefSubParam = nil then
    FqSearchParamDefSubParam := TQuerySearchParamDefSubParam.Create(Self);

  Result := FqSearchParamDefSubParam;
end;

function TComponentsFrame.GetqSearchParameter: TQuerySearchParameter;
begin
  if FqSearchParameter = nil then
    FqSearchParameter := TQuerySearchParameter.Create(Self);

  Result := FqSearchParameter;
end;

function TComponentsFrame.GetqSubParameters: TQuerySubParameters2;
begin
  if FqSubParameters = nil then
    FqSubParameters := TQuerySubParameters2.Create(Self);

  Result := FqSubParameters;
end;

procedure TComponentsFrame.LoadDocFromExcelDocument;
var
  AFileName: string;
begin
  if not TDialog.Create.ShowDialog(TExcelFileOpenDialog,
    TSettings.Create.LastFolderForComponentsLoad, '', AFileName) then
    Exit;
  // отказались от выбора файла

  // Сохраняем эту папку в настройках
  TSettings.Create.LastFolderForComponentsLoad :=
    TPath.GetDirectoryName(AFileName);

  TBindDoc.LoadDocBindsFromExcelDocument(AFileName);
end;

function TComponentsFrame.LoadExcelFileHeader(var AFileName: String;
AFieldsInfo: TFieldsInfo): Boolean;
var
  ARootTreeNode: TStringTreeNode;
begin
  Result := False;
  Assert(AFieldsInfo <> nil);

  if not TDialog.Create.ShowDialog(TExcelFileOpenDialog,
    TSettings.Create.ParametricDataFolder, '', AFileName) then
    Exit;
  // отказались от выбора файла

  // Сохраняем эту папку в настройках
  TSettings.Create.ParametricDataFolder := TPath.GetDirectoryName(AFileName);

  // Описания полей excel файла
  ARootTreeNode := TExcelDM.LoadExcelFileHeader(AFileName);
  try
    Result := InternalLoadExcelFileHeader(ARootTreeNode, AFieldsInfo);
  finally
    FreeAndNil(ARootTreeNode);
  end;
end;

function TComponentsFrame.InternalLoadExcelFileHeader(ARootTreeNode
  : TStringTreeNode; AFieldsInfo: TFieldsInfo): Boolean;

  function ShowErrorForm(AParametricErrorTable: TParametricErrorTable): Boolean;
  var
    AfrmParametricTableError: TfrmParametricTableError;
  begin
    AfrmParametricTableError := TfrmParametricTableError.Create(Self);
    try
      // AfrmGridView.Caption := 'Ошибки среди параметров';
      AfrmParametricTableError.ViewParametricTableError.DataSet :=
        AParametricErrorTable;
      // Показываем что мы собираемся привязывать
      Result := AfrmParametricTableError.ShowModal = mrOk;
    finally
      FreeAndNil(AfrmParametricTableError);
    end;
  end;

var
  AFieldName: string;
  AParametricErrorTable: TParametricErrorTable;
  OK: Boolean;
  AIDArray: TArray<Integer>;
  AID: Integer;
  rc: Integer;
begin
  Result := False;
  Assert(AFieldsInfo <> nil);

  // Описания полей excel файла
  AParametricErrorTable := TParametricErrorTable.Create(Self);
  try
    AIDArray := InternalLoadExcelFileHeaderEx(ARootTreeNode,
      AParametricErrorTable);

    if Length(AIDArray) = 0 then
    begin
      TDialog.Create.ParametricTableNotFound;
      Exit;
    end;

    // Если были обнаружены ошибки
    if AParametricErrorTable.RecordCount > 0 then
    begin
      // Пока количество ошибок увеличивается
      repeat
        // Считаем, сколько ошибок мы получили
        rc := AParametricErrorTable.RecordCount;

        // Скрываем те ошибки, что уже исправили
        AParametricErrorTable.FilterFixed;

        OK := ShowErrorForm(AParametricErrorTable);

        // Если отказались от загрузки
        if not OK then
          Exit;

        // Снова оставляем все ошибки
        AParametricErrorTable.Filtered := False;

        AIDArray := InternalLoadExcelFileHeaderEx(ARootTreeNode,
          AParametricErrorTable);

      until AParametricErrorTable.RecordCount = rc;
    end;
  finally
    FreeAndNil(AParametricErrorTable);
  end;

  OK := False;
  // Для всех найденных полей создаём их описания
  for AID in AIDArray do
  begin
    // Если этот столбец с ошибкой
    if AID < 0 then
      AFieldName := GetNFFieldName(-AID)
    else
    begin
      AFieldName := TParametricExcelTable.GetFieldNameByParamSubParamID(AID);
      OK := True;
    end;

    AFieldsInfo.Add(TFieldInfo.Create(AFieldName));
  end;

  if not OK then
    TDialog.Create.ErrorMessageDialog
      ('Нет параметров, значения которых можно загрузить');

  Result := OK;
end;

function TComponentsFrame.InternalLoadExcelFileHeaderEx(ARootTreeNode
  : TStringTreeNode; AParametricErrorTable: TParametricErrorTable)
  : TArray<Integer>;

  function ProcessParamSearhResult(ACount: Integer;
  AStringTreeNode: TStringTreeNode;
  AParametricErrorTable: TParametricErrorTable): Boolean;
  begin
    Result := True;
    if ACount = 1 then
      Exit;

    if ACount = 0 then
    begin
      AParametricErrorTable.AddErrorMessage(AStringTreeNode.value,
        'Параметр не найден', petParamNotFound, AStringTreeNode.ID);
    end
    else
    begin
      AParametricErrorTable.AddErrorMessage(AStringTreeNode.value,
        Format('Параметр найден в справочнике параметров %d %s',
        [ACount, NameForm(ACount, 'раз', 'раза', 'раз')]), petParamDuplicate,
        AStringTreeNode.ID);
    end;

    Result := False;
  end;

  function ProcessSubParamSearhResult(ACount: Integer;
  AStringTreeNode: TStringTreeNode;
  AParametricErrorTable: TParametricErrorTable): Boolean;
  begin
    Result := True;
    if ACount = 1 then
      Exit;

    if ACount = 0 then
    begin
      AParametricErrorTable.AddErrorMessage(AStringTreeNode.value,
        'Подпараметр не найден', petSubParamNotFound, AStringTreeNode.ID);
    end;

    if ACount > 1 then
    begin
      AParametricErrorTable.AddErrorMessage(AStringTreeNode.value,
        Format('Подпараметр найден в справочнике подпараметров %d %s',
        [ACount, NameForm(ACount, 'раз', 'раза', 'раз')]), petSubParamDuplicate,
        AStringTreeNode.ID);
    end;

    Result := False;
  end;

  function CheckUniqueSubParam(AParamSubParamID: Integer;
  AIDList: TList<Integer>; AStringTreeNode: TStringTreeNode;
  AParametricErrorTable: TParametricErrorTable): Boolean;
  begin
    Assert(AParamSubParamID > 0);
    Result := True;

    // Проверяем, не встечался ли такой подпараметр ранее
    if AIDList.IndexOf(AParamSubParamID) < 0 then
      Exit;

    AParametricErrorTable.AddErrorMessage(AStringTreeNode.value,
      'Параметр встречается более одного раза', petNotUnique,
      AStringTreeNode.ID);
    Result := False;
  end;

var
  AStringTreeNode: TStringTreeNode;
  AStringTreeNode2: TStringTreeNode;
  rc: Integer;
  AIDList: TList<Integer>;
  AParamSubParamID: Integer;
  FamilyNameCoumn: string;
  ParamIsOk: Boolean;
  prc: Integer;
  SubParamIsOk: Boolean;

begin
  Assert(AParametricErrorTable <> nil);

  // Варианты того как может называться колонка с наименованием компонентов
  FamilyNameCoumn := ';PART;PART NUMBER;';

  // Описания полей excel файла
  AIDList := TList<Integer>.Create;
  try
    // Цикл по всем заголовкам таблицы
    for AStringTreeNode in ARootTreeNode.Childs do
    begin
      // Если это первый столбец НАИМЕНОВАНИЕ
      if FamilyNameCoumn.IndexOf(';' + AStringTreeNode.value.ToUpper + ';') >= 0
      then
      begin
        Assert(AStringTreeNode.Childs.Count = 0);
        AIDList.Add(-AStringTreeNode.ID);
        Continue;
      end;

      // Ищем, возможно этот узел раньше был помечен как ошибочный
      if AParametricErrorTable.LocateByID(AStringTreeNode.ID) then
      begin
        ParamIsOk := AParametricErrorTable.Fixed.AsBoolean;
        if ParamIsOk then
          qSearchParameter.SearchByID
            (AParametricErrorTable.ParameterID.AsInteger, True);
      end
      else
      begin
        // Ищем такой параметр в справочнике параметров
        prc := qSearchParameter.SearchByTableName
          (ReplaceNotKeyboadChars(AStringTreeNode.value));
        ParamIsOk := ProcessParamSearhResult(prc, AStringTreeNode,
          AParametricErrorTable);
      end;

      // Цикл по всем подпараметрам
      if AStringTreeNode.Childs.Count > 0 then
      begin
        for AStringTreeNode2 in AStringTreeNode.Childs do
        begin
          // Если с нашим параметром не всё в порядке
          if not ParamIsOk then
          begin
            // Этот столбец в Excel-файле будем пропускать
            AIDList.Add(-AStringTreeNode2.ID);
            Continue;
          end;

          // Ищем, возможно этот узел раньше был помечен как ошибочный
          if AParametricErrorTable.LocateByID(AStringTreeNode2.ID) then
          begin
            SubParamIsOk := AParametricErrorTable.Fixed.AsBoolean;
            if SubParamIsOk then
              qSubParameters.SearchByID
                (AParametricErrorTable.ParameterID.AsInteger, True)
          end
          else
          begin
            // Ищем такой подпараметр в справочнике подпараметров
            rc := qSubParameters.Search
              (ReplaceNotKeyboadChars(AStringTreeNode2.value));
            SubParamIsOk := ProcessSubParamSearhResult(rc, AStringTreeNode2,
              AParametricErrorTable);
          end;

          // Если с нашим подпараметром не всё впорядке
          if not SubParamIsOk then
          begin
            // Этот столбец в Excel-файле будем пропускать
            AIDList.Add(-AStringTreeNode2.ID);
            Continue;
          end;

          // Ищем, есть ли у нашего параметра такой подпараметр
          rc := qParamSubParams.SearchBySubParam
            (qSearchParameter.W.PK.AsInteger, qSubParameters.W.PK.AsInteger);
          Assert(rc <= 1);

          // Если нужно связать параметр с подпараметром
          if rc = 0 then
            qParamSubParams.W.AppendSubParameter
              (qSearchParameter.W.PK.AsInteger, qSubParameters.W.PK.AsInteger);

          // Запоминаем описание поля связанного с подпараметром
          AParamSubParamID := qParamSubParams.W.PK.AsInteger;

          // Проверяем ссылку на подпараметр на уникальность
          if CheckUniqueSubParam(AParamSubParamID, AIDList, AStringTreeNode,
            AParametricErrorTable) then
            AIDList.Add(AParamSubParamID)
          else
            AIDList.Add(-AStringTreeNode2.ID);
        end;
      end
      else
      begin
        // Если у нашего параметра нет подпараметров
        // Если параметр был не найден
        if not ParamIsOk then
        begin
          // Этот столбец в Excel-файле будем пропускать
          AIDList.Add(-AStringTreeNode.ID);
          Continue;
        end;

        // Ищем подпараметр "по умолчанию" для параметра без подпараметров
        qSearchParamDefSubParam.SearchByID(qSearchParameter.W.PK.AsInteger, 1);
        AParamSubParamID := qSearchParamDefSubParam.W.ParamSubParamID.
          F.AsInteger;

        // Проверяем, не встечался ли такой подпараметр ранее
        if CheckUniqueSubParam(AParamSubParamID, AIDList, AStringTreeNode,
          AParametricErrorTable) then
          AIDList.Add(AParamSubParamID)
        else
          AIDList.Add(-AStringTreeNode.ID);
      end;
    end;

    Result := AIDList.ToArray;
  finally
    FreeAndNil(AIDList);
  end;
end;

procedure TComponentsFrame.LoadParametricData(AComponentTypeSet
  : TComponentTypeSet);
var
  ADataOnly: Boolean;
  AFieldsInfo: TFieldsInfo;
  AFileName: string;
  AFullFileName: string;
  AParametricExcelDM: TParametricExcelDM;
  m: TArray<String>;
  rc: Integer;
begin
  AFieldsInfo := TFieldsInfo.Create();
  try
    if not LoadExcelFileHeader(AFullFileName, AFieldsInfo) then
      Exit;

    // Если идёт загрузка только данных
    ADataOnly := AComponentTypeSet = [ctComponent];

    if not ADataOnly then
    begin
      // В начале имени файла - код категории в которую будем загружать параметры
      AFileName := TPath.GetFileNameWithoutExtension(AFullFileName);

      m := AFileName.Split([' ']);
      if Length(m) = 1 then
      begin
        TDialog.Create.ErrorMessageDialog('Имя файла должно содержать пробел');
        Exit;
      end;

      try
        // Проверяем что первая часть содержит целочисленный код категории
        m[0].ToInteger;
      except
        TDialog.Create.ErrorMessageDialog('Имя файла должно содержать пробел');
        Exit;
      end;

      // Ищем, есть ли категория с такми внешним кодом
      if qSearchCategory.SearchByExternalID(m[0]) = 0 then
      begin
        TDialog.Create.ErrorMessageDialog
          (Format('Категория %s не найдена', [m[0]]));
        Exit;
      end;

      // Ищем все дочерние категории
      rc := qSearchDaughterCategories.SearchEx(qSearchCategory.W.PK.AsInteger);
      Assert(rc > 1);
    end;

    AParametricExcelDM := TParametricExcelDM.Create(Self, AFieldsInfo,
      AComponentTypeSet);
    FWriteProgress := TTotalProgress.Create;
    FfrmProgressBar := TfrmProgressBar3.Create(Self);
    try
      TNotifyEventWrap.Create(AParametricExcelDM.AfterLoadSheet,
        DoAfterLoadSheet);
      TNotifyEventWrap.Create(AParametricExcelDM.OnTotalProgress,
        DoOnTotalReadProgress);

      FfrmProgressBar.Show;
      AParametricExcelDM.LoadExcelFile2(AFullFileName);

      // Обновляем параметры для текущей категории
      TDM.Create.CategoryParametersGroup.RefreshData;
      // Пытаемся обновить параметрическую таблицу
      TDM.Create.ComponentsExGroup.TryRefresh;
    finally
      FreeAndNil(AParametricExcelDM);
      FreeAndNil(FWriteProgress);
      FreeAndNil(FfrmProgressBar);
    end;
  finally
    FreeAndNil(AFieldsInfo);
  end;

end;

procedure TComponentsFrame.LoadParametricDataFromActiveSheet;
var
  AFieldsInfo: TFieldsInfo;
  AParametricExcelDM: TParametricExcelDM;
  ARootTreeNode: TStringTreeNode;
begin
  AFieldsInfo := TFieldsInfo.Create();
  try
    // Описания полей excel файла
    ARootTreeNode := TExcelDM.LoadExcelFileHeaderFromActiveSheet;
    try
      InternalLoadExcelFileHeader(ARootTreeNode, AFieldsInfo);
    finally
      FreeAndNil(ARootTreeNode);
    end;

    AParametricExcelDM := TParametricExcelDM.Create(Self, AFieldsInfo,
      [ctComponent]);
    FWriteProgress := TTotalProgress.Create;
    FfrmProgressBar := TfrmProgressBar3.Create(Self);
    try
      TNotifyEventWrap.Create(AParametricExcelDM.AfterLoadSheet,
        DoAfterLoadSheet);
      TNotifyEventWrap.Create(AParametricExcelDM.OnTotalProgress,
        DoOnTotalReadProgressSelected);

      FfrmProgressBar.Show;
      AParametricExcelDM.LoadFromActiveSheet();

      // Обновляем параметры для текущей категории
      TDM.Create.CategoryParametersGroup.RefreshData;
      // Пытаемся обновить параметрическую таблицу
      TDM.Create.ComponentsExGroup.TryRefresh;
    finally
      FreeAndNil(AParametricExcelDM);
      FreeAndNil(FWriteProgress);
      FreeAndNil(FfrmProgressBar);
    end;
  finally
    FreeAndNil(AFieldsInfo);
  end;
end;

procedure TComponentsFrame.TryUpdateWrite0Statistic(API: TProgressInfo);
begin
  if (API.ProcessRecords mod OnWriteProcessEventRecordCount = 0) or
    (API.ProcessRecords = API.TotalRecords) then
    // Отображаем общий прогресс записи
    FfrmProgressBar.UpdateWriteStatistic0(API);
end;

procedure TComponentsFrame.TryUpdateWriteStatistic(API: TProgressInfo);
begin
  if (API.ProcessRecords mod OnWriteProcessEventRecordCount = 0) or
    (API.ProcessRecords = API.TotalRecords) then
    // Отображаем общий прогресс записи
    FfrmProgressBar.UpdateWriteStatistic(API);
end;

procedure TComponentsFrame.TryUpdateAnalizeStatistic(API: TProgressInfo);
begin
  if (API.ProcessRecords mod OnWriteProcessEventRecordCount = 0) or
    (API.ProcessRecords = API.TotalRecords) then
    // Отображаем прогресс анализа
    FfrmProgressBar.UpdateAnalizeStatistic(API);
end;

function TFieldsInfo.Find(const AFieldName: string): TFieldInfo;
begin
  Assert(not AFieldName.IsEmpty);

  for Result in Self do
  begin
    if Result.FieldName = AFieldName then
      Exit;
  end;
  Result := nil;
end;

end.
