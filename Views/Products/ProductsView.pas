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
  cxDBLookupComboBox, CustomErrorTable, FieldInfoUnit;

type
  TViewProducts = class(TViewProductsBase)
    actAdd: TAction;
    actDelete: TAction;
    dxbrbtnAdd: TdxBarButton;
    dxbrbtnDelete: TdxBarButton;
    dxbrbtnSave: TdxBarButton;
    dxBarButton2: TdxBarButton;
    actPasteComponents: TAction;
    N2: TMenuItem;
    procedure actAddExecute(Sender: TObject);
    procedure actCommitExecute(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
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
    function GetFieldInfoByColumnCaption(ABandCaption: string;
      const AColumnCaption: String): TFieldInfo;
    function LoadExcelFileHeader(const AFileName: String;
      AFieldsInfo: TList<TFieldInfo>): Boolean;
    procedure LoadFromExcelDocument(const AFileName: String);
    procedure UpdateView; override;
    property QueryProducts: TQueryProducts read GetQueryProducts
      write SetQueryProducts;
    { Public declarations }
  end;

  TProductsErrorTable = class(TCustomErrorTable)
  private
    function GetDescription: TField;
    function GetError: TField;
    function GetColumnName: TField;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AddErrorMessage(const AColumnName: string; AMessage: string);
    property Description: TField read GetDescription;
    property Error: TField read GetError;
    property ColumnName: TField read GetColumnName;
  end;

implementation

{$R *.dfm}

uses NotifyEvents, System.Generics.Defaults, RepositoryDataModule,
  System.IOUtils, Winapi.ShellAPI, ClipboardUnit, System.Math, ProjectConst,
  DialogUnit, Vcl.Clipbrd, SettingsController, ExcelDataModule,
  ProductsExcelDataModule, ProgressBarForm, ErrorForm, CustomExcelTable,
  GridViewForm;

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

function TViewProducts.GetFieldInfoByColumnCaption(ABandCaption: string;
  const AColumnCaption: String): TFieldInfo;
var
  ABand: TcxGridBand;
  ACollectionItem: TCollectionItem;
  AColumn: TcxGridDBBandedColumn;
  i: Integer;
  S1, S2: String;
begin
  Assert(not AColumnCaption.IsEmpty);

  Result := nil;

  // Цикл по всем бэндам
  for ACollectionItem in MainView.Bands do
  begin
    ABand := ACollectionItem as TcxGridBand;
    // Если заголовок бэнда нам подходит
    if ABand.Caption.Trim.ToUpper = ABandCaption.Trim.ToUpper then
    begin
      for i := 0 to ABand.ColumnCount - 1 do
      begin
        AColumn := ABand.Columns[i] as TcxGridDBBandedColumn;

        S1 := AColumn.Caption.Replace(' ', '', [rfReplaceAll]).ToUpper;
        S2 := AColumnCaption.Replace(' ', '', [rfReplaceAll]).ToUpper;

        if S1 = S2 then
        begin
          Result := TFieldInfo.Create(AColumn.DataBinding.FieldName);
          break;
        end;
      end;
      if Result <> nil then
        break;
    end;
  end;
end;

function TViewProducts.GetQueryProducts: TQueryProducts;
begin
  Result := QueryProductsBase as TQueryProducts;
end;

function TViewProducts.LoadExcelFileHeader(const AFileName: String;
  AFieldsInfo: TList<TFieldInfo>): Boolean;

  function GetFieldInfo(const ABandCaption, AColumnCaption: String;
    ADefaultFields: TDictionary<String, TFieldInfo>): TFieldInfo;
  var
    AKey: string;
    S: string;
  begin
    AKey := AColumnCaption.Trim.ToUpper;

    if ADefaultFields.ContainsKey(AKey) then
    begin
      Result := ADefaultFields[AKey];
    end
    else
    begin
      Result := GetFieldInfoByColumnCaption(ABandCaption, AKey);
    end;
    if Result <> nil then
      S:=Result.FieldName;

  end;

var
  AChildStringTreeNode: TStringTreeNode;
  ADefaultFields: TDictionary<String, TFieldInfo>;
  AExcelDM: TExcelDM;
  AFieldInfo: TFieldInfo;
  AfrmGridView: TfrmGridView;
  AProductsErrorTable: TProductsErrorTable;
  ARootTreeNode: TStringTreeNode;
  AStringTreeNode: TStringTreeNode;
  OK: Boolean;
  UnknownFieldCount: cardinal;

begin
  Assert(not AFileName.IsEmpty);
  Assert(AFieldsInfo <> nil);

  ADefaultFields := TDictionary<String, TFieldInfo>.Create;
  try
    // Заполняем поля "по умолчанию"
    ADefaultFields.Add(clValue.Caption.ToUpper,
      TFieldInfo.Create(QueryProducts.Value.FieldName, True,
      'Не задано название компонента'));

    ADefaultFields.Add(clProducer.Caption.ToUpper, TFieldInfo.Create('Producer',
      True, 'Не задан производитель'));

    AExcelDM := TExcelDM.Create(Self);
    try
      // Загружаем описания полей Excel файла
      ARootTreeNode := AExcelDM.LoadExcelFileHeader(AFileName);

      UnknownFieldCount := 0; // Кол-во нераспознанных полей

      // Создаём таблицу с ошибками
      AProductsErrorTable := TProductsErrorTable.Create(Self);
      try
        // Цикл по всем заголовкам таблицы
        for AStringTreeNode in ARootTreeNode.Childs do
        begin
          AFieldInfo := nil;

          // Если у этого элемента нет дочерних
          if AStringTreeNode.Childs.Count = 0 then
          begin
            AFieldInfo := GetFieldInfo('', AStringTreeNode.Value,
              ADefaultFields);
          end
          else
          begin
            // Если у этого элемента есть дочерние
            for AChildStringTreeNode in AStringTreeNode.Childs do
            begin
              AFieldInfo := GetFieldInfo(AStringTreeNode.Value,
                AChildStringTreeNode.Value, ADefaultFields);
            end;
          end;

          if AFieldInfo = nil then
          begin
            Inc(UnknownFieldCount);
            AProductsErrorTable.AddErrorMessage(AStringTreeNode.Value,
              'Нераспознанный столбец');

            // Создаём описание нераспознанной колонки
            AFieldInfo := TFieldInfo.Create(Format('UnknownField_%d',
              [UnknownFieldCount]));
          end;
          // Создаём описание поля для Excel таблицы
          AFieldsInfo.Add(AFieldInfo);
        end;

        // Если среди колонок excel файла есть нераспознанные
        OK := AProductsErrorTable.RecordCount = 0;
        if not OK then
        begin
          AfrmGridView := TfrmGridView.Create(Self);
          try
            AfrmGridView.Caption := 'Нераспознанные столбцы';
            AfrmGridView.DataSet := AProductsErrorTable;
            // Показываем что мы собираемся привязывать
            OK := AfrmGridView.ShowModal = mrOk;
          finally
            FreeAndNil(AfrmGridView);
          end;

        end;

      finally
        FreeAndNil(AProductsErrorTable);
      end;
    finally
      FreeAndNil(AExcelDM);
    end;
  finally
    FreeAndNil(ADefaultFields);
  end;

  OK := OK and (AFieldsInfo.Count > 0);
  Result := OK;
end;

procedure TViewProducts.LoadFromExcelDocument(const AFileName: String);
var
  AFieldsInfo: TList<TFieldInfo>;
  AfrmError: TfrmError;
  AProductsExcelDM: TProductsExcelDM;
  OK: Boolean;
begin
  Assert(not AFileName.IsEmpty);

  AFieldsInfo := TList<TFieldInfo>.Create();
  try
    // Загружаем список полей из файла
    if not LoadExcelFileHeader(AFileName, AFieldsInfo) then
      Exit;

    AProductsExcelDM := TProductsExcelDM.Create(Self, AFieldsInfo);
    try
      // Загружаем данные из Excel файла
      TfrmProgressBar.Process(AProductsExcelDM,
        procedure
        begin
          AProductsExcelDM.LoadExcelFile(AFileName);
        end, 'Загрузка складских данных', sRows);

      OK := AProductsExcelDM.ExcelTable.Errors.RecordCount = 0;
      // Если в ходе загрузки данных произошли ошибки (производитель не найден)
      if not OK then
      begin
        AfrmError := TfrmError.Create(Self);
        try
          AfrmError.ErrorTable := AProductsExcelDM.ExcelTable.Errors;
          // Показываем ошибки
          OK := AfrmError.ShowModal = mrOk;
          AProductsExcelDM.ExcelTable.ExcludeErrors(etError);
        finally
          FreeAndNil(AfrmError);
        end;
      end;
      if OK then
      begin
        // Сохраняем данные в БД
        TfrmProgressBar.Process(AProductsExcelDM.ExcelTable,
          procedure
          begin
            QueryProducts.AppendList(AProductsExcelDM.ExcelTable);
          end, 'Сохранение складских данных в БД', sRecords);
      end;

    finally
      FreeAndNil(AProductsExcelDM);
    end;
  finally
    FreeAndNil(AFieldsInfo);
  end;

end;

procedure TViewProducts.OnGridPopupMenuPopup(AColumn: TcxGridDBBandedColumn);
Var
  OK: Boolean;
begin
  OK := Clipboard.HasFormat(CF_TEXT) and (AColumn <> nil);

  actPasteComponents.Enabled := OK and (AColumn.GridView.Level = cxGridLevel)
    and (AColumn.DataBinding.FieldName = clValue.DataBinding.FieldName);

  OK := (AColumn <> nil);

  actPasteComponents.Visible := OK and (AColumn.GridView.Level = cxGridLevel)
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

procedure TViewProducts.StatusBarResize(Sender: TObject);
const
  EmptyPanelIndex = 2;
var
  i: Integer;
  x: Integer;
begin
  x := StatusBar.ClientWidth;
  for i := 0 to StatusBar.Panels.Count - 1 do
  begin
    if i <> EmptyPanelIndex then
    begin
      Dec(x, StatusBar.Panels[i].Width);
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
  OK: Boolean;
begin
  inherited;
  OK := (QueryProductsBase <> nil) and (QueryProductsBase.FDQuery.Active);
  AFocusedView := FocusedTableView;

  actAdd.Enabled := OK;
  {
    and ((QueryProductsBase.FDQuery.State = dsBrowse) or
    ((QueryProductsBase.FDQuery.State in [dsEdit, dsInsert]) and
    (not QueryProductsBase.Value.AsString.IsEmpty)));
  }
  actDelete.Enabled := OK and (AFocusedView <> nil) and
    (AFocusedView.DataController.RowCount > 0);
end;

constructor TProductsErrorTable.Create(AOwner: TComponent);
begin
  inherited;
  FieldDefs.Add('ColumnName', ftString, 100);
  FieldDefs.Add('Error', ftString, 50);
  FieldDefs.Add('Description', ftString, 150);
  CreateDataSet;

  Open;

  ColumnName.DisplayLabel := 'Колонка';
  Description.DisplayLabel := 'Описание';
  Error.DisplayLabel := 'Вид ошибки';
end;

procedure TProductsErrorTable.AddErrorMessage(const AColumnName: string;
AMessage: string);
begin
  Assert(Active);

  if not(State in [dsEdit, dsInsert]) then
    Append;

  ColumnName.AsString := AColumnName;
  Error.AsString := ErrorMessage;
  Description.AsString := AMessage;
  Post;
end;

function TProductsErrorTable.GetDescription: TField;
begin
  Result := FieldByName('Description');
end;

function TProductsErrorTable.GetError: TField;
begin
  Result := FieldByName('Error');
end;

function TProductsErrorTable.GetColumnName: TField;
begin
  Result := FieldByName('ColumnName');
end;

end.
