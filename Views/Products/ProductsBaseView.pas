unit ProductsBaseView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, GridFrame, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB, cxDBData, System.Actions,
  Vcl.ActnList, dxBar, cxClasses, Vcl.ComCtrls, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridBandedTableView,
  cxGridDBBandedTableView, cxGrid, cxTextEdit, cxBlobEdit, cxButtonEdit,
  cxSpinEdit, cxCurrencyEdit, ProductsBaseQuery, cxCalendar,
  cxGridCustomPopupMenu, cxGridPopupMenu, Vcl.Menus, DocFieldInfo, dxSkinsCore,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
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
  dxSkinXmas2008Blue, dxSkinscxPCPainter, dxSkinsdxBarPainter,
  cxDBLookupComboBox, cxLabel, SearchParameterValues, GridSort,
  ProductBaseGroupUnit, TreeListFrame, ProductsBaseView2, ProductsView2;

type
  TViewProductsBase = class(TfrmGrid)
    clID: TcxGridDBBandedColumn;
    actOpenDatasheet: TAction;
    actLoadDatasheet: TAction;
    actOpenImage: TAction;
    actLoadImage: TAction;
    actCommit: TAction;
    actRollback: TAction;
    actOpenDiagram: TAction;
    actLoadDiagram: TAction;
    actOpenDrawing: TAction;
    actLoadDrawing: TAction;
    actOpenInParametricTable: TAction;
    actExportToExcelDocument: TAction;
    cxGridLevel2: TcxGridLevel;
    cxGridDBBandedTableView2: TcxGridDBBandedTableView;
    clID2: TcxGridDBBandedColumn;
    clValue2: TcxGridDBBandedColumn;
    clProducer2: TcxGridDBBandedColumn;
    clStorehouseID2: TcxGridDBBandedColumn;
    clDescription2: TcxGridDBBandedColumn;
    clDatasheet2: TcxGridDBBandedColumn;
    clDiagram2: TcxGridDBBandedColumn;
    clDrawing2: TcxGridDBBandedColumn;
    clImage2: TcxGridDBBandedColumn;
    clPackagePins2: TcxGridDBBandedColumn;
    clReleaseDate2: TcxGridDBBandedColumn;
    clBatchNumber2: TcxGridDBBandedColumn;
    clAmount2: TcxGridDBBandedColumn;
    clPackaging2: TcxGridDBBandedColumn;
    clPrice2: TcxGridDBBandedColumn;
    clOriginCountryCode2: TcxGridDBBandedColumn;
    clOriginCountry2: TcxGridDBBandedColumn;
    clCustomDeclarationNumber2: TcxGridDBBandedColumn;
    clStorage2: TcxGridDBBandedColumn;
    clStoragePlace2: TcxGridDBBandedColumn;
    clBarcode2: TcxGridDBBandedColumn;
    clSeller2: TcxGridDBBandedColumn;
    clProductID2: TcxGridDBBandedColumn;
    clComponentGroup: TcxGridDBBandedColumn;
    procedure actCommitExecute(Sender: TObject);
    procedure actExportToExcelDocumentExecute(Sender: TObject);
    procedure actRollbackExecute(Sender: TObject);
    procedure actLoadImageExecute(Sender: TObject);
    procedure actLoadDatasheetExecute(Sender: TObject);
    procedure actLoadDiagramExecute(Sender: TObject);
    procedure actLoadDrawingExecute(Sender: TObject);
    procedure actOpenImageExecute(Sender: TObject);
    procedure actOpenDatasheetExecute(Sender: TObject);
    procedure actOpenDiagramExecute(Sender: TObject);
    procedure actOpenDrawingExecute(Sender: TObject);
    procedure actOpenInParametricTableExecute(Sender: TObject);
    procedure actRollback2Execute(Sender: TObject);
    procedure clDatasheetGetDataText(Sender: TcxCustomGridTableItem;
      ARecordIndex: Integer; var AText: string);
    procedure cxGridDBBandedTableView2EditKeyDown
      (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
      AEdit: TcxCustomEdit; var Key: Word; Shift: TShiftState);
    procedure cxGridDBBandedTableViewColumnHeaderClick(Sender: TcxGridTableView;
      AColumn: TcxGridColumn);

  private
    FProductBaseGroup: TProductBaseGroup;
    FQuerySearchParameterValues: TQuerySearchParameterValues;
    function GetQuerySearchParameterValues: TQuerySearchParameterValues;
    procedure SetProductBaseGroup(const Value: TProductBaseGroup);
    { Private declarations }
  protected
    procedure CreateColumnsBarButtons; override;
    procedure MyInitializeComboBoxColumn; virtual;
    procedure OpenDoc(ADocFieldInfo: TDocFieldInfo;
      const AErrorMessage, AEmptyErrorMessage: string);
    procedure UploadDoc(ADocFieldInfo: TDocFieldInfo);
    property QuerySearchParameterValues: TQuerySearchParameterValues
      read GetQuerySearchParameterValues;
  public
    constructor Create(AOwner: TComponent); override;
    function CheckAndSaveChanges: Integer;
    procedure UpdateView; override;
    property ProductBaseGroup: TProductBaseGroup read FProductBaseGroup
      write SetProductBaseGroup;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses System.IOUtils, Winapi.ShellAPI, DialogUnit, SettingsController,
  ParameterValuesUnit, cxDropDownEdit, RepositoryDataModule, cxGridExportLink;

