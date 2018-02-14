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
    // ������� ������ � ������� ���������
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

      // ���� ����������� ������� ���������
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
    Exit; // ���������� �� ������ �����

  // ��������� ��� ����� � ����������
  TSettings.Create.LastFolderForComponentsLoad :=
    TPath.GetDirectoryName(AFileName);

  S := TPath.GetFileNameWithoutExtension(AFileName);

  m := S.Split([' ']);
  if Length(m) = 0 then
  begin
    TDialog.Create.ErrorMessageDialog('��� ����� ������ ��������� ������');
    Exit;
  end;

  try
    // ��������� ��� ������ ����� �������� ������������� ��� ���������
    m[0].ToInteger;
  except
    TDialog.Create.ErrorMessageDialog
      ('� ������ ����� ����� ������ ���� ��� ���������');
    Exit;
  end;

  qTreeList := (ViewComponents.ComponentsGroup.qFamily.Master as
    TQueryTreeList);

  // ��������� � ������ ��������� �� ����������� ���������
  if not qTreeList.LocateByExternalID(m[0]) then
  begin
    TDialog.Create.ErrorMessageDialog(Format('��������� %s �� �������',
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
  // �������� �������������
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
  // ����� ��������� ��������������� ������ ��� ����������� (�� ��������)
  LoadParametricData(False);
end;

procedure TComponentsFrame.actLoadParametricTableExecute(Sender: TObject);
begin
  Application.Hint := '';
  // ����� ��������� ��������������� ������ ��� �������� �����������
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
  // ���� ��������� �� ������� "��������������� �������"
  if (cxpcComponents.ActivePage <> cxtsParametricTable) and
    (NewPage = cxtsParametricTable) then
  begin
    // �������� � ���, ��� ���� ������ ����������� � ��� ���� ��������������
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

  // ���� �������� �������� ������
  if FWriteProgress.PIList.Count = 0 then
    FWriteProgress.Assign(e.TotalProgress);

  OK := e.ExcelTable.Errors.RecordCount = 0;
  // ���� � ���� �������� ������ ��������� ������ (��������� �� ������)
  if not OK then
  begin
    FfrmProgressBar.Hide;
    AfrmError := TfrmCustomError.Create(nil);
    try
      AfrmError.ViewGridEx.DataSet := e.ExcelTable.Errors;
      // ���������� ������
      OK := AfrmError.ShowModal = mrOk;
      if OK then
      begin
        if AfrmError.ContinueType = ctSkip then
          // ������� ������ � �������� � ����������������
          e.ExcelTable.ExcludeErrors(etWarring)
        else
          // ������� ������ � ��������
          e.ExcelTable.ExcludeErrors(etError);
      end;
    finally
      FreeAndNil(AfrmError);
    end;
  end;

  // ���� �� ������������� �������� ��������� ������
  e.Terminate := not OK;

  if not OK then
    Exit;

  FfrmProgressBar.Show;

  // ����� ������� ������� ����� �������� ��� ����������� ���������
  if e.SheetIndex = 1 then
  begin

    // 1 ��������� ��������� � ���������
    e.ExcelTable.Process(
      procedure(ASender: TObject)
      begin
        TParameterValues.LoadParameters(e.ExcelTable as TParametricExcelTable);
      end,

    // ���������� �������
      procedure(ASender: TObject)
      Var
        API: TProgressInfo;
      begin
        API := ASender as TProgressInfo;
        TryUpdateWrite0Statistic(API);
      end);
  end;

  // 2 ��������� �������� ����������
  e.ExcelTable.Process(
    procedure(ASender: TObject)
    begin
      TParameterValues.LoadParameterValues
        (e.ExcelTable as TParametricExcelTable, False);
    end,

  // ���������� �������
    procedure(ASender: TObject)
    Var
      API: TProgressInfo;
    begin
      API := ASender as TProgressInfo;
      // ���������� �������� ������ �����
      FWriteProgress.PIList[e.SheetIndex - 1].Assign(API);
      // ��������� ����� �������� ������
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
    Exit; // ���������� �� ������ �����

  // ��������� ��� ����� � ����������
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

  // �������� ���� ��� ����� ���������� ������� � ������������� �����������
  FamilyNameCoumn := ';PART;PART NUMBER;';

  if not TDialog.Create.ShowDialog(TExcelFileOpenDialog,
    TSettings.Create.ParametricDataFolder, '', AFileName) then
    Exit; // ���������� �� ������ �����

  // ��������� ��� ����� � ����������
  TSettings.Create.ParametricDataFolder := TPath.GetDirectoryName(AFileName);

  // �������� ����� excel �����
  AParametricErrorTable := TParametricErrorTable.Create(Self);
  AExcelDM := TExcelDM.Create(Self);
  // ��������� �������� ����� Excel �����
  ARootTreeNode := AExcelDM.LoadExcelFileHeader(AFileName);
  try
    ARootTreeNode.ClearMaxID;
    AIDList := TList<Integer>.Create;
    try
      // ���� �� ���� ���������� �������
      for AStringTreeNode in ARootTreeNode.Childs do
      begin
        AIDList.Clear;

        // ���� ��� ������ ������� ������������
        if FamilyNameCoumn.IndexOf(';' + AStringTreeNode.value.ToUpper + ';') >= 0
        then
        begin
          Assert(AStringTreeNode.Childs.Count = 0);
          AIDList.Add(-AStringTreeNode.ID);
          // AFieldsInfo.Add
          // (TFieldInfo.Create(GetNFFieldName(AStringTreeNode.ID)));
          Continue;
        end;

        // ����� ����� ����� ��������
        prc := qSearchParameter.SearchMain(AStringTreeNode.value);
        // ���� �� ���� �������������
        if AStringTreeNode.Childs.Count > 0 then
        begin
          for AStringTreeNode2 in AStringTreeNode.Childs do
          begin
            // ���� �������� ��� ������
            if prc = 1 then
            begin
              // ����, ���� �� ����������� � ����� ������
              rc := qSubParameters.Search(AStringTreeNode2.value);
              Assert(rc <= 1);
              if rc = 1 then
              begin
                // ����, ���� �� � ������ ��������� ����� �����������
                rc := qParamSubParams.SearchBySubParam
                  (qSearchParameter.PK.AsInteger, qSubParameters.PK.AsInteger);
                // ���� ����� ������ �������� � �������������
                if rc = 0 then
                  qParamSubParams.AppendSubParameter
                    (qSearchParameter.PK.AsInteger,
                    qSubParameters.PK.AsInteger);

                // ���������� �������� ���� ���������� � �������������
                AParamSubParamID := qParamSubParams.PK.AsInteger;
              end
              else
              begin
                AParametricErrorTable.AddErrorMessage(AStringTreeNode2.value,
                  '����������� �� ������', petSubParamNotFound,
                  AStringTreeNode2.ID);
                AParamSubParamID := -AStringTreeNode2.ID;
              end;
            end
            else // �������� ��� �� ������ ��� �����������
            begin
              AParamSubParamID := -AStringTreeNode2.ID;
            end;

            // ���������, �� ��������� �� ����� ����������� �����
            if (AParamSubParamID > 0) and
              (AIDList.IndexOf(AParamSubParamID) >= 0) then
            begin
              AParametricErrorTable.AddErrorMessage(AStringTreeNode.value,
                '�������� ����������� ����� ������ ����', petNotUnique,
                AStringTreeNode.ID);
              AParamSubParamID := -AStringTreeNode.ID;
            end;

            AIDList.Add(AParamSubParamID);
          end;
        end
        else
        begin
          // ���� � ������ ��������� ��� �������������
          // ���� �������� ��� ������
          if prc = 1 then
          begin
            // ���� ����������� "�� ���������" ��� ��������� ��� �������������
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
                  '�������� �� ������', petNotFound, AStringTreeNode.ID);
              1:
                ; // ����� ���� ��� - ��� ������
            else
              AParametricErrorTable.AddErrorMessage(AStringTreeNode.value,
                Format('�������� ������ � ����������� ���������� %d ���',
                [prc]), petDuplicate, AStringTreeNode.ID);
            end;

            AParamSubParamID := -AStringTreeNode.ID;
          end;

          // ���������, �� ��������� �� ����� ����������� �����
          if (AParamSubParamID > 0) and (AIDList.IndexOf(AParamSubParamID) >= 0)
          then
          begin
            AParametricErrorTable.AddErrorMessage(AStringTreeNode.value,
              '�������� ����������� ����� ������ ����', petNotUnique,
              AStringTreeNode.ID);
            AParamSubParamID := -AStringTreeNode.ID;
          end;

          AIDList.Add(AParamSubParamID);
        end;

        // ��� ���� ��������� ����� ������ �� ��������
        for AID in AIDList do
        begin
          // ���� ���� ������� � �������
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

    // ���� ����� ���������� ���� ������ (�� ���������)
    OK := AParametricErrorTable.RecordCount = 0;
    if not OK then
    begin
      AfrmParametricTableError := TfrmParametricTableError.Create(Self);
      try
        // AfrmGridView.Caption := '������ ����� ����������';
        AfrmParametricTableError.ViewParametricTableError.DataSet :=
          AParametricErrorTable;
        // ���������� ��� �� ���������� �����������
        OK := AfrmParametricTableError.ShowModal = mrOk;
      finally
        FreeAndNil(AfrmParametricTableError);
      end;

      if OK then
      begin
        // ��������� ������ ��, ��� ���������
        AParametricErrorTable.FilterFixed;
        AParametricErrorTable.First;
        AFixIDList := TList < TPair < Integer, Integer >>.Create;
        try
          while not AParametricErrorTable.Eof do
          begin
            Assert(AParametricErrorTable.ParameterID.AsInteger > 0);

            // ���� ��� ���� � ������, ������� ������ ������
            AStringTreeNode := ARootTreeNode.FindByID
              (AParametricErrorTable.StringTreeNodeID.AsInteger);
            Assert(AStringTreeNode <> nil);

            // ���� ���� ������������
            if AStringTreeNode.Childs.Count > 0 then
            begin
              // ���� �� ���� ������������� ���������� �� ���������� ���������
              for AStringTreeNode2 in AStringTreeNode.Childs do
              begin

                // ����, ���� �� ����������� � ����� ������
                rc := qSubParameters.Search(AStringTreeNode2.value);
                Assert(rc <= 1);
                if rc = 1 then
                begin
                  // ����, ���� �� � ������ ��������� ����� �����������
                  rc := qParamSubParams.SearchBySubParam
                    (qSearchParameter.PK.AsInteger,
                    qSubParameters.PK.AsInteger);
                  // ���� ����� ������ �������� � �������������
                  if rc = 0 then
                    qParamSubParams.AppendSubParameter
                      (qSearchParameter.PK.AsInteger,
                      qSubParameters.PK.AsInteger);

                  // ���������� �������� ���� ���������� � �������������
                  AParamSubParamID := qParamSubParams.PK.AsInteger;
                  AFixIDList.Add
                    (TPair<Integer, Integer>.Create(AParamSubParamID,
                    AStringTreeNode2.ID));
                end
              end;
            end
            else
            begin
              // ���� ����������� "�� ���������" ��� ��������� ��� �������������
              qSearchParamDefSubParam.SearchByID
                (AParametricErrorTable.ParameterID.AsInteger, 1);
              AParamSubParamID :=
                qSearchParamDefSubParam.ParamSubParamID.AsInteger;
              AFixIDList.Add(TPair<Integer, Integer>.Create(AParamSubParamID,
                AStringTreeNode.ID));
            end;
            AParametricErrorTable.Next;
          end;
          // �����������, ��� �� ���������
          for APair in AFixIDList do
          begin
            // ���� ����� ��������� ���������-������������ ��� �����������
            if (AIDList.IndexOf(APair.Key) >= 0) then
              Continue;

            AIDList.Add(APair.Key);
            AFieldName := TParametricExcelTable.GetFieldNameByParamSubParamID
              (APair.Key);

            // ���� �������� ����� ����
            AFieldInfo := AFieldsInfo.Find(GetNFFieldName(APair.value));
            Assert(AFieldInfo <> nil);
            // �������� ��� ����
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

      // ��������� ��������� ��� ������� ���������
      DM2.CategoryParametersGroup.RefreshData;
      // �������� �������� ��������������� �������
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
    // ���������� ����� �������� ������
    FfrmProgressBar.UpdateWriteStatistic0(API);
end;

procedure TComponentsFrame.TryUpdateWriteStatistic(API: TProgressInfo);
begin
  if (API.ProcessRecords mod OnWriteProcessEventRecordCount = 0) or
    (API.ProcessRecords = API.TotalRecords) then
    // ���������� ����� �������� ������
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
