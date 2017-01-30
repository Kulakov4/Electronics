unit ParametersForCategoriesView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, GridFrame, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB, cxDBData,
  cxGridCustomPopupMenu, cxGridPopupMenu, Vcl.Menus, System.Actions,
  Vcl.ActnList, dxBar, cxClasses, Vcl.ComCtrls, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridBandedTableView,
  cxGridDBBandedTableView, cxGrid, ParametersForCategoriesMasterDetailUnit,
  cxLabel, cxCheckBox, dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
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
  dxSkinXmas2008Blue, dxSkinscxPCPainter, dxSkinsdxBarPainter;

type
  TViewParametersForCategories = class(TfrmGrid)
    cxGridLevel2: TcxGridLevel;
    cxGridDBBandedTableView2: TcxGridDBBandedTableView;
    clParameterType: TcxGridDBBandedColumn;
    clCheckBox: TcxGridDBBandedColumn;
    clID: TcxGridDBBandedColumn;
    clIsAttribute: TcxGridDBBandedColumn;
    clValue: TcxGridDBBandedColumn;
    clTableName: TcxGridDBBandedColumn;
    clValueT: TcxGridDBBandedColumn;
    clIDParameterType: TcxGridDBBandedColumn;
    clOrder: TcxGridDBBandedColumn;
    clID1: TcxGridDBBandedColumn;
    procedure cxGridDBBandedTableViewDataControllerDetailExpanded(
      ADataController: TcxCustomDataController; ARecordIndex: Integer);
    procedure cxGridDBBandedTableView2DataControllerDataModeControllerDetailFirst(
      Sender: TcxDBDataModeController; ADataSet: TDataSet;
      const AMasterDetailKeyFieldNames: string;
      const AMasterDetailKeyValues: Variant; var AReopened: Boolean);
    function cxGridDBBandedTableView2DataControllerDataModeControllerDetailIsCurrentQuery(
      Sender: TcxDBDataModeController; ADataSet: TDataSet;
      const AMasterDetailKeyFieldNames: string;
      const AMasterDetailKeyValues: Variant): Boolean;
    procedure clCheckBoxPropertiesChange(Sender: TObject);
  private
    FParametersForCategoriesMasterDetail: TParametersForCategoriesMasterDetail;
    procedure SetParametersForCategoriesMasterDetail(const Value:
        TParametersForCategoriesMasterDetail);
    { Private declarations }
  public
    property ParametersForCategoriesMasterDetail:
        TParametersForCategoriesMasterDetail read
        FParametersForCategoriesMasterDetail write
        SetParametersForCategoriesMasterDetail;
    { Public declarations }
  end;

var
  ViewParametersForCategories: TViewParametersForCategories;

implementation

{$R *.dfm}

uses NotifyEvents;

procedure TViewParametersForCategories.clCheckBoxPropertiesChange(
  Sender: TObject);
begin
  cxGridDBBandedTableView.BeginUpdate();
  try
    (Sender as TcxCheckBox).PostEditValue;
    ParametersForCategoriesMasterDetail.qParametersDetail.TryPost;
  finally
    cxGridDBBandedTableView.EndUpdate;
  end;
end;

procedure TViewParametersForCategories.cxGridDBBandedTableView2DataControllerDataModeControllerDetailFirst(
  Sender: TcxDBDataModeController; ADataSet: TDataSet;
  const AMasterDetailKeyFieldNames: string;
  const AMasterDetailKeyValues: Variant; var AReopened: Boolean);
var
  x: Integer;
begin
  inherited;
  if VarIsNull(AMasterDetailKeyValues) then
    Exit;

  x := AMasterDetailKeyValues;

  if ParametersForCategoriesMasterDetail.qParametersDetail.FDQuery.ParamByName('IDParameterType').AsInteger = x then
  begin
    ParametersForCategoriesMasterDetail.qParametersDetail.FDQuery.First;
    AReopened := False;
  end
  else
  begin
    ParametersForCategoriesMasterDetail.RefreshDetail(x);
    AReopened := True
  end;

end;

function TViewParametersForCategories.cxGridDBBandedTableView2DataControllerDataModeControllerDetailIsCurrentQuery(
  Sender: TcxDBDataModeController; ADataSet: TDataSet;
  const AMasterDetailKeyFieldNames: string;
  const AMasterDetailKeyValues: Variant): Boolean;
begin
  inherited;
  Result := ParametersForCategoriesMasterDetail.qParametersDetail.FDQuery.
    ParamByName('IDParameterType').AsInteger = AMasterDetailKeyValues;
end;

procedure TViewParametersForCategories.cxGridDBBandedTableViewDataControllerDetailExpanded(
  ADataController: TcxCustomDataController; ARecordIndex: Integer);
var
  I: Integer;
begin
  cxGridDBBandedTableView.BeginUpdate();
  try
    // ����������� ��� ������ ����� �����������
    for I := 0 to cxGridDBBandedTableView.ViewData.RowCount - 1 do
    begin
      if cxGridDBBandedTableView.ViewData.Rows[I].RecordIndex <> ARecordIndex then
      begin
        cxGridDBBandedTableView.ViewData.Rows[I].Collapse(True);
      end;
    end;
  finally
    cxGridDBBandedTableView.EndUpdate;
  end;

  // ���������� ��������� ����
  cxGridDBBandedTableView.DataController.FocusedRecordIndex := ARecordIndex;

  // ��������� ��������� ���� �� ������� ������ � �����
  cxGridDBBandedTableView.Controller.TopRecordIndex := ARecordIndex;

  // ���������� �������� �������������
  GetDBBandedTableView(1).Focused := True;
end;

procedure TViewParametersForCategories.SetParametersForCategoriesMasterDetail(const Value:
    TParametersForCategoriesMasterDetail);
begin
  if FParametersForCategoriesMasterDetail <> Value then
  begin
    FParametersForCategoriesMasterDetail := Value;

    FEventList.Clear; // ������������ �� ������ �������

    if FParametersForCategoriesMasterDetail <> nil then
    begin
      // ������������� �� �������
//      TNotifyEventWrap.Create
//        (FParametersForCategoriesMasterDetail.qParametersDetail.AfterLoad,
//        AfterLoadData, FEventList);

      // ������������ �������� �������
//      AfterLoadData(FParametersForCategoriesMasterDetail.qParametersDetail.
//        AfterLoad);

      cxGridDBBandedTableView.DataController.DataSource :=
        FParametersForCategoriesMasterDetail.qParameterTypes.DataSource;

      cxGridDBBandedTableView2.DataController.DataSource :=
        FParametersForCategoriesMasterDetail.qParametersDetail.DataSource;
    end;
  end;
end;

end.
