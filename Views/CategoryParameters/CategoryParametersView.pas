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
    cxStyleBegin: TcxStyle;
    cxStyleEnd: TcxStyle;
    actApplyUpdates: TAction;
    dxBarButton6: TdxBarButton;
    actCancelUpdates: TAction;
    dxBarButton7: TdxBarButton;
    clParameterType: TcxGridDBBandedColumn;
    dxBarButton8: TdxBarButton;
    actDelete: TAction;
    actAddToBegin: TAction;
    dxBarButton10: TdxBarButton;
    actAddToCenter: TAction;
    actAddToEnd: TAction;
    dxBarSubItem1: TdxBarSubItem;
    dxBarButton9: TdxBarButton;
    dxBarButton11: TdxBarButton;
    dxBarButton12: TdxBarButton;
    procedure actAddToBeginExecute(Sender: TObject);
    procedure actAddToCenterExecute(Sender: TObject);
    procedure actAddToEndExecute(Sender: TObject);
    procedure actApplyUpdatesExecute(Sender: TObject);
    procedure actCancelUpdatesExecute(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure actDownExecute(Sender: TObject);
    procedure actPosBeginExecute(Sender: TObject);
    procedure actPosCenterExecute(Sender: TObject);
    procedure actPosEndExecute(Sender: TObject);
    procedure actUpExecute(Sender: TObject);
    procedure cxGridDBBandedTableViewEditValueChanged
      (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem);
    procedure cxGridDBBandedTableViewStylesGetContentStyle
      (Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
      AItem: TcxCustomGridTableItem; var AStyle: TcxStyle);
    procedure dxBarButton10Click(Sender: TObject);
    procedure dxBarSubItem1Click(Sender: TObject);
  private
    FQueryCategoryParameters: TQueryCategoryParameters;
    FQueryParameterPos: TQueryParameterPos;
    procedure Add(APosID: Integer);
    procedure DoAfterLoad(Sender: TObject);
    function GetQueryParameterPos: TQueryParameterPos;
    procedure Move(AUp: Boolean);
    procedure SetPos(APosID: Integer);
    procedure SetQueryCategoryParameters(const Value: TQueryCategoryParameters);
    { Private declarations }
  protected
    property QueryParameterPos: TQueryParameterPos read GetQueryParameterPos;
  public
    function CheckAndSaveChanges: Integer;
    procedure UpdateView; override;
    property QueryCategoryParameters: TQueryCategoryParameters
      read FQueryCategoryParameters write SetQueryCategoryParameters;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses cxDropDownEdit, NotifyEvents, System.Generics.Collections, System.Math,
  DialogUnit, ProjectConst, ParametersForm, ParametersGroupUnit, DBRecordHolder,
  MaxCategoryParameterOrderQuery;

procedure TViewCategoryParameters.actAddToBeginExecute(Sender: TObject);
begin
  Add(0);
end;

procedure TViewCategoryParameters.actAddToCenterExecute(Sender: TObject);
begin
  inherited;
  Add(1);
end;

procedure TViewCategoryParameters.actAddToEndExecute(Sender: TObject);
begin
  inherited;
  Add(2);
end;

procedure TViewCategoryParameters.actApplyUpdatesExecute(Sender: TObject);
begin
  inherited;
  QueryCategoryParameters.ApplyUpdates;
  UpdateView;
end;

procedure TViewCategoryParameters.actCancelUpdatesExecute(Sender: TObject);
begin
  inherited;
  QueryCategoryParameters.CancelUpdates;
  UpdateView;
end;

procedure TViewCategoryParameters.actDeleteExecute(Sender: TObject);
var
  AView: TcxGridDBBandedTableView;
begin
  inherited;
  if not TDialog.Create.DeleteRecordsDialog(sDoYouWantToDeleteCategoryParameter)
  then
    Exit;

  AView := FocusedTableView;
  if AView = nil then
    Exit;

  BeginUpdate;
  try
    AView.Controller.DeleteSelection;
  finally
    EndUpdate
  end;

  UpdateView;
end;

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

procedure TViewCategoryParameters.Add(APosID: Integer);
var
  AfrmParameters: TfrmParameters;
  AParametersGroup: TParametersGroup;
  m: TArray<String>;
  CheckedList: string;
  OK: Boolean;
  RH: TRecordHolder;
  S: string;
  SS: string;
begin
  inherited;

  BeginUpdate;
  try

    AParametersGroup := TParametersGroup.Create(Self);
    try
      // Настраиваем на отображение галочек из нашей категории
      AParametersGroup.qMainParameters.ProductCategoryIDValue :=
        QueryCategoryParameters.ParentValue;

      AParametersGroup.ReOpen;

      AfrmParameters := TfrmParameters.Create(Self);
      try
        AfrmParameters.ViewParameters.ParametersGroup := AParametersGroup;
        AfrmParameters.ViewParameters.CheckedMode := True;
        AfrmParameters.ShowModal;
      finally
        FreeAndNil(AfrmParameters);
      end;

      // Список выбранных параметров
      CheckedList := ',' + AParametersGroup.qMainParameters.GetCheckedPKValues.
        Trim([',']) + ',';
      // Список параметров для категории
      SS := ',' + QueryCategoryParameters.GetFieldValues
        (QueryCategoryParameters.ParameterID.FieldName).Trim([',']) + ',';

      m := SS.Trim([',']).Split([',']);
      // Цикл по параметрам для категории
      for S in m do
      begin
        // Если галочку с одного из параметров категории сняли
        if CheckedList.IndexOf(',' + S + ',') < 0 then
        begin
          if QueryCategoryParameters.LocateByPK(S) then
          begin
            QueryCategoryParameters.FDQuery.Delete;
          end;
        end;
      end;

      m := CheckedList.Trim([',']).Split([',']);
      // Цикл по параметрам для категории
      for S in m do
      begin
        // Если галочку поставили
        if SS.IndexOf(',' + S + ',') < 0 then
        begin
          if AParametersGroup.qMainParameters.LocateByPK(S) then
          begin
            // Ищем такой тип параметра
            OK := AParametersGroup.qParameterTypes.LocateByPK
              (AParametersGroup.qMainParameters.IDParameterType.AsInteger);
            Assert(OK);
            RH := TRecordHolder.Create
              (AParametersGroup.qMainParameters.FDQuery);
            try
              // Первичный ключ - это идентификатор параметра
              RH.Find(AParametersGroup.qMainParameters.PKFieldName).FieldName :=
                QueryCategoryParameters.ParameterID.FieldName;

              // Порядок - надо вычислить как максимум
              RH.Find(AParametersGroup.qMainParameters.Order.FieldName).Value :=
                QueryCategoryParameters.NextOrder;

              // Добавляем поле "Тип параметра"
              TFieldHolder.Create(RH,
                AParametersGroup.qParameterTypes.ParameterType.FieldName,
                AParametersGroup.qParameterTypes.ParameterType.AsString);

              QueryCategoryParameters.AppendParameter(RH, APosID);
            finally
              FreeAndNil(RH);
            end;
          end;
        end;
      end;

    finally
      FreeAndNil(AParametersGroup);
    end;
  finally
    EndUpdate;
  end;
  // PostMyApplyBestFitEvent;
  ApplyBestFitEx;
  UpdateView;
end;

function TViewCategoryParameters.CheckAndSaveChanges: Integer;
begin
  Result := 0;
  if QueryCategoryParameters = nil then
    Exit;

  // Если есть несохранённые изменения
  if QueryCategoryParameters.HaveAnyChanges then
  begin
    Result := TDialog.Create.SaveDataDialog;
    case Result of
      IDYes:
        actApplyUpdates.Execute;
      IDNO:
        actCancelUpdates.Execute;
    end;
  end;
end;

procedure TViewCategoryParameters.cxGridDBBandedTableViewEditValueChanged
  (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem);
begin
  inherited;
  if AItem = clPosID then
    cxGridDBBandedTableView.DataController.Post();
end;

procedure TViewCategoryParameters.cxGridDBBandedTableViewStylesGetContentStyle
  (Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
  AItem: TcxCustomGridTableItem; var AStyle: TcxStyle);
var
  APosID: Integer;
  V: Variant;
begin
  inherited;
  if (ARecord = nil) or (AItem = nil) or (not ARecord.IsData) then
    Exit;
  // Получаем значение расположения
  V := ARecord.Values[clPosID.Index];
  if VarIsNull(V) then
    Exit;
  {
    S := AItem.ClassName;

    if not(AItem is TcxGridDBBandedColumn) then
    beep;
  }
  APosID := V;
  case APosID of
    0:
      AStyle := cxStyleBegin;
    2:
      AStyle := cxStyleEnd;
  end;
end;

procedure TViewCategoryParameters.DoAfterLoad(Sender: TObject);
begin
  UpdateView;
end;

procedure TViewCategoryParameters.dxBarButton10Click(Sender: TObject);
begin
  inherited;
  ApplyBestFitEx;
end;

procedure TViewCategoryParameters.dxBarSubItem1Click(Sender: TObject);
begin
  inherited;
  ;
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

      // Если положение первой и последней перемещаемой записи разное
      if Value(MainView, clPosID, m.First) <> Value(MainView, clPosID, m.Last)
      then
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
    UpdateView;
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
  UpdateView;
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

      InitializeLookupColumn(clPosID, QueryParameterPos.DataSource, lsFixedList,
        QueryParameterPos.Pos.FieldName);

      TNotifyEventWrap.Create(FQueryCategoryParameters.AfterLoad, DoAfterLoad,
        FEventList);
      ApplyBestFitEx;
      UpdateView;
    end;
  end;
end;

procedure TViewCategoryParameters.UpdateView;
var
  OK: Boolean;
begin
  OK := (FQueryCategoryParameters <> nil) and
    (QueryCategoryParameters.FDQuery.Active);

  actPosBegin.Enabled := OK and (MainView.Controller.SelectedRowCount > 0) and
    (QueryCategoryParameters.FDQuery.RecordCount > 0);
  actPosCenter.Enabled := actPosBegin.Enabled;
  actPosEnd.Enabled := actPosBegin.Enabled;

  actApplyUpdates.Enabled := OK and QueryCategoryParameters.HaveAnyChanges;
  actCancelUpdates.Enabled := actApplyUpdates.Enabled;

  actDelete.Enabled := OK and (MainView.Controller.SelectedRowCount > 0);
end;

end.
