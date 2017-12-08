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
  System.Generics.Collections, StrHelper, ParametersForCategoryQuery,
  BandsInfo, cxMemo, Vcl.StdCtrls, cxButtons, Vcl.ExtCtrls, dxCalloutPopup,
  GridFrame, GridView, System.Math, cxCheckBox, cxLabel, ParameterKindEnum,
  PopupAnalogGridView, RepositoryDataModule;

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
    procedure dxCalloutPopup1Hide(Sender: TObject);
    procedure EditorTimerTimer(Sender: TObject);
  private
    FAnalogGroup: TAnalogGroup;
    FBandsInfo: TBandsInfo;
    FColumns: TList<TcxGridDBBandedColumn>;
    FcxGridDBBandedColumn: TcxGridDBBandedColumn;
    FcxMemo: TcxMemo;
    procedure CreateColumn(AView: TcxGridDBBandedTableView;
      AIDParameter: Integer; const ABandCaption, AColumnCaption,
      AFieldName: String; AVisible: Boolean; const AHint: string;
      ACategoryParamID, AOrder, APosID: Integer);
    procedure DeleteBands;
    procedure DeleteColumns;
    procedure SetAnalogGroup(const Value: TAnalogGroup);
    { Private declarations }
  protected
    procedure AfterInitEdit(var Message: TMessage); message WM_AFTER_INIT_EDIT;
    procedure DoAfterInitMemo;
    function IsMemoEditorHide: Boolean;
    procedure InitColumns; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property AnalogGroup: TAnalogGroup read FAnalogGroup write SetAnalogGroup;
    { Public declarations }
  end;

implementation

uses
  AutoSizeGridViewForm, System.Types;

{$R *.dfm}

constructor TViewAnalogGrid.Create(AOwner: TComponent);
begin
  inherited;
  FColumns := TList<TcxGridDBBandedColumn>.Create;
  FBandsInfo := TBandsInfo.Create;
  FcxMemo := nil;
  FcxGridDBBandedColumn := nil;
  cxEditorButton.Parent := cxGrid;
  cxEditorButton.Visible := False;
  actShowPopup.Caption := #$2219#$2219#$2219;
end;

destructor TViewAnalogGrid.Destroy;
begin
  FreeAndNil(FBandsInfo);
  FreeAndNil(FColumns);
  inherited;
end;

procedure TViewAnalogGrid.actClearExecute(Sender: TObject);
var
  AColumn: TcxGridDBBandedColumn;
  AParameterID: Integer;
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
    AParameterID := AnalogGroup.GetParamIDByFieldName( AColumn.DataBinding.FieldName );
    AnalogGroup.Clear(AParameterID);
  end;
end;

procedure TViewAnalogGrid.actFullAnalogExecute(Sender: TObject);
begin
  inherited;
  AnalogGroup.CheckDefault;
end;

procedure TViewAnalogGrid.actNearAnalogExecute(Sender: TObject);
begin
  inherited;
  AnalogGroup.CheckNear;
end;

procedure TViewAnalogGrid.actSaveExecute(Sender: TObject);
begin
  inherited;
  AnalogGroup.SetAsDefaultValues;
end;

procedure TViewAnalogGrid.actShowPopupExecute(Sender: TObject);
var
  AColumn: TcxGridDBBandedColumn;
  AParameterID: Integer;
  AParamValues: TParamValues;
  R: TRect;
begin
  inherited;

  Assert(FcxGridDBBandedColumn <> nil);

  // Получаем идентификатор параметра, связанного с редактируемой колонкой
  AParameterID := AnalogGroup.GetParamIDByFieldName
    (FcxGridDBBandedColumn.DataBinding.FieldName);

  AParamValues := AnalogGroup.ParamValuesList.FindByParameterID(AParameterID);
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

procedure TViewAnalogGrid.CreateColumn(AView: TcxGridDBBandedTableView;
  AIDParameter: Integer; const ABandCaption, AColumnCaption, AFieldName: String;
  AVisible: Boolean; const AHint: string; ACategoryParamID, AOrder,
  APosID: Integer);
var
  ABand: TcxGridBand;
  ABandInfo: TBandInfo;
  AColumn: TcxGridDBBandedColumn;
  NeedInitialize: Boolean;
