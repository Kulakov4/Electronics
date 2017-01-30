unit ReportsView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, GridFrame, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB, cxDBData,
  cxGridCustomPopupMenu, cxGridPopupMenu, Vcl.Menus, System.Actions,
  Vcl.ActnList, dxBar, cxClasses, Vcl.ComCtrls, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridBandedTableView,
  cxGridDBBandedTableView, cxGrid, ReportQuery, dxBarExtItems,
  System.Generics.Collections, dxSkinsCore, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
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
  dxSkinXmas2008Blue, dxSkinscxPCPainter, dxSkinsdxBarPainter;

type
  TViewReports = class(TfrmGrid)
    actExportToExcelDocument: TAction;
    dxbrbExportToExcelDocument: TdxBarButton;
    clManufacturer: TcxGridDBBandedColumn;
    clComponent: TcxGridDBBandedColumn;
    clSpecification: TcxGridDBBandedColumn;
    clScheme: TcxGridDBBandedColumn;
    clDrawing: TcxGridDBBandedColumn;
    clImage: TcxGridDBBandedColumn;
    clDescription: TcxGridDBBandedColumn;
    actFilterBySpecification: TAction;
    dxBarButton1: TdxBarButton;
    actFilterBySchema: TAction;
    dxBarButton2: TdxBarButton;
    dxBarManagerBar1: TdxBar;
    dxBarStatic1: TdxBarStatic;
    actFilterByDrawing: TAction;
    dxBarButton3: TdxBarButton;
    actFilterByImage: TAction;
    dxBarButton4: TdxBarButton;
    actClearFilters: TAction;
    dxBarButton5: TdxBarButton;
    actFilterByDescription: TAction;
    dxBarButton6: TdxBarButton;
    procedure actClearFiltersExecute(Sender: TObject);
    procedure actExportToExcelDocumentExecute(Sender: TObject);
    procedure actFilterByDescriptionExecute(Sender: TObject);
    procedure actFilterByDrawingExecute(Sender: TObject);
    procedure actFilterByImageExecute(Sender: TObject);
    procedure actFilterBySchemaExecute(Sender: TObject);
    procedure actFilterBySpecificationExecute(Sender: TObject);
  private
    FFilterFields: TList<String>;
    FQueryReports: TQueryReports;
    procedure FilterByColumn(const AColumn: TcxGridDBBandedColumn;
      const AValue: String);
    function GetFileName: string;
    procedure SetQueryReports(const Value: TQueryReports);
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property QueryReports: TQueryReports read FQueryReports
      write SetQueryReports;
    { Public declarations }
  end;

implementation

uses DialogUnit, RepositoryDataModule, System.StrUtils;

{$R *.dfm}

constructor TViewReports.Create(AOwner: TComponent);
begin
  inherited;
  FFilterFields := TList<String>.Create;
end;

destructor TViewReports.Destroy;
begin
  FFilterFields.Clear;
  FreeAndNil(FFilterFields);
  inherited;
end;

procedure TViewReports.actClearFiltersExecute(Sender: TObject);
begin
  MainView.DataController.Filter.Root.Clear;
  actClearFilters.Checked := True;
  actClearFilters.Checked := False;
end;

procedure TViewReports.actExportToExcelDocumentExecute(Sender: TObject);
var
  AFileName: String;
begin
  AFileName := GetFileName;
  AFileName := TDialog.Create.SaveToExcelFile(AFileName);
  if AFileName = '' then
    Exit;

  ExportViewToExcel(MainView, AFileName);
end;

procedure TViewReports.actFilterByDescriptionExecute(Sender: TObject);
begin
  if not actFilterByDescription.Checked then
  begin
    FilterByColumn(MainView.GetColumnByFieldName('Описание'), 'отсутствует');
    actFilterByDescription.Checked := True;
  end;
end;

