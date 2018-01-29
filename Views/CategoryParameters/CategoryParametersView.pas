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
  DragHelper, cxCheckBox, CategoryParametersQuery2;

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
    actAddToBegin: TAction;
    actAddToCenter: TAction;
    actAddToEnd: TAction;
    dxBarSubItem1: TdxBarSubItem;
    dxBarButton9: TdxBarButton;
    dxBarButton11: TdxBarButton;
    dxBarButton12: TdxBarButton;
    clIsAttribute: TcxGridDBBandedColumn;
    procedure actAddToBeginExecute(Sender: TObject);
    procedure actAddToCenterExecute(Sender: TObject);
    procedure actAddToEndExecute(Sender: TObject);
    procedure actApplyUpdatesExecute(Sender: TObject);
    procedure actCancelUpdatesExecute(Sender: TObject);
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
  private
    FQueryCategoryParameters: TQueryCategoryParameters2;
    FQueryParameterPos: TQueryParameterPos;
    procedure Add(APosID: Integer);
    procedure DoAfterLoad(Sender: TObject);
    function GetQueryParameterPos: TQueryParameterPos;
    procedure Move(AUp: Boolean);
    procedure SetPos(APosID: Integer);
    procedure SetQueryCategoryParameters(const Value
      : TQueryCategoryParameters2);
    { Private declarations }
  protected
    property QueryParameterPos: TQueryParameterPos read GetQueryParameterPos;
  public
    constructor Create(AOwner: TComponent); override;
    function CheckAndSaveChanges: Integer;
    procedure UpdateView; override;
    property QueryCategoryParameters: TQueryCategoryParameters2
      read FQueryCategoryParameters write SetQueryCategoryParameters;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses cxDropDownEdit, NotifyEvents, System.Generics.Collections, System.Math,
  DialogUnit, ProjectConst, ParametersForm, ParametersGroupUnit, DBRecordHolder,
  MaxCategoryParameterOrderQuery;

constructor TViewCategoryParameters.Create(AOwner: TComponent);
begin
  inherited;
  DeleteMessages.Add(cxGridLevel, sDoYouWantToDeleteCategoryParameter);
end;

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

procedure TViewCategoryParameters.actDownExecute(Sender: TObject);
begin
  inherited;
  Move(False);
end;

procedure TViewCategoryParameters.actPosBeginExecute(Sender: TObject);
begin
  inherited;
  // ���������� ��������� "� ������"
  SetPos(0);
end;

procedure TViewCategoryParameters.actPosCenterExecute(Sender: TObject);
begin
  inherited;
  // ���������� ��������� "� ��������"
  SetPos(1);
end;

