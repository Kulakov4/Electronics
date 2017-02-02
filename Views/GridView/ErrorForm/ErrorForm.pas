unit ErrorForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics,
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
  dxSkinXmas2008Blue, Vcl.StdCtrls, cxButtons, Data.DB, GridFrame,
  Vcl.ExtCtrls, cxControls, cxContainer, cxEdit, cxLabel, GridView,
  GridViewForm, CustomErrorTable;

type
  TfrmError = class(TfrmGridView)
    Panel1: TPanel;
    cxlblTotalErrors: TcxLabel;
    cxbtnOK: TcxButton;
  private
    function GetErrorTable: TCustomErrorTable;
    procedure SetErrorTable(const Value: TCustomErrorTable);
    { Private declarations }
  protected
    procedure AssignErrorTable; override;
  public
    property ErrorTable: TCustomErrorTable read GetErrorTable write SetErrorTable;
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TfrmError.AssignErrorTable;
begin
  inherited;
  cxlblTotalErrors.Caption := Format('Ошибок: %d, Предупреждений: %d', [ErrorTable.TotalError, ErrorTable.TotalWarrings]);
end;

function TfrmError.GetErrorTable: TCustomErrorTable;
begin
  if DataSet <> nil then
    Result := DataSet as TCustomErrorTable
  else
    Result := nil;
end;

procedure TfrmError.SetErrorTable(const Value: TCustomErrorTable);
begin
  if DataSet <> Value then
  begin
    DataSet := Value;
  end;

end;

end.
