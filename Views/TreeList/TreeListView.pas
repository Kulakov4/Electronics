unit TreeListView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, TreeListFrame, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxCustomData, cxStyles, cxTL,
  cxTLdxBarBuiltInMenu, dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
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
  dxSkinXmas2008Blue, dxSkinsdxBarPainter, Vcl.Menus, System.Actions,
  Vcl.ActnList, dxBar, cxClasses, Vcl.ComCtrls, cxInplaceContainer, cxTLData,
  cxDBTL, TreeListQuery, cxMaskEdit, RepositoryDataModule, Vcl.ExtCtrls,
  cxSplitter, DuplicateCategoryView, DuplicateCategoryQuery, NotifyEvents,
  cxTextEdit, cxBarEditItem,
  cxDataControllerConditionalFormattingRulesManagerDialog;

type
  TViewTreeList = class(TfrmTreeList)
    clID: TcxDBTreeListColumn;
    clValue: TcxDBTreeListColumn;
    clOrd: TcxDBTreeListColumn;
    actAdd: TAction;
    actRename: TAction;
    actDelete: TAction;
    actExportTreeToExcelDocument: TAction;
    actLoadTreeFromExcelDocument: TAction;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    Excel1: TMenuItem;
    Excel2: TMenuItem;
    pnlBottom: TPanel;
    cxSplitter: TcxSplitter;
    dxBarButton1: TdxBarButton;
    actDuplicate: TAction;
    cxbeiSearch: TcxBarEditItem;
    dxBarButton2: TdxBarButton;
    actSearch: TAction;
    dxBarButton3: TdxBarButton;
    actClear: TAction;
    procedure actAddExecute(Sender: TObject);
    procedure actClearExecute(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure actExportTreeToExcelDocumentExecute(Sender: TObject);
    procedure actLoadTreeFromExcelDocumentExecute(Sender: TObject);
    procedure actRenameExecute(Sender: TObject);
    procedure actDuplicateExecute(Sender: TObject);
    procedure actSearchExecute(Sender: TObject);
    procedure cxDBTreeListClick(Sender: TObject);
    procedure cxDBTreeListCollapsed(Sender: TcxCustomTreeList;
      ANode: TcxTreeListNode);
    procedure cxDBTreeListDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure cxDBTreeListDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure cxDBTreeListExpanded(Sender: TcxCustomTreeList;
      ANode: TcxTreeListNode);
    procedure cxDBTreeListMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cxSplitterAfterClose(Sender: TObject);
    procedure cxSplitterAfterOpen(Sender: TObject);
    procedure cxbeiSearchPropertiesChange(Sender: TObject);
    procedure cxbeiSearchPropertiesEditValueChanged(Sender: TObject);
  private
    FqTreeList: TQueryTreeList;
    FViewDuplicateCategory: TViewDuplicateCategory;

  const
    KeyFolder: String = 'TreeList';
    function GetLevel(ANode: TcxTreeListNode): Integer;
    procedure SetqTreeList(const Value: TQueryTreeList);
    { Private declarations }
  protected
    procedure DoOnDuplicateClick(Sender: TObject);
    procedure MyUpdateView(X, Y: Integer);
    property ViewDuplicateCategory: TViewDuplicateCategory
      read FViewDuplicateCategory;
  public
    constructor Create(AOwner: TComponent); override;
    procedure ExpandRoot;
    procedure UpdateView; override;
    property qTreeList: TQueryTreeList read FqTreeList write SetqTreeList;
    { Public declarations }
  end;

implementation

uses
  ProjectConst, DialogUnit, RecursiveTreeQuery, RecursiveTreeView, DialogUnit2,
  GridViewForm2, LoadFromExcelFileHelper, TreeExcelDataModule, CustomErrorForm,
  System.Types, System.UITypes, Vcl.StdCtrls, FireDAC.Comp.DataSet, cxEdit;

{$R *.dfm}

constructor TViewTreeList.Create(AOwner: TComponent);
begin
  inherited;

  // Создаём представление для дублирующихся категорий
  FViewDuplicateCategory := TViewDuplicateCategory.Create(Self);
  FViewDuplicateCategory.Parent := pnlBottom;
  FViewDuplicateCategory.Align := alClient;

  cxSplitter.CloseSplitter;

  cxbeiSearch.Properties.ImmediatePost := True;
  (cxbeiSearch.Properties as TcxTextEditProperties).ImmediateUpdateText := True;

  FEnableClearSelection := False;
end;

procedure TViewTreeList.actAddExecute(Sender: TObject);
var
  AValue: String;
begin
  inherited;
  qTreeList.W.TryPost;

  AValue := InputBox(sDatabase, sPleaseWrite, '');
  if AValue.IsEmpty then
    Exit;

  qTreeList.W.AddChildCategory(AValue, GetLevel(cxDBTreeList.FocusedNode));
end;

procedure TViewTreeList.actClearExecute(Sender: TObject);
begin
  inherited;
  cxbeiSearch.EditValue := Null;
  UpdateView;
end;

procedure TViewTreeList.actDeleteExecute(Sender: TObject);
begin
  inherited;
  qTreeList.W.TryPost;
  if not TDialog.Create.DeleteRecordsDialog(sDoYouWantToDelete) then
    Exit;

  qTreeList.W.Delete
end;

procedure TViewTreeList.actExportTreeToExcelDocumentExecute(Sender: TObject);
var
  AQueryRecursiveTree: TQueryRecursiveTree;
  AViewRecursiveTree: TViewRecursiveTree;
begin
  inherited;

  Application.Hint := '';

  AQueryRecursiveTree := TQueryRecursiveTree.Create(Self);
  AViewRecursiveTree := TViewRecursiveTree.Create(Self);
  try
    AQueryRecursiveTree.W.RefreshQuery;
    AViewRecursiveTree.QueryRecursiveTree := AQueryRecursiveTree;
    AViewRecursiveTree.actExportToExcelDocument.Execute;
  finally
    FreeAndNil(AViewRecursiveTree);
    FreeAndNil(AQueryRecursiveTree);
  end;
end;

procedure TViewTreeList.actLoadTreeFromExcelDocumentExecute(Sender: TObject);
var
  AFileName: string;
  AfrmGridView: TfrmGridView2;
  AQueryRecursiveTree: TQueryRecursiveTree;
  OK: Boolean;
begin
  inherited;
  Application.Hint := '';

  if not TOpenExcelDialog.SelectInFolder(AFileName, Handle, KeyFolder) then
    Exit;

  AQueryRecursiveTree := TQueryRecursiveTree.Create(Self);
  try
    AQueryRecursiveTree.FDQuery.Open;
    TLoad.Create.LoadAndProcess(AFileName, TTreeExcelDM, TfrmCustomError,
      procedure(ASender: TObject)
      begin
        AQueryRecursiveTree.LoadDataFromExcelTable(ASender as TTreeExcelTable);
      end);

    // Получаем добавленные категории
    AQueryRecursiveTree.W.HideNotAdded;
    // Если есть категории, которые были добавлены
    if AQueryRecursiveTree.FDQuery.RecordCount > 0 then
    begin
      AfrmGridView := TfrmGridView2.Create(Self);
      try
        AfrmGridView.Caption := 'Добавленные категории';
        AfrmGridView.ViewGridEx.DSWrap := AQueryRecursiveTree.W;
        AfrmGridView.ShowModal;
      finally
        FreeAndNil(AfrmGridView);
      end;
    end;

    AQueryRecursiveTree.W.HideNotDeleted;
    // Если есть категории, которые надо удалить
    if AQueryRecursiveTree.FDQuery.RecordCount > 0 then
    begin
      AfrmGridView := TfrmGridView2.Create(Self);
      try
        AfrmGridView.Caption := 'Удаление категорий';
        AfrmGridView.cxbtnOK.Caption := 'Удалить';
        AfrmGridView.ViewGridEx.DSWrap := AQueryRecursiveTree.W;
        OK := AfrmGridView.ShowModal = mrOk;
      finally
        FreeAndNil(AfrmGridView);
      end;

      if OK then
        AQueryRecursiveTree.DeleteAll;
    end;

  finally
    FreeAndNil(AQueryRecursiveTree);
  end;

  // Перечитываем дерево из БД
  cxDBTreeList.BeginUpdate;
  try
    qTreeList.W.RefreshQuery;
  finally
    cxDBTreeList.EndUpdate;
    cxDBTreeList.FocusedNode.Expand(False);
  end;
end;

procedure TViewTreeList.actRenameExecute(Sender: TObject);
var
  Value: string;
begin
  inherited;
  qTreeList.W.TryPost;

  Value := InputBox(sDatabase, sPleaseWrite, qTreeList.W.Value.F.AsString);
  if (Value <> '') and (qTreeList.W.CheckPossibility(qTreeList.W.ParentId.F.AsInteger,
    Value)) then
  begin
    qTreeList.W.TryEdit;
    qTreeList.W.Value.F.AsString := Value;
    qTreeList.W.TryPost;
  end;
end;

procedure TViewTreeList.actDuplicateExecute(Sender: TObject);
begin
  inherited;
  cxSplitter.OpenSplitter;
  Assert(qTreeList.FDQuery.RecordCount > 0);
end;

procedure TViewTreeList.actSearchExecute(Sender: TObject);
var
  AExternalID: string;
begin
  inherited;
  AExternalID := VarToStrDef(cxbeiSearch.EditValue, '');
  if AExternalID.IsEmpty then
    Exit;

  // Ищем
  if not qTreeList.W.LocateByExternalID(AExternalID, [lxoPartialKey]) then
    TDialog.Create.CategoryNotExist(AExternalID);
end;

procedure TViewTreeList.cxbeiSearchPropertiesChange(Sender: TObject);
begin
  inherited;
  actSearch.Enabled := not VarToStrDef(cxbeiSearch.CurEditValue, '').IsEmpty;
end;

procedure TViewTreeList.cxbeiSearchPropertiesEditValueChanged(Sender: TObject);
begin
  inherited;
  // Сразу же сохраняем редактируемое значение
  (Sender as TcxTextEdit).PostEditValue;
  actSearch.Execute;
end;

procedure TViewTreeList.cxDBTreeListClick(Sender: TObject);
begin
  inherited;
  cxDBTreeList.ApplyBestFit;
end;

procedure TViewTreeList.cxDBTreeListCollapsed(Sender: TcxCustomTreeList;
ANode: TcxTreeListNode);
begin
  inherited;
  cxDBTreeList.ApplyBestFit;
  /// todo: придумать как обработать правильно
  cxDBTreeList.OptionsView.ScrollBars := ssBoth;
end;

procedure TViewTreeList.cxDBTreeListDragDrop(Sender, Source: TObject;
X, Y: Integer);
begin
  inherited;
  with TcxTreeList(Sender) do
  begin
    HitTest.ReCalculate(Point(X, Y));
    if HitTest.HitAtBackground then
    begin
      HitTest.HitTestItem := Root;
    end;
    // cn := HitTest.HitTestItem.ClassName;
  end;
end;

procedure TViewTreeList.cxDBTreeListDragOver(Sender, Source: TObject;
X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  inherited;
  Accept := True;
end;

procedure TViewTreeList.cxDBTreeListExpanded(Sender: TcxCustomTreeList;
ANode: TcxTreeListNode);
var
  vOldWidth: Integer;
begin
  inherited;

  vOldWidth := clValue.DisplayWidth;
  clValue.ApplyBestFit;
  // tlLeftControl.ApplyBestFit;
  if clValue.DisplayWidth < vOldWidth then
  // при раскрытии убедиться что ширина не станет меньше чем была
  begin
    Application.ProcessMessages;
    clValue.DisplayWidth := vOldWidth;
    clValue.Width := vOldWidth;
    clValue.MinWidth := vOldWidth;
  end;
  cxDBTreeList.OptionsView.ScrollBars := ssBoth;
end;

procedure TViewTreeList.cxDBTreeListMouseUp(Sender: TObject;
Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  MyUpdateView(X, Y);
end;

procedure TViewTreeList.cxSplitterAfterClose(Sender: TObject);
begin
  inherited;
  if qTreeList = nil then
    Exit;

  qTreeList.AutoSearchDuplicate := False;
end;

procedure TViewTreeList.cxSplitterAfterOpen(Sender: TObject);
begin
  inherited;
  if qTreeList = nil then
    Exit;
  qTreeList.AutoSearchDuplicate := True;
end;

procedure TViewTreeList.DoOnDuplicateClick(Sender: TObject);
begin
  qTreeList.GotoDuplicate;
end;

procedure TViewTreeList.ExpandRoot;
begin
  Assert(cxDBTreeList.Root.Count >= 1);
  cxDBTreeList.Root.Items[0].Expand(False);
end;

function TViewTreeList.GetLevel(ANode: TcxTreeListNode): Integer;
begin
  Result := 1;
  if ANode.Parent <> nil then
    Result := Result + GetLevel(ANode.Parent);
end;

procedure TViewTreeList.MyUpdateView(X, Y: Integer);

begin
  UpdateView;
  if not actRename.Enabled then
    Exit;

  actRename.Enabled := True;

  with cxDBTreeList do
  begin
    OptionsData.Editing := True;
    HitTest.ReCalculate(Point(X, Y));

    if HitTest.HitAtBackground then
    begin
      qTreeList.W.LocateToRoot;
      actRename.Enabled := False;
      OptionsData.Editing := False;
    end;

    if HitTest.HitAtNode then
    begin
      if qTreeList.W.IsRootFocused then
      begin
        actRename.Enabled := False;
        OptionsData.Editing := False;
      end;
    end;
  end;
end;

procedure TViewTreeList.SetqTreeList(const Value: TQueryTreeList);
begin
  if FqTreeList = Value then
    Exit;

  FqTreeList := Value;

  if FqTreeList = nil then
    Exit;

  cxDBTreeList.DataController.DataSource := qTreeList.W.DataSource;
  cxDBTreeList.DataController.KeyField := qTreeList.W.PKFieldName;
  cxDBTreeList.DataController.ParentField := qTreeList.W.ParentId.FieldName;

  ViewDuplicateCategory.qDuplicateCategory := FqTreeList.qDuplicateCategory;

  TNotifyEventWrap.Create(FqTreeList.qDuplicateCategory.OnDuplicateClick,
    DoOnDuplicateClick, FEventList);

  UpdateView;
end;

procedure TViewTreeList.UpdateView;
var
  OK: Boolean;
begin
  OK := (qTreeList <> nil) and (qTreeList.FDQuery.Active);

  actCopy.Enabled := OK;
  actAdd.Enabled := OK;
  actRename.Enabled := OK;
  actDelete.Enabled := OK;
  actExportTreeToExcelDocument.Enabled := OK;
  actLoadTreeFromExcelDocument.Enabled := OK;
  actDuplicate.Enabled := OK;
  actClear.Enabled := OK;
  actSearch.Enabled := OK and not VarToStrDef(cxbeiSearch.CurEditValue,
    '').IsEmpty;
end;

end.
