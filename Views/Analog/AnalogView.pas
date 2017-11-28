unit AnalogView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AnalogQueryes, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, dxSkinBlack,
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
  dxSkinXmas2008Blue, dxSkinscxPCPainter, dxBarBuiltInMenu, cxPC, GridViewEx,
  Vcl.ExtCtrls;

type
  TViewAnalog = class(TFrame)
  private
    FAnalogGroup: TAnalogGroup;
    procedure SetAnalogGroup(const Value: TAnalogGroup);
    { Private declarations }
  public
    property AnalogGroup: TAnalogGroup read FAnalogGroup write SetAnalogGroup;
    { Public declarations }
  end;

implementation

uses System.StrUtils;

{$R *.dfm}

procedure TViewAnalog.SetAnalogGroup(const Value: TAnalogGroup);
var
  APanel: TPanel;
  AParamValues: TParamValues;
  AViewGridEx: TViewGridEx;
  i: Integer;
begin
  if FAnalogGroup = Value then
    Exit;

  FAnalogGroup := Value;

  if FAnalogGroup = nil then
    Exit;

  i := 0;
  for AParamValues in FAnalogGroup.ParamValuesList do
  begin
    APanel := TPanel.Create(Self);
    APanel.Parent := Self;
    APanel.Align := alLeft;
    APanel.Width := 100;
  {
    AcxTabSheet := TcxTabSheet.Create(Self);
    AcxTabSheet.Caption := AParamValues.Caption;
    AcxTabSheet.AllowCloseButton := False;
    AcxTabSheet.PageControl := cxPageControl;
  }

    Inc(i);

    AViewGridEx := TViewGridEx.Create(Self);
    AViewGridEx.Name := Format('ViewGridEx_%d', [i]);
    AViewGridEx.Parent := APanel;
    AViewGridEx.Align := alClient;
    AViewGridEx.DataSet := AParamValues.Table;

  end;

end;

end.
