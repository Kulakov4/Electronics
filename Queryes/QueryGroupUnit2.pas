unit QueryGroupUnit2;

interface

uses
  System.Classes, System.Contnrs, BaseEventsQuery, System.Generics.Collections,
  FireDAC.Comp.Client;

type
  TQueryGroup2 = class(TComponent)
  private
    FEventList: TObjectList;
    FQList: TList<TQueryBaseEvents>;
    function GetChangeCount: Integer;
    function GetConnection: TFDCustomConnection;
  protected
    function GetHaveAnyChanges: Boolean; virtual;
    property EventList: TObjectList read FEventList;
    property QList: TList<TQueryBaseEvents> read FQList;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddClient; virtual;
    function ApplyUpdates: Boolean; virtual;
    procedure CancelUpdates; virtual;
    procedure Commit; virtual;
    procedure DisableControls;
    procedure EnableControls;
    procedure RefreshData; virtual;
    procedure RemoveClient; virtual;
    procedure ReOpen; virtual;
    procedure Rollback; virtual;
    procedure TryOpen;
    procedure TryPost; virtual;
    property ChangeCount: Integer read GetChangeCount;
    property Connection: TFDCustomConnection read GetConnection;
    property HaveAnyChanges: Boolean read GetHaveAnyChanges;
  end;

implementation

uses
  System.SysUtils;

constructor TQueryGroup2.Create(AOwner: TComponent);
begin
  inherited;
  FEventList := TObjectList.Create;

  FQList := TList<TQueryBaseEvents>.Create;
end;

destructor TQueryGroup2.Destroy;
begin
  // Отписываемся от всех событий!
  FreeAndNil(FEventList);
  FreeAndNil(FQList);
  inherited;
end;

procedure TQueryGroup2.AddClient;
var
  I: Integer;
begin
  for I := 0 to QList.Count - 1 do
    QList[I].AddClient;
end;

function TQueryGroup2.ApplyUpdates: Boolean;
var
  Q: TQueryBaseEvents;
begin
  Result := False;

  Assert(FQList.Count > 0);
  for Q in QList do
  begin
    Q.ApplyUpdates;

    // Если сохранение не удалось
    if Q.HaveAnyChanges then
      Exit;
  end;
  Result := True;
end;

procedure TQueryGroup2.CancelUpdates;
var
  I: Integer;
begin
  Assert(QList.Count > 0);

  // отменяем все сделанные изменения на стороне клиента
  for I := QList.Count - 1 downto 0 do
  begin
    if QList[I].FDQuery.CachedUpdates then
      QList[I].CancelUpdates;
  end;
end;

procedure TQueryGroup2.Commit;
begin
  ApplyUpdates;
  Assert(Connection.InTransaction);
  Connection.Commit;
end;

procedure TQueryGroup2.DisableControls;
var
  I: Integer;
begin
  for I := QList.Count - 1 downto 0 do
    QList[I].FDQuery.DisableControls;
end;

procedure TQueryGroup2.EnableControls;
var
  I: Integer;
begin
  for I := 0 to QList.Count - 1 do
    QList[I].FDQuery.EnableControls;
end;

function TQueryGroup2.GetChangeCount: Integer;
var
  Q: TQueryBaseEvents;
begin
  Result := 0;
  for Q in QList do
  begin
    Inc(Result, Q.FDQuery.ChangeCount);
  end;
end;

function TQueryGroup2.GetConnection: TFDCustomConnection;
begin
  Assert(QList.Count > 0);
  Result := QList[0].FDQuery.Connection;
end;

function TQueryGroup2.GetHaveAnyChanges: Boolean;
var
  Q: TQueryBaseEvents;
begin
  Result := False;
  for Q in QList do
  begin
    Result := Q.HaveAnyChanges;
    if Result then
      Exit;
  end;
end;

procedure TQueryGroup2.RefreshData;
var
  I: Integer;
begin
  // DisableControls;
  // try
  for I := QList.Count - 1 downto 0 do
    QList[I].Wrap.SaveBookmark;

  ReOpen;

  for I := 0 to QList.Count - 1 do
    QList[I].Wrap.RestoreBookmark;

  // finally
  // !! FDQuery.EnableControls вызывает ошибку в cxGrid у дочернего представления
  // EnableControls;
  // end;
end;

procedure TQueryGroup2.RemoveClient;
var
  I: Integer;
begin
  for I := 0 to QList.Count - 1 do
    QList[I].RemoveClient;
end;

procedure TQueryGroup2.ReOpen;
var
  I: Integer;
begin
  for I := QList.Count - 1 downto 0 do
    QList[I].FDQuery.Close;

  for I := 0 to QList.Count - 1 do
    QList[I].FDQuery.Open;
end;

procedure TQueryGroup2.Rollback;
begin
  CancelUpdates;

  Assert(Connection.InTransaction);

  Connection.Rollback;

  RefreshData;
end;

procedure TQueryGroup2.TryOpen;
var
  I: Integer;
begin
  for I := 0 to QList.Count - 1 do
    QList[I].Wrap.TryOpen;
end;

procedure TQueryGroup2.TryPost;
var
  I: Integer;
begin
  for I := 0 to QList.Count - 1 do
    QList[I].Wrap.TryPost;
end;

end.
