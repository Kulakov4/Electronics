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
  ComponentsExGroupUnit2, System.Generics.Collections,
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
  CategoryParametersQuery2, cxCheckBox, cxBarEditItem,
  cxDataControllerConditionalFormattingRulesManagerDialog, dxBarBuiltInMenu,
  BaseComponentsGroupUnit2, DSWrap, dxDateRanges, ColInfo;

type
  TParametricTableLockInfo = class
  public
    BaseComponentsGroup: TBaseComponentsGroup2;
    Locked: Boolean;
    constructor Create;
  end;

  TViewParametricTable = class(TViewComponentsBase)
    actAutoWidth: TAction;
    dxbrbtnApplyUpdates: TdxBarButton;
    dxbbFullAnalog: TdxBarButton;
    actFullAnalog: TAction;
    actClearFilters: TAction;
    actAnalog: TAction;
    dxbbClearFilters: TdxBarButton;
    BandTimer: TTimer;
    dxBarButton1: TdxBarButton;
    actLocateInStorehouse: TAction;
    cxStyleRepository: TcxStyleRepository;
    cxStyleBegin: TcxStyle;
    cxStyleEnd: TcxStyle;
    dxBarButton3: TdxBarButton;
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
    actBandWidth: TAction;
    N10: TMenuItem;
    actColumnWidth: TAction;
    N11: TMenuItem;
    actColumnApplyBestFit: TAction;
    ColumnApplyBestFit1: TMenuItem;
    actBandAutoHeight: TAction;
    N12: TMenuItem;
    actBandAutoWidth: TAction;
    N13: TMenuItem;
    actChangeBandWidth: TAction;
    ChangeBandWidth1: TMenuItem;
    ColumnTimer: TTimer;
    actShowCategoryParametersQuery: TAction;
    actBandIDList: TAction;
    N14: TMenuItem;
    actUpdateDetailColumnWidth2: TAction;
    cxbeiTableName: TcxBarEditItem;
    actUpdateColumnWidth: TAction;
    actTestBandsID: TAction;
    actTestBandsID1: TMenuItem;
    actChangeCount: TAction;
    procedure actAddSubParameterExecute(Sender: TObject);
    procedure actAutoWidthExecute(Sender: TObject);
    procedure actClearFiltersExecute(Sender: TObject);
    procedure actFullAnalogExecute(Sender: TObject);
    procedure actLocateInStorehouseExecute(Sender: TObject);
    procedure actAnalogExecute(Sender: TObject);
    procedure actBandAutoHeightExecute(Sender: TObject);
    procedure actBandAutoWidthExecute(Sender: TObject);
    procedure actBandIDListExecute(Sender: TObject);
    procedure actBandWidthExecute(Sender: TObject);
    procedure actChangeBandWidthExecute(Sender: TObject);
    procedure actClearSelectedExecute(Sender: TObject);
    procedure actColumnApplyBestFitExecute(Sender: TObject);
    procedure actColumnWidthExecute(Sender: TObject);
    procedure actDropParameterExecute(Sender: TObject);
    procedure actDropSubParameterExecute(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
    procedure actShowCategoryParametersQueryExecute(Sender: TObject);
    procedure actTestBandsIDExecute(Sender: TObject);
    procedure actUpdateColumnWidthExecute(Sender: TObject);
    procedure actChangeCountExecute(Sender: TObject);
    procedure actUpdateDetailColumnWidth2Execute(Sender: TObject);
    procedure cxGridDBBandedTableViewBandPosChanged
      (Sender: TcxGridBandedTableView; ABand: TcxGridBand);
    procedure cxGridDBBandedTableViewInitEditValue
      (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
      AEdit: TcxCustomEdit; var AValue: Variant);
    procedure cxGridDBBandedTableViewDataControllerFilterChanged
      (Sender: TObject);
    procedure cxGridDBBandedTableViewMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
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
    procedure cxbeiTableNamePropertiesChange(Sender: TObject);
    procedure cxGridDBBandedTableViewColumnSizeChanged(Sender: TcxGridTableView;
      AColumn: TcxGridColumn);
    // TODO: cxGridDBBandedTableViewDataControllerFilterChanged
    // procedure cxGridDBBandedTableViewDataControllerFilterChanged
    // (Sender: TObject);
  private
    FBandInfo: TBandInfo;
    FBandsInfo: TBandsInfo;
    FColumnsInfo: TColumnsInfo;
    FLockDetailFilterChange: Boolean;
    FMark: string;
    FColMoveArray: TArray<TPair<Integer, Integer>>;
    FLockInfo: TParametricTableLockInfo;
    FSortSL: TList<String>;
    procedure CreateColumn(AViewArray: TArray<TcxGridDBBandedTableView>;
      AIDList: TArray<Integer>;
      qCategoryParameters: TQueryCategoryParameters2); overload;
    procedure CreateColumn(ABandInfo: TBandInfo;
      qCategoryParameters: TQueryCategoryParameters2); overload;
    procedure DeleteBands;
    procedure DeleteColumns;
    procedure DoAfterFamilyExOpen(Sender: TObject);
    procedure DoOnEditValueChanged(Sender: TObject);
    procedure DoOnGetDataText(Sender: TcxCustomGridTableItem;
      ARecordIndex: Integer; var AText: string);
    procedure DoOnGetFilterValues(Sender: TcxCustomGridTableItem;
      AValueList: TcxDataFilterValueList);
    procedure DoOnUserFilteringEx(Sender: TcxCustomGridTableItem;
      AFilterList: TcxFilterCriteriaItemList; const AValue: Variant;
      const ADisplayText: string);
    procedure DoOnValidate(Sender: TObject; var DisplayValue: Variant;
      var ErrorText: TCaption; var Error: Boolean);
    function GetclAnalog: TcxGridDBBandedColumn;
    procedure UpdateColumn(AIDCategoryParam: Integer);
    function GetComponentsExGroup: TComponentsExGroup2;
    function GetqCategoryParameters: TQueryCategoryParameters2;
    function GetUseTableName: Boolean;
    procedure InitializeDefaultCreatedBands(AViewArray
      : TArray<TcxGridDBBandedTableView>);
    procedure ProcessBandMove;
    procedure ProcessColumnMove(AColumn: TcxGridDBBandedColumn);
    procedure SetComponentsExGroup(const Value: TComponentsExGroup2);
    procedure SetUseTableName(const Value: Boolean);
    // TODO: UpdateColumnPosition
    // procedure UpdateColumnPosition(ABandInfo: TBandInfo);
    procedure UpdateColumns;
    procedure UpdateColumnsCustomization;
    { Private declarations }
  protected
    procedure ApplyFilter;
    function CreateBandInfoEx(AViewArray: TArray<TcxGridDBBandedTableView>;
      const AIDList: TArray<Integer>): TBandInfoEx;
    function CreateColInfoArray: TArray<TColInfo>; override;
    procedure CreateColumnsBarButtons; override;
    procedure CreateColumnsForBand(AIDCategoryParam: Integer);
    procedure CreateDetailFilter;
    procedure DoAfterLoadData; override;
    procedure DoBeforeFamilyExOpen(Sender: TObject);
    // TODO: CreateFilter
    // procedure CreateFilter(AColumn: TcxGridDBBandedColumn;
    // const AValue: string);
    procedure DoOnMasterDetailChange; override;
    procedure DropColumn(AIDCategoryParam: Integer);
    function GetBandCaption(qryCategoryParameters
      : TQueryCategoryParameters2): string;
    procedure InitComponentsColumns; override;
    procedure InitializeBandInfo(ABandInfo: TBandInfoEx;
      const AIDList: TArray<Integer>;
      qCategoryParameters2: TQueryCategoryParameters2);
    procedure OnGridBandHeaderPopupMenu(ABand: TcxGridBand;
      var AllowPopup: Boolean); override;
    procedure OnGridColumnHeaderPopupMenu(AColumn: TcxGridDBBandedColumn;
      var AllowPopup: Boolean); override;
    procedure OnGridRecordCellPopupMenu(AColumn: TcxGridDBBandedColumn;
      var AllowPopup: Boolean); override;
    procedure RecreateColumns;
    procedure UpdateBandsCaptions;
    procedure UpdateBandsPosition;
    procedure UpdateDetailColumnsWidth2;
    procedure UpdateFiltersAction;
    procedure UpdateGeneralIndexes;
    property qCategoryParameters: TQueryCategoryParameters2
      read GetqCategoryParameters;
    property SortSL: TList<String> read FSortSL;
    property UseTableName: Boolean read GetUseTableName write SetUseTableName;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure FilterByFamily(AFamily: string);
    procedure FilterByComponent(AComponent: string);
    procedure Lock;
    procedure Unlock;
    function UpdateMinBandWindth(ABandInfo: TBandInfoEx): TRect;
    procedure UpdateView; override;
    property clAnalog: TcxGridDBBandedColumn read GetclAnalog;
    property ComponentsExGroup: TComponentsExGroup2 read GetComponentsExGroup
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
  GridExtension, DragHelper, System.Math, AnalogForm, AnalogQueryes,
  AnalogGridView, SearchProductByParamValuesQuery, NaturalSort,
  CategoryParametersGroupUnit2, FireDAC.Comp.Client, MoveHelper,
  SubParametersForm, System.Types, TextRectHelper, GridViewForm2, DialogUnit,
  FamilyExQuery;

constructor TViewParametricTable.Create(AOwner: TComponent);
begin
  inherited;
  ShowHint := false;

  FLockInfo := TParametricTableLockInfo.Create;

  FBandsInfo := TBandsInfo.Create;
  FColumnsInfo := TColumnsInfo.Create;

  ApplyBestFitMultiLine := True;
  FSortSL := TList<String>.Create;
end;

destructor TViewParametricTable.Destroy;
// var
// ABI: TBandInfo;
// I: Integer;
begin
  {
    for I := FBandsInfo.Count - 1 downto 0 do
    begin
    ABI := FBandsInfo[i];
    FBandsInfo.Delete(i);
    FreeAndNil(ABI);
    end;
  }

  // FBandsInfo ������� ����� ����������
  FreeAndNil(FBandsInfo);

  FreeAndNil(FColumnsInfo);

  FreeAndNil(FLockInfo);

  FreeAndNil(FSortSL);

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

  // ���� ��������� ��������� �� �������
  if not ComponentsExGroup.CatParamsGroup.ApplyOrCancelUpdates then
  begin
    Exit;
  end;

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

    FLockDetailFilterChange := false;
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

  AnalogGroup := TAnalogGroup.Create(nil);
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
          qCategoryParameters.W.LocateByPK(ACI.IDCategoryParam);
          AParamSubParamId := qCategoryParameters.W.ParamSubParamId.F.AsInteger;

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
      if not AnalogGroup.Load(AProductCategoryID, ARecHolder,
        ComponentsExGroup.AllParameterFields) then
      begin
        TDialog.Create.NoParametersForAnalog;
        Exit;
      end;

      AfrmAnalog := TfrmAnalog.Create(Self);
      try
        AfrmAnalog.ViewAnalogGrid.UseTableName := UseTableName;
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

procedure TViewParametricTable.actBandIDListExecute(Sender: TObject);
var
  ABand: TcxGridBand;
  ABI: TBandInfo;
  AID: Integer;
  S: string;
begin
  inherited;
  Assert(FHitTest <> nil);
  Assert(FHitTest is TcxGridBandHeaderHitTest);

  ABand := (FHitTest as TcxGridBandHeaderHitTest).Band;
  ABI := FBandsInfo.Search(ABand, True);

  S := '';
  for AID in ABI.IDList do
    S := S + IfThen(S.IsEmpty, '', ',') + AID.ToString;

  ShowMessage(S);
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
        [qCategoryParameters.W.ParamSubParamId.F.AsInteger];

      AColumn := AView.GetColumnByFieldName(AFieldName);

      if AColumn.Selected then
        AFieldList.Add(AFieldName);

      qCategoryParameters.FDQuery.Next;
    end;

    Assert(clID.Index = clID2.Index);
    m := GetSelectedIntValues(AView, clID.Index);

    BeginUpdate;
    try
      FocusedQuery.W.ClearFields(AFieldList.ToArray, m);
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

  // ���� �� ������� ��������� ��������� ���������
  if not ComponentsExGroup.CatParamsGroup.ApplyOrCancelUpdates then
    Exit;

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

  // ���� �� ������� ��������� ��������� ���������
  if not ComponentsExGroup.CatParamsGroup.ApplyOrCancelUpdates then
    Exit;

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
  FocusTopLeft(clValue.DataBinding.FieldName);
end;

procedure TViewParametricTable.actShowCategoryParametersQueryExecute
  (Sender: TObject);
var
  AfrmGridView: TfrmGridView2;
begin
  inherited;
  Application.Hint := '';
  AfrmGridView := TfrmGridView2.Create(Self);
  try
    AfrmGridView.ViewGridEx.DSWrap := qCategoryParameters.Wrap;
    AfrmGridView.ShowModal;
  finally
    FreeAndNil(AfrmGridView);
  end;
end;

procedure TViewParametricTable.actTestBandsIDExecute(Sender: TObject);
var
  ABI: TBandInfo;
begin
  inherited;
  for ABI in FBandsInfo do
  begin
    if not ABI.Band.Visible then
      Continue;

    // if ABI.IDList.Count = 0 then
    // beep;
  end;
end;

procedure TViewParametricTable.actUpdateColumnWidthExecute(Sender: TObject);
var
  ACol: TcxGridDBBandedColumn;
begin
  inherited;
  ACol := MainView.GetColumnByFieldName(clValue.DataBinding.FieldName);
  ACol.Position.Band.Width := 0;
  ACol.ApplyBestFit();
end;

procedure TViewParametricTable.actChangeCountExecute(Sender: TObject);
var
  S: string;
begin
  inherited;
  S := Format('%d - %d', [ComponentsExGroup.qFamilyEx.FDQuery.ChangeCount,
    ComponentsExGroup.qComponentsEx.FDQuery.ChangeCount]);

  ShowMessage(S);
end;

procedure TViewParametricTable.actUpdateDetailColumnWidth2Execute
  (Sender: TObject);
begin
  inherited;
  UpdateDetailColumnsWidth;
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
    AValueList.Add(fviUserEx, Format('%%%s%s%s%%', [Mark, S, Mark]), S, false);
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

procedure TViewParametricTable.cxbeiTableNamePropertiesChange(Sender: TObject);
begin
  inherited;
  (Sender as TcxCheckBox).PostEditValue;
  UseTableName := (Sender as TcxCheckBox).Checked;
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

  (* ********************************************************* *)
  // ������ �� ����� ��������� ����� ��������� ������ � ��
  (* ********************************************************* *)
  {
    // �������� ��� ��������� ������ ����� ����� ������������� ����������
    FBandInfo := ABandInfo;
    BandTimer.Enabled := True;
  }
end;

var
  FInChange: Boolean = false;

procedure TViewParametricTable.
  cxGridDBBandedTableViewDataControllerFilterChanged(Sender: TObject);
begin
  if FLockDetailFilterChange then
    Exit;

  inherited;
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

procedure TViewParametricTable.DoAfterFamilyExOpen(Sender: TObject);
begin
  RecreateColumns;

  PostMyApplyBestFitEvent;
  EndUpdate;
end;

procedure TViewParametricTable.DoOnEditValueChanged(Sender: TObject);
var
  AColumn: TcxGridDBBandedColumn;
begin
  // ��������� ������������� �������� � ���� (��� ������ ��� ��������� ���������)
  (Sender as TcxCustomEdit).PostEditValue;

  ComponentsExGroup.TryPost;
  UpdateView;

  if not(FocusedTableView = MainView) then
    Exit;

  AColumn := (MainView.Controller.FocusedColumn as TcxGridDBBandedColumn);
  MyApplyBestFitForBand(AColumn.Position.Band);
  UpdateDetailColumnsWidth;
end;

procedure TViewParametricTable.DoOnMasterDetailChange;
begin
  inherited;
  Assert(not FLockInfo.Locked);
  if BaseCompGrp = nil then
    Exit;

  FMark := ComponentsExGroup.Mark;

  TNotifyEventWrap.Create(ComponentsExGroup.qFamilyEx.W.BeforeOpen,
    DoBeforeFamilyExOpen, FEventList);

  TNotifyEventWrap.Create(ComponentsExGroup.qFamilyEx.W.AfterOpen,
    DoAfterFamilyExOpen, FEventList);

  // ���� ����� �� ��������� ��� �� ����������������
  if FBandsInfo.Count = 0 then
    InitializeDefaultCreatedBands([MainView, GridView(cxGridLevel2)]);

  // ���� ������ ������� � �� ������� ����������
  if ComponentsExGroup.qFamilyEx.Actual then
  begin
    RecreateColumns;
    PostMyApplyBestFitEvent;
  end;

  Assert(cxGridPopupMenu.PopupMenus.Count = 4);

  cxGridPopupMenu.PopupMenus.Items[2].GridView := MainView;
  cxGridPopupMenu.PopupMenus.Items[3].GridView := MainView;
  PostMessageUpdateDetailColumnsWidth;
end;

procedure TViewParametricTable.FilterByFamily(AFamily: string);
var
  AColumn: TcxGridDBBandedColumn;
  AFilterList: TcxFilterCriteriaItemList;
begin
  Assert(not AFamily.IsEmpty);
  AColumn := MainView.GetColumnByFieldName
    (ComponentsExGroup.qFamilyEx.W.Value.FieldName);
  Assert(AColumn <> nil);

  FLockDetailFilterChange := True;
  try
    AFilterList := MainView.DataController.Filter.root;
    AFilterList.Clear;
    AFilterList.BoolOperatorKind := fboAnd;
    AFilterList.AddItem(AColumn, foEqual, AFamily, AFamily);
    MainView.DataController.Filter.Active := True;
  finally
    FLockDetailFilterChange := false;
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
    (ComponentsExGroup.qComponentsEx.W.Value.FieldName);
  Assert(AColumn <> nil);

  FLockDetailFilterChange := True;
  try
    AFilterList := GridView(cxGridLevel2).DataController.Filter.root;
    AFilterList.Clear;
    AFilterList.BoolOperatorKind := fboAnd;
    AFilterList.AddItem(AColumn, foEqual, AComponent, AComponent);
    GridView(cxGridLevel2).DataController.Filter.Active := True;
  finally
    FLockDetailFilterChange := false;
  end;

  // ������������� ������������� �����������
  ARow := GetRow(0) as TcxMyGridMasterDataRow;
  Assert(ARow <> nil);
  AView := GetDBBandedTableView(1);
  ARow.MyExpand(false);
  AView.Focused := True;
end;

function TViewParametricTable.GetComponentsExGroup: TComponentsExGroup2;
begin
  Result := BaseCompGrp as TComponentsExGroup2;
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
        AColumn.Position.Band.Visible := false;
        AColumn.Position.Band.VisibleForCustomization := false;

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

procedure TViewParametricTable.SetComponentsExGroup
  (const Value: TComponentsExGroup2);
begin
  BaseCompGrp := Value;
end;

procedure TViewParametricTable.BandTimerTimer(Sender: TObject);
begin
  inherited;
  BandTimer.Enabled := false;
  ProcessBandMove;
end;

procedure TViewParametricTable.ColumnTimerTimer(Sender: TObject);
var
  ACI: TColumnInfo;
  APair: TPair<Integer, Integer>;
begin
  inherited;
  ColumnTimer.Enabled := false;

  if not ComponentsExGroup.CatParamsGroup.ApplyOrCancelUpdates then
  begin
    // ��������������� ������� �������
    FColumnsInfo.RestoreColumnPosition;
    Exit;
  end;

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

function TViewParametricTable.CreateColInfoArray: TArray<TColInfo>;
Var
  W: TFamilyExW;
begin
  W := ComponentsExGroup.qFamilyEx.FamilyExW;

  Result := [TColInfo.Create(W.ID, 0), TColInfo.Create(W.Analog, 0),
    TColInfo.Create(W.Value, 0, W.Value.DisplayLabel),
    TColInfo.Create(W.Producer, 1, W.Producer.FieldName),
    TColInfo.Create(W.DescriptionComponentName, 2,
    W.DescriptionComponentName.FieldName), TColInfo.Create(W.Datasheet, 3,
    W.Datasheet.FieldName), TColInfo.Create(W.Diagram, 4, W.Diagram.FieldName),
    TColInfo.Create(W.Drawing, 5, W.Drawing.FieldName),
    TColInfo.Create(W.Image, 6, W.Image.FieldName)]
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
    (qCategoryParameters.W.ParamSubParamId.F.AsInteger);

  if ABandInfo <> nil then
  begin
    // ���� ����� ����� ������� ��������� ������
    // ���� "�� ���������" ������ ������ � ����� ������������� "�� ���������"
    Assert(Length(AIDList) = 1);
    // ���������� ������������� ����� �����
    ABandInfo.IDList.AddRange(AIDList)
  end
  else
  begin
    // ���� �� ��������������� �����
    ABandInfo := FBandsInfo.SearchByIDList(AIDList);
  end;

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

  CreateColumn(ABandInfo, qCategoryParameters);
end;

procedure TViewParametricTable.CreateColumn(ABandInfo: TBandInfo;
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

  AParamSubParamId := qCategoryParameters.W.ParamSubParamId.F.AsInteger;

  // ����, �������� ����� ������� ��� ����?
  ACI := FColumnsInfo.Search(qCategoryParameters.W.PK.AsInteger);
  if ACI <> nil then
  begin
    // ��� ������� ������ ������������ ����� �����
    Assert(ACI.Column.Position.Band = ABandInfo.Band);
  end
  else // ���� ����� ������� �� ��������� ���
  begin
    // ������ ����������� �������
    AColumnList := TList<TcxGridDBBandedColumn>.Create;
    try
      // ���� ����� ���� �� ����������� �� "���������"
      if not ABandInfo.DefaultCreated then
      begin
        // ���� �� ���� ������
        for ABand in (ABandInfo as TBandInfoEx).Bands do
        begin
          // ������ ������� ��� ����� �����
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
            (AColumn.Properties as TcxMemoProperties).WordWrap := false;

            (AColumn.Properties as TcxMemoProperties).OnValidate :=
              DoOnValidate;

            (AColumn.Properties as TcxMemoProperties).OnEditValueChanged :=
              DoOnEditValueChanged;
            AColumn.OnUserFilteringEx := DoOnUserFilteringEx;
            AColumn.OnGetFilterValues := DoOnGetFilterValues;
          end
          else
          begin
            AColumn.PropertiesClass := TcxTextEditProperties;
            (AColumn.Properties as TcxTextEditProperties).OnEditValueChanged :=
              DoOnEditValueChanged;
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
        qCategoryParameters.W.PK.AsInteger,
        qCategoryParameters.W.Ord.F.AsInteger, ABandInfo.DefaultCreated,
        qCategoryParameters.W.IsDefault.F.AsInteger = 1));
    finally
      FreeAndNil(AColumnList);
    end;
  end;
