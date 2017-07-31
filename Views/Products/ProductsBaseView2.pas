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
  cxMaskEdit, cxDBLookupComboBox, cxDropDownEdit, cxBarEditItem, Data.DB,
  cxCalc, DocFieldInfo, cxButtonEdit;

type
  TViewProductsBase2 = class(TfrmTreeList)
    actCommit: TAction;
    actRollback: TAction;
    actExportToExcelDocument: TAction;
    actOpenInParametricTable: TAction;
    actAddCategory: TAction;
    clID: TcxDBTreeListColumn;
    clIsGroup: TcxDBTreeListColumn;
    clIDComponentGroup: TcxDBTreeListColumn;
    clValue: TcxDBTreeListColumn;
    clIDProducer: TcxDBTreeListColumn;
    clDescription: TcxDBTreeListColumn;
    clDatasheet: TcxDBTreeListColumn;
    clDiagram: TcxDBTreeListColumn;
    clDrawing: TcxDBTreeListColumn;
    clImage: TcxDBTreeListColumn;
    clPackagePins: TcxDBTreeListColumn;
    clYYYY: TcxDBTreeListColumn;
    clMM: TcxDBTreeListColumn;
    clWW: TcxDBTreeListColumn;
    clAmount: TcxDBTreeListColumn;
    clPackaging: TcxDBTreeListColumn;
    clPriceR2: TcxDBTreeListColumn;
    clPriceD2: TcxDBTreeListColumn;
    clPriceR1: TcxDBTreeListColumn;
    clPriceD1: TcxDBTreeListColumn;
    clPriceR: TcxDBTreeListColumn;
    clPriceD: TcxDBTreeListColumn;
    clOriginCountryCode: TcxDBTreeListColumn;
    clOriginCountry: TcxDBTreeListColumn;
    clBatchNumber: TcxDBTreeListColumn;
    clCustomsDeclarationNumber: TcxDBTreeListColumn;
    clStorage: TcxDBTreeListColumn;
    clStoragePlace: TcxDBTreeListColumn;
    clSeller: TcxDBTreeListColumn;
    clDocumentNumber: TcxDBTreeListColumn;
    clBarcode: TcxDBTreeListColumn;
    actAddComponent: TAction;
    actDelete: TAction;
    dxBarManagerBar2: TdxBar;
    dxbcRate1: TdxBarCombo;
    dxbcRate2: TdxBarCombo;
    cxbeiRate: TcxBarEditItem;
    actOpenDatasheet: TAction;
    actLoadDatasheet: TAction;
    actOpenImage: TAction;
    actLoadImage: TAction;
    actOpenDiagram: TAction;
    actLoadDiagram: TAction;
    actOpenDrawing: TAction;
    actLoadDrawing: TAction;
    procedure actAddCategoryExecute(Sender: TObject);
    procedure actAddComponentExecute(Sender: TObject);
    procedure actCommitExecute(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure actExportToExcelDocumentExecute(Sender: TObject);
    procedure actLoadDatasheetExecute(Sender: TObject);
    procedure actLoadDiagramExecute(Sender: TObject);
    procedure actLoadDrawingExecute(Sender: TObject);
    procedure actLoadImageExecute(Sender: TObject);
    procedure actOpenDatasheetExecute(Sender: TObject);
    procedure actOpenDiagramExecute(Sender: TObject);
    procedure actOpenDrawingExecute(Sender: TObject);
    procedure actOpenImageExecute(Sender: TObject);
    procedure actOpenInParametricTableExecute(Sender: TObject);
    procedure actRollbackExecute(Sender: TObject);
    procedure clDatasheetGetDisplayText(Sender: TcxTreeListColumn;
      ANode: TcxTreeListNode; var Value: string);
    procedure cxbeiRateChange(Sender: TObject);
    procedure cxDBTreeListIsGroupNode(Sender: TcxCustomTreeList;
      ANode: TcxTreeListNode; var IsGroup: Boolean);
    procedure cxDBTreeListFocusedNodeChanged(Sender: TcxCustomTreeList;
      APrevFocusedNode, AFocusedNode: TcxTreeListNode);
    procedure dxbcRate2Change(Sender: TObject);
    procedure dxbcRate1Change(Sender: TObject);
    procedure dxbcRate1DrawItem(Sender: TdxBarCustomCombo; AIndex: Integer;
      ARect: TRect; AState: TOwnerDrawState);
  private
    FProductBaseGroup: TProductBaseGroup;
    procedure DoAfterLoad(Sender: TObject);
    function GetIsFocusedNodeGroup: Boolean;
    procedure SetProductBaseGroup(const Value: TProductBaseGroup);
    { Private declarations }
  protected
    procedure BindRate(ARateField: TField; AdxBarCombo: TdxBarCombo);
    procedure DoAfterScroll(Sender: TObject);
    procedure InitializeColumns;
    procedure OpenDoc(ADocFieldInfo: TDocFieldInfo;
      const AErrorMessage, AEmptyErrorMessage: string);
    function PerсentToRate(APerсent: Double): Double;
    function RateToPerсent(ARate: Double): Double;
    procedure UpdateRate(const ARate: Double; RateField: TField);
    procedure UploadDoc(ADocFieldInfo: TDocFieldInfo);
  public
    constructor Create(AOwner: TComponent); override;
    function CheckAndSaveChanges: Integer;
    procedure UpdateView; override;
    property IsFocusedNodeGroup: Boolean read GetIsFocusedNodeGroup;
    property ProductBaseGroup: TProductBaseGroup read FProductBaseGroup
      write SetProductBaseGroup;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses DialogUnit, RepositoryDataModule, NotifyEvents, System.IOUtils,
  SettingsController, Winapi.Shellapi, System.Generics.Collections,
  System.StrUtils;

constructor TViewProductsBase2.Create(AOwner: TComponent);
begin
  inherited;
  // Список полей при редактировании которых Enter - сохранение
  PostOnEnterFields.Add(clPriceR.DataBinding.FieldName);
  PostOnEnterFields.Add(clPriceD.DataBinding.FieldName);
  InitializeColumns;
end;

procedure TViewProductsBase2.actAddCategoryExecute(Sender: TObject);
begin
  inherited;
  ProductBaseGroup.qProductsBase.AddCategory;

  cxDBTreeList.ApplyBestFit;
  cxDBTreeList.SetFocus;

  // Переводим колонку в режим редактирования
  clValue.Editing := True;
end;

procedure TViewProductsBase2.actAddComponentExecute(Sender: TObject);
var
  AID: Integer;
begin
  inherited;

  cxDBTreeList.Post;

  if cxDBTreeList.FocusedNode.IsGroupNode then
    AID := FocusedNodeValue(clID)
  else
  begin
    Assert(cxDBTreeList.FocusedNode.Parent <> nil);
    AID := cxDBTreeList.FocusedNode.Parent.Values[clID.ItemIndex];
  end;

  ProductBaseGroup.qProductsBase.AddProduct(AID);

  cxDBTreeList.ApplyBestFit;
  cxDBTreeList.SetFocus;

  // Переводим колонку в режим редактирования
  clValue.Editing := True;
end;

procedure TViewProductsBase2.actCommitExecute(Sender: TObject);
begin
  inherited;
  FProductBaseGroup.ApplyUpdates;
  UpdateView;
end;

procedure TViewProductsBase2.actDeleteExecute(Sender: TObject);
var
  AID: Integer;
  AIDS: TList<Integer>;
  i: Integer;
  S: string;
begin
  inherited;
  if cxDBTreeList.SelectionCount = 0 then
    Exit;

  if cxDBTreeList.Selections[0].IsGroupNode then
    S := 'Удалить группу компонентов с текущего склада?'
  else
    S := Format('Удалить %s?', [IfThen(cxDBTreeList.SelectionCount = 1, 'компонент', 'компоненты')]);

  if not(TDialog.Create.DeleteRecordsDialog(S)) then
    Exit;

  AIDS := TList<Integer>.Create;
  try
    // Заполняем список идентификаторов узлов, которые будем удалять
    for i := 0 to cxDBTreeList.SelectionCount - 1 do
    begin
      AIDS.Add(cxDBTreeList.Selections[i].Values[clID.ItemIndex]);
    end;

    cxDBTreeList.BeginUpdate;
    try
      for AID in AIDS do
        ProductBaseGroup.qProductsBase.DeleteNode(AID);
      // Это почему-то не работает
      // cxDBTreeList.DataController.DeleteFocused;
    finally
      cxDBTreeList.EndUpdate;
    end;

  finally
    FreeAndNil(AIDS);
  end;

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

procedure TViewProductsBase2.actLoadDatasheetExecute(Sender: TObject);
begin
  inherited;
  UploadDoc(TDatasheetDoc.Create);
end;

procedure TViewProductsBase2.actLoadDiagramExecute(Sender: TObject);
begin
  inherited;
  UploadDoc(TDiagramDoc.Create);
end;

procedure TViewProductsBase2.actLoadDrawingExecute(Sender: TObject);
begin
  inherited;
  UploadDoc(TDrawingDoc.Create);
end;

procedure TViewProductsBase2.actLoadImageExecute(Sender: TObject);
begin
  inherited;
  UploadDoc(TImageDoc.Create);
end;

procedure TViewProductsBase2.actOpenDatasheetExecute(Sender: TObject);
begin
  inherited;
  OpenDoc(TDatasheetDoc.Create, 'Файл спецификации с именем %s не найден',
    'не задана спецификация');
end;

procedure TViewProductsBase2.actOpenDiagramExecute(Sender: TObject);
begin
  inherited;
  OpenDoc(TDiagramDoc.Create, 'Файл схемы с именем %s не найден',
    'Не задана схема');
end;

procedure TViewProductsBase2.actOpenDrawingExecute(Sender: TObject);
begin
  inherited;
  OpenDoc(TDrawingDoc.Create, 'Файл чертежа с именем %s не найден',
    'Не задан чертёж');
end;

procedure TViewProductsBase2.actOpenImageExecute(Sender: TObject);
begin
  inherited;
  OpenDoc(TImageDoc.Create, 'Файл изображения с именем %s не найден',
    'Не задано изображение');
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

procedure TViewProductsBase2.BindRate(ARateField: TField;
  AdxBarCombo: TdxBarCombo);
var
  r: Double;
begin
  r := RateToPerсent(ARateField.AsFloat);
  if r = 0 then
  begin
    AdxBarCombo.Text := '';
  end
  else
  begin
    AdxBarCombo.Tag := 1;
    AdxBarCombo.Text := Format('%8.2f', [r]);
    AdxBarCombo.Tag := 0;
  end;
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

procedure TViewProductsBase2.clDatasheetGetDisplayText
  (Sender: TcxTreeListColumn; ANode: TcxTreeListNode; var Value: string);
begin
  inherited;
  if not Value.IsEmpty then
    Value := TPath.GetFileNameWithoutExtension(Value);
end;

procedure TViewProductsBase2.cxbeiRateChange(Sender: TObject);
var
  r: Double;
  S: string;
begin
  inherited;
  S := cxbeiRate.EditValue;
  r := StrToFloatDef(S, 0);
  if r <> 0 then
  begin
    // Обновлям курс доллара
    FProductBaseGroup.qProductsBase.Rate := r;
    FProductBaseGroup.qProductsBase.FDQuery.Resync([rmExact, rmCenter]);
  end;
end;

procedure TViewProductsBase2.cxDBTreeListFocusedNodeChanged
  (Sender: TcxCustomTreeList; APrevFocusedNode, AFocusedNode: TcxTreeListNode);
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
  cxDBTreeList.FullCollapse;
  // cxDBTreeList.ApplyBestFit;
end;

procedure TViewProductsBase2.DoAfterScroll(Sender: TObject);
begin
  BindRate(FProductBaseGroup.qProductsBase.Rate1, dxbcRate1);
  BindRate(FProductBaseGroup.qProductsBase.Rate2, dxbcRate2);
end;

procedure TViewProductsBase2.dxbcRate2Change(Sender: TObject);
var
  r: Double;
begin
  inherited;
  if (Sender as TComponent).Tag = 1 then
    Exit;

  r := StrToFloatDef(dxbcRate2.Text, 0);
  if r = 0 then
    Exit;

  UpdateRate(PerсentToRate(r), FProductBaseGroup.qProductsBase.Rate2);
end;

procedure TViewProductsBase2.dxbcRate1Change(Sender: TObject);
var
  r: Double;
begin
  inherited;
  if (Sender as TComponent).Tag = 1 then
    Exit;

  r := StrToFloatDef(dxbcRate1.Text, 0);
  if r = 0 then
    Exit;

  UpdateRate(PerсentToRate(r), FProductBaseGroup.qProductsBase.Rate1);
end;

const
  clClickedColor = clRed;

procedure TViewProductsBase2.dxbcRate1DrawItem(Sender: TdxBarCustomCombo;
  AIndex: Integer; ARect: TRect; AState: TOwnerDrawState);
var
  S: string;
begin
  inherited;

  if odSelected in AState then
  begin
    Brush.Color := clClickedColor;
    Font.Color := clHighlightText;
  end
  else
  begin
    Brush.Color := clWindow;
    Font.Color := clWindowText;
  end;

  Sender.Canvas.FillRect(ARect);
  if odFocused in AState then
    DrawFocusRect(Sender.Canvas.Handle, ARect);

  if AIndex >= 0 then
    S := Sender.Items[AIndex]
  else
    S := Sender.Text;
  if S <> '' then
    S := S + '%';

  Sender.Canvas.TextOut(ARect.Left + 2, ARect.Top + 2, S);
end;

function TViewProductsBase2.GetIsFocusedNodeGroup: Boolean;
var
  ANode: TcxTreeListNode;
  V: Variant;
begin
  Result := False;
  ANode := cxDBTreeList.FocusedNode;
  if ANode = nil then
    Exit;

  V := ANode.Values[clIsGroup.ItemIndex];
  Result := not VarIsNull(V) and (V = 1);
end;

procedure TViewProductsBase2.InitializeColumns;
var
  i: Integer;
begin
  for i := 0 to cxDBTreeList.ColumnCount - 1 do
  begin
    cxDBTreeList.Columns[i].MinWidth := 100;
  end;
end;

procedure TViewProductsBase2.OpenDoc(ADocFieldInfo: TDocFieldInfo;
  const AErrorMessage, AEmptyErrorMessage: string);
var
  AFileName: string;
begin
  if FProductBaseGroup.qProductsBase.FDQuery.FieldByName
    (ADocFieldInfo.FieldName).AsString <> '' then
  begin
    AFileName := TPath.Combine(TPath.Combine(TSettings.Create.DataBasePath,
      ADocFieldInfo.Folder), FProductBaseGroup.qProductsBase.FDQuery.FieldByName
      (ADocFieldInfo.FieldName).AsString);

    if FileExists(AFileName) then
      ShellExecute(Handle, nil, PChar(AFileName), nil, nil, SW_SHOWNORMAL)
    else
      TDialog.Create.ErrorMessageDialog(Format(AErrorMessage, [AFileName]));
  end
  else
    TDialog.Create.ErrorMessageDialog(AEmptyErrorMessage);

end;

function TViewProductsBase2.PerсentToRate(APerсent: Double): Double;
begin
  Result := 1 + APerсent / 100
end;

function TViewProductsBase2.RateToPerсent(ARate: Double): Double;
begin
  if ARate <= 0 then
  begin
    Result := 0;
    Exit;
  end;

  if ARate > 1 then
  begin
    Result := (ARate - 1) * 100;
  end
  else
  begin
    Result := (1 - ARate) * -100
  end;

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

  InitializeLookupColumn(clIDProducer,
    FProductBaseGroup.qProductsBase.qProducers.DataSource, lsEditFixedList,
    FProductBaseGroup.qProductsBase.qProducers.Name.FieldName);

  TNotifyEventWrap.Create(FProductBaseGroup.qProductsBase.AfterScroll,
    DoAfterScroll);

  UpdateView;
end;

procedure TViewProductsBase2.UpdateRate(const ARate: Double; RateField: TField);
var
  ANode: TcxDBTreeListNode;
  i: Integer;
  OK: Boolean;
begin
  FProductBaseGroup.qProductsBase.FDQuery.DisableControls;
  try
    for i := 0 to cxDBTreeList.SelectionCount - 1 do
    begin
      ANode := cxDBTreeList.Selections[i] as TcxDBTreeListNode;
      if ANode.IsGroupNode then
        Continue;
      OK := FProductBaseGroup.qProductsBase.LocateByPK
        (ANode.Values[clID.ItemIndex]);
      Assert(OK);
      FProductBaseGroup.qProductsBase.TryEdit;
      RateField.Value := ARate;
      FProductBaseGroup.qProductsBase.TryPost;
    end;
  finally
    FProductBaseGroup.qProductsBase.FDQuery.EnableControls;
  end;
end;

procedure TViewProductsBase2.UpdateView;
var
  OK: Boolean;
begin
  inherited;
  OK := (ProductBaseGroup <> nil) and
    (ProductBaseGroup.qProductsBase.FDQuery.Active);
  actCommit.Enabled := OK and ProductBaseGroup.qProductsBase.HaveAnyChanges;
  actRollback.Enabled := actCommit.Enabled;
  actExportToExcelDocument.Enabled := OK and
    (cxDBTreeList.DataController.DataSet.RecordCount > 0);
  actOpenInParametricTable.Enabled := OK and
    (cxDBTreeList.DataController.DataSet.RecordCount > 0);

  actAddCategory.Enabled := OK;

  actAddComponent.Enabled := OK and (cxDBTreeList.FocusedNode <> nil);

  actDelete.Enabled := OK and (cxDBTreeList.FocusedNode <> nil) and
    (cxDBTreeList.DataController.DataSet.RecordCount > 0);

  cxbeiRate.EditValue := ProductBaseGroup.qProductsBase.Rate;
end;

procedure TViewProductsBase2.UploadDoc(ADocFieldInfo: TDocFieldInfo);
var
  sourceFileName: string;
begin
  // Открываем диалог выбора файла для загрузки
  sourceFileName := TDialog.Create.OpenPictureDialog(ADocFieldInfo.Folder);
  if sourceFileName.IsEmpty then
    Exit;

  FProductBaseGroup.qProductsBase.LoadDocFile(sourceFileName, ADocFieldInfo);
end;

end.
