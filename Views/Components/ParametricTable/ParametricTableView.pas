unit ParametricTableView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ComponentsParentView, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData,
  cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB, cxDBData,
  cxLabel, cxEditRepositoryItems, cxGridCustomPopupMenu, cxGridPopupMenu,
  Vcl.Menus, System.Actions, Vcl.ActnList, dxBar, cxClasses, Vcl.ComCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridBandedTableView,
  cxGridDBBandedTableView, cxGridCustomView, cxGrid,
  ComponentsExGroupUnit, System.Generics.Collections,
  ColumnsBarButtonsHelper, cxContainer, cxTextEdit, cxMemo, Vcl.StdCtrls,
  Vcl.ExtCtrls, dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
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
  dxSkinXmas2008Blue, dxSkinscxPCPainter, dxSkinsdxBarPainter,
  ComponentsBaseView, cxDBLookupComboBox, cxDropDownEdit, cxButtonEdit,
  cxExtEditRepositoryItems, CustomComponentsQuery, cxBlobEdit;

const
  WM_ON_EDIT_VALUE_CHANGE = WM_USER + 61;
  WM_ON_BAND_POS_CHANGE = WM_USER + 62;

type
  TViewParametricTable = class(TViewComponentsBase)
    actAutoWidth: TAction;
    dxbrbtnApplyUpdates: TdxBarButton;
    dxbrsbtmAnalogSearch: TdxBarSubItem;
    dxbbFullAnalog: TdxBarButton;
    actFullAnalog: TAction;
    actClearFilters: TAction;
    actNearAnalog: TAction;
    dxBarButton2: TdxBarButton;
    dxbbClearFilters: TdxBarButton;
    Timer: TTimer;
    Timer2: TTimer;
    procedure actAutoWidthExecute(Sender: TObject);
    procedure actClearFiltersExecute(Sender: TObject);
    procedure actFullAnalogExecute(Sender: TObject);
    procedure actNearAnalogExecute(Sender: TObject);
    procedure cxGridDBBandedTableViewBandPosChanged
      (Sender: TcxGridBandedTableView; ABand: TcxGridBand);
    procedure cxGridDBBandedTableViewInitEditValue
      (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
      AEdit: TcxCustomEdit; var AValue: Variant);
    procedure cxGridDBBandedTableViewDataControllerFilterChanged
      (Sender: TObject);
    procedure cxGridDBBandedTableViewMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure dxBarButton2Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    // TODO: cxGridDBBandedTableViewDataControllerFilterChanged
    // procedure cxGridDBBandedTableViewDataControllerFilterChanged
    // (Sender: TObject);
  private
    FBands: TList<TcxGridBand>;
    FColumns: TList<TcxGridDBBandedColumn>;
    FDefaultCreatedBands: TList<TcxGridBand>;
    FDefaultVisibleBands: TList<TcxGridBand>;
    FLockDetailFilterChange: Boolean;
    FMark: string;
    procedure CreateColumn(AView: TcxGridDBBandedTableView; AIDBand: Integer;
      const ABandCaption, AColumnCaption, AFieldName: String; AVisible: Boolean;
      const AHint: string);
    function GetBand(ALevel: TcxGridLevel; AIDParameter: Integer): TcxGridBand;
    procedure DeleteBands;
    procedure DeleteColumns;
    procedure DoAfterLoad(Sender: TObject);
    procedure DoOnEditValueChanged(Sender: TObject);
    procedure DoOnGetDataText(Sender: TcxCustomGridTableItem;
      ARecordIndex: Integer; var AText: string);
    procedure DoOnGetFilterValues(Sender: TcxCustomGridTableItem;
      AValueList: TcxDataFilterValueList);
    procedure DoOnUserFilteringEx(Sender: TcxCustomGridTableItem;
      AFilterList: TcxFilterCriteriaItemList; const AValue: Variant;
      const ADisplayText: string);
    function GetComponentsExGroup: TComponentsExGroup;
    procedure InitializeDefaultCreatedBands(AView: TcxGridDBBandedTableView;
      AQueryCustomComponents: TQueryCustomComponents);
    procedure SetComponentsExGroup(const Value: TComponentsExGroup);
    { Private declarations }
  protected
    procedure CreateColumnsBarButtons; override;
    procedure CreateDetailFilter;
    procedure DoAfterBandPosChange(var Message: TMessage);
      message WM_ON_BAND_POS_CHANGE;
    // TODO: CreateFilter
    // procedure CreateFilter(AColumn: TcxGridDBBandedColumn;
    // const AValue: string);
    procedure DoOnMasterDetailChange; override;
    procedure OnEditValueChangeProcess(var Message: TMessage);
      message WM_ON_EDIT_VALUE_CHANGE;
    procedure UpdateDetailColumnsWidth2;
    procedure UpdateFiltersAction;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure FilterByFamily(AFamily: string);
    procedure MyApplyBestFit; override;
    procedure UpdateView; override;
    property ComponentsExGroup: TComponentsExGroup read GetComponentsExGroup
      write SetComponentsExGroup;
    property Mark: string read FMark;
    { Public declarations }
  end;

  TShowDefaults = class(TCustomizeGridViewAction)
  private
    FDefaultActions: TList<TCustomizeGridViewItemAction>;
  protected
    procedure actShowDefaultBandsExecute(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure MakeCurrentActionsAsDefault;
    property DefaultActions: TList<TCustomizeGridViewItemAction>
      read FDefaultActions;
  end;

  TColumnsBarButtonsEx2 = class(TColumnsBarButtonsEx)
  private
    FShowDefaults: TShowDefaults;
  protected
    procedure CreateGridViewActions; override;
    procedure ProcessGridView; override;
  end;

  TFilterItem = class(TObject)
  private
    FColumn: TcxGridDBBandedColumn;
    FFilterOperatorKind: TcxFilterOperatorKind;
    FValue: Variant;
  public
    constructor Create(AColumn: TcxGridDBBandedColumn;
      AFilterOperatorKind: TcxFilterOperatorKind; AValue: Variant);
    property Column: TcxGridDBBandedColumn read FColumn;
    property FilterOperatorKind: TcxFilterOperatorKind read FFilterOperatorKind;
    property Value: Variant read FValue;
  end;

implementation

{$R *.dfm}

uses NotifyEvents, ParametersForCategoryQuery, System.StrUtils,
  RepositoryDataModule, cxFilterConsts, cxGridDBDataDefinitions, StrHelper,
  ParameterValuesUnit, ProjectConst, ParametersForProductQuery,
  SearchParametersForCategoryQuery, System.Generics.Defaults;

constructor TViewParametricTable.Create(AOwner: TComponent);
begin
  inherited;

  FColumns := TList<TcxGridDBBandedColumn>.Create;
  FBands := TList<TcxGridBand>.Create;
  FDefaultVisibleBands := TList<TcxGridBand>.Create;
  FDefaultCreatedBands := TList<TcxGridBand>.Create;
end;

destructor TViewParametricTable.Destroy;
begin
  FreeAndNil(FDefaultVisibleBands);
  FreeAndNil(FColumns);
  FreeAndNil(FBands);
  FreeAndNil(FDefaultCreatedBands);
  inherited;
end;

procedure TViewParametricTable.actAutoWidthExecute(Sender: TObject);
begin
  PostMyApplyBestFitEvent;
end;

procedure TViewParametricTable.actClearFiltersExecute(Sender: TObject);
begin
  MainView.DataController.Filter.Clear;
  UpdateFiltersAction;
end;

procedure TViewParametricTable.actFullAnalogExecute(Sender: TObject);
var
  AColumn: TcxGridDBBandedColumn;
  AFilterList: TcxFilterCriteriaItemList;
  AMainColumn: TcxGridDBBandedColumn;
  F: TList<TList<TFilterItem>>;
  fi: TFilterItem;
  i: Integer;
  m: TArray<String>;
  R: TcxCustomGridRecord;
  root: TcxFilterCriteriaItemList;
  AValue: string;
  AView: TcxGridDBBandedTableView;
  L: TList<TFilterItem>;
  ms: string;
  S: string;
begin
  AView := FocusedTableView;

  if AView.ViewData.RecordCount = 0 then
    Exit;

  R := AView.Controller.FocusedRecord;
  Assert(R <> nil);

  F := TList < TList < TFilterItem >>.Create;
  try

    for i := 0 to AView.ColumnCount - 1 do
    begin
      AColumn := AView.Columns[i];
      if (AColumn.Position.Band.Tag > 0) and (AColumn.Visible) then
      begin
        AValue := VarToStrDef(R.Values[AColumn.Index], '').Trim;
        if not AValue.IsEmpty then
        begin
          L := TList<TFilterItem>.Create;
          F.Add(L);
          // Разбиваем значение на отдельные строки
          m := AValue.Split([#13]);
          for ms in m do
          begin

            S := ms.Trim;
            if not S.IsEmpty then
            begin
              S := '%' + S + '%';
              if AView = GetDBBandedTableView(1) then
                AMainColumn := MainView.GetColumnByFieldName
                  (AColumn.DataBinding.FieldName)
              else
                AMainColumn := AColumn;
              L.Add(TFilterItem.Create(AMainColumn, foLike, S));
            end;
          end;
        end;
      end;
    end;

    FLockDetailFilterChange := True;
    root := MainView.DataController.Filter.root;
    root.Clear;
    root.BoolOperatorKind := fboAnd;

    for L in F do
    begin
      // Если будем добавлять несколько условий на один столбец
      if L.Count > 1 then
      begin
        AFilterList := root.AddItemList(fboOr);
      end
      else
        AFilterList := root;

      for fi in L do
      begin
        AFilterList.AddItem(fi.Column, fi.FilterOperatorKind, fi.Value,
          fi.Value);
        fi.Free;
      end;

      L.Free;
    end;
    MainView.DataController.Filter.Active := True;
    // if AView = MainView then
    CreateDetailFilter;

    FLockDetailFilterChange := False;
  finally
    FreeAndNil(F);
  end;

end;

procedure TViewParametricTable.actNearAnalogExecute(Sender: TObject);
var
  AColumn: TcxGridDBBandedColumn;
  AFilterList: TcxFilterCriteriaItemList;
  F: TList<TList<TFilterItem>>;
  fi: TFilterItem;
  i: Integer;
  m: TArray<String>;
  R: TcxCustomGridRecord;
  root: TcxFilterCriteriaItemList;
  AValue: string;
  AView: TcxGridDBBandedTableView;
  L: TList<TFilterItem>;
  ms: string;
  S: string;
begin
  AView := FocusedTableView;

  if AView.ViewData.RecordCount = 0 then
    Exit;

  R := AView.Controller.FocusedRecord;
  Assert(R <> nil);

  F := TList < TList < TFilterItem >>.Create;
  try

    for i := 0 to AView.ColumnCount - 1 do
    begin
      AColumn := AView.Columns[i];
      if (AColumn.Position.Band.Tag > 0) and (AColumn.Visible) then
      begin
        AValue := VarToStrDef(R.Values[AColumn.Index], '').Trim;
        if not AValue.IsEmpty then
        begin
          L := TList<TFilterItem>.Create;
          F.Add(L);
          // Разбиваем значение на отдельные строки
          m := AValue.Split([#13]);
          for ms in m do
          begin

            S := ms.Trim;
            if not S.IsEmpty then
            begin
              S := '%' + S + '%';
              L.Add(TFilterItem.Create(AColumn, foLike, S));
            end;
          end;
        end;
      end;
    end;

    FLockDetailFilterChange := True;
    root := AView.DataController.Filter.root;
    root.Clear;
    root.BoolOperatorKind := fboAnd;

    for L in F do
    begin
      // Если будем добавлять несколько условий на один столбец
      if L.Count > 1 then
      begin
        AFilterList := root.AddItemList(fboOr);
      end
      else
        AFilterList := root;

      for fi in L do
      begin
        AFilterList.AddItem(fi.Column, fi.FilterOperatorKind, fi.Value,
          fi.Value);
        fi.Free;
      end;

      L.Free;
    end;
    AView.DataController.Filter.Active := True;
    CreateDetailFilter;

    FLockDetailFilterChange := False;
  finally
    FreeAndNil(F);
  end;

end;

procedure TViewParametricTable.DoOnGetFilterValues
  (Sender: TcxCustomGridTableItem; AValueList: TcxDataFilterValueList);
var
  ADisplayText: string;
  i: Integer;
  AKind: TcxFilterValueItemKind;
  ANewDisplayText: string;
  AValue: Variant;
  AValues: TList<String>;
  m: TArray<String>;
  S: string;
begin
  inherited;
  Assert(not FMark.IsEmpty);

  AValues := TList<String>.Create;
  try

    for i := 0 to AValueList.Count - 1 do
    begin
      AKind := AValueList.Items[i].Kind;
      if AKind <> fviCustom then
      begin
        ADisplayText := AValueList.Items[i].DisplayText;
        AValue := AValueList.Items[i].Value;

        if AKind = fviValue then
        begin
          m := ADisplayText.Split([#13]);
          for S in m do
          begin
            ANewDisplayText := S.Trim;
            if not ANewDisplayText.IsEmpty then
            begin
              if AValues.IndexOf(ANewDisplayText) = -1 then
              begin
                AValues.Add(ANewDisplayText);
              end;
            end;
          end;
        end
      end;
    end;

    AValueList.Clear;
    AValueList.Add(fviAll, null, '(Все)', True);
    // AValueList.Add(fviBlanks, null, '(Пустые)', True);
    // AValueList.Add(fviNonBlanks, null, '(Не пустые)', True);
    // AValueList.Add(fviUserEx, null, '(Все)', True);

    for S in AValues do
    begin
      AValueList.Add(fviUserEx, Format('%%%s%s%s%%', [Mark, S, Mark]),
        S, False);
    end;

  finally
    FreeAndNil(AValues);
  end;

end;

procedure TViewParametricTable.DoOnGetDataText(Sender: TcxCustomGridTableItem;
  ARecordIndex: Integer; var AText: string);
begin
  AText := AText.Replace(Mark, '', [rfReplaceAll]);
end;

procedure TViewParametricTable.DoOnUserFilteringEx
  (Sender: TcxCustomGridTableItem; AFilterList: TcxFilterCriteriaItemList;
  const AValue: Variant; const ADisplayText: string);
// var
// AMyFilterList: TcxFilterCriteriaItemList;
begin
  // Содержит
  AFilterList.AddItem(Sender, foLike, AValue, ADisplayText);
  UpdateFiltersAction;

  {
    AColumn := Sender as TcxGridDBBandedColumn;
    ADetailColumn := cxGridDBBandedTableView2.GetColumnByFieldName(AColumn.DataBinding.FieldName);
    ADetailColumn.DataBinding.FilterCriteriaItem.
    {
    r := cxGridDBBandedTableView2.DataController.Filter.Root;
    r.AddItem(ADetailColumn, foLike, AValue, ADisplayText);
    cxGridDBBandedTableView2.DataController.Filter.Active := True;
  }
  {

    AMyFilterList := AFilterList.AddItemList(fboOr);

    // Точное совпадение
    AMyFilterList.AddItem(Sender, foEqual, AValue, AValue);
    // В начале списка
    AMyFilterList.AddItem(Sender, foLike, AValue + #13#10 + '%', AValue);
    // В середине списка
    AMyFilterList.AddItem(Sender, foLike, '%' + #13#10 + AValue + #13#10 +
    '%', AValue);
    // В конце списка
    AMyFilterList.AddItem(Sender, foLike, '%' + #13#10 + AValue, AValue);
  }
end;

procedure TViewParametricTable.dxBarButton2Click(Sender: TObject);
begin
  inherited;
  UpdateDetailColumnsWidth2;
end;

procedure TViewParametricTable.CreateColumn(AView: TcxGridDBBandedTableView;
  AIDBand: Integer; const ABandCaption, AColumnCaption, AFieldName: String;
  AVisible: Boolean; const AHint: string);
var
  ABand: TcxGridBand;
  AcxGridDBBandedColumn: TcxGridDBBandedColumn;
  i: Integer;
begin
  ABand := nil;

  // Поиск среди ранее созданных бэндов
  for i := 0 to AView.Bands.Count - 1 do
  begin
    if AView.Bands[i].Tag = AIDBand then
    begin
      ABand := AView.Bands[i];
      Break;
    end;
  end;

  // Если не нашли подходящий бэнд
  if ABand = nil then
  begin
    // если подходящий бэнд не нашли
    ABand := AView.Bands.Add;
    ABand.Tag := AIDBand;
    ABand.Caption := DeleteDoubleSpace(ABandCaption);
    ABand.AlternateCaption := AHint;
    ABand.Visible := AVisible;
    if AVisible then
      FDefaultVisibleBands.Add(ABand);
    FBands.Add(ABand);
  end;

  // Если такой бэнд существует по "умолчанию"
  if FDefaultCreatedBands.IndexOf(ABand) >= 0 then
  begin
    if ABand.VisibleForCustomization = False then
    begin
      ABand.VisibleForCustomization := True;
      ABand.Caption := DeleteDoubleSpace(ABandCaption);
      ABand.AlternateCaption := AHint;
      ABand.Position.ColIndex := 1000; // Помещаем бэнд в конец
      ABand.Visible := AVisible;
      if AVisible then
        FDefaultVisibleBands.Add(ABand);
    end;
  end
  else
  begin
    // Создаём колонку для этого бэнда
    AcxGridDBBandedColumn := AView.CreateColumn;
    AcxGridDBBandedColumn.Position.BandIndex := ABand.Index;
    AcxGridDBBandedColumn.MinWidth := 40;
    AcxGridDBBandedColumn.Caption := DeleteDoubleSpace(AColumnCaption);
    AcxGridDBBandedColumn.AlternateCaption := AHint;
    AcxGridDBBandedColumn.DataBinding.FieldName := AFieldName;
    AcxGridDBBandedColumn.OnGetDataText := DoOnGetDataText;

    if AView = MainView then
    begin
      AcxGridDBBandedColumn.PropertiesClass := TcxMemoProperties;
      (AcxGridDBBandedColumn.Properties as TcxMemoProperties).WordWrap := False;
      (AcxGridDBBandedColumn.Properties as TcxMemoProperties).OnEditValueChanged
        := DoOnEditValueChanged;
      AcxGridDBBandedColumn.OnUserFilteringEx := DoOnUserFilteringEx;
      AcxGridDBBandedColumn.OnGetFilterValues := DoOnGetFilterValues;
    end
    else
    begin
      AcxGridDBBandedColumn.PropertiesClass := TcxTextEditProperties;
    end;
    FColumns.Add(AcxGridDBBandedColumn);
  end;
end;

procedure TViewParametricTable.CreateColumnsBarButtons;
begin
  // FColumnsBarButtons := TColumnsBarButtonsEx.Create(Self,
  // dxbrsbtmColumnsCustomization, MainView, cxGridDBBandedTableView2);
end;

procedure TViewParametricTable.CreateDetailFilter;
begin
  cxGridDBBandedTableView2.DataController.Filter.Assign
    (MainView.DataController.Filter);
  UpdateFiltersAction;
end;

procedure TViewParametricTable.cxGridDBBandedTableViewBandPosChanged
  (Sender: TcxGridBandedTableView; ABand: TcxGridBand);
begin
  inherited;
  // Перемещать можно только бэнд-параметр
  Assert(ABand.Tag > 0);

  // Меняем позицию дочернего бэнда
  GetBand(cxGridLevel2, ABand.Tag).Position.ColIndex := ABand.Position.ColIndex;

  // Сообщаем что изменение бэндов нужно будет дополнительно обработать
  // PostMessage(Handle, WM_ON_BAND_POS_CHANGE, 0, 0);
  Timer2.Enabled := True;
end;

// TODO: CreateFilter
// procedure TViewParametricTable.CreateFilter(AColumn: TcxGridDBBandedColumn;
// const AValue: string);
// var
// r: TcxFilterCriteriaItemList;
// begin
// r := MainView.DataController.Filter.Root;
// r.Clear;
// r.BoolOperatorKind := fboOr;
//
/// / Точное совпадение
// r.AddItem(AColumn, foEqual, AValue, AValue);
/// / В начале списка
// r.AddItem(AColumn, foLike, AValue + #13#10 + '%', AValue);
/// / В середине списка
// r.AddItem(AColumn, foLike, '%' + #13#10 + AValue + #13#10 + '%', AValue);
/// / В конце списка
// r.AddItem(AColumn, foLike, '%' + #13#10 + AValue, AValue);
//
// MainView.DataController.Filter.Active := True;
//
// end;

var
  FInChange: Boolean = False;

procedure TViewParametricTable.
  cxGridDBBandedTableViewDataControllerFilterChanged(Sender: TObject);
{
  var
  a: Boolean;
  fc: TcxGridDBDataFilterCriteria;
  fca: string;
  ft: string;
  ie: Boolean;
  isf: Boolean;
}
begin
  if FLockDetailFilterChange then
    Exit;

  inherited;
  {
    fc := Sender as TcxGridDBDataFilterCriteria;
    ft := fc.FilterText;
    isf := fc.IsFiltering;
    ie := fc.IsEmpty;
    a := fc.Active;
    fca := fc.FilterCaption;
  }
{
  FLockDetailFilterChange := True;
  try
    CreateDetailFilter;
  finally
    FLockDetailFilterChange := False;
  end;
}
  // cxGridDBBandedTableView2.DataController.Filter.Active := True;
end;

procedure TViewParametricTable.cxGridDBBandedTableViewInitEditValue
  (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
  AEdit: TcxCustomEdit; var AValue: Variant);
var
  S: string;
begin
  if AEdit is TcxMemo then
  begin
    S := VarToStrDef(AValue, '');
    S := S.Replace(Mark, '', [rfReplaceAll]);
    AValue := S;
  end;
end;

procedure TViewParametricTable.cxGridDBBandedTableViewMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
Var
  P: TPoint;
  H: TcxCustomGridHitTest;
  // S: String;
begin
  inherited;

  cxGrid.Hint := '';
  H := MainView.GetHitTest(X, Y);

  // S := H.ClassName;

  // dxbbClearFilters.Caption := S;

  if H is TcxGridBandHeaderHitTest then
  begin
    cxGrid.Hint := (H as TcxGridBandHeaderHitTest).Band.AlternateCaption;
    // обнуляем время на таймере
    Timer.Enabled := False;
    Timer.Enabled := True;
  end
  else
  begin
    GetCursorPos(P);
    Application.ActivateHint(P);
  end;

end;

function TViewParametricTable.GetBand(ALevel: TcxGridLevel;
  AIDParameter: Integer): TcxGridBand;
var
  i: Integer;
begin
  Assert(AIDParameter > 0);
  Assert(ALevel <> nil);
  Result := nil;

  for i := 0 to GridView(ALevel).Bands.Count do
  begin
    Result := GridView(ALevel).Bands[i];

    if Result.Tag = AIDParameter then
    begin
      Break;
    end;
  end;
  Assert(Result <> nil);
end;

procedure TViewParametricTable.DeleteBands;
var
  ABand: TcxGridBand;
begin
  FDefaultVisibleBands.Clear;

  for ABand in FBands do
    ABand.Free;

  FBands.Clear;

  // Бэнды, которые существуют "по умолчанию" прячем
  for ABand in FDefaultCreatedBands do
  begin
    ABand.Visible := False;
    ABand.VisibleForCustomization := False;
  end;

end;

procedure TViewParametricTable.DeleteColumns;
var
  AcxGridDBBandedColumn: TcxGridDBBandedColumn;
begin
  for AcxGridDBBandedColumn in FColumns do
    AcxGridDBBandedColumn.Free;

  FColumns.Clear;

end;

procedure TViewParametricTable.DoAfterBandPosChange(var Message: TMessage);
var
  ABands: TList<TcxGridBand>;
  ACustomizeBandActionEx: TCustomizeBandActionEx;
  AdxBarButton: TdxBarButton;
  AIDParameter: Integer;
  ANewOrder: Integer;
  AQrySearchParamForCat: TQuerySearchParametersForCategory;
  i: Integer;
  IsEdit: Boolean;
  OK: Boolean;
begin
  // Список бэндов-параметров
  ABands := TList<TcxGridBand>.Create;
  try

    // Меняем порядок параметров в БД в соответствии с новым порядком бэндов
    for i := 0 to MainView.Bands.Count - 1 do
    begin
      // Если бэнду соответсвует какой-то параметр категории
      if MainView.Bands[i].VisibleForCustomization then
      begin
        ABands.Add(MainView.Bands[i]);
      end;
    end;

    // Отсортируем эти бэнды в соответствии с их новым местоположением
    ABands.Sort(TComparer<TcxGridBand>.Construct(
      function(const L, R: TcxGridBand): Integer
      begin
        Result := L.Position.ColIndex - R.Position.ColIndex;
      end));

    AQrySearchParamForCat := TQuerySearchParametersForCategory.Create(Self);
    try
      // Ищем все параметры нашей категории
      AQrySearchParamForCat.Search(ComponentsExGroup.qFamilyEx.ParentValue);

      IsEdit := False;
      // Цикл по всем бэндам-параметрам
      for i := 0 to ABands.Count - 1 do
      begin
        ANewOrder := i + 1;
        AIDParameter := ABands[i].Tag;
        Assert(AIDParameter > 0);

        // Если найден параметр соответсвующий бэнду
        OK := AQrySearchParamForCat.FDQuery.LocateEx('UnionParameterID',
          AIDParameter);
        Assert(OK);

        if (AQrySearchParamForCat.FDQueryOrder.AsInteger <> ANewOrder) or
          (AQrySearchParamForCat.FDQueryIsAttribute.AsBoolean <>
          ABands[i].Visible) then
        begin
          AQrySearchParamForCat.FDQuery.Edit;
          AQrySearchParamForCat.FDQueryOrder.AsInteger := ANewOrder;
          AQrySearchParamForCat.FDQueryIsAttribute.AsBoolean :=
            ABands[i].Visible;
          AQrySearchParamForCat.FDQuery.Post;
          IsEdit := True;
        end;

        // Получаем кнопку
        AdxBarButton := dxbrsbtmColumnsCustomization.ItemLinks[i + 2]
          .Item as TdxBarButton;
        // С этой кнопкой должно быть связано дейсвие над бэндом
        Assert(AdxBarButton.Action is TCustomizeBandActionEx);
        ACustomizeBandActionEx := AdxBarButton.Action as TCustomizeBandActionEx;
        // Привязываем это действие к другому бэнду
        ACustomizeBandActionEx.Band := ABands[i];
      end;

    finally
      FreeAndNil(AQrySearchParamForCat);
    end;

  finally
    FreeAndNil(ABands);
  end;

  // Помечаем, что запрос надо будет обновить, даже если мастер не изменится
  if IsEdit then
    ComponentsExGroup.NeedRefresh := True;

end;

procedure TViewParametricTable.DoAfterLoad(Sender: TObject);
var
  ABandCaption: string;
  ACaption: String;
  AHint: String;
  AColumnCaption: string;
  AFieldName: String;
  AIDBand: Integer;
  AQueryParametersForCategory: TQueryParametersForCategory;
  AVisible: Boolean;
begin
  FreeAndNil(FColumnsBarButtons);

  AQueryParametersForCategory := ComponentsExGroup.QueryParametersForCategory;

  cxGrid.BeginUpdate();
  try
    // Сначала удаляем ранее добавленные колонки
    DeleteColumns;
    // Потом удаляем ранее добавленные бэнды
    DeleteBands;

    // AQueryParametersForCategory.Load(ComponentsExGroup.qComponentsEx.ParentValue);
    AQueryParametersForCategory.FDQuery.First;
    while not AQueryParametersForCategory.FDQuery.Eof do
    begin
      // Имя поля получаем из словаря всех имён полей параметров
      AFieldName := ComponentsExGroup.AllParameterFields
        [AQueryParametersForCategory.ID.AsInteger];
      AVisible := AQueryParametersForCategory.IsAttribute.AsBoolean;
      ACaption := IfThen(not AQueryParametersForCategory.TableName.IsNull,
        AQueryParametersForCategory.TableName.AsString,
        AQueryParametersForCategory.Value.AsString);
      AHint := AQueryParametersForCategory.ValueT.AsString;

      // Если это родительский параметр
      if AQueryParametersForCategory.ParentParameter.IsNull then
      begin
        AIDBand := AQueryParametersForCategory.ID.AsInteger;
        ABandCaption := ACaption;
        AColumnCaption := ' ';
      end
      else
      begin
        AIDBand := AQueryParametersForCategory.ParentParameter.AsInteger;
        ABandCaption := AQueryParametersForCategory.Band.AsString;
        AColumnCaption := ACaption;
      end;

      // Создаём колонку в главном представлении
      CreateColumn(MainView, AIDBand, ABandCaption, AColumnCaption, AFieldName,
        AVisible, AHint);

      // Создаём колонку в дочернем представлении
      CreateColumn(cxGridDBBandedTableView2, AIDBand, ABandCaption,
        AColumnCaption, AFieldName, AVisible, AHint);

      AQueryParametersForCategory.FDQuery.Next;
    end;

    MainView.ViewData.Collapse(True);
  finally
    cxGrid.EndUpdate;
  end;
  FColumnsBarButtons := TColumnsBarButtonsEx2.Create(Self,
    dxbrsbtmColumnsCustomization, MainView, cxGridDBBandedTableView2);

  PostMyApplyBestFitEvent;
end;

var
  b: Boolean = False;

procedure TViewParametricTable.DoOnEditValueChanged(Sender: TObject);
var
  AMemo: TcxMemo;
  AStringList: TStringList;
  i: Integer;
  S: string;
begin
  if b then
    Exit;

  b := True;

  AMemo := (Sender as TcxMemo);

  AStringList := TStringList.Create;
  try
    for i := 0 to AMemo.Lines.Count - 1 do
    begin
      AStringList.Add(Format('%s%s%s', [Mark, AMemo.Lines[i].Trim, Mark]));
    end;
    S := AStringList.Text.Trim([#13, #10]);

    AMemo.Text := S;
  finally
    FreeAndNil(AStringList);
  end;

  b := False;

  ApplyBestFitFocusedBand;
  PostMessage(Handle, WM_ON_EDIT_VALUE_CHANGE, 0, 0);
  // UpdateView;
  // ComponentsExGroup.TryPost;
end;

procedure TViewParametricTable.DoOnMasterDetailChange;
begin
  inherited;
  if BaseComponentsGroup <> nil then
  begin
    FMark := ComponentsExGroup.Mark;
    TNotifyEventWrap.Create(ComponentsExGroup.qFamilyEx.AfterLoad, DoAfterLoad,
      FEventList);
    TNotifyEventWrap.Create(ComponentsExGroup.qFamilyEx.AfterOpen, DoAfterLoad,
      FEventList);

    InitializeDefaultCreatedBands(MainView, ComponentsExGroup.qFamilyEx);
    InitializeDefaultCreatedBands
      (cxGridLevel2.GridView as TcxGridDBBandedTableView,
      ComponentsExGroup.qComponentsEx);

    // если данные открыты и не требуют обновления
    if ComponentsExGroup.qFamilyEx.Actual then
    begin
      // Искусственно вызываем событие
      DoAfterLoad(nil);
    end;
  end
end;

procedure TViewParametricTable.FilterByFamily(AFamily: string);
var
  AColumn: TcxGridDBBandedColumn;
  AFilterList: TcxFilterCriteriaItemList;
begin
  Assert(not AFamily.IsEmpty);
  AColumn := MainView.GetColumnByFieldName( ComponentsExGroup.qFamilyEx.Value.FieldName );
  Assert(AColumn <> nil);


  FLockDetailFilterChange := True;
  AFilterList := MainView.DataController.Filter.root;
  AFilterList.Clear;
  AFilterList.BoolOperatorKind := fboAnd;
  AFilterList.AddItem(AColumn, foEqual, AFamily, AFamily);
  FLockDetailFilterChange := False;
end;

function TViewParametricTable.GetComponentsExGroup: TComponentsExGroup;
begin
  Result := BaseComponentsGroup as TComponentsExGroup;
end;

procedure TViewParametricTable.InitializeDefaultCreatedBands
  (AView: TcxGridDBBandedTableView;
AQueryCustomComponents: TQueryCustomComponents);
var
  AColumn: TcxGridDBBandedColumn;
  AFieldName: string;
  AIDParameter: Integer;
begin
  Assert(AView <> nil);
  Assert(AQueryCustomComponents <> nil);

  for AIDParameter in AQueryCustomComponents.ParameterFields.Keys do
  begin
    // Получаем поле, SQL запроса которое является параметром
    AFieldName := ComponentsExGroup.qFamilyEx.ParameterFields[AIDParameter];
    AColumn := AView.GetColumnByFieldName(AFieldName);
    Assert(AColumn <> nil);
    Assert(AColumn.Position.Band <> nil);
    Assert(AColumn.Position.Band.ColumnCount = 1);

    // Помечаем, что бэнд этой колонки принадлежит параметру
    AColumn.Position.Band.Tag := AIDParameter;
    AColumn.Position.Band.Visible := False;
    AColumn.Position.Band.VisibleForCustomization := False;

    // Запоминаем, что этот бэнд существует "по умолчанию"
    if FDefaultCreatedBands.IndexOf(AColumn.Position.Band) < 0 then
      FDefaultCreatedBands.Add(AColumn.Position.Band);
  end;
end;

procedure TViewParametricTable.MyApplyBestFit;
var
  i: Integer;
begin
  MainView.BeginBestFitUpdate;
  try
    for i := 0 to MainView.Bands.Count - 1 do
    begin
      MainView.Bands[i].ApplyBestFit(True);
    end;
    UpdateDetailColumnsWidth;
  finally
    MainView.EndBestFitUpdate;
  end;
end;

procedure TViewParametricTable.OnEditValueChangeProcess(var Message: TMessage);
begin
  inherited;
  ComponentsExGroup.TryPost;
  UpdateView;
end;

procedure TViewParametricTable.SetComponentsExGroup
  (const Value: TComponentsExGroup);
begin
  BaseComponentsGroup := Value;
end;

procedure TViewParametricTable.Timer2Timer(Sender: TObject);
begin
  Timer2.Enabled := False;
  PostMessage(Handle, WM_ON_BAND_POS_CHANGE, 0, 0);
end;

procedure TViewParametricTable.TimerTimer(Sender: TObject);
var
  P: TPoint;
begin
  Timer.Enabled := False;
  GetCursorPos(P);
  Application.ActivateHint(P);
end;

procedure TViewParametricTable.UpdateDetailColumnsWidth2;
var
  ABand: TcxGridBand;
  ADetailColumn: TcxGridDBBandedColumn;
  AMainColumn: TcxGridDBBandedColumn;
  // AView: TcxGridDBBandedTableView;
  dx: Integer;
  i: Integer;
  RealBandWidth: Integer;
  RealColumnWidth: Integer;
begin
  // cxGrid.BeginUpdate();
  // cxGridDBBandedTableView2.BeginBestFitUpdate;
  try

    for i := 0 to cxGridDBBandedTableView2.Bands.Count - 1 do
    begin
      ABand := MainView.Bands[i];
      if ABand.VisibleIndex >= 0 then
      begin
        RealBandWidth := MainView.ViewInfo.HeaderViewInfo.BandsViewInfo.Items
          [ABand.VisibleIndex].Width;
        // - MainView.ViewInfo.FirstItemAdditionalWidth-2;
        dx := ABand.Width - RealBandWidth;

        cxGridDBBandedTableView2.Bands[i].Width := RealBandWidth -
          MainView.ViewInfo.FirstItemAdditionalWidth + dx;

        // AView := GetDBBandedTableView(1);

        // AView.ViewInfo.HeaderViewInfo.BandsViewInfo.Items
        // [ABand.VisibleIndex].Width := RealBandWidth;
      end;
    end;
    (*
      for i := 0 to cxGridDBBandedTableView2.ColumnCount - 1 do
      begin
      AMainColumn := MainView.Columns[i];
      if AMainColumn.VisibleIndex >= 0 then
      begin
      RealColumnWidth := MainView.ViewInfo.HeaderViewInfo.Items
      [AMainColumn.VisibleIndex].Width;

      // if ADetailColumn.VisibleIndex >= 0 then
      // begin
      // cxGridDBBandedTableView2.ViewInfo.HeaderViewInfo.Items
      // [ADetailColumn.VisibleIndex].Width := RealColumnWidth;
      // end
      // else
      //        AMainColumn.Width := RealColumnWidth;
      end;

      end;
      (* *)

    for i := 0 to cxGridDBBandedTableView2.ColumnCount - 1 do
    // изменить размеры колонок у дочерней вью
    begin
      AMainColumn := MainView.Columns[i];
      ADetailColumn := cxGridDBBandedTableView2.Columns[i];

      ADetailColumn.Width := AMainColumn.Width;
      if AMainColumn.VisibleIndex >= 0 then
      begin
        RealColumnWidth := MainView.ViewInfo.HeaderViewInfo.Items
          [AMainColumn.VisibleIndex].Width;

        if AMainColumn.VisibleIndex = 0 then
          Dec(RealColumnWidth, MainView.ViewInfo.FirstItemAdditionalWidth);

        ADetailColumn.Width := RealColumnWidth;
      end;
    end;

    (* *)
  finally
    // cxGridDBBandedTableView2.EndBestFitUpdate;
    // cxGrid.EndUpdate;
  end;
end;

procedure TViewParametricTable.UpdateFiltersAction;
begin
  actClearFilters.Enabled := MainView.DataController.Filter.Active and
    not MainView.DataController.Filter.FilterText.IsEmpty;
end;

procedure TViewParametricTable.UpdateView;
begin
  inherited;
  UpdateFiltersAction;
end;

constructor TShowDefaults.Create(AOwner: TComponent);
begin
  inherited;
  Caption := 'Показать только активные';
  OnExecute := actShowDefaultBandsExecute;
  FDefaultActions := TList<TCustomizeGridViewItemAction>.Create;
end;

destructor TShowDefaults.Destroy;
begin
  inherited;
  FreeAndNil(FDefaultActions);
end;

procedure TShowDefaults.actShowDefaultBandsExecute(Sender: TObject);
var
  AAction: TCustomizeGridViewItemAction;
  AGridView: TcxGridDBBandedTableView;
  IsDefault: Boolean;
begin
  if Actions.Count > 0 then
  begin

    AGridView := Actions[0].GridView;
    Assert(AGridView <> nil);

    AGridView.BeginBestFitUpdate;
    try
      for AAction in Actions do
      begin
        // Ищем очередное действие в списке действий "по умолчанию"
        IsDefault := FDefaultActions.IndexOf(AAction) >= 0;

        // Отображаем или скрываем элемент
        if (not AAction.Checked and IsDefault) or
          (AAction.Checked and not IsDefault) then
          AAction.Execute;
      end;
    finally
      AGridView.EndBestFitUpdate;
    end;
  end;

end;

procedure TShowDefaults.MakeCurrentActionsAsDefault;
var
  AAction: TCustomizeGridViewItemAction;
begin
  Assert(FDefaultActions <> nil);
  for AAction in Actions do
  begin
    if AAction.Checked then
      FDefaultActions.Add(AAction);
  end;
end;

procedure TColumnsBarButtonsEx2.CreateGridViewActions;
begin
  // Добавляем действие "Спрятать все колонки"
  inherited;
  // Добавляем действие "Показать бэнды по умолчанию"
  FShowDefaults := CreateGridViewAction(TShowDefaults) as TShowDefaults;
end;

procedure TColumnsBarButtonsEx2.ProcessGridView;
begin
  inherited;
  FShowDefaults.MakeCurrentActionsAsDefault;
end;

constructor TFilterItem.Create(AColumn: TcxGridDBBandedColumn;
AFilterOperatorKind: TcxFilterOperatorKind; AValue: Variant);
begin
  inherited Create;
  Assert(AColumn <> nil);

  FColumn := AColumn;
  FFilterOperatorKind := AFilterOperatorKind;
  FValue := AValue;
end;

end.
