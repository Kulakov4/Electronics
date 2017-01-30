unit BodyTypesTreeView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls,
  cxLookAndFeels,
  cxLookAndFeelPainters, cxCustomData, cxStyles, cxTL, cxTLdxBarBuiltInMenu,
  cxInplaceContainer, cxTLData,
  cxDBTL, BodyTypesTreeQuery, cxMaskEdit, cxClasses, dxBar, System.Actions,
  Vcl.ActnList, Vcl.Grids, Vcl.DBGrids, cxButtonEdit, cxEdit,
  cxEditRepositoryItems, cxGridDBBandedTableView, Data.DB, dxSkinsCore,
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
  dxSkinSummer2008, dxSkinTheAsphaltWorld, dxSkinsDefaultPainters,
  dxSkinValentine, dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, dxSkinsdxBarPainter;

type
  TViewBodyTypesTree = class(TFrame)
    cxDBTreeList: TcxDBTreeList;
    lcOutlineDrawing: TcxDBTreeListColumn;
    lcLandPattern: TcxDBTreeListColumn;
    lcVariation: TcxDBTreeListColumn;
    lcImage: TcxDBTreeListColumn;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    dxbrbtnApplyBestFit: TdxBarButton;
    ActionList: TActionList;
    actApplyBestFit: TAction;
    actAddRoot: TAction;
    actAddBodyType: TAction;
    dxbrbtnAddBodyType: TdxBarButton;
    lcID: TcxDBTreeListColumn;
    actAddBodyVariation: TAction;
    dxbrbtnAddBodyVariation: TdxBarButton;
    actDrop: TAction;
    dxbrbtnDrop: TdxBarButton;
    lcLevel: TcxDBTreeListColumn;
    actLoadFromExcelDocument: TAction;
    dxbrsbtmExportImport: TdxBarSubItem;
    dxbrbtnLoadFromExcelDocument: TdxBarButton;
    dxbbCommit: TdxBarButton;
    cxEditRepository: TcxEditRepository;
    cxEditRepositoryButtonItem1: TcxEditRepositoryButtonItem;
    cxEditRepositoryTextItem1: TcxEditRepositoryTextItem;
    actExportToExcelDocument: TAction;
    dxbbExportToExcel: TdxBarButton;
    actCommit: TAction;
    actRollback: TAction;
    dxbbRollback: TdxBarButton;
    procedure actAddBodyTypeExecute(Sender: TObject);
    procedure actAddBodyVariationExecute(Sender: TObject);
    procedure actAddRootExecute(Sender: TObject);
    procedure actApplyBestFitExecute(Sender: TObject);
    procedure actCommitExecute(Sender: TObject);
    procedure actDropExecute(Sender: TObject);
    procedure actExportToExcelDocumentExecute(Sender: TObject);
    procedure actLoadFromExcelDocumentExecute(Sender: TObject);
    procedure actRollbackExecute(Sender: TObject);
    procedure cxDBTreeListChange(Sender: TObject);
    procedure cxDBTreeListEdited(Sender: TcxCustomTreeList;
      AColumn: TcxTreeListColumn);
    procedure cxDBTreeListEditing(Sender: TcxCustomTreeList;
      AColumn: TcxTreeListColumn; var Allow: Boolean);
    procedure cxDBTreeListIsGroupNode(Sender: TcxCustomTreeList;
      ANode: TcxTreeListNode; var IsGroup: Boolean);
    procedure cxDBTreeListKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lcOutlineDrawingGetEditProperties(Sender: TcxTreeListColumn;
      ANode: TcxTreeListNode; var EditProperties: TcxCustomEditProperties);
    procedure cxEditRepositoryButtonItem1PropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure lcLandPatternPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure lcImagePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
  private
    FQueryBodyTypesTree: TQueryBodyTypesTree;
    procedure DeleteSelected;
    function GetFocusedLevel: Integer;
    function GetFocusedNode: TcxDBTreeListNode;
    procedure SetQueryBodyTypesTree(const Value: TQueryBodyTypesTree);
    { Private declarations }
  protected
    procedure DoOnDataChange(Sender: TObject);
    function IsGroupNode(ANode: TcxTreeListNode): Boolean;
    procedure MySyncData(ANode: TcxDBTreeListNode);
    property FocusedLevel: Integer read GetFocusedLevel;
    property FocusedNode: TcxDBTreeListNode read GetFocusedNode;
  public
    procedure CollapseAll;
    procedure ExportViewToExcel(ADataSource: TDataSource; AFileName: string);
    procedure UpdateView;
    property QueryBodyTypesTree: TQueryBodyTypesTree read FQueryBodyTypesTree
      write SetQueryBodyTypesTree;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses RepositoryDataModule, NotifyEvents, SplashXP, BodyTypesExcelDataModule3,
  ImportErrorForm, DialogUnit, CustomExcelTable, System.Generics.Collections, System.Math, FireDAC.Comp.Client,
  OpenDocumentUnit, ProjectConst, cxGrid, cxGridLevel, BodyTypesGridQuery,
  cxGridExportLink, BodyTypesGridView, SettingsController, System.IOUtils;

