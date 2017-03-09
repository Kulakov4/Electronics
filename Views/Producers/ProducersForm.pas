unit ProducersForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
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
    ViewProducers: TViewProducers;
  private
    { Private declarations }
  protected
    procedure ApplyUpdates; override;
    procedure CancelUpdates; override;
    procedure ClearFormVariable; override;
    function HaveAnyChanges: Boolean; override;
  public
    class function TakeProducer: String; static;
    { Public declarations }
  end;

var
  frmProducers: TfrmProducers;

implementation

{$R *.dfm}

uses ProducersQuery, DialogUnit;

procedure TfrmProducers.ApplyUpdates;
begin
  ViewProducers.actCommit.Execute;
end;

procedure TfrmProducers.CancelUpdates;
begin
  ViewProducers.actRollback.Execute;
end;

procedure TfrmProducers.ClearFormVariable;
begin
  frmProducers := nil;
end;

function TfrmProducers.HaveAnyChanges: Boolean;
begin
  Result := ViewProducers.QueryProducers.FDQuery.Connection.InTransaction;
end;

class function TfrmProducers.TakeProducer: String;
var
  AfrmProducers: TfrmProducers;
  AQueryProducers: TQueryProducers;
begin
  Result := '';
  // ������� ������� ������������� �� �����������
  AQueryProducers := TQueryProducers.Create(nil);
  try
    AQueryProducers.RefreshQuery;
    AfrmProducers := TfrmProducers.Create(nil);
    try
      AfrmProducers.Caption := '�������� �������������';
      AfrmProducers.btnOk.ModalResult := mrOk;

      AfrmProducers.ViewProducers.QueryProducers :=
        AQueryProducers;
      if AfrmProducers.ShowModal <> mrOk then
        Exit;
    finally
      FreeAndNil(AfrmProducers);
    end;

    if AQueryProducers.FDQuery.RecordCount = 0 then
    begin
      TDialog.Create.ErrorMessageDialog('���������� ������������� ������. ' +
        '���������� �������� ������������� ����������� �����������.');
      Exit;
    end;

    Result := AQueryProducers.Name.AsString;
  finally
    FreeAndNil(AQueryProducers);
  end;
end;

end.
