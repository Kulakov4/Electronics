unit GridViewForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, Vcl.StdCtrls, cxButtons,
  cxClasses, cxPropertiesStore, GridFrame, Vcl.ActnList, dxSkinsCore,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
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
  dxSkinXmas2008Blue, RootForm;

type
  TMyMsgDlgBtn = (mmbOK, mmbCancel, mmbContinue);
  TMyMsgDlgButtons = set of TMyMsgDlgBtn;


  TfrmGridView = class(TfrmRoot)
    pnlMain: TPanel;
    cxbtnOK: TcxButton;
    cxbtnCancel: TcxButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FGridView: TfrmGrid;
    FGridViewClass: TGridViewClass;
    FOKAction: TAction;
    procedure SetGridViewClass(const Value: TGridViewClass);
    { Private declarations }
  public
    constructor Create(AOwner: TComponent; const ACaption: string; MyMsgDlgButtons:
        TMyMsgDlgButtons; AWidth: Cardinal = 0; AHeight: Cardinal = 0); reintroduce;
    procedure AfterConstruction; override;
    property GridView: TfrmGrid read FGridView;
    property GridViewClass: TGridViewClass read FGridViewClass
      write SetGridViewClass;
    property OKAction: TAction read FOKAction write FOKAction;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TfrmGridView.Create(AOwner: TComponent; const ACaption: string;
    MyMsgDlgButtons: TMyMsgDlgButtons; AWidth: Cardinal = 0; AHeight: Cardinal
    = 0);
begin
  inherited Create(AOwner);
  OKAction := nil;
  Caption := ACaption;

  // Если кнопка отмена нам не нужна
  if not (mmbCancel in MyMsgDlgButtons) then
  begin
    cxbtnOk.Left := cxbtnCancel.Left;
    cxbtnCancel.Visible := False;
  end;

  if mmbContinue in MyMsgDlgButtons then
  begin
    cxbtnOK.Caption := 'Продолжить'
  end;

  if AWidth > 0 then
    Width := AWidth;

  if AHeight > 0 then
    Height := AHeight;
end;

procedure TfrmGridView.AfterConstruction;
begin
  inherited;

//  cxpsViewForm.RestoreFrom;
end;

procedure TfrmGridView.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//  cxpsViewForm.StoreTo();

  if (ModalResult = mrOK) and (OKAction <> nil) and (OKAction.Enabled) then
  try
    // Пытаемся сохранить
    OKAction.Execute;
  except
    Action := caNone;
    raise;
  end;
end;

procedure TfrmGridView.SetGridViewClass(const Value: TGridViewClass);
begin
  if FGridViewClass = Value then
    Exit;

  FGridViewClass := Value;
  FreeAndNil(FGridView);
  FGridView := FGridViewClass.Create(nil);
  FGridView.Place(pnlMain);
end;

end.
