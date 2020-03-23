unit ProductsSearchView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  ProductsBaseView1, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxCustomData, cxStyles, cxTL, cxMaskEdit,
  cxDBLookupComboBox, cxDropDownEdit, cxButtonEdit, cxTLdxBarBuiltInMenu,
  dxSkinsCore, dxSkinsDefaultPainters, cxCalendar, cxCurrencyEdit, Vcl.ExtCtrls,
  Vcl.Menus, System.Actions, Vcl.ActnList, dxBar, cxBarEditItem, cxClasses,
  Vcl.ComCtrls, cxInplaceContainer, cxDBTL, cxTLData, ProductsSearchViewModel,
  ProductsBaseView0;

type
  TViewProductsSearch = class(TViewProductsBase1)
    actClear: TAction;
    actSearch: TAction;
    actPasteFromBuffer: TAction;
    clStoreHouseID2: TcxDBTreeListColumn;
    dxBarButton2: TdxBarButton;
    dxBarButton3: TdxBarButton;
    dxBarButton4: TdxBarButton;
    dxBarButton5: TdxBarButton;
    dxBarButton6: TdxBarButton;
    dxBarSubItem1: TdxBarSubItem;
    dxBarButton7: TdxBarButton;
    dxBarButton8: TdxBarButton;
    dxBarButton9: TdxBarButton;
    dxBarButton10: TdxBarButton;
    procedure actClearExecute(Sender: TObject);
    procedure actPasteFromBufferExecute(Sender: TObject);
    procedure actSearchExecute(Sender: TObject);
    procedure cxDBTreeListEdited(Sender: TcxCustomTreeList;
      AColumn: TcxTreeListColumn);
  private
    function GetSearchViewModel: TProductsSearchViewModel;
    procedure Search(ALike: Boolean);
    procedure SetSearchViewModel(const Value: TProductsSearchViewModel);
    { Private declarations }
  protected
    procedure ApplyGridSort; override;
    function CreateProductView: TViewProductsBase0; override;
    procedure InitializeColumns; override;
    function IsViewOK: Boolean; override;
  public
    procedure FocusValueColumn;
    procedure UpdateView; override;
    property SearchViewModel: TProductsSearchViewModel read GetSearchViewModel
      write SetSearchViewModel;
    { Public declarations }
  end;

implementation

uses
  SearchInterfaceUnit, Vcl.Clipbrd, ClipboardUnit, GridSort, dxCore,
  RepositoryDataModule;

{$R *.dfm}

procedure TViewProductsSearch.actClearExecute(Sender: TObject);
begin
  inherited;
  if CheckAndSaveChanges = IDCANCEL then
    Exit;

  cxDBTreeList.BeginUpdate;
  try
    SearchViewModel.qProductsSearch.ClearSearchResult;
    UpdateView;
  finally
    cxDBTreeList.EndUpdate;
  end;
  FocusValueColumn;
end;

procedure TViewProductsSearch.actPasteFromBufferExecute(Sender: TObject);
begin
  inherited;
  // Если в буфере обмена ничего нет
  if Clipboard.AsText.Trim.IsEmpty then
    Exit;

  cxDBTreeList.BeginUpdate;
  try
    SearchViewModel.qProductsSearch.W.AppendRows
      (SearchViewModel.qProductsSearch.W.Value.FieldName,
      TClb.Create.GetRowsAsArray);
    UpdateView;

  finally
    cxDBTreeList.EndUpdate;
  end;
end;

procedure TViewProductsSearch.actSearchExecute(Sender: TObject);
begin
  inherited;
  Search(False);
end;

procedure TViewProductsSearch.ApplyGridSort;
begin
  GridSort.Add(TSortVariant.Create(clValue, [clValue, clStoreHouseID2]));
  GridSort.Add(TSortVariant.Create(clIDProducer, [clIDProducer, clValue]));
  GridSort.Add(TSortVariant.Create(clLoadDate, [clLoadDate, clValue]));
  ApplySort(clValue, soAscending);
end;

function TViewProductsSearch.CreateProductView: TViewProductsBase0;
begin
  Result := TViewProductsSearch.Create(nil);
