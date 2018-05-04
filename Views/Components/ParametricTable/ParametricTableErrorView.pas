unit ParametricTableErrorView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, GridViewEx, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinBlack,
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
  dxSkinXmas2008Blue, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, cxNavigator, Data.DB, cxDBData, dxSkinsdxBarPainter,
  Vcl.ExtCtrls, System.ImageList, Vcl.ImgList, cxGridCustomPopupMenu,
  cxGridPopupMenu, Vcl.Menus, System.Actions, Vcl.ActnList, dxBar, cxClasses,
  Vcl.ComCtrls, cxGridLevel, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridBandedTableView, cxGridDBBandedTableView, cxGrid,
  cxButtonEdit, ParametersForm, ParametricErrorTable, DialogUnit,
  ParametersGroupUnit, System.UITypes;

type
  TViewParametricTableError = class(TViewGridEx)
    clButton: TcxGridDBBandedColumn;
    actFix: TAction;
    procedure actFixExecute(Sender: TObject);
  private
    function GetParametricErrorTable: TParametricErrorTable;
    { Private declarations }
  public
    property ParametricErrorTable: TParametricErrorTable
      read GetParametricErrorTable;
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TViewParametricTableError.actFixExecute(Sender: TObject);
var
  AfrmParameters: TfrmParameters;
  OK: Boolean;
  AParametersGroup: TParametersGroup;
begin
  Assert(ParametricErrorTable <> nil);

  AParametersGroup := TParametersGroup.Create(Self);
  AParametersGroup.ReOpen;

  AfrmParameters := TfrmParameters.Create(Self);
  try
    AfrmParameters.CloseAction := caHide;
    AfrmParameters.ViewParameters.ParametersGrp := AParametersGroup;
    AfrmParameters.ViewSubParameters.QuerySubParameters :=
      AParametersGroup.qSubParameters;
    // Если ошибка связана с тем, что параметр дублируется в параметрической таблице
    if ParametricErrorTable.ErrorType.AsInteger = Integer(petParamDuplicate)
    then
    begin
      AfrmParameters.ViewParameters.Search
        (ParametricErrorTable.ParameterName.AsString);
      AfrmParameters.ViewParameters.actFilterByTableName.Execute;
    end;

    // Ошибки "Подпараметр не найден, Подпараметр дублируется в справочнике подпараметров"
    if ParametricErrorTable.ErrorType.AsInteger
      in [Integer(petSubParamNotFound), Integer(petSubParamDuplicate)] then
      // Переключаемся на вкладку "Подпараметры"
      AfrmParameters.cxPageControl.ActivePage :=
        AfrmParameters.cxtsSubParameters;

    if AfrmParameters.ShowModal <> mrOK then
      Exit;

    OK := (AParametersGroup.qParameters.FDQuery.RecordCount <> 0) and
      (AParametersGroup.qParameters.TableName.AsString = ParametricErrorTable.
      ParameterName.AsString);

    if OK then
    begin
      // Фиксим ошибку
      ParametricErrorTable.Fix(AParametersGroup.qParameters.PK.AsInteger);
    end
    else
    begin
      TDialog.Create.ErrorMessageDialog
        ('Табличное имя выбранного параметра не совпадает с заголовков в Excel файле');
    end
  finally
    FreeAndNil(AfrmParameters);
    FreeAndNil(AParametersGroup);
  end;
end;

function TViewParametricTableError.GetParametricErrorTable
  : TParametricErrorTable;
begin
  if DataSet = nil then
    Result := nil
  else
    Result := DataSet as TParametricErrorTable;
end;

end.
