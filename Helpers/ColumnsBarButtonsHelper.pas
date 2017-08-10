unit ColumnsBarButtonsHelper;

interface

uses
  System.Classes, Vcl.ActnList, dxBar, cxGridDBBandedTableView,
  cxGridBandedTableView, System.Generics.Collections, cxVGridViewInfo, cxGrid,
  cxDBTL, cxTL;

type
  TGroupGVAction = class;
  TGVAction = class;
  TTLAction = class;
  TTLBandAction = class;
  TTLColumnAction = class;
  TGroupTLAction = class;

  TGroupTLActionClass = class of TGroupTLAction;
  TGroupGVActionClass = class of TGroupGVAction;

  TGVAction = class(TAction)
  private
  protected
    function GetGridView: TcxGridDBBandedTableView; virtual; abstract;
  public
    property GridView: TcxGridDBBandedTableView read GetGridView;
  end;

  TGVBandAction = class(TGVAction)
    procedure actCustomizeBandExecute(Sender: TObject); virtual;
  private
    FBand: TcxGridBand;
    procedure SetBand(const Value: TcxGridBand);
  protected
    function GetGridView: TcxGridDBBandedTableView; override;
  public
    property Band: TcxGridBand read FBand write SetBand;
  end;

  TGVColumnAction = class(TGVAction)
    procedure actCustomizeColumnExecute(Sender: TObject); virtual;
  private
    FColumn: TcxGridDBBandedColumn;
    procedure SetColumn(const Value: TcxGridDBBandedColumn);
  protected
    function GetGridView: TcxGridDBBandedTableView; override;
  public
    property Column: TcxGridDBBandedColumn read FColumn write SetColumn;
  end;

  TGVColumnsBarButtons = class(TComponent)
  private
    FGroupActions: TList<TGroupGVAction>;
    FcxGridDBBandedTableView: TcxGridDBBandedTableView;
    FdxBarSubitem: TdxBarSubItem;
  protected
    function CreateBandAction(ABand: TcxGridBand): TGVBandAction; virtual;
    function CreateColumnAction(AColumn: TcxGridDBBandedColumn)
      : TGVColumnAction; virtual;
    procedure CreateDxBarButton(AAction: TAction;
      ABarButtonStyle: TdxBarButtonStyle; ACloseSubMenuOnClick: Boolean);
    function CreateGroupAction(AActionClass: TGroupGVActionClass)
      : TGroupGVAction;
    procedure CreateGroupActions; virtual;
    procedure ProcessGridView; virtual;
  public
    constructor Create(AOwner: TComponent; AdxBarSubitem: TdxBarSubItem;
      AcxGridDBBandedTableView: TcxGridDBBandedTableView); reintroduce; virtual;
    destructor Destroy; override;
    procedure AfterConstruction; override;
  end;

  TGroupGVAction = class(TAction)
  private
    FActions: TList<TGVAction>;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Actions: TList<TGVAction> read FActions;
  end;

  TGVHideAllAction = class(TGroupGVAction)
    procedure actHideAllExecute(Sender: TObject);
  private
    HideAll: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TGVColumnsBarButtonsEx = class(TGVColumnsBarButtons)
  private
    FChildGridView: TcxGridDBBandedTableView;
  protected
    function CreateBandAction(ABand: TcxGridBand): TGVBandAction; override;
    function CreateColumnAction(AColumn: TcxGridDBBandedColumn)
      : TGVColumnAction; override;
  public
    constructor Create(AOwner: TComponent; AdxBarSubitem: TdxBarSubItem;
      AcxGridDBBandedTableView, AChildGridView: TcxGridDBBandedTableView);
      reintroduce;
  end;

  TGVColumnActionEx = class(TGVColumnAction)
    procedure actCustomizeColumnExecute(Sender: TObject); override;
  private
    FChildAction: TGVColumnAction;
    property ChildAction: TGVColumnAction read FChildAction write FChildAction;
  end;

  TGVBandActionEx = class(TGVBandAction)
    procedure actCustomizeBandExecute(Sender: TObject); override;
  private
    FChildAction: TGVBandAction;
    property ChildAction: TGVBandAction read FChildAction write FChildAction;
  end;

  TTLColumnsBarButtons = class(TComponent)
  private
    FcxDBTreeList: TcxDBTreeList;
    FdxBarSubitem: TdxBarSubItem;
    FGroupActions: TList<TGroupTLAction>;
  protected
    procedure CreateDxBarButton(AAction: TAction;
      ABarButtonStyle: TdxBarButtonStyle; ACloseSubMenuOnClick: Boolean);
    function CreateGroupAction(AActionClass: TGroupTLActionClass)
      : TGroupTLAction;
    procedure CreateGroupActions;
    function CreateBandAction(Band: TcxTreeListBand): TTLBandAction;
    function CreateColumnAction(AColumn: TcxTreeListColumn): TTLColumnAction;
    procedure ProcessTreeList;
  public
    constructor Create(AOwner: TComponent; AdxBarSubitem: TdxBarSubItem;
      AcxDBTreeList: TcxDBTreeList); reintroduce;
    destructor Destroy; override;
    procedure AfterConstruction; override;
  end;

  TTLAction = class(TAction)
  private
  protected
    function GetDBTreeList: TcxDBTreeList; virtual; abstract;
  public
    property DBTreeList: TcxDBTreeList read GetDBTreeList;
  end;

  TTLBandAction = class(TTLAction)
    procedure actHideBandExecute(Sender: TObject); virtual;
  private
    FcxTreeListBand: TcxTreeListBand;
    procedure SetcxTreeListBand(const Value: TcxTreeListBand);
  protected
    function GetDBTreeList: TcxDBTreeList; override;
  public
    property cxTreeListBand: TcxTreeListBand read FcxTreeListBand
      write SetcxTreeListBand;
  end;

  TTLColumnAction = class(TTLAction)
    procedure actHideColumnExecute(Sender: TObject); virtual;
  private
    FColumn: TcxTreeListColumn;
    procedure SetColumn(const Value: TcxTreeListColumn);
  protected
    function GetDBTreeList: TcxDBTreeList; override;
  public
    property Column: TcxTreeListColumn read FColumn write SetColumn;
  end;

  TGroupTLAction = class(TAction)
  private
    FActions: TList<TTLAction>;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Actions: TList<TTLAction> read FActions;
  end;

  TTLHideAllAction = class(TGroupTLAction)
    procedure actHideAllExecute(Sender: TObject);
  private
    HideAll: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses System.SysUtils, System.Generics.Defaults;