end;

procedure TViewProductsSearch.cxDBTreeListEdited(Sender: TcxCustomTreeList;
  AColumn: TcxTreeListColumn);
begin
  if SearchViewModel.qProductsSearch.ProductSearchW.Mode = SearchMode then
  begin
    if cxDBTreeList.LockUpdate > 0 then
      Exit;

    // Если закончили редактирование наименования
    if (AColumn as TcxDBTreeListColumn).DataBinding.FieldName = clValue.
      DataBinding.FieldName then
    begin
      if VarToStrDef(FocusedNodeValue(AColumn as TcxDBTreeListColumn), '') <> ''
      then
        Search(True);
    end;
  end
  else
    inherited;
end;

procedure TViewProductsSearch.FocusValueColumn;
begin
  cxDBTreeList.SetFocus;

  // Переводим колонку в режим редактирования
  clValue.Editing := True;
end;

function TViewProductsSearch.GetSearchViewModel: TProductsSearchViewModel;
begin
  Result := Model as TProductsSearchViewModel;
end;

procedure TViewProductsSearch.InitializeColumns;
begin
  inherited;

  Assert(M <> nil);

  InitializeLookupColumn(clStorehouseId,
    SearchViewModel.qStoreHouseList.W.DataSource, lsEditFixedList,
    SearchViewModel.qStoreHouseList.W.Abbreviation.FieldName);

  InitializeLookupColumn(clStorehouseId2,
    SearchViewModel.qStoreHouseList.W.DataSource, lsEditFixedList,
    SearchViewModel.qStoreHouseList.W.Title.FieldName);
end;

function TViewProductsSearch.IsViewOK: Boolean;
begin
  Result := (M <> nil) and (SearchViewModel.qProductsSearch <> nil) and
    (SearchViewModel.qProductsSearch.ProductSearchW.Mode = RecordsMode);
end;

procedure TViewProductsSearch.Search(ALike: Boolean);
begin
  cxDBTreeList.BeginUpdate;
  try
    CheckAndSaveChanges;

    SearchViewModel.qProductsSearch.DoSearch(ALike);

  finally
    cxDBTreeList.EndUpdate;
  end;
  MyApplyBestFit;
  // cxDBTreeList.FullExpand;

  cxDBTreeList.SetFocus;
  // Переводим колонку в режим редактирования
  clValue.Editing := True;

  UpdateView;
end;

procedure TViewProductsSearch.SetSearchViewModel(const Value
  : TProductsSearchViewModel);
begin
  if Model = Value then
    Exit;

  Model := Value;
end;

procedure TViewProductsSearch.UpdateView;
var
  Ok: Boolean;
begin
  inherited;
  Ok := (SearchViewModel <> nil) and
    (SearchViewModel.qProductsSearch.FDQuery.Active);

  actClear.Enabled := Ok and SearchViewModel.qProductsSearch.IsClearEnabled;

  actSearch.Enabled := Ok and SearchViewModel.qProductsSearch.IsSearchEnabled;

  actCommit.Enabled := Ok and SearchViewModel.qProductsSearch.HaveAnyChanges and
    (SearchViewModel.qProductsSearch.ProductSearchW.Mode = RecordsMode);

  actRollback.Enabled := actCommit.Enabled;

  actPasteFromBuffer.Enabled := Ok and
    (SearchViewModel.qProductsSearch.ProductSearchW.Mode = SearchMode);


  // cxGridDBBandedTableView.OptionsData.Appending :=
  // qProductsSearch.qProductsSearch.Mode = SearchMode;

  // cxGridDBBandedTableView.OptionsData.Inserting :=
  // qProductsSearch.qProductsSearch.Mode = SearchMode;

  actExportToExcelDocument.Caption := 'В документ Excel';
  actExportToExcelDocument.Hint := 'Экспортировать в документ Excel';
  actExportToExcelDocument.Enabled := Ok and
    (SearchViewModel.qProductsSearch.FDQuery.RecordCount > 0) and
    (SearchViewModel.qProductsSearch.ProductSearchW.Mode = RecordsMode);
end;

end.
