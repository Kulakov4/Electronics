unit AnalogGridView;

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
  System.ImageList, Vcl.ImgList, cxGridCustomPopupMenu, cxGridPopupMenu,
  Vcl.Menus, System.Actions, Vcl.ActnList, dxBar, cxClasses, Vcl.ComCtrls,
  cxGridLevel, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridBandedTableView, cxGridDBBandedTableView, cxGrid, AnalogQueryes,
  System.Generics.Collections, StrHelper, BandsInfo, cxMemo, Vcl.StdCtrls,
  cxButtons, Vcl.ExtCtrls, dxCalloutPopup, GridFrame, GridView, System.Math,
  cxCheckBox, cxLabel, ParameterKindEnum, PopupAnalogGridView,
  RepositoryDataModule, CategoryParametersQuery2,
  cxDataControllerConditionalFormattingRulesManagerDialog, dxBarBuiltInMenu,
  cxImageList;

const
  WM_AFTER_INIT_EDIT = WM_USER + 1;

type
  TViewAnalogGrid = class(TViewGridEx)
    cxEditorButton: TcxButton;
    EditorTimer: TTimer;
    actShowPopup: TAction;
    dxCalloutPopup1: TdxCalloutPopup;
    PopupPanel: TPanel;
    ViewGridPopupAnalog: TViewGridPopupAnalog;
    actClear: TAction;
    N2: TMenuItem;
    actFullAnalog: TAction;
    dxBarButton2: TdxBarButton;
    actNearAnalog: TAction;
    dxBarButton3: TdxBarButton;
    actSave: TAction;
    dxBarButton4: TdxBarButton;
    dxBarButton5: TdxBarButton;
    procedure actClearExecute(Sender: TObject);
    procedure actFullAnalogExecute(Sender: TObject);
    procedure actNearAnalogExecute(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure actShowPopupExecute(Sender: TObject);
    procedure cxGridDBBandedTableViewInitEdit(Sender: TcxCustomGridTableView;
      AItem: TcxCustomGridTableItem; AEdit: TcxCustomEdit);
    procedure cxGridDBBandedTableViewMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure dxCalloutPopup1Hide(Sender: TObject);
    procedure EditorTimerTimer(Sender: TObject);
  private
    FAnalogGroup: TAnalogGroup;
    FBandsInfo: TBandsInfo;
    FColumnsInfo: TColumnsInfo;
    FcxGridDBBandedColumn: TcxGridDBBandedColumn;
    FcxMemo: TcxMemo;
    FUseTableName: Boolean;
    procedure CreateColumn(AViewArray: TArray<TcxGridDBBandedTableView>;
      const AIDList: TArray<Integer>;
      qCategoryParameters: TQueryCategoryParameters2);
    procedure DeleteBands;
    procedure DeleteColumns;
    function GetqCategoryParameters: TQueryCategoryParameters2;
    procedure SetAnalogGroup(const Value: TAnalogGroup);
    procedure SetUseTableName(const Value: Boolean);
    property qCategoryParameters: TQueryCategoryParameters2
      read GetqCategoryParameters;
    { Private declarations }
  protected
    procedure AfterInitEdit(var Message: TMessage); message WM_AFTER_INIT_EDIT;
    procedure CreateColumnsForBand(AIDCategoryParam: Integer);
    procedure DoAfterInitMemo;
    function GetBandCaption(qryCategoryParameters : TQueryCategoryParameters2):
        string;
    function IsMemoEditorHide: Boolean;
    procedure InitColumns; override;
    procedure UpdateBandsCaptions;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure UpdateMinBandWindth(ABandInfo: TBandInfoEx);
    property AnalogGroup: TAnalogGroup read FAnalogGroup write SetAnalogGroup;
    property UseTableName: Boolean read FUseTableName write SetUseTableName;
    { Public declarations }
  end;

implementation

uses
  AutoSizeGridViewForm, System.Types, FireDAC.Comp.Client, TextRectHelper,
  System.StrUtils, CategoryParametersGroupUnit2;

{$R *.dfm}

constructor TViewAnalogGrid.Create(AOwner: TComponent);
begin
  inherited;
  FBandsInfo := TBandsInfo.Create;
  FColumnsInfo := TColumnsInfo.Create;

  FcxMemo := nil;
  FcxGridDBBandedColumn := nil;
  cxEditorButton.Parent := cxGrid;
  cxEditorButton.Visible := False;
  actShowPopup.Caption := #$2219#$2219#$2219;

  ApplyBestFitMultiLine := True;
end;

destructor TViewAnalogGrid.Destroy;
begin
  FreeAndNil(FBandsInfo);
  FreeAndNil(FColumnsInfo);
  inherited;
end;

procedure TViewAnalogGrid.actClearExecute(Sender: TObject);
var
  AColumn: TcxGridDBBandedColumn;
  AParamSubParamID: Integer;
  i: Integer;
begin
  inherited;
  if (MainView.Controller.FocusedRow = nil) or
    (MainView.Controller.FocusedColumn = nil) or
    (MainView.Controller.SelectedColumnCount = 0) then
    Exit;

  for i := 0 to MainView.Controller.SelectedColumnCount - 1 do
  begin
    AColumn := MainView.Controller.SelectedColumns[i] as TcxGridDBBandedColumn;
    AParamSubParamID := AnalogGroup.GetParamSubParamIDByFieldName
      (AColumn.DataBinding.FieldName);
    AnalogGroup.Clear(AParamSubParamID);
  end;
end;

procedure TViewAnalogGrid.actFullAnalogExecute(Sender: TObject);
begin
  inherited;
  AnalogGroup.CheckDefault;
  MyApplyBestFit;
end;

procedure TViewAnalogGrid.actNearAnalogExecute(Sender: TObject);
begin
  inherited;
  AnalogGroup.CheckNear;
  MyApplyBestFit;
end;

procedure TViewAnalogGrid.actSaveExecute(Sender: TObject);
begin
  inherited;
  AnalogGroup.SetAsDefaultValues;
end;

procedure TViewAnalogGrid.actShowPopupExecute(Sender: TObject);
var
  AColumn: TcxGridDBBandedColumn;
  AParamSubParamID: Integer;
  AParamValues: TParamValues;
  R: TRect;
begin
  inherited;
  Application.Hint := '';
  Assert(FcxGridDBBandedColumn <> nil);

  // Получаем идентификатор связки подпараметра с параметром, связанного с редактируемой колонкой
  AParamSubParamID := AnalogGroup.GetParamSubParamIDByFieldName
    (FcxGridDBBandedColumn.DataBinding.FieldName);

  AParamValues := AnalogGroup.ParamValuesList.FindByParamSubParamID
    (AParamSubParamID);
  Assert(AParamValues <> nil);

  ViewGridPopupAnalog.DataSet := AParamValues.Table;
  AColumn := ViewGridPopupAnalog.MainView.GetColumnByFieldName
    (AParamValues.Table.Checked.FieldName);
  Assert(AColumn <> nil);
  AColumn.PropertiesClass := TcxCheckBoxProperties;
  (AColumn.Properties as TcxCheckBoxProperties).ValueChecked := 1;
  (AColumn.Properties as TcxCheckBoxProperties).ValueUnchecked := 0;
  (AColumn.Properties as TcxCheckBoxProperties).ImmediatePost := True;

  AColumn := ViewGridPopupAnalog.MainView.GetColumnByFieldName
    (AParamValues.Table.Value.FieldName);
  Assert(AColumn <> nil);
  AColumn.PropertiesClass := TcxLabelProperties;

  PopupPanel.Width :=
    Max(ViewGridPopupAnalog.MainView.ViewInfo.HeaderViewInfo.Width + 20,
    FcxGridDBBandedColumn.GridView.ViewInfo.HeaderViewInfo.Items
    [FcxGridDBBandedColumn.VisibleIndex].Width);

  // dxCalloutPopup1.PopupControl := PopupPanel;
  UpdateDataTimer.Enabled := False;

  R := FcxMemo.BoundsRect;

  R.Left := 5 + R.Left;
  // R.Right := cxEditorButton.Left + R.Right;
  // R.Top := cxEditorButton.Top + R.Top;
  // R.Bottom := cxEditorButton.Top + R.Bottom;
  dxCalloutPopup1.Popup(cxEditorButton.Parent, R);

  {
    AfrmGridViewAutoSize := TfrmGridViewAutoSize.Create(Self);
    try
    AfrmGridViewAutoSize.Caption := AParamValues.Caption;
    AfrmGridViewAutoSize.ViewGridEx.DataSet := AParamValues.Table;
    AfrmGridViewAutoSize.Constraints.MinWidth :=
    ;


    R := FcxMemo.GetVisibleBounds;
    p := cxEditorButton.Parent.ClientToScreen( Point( FcxMemo.Left, FcxMemo.Top + R.BottomRight.Y ) );
    AfrmGridViewAutoSize.Left := p.X;
    AfrmGridViewAutoSize.Top := p.Y;
    AfrmGridViewAutoSize.ShowModal;

    finally
    FreeAndNil(AfrmGridViewAutoSize);
    end;
  }
end;

procedure TViewAnalogGrid.AfterInitEdit(var Message: TMessage);
begin
  inherited;
  DoAfterInitMemo;
end;

procedure TViewAnalogGrid.CreateColumn(AViewArray
  : TArray<TcxGridDBBandedTableView>; const AIDList: TArray<Integer>;
  qCategoryParameters: TQueryCategoryParameters2);
var
  ABand: TcxGridBand;
  ABandInfo: TBandInfo;
  ABandList: TList<TcxGridBand>;
  ACI: TColumnInfo;
  AColumn: TcxGridDBBandedColumn;
  AColumnList: TList<TcxGridDBBandedColumn>;
  AParamSubParamID: Integer;
  AView: TcxGridDBBandedTableView;
  NeedInitialize: Boolean;
  R: TRect;
begin
  // Поиск среди ранее созданных бэндов
  // Ищем среди заранее созданных бэндов
  ABandInfo := FBandsInfo.SearchByIDParamSubParam
    (qCategoryParameters.W.ParamSubParamId.F.AsInteger);
  // Ищем по идентификатору бэнда
  if ABandInfo = nil then
    ABandInfo := FBandsInfo.SearchByIDList(AIDList);

  AParamSubParamID := qCategoryParameters.W.ParamSubParamId.F.AsInteger;

  // Нужна ли инициализация бэнда
  NeedInitialize := (ABandInfo = nil) or
    (ABandInfo.DefaultCreated and not ABandInfo.Band.VisibleForCustomization);

  // Если не нашли подходящий бэнд
  if ABandInfo = nil then
  begin
    // Список бэндов, с которыми мы будем работать
    ABandList := TList<TcxGridBand>.Create;
    try
      // Для всех представлений создаём дополнительный бэнд
      for AView in AViewArray do
      begin
        ABand := AView.Bands.Add;
        ABandList.Add(ABand);
      end;

      // Добавляем эти бэнды в описание
      ABandInfo := TBandInfoEx.Create(ABandList.ToArray, AIDList);
    finally
      FreeAndNil(ABandList);
    end;
    FBandsInfo.Add(ABandInfo);
  end;
  Assert(ABandInfo <> nil);

  // Если инициализация нужна
  if NeedInitialize then
  begin
    ABandInfo.IDList.Assign(AIDList); // Идентификаторы колонок бэнда
    ABandInfo.IsDefault := qCategoryParameters.W.IsDefault.F.AsInteger = 1;
    // Параметр "по умолчанию" всегда в отдельно бэнде
    if qCategoryParameters.W.IsDefault.F.AsInteger = 1 then
      ABandInfo.IDParamSubParam := qCategoryParameters.W.ParamSubParamId.F.
        AsInteger;

    // Связан ли он с подпараметром по умолчанию
    ABandInfo.IDParameter := qCategoryParameters.W.IDParameter.F.AsInteger;
    // Параметр, с которым связан бэнд
    // Подпараметр по "умолчанию"
    ABandInfo.DefaultVisible := qCategoryParameters.W.IsAttribute.F.AsInteger = 1;
    ABandInfo.IDParameterKind := qCategoryParameters.W.IDParameterKind.F.AsInteger;
    ABandInfo.Pos := qCategoryParameters.W.PosID.F.AsInteger;

    // Инициализируем сами бэнды
    for ABand in (ABandInfo as TBandInfoEx).Bands do
    begin
      ABand.Visible := ABandInfo.DefaultVisible;
      ABand.Options.HoldOwnColumnsOnly := True;
      ABand.VisibleForCustomization := True;
      ABand.Caption := GetBandCaption(qCategoryParameters);
      ABand.AlternateCaption :=
        DeleteDouble(qCategoryParameters.W.ValueT.F.AsString, ' ');
      if ABandInfo.DefaultCreated then
        ABand.Position.ColIndex := 1000; // Помещаем бэнд в конец
    end;
  end;

  // Ищем, возможно такая колонка уже есть?
  ACI := FColumnsInfo.Search(qCategoryParameters.W.PK.AsInteger);
  if ACI <> nil then
  begin
    // Эта колонка должна принадлежать этому бэнду
    Assert(ACI.Column.Position.Band = ABandInfo.Band);
  end
  else
  begin
    // Список создаваемых колонок
    AColumnList := TList<TcxGridDBBandedColumn>.Create;
    try
      // Если такой колонки не создавали ещё
      // Если такой бэнд не существовал по "умолчанию"
      if not ABandInfo.DefaultCreated then
      begin
        // Инициализируем сами бэнды
        for ABand in (ABandInfo as TBandInfoEx).Bands do
        begin
          // Создаём колонку для этого бэнда
          AColumn := ABand.GridView.CreateColumn as TcxGridDBBandedColumn;
          AColumn.Position.BandIndex := ABand.Index;
          AColumn.MinWidth := 40;
          AColumn.Caption :=
            DeleteDouble(qCategoryParameters.W.Name.F.AsString, ' ');
          if AColumn.Caption.IsEmpty then
            AColumn.Caption := ' ';
          AColumn.HeaderAlignmentHorz := taCenter;
          AColumn.AlternateCaption :=
            DeleteDouble(qCategoryParameters.W.Translation.F.AsString, ' ');

          // Такое поле должно быть в датасете
          Assert(AnalogGroup.AllParameterFields.ContainsKey(AParamSubParamID));

          AColumn.DataBinding.FieldName := AnalogGroup.AllParameterFields
            [AParamSubParamID];

          R := TTextRect.Calc(AColumn.GridView.ViewInfo.Canvas.Canvas,
            AColumn.Caption, AColumn.MinWidth);
          AColumn.Width := R.Width + 10;

          // В режиме просмотра убираем ограничители
          // AColumn.OnGetDataText := DoOnGetDataText;

          // if ABand.GridView = MainView then
          // begin
          AColumn.PropertiesClass := TcxMemoProperties;
          (AColumn.Properties as TcxMemoProperties).WordWrap := False;
          // (AColumn.Properties as TcxMemoProperties).OnEditValueChanged :=
          // DoOnEditValueChanged;
          // AColumn.OnUserFilteringEx := DoOnUserFilteringEx;
          // AColumn.OnGetFilterValues := DoOnGetFilterValues;
          // end
          // else
          // begin
          //
          // AColumn.PropertiesClass := TcxTextEditProperties;
          // end;

          AColumnList.Add(AColumn);
        end;
      end
      else
      begin
        for ABand in (ABandInfo as TBandInfoEx).Bands do
        begin
          // У бэнда "по умолчанию" всегда одна колонка
          Assert(ABand.ColumnCount = 1);
          AColumnList.Add(ABand.Columns[0] as TcxGridDBBandedColumn);
        end;

      end;
      // Сохраняем информацию о созданных или уже существующих колонках
      FColumnsInfo.Add(TColumnInfoEx.Create(AColumnList.ToArray,
        qCategoryParameters.W.PK.AsInteger, qCategoryParameters.W.Ord.F.AsInteger,
        ABandInfo.DefaultCreated, qCategoryParameters.W.IsDefault.F.AsInteger = 1));
    finally
      FreeAndNil(AColumnList);
    end;
  end;
end;

procedure TViewAnalogGrid.CreateColumnsForBand(AIDCategoryParam: Integer);
var
  AClone: TFDMemTable;
  AIDList: TList<Integer>;
begin
  Assert(AIDCategoryParam > 0);

  qCategoryParameters.W.LocateByPK(AIDCategoryParam, True);

  AIDList := TList<Integer>.Create;
  // Получаем все подпараметры текущего бэнда
  AClone := qCategoryParameters.CreateSubParamsClone;
  try
    // Составляем список идентификаторов текущего бэнда
    while not AClone.Eof do
    begin
      AIDList.Add(AClone.FieldByName(qCategoryParameters.W.PKFieldName).AsInteger);
      AClone.Next;
    end;

    AClone.First;
    while not AClone.Eof do
    begin
      // Переходим на очередной подпараметр
      qCategoryParameters.W.LocateByPK
        (AClone.FieldByName(qCategoryParameters.W.PKFieldName).AsInteger, True);

      // Создаём колонку
      CreateColumn([MainView], AIDList.ToArray, qCategoryParameters);

      AClone.Next;
    end;
  finally
    qCategoryParameters.W.DropClone(AClone);
    FreeAndNil(AIDList);
  end;

end;

procedure TViewAnalogGrid.cxGridDBBandedTableViewInitEdit
  (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
  AEdit: TcxCustomEdit);
begin
  inherited;

  if not(AEdit is TcxMemo) then
    Exit;

  FcxGridDBBandedColumn := AItem as TcxGridDBBandedColumn;

  FcxMemo := AEdit as TcxMemo;
  PostMessage(Handle, WM_AFTER_INIT_EDIT, 0, 0);
end;

procedure TViewAnalogGrid.cxGridDBBandedTableViewMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  H: TcxCustomGridHitTest;
begin
  inherited;

  cxGrid.Hint := '';
  H := MainView.GetHitTest(X, Y);

  // Показываем всплывающие подсказки
  if H is TcxGridBandHeaderHitTest then
  begin
    cxGrid.Hint := (H as TcxGridBandHeaderHitTest).Band.AlternateCaption;
  end
  else if H is TcxGridColumnHeaderHitTest then
  begin
    cxGrid.Hint := (H as TcxGridColumnHeaderHitTest).Column.AlternateCaption;
  end

end;

procedure TViewAnalogGrid.DeleteBands;
begin
  // Бэнды, которые не существуют "по умолчанию" удаляем
  FBandsInfo.FreeNotDefaultBands;

  // Бэнды, которые существуют "по умолчанию" прячем
  FBandsInfo.HideDefaultBands;
end;

procedure TViewAnalogGrid.DeleteColumns;
begin
  FColumnsInfo.FreeNotDefaultColumns;
  FColumnsInfo.Clear;
end;

procedure TViewAnalogGrid.DoAfterInitMemo;
begin
  if FcxMemo = nil then
    Exit;

  if FcxMemo.Parent <> nil then
  begin
    cxEditorButton.Left := FcxMemo.Left + FcxMemo.Width -
      cxEditorButton.Width + 1;
    cxEditorButton.Top := FcxMemo.Top + 1;
    cxEditorButton.Height := FcxMemo.Height;
    cxEditorButton.Visible := True;
    EditorTimer.Enabled := True;
  end
  else
  begin
    cxEditorButton.Visible := False;
  end;

  // UpdateSimpleText;
end;

procedure TViewAnalogGrid.dxCalloutPopup1Hide(Sender: TObject);
var
  AParamSubParamID: Integer;
begin
  inherited;

  // Получаем идентификатор параметра, связанного с редактируемой колонкой
  AParamSubParamID := AnalogGroup.GetParamSubParamIDByFieldName
    (FcxGridDBBandedColumn.DataBinding.FieldName);

  AnalogGroup.UpdateParameterValues(AParamSubParamID);
end;

procedure TViewAnalogGrid.EditorTimerTimer(Sender: TObject);
begin
  inherited;
  if IsMemoEditorHide then
    EditorTimer.Enabled := False;
end;

function TViewAnalogGrid.GetBandCaption(qryCategoryParameters :
    TQueryCategoryParameters2): string;
begin
  Assert(qryCategoryParameters <> nil);
  Assert(qryCategoryParameters.FDQuery.RecordCount > 0);

  if UseTableName then
    Result := qCategoryParameters.W.TableName.F.AsString
  else
    Result := qCategoryParameters.W.Value.F.AsString;

  Result := DeleteDouble(Result, ' ');
end;

function TViewAnalogGrid.GetqCategoryParameters: TQueryCategoryParameters2;
begin
  Result := AnalogGroup.CatParamsGroup.qCategoryParameters;
end;

function TViewAnalogGrid.IsMemoEditorHide: Boolean;
begin
  // спрятан ли текстовый редактор
  Result := (FcxMemo = nil) or ((FcxMemo <> nil) and (FcxMemo.Parent = nil) and
    (not cxEditorButton.Focused));
  cxEditorButton.Visible := not Result;
end;

procedure TViewAnalogGrid.InitColumns;
var
  ABandInfo: TBandInfo;
  qCatParams: TQryCategoryParameters;
begin
  FreeAndNil(FColumnsBarButtons);

  AnalogGroup.CatParamsGroup.LoadData;
  qCatParams := AnalogGroup.CatParamsGroup.qCatParams;

  // Возможно у нас нет ни одного параметра
  if qCatParams.RecordCount = 0 then
    Exit;

  qCatParams.First;
  cxGrid.BeginUpdate();
  try
    // Сначала удаляем ранее добавленные колонки
    DeleteColumns;
    // Потом удаляем ранее добавленные бэнды
    DeleteBands;

    // Цикл по бэндам (параметрам)
    while not qCatParams.Eof do
    begin
      CreateColumnsForBand(qCatParams.ID.AsInteger);
      qCatParams.Next;
    end;

    // запоминаем в какой позиции находится наш бэнд
    for ABandInfo in FBandsInfo do
      ABandInfo.ColIndex := ABandInfo.Band.Position.ColIndex;

    MainView.ViewData.Collapse(True);
  finally
    cxGrid.EndUpdate;
    PostMyApplyBestFitEvent;
  end;
end;

procedure TViewAnalogGrid.SetAnalogGroup(const Value: TAnalogGroup);
begin
  if FAnalogGroup = Value then
    Exit;

  FAnalogGroup := Value;

  if FAnalogGroup = nil then
    Exit;

  DataSet := FAnalogGroup.FDMemTable;

end;

procedure TViewAnalogGrid.SetUseTableName(const Value: Boolean);
begin
  FUseTableName := Value;
  UpdateBandsCaptions;
end;

procedure TViewAnalogGrid.UpdateBandsCaptions;
var
  ABI: TBandInfo;
  ACaption: string;
  AID: Integer;
begin
  for ABI in FBandsInfo do
  begin
    if not ABI.Band.Visible then
      continue;

    // Ищем данные о заголовке бэнда
    Assert(ABI.IDList.Count > 0);
    // Берём первый подпараметр
    AID := ABI.IDList[0];
    qCategoryParameters.W.LocateByPK(AID, True);

    // Меняем заголовок бэнда
    ACaption := GetBandCaption(qCategoryParameters);
    if ACaption = ABI.Band.Caption then
      Continue;

    ABI.Band.Caption := ACaption;
    // Ширина бэнда
    UpdateMinBandWindth(ABI as TBandInfoEx);
  end;
end;

procedure TViewAnalogGrid.UpdateMinBandWindth(ABandInfo: TBandInfoEx);
var
  ABand: TcxGridBand;
  R: TRect;
begin
  // Ширина бэнда

  ABand := ABandInfo.Band;

  R := TTextRect.Calc(ABand.GridView.ViewInfo.Canvas.Canvas, ABand.Caption);

  for ABand in ABandInfo.Bands do
    ABand.Width := R.Width + 10;
end;

end.
