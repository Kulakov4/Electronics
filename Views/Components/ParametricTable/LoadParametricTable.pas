unit LoadParametricTable;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, LoadParametricForm, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit,
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
  dxSkinXmas2008Blue, Vcl.Menus, System.Actions, Vcl.ActnList, System.ImageList,
  Vcl.ImgList, cxImageList, cxCheckBox, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  Vcl.StdCtrls, cxButtons, cxRadioGroup, cxLabel, cxGroupBox;

type
  TfrmLoadParametricTable = class(TfrmLoadParametric)
    cxcbLoadComponentGroup: TcxCheckBox;
    cxcbShowParametricTable: TcxCheckBox;
    procedure cxcbLoadComponentGroupClick(Sender: TObject);
  private
    function GetLoadComponentGroup: Boolean;
    function GetShowParametricTable: Boolean;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    property LoadComponentGroup: Boolean read GetLoadComponentGroup;
    property ShowParametricTable: Boolean read GetShowParametricTable;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TfrmLoadParametricTable.Create(AOwner: TComponent);
begin
  inherited;
  FIniSection := 'ParametricTableFiles';
end;

procedure TfrmLoadParametricTable.cxcbLoadComponentGroupClick(Sender: TObject);
begin
  inherited;
  cxcbShowParametricTable.Enabled := cxcbLoadComponentGroup.Checked;

  if not cxcbShowParametricTable.Enabled then
    cxcbShowParametricTable.Checked := False;
end;

function TfrmLoadParametricTable.GetLoadComponentGroup: Boolean;
begin
  Result := cxcbLoadComponentGroup.Checked;
end;

function TfrmLoadParametricTable.GetShowParametricTable: Boolean;
begin
  Result := cxcbShowParametricTable.Checked;
end;

end.
