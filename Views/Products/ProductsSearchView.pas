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
  ProductsBaseView0, cxDataControllerConditionalFormattingRulesManagerDialog,
  Vcl.StdCtrls;

const
  WM_FOCUS_VALUE = WM_USER + 369;

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
    procedure cxDBTreeListKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    function GetSearchViewModel: TProductsSearchViewModel;
    procedure PostFocusValueColumnMessage;
    procedure Search(ALike: Boolean);
    procedure SetSearchViewModel(const Value: TProductsSearchViewModel);
    { Private declarations }
  protected
    procedure ApplyGridSort; override;
    function CreateProductView: TViewProductsBase0; override;
    procedure FocusValueMsg(var Message: TMessage); message WM_FOCUS_VALUE;
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
  RepositoryDataModule, DialogUnit;

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
  PostFocusValueColumnMessage;
end;

procedure TViewProductsSearch.actPasteFromBufferExecute(Sender: TObject);
begin
  inherited;
  // ≈сли в буфере обмена ничего нет
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
  MyApplyBestFit(clValue.Position.Band);
end;

procedure TViewProductsSearch.actSearchExecute(Sender: TObject);
begin
  inherited;

  if (SearchViewModel = nil) or
    (SearchViewModel.qProductsSearch.ProductSearchW.Mode <> SearchMode) then
    Exit;

  if clValue.Editing then
  begin
    // завершаем редактирование наименовани€
    cxDBTreeList.FocusedNode.EndEdit(False);
  end;

  if VarToStrDef(clValue.Value, '') <> '' then
    Search(False)
  else
  begin
    TDialog.Create.ProductSearchIsEmpty;
    PostFocusValueColumnMessage;
  end;
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

procedure TViewProductsSearch.cxDBTreeListKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  inherited;
  if (Key <> 13) or (SearchViewModel = nil) then
    Exit;

  if not cxDBTreeList.IsEditing or not clValue.Editing then
    Exit;

  if (SearchViewModel.qProductsSearch.ProductSearchW.Mode <> SearchMode) then
    Exit;

  // завершаем редактирование наименовани€
  cxDBTreeList.FocusedNode.EndEdit(False);

  if (VarToStrDef(clValue.EditValue, '') = '') or
    (VarToStrDef(clValue.Value, '') = '') then
    Exit;

  // ≈сли закончили редактирование наименовани€
  Search(True);
end;

procedure TViewProductsSearch.FocusValueColumn;
begin
  cxDBTreeList.SetFocus;
  clValue.Focused := True;

  // ѕереводим колонку в режим редактировани€
  clValue.Editing := True;

  // cxDBTreeList.ShowEdit;
end;

procedure TViewProductsSearch.FocusValueMsg(var Message: TMessage);
begin
  inherited;
  FocusValueColumn;
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

  InitializeLookupColumn(clStoreHouseID2,
    SearchViewModel.qStoreHouseList.W.DataSource, lsEditFixedList,
    SearchViewModel.qStoreHouseList.W.Title.FieldName);
end;

function TViewProductsSearch.IsViewOK: Boolean;
begin
  Result := (M <> nil) and (SearchViewModel.qProductsSearch <> nil) and
    (SearchViewModel.qProductsSearch.ProductSearchW.Mode = RecordsMode);
end;

procedure TViewProductsSearch.PostFocusValueColumnMessage;
begin
  PostMessage(Handle, WM_FOCUS_VALUE, 0, 0);
end;

procedure TViewProductsSearch.Search(ALike: Boolean);
var
  OK: Boolean;
begin
  cxDBTreeList.BeginUpdate;
  try
    CheckAndSaveChanges;
    OK := SearchViewModel.qProductsSearch.DoSearch(ALike);
  finally
    cxDBTreeList.EndUpdate;
  end;

  if OK then
  begin
    MyApplyBestFit;
    // cxDBTreeList.FullExpand;
  end
  else
  begin
    TDialog.Create.ProductSearchNotFoundDialog;
    PostFocusValueColumnMessage;
  end;

  UpdateView;
end;

procedure TViewProductsSearch.SetSearchViewModel(const Value
  : TProductsSearchViewModel);
begin
  if Model = Value then
    Exit;

  Model := Value;

  if Model <> nil then
    PostFocusValueColumnMessage
end;

procedure TViewProductsSearch.UpdateView;
var
  OK: Boolean;
begin
  inherited;
  OK := (SearchViewModel <> nil) and
    (SearchViewModel.qProductsSearch.FDQuery.Active);

  actClear.Enabled := OK;

  actSearch.Enabled := OK and
    (SearchViewModel.qProductsSearch.ProductSearchW.Mode = SearchMode);

  actCommit.Enabled := OK and SearchViewModel.qProductsSearch.HaveAnyChanges and
    (SearchViewModel.qProductsSearch.ProductSearchW.Mode = RecordsMode);

  actRollback.Enabled := actCommit.Enabled;

  actPasteFromBuffer.Enabled := OK and
    (SearchViewModel.qProductsSearch.ProductSearchW.Mode = SearchMode);


  // cxGridDBBandedTableView.OptionsData.Appending :=
  // qProductsSearch.qProductsSearch.Mode = SearchMode;

  // cxGridDBBandedTableView.OptionsData.Inserting :=
  // qProductsSearch.qProductsSearch.Mode = SearchMode;

  actExportToExcelDocument.Caption := '¬ документ Excel';
  actExportToExcelDocument.Hint := 'Ёкспортировать в документ Excel';
  actExportToExcelDocument.Enabled := OK and
    (SearchViewModel.qProductsSearch.FDQuery.RecordCount > 0) and
    (SearchViewModel.qProductsSearch.ProductSearchW.Mode = RecordsMode);
end;

end.
