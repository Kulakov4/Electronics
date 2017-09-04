unit CustomErrorForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, GridViewForm, cxGraphics,
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
  dxSkinXmas2008Blue, Vcl.ExtCtrls, Data.DB, Vcl.StdCtrls, cxButtons, GridFrame,
  GridView, CustomErrorTable;

type
  TContinueType = (ctAll, ctSkip);
  TCustomErrorFormClass = class of TfrmCustomError;

  TfrmCustomError = class(TfrmGridView)
  private
    function GetErrorTable: TCustomErrorTable;
    procedure SetErrorTable(const Value: TCustomErrorTable);
    { Private declarations }
  protected
    FContinueType: TContinueType;
    procedure AssignDataSet; override;
  public
    constructor Create(AOwner: TComponent); override;
    property ContinueType: TContinueType read FContinueType;
    property ErrorTable: TCustomErrorTable read GetErrorTable write SetErrorTable;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TfrmCustomError.Create(AOwner: TComponent);
begin
  inherited;
  FContinueType := ctAll;
end;

procedure TfrmCustomError.AssignDataSet;
begin
  inherited;
  if (ErrorTable <> nil) and (ErrorTable.Active) then
    lblStatus.Caption := Format('������: %d, ��������������: %d',
      [ErrorTable.TotalError, ErrorTable.TotalWarrings]);
end;

function TfrmCustomError.GetErrorTable: TCustomErrorTable;
begin
  if DataSet <> nil then
    Result := DataSet as TCustomErrorTable
  else
    Result := nil;
end;

procedure TfrmCustomError.SetErrorTable(const Value: TCustomErrorTable);
begin
  if DataSet <> Value then
  begin
    DataSet := Value;
  end;

end;

end.