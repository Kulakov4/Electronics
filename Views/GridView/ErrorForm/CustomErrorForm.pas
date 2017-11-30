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
  dxSkinXmas2008Blue, Vcl.StdCtrls, cxButtons, GridFrame, GridView, GridViewEx,
  Vcl.ExtCtrls, NotifyEvents, CustomErrorTable, cxControls, cxContainer, cxEdit,
  cxLabel;

type
  TContinueType = (ctAll, ctSkip);
  TCustomErrorFormClass = class of TfrmCustomError;

  TfrmCustomError = class(TfrmGridView)
    lblStatus: TcxLabel;
  private
    procedure DoOnAssignDataSet(Sender: TObject);
    function GetErrorTable: TCustomErrorTable;
    { Private declarations }
  protected
    FContinueType: TContinueType;
  public
    constructor Create(AOwner: TComponent); override;
    property ContinueType: TContinueType read FContinueType;
    property ErrorTable: TCustomErrorTable read GetErrorTable;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TfrmCustomError.Create(AOwner: TComponent);
begin
  inherited;
  TNotifyEventWrap.Create(ViewGridEx.OnAssignDataSet, DoOnAssignDataSet);
end;

procedure TfrmCustomError.DoOnAssignDataSet(Sender: TObject);
begin
  if (ErrorTable <> nil) and (ErrorTable.Active) then
    lblStatus.Caption := Format('������: %d, ��������������: %d',
      [ErrorTable.TotalError, ErrorTable.TotalWarrings]);
end;

function TfrmCustomError.GetErrorTable: TCustomErrorTable;
begin
  if ViewGridEx.DataSet <> nil then
    Result := ViewGridEx.DataSet as TCustomErrorTable
  else
    Result := nil;
end;

end.