{ TGVColumnsBarButtons }

constructor TGVColumnsBarButtons.Create(AOwner: TComponent;
  AdxBarSubitem: TdxBarSubItem;
  AcxGridDBBandedTableView: TcxGridDBBandedTableView);
begin
  inherited Create(AOwner);

  Assert(AdxBarSubitem <> nil);
  Assert(AcxGridDBBandedTableView <> nil);

  FdxBarSubitem := AdxBarSubitem;
  FcxGridDBBandedTableView := AcxGridDBBandedTableView;
  FGroupActions := TList<TGroupGVAction>.Create;
end;

destructor TGVColumnsBarButtons.Destroy;
begin
  inherited;
  FreeAndNil(FGroupActions);
end;

procedure TGVColumnsBarButtons.AfterConstruction;
begin
  inherited;
  ProcessGridView;
end;

function TGVColumnsBarButtons.CreateBandAction(ABand: TcxGridBand)
  : TGVBandAction;
begin
  Result := TGVBandAction.Create(Self);
  Result.Band := ABand;
end;

function TGVColumnsBarButtons.CreateColumnAction(AColumn: TcxGridDBBandedColumn)
  : TGVColumnAction;
begin
  Result := TGVColumnAction.Create(Self);
  Result.Column := AColumn;
end;

procedure TGVColumnsBarButtons.CreateDxBarButton(AAction: TAction;
  ABarButtonStyle: TdxBarButtonStyle; ACloseSubMenuOnClick: Boolean);
var
  AdxBarButton: TdxBarButton;
  AdxBarItemLink: TdxBarItemLink;
begin
  AdxBarButton := TdxBarButton.Create(Self);
  AdxBarButton.ButtonStyle := ABarButtonStyle;
  AdxBarButton.CloseSubMenuOnClick := ACloseSubMenuOnClick;
  AdxBarButton.Action := AAction;

  AdxBarItemLink := FdxBarSubitem.ItemLinks.AddButton;
  AdxBarItemLink.Item := AdxBarButton;
end;

function TGVColumnsBarButtons.CreateGroupAction(AActionClass
  : TGroupGVActionClass): TGroupGVAction;
