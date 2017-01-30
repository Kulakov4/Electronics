unit ProductsView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ProductsBaseView, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB, cxDBData, cxGridLevel,
  cxClasses, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridBandedTableView, cxGridDBBandedTableView, cxGrid, dxBar,
  cxGridDBTableView, System.Actions, Vcl.ActnList, ProductsQuery,
  Vcl.ComCtrls, System.Generics.Collections, cxTextEdit, cxBlobEdit, cxButtonEdit, cxSpinEdit,
  cxCurrencyEdit, GridFrame, cxGridCustomPopupMenu, cxGridPopupMenu, Vcl.Menus,
  {ExcelController, }dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
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
    actPasteFromBuffer: TAction;
    actPasteFromExcel: TAction;
    actPasteFromExcelSheet: TAction;
    dxbrbtnPasteFromBuffer: TdxBarButton;
    dxbrbtnPasteFromExcel: TdxBarButton;
    dxbrbtnPasteFromExcelSheet: TdxBarButton;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    procedure actAddExecute(Sender: TObject);
    procedure actCommitExecute(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure actPasteFromBufferExecute(Sender: TObject);
    procedure actPasteFromExcelExecute(Sender: TObject);
    procedure actPasteFromExcelSheetExecute(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
    procedure actRollbackExecute(Sender: TObject);
    procedure cxGridDBBandedTableViewSelectionChanged(Sender:
        TcxCustomGridTableView);
    procedure cxGridDBBandedTableViewDataControllerCompare(
      ADataController: TcxCustomDataController; ARecordIndex1, ARecordIndex2,
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
//  function SortList(AList: TList<TProductRecord>; ASortMode: Integer)
//    : TList<TProductRecord>;
    procedure UpdateProductCount;
    procedure UpdateSelectedCount;
    { Private declarations }
  protected
  public
    procedure UpdateView; override;
    property QueryProducts: TQueryProducts read GetQueryProducts write
        SetQueryProducts;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses NotifyEvents, SplashXP, System.Generics.Defaults,
  RepositoryDataModule, System.IOUtils, Winapi.ShellAPI, ClipboardUnit,
  {ClipboardManager, }System.Math, ProjectConst, DialogUnit;

procedure TViewProducts.actAddExecute(Sender: TObject);
var
  AColumn: TcxGridDBBandedColumn;
  AView: TcxGridDBBandedTableView;
begin
  AView := GetDBBandedTableView(0);
  AView.Focused := True;

  AView.DataController.Append;

  AColumn := AView.GetColumnByFieldName( QueryProducts.Value.FieldName );
  // Site обеспечивает доступ к элементам размещённым на cxGrid
  AView.Site.SetFocus;
  // Показываем редактор для колонки
  AView.Controller.EditingController.ShowEdit(AColumn);

  UpdateView;
end;

procedure TViewProducts.actCommitExecute(Sender: TObject);
begin
  inherited;
  ;
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

procedure TViewProducts.actPasteFromBufferExecute(Sender: TObject);
//var
//  ARows: TArray<String>;
begin
  TDialog.Create.MethodNotImplemended;
{
  Assert(QueryProducts <> nil);
  ARows := TClb.Create.GetRowsAsArray;

  cxGridDBBandedTableView.BeginUpdate();
  try
    QueryProducts.AddStringList(ARows);
  finally
    cxGridDBBandedTableView.EndUpdate;
  end;
}
end;

procedure TViewProducts.actPasteFromExcelExecute(Sender: TObject);
{
var
  AExcelController: TExcelController;
  AList: TList<TProductRecord>;
  dr, ASortMode: Integer;
}
begin
  TDialog.Create.MethodNotImplemended;
{
  dr := Application.MessageBox(PChar(TLanguageConstants.IsShouldSort),
    // нужно ли сортировать
    PChar(TLanguageConstants.Question), MB_YESNO + MB_ICONQUESTION);

  ASortMode := 0;
  if dr = mrYes then
    ASortMode := 1;

  AExcelController := TExcelController.Create;
  MessageForm.Show(sLoading, sWaitExcelLoading);
  try
    AList := AExcelController.ReadFile;
  finally
    AExcelController.Free;
    MessageForm.Close;
  end;
  if AList.Count = 0 then
    Exit;

  // if dr = mrYes then   //сортировать?
  // begin
  MessageForm.Show(sLoading, sSorting);
  AList := SortList(AList, ASortMode);
  MessageForm.Close;
  // end;

  QueryProducts.TryPost;

  cxGridDBBandedTableView.BeginUpdate();
  MessageForm.Show(sLoading, sForming);
  try
    QueryProducts.InsertRecordList(AList);
  finally
    MessageForm.Close;
    cxGridDBBandedTableView.EndUpdate;
  end;
}
end;

procedure TViewProducts.actPasteFromExcelSheetExecute(Sender: TObject);
{
var
  AClipboardManager: TClipboardManager;
  ARows: TStringList;
}
begin
  TDialog.Create.MethodNotImplemended;
{
  AClipboardManager := TClipboardManager.Create;
  try
    ARows := AClipboardManager.GetRowsExcel;
  finally
    FreeAndNil(AClipboardManager);
  end;

  cxGridDBBandedTableView.BeginUpdate();
  MessageForm.Show(sLoading, sForming);
  try
    QueryProducts.InsertRecordList( QueryProducts.ConvertRowsToRecords(ARows));
  finally
    MessageForm.Close;
    cxGridDBBandedTableView.EndUpdate;
  end;
}
end;

procedure TViewProducts.actRefreshExecute(Sender: TObject);
begin
  CheckAndSaveChanges;
end;

procedure TViewProducts.actRollbackExecute(Sender: TObject);
begin
  inherited;
  ;
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

procedure TViewProducts.cxGridDBBandedTableViewDataControllerCompare(
  ADataController: TcxCustomDataController; ARecordIndex1, ARecordIndex2,
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

procedure TViewProducts.cxGridDBBandedTableViewSelectionChanged(
    Sender: TcxCustomGridTableView);
begin
  UpdateSelectedCount;
end;

function TViewProducts.GetQueryProducts: TQueryProducts;
begin
  Result := QueryProductsBase as TQueryProducts;
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

      TNotifyEventWrap.Create(QueryProducts.AfterOpen, AfterOpen,
        FEventList);

      TNotifyEventWrap.Create(QueryProducts.AfterPost, AfterPost,
        FEventList);

      TNotifyEventWrap.Create(QueryProducts.AfterDelete,
        AfterDelete, FEventList);
    end;

    UpdateView;
  end;
end;

// TODO: SortList
//{ Сортировка в рамках одной группы компонентов }
//function TViewProducts.SortList(AList: TList<TProductRecord>;
//ASortMode: Integer): TList<TProductRecord>;
//var
//AComparison: TComparison<TProductRecord>;
//// AComparisonByExcelRow: TComparison<TProductRecord>;
//ATempList: TList<TProductRecord>;
//i: Integer;
//begin
//// пользовательское сравнение по значению
//if ASortMode = 1 then
//begin
//  AComparison := function(const Left, Right: TProductRecord): Integer
//    begin
//      Result := CompareText(Left.Value, Right.Value);
//      if Result = 0 then
//      begin
//        Result := Left.ExcelRowNumber - Right.ExcelRowNumber;
//        if Result > 0 then
//          Result := 1;
//        if Result < 0 then
//          Result := -1;
//      end;
//    end;
//end;
//if ASortMode = 0 then
//begin
//  // Сортировка по номеру строки
//  AComparison := function(const Left, Right: TProductRecord): Integer
//    begin
//      Result := Left.ExcelRowNumber - Right.ExcelRowNumber;
//      if Result > 0 then
//        Result := 1;
//      if Result < 0 then
//        Result := -1;
//    end;
//end;
//
//Result := TList<TProductRecord>.Create();
//ATempList := TList<TProductRecord>.Create();
//for i := 0 to AList.Count - 1 do // берем весь список
//begin
//  if (ATempList.Count > 0) then // если временный список не пустой
//  begin
//    if (ATempList.Last.ComponentGroup <> AList[i].ComponentGroup) then
//    // и совпадает группа компонентов
//    begin // иначе отсортировать временный список и всё равно добавить запись
//      ATempList.Sort(TComparer<TProductRecord>.Construct(AComparison));
//      // сортировка пользовательским сравнением
//      Result.AddRange(ATempList);
//      ATempList := TList<TProductRecord>.Create();
//    end;
//  end; // в результате всё равно добавить запись
//  ATempList.Add(AList[i]);
//end;
//// и в результате нужно отсортировать временный список и из него внести данные, чтобы не потерять последнюю группу компонентов
//ATempList.Sort(TComparer<TProductRecord>.Construct(AComparison));
//// сортировка пользовательским сравнением
//Result.AddRange(ATempList);
//
//// Result := AList;
//
//{ AComparison := function(const Left, Right: TProductRecord): Integer
//  begin
//  Result := CompareText(Left.ComponentGroup, Right.ComponentGroup);
//  end;
//  AList.Sort(TComparer<TProductRecord>.Construct(AComparison)); }
//end;

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
  StatusBar.Panels[0].Text :=
    Format('%d', [QueryProducts.FDQuery.RecordCount]);

  // На всех складах
  StatusBar.Panels[3].Text := Format('Всего: %d',
    [QueryProducts.TotalCount]);

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

  actAdd.Enabled := OK;
  actDelete.Enabled := Ok and (AFocusedView <> nil) and
    (AFocusedView.DataController.RowCount > 0);

  actPasteFromBuffer.Enabled := OK;
  actPasteFromExcelSheet.Enabled := Ok;
  actPasteFromExcel.Enabled := Ok;
end;

end.
