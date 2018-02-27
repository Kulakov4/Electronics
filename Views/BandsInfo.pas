unit BandsInfo;

interface

uses
  cxGridBandedTableView, System.Generics.Collections, System.Generics.Defaults,
  ParameterKindEnum, cxGridDBBandedTableView;

type
  TBandInfo = class(TObject)
  private
    FBand: TcxGridBand;
    FDefaultCreated: Boolean;
    FDefaultVisible: Boolean;
    FOrder: Integer;
    FBandID: Integer;
    FColIndex: Integer;
    FIDParameter: Integer;
    FIDParameterKind: Integer;
    FIsDefault: Boolean;
    FIDParamSubParam: Integer;
    FPos: Integer;
  protected
  public
    constructor Create(ABand: TcxGridBand; ABandID: Integer); overload;
    procedure FreeBand; virtual;
    function HaveBand(OtherBand: TcxGridBand): Boolean; virtual;
    procedure Hide; virtual;
    property Band: TcxGridBand read FBand write FBand;
    property DefaultCreated: Boolean read FDefaultCreated write FDefaultCreated;
    property DefaultVisible: Boolean read FDefaultVisible write FDefaultVisible;
    property Order: Integer read FOrder write FOrder;
    property BandID: Integer read FBandID write FBandID;
    property ColIndex: Integer read FColIndex write FColIndex;
    property IDParameter: Integer read FIDParameter write FIDParameter;
    property IDParameterKind: Integer read FIDParameterKind
      write FIDParameterKind;
    property IsDefault: Boolean read FIsDefault write FIsDefault;
    property IDParamSubParam: Integer read FIDParamSubParam
      write FIDParamSubParam;
    property Pos: Integer read FPos write FPos;
  end;

  TBandsInfo = class(TList<TBandInfo>)
  private
  protected
  public
    procedure FreeNotDefaultBands;
    function GetChangedColIndex: TBandsInfo;
    function HaveDifferentPos: Boolean;
    procedure HideDefaultBands;
    function Search(ABand: TcxGridBand; TestResult: Boolean = False)
      : TBandInfo; overload;
    function SearchByColIndex(AColIndex: Integer; TestResult: Boolean = False)
      : TBandInfo;
    function SearchByID(AIDBand: Integer; TestResult: Boolean = False)
      : TBandInfo;
    function SearchByIDParamSubParam(AIDParamSubParam: Integer;
      TestResult: Boolean = False): TBandInfo;
  end;

  TDescComparer = class(TComparer<TBandInfo>)
  public
    function Compare(const Left, Right: TBandInfo): Integer; override;
  end;

  TColumnInfo = class(TObject)
  private
    FColIndex: Integer;
    FColumn: TcxGridDBBandedColumn;
    FDefaultCreated: Boolean;
    FIDCategoryParam: Integer;
    FIsDefault: Boolean;
    FOrder: Integer;
  public
    constructor Create(AColumn: TcxGridDBBandedColumn;
      AIDCategoryParam, AOrder: Integer;
      ADefaultCreated, AIsDefault: Boolean); overload;
    procedure FreeColumn; virtual;
    function HaveColumn(OtherColumn: TcxGridBandedColumn): Boolean; virtual;
    property ColIndex: Integer read FColIndex write FColIndex;
    property Column: TcxGridDBBandedColumn read FColumn write FColumn;
    property DefaultCreated: Boolean read FDefaultCreated write FDefaultCreated;
    property IDCategoryParam: Integer read FIDCategoryParam
      write FIDCategoryParam;
    property IsDefault: Boolean read FIsDefault write FIsDefault;
    property Order: Integer read FOrder write FOrder;
  end;

  TColumnsInfo = class(TList<TColumnInfo>)
  protected
  public
    procedure FreeNotDefaultColumns;
    function GetChangedColIndex: TColumnsInfo;
    function Search(AColumn: TcxGridDBBandedColumn; TestResult: Boolean = False)
      : TColumnInfo; overload;
    function Search(AIDCategoryParam: Integer; TestResult: Boolean = False)
      : TColumnInfo; overload;
  end;

  TBandInfoEx = class(TBandInfo)
  private
    FBands: TArray<TcxGridBand>;
  protected
  public
    constructor Create(ABands: TArray<TcxGridBand>; ABandID: Integer);
      reintroduce; overload;
    constructor CreateAsDefault(AIDParamSubParam: Integer;
      ABands: TArray<TcxGridBand>);
    procedure FreeBand; override;
    function HaveBand(OtherBand: TcxGridBand): Boolean; override;
    procedure Hide; override;
    property Bands: TArray<TcxGridBand> read FBands write FBands;
  end;

  TColumnInfoEx = class(TColumnInfo)
  private
    FColumns: TArray<TcxGridDBBandedColumn>;
  public
    constructor Create(AColumns: TArray<TcxGridDBBandedColumn>;
      AIDCategoryParam, AOrder: Integer; ADefaultCreated, AIsDefault: Boolean);
      reintroduce; overload;
    procedure FreeColumn; override;
    function HaveColumn(OtherColumn: TcxGridBandedColumn): Boolean; override;
    property Columns: TArray<TcxGridDBBandedColumn> read FColumns
      write FColumns;
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

