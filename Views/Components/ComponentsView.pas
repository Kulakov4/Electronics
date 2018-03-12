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
  cxGridCustomView, cxGrid, ComponentsGroupUnit, cxGridCustomPopupMenu,
  cxGridPopupMenu, Vcl.Menus, ExcelDataModule, DocFieldInfo, ProgressBarForm,
  System.Contnrs, CustomExcelTable, NotifyEvents, dxSkinsCore, dxSkinBlack,
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
  System.Generics.Collections, CustomComponentsQuery,
  cxTextEdit, cxBlobEdit;

{$WARN UNIT_PLATFORM OFF}

type
  TViewComponents = class(TViewComponentsBase)
    dxbrsbtmAdd: TdxBarSubItem;
    dxbrbtnAddFamily: TdxBarButton;
    dxbrbtnAddComponent: TdxBarButton;
    dxbrsbtmDelete: TdxBarSubItem;
    dxbrbtnDeleteMain: TdxBarButton;
    dxbrbtnDeleteFromAllCategories: TdxBarButton;
    dxbrbtnApply: TdxBarButton;
    dxbrbtnPasteFromBuffer: TdxBarButton;
    actShowParametricTable: TAction;
    dxbrbtnParametricTable: TdxBarButton;
    dxbb1: TdxBarButton;
    dxbrsbtmLoad: TdxBarSubItem;
    dxbbLoadSpecifications: TdxBarButton;
    dxbrbtnLoadImages: TdxBarButton;
    dxbrbtnLoadSchemes: TdxBarButton;
    dxbrbtnLoadDrawings: TdxBarButton;
    dxbbParametricTable: TdxBarButton;
    dxbbSettings: TdxBarButton;
    dxBarButton3: TdxBarButton;
    actRefresh: TAction;
    dxBarManagerBar1: TdxBar;
    dxBarButton1: TdxBarButton;
    procedure actRefreshExecute(Sender: TObject);
    procedure actShowParametricTableExecute(Sender: TObject);
    procedure cxGridDBBandedTableViewSelectionChanged
      (Sender: TcxCustomGridTableView);
    procedure dxBarButton2Click(Sender: TObject);
  private
    FCountEvents: TObjectList;
    FOnShowParametricTableEvent: TNotifyEventsEx;
    procedure DoOnUpdateComponentslCount(Sender: TObject);
    procedure DoOnUpdateFamilyCount(Sender: TObject);
    function GetComponentsGroup: TComponentsGroup;
    procedure SetComponentsGroup(const Value: TComponentsGroup);
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
    procedure LoadFromExcelDocument(const AFileName, AProducer: string);
    procedure LoadFromExcelFolder(const AFolderName, AProducer: string);
    property ComponentsGroup: TComponentsGroup read GetComponentsGroup
      write SetComponentsGroup;
    property OnShowParametricTableEvent: TNotifyEventsEx
      read FOnShowParametricTableEvent;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses RepositoryDataModule, ComponentsExcelDataModule, ImportErrorForm,
  DialogUnit, Vcl.Clipbrd, SettingsController, Vcl.FileCtrl, System.IOUtils,
  System.Types, ProgressInfo, System.Math, ErrorTable, FireDAC.Comp.DataSet,
  ImportProcessForm, ProjectConst, CustomErrorForm, LoadFromExcelFileHelper;

constructor TViewComponents.Create(AOwner: TComponent);
begin
  inherited;

  FCountEvents := TObjectList.Create;

  // Событие о отображении формы с параметрической таблицей
  FOnShowParametricTableEvent := TNotifyEventsEx.Create(Self);

  StatusBarEmptyPanelIndex := 3;
end;

destructor TViewComponents.Destroy;
begin
  FreeAndNil(FCountEvents);
  inherited;
end;

procedure TViewComponents.actRefreshExecute(Sender: TObject);
begin
  inherited;
  RefreshData;
end;

