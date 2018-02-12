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
  cxExtEditRepositoryItems, CustomComponentsQuery, cxBlobEdit,
  System.Generics.Defaults, BandsInfo, DBRecordHolder,
  BaseQuery, ParameterKindEnum, Vcl.Clipbrd, cxButtons,
  CategoryParametersQuery2;

const
  WM_ON_EDIT_VALUE_CHANGE = WM_USER + 61;
  WM_ON_BAND_POS_CHANGE = WM_USER + 62;

type
  TViewParametricTable = class(TViewComponentsBase)
    actAutoWidth: TAction;
    dxbrbtnApplyUpdates: TdxBarButton;
    dxbbFullAnalog: TdxBarButton;
    actFullAnalog: TAction;
    actClearFilters: TAction;
    actAnalog: TAction;
    dxBarButton2: TdxBarButton;
    dxbbClearFilters: TdxBarButton;
    BandTimer: TTimer;
    dxBarButton1: TdxBarButton;
    actLocateInStorehouse: TAction;
    cxStyleRepository: TcxStyleRepository;
    cxStyleBegin: TcxStyle;
    cxStyleEnd: TcxStyle;
    dxBarButton3: TdxBarButton;
    clAnalog: TcxGridDBBandedColumn;
    clAnalog2: TcxGridDBBandedColumn;
    dxBarButton4: TdxBarButton;
    actRefresh: TAction;
    dxBarButton5: TdxBarButton;
    actClearSelected: TAction;
    N6: TMenuItem;
    procedure actAutoWidthExecute(Sender: TObject);
    procedure actClearFiltersExecute(Sender: TObject);
    procedure actFullAnalogExecute(Sender: TObject);
    procedure actLocateInStorehouseExecute(Sender: TObject);
    procedure actAnalogExecute(Sender: TObject);
    procedure actClearSelectedExecute(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
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
    procedure BandTimerTimer(Sender: TObject);
    procedure cxGridDBBandedTableViewColumnHeaderClick(Sender: TcxGridTableView;
      AColumn: TcxGridColumn);
    procedure cxGridDBBandedTableViewStylesGetContentStyle
      (Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
      AItem: TcxCustomGridTableItem; var AStyle: TcxStyle);
    procedure cxGridDBBandedTableViewStylesGetHeaderStyle
      (Sender: TcxGridTableView; AColumn: TcxGridColumn; var AStyle: TcxStyle);
    // TODO: cxGridDBBandedTableViewDataControllerFilterChanged
    // procedure cxGridDBBandedTableViewDataControllerFilterChanged
    // (Sender: TObject);
  private
    FBandInfo: TBandInfo;
    FBandsInfo: TBandsInfo;
    FColumns: TList<TcxGridDBBandedColumn>;
    FLockDetailFilterChange: Boolean;
    FMark: string;
    procedure CreateColumn(AView: TcxGridDBBandedTableView;
      AIDParameter: Integer; const ABandCaption, AColumnCaption,
      AFieldName: String; AVisible: Boolean; const ABandHint: string;
      ACategoryParamID, AOrder, APosID, AIDParameterKind, AColumnID: Integer;
      const AColumnHint: String);
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
    procedure UpdateColumnsCustomization;
    { Private declarations }
  protected
    procedure ApplyFilter;
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
    procedure OnGridPopupMenuPopup(AColumn: TcxGridDBBandedColumn); override;
    procedure UpdateDetailColumnsWidth2;
    procedure UpdateFiltersAction;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure FilterByFamily(AFamily: string);
    procedure FilterByComponent(AComponent: string);
    procedure MyApplyBestFit; override;
    procedure UpdateView; override;
    property ComponentsExGroup: TComponentsExGroup read GetComponentsExGroup
      write SetComponentsExGroup;
    property Mark: string read FMark;
    { Public declarations }
  end;

  TShowDefaults = class(TGroupGVAction)
  private
    FDefaultActions: TList<TGVAction>;
  protected
    procedure actShowDefaultBandsExecute(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure MakeCurrentActionsAsDefault;
    property DefaultActions: TList<TGVAction> read FDefaultActions;
  end;

  TColumnsBarButtonsEx2 = class(TGVColumnsBarButtonsEx)
  private
    FShowDefaults: TShowDefaults;
  protected
    procedure CreateGroupActions; override;
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
  SearchParametersForCategoryQuery, GridExtension, DragHelper, System.Math,
  AnalogForm, AnalogQueryes, AnalogGridView, SearchProductByParamValuesQuery,
  NaturalSort, CategoryParametersGroupUnit, FireDAC.Comp.Client;

constructor TViewParametricTable.Create(AOwner: TComponent);
begin
  inherited;

  FColumns := TList<TcxGridDBBandedColumn>.Create;
  FBandsInfo := TBandsInfo.Create;

  ApplyBestFitMultiLine := True;
end;

destructor TViewParametricTable.Destroy;
begin
  FreeAndNil(FColumns);
  FreeAndNil(FBandsInfo);
  inherited;
end;

procedure TViewParametricTable.actAutoWidthExecute(Sender: TObject);
begin
  PostMyApplyBestFitEvent;
end;

procedure TViewParametricTable.actClearFiltersExecute(Sender: TObject);
begin
  MainView.DataController.Filter.Clear;
  GridView(cxGridLevel2).DataController.Filter.Clear;
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

      if (AColumn.Visible) and (AColumn.Position.Band <> nil) and
        (FBandsInfo.Search(AColumn.Position.Band) <> nil) then
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

procedure TViewParametricTable.actLocateInStorehouseExecute(Sender: TObject);
begin
  inherited;
  ComponentsExGroup.qComponentsEx.LocateInStorehouse;
end;

procedure TViewParametricTable.actAnalogExecute(Sender: TObject);
var
  ABand: TcxGridBand;
  ABI: TBandInfo;
  AColumn: TcxGridDBBandedColumn;
  AfrmAnalog: TfrmAnalog;
  AIDParameter: Integer;
  AnalogGroup: TAnalogGroup;
  AProductCategoryID: Integer;
  ARecHolder: TRecordHolder;
  AValue: string;
  AView: TcxGridDBBandedTableView;
  i: Integer;
  j: Integer;
  m: TArray<String>;
  OK: Boolean;
  P: Integer;
  S: string;
  V: Variant;
begin
  ComponentsExGroup.TryPost;

  AnalogGroup := TAnalogGroup.Create(Self);
  try

    AProductCategoryID := ComponentsExGroup.qFamilyEx.ParentValue;

    ARecHolder := TRecordHolder.Create();
    try
      if MainView.Focused then
        AView := MainView
      else
        AView := GridView(cxGridLevel2);

      // Assert(AView.Focused);

      // Цикл по всем бэндам сфокусированного табличного представления
      for i := 0 to AView.Bands.Count - 1 do
      begin
        ABand := AView.Bands[i];

        if not ABand.Visible then
          Continue;

        // Получаем информацию о бэнде
        ABI := FBandsInfo.Search(ABand);

        // Этот бэнд не является бэндом-параметром
        if ABI = nil then
          Continue;

        Assert(ABI <> nil);
        Assert(ABI.IDParameterKind >= Integer(Неиспользуется));
        Assert(ABI.IDParameterKind <= Integer(Строковый_частичный));

        if ABI.IDParameterKind = Integer(Неиспользуется) then
          Continue;

        // Каждый бэнд-параметр может иметь несколько колонок-подпараметров
        Assert(ABand.ColumnCount >= 1);
        for P := 0 to ABand.ColumnCount - 1 do
        begin
          AColumn := ABand.Columns[P] as TcxGridDBBandedColumn;
          AIDParameter := AColumn.Tag;
          Assert(AIDParameter > 0);

          // Получаем значение очередной колонки сфокусированной записи
          V := FocusedTableView.Controller.FocusedRecord.Values[AColumn.Index];

          if VarIsNull(V) then
          begin
            // Пустое значение у семейства - не используем при поиске аналога
            if FocusedTableView = MainView then
              Continue;

            Assert(FocusedTableView.Level = cxGridLevel2);
            // Пустое значение у компонента - берем значение из семейства
            // Ищем бэнд у семейства
            ABI := FBandsInfo.Search(MainView, ABI.ParameterID);
            Assert(ABI <> nil);
            ABand := ABI.Band;
            Assert(ABand.ColumnCount >= P);
            // Берём такую-же колонку
            AColumn := ABand.Columns[P] as TcxGridDBBandedColumn;
            // Это должен-быть тот-же самый параметр
            Assert(AIDParameter = AColumn.Tag);

            // Получаем значение очередной колонки у семейства
            V := MainView.Controller.FocusedRecord.Values[AColumn.Index];

            // Пустое значение у семейства - не используем при поиске аналога
            if VarIsNull(V) then
              Continue;
          end;

          // Избавляемся от маркеров в значении
          AValue := '';
          m := VarToStr(V).Split([#13, #10]);
          for j := Low(m) to High(m) do
          begin
            S := m[j].Trim([Mark.Chars[0], #13, #10]);
            if S.IsEmpty then
              Continue;

            AValue := Format('%s'#13#10'%s', [AValue, S]);
          end;
          AValue := AValue.Trim([#13, #10]);

          // Добавляем значение поля в коллекции
          TFieldHolder.Create(ARecHolder,
            AnalogGroup.GetFieldName(AIDParameter), AValue);
        end;

      end;

      // Загружаем значения параметров для текущей категории
      AnalogGroup.Load(AProductCategoryID, ARecHolder);

      AfrmAnalog := TfrmAnalog.Create(Self);
      try
        AfrmAnalog.ViewAnalogGrid.AnalogGroup := AnalogGroup;
        OK := AfrmAnalog.ShowModal = mrOk;
      finally
        FreeAndNil(AfrmAnalog);
      end;
    finally
      FreeAndNil(ARecHolder);
    end;

    if OK then
    begin
      AnalogGroup.ApplyFilter;
      ComponentsExGroup.ReOpen;
      // RefreshData; // Перечитываем данные о найденных аналогов из бд
      ApplyFilter;
      UpdateView;
      {
        q := TQueryBase.Create(Self);
        try
        q.FDQuery.SQL.Text := Format('SELECT FamilyID FROM FamilyAnalog',
        [AnalogGroup.TempTableName]);

        q.RefreshQuery;

        Assert(q.FDQuery.RecordCount > 0);
        // Создаём вариантный массив
        AFilterValues := VarArrayCreate([0, q.FDQuery.RecordCount - 1],
        varInteger);
        // Надо наложить фильтр
        for i := 1 to q.FDQuery.RecordCount do
        begin
        q.FDQuery.RecNo := i;
        AFilterValues[i - 1] := q.Field('FamilyID').AsInteger;
        end;

        q.FDQuery.SQL.Text := Format('SELECT distinct ProductID FROM %s',
        [AnalogGroup.TempTableName]);

        q.RefreshQuery;

        Assert(q.FDQuery.RecordCount > 0);
        // Создаём вариантный массив
        AFilterValues2 := VarArrayCreate([0, q.FDQuery.RecordCount - 1],
        varInteger);
        // Надо наложить фильтр
        for i := 1 to q.FDQuery.RecordCount do
        begin
        q.FDQuery.RecNo := i;
        AFilterValues2[i - 1] := q.Field('ProductID').AsInteger;
        end;

        ApplyFilter(AFilterValues, AFilterValues2);
        finally
        FreeAndNil(q);
        end;
      }
    end;

  finally
    FreeAndNil(AnalogGroup);
  end;
end;

procedure TViewParametricTable.actClearSelectedExecute(Sender: TObject);
var
  AColumn: TcxGridDBBandedColumn;
  AFieldList: TList<String>;
  AFieldName: String;
  AProductID: Integer;
  AProductIDList: TList<Integer>;
  AView: TcxGridDBBandedTableView;
  j: Integer;
  // qParametersForCategory: TQueryParametersForCategory;
  qCategoryParameters: TQueryCategoryParameters2;
  V: Variant;
begin
  inherited;
  AView := FocusedTableView;

  AFieldList := TList<String>.Create;
  try
    qCategoryParameters := ComponentsExGroup.CatParamsGroup.qCategoryParameters;
    qCategoryParameters.FDQuery.First;
    while not qCategoryParameters.FDQuery.Eof do
    begin
      qCategoryParameters.FDQuery.Next;

      // Имя поля получаем из словаря всех имён полей параметров
      AFieldName := ComponentsExGroup.AllParameterFields
        [qCategoryParameters.ParamSubParamId.AsInteger];

      AColumn := AView.GetColumnByFieldName(AFieldName);

      if AColumn.Selected then
        AFieldList.Add(AFieldName);

      qCategoryParameters.FDQuery.Next;

    end;

    {
      qParametersForCategory := ComponentsExGroup.qParametersForCategory;
      qParametersForCategory.FDQuery.First;
      while not qParametersForCategory.FDQuery.Eof do
      begin
      // Имя поля получаем из словаря всех имён полей параметров
      AFieldName := ComponentsExGroup.AllParameterFields
      [qParametersForCategory.ParameterID.AsInteger];

      AColumn := AView.GetColumnByFieldName(AFieldName);

      if AColumn.Selected then
      AFieldList.Add(AFieldName);

      qParametersForCategory.FDQuery.Next;
      end;
    }
    AProductIDList := TList<Integer>.Create;
    try
      // Цикл по всем выделенным строкам
      for j := 0 to AView.Controller.SelectedRowCount - 1 do
      begin
        V := AView.Controller.SelectedRows[j].Values[clID.Index];
        Assert(not VarIsNull(V));

        AProductID := V;
        AProductIDList.Add(AProductID);
      end;

      BeginUpdate;
      try
        FocusedQuery.ClearFields(AFieldList, AProductIDList);
      finally
        EndUpdate;
      end;

    finally
      FreeAndNil(AProductIDList);
    end;
  finally
    FreeAndNil(AFieldList);
  end;
  UpdateView;
end;

procedure TViewParametricTable.actRefreshExecute(Sender: TObject);
begin
  inherited;
  RefreshData;
end;

procedure TViewParametricTable.ApplyFilter;
var
  AColumn: TcxGridDBBandedColumn;
  FilterRoot: TcxFilterCriteriaItemList;
begin
  // Накладываем фильтр на семейства
  FilterRoot := MainView.DataController.Filter.root;
  FilterRoot.Clear;

  AColumn := MainView.GetColumnByFieldName(clAnalog.DataBinding.FieldName);

  FilterRoot.AddItem(AColumn, foEqual, 1, 'Да');
  MainView.DataController.Filter.Active := True;

  // Накладываем фильтр на компоненты
  FilterRoot := GridView(cxGridLevel2).DataController.Filter.root;
  FilterRoot.Clear;

  AColumn := GridView(cxGridLevel2).GetColumnByFieldName
    (clAnalog2.DataBinding.FieldName);

  FilterRoot.AddItem(AColumn, foEqual, 1, 'Да');
  GridView(cxGridLevel2).DataController.Filter.Active := True;
end;

procedure TViewParametricTable.DoOnGetFilterValues
  (Sender: TcxCustomGridTableItem; AValueList: TcxDataFilterValueList);
var
  ADisplayText: string;
  i: Integer;
  AKind: TcxFilterValueItemKind;
  ANewDisplayText: string;
  AValue: Variant;
  // AValues: TList<String>;
  m: TArray<String>;
  S: string;
begin
  inherited;
  Assert(not FMark.IsEmpty);

  // AValues := TList<String>.Create;
  // try
  SortSL.Clear;
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
            if SortSL.IndexOf(ANewDisplayText) = -1 then
            begin
              SortSL.Add(ANewDisplayText);
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

  // Сортируем варианты фильтров
  SortSL.Sort(TNaturalStringComparer.Create);

  for S in SortSL do
  begin
    AValueList.Add(fviUserEx, Format('%%%s%s%s%%', [Mark, S, Mark]), S, False);
  end;

  // finally
  // FreeAndNil(AValues);
  // end;

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
  AIDParameter: Integer; const ABandCaption, AColumnCaption, AFieldName: String;
  AVisible: Boolean; const ABandHint: string; ACategoryParamID, AOrder, APosID,
  AIDParameterKind, AColumnID: Integer; const AColumnHint: String);
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
    ABandInfo.IDParameterKind := AIDParameterKind;
    ABand.Visible := AVisible;
    ABand.VisibleForCustomization := True;
    ABand.Caption := DeleteDouble(ABandCaption, ' ');
    ABand.AlternateCaption := ABandHint;
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
    AColumn.HeaderAlignmentHorz := taCenter;
    AColumn.AlternateCaption := AColumnHint;
    AColumn.Tag := AColumnID;
    AColumn.DataBinding.FieldName := AFieldName;
    // В режиме просмотра убираем ограничители
    AColumn.OnGetDataText := DoOnGetDataText;

    if AView = MainView then
    begin
      AColumn.PropertiesClass := TcxMemoProperties;
      (AColumn.Properties as TcxMemoProperties).WordWrap := False;
      (AColumn.Properties as TcxMemoProperties).OnEditValueChanged :=
        DoOnEditValueChanged;
      AColumn.OnUserFilteringEx := DoOnUserFilteringEx;
      AColumn.OnGetFilterValues := DoOnGetFilterValues;
    end
    else
    begin
      AColumn.PropertiesClass := TcxTextEditProperties;
    end;
    FColumns.Add(AColumn);
  end
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
var
  ABandInfo, ADaughterBandInfo: TBandInfo;
  ABI: TBandInfo;
  L: TBandsInfo;
begin
  inherited;
  // Ищем информацию о перемещаемом бэнде
  ABandInfo := FBandsInfo.Search(ABand);
  // Перемещать можно только бэнд-параметр
  Assert(ABandInfo <> nil);

  L := FBandsInfo.GetChangedColIndex(ABand.GridView);
  try
    // Если переместили в другую группу или предыдущий запрос ещё не обработан
    if (L.HaveDifferentPos) or (BandTimer.Enabled) then
    begin
      // Возвращаем колонки на место
      for ABI in L do
        ABI.Band.Position.ColIndex := ABI.ColIndex;
      Exit;
    end;
  finally
    FreeAndNil(L);
  end;

  // Ищем соответствующий дочерний бэнд
  ADaughterBandInfo := FBandsInfo.Search(GridView(cxGridLevel2),
    ABandInfo.ParameterID);
  Assert(ADaughterBandInfo <> nil);
  // Меняем позицию дочернего бэнда
  ADaughterBandInfo.Band.Position.ColIndex := ABand.Position.ColIndex;

  // Сообщаем что изменение бэндов нужно будет дополнительно обработать
  FBandInfo := ABandInfo;
  BandTimer.Enabled := True;
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

procedure TViewParametricTable.cxGridDBBandedTableViewStylesGetContentStyle
  (Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
  AItem: TcxCustomGridTableItem; var AStyle: TcxStyle);
var
  ABI: TBandInfo;
  AColumn: TcxGridDBBandedColumn;
begin
  inherited;
  if (ARecord = nil) or (AItem = nil) or (not ARecord.IsData) then
    Exit;

  if not(AItem is TcxGridDBBandedColumn) then
    Exit;

  AColumn := AItem as TcxGridDBBandedColumn;

  ABI := FBandsInfo.Search(AColumn.Position.Band);
  if ABI = nil then
    Exit;
  // Assert(ABI <> nil);

  case ABI.Pos of
    0:
      AStyle := cxStyleBegin;
    2:
      AStyle := cxStyleEnd;
  end;

end;

procedure TViewParametricTable.cxGridDBBandedTableViewStylesGetHeaderStyle
  (Sender: TcxGridTableView; AColumn: TcxGridColumn; var AStyle: TcxStyle);
begin
  inherited;;
end;

procedure TViewParametricTable.DeleteBands;
begin
  // Бэнды, которые не существуют "по умолчанию" удаляем
  FBandsInfo.FreeNotDefaultBands;

  // Бэнды, которые существуют "по умолчанию" прячем
  FBandsInfo.HideDefaultBands;
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
  AGVBandActionEx: TGVBandActionEx;
  AdxBarButton: TdxBarButton;
  AIDParameter: Integer;
  ANewOrder: Integer;
  AQrySearchParamForCat: TQuerySearchParametersForCategory;
  i: Integer;
  IsEdit: Boolean;
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
        AQrySearchParamForCat.LocateByParameterID(AIDParameter, True);

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
        AdxBarButton := dxbsColumns.ItemLinks[i + 2].Item as TdxBarButton;
        // С этой кнопкой должно быть связано дейсвие над бэндом
        Assert(AdxBarButton.Action is TGVBandActionEx);
        AGVBandActionEx := AdxBarButton.Action as TGVBandActionEx;
        // Привязываем это действие к другому бэнду
        AGVBandActionEx.Band := ABands[i];
      end;

    finally
      FreeAndNil(AQrySearchParamForCat);
    end;

  finally
    FreeAndNil(ABands);
  end;

  // Обновляем запрос, если есть клиенты
  if IsEdit then
    ComponentsExGroup.TryRefresh;
end;

procedure TViewParametricTable.DoAfterLoad(Sender: TObject);
var
  ABandCaption: string;
  ABandHint: string;
  ABandInfo: TBandInfo;
  // ACaption: String;
  ACategoryParamID: Integer;
  AClone: TFDMemTable;
  AColumnHint: String;
  AColumnCaption: string;
  AColumnID: Integer;
  AFieldName: String;
  AIDBand: Integer;
  AIDParameterKind: Integer;
  AOrder: Integer;
  AParamSubParamId: Integer;
  APosID: Integer;
  // qParametersForCategory: TQueryParametersForCategory;
  qCategoryParameters: TQueryCategoryParameters2;
  qCatParams: TQryCategoryParameters;
  // qCatSubParams: TQryCategorySubParameters;
  AVisible: Boolean;
begin
  FreeAndNil(FColumnsBarButtons);

  qCategoryParameters := ComponentsExGroup.CatParamsGroup.qCategoryParameters;

  // qParametersForCategory := ComponentsExGroup.qParametersForCategory;

  cxGrid.BeginUpdate();
  try
    // Сначала удаляем ранее добавленные колонки
    DeleteColumns;
    // Потом удаляем ранее добавленные бэнды
    DeleteBands;

    // qParametersForCategory.Load(ComponentsExGroup.qComponentsEx.ParentValue);

    // qParametersForCategory.FDQuery.First;

    ComponentsExGroup.CatParamsGroup.LoadData;
    qCatParams := ComponentsExGroup.CatParamsGroup.qCatParams;

    Assert(qCatParams.RecordCount > 0);
    qCatParams.First;
    // Цикл по бэндам (параметрам)
    while not qCatParams.Eof do
    begin
      qCategoryParameters.LocateByPK(qCatParams.ID.AsInteger);
      // Получаем все подпараметры текущего бэнда
      AClone := qCategoryParameters.CreateSubParamsClone;
      try
        while not AClone.Eof do
        begin
          // Имя поля получаем из словаря всех имён полей параметров
          AParamSubParamId := AClone.FieldByName
            (qCategoryParameters.ParamSubParamId.FieldName).AsInteger;
          AFieldName := ComponentsExGroup.AllParameterFields[AParamSubParamId];
          AVisible := AClone.FieldByName
            (qCategoryParameters.IsAttribute.FieldName).AsInteger = 1;
          ABandCaption := AClone.FieldByName
            (qCategoryParameters.Value.FieldName).AsString;
          AColumnCaption := AClone.FieldByName
            (qCategoryParameters.Name.FieldName).AsString;

          // Иначе грид отображает имя поля
          if AColumnCaption.IsEmpty then
            AColumnCaption := ' ';

          ABandHint := AClone.FieldByName
            (qCategoryParameters.ValueT.FieldName).AsString;
          AColumnHint := AClone.FieldByName
            (qCategoryParameters.Translation.FieldName).AsString;
          AOrder := AClone.FieldByName(qCategoryParameters.Ord.FieldName)
            .AsInteger;
          APosID := AClone.FieldByName(qCategoryParameters.PosID.FieldName)
            .AsInteger;
          ACategoryParamID := APosID;
          // qParametersForCategory.IDCategory.AsInteger;
          // Как искать аналог для этого параметра
          AIDParameterKind := AClone.FieldByName
            (qCategoryParameters.IDParameterKind.FieldName).AsInteger;
          // Идентификатор бэнда
          AIDBand := qCatParams.ID.AsInteger;
          AColumnID := AParamSubParamId;

          // Создаём колонку в главном представлении
          CreateColumn(MainView, AIDBand, ABandCaption, AColumnCaption,
            AFieldName, AVisible, ABandHint, ACategoryParamID, AOrder, APosID,
            AIDParameterKind, AColumnID, AColumnHint);

          // Создаём колонку в дочернем представлении
          CreateColumn(GridView(cxGridLevel2), AIDBand, ABandCaption,
            AColumnCaption, AFieldName, AVisible, ABandHint, ACategoryParamID,
            AOrder, APosID, AIDParameterKind, AColumnID, AColumnHint);

          AClone.Next;
        end;
      finally
        qCategoryParameters.DropClone(AClone);
      end;
      qCatParams.Next;
      {
        // Вот тут странная ошибка может произойти - пустой порядок
        if qParametersForCategory.Ord.IsNull then
        begin
        qParametersForCategory.FDQuery.Next;
        Continue;
        end;

        Assert(not qParametersForCategory.Ord.IsNull);

        AOrder := qParametersForCategory.Ord.AsInteger;
        APosID := qParametersForCategory.PosID.AsInteger;
        // Как искать аналог для этого параметра
        AIDParameterKind := qParametersForCategory.IDParameterKind.AsInteger;
        // Идентификатор параметра или подпараметра
        AColumnID := qParametersForCategory.ParameterID.AsInteger;

        // Если это родительский параметр
        if qParametersForCategory.ParentParameter.IsNull then
        begin
        AIDBand := AColumnID;
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
        AVisible, ABandHint, ACategoryParamID, AOrder, APosID, AIDParameterKind,
        AColumnID, AColumnHint);

        // Создаём колонку в дочернем представлении
        CreateColumn(GridView(cxGridLevel2), AIDBand, ABandCaption,
        AColumnCaption, AFieldName, AVisible, ABandHint, ACategoryParamID,
        AOrder, APosID, AIDParameterKind, AColumnID, AColumnHint);

        qParametersForCategory.FDQuery.Next;
      }
    end;

    // запоминаем в какой позиции находится наш бэнд
    for ABandInfo in FBandsInfo do
      ABandInfo.ColIndex := ABandInfo.Band.Position.ColIndex;

  finally
    MainView.ViewData.Collapse(True);
    cxGrid.EndUpdate;
    PostMyApplyBestFitEvent;
    FColumnsBarButtons := TColumnsBarButtonsEx2.Create(Self, dxbsColumns,
      MainView, cxGridDBBandedTableView2);
  end;
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
  AColumn := MainView.GetColumnByFieldName
    (ComponentsExGroup.qFamilyEx.Value.FieldName);
  Assert(AColumn <> nil);

  FLockDetailFilterChange := True;
  try
    AFilterList := MainView.DataController.Filter.root;
    AFilterList.Clear;
    AFilterList.BoolOperatorKind := fboAnd;
    AFilterList.AddItem(AColumn, foEqual, AFamily, AFamily);
    MainView.DataController.Filter.Active := True;
  finally
    FLockDetailFilterChange := False;
  end;
end;

procedure TViewParametricTable.FilterByComponent(AComponent: string);
var
  AColumn: TcxGridDBBandedColumn;
  AFilterList: TcxFilterCriteriaItemList;
  ARow: TcxMyGridMasterDataRow;
  AView: TcxGridDBBandedTableView;
begin
  Assert(not AComponent.IsEmpty);

  AColumn := GridView(cxGridLevel2).GetColumnByFieldName
    (ComponentsExGroup.qComponentsEx.Value.FieldName);
  Assert(AColumn <> nil);

  FLockDetailFilterChange := True;
  try
    AFilterList := GridView(cxGridLevel2).DataController.Filter.root;
    AFilterList.Clear;
    AFilterList.BoolOperatorKind := fboAnd;
    AFilterList.AddItem(AColumn, foEqual, AComponent, AComponent);
    GridView(cxGridLevel2).DataController.Filter.Active := True;
  finally
    FLockDetailFilterChange := False;
  end;

  // Разворачиваем представление компонентов
  ARow := GetRow(0) as TcxMyGridMasterDataRow;
  Assert(ARow <> nil);
  AView := GetDBBandedTableView(1);
  ARow.MyExpand(False);
  AView.Focused := True;
end;

function TViewParametricTable.GetComponentsExGroup: TComponentsExGroup;
begin
  Result := BaseComponentsGroup as TComponentsExGroup;
end;

procedure TViewParametricTable.InitializeDefaultCreatedBands
  (AView: TcxGridDBBandedTableView;
AQueryCustomComponents: TQueryCustomComponents);
var
  ABandInfo: TBandInfo;
  AColumn: TcxGridDBBandedColumn;
  AFieldName: string;
  AIDParameter: Integer;
begin
  Assert(AView <> nil);
  Assert(AQueryCustomComponents <> nil);

  // Цикл по всем полям запроса, которые являются параметрами
  for AIDParameter in AQueryCustomComponents.ParameterFields.Keys do
  begin
    // Получаем поле, SQL запроса которое является параметром
    AFieldName := ComponentsExGroup.qFamilyEx.ParameterFields[AIDParameter];
    AColumn := AView.GetColumnByFieldName(AFieldName);
    Assert(AColumn <> nil);
    Assert(AColumn.Position.Band <> nil);
    Assert(AColumn.Position.Band.ColumnCount = 1);

    // Помечаем, что бэнд этой колонки принадлежит параметру
    ABandInfo := TBandInfo.Create(AColumn.Position.Band, AIDParameter);
    // Помечаем что бэнд этой колонки существует "по умолчанию"
    ABandInfo.DefaultCreated := True;
    FBandsInfo.Add(ABandInfo);
    AColumn.Position.Band.Visible := False;
    AColumn.Position.Band.VisibleForCustomization := False;
    AColumn.Tag := AIDParameter;
  end;
end;

procedure TViewParametricTable.MyApplyBestFit;
// var
// i: Integer;
begin
  {
    for i := 0 to MainView.Bands.Count - 1 do
    begin
    MainView.Bands[i].ApplyBestFit(True);
    end;
  }
  Inherited;
  UpdateDetailColumnsWidth;
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

procedure TViewParametricTable.BandTimerTimer(Sender: TObject);
var
  ABandInfo: TBandInfo;
  AOrder: Integer;
  BIList: TBandsInfo;
  i: Integer;
  L: TList<TRecOrder>;
  X: Integer;
  AReverse: Integer;
begin
  BandTimer.Enabled := False;

  Assert(FBandInfo <> nil);
  Assert(FBandInfo.ColIndex <> FBandInfo.Band.Position.ColIndex);

  BIList := FBandsInfo.GetChangedColIndex(MainView);
  try
    // Как минимум 2 бэнда должны были поменять свою позицию
    Assert(BIList.Count >= 2);

    // Куда произошло перемещение: влево или вправо?
    AReverse := System.Math.IfThen(FBandInfo.ColIndex >
      FBandInfo.Band.Position.ColIndex, -1, 1);

    // Бэнды нужно отсортировать по их позициям до переноса
    BIList.Sort(TComparer<TBandInfo>.Construct(
      function(const Left, Right: TBandInfo): Integer
      begin
        Result := AReverse * (Left.ColIndex - Right.ColIndex);
      end));

    // Первым элементом списка должен стать тот, который мы перетаскивали
    Assert(BIList.First = FBandInfo);

    L := TList<TRecOrder>.Create;
    try
      // Меняем порядок записи на противоположный
      AOrder := BIList.First.Order;
      L.Add(TRecOrder.Create(BIList.First.CategoryParamID, -AOrder));
      // Смещаем остальные записи
      for i := 1 to BIList.Count - 1 do
      begin
        ABandInfo := BIList[i];
        L.Add(TRecOrder.Create(ABandInfo.CategoryParamID, AOrder));
        // Обмен местами
        X := ABandInfo.Order;
        ABandInfo.Order := AOrder;
        AOrder := X;
      end;
      L.Add(TRecOrder.Create(BIList.First.CategoryParamID, AOrder));
      BIList.First.Order := AOrder;

      ComponentsExGroup.OnParamOrderChange.CallEventHandlers(L);

      // запоминаем в какой позиции находится наш бэнд
      for ABandInfo in FBandsInfo do
        ABandInfo.ColIndex := ABandInfo.Band.Position.ColIndex;
    finally
      FreeAndNil(L);
    end;
  finally
    FreeAndNil(BIList);
  end;

  // Обновляем порядок бэндов в выпадающем списке
  UpdateColumnsCustomization;
end;

procedure TViewParametricTable.cxGridDBBandedTableViewColumnHeaderClick
  (Sender: TcxGridTableView; AColumn: TcxGridColumn);
begin;
  inherited;
end;

procedure TViewParametricTable.OnGridPopupMenuPopup
  (AColumn: TcxGridDBBandedColumn);
Var
  AColumnIsValue: Boolean;
begin
  inherited;

  AColumnIsValue := (AColumn <> nil) and
    (AColumn.DataBinding.FieldName = clValue.DataBinding.FieldName);

  actClearSelected.Visible := (AColumn <> nil) and not(AColumnIsValue);
  actClearSelected.Enabled := actClearSelected.Visible;
end;

procedure TViewParametricTable.UpdateColumnsCustomization;
var
  ABI: TBandInfo;
  AGVBandActionEx: TGVBandActionEx;
  AdxBarButton: TdxBarButton;
  i: Integer;
begin
  // Сортируем все бэнды слева на право
  FBandsInfo.Sort(TComparer<TBandInfo>.Construct(
    function(const Left, Right: TBandInfo): Integer
    begin
      Result := (Left.ColIndex - Right.ColIndex);
    end));

  // Начиная с 3-ей кнопки
  i := 2;
  for ABI in FBandsInfo do
  begin
    if ABI.Band.GridView <> MainView then
      Continue;

    // Получаем кнопку
    AdxBarButton := dxbsColumns.ItemLinks[i].Item as TdxBarButton;

    // С этой кнопкой должно быть связано дейсвие над бэндом
    Assert(AdxBarButton.Action is TGVBandActionEx);
    AGVBandActionEx := AdxBarButton.Action as TGVBandActionEx;

    // Привязываем это действие к другому бэнду
    AGVBandActionEx.Band := ABI.Band;
    Inc(i);
    if i >= dxbsColumns.ItemLinks.Count then
      break;
  end;
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
var
  OK: Boolean;
begin
  inherited;

  OK := (ComponentsExGroup <> nil) and
    (ComponentsExGroup.qFamilyEx.FDQuery.Active) and
    (ComponentsExGroup.qComponentsEx.FDQuery.Active);
  UpdateFiltersAction;
  actLocateInStorehouse.Enabled := OK and
    (FocusedTableView.Level = cxGridLevel2) and
    (FocusedTableView.DataController.RecordCount > 0);
  // and (GridView(cxGridLevel2).DataController.RecordCount > 0);

  // Поиск аналога только если всё сохранено
  actAnalog.Enabled := OK and not actCommit.Enabled;
end;

constructor TShowDefaults.Create(AOwner: TComponent);
begin
  inherited;
  Caption := 'Показать только активные';
  OnExecute := actShowDefaultBandsExecute;
  FDefaultActions := TList<TGVAction>.Create;
end;

destructor TShowDefaults.Destroy;
begin
  inherited;
  FreeAndNil(FDefaultActions);
end;

procedure TShowDefaults.actShowDefaultBandsExecute(Sender: TObject);
var
  AAction: TGVAction;
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
  AAction: TGVAction;
begin
  Assert(FDefaultActions <> nil);
  for AAction in Actions do
  begin
    if AAction.Checked then
      FDefaultActions.Add(AAction);
  end;
end;

procedure TColumnsBarButtonsEx2.CreateGroupActions;
begin
  // Добавляем действие "Спрятать все колонки"
  inherited;
  // Добавляем действие "Показать бэнды по умолчанию"
  FShowDefaults := CreateGroupAction(TShowDefaults) as TShowDefaults;
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
