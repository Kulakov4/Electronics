unit ProductsView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ProductsBaseView1, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxCustomData, cxStyles,
  cxTL, cxMaskEdit, cxDBLookupComboBox, cxDropDownEdit, cxButtonEdit,
  cxTLdxBarBuiltInMenu, dxSkinsCore, dxSkinsDefaultPainters, cxCalendar,
  cxCurrencyEdit, Vcl.ExtCtrls, Vcl.Menus, System.Actions, Vcl.ActnList, dxBar,
  cxBarEditItem, cxClasses, Vcl.ComCtrls, cxInplaceContainer, cxDBTL, cxTLData,
  ProductsViewModel, ProductsBaseView0,
  cxDataControllerConditionalFormattingRulesManagerDialog;

type
  TViewProducts = class(TViewProductsBase1)
    actFullScreen: TAction;
    actFilterAndExportToExcelDocument: TAction;
    actLoadFromExcelDocument: TAction;
    actAddCategory: TAction;
    actAddComponent: TAction;
    dxBarSubItem1: TdxBarSubItem;
    dxBarButton2: TdxBarButton;
    dxBarButton3: TdxBarButton;
    dxBarButton4: TdxBarButton;
    dxBarButton5: TdxBarButton;
    dxBarButton6: TdxBarButton;
    dxBarSubItem2: TdxBarSubItem;
    dxBarButton7: TdxBarButton;
    dxBarSubItem3: TdxBarSubItem;
    dxBarButton8: TdxBarButton;
    dxBarButton9: TdxBarButton;
    dxBarButton10: TdxBarButton;
    dxBarButton11: TdxBarButton;
    dxBarButton12: TdxBarButton;
    dxBarButton13: TdxBarButton;
    procedure actAddCategoryExecute(Sender: TObject);
    procedure actAddComponentExecute(Sender: TObject);
    procedure actFilterAndExportToExcelDocumentExecute(Sender: TObject);
    procedure actFullScreenExecute(Sender: TObject);
    procedure actLoadFromExcelDocumentExecute(Sender: TObject);
  private const
    FolderKey: String = 'Products';
    function GetProductsModel: TProductsViewModel;
    procedure SetProductsModel(const Value: TProductsViewModel);
    { Private declarations }
  protected
    function CreateProductView: TViewProductsBase0; override;
    procedure InitializeColumns; override;
    procedure UpdateProductCount; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure LoadFromExcelDocument(const AFileName: String);
    procedure UpdateView; override;
    property ProductsModel: TProductsViewModel read GetProductsModel
      write SetProductsModel;
    { Public declarations }
  end;

implementation

uses
  ProductsViewForm, DialogUnit, DialogUnit2, ExcelDataModule,
  System.Generics.Collections, ProductsExcelDataModule, FieldInfoUnit,
  LoadFromExcelFileHelper, CustomErrorForm, CurrencyUnit, RepositoryDataModule;

{$R *.dfm}

constructor TViewProducts.Create(AOwner: TComponent);
begin
  inherited;
  Name := 'ViewProducts';
end;

procedure TViewProducts.actAddCategoryExecute(Sender: TObject);
begin
  // Если текущий склад не выбран
  if (ProductsModel.StorehouseListInt = nil) or
    (ProductsModel.StorehouseListInt.StoreHouseTitle.IsEmpty) or
    (ProductsModel.qProducts.ParentValue <= 0) then
  begin
    TDialog.Create.ErrorMessageDialog('Не выбран склад');
    Exit;
  end;

  cxDBTreeList.HideEdit;

  ProductW.AddCategory;

  cxDBTreeList.SetFocus;
  // cxDBTreeList.ApplyBestFit;

  // Переводим колонку в режим редактирования
  clValue.Editing := True;
end;

procedure TViewProducts.actAddComponentExecute(Sender: TObject);
var
  AID: Integer;
begin
  inherited;

  // Если редактировалась группа - то по окончании редактироваия она автосохранится!!!
  cxDBTreeList.HideEdit;

  cxDBTreeList.Post;

  if cxDBTreeList.FocusedNode.IsGroupNode then
    AID := FocusedNodeValue(clID)
  else
  begin
    Assert(cxDBTreeList.FocusedNode.Parent <> nil);
    AID := cxDBTreeList.FocusedNode.Parent.Values[clID.ItemIndex];
  end;

  ProductW.AddProduct(AID);

  cxDBTreeList.SetFocus;

  // Переводим колонку в режим редактирования
  clValue.Editing := True;
end;

procedure TViewProducts.actFilterAndExportToExcelDocumentExecute
  (Sender: TObject);
var
  AFileName: String;
  AIDArray: TArray<Integer>;
  Model: TProductsViewModel;
  AViewProducts: TViewProducts;
  rc: Integer;
