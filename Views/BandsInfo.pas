unit BandsInfo;

interface

uses
  cxGridBandedTableView, System.Generics.Collections, System.Generics.Defaults,
  ParameterKindEnum, cxGridDBBandedTableView;

type
  TBandInfo = class(TObject)
  private
    FBand: TcxGridBand;
    FCategoryParamID: Integer;
    FDefaultCreated: Boolean;
    FDefaultVisible: Boolean;
    FOrder: Integer;
    FBandID: Integer;
    FColIndex: Integer;
    FIDParameterKind: Integer;
    FIsDefault: Boolean;
    FParameterID: Integer;
    FPos: Integer;
  public
    constructor Create(ABand: TcxGridBand; ABandID: Integer); overload;
    constructor Create(ABand: TcxGridBand; AParameterID: Integer;
      AIsDefault: Boolean); overload;
    property Band: TcxGridBand read FBand write FBand;
    property CategoryParamID: Integer read FCategoryParamID
      write FCategoryParamID;
    property DefaultCreated: Boolean read FDefaultCreated write FDefaultCreated;
    property DefaultVisible: Boolean read FDefaultVisible write FDefaultVisible;
    property Order: Integer read FOrder write FOrder;
    property BandID: Integer read FBandID write FBandID;
    property ColIndex: Integer read FColIndex write FColIndex;
    property IDParameterKind: Integer read FIDParameterKind
      write FIDParameterKind;
    property IsDefault: Boolean read FIsDefault write FIsDefault;
    property ParameterID: Integer read FParameterID write FParameterID;
    property Pos: Integer read FPos write FPos;
  end;

  TBandsInfo = class(TList<TBandInfo>)
  private
  public
    procedure FreeNotDefaultBands;
    function GetChangedColIndex(AView: TcxGridBandedTableView): TBandsInfo;
    function GetBandsForView(AView: TcxGridBandedTableView): TBandsInfo;
    function HaveDifferentPos: Boolean;
    procedure HideDefaultBands;
    function Search(AView: TcxGridBandedTableView;
      AIDBand, AIDParameter: Integer; AIsDefault: Boolean): TBandInfo; overload;
    function Search(ABand: TcxGridBand): TBandInfo; overload;
    function Search(AView: TcxGridBandedTableView; AIDParameter: Integer;
      AIsDefault: Boolean): TBandInfo; overload;
    function Search(AView: TcxGridBandedTableView; AIDBand: Integer)
      : TBandInfo; overload;
    function SearchByColIndex(AView: TcxGridBandedTableView; AColIndex: Integer)
      : TBandInfo;
  end;

  TDescComparer = class(TComparer<TBandInfo>)
  public
    function Compare(const Left, Right: TBandInfo): Integer; override;
  end;

  TColumnInfo = class(TObject)
  private
    FColIndex: Integer;
    FColumn: TcxGridBandedColumn;
    FDefaultCreated: Boolean;
    FIDCategoryParam: Integer;
    FOrder: Integer;
  public
    constructor Create(AColumn: TcxGridBandedColumn; AIDCategoryParam, AOrder:
        Integer; ADefaultCreated: Boolean); overload;
    property ColIndex: Integer read FColIndex write FColIndex;
    property Column: TcxGridBandedColumn read FColumn write FColumn;
    property DefaultCreated: Boolean read FDefaultCreated write FDefaultCreated;
    property IDCategoryParam: Integer read FIDCategoryParam write FIDCategoryParam;
    property Order: Integer read FOrder write FOrder;
  end;

  TColumnsInfo = class(TList<TColumnInfo>)
  public
    procedure FreeNotDefaultColumns;
    function GetChangedColIndex(AView: TcxGridBandedTableView): TColumnsInfo;
    function Search(AColumn: TcxGridDBBandedColumn): TColumnInfo; overload;
    function Search(AView: TcxGridDBBandedTableView; AIDCategoryParam: Integer):
        TColumnInfo; overload;
  end;

implementation

constructor TBandInfo.Create(ABand: TcxGridBand; ABandID: Integer);
begin
  inherited Create;
  Assert(ABand <> nil);
  Assert(ABandID > 0);

  FBand := ABand;
  FBandID := ABandID;
end;

constructor TBandInfo.Create(ABand: TcxGridBand; AParameterID: Integer;
  AIsDefault: Boolean);
begin
  inherited Create;
  Assert(ABand <> nil);
  Assert(AParameterID > 0);

  // Этот бэнд для подпараметра "по умолчанию" какого-либо параметра
  FBand := ABand;
  FParameterID := AParameterID;
  FIsDefault := AIsDefault;
end;

procedure TBandsInfo.FreeNotDefaultBands;
var
  i: Integer;
begin
  for i := Count - 1 downto 0 do
  begin
    if not Items[i].DefaultCreated then
    begin
      // разрушаем бэнд
      Items[i].Band.Free;
      // Удаляем описание этого бэнда
      Delete(i);
    end;
  end;

end;

function TBandsInfo.GetChangedColIndex(AView: TcxGridBandedTableView)
  : TBandsInfo;
var
  ABandInfo: TBandInfo;
begin
  Assert(AView <> nil);
  Result := TBandsInfo.Create;
  for ABandInfo in Self do
  begin
    if (ABandInfo.Band.GridView = AView) and
      (ABandInfo.ColIndex <> ABandInfo.Band.Position.ColIndex) then
      Result.Add(ABandInfo);
  end;
end;