begin
  // Добавляем действие для представления в целом
  Result := AActionClass.Create(Self);
  CreateDxBarButton(Result, bsDefault, True);
  FGroupActions.Add(Result);
end;

procedure TGVColumnsBarButtons.CreateGroupActions;
begin
  // Добавляем действие "Спрятать все колонки"
  CreateGroupAction(TGVHideAllAction);
end;

procedure TGVColumnsBarButtons.ProcessGridView;
var
  AAction: TGVAction;
  AColumn: TcxGridDBBandedColumn;
  i: Integer;
  ACaptions: TList<string>;
  AColumns: TList<TcxGridDBBandedColumn>;
  ACustomizeGridViewAction: TGroupGVAction;
begin
  // Создаём действия для табличного представления в целом
  CreateGroupActions;

  ACaptions := TList<string>.Create;
  try
    // Список колонок cxGrid
    AColumns := TList<TcxGridDBBandedColumn>.Create;
    try
      // Добавляем в список все колонки, которые есть у cxGrid
      for i := 0 to FcxGridDBBandedTableView.ColumnCount - 1 do
      begin
        Assert(FcxGridDBBandedTableView.Columns[i].Position.Band <> nil);
        AColumns.Add(FcxGridDBBandedTableView.Columns[i]);
      end;
      // Сортируем эти столбцы по позиции бэнда и по позиции внутри бэнда
      AColumns.Sort(TComparer<TcxGridDBBandedColumn>.Construct(
        function(const L, R: TcxGridDBBandedColumn): Integer
        begin
          Result := L.Position.Band.Position.ColIndex -
            R.Position.Band.Position.ColIndex;
          if Result = 0 then
            Result := L.Position.ColIndex - R.Position.ColIndex;
        end));

      for AColumn in AColumns do
      begin
        // AColumn := FcxGridDBBandedTableView.Columns[i];
        Assert(AColumn.Position.Band <> nil);
        if (AColumn.VisibleForCustomization) and
          (AColumn.Position.Band.VisibleForCustomization) then
        begin
          AAction := nil;

          // Если колонка относится к "пустому" бэнду
          if (AColumn.Position.Band.Caption = '') then
          begin
            // Если этот бэнд не зафиксирован
            if AColumn.Position.Band.FixedKind = fkNone then
            begin
              // если такого заголовка ещё не было
              if ACaptions.IndexOf(AColumn.Caption) < 0 then
              begin
                ACaptions.Add(AColumn.Caption);
                AAction := CreateColumnAction(AColumn);
              end;
            end;
          end
          else
          begin
            // Если колонка относится к не пустому бэнду
            // если такого заголовка бэнда ещё не было
            if ACaptions.IndexOf(AColumn.Position.Band.Caption) < 0 then
            begin
              ACaptions.Add(AColumn.Position.Band.Caption);
              AAction := CreateBandAction(AColumn.Position.Band);
            end;
          end;

          if AAction <> nil then
          begin
            for ACustomizeGridViewAction in FGroupActions do
              ACustomizeGridViewAction.Actions.Add(AAction);

            CreateDxBarButton(AAction, bsChecked, False);
          end;
        end;
      end;
    finally
      FreeAndNil(AColumns)
    end;
  finally
    FreeAndNil(ACaptions);
  end;

end;

procedure TGVBandAction.actCustomizeBandExecute(Sender: TObject);
begin
  Assert(FBand <> nil);
  Checked := not Checked;
  FBand.Visible := Checked;

  if FBand.Visible then
    FBand.ApplyBestFit();
end;

function TGVBandAction.GetGridView: TcxGridDBBandedTableView;
begin
  Result := Band.GridView as TcxGridDBBandedTableView;
end;

procedure TGVBandAction.SetBand(const Value: TcxGridBand);
begin
  if FBand <> Value then
  begin
    FBand := Value;
    if FBand <> nil then
    begin
      Caption := FBand.Caption;
      Checked := FBand.Visible;
      OnExecute := actCustomizeBandExecute;
    end
    else
    begin
      Caption := '';
      Checked := False;
      OnExecute := nil;
    end;

  end;
end;

procedure TGVColumnAction.actCustomizeColumnExecute(Sender: TObject);
var
  ABand: TcxGridBand;
  AnyVisible: Boolean;
  i: Integer;
