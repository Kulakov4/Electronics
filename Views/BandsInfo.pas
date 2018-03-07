unit BandsInfo;

interface

uses
  cxGridBandedTableView, System.Generics.Collections, System.Generics.Defaults,
  ParameterKindEnum, cxGridDBBandedTableView, System.SysUtils;

type
  TIDList = class(TList<Integer>)
  public
    procedure Assign(AArray: TArray<Integer>);
    function eq(AArray: TArray<Integer>): Boolean;
    function IsSame(AArray: TArray<Integer>): Boolean;
  end;

  TBandInfo = class(TObject)
  private
    FBand: TcxGridBand;
    FDefaultCreated: Boolean;
    FDefaultVisible: Boolean;
    FOrder: Integer;
    FIDList: TIDList;
    FColIndex: Integer;
    FIDParameter: Integer;
    FIDParameterKind: Integer;
    FIsDefault: Boolean;
    FIDParamSubParam: Integer;
    FPos: Integer;
  protected
  public
    constructor Create(const ABand: TcxGridBand;
      AIDList: TArray<Integer>); overload;
    destructor Destroy; override;
    procedure FreeBand; virtual;
    function HaveBand(OtherBand: TcxGridBand): Boolean; virtual;
    procedure Hide; virtual;
    procedure RestoreBandPosition;
    procedure SaveBandPosition;
    procedure UpdateBandPosition(AColIndex: Integer); virtual;
    property Band: TcxGridBand read FBand write FBand;
    property DefaultCreated: Boolean read FDefaultCreated write FDefaultCreated;
    property DefaultVisible: Boolean read FDefaultVisible write FDefaultVisible;
    property Order: Integer read FOrder write FOrder;
    property IDList: TIDList read FIDList;
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
    procedure FreeBand(ABandInfo: TBandInfo);
    procedure RestoreBandPosition;
    procedure SaveBandPosition;
    function Search(ABand: TcxGridBand; TestResult: Boolean = False)
      : TBandInfo; overload;
    function SearchByColIndex(AColIndex: Integer; TestResult: Boolean = False)
      : TBandInfo;
    function SearchByIDList(const AIDList: TArray<Integer>;
      TestResult: Boolean = False): TBandInfo;
    function SearchByID(const AID: Integer; TestResult: Boolean = False)
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
    FBandIndex: Integer;
    FGeneralColIndex: Integer;
    FColumn: TcxGridDBBandedColumn;
    FDefaultCreated: Boolean;
    FOldGeneralColIndex: Integer;
    FIDCategoryParam: Integer;
    FIsDefault: Boolean;
    FOrder: Integer;
  public
    constructor Create(AColumn: TcxGridDBBandedColumn;
      AIDCategoryParam, AOrder: Integer;
      ADefaultCreated, AIsDefault: Boolean); overload;
    procedure FreeColumn; virtual;
    function HaveColumn(OtherColumn: TcxGridBandedColumn): Boolean; virtual;
    procedure RestoreColumnPosition;
    procedure SetColumnPosition(ABandIndex, AColIndex: Integer); virtual;
    procedure SaveColumnPosition;
    property ColIndex: Integer read FColIndex write FColIndex;
    property BandIndex: Integer read FBandIndex write FBandIndex;
    property GeneralColIndex: Integer read FGeneralColIndex
      write FGeneralColIndex;
    property Column: TcxGridDBBandedColumn read FColumn write FColumn;
    property DefaultCreated: Boolean read FDefaultCreated write FDefaultCreated;
    property OldGeneralColIndex: Integer read FOldGeneralColIndex
      write FOldGeneralColIndex;
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
    function GetChangedGeneralColIndex: TArray<TColumnInfo>;
    procedure RestoreColumnPosition;
    function Search(AColumn: TcxGridDBBandedColumn; TestResult: Boolean = False)
      : TColumnInfo; overload;
    function Search(AIDCategoryParam: Integer; TestResult: Boolean = False)
      : TColumnInfo; overload;
    procedure UpdateGeneralIndexes(AColumns: TArray<TcxGridDBBandedColumn>);
    procedure SaveColumnPosition;
  end;

  TBandInfoEx = class(TBandInfo)
  private
    FBands: TArray<TcxGridBand>;
  protected
  public
    constructor Create(ABands: TArray<TcxGridBand>;
      const AIDList: TArray<Integer>); reintroduce; overload;
    constructor CreateAsDefault(AIDParamSubParam: Integer;
      ABands: TArray<TcxGridBand>);
    procedure FreeBand; override;
    function HaveBand(OtherBand: TcxGridBand): Boolean; override;
    procedure Hide; override;
    procedure UpdateBandPosition(AColIndex: Integer); override;
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
    procedure SetColumnPosition(ABandIndex, AColIndex: Integer); override;
    property Columns: TArray<TcxGridDBBandedColumn> read FColumns
      write FColumns;
  end;

