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
  DataModule2, ParametricErrorTable, ParametricTableErrorForm,
  SubParametersQuery2, ParamSubParamsQuery, SearchParamDefSubParamQuery,
  SearchParameterQuery;

type
  TFieldsInfo = class(TList<TFieldInfo>)
  public
    function Find(const AFieldName: string): TFieldInfo;
  end;

  TComponentsFrame = class(TFrame)
    cxpcComponents: TcxPageControl;
    cxtsCategory: TcxTabSheet;
    cxgrdFunctionalGroup: TcxGrid;
    tvFunctionalGroup: TcxGridDBTableView;
    clFunctionalGroupId: TcxGridDBColumn;
    clFunctionalGroupExternalId: TcxGridDBColumn;
    clFunctionalGroupValue: TcxGridDBColumn;
    clFunctionalGroupOrder: TcxGridDBColumn;
    clFunctionalGroupParentExternalId: TcxGridDBColumn;
    glFunctionalGroup: TcxGridLevel;
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
    ViewComponents: TViewComponents;
    ViewComponentsSearch: TViewComponentsSearch;
    actLoadParametricData: TAction;
    dxBarSubItem5: TdxBarSubItem;
    dxBarButton8: TdxBarButton;
    ViewCategoryParameters: TViewCategoryParameters;
    ViewParametricTable: TViewParametricTable;
    procedure actAutoBindingDescriptionsExecute(Sender: TObject);
    procedure actAutoBindingDocExecute(Sender: TObject);
    procedure actLoadFromExcelDocumentExecute(Sender: TObject);
    procedure actLoadFromExcelFolderExecute(Sender: TObject);
    procedure actLoadParametricDataExecute(Sender: TObject);
    procedure actLoadParametricTableExecute(Sender: TObject);
    procedure actReportExecute(Sender: TObject);
    procedure cxpcComponentsPageChanging(Sender: TObject; NewPage: TcxTabSheet;
      var AllowChange: Boolean);
    procedure cxtsCategoryComponentsShow(Sender: TObject);
    procedure cxtsCategoryParametersShow(Sender: TObject);
    procedure cxtsComponentsSearchShow(Sender: TObject);
  private
    FfrmProgressBar: TfrmProgressBar3;
    FqParamSubParams: TQueryParamSubParams;
    FqSearchParamDefSubParam: TQuerySearchParamDefSubParam;
    FqSearchParameter: TQuerySearchParameter;
    FqSubParameters: TQuerySubParameters2;
    FWriteProgress: TTotalProgress;
    procedure DoAfterLoadSheet(ASender: TObject);
    procedure DoOnTotalReadProgress(ASender: TObject);
    function GetNFFieldName(AStringTreeNodeID: Integer): string;
    function GetqParamSubParams: TQueryParamSubParams;
    function GetqSearchParamDefSubParam: TQuerySearchParamDefSubParam;
    function GetqSearchParameter: TQuerySearchParameter;
    function GetqSubParameters: TQuerySubParameters2;
    procedure LoadDocFromExcelDocument;
    function LoadExcelFileHeader(var AFileName: String;
      AFieldsInfo: TFieldsInfo): Boolean;
    procedure LoadParametricData(AFamily: Boolean);
    procedure TryUpdateWrite0Statistic(API: TProgressInfo);
    procedure TryUpdateWriteStatistic(API: TProgressInfo);
    { Private declarations }
  protected
    property qParamSubParams: TQueryParamSubParams read GetqParamSubParams;
    property qSearchParamDefSubParam: TQuerySearchParamDefSubParam
      read GetqSearchParamDefSubParam;
    property qSearchParameter: TQuerySearchParameter read GetqSearchParameter;
    property qSubParameters: TQuerySubParameters2 read GetqSubParameters;
  public
    constructor Create(AOwner: TComponent); override;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses RepositoryDataModule, SettingsController, ProducersForm, DialogUnit,
  System.IOUtils, TreeListQuery, ParametricExcelDataModule,
  ProgressBarForm, ProjectConst, CustomExcelTable, ParameterValuesUnit,
  GridViewForm, ReportQuery, ReportsForm, FireDAC.Comp.Client, AllFamilyQuery,
  AutoBindingDocForm, AutoBinding, AutoBindingDescriptionForm, BindDocUnit,
  NotifyEvents, CustomErrorForm;

constructor TComponentsFrame.Create(AOwner: TComponent);
begin
  inherited;
  ViewParametricTable.ShowHint := False;
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
          AQueryAllFamily.RefreshQuery;
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
  if not qTreeList.LocateByExternalID(m[0]) then
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
  LoadParametricData(False);
end;

