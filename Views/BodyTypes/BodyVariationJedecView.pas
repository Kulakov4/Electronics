unit BodyVariationJedecView;

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
  cxGridDBBandedTableView, cxGrid, BodyVariationJedecQuery,
  BodyVariationsJedecQuery, JEDECQuery, cxDBLookupComboBox;

type
  TViewBodyVariationJEDEC = class(TViewGrid)
    DataSource: TDataSource;
    clIDJEDEC: TcxGridDBBandedColumn;
    dsJEDEC: TDataSource;
  private
    FIDBodyVariations: string;
    FqBodyVariationsJedec: TQueryBodyVariationsJedec;
    FqJEDEC: TQueryJEDEC;
    function GetqBodyVariationsJedec: TQueryBodyVariationsJedec;
    function GetqJEDEC: TQueryJEDEC;
    procedure SetIDBodyVariations(const Value: string);
    { Private declarations }
  protected
    property qBodyVariationsJedec: TQueryBodyVariationsJedec read
        GetqBodyVariationsJedec;
    property qJEDEC: TQueryJEDEC read GetqJEDEC;
  public
    property IDBodyVariations: string read FIDBodyVariations write
        SetIDBodyVariations;
    { Public declarations }
  end;

implementation

{$R *.dfm}

function TViewBodyVariationJEDEC.GetqBodyVariationsJedec:
    TQueryBodyVariationsJedec;
begin
  if FqBodyVariationsJedec = nil then
  begin
    FqBodyVariationsJedec := TQueryBodyVariationsJedec.Create(Self);
  end;
  Result := FqBodyVariationsJedec;
end;

function TViewBodyVariationJEDEC.GetqJEDEC: TQueryJEDEC;
begin
  if FqJEDEC = nil then
  begin
    FqJEDEC := TQueryJEDEC.Create(Self);
    FqJEDEC.FDQuery.Open;
  end;
  Result := FqJEDEC;
end;

procedure TViewBodyVariationJEDEC.SetIDBodyVariations(const Value: string);
begin
  FIDBodyVariations := Value;
  dsJEDEC.DataSet := qJEDEC.FDQuery;
  DataSource.DataSet := qBodyVariationsJedec.FDQuery;

  qBodyVariationsJedec.SearchByIDBodyVariations(FIDBodyVariations);
end;

end.
