unit ImportErrorForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, GridFrame,
  Vcl.ExtCtrls, cxGraphics, cxLookAndFeels,
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
  dxSkinXmas2008Blue, Vcl.StdCtrls, cxButtons, System.Actions, Vcl.ActnList,
  cxControls, cxContainer, cxEdit, cxLabel, GridView,
  CustomErrorTable, GridViewForm, CustomGridViewForm;

type
  TContinueType = (ctAll, ctSkip);

  TfrmImportError = class(TfrmGridView)
    pmContinue: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    ActionList1: TActionList;
    actAll: TAction;
    actSkip: TAction;
    cxbtnCancel: TcxButton;
    procedure actAllExecute(Sender: TObject);
    procedure actSkipExecute(Sender: TObject);
  private
    FContinueType: TContinueType;
    function GetErrorTable: TCustomErrorTable;
    procedure SetErrorTable(const Value: TCustomErrorTable);
    { Private declarations }
  protected
    procedure AssignDataSet; override;
  public
    property ContinueType: TContinueType read FContinueType;
    property ErrorTable: TCustomErrorTable read GetErrorTable write SetErrorTable;
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TfrmImportError.actAllExecute(Sender: TObject);
begin
  inherited;
  FContinueType := ctAll;
  ModalResult := mrOk;

end;

procedure TfrmImportError.actSkipExecute(Sender: TObject);
begin
  inherited;
  FContinueType := ctSkip;
  ModalResult := mrOk;
end;

procedure TfrmImportError.AssignDataSet;
begin
  inherited;
  if (DataSet <> nil) and (DataSet.Active) then
    lblStatus.Caption := Format('Ошибок: %d, Предупреждений: %d', [ErrorTable.TotalError, ErrorTable.TotalWarrings]);
end;

function TfrmImportError.GetErrorTable: TCustomErrorTable;
begin
  if DataSet <> nil then
    Result := DataSet as TCustomErrorTable
  else
    Result := nil;
end;

procedure TfrmImportError.SetErrorTable(const Value: TCustomErrorTable);
begin
  if DataSet <> Value then
  begin
    DataSet := Value;
  end;

end;

end.