begin
  Assert(FColumn <> nil);
  Checked := not Checked;
  FColumn.Visible := Checked;

  if not FColumn.Visible then
  begin
    AnyVisible := False;
    ABand := FColumn.Position.Band;
    for i := 0 to ABand.ColumnCount - 1 do
    begin
      AnyVisible := ABand.Columns[i].Visible;
      if AnyVisible then
        Break;
    end;

    // если все колонки в бэнде невидимые
    if not AnyVisible then
      ABand.Visible := False;
  end
  else
    FColumn.Position.Band.Visible := True;
end;

function TGVColumnAction.GetGridView: TcxGridDBBandedTableView;
begin
  Result := FColumn.GridView as TcxGridDBBandedTableView;
end;

procedure TGVColumnAction.SetColumn(const Value: TcxGridDBBandedColumn);
begin
  if FColumn <> Value then
  begin
    FColumn := Value;
    if FColumn <> nil then
    begin
      Caption := FColumn.Caption;
      Checked := FColumn.Visible;
      OnExecute := actCustomizeColumnExecute;
    end
    else
    begin
      Caption := '';
      Checked := False;
      OnExecute := nil;
    end;
  end;
end;

constructor TGVHideAllAction.Create(AOwner: TComponent);
begin
  inherited;
  HideAll := False;
  Caption := 'Спрятать все';
  OnExecute := actHideAllExecute;
end;

procedure TGVHideAllAction.actHideAllExecute(Sender: TObject);
var
  AAction: TAction;
  AGridView: TcxGridDBBandedTableView;
begin
  if Actions.Count > 0 then
  begin
    HideAll := not HideAll;

    if HideAll then
      Caption := 'Показать все'
    else
      Caption := 'Спрятать все';

    AGridView := Actions[0].GridView;
    Assert(AGridView <> nil);

    AGridView.BeginBestFitUpdate;
    try
      for AAction in Actions do
      begin
        if (HideAll and AAction.Checked) or (not HideAll and not AAction.Checked)
        then
          AAction.Execute;
      end;
    finally
      AGridView.EndBestFitUpdate;
    end;
  end;
end;

procedure TGVColumnActionEx.actCustomizeColumnExecute(Sender: TObject);
begin
  inherited;

  if FChildAction <> nil then
    FChildAction.Execute;
end;

{ TGVColumnsBarButtonsEx }

constructor TGVColumnsBarButtonsEx.Create(AOwner: TComponent;
AdxBarSubitem: TdxBarSubItem; AcxGridDBBandedTableView, AChildGridView
  : TcxGridDBBandedTableView);
begin
  inherited Create(AOwner, AdxBarSubitem, AcxGridDBBandedTableView);
  FChildGridView := AChildGridView;
end;

function TGVColumnsBarButtonsEx.CreateBandAction(ABand: TcxGridBand)
  : TGVBandAction;
var
  AChildAction: TGVBandAction;
begin
  Assert(FChildGridView <> nil);

  Result := TGVBandActionEx.Create(Self);
  Result.Band := ABand;

  AChildAction := TGVBandAction.Create(Self);
  AChildAction.Band := FChildGridView.Bands[ABand.Index];

  (Result as TGVBandActionEx).ChildAction := AChildAction;
end;

function TGVColumnsBarButtonsEx.CreateColumnAction
  (AColumn: TcxGridDBBandedColumn): TGVColumnAction;
var
  AChildAction: TGVColumnAction;
begin
  Assert(FChildGridView <> nil);

  Result := TGVColumnActionEx.Create(Self);
  Result.Column := AColumn;

  AChildAction := TGVColumnAction.Create(Self);
  AChildAction.Column := FChildGridView.Columns[AColumn.Index];

  (Result as TGVColumnActionEx).ChildAction := AChildAction;
end;

procedure TGVBandActionEx.actCustomizeBandExecute(Sender: TObject);
begin
  inherited;

  if FChildAction <> nil then
    FChildAction.Execute;
end;

constructor TGroupGVAction.Create(AOwner: TComponent);
begin
  inherited;
  FActions := TList<TGVAction>.Create;
end;

destructor TGroupGVAction.Destroy;
begin
  FreeAndNil(FActions);
  inherited;
end;

{ TTLColumnsBarButtons }

