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
    actAddSubParameter: TAction;
    actDropSubParameter: TAction;
    pmHeaders: TPopupMenu;
    N7: TMenuItem;
    N8: TMenuItem;
    pmBands: TPopupMenu;
    actDropParameter: TAction;
    N9: TMenuItem;
    dxBarButton6: TdxBarButton;
    actBandWidth: TAction;
    N10: TMenuItem;
    actColumnWidth: TAction;
    N11: TMenuItem;
    dxBarButton7: TdxBarButton;
    actColumnApplyBestFit: TAction;
    ColumnApplyBestFit1: TMenuItem;
    actBandAutoHeight: TAction;
    N12: TMenuItem;
    actBandAutoWidth: TAction;
    N13: TMenuItem;
    actChangeBandWidth: TAction;
    ChangeBandWidth1: TMenuItem;
    dxBarButton8: TdxBarButton;
    dxBarButton9: TdxBarButton;
    dxBarManagerBar1: TdxBar;
    dxBarButton10: TdxBarButton;
    dxBarButton11: TdxBarButton;
    ColumnTimer: TTimer;
    actShowCategoryParametersQuery: TAction;
    dxBarButton12: TdxBarButton;
    procedure actAddSubParameterExecute(Sender: TObject);
    procedure actAutoWidthExecute(Sender: TObject);
    procedure actClearFiltersExecute(Sender: TObject);
    procedure actFullAnalogExecute(Sender: TObject);
    procedure actLocateInStorehouseExecute(Sender: TObject);
    procedure actAnalogExecute(Sender: TObject);
    procedure actBandAutoHeightExecute(Sender: TObject);
    procedure actBandAutoWidthExecute(Sender: TObject);
    procedure actBandWidthExecute(Sender: TObject);
    procedure actChangeBandWidthExecute(Sender: TObject);
    procedure actClearSelectedExecute(Sender: TObject);
    procedure actColumnApplyBestFitExecute(Sender: TObject);
    procedure actColumnWidthExecute(Sender: TObject);
    procedure actDropParameterExecute(Sender: TObject);
    procedure actDropSubParameterExecute(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
    procedure actShowCategoryParametersQueryExecute(Sender: TObject);
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
    procedure ColumnTimerTimer(Sender: TObject);
    procedure cxGridDBBandedTableViewColumnHeaderClick(Sender: TcxGridTableView;
      AColumn: TcxGridColumn);
    procedure cxGridDBBandedTableViewColumnPosChanged(Sender: TcxGridTableView;
      AColumn: TcxGridColumn);
    procedure cxGridDBBandedTableViewStylesGetContentStyle
      (Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
      AItem: TcxCustomGridTableItem; var AStyle: TcxStyle);
    procedure cxGridDBBandedTableViewStylesGetHeaderStyle
      (Sender: TcxGridTableView; AColumn: TcxGridColumn; var AStyle: TcxStyle);
    procedure dxBarButton7Click(Sender: TObject);
    procedure dxBarButton8Click(Sender: TObject);
    procedure dxBarButton9Click(Sender: TObject);
    procedure dxBarButton10Click(Sender: TObject);
    procedure dxBarButton11Click(Sender: TObject);
    // TODO: cxGridDBBandedTableViewDataControllerFilterChanged
    // procedure cxGridDBBandedTableViewDataControllerFilterChanged
    // (Sender: TObject);
  private
    FBandInfo: TBandInfo;
    FBandsInfo: TBandsInfo;
    FColumnsInfo: TColumnsInfo;
    FLeftPos: Integer;
    FLockDetailFilterChange: Boolean;
    FMark: string;
    FColMoveArray: TArray<TPair<Integer, Integer>>;
    procedure CreateColumn(AViewArray: TArray<TcxGridDBBandedTableView>;
      AIDList: TArray<Integer>;
      qCategoryParameters: TQueryCategoryParameters2); overload;
    procedure CreateColumn(AViewArray: TArray<TcxGridDBBandedTableView>;
      ABandInfo: TBandInfo;
      qCategoryParameters: TQueryCategoryParameters2); overload;
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
    procedure UpdateColumn(AIDCategoryParam: Integer);
    function GetComponentsExGroup: TComponentsExGroup;
    function GetqCategoryParameters: TQueryCategoryParameters2;
    procedure InitializeDefaultCreatedBands(AViewArray
      : TArray<TcxGridDBBandedTableView>);
    procedure ProcessBandMove;
    procedure ProcessColumnMove(AColumn: TcxGridDBBandedColumn);
    procedure SetComponentsExGroup(const Value: TComponentsExGroup);
    procedure UpdateColumnPosition(ABandInfo: TBandInfo);
    procedure UpdateColumns;
    procedure UpdateColumnsCustomization;
    { Private declarations }
  protected
    procedure ApplyFilter;
    function CreateBandInfoEx(AViewArray: TArray<TcxGridDBBandedTableView>;
      const AIDList: TArray<Integer>): TBandInfoEx;
    procedure CreateColumnForSubParameter(AIDCategoryParam, AIDBand: Integer);
    procedure CreateColumnsBarButtons; override;
    procedure CreateColumnsForBand(AIDCategoryParam: Integer);
    procedure CreateDetailFilter;
    procedure DoAfterLoadData; override;
    procedure DoBeforeLoad(Sender: TObject);
    // TODO: CreateFilter
    // procedure CreateFilter(AColumn: TcxGridDBBandedColumn;
    // const AValue: string);
    procedure DoOnMasterDetailChange; override;
    procedure DropColumn(AIDCategoryParam: Integer);
    procedure InitializeBandInfo(ABandInfo: TBandInfoEx;
      const AIDList: TArray<Integer>;
      qCategoryParameters2: TQueryCategoryParameters2);
    procedure OnEditValueChangeProcess(var Message: TMessage);
      message WM_ON_EDIT_VALUE_CHANGE;
    procedure OnGridBandHeaderPopupMenu(ABand: TcxGridBand;
      var AllowPopup: Boolean); override;
    procedure OnGridColumnHeaderPopupMenu(AColumn: TcxGridDBBandedColumn;
      var AllowPopup: Boolean); override;
    procedure OnGridRecordCellPopupMenu(AColumn: TcxGridDBBandedColumn;
      var AllowPopup: Boolean); override;
    procedure RecreateColumns;
    procedure UpdateBandsPosition;
    procedure UpdateDetailColumnsWidth2;
    procedure UpdateFiltersAction;
    procedure UpdateGeneralIndexes;
    property qCategoryParameters: TQueryCategoryParameters2
      read GetqCategoryParameters;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure FilterByFamily(AFamily: string);
    procedure FilterByComponent(AComponent: string);
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

uses NotifyEvents, System.StrUtils, RepositoryDataModule, cxFilterConsts,
  cxGridDBDataDefinitions, StrHelper, ParameterValuesUnit, ProjectConst,
  ParametersForProductQuery, SearchParametersForCategoryQuery, GridExtension,
  DragHelper, System.Math, AnalogForm, AnalogQueryes, AnalogGridView,
  SearchProductByParamValuesQuery, NaturalSort, CategoryParametersGroupUnit,
  FireDAC.Comp.Client, MoveHelper, SubParametersForm, System.Types,
  TextRectHelper, GridViewForm;

constructor TViewParametricTable.Create(AOwner: TComponent);
begin
  inherited;

  FBandsInfo := TBandsInfo.Create;
  FColumnsInfo := TColumnsInfo.Create;

  ApplyBestFitMultiLine := True;
end;

destructor TViewParametricTable.Destroy;
begin
  FreeAndNil(FBandsInfo);
  FreeAndNil(FColumnsInfo);
  inherited;
end;

procedure TViewParametricTable.actAddSubParameterExecute(Sender: TObject);
var
  ABI: TBandInfo;
  ACI: TColumnInfo;
  AColumn: TcxGridDBBandedColumn;
  S: string;
begin
  inherited;
  AColumn := (FHitTest as TcxGridColumnHeaderHitTest)
    .Column as TcxGridDBBandedColumn;

  ACI := FColumnsInfo.Search(AColumn, True);

  Assert(AColumn.Position.Band <> nil);
  // �������� ���������� � ����� ����� �������
  ABI := FBandsInfo.Search(AColumn.Position.Band, True);

  // �������� ���������� ��������� ������������
  if not TfrmSubParameters.GetCheckedID(ABI.IDParameter,
    qCategoryParameters.ParentValue, S) then
    Exit;

  ComponentsExGroup.CatParamsGroup.AddOrDeleteSubParameters
    (ACI.IDCategoryParam, S);
  ComponentsExGroup.CatParamsGroup.ApplyUpdates;

  // ��������� ���� � �������
  ComponentsExGroup.UpdateFields;
  // ��������� ������� � �������������
  UpdateColumns;

  qCategoryParameters.ClearSubParamsRecHolders;

  // PostMyApplyBestFitEvent;

  ComponentsExGroup.OnParamOrderChange.CallEventHandlers(Self);
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
          // ��������� �������� �� ��������� ������
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
      // ���� ����� ��������� ��������� ������� �� ���� �������
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
  ACI: TColumnInfo;
  ACI_EX: TColumnInfoEx;
  AColumn: TcxGridDBBandedColumn;
  AfrmAnalog: TfrmAnalog;
  AnalogGroup: TAnalogGroup;
  AParamSubParamId: Integer;
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

  AProductCategoryID := ComponentsExGroup.qFamilyEx.ParentValue;
  if MainView.Focused then
    AView := MainView
  else
    AView := GridView(cxGridLevel2);

  AnalogGroup := TAnalogGroup.Create(Self);
  try
    ARecHolder := TRecordHolder.Create();
    try
      // ���� �� ���� ������ ���������������� ���������� �������������
      for i := 0 to AView.Bands.Count - 1 do
      begin
        ABand := AView.Bands[i];

        if not ABand.Visible then
          Continue;

        // �������� ���������� � �����
        ABI := FBandsInfo.Search(ABand);

        // ���� ���� �� �������� ������-����������
        if ABI = nil then
          Continue;

        Assert(ABI <> nil);
        Assert(ABI.IDParameterKind >= Integer(��������������));
        Assert(ABI.IDParameterKind <= Integer(���������_���������));

        if ABI.IDParameterKind = Integer(��������������) then
          Continue;

        // ������ ����-�������� ����� ����� ��������� �������-�������������
        Assert(ABand.ColumnCount >= 1);
        for P := 0 to ABand.ColumnCount - 1 do
        begin
          AColumn := ABand.Columns[P] as TcxGridDBBandedColumn;
          // ���� ���������� � �������
          ACI := FColumnsInfo.Search(AColumn, True);
          qCategoryParameters.LocateByPK(ACI.IDCategoryParam);
          AParamSubParamId := qCategoryParameters.ParamSubParamId.AsInteger;

          // �������� �������� ��������� ������� ��������������� ������
          V := FocusedTableView.Controller.FocusedRecord.Values[AColumn.Index];

          if VarIsNull(V) then
          begin
            // ������ �������� � ��������� - �� ���������� ��� ������ �������
            if FocusedTableView = MainView then
              Continue;

            Assert(FocusedTableView.Level = cxGridLevel2);
            // ������ �������� � ���������� - ����� �������� �� ���������
            // ���� ���� � ���������

            Assert(Length((ABI as TBandInfoEx).Bands) = 2);
            Assert((ABI as TBandInfoEx).Bands[1] = ABand);
            ACI_EX := ACI as TColumnInfoEx;
            Assert(Length(ACI_EX.Columns) = 2);
            Assert(ACI_EX.Columns[1] = AColumn);

            // ���� �����-�� ������� �� � ���������
            AColumn := ACI_EX.Columns[0];

            // �������� �������� ��������� ������� � ���������
            V := MainView.Controller.FocusedRecord.Values[AColumn.Index];

            // ������ �������� � ��������� - �� ���������� ��� ������ �������
            if VarIsNull(V) then
              Continue;
          end;

          // ����������� �� �������� � ��������
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

          Assert(ComponentsExGroup.AllParameterFields.ContainsKey
            (AParamSubParamId));

          // ��������� �������� ���� � ���������
          TFieldHolder.Create(ARecHolder, ComponentsExGroup.AllParameterFields
            [AParamSubParamId], AValue);
        end;

      end;

      // ��������� �������� ���������� ��� ������� ���������
      AnalogGroup.Load(AProductCategoryID, ARecHolder,
        ComponentsExGroup.AllParameterFields);

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
      // RefreshData; // ������������ ������ � ��������� �������� �� ��
      ApplyFilter;
      UpdateView;
    end;

  finally
    FreeAndNil(AnalogGroup);
  end;
end;

procedure TViewParametricTable.actBandAutoHeightExecute(Sender: TObject);
var
  ABand: TcxGridBand;
begin
  inherited;
  Assert(FHitTest <> nil);
  Assert(FHitTest is TcxGridBandHeaderHitTest);

  ABand := (FHitTest as TcxGridBandHeaderHitTest).Band;

  ABand.GridView.OptionsView.BandHeaderHeight := CalcBandHeight(ABand);
end;

procedure TViewParametricTable.actBandAutoWidthExecute(Sender: TObject);
var
  ABand: TcxGridBand;
begin
  inherited;
  Assert(FHitTest <> nil);
  Assert(FHitTest is TcxGridBandHeaderHitTest);

  ABand := (FHitTest as TcxGridBandHeaderHitTest).Band;
  // ABand.GridView.OptionsView.BandHeaderHeight := 100;
  ABand.ApplyBestFit();
end;

procedure TViewParametricTable.actBandWidthExecute(Sender: TObject);
var
  ABand: TcxGridBand;
  S: string;
begin
  inherited;
  Assert(FHitTest <> nil);
  Assert(FHitTest is TcxGridBandHeaderHitTest);

  ABand := (FHitTest as TcxGridBandHeaderHitTest).Band;
  Assert(ABand <> nil);

  S := Format('Width = %d', [ABand.Width]);
  ShowMessage(S);
end;

procedure TViewParametricTable.actChangeBandWidthExecute(Sender: TObject);
var
  ABand: TcxGridBand;
  ABandWidth: Integer;
begin
  inherited;
  Assert(FHitTest <> nil);
  Assert(FHitTest is TcxGridBandHeaderHitTest);

  ABand := (FHitTest as TcxGridBandHeaderHitTest).Band;

  ABandWidth := ABand.GridView.ViewInfo.HeaderViewInfo.BandsViewInfo.Items
    [ABand.VisibleIndex].Width;

  ABand.Width := ABandWidth + 100;
end;

procedure TViewParametricTable.actClearSelectedExecute(Sender: TObject);
var
  AColumn: TcxGridDBBandedColumn;
  AFieldList: TList<String>;
  AFieldName: String;
  AView: TcxGridDBBandedTableView;
  m: TArray<Integer>;
begin
  inherited;
  AView := FocusedTableView;

  AFieldList := TList<String>.Create;
  try
    qCategoryParameters.FDQuery.First;
    while not qCategoryParameters.FDQuery.Eof do
    begin
      // ��� ���� �������� �� ������� ���� ��� ����� ����������
      AFieldName := ComponentsExGroup.AllParameterFields
        [qCategoryParameters.ParamSubParamId.AsInteger];

      AColumn := AView.GetColumnByFieldName(AFieldName);

      if AColumn.Selected then
        AFieldList.Add(AFieldName);

      qCategoryParameters.FDQuery.Next;
    end;

    Assert(clID.Index = clID2.Index);
    m := GetSelectedIntValues(AView, clID.Index);

    BeginUpdate;
    try
      FocusedQuery.ClearFields(AFieldList.ToArray, m);
    finally
      EndUpdate;
    end;

  finally
    FreeAndNil(AFieldList);
  end;
  UpdateView;
end;

procedure TViewParametricTable.actColumnApplyBestFitExecute(Sender: TObject);
var
  // ABandCaption: String;
  // ACaption: Integer;
  AColumn: TcxGridDBBandedColumn;
begin
  inherited;

  AColumn := (FHitTest as TcxGridColumnHeaderHitTest)
    .Column as TcxGridDBBandedColumn;

  AColumn.GridView.BeginBestFitUpdate;
  AColumn.ApplyBestFit(True);
  AColumn.GridView.EndBestFitUpdate;
end;

procedure TViewParametricTable.actColumnWidthExecute(Sender: TObject);
var
  AColumn: TcxGridDBBandedColumn;
  H: Integer;
  S: string;
  W: Integer;
begin
  inherited;
  AColumn := (FHitTest as TcxGridColumnHeaderHitTest)
    .Column as TcxGridDBBandedColumn;

  W := AColumn.GridView.ViewInfo.HeaderViewInfo.Items
    [AColumn.VisibleIndex].Width;

  H := AColumn.GridView.ViewInfo.HeaderViewInfo.Items
    [AColumn.VisibleIndex].Height;

  S := Format('Width = %d, HeaderViewInfoWidth = %d, HeaderViewInfoHeight = %d',
    [AColumn.Width, W, H]);
  ShowMessage(S);
end;

procedure TViewParametricTable.actDropParameterExecute(Sender: TObject);
var
  ABand: TcxGridBand;
  ABI: TBandInfo;
  ACI: TColumnInfo;
begin
  inherited;
  Assert(FHitTest <> nil);
  Assert(FHitTest is TcxGridBandHeaderHitTest);

  ABand := (FHitTest as TcxGridBandHeaderHitTest).Band;
  Assert(ABand <> nil);

  // ���� ���������� �� ���� �����
  ABI := FBandsInfo.Search(ABand);

  // ���� ��� �� ����-��������
  if ABI = nil then
    Exit;

  Assert(ABand.ColumnCount > 0);
  // �������� ���������� � ������ ������� ������ �����
  ACI := FColumnsInfo.Search(ABand.Columns[0] as TcxGridDBBandedColumn, True);

  qCategoryParameters.ClearSubParamsRecHolders;

  // ������ ������� ��� ������������ ���� ������
  ComponentsExGroup.CatParamsGroup.DeleteParameters([ACI.IDCategoryParam]);
  ComponentsExGroup.CatParamsGroup.ApplyUpdates;

  ComponentsExGroup.UpdateFields;
  UpdateColumns;

  qCategoryParameters.ClearSubParamsRecHolders;
  ComponentsExGroup.OnParamOrderChange.CallEventHandlers(Self);
end;

procedure TViewParametricTable.actDropSubParameterExecute(Sender: TObject);
var
  ACI: TColumnInfo;
  AColumn: TcxGridDBBandedColumn;
begin
  inherited;
  AColumn := (FHitTest as TcxGridColumnHeaderHitTest)
    .Column as TcxGridDBBandedColumn;

  qCategoryParameters.ClearSubParamsRecHolders;

  // �������� ���������� �� ���� �������
  ACI := FColumnsInfo.Search(AColumn, True);
  // ������� �����������, ��������������� ������
  ComponentsExGroup.CatParamsGroup.DeleteSubParameters([ACI.IDCategoryParam]);
  ComponentsExGroup.CatParamsGroup.ApplyUpdates;

  // �������� ����, ��� ��������� ��������� ����� ���������� ���������
  ComponentsExGroup.OnParamOrderChange.CallEventHandlers(Self);

  Assert(AColumn.Position.Band <> nil);

  // ��������� ���� � �������
  ComponentsExGroup.UpdateFields;
  // ��������� ������� � �������������
  UpdateColumns;

  qCategoryParameters.ClearSubParamsRecHolders;
end;

procedure TViewParametricTable.actRefreshExecute(Sender: TObject);
begin
  inherited;
  RefreshData;
end;

procedure TViewParametricTable.actShowCategoryParametersQueryExecute
  (Sender: TObject);
var
  AfrmGridView: TfrmGridView;
begin
  inherited;
  AfrmGridView := TfrmGridView.Create(Self);
  try
    AfrmGridView.ViewGridEx.DataSet := qCategoryParameters.FDQuery;
    AfrmGridView.ShowModal;
  finally
    FreeAndNil(AfrmGridView);
  end;
end;

procedure TViewParametricTable.ApplyFilter;
var
  AColumn: TcxGridDBBandedColumn;
  FilterRoot: TcxFilterCriteriaItemList;
begin
  // ����������� ������ �� ���������
  FilterRoot := MainView.DataController.Filter.root;
  FilterRoot.Clear;

  AColumn := MainView.GetColumnByFieldName(clAnalog.DataBinding.FieldName);

  FilterRoot.AddItem(AColumn, foEqual, 1, '��');
  MainView.DataController.Filter.Active := True;

  // ����������� ������ �� ����������
  FilterRoot := GridView(cxGridLevel2).DataController.Filter.root;
  FilterRoot.Clear;

  AColumn := GridView(cxGridLevel2).GetColumnByFieldName
    (clAnalog2.DataBinding.FieldName);

  FilterRoot.AddItem(AColumn, foEqual, 1, '��');
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
  AValueList.Add(fviAll, null, '(���)', True);
  // AValueList.Add(fviBlanks, null, '(������)', True);
  // AValueList.Add(fviNonBlanks, null, '(�� ������)', True);
  // AValueList.Add(fviUserEx, null, '(���)', True);

  // ��������� �������� ��������
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
  // ��������
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

    // ������ ����������
    AMyFilterList.AddItem(Sender, foEqual, AValue, AValue);
    // � ������ ������
    AMyFilterList.AddItem(Sender, foLike, AValue + #13#10 + '%', AValue);
    // � �������� ������
    AMyFilterList.AddItem(Sender, foLike, '%' + #13#10 + AValue + #13#10 +
    '%', AValue);
    // � ����� ������
    AMyFilterList.AddItem(Sender, foLike, '%' + #13#10 + AValue, AValue);
  }
end;

procedure TViewParametricTable.dxBarButton10Click(Sender: TObject);
begin
  inherited;
  BeginUpdate;
end;

procedure TViewParametricTable.dxBarButton11Click(Sender: TObject);
begin
  inherited;
  PostMyApplyBestFitEvent;
  EndUpdate;
end;

procedure TViewParametricTable.dxBarButton2Click(Sender: TObject);
begin
  inherited;
  UpdateDetailColumnsWidth2;
end;

procedure TViewParametricTable.dxBarButton7Click(Sender: TObject);
begin
  inherited;
  BeginUpdate;
  try
    RecreateColumns;
  finally
    PostMyApplyBestFitEvent;
    EndUpdate;
  end;
end;

procedure TViewParametricTable.dxBarButton8Click(Sender: TObject);
begin
  inherited;
  FLeftPos := MainView.Controller.LeftPos;
end;

procedure TViewParametricTable.dxBarButton9Click(Sender: TObject);
begin
  inherited;
  MainView.Controller.LeftPos := FLeftPos;
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
  ABandInfo: TBandInfo;
  ABI: TBandInfo;
  L: TBandsInfo;
begin
  inherited;
  // ���� ���������� � ������������ �����
  ABandInfo := FBandsInfo.Search(ABand, True);

  // �������� ���������� � ��� ������, ��������� ������� ����������
  L := FBandsInfo.GetChangedColIndex;
  try
    // ���� ����������� � ������ ������ ��� ���������� ������ ��� �� ���������
    if (L.HaveDifferentPos) or (BandTimer.Enabled) then
    begin
      // ���������� ������� �� �����
      for ABI in L do
        ABI.Band.Position.ColIndex := ABI.ColIndex;
      Exit;
    end;
  finally
    FreeAndNil(L);
  end;

  // ������ ������� ��������� �����
  (ABandInfo as TBandInfoEx).Bands[1].Position.ColIndex :=
    ABand.Position.ColIndex;

  // �������� ��� ��������� ������ ����� ����� ������������� ����������
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
/// / ������ ����������
// r.AddItem(AColumn, foEqual, AValue, AValue);
/// / � ������ ������
// r.AddItem(AColumn, foLike, AValue + #13#10 + '%', AValue);
/// / � �������� ������
// r.AddItem(AColumn, foLike, '%' + #13#10 + AValue + #13#10 + '%', AValue);
/// / � ����� ������
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

  // ���� ���� ������ ���������
  if UpdateCount > 0 then
    Exit;

  H := MainView.GetHitTest(X, Y);

  // ���������� ����������� ���������
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

  case ABI.pos of
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
  // �����, ������� �� ���������� "�� ���������" �������
  FBandsInfo.FreeNotDefaultBands;

  // �����, ������� ���������� "�� ���������" ������
  FBandsInfo.HideDefaultBands;
end;

procedure TViewParametricTable.DeleteColumns;
begin
  FColumnsInfo.FreeNotDefaultColumns;
  FColumnsInfo.Clear;
end;

procedure TViewParametricTable.DoAfterLoad(Sender: TObject);
begin
  RecreateColumns;

  PostMyApplyBestFitEvent;
  EndUpdate;
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
    // TNotifyEventWrap.Create(ComponentsExGroup.qFamilyEx.AfterLoad, DoAfterLoad,
    // FEventList);

    TNotifyEventWrap.Create(ComponentsExGroup.qFamilyEx.BeforeOpen,
      DoBeforeLoad, FEventList);

    TNotifyEventWrap.Create(ComponentsExGroup.qFamilyEx.AfterOpen, DoAfterLoad,
      FEventList);

    InitializeDefaultCreatedBands([MainView, GridView(cxGridLevel2)]);

    // ���� ������ ������� � �� ������� ����������
    if ComponentsExGroup.qFamilyEx.Actual then
    begin
      // ������������ �������� �������
      DoAfterLoad(nil);
    end;
    cxGridPopupMenu.PopupMenus.Items[2].GridView := MainView;
    cxGridPopupMenu.PopupMenus.Items[3].GridView := MainView;
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

  // ������������� ������������� �����������
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
  (AViewArray: TArray<TcxGridDBBandedTableView>);
var
  ABandInfo: TBandInfo;
  AColumn: TcxGridDBBandedColumn;
  ABandList: TList<TcxGridBand>;
  AFieldName: string;
  AIDParamSubParam: Integer;
  AView: TcxGridDBBandedTableView;
begin
  // ���� �� ���� ����� �������, ������� �������� �����������
  for AIDParamSubParam in ComponentsExGroup.qFamilyEx.ParameterFields.Keys do
  begin
    // �������� ����, SQL ������� ������� �������� ����������
    AFieldName := ComponentsExGroup.qFamilyEx.ParameterFields[AIDParamSubParam];
    ABandList := TList<TcxGridBand>.Create;
    try
      for AView in AViewArray do
      begin
        AColumn := AView.GetColumnByFieldName(AFieldName);
        Assert(AColumn <> nil);
        Assert(AColumn.Position.Band <> nil);
        Assert(AColumn.Position.Band.ColumnCount = 1);
        AColumn.Position.Band.Visible := False;
        AColumn.Position.Band.VisibleForCustomization := False;

        ABandList.Add(AColumn.Position.Band);
      end;

      // ��������, ��� ���� ���� ������� ����������� ���������
      ABandInfo := TBandInfoEx.CreateAsDefault(AIDParamSubParam,
        ABandList.ToArray);
      FBandsInfo.Add(ABandInfo);
    finally
      FreeAndNil(ABandList);
    end;
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

procedure TViewParametricTable.BandTimerTimer(Sender: TObject);
begin
  inherited;
  BandTimer.Enabled := False;
  ProcessBandMove;
end;

procedure TViewParametricTable.ColumnTimerTimer(Sender: TObject);
var
  ACI: TColumnInfo;
  APair: TPair<Integer, Integer>;
begin
  inherited;
  ColumnTimer.Enabled := False;

  ComponentsExGroup.CatParamsGroup.ApplyUpdates;
  FColumnsInfo.SaveColumnPosition;

  // ���� �������� ������� � �� ��� �������� �������
  for APair in FColMoveArray do
  begin
    ACI := FColumnsInfo.Search(APair.Key, True);
    // ����������, ����� ������ ������� � ���� ������� � ��
    ACI.Order := APair.Value;
  end;

  // �������� ����-�� � ���, ��� �� �������� �������
  ComponentsExGroup.OnParamOrderChange.CallEventHandlers(Self);
end;

function TViewParametricTable.CreateBandInfoEx
  (AViewArray: TArray<TcxGridDBBandedTableView>; const AIDList: TArray<Integer>)
  : TBandInfoEx;
var
  ABand: TcxGridBand;
  ABandList: TList<TcxGridBand>;
  AView: TcxGridDBBandedTableView;
begin
  // ������ ������, � �������� �� ����� ��������
  ABandList := TList<TcxGridBand>.Create;
  try
    // ��� ���� ������������� ������ �������������� ����
    for AView in AViewArray do
    begin
      ABand := AView.Bands.Add;
      ABandList.Add(ABand);
    end;

    // ��������� ��� ����� � ��������
    Result := TBandInfoEx.Create(ABandList.ToArray, AIDList);
  finally
    FreeAndNil(ABandList);
  end;
end;

procedure TViewParametricTable.CreateColumn(AViewArray
  : TArray<TcxGridDBBandedTableView>; AIDList: TArray<Integer>;
  qCategoryParameters: TQueryCategoryParameters2);
var
  ABandInfo: TBandInfo;
  ANeedInitialize: Boolean;
begin
  // ����� ����� ����� ��������� ������
  // ���� ����� ������� ��������� ������
  ABandInfo := FBandsInfo.SearchByIDParamSubParam
    (qCategoryParameters.ParamSubParamId.AsInteger);
  // ���� �� �������������� �����
  if ABandInfo = nil then
    ABandInfo := FBandsInfo.SearchByIDList(AIDList);

  ANeedInitialize := (ABandInfo = nil) or
    (ABandInfo.DefaultCreated and not ABandInfo.Band.VisibleForCustomization);

  // ���� �� ����� ���������� ���� - ������ ���!
  if ABandInfo = nil then
  begin
    ABandInfo := CreateBandInfoEx(AViewArray, AIDList);
    FBandsInfo.Add(ABandInfo);
  end;

  if ANeedInitialize then
  begin
    InitializeBandInfo(ABandInfo as TBandInfoEx, AIDList, qCategoryParameters);
  end;

  CreateColumn(AViewArray, ABandInfo, qCategoryParameters);
end;

procedure TViewParametricTable.CreateColumn(AViewArray
  : TArray<TcxGridDBBandedTableView>; ABandInfo: TBandInfo;
  qCategoryParameters: TQueryCategoryParameters2);
var
  ABand: TcxGridBand;
  ACI: TColumnInfo;
  AColumn: TcxGridDBBandedColumn;
  AColumnList: TList<TcxGridDBBandedColumn>;
  AParamSubParamId: Integer;
  R: TRect;
begin
  Assert(ABandInfo <> nil);

  AParamSubParamId := qCategoryParameters.ParamSubParamId.AsInteger;

  // ����, �������� ����� ������� ��� ����?
  ACI := FColumnsInfo.Search(qCategoryParameters.PK.AsInteger);
  if ACI <> nil then
  begin
    // ��� ������� ������ ������������ ����� �����
    Assert(ACI.Column.Position.Band = ABandInfo.Band);
  end
  else
  begin
    // ������ ����������� �������
    AColumnList := TList<TcxGridDBBandedColumn>.Create;
    try
      // ���� ����� ������� �� ��������� ���
      // ���� ����� ���� �� ����������� �� "���������"
      if not ABandInfo.DefaultCreated then
      begin
        // �������������� ���� �����
        for ABand in (ABandInfo as TBandInfoEx).Bands do
        begin
          // ������ ������� ��� ����� �����
          AColumn := ABand.GridView.CreateColumn as TcxGridDBBandedColumn;
          AColumn.Position.BandIndex := ABand.Index;
          AColumn.MinWidth := 40;
          AColumn.Caption :=
            DeleteDouble(qCategoryParameters.Name.AsString, ' ');
          if AColumn.Caption.IsEmpty then
            AColumn.Caption := ' ';
          AColumn.HeaderAlignmentHorz := taCenter;
          AColumn.AlternateCaption :=
            DeleteDouble(qCategoryParameters.Translation.AsString, ' ');

          // ����� ���� ������ ���� � ��������
          Assert(ComponentsExGroup.AllParameterFields.ContainsKey
            (AParamSubParamId));

          AColumn.DataBinding.FieldName := ComponentsExGroup.AllParameterFields
            [AParamSubParamId];

          R := TTextRect.Calc(AColumn.GridView.ViewInfo.Canvas.Canvas,
            AColumn.Caption, AColumn.MinWidth);
          AColumn.Width := R.Width + 10;

          // � ������ ��������� ������� ������������
          AColumn.OnGetDataText := DoOnGetDataText;

          if ABand.GridView = MainView then
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
          AColumnList.Add(AColumn);
        end;
      end
      else
      begin
        for ABand in (ABandInfo as TBandInfoEx).Bands do
        begin
          // � ����� "�� ���������" ������ ���� �������
          Assert(ABand.ColumnCount = 1);
          AColumnList.Add(ABand.Columns[0] as TcxGridDBBandedColumn);
        end;

      end;
      // ��������� ���������� � ��������� ��� ��� ������������ ��������
      FColumnsInfo.Add(TColumnInfoEx.Create(AColumnList.ToArray,
        qCategoryParameters.PK.AsInteger, qCategoryParameters.Ord.AsInteger,
        ABandInfo.DefaultCreated, qCategoryParameters.IsDefault.AsInteger = 1));
    finally
      FreeAndNil(AColumnList);
    end;
  end;
end;

procedure TViewParametricTable.CreateColumnForSubParameter(AIDCategoryParam,
  AIDBand: Integer);
begin
  qCategoryParameters.LocateByPK(AIDCategoryParam, True);
  {

    // ��� ���� �������� �� ������� ���� ��� ����� ����������
    AParamSubParamId := AClone.FieldByName
    (qCategoryParameters.ParamSubParamId.FieldName).AsInteger;

    Assert(ComponentsExGroup.AllParameterFields.ContainsKey
    (AParamSubParamId));

    AFieldName := ComponentsExGroup.AllParameterFields[AParamSubParamId];

    AVisible := AClone.FieldByName(qCategoryParameters.IsAttribute.FieldName)
    .AsInteger = 1;
    ABandCaption := AClone.FieldByName
    (qCategoryParameters.Value.FieldName).AsString;
    AColumnCaption := AClone.FieldByName
    (qCategoryParameters.Name.FieldName).AsString;

    // ����� ���� ���������� ��� ����
    if AColumnCaption.IsEmpty then
    AColumnCaption := ' ';

    ABandHint := AClone.FieldByName
    (qCategoryParameters.ValueT.FieldName).AsString;
    AColumnHint := AClone.FieldByName
    (qCategoryParameters.Translation.FieldName).AsString;
    AOrder := AClone.FieldByName(qCategoryParameters.Ord.FieldName).AsInteger;
    APosID := AClone.FieldByName(qCategoryParameters.PosID.FieldName)
    .AsInteger;
    // ��� ������ ������ ��� ����� ���������
    AIDParameterKind := AClone.FieldByName
    (qCategoryParameters.IDParameterKind.FieldName).AsInteger;
    // ������������� �����
    AIDCategoryParam := AClone.FieldByName
    (qCategoryParameters.IDParameter.FieldName).AsInteger;
    AIsDefault := AClone.FieldByName(qCategoryParameters.IsDefault.FieldName)
    .AsInteger = 1;
    // ������������� ������� - ��� ������������� ������ � ������������
    ACategoryParamID := AClone.FieldByName(qCategoryParameters.PKFieldName)
    .AsInteger;

    // ������ ������� � ����� ��������������
    CreateColumn2([MainView, GridView(cxGridLevel2)], AIDBand,
    AIDCategoryParam, AIsDefault, ABandCaption, AColumnCaption, AFieldName,
    AVisible, ABandHint, ACategoryParamID, AOrder, APosID, AIDParameterKind,
    AColumnHint);
  }
end;

procedure TViewParametricTable.CreateColumnsForBand(AIDCategoryParam: Integer);
var
  AClone: TFDMemTable;
  AIDList: TList<Integer>;
begin
  Assert(AIDCategoryParam > 0);

  qCategoryParameters.LocateByPK(AIDCategoryParam, True);

  AIDList := TList<Integer>.Create;
  // �������� ��� ������������ �������� �����
  AClone := qCategoryParameters.CreateSubParamsClone;
  try
    // ���������� ������ ��������������� �������� �����
    while not AClone.Eof do
    begin
      AIDList.Add(AClone.FieldByName(qCategoryParameters.PKFieldName)
        .AsInteger);
      AClone.Next;
    end;

    AClone.First;
    while not AClone.Eof do
    begin
      // ��������� �� ��������� �����������
      qCategoryParameters.LocateByPK
        (AClone.FieldByName(qCategoryParameters.PKFieldName).AsInteger, True);

      // ������ �������
      CreateColumn([MainView, GridView(cxGridLevel2)], AIDList.ToArray,
        qCategoryParameters);

      AClone.Next;
    end;
  finally
    qCategoryParameters.DropClone(AClone);
    FreeAndNil(AIDList);
  end;

end;

procedure TViewParametricTable.cxGridDBBandedTableViewColumnHeaderClick
  (Sender: TcxGridTableView; AColumn: TcxGridColumn);
begin;
  inherited;
end;

procedure TViewParametricTable.cxGridDBBandedTableViewColumnPosChanged
  (Sender: TcxGridTableView; AColumn: TcxGridColumn);
begin
  inherited;
  ProcessColumnMove(AColumn as TcxGridDBBandedColumn);
end;

procedure TViewParametricTable.DoAfterLoadData;
begin
  // �� �� ������ ������������ ������� ����� �������� ������
end;

procedure TViewParametricTable.DoBeforeLoad(Sender: TObject);
begin
  BeginUpdate;
end;

procedure TViewParametricTable.DropColumn(AIDCategoryParam: Integer);
var
  ABand: TcxGridBand;
  ABI: TBandInfo;
  ACI: TColumnInfo;
begin
  Assert(AIDCategoryParam > 0);

  ACI := FColumnsInfo.Search(AIDCategoryParam, True);

  ABand := ACI.Column.Position.Band;
  Assert(ABand <> nil);

  // �������� ���������� � �����
  ABI := FBandsInfo.Search(ABand, True);

  // ���� ��� ����, ������� ������ "�� ���������"
  if ABI.DefaultCreated then
  begin
    Assert(ABand.ColumnCount = 1);
    // ������ ������ ����� ����
    ABI.Hide;
  end
  else
  begin
    ABI.IDList.Remove(AIDCategoryParam);

    // ������� ���������� � ���� �������
    FColumnsInfo.Remove(ACI);
    // ������� ���� �������
    ACI.FreeColumn;
    ACI.Free;

    // �������� �� ������� ��������� ������� �����
    if ABand.ColumnCount = 0 then
    begin
      // ������� ��� ����
      FBandsInfo.Remove(ABI);
      ABI.FreeBand;
      ABI.Free;
    end;
  end;
end;

procedure TViewParametricTable.UpdateColumn(AIDCategoryParam: Integer);
var
  ACI: TColumnInfoEx;
  AColumn: TcxGridDBBandedColumn;
begin
  ACI := FColumnsInfo.Search(AIDCategoryParam, True) as TColumnInfoEx;
  qCategoryParameters.LocateByPK(AIDCategoryParam, True);

  // ��������� ������� ����, ��� ��� ����������� �� ���������
  ACI.IsDefault := qCategoryParameters.IsDefault.AsInteger = 1;

  for AColumn in ACI.Columns do
  begin
    AColumn.Caption := DeleteDouble(qCategoryParameters.Name.AsString, ' ');
    if AColumn.Caption.IsEmpty then
      AColumn.Caption := AColumn.Caption + ' ';

    AColumn.AlternateCaption :=
      DeleteDouble(qCategoryParameters.Translation.AsString, ' ');
  end;
end;

function TViewParametricTable.GetqCategoryParameters: TQueryCategoryParameters2;
begin
  Result := ComponentsExGroup.CatParamsGroup.qCategoryParameters;
end;

procedure TViewParametricTable.InitializeBandInfo(ABandInfo: TBandInfoEx;
  const AIDList: TArray<Integer>;
  qCategoryParameters2: TQueryCategoryParameters2);
var
  ABand: TcxGridBand;
begin
  Assert(ABandInfo <> nil);
  Assert(qCategoryParameters.FDQuery.RecordCount > 0);

  ABandInfo.IDList.Assign(AIDList); // ������������� �����
  ABandInfo.IsDefault := qCategoryParameters.IsDefault.AsInteger = 1;
  // �������� "�� ���������" ������ � �������� �����
  if qCategoryParameters.IsDefault.AsInteger = 1 then
    ABandInfo.IDParamSubParam := qCategoryParameters.ParamSubParamId.AsInteger;

  // ������ �� �� � ������������� �� ���������
  ABandInfo.IDParameter := qCategoryParameters.IDParameter.AsInteger;
  // ��������, � ������� ������ ����
  // ����������� �� "���������"
  ABandInfo.DefaultVisible := qCategoryParameters.IsAttribute.AsInteger = 1;
  ABandInfo.IDParameterKind := qCategoryParameters.IDParameterKind.AsInteger;
  // ����� ������� ����� �������� � ��
  ABandInfo.Order := qCategoryParameters.Ord.AsInteger;
  ABandInfo.pos := qCategoryParameters.PosID.AsInteger;

  // �������������� ���� �����
  for ABand in ABandInfo.Bands do
  begin
    ABand.Visible := ABandInfo.DefaultVisible;
    ABand.Options.HoldOwnColumnsOnly := ABandInfo.DefaultCreated;
    ABand.VisibleForCustomization := True;
    ABand.Caption := DeleteDouble(qCategoryParameters.Value.AsString, ' ');
    ABand.AlternateCaption :=
      DeleteDouble(qCategoryParameters.ValueT.AsString, ' ');
    if ABandInfo.DefaultCreated then
      ABand.Position.ColIndex := 1000; // �������� ���� � �����
  end;

end;

procedure TViewParametricTable.OnGridBandHeaderPopupMenu(ABand: TcxGridBand;
  var AllowPopup: Boolean);
var
  ABI: TBandInfo;
begin
  Assert(ABand <> nil);
  ABI := FBandsInfo.Search(ABand);

  // �������� ���� �� �������� ������-����������
  AllowPopup := ABI <> nil;
  actDropParameter.Enabled := AllowPopup;
end;

procedure TViewParametricTable.OnGridColumnHeaderPopupMenu
  (AColumn: TcxGridDBBandedColumn; var AllowPopup: Boolean);
var
  ABand: TcxGridBand;
  ABI: TBandInfo;
  ACI: TColumnInfo;
begin
  ABand := AColumn.Position.Band;
  Assert(ABand <> nil);
  ABI := FBandsInfo.Search(ABand);

  // ����� ������������ "�� ���������" ������ �������� ���� ������� �� "���������"
  AllowPopup := (ABI <> nil) and (not ABI.DefaultCreated);
  if not AllowPopup then
    Exit;

  ACI := FColumnsInfo.Search(AColumn, True);

  // ������ ������� ������� � ������������� "�� ���������"
  actDropSubParameter.Enabled := not ACI.IsDefault;
end;

procedure TViewParametricTable.OnGridRecordCellPopupMenu
  (AColumn: TcxGridDBBandedColumn; var AllowPopup: Boolean);
Var
  AColumnIsValue: Boolean;
begin
  inherited;

  AColumnIsValue := (AColumn <> nil) and
    (AColumn.DataBinding.FieldName = clValue.DataBinding.FieldName);

  actClearSelected.Visible := (AColumn <> nil) and not(AColumnIsValue);
  actClearSelected.Enabled := actClearSelected.Visible;

end;

// ��������� ����������� ������
procedure TViewParametricTable.ProcessBandMove;
var
  A: TArray<TPair<Integer, Integer>>;
  ABandInfo: TBandInfo;
  ABI: TBandInfo;
  ACI: TColumnInfo;
  AColumn: TcxGridDBBandedColumn;
  ALeft: Boolean;
  APair: TPair<Integer, Integer>;
  BIList: TBandsInfo;
  i: Integer;
  L: TList<TPair<Integer, Integer>>;
begin
  // ����������, ��� ����������� ������������� ���������
  Assert(FBandInfo <> nil);
  Assert(FBandInfo.ColIndex <> FBandInfo.Band.Position.ColIndex);

  // ���� ��������� �����������: ����� ��� ������?
  ALeft := FBandInfo.ColIndex > FBandInfo.Band.Position.ColIndex;

  BIList := FBandsInfo.GetChangedColIndex;
  try
    // ��� ������� 2 ����� ������ ���� �������� ���� �������
    Assert(BIList.Count >= 2);
    // ������ �������������, ������� ������ ���� �������
    L := TList < TPair < Integer, Integer >>.Create;
    try
      for ABI in BIList do
      begin
        // ���� �� ���� �������� �����, ������� ������� ��� ���������
        for i := 0 to ABI.Band.ColumnCount - 1 do
        begin
          // ���� ���������� � ������������ ������ � ������ �������
          AColumn := ABI.Band.Columns[i] as TcxGridDBBandedColumn;
          ACI := FColumnsInfo.Search(AColumn, True);

          // ����������, ����� ������ � �� �������� �������� �� ����� �����
          L.Add(TPair<Integer, Integer>.Create(ACI.IDCategoryParam, ACI.Order));
        end;
      end;
      // ������� ����� ���� �� ���������� ��������
      A := TMoveHelper.Move(L.ToArray, ALeft, FBandInfo.Band.ColumnCount);
    finally
      FreeAndNil(L);
    end;
  finally
    FreeAndNil(BIList);
  end;

  // ������ ������� ��������������� ��������� � ��
  ComponentsExGroup.CatParamsGroup.qCategoryParameters.Move(A);
  ComponentsExGroup.CatParamsGroup.ApplyUpdates;

  // ���������� � ����� ������� ��������� ��� ����
  for ABandInfo in FBandsInfo do
    ABandInfo.ColIndex := ABandInfo.Band.Position.ColIndex;

  // ���� �������� ������� � �� ��� �������� �������
  for APair in A do
  begin
    ACI := FColumnsInfo.Search(APair.Key, True);

    // ����������, ����� ������ ������� � ���� ������� � ��
    ACI.Order := APair.Value;
  end;

  // ��������� ������� ������ � ���������� ������
  UpdateColumnsCustomization;

  // �������� ����-�� � ���, ��� �� �������� �������
  ComponentsExGroup.OnParamOrderChange.CallEventHandlers(Self);
end;

// ��������� ����������� �������
procedure TViewParametricTable.ProcessColumnMove
  (AColumn: TcxGridDBBandedColumn);
var
  A: TArray<TPair<Integer, Integer>>;
  ABand: TcxGridBand;
  ABandInfo: TBandInfo;
  ACI: TColumnInfo;
  ACI2: TColumnInfo;
  ANewIDList: TIDList;
  ALeft: Boolean;
  AOldBandInfo: TBandInfoEx;
  AIDList: TIDList;
  ANewIDListArr: TArray<Integer>;
  AOldIDListArr: TArray<Integer>;
  APair: TPair<Integer, Integer>;
  CIList: TArray<TColumnInfo>;
  L: TList<TPair<Integer, Integer>>;
begin
  Assert(AColumn <> nil);

  // ���� ���������� � ������������ �������
  ACI := FColumnsInfo.Search(AColumn, True);

  // ���� ��� ����, �������� ������� ������������ �� ��������
  ABand := MainView.Bands.Items[ACI.BandIndex];

  AOldBandInfo := FBandsInfo.Search(ABand, True) as TBandInfoEx;
  AOldIDListArr := AOldBandInfo.IDList.ToArray;

  // ����������, ��� ����������� ������������� ���������
  Assert((ACI.ColIndex <> ACI.Column.Position.ColIndex) or
    (ACI.BandIndex <> ACI.Column.Position.BandIndex));

  // ���� ��������� �����������: ����� ��� ������?
  ALeft := ((ACI.BandIndex * 100) + ACI.ColIndex) >
    (ACI.Column.Position.BandIndex * 100) + ACI.Column.Position.ColIndex;

  UpdateGeneralIndexes;
  CIList := FColumnsInfo.GetChangedGeneralColIndex;

  // ���� �� ����� ���� ����������� �� ���������
  if Length(CIList) < 2 then
  begin
    // ���� ������� ������� �� �����
    ACI.RestoreColumnPosition;
    Exit;
  end;

  // ������ �������������, ������� ������ ���� �������
  L := TList < TPair < Integer, Integer >>.Create;
  try
    for ACI2 in CIList do
    begin
      // ����������, ����� ������ � �� �������� �������� �� ����� �����
      L.Add(TPair<Integer, Integer>.Create(ACI2.IDCategoryParam, ACI2.Order));
    end;
    // ������� ����� ���� �� ���������� ��������
    A := TMoveHelper.Move(L.ToArray, ALeft, 1);
  finally
    FreeAndNil(L);
  end;

  // ������ ������� ��������������� ��������� � ��
  qCategoryParameters.Move(A);

//  actShowCategoryParametersQuery.Execute;

  ANewIDListArr := ComponentsExGroup.CatParamsGroup.GetIDList
    (ACI.IDCategoryParam);

  ANewIDList := TIDList.Create;
  ANewIDList.AddRange(ANewIDListArr);
  try
    // ���� ������� �������� � ��� �� �����
    if AOldBandInfo.IDList.IsSame(ANewIDList.ToArray) then
    begin
      AOldBandInfo.IDList.Assign(ANewIDList.ToArray);

      // ��������� ������� � ������ �����
      AColumn.Position.BandIndex := AOldBandInfo.Band.Index;

      // ��������� ������� ������
      UpdateBandsPosition;

      // ��������� ������� ������� � ���� �����!
      UpdateColumnPosition(AOldBandInfo);
    end
    else
    begin

      // ����, ���� �� � ��� ����, � ������� ������ ���� �������?
      ABandInfo := FBandsInfo.SearchByIDList(ANewIDList.ToArray);

      if ABandInfo <> nil then
      begin
        // ������� �������� � ��� �� �����. ��������� ������ �������
        Assert(ABandInfo.IDList.Count = 1);
        Assert(ABandInfo.IDList.IndexOf(ACI.IDCategoryParam) = 0);

        // �������� ������� � � ������ ����!
        AColumn.Position.BandIndex := ABandInfo.Band.Index;

        // ��������� ������� ������
        UpdateBandsPosition;
      end
      else
      begin
        // ���� ������� ����� �������� ������ � ��������� ����� ����
        // ��������� ����� ����
        if ANewIDList.Count = 1 then
        begin
          Assert(ANewIDList[0] = ACI.IDCategoryParam);
          // ������ ���� ������� ������� �� ���� �������
          Assert(AOldBandInfo.IDList.Count >= 2);
          // ���� ������� ������ ���� � ������� ������� �����!
          Assert(AOldBandInfo.IDList.IndexOf(ACI.IDCategoryParam) >= 0);
          // ������� ������������� ����� ������� �� ��������������� ������� �����
          AOldBandInfo.IDList.Remove(ACI.IDCategoryParam);

          // ������ ����� ����
          ABandInfo := CreateBandInfoEx([MainView, GridView(cxGridLevel2)],
            [ACI.IDCategoryParam]);
          FBandsInfo.Add(ABandInfo);

          qCategoryParameters.LocateByPK(ACI.IDCategoryParam, True);

          // �������������� ����� ����
          InitializeBandInfo(ABandInfo as TBandInfoEx, ANewIDList.ToArray,
            qCategoryParameters);

          // �������� ������� � ��� ����� ����!
          AColumn.Position.BandIndex := ABandInfo.Band.Index;

          UpdateBandsPosition;
        end
        else
        begin
          // ������������ ������� ����� ����� �������� ����������� � �������. �����
          if AOldBandInfo.IDList.Count = 1 then
          begin
            Assert(ACI.IDCategoryParam = AOldBandInfo.IDList[0]);
            // ������� ������ ����������� � ������������� �����
            Assert(ANewIDList.IndexOf(ACI.IDCategoryParam) >= 0);
            Assert(ANewIDList.Count >= 2);

            // ����� ��� ������������� ����� �� ������������?
            AIDList := TIDList.Create;
            try
              AIDList.AddRange(ANewIDList.ToArray);
              AIDList.Remove(ACI.IDCategoryParam);

              // ���� ����, � ������� ������ �������
              ABandInfo := FBandsInfo.SearchByIDList(AIDList.ToArray, True);
            finally
              FreeAndNil(AIDList);
            end;
            ABandInfo.IDList.Assign(ANewIDList.ToArray);

            // �������� ������� � � ����!
            AColumn.Position.BandIndex := ABandInfo.Band.Index;
            // ��������� ������� ������� � ���� �����!
            UpdateColumnPosition(ABandInfo);

            // ����� ������� ������ ���� - �� ������� ��� �������
            FBandsInfo.FreeBand(AOldBandInfo);
          end
          else
          begin
            // �� ������������ ������� ����� ����������� ����������� � �������. �����
            // ������� ������ ����������� � ������������� �����
            Assert(AOldBandInfo.IDList.Count >= 2);
            Assert(ANewIDList.Count >= 2);
            Assert(AOldBandInfo.IDList.IndexOf(ACI.IDCategoryParam) >= 0);
            Assert(ANewIDList.IndexOf(ACI.IDCategoryParam) >= 0);

            // ����� ��� ������������� ����� �� ������������?
            AIDList := TIDList.Create;
            try
              AIDList.AddRange(ANewIDList.ToArray);
              AIDList.Remove(ACI.IDCategoryParam);

              // ���� ����, � ������� ������ �������
              ABandInfo := FBandsInfo.SearchByIDList(AIDList.ToArray, True);
            finally
              FreeAndNil(AIDList);
            end;
            ABandInfo.IDList.Assign(ANewIDList.ToArray);
            AOldBandInfo.IDList.Remove(ACI.IDCategoryParam);

            // �������� ������� � � ����!
            AColumn.Position.BandIndex := ABandInfo.Band.Index;
            // ��������� ������� ������� � ���� �����!
            UpdateColumnPosition(ABandInfo);
          end;
        end;
      end;
    end;
  finally
    FreeAndNil(ANewIDList);
  end;

  FColMoveArray := A;
  ColumnTimer.Enabled := True;

  // ��������� ������� �� �������
  {

    ComponentsExGroup.CatParamsGroup.ApplyUpdates;
    FColumnsInfo.SaveColumnPosition;

    // ���� �������� ������� � �� ��� �������� �������
    for APair in A do
    begin
    ACI := FColumnsInfo.Search(APair.Key, True);

    // ����������, ����� ������ ������� � ���� ������� � ��
    ACI.Order := APair.Value;
    end;

    // �������� ����-�� � ���, ��� �� �������� �������
    ComponentsExGroup.OnParamOrderChange.CallEventHandlers(Self);
  }
end;

procedure TViewParametricTable.RecreateColumns;
var
  ABandInfo: TBandInfo;
  qCatParams: TQryCategoryParameters;
begin
  FreeAndNil(FColumnsBarButtons);
  try

    ComponentsExGroup.CatParamsGroup.LoadData;
    qCatParams := ComponentsExGroup.CatParamsGroup.qCatParams;

    // �������� � ��� ��� �� ������ ���������
    if qCatParams.RecordCount = 0 then
      Exit;

    qCatParams.First;

    // DisableCollapsingAndExpanding;
    // cxGrid.BeginUpdate();
    try
      // ������� ������� ����� ����������� �������
      DeleteColumns;
      // ����� ������� ����� ����������� �����
      DeleteBands;

      // ���� �� ������ (����������)
      while not qCatParams.Eof do
      begin
        CreateColumnsForBand(qCatParams.ID.AsInteger);
        qCatParams.Next;
      end;

      // ���������� � ����� ������� ��������� ��� ����
      for ABandInfo in FBandsInfo do
        ABandInfo.ColIndex := ABandInfo.Band.Position.ColIndex;

      UpdateGeneralIndexes;
      FColumnsInfo.SaveColumnPosition;

    finally
      MainView.ViewData.Collapse(True);

      // EnableCollapsingAndExpanding;
      // PostMyApplyBestFitEvent;
      // cxGrid.EndUpdate;
      // EndUpdate;
    end;
    // PostMyApplyBestFitEvent;

  finally
    FColumnsBarButtons := TColumnsBarButtonsEx2.Create(Self, dxbsColumns,
      MainView, cxGridDBBandedTableView2);
  end;
end;

procedure TViewParametricTable.UpdateBandsPosition;
var
  A: TArray<Integer>;
  ABand: TcxGridBand;
  ABI: TBandInfo;
  AIDList: TList<Integer>;
  i: Integer;
  k: Integer;
begin
  if qCategoryParameters.FDQuery.RecordCount = 0 then
    Exit;

  k := 0;
  // �������, ������� ������ � ��� ������
  for i := 0 to MainView.Bands.Count - 1 do
  begin
    ABand := MainView.Bands[i];
    if not ABand.Visible then
      Inc(k);
  end;

  AIDList := TList<Integer>.Create;
  try
    qCategoryParameters.FDQuery.First;
    AIDList.Add(qCategoryParameters.PK.AsInteger);

    while not qCategoryParameters.FDQuery.Eof do
    begin
      // ���� ��������� ������ ��������� � ��� �� ������
      if qCategoryParameters.NextEx then
        AIDList.Add(qCategoryParameters.PK.AsInteger)
      else
      begin
        // ���� ���� � ������ ����������������
        A := AIDList.ToArray;
        ABI := FBandsInfo.SearchByIDList(A, True);
        Inc(k);
        ABI.UpdateBandPosition(k);

        if qCategoryParameters.FDQuery.Eof then
          Exit;

        AIDList.Clear;
        AIDList.Add(qCategoryParameters.PK.AsInteger);
      end;
    end;
  finally
    FreeAndNil(AIDList);
  end;
end;

procedure TViewParametricTable.UpdateColumnPosition(ABandInfo: TBandInfo);
var
  ACI: TColumnInfo;
  AColIndex: Integer;
  AID: Integer;
begin
  Assert(ABandInfo <> nil);

  // ������� ����������� � ������� ���������� �� ���������������

  AColIndex := 0;
  for AID in ABandInfo.IDList do
  begin
    // ���� �������
    ACI := FColumnsInfo.Search(AID, True);
    Assert(ACI.Column.Position.Band = ABandInfo.Band);
    // �������� ������� �������
    ACI.SetColumnPosition(ABandInfo.Band.Index, AColIndex);

    Inc(AColIndex);
  end;
end;

procedure TViewParametricTable.UpdateColumns;
var
  ABI: TBandInfo;
  ANewIDList: TArray<Integer>;
  AIDCategoryParam: Integer;
  AIDList: TIDList;
  ARecHolder: TRecordHolder;
begin
  // ������� �������
  for ARecHolder in qCategoryParameters.DeletedSubParams do
  begin
    AIDCategoryParam := ARecHolder.Field[qCategoryParameters.PKFieldName];
    DropColumn(AIDCategoryParam);
  end;

  // ��������� �������
  for ARecHolder in qCategoryParameters.EditedSubParams do
  begin
    AIDCategoryParam := ARecHolder.Field[qCategoryParameters.PKFieldName];
    UpdateColumn(AIDCategoryParam);
  end;

  // ��������� �������
  DisableCollapsingAndExpanding;
  try
    for ARecHolder in qCategoryParameters.InsertedSubParams do
    begin
      AIDCategoryParam := ARecHolder.Field[qCategoryParameters.PKFieldName];

      // ����� ��������������
      ANewIDList := ComponentsExGroup.CatParamsGroup.GetIDList
        (AIDCategoryParam);

      // ���� ���� � ������� ������ ������� ���� �������
      ABI := FBandsInfo.SearchByID(ANewIDList[0], True);
      ABI.IDList.Assign(ANewIDList);

      qCategoryParameters.LocateByPK(AIDCategoryParam, True);
      // ������ ������� ��� �����
      CreateColumn([MainView, GridView(cxGridLevel2)], ABI,
        qCategoryParameters);
    end;
  finally
    EnableCollapsingAndExpanding;
  end;

  UpdateGeneralIndexes;
end;

procedure TViewParametricTable.UpdateColumnsCustomization;
var
  ABI: TBandInfo;
  AGVBandActionEx: TGVBandActionEx;
  AdxBarButton: TdxBarButton;
  i: Integer;
begin
  // ��������� ��� ����� ����� �� �����
  FBandsInfo.Sort(TComparer<TBandInfo>.Construct(
    function(const Left, Right: TBandInfo): Integer
    begin
      Result := (Left.ColIndex - Right.ColIndex);
    end));

  // ������� � 3-�� ������
  i := 2;
  for ABI in FBandsInfo do
  begin
    if (ABI.Band.GridView <> MainView) or (not ABI.Band.VisibleForCustomization)
    then
      Continue;

    // �������� ������
    AdxBarButton := dxbsColumns.ItemLinks[i].Item as TdxBarButton;

    // � ���� ������� ������ ���� ������� ������� ��� ������
    Assert(AdxBarButton.Action is TGVBandActionEx);
    AGVBandActionEx := AdxBarButton.Action as TGVBandActionEx;

    // ����������� ��� �������� � ������� �����
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
    // �������� ������� ������� � �������� ���
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

procedure TViewParametricTable.UpdateGeneralIndexes;
var
  A: TArray<TcxGridDBBandedColumn>;
begin
  A := GetColumns(MainView);

  // ��������� ���� �������
  TArray.Sort<TcxGridDBBandedColumn>(A,
    TComparer<TcxGridDBBandedColumn>.Construct(
    function(const Left, Right: TcxGridDBBandedColumn): Integer
    begin
      // ������� ���������� ������� ������
      Result := TComparer<Integer>.Default.Compare(Left.Position.BandIndex,
        Right.Position.BandIndex);
      // ���� ������� ����������� ������ ����� ���������� ��������� � �����
      if Result = 0 then
        Result := TComparer<Integer>.Default.Compare(Left.Position.ColIndex,
          Right.Position.ColIndex);
    end));

  // ��������� ���������� ����� ����� �������
  FColumnsInfo.UpdateGeneralIndexes(A);
end;

procedure TViewParametricTable.UpdateView;
var
  AView: TcxGridDBBandedTableView;
  OK: Boolean;
begin
  inherited;

  AView := FocusedTableView;

  OK := (ComponentsExGroup <> nil) and
    (ComponentsExGroup.qFamilyEx.FDQuery.Active) and
    (ComponentsExGroup.qComponentsEx.FDQuery.Active);
  UpdateFiltersAction;
  actLocateInStorehouse.Enabled := OK and (AView.Level = cxGridLevel2) and
    (AView.DataController.RowCount > 0);
  // and (GridView(cxGridLevel2).DataController.RecordCount > 0);

  // ����� ������� ������ ���� �� ���������
  actAnalog.Enabled := OK and not actCommit.Enabled and
    (AView.DataController.RowCount > 0);
end;

constructor TShowDefaults.Create(AOwner: TComponent);
begin
  inherited;
  Caption := '�������� ������ ��������';
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
        // ���� ��������� �������� � ������ �������� "�� ���������"
        IsDefault := FDefaultActions.IndexOf(AAction) >= 0;

        // ���������� ��� �������� �������
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
  // ��������� �������� "�������� ��� �������"
  inherited;
  // ��������� �������� "�������� ����� �� ���������"
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
