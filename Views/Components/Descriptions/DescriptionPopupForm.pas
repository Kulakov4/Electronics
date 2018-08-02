unit DescriptionPopupForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, PopupForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore,
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
  dxSkinXmas2008Blue, cxTextEdit, cxMemo, cxDBEdit, CustomComponentsQuery,
  dxSkinsdxBarPainter, System.Actions, Vcl.ActnList, cxClasses, dxBar,
  BaseQuery, QueryWithDataSourceUnit, Data.DB;

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
    procedure actClearExecute(Sender: TObject);
    procedure actSelectExecute(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FQuery: TQueryWithDataSource;
    function GetDescription: TField;
    function GetDescriptionComponentName: TField;
    function GetDescriptionID: TField;
    procedure SetQuery(const Value: TQueryWithDataSource);
    { Private declarations }
  protected
    procedure UpdateView;
  public
    constructor Create(AOwner: TComponent); override;
    property Description: TField read GetDescription;
    property DescriptionComponentName: TField read GetDescriptionComponentName;
    property DescriptionID: TField read GetDescriptionID;
    property Query: TQueryWithDataSource read FQuery write SetQuery;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses DescriptionsForm, DataModule;

constructor TfrmDescriptionPopup.Create(AOwner: TComponent);
begin
  inherited;
;
end;

procedure TfrmDescriptionPopup.actClearExecute(Sender: TObject);
begin
  inherited;
  FQuery.TryEdit;
  DescriptionComponentName.Value := NULL;
  Description.Value := NULL;
  DescriptionID.Value := NULL;
  FQuery.TryPost;

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
    AfrmDescriptions.ViewDescriptions.DescriptionsGroup := TDM.Create.DescriptionsGroup;

    if not DescriptionComponentName.AsString.IsEmpty then
      AfrmDescriptions.ViewDescriptions.Locate(DescriptionComponentName.AsString);

    if AfrmDescriptions.ShowModal = mrOk then
    begin
      FQuery.TryEdit;
      DescriptionComponentName.Value :=
        TDM.Create.DescriptionsGroup.qDescriptions.ComponentName.Value;
      Description.Value :=
        TDM.Create.DescriptionsGroup.qDescriptions.Description.Value;
      DescriptionID.Value :=
        TDM.Create.DescriptionsGroup.qDescriptions.PK.Value;
      FQuery.TryPost;
    end;
  finally
    FreeAndNil(AfrmDescriptions);
  end;
  UpdateView;
end;

procedure TfrmDescriptionPopup.FormHide(Sender: TObject);
begin
  inherited;
  ;
end;

procedure TfrmDescriptionPopup.FormShow(Sender: TObject);
begin
  inherited;
  UpdateView;
end;

function TfrmDescriptionPopup.GetDescription: TField;
begin
  Result := FQuery.Field('Description');
end;

function TfrmDescriptionPopup.GetDescriptionComponentName: TField;
begin
  Result := FQuery.Field('DescriptionComponentName');
end;

function TfrmDescriptionPopup.GetDescriptionID: TField;
begin
  Result := FQuery.Field('DescriptionID');
end;

procedure TfrmDescriptionPopup.SetQuery(const Value: TQueryWithDataSource);
begin
  if FQuery = Value then Exit;

  FQuery := Value;

  if FQuery <> nil then
  begin
    Assert(FQuery.FDQuery.Active);
    cxdbmDescriptions.DataBinding.DataSource :=
      FQuery.DataSource;
    cxdbmDescriptions.DataBinding.DataField :=
      Description.FieldName;
  end;

  UpdateView;
end;

procedure TfrmDescriptionPopup.UpdateView;
begin
  actSelect.Enabled := (FQuery <> nil);
  actClear.Enabled := (FQuery <> nil) and (not DescriptionID.IsNull);
end;

end.