constructor TTLColumnsBarButtons.Create(AOwner: TComponent;
AdxBarSubitem: TdxBarSubItem; AcxDBTreeList: TcxDBTreeList);
begin
  inherited Create(AOwner);

  Assert(AdxBarSubitem <> nil);
  Assert(AcxDBTreeList <> nil);

  FdxBarSubitem := AdxBarSubitem;
  FcxDBTreeList := AcxDBTreeList;

  // Действия над всем деревом
  FGroupActions := TList<TGroupTLAction>.Create;
end;

destructor TTLColumnsBarButtons.Destroy;
begin
  inherited;
  FreeAndNil(FGroupActions);
end;

procedure TTLColumnsBarButtons.AfterConstruction;
begin
  inherited;
  ProcessTreeList;
end;

procedure TTLColumnsBarButtons.CreateDxBarButton(AAction: TAction;
ABarButtonStyle: TdxBarButtonStyle; ACloseSubMenuOnClick: Boolean);
var
  AdxBarButton: TdxBarButton;
  AdxBarItemLink: TdxBarItemLink;
begin
  AdxBarButton := TdxBarButton.Create(Self);
  AdxBarButton.ButtonStyle := ABarButtonStyle;
  AdxBarButton.CloseSubMenuOnClick := ACloseSubMenuOnClick;
  AdxBarButton.Action := AAction;

  AdxBarItemLink := FdxBarSubitem.ItemLinks.AddButton;
  AdxBarItemLink.Item := AdxBarButton;
end;

function TTLColumnsBarButtons.CreateGroupAction(AActionClass
  : TGroupTLActionClass): TGroupTLAction;
begin
  // Добавляем действие для представления в целом
  Result := AActionClass.Create(Self);
  CreateDxBarButton(Result, bsDefault, True);
  FGroupActions.Add(Result);
end;

procedure TTLColumnsBarButtons.CreateGroupActions;
begin
  // Создаём действие "спрятать всё"
  CreateGroupAction(TTLHideAllAction);
end;

function TTLColumnsBarButtons.CreateBandAction(Band: TcxTreeListBand)
  : TTLBandAction;
begin
  Assert(Band <> nil);
  Result := TTLBandAction.Create(Self);
  Result.cxTreeListBand := Band;
end;

function TTLColumnsBarButtons.CreateColumnAction(AColumn: TcxTreeListColumn)
  : TTLColumnAction;
begin
  Assert(AColumn <> nil);
  Result := TTLColumnAction.Create(Self);
  Result.Column := AColumn;
end;

procedure TTLColumnsBarButtons.ProcessTreeList;
var
  AAction: TTLAction;
  ABaseTLAction: TGroupTLAction;
  ACaptions: TList<String>;
  AColumn: TcxTreeListColumn;
  AColumns: TList<TcxTreeListColumn>;
  i: Integer;
begin
  // Создаём действия для табличного представления в целом
  CreateGroupActions;

  ACaptions := TList<string>.Create;
  try
    // Список колонок TreeList
    AColumns := TList<TcxTreeListColumn>.Create;
    try
      // Добавляем в список все колонки, которые есть у cxGrid
      for i := 0 to FcxDBTreeList.ColumnCount - 1 do
      begin
        Assert(FcxDBTreeList.Columns[i].Position.Band <> nil);
        AColumns.Add(FcxDBTreeList.Columns[i]);
      end;
      // Сортируем эти столбцы по позиции бэнда и по позиции внутри бэнда
      AColumns.Sort(TComparer<TcxTreeListColumn>.Construct(
        function(const L, R: TcxTreeListColumn): Integer
        begin
          Result := L.Position.Band.Position.ColIndex -
            R.Position.Band.Position.ColIndex;
          if Result = 0 then
            Result := L.Position.ColIndex - R.Position.ColIndex;
        end));

      for AColumn in AColumns do
      begin
        Assert(AColumn.Position.Band <> nil);
        if (AColumn.Options.Customizing) and
          (AColumn.Position.Band.Options.Customizing) then
        begin
          AAction := nil;

          // Если колонка относится к "пустому" бэнду
          if (AColumn.Position.Band.Caption.Text = '') then
          begin
            // Если этот бэнд не зафиксирован
            if AColumn.Position.Band.FixedKind = tlbfNone then
            begin
              // если такого заголовка ещё не было
              if ACaptions.IndexOf(AColumn.Caption.Text) < 0 then
              begin
                ACaptions.Add(AColumn.Caption.Text);
                AAction := CreateColumnAction(AColumn);
              end;
            end;
          end
          else
          begin
            // Если колонка относится к не пустому бэнду
            if AColumn.Position.Band.FixedKind = tlbfNone then
            begin
              // если такого заголовка бэнда ещё не было
              if ACaptions.IndexOf(AColumn.Position.Band.Caption.Text) < 0 then
              begin
                ACaptions.Add(AColumn.Position.Band.Caption.Text);
                AAction := CreateBandAction(AColumn.Position.Band);
              end;
            end;
          end;

          if AAction <> nil then
          begin
            for ABaseTLAction in FGroupActions do
              ABaseTLAction.Actions.Add(AAction);

            CreateDxBarButton(AAction, bsChecked, False);
          end;
        end;
      end;
    finally
      FreeAndNil(AColumns)
    end;
  finally
    FreeAndNil(ACaptions);
  end;

