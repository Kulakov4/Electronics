unit ExtraChargeForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DictonaryForm, cxGraphics,
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
  Vcl.ExtCtrls, ExtraChargeView;

type
  TfrmExtraCharge = class(TfrmDictonary)
  private
    FViewExtraCharge: TViewExtraCharge;
    { Private declarations }
  protected
    procedure ApplyUpdates; override;
    procedure CancelUpdates; override;
    procedure ClearFormVariable; override;
    function HaveAnyChanges: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    property ViewExtraCharge: TViewExtraCharge read FViewExtraCharge;
    { Public declarations }
  end;

var
  frmExtraCharge: TfrmExtraCharge;

implementation

{$R *.dfm}

uses RepositoryDataModule;

constructor TfrmExtraCharge.Create(AOwner: TComponent);
begin
  inherited;
  FViewExtraCharge := TViewExtraCharge.Create(Self);
  FViewExtraCharge.Parent := Panel1;
  FViewExtraCharge.Align := alClient;
end;

procedure TfrmExtraCharge.ApplyUpdates;
begin
  ViewExtraCharge.actCommit.Execute;
end;

procedure TfrmExtraCharge.CancelUpdates;
begin
  ViewExtraCharge.actRollback.Execute;
end;

procedure TfrmExtraCharge.ClearFormVariable;
begin
  frmExtraCharge := nil;
end;

function TfrmExtraCharge.HaveAnyChanges: Boolean;
begin
  Result := ViewExtraCharge.qExtraCharge.FDQuery.Connection.InTransaction;
end;

end.
