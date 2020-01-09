unit ProductsView2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ProductsBaseView2, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxCustomData, cxStyles,
  cxTL, cxMaskEdit, cxDBLookupComboBox, cxButtonEdit, cxTLdxBarBuiltInMenu,
  dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
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
  dxSkinXmas2008Blue, dxSkinsdxBarPainter, cxCalc, System.Actions, Vcl.ActnList,
  cxBarEditItem, dxBar, cxClasses, cxInplaceContainer, cxDBTL, cxTLData,
  System.Generics.collections, FieldInfoUnit, ProductsExcelDataModule,
  Vcl.Menus, Vcl.ComCtrls, System.Contnrs, ProgressBarForm2, ExcelDataModule,
  cxDropDownEdit, ProductsQuery, cxTextEdit, Vcl.ExtCtrls,
  cxDBExtLookupComboBox, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator,
  Data.DB, cxDBData, cxGridCustomTableView, cxGridTableView,
  cxGridBandedTableView, cxGridDBBandedTableView, cxGridCustomView, cxGrid,
  cxCalendar, cxDataControllerConditionalFormattingRulesManagerDialog,
  ProductsBaseQuery, cxCurrencyEdit;

type
  TViewProducts2 = class(TViewProductsBase2)
    dxBarSubItem1: TdxBarSubItem;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    dxBarButton3: TdxBarButton;
    dxBarButton4: TdxBarButton;
    dxBarButton5: TdxBarButton;
    dxBarButton6: TdxBarButton;
    dxBarSubItem2: TdxBarSubItem;
    dxBarButton9: TdxBarButton;
    actColumnsAutoWidth2: TAction;
    dxBarButton7: TdxBarButton;
    actFullScreen: TAction;
    dxBarButton8: TdxBarButton;
    actFilterAndExportToExcelDocument: TAction;
    dxBarButton10: TdxBarButton;
    actCalcCount: TAction;
    actTryEdit: TAction;
    actDisContrl: TAction;
    actEnContrl: TAction;
    actIsContolDis: TAction;
    actLoadFromExcelDocument: TAction;
    dxBarSubItem3: TdxBarSubItem;
    dxBarButton17: TdxBarButton;
    procedure actColumnsAutoWidth2Execute(Sender: TObject);
    procedure actExportToExcelDocument2Execute(Sender: TObject);
    procedure actFilterAndExportToExcelDocumentExecute(Sender: TObject);
    procedure actFullScreenExecute(Sender: TObject);
    procedure actCalcCountExecute(Sender: TObject);
    procedure actDisContrlExecute(Sender: TObject);
    procedure actEnContrlExecute(Sender: TObject);
    procedure actIsContolDisExecute(Sender: TObject);
    procedure actLoadFromExcelDocumentExecute(Sender: TObject);
    procedure actTryEditExecute(Sender: TObject);
    procedure cxBarEditItem1PropertiesValidate(Sender: TObject;
      var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
    procedure cxbeiWholeSalePropertiesDrawItem(AControl: TcxCustomComboBox;
      ACanvas: TcxCanvas; AIndex: Integer; const ARect: TRect;
      AState: TOwnerDrawState);
    procedure cxbeiWholeSalePropertiesEditValueChanged(Sender: TObject);
    procedure cxBarEditItem1PropertiesDrawItem(AControl: TcxCustomComboBox;
      ACanvas: TcxCanvas; AIndex: Integer; const ARect: TRect;
      AState: TOwnerDrawState);
    procedure clIDProducerPropertiesNewLookupDisplayText(Sender: TObject;
      const AText: TCaption);
  private const
    FolderKey: String = 'Products';
    function GetqProducts: TQueryProducts;
    procedure SetqProducts(const Value: TQueryProducts);
    { Private declarations }
  protected
    function CreateProductView: TViewProductsBase2; override;
    function GetW: TProductW; override;
    procedure InitializeColumns; override;
    procedure UpdateProductCount; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure LoadFromExcelDocument(const AFileName: String);
    procedure UpdateView; override;
    property qProducts: TQueryProducts read GetqProducts write SetqProducts;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses RepositoryDataModule, ProgressBarForm, ProjectConst, CustomExcelTable,
  NotifyEvents, ProgressInfo, LoadFromExcelFileHelper,
  CustomErrorForm, HttpUnit, ProductsViewForm, DialogUnit, CurrencyUnit,
  DialogUnit2;

constructor TViewProducts2.Create(AOwner: TComponent);
begin
  inherited;
  Name := 'ViewProducts2';
end;

procedure TViewProducts2.actColumnsAutoWidth2Execute(Sender: TObject);
begin
  inherited;
  // cxDBTreeList.BeginUpdate;
  // try
  cxDBTreeList.Root.Expand(true);

  MyApplyBestFit;
  // cxDBTreeList.Root.Collapse(true);
  // finally
  // cxDBTreeList.EndUpdate;
  // end;
end;

procedure TViewProducts2.actExportToExcelDocument2Execute(Sender: TObject);
var
  AFileName: String;
  AViewProducts2: TViewProducts2;
begin
  inherited;
  Application.Hint := '';
  if not TDialog.Create.ShowDialog(TExcelFileSaveDialog, '',
    qProductsBase.ExportFileName, AFileName) then
    Exit;

  AViewProducts2 := TViewProducts2.Create(nil);
  try
    AViewProducts2.qProducts := qProducts;
    AViewProducts2.ExportToExcelDocument(AFileName);
  finally
    FreeAndNil(AViewProducts2);
  end;
end;

procedure TViewProducts2.actFilterAndExportToExcelDocumentExecute
  (Sender: TObject);
var
  AFileName: String;
  AIDArray: TArray<Integer>;
  AQueryProducts: TQueryProducts;
  AViewProducts2: TViewProducts2;
  rc: Integer;
begin
  inherited;
  if not TDialog.Create.ShowDialog(TExcelFileSaveDialog, '',
    qProductsBase.ExportFileName, AFileName) then
    Exit;

  AIDArray := GetSelectedID;

  AQueryProducts := TQueryProducts.Create(nil);
  try
    rc := AQueryProducts.SearchByID(AIDArray);
    Assert(rc > 0);
    AViewProducts2 := TViewProducts2.Create(nil);
    try
      AViewProducts2.qProducts := AQueryProducts;
      AViewProducts2.ExportToExcelDocument(AFileName);
    finally
      FreeAndNil(AViewProducts2);
    end;
  finally
    FreeAndNil(AQueryProducts);
  end;
end;

procedure TViewProducts2.actFullScreenExecute(Sender: TObject);
begin
  inherited;
  if frmProducts = nil then
  begin
    frmProducts := TfrmProducts.Create(Self);
    frmProducts.ViewProducts2.qProducts := qProducts;
  end;
  frmProducts.Show;
end;

procedure TViewProducts2.actCalcCountExecute(Sender: TObject);
begin
  inherited;
  ShowMessage(qProducts.CalcExecCount.ToString);
end;

procedure TViewProducts2.actDisContrlExecute(Sender: TObject);
begin
  inherited;
  W.DataSource.Enabled := False;
end;

procedure TViewProducts2.actEnContrlExecute(Sender: TObject);
begin
  inherited;
  BeginUpdate;
  cxDBTreeList.DataController.DataSource := qProducts.W.DataSource;
  EndUpdate;
end;

procedure TViewProducts2.actIsContolDisExecute(Sender: TObject);
begin
  inherited;
  ShowMessage(BoolToStr(cxDBTreeList.DataController.DataSource <> nil, true));
end;

procedure TViewProducts2.actLoadFromExcelDocumentExecute(Sender: TObject);
var
  AFileName: String;
begin
  Application.Hint := '';

  Assert(qProducts.Master <> nil);

  if qProducts.Master.FDQuery.RecordCount = 0 then
  begin
    TDialog.Create.ErrorMessageDialog
      ('Нет информации о текущем складе.'#13#10'Действие отменено');
    Exit;
  end;

  // Открываем диалог выбора excel файла из последнего места
  if not TOpenExcelDialog.SelectInFolder(AFileName, Handle, FolderKey) then
    Exit;

  LoadFromExcelDocument(AFileName);
  UpdateView;
  // Сразу пытаемся сохранить. Тут возникает диалог выбора оптовой наценки
  actCommit.Execute;
end;

procedure TViewProducts2.actTryEditExecute(Sender: TObject);
begin
  inherited;
  FHRTimer.StartTimer;
  // ShowMessage('0');
  W.TryEdit;
  ShowMessage(Format('Время: %f', [FHRTimer.ReadTimer]));
end;

procedure TViewProducts2.clIDProducerPropertiesNewLookupDisplayText
  (Sender: TObject; const AText: TCaption);
begin
  inherited;;
end;

function TViewProducts2.CreateProductView: TViewProductsBase2;
begin
  Result := TViewProducts2.Create(nil);
end;

procedure TViewProducts2.cxBarEditItem1PropertiesDrawItem
  (AControl: TcxCustomComboBox; ACanvas: TcxCanvas; AIndex: Integer;
  const ARect: TRect; AState: TOwnerDrawState);
var
  S: string;
begin
  inherited;
  if odSelected in AState then
  begin
    Brush.Color := clRed;
    Font.Color := clHighlightText;
  end
  else
  begin
    Brush.Color := clWindow;
    Font.Color := clWindowText;
  end;

  ACanvas.FillRect(ARect);
  if odFocused in AState then
    DrawFocusRect(ACanvas.Handle, ARect);

  if AIndex >= 0 then
    S := AControl.Properties.Items[AIndex]
  else
    S := AControl.Text;
  if S <> '' then
    S := S + '%';

  ACanvas.TextOut(ARect.Left, ARect.Top, S);

end;

procedure TViewProducts2.cxBarEditItem1PropertiesValidate(Sender: TObject;
  var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
var
  x: Double;
begin
  inherited;
  x := StrToFloatDef(DisplayValue, 0);
  if x > 0 then
    Exit;

  ErrorText := 'Редактируемое значение не является курсом валюты';
  Error := true;
end;

procedure TViewProducts2.cxbeiWholeSalePropertiesDrawItem
  (AControl: TcxCustomComboBox; ACanvas: TcxCanvas; AIndex: Integer;
  const ARect: TRect; AState: TOwnerDrawState);
begin
  inherited;;
end;

procedure TViewProducts2.cxbeiWholeSalePropertiesEditValueChanged
  (Sender: TObject);
begin
  inherited;;
end;

function TViewProducts2.GetqProducts: TQueryProducts;
begin
  Result := qProductsBase as TQueryProducts;
end;

function TViewProducts2.GetW: TProductW;
begin
  Result := qProducts.W;
end;

procedure TViewProducts2.InitializeColumns;
begin
  inherited;

  Assert(qProducts <> nil);
  Assert(clStoreHouseID.Position.Band <> nil);

  clStoreHouseID.Position.Band.Visible := False;
end;

procedure TViewProducts2.LoadFromExcelDocument(const AFileName: String);
var
  AChildNode: TStringTreeNode;
  AErrorList: TList<String>;
  AExcelTable: TProductsExcelTable;
  AFI: TFieldInfoEx;
  ANode: TStringTreeNode;
  ARootTreeNode: TStringTreeNode;
  FieldsInfo, FieldsInfo2: TFieldsInfoEx;
  S: string;
begin
  Assert(not AFileName.IsEmpty);

  FieldsInfo := TFieldsInfoEx.Create;
  FieldsInfo2 := TFieldsInfoEx.Create;

  FieldsInfo.Add(TFieldInfoEx.Create('ComponentGroup', true,
    'Группа компонентов не задана', 'Группа компонентов', true));
  FieldsInfo.Add(TFieldInfoEx.Create('Value', true, 'Наименование не задано',
    'Наименование'));
  FieldsInfo.Add(TFieldInfoEx.Create('Producer', true, 'Производитель не задан',
    'Производитель'));
  FieldsInfo.Add(TFieldInfoEx.Create('PackagePins', False, '', 'Корпус'));
  FieldsInfo.Add(TFieldInfoEx.Create('ReleaseDate', False, '', 'Дата выпуска'));
  FieldsInfo.Add(TFieldInfoEx.Create('Amount', true, 'Количество не задано',
    'Количество'));
  FieldsInfo.Add(TFieldInfoEx.Create('Packaging', False, '', 'Упаковка'));
  FieldsInfo.Add(TFieldInfoEx.Create('PriceR', False, '',
    'Закупочная цена (без НДС)|₽'));
  FieldsInfo.Add(TFieldInfoEx.Create('PriceD', False, '',
    'Закупочная цена (без НДС)|$'));
  FieldsInfo.Add(TFieldInfoEx.Create('PriceE', False, '',
    'Закупочная цена (без НДС)|€'));
  FieldsInfo.Add(TFieldInfoEx.Create('OriginCountryCode', False, '',
    'Страна происхождения|Цифровой код'));
  FieldsInfo.Add(TFieldInfoEx.Create('OriginCountry', False, '',
    'Страна происхождения|Название'));
  FieldsInfo.Add(TFieldInfoEx.Create('BatchNumber', False, '', 'Номер партии'));
  FieldsInfo.Add(TFieldInfoEx.Create('CustomsDeclarationNumber', False, '',
    'Номер таможенной декларации'));
  FieldsInfo.Add(TFieldInfoEx.Create('Storage', False, '',
    'Место хранения|Стеллаж №'));
  FieldsInfo.Add(TFieldInfoEx.Create('StoragePlace', False, '',
    'Место хранения|Место №'));
  FieldsInfo.Add(TFieldInfoEx.Create('Seller', False, '',
    'Организация - продавец'));
  FieldsInfo.Add(TFieldInfoEx.Create('DocumentNumber', False, '',
    '№ документа'));
  FieldsInfo.Add(TFieldInfoEx.Create('Barcode', False, '',
    'Цифровой код (Штрих-код)'));
  FieldsInfo.Add(TFieldInfoEx.Create('LoadDate', False, '', 'Дата загрузки'));
  FieldsInfo.Add(TFieldInfoEx.Create('Dollar', False, '', 'Курсы валют|$'));
  FieldsInfo.Add(TFieldInfoEx.Create('Euro', False, '', 'Курсы валют|€'));

  ARootTreeNode := TExcelDM.LoadExcelFileHeader(AFileName);
  AErrorList := TList<String>.Create;
  // Цикл по всем дочерним узлам
  for ANode in ARootTreeNode.Childs do
  begin
    // Если есть дочерние колонки
    if ANode.Childs.Count > 0 then
    begin
      for AChildNode in ANode.Childs do
      begin
        // Ищем описание этого поля
        AFI := FieldsInfo.Find(ANode.Value.Trim + '|' +
          AChildNode.Value.Trim, true);
        if AFI <> nil then
        begin
          Assert(not AFI.Exist);
          AFI.Exist := true;
          FieldsInfo2.Add(AFI);
        end
        else
          AErrorList.Add(ANode.Value.Trim + ' ' + AChildNode.Value.Trim)
      end;
    end
    else
    begin
      // Ищем описание этого поля
      AFI := FieldsInfo.Find(ANode.Value.Trim, False);
      if AFI <> nil then
      begin
        Assert(not AFI.Exist);
        AFI.Exist := true;
        FieldsInfo2.Add(AFI);
      end
      else
        AErrorList.Add(ANode.Value.Trim + ' ' + AChildNode.Value.Trim)
    end;
  end;

  if AErrorList.Count > 0 then
  begin
    S := Format('Не распознанная колонка в документе Excel.'#13#10'"%s"',
      [AErrorList[0]]);

    TDialog.Create.ErrorMessageDialog(S);
    Exit;
  end;

  for AFI in FieldsInfo do
  begin
    // Отсутсвует обязательное для заполнение поле
    if AFI.Required and not AFI.Exist then
    begin
      S := Format('Не найдена обязательная для заполнения колонка.'#13#10'"%s"',
        [AFI.DisplayLabel.Replace('|', #13#10)]);

      TDialog.Create.ErrorMessageDialog(S);
      Exit;
    end;
  end;

  BeginUpdate;
  try
    TLoad.Create.LoadAndProcess(AFileName, TProductsExcelDM, TfrmCustomError,
      procedure(ASender: TObject)
      begin
        qProducts.LoadDataFromExcelTable(ASender as TProductsExcelTable);
      end,
      procedure(ASender: TObject)
      begin
        AExcelTable := ASender as TProductsExcelTable;
        // Инициализируем
        AExcelTable.CheckDuplicate := qProducts;
        AExcelTable.CurrencyInt := TMyCurrency.Create;
      end,
      procedure(ASender: TObject)
      begin
        (ASender as TProductsExcelDM).Init(FieldsInfo2.ToArray);
      end);
  finally
    cxDBTreeList.FullCollapse;
    EndUpdate;
  end;

end;

procedure TViewProducts2.SetqProducts(const Value: TQueryProducts);
begin
  if qProductsBase = Value then
    Exit;

  // Отписываемся от событий
  FEventList.Clear;

  qProductsBase := Value;
end;

procedure TViewProducts2.UpdateProductCount;
begin
  inherited;

  // обновляем количество продуктов на всех складах
  StatusBar.Panels[3].Text := Format('%d', [qProducts.TotalCount]);
end;

procedure TViewProducts2.UpdateView;
var
  OK: Boolean;
begin
  inherited;
  OK := (cxDBTreeList.DataController.DataSource <> nil) and (qProducts <> nil)
    and (qProducts.FDQuery.Active) and IsViewOK and
    (cxDBTreeList.DataController.DataSet <> nil);

  actFilterAndExportToExcelDocument.Enabled := actExportToExcelDocument.Enabled;

  // Есть хотя-бы один склад!  Предпологаем что у нас он всегда выделен!!!
  actFullScreen.Enabled := OK and (qProducts.StorehouseListInt <> nil) and
    (qProducts.StorehouseListInt.StoreHouseCount > 0);
end;

end.