procedure TViewCategoryParameters.actPosEndExecute(Sender: TObject);
begin
  inherited;
  // ���������� ��������� "� �����"
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
      // ����������� �� ����������� ������� �� ����� ���������
      AParametersGroup.qMainParameters.ProductCategoryIDValue :=
        QueryCategoryParameters.ParentValue;

      AParametersGroup.ReOpen;

      AfrmParameters := TfrmParameters.Create(Self);
      try
        AfrmParameters.ViewParameters.ParametersGroup := AParametersGroup;
        AfrmParameters.ViewSubParameters.QuerySubParameters :=
          AParametersGroup.qSubParameters2;
        AfrmParameters.ViewParameters.CheckedMode := True;
        AfrmParameters.ShowModal;
      finally
        FreeAndNil(AfrmParameters);
      end;

      // ������ ��������� ����������
      CheckedList := ',' + AParametersGroup.qMainParameters.
        GetCheckedIDParamSubParamValues.Trim([',']) + ',';
      // ������ ������������� ��� ���������
      SS := ',' + QueryCategoryParameters.GetFieldValues
        (QueryCategoryParameters.ParamSubParamId.FieldName).Trim([',']) + ',';

      m := SS.Trim([',']).Split([',']);
      // ���� �� ���������� ��� ���������
      for S in m do
      begin
        // ���� ������� � ������ �� ���������� ��������� �����
        if CheckedList.IndexOf(',' + S + ',') < 0 then
        begin
          // ���� ����� ����������� � ������ ������������� ���������
          if QueryCategoryParameters.LocateByField
            (QueryCategoryParameters.ParamSubParamId.FieldName, S) then
          begin
            QueryCategoryParameters.FDQuery.Delete;
          end;
        end;
      end;

      m := CheckedList.Trim([',']).Split([',']);
      // ���� �� ���������� � ����������� �������������
      for S in m do
      begin
        // ���� ������� ���������
        if SS.IndexOf(',' + S + ',') < 0 then
        begin
          // ���� ����������� � ����������� ����������
          if AParametersGroup.qMainParameters.LocateByField
            (AParametersGroup.qMainParameters.IDParamSubParam.FieldName, S) then
          begin
            // ���� ����� ��� ���������
            OK := AParametersGroup.qParameterTypes.LocateByPK
              (AParametersGroup.qMainParameters.IDParameterType.AsInteger);
            Assert(OK);

            RH := TRecordHolder.Create
              (AParametersGroup.qMainParameters.FDQuery);
            try
              // ��������� ���� - ��� ������������� ������������ ���������
              RH.Find(AParametersGroup.qMainParameters.PKFieldName).FieldName :=
                QueryCategoryParameters.ParamSubParamId.FieldName;

              // ������� - ���� ��������� ��� ��������
              TFieldHolder.Create(RH,
                QueryCategoryParameters.Ord.FieldName,
                QueryCategoryParameters.NextOrder);

              // ��������� ���� "��� ���������"
              TFieldHolder.Create(RH,
                QueryCategoryParameters.ParameterType.FieldName,
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

  MyApplyBestFit;
  UpdateView;
end;

function TViewCategoryParameters.CheckAndSaveChanges: Integer;
begin
  Result := 0;
  if QueryCategoryParameters = nil then
    Exit;

  // ���� ���� ������������ ���������
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
  // �������� �������� ������������
  V := ARecord.Values[clPosID.Index];
  if VarIsNull(V) then
    Exit;

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
      if MainView.Controller.SelectedRowCount > 0 then
      begin
        for i := 0 to MainView.Controller.SelectedRowCount - 1 do
        begin
          m.Add(MainView.Controller.SelectedRows[i].Index);
        end;
      end
      else
        m.Add(MainView.Controller.FocusedRow.Index);

      m.Sort;
      // ���������� ��� ������� � ������ ����������
      Assert(m.Last - m.First + 1 = m.Count);

      // ������ ������ c ������� ����� �������� ��������
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

      // ���� ��������� ������������ ������� � ������ ����� ������
      if Value(MainView, clPosID, i) <> Value(MainView, clPosID, m.First) then
        Exit;

      // ���� ��������� ������ � ��������� ������������ ������ ������
      if Value(MainView, clPosID, m.First) <> Value(MainView, clPosID, m.Last)
      then
        Exit;

      L := TList<TRecOrder>.Create;
      try
        // ������ ������� ������ �� ���������������
        L.Add(TRecOrder.Create(AID, -AOrder));
        // ������� ��������� ������
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
      // ����������, ����� ������ � �� ����� �� ��
      MainView.Controller.SelectedRows[i].Focused := True;
      QueryCategoryParameters.SetPos(APosID);
    end;
  finally
    MainView.EndSortingUpdate;
  end;
  UpdateView;
end;

procedure TViewCategoryParameters.SetQueryCategoryParameters
  (const Value: TQueryCategoryParameters2);
begin
  if FQueryCategoryParameters <> Value then
  begin
    FQueryCategoryParameters := Value;

    // ������������ �� ������ �����������
    FEventList.Clear;

    if FQueryCategoryParameters <> nil then
    begin
      MainView.DataController.DataSource := FQueryCategoryParameters.DataSource;

      InitializeLookupColumn(clPosID, QueryParameterPos.DataSource, lsFixedList,
        QueryParameterPos.Pos.FieldName);

      // (clIsAttribute.Properties as TcxCheckBoxProperties).ImmediatePost := True;

      TNotifyEventWrap.Create(FQueryCategoryParameters.AfterLoad, DoAfterLoad,
        FEventList);
      MyApplyBestFit;
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

  // ������� ��������� ������ ���� ���-�� ��������
  actDeleteEx.Enabled := OK and (MainView.Controller.SelectedRowCount > 0);

  actAddToBegin.Enabled := OK and not FQueryCategoryParameters.HaveAnyChanges;
  actAddToCenter.Enabled := actAddToBegin.Enabled;
  actAddToEnd.Enabled := actAddToBegin.Enabled;

  actUp.Enabled := OK and not FQueryCategoryParameters.HaveInserted;
  actDown.Enabled := actUp.Enabled;
end;

end.
