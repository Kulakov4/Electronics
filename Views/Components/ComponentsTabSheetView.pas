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
  ProgressBarForm3, ProgressInfo;

type
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
    ViewCategoryParameters: TViewCategoryParameters;
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
    actLoadDocFromExcelDocument: TAction;
    dxBarButton7: TdxBarButton;
    ViewComponents: TViewComponents;
    ViewComponentsSearch: TViewComponentsSearch;
    ViewParametricTable: TViewParametricTable;
    procedure actAutoBindingDescriptionsExecute(Sender: TObject);
    procedure actAutoBindingDocExecute(Sender: TObject);
    procedure actLoadDocFromExcelDocumentExecute(Sender: TObject);
    procedure actLoadFromExcelDocumentExecute(Sender: TObject);
    procedure actLoadFromExcelFolderExecute(Sender: TObject);
    procedure actLoadParametricTableExecute(Sender: TObject);
    procedure actReportExecute(Sender: TObject);
    procedure cxpcComponentsPageChanging(Sender: TObject; NewPage: TcxTabSheet;
      var AllowChange: Boolean);
    procedure cxtsCategoryComponentsShow(Sender: TObject);
    procedure cxtsCategoryParametersShow(Sender: TObject);
    procedure cxtsComponentsSearchShow(Sender: TObject);
  private
    FfrmProgressBar: TfrmProgressBar3;
    FWriteProgress: TTotalProgress;
    procedure DoAfterLoadSheet(ASender: TObject);
    procedure DoOnTotalReadProgress(ASender: TObject);
    function LoadExcelFileHeader(var AFileName: String;
      AFieldsInfo: TList<TFieldInfo>): Boolean;
    procedure TryUpdateWrite0Statistic(API: TProgressInfo);
    procedure TryUpdateWriteStatistic(API: TProgressInfo);
    { Private declarations }
  public
    { Public declarations }
  end;

type
  TParametricErrorTable = class(TCustomErrorTable)
  private
    function GetDescription: TField;
    function GetError: TField;
    function GetParameterName: TField;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AddErrorMessage(const AParameterName: string; AMessage: string);
    property Description: TField read GetDescription;
    property Error: TField read GetError;
    property ParameterName: TField read GetParameterName;
  end;

implementation

{$R *.dfm}

uses RepositoryDataModule, SettingsController, ProducersForm, DialogUnit,
  System.IOUtils, TreeListQuery, ErrorForm, ParametricExcelDataModule,
  ProgressBarForm, ProjectConst, CustomExcelTable, ParameterValuesUnit,
  GridViewForm, ReportQuery, ReportsForm, FireDAC.Comp.Client, AllFamilyQuery,
  AutoBindingDocForm, AutoBinding, AutoBindingDescriptionForm, BindDocUnit,
  SearchParameterQuery, NotifyEvents, CustomErrorForm;

procedure TComponentsFrame.actAutoBindingDescriptionsExecute(Sender: TObject);
var
  AIDCategory: Integer;
  frmAutoBindingDescriptions: TfrmAutoBindingDescriptions;
  MR: Integer;
begin
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
        AFDQuery := ViewComponents.ComponentsGroup.qFamily.FDQuery
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

procedure TComponentsFrame.actLoadDocFromExcelDocumentExecute(Sender: TObject);
var
  AFileName: string;
begin
  AFileName := TDialog.Create.OpenExcelFile
    (TSettings.Create.LastFolderForComponentsLoad);

  if AFileName.IsEmpty then
    Exit; // ���������� �� ������ �����

  // ��������� ��� ����� � ����������
  TSettings.Create.LastFolderForComponentsLoad :=
    TPath.GetDirectoryName(AFileName);

  TBindDoc.LoadDocBindsFromExcelDocument(AFileName);
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
  if not TfrmProducers.TakeProducer(AProducerID, AProducer) then
    Exit;

  AFileName := TDialog.Create.OpenExcelFile
    (TSettings.Create.LastFolderForComponentsLoad);

  if AFileName.IsEmpty then
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
  // �������� �������������
  if not TfrmProducers.TakeProducer(AProducerID, AProducer) then
    Exit;

  AFileName := TDialog.Create.OpenDialog(TExcelFilesFolderOpenDialog,
    TSettings.Create.LastFolderForComponentsLoad);
  if AFileName.IsEmpty then
    Exit;

  AFolderName := TPath.GetDirectoryName(AFileName);

  TSettings.Create.LastFolderForComponentsLoad := AFolderName;

  ViewComponents.LoadFromExcelFolder(AFolderName, AProducer);
