unit ParametersForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DictonaryForm, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, System.Actions,
  Vcl.ActnList, Vcl.StdCtrls, cxButtons, Vcl.ExtCtrls, GridFrame,
  ParametersView,
  dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
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
  dxSkinXmas2008Blue, cxControls, dxSkinscxPCPainter, dxBarBuiltInMenu, cxPC,
  SubParametersView;

type
  TfrmParameters = class(TfrmDictonary)
    cxPageControl: TcxPageControl;
    cxtsParameters: TcxTabSheet;
    cxtsSubParameters: TcxTabSheet;
    ViewParameters: TViewParameters;
    ViewSubParameters: TViewSubParameters;
    procedure FormCreate(Sender: TObject);
    procedure cxPageControlPageChanging(Sender: TObject; NewPage: TcxTabSheet;
      var AllowChange: Boolean);
  private
    { Private declarations }
  protected
    procedure ApplyUpdates; override;
    procedure CancelUpdates; override;
    procedure ClearFormVariable; override;
    function HaveAnyChanges: Boolean; override;
  public
    { Public declarations }
  end;

var
  frmParameters: TfrmParameters;

implementation

{$R *.dfm}

procedure TfrmParameters.ApplyUpdates;
begin
  ViewParameters.CommitOrPost;
end;

procedure TfrmParameters.CancelUpdates;
begin
  ViewParameters.actRollback.Execute;
end;

procedure TfrmParameters.ClearFormVariable;
begin
  frmParameters := nil;
end;

procedure TfrmParameters.cxPageControlPageChanging(Sender: TObject;
  NewPage: TcxTabSheet; var AllowChange: Boolean);
begin
  inherited;
  if cxPageControl.ActivePage = cxtsSubParameters then
    AllowChange := ViewSubParameters.CheckAndSaveChanges <> IDCANCEL;

  if cxPageControl.ActivePage = cxtsParameters then
    AllowChange := ViewParameters.CheckAndSaveChanges <> IDCANCEL;
end;

procedure TfrmParameters.FormCreate(Sender: TObject);
begin
  inherited;
  cxPageControl.ActivePage := cxtsParameters;
end;

function TfrmParameters.HaveAnyChanges: Boolean;
begin
  Result := ViewParameters.ParametersGrp.Connection.InTransaction;
end;

end.
