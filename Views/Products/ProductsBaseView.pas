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
  cxDBLookupComboBox, cxLabel, SearchParameterValues, Manufacturers2Query;

type
  TViewProductsBase = class(TfrmGrid)
    clID: TcxGridDBBandedColumn;
    clValue: TcxGridDBBandedColumn;
    clProducer: TcxGridDBBandedColumn;
    clSubgroup: TcxGridDBBandedColumn;
    clDescription: TcxGridDBBandedColumn;
    clDatasheet: TcxGridDBBandedColumn;
    clImage: TcxGridDBBandedColumn;
    clPackagePins: TcxGridDBBandedColumn;
    clReleaseDate: TcxGridDBBandedColumn;
    clBatchNumber: TcxGridDBBandedColumn;
    clAmount: TcxGridDBBandedColumn;
    clPrice: TcxGridDBBandedColumn;
    clPackaging: TcxGridDBBandedColumn;
    clOriginCountry: TcxGridDBBandedColumn;
    clOriginCountryCode: TcxGridDBBandedColumn;
    clCustomsDeclarationNumber: TcxGridDBBandedColumn;
    clStorage: TcxGridDBBandedColumn;
    clStoragePlace: TcxGridDBBandedColumn;
    clBarcode: TcxGridDBBandedColumn;
    clSeller: TcxGridDBBandedColumn;
    clDiagram: TcxGridDBBandedColumn;
    clDrawing: TcxGridDBBandedColumn;
    clProductId: TcxGridDBBandedColumn;
    actOpenDatasheet: TAction;
    actLoadDatasheet: TAction;
    actOpenImage: TAction;
    actLoadImage: TAction;
    actCommit: TAction;
    actRollback: TAction;
    clStorehouseID: TcxGridDBBandedColumn;
    actOpenDiagram: TAction;
    actLoadDiagram: TAction;
    actOpenDrawing: TAction;
    actLoadDrawing: TAction;
    procedure actCommitExecute(Sender: TObject);
    procedure actRollbackExecute(Sender: TObject);
    procedure actLoadImageExecute(Sender: TObject);
    procedure actLoadDatasheetExecute(Sender: TObject);
    procedure actLoadDiagramExecute(Sender: TObject);
    procedure actLoadDrawingExecute(Sender: TObject);
    procedure actOpenImageExecute(Sender: TObject);
    procedure actOpenDatasheetExecute(Sender: TObject);
    procedure actOpenDiagramExecute(Sender: TObject);
    procedure actOpenDrawingExecute(Sender: TObject);
    procedure actRollback2Execute(Sender: TObject);
    procedure clDatasheetGetDataText(Sender: TcxCustomGridTableItem;
      ARecordIndex: Integer; var AText: string);
    procedure clPriceGetDisplayText(Sender: TcxCustomGridTableItem;
      ARecord: TcxCustomGridRecord; var AText: string);

  private
    FQueryProductsBase: TQueryProductsBase;
    FQuerySearchParameterValues: TQuerySearchParameterValues;
    function GetQuerySearchParameterValues: TQuerySearchParameterValues;
    procedure SetQueryProductsBase(const Value: TQueryProductsBase);
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
    function CheckAndSaveChanges: Integer;
    procedure UpdateView; override;
    property QueryProductsBase: TQueryProductsBase read FQueryProductsBase
      write SetQueryProductsBase;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses System.IOUtils, Winapi.ShellAPI, DialogUnit, SettingsController,
  ParameterValuesUnit, cxDropDownEdit, RepositoryDataModule;

procedure TViewProductsBase.actCommitExecute(Sender: TObject);
begin
  FQueryProductsBase.ApplyUpdates;
  UpdateView;
  // Заново заполняем выпадающие списки данными
  MyInitializeComboBoxColumn;
end;

procedure TViewProductsBase.actRollbackExecute(Sender: TObject);
begin
  QueryProductsBase.CancelUpdates;
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

procedure TViewProductsBase.actRollback2Execute(Sender: TObject);
begin
  QueryProductsBase.CancelUpdates;
  UpdateView;
end;

function TViewProductsBase.CheckAndSaveChanges: Integer;
begin
  Result := 0;
  if QueryProductsBase = nil then
    Exit;

  if QueryProductsBase.HaveAnyChanges then
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

procedure TViewProductsBase.clPriceGetDisplayText
  (Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
  var AText: string);
begin
  if VarToStrDef(ARecord.Values[clPrice.Index], '0') = '0' then
    AText := '';

end;

procedure TViewProductsBase.CreateColumnsBarButtons;
begin
  inherited;
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
  InitializeLookupColumn(MainView, clProducer.DataBinding.FieldName,
    QueryProductsBase.QueryProducers.DataSource, lsEditList,
    QueryProductsBase.QueryProducers.Name.FieldName);
end;

procedure TViewProductsBase.OpenDoc(ADocFieldInfo: TDocFieldInfo;
  const AErrorMessage, AEmptyErrorMessage: string);
var
  AFileName: string;
begin
  if FQueryProductsBase.FDQuery.FieldByName(ADocFieldInfo.FieldName).AsString <> ''
  then
  begin
    AFileName := TPath.Combine(TPath.Combine(TSettings.Create.DataBasePath,
      ADocFieldInfo.Folder), FQueryProductsBase.FDQuery.FieldByName
      (ADocFieldInfo.FieldName).AsString);

    if FileExists(AFileName) then
      ShellExecute(Handle, nil, PChar(AFileName), nil, nil, SW_SHOWNORMAL)
    else
      TDialog.Create.ErrorMessageDialog(Format(AErrorMessage, [AFileName]));
  end
  else
    TDialog.Create.ErrorMessageDialog(AEmptyErrorMessage);

end;

procedure TViewProductsBase.SetQueryProductsBase(const Value
  : TQueryProductsBase);
begin
  if FQueryProductsBase <> Value then
  begin
    FQueryProductsBase := Value;

    if FQueryProductsBase <> nil then
    begin
      FQueryProductsBase.QueryProducers.TryOpen;

      // Привязываем представление к данным\
      cxGridDBBandedTableView.DataController.DataSource :=
        FQueryProductsBase.DataSource;

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
  Ok := (QueryProductsBase <> nil) and (QueryProductsBase.FDQuery.Active);
  actCommit.Enabled := Ok and QueryProductsBase.HaveAnyChanges;
  actRollback.Enabled := actCommit.Enabled;
end;

procedure TViewProductsBase.UploadDoc(ADocFieldInfo: TDocFieldInfo);
var
  sourceFileName: string;
begin
  // Открываем диалог выбора файла для загрузки
  sourceFileName := TDialog.Create.OpenPictureDialog(ADocFieldInfo.Folder);
  if sourceFileName.IsEmpty then
    Exit;

  FQueryProductsBase.LoadDocFile(sourceFileName, ADocFieldInfo);
end;

end.
