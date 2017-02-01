unit ImportProcessForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, CustomErrorForm, Data.DB, GridFrame,
  ImportErrorView, Vcl.ExtCtrls, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, dxSkinsCore, dxSkinBlack, dxSkinBlue,
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
  dxSkinXmas2008Blue, Vcl.StdCtrls, cxButtons;

type
  TfrmImportProcess = class(TfrmCustomError)
    Panel1: TPanel;
    cxbtnOK: TcxButton;
    procedure cxbtnOKClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    FDone: Boolean;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    property Done: Boolean read FDone write FDone;
    { Public declarations }
  end;

var
  frmImportProcess: TfrmImportProcess;

implementation

{$R *.dfm}

constructor TfrmImportProcess.Create(AOwner: TComponent);
begin
  inherited;
  FDone := False;
end;

procedure TfrmImportProcess.cxbtnOKClick(Sender: TObject);
begin
  inherited;
  Close;
  ModalResult := mrOk;
end;

procedure TfrmImportProcess.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  Action := caFree;
  frmImportProcess := nil;
end;

procedure TfrmImportProcess.FormCloseQuery(Sender: TObject; var CanClose:
    Boolean);
begin
  inherited;
  CanClose := Done;
end;

end.