procedure TViewReports.actFilterByDrawingExecute(Sender: TObject);
begin
  if not actFilterByDrawing.Checked then
  begin
    FilterByColumn(MainView.GetColumnByFieldName('Чертёж'), 'отсутствует');
    actFilterByDrawing.Checked := True;
  end;
end;

procedure TViewReports.actFilterByImageExecute(Sender: TObject);
begin
  if not actFilterByImage.Checked then
  begin
    FilterByColumn(MainView.GetColumnByFieldName('Изображение'), 'отсутствует');
    actFilterByImage.Checked := True;
  end;
end;

procedure TViewReports.actFilterBySchemaExecute(Sender: TObject);
begin
  if not actFilterBySchema.Checked then
  begin
    FilterByColumn(MainView.GetColumnByFieldName('Схема'), 'отсутствует');
    actFilterBySchema.Checked := True;
  end;
end;

procedure TViewReports.actFilterBySpecificationExecute(Sender: TObject);
begin
  if not actFilterBySpecification.Checked then
  begin
    FilterByColumn(MainView.GetColumnByFieldName('Спецификация'),
      'отсутствует');
    actFilterBySpecification.Checked := True;
  end;
end;

procedure TViewReports.FilterByColumn(const AColumn: TcxGridDBBandedColumn;
  const AValue: String);
var
  ci: TcxFilterCriteriaItem;
  r: TcxFilterCriteriaItemList;
  s: string;
begin
  r := MainView.DataController.Filter.Root;

  // r.Clear;
  // Снимаем фильтры с других полей
  for s in FFilterFields do
  begin
    ci := r.Criteria.FindItemByItemLink(MainView.GetColumnByFieldName(s));
    if ci <> nil then
      ci.free;
  end;

  r.AddItem(AColumn, foEqual, AValue, AValue);
  MainView.DataController.Filter.Active := True;
end;

function TViewReports.GetFileName: string;
var
  AColumn: TcxGridDBBandedColumn;
  AManufacturer: String;
  s: string;
begin
  s := '';
  AColumn := MainView.GetColumnByFieldName('Производитель');

  if AColumn.DataBinding.Filtered then
    AManufacturer := AColumn.DataBinding.FilterCriteriaItem.Value
  else
    AManufacturer := 'Все производители';

  if MainView.GetColumnByFieldName('Описание').DataBinding.Filtered then
    s := String.Format('%s,%s', [s, 'Краткое описание']);

  if MainView.GetColumnByFieldName('Спецификация').DataBinding.Filtered then
    s := String.Format('%s,%s', [s, 'Спецификация']);

  if MainView.GetColumnByFieldName('Схема').DataBinding.Filtered then
    s := String.Format('%s,%s', [s, 'Схема']);

  if MainView.GetColumnByFieldName('Чертёж').DataBinding.Filtered then
    s := String.Format('%s,%s', [s, 'Чертёж']);

  if MainView.GetColumnByFieldName('Изображение').DataBinding.Filtered then
    s := String.Format('%s,%s', [s, 'Изображение']);

  s := s.Trim([',']);
  if s.IsEmpty then
    s := 'Все документы';

  Result := String.Format('%s (%s) %s',
    [AManufacturer, s, FormatDateTime('dd-mm-yyyy', Date)]);
end;

procedure TViewReports.SetQueryReports(const Value: TQueryReports);
begin
  if FQueryReports <> Value then
  begin
    FQueryReports := Value;
    if FQueryReports <> nil then
    begin
      FFilterFields.Clear;
      FFilterFields.Add(QueryReports.Описание.FieldName);
      FFilterFields.Add(QueryReports.Спецификация.FieldName);
      FFilterFields.Add(QueryReports.Схема.FieldName);
      FFilterFields.Add(QueryReports.Чертёж.FieldName);
      FFilterFields.Add(QueryReports.Изображение.FieldName);

      MainView.DataController.DataSource := FQueryReports.DataSource;
    end;
  end;
end;

end.
