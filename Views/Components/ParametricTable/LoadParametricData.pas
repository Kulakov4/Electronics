unit LoadParametricData;

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
  Vcl.ImgList, cxImageList, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  Vcl.StdCtrls, cxButtons, cxRadioGroup, cxLabel, cxGroupBox, cxCheckBox;

type
  TfrmLoadParametricData = class(TfrmLoadParametric)
    cxcbCopyCommonValueToFamily: TcxCheckBox;
    cxlblCopyCommonValueToFamily: TcxLabel;
  private
    function GetCopyCommonValueToFamily: Boolean;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    property CopyCommonValueToFamily: Boolean read GetCopyCommonValueToFamily;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TfrmLoadParametricData.Create(AOwner: TComponent);
begin
  inherited;
  FIniSection := 'ParametricTableData';
end;

function TfrmLoadParametricData.GetCopyCommonValueToFamily: Boolean;
begin
  Result := cxcbCopyCommonValueToFamily.Checked;
end;

end.
