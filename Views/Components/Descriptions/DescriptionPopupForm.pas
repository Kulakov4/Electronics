unit DescriptionPopupForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, PopupForm,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
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
  dxSkinXmas2008Blue, cxTextEdit, cxMemo, cxDBEdit, CustomComponentsQuery,
  dxSkinsdxBarPainter, System.Actions, Vcl.ActnList, cxClasses, dxBar,
  BaseQuery, Data.DB, DescriptionsQueryWrap;

type
  TfrmDescriptionPopup = class(TfrmPopupForm)
    cxdbmDescriptions: TcxDBMemo;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    ActionList: TActionList;
    actSelect: TAction;
    dxBarButton1: TdxBarButton;
    actClear: TAction;
    dxBarButton2: TdxBarButton;
    DataSource: TDataSource;
    procedure actClearExecute(Sender: TObject);
    procedure actSelectExecute(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FDescriptionW: TDescriptionW;
    procedure SetDescriptionW(const Value: TDescriptionW);
    { Private declarations }
  protected
    procedure UpdateView;
  public
    constructor Create(AOwner: TComponent); override;
    property DescriptionW: TDescriptionW read FDescriptionW
      write SetDescriptionW;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses DescriptionsForm, DataModule;

constructor TfrmDescriptionPopup.Create(AOwner: TComponent);
begin
  inherited;;
end;

procedure TfrmDescriptionPopup.actClearExecute(Sender: TObject);
begin
  inherited;

  FDescriptionW.TryEdit;
  FDescriptionW.DescriptionComponentName.F.Value := NULL;
  FDescriptionW.Description.F.Value := NULL;
  FDescriptionW.DescriptionID.F.Value := NULL;
  FDescriptionW.TryPost;

  UpdateView;
end;

procedure TfrmDescriptionPopup.actSelectExecute(Sender: TObject);
var
  AfrmDescriptions: TfrmDescriptions;
begin
  inherited;
  TDM.Create.DescriptionsGroup.ReOpen;

  AfrmDescriptions := TfrmDescriptions.Create(Self);
  try
    AfrmDescriptions.ViewDescriptions.DescriptionsGroup :=
      TDM.Create.DescriptionsGroup;

    if not FDescriptionW.DescriptionComponentName.F.AsString.IsEmpty then
      AfrmDescriptions.ViewDescriptions.Locate
        (FDescriptionW.DescriptionComponentName.F.AsString);

    if AfrmDescriptions.ShowModal = mrOk then
    begin
      FDescriptionW.TryEdit;

      FDescriptionW.DescriptionComponentName.F.Value :=
        TDM.Create.DescriptionsGroup.qDescriptions.W.ComponentName.F.Value;

      FDescriptionW.Description.F.Value :=
        TDM.Create.DescriptionsGroup.qDescriptions.W.Description.F.Value;

      FDescriptionW.DescriptionID.F.Value :=
        TDM.Create.DescriptionsGroup.qDescriptions.W.PK.Value;

      FDescriptionW.TryPost;
    end;
  finally
    FreeAndNil(AfrmDescriptions);
  end;
  UpdateView;
end;

procedure TfrmDescriptionPopup.FormHide(Sender: TObject);
begin
  inherited;;
end;

procedure TfrmDescriptionPopup.FormShow(Sender: TObject);
begin
  inherited;
  UpdateView;
end;

procedure TfrmDescriptionPopup.SetDescriptionW(const Value: TDescriptionW);
begin
  if FDescriptionW = Value then
    Exit;

  FDescriptionW := Value;

  if FDescriptionW <> nil then
  begin
    Assert(FDescriptionW.DataSet.Active);
    cxdbmDescriptions.DataBinding.DataField :=
      FDescriptionW.Description.FieldName;
  end;

  UpdateView;
end;

procedure TfrmDescriptionPopup.UpdateView;
begin
  actSelect.Enabled := (FDescriptionW <> nil);
  actClear.Enabled := (FDescriptionW <> nil) and
    (not FDescriptionW.DescriptionID.F.IsNull);
end;

end.