procedure TComponentsFrame.actLoadParametricTableExecute(Sender: TObject);
begin
  Application.Hint := '';
  // будем загружать параметрические данные для семейств компонентов
  LoadParametricData(True);
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
      AQueryReports.RefreshQuery;

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
  // если переходим на вкладку "Параметрическая таблица"
  if (cxpcComponents.ActivePage <> cxtsParametricTable) and
    (NewPage = cxtsParametricTable) then
  begin
    // сообщаем о том, что этот запрос понадобится и его надо разблокировать
    if ViewParametricTable.ComponentsExGroup <> nil then
      ViewParametricTable.ComponentsExGroup.AddClient;
  end;

  if (cxpcComponents.ActivePage = cxtsParametricTable) and
    (NewPage <> cxtsParametricTable) then
  begin
    if ViewParametricTable.ComponentsExGroup <> nil then
      ViewParametricTable.ComponentsExGroup.DecClient;
  end;
end;

procedure TComponentsFrame.cxtsCategoryComponentsShow(Sender: TObject);
begin
  ViewComponents.PostMyApplyBestFitEvent;
end;

procedure TComponentsFrame.cxtsCategoryParametersShow(Sender: TObject);
begin
  ViewCategoryParameters.MyApplyBestFit;
end;

procedure TComponentsFrame.cxtsComponentsSearchShow(Sender: TObject);
begin
  ViewComponentsSearch.MyApplyBestFit;
end;

procedure TComponentsFrame.DoAfterLoadSheet(ASender: TObject);
var
  AfrmError: TfrmCustomError;
  e: TExcelDMEvent;
  OK: Boolean;