begin
  inherited;
  if not TDialog.Create.ShowDialog(TExcelFileSaveDialog, '',
    ProductsModel.ExportFileName, AFileName) then
    Exit;

  AIDArray := GetSelectedID;

  Model := TProductsViewModel.Create(nil);
  try
    rc := Model.qProducts.SearchByID(AIDArray);
    Assert(rc > 0);
    AViewProducts := TViewProducts.Create(nil);
    try
      AViewProducts.ProductsModel := Model;
      AViewProducts.ExportToExcelDocument(AFileName);
    finally
      FreeAndNil(AViewProducts);
    end;
  finally
    FreeAndNil(Model);
  end;
end;

procedure TViewProducts.actFullScreenExecute(Sender: TObject);
begin
  inherited;
  if frmProducts = nil then
  begin
    frmProducts := TfrmProducts.Create(Self);
    frmProducts.ViewProducts.ProductsModel := ProductsModel;
  end;
  frmProducts.Show;
end;

procedure TViewProducts.actLoadFromExcelDocumentExecute(Sender: TObject);
var
  AFileName: String;
begin
  Application.Hint := '';

  if (ProductsModel.StorehouseListInt = nil) or
    (ProductsModel.StorehouseListInt.StoreHouseCount = 0) then
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

function TViewProducts.CreateProductView: TViewProductsBase0;
begin
  Result := TViewProducts.Create(nil);
end;

function TViewProducts.GetProductsModel: TProductsViewModel;
begin
  Result := Model as TProductsViewModel;
end;

procedure TViewProducts.InitializeColumns;
begin
  inherited;

  Assert(ProductsModel  <> nil);
  Assert(clStoreHouseID.Position.Band <> nil);

  clStoreHouseID.Position.Band.Visible := False;
end;

procedure TViewProducts.LoadFromExcelDocument(const AFileName: String);
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
  AChildNode := nil;

  FieldsInfo := TFieldsInfoEx.Create;
  FieldsInfo2 := TFieldsInfoEx.Create;

  FieldsInfo.Add(TFieldInfoEx.Create('ComponentGroup', True,
    'Группа компонентов не задана', 'Группа компонентов', True));
  FieldsInfo.Add(TFieldInfoEx.Create('Value', True, 'Наименование не задано',
    'Наименование'));
  FieldsInfo.Add(TFieldInfoEx.Create('Producer', True, 'Производитель не задан',
    'Производитель'));
  FieldsInfo.Add(TFieldInfoEx.Create('PackagePins', False, '', 'Корпус'));
  FieldsInfo.Add(TFieldInfoEx.Create('ReleaseDate', False, '', 'Дата выпуска'));
  FieldsInfo.Add(TFieldInfoEx.Create('Amount', True, 'Количество не задано',
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
          AChildNode.Value.Trim, True);
        if AFI <> nil then
        begin
          Assert(not AFI.Exist);
          AFI.Exist := True;
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
        AFI.Exist := True;
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
        ProductsModel.qProducts.LoadDataFromExcelTable
          (ASender as TProductsExcelTable);
      end,
      procedure(ASender: TObject)
      begin
        AExcelTable := ASender as TProductsExcelTable;
        // Инициализируем
        AExcelTable.CheckDuplicate := ProductsModel.qProducts;
        AExcelTable.CurrencyInt := TMyCurrency.Create;
      end,
      procedure(ASender: TObject)
      begin
        (ASender as TProductsExcelDM).Init(FieldsInfo2.ToArray);
      end);
  finally
    EndUpdate;
  end;
  PostFullCollapseMessage;
end;

procedure TViewProducts.SetProductsModel(const Value: TProductsViewModel);
begin
  Model := Value;
end;

procedure TViewProducts.UpdateProductCount;
begin
  inherited;

  // обновляем количество продуктов на всех складах
  StatusBar.Panels[3].Text := Format('%d', [ProductsModel.qProducts.TotalCount]);
end;

procedure TViewProducts.UpdateView;
var
  OK: Boolean;
begin
  inherited;
  OK := (cxDBTreeList.DataController.DataSource <> nil) and
    (ProductsModel <> nil) and (ProductsModel.qProductsBase <> nil) and
    (ProductsModel.qProductsBase.FDQuery.Active) and IsViewOK and
    (cxDBTreeList.DataController.DataSet <> nil);

  actFilterAndExportToExcelDocument.Enabled := actExportToExcelDocument.Enabled;

  // Выбран какой-то склад!!!
  actAddCategory.Enabled := OK and (ProductsModel.qProductsBase.ParentValue > 0);

  // Выбран какой-то склад!!!
  actAddComponent.Enabled := OK and (cxDBTreeList.FocusedNode <> nil)
     and (ProductsModel.qProductsBase.ParentValue > 0) and
    (cxDBTreeList.SelectionCount = 1);

  // Выбран какой-то склад!!!
  actFullScreen.Enabled := OK and (ProductsModel.qProductsBase.ParentValue > 0);

  // Выбран какой-то склад!!!
  actLoadFromExcelDocument.Enabled := OK and
    (ProductsModel.qProductsBase.ParentValue > 0);
end;

end.
