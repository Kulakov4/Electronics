unit ProgressBarForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls,
  cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, cxProgressBar,
  cxLabel, ProgressInfo, RootForm, dxSkinsCore, dxSkinBlack, dxSkinBlue,
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
  dxSkinXmas2008Blue;

type
  TfrmProgressBar = class;

  TfrmProgressBar = class(TfrmRoot)
    pnlMain: TPanel;
    cxlblProgress: TcxLabel;
    cxpbMain: TcxProgressBar;
  private
    FProgressInfo: TProgressInfo;
    procedure DoOnAssign(Sender: TObject);
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    property ProgressInfo: TProgressInfo read FProgressInfo;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses NotifyEvents;

constructor TfrmProgressBar.Create(AOwner: TComponent);
begin
  inherited;
  FProgressInfo := TProgressInfo.Create;
  TNotifyEventWrap.Create(FProgressInfo.OnAssign, DoOnAssign);
end;

procedure TfrmProgressBar.DoOnAssign(Sender: TObject);
begin
  cxlblProgress.Caption := Format('Обработано строк: %d из %d',
    [FProgressInfo.ProcessRecords, FProgressInfo.TotalRecords]);
  cxpbMain.Position := FProgressInfo.Position;

  Application.ProcessMessages;
end;

end.
