unit BandsInfo;

interface

uses
  cxGridBandedTableView, System.Generics.Collections, System.Generics.Defaults,
  ParameterKindEnum;

type
  TBandInfo = class(TObject)
  private
    FBand: TcxGridBand;
    FCategoryParamID: Integer;
    FDefaultCreated: Boolean;
    FDefaultVisible: Boolean;
    FOrder: Integer;
    FParameterID: Integer;
    FColIndex: Integer;
    FIDParameterKind: Integer;
    FPos: Integer;
  public
    constructor Create(ABand: TcxGridBand; AParameterID: Integer);
    property Band: TcxGridBand read FBand write FBand;
    property CategoryParamID: Integer read FCategoryParamID write FCategoryParamID;
    property DefaultCreated: Boolean read FDefaultCreated write FDefaultCreated;
    property DefaultVisible: Boolean read FDefaultVisible write FDefaultVisible;
    property Order: Integer read FOrder write FOrder;
    property ParameterID: Integer read FParameterID write FParameterID;
    property ColIndex: Integer read FColIndex write FColIndex;
    property IDParameterKind: Integer read FIDParameterKind write FIDParameterKind;
    property Pos: Integer read FPos write FPos;
  end;

type
  TBandsInfo = class(TList<TBandInfo>)
  private
  public
    procedure FreeNotDefaultBands;
    function GetChangedColIndex(AView: TcxGridBandedTableView): TBandsInfo;
    function GetBandsForView(AView: TcxGridBandedTableView): TBandsInfo;
    function HaveDifferentPos: Boolean;
    procedure HideDefaultBands;
    function Search(AView: TcxGridBandedTableView; AParameterID: Integer)
      : TBandInfo; overload;
    function Search(ABand: TcxGridBand): TBandInfo; overload;
    function SearchByColIndex(AView: TcxGridBandedTableView; AColIndex: Integer)
      : TBandInfo;
  end;

type
  TDescComparer = class(TComparer<TBandInfo>)
  public
    function Compare(const Left, Right: TBandInfo): Integer; override;
  end;

implementation

constructor TBandInfo.Create(ABand: TcxGridBand; AParameterID: Integer);
begin
  inherited Create;
  Assert(ABand <> nil);
  Assert(AParameterID > 0);

  FBand := ABand;
  FParameterID := AParameterID;
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

function TBandsInfo.Search(AView: TcxGridBandedTableView; AParameterID: Integer)
  : TBandInfo;
var
  ABandInfo: TBandInfo;
begin
  Assert(AParameterID > 0);
  Assert(AView <> nil);

  for ABandInfo in Self do
  begin
    Result := ABandInfo;

    if (ABandInfo.ParameterID = AParameterID) and
      (ABandInfo.Band.GridView = AView) then
      Exit;
  end;
  Result := nil;
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

end.
