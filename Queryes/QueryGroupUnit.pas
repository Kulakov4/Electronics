unit QueryGroupUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, FireDAC.Comp.Client, BaseEventsQuery, System.Contnrs,
  NotifyEvents, System.Generics.Collections;

type
  TQueryGroup = class(TFrame)
  private
    FEventList: TObjectList;
    FQList: TList<TQueryBaseEvents>;
    function GetChangeCount: Integer;
    function GetConnection: TFDCustomConnection;
    { Private declarations }
  protected
    function GetHaveAnyChanges: Boolean; virtual;
    procedure InitializeQuery(AQuery: TFDQuery); virtual;
    property EventList: TObjectList read FEventList;
    property QList: TList<TQueryBaseEvents> read FQList;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ApplyUpdates: Boolean; virtual;
    procedure CancelUpdates; virtual;
    procedure Commit; virtual;
    procedure RefreshData; virtual;
    procedure ReOpen; virtual;
    procedure Rollback; virtual;
    procedure TryPost; virtual;
    property ChangeCount: Integer read GetChangeCount;
    property Connection: TFDCustomConnection read GetConnection;
    property HaveAnyChanges: Boolean read GetHaveAnyChanges;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TQueryGroup.Create(AOwner: TComponent);
begin
  inherited;
  FEventList := TObjectList.Create;

  FQList := TList<TQueryBaseEvents>.Create;
end;

destructor TQueryGroup.Destroy;
begin
  // Отписываемся от всех событий!
  FreeAndNil(FEventList);
  FreeAndNil(FQList);
end;

function TQueryGroup.ApplyUpdates: Boolean;
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

procedure TQueryGroup.CancelUpdates;
var
  I: Integer;
begin
  Assert(QList.Count > 0);

  // отменяем все сделанные изменения на стороне клиента
  for I := QList.Count - 1 downto 0 do
  begin
    // Просим набор данных отменить все свои изменения
    QList[I].CancelUpdates;
  end;
end;

procedure TQueryGroup.Commit;
begin
  ApplyUpdates;
  Assert(Connection.InTransaction);
  Connection.Commit;
end;

function TQueryGroup.GetChangeCount: Integer;
var
  Q: TQueryBaseEvents;
begin
  Result := 0;
  for Q in QList do
  begin
    Inc(Result, Q.FDQuery.ChangeCount);
  end;
end;

function TQueryGroup.GetConnection: TFDCustomConnection;
begin
  Assert(QList.Count > 0);
  Result := QList[0].FDQuery.Connection;
end;

function TQueryGroup.GetHaveAnyChanges: Boolean;
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

procedure TQueryGroup.InitializeQuery(AQuery: TFDQuery);
begin
  Assert(AQuery <> nil);
end;

procedure TQueryGroup.RefreshData;
var
  I: Integer;
begin
  for I := QList.Count - 1 downto 0 do
    QList[I].FDQuery.DisableControls;
  try
    for I := QList.Count - 1 downto 0 do
      QList[I].Wrap.SaveBookmark;

    ReOpen;

    for I := 0 to QList.Count - 1 do
      QList[I].Wrap.RestoreBookmark;

  finally
    for I := 0 to QList.Count - 1 do
      QList[I].FDQuery.EnableControls;
  end;
end;

procedure TQueryGroup.ReOpen;
var
  I: Integer;
begin
  for I := QList.Count - 1 downto 0 do
    QList[I].FDQuery.Close;

  for I := 0 to QList.Count - 1 do
    QList[I].FDQuery.Open;
end;

procedure TQueryGroup.Rollback;
begin
  CancelUpdates;

  Assert(Connection.InTransaction);

  Connection.Rollback;

  RefreshData;
end;

procedure TQueryGroup.TryPost;
var
  I: Integer;
begin
  for I := 0 to QList.Count - 1 do
    QList[I].TryPost;
end;

end.