procedure TViewBodyTypesTree.actAddBodyTypeExecute(Sender: TObject);
var
  AIDParent: Integer;
  // ALevel: Integer;
  V: Variant;
begin
  QueryBodyTypesTree.TryPost;
  V := FocusedNode.Values[lcLevel.Position.ColIndex];
  if VarIsNull(V) then
    Exit;
  // ALevel := V;

  // if ALevel = 0 then
  AIDParent := FocusedNode.KeyValue;
  // else
  // AIDParent := FocusedNode.ParentKeyValue;

  QueryBodyTypesTree.AddNode(AIDParent);
end;

procedure TViewBodyTypesTree.actAddBodyVariationExecute(Sender: TObject);
var
  AIDParent: Integer;
  ALevel: Integer;
  V: Variant;
begin
  Assert(FocusedNode <> nil);
  V := FocusedNode.Values[lcLevel.Position.ColIndex];
  Assert(not VarIsNull(V));
  ALevel := V;
  if ALevel = 100 then
    AIDParent := FocusedNode.ParentKeyValue
  else
    AIDParent := FocusedNode.KeyValue;

  QueryBodyTypesTree.AddVariation(AIDParent);
end;

procedure TViewBodyTypesTree.actAddRootExecute(Sender: TObject);
begin
  QueryBodyTypesTree.AddRoot;
  // cxDBTreeList.SetFocus;
end;

procedure TViewBodyTypesTree.actApplyBestFitExecute(Sender: TObject);
begin
  cxDBTreeList.ApplyBestFit;
end;

procedure TViewBodyTypesTree.actCommitExecute(Sender: TObject);
begin
  cxDBTreeList.BeginUpdate();
  try
    // Сохраняем изменения и завершаем транзакцию
    QueryBodyTypesTree.ApplyUpdates;

    // Начинаем новую транзакцию
    // QueryBodyTypesTree.FDQuery.Connection.StartTransaction;

  finally
    cxDBTreeList.EndUpdate;
  end;

  // Обновляем представление
  UpdateView;
end;

procedure TViewBodyTypesTree.actDropExecute(Sender: TObject);
begin
  if TDialog.Create.DeleteRecordsDialog('Удалить выделенные корпуса?') then
    DeleteSelected;
end;

procedure TViewBodyTypesTree.actExportToExcelDocumentExecute(Sender: TObject);
var
  AQueryBodyTypesGrid: TQueryBodyTypesGrid;
  AViewBodyTypesGrid: TViewBodyTypesGrid;
  // AQueryBodyTypesExport: TQueryBodyTypesExport;
begin
  // Создаём запрос выбирающий данные в виде таблицы
  AQueryBodyTypesGrid := TQueryBodyTypesGrid.Create(Self);
  try
    AQueryBodyTypesGrid.FDQuery.Open();

    // Создаём представление данных в виде таблицы
    AViewBodyTypesGrid := TViewBodyTypesGrid.Create(Self);
    try
      AViewBodyTypesGrid.QueryBodyTypesGrid := AQueryBodyTypesGrid;

      // Экспортируем представление в документ Excel
      AViewBodyTypesGrid.actExportToExcelDocument.Execute;
    finally
      FreeAndNil(AViewBodyTypesGrid);
    end;
  finally
    FreeAndNil(AQueryBodyTypesGrid);
  end;
end;

procedure TViewBodyTypesTree.actLoadFromExcelDocumentExecute(Sender: TObject);
var
  ABodyTypesExcelDM: TBodyTypesExcelDM3;
  AFileName: string;
  AfrmImportError: TfrmImportError;
  OK: Boolean;
