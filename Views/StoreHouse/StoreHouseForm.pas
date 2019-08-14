unit StoreHouseForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DictonaryForm, RootForm, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, dxSkinsCore, dxSkinBlack,
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
  dxSkinXmas2008Blue, System.Actions, Vcl.ActnList, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls, StoreHouseInfoView;

type
  TfrmStoreHouse = class(TfrmDictonary)
  private
    FViewStorehouseInfo: TViewStorehouseInfo;
    { Private declarations }
  protected
    procedure ApplyUpdates; override;
    procedure CancelUpdates; override;
    procedure ClearFormVariable; override;
    function HaveAnyChanges: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    property ViewStorehouseInfo: TViewStorehouseInfo read FViewStorehouseInfo;
    { Public declarations }
  end;


implementation

{$R *.dfm}

constructor TfrmStoreHouse.Create(AOwner: TComponent);
begin
  inherited;
  FViewStorehouseInfo := TViewStorehouseInfo.Create(Self);
  FViewStorehouseInfo.Parent := Panel1;
  FViewStorehouseInfo.Align := alClient;
end;

procedure TfrmStoreHouse.ApplyUpdates;
begin
  ViewStorehouseInfo.qStoreHouseList.ApplyUpdates;
end;

procedure TfrmStoreHouse.CancelUpdates;
begin
  ViewStorehouseInfo.qStoreHouseList.CancelUpdates;
end;

procedure TfrmStoreHouse.ClearFormVariable;
begin
  inherited;
end;

function TfrmStoreHouse.HaveAnyChanges: Boolean;
begin
  Result := ViewStorehouseInfo.qStoreHouseList.HaveAnyChanges;
end;

end.