implementation

constructor TBandInfo.Create(const ABand: TcxGridBand;
  AIDList: TArray<Integer>);
begin
  inherited Create;
  Assert(ABand <> nil);

  FBand := ABand;
  FIDList := TIDList.Create;
  FIDList.AddRange(AIDList);
end;

destructor TBandInfo.Destroy;
begin
  FreeAndNil(FIDList);
  inherited;
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

procedure TBandInfo.RestoreBandPosition;
begin
  // Восстанавливаем позицию бэнда
  Band.Position.ColIndex := ColIndex;
end;

procedure TBandInfo.SaveBandPosition;
begin
  // Сохраняем позицию бэнда
  ColIndex := Band.Position.ColIndex;
end;

procedure TBandInfo.UpdateBandPosition(AColIndex: Integer);
begin
  AColIndex := AColIndex;
  Band.Position.ColIndex := AColIndex;
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

    FreeBand(ABandInfo);
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

procedure TBandsInfo.FreeBand(ABandInfo: TBandInfo);
begin
  Assert(ABandInfo <> nil);
  Assert(not ABandInfo.DefaultCreated);

  // Удаляем описание этого бэнда из списка
  Remove(ABandInfo);

  // разрушаем бэнд
  ABandInfo.FreeBand;
  // Удаляем описание бэнда
  ABandInfo.Free;

end;

procedure TBandsInfo.RestoreBandPosition;
var
  ABandInfo: TBandInfo;
begin
  // Восстанавливаем позицию бэнда
  for ABandInfo in Self do
    ABandInfo.RestoreBandPosition;
end;

procedure TBandsInfo.SaveBandPosition;
var
  ABandInfo: TBandInfo;
begin
  // Сохраняем позицию бэнда
  for ABandInfo in Self do
    ABandInfo.SaveBandPosition;
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

function TBandsInfo.SearchByIDList(const AIDList: TArray<Integer>;
  TestResult: Boolean = False): TBandInfo;
begin
  for Result in Self do
  begin
    if Result.IDList.eq(AIDList) then
      Exit;
  end;
  Result := nil;
  if TestResult then
  begin
    Assert(False);
  end;
end;

function TBandsInfo.SearchByID(const AID: Integer; TestResult: Boolean = False)
  : TBandInfo;
begin
  for Result in Self do
  begin
    if Result.IDList.IndexOf(AID) >= 0 then
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
  FIsDefault := AIsDefault;

  // Запоминаем позицию колонки
  SaveColumnPosition;
end;

procedure TColumnInfo.FreeColumn;
begin
  FColumn.Free;
end;

function TColumnInfo.HaveColumn(OtherColumn: TcxGridBandedColumn): Boolean;
begin
  Result := FColumn = OtherColumn;
end;

procedure TColumnInfo.RestoreColumnPosition;
begin
  // восстанавливаем позиции, в которых находились наши колонки
  Column.Position.BandIndex := BandIndex;
  Column.Position.ColIndex := ColIndex;
