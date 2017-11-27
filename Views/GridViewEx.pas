unit GridViewEx;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, GridView, cxGraphics, cxControls,
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
  cxGridDBBandedTableView, cxGrid, System.ImageList, Vcl.ImgList;

type
  TViewGridEx = class(TViewGrid)
    DataSource: TDataSource;
    cxImageList1: TcxImageList;
  private
    FDataSet: TDataSet;
    procedure SetDataSet(const Value: TDataSet);
    { Private declarations }
  protected
    procedure AssignDataSet; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    procedure UpdateStatusBar;
    procedure UpdateView; override;
    property DataSet: TDataSet read FDataSet write SetDataSet;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TViewGridEx.Create(AOwner: TComponent);
begin
  inherited;
  UpdateView;
end;

procedure TViewGridEx.AssignDataSet;
begin
  inherited;
  DataSource.DataSet := FDataSet;
  // Подключаем представление к данным
  MainView.DataController.DataSource := DataSource;
  MainView.DataController.CreateAllItems(True);
  MyCreateColumnsBarButtons;
  ApplyBestFitEx;
  UpdateStatusBar;
end;

procedure TViewGridEx.SetDataSet(const Value: TDataSet);
begin
  if FDataSet <> Value then
  begin
    FDataSet := Value;
    if FDataSet <> nil then
    begin
      AssignDataSet;
    end
    else
    begin
      DataSource.DataSet := nil;
    end;
  end;

end;

procedure TViewGridEx.UpdateStatusBar;
begin
  if (DataSet <> nil) and (DataSet.Active) then
    StatusBar.Panels[0].Text := Format('Всего записей: %d', [DataSet.RecordCount]);
end;

procedure TViewGridEx.UpdateView;
begin
  actExportToExcel.Enabled := (DataSet <> nil) and (DataSet.RecordCount > 0);
end;

end.
