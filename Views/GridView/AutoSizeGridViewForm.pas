unit AutoSizeGridViewForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, GridViewForm2, cxGraphics,
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
  dxSkinXmas2008Blue, Vcl.StdCtrls, cxButtons, GridFrame, GridView, GridViewEx,
  Vcl.ExtCtrls, NotifyEvents;

type
  TfrmGridViewAutoSize = class(TfrmGridView2)
  private
    procedure DoOnAssignDataset(Sender: TObject);
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TfrmGridViewAutoSize.Create(AOwner: TComponent);
begin
  inherited;
  AutoSaveFormSize := False;

  TNotifyEventWrap.Create( ViewGridEx.OnAssignDataSet, DoOnAssignDataset );
end;

procedure TfrmGridViewAutoSize.DoOnAssignDataset(Sender: TObject);
//var
//  I: Integer;
//  w: Integer;
begin
//  i := ViewGridEx.MainView.ViewInfo.HeaderViewInfo.Width;
//  w := 0;
//  for I := 0 to ViewGridEx.MainView.ViewInfo.HeaderViewInfo.Count - 1 do
//    Inc(w, ViewGridEx.MainView.ViewInfo.HeaderViewInfo.Items[i].Width);

  ClientWidth := ViewGridEx.MainView.ViewInfo.HeaderViewInfo.Width + 20;
end;

end.