begin

  AFileName := TDialog.Create.OpenExcelFile
    (TSettings.Create.LastFolderForExcelFile);

  if AFileName.IsEmpty then
    Exit; // отказались от выбора файла

  // Сохраняем эту папку в настройках
  TSettings.Create.LastFolderForExcelFile := TPath.GetDirectoryName(AFileName);

  ABodyTypesExcelDM := TBodyTypesExcelDM3.Create(Self);
  try
    MessageForm.Show(sLoading, sWaitExcelLoading);
    try
      ABodyTypesExcelDM.ExcelTable.BodyVariationsDataSet :=
        QueryBodyTypesTree.FDQuery;
      ABodyTypesExcelDM.LoadExcelFile(AFileName);
    finally
      MessageForm.Close;
    end;

    OK := ABodyTypesExcelDM.ExcelTable.Errors.RecordCount = 0;

    if not OK then
    begin
      AfrmImportError := TfrmImportError.Create(Self);
      try
        AfrmImportError.ErrorTable := ABodyTypesExcelDM.ExcelTable.Errors;
        OK := AfrmImportError.ShowModal = mrOk;
        if OK then
        begin
          if AfrmImportError.ContinueType = ctSkip then
          begin
            // Убираем записи с ошибками и предупреждениями
            ABodyTypesExcelDM.ExcelTable.ExcludeErrors(etWarring);
          end
          else
          begin
            // Убираем все записи с ошибками
            ABodyTypesExcelDM.ExcelTable.ExcludeErrors(etError);
          end;
        end;
      finally
        FreeAndNil(AfrmImportError);
      end;
    end;

    if OK then
    begin
      cxDBTreeList.BeginUpdate;
      MessageForm.Show(sLoading, sForming);
      try
        QueryBodyTypesTree.InsertRecordList(ABodyTypesExcelDM.ExcelTable);
      finally
        MessageForm.Close;
        cxDBTreeList.EndUpdate;
      end;
    end;
  finally
    FreeAndNil(ABodyTypesExcelDM);
  end;
  CollapseAll;
  UpdateView;
end;

procedure TViewBodyTypesTree.actRollbackExecute(Sender: TObject);
begin
  cxDBTreeList.BeginUpdate();
  try
    // Отменяем все сделанные изменения
    QueryBodyTypesTree.CancelUpdates;

    // Начинаем новую транзакцию
    // QueryBodyTypesTree.FDQuery.Connection.StartTransaction;

  finally
    cxDBTreeList.EndUpdate;
  end;

  // Обновляем представление
  UpdateView;
end;

procedure TViewBodyTypesTree.CollapseAll;
begin
  if Assigned(cxDBTreeList.Root) then
    cxDBTreeList.Root.Collapse(True);
end;

procedure TViewBodyTypesTree.cxDBTreeListChange(Sender: TObject);
begin
  // UpdateView;
end;

procedure TViewBodyTypesTree.cxDBTreeListEdited(Sender: TcxCustomTreeList;
  AColumn: TcxTreeListColumn);
begin;
end;

procedure TViewBodyTypesTree.cxDBTreeListEditing(Sender: TcxCustomTreeList;
  AColumn: TcxTreeListColumn; var Allow: Boolean);
begin
  MySyncData(Sender.FocusedNode as TcxDBTreeListNode);
end;

procedure TViewBodyTypesTree.cxDBTreeListIsGroupNode(Sender: TcxCustomTreeList;
  ANode: TcxTreeListNode; var IsGroup: Boolean);
begin
  IsGroup := IsGroupNode(ANode);
end;

procedure TViewBodyTypesTree.cxDBTreeListKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 13 then
    QueryBodyTypesTree.TryPost;
end;

procedure TViewBodyTypesTree.cxEditRepositoryButtonItem1PropertiesButtonClick
  (Sender: TObject; AButtonIndex: Integer);
begin
  TDocument.Create.Open(Handle, TSettings.Create.BodyTypesOutlineDrawingFolder,
    QueryBodyTypesTree.OutlineDrawing.AsString,
    'Файл чертежа корпуса с именем %s не найден', 'Чертёж корпуса не задан',
    sBodyTypesFilesExt);
end;

procedure TViewBodyTypesTree.DeleteSelected;
var
  I: Integer;
  kv: Variant;
  AList: TList<Variant>;
begin
  if cxDBTreeList.SelectionCount = 0 then
    Exit;

  AList := TList<Variant>.Create;
  try
    for I := 0 to cxDBTreeList.SelectionCount - 1 do
    begin
      kv := (cxDBTreeList.Selections[I] as TcxDBTreeListNode).KeyValue;
      if not VarIsNull(kv) then
        AList.Add(kv);
    end;
    cxDBTreeList.BeginUpdate;
    try
      QueryBodyTypesTree.DeleteList(AList);
    finally
      cxDBTreeList.EndUpdate;
    end;
  finally
    FreeAndNil(AList);
  end;
end;

procedure TViewBodyTypesTree.DoOnDataChange(Sender: TObject);
begin
  UpdateView;
end;

procedure TViewBodyTypesTree.ExportViewToExcel(ADataSource: TDataSource;
  AFileName: string);
var
  Grid: TcxGrid;
  Level: TcxGridLevel;
  View: TcxGridDBBandedTableView;
