unit StoreHouseInfoView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, cxTextEdit,
  cxMemo, cxDBEdit, cxLabel, Vcl.ExtCtrls, Data.DB, cxMaskEdit, cxSpinEdit,
  StoreHouseListQuery, dxSkinsCore, dxSkinsDefaultPainters, dxSkinBlack,
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
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVisualStudio2013Blue,
  dxSkinVisualStudio2013Dark, dxSkinVisualStudio2013Light, dxSkinVS2010,
  dxSkinWhiteprint, dxSkinXmas2008Blue;

type
  TViewStorehouseInfo = class(TFrame)
    lblTitle: TcxLabel;
    lblExternalId: TcxLabel;
    lblResponsible: TcxLabel;
    lblAddress: TcxLabel;
    cxTeResponsible: TcxDBTextEdit;
    cxdbmAddress: TcxDBMemo;
    cxdbteAbbreviation: TcxDBTextEdit;
    cxdbmTitle: TcxDBMemo;
    procedure FrameClick(Sender: TObject);
  private
    FQueryStoreHouseList: TQueryStoreHouseList;
    procedure SetQueryStoreHouseList(const Value: TQueryStoreHouseList);
    { Private declarations }
  protected
  public
// TODO: SaveChanges
//  procedure SaveChanges;
    property QueryStoreHouseList: TQueryStoreHouseList read FQueryStoreHouseList
        write SetQueryStoreHouseList;
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TViewStorehouseInfo.FrameClick(Sender: TObject);
begin
  if QueryStoreHouseList <> nil then
    QueryStoreHouseList.TryPost;
end;

// TODO: SaveChanges
//procedure TfrStorehouseInfo.SaveChanges;
//begin
//if datamoduleMain.dsStorehouseList.DataSet.State in [dsEdit, dsInsert] then
//  datamoduleMain.dsStorehouseList.DataSet.Post;
//end;

procedure TViewStorehouseInfo.SetQueryStoreHouseList(const Value:
    TQueryStoreHouseList);
begin
  if FQueryStoreHouseList <> Value then
  begin
    FQueryStoreHouseList := Value;

    if FQueryStoreHouseList <> nil then
    begin
      cxdbmTitle.DataBinding.DataSource := FQueryStoreHouseList.DataSource;
      cxdbteAbbreviation.DataBinding.DataSource := FQueryStoreHouseList.DataSource;
      cxTeResponsible.DataBinding.DataSource := FQueryStoreHouseList.DataSource;
      cxdbmAddress.DataBinding.DataSource := FQueryStoreHouseList.DataSource;
    end
    else
    begin
      cxdbmTitle.DataBinding.DataSource := nil;
      cxdbteAbbreviation.DataBinding.DataSource := nil;
      cxTeResponsible.DataBinding.DataSource := nil;
      cxdbmAddress.DataBinding.DataSource := nil;
    end;
  end;
end;

end.
