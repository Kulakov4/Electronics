unit ColumnsBarButtonsHelper;

interface

uses
  System.Classes, Vcl.ActnList, dxBar, cxGridDBBandedTableView,
  cxGridBandedTableView, System.Generics.Collections, cxVGridViewInfo, cxGrid;

type
  TCustomizeGridViewAction = class;
  TCustomizeGridViewItemAction = class;

  TCustomizeGridViewActionClass = class of TCustomizeGridViewAction;
  TCustomizeGridViewItemActionClass = class of TCustomizeGridViewItemAction;

  TCustomizeGridViewItemAction = class(TAction)
  private
  protected
    function GetGridView: TcxGridDBBandedTableView; virtual; abstract;
  public
    property GridView: TcxGridDBBandedTableView read GetGridView;
  end;

  TCustomizeBandAction = class(TCustomizeGridViewItemAction)
    procedure actCustomizeBandExecute(Sender: TObject); virtual;
  private
    FBand: TcxGridBand;
    procedure SetBand(const Value: TcxGridBand);
  protected
    function GetGridView: TcxGridDBBandedTableView; override;
  public
    property Band: TcxGridBand read FBand write SetBand;
  end;

  TCustomizeColumnAction = class(TCustomizeGridViewItemAction)
    procedure actCustomizeColumnExecute(Sender: TObject); virtual;
  private
    FColumn: TcxGridDBBandedColumn;
    procedure SetColumn(const Value: TcxGridDBBandedColumn);
  protected
    function GetGridView: TcxGridDBBandedTableView; override;
  public
    property Column: TcxGridDBBandedColumn read FColumn write SetColumn;
  end;

  TColumnsBarButtons = class(TComponent)
  private
    FCustomizeGridViewActionList: TList<TCustomizeGridViewAction>;
    FcxGridDBBandedTableView: TcxGridDBBandedTableView;
    FdxBarSubitem: TdxBarSubItem;
  protected
    function CreateCustomizeBandAction(ABand: TcxGridBand)
      : TCustomizeBandAction; virtual;
    function CreateCustomizeColumnAction(AColumn: TcxGridDBBandedColumn)
      : TCustomizeColumnAction; virtual;
    procedure CreateDxBarButton(AAction: TAction;
      ABarButtonStyle: TdxBarButtonStyle; ACloseSubMenuOnClick: Boolean);
    function CreateGridViewAction(AActionClass: TCustomizeGridViewActionClass)
      : TCustomizeGridViewAction;
    procedure CreateGridViewActions; virtual;
    procedure ProcessGridView; virtual;
  public
    constructor Create(AOwner: TComponent; AdxBarSubitem: TdxBarSubItem;
      AcxGridDBBandedTableView: TcxGridDBBandedTableView); reintroduce; virtual;
    destructor Destroy; override;
    procedure AfterConstruction; override;
  end;

  TCustomizeGridViewAction = class(TAction)
  private
    FActions: TList<TCustomizeGridViewItemAction>;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Actions: TList<TCustomizeGridViewItemAction> read FActions;
  end;

  THideAllAction = class(TCustomizeGridViewAction)
    procedure actHideAllExecute(Sender: TObject);
  private
    HideAll: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TColumnsBarButtonsEx = class(TColumnsBarButtons)
  private
    FChildGridView: TcxGridDBBandedTableView;
  protected
    function CreateCustomizeBandAction(ABand: TcxGridBand)
      : TCustomizeBandAction; override;
    function CreateCustomizeColumnAction(AColumn: TcxGridDBBandedColumn)
      : TCustomizeColumnAction; override;
  public
    constructor Create(AOwner: TComponent; AdxBarSubitem: TdxBarSubItem;
      AcxGridDBBandedTableView, AChildGridView: TcxGridDBBandedTableView);
      reintroduce;
  end;

  TCustomizeColumnActionEx = class(TCustomizeColumnAction)
    procedure actCustomizeColumnExecute(Sender: TObject); override;
  private
    FChildAction: TCustomizeColumnAction;
    property ChildAction: TCustomizeColumnAction read FChildAction
      write FChildAction;
  end;

  TCustomizeBandActionEx = class(TCustomizeBandAction)
    procedure actCustomizeBandExecute(Sender: TObject); override;
  private
    FChildAction: TCustomizeBandAction;
    property ChildAction: TCustomizeBandAction read FChildAction
      write FChildAction;
  end;

implementation

uses System.SysUtils, System.Generics.Defaults;

{ TColumnsBarButtons }

constructor TColumnsBarButtons.Create(AOwner: TComponent;
  AdxBarSubitem: TdxBarSubItem;
  AcxGridDBBandedTableView: TcxGridDBBandedTableView);
begin
  inherited Create(AOwner);

  Assert(AdxBarSubitem <> nil);
  Assert(AcxGridDBBandedTableView <> nil);

  FdxBarSubitem := AdxBarSubitem;
  FcxGridDBBandedTableView := AcxGridDBBandedTableView;
  FCustomizeGridViewActionList := TList<TCustomizeGridViewAction>.Create;
end;

destructor TColumnsBarButtons.Destroy;
begin
  inherited;
  FreeAndNil(FCustomizeGridViewActionList);
end;

procedure TColumnsBarButtons.AfterConstruction;
begin
  inherited;
  ProcessGridView;
end;

function TColumnsBarButtons.CreateCustomizeBandAction(ABand: TcxGridBand)
  : TCustomizeBandAction;
begin
  Result := TCustomizeBandAction.Create(Self);
  Result.Band := ABand;
