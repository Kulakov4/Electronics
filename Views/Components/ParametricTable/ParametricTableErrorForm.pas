unit ParametricTableErrorForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RootForm, Vcl.ExtCtrls, GridFrame,
  GridView, GridViewEx, ParametricTableErrorView, cxGraphics, cxLookAndFeels,
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
  dxSkinXmas2008Blue, Vcl.StdCtrls, cxButtons, System.Contnrs;

type
  TfrmParametricTableError = class(TfrmRoot)
    pnlMain: TPanel;
    cxButtonNext: TcxButton;
    cxButtonCancel: TcxButton;
  private
    FEvents: TObjectList;
    FViewParametricTableError: TViewParametricTableError;
    procedure DoOnAssignDataSet(Sender: TObject);
    procedure DoOnFixError(Sender: TObject);
    procedure UpdateView;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property ViewParametricTableError: TViewParametricTableError
      read FViewParametricTableError;
    { Public declarations }
  end;

implementation

uses
  NotifyEvents, ParametricErrorTable;

{$R *.dfm}

constructor TfrmParametricTableError.Create(AOwner: TComponent);
begin
  inherited;
  FEvents := TObjectList.Create;
  FViewParametricTableError := TViewParametricTableError.Create(Self);
  FViewParametricTableError.Parent := pnlMain;
  FViewParametricTableError.Align := alClient;
  TNotifyEventWrap.Create(FViewParametricTableError.OnAssignDataSet,
    DoOnAssignDataSet, FEvents);
  UpdateView;
end;

destructor TfrmParametricTableError.Destroy;
begin
  FreeAndNil(FEvents);
  inherited;
end;

procedure TfrmParametricTableError.DoOnAssignDataSet(Sender: TObject);
begin
  TNotifyEventWrap.Create(FViewParametricTableError.W.OnFixError,
    DoOnFixError, FEvents);
  UpdateView;
end;

procedure TfrmParametricTableError.DoOnFixError(Sender: TObject);
begin
  UpdateView;
end;

procedure TfrmParametricTableError.UpdateView;
begin
  // Кнопка "Далее" активна,
  // если в списке ошибок нет ошибок связанных с дублированием параметра

  cxButtonNext.Enabled := (FViewParametricTableError.DSWrap <> nil) and
    ((FViewParametricTableError.W.DataSet as TParametricErrorTable)
    .ParamDuplicateClone.RecordCount = 0);
end;

end.
