unit BodyTypesGridView;

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
  cxGridDBBandedTableView, cxGrid, BodyTypesGridQuery, DialogUnit, dxSkinsCore,
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
  dxSkinXmas2008Blue, dxSkinscxPCPainter, dxSkinsdxBarPainter;

type
  TViewBodyTypesGrid = class(TfrmGrid)
    clBodyType1: TcxGridDBBandedColumn;
    clBodyType: TcxGridDBBandedColumn;
    clLandPattern: TcxGridDBBandedColumn;
    clOutlineDrawing: TcxGridDBBandedColumn;
    clVariation: TcxGridDBBandedColumn;
    clImage: TcxGridDBBandedColumn;
    clBodyType0: TcxGridDBBandedColumn;
    actExportToExcelDocument: TAction;
    dxBarButton1: TdxBarButton;
    procedure actExportToExcelDocumentExecute(Sender: TObject);
  private
    FQueryBodyTypesGrid: TQueryBodyTypesGrid;
    procedure SetQueryBodyTypesGrid(const Value: TQueryBodyTypesGrid);
    { Private declarations }
  public
    property QueryBodyTypesGrid: TQueryBodyTypesGrid read FQueryBodyTypesGrid
      write SetQueryBodyTypesGrid;
    { Public declarations }
  end;

var
  ViewBodyTypesGrid: TViewBodyTypesGrid;

implementation

{$R *.dfm}

procedure TViewBodyTypesGrid.actExportToExcelDocumentExecute(Sender: TObject);
var
  AFileName: string;
begin
  AFileName := 'Типы корпусов';
  AFileName := TDialog.Create.SaveToExcelFile(AFileName);
  if AFileName = '' then
    Exit;

  ExportViewToExcel(cxGridDBBandedTableView, AFileName);
end;

procedure TViewBodyTypesGrid.SetQueryBodyTypesGrid
  (const Value: TQueryBodyTypesGrid);
begin
  if FQueryBodyTypesGrid <> Value then
  begin
    FQueryBodyTypesGrid := Value;
    if FQueryBodyTypesGrid <> nil then
    begin
      cxGridDBBandedTableView.DataController.DataSource :=
        FQueryBodyTypesGrid.DataSource;
    end;

  end;
end;

end.