begin
  // Поиск среди ранее созданных бэндов
  ABandInfo := FBandsInfo.Search(AView, AIDParameter);

  // Нужна ли инициализация бэнда
  NeedInitialize := (ABandInfo = nil) or
    (ABandInfo.DefaultCreated and not ABandInfo.Band.VisibleForCustomization);

  // Если не нашли подходящий бэнд
  if ABandInfo = nil then
  begin
    // Создаём новый бэнд
    ABand := AView.Bands.Add;
    // Добавляем его в описание
    ABandInfo := TBandInfo.Create(ABand, AIDParameter);
    FBandsInfo.Add(ABandInfo);
  end;
  Assert(ABandInfo <> nil);
  ABand := ABandInfo.Band;

  // Инициализируем бэнд
  if NeedInitialize then
  begin
    ABandInfo.CategoryParamID := ACategoryParamID;
    ABandInfo.DefaultVisible := AVisible;
    ABand.Visible := AVisible;
    ABand.VisibleForCustomization := True;
    ABand.Caption := DeleteDouble(ABandCaption, ' ');
    ABand.AlternateCaption := AHint;
    if ABandInfo.DefaultCreated then
      ABand.Position.ColIndex := 1000; // Помещаем бэнд в конец
    // Какой порядок имеет параметр в БД
    ABandInfo.Order := AOrder;
    ABandInfo.Pos := APosID;
  end;

  // Если такой бэнд не существовал по "умолчанию"
  if not ABandInfo.DefaultCreated then
  begin
    // Создаём колонку для этого бэнда
    AColumn := AView.CreateColumn;
    AColumn.Position.BandIndex := ABand.Index;
    AColumn.MinWidth := 40;
    AColumn.Caption := DeleteDouble(AColumnCaption, ' ');
    AColumn.AlternateCaption := AHint;
    AColumn.DataBinding.FieldName := AFieldName;
    // В режиме просмотра убираем ограничители
    // AColumn.OnGetDataText := DoOnGetDataText;

    // if AView = MainView then
    // begin
    AColumn.PropertiesClass := TcxMemoProperties;
    (AColumn.Properties as TcxMemoProperties).WordWrap := False;
    (AColumn.Properties as TcxMemoProperties).ReadOnly := True;
    // (AColumn.Properties as TcxMemoProperties).OnEditValueChanged :=
    // DoOnEditValueChanged;
    // AColumn.OnUserFilteringEx := DoOnUserFilteringEx;
    // AColumn.OnGetFilterValues := DoOnGetFilterValues;
    // end
    // else
    // begin
    // AColumn.PropertiesClass := TcxTextEditProperties;
    // end;
    FColumns.Add(AColumn);
  end
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

procedure TViewAnalogGrid.DeleteBands;
begin
  // Бэнды, которые не существуют "по умолчанию" удаляем
  FBandsInfo.FreeNotDefaultBands;

  // Бэнды, которые существуют "по умолчанию" прячем
  FBandsInfo.HideDefaultBands;
end;

procedure TViewAnalogGrid.DeleteColumns;
var
  AcxGridDBBandedColumn: TcxGridDBBandedColumn;
begin
  for AcxGridDBBandedColumn in FColumns do
    AcxGridDBBandedColumn.Free;

  FColumns.Clear;

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
  AParameterID: Integer;
begin
  inherited;

  // Получаем идентификатор параметра, связанного с редактируемой колонкой
  AParameterID := AnalogGroup.GetParamIDByFieldName
    (FcxGridDBBandedColumn.DataBinding.FieldName);

  AnalogGroup.UpdateParameterValues(AParameterID);
end;

procedure TViewAnalogGrid.EditorTimerTimer(Sender: TObject);
begin
  inherited;
  if IsMemoEditorHide then
    EditorTimer.Enabled := False;
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
  ABandCaption: string;
  ABandInfo: TBandInfo;
  ACaption: String;
  ACategoryParamID: Integer;
  AHint: String;
  AColumnCaption: string;
  AFieldName: String;
  AIDBand: Integer;
  AOrder: Integer;
  APosID: Integer;
  qParametersForCategory: TQueryParametersForCategory;
  AVisible: Boolean;
begin
  FreeAndNil(FColumnsBarButtons);

  qParametersForCategory := AnalogGroup.qParametersForCategory;

  cxGrid.BeginUpdate();
  try
    // Сначала удаляем ранее добавленные колонки
    DeleteColumns;
    // Потом удаляем ранее добавленные бэнды
    DeleteBands;

    // qParametersForCategory.Load(ComponentsExGroup.qComponentsEx.ParentValue);
    qParametersForCategory.FDQuery.First;
    while not qParametersForCategory.FDQuery.Eof do
    begin
      // Имя поля получаем из словаря всех имён полей параметров
      AFieldName := AnalogGroup.AllParameterFields
        [qParametersForCategory.ParameterID.AsInteger];
      AVisible := qParametersForCategory.IsAttribute.AsBoolean;
      ACaption := qParametersForCategory.Caption.AsString;
      AHint := qParametersForCategory.Hint.AsString;
      ACategoryParamID := qParametersForCategory.IDCategory.AsInteger;
      Assert(not qParametersForCategory.Ord.IsNull);
      AOrder := qParametersForCategory.Ord.AsInteger;
      APosID := qParametersForCategory.PosID.AsInteger;

      // Если это родительский параметр
      if qParametersForCategory.ParentParameter.IsNull then
      begin
        AIDBand := qParametersForCategory.ParameterID.AsInteger;
        ABandCaption := ACaption;
        AColumnCaption := ' ';
      end
      else
      begin
        AIDBand := qParametersForCategory.ParentParameter.AsInteger;
        ABandCaption := qParametersForCategory.ParentCaption.AsString;
        AColumnCaption := ACaption;
      end;

      // Создаём колонку в главном представлении
      CreateColumn(MainView, AIDBand, ABandCaption, AColumnCaption, AFieldName,
        AVisible, AHint, ACategoryParamID, AOrder, APosID);

      // Создаём колонку в дочернем представлении
      // CreateColumn(GridView(cxGridLevel2), AIDBand, ABandCaption,
      // AColumnCaption, AFieldName, AVisible, AHint, ACategoryParamID,
      // AOrder, APosID);

      qParametersForCategory.FDQuery.Next;
    end;

    // запоминаем в какой позиции находится наш бэнд
    for ABandInfo in FBandsInfo do
      ABandInfo.ColIndex := ABandInfo.Band.Position.ColIndex;

    MainView.ViewData.Collapse(True);
  finally
    cxGrid.EndUpdate;
  end;
  // FColumnsBarButtons := TColumnsBarButtonsEx2.Create(Self, dxbsColumns,
  // MainView, cxGridDBBandedTableView2);

  PostMyApplyBestFitEvent;

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

end.