begin
  e := ASender as TExcelDMEvent;

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

  // Перед записью первого листа создадим все необходимые параметры
  if e.SheetIndex = 1 then
  begin

    // 1 Добавляем параметры в категорию
    e.ExcelTable.Process(
      procedure(ASender: TObject)
      begin
        TParameterValues.LoadParameters(e.ExcelTable as TParametricExcelTable);
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
  e.ExcelTable.Process(
    procedure(ASender: TObject)
    begin
      TParameterValues.LoadParameterValues
        (e.ExcelTable as TParametricExcelTable, False);
    end,

  // Обработчик события
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

end;

procedure TComponentsFrame.DoOnTotalReadProgress(ASender: TObject);
var
  e: TExcelDMEvent;
begin
  Assert(FfrmProgressBar <> nil);
  e := ASender as TExcelDMEvent;
  FfrmProgressBar.UpdateReadStatistic(e.TotalProgress.TotalProgress);
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
    Exit; // отказались от выбора файла

  // Сохраняем эту папку в настройках
  TSettings.Create.LastFolderForComponentsLoad :=
    TPath.GetDirectoryName(AFileName);

  TBindDoc.LoadDocBindsFromExcelDocument(AFileName);
end;

function TComponentsFrame.LoadExcelFileHeader(var AFileName: String;
AFieldsInfo: TFieldsInfo): Boolean;
var
  AFixIDList: TList<TPair<Integer, Integer>>;
  AExcelDM: TExcelDM;
  AFieldInfo: TFieldInfo;
  AFieldName: string;
  // AfrmGridView: TfrmGridView;
  AParametricErrorTable: TParametricErrorTable;
  ARootTreeNode: TStringTreeNode;
  AStringTreeNode: TStringTreeNode;
  AStringTreeNode2: TStringTreeNode;
  I: Integer;
  nf: Boolean;
  OK: Boolean;
  rc: Integer;
  AIDList: TList<Integer>;
  AfrmParametricTableError: TfrmParametricTableError;
  AID: Integer;
  APair: TPair<Integer, Integer>;
  AParamSubParamID: Integer;
  FamilyNameCoumn: string;
  prc: Integer;

begin
  Result := False;
  Assert(AFieldsInfo <> nil);

  // Варианты того как может называться колонка с наименованием компонентов
  FamilyNameCoumn := ';PART;PART NUMBER;';

  if not TDialog.Create.ShowDialog(TExcelFileOpenDialog,
    TSettings.Create.ParametricDataFolder, '', AFileName) then
    Exit; // отказались от выбора файла

  // Сохраняем эту папку в настройках
  TSettings.Create.ParametricDataFolder := TPath.GetDirectoryName(AFileName);

  // Описания полей excel файла
  AParametricErrorTable := TParametricErrorTable.Create(Self);
  AExcelDM := TExcelDM.Create(Self);
  // Загружаем описания полей Excel файла
  ARootTreeNode := AExcelDM.LoadExcelFileHeader(AFileName);
  try
    ARootTreeNode.ClearMaxID;
    AIDList := TList<Integer>.Create;
    try
      // Цикл по всем заголовкам таблицы
      for AStringTreeNode in ARootTreeNode.Childs do
      begin
        AIDList.Clear;

        // Если это первый столбец НАИМЕНОВАНИЕ
        if FamilyNameCoumn.IndexOf(';' + AStringTreeNode.value.ToUpper + ';') >= 0
        then
        begin
          Assert(AStringTreeNode.Childs.Count = 0);
          AIDList.Add(-AStringTreeNode.ID);
          // AFieldsInfo.Add
          // (TFieldInfo.Create(GetNFFieldName(AStringTreeNode.ID)));
          Continue;
        end;

        // Нужно найти такой параметр
        prc := qSearchParameter.SearchMain(AStringTreeNode.value);
        // Цикл по всем подпараметрам
        if AStringTreeNode.Childs.Count > 0 then
        begin
          for AStringTreeNode2 in AStringTreeNode.Childs do
          begin
            // если параметр был найден
            if prc = 1 then
            begin
              // Ищем, есть ли подпараметр с таким именем
              rc := qSubParameters.Search(AStringTreeNode2.value);
              Assert(rc <= 1);
              if rc = 1 then
              begin
                // Ищем, есть ли у нашего параметра такой подпараметр
                rc := qParamSubParams.SearchBySubParam
                  (qSearchParameter.PK.AsInteger, qSubParameters.PK.AsInteger);
                // Если нужно связть параметр с подпараметром
                if rc = 0 then
                  qParamSubParams.AppendSubParameter
                    (qSearchParameter.PK.AsInteger,
                    qSubParameters.PK.AsInteger);

                // Запоминаем описание поля связанного с подпараметром
                AParamSubParamID := qParamSubParams.PK.AsInteger;
              end
              else
              begin
                AParametricErrorTable.AddErrorMessage(AStringTreeNode2.value,
                  'Подпараметр не найден', petSubParamNotFound,
                  AStringTreeNode2.ID);
                AParamSubParamID := -AStringTreeNode2.ID;
              end;
            end
            else // параметр был не найден или дублируется
            begin
              AParamSubParamID := -AStringTreeNode2.ID;
            end;

            // Проверяем, не встечался ли такой подпараметр ранее
            if (AParamSubParamID > 0) and
              (AIDList.IndexOf(AParamSubParamID) >= 0) then
            begin
              AParametricErrorTable.AddErrorMessage(AStringTreeNode.value,
                'Параметр встречается более одного раза', petNotUnique,
                AStringTreeNode.ID);
              AParamSubParamID := -AStringTreeNode.ID;
            end;

            AIDList.Add(AParamSubParamID);
          end;
        end
        else
        begin
          // Если у нашего параметра нет подпараметров
          // Если параметр был найден
          if prc = 1 then
          begin
            // Ищем подпараметр "по умолчанию" для параметра без подпараметров
            qSearchParamDefSubParam.SearchByID
              (qSearchParameter.PK.AsInteger, 1);
            AParamSubParamID :=
              qSearchParamDefSubParam.ParamSubParamID.AsInteger;
          end
          else
          begin
            case prc of
              0:
                AParametricErrorTable.AddErrorMessage(AStringTreeNode.value,
                  'Параметр не найден', petNotFound, AStringTreeNode.ID);
              1:
                ; // Нашли один раз - это хорошо
            else
              AParametricErrorTable.AddErrorMessage(AStringTreeNode.value,
                Format('Параметр найден в справочнике параметров %d раз',
                [prc]), petDuplicate, AStringTreeNode.ID);
            end;

            AParamSubParamID := -AStringTreeNode.ID;
          end;

          // Проверяем, не встечался ли такой подпараметр ранее
          if (AParamSubParamID > 0) and (AIDList.IndexOf(AParamSubParamID) >= 0)
          then
          begin
            AParametricErrorTable.AddErrorMessage(AStringTreeNode.value,
              'Параметр встречается более одного раза', petNotUnique,
              AStringTreeNode.ID);
            AParamSubParamID := -AStringTreeNode.ID;
          end;

          AIDList.Add(AParamSubParamID);
        end;

        // Для всех найденных полей создаём их описания
        for AID in AIDList do
        begin
          // Если этот столбец с ошибкой
          if AID < 0 then
            AFieldName := GetNFFieldName(-AID)
          else
            AFieldName :=
              TParametricExcelTable.GetFieldNameByParamSubParamID(AID);

          AFieldsInfo.Add(TFieldInfo.Create(AFieldName));
        end;
      end;
    finally
      FreeAndNil(AIDList);
    end;

    if AFieldsInfo.Count = 0 then
    begin
      TDialog.Create.ParametricTableNotFound;
      Exit;
    end;

    // Если среди параметров есть ошибки (не найденные)
    OK := AParametricErrorTable.RecordCount = 0;
    if not OK then
    begin
      AfrmParametricTableError := TfrmParametricTableError.Create(Self);
      try
        // AfrmGridView.Caption := 'Ошибки среди параметров';
        AfrmParametricTableError.ViewParametricTableError.DataSet :=
          AParametricErrorTable;
        // Показываем что мы собираемся привязывать
        OK := AfrmParametricTableError.ShowModal = mrOk;
      finally
        FreeAndNil(AfrmParametricTableError);
      end;

      if OK then
      begin
        // Оставляем только то, что исправили
        AParametricErrorTable.FilterFixed;
        AParametricErrorTable.First;
        AFixIDList := TList < TPair < Integer, Integer >>.Create;
        try
          while not AParametricErrorTable.Eof do
          begin
            Assert(AParametricErrorTable.ParameterID.AsInteger > 0);

            // Ищем тот узел в дереве, который вызыал ошибку
            AStringTreeNode := ARootTreeNode.FindByID
              (AParametricErrorTable.StringTreeNodeID.AsInteger);
            Assert(AStringTreeNode <> nil);

            // если есть подпараметры
            if AStringTreeNode.Childs.Count > 0 then
            begin
              // Цикл по всем подпараметрам изначально не найденного параметра
              for AStringTreeNode2 in AStringTreeNode.Childs do
              begin

                // Ищем, есть ли подпараметр с таким именем
                rc := qSubParameters.Search(AStringTreeNode2.value);
                Assert(rc <= 1);
                if rc = 1 then
                begin
                  // Ищем, есть ли у нашего параметра такой подпараметр
                  rc := qParamSubParams.SearchBySubParam
                    (qSearchParameter.PK.AsInteger,
                    qSubParameters.PK.AsInteger);
                  // Если нужно связть параметр с подпараметром
                  if rc = 0 then
                    qParamSubParams.AppendSubParameter
                      (qSearchParameter.PK.AsInteger,
                      qSubParameters.PK.AsInteger);

                  // Запоминаем описание поля связанного с подпараметром
                  AParamSubParamID := qParamSubParams.PK.AsInteger;
                  AFixIDList.Add
                    (TPair<Integer, Integer>.Create(AParamSubParamID,
                    AStringTreeNode2.ID));
                end
              end;
            end
            else
            begin
              // Ищем подпараметр "по умолчанию" для параметра без подпараметров
              qSearchParamDefSubParam.SearchByID
                (AParametricErrorTable.ParameterID.AsInteger, 1);
              AParamSubParamID :=
                qSearchParamDefSubParam.ParamSubParamID.AsInteger;
              AFixIDList.Add(TPair<Integer, Integer>.Create(AParamSubParamID,
                AStringTreeNode.ID));
            end;
            AParametricErrorTable.Next;
          end;
          // Анализируем, что мы пофиксили
          for APair in AFixIDList do
          begin
            // Если такое сочетание параметра-подпараметра уже встречается
            if (AIDList.IndexOf(APair.Key) >= 0) then
              Continue;

            AIDList.Add(APair.Key);
            AFieldName := TParametricExcelTable.GetFieldNameByParamSubParamID
              (APair.Key);

            // Ищем описание этого поля
            AFieldInfo := AFieldsInfo.Find(GetNFFieldName(APair.value));
            Assert(AFieldInfo <> nil);
            // Изменяем имя поля
            AFieldInfo.FieldName := AFieldName;
          end;
        finally
          FreeAndNil(AFixIDList);
        end;
      end;
    end;
  finally
    FreeAndNil(AParametricErrorTable);
    FreeAndNil(ARootTreeNode);
    FreeAndNil(AExcelDM);
  end;
  Result := OK;
end;

procedure TComponentsFrame.LoadParametricData(AFamily: Boolean);
var
  AFieldsInfo: TFieldsInfo;
  AFileName: string;
  AParametricExcelDM: TParametricExcelDM;
begin
  AFieldsInfo := TFieldsInfo.Create();
  try
    if not LoadExcelFileHeader(AFileName, AFieldsInfo) then
      Exit;

    AParametricExcelDM := TParametricExcelDM.Create(Self, AFieldsInfo, AFamily);
    FWriteProgress := TTotalProgress.Create;
    FfrmProgressBar := TfrmProgressBar3.Create(Self);
    try
      TNotifyEventWrap.Create(AParametricExcelDM.AfterLoadSheet,
        DoAfterLoadSheet);
      TNotifyEventWrap.Create(AParametricExcelDM.OnTotalProgress,
        DoOnTotalReadProgress);

      FfrmProgressBar.Show;
      AParametricExcelDM.LoadExcelFile2(AFileName);

      // Обновляем параметры для текущей категории
      DM2.CategoryParametersGroup.RefreshData;
      // Пытаемся обновить параметрическую таблицу
      DM2.ComponentsExGroup.TryRefresh;
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
