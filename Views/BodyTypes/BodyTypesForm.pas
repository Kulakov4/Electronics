unit BodyTypesForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  DictonaryForm, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus,
  System.Actions, Vcl.ActnList, Vcl.StdCtrls, cxButtons, Vcl.ExtCtrls,
  GridFrame, BodyTypesView, dxSkinsCore, dxSkinBlack,
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
  dxSkinXmas2008Blue;

type
  TfrmBodyTypes = class(TfrmDictonary)
  private
    FViewBodyTypes: TViewBodyTypes;
    { Private declarations }
  protected
    procedure ApplyUpdates; override;
    procedure CancelUpdates; override;
    procedure ClearFormVariable; override;
    function HaveAnyChanges: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    property ViewBodyTypes: TViewBodyTypes read FViewBodyTypes;
    { Public declarations }
  end;

var
  frmBodyTypes: TfrmBodyTypes;

implementation

{$R *.dfm}

constructor TfrmBodyTypes.Create(AOwner: TComponent);
begin
  inherited;
  FViewBodyTypes := TViewBodyTypes.Create(Self);
  FViewBodyTypes.Parent := Panel1;
  FViewBodyTypes.Align := alClient;
end;

procedure TfrmBodyTypes.ApplyUpdates;
begin
  ViewBodyTypes.UpdateView;
  ViewBodyTypes.actCommit.Execute;
end;

procedure TfrmBodyTypes.CancelUpdates;
begin
  ViewBodyTypes.UpdateView;
  ViewBodyTypes.actRollback.Execute;
end;

procedure TfrmBodyTypes.ClearFormVariable;
begin
  frmBodyTypes := nil;
end;

function TfrmBodyTypes.HaveAnyChanges: Boolean;
begin
  Result := ViewBodyTypes.BodyTypesGroup.HaveAnyChanges;
end;

end.
