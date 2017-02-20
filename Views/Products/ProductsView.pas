unit ProductsView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ProductsBaseView, cxGraphics,
  cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB, cxDBData, cxGridLevel,
  cxClasses, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridBandedTableView, cxGridDBBandedTableView, cxGrid, dxBar,
  cxGridDBTableView, System.Actions, Vcl.ActnList, ProductsQuery,
  Vcl.ComCtrls, System.Generics.Collections, cxTextEdit, cxBlobEdit,
  cxButtonEdit, cxSpinEdit,
  cxCurrencyEdit, GridFrame, cxGridCustomPopupMenu, cxGridPopupMenu, Vcl.Menus,
  dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
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
  dxSkinXmas2008Blue, dxSkinscxPCPainter, dxSkinsdxBarPainter,
  cxDBLookupComboBox;

type
  TViewProducts = class(TViewProductsBase)
    actAdd: TAction;
    actDelete: TAction;
    dxbrbtnAdd: TdxBarButton;
    dxbrbtnDelete: TdxBarButton;
    dxbrbtnSave: TdxBarButton;
    dxbrsbtmPaste: TdxBarSubItem;
    dxBarButton2: TdxBarButton;
    actPasteComponents: TAction;
    N2: TMenuItem;
    actLoadFromExcelDocument: TAction;
    dxBarButton1: TdxBarButton;
    procedure actAddExecute(Sender: TObject);
    procedure actCommitExecute(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure actLoadFromExcelDocumentExecute(Sender: TObject);
    procedure actPasteComponentsExecute(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
    procedure actRollbackExecute(Sender: TObject);
    procedure cxGridDBBandedTableViewSelectionChanged
      (Sender: TcxCustomGridTableView);
    procedure cxGridDBBandedTableViewDataControllerCompare(ADataController
      : TcxCustomDataController; ARecordIndex1, ARecordIndex2,
      AItemIndex: Integer; const V1, V2: Variant; var Compare: Integer);
    procedure StatusBarResize(Sender: TObject);
  private
    procedure AfterDelete(Sender: TObject);
    procedure AfterLoad(Sender: TObject);
    procedure AfterOpen(Sender: TObject);
    procedure AfterPost(Sender: TObject);
    procedure BeforeLoad(Sender: TObject);
    function GetQueryProducts: TQueryProducts;
    procedure SetQueryProducts(const Value: TQueryProducts);
    // TODO: SortList
    // function SortList(AList: TList<TProductRecord>; ASortMode: Integer)
    // : TList<TProductRecord>;
    procedure UpdateProductCount;
    procedure UpdateSelectedCount;
    { Private declarations }
  protected
    procedure OnGridPopupMenuPopup(AColumn: TcxGridDBBandedColumn); override;
  public
    procedure UpdateView; override;
    property QueryProducts: TQueryProducts read GetQueryProducts
      write SetQueryProducts;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses NotifyEvents, System.Generics.Defaults, RepositoryDataModule,
  System.IOUtils, Winapi.ShellAPI, ClipboardUnit, System.Math, ProjectConst,
  DialogUnit, Vcl.Clipbrd, SettingsController, FieldInfoUnit, ExcelDataModule,
  ProductsExcelDataModule, ProgressBarForm;

procedure TViewProducts.actAddExecute(Sender: TObject);
var
  AColumn: TcxGridDBBandedColumn;
  AView: TcxGridDBBandedTableView;
begin
  AView := GetDBBandedTableView(0);
  AView.Focused := True;

  AView.DataController.Append;

  AColumn := AView.GetColumnByFieldName(QueryProducts.Value.FieldName);
  // Site обеспечивает доступ к элементам размещённым на cxGrid
  AView.Site.SetFocus;
  // Показываем редактор для колонки
  AView.Controller.EditingController.ShowEdit(AColumn);

  UpdateView;
end;

procedure TViewProducts.actCommitExecute(Sender: TObject);
begin
  inherited;;
end;

procedure TViewProducts.actDeleteExecute(Sender: TObject);
var
  AFocusedView: TcxGridDBBandedTableView;
begin

  if TDialog.Create.DeleteRecordsDialog(sDoYouWantToDeleteProducts) then
  begin
    AFocusedView := FocusedTableView;
    if AFocusedView <> nil then
    begin

      BeginUpdate;
      try
        AFocusedView.Controller.DeleteSelection;
      finally
        EndUpdate
      end;

      UpdateView;
    end;
  end;
end;

procedure TViewProducts.actLoadFromExcelDocumentExecute(Sender: TObject);
Var
  AExcelDM: TExcelDM;
  AFieldName: string;
  AFieldsInfo: TList<TFieldInfo>;
  AFileName: String;
  AProductsExcelDM: TProductsExcelDM;
  ARootTreeNode: TStringTreeNode;
  AStringTreeNode: TStringTreeNode;
  i: Integer;
begin
  inherited;
  AFileName := TDialog.Create.OpenExcelFile
    (TSettings.Create.ParametricDataFolder);

  if AFileName.IsEmpty then
    Exit; // отказались от выбора файла

  // Сохраняем эту папку в настройках
  TSettings.Create.LastFolderForExcelFile := TPath.GetDirectoryName(AFileName);

  // Описания полей excel файла
  AFieldsInfo := TList<TFieldInfo>.Create;
  try
    AExcelDM := TExcelDM.Create(Self);
    try
      // Загружаем описания полей Excel файла
      ARootTreeNode := AExcelDM.LoadExcelFileHeader(AFileName);

      // Цикл по всем заголовкам таблицы
      for AStringTreeNode in ARootTreeNode.Childs do
      begin
        // Цикл по всем колонкам представления
        for i := 0 to MainView.ColumnCount - 1 do
        begin
          if SameText(MainView.Columns[i].Caption, AStringTreeNode.Value) then
          begin
            // Создаём описание поля связанного с подпараметром
            AFieldsInfo.Add(TFieldInfo.Create(MainView.Columns[i].DataBinding.FieldName));
            break;
          end;
        end;
      end;

      if AFieldsInfo.Count = 0 then
      begin
        TDialog.Create.ErrorMessageDialog('Заголовки столбцов не распознаны');
        Exit;
      end;

      AProductsExcelDM := TProductsExcelDM.Create(Self, AFieldsInfo);
      try
        // Загружаем данные из Excel файла
        TfrmProgressBar.Process(AProductsExcelDM,
          procedure
          begin
            AProductsExcelDM.LoadExcelFile(AFileName);
          end, 'Загрузка складских данных', sRows);

      finally
        FreeAndNil(AProductsExcelDM);
      end;
    finally
      FreeAndNil(AExcelDM)
    end;
  finally
    FreeAndNil(AFieldsInfo);
  end;
end;

procedure TViewProducts.actPasteComponentsExecute(Sender: TObject);
var
  m: TArray<String>;
begin
  m := TClb.Create.GetRowsAsArray;
  if Length(m) = 0 then
    Exit;

  // Просим добавить компоненты на склад
  QueryProducts.AppendRows(QueryProducts.Value.FieldName, m);

  PutInTheCenterFocusedRecord(MainView);

  UpdateView;
end;

procedure TViewProducts.actRefreshExecute(Sender: TObject);
begin
  CheckAndSaveChanges;
end;

procedure TViewProducts.actRollbackExecute(Sender: TObject);
begin
  inherited;;
end;

procedure TViewProducts.AfterDelete(Sender: TObject);
begin
  UpdateProductCount;
end;

procedure TViewProducts.AfterLoad(Sender: TObject);
begin
  ApplyBestFitEx;
end;

procedure TViewProducts.AfterOpen(Sender: TObject);
begin
  UpdateProductCount;
  UpdateView;
end;

procedure TViewProducts.AfterPost(Sender: TObject);
begin
  UpdateProductCount;
end;

procedure TViewProducts.BeforeLoad(Sender: TObject);
begin
  UpdateView;
  { при выборе другого склада проверить наличие изменений в старом складе }
  if CheckAndSaveChanges = IDCANCEL then
    raise EAbort.Create('Cancel scroll');
end;

procedure TViewProducts.cxGridDBBandedTableViewDataControllerCompare
  (ADataController: TcxCustomDataController; ARecordIndex1, ARecordIndex2,
  AItemIndex: Integer; const V1, V2: Variant; var Compare: Integer);
var
  AVar1, AVar2: Integer;
begin
  if AItemIndex = 1 then
  begin
    if VarIsNull(V1) and not(VarIsNull(V2)) then
      Compare := -1;
    if VarIsNull(V2) and not(VarIsNull(V1)) then
      Compare := 1;
    if VarIsNull(V1) and VarIsNull(V2) then
      Compare := 0;
    if not(VarIsNull(V1) or VarIsNull(V2)) then
    begin
      if Pos('-', V1) > 0 then
        AVar1 := StrToInt(Copy(V1, 0, Pos('-', V1) - 1))
      else
        AVar1 := StrToInt(V1);

      if Pos('-', V2) > 0 then
        AVar2 := StrToInt(Copy(V2, 0, Pos('-', V2) - 1))
      else
        AVar2 := StrToInt(V2);

      if AVar1 > AVar2 then
        Compare := -1;
      if AVar1 < AVar2 then
        Compare := 1;
      if AVar1 = AVar2 then
        Compare := 0;

      { if V1 > V2 then
        Compare := -1;
        if V1 < V2 then
        Compare := 1;
        if V1 = V2 then
        Compare := 0; }
    end;
    // if btStorehouseProducts.Columns[AItemIndex].SortOrder = soAscending then
    Compare := Compare * (-1); // инвертировать порядок при необходимости

  end
  else
  begin
    case VarCompareValue(V1, V2) of
      vrEqual:
        Compare := 0;
      vrLessThan:
        Compare := -1;
      vrGreaterThan:
        Compare := 1;
    else
      Compare := 0;
    end;
  end;
end;

procedure TViewProducts.cxGridDBBandedTableViewSelectionChanged
  (Sender: TcxCustomGridTableView);
begin
  UpdateSelectedCount;
end;

function TViewProducts.GetQueryProducts: TQueryProducts;
begin
  Result := QueryProductsBase as TQueryProducts;
end;

procedure TViewProducts.OnGridPopupMenuPopup(AColumn: TcxGridDBBandedColumn);
Var
  Ok: Boolean;
begin
  Ok := Clipboard.HasFormat(CF_TEXT) and (AColumn <> nil);

  actPasteComponents.Enabled := Ok and (AColumn.GridView.Level = cxGridLevel)
    and (AColumn.DataBinding.FieldName = clValue.DataBinding.FieldName);

  Ok := (AColumn <> nil);

  actPasteComponents.Visible := Ok and (AColumn.GridView.Level = cxGridLevel)
    and (AColumn.DataBinding.FieldName = clValue.DataBinding.FieldName);
end;

procedure TViewProducts.SetQueryProducts(const Value: TQueryProducts);
begin
  if QueryProductsBase <> Value then
  begin
    QueryProductsBase := Value;

    FEventList.Clear;

    if QueryProducts <> nil then
    begin
      // Подписываемся на события
      TNotifyEventWrap.Create(QueryProducts.Master.BeforeScrollI, BeforeLoad,
        FEventList);

      // Подписываемся на события
      TNotifyEventWrap.Create(QueryProducts.AfterLoad, AfterLoad, FEventList);

      TNotifyEventWrap.Create(QueryProducts.AfterOpen, AfterOpen, FEventList);

      TNotifyEventWrap.Create(QueryProducts.AfterPost, AfterPost, FEventList);

      TNotifyEventWrap.Create(QueryProducts.AfterDelete, AfterDelete,
        FEventList);

      Assert(clProducer.DataBinding.FieldName <> '');
      Assert(MainView.GetColumnByFieldName(clProducer.DataBinding.FieldName)
        .DataBinding.FieldName <> '');
    end;

    UpdateView;
  end;
end;

// TODO: SortList
// { Сортировка в рамках одной группы компонентов }
// function TViewProducts.SortList(AList: TList<TProductRecord>;
// ASortMode: Integer): TList<TProductRecord>;
// var
// AComparison: TComparison<TProductRecord>;
/// / AComparisonByExcelRow: TComparison<TProductRecord>;
// ATempList: TList<TProductRecord>;
// i: Integer;
// begin
/// / пользовательское сравнение по значению
// if ASortMode = 1 then
// begin
// AComparison := function(const Left, Right: TProductRecord): Integer
// begin
// Result := CompareText(Left.Value, Right.Value);
// if Result = 0 then
// begin
// Result := Left.ExcelRowNumber - Right.ExcelRowNumber;
// if Result > 0 then
// Result := 1;
// if Result < 0 then
// Result := -1;
// end;
// end;
// end;
// if ASortMode = 0 then
// begin
// // Сортировка по номеру строки
// AComparison := function(const Left, Right: TProductRecord): Integer
// begin
// Result := Left.ExcelRowNumber - Right.ExcelRowNumber;
// if Result > 0 then
// Result := 1;
// if Result < 0 then
// Result := -1;
// end;
// end;
//
// Result := TList<TProductRecord>.Create();
// ATempList := TList<TProductRecord>.Create();
// for i := 0 to AList.Count - 1 do // берем весь список
// begin
// if (ATempList.Count > 0) then // если временный список не пустой
// begin
// if (ATempList.Last.ComponentGroup <> AList[i].ComponentGroup) then
// // и совпадает группа компонентов
// begin // иначе отсортировать временный список и всё равно добавить запись
// ATempList.Sort(TComparer<TProductRecord>.Construct(AComparison));
// // сортировка пользовательским сравнением
// Result.AddRange(ATempList);
// ATempList := TList<TProductRecord>.Create();
// end;
// end; // в результате всё равно добавить запись
// ATempList.Add(AList[i]);
// end;
/// / и в результате нужно отсортировать временный список и из него внести данные, чтобы не потерять последнюю группу компонентов
// ATempList.Sort(TComparer<TProductRecord>.Construct(AComparison));
/// / сортировка пользовательским сравнением
// Result.AddRange(ATempList);
//
/// / Result := AList;
//
// { AComparison := function(const Left, Right: TProductRecord): Integer
// begin
// Result := CompareText(Left.ComponentGroup, Right.ComponentGroup);
// end;
// AList.Sort(TComparer<TProductRecord>.Construct(AComparison)); }
// end;

procedure TViewProducts.StatusBarResize(Sender: TObject);
const
  EmptyPanelIndex = 2;
var
  I: Integer;
  x: Integer;
begin
  x := StatusBar.ClientWidth;
  for I := 0 to StatusBar.Panels.Count - 1 do
  begin
    if I <> EmptyPanelIndex then
    begin
      Dec(x, StatusBar.Panels[I].Width);
    end;
  end;
  x := IfThen(x >= 0, x, 0);
  StatusBar.Panels[EmptyPanelIndex].Width := x;
end;

procedure TViewProducts.UpdateProductCount;
begin
  // На выбранном складе
  StatusBar.Panels[0].Text := Format('%d', [QueryProducts.FDQuery.RecordCount]);

  // На всех складах
  StatusBar.Panels[3].Text := Format('Всего: %d', [QueryProducts.TotalCount]);

end;

procedure TViewProducts.UpdateSelectedCount;
begin
  StatusBar.Panels[1].Text :=
    Format('%d', [cxGridDBBandedTableView.DataController.GetSelectedCount]);
end;

procedure TViewProducts.UpdateView;
var
  AFocusedView: TcxGridDBBandedTableView;
  Ok: Boolean;
begin
  inherited;
  Ok := (QueryProductsBase <> nil) and (QueryProductsBase.FDQuery.Active);
  AFocusedView := FocusedTableView;

  actAdd.Enabled := Ok;
  {
    and ((QueryProductsBase.FDQuery.State = dsBrowse) or
    ((QueryProductsBase.FDQuery.State in [dsEdit, dsInsert]) and
    (not QueryProductsBase.Value.AsString.IsEmpty)));
  }
  actDelete.Enabled := Ok and (AFocusedView <> nil) and
    (AFocusedView.DataController.RowCount > 0);

  actLoadFromExcelDocument.Enabled := Ok;
end;

end.