end;

procedure TViewParametricTable.CreateColumnsForBand(AIDCategoryParam: Integer);
var
  ACloneW: TCategoryParameters2W;
  AIDList: TList<Integer>;
begin
  Assert(AIDCategoryParam > 0);

  qCategoryParameters.W.LocateByPK(AIDCategoryParam, True);

  AIDList := TList<Integer>.Create;
  // �������� ��� ������������ �������� �����
  ACloneW := qCategoryParameters.CreateSubParamsClone;
  try
    // ���������� ������ ��������������� �������� �����
    while not ACloneW.DataSet.Eof do
    begin
      AIDList.Add(ACloneW.ID.F.AsInteger);
      ACloneW.DataSet.Next;
    end;

    ACloneW.DataSet.First;
    while not ACloneW.DataSet.Eof do
    begin
      // ��������� �� ��������� �����������
      qCategoryParameters.W.LocateByPK(ACloneW.ID.F.AsInteger, True);

      // ������ �������
      CreateColumn([MainView, GridView(cxGridLevel2)], AIDList.ToArray,
        qCategoryParameters);

      ACloneW.DataSet.Next;
    end;
  finally
    qCategoryParameters.W.DropClone(ACloneW.DataSet as TFDMemTable);
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
  Application.Hint := '';
  (* ********************************************************* *)
  // ������ �� ����� ��������� ��������� ������� � ��
  (* ********************************************************* *)
  ProcessColumnMove(AColumn as TcxGridDBBandedColumn);
