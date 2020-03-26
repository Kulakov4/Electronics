unit CustomErrorForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, GridViewForm2, cxGraphics,
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
  cxLabel, System.Actions, Vcl.ActnList;

type
  TContinueType = (ctAll, ctSkip);
  TCustomErrorFormClass = class of TfrmCustomError;

  TfrmCustomError = class(TfrmGridView2)
    lblStatus: TcxLabel;
    ErrorActionList: TActionList;
    actAll: TAction;
    actSkip: TAction;
    procedure actAllExecute(Sender: TObject);
    procedure actSkipExecute(Sender: TObject);
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

procedure TfrmCustomError.actAllExecute(Sender: TObject);
begin
  inherited;
  FContinueType := ctAll;
  ModalResult := mrOk;
end;

procedure TfrmCustomError.actSkipExecute(Sender: TObject);
begin
  inherited;
  FContinueType := ctSkip;
  ModalResult := mrOk;
end;

procedure TfrmCustomError.DoOnAssignDataSet(Sender: TObject);
begin
  if (ErrorTable <> nil) and (ErrorTable.Active) then
  begin
    lblStatus.Caption := Format('Ошибок: %d, Предупреждений: %d',
      [ErrorTable.TotalError, ErrorTable.TotalWarrings]);

    actAll.Visible := ErrorTable.TotalWarrings > 0;
    actSkip.Visible := ErrorTable.TotalWarrings > 0;
  end;
end;

function TfrmCustomError.GetErrorTable: TCustomErrorTable;
begin
  if ViewGridEx.DSWrap <> nil then
    Result := ViewGridEx.DsWrap.DataSet as TCustomErrorTable
  else
    Result := nil;
end;

end.