end;

procedure TTLBandAction.actHideBandExecute(Sender: TObject);
begin
  Assert(FcxTreeListBand <> nil);
  Checked := not Checked;
  FcxTreeListBand.Visible := Checked;

  if FcxTreeListBand.Visible then
    FcxTreeListBand.ApplyBestFit();
end;

function TTLBandAction.GetDBTreeList: TcxDBTreeList;
begin
  Assert(FcxTreeListBand <> nil);
  Result := FcxTreeListBand.TreeList as TcxDBTreeList;
end;

procedure TTLBandAction.SetcxTreeListBand(const Value: TcxTreeListBand);
begin
  if FcxTreeListBand = Value then
    Exit;

  FcxTreeListBand := Value;
  if FcxTreeListBand <> nil then
  begin
    Caption := FcxTreeListBand.Caption.Text;
    Checked := FcxTreeListBand.Visible;
    OnExecute := actHideBandExecute;
  end
  else
  begin
    Caption := '';
    Checked := False;
    OnExecute := nil;
  end;

end;

procedure TTLColumnAction.actHideColumnExecute(Sender: TObject);
var
  ABand: TcxTreeListBand;
  AnyVisible: Boolean;
  i: Integer;
begin
  Assert(FColumn <> nil);
  Checked := not Checked;
  FColumn.Visible := Checked;

  if not FColumn.Visible then
  begin
    AnyVisible := False;
    ABand := FColumn.Position.Band;
    for i := 0 to ABand.ColumnCount - 1 do
    begin
      AnyVisible := ABand.Columns[i].Visible;
      if AnyVisible then
        Break;
    end;

    // если все колонки в бэнде невидимые
    if not AnyVisible then
      ABand.Visible := False;
  end
  else
    FColumn.Position.Band.Visible := True;

end;

function TTLColumnAction.GetDBTreeList: TcxDBTreeList;
begin
  Assert(FColumn <> nil);
  Result := FColumn.TreeList as TcxDBTreeList;
end;

procedure TTLColumnAction.SetColumn(const Value: TcxTreeListColumn);
begin
  if FColumn = Value then
    Exit;

  FColumn := Value;
  if FColumn <> nil then
  begin
    Caption := FColumn.Caption.Text;
    Checked := FColumn.Visible;
    OnExecute := actHideColumnExecute;
  end
  else
  begin
    Caption := '';
    Checked := False;
    OnExecute := nil;
  end;
end;

constructor TGroupTLAction.Create(AOwner: TComponent);
begin
  inherited;
  FActions := TList<TTLAction>.Create;
end;

destructor TGroupTLAction.Destroy;
begin
  FreeAndNil(FActions);
  inherited;
end;

constructor TTLHideAllAction.Create(AOwner: TComponent);
begin
  inherited;
  HideAll := False;
  Caption := 'Спрятать все';
  OnExecute := actHideAllExecute;
end;

procedure TTLHideAllAction.actHideAllExecute(Sender: TObject);
var
  AAction: TAction;
  ATreeList: TcxDBTreeList;
begin
  if Actions.Count > 0 then
  begin
    HideAll := not HideAll;

    if HideAll then
      Caption := 'Показать все'
    else
      Caption := 'Спрятать все';

    ATreeList := Actions[0].DBTreeList;
    Assert(ATreeList <> nil);

    ATreeList.BeginUpdate;
    try
      for AAction in Actions do
      begin
        if (HideAll and AAction.Checked) or (not HideAll and not AAction.Checked)
        then
          AAction.Execute;
      end;
    finally
      ATreeList.EndUpdate;
    end;
  end;
end;

end.