end;

procedure TViewParametricTable.cxGridDBBandedTableViewColumnSizeChanged
  (Sender: TcxGridTableView; AColumn: TcxGridColumn);
begin
  inherited;
  beep;
end;

procedure TViewParametricTable.DoAfterLoadData;
begin
  // �� �� ������ ������������ ������� ����� �������� ������
  PostMessage(Handle, WM_FOCUS_TOP_LEFT, 0, 0);
end;

procedure TViewParametricTable.DoBeforeFamilyExOpen(Sender: TObject);
begin
  BeginUpdate;
end;

procedure TViewParametricTable.DoOnValidate(Sender: TObject;
  var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
var
  AStringList: TStringList;
  m: TArray<String>;
  S: String;
  S1: string;
begin
  S := VarToStrDef(DisplayValue, '');
  if S.IsEmpty then
    Exit;

  // ���� ��� �������� ��� ���� ��������������!
  if S.Contains(Mark) then
    Exit;

  AStringList := TStringList.Create;
  try
    m := S.Split([#13]);
    for S1 in m do
    begin
      S := S1.Trim([#10, ' ']);
      if S.IsEmpty then
        Continue;

      AStringList.Add(Format('%s%s%s', [Mark, S, Mark]))
    end;
    DisplayValue := AStringList.Text.Trim([#13, #10, ' ']);
  finally
    FreeAndNil(AStringList);
  end;
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

    // ������� ���� �������
    ACI.FreeColumn;

    // ������� ���������� � ���� �������
    FColumnsInfo.Remove(ACI);
    // ACI.Free;

    // �������� �� ������� ��������� ������� �����
    if ABand.ColumnCount = 0 then
    begin
      // ������� ��� ����
      ABI.FreeBand;

      // ������� ���������� � �����
      FBandsInfo.Remove(ABI);
      // ABI.Free;
    end;
  end;
end;

function TViewParametricTable.GetBandCaption(qryCategoryParameters
  : TQueryCategoryParameters2): string;
begin
  Assert(qryCategoryParameters <> nil);
  Assert(qryCategoryParameters.FDQuery.RecordCount > 0);

  if UseTableName then
    Result := qCategoryParameters.W.TableName.F.AsString
  else
    Result := qCategoryParameters.W.Value.F.AsString;

  Result := DeleteDouble(Result, ' ');
end;

function TViewParametricTable.GetclAnalog: TcxGridDBBandedColumn;
begin
  Result := MainView.GetColumnByFieldName
    (ComponentsExGroup.qFamilyEx.FamilyExW.Analog.FieldName);
  Result.Caption := '������';
end;

procedure TViewParametricTable.UpdateColumn(AIDCategoryParam: Integer);
var
  ACI: TColumnInfoEx;
  AColumn: TcxGridDBBandedColumn;
begin
  ACI := FColumnsInfo.Search(AIDCategoryParam, True) as TColumnInfoEx;
  qCategoryParameters.W.LocateByPK(AIDCategoryParam, True);

  // ��������� ������� ����, ��� ��� ����������� �� ���������
  ACI.IsDefault := qCategoryParameters.W.IsDefault.F.AsInteger = 1;

  for AColumn in ACI.Columns do
  begin
    AColumn.Caption := DeleteDouble(qCategoryParameters.W.Name.F.AsString, ' ');
    if AColumn.Caption.IsEmpty then
      AColumn.Caption := AColumn.Caption + ' ';

    AColumn.AlternateCaption :=
      DeleteDouble(qCategoryParameters.W.Translation.F.AsString, ' ');
  end;
end;

function TViewParametricTable.GetqCategoryParameters: TQueryCategoryParameters2;
begin
  Result := ComponentsExGroup.CatParamsGroup.qCategoryParameters;
end;

function TViewParametricTable.GetUseTableName: Boolean;
var
  b: Boolean;
begin
  b := cxbeiTableName.EditValue;
  Result := b;
end;

procedure TViewParametricTable.InitComponentsColumns;
var
  ACol: TcxGridDBBandedColumn;
  AView: TcxGridDBBandedTableView;
  i: Integer;
begin
  inherited;

  for AView in ViewArr do
  begin
    // ��� ������� ���������� �������������
    for i := 0 to AView.ColumnCount - 1 do
    begin
      ACol := AView.Columns[i];
      ACol.Caption := ' ';
    end;
  end;
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
  ABandInfo.IsDefault := qCategoryParameters.W.IsDefault.F.AsInteger = 1;
  // �������� "�� ���������" ������ � �������� �����
  if qCategoryParameters.W.IsDefault.F.AsInteger = 1 then
    ABandInfo.IDParamSubParam := qCategoryParameters.W.ParamSubParamId.
      F.AsInteger;

  // ������ �� �� � ������������� �� ���������
  ABandInfo.IDParameter := qCategoryParameters.W.IDParameter.F.AsInteger;
  // ��������, � ������� ������ ����
  // ����������� �� "���������"
  ABandInfo.DefaultVisible := qCategoryParameters.W.IsAttribute.F.AsInteger = 1;
  ABandInfo.IDParameterKind := qCategoryParameters.W.IDParameterKind.F.
    AsInteger;
  ABandInfo.pos := qCategoryParameters.W.PosID.F.AsInteger;

  // �������������� ���� �����
  for ABand in ABandInfo.Bands do
  begin
    ABand.Visible := ABandInfo.DefaultVisible;
    ABand.Options.HoldOwnColumnsOnly := ABandInfo.DefaultCreated;
    ABand.VisibleForCustomization := True;

    ABand.Caption := GetBandCaption(qCategoryParameters);

    ABand.AlternateCaption :=
      DeleteDouble(qCategoryParameters.W.ValueT.F.AsString, ' ');
    if ABandInfo.DefaultCreated then
      ABand.Position.ColIndex := 1000; // �������� ���� � �����

  end;
  // ������ �����
  UpdateMinBandWindth(ABandInfo);
end;

procedure TViewParametricTable.Lock;
begin
  Assert(not FLockInfo.Locked);

  // ����������, � ����� ������ �� ������ ���� ����������
  FLockInfo.BaseComponentsGroup := BaseCompGrp;

  // ����������� �� ������
  BaseCompGrp := nil;

  FLockInfo.Locked := True;
  BeginUpdate;
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
  ComponentsExGroup.CatParamsGroup.qCategoryParameters.W.Move(A);

  // ���� �� ������� ��������� ��� ���������
  if not ComponentsExGroup.CatParamsGroup.ApplyOrCancelUpdates then
  begin
    FBandsInfo.RestoreBandPosition;
    Exit;
  end;

  // ���������� � ����� ������� ��������� ��� ����
  FBandsInfo.SaveBandPosition;

  // ���� �������� ������� � �� ��� �������� �������
  for APair in A do
  begin
    ACI := FColumnsInfo.Search(APair.Key, True);

    // ����������, ����� ������ ������� � ���� ������� � ��
    ACI.Order := APair.Value;
  end;

  // ���������� ����� ��������� ������� �������
  FColumnsInfo.SaveColumnPosition;
  // ���������� ����� ���������� ������� �������
  UpdateGeneralIndexes;

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
  // ABandInfo: TBandInfo;
  ACI: TColumnInfo;
  ACI2: TColumnInfo;
  ANewIDList: TIDList;
  ALeft: Boolean;
  AOldBandInfo: TBandInfoEx;
  // AIDList: TIDList;
  ANewIDListArr: TArray<Integer>;
  AOldIDListArr: TArray<Integer>;
  // APair: TPair<Integer, Integer>;
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
  qCategoryParameters.W.Move(A);

  // actShowCategoryParametersQuery.Execute;

  ANewIDListArr := ComponentsExGroup.CatParamsGroup.GetIDList
    (ACI.IDCategoryParam);

  ANewIDList := TIDList.Create;
  try
    ANewIDList.AddRange(ANewIDListArr);
    UpdateBandsPosition;
  finally
    FreeAndNil(ANewIDList);
  end;

  FColMoveArray := A;
  ColumnTimer.Enabled := True;
end;

procedure TViewParametricTable.RecreateColumns;
var
  qCatParams: TQryCategoryParameters;
begin
  if FColumnsBarButtons <> nil then
    FreeAndNil(FColumnsBarButtons);
  try

    ComponentsExGroup.CatParamsGroup.LoadData;
    qCatParams := ComponentsExGroup.CatParamsGroup.qCatParams;

    // �������� � ��� ��� �� ������ ���������
    if qCatParams.RecordCount = 0 then
      Exit;

    MainView.BeginUpdate();
    cxGridLevel2.GridView.BeginUpdate();
    try

      qCatParams.First;
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

      finally
        cxGridLevel2.GridView.EndUpdate;
        MainView.EndUpdate;
      end;
      // ���������� � ����� ������� ��������� ��� ����
      FBandsInfo.SaveBandPosition;
      UpdateGeneralIndexes;
      FColumnsInfo.SaveColumnPosition;
    finally
      MainView.ViewData.Collapse(True);
    end;

  finally
    FColumnsBarButtons := TColumnsBarButtonsEx2.Create(Self, dxbsColumns,
      MainView, cxGridDBBandedTableView2);
  end;
end;

procedure TViewParametricTable.SetUseTableName(const Value: Boolean);
begin
  UpdateBandsCaptions;
end;

procedure TViewParametricTable.Unlock;
begin
  Assert(FLockInfo.Locked);
  Assert(BaseCompGrp = nil);
  FLockInfo.Locked := false;

  // ���������� ������������� � ������
  BaseCompGrp := FLockInfo.BaseComponentsGroup;
  EndUpdate;
//  PostMessage(Handle, WM_FOCUS_TOP_LEFT, 0, 0);
end;

procedure TViewParametricTable.UpdateBandsCaptions;
var
  ABI: TBandInfo;
  ACaption: string;
  AID: Integer;
  AMaxBandHeaderHeight: Integer;
  R: TRect;
  S: string;
begin
  AMaxBandHeaderHeight := 0;
  for ABI in FBandsInfo do
  begin
    if not ABI.Band.Visible then
      Continue;

    if ABI.IDList.Count = 0 then
    begin
      S := ABI.Band.Caption;
    end;

    // ���� ������ � ��������� �����
    Assert(ABI.IDList.Count > 0);
    // ���� ������ �����������
    AID := ABI.IDList[0];
    qCategoryParameters.W.LocateByPK(AID, True);

    // ������ ��������� �����
    ACaption := GetBandCaption(qCategoryParameters);
    if ACaption = ABI.Band.Caption then
      Continue;

    ABI.Band.Caption := ACaption;
    // ��������� ����������� ������ �����
    R := UpdateMinBandWindth(ABI as TBandInfoEx);
    if (R.Height + 10) > AMaxBandHeaderHeight then
      AMaxBandHeaderHeight := R.Height + 10;
  end;
  // ��������� ������ ���� ������
  MainView.OptionsView.BandHeaderHeight := AMaxBandHeaderHeight;
end;

procedure TViewParametricTable.UpdateBandsPosition;
var
  A: TArray<Integer>;
  ABand: TcxGridBand;
  ABI: TBandInfo;
  ABI2: TBandInfo;
  ACI: TColumnInfo;
  ADropBI: TList<TBandInfo>;
  AID: Integer;
  AIDList: TList<Integer>;
  AIsEof: Boolean;
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

  ADropBI := TList<TBandInfo>.Create;
  AIDList := TList<Integer>.Create;
  try
    qCategoryParameters.FDQuery.First;
    AIDList.Add(qCategoryParameters.W.PK.AsInteger);

    while not qCategoryParameters.FDQuery.Eof do
    begin
      // ���� ��������� ������ ��������� � ��� �� ������
      if qCategoryParameters.W.NextEx then
        AIDList.Add(qCategoryParameters.W.PK.AsInteger)
      else
      begin
        AIsEof := qCategoryParameters.FDQuery.Eof;

        // ���� ���� � ������ ����������������
        A := AIDList.ToArray;

        ABI := FBandsInfo.SearchByIDList(A);

        // ���� ���� ��� ������ �� �����, ���������� �� ������ ��� �� �����������
        if ABI = nil then
        begin
          ABI := FBandsInfo.SearchByID(A[0]);

          // ����� ���� ����������� �����, �� ��� ������ �� ����� ��� ���������� �� ������
          if ABI <> nil then
          begin
            // ��������� ��������� ��������������
            for i := 1 to AIDList.Count - 1 do
            begin
              ABI2 := FBandsInfo.SearchByID(AIDList[i]);

              // ���� ����� ����� ����������� ���������� ������ � ����
              if (ABI2 <> nil) and (ABI2 <> ABI) and (ADropBI.IndexOf(ABI2) < 0)
              then
                ADropBI.Add(ABI2);
            end;

            ABI.IDList.Assign(A);
            // ����� ������� ����� ���������� � ����� ����
          end
          else
          begin
            // ���� ����� ���� ���� �� ����������� �����
            // ������ ����� ����
            ABI := CreateBandInfoEx([MainView, GridView(cxGridLevel2)], A);
            FBandsInfo.Add(ABI);

            qCategoryParameters.W.SaveBookmark;
            qCategoryParameters.W.LocateByPK(A[0], True);
            // �������������� ����� ����
            InitializeBandInfo(ABI as TBandInfoEx, A, qCategoryParameters);
            qCategoryParameters.W.RestoreBookmark;
          end;
        end;

        Inc(k);
        ABI.UpdateBandPosition(k);

        // ���� �� ���� ��������������� ������� �����
        for AID in A do
        begin
          ACI := FColumnsInfo.Search(AID, True);
          // �������� ������� � ��� ����� ����!
          if ACI.Column.Position.BandIndex <> ABI.Band.Index then
            ACI.Column.Position.BandIndex := ABI.Band.Index;
        end;

        if AIsEof then
          break;

        AIDList.Clear;
        AIDList.Add(qCategoryParameters.W.PK.AsInteger);
      end;
    end;

    // ���� �� ������, ������� ����� �������
    for ABI in ADropBI do
    begin
      Assert(ABI.Band.ColumnCount = 0);
      // ����� ������� ������ ���� - �� ������� ��� �������
      FBandsInfo.FreeBand(ABI);
    end;

  finally
    FreeAndNil(AIDList);
    FreeAndNil(ADropBI);
  end;
end;

// TODO: UpdateColumnPosition
// procedure TViewParametricTable.UpdateColumnPosition(ABandInfo: TBandInfo);
// var
// ACI: TColumnInfo;
// AColIndex: Integer;
// AID: Integer;
// begin
// Assert(ABandInfo <> nil);
//
/// / ������� ����������� � ������� ���������� �� ���������������
//
// AColIndex := 0;
// for AID in ABandInfo.IDList do
// begin
// // ���� �������
// ACI := FColumnsInfo.Search(AID, True);
// Assert(ACI.Column.Position.Band = ABandInfo.Band);
// // �������� ������� �������
// ACI.SetColumnPosition(ABandInfo.Band.Index, AColIndex);
//
// Inc(AColIndex);
// end;
// end;

procedure TViewParametricTable.UpdateColumns;
var
  ABI: TBandInfo;
  ANewIDList: TArray<Integer>;
  AIDCategoryParam: Integer;
  ARecHolder: TRecordHolder;
begin
  // ������� �������
  for ARecHolder in qCategoryParameters.DeletedSubParams do
  begin
    AIDCategoryParam := ARecHolder.Field[qCategoryParameters.W.PKFieldName];
    DropColumn(AIDCategoryParam);
  end;

  // ��������� �������
  for ARecHolder in qCategoryParameters.EditedSubParams do
  begin
    AIDCategoryParam := ARecHolder.Field[qCategoryParameters.W.PKFieldName];
    UpdateColumn(AIDCategoryParam);
  end;

  // ��������� �������
  DisableCollapsingAndExpanding;
  try
    for ARecHolder in qCategoryParameters.InsertedSubParams do
    begin
      AIDCategoryParam := ARecHolder.Field[qCategoryParameters.W.PKFieldName];

      // ����� ��������������
      ANewIDList := ComponentsExGroup.CatParamsGroup.GetIDList
        (AIDCategoryParam);

      // ���� ���� � ������� ������ ������� ���� �������
      ABI := FBandsInfo.SearchByID(ANewIDList[0], True);
      ABI.IDList.Assign(ANewIDList);

      qCategoryParameters.W.LocateByPK(AIDCategoryParam, True);
      // ������ ������� ��� �����
      CreateColumn(ABI, qCategoryParameters);
    end;
  finally
    EnableCollapsingAndExpanding;
  end;

  UpdateGeneralIndexes;
  FColumnsInfo.SaveColumnPosition;
  FBandsInfo.SaveBandPosition;
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

function TViewParametricTable.UpdateMinBandWindth
  (ABandInfo: TBandInfoEx): TRect;
var
  ABand: TcxGridBand;
  // ABandHeaderHeight: Integer;
begin
  // ������ �����

  ABand := ABandInfo.Band;

  Result := TTextRect.Calc(ABand.GridView.ViewInfo.Canvas.Canvas,
    ABand.Caption);

  // ������ ������ ����� �� ������ � ������ ������
  for ABand in ABandInfo.Bands do
    ABand.Width := Result.Width + 10;

  // ��������� ������ �����
  // ABandHeaderHeight := CalcBandHeight(ABand);

  // ������ ������ ���� ������
  // if MainView.OptionsView.BandHeaderHeight < (R.Height + 10) then
  // MainView.OptionsView.BandHeaderHeight := R.Height + 10;

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
  Application.Hint := '';
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

constructor TParametricTableLockInfo.Create;
begin
  Locked := false;
  BaseComponentsGroup := nil;
end;

end.
