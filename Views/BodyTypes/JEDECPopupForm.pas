unit JEDECPopupForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, PopupForm, dxSkinsCore, dxSkinBlack,
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
  dxSkinXmas2008Blue, dxSkinsdxBarPainter, cxClasses, dxBar, System.Actions,
  Vcl.ActnList, System.ImageList, Vcl.ImgList, cxGraphics,
  BodyVariationJedecQuery, BodyVariationJedecView;

type
  TfrmJEDECPopup = class(TfrmPopupForm)
  private
    FViewBodyVariationJEDEC: TViewBodyVariationJEDEC;
    { Private declarations }
  protected
  public
    constructor Create(AOwner: TComponent); override;
    property ViewBodyVariationJEDEC: TViewBodyVariationJEDEC read
        FViewBodyVariationJEDEC;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TfrmJEDECPopup.Create(AOwner: TComponent);
begin
  inherited;
  FViewBodyVariationJEDEC := TViewBodyVariationJEDEC.Create(Self);
  FViewBodyVariationJEDEC.Parent := Self;
  FViewBodyVariationJEDEC.Align := alClient;
end;

end.