end;

function TColumnsBarButtons.CreateCustomizeColumnAction
  (AColumn: TcxGridDBBandedColumn): TCustomizeColumnAction;
begin
  Result := TCustomizeColumnAction.Create(Self);
  Result.Column := AColumn;
end;

procedure TColumnsBarButtons.CreateDxBarButton(AAction: TAction;
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

function TColumnsBarButtons.CreateGridViewAction(AActionClass
  : TCustomizeGridViewActionClass): TCustomizeGridViewAction;
begin
  // Добавляем действие для представления в целом
  Result := AActionClass.Create(Self);
  CreateDxBarButton(Result, bsDefault, True);
  FCustomizeGridViewActionList.Add(Result);
end;

procedure TColumnsBarButtons.CreateGridViewActions;
begin
  // Добавляем действие "Спрятать все колонки"
  CreateGridViewAction(THideAllAction);
end;

procedure TColumnsBarButtons.ProcessGridView;
var
  AAction: TCustomizeGridViewItemAction;
  AColumn: TcxGridDBBandedColumn;
  i: Integer;
  ACaptions: TList<string>;
  AColumns: TList<TcxGridDBBandedColumn>;
  ACustomizeGridViewAction: TCustomizeGridViewAction;
begin
  // Создаём действия для табличного представления в целом
  CreateGridViewActions;

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
      // Сортируем эти столбцы по позиции бэнда
      AColumns.Sort(TComparer<TcxGridDBBandedColumn>.Construct(
        function(const L, R: TcxGridDBBandedColumn): Integer
        begin
          Result := L.Position.Band.Position.ColIndex -
            R.Position.Band.Position.ColIndex;
        end));

      for AColumn in AColumns do
      begin
//        AColumn := FcxGridDBBandedTableView.Columns[i];
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
                AAction := CreateCustomizeColumnAction(AColumn);
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
              AAction := CreateCustomizeBandAction(AColumn.Position.Band);
            end;
          end;

          if AAction <> nil then
          begin
            for ACustomizeGridViewAction in FCustomizeGridViewActionList do
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

procedure TCustomizeBandAction.actCustomizeBandExecute(Sender: TObject);
begin
  Assert(FBand <> nil);
  Checked := not Checked;
  FBand.Visible := Checked;

  if FBand.Visible then
    FBand.ApplyBestFit();
end;

function TCustomizeBandAction.GetGridView: TcxGridDBBandedTableView;
begin
  Result := Band.GridView as TcxGridDBBandedTableView;
end;

procedure TCustomizeBandAction.SetBand(const Value: TcxGridBand);
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

procedure TCustomizeColumnAction.actCustomizeColumnExecute(Sender: TObject);
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

function TCustomizeColumnAction.GetGridView: TcxGridDBBandedTableView;
begin
  Result := FColumn.GridView as TcxGridDBBandedTableView;
end;

procedure TCustomizeColumnAction.SetColumn(const Value: TcxGridDBBandedColumn);
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

constructor THideAllAction.Create(AOwner: TComponent);
begin
  inherited;
  HideAll := False;
  Caption := 'Спрятать все';
  OnExecute := actHideAllExecute;
end;

procedure THideAllAction.actHideAllExecute(Sender: TObject);
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

procedure TCustomizeColumnActionEx.actCustomizeColumnExecute(Sender: TObject);
begin
  inherited;

  if FChildAction <> nil then
    FChildAction.Execute;
end;

{ TColumnsBarButtonsEx }

constructor TColumnsBarButtonsEx.Create(AOwner: TComponent;
AdxBarSubitem: TdxBarSubItem; AcxGridDBBandedTableView, AChildGridView
  : TcxGridDBBandedTableView);
begin
  inherited Create(AOwner, AdxBarSubitem, AcxGridDBBandedTableView);
  FChildGridView := AChildGridView;
end;

function TColumnsBarButtonsEx.CreateCustomizeBandAction(ABand: TcxGridBand)
  : TCustomizeBandAction;
var
  AChildAction: TCustomizeBandAction;
begin
  Assert(FChildGridView <> nil);

  Result := TCustomizeBandActionEx.Create(Self);
  Result.Band := ABand;

  AChildAction := TCustomizeBandAction.Create(Self);
  AChildAction.Band := FChildGridView.Bands[ABand.Index];

  (Result as TCustomizeBandActionEx).ChildAction := AChildAction;
end;

function TColumnsBarButtonsEx.CreateCustomizeColumnAction
  (AColumn: TcxGridDBBandedColumn): TCustomizeColumnAction;
var
  AChildAction: TCustomizeColumnAction;
begin
  Assert(FChildGridView <> nil);

  Result := TCustomizeColumnActionEx.Create(Self);
  Result.Column := AColumn;

  AChildAction := TCustomizeColumnAction.Create(Self);
  AChildAction.Column := FChildGridView.Columns[AColumn.Index];

  (Result as TCustomizeColumnActionEx).ChildAction := AChildAction;
end;

procedure TCustomizeBandActionEx.actCustomizeBandExecute(Sender: TObject);
begin
  inherited;

  if FChildAction <> nil then
    FChildAction.Execute;
end;

constructor TCustomizeGridViewAction.Create(AOwner: TComponent);
begin
  inherited;
  FActions := TList<TCustomizeGridViewItemAction>.Create;
end;

destructor TCustomizeGridViewAction.Destroy;
begin
  FreeAndNil(FActions);
  inherited;
end;

end.
