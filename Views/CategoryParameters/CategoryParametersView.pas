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
  cxGridDBBandedTableView, cxGrid, CategoryParametersQuery, ParameterPosQuery,
  DragHelper;

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
    actUp: TAction;
    actDown: TAction;
    dxBarButton4: TdxBarButton;
    dxBarButton5: TdxBarButton;
    cxStyleRepository: TcxStyleRepository;
    cxStyle1: TcxStyle;
    procedure actDownExecute(Sender: TObject);
    procedure actPosBeginExecute(Sender: TObject);
    procedure actPosCenterExecute(Sender: TObject);
    procedure actPosEndExecute(Sender: TObject);
    procedure actUpExecute(Sender: TObject);
    procedure cxGridDBBandedTableViewEditValueChanged
      (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem);
    procedure cxGridDBBandedTableViewStylesGetContentStyle(
      Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
      AItem: TcxCustomGridTableItem; var AStyle: TcxStyle);
  private
    FQueryCategoryParameters: TQueryCategoryParameters;
    FQueryParameterPos: TQueryParameterPos;
    procedure DoAfterLoad(Sender: TObject);
    function GetQueryParameterPos: TQueryParameterPos;
    procedure Move(AUp: Boolean);
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

uses cxDropDownEdit, NotifyEvents, System.Generics.Collections, System.Math;

procedure TViewCategoryParameters.actDownExecute(Sender: TObject);
begin
  inherited;
  Move(False);
end;

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

procedure TViewCategoryParameters.actUpExecute(Sender: TObject);
begin
  inherited;
  Move(True);
end;

procedure TViewCategoryParameters.cxGridDBBandedTableViewEditValueChanged
  (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem);
begin
  inherited;
  if AItem = clPosID then
    cxGridDBBandedTableView.DataController.Post();
end;

procedure TViewCategoryParameters.cxGridDBBandedTableViewStylesGetContentStyle(
  Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
  AItem: TcxCustomGridTableItem; var AStyle: TcxStyle);
var
  V: Variant;
begin
  inherited;
  if (ARecord = nil) or (AItem = nil) or (not ARecord.IsData ) then exit;
  // Получаем значение расположения
  V := ARecord.Values[clPosID.Index];
  if VarIsNull(V) then
    Exit;


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

procedure TViewCategoryParameters.Move(AUp: Boolean);
var
  AID: Integer;
  m: TList<Integer>;
  i: Integer;
  AOrder: Integer;
  L: TList<TRecOrder>;
begin
  inherited;
  MainView.BeginSortingUpdate;
  try
    m := TList<Integer>.Create;
    try
      for i := 0 to MainView.Controller.SelectedRowCount - 1 do
      begin
        m.Add(MainView.Controller.SelectedRows[i].Index);
      end;

      m.Sort;
      // Убеждаемся что индексы в списке непрерывны
      Assert(m.Last - m.First + 1 = m.Count);

      // Индекс строки c которой будем меняться позицией
      if AUp then
        i := m.First - 1
      else
      begin
        m.Reverse;
        i := m.First + 1;
      end;

      if (i < 0) or (i >= MainView.ViewData.RowCount) then
        Exit;

      AID := Value(MainView, clID, i);
      AOrder := Value(MainView, clOrder, i);

      // Если положение перемещаемых записей и нового места разные
      if Value(MainView, clPosID, i) <> Value(MainView, clPosID, m.First) then
        Exit;

      L := TList<TRecOrder>.Create;
      try
        // Меняем порядок записи на противоположный
        L.Add(TRecOrder.Create(AID, -AOrder));
        // Смещаем остальные записи
        for i in m do
        begin
          L.Add(TRecOrder.Create(Value(MainView, clID, i), AOrder));
          AOrder := Value(MainView, clOrder, i);
        end;
        L.Add(TRecOrder.Create(AID, AOrder));
        QueryCategoryParameters.Move(L);
      finally
        FreeAndNil(L);
      end;
    finally
      FreeAndNil(m);
    end;
  finally
    MainView.EndSortingUpdate;
  end;
end;

procedure TViewCategoryParameters.SetPos(APosID: Integer);
var
  i: Integer;
begin
  MainView.BeginSortingUpdate;
  try
    for i := 0 to MainView.Controller.SelectedRowCount - 1 do
    begin
      // Фокусируем, чтобы курсор в БД встал на неё
      MainView.Controller.SelectedRows[i].Focused := True;
      QueryCategoryParameters.SetPos(APosID);
    end;
  finally
    MainView.EndSortingUpdate;
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

      TNotifyEventWrap.Create(FQueryCategoryParameters.AfterLoad, DoAfterLoad,
        FEventList);
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
