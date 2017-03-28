unit CategoryParametersView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, GridFrame, cxGraphics, cxControls,
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
  cxGridCustomPopupMenu, cxGridPopupMenu, Vcl.Menus, System.Actions,
  Vcl.ActnList, dxBar, cxClasses, Vcl.ComCtrls, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridBandedTableView,
  cxGridDBBandedTableView, cxGrid, CategoryParametersQuery, ParameterPosQuery;

type
  TViewCategoryParameters = class(TfrmGrid)
    clValue: TcxGridDBBandedColumn;
    clTableName: TcxGridDBBandedColumn;
    clID: TcxGridDBBandedColumn;
    clPosID: TcxGridDBBandedColumn;
    clOrder: TcxGridDBBandedColumn;
    clValueT: TcxGridDBBandedColumn;
    actPosBegin: TAction;
    actPosEnd: TAction;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    actPosCenter: TAction;
    dxBarButton3: TdxBarButton;
    procedure actPosBeginExecute(Sender: TObject);
    procedure actPosCenterExecute(Sender: TObject);
    procedure actPosEndExecute(Sender: TObject);
    procedure cxGridDBBandedTableViewEditValueChanged
      (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem);
  private
    FQueryCategoryParameters: TQueryCategoryParameters;
    FQueryParameterPos: TQueryParameterPos;
    procedure DoAfterLoad(Sender: TObject);
    function GetQueryParameterPos: TQueryParameterPos;
    procedure SetPos(APosID: Integer);
    procedure SetQueryCategoryParameters(const Value: TQueryCategoryParameters);
    { Private declarations }
  protected
    property QueryParameterPos: TQueryParameterPos read GetQueryParameterPos;
  public
    procedure UpdateView; override;
    property QueryCategoryParameters: TQueryCategoryParameters
      read FQueryCategoryParameters write SetQueryCategoryParameters;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses cxDropDownEdit, NotifyEvents;

procedure TViewCategoryParameters.actPosBeginExecute(Sender: TObject);
begin
  inherited;
  // Установить положение "в начале"
  SetPos(0);
end;

procedure TViewCategoryParameters.actPosCenterExecute(Sender: TObject);
begin
  inherited;
  // Установить положение "в середине"
  SetPos(1);
end;

procedure TViewCategoryParameters.actPosEndExecute(Sender: TObject);
begin
  inherited;
  // Установить положение "в конце"
  SetPos(2);
end;

procedure TViewCategoryParameters.cxGridDBBandedTableViewEditValueChanged
  (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem);
begin
  inherited;
  if AItem = clPosID then
    cxGridDBBandedTableView.DataController.Post();
end;

procedure TViewCategoryParameters.DoAfterLoad(Sender: TObject);
begin
  UpdateView;
end;

function TViewCategoryParameters.GetQueryParameterPos: TQueryParameterPos;
begin
  if FQueryParameterPos = nil then
  begin
    FQueryParameterPos := TQueryParameterPos.Create(Self);
    FQueryParameterPos.RefreshQuery;
  end;
  Result := FQueryParameterPos;
end;

procedure TViewCategoryParameters.SetPos(APosID: Integer);
var
  i: Integer;
begin
  for i := 0 to MainView.Controller.SelectedRowCount - 1 do
  begin
    // Фокусируем, чтобы курсор в БД встал на неё
    MainView.Controller.SelectedRows[i].Focused := True;
    QueryCategoryParameters.SetPos(APosID);
  end;

end;

procedure TViewCategoryParameters.SetQueryCategoryParameters
  (const Value: TQueryCategoryParameters);
begin
  if FQueryCategoryParameters <> Value then
  begin
    FQueryCategoryParameters := Value;

    // Отписываемся от старых подписчиков
    FEventList.Clear;

    if FQueryCategoryParameters <> nil then
    begin
      MainView.DataController.DataSource := FQueryCategoryParameters.DataSource;

      InitializeLookupColumn(MainView, FQueryCategoryParameters.PosID.FieldName,
        QueryParameterPos.DataSource, lsFixedList,
        QueryParameterPos.Pos.FieldName);

      TNotifyEventWrap.Create(FQueryCategoryParameters.AfterLoad, DoAfterLoad, FEventList);
      UpdateView;
    end;
  end;
end;

procedure TViewCategoryParameters.UpdateView;
var
  OK: Boolean;
begin
  OK := (FQueryCategoryParameters <> nil) and
    (QueryCategoryParameters.FDQuery.Active) and
    (QueryCategoryParameters.FDQuery.RecordCount > 0);

  actPosBegin.Enabled := OK and (MainView.Controller.SelectedRowCount > 0);
  actPosCenter.Enabled := actPosBegin.Enabled;
  actPosEnd.Enabled := actPosBegin.Enabled;
end;

end.
