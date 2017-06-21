unit RecursiveTreeView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, GridFrame, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
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
  dxSkinXmas2008Blue, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, cxNavigator, Data.DB, cxDBData, dxSkinsdxBarPainter,
  cxGridCustomPopupMenu, cxGridPopupMenu, Vcl.Menus, System.Actions,
  Vcl.ActnList, dxBar, cxClasses, Vcl.ComCtrls, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridBandedTableView,
  cxGridDBBandedTableView, cxGrid, RecursiveTreeQuery;

type
  TViewRecursiveTree = class(TfrmGrid)
    clExternalID: TcxGridDBBandedColumn;
    clValue: TcxGridDBBandedColumn;
    clParentExternalID: TcxGridDBBandedColumn;
    actExportToExcelDocument: TAction;
    procedure actExportToExcelDocumentExecute(Sender: TObject);
  private
    FQueryRecursiveTree: TQueryRecursiveTree;
    procedure SetQueryRecursiveTree(const Value: TQueryRecursiveTree);
    { Private declarations }
  public
    property QueryRecursiveTree: TQueryRecursiveTree read FQueryRecursiveTree
      write SetQueryRecursiveTree;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses DialogUnit;

procedure TViewRecursiveTree.actExportToExcelDocumentExecute(Sender: TObject);
var
  AFileName: String;
begin
  inherited;
  AFileName := 'Категории';
  AFileName := TDialog.Create.SaveToExcelFile(AFileName);
  if AFileName = '' then
    Exit;

  ExportViewToExcel(MainView, AFileName);
end;

procedure TViewRecursiveTree.SetQueryRecursiveTree
  (const Value: TQueryRecursiveTree);
begin
  if FQueryRecursiveTree <> Value then
  begin
    FQueryRecursiveTree := Value;

    // Отписываемся
    FEventList.Clear;

    if FQueryRecursiveTree <> nil then
    begin
      MainView.DataController.DataSource := FQueryRecursiveTree.DataSource;
    end;

  end;
end;

end.
