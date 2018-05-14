unit ProgressBarForm3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RootForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore,
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
  dxSkinXmas2008Blue, cxLabel, cxProgressBar, ProgressInfo;

type
  TfrmProgressBar3 = class(TfrmRoot)
    pbRead: TcxProgressBar;
    lRead: TcxLabel;
    lWrite: TcxLabel;
    pbWrite: TcxProgressBar;
    lWrite0: TcxLabel;
    pbWrite0: TcxProgressBar;
    lAnalize: TcxLabel;
    bpAnalize: TcxProgressBar;
  private
    FReadLabel: string;
    FAnalizeLabel: string;
    FWriteLabel0: string;
    FWriteLabel: string;
    { Private declarations }
  protected
    property ReadLabel: string read FReadLabel write FReadLabel;
    property AnalizeLabel: string read FAnalizeLabel write FAnalizeLabel;
    property WriteLabel0: string read FWriteLabel0 write FWriteLabel0;
    property WriteLabel: string read FWriteLabel write FWriteLabel;
  public
    constructor Create(AOwner: TComponent); override;
    procedure UpdateReadStatistic(AProgressInfo: TProgressInfo);
    procedure UpdateWriteStatistic(AProgressInfo: TProgressInfo);
    procedure UpdateWriteStatistic0(AProgressInfo: TProgressInfo);
    procedure UpdateAnalizeStatistic(AProgressInfo: TProgressInfo);
    { Public declarations }
  end;

var
  frmProgressBar3: TfrmProgressBar3;

implementation

{$R *.dfm}

constructor TfrmProgressBar3.Create(AOwner: TComponent);
begin
  inherited;
  FReadLabel := 'Прочитано строк';
  FWriteLabel0 := 'Добавлено/обновлено параметров';
  FWriteLabel := 'Сохранено записей';
  FAnalizeLabel := 'Проанализировано записей';
end;

procedure TfrmProgressBar3.UpdateReadStatistic(AProgressInfo: TProgressInfo);
begin
  Assert(AProgressInfo <> nil);

  lRead.Caption := Format('%s: %d из %d',
    [FReadLabel, AProgressInfo.ProcessRecords,
    AProgressInfo.TotalRecords]);

  pbRead.Position := AProgressInfo.Position;

  Application.ProcessMessages;
end;

procedure TfrmProgressBar3.UpdateWriteStatistic(AProgressInfo: TProgressInfo);
begin
  lWrite.Caption := Format('%s: %d из %d',
    [FWriteLabel, AProgressInfo.ProcessRecords,
    AProgressInfo.TotalRecords]);

  pbWrite.Position := AProgressInfo.Position;

  Application.ProcessMessages;
end;

procedure TfrmProgressBar3.UpdateWriteStatistic0(AProgressInfo: TProgressInfo);
begin
  lWrite0.Caption := Format('%s: %d из %d',
    [FWriteLabel0, AProgressInfo.ProcessRecords,
    AProgressInfo.TotalRecords]);

  pbWrite0.Position := AProgressInfo.Position;

  Application.ProcessMessages;
end;

procedure TfrmProgressBar3.UpdateAnalizeStatistic(AProgressInfo: TProgressInfo);
begin
  lAnalize.Caption := Format('%s: %d из %d',
    [FAnalizeLabel, AProgressInfo.ProcessRecords,
    AProgressInfo.TotalRecords]);

  bpAnalize.Position := AProgressInfo.Position;

  Application.ProcessMessages;
end;

end.