end;

procedure TColumnInfo.SetColumnPosition(ABandIndex, AColIndex: Integer);
begin
  Column.Position.BandIndex := ABandIndex;
  Column.Position.ColIndex := AColIndex;
  // запоминаем, в какой позиции находятся наши колонки
//  SaveColumnPosition;
end;

procedure TColumnInfo.SaveColumnPosition;
begin
  // запоминаем, в какой позиции находятся наши колонки
  BandIndex := Column.Position.BandIndex;
  ColIndex := Column.Position.ColIndex;
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

function TColumnsInfo.GetChangedGeneralColIndex: TArray<TColumnInfo>;
var
  ACI: TColumnInfo;
  L: TColumnsInfo;
begin
  L := TColumnsInfo.Create;
  try
    for ACI in Self do
    begin
      if ACI.OldGeneralColIndex <> ACI.GeneralColIndex then
        L.Add(ACI);
    end;
    Result := L.ToArray;
  finally
    FreeAndNil(L);
  end;
end;

procedure TColumnsInfo.RestoreColumnPosition;
var
  ACI: TColumnInfo;
begin
  for ACI in Self do
  begin
    // Восстанавливаем позиции колонок
    ACI.RestoreColumnPosition;
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

procedure TColumnsInfo.UpdateGeneralIndexes
  (AColumns: TArray<TcxGridDBBandedColumn>);
var
  ACI: TColumnInfo;
  AColumn: TcxGridDBBandedColumn;
  i: Integer;
begin
  i := 0;
  for AColumn in AColumns do
  begin
    ACI := Search(AColumn);
    // Если эта колонка не является колонкой-подпараметром
    if ACI = nil then
      Continue;

    ACI.OldGeneralColIndex := ACI.GeneralColIndex;
    ACI.GeneralColIndex := i;
    Inc(i);
  end;
end;

procedure TColumnsInfo.SaveColumnPosition;
var
  ACI: TColumnInfo;
begin
  for ACI in Self do
  begin
    // запоминаем, в какой позиции находятся наши колонки
    ACI.SaveColumnPosition;
  end;
end;

constructor TBandInfoEx.Create(ABands: TArray<TcxGridBand>;
  const AIDList: TArray<Integer>);
begin
  // В массиве должен быть хотя-бы один бэнд
  Assert(Length(ABands) > 0);
  inherited Create(ABands[0], AIDList);
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
  FIDList := TIDList.Create;
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

procedure TBandInfoEx.UpdateBandPosition(AColIndex: Integer);
var
  ABand: TcxGridBand;
begin
  inherited;
  for ABand in Bands do
    ABand.Position.ColIndex := AColIndex;
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

procedure TColumnInfoEx.SetColumnPosition(ABandIndex, AColIndex: Integer);
var
  AColumn: TcxGridDBBandedColumn;
begin
  inherited;
  for AColumn in Columns do
  begin
    AColumn.Position.BandIndex := ABandIndex;
    AColumn.Position.ColIndex := AColIndex;
  end;
end;

procedure TIDList.Assign(AArray: TArray<Integer>);
begin
  Self.Clear;
  Self.AddRange(AArray);
end;

function TIDList.eq(AArray: TArray<Integer>): Boolean;
var
  i: Integer;
begin
  Result := Self.Count = Length(AArray);
  if not Result then
    Exit;

  for i := 0 to Self.Count - 1 do
  begin
    Result := Items[i] = AArray[i];
    if not Result then
      Exit;
  end;
end;

function TIDList.IsSame(AArray: TArray<Integer>): Boolean;
var
  i: Integer;
begin
  Result := Self.Count = Length(AArray);
  if not Result then
    Exit;

  for i := 0 to high(AArray) do
  begin
    Result := (IndexOf(AArray[i]) >= 0);
    if not Result then
      Exit;
  end;

end;

end.
