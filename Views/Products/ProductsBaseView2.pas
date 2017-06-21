unit ProductsBaseView2;

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
  dxSkinXmas2008Blue, dxSkinsdxBarPainter, System.Actions, Vcl.ActnList,
  cxClasses, dxBar, cxInplaceContainer, cxTLData, cxDBTL, ProductBaseGroupUnit,
  cxMaskEdit;

type
  TViewProductsBase2 = class(TfrmTreeList)
    actCommit: TAction;
    actRollback: TAction;
    actExportToExcelDocument: TAction;
    actOpenInParametricTable: TAction;
    actAddCategory: TAction;
    dxBarButton1: TdxBarButton;
    clID: TcxDBTreeListColumn;
    clValue: TcxDBTreeListColumn;
    clIDProducer: TcxDBTreeListColumn;
    clIsGroup: TcxDBTreeListColumn;
    actAddComponent: TAction;
    dxBarSubItem1: TdxBarSubItem;
    dxBarButton2: TdxBarButton;
    procedure actAddCategoryExecute(Sender: TObject);
    procedure actCommitExecute(Sender: TObject);
    procedure actExportToExcelDocumentExecute(Sender: TObject);
    procedure actOpenInParametricTableExecute(Sender: TObject);
    procedure actRollbackExecute(Sender: TObject);
    procedure cxDBTreeListIsGroupNode(Sender: TcxCustomTreeList;
      ANode: TcxTreeListNode; var IsGroup: Boolean);
    procedure cxDBTreeListEdited(Sender: TcxCustomTreeList;
      AColumn: TcxTreeListColumn);
    procedure cxDBTreeListFocusedNodeChanged(Sender: TcxCustomTreeList;
        APrevFocusedNode, AFocusedNode: TcxTreeListNode);
  private
    FProductBaseGroup: TProductBaseGroup;
    procedure DoAfterLoad(Sender: TObject);
    function GetIsFocusedNodeGroup: Boolean;
    procedure SetProductBaseGroup(const Value: TProductBaseGroup);
    { Private declarations }
  public
    function CheckAndSaveChanges: Integer;
    procedure UpdateView; override;
    property IsFocusedNodeGroup: Boolean read GetIsFocusedNodeGroup;
    property ProductBaseGroup: TProductBaseGroup read FProductBaseGroup
      write SetProductBaseGroup;
    { Public declarations }
  end;

var
  ViewProductsBase2: TViewProductsBase2;

implementation

{$R *.dfm}

uses DialogUnit, RepositoryDataModule, NotifyEvents;

procedure TViewProductsBase2.actAddCategoryExecute(Sender: TObject);
begin
  inherited;
  ProductBaseGroup.qProductsBase.AddCategory;

  cxDBTreeList.ApplyBestFit;
  cxDBTreeList.SetFocus;

  // Переводим колонку в режим редактирования
  clValue.Editing := True;
  // cxDBTreeList.VisibleColumns[clValue.VisibleIndex].Editing := True;
end;

procedure TViewProductsBase2.actCommitExecute(Sender: TObject);
begin
  inherited;
  FProductBaseGroup.ApplyUpdates;
  UpdateView;
end;

procedure TViewProductsBase2.actExportToExcelDocumentExecute(Sender: TObject);
var
  AFileName: String;
begin
  inherited;

  AFileName := ProductBaseGroup.qProductsBase.ExportFileName;
  AFileName := TDialog.Create.SaveToExcelFile(AFileName);
  if AFileName = '' then
    Exit;

  // Тут надо создать какое-то табличное представление
  {
    ExportViewToExcel(MainView, AFileName,
    procedure(AView: TcxGridDBBandedTableView)
    begin
    AView.Bands[0].FixedKind := fkNone;
    end);
  }
end;

