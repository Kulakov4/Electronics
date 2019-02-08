unit SubParametersForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DictonaryForm, cxGraphics,
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
  dxSkinXmas2008Blue, System.Actions, Vcl.ActnList, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls, GridFrame, SubParametersView;

type
  TfrmSubParameters = class(TfrmDictonary)
    ViewSubParameters: TViewSubParameters;
  private
    { Private declarations }
  protected
    procedure ApplyUpdates; override;
    procedure CancelUpdates; override;
    procedure ClearFormVariable; override;
    function HaveAnyChanges: Boolean; override;
  public
    class function GetCheckedID(AIDParameter, AProductCategoryID: Integer; out
        ACheckedID: String): Boolean; static;
    { Public declarations }
  end;


implementation

uses
  SubParametersQuery2;

{$R *.dfm}

procedure TfrmSubParameters.ApplyUpdates;
begin
  ViewSubParameters.CommitOrPost;
end;

procedure TfrmSubParameters.CancelUpdates;
begin
  ViewSubParameters.UpdateView;
  ViewSubParameters.actRollback.Execute;
end;

procedure TfrmSubParameters.ClearFormVariable;
begin
end;

class function TfrmSubParameters.GetCheckedID(AIDParameter, AProductCategoryID:
    Integer; out ACheckedID: String): Boolean;
var
  AfrmSubParameters: TfrmSubParameters;
  qSubParameters: TQuerySubParameters2;
begin
  qSubParameters := TQuerySubParameters2.Create(nil);
  AfrmSubParameters := TfrmSubParameters.Create(nil);
  try
    AfrmSubParameters.ViewSubParameters.CheckedMode := True;
    // Добавляем в SQL запрос поле с галочкой
    qSubParameters.OpenWithChecked(AIDParameter, AProductCategoryID);

    AfrmSubParameters.ViewSubParameters.QuerySubParameters := qSubParameters;
    Result := AfrmSubParameters.ShowModal = mrOK;
    if Result then
    begin
      // Получаем идентификаторы отмеченных галочками подпараметров
      ACheckedID := qSubParameters.GetCheckedValues(qSubParameters.W.PKFieldName);
    end;

    // Когда поставили галочку, в данных как-бы произошли изменения
    qSubParameters.CancelUpdates;
  finally
    FreeAndNil(AfrmSubParameters);
    FreeAndNil(qSubParameters);
  end;
end;

function TfrmSubParameters.HaveAnyChanges: Boolean;
begin
  Result := ViewSubParameters.QuerySubParameters.FDQuery.Connection.InTransaction;
end;

end.