begin
  Assert(not AFileName.IsEmpty);

  Grid := TcxGrid.Create(Self);
  Level := Grid.Levels.Add;
  View := Grid.CreateView(TcxGridDBBandedTableView) as TcxGridDBBandedTableView;
  View.DataController.DataSource := ADataSource;
  View.DataController.CreateAllItems();
  View.OptionsView.Footer := False; // Футер экспортировать не будем

  // Фильтруем так-же как у образца
  // CreateFilterForExport(View, ADataSource);

  // Делаем скрытый грид такой-же по размерам как и наш
  Grid.Width := cxDBTreeList.Width;
  Grid.Height := cxDBTreeList.Height;
  // Выставляем тот-же шрифт
  Grid.Font.Assign(Font);

  Level.GridView := View;

  // Экспортируем в Excel
  ExportGridToExcel(AFileName, Grid);

  FreeAndNil(View);
  FreeAndNil(Grid);
end;

function TViewBodyTypesTree.GetFocusedLevel: Integer;
var
  V: Variant;
begin
  if FocusedNode <> nil then
  begin
    V := FocusedNode.Values[lcLevel.Position.ColIndex];
    if VarIsNull(V) then
      Result := 0
    else
      Result := V;
  end
  else
    Result := -1;
end;

function TViewBodyTypesTree.GetFocusedNode: TcxDBTreeListNode;
begin
  if Assigned(cxDBTreeList.FocusedNode) then
    Result := cxDBTreeList.FocusedNode as TcxDBTreeListNode
  else
    Result := nil;
end;

function TViewBodyTypesTree.IsGroupNode(ANode: TcxTreeListNode): Boolean;
var
  V: Variant;
begin
  V := (ANode as TcxDBTreeListNode).Values[lcLevel.Position.ColIndex];
  Result := VarIsNull(V) or (V < 100);
end;

procedure TViewBodyTypesTree.lcImagePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  TDocument.Create.Open(Handle, TSettings.Create.BodyTypesImageFolder,
    QueryBodyTypesTree.Image.AsString,
    'Файл изображения корпуса с именем %s не найден',
    'Файл изображения корпуса не задан', sBodyTypesFilesExt);
end;

procedure TViewBodyTypesTree.lcLandPatternPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  TDocument.Create.Open(Handle, TSettings.Create.BodyTypesLandPatternFolder,
    QueryBodyTypesTree.LandPattern.AsString,
    'Файл чертежа посадочной площадки корпуса с именем %s не найден',
    'Чертёж посадочной площадки корпуса не задан', sBodyTypesFilesExt);
end;

procedure TViewBodyTypesTree.lcOutlineDrawingGetEditProperties
  (Sender: TcxTreeListColumn; ANode: TcxTreeListNode;
  var EditProperties: TcxCustomEditProperties);
begin
  if ANode = nil then
    Exit;

  if IsGroupNode(ANode) then
  begin
    EditProperties := cxEditRepositoryTextItem1.Properties
  end
  else
  begin
    EditProperties := cxEditRepositoryButtonItem1.Properties
  end;
end;

procedure TViewBodyTypesTree.MySyncData(ANode: TcxDBTreeListNode);
begin
  // if (not VarIsNull(ANode.KeyValue)) and (QueryBodyTypesTree.PKValue <>  ANode.KeyValue) then
  // QueryBodyTypesTree.LocateByPK(ANode.KeyValue);
end;

procedure TViewBodyTypesTree.SetQueryBodyTypesTree
  (const Value: TQueryBodyTypesTree);
begin
  if FQueryBodyTypesTree <> Value then
  begin
    FQueryBodyTypesTree := Value;
    if FQueryBodyTypesTree <> nil then
    begin
      cxDBTreeList.DataController.DataSource := FQueryBodyTypesTree.DataSource;
      cxDBTreeList.DataController.KeyField := FQueryBodyTypesTree.PKFieldName;
      cxDBTreeList.DataController.ParentField :=
        FQueryBodyTypesTree.IDParentBodyType.FieldName;

      TNotifyEventWrap.Create(FQueryBodyTypesTree.OnDataChange, DoOnDataChange);
      TNotifyEventWrap.Create(FQueryBodyTypesTree.AfterDataChange,
        DoOnDataChange);

      actApplyBestFit.Execute;

      // Будем работать в рамках транзакции
      // FQueryBodyTypesTree.FDQuery.Connection.StartTransaction;

      UpdateView;
    end;
  end;
end;

procedure TViewBodyTypesTree.UpdateView;
var
  OK: Boolean;
begin
  OK := (QueryBodyTypesTree <> nil) and (QueryBodyTypesTree.FDQuery.Active);

  actAddRoot.Enabled := OK;

  actAddBodyType.Enabled := OK and (FocusedNode <> nil) and
    (FocusedLevel < 100);

  actAddBodyVariation.Enabled := OK and (FocusedNode <> nil);

  actCommit.Enabled := OK and
    (QueryBodyTypesTree.FDQuery.Connection.InTransaction);
  actRollback.Enabled := actCommit.Enabled;

  actExportToExcelDocument.Enabled := OK and
    (QueryBodyTypesTree.FDQuery.RecordCount > 0);
  actLoadFromExcelDocument.Enabled := OK;
end;

end.