end;

procedure TComponentsFrame.actLoadParametricTableExecute(Sender: TObject);
var
  AFieldsInfo: TList<TFieldInfo>;
  AFileName: string;
  AfrmError: TfrmError;
  AParametricExcelDM: TParametricExcelDM;
  OK: Boolean;
begin
  AFieldsInfo := TList<TFieldInfo>.Create();
  try
    if not LoadExcelFileHeader(AFileName, AFieldsInfo) then
      Exit;

    AParametricExcelDM := TParametricExcelDM.Create(Self, AFieldsInfo);
    FWriteProgress := TTotalProgress.Create;
    FfrmProgressBar := TfrmProgressBar3.Create(Self);
    try
      TNotifyEventWrap.Create(AParametricExcelDM.AfterLoadSheet,
        DoAfterLoadSheet);
      TNotifyEventWrap.Create(AParametricExcelDM.OnTotalProgress,
        DoOnTotalReadProgress);

      AParametricExcelDM.LoadExcelFile2(AFileName);
    finally
      FreeAndNil(AParametricExcelDM);
      FreeAndNil(FWriteProgress);
      FreeAndNil(FfrmProgressBar);
    end;
  finally
    FreeAndNil(AFieldsInfo);
  end;

end;

procedure TComponentsFrame.actReportExecute(Sender: TObject);
var
  AQueryReports: TQueryReports;
  frmReports: TfrmReports;
begin
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
  ViewComponents.PostApplyBestFit;
end;

procedure TComponentsFrame.cxtsCategoryParametersShow(Sender: TObject);
begin
  ViewCategoryParameters.ApplyBestFitEx;
end;

procedure TComponentsFrame.cxtsComponentsSearchShow(Sender: TObject);
begin
  ViewComponentsSearch.ApplyBestFitEx;
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
    AfrmError := TfrmError.Create(nil);
    try
      AfrmError.ErrorTable := e.ExcelTable.Errors;
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

function TComponentsFrame.LoadExcelFileHeader(var AFileName: String;
AFieldsInfo: TList<TFieldInfo>): Boolean;
var
  AExcelDM: TExcelDM;
  AFieldName: string;
  AfrmGridView: TfrmGridView;
  AParametricErrorTable: TParametricErrorTable;
  qSearchDaughterParameter: TQuerySearchParameter;
  qSearchParameter: TQuerySearchParameter;
  ARootTreeNode: TStringTreeNode;
  AStringTreeNode: TStringTreeNode;
  AStringTreeNode2: TStringTreeNode;
  I: Integer;
  nf: Boolean;
  OK: Boolean;
  rc: Integer;
  AFieldNames: TList<String>;