procedure TViewProductsBase2.actOpenInParametricTableExecute(Sender: TObject);
begin
  inherited;
  Assert(ProductBaseGroup.qProductsBase.FDQuery.RecordCount > 0);

  if ProductBaseGroup.qProductsBase.Value.AsString.Trim.IsEmpty then
  begin
    TDialog.Create.ErrorMessageDialog('Не задано наименование');
    Exit;
  end;

  if ProductBaseGroup.qProductsBase.IDProducer.AsInteger = 0 then
  begin
    TDialog.Create.ErrorMessageDialog('Не задан производитель');
    Exit;
  end;

  if not ProductBaseGroup.qProductsBase.LocateInComponents then
  begin
    TDialog.Create.ErrorMessageDialog
      (Format('Компонент %s не найден в теоретической базе',
      [ProductBaseGroup.qProductsBase.Value.AsString]));
    Exit;
  end;

end;

procedure TViewProductsBase2.actRollbackExecute(Sender: TObject);
begin
  inherited;
  ProductBaseGroup.CancelUpdates;
  UpdateView;
end;

function TViewProductsBase2.CheckAndSaveChanges: Integer;
begin
  Result := 0;
  if ProductBaseGroup = nil then
    Exit;

  if ProductBaseGroup.HaveAnyChanges then
  begin
    Result := TDialog.Create.SaveDataDialog;
    case Result of
      IDYES:
        actCommit.Execute;
      IDNO:
        begin
          actRollback.Execute;
        end;
    end;
  end;
end;

procedure TViewProductsBase2.cxDBTreeListEdited(Sender: TcxCustomTreeList;
  AColumn: TcxTreeListColumn);
begin
  inherited;
  Sender.Post;
  UpdateView;
end;

procedure TViewProductsBase2.cxDBTreeListFocusedNodeChanged(Sender:
    TcxCustomTreeList; APrevFocusedNode, AFocusedNode: TcxTreeListNode);
begin
  inherited;
  UpdateView;
end;

procedure TViewProductsBase2.cxDBTreeListIsGroupNode(Sender: TcxCustomTreeList;
  ANode: TcxTreeListNode; var IsGroup: Boolean);
var
  V: Variant;
begin
  inherited;
  V := ANode.Values[clIsGroup.ItemIndex];
  IsGroup := not VarIsNull(V) and (V = 1);
end;

procedure TViewProductsBase2.DoAfterLoad(Sender: TObject);
begin
  UpdateView;

end;

function TViewProductsBase2.GetIsFocusedNodeGroup: Boolean;
var
  ANode: TcxTreeListNode;
  V: Variant;
begin
  Result := False;
  ANode := cxDBTreeList.FocusedNode;
  if ANode = nil then Exit;

  V := ANode.Values[clIsGroup.ItemIndex];
  Result := not VarIsNull(V) and (V = 1);
end;

procedure TViewProductsBase2.SetProductBaseGroup(const Value
  : TProductBaseGroup);
begin
  if FProductBaseGroup = Value then
    Exit;

  FProductBaseGroup := Value;

  if FProductBaseGroup = nil then
    Exit;

  cxDBTreeList.DataController.DataSource :=
    FProductBaseGroup.qProductsBase.DataSource;

  TNotifyEventWrap.Create(FProductBaseGroup.qProductsBase.AfterLoad,
    DoAfterLoad);

  UpdateView;
end;

procedure TViewProductsBase2.UpdateView;
var
  Ok: Boolean;
begin
  inherited;
  Ok := (ProductBaseGroup <> nil) and
    (ProductBaseGroup.qProductsBase.FDQuery.Active);
  actCommit.Enabled := Ok and ProductBaseGroup.qProductsBase.HaveAnyChanges;
  actRollback.Enabled := actCommit.Enabled;
  actExportToExcelDocument.Enabled := Ok and
    (ProductBaseGroup.qProductsBase.FDQuery.RecordCount > 0);
  actOpenInParametricTable.Enabled := Ok and
    (cxDBTreeList.DataController.RecordCount > 0);

  actAddCategory.Enabled := Ok;

  actAddComponent.Enabled := OK and IsFocusedNodeGroup;
end;

end.