procedure TViewComponents.actShowParametricTableExecute(Sender: TObject);
begin
  CheckAndSaveChanges;

  FOnShowParametricTableEvent.CallEventHandlers(Self);

  UpdateView;
end;

procedure TViewComponents.DoOnUpdateComponentslCount(Sender: TObject);
begin
  // Выводим кол-во дочерних наименований
  StatusBar.Panels[1].Text :=
    Format('%d', [ComponentsGroup.qComponents.FDQuery.RecordCount]);
end;

procedure TViewComponents.DoOnUpdateFamilyCount(Sender: TObject);
begin
  if ComponentsGroup.qFamily.FDQuery.State = dsBrowse then
  begin
    // Выводим кол-во родительских наименований
    StatusBar.Panels[0].Text :=
      Format('%d', [ComponentsGroup.qFamily.FDQuery.RecordCount]);

    UpdateTotalComponentCount;
  end;
end;

procedure TViewComponents.dxBarButton2Click(Sender: TObject);
(*
var
  ABand: TcxGridBand;
  AColumn: TcxGridDBBandedColumn;
  AView: TcxGridDBBandedTableView;
  I: Integer;
  w1: Integer;
  w2: Integer;
  S: String;
  x: Integer;
*)
begin
  inherited;
(*


  S := '';

  AView := MainView;

  for I := 0 to AView.Bands.Count - 1 do
  begin
    ABand := AView.Bands[i];
    if not ABand.Visible then
      Continue;

    S := Format('%s'#13#10'%d', [S, ABand.Index]);
    S := Format('%s, Width1 = %d', [S, AView.ViewInfo.HeaderViewInfo.BandsViewInfo.Items[ABand.VisibleIndex].Width]);
    S := Format('%s, Width2 = %d', [S, ABand.Width]);
  end;


{
  for I := 0 to AView.VisibleColumnCount - 1 do
  begin
    AColumn := AView.VisibleColumns[i] as TcxGridDBBandedColumn;
    S := Format('%s'#13#10'%s', [S, AColumn.DataBinding.FieldName]);
    S := Format('%s, Width1 = %d', [S, AView.ViewInfo.HeaderViewInfo.Items[AColumn.VisibleIndex].Width]);
    S := Format('%s, Width2 = %d', [S, AView.GetColumnByFieldName(AColumn.DataBinding.FieldName).Width]);
  end;
}
  S := S.Trim([#13, #10]);

  AView := cxGridDBBandedTableView2;

  for I := 0 to AView.Bands.Count - 1 do
  begin
    ABand := AView.Bands[i];
    if not ABand.Visible then
      Continue;

    S := Format('%s'#13#10'%d', [S, ABand.Index]);
//    S := Format('%s, Width1 = %d', [S, AView.ViewInfo.HeaderViewInfo.BandsViewInfo.Items[ABand.VisibleIndex].Width]);
    S := Format('%s, Width2 = %d', [S, ABand.Width]);
  end;

{
  x := AView.ViewInfo.HeaderViewInfo.Count;
  if x > 0 then Exit;


  for I := 0 to AView.VisibleColumnCount - 1 do
  begin
    AColumn := AView.VisibleColumns[i] as TcxGridDBBandedColumn;
    S := Format('%s'#13#10'%s', [S, AColumn.DataBinding.FieldName]);
//    S := Format('%s, Width1 = %d', [S, AView.ViewInfo.HeaderViewInfo.Items[AColumn.VisibleIndex].Width]);
    S := Format('%s, Width2 = %d', [S, AView.GetColumnByFieldName(AColumn.DataBinding.FieldName).Width]);
  end;
}
  S := S.Trim([#13, #10]);

  ShowMessage(S);

//  w1 := AView.GetColumnByFieldName(clSubGroup.DataBinding.FieldName).Width;
//  w2 := clSubGroup2.Width;
//  dxBarButton2.Caption := Format('%s', [S]);
*)
end;

procedure TViewComponents.BeginUpdate;
begin
  // Отписываемся от событий о смене кол-ва
  if UpdateCount = 0 then
    FCountEvents.Clear;

  inherited;
end;

procedure TViewComponents.CreateCountEvents;
begin
  // Подписываемся на события чтобы отслеживать кол-во
  TNotifyEventWrap.Create(ComponentsGroup.qFamily.AfterPost,
    DoOnUpdateFamilyCount, FCountEvents);

  TNotifyEventWrap.Create(ComponentsGroup.qFamily.AfterOpen,
    DoOnUpdateFamilyCount, FCountEvents);

  TNotifyEventWrap.Create(ComponentsGroup.qFamily.AfterDelete,
    DoOnUpdateFamilyCount, FCountEvents);

  TNotifyEventWrap.Create(ComponentsGroup.qComponents.AfterPost,
    DoOnUpdateComponentslCount, FCountEvents);

  TNotifyEventWrap.Create(ComponentsGroup.qComponents.AfterOpen,
    DoOnUpdateComponentslCount);

  TNotifyEventWrap.Create(ComponentsGroup.qComponents.AfterDelete,
    DoOnUpdateComponentslCount, FCountEvents);

  DoOnUpdateComponentslCount(nil);
  DoOnUpdateFamilyCount(nil);
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
  if UpdateCount = 0 then
    CreateCountEvents;
end;

function TViewComponents.GetComponentsGroup: TComponentsGroup;
begin
  Result := BaseComponentsGroup as TComponentsGroup;
end;

procedure TViewComponents.LoadFromExcelDocument(const AFileName,
  AProducer: string);
begin
  Assert(not AFileName.IsEmpty);
  Assert(not AProducer.IsEmpty);

  BeginUpdate;
  try
    TLoad.Create.LoadAndProcess(AFileName, TComponentsExcelDM, TfrmImportError,
      procedure(ASender: TObject)
      begin
        ComponentsGroup.LoadDataFromExcelTable(ASender as TComponentsExcelTable,
          AProducer);
      end);
  finally
    EndUpdate;
  end;

  UpdateView;
end;

procedure TViewComponents.LoadFromExcelFolder(const AFolderName,
  AProducer: string);
var
  AFileName: string;
  AFileNames: TList<String>;
  AutomaticLoadErrorTable: TAutomaticLoadErrorTable;
  i: Integer;
  m: TStringDynArray;
  S: string;
begin
  Assert(not AFolderName.IsEmpty);
  Assert(not AProducer.IsEmpty);

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
      AutomaticLoadErrorTable.LocateOrAppendData(S, NULL, '', '', '');
    end;
    AutomaticLoadErrorTable.First;

    if frmImportProcess <> nil then
      FreeAndNil(frmImportProcess);

    frmImportProcess := TfrmImportProcess.Create(Self);
    frmImportProcess.Caption := 'Загрузка компонентов';
    frmImportProcess.ViewGridEx.DataSet := AutomaticLoadErrorTable;
    frmImportProcess.ViewGridEx.ApplyBestFitOnUpdateData := True;
    // Показываем отчёт
    frmImportProcess.Show;

    Application.ProcessMessages;

    BeginUpdate; // Замораживаем представление
    try
      ComponentsGroup.LoadFromExcelFolder(AFileNames, AutomaticLoadErrorTable,
        AProducer);
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

procedure TViewComponents.SetComponentsGroup(const Value: TComponentsGroup);
begin
  if BaseComponentsGroup <> Value then
  begin
    BaseComponentsGroup := Value;

    if BaseComponentsGroup <> nil then
    begin
      if UpdateCount = 0 then
        CreateCountEvents;
    end;
  end;
end;

procedure TViewComponents.UpdateSelectedCount;
begin
  if UpdateCount = 0 then

    StatusBar.Panels[2].Text :=
      Format('%d', [MainView.DataController.GetSelectedCount]);
end;

procedure TViewComponents.UpdateTotalComponentCount;
begin
  // Общее число компонентов на в БД
  StatusBar.Panels[4].Text := Format('Всего: %d', [ComponentsGroup.TotalCount]);
end;

end.