begin
  Result := False;
  Assert(AFieldsInfo <> nil);

  AFileName := TDialog.Create.OpenExcelFile
    (TSettings.Create.ParametricDataFolder);

  if AFileName.IsEmpty then
    Exit; // ���������� �� ������ �����

  // ��������� ��� ����� � ����������
  TSettings.Create.ParametricDataFolder := TPath.GetDirectoryName(AFileName);

  // �������� ����� excel �����
  AParametricErrorTable := TParametricErrorTable.Create(Self);
  try

    AExcelDM := TExcelDM.Create(Self);
    try
      // ��������� �������� ����� Excel �����
      ARootTreeNode := AExcelDM.LoadExcelFileHeader(AFileName);
      qSearchParameter := TQuerySearchParameter.Create(nil);
      qSearchDaughterParameter := TQuerySearchParameter.Create(nil);
      try
        I := 0;

        AFieldNames := TList<String>.Create;
        try
          // ���� �� ���� ���������� �������
          for AStringTreeNode in ARootTreeNode.Childs do
          begin
            AFieldNames.Clear;
            nf := AStringTreeNode.value.ToUpper = 'Part'.ToUpper;

            if not nf then
            begin
              // ����� ����� ����� ��������
              rc := qSearchParameter.SearchMain(AStringTreeNode.value);
              if rc = 0 then
                AParametricErrorTable.AddErrorMessage(AStringTreeNode.value,
                  '�������� �� ������');
              if rc > 1 then
                AParametricErrorTable.AddErrorMessage(AStringTreeNode.value,
                  Format('�������� ������ %d ���', [rc]));

              // ���� ����� ����� ���� �������� � �����������
              if rc = 1 then
              begin

                if AStringTreeNode.Childs.Count > 0 then
                begin
                  for AStringTreeNode2 in AStringTreeNode.Childs do
                  begin
                    rc := qSearchDaughterParameter.SearchDaughter
                      (AStringTreeNode2.value, qSearchParameter.PK.AsInteger);
                    if rc > 1 then
                    begin
                      AParametricErrorTable.AddErrorMessage
                        (AStringTreeNode2.value,
                        Format('����������� ������ %d ���', [rc]));
                    end
                    else
                    begin
                      // ���� ������ ��������� ��������� �� �� �����
                      if rc = 0 then
                      begin
                        qSearchDaughterParameter.AppendDaughter
                          (AStringTreeNode2.value);
                      end;
                      // ���������� �������� ���� ���������� � �������������
                      AFieldNames.Add
                        (TParametricExcelTable.GetFieldNameByIDParam
                        (qSearchDaughterParameter.PK.value,
                        qSearchParameter.PK.value))
                    end;
                  end;
                end
                else
                begin
                  // ���� � ������ ��������� ��� �������� ����������
                  // ���������� �������� ���� ���������� � ����������
                  AFieldNames.Add(TParametricExcelTable.GetFieldNameByIDParam
                    (qSearchParameter.PK.value, 0));
                end;
              end
              else
              begin
                nf := True;
              end;
            end;

            if nf then
            begin
              // ������ �������� ���� �� ���������� � ����������
              AFieldNames.Add(Format('NotFoundParam_%d', [I]));
              Inc(I);
            end;

            // ��� ���� ��������� ����� ������ �� ��������
            for AFieldName in AFieldNames do
              AFieldsInfo.Add(TFieldInfo.Create(AFieldName));
          end;
        finally
          FreeAndNil(AFieldNames);
        end;

      finally
        FreeAndNil(qSearchParameter);
        FreeAndNil(qSearchDaughterParameter);
      end;

    finally
      FreeAndNil(AExcelDM);
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
      AfrmGridView := TfrmGridView.Create(Self);
      try
        AfrmGridView.Caption := '������ ����� ����������';
        AfrmGridView.DataSet := AParametricErrorTable;
        // ���������� ��� �� ���������� �����������
        OK := AfrmGridView.ShowModal = mrOk;
      finally
        FreeAndNil(AfrmGridView);
      end;

    end;
  finally
    FreeAndNil(AParametricErrorTable)
  end;
  Result := OK;
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

constructor TParametricErrorTable.Create(AOwner: TComponent);
begin
  inherited;
  FieldDefs.Add('ParameterName', ftString, 100);
  FieldDefs.Add('Error', ftString, 50);
  FieldDefs.Add('Description', ftString, 150);
  CreateDataSet;

  Open;

  ParameterName.DisplayLabel := '��������';
  Description.DisplayLabel := '��������';
  Error.DisplayLabel := '��� ������';
end;

function TParametricErrorTable.GetDescription: TField;
begin
  Result := FieldByName('Description');
end;

function TParametricErrorTable.GetError: TField;
begin
  Result := FieldByName('Error');
end;

function TParametricErrorTable.GetParameterName: TField;
begin
  Result := FieldByName('ParameterName');
end;

procedure TParametricErrorTable.AddErrorMessage(const AParameterName: string;
AMessage: string);
begin
  Assert(Active);

  if not(State in [dsEdit, dsInsert]) then
    Append;

  ParameterName.AsString := AParameterName;
  Error.AsString := ErrorMessage;
  Description.AsString := AMessage;
  Post;
end;

end.