constructor TViewProductsBase.Create(AOwner: TComponent);
begin
  inherited;
  // Если щёлкнули по группе компонентов
  // GridSort.Add(TSortVariant.Create( clSubgroup, [clSubgroup] ));

  // Если щёлкнули по производителю
  GridSort.Add(TSortVariant.Create(clProducer2, [clProducer2]));

  // Если щёлкнули по наименованию
  GridSort.Add(TSortVariant.Create(clValue2, [clValue2]));

  PostOnEnterFields.Add(clComponentGroup.DataBinding.FieldName);
end;

procedure TViewProductsBase.actCommitExecute(Sender: TObject);
begin
  FProductBaseGroup.ApplyUpdates;
  UpdateView;
  // Заново заполняем выпадающие списки данными
  MyInitializeComboBoxColumn;
end;

procedure TViewProductsBase.actExportToExcelDocumentExecute(Sender: TObject);
var
  AFileName: String;
begin
  if not TDialog.Create.SaveToExcelFile(ProductBaseGroup.qProductsBase.ExportFileName, AFileName) then
    Exit;

  ExportViewToExcel(MainView, AFileName,
    procedure(AView: TcxGridDBBandedTableView)
    begin
      AView.Bands[0].FixedKind := fkNone;
    end);


  {
    MainView.Bands[0].FixedKind := fkNone;
    try
    // Экспортируем в Excel
    ExportGridToExcel(AFileName, cxGrid, True, True, False);
    finally
    MainView.Bands[0].FixedKind := fkLeft;
    end;
  }
end;

procedure TViewProductsBase.actRollbackExecute(Sender: TObject);
begin
  ProductBaseGroup.CancelUpdates;
  UpdateView;
end;

procedure TViewProductsBase.actLoadImageExecute(Sender: TObject);
begin
  UploadDoc(TImageDoc.Create);
end;

procedure TViewProductsBase.actLoadDatasheetExecute(Sender: TObject);
begin
  UploadDoc(TDatasheetDoc.Create);
end;

procedure TViewProductsBase.actLoadDiagramExecute(Sender: TObject);
begin
  UploadDoc(TDiagramDoc.Create);
end;

procedure TViewProductsBase.actLoadDrawingExecute(Sender: TObject);
begin
  UploadDoc(TDrawingDoc.Create);
end;

procedure TViewProductsBase.actOpenImageExecute(Sender: TObject);
begin
  OpenDoc(TImageDoc.Create, 'Файл изображения с именем %s не найден',
    'Не задано изображение');
end;

procedure TViewProductsBase.actOpenDatasheetExecute(Sender: TObject);
begin
  OpenDoc(TDatasheetDoc.Create, 'Файл спецификации с именем %s не найден',
    'не задана спецификация');
