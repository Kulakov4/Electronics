unit MinWholeSaleForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore, dxSkinBlack,
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
  dxSkinXmas2008Blue, cxTextEdit, cxMaskEdit, cxSpinEdit, cxLabel, Vcl.Menus,
  Vcl.StdCtrls, cxButtons, cxCheckBox;

type
  TfrmMinWholeSale = class(TForm)
    cxLabel1: TcxLabel;
    cxseMinWholeSale: TcxSpinEdit;
    cxLabel2: TcxLabel;
    cxbtnYes: TcxButton;
    cxbtnCancel: TcxButton;
    cxcbSave: TcxCheckBox;
  private
    function GetMinWholeSale: Double;
    function GetSave: Boolean;
    procedure SetMinWholeSale(const Value: Double);
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    class function DoShowModal(var ADefMinWholeSale: Double; var ASave: Boolean):
        Boolean; static;
    property MinWholeSale: Double read GetMinWholeSale write SetMinWholeSale;
    property Save: Boolean read GetSave;
    { Public declarations }
  end;

implementation

uses
  FormsHelper, ProjectConst;

{$R *.dfm}

constructor TfrmMinWholeSale.Create(AOwner: TComponent);
begin
  inherited;
//  TFormsHelper.SetFont(Self, BaseFontSize);
end;

function TfrmMinWholeSale.GetMinWholeSale: Double;
begin
  Result := StrToFloat(VarToStrDef(cxseMinWholeSale.Value, '0'));
end;

procedure TfrmMinWholeSale.SetMinWholeSale(const Value: Double);
begin
  cxseMinWholeSale.Value := Value;
end;

class function TfrmMinWholeSale.DoShowModal(var ADefMinWholeSale: Double; var
    ASave: Boolean): Boolean;
var
  AfrmMinWholeSale: TfrmMinWholeSale;
begin
  AfrmMinWholeSale := TfrmMinWholeSale.Create(nil);
  try
    AfrmMinWholeSale.MinWholeSale := ADefMinWholeSale;
    Result := AfrmMinWholeSale.ShowModal = mrOK;
    if Result then
      ADefMinWholeSale := AfrmMinWholeSale.MinWholeSale;

    ASave := Result and AfrmMinWholeSale.Save;
  finally
    AfrmMinWholeSale.Free;
  end;
end;

function TfrmMinWholeSale.GetSave: Boolean;
begin
  Result := cxcbSave.Checked;
end;

end.