procedure TBandInfo.FreeBand;
begin
  // разрушаем связанный с описанием бэнд
  Band.Free;
  Band := nil;
end;

function TBandInfo.HaveBand(OtherBand: TcxGridBand): Boolean;
begin
  Assert(OtherBand <> nil);
  Result := FBand = OtherBand;
end;

procedure TBandInfo.Hide;
begin
  Band.Visible := False;
  Band.VisibleForCustomization := False;
end;

procedure TBandsInfo.FreeNotDefaultBands;
var
  ABandInfo: TBandInfo;
  i: Integer;
begin
  for i := Count - 1 downto 0 do
  begin
    ABandInfo := Items[i];
    if ABandInfo.DefaultCreated then
      Continue;

    // Удаляем описание этого бэнда из списка
    Remove(ABandInfo);

    // разрушаем бэнд
    ABandInfo.FreeBand;
    // Удаляем описание бэнда
    ABandInfo.Free;
  end;

end;

function TBandsInfo.GetChangedColIndex: TBandsInfo;
var
  ABandInfo: TBandInfo;
begin
  Result := TBandsInfo.Create;
  for ABandInfo in Self do
  begin
    if ABandInfo.ColIndex <> ABandInfo.Band.Position.ColIndex then
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
      ABandInfo.Hide;
    end;
end;

function TBandsInfo.Search(ABand: TcxGridBand; TestResult: Boolean = False)
  : TBandInfo;
begin
  Assert(ABand <> nil);

  for Result in Self do
  begin
    if Result.HaveBand(ABand) then
      Exit;
  end;
  Result := nil;
  if TestResult then
    Assert(False);
end;

function TBandsInfo.SearchByColIndex(AColIndex: Integer;
  TestResult: Boolean = False): TBandInfo;
begin
  Assert(AColIndex > 0);

  for Result in Self do
  begin
    if Result.ColIndex = AColIndex then
      Exit;
  end;
  Result := nil;
  if TestResult then
    Assert(False);
end;

function TBandsInfo.SearchByID(AIDBand: Integer; TestResult: Boolean = False)
  : TBandInfo;
begin
  Assert(AIDBand > 0);

  for Result in Self do
  begin
    if Result.BandID = AIDBand then
      Exit;
  end;
  Result := nil;
  if TestResult then
    Assert(False);
end;

function TBandsInfo.SearchByIDParamSubParam(AIDParamSubParam: Integer;
  TestResult: Boolean = False): TBandInfo;
begin
  Assert(AIDParamSubParam > 0);

  for Result in Self do
  begin
    if (Result.IDParamSubParam = AIDParamSubParam) and (Result.IsDefault = True)
    then
      Exit;
  end;
  Result := nil;

  if TestResult then
    Assert(False);
end;

function TDescComparer.Compare(const Left, Right: TBandInfo): Integer;
begin
  // Сортировка в обратном порядке
  Result := -1 * (Left.ColIndex - Right.ColIndex);
end;

constructor TColumnInfo.Create(AColumn: TcxGridDBBandedColumn;
  AIDCategoryParam, AOrder: Integer; ADefaultCreated, AIsDefault: Boolean);
begin
  Assert(AColumn <> nil);
  Assert(AIDCategoryParam > 0);
  Assert(AOrder > 0);

  FColumn := AColumn;
  FIDCategoryParam := AIDCategoryParam;
  FOrder := AOrder;
  FDefaultCreated := ADefaultCreated;
  FColIndex := FColumn.Position.ColIndex;
  FIsDefault := AIsDefault;
end;

