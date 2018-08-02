unit ProducersForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DictonaryForm, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, System.Actions,
  Vcl.ActnList, Vcl.StdCtrls, cxButtons, Vcl.ExtCtrls, GridFrame,
  dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
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
  dxSkinXmas2008Blue, ProducersView;

type
  TfrmProducers = class(TfrmDictonary)
  private
    FViewProducers: TViewProducers;
    { Private declarations }
  protected
    procedure ApplyUpdates; override;
    procedure CancelUpdates; override;
    procedure ClearFormVariable; override;
    function HaveAnyChanges: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    class function TakeProducer(var AProducerID: Integer;
      var AProducerName: String): Boolean; static;
    property ViewProducers: TViewProducers read FViewProducers;
    { Public declarations }
  end;

var
  frmProducers: TfrmProducers;

implementation

{$R *.dfm}

uses ProducersQuery, DialogUnit, ProducersGroupUnit2, SettingsController;

constructor TfrmProducers.Create(AOwner: TComponent);
begin
  inherited;
  FViewProducers := TViewProducers.Create(Self);
  FViewProducers.Parent := Panel1;
  FViewProducers.Align := alClient;
end;

procedure TfrmProducers.ApplyUpdates;
begin
  ViewProducers.UpdateView;
  ViewProducers.actCommit.Execute;
end;

procedure TfrmProducers.CancelUpdates;
begin
  ViewProducers.UpdateView;
  ViewProducers.actRollback.Execute;
end;

procedure TfrmProducers.ClearFormVariable;
begin
  frmProducers := nil;
end;

function TfrmProducers.HaveAnyChanges: Boolean;
begin
  Result := ViewProducers.ProducersGroup.HaveAnyChanges;
end;

class function TfrmProducers.TakeProducer(var AProducerID: Integer;
  var AProducerName: String): Boolean;
var
  AfrmProducers: TfrmProducers;
  ALastProducer: string;
  AProducersGroup: TProducersGroup2;
begin
  Result := False;
  // Сначала выберем производителя из справочника
  AProducersGroup := TProducersGroup2.Create(nil);
  try
    AProducersGroup.ReOpen;
    AfrmProducers := TfrmProducers.Create(nil);
    try
      AfrmProducers.Caption := 'Выберите производителя';
      AfrmProducers.btnOk.ModalResult := mrOk;

      AfrmProducers.ViewProducers.ProducersGroup := AProducersGroup;

      // Ищем ранее использованного производтеля
      ALastProducer := TSettings.Create.Producer;
      if not ALastProducer.IsEmpty then
        AfrmProducers.ViewProducers.Locate(ALastProducer);

      if AfrmProducers.ShowModal <> mrOk then
        Exit;
    finally
      FreeAndNil(AfrmProducers);
    end;

    if AProducersGroup.qProducers.FDQuery.RecordCount = 0 then
    begin
      TDialog.Create.ErrorMessageDialog('Справочник производителя пустой. ' +
        'Необходимо добавить производителя загружаемых компонентов.');
      Exit;
    end;

    AProducerID := AProducersGroup.qProducers.PK.AsInteger;
    AProducerName := AProducersGroup.qProducers.Name.AsString;

    // Сохраняем в настройках выбранного производителя
    TSettings.Create.Producer := AProducerName;

    Result := True;
  finally
    FreeAndNil(AProducersGroup);
  end;
end;

end.
