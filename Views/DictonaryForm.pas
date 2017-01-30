unit DictonaryForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, Vcl.StdCtrls, cxButtons, Vcl.ExtCtrls,
  System.Actions, Vcl.ActnList, RootForm, dxSkinsCore, dxSkinBlack, dxSkinBlue,
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
  dxSkinXmas2008Blue;

type
  TfrmDictonary = class(TfrmRoot)
    Panel1: TPanel;
    btnOk: TcxButton;
    btnCancel: TcxButton;
    ActionList: TActionList;
    actOk: TAction;
    actCancel: TAction;
    procedure actCancelExecute(Sender: TObject);
    procedure actOkExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  protected
    procedure ApplyUpdates; virtual; abstract;
    procedure CancelUpdates; virtual; abstract;
    procedure ClearFormVariable; virtual; abstract;
    function HaveAnyChanges: Boolean; virtual; abstract;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses RepositoryDataModule, DialogUnit;

procedure TfrmDictonary.actCancelExecute(Sender: TObject);
begin
  CancelUpdates;
  Close;
end;

procedure TfrmDictonary.actOkExecute(Sender: TObject);
begin
  ApplyUpdates;
  Close;
end;

procedure TfrmDictonary.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;

  if HaveAnyChanges then
  begin
    case TDialog.Create.SaveDataDialog of
      IDYES:
        ApplyUpdates;
      IDNO:
        CancelUpdates;
      IDCancel:
        Action := caNone;
    end;
  end;

  if Action <> caNone then
  begin
    Action := caFree;
    ClearFormVariable;
  end;
end;

end.