procedure TColumnInfo.FreeColumn;
begin
  FColumn.Free;
end;

function TColumnInfo.HaveColumn(OtherColumn: TcxGridBandedColumn): Boolean;
begin
  Result := FColumn = OtherColumn;
end;

procedure TColumnsInfo.FreeNotDefaultColumns;
var
  ACI: TColumnInfo;
  i: Integer;
begin
  for i := Count - 1 downto 0 do
  begin
    ACI := Items[i];
    if ACI.DefaultCreated then
      Continue;

    // Удаляем описание этой колонки
    Remove(ACI);

    // разрушаем колонку
    ACI.FreeColumn;
    ACI.Free;
  end;

end;

function TColumnsInfo.GetChangedColIndex: TColumnsInfo;
var
  ACI: TColumnInfo;
begin
  Result := TColumnsInfo.Create;
  for ACI in Self do
  begin
    if ACI.ColIndex <> ACI.Column.Position.ColIndex then
      Result.Add(ACI);
  end;
end;

function TColumnsInfo.Search(AColumn: TcxGridDBBandedColumn;
  TestResult: Boolean = False): TColumnInfo;
begin
  Assert(AColumn <> nil);
  for Result in Self do
  begin
    if Result.HaveColumn(AColumn) then
      Exit;
  end;
  Result := nil;

  if TestResult then
    Assert(False);
end;

function TColumnsInfo.Search(AIDCategoryParam: Integer;
  TestResult: Boolean = False): TColumnInfo;
begin
  for Result in Self do
  begin
    if Result.IDCategoryParam = AIDCategoryParam then
      Exit;
  end;
  Result := nil;
  if TestResult then
    Assert(False);
end;

constructor TBandInfoEx.Create(ABands: TArray<TcxGridBand>; ABandID: Integer);
begin
  // В массиве должен быть хотя-бы один бэнд
  Assert(Length(ABands) > 0);
  inherited Create(ABands[0], ABandID);
  // Все бэнды
  FBands := ABands;
end;

constructor TBandInfoEx.CreateAsDefault(AIDParamSubParam: Integer;
  ABands: TArray<TcxGridBand>);
begin
  // В массиве должен быть хотя-бы один бэнд
  Assert(Length(ABands) > 0);
  Assert(AIDParamSubParam > 0);

  // Главный бэнд
  FBand := ABands[0];
  // Все бэнды
  FBands := ABands;
  IsDefault := True;
  DefaultCreated := True;
  FIDParamSubParam := AIDParamSubParam;
end;

procedure TBandInfoEx.FreeBand;
var
  ABand: TcxGridBand;
begin
  // разрушаем связанные с описанием бэнды
  for ABand in FBands do
  begin
    ABand.Free;
  end;
  // В массиве больше нет ссылок на бэнды
  SetLength(FBands, 0);
end;

function TBandInfoEx.HaveBand(OtherBand: TcxGridBand): Boolean;
var
  ABand: TcxGridBand;
begin
  Assert(OtherBand <> nil);
  Result := False;
  for ABand in FBands do
  begin
    if ABand = OtherBand then
    begin
      Result := True;
      Exit;
    end;
  end;
end;

procedure TBandInfoEx.Hide;
var
  ABand: TcxGridBand;
begin
  for ABand in FBands do
  begin
    ABand.Visible := False;
    ABand.VisibleForCustomization := False;
  end;
end;

constructor TColumnInfoEx.Create(AColumns: TArray<TcxGridDBBandedColumn>;
  AIDCategoryParam, AOrder: Integer; ADefaultCreated, AIsDefault: Boolean);
begin
  // В массиве колонок должна быть хотя бы одна колонка
  Assert(Length(AColumns) > 0);
  Create(AColumns[0], AIDCategoryParam, AOrder, ADefaultCreated, AIsDefault);
  FColumns := AColumns;
end;

procedure TColumnInfoEx.FreeColumn;
var
  AColumn: TcxGridBandedColumn;
begin
  for AColumn in FColumns do
  begin
    AColumn.Free;
  end;
  SetLength(FColumns, 0);
end;

function TColumnInfoEx.HaveColumn(OtherColumn: TcxGridBandedColumn): Boolean;
var
  AColumn: TcxGridBandedColumn;
begin
  Result := False;

  for AColumn in FColumns do
  begin
    if AColumn = OtherColumn then
    begin
      Result := True;
      Exit;
    end;
  end;

end;

end.
