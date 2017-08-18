unit ProgressBarForm2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
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
  dxSkinXmas2008Blue, cxLabel, cxProgressBar, ProgressInfo, ProcRefUnit,
  ExcelDataModule, System.Contnrs;

type
  TfrmProgressBar2 = class(TfrmRoot)
    pbRead: TcxProgressBar;
    lRead: TcxLabel;
    lWrite: TcxLabel;
    pbWrite: TcxProgressBar;
  private
    FReadLabel: string;
    FWriteLabel: string;
    procedure DoAfterLoadSheet(ASender: TObject);
    procedure DoBeforeLoadSheet(ASender: TObject);
    procedure DoOnTotalProgress(ASender: TObject);
    { Private declarations }
  protected
    property ReadLabel: string read FReadLabel write FReadLabel;
    property WriteLabel: string read FWriteLabel write FWriteLabel;
  public
    constructor Create(AOwner: TComponent); override;
    class procedure Process(AExcelDM: TExcelDM;
      const AFileName, ACaption, ARowSubstitute: string); static;
    procedure UpdateReadStatistic(AProgressInfo: TProgressInfo);
    procedure UpdateWriteStatistic(AProgressInfo: TProgressInfo);
    { Public declarations }
  end;

implementation

uses NotifyEvents;

Var AfrmProgressBar: TfrmProgressBar2;

{$R *.dfm}

constructor TfrmProgressBar2.Create(AOwner: TComponent);
begin
  inherited;
  FReadLabel := 'Прочитано строк';
  FWriteLabel := 'Сохранено записей'
end;

procedure TfrmProgressBar2.DoAfterLoadSheet(ASender: TObject);
begin
  // Прямем окно с прогрессом
  Assert(AfrmProgressBar <> nil);
  AfrmProgressBar.Hide;
end;

procedure TfrmProgressBar2.DoBeforeLoadSheet(ASender: TObject);
begin
  Assert(AfrmProgressBar <> nil);
  AfrmProgressBar.Show; // Показываем окно с прогрессом
end;

procedure TfrmProgressBar2.DoOnTotalProgress(ASender: TObject);
begin
  Assert(AfrmProgressBar <> nil);
  AfrmProgressBar.UpdateReadStatistic(ASender as TProgressInfo);
end;

class procedure TfrmProgressBar2.Process(AExcelDM: TExcelDM;
  const AFileName, ACaption, ARowSubstitute: string);
var
  e: TNotifyEventWrap;
  L: TObjectList;
begin
  AfrmProgressBar := TfrmProgressBar2.Create(nil);
  try
    if not ACaption.IsEmpty then
      AfrmProgressBar.Caption := ACaption;

    if not ARowSubstitute.IsEmpty then
      AfrmProgressBar.ReadLabel := Format('Прочитано %s', [ARowSubstitute]);

    L := TObjectList.Create;
    try
      TNotifyEventWrap.Create(AExcelDM.BeforeLoadSheet, AfrmProgressBar.DoBeforeLoadSheet, L);
      e := TNotifyEventWrap.Create(AExcelDM.AfterLoadSheet, AfrmProgressBar.DoAfterLoadSheet, L);
      // Хотим первыми получать извещение об этом событии
      e.Index := 0;
      TNotifyEventWrap.Create(AExcelDM.OnTotalProgress, AfrmProgressBar.DoOnTotalProgress, L);

      AExcelDM.LoadExcelFile2(AFileName);
    finally
      FreeAndNil(L)
    end;

  finally
    FreeAndNil(AfrmProgressBar);
  end;

end;

procedure TfrmProgressBar2.UpdateReadStatistic(AProgressInfo: TProgressInfo);
begin
  Assert(AProgressInfo <> nil);

  lRead.Caption := Format('%s: %d из %d',
    [FReadLabel, AProgressInfo.ProcessRecords,
    AProgressInfo.TotalRecords]);

  pbRead.Position := AProgressInfo.Position;

  Application.ProcessMessages;
end;

procedure TfrmProgressBar2.UpdateWriteStatistic(AProgressInfo: TProgressInfo);
begin
  lWrite.Caption := Format('%s: %d из %d',
    [FWriteLabel, AProgressInfo.ProcessRecords,
    AProgressInfo.TotalRecords]);

  pbWrite.Position := AProgressInfo.Position;

  Application.ProcessMessages;
end;

end.