function TBandsInfo.GetBandsForView(AView: TcxGridBandedTableView): TBandsInfo;
var
  ABandInfo: TBandInfo;
begin
  Assert(AView <> nil);
  Result := TBandsInfo.Create;
  for ABandInfo in Self do
  begin
    if (ABandInfo.Band.GridView = AView) then
      Result.Add(ABandInfo);
  end;
end;

function TBandsInfo.HaveDifferentPos: Boolean;
var
  ABI: TBandInfo;
  APos: Integer;
begin
  Result := True;
  APos := First.Pos;
  for ABI in Self do
  begin
    if ABI.Pos <> APos then
      Exit;
  end;
  Result := False;
end;

procedure TBandsInfo.HideDefaultBands;
var
  ABandInfo: TBandInfo;
begin
  for ABandInfo in Self do
    if ABandInfo.DefaultCreated then
    begin
      ABandInfo.Band.Visible := False;
      ABandInfo.Band.VisibleForCustomization := False;
    end;
end;

function TBandsInfo.Search(AView: TcxGridBandedTableView;
  AIDBand, AIDParameter: Integer; AIsDefault: Boolean): TBandInfo;
begin
  Assert(AIDBand > 0);
  Assert(AIDParameter > 0);
  Assert(AView <> nil);

  // Бэнд с подпараметром по умолчанию встречается только один раз
  if AIsDefault then
    Result := Search(AView, AIDParameter, AIsDefault)
  else
    Result := Search(AView, AIDBand);
end;

function TBandsInfo.Search(ABand: TcxGridBand): TBandInfo;
var
  ABandInfo: TBandInfo;
begin
  Assert(ABand <> nil);

  for ABandInfo in Self do
  begin
    Result := ABandInfo;

    if ABandInfo.Band = ABand then
      Exit;
  end;
  Result := nil;
end;

function TBandsInfo.Search(AView: TcxGridBandedTableView; AIDParameter: Integer;
  AIsDefault: Boolean): TBandInfo;
var
  ABandInfo: TBandInfo;
begin
  Assert(AIDParameter > 0);
  Assert(AView <> nil);

  for ABandInfo in Self do
  begin
    Result := ABandInfo;

    if (ABandInfo.Band.GridView = AView) and
      (ABandInfo.ParameterID = AIDParameter) and
      (ABandInfo.IsDefault = AIsDefault) then
      Exit;
  end;
  Result := nil;
end;

function TBandsInfo.Search(AView: TcxGridBandedTableView; AIDBand: Integer)
  : TBandInfo;
var
  ABandInfo: TBandInfo;
begin
  Assert(AIDBand > 0);
  Assert(AView <> nil);

  for ABandInfo in Self do
  begin
    Result := ABandInfo;

    if (ABandInfo.Band.GridView = AView) and (ABandInfo.BandID = AIDBand) then
      Exit;
  end;
  Result := nil;
end;

function TBandsInfo.SearchByColIndex(AView: TcxGridBandedTableView;
  AColIndex: Integer): TBandInfo;
var
  ABandInfo: TBandInfo;
begin
  Assert(AColIndex > 0);
  Assert(AView <> nil);

  for ABandInfo in Self do
  begin
    Result := ABandInfo;

    if (ABandInfo.ColIndex = AColIndex) and (ABandInfo.Band.GridView = AView)
    then
      Exit;
  end;
  Result := nil;
end;

function TDescComparer.Compare(const Left, Right: TBandInfo): Integer;
begin
  // Сортировка в обратном порядке
  Result := -1 * (Left.ColIndex - Right.ColIndex);
end;

constructor TColumnInfo.Create(AColumn: TcxGridBandedColumn; AIDCategoryParam,
    AOrder: Integer; ADefaultCreated: Boolean);
begin
  Assert(AColumn <> nil);
  Assert(AIDCategoryParam > 0);
  Assert(AOrder > 0);

  FColumn := AColumn;
  FIDCategoryParam := AIDCategoryParam;
  FOrder := AOrder;
  FDefaultCreated := ADefaultCreated;
  FColIndex := FColumn.Position.ColIndex;
end;

procedure TColumnsInfo.FreeNotDefaultColumns;
var
  i: Integer;
begin
  for i := Count - 1 downto 0 do
  begin
    if not Items[i].DefaultCreated then
    begin
      // разрушаем колонку
      Items[i].Column.Free;
      // Удаляем описание этой колонки
      Delete(i);
    end;
  end;

end;

function TColumnsInfo.GetChangedColIndex(AView: TcxGridBandedTableView):
    TColumnsInfo;
var
  ACI: TColumnInfo;
begin
  Assert(AView <> nil);
  Result := TColumnsInfo.Create;
  for ACI in Self do
  begin
    if (ACI.Column.GridView = AView) and
      (ACI.ColIndex <> ACI.Column.Position.ColIndex) then
      Result.Add(ACI);
  end;
end;

function TColumnsInfo.Search(AColumn: TcxGridDBBandedColumn): TColumnInfo;
begin
  Assert(AColumn <> nil);
  for Result in Self do
  begin
    if Result.Column = AColumn then
      Exit;
  end;
  Result := nil;
end;

function TColumnsInfo.Search(AView: TcxGridDBBandedTableView; AIDCategoryParam:
    Integer): TColumnInfo;
begin
  for Result in Self do
  begin
    if ( Result.Column.GridView = AView ) and (Result.IDCategoryParam = AIDCategoryParam) then
      Exit;
  end;
  Result := nil;
end;

end.