end;

procedure TViewProductsBase.actOpenDiagramExecute(Sender: TObject);
begin
  OpenDoc(TDiagramDoc.Create, 'Файл схемы с именем %s не найден',
    'Не задана схема');
end;

procedure TViewProductsBase.actOpenDrawingExecute(Sender: TObject);
begin
  OpenDoc(TDrawingDoc.Create, 'Файл чертежа с именем %s не найден',
    'Не задан чертёж');
end;

procedure TViewProductsBase.actOpenInParametricTableExecute(Sender: TObject);
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

procedure TViewProductsBase.actRollback2Execute(Sender: TObject);
begin
  ProductBaseGroup.CancelUpdates;
  UpdateView;
end;

function TViewProductsBase.CheckAndSaveChanges: Integer;
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

procedure TViewProductsBase.clDatasheetGetDataText
  (Sender: TcxCustomGridTableItem; ARecordIndex: Integer; var AText: string);
begin
  inherited;
  if not AText.IsEmpty then
    AText := TPath.GetFileNameWithoutExtension(AText);
end;

procedure TViewProductsBase.CreateColumnsBarButtons;
begin
  inherited;
end;

procedure TViewProductsBase.cxGridDBBandedTableView2EditKeyDown
  (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
AEdit: TcxCustomEdit; var Key: Word; Shift: TShiftState);
var
  AColumn: TcxGridDBBandedColumn;
  ATextEdit: TcxTextEdit;
  S: string;
begin
  inherited;
  AColumn := AItem as TcxGridDBBandedColumn;
  if (Key = 13) and
    (AColumn.DataBinding.FieldName = clValue2.DataBinding.FieldName) then
  begin
    // само наименование ещё может быть в эдите а не в датасете
    ATextEdit := (AEdit as TcxTextEdit);
    S := ATextEdit.Text;
    // Если наименование задано
    if (not S.Trim.IsEmpty) and
      (ProductBaseGroup.qProductsBase.IDProducer.AsInteger > 0) then
      ProductBaseGroup.qProductsBase.TryPost;
    UpdateView;
  end;

end;

procedure TViewProductsBase.cxGridDBBandedTableViewColumnHeaderClick
  (Sender: TcxGridTableView; AColumn: TcxGridColumn);
begin
  inherited;

  ApplySort(Sender, AColumn);
end;

function TViewProductsBase.GetQuerySearchParameterValues
  : TQuerySearchParameterValues;
begin
  if FQuerySearchParameterValues = nil then
    FQuerySearchParameterValues := TQuerySearchParameterValues.Create(Self);

  Result := FQuerySearchParameterValues;
end;

procedure TViewProductsBase.MyInitializeComboBoxColumn;
begin
  InitializeLookupColumn(clProducer2,
    ProductBaseGroup.qProductsBase.qProducers.DataSource, lsEditList,
    ProductBaseGroup.qProductsBase.qProducers.Name.FieldName);
end;

procedure TViewProductsBase.OpenDoc(ADocFieldInfo: TDocFieldInfo;
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

procedure TViewProductsBase.SetProductBaseGroup(const Value: TProductBaseGroup);
begin
  if FProductBaseGroup <> Value then
  begin
    FProductBaseGroup := Value;

    if FProductBaseGroup <> nil then
    begin
      FProductBaseGroup.qProductsBase.qProducers.TryOpen;
      // FProductBaseGroup.qComponentGroups.TryOpen;

      // Привязываем представление к данным\
      // MainView.DataController.DataSource :=
      // FProductBaseGroup.qComponentGroups.DataSource;

      cxGridDBBandedTableView2.DataController.DataSource :=
        FProductBaseGroup.qProductsBase.DataSource;

      // Инициализируем выпадающие списки
      MyInitializeComboBoxColumn;
    end;

    UpdateView;
  end;

end;

procedure TViewProductsBase.UpdateView;
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
    (MainView.DataController.RecordCount > 0);
end;

procedure TViewProductsBase.UploadDoc(ADocFieldInfo: TDocFieldInfo);
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
