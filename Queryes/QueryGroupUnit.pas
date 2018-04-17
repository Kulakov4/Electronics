unit QueryGroupUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  FireDAC.Comp.Client, QueryWithDataSourceUnit, System.Contnrs, NotifyEvents;

type
  TQueryGroup = class(TFrame)
  private
    FAfterCommit: TNotifyEventsEx;
    FDetail: TQueryWithDataSource;
    FEventList: TObjectList;
    FMain: TQueryWithDataSource;
    function GetChangeCount: Integer;
    function GetConnection: TFDCustomConnection;
    procedure SetDetail(const Value: TQueryWithDataSource);
    procedure SetMain(const Value: TQueryWithDataSource);
    { Private declarations }
  protected
    procedure CheckMasterAndDetail;
    function GetHaveAnyChanges: Boolean; virtual;
    procedure InitializeQuery(AQuery: TFDQuery); virtual;
    property EventList: TObjectList read FEventList;
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
    property AfterCommit: TNotifyEventsEx read FAfterCommit;
    property ChangeCount: Integer read GetChangeCount;
    property Connection: TFDCustomConnection read GetConnection;
    property Detail: TQueryWithDataSource read FDetail write SetDetail;
    property HaveAnyChanges: Boolean read GetHaveAnyChanges;
    property Main: TQueryWithDataSource read FMain write SetMain;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TQueryGroup.Create(AOwner: TComponent);
begin
  inherited;
  FEventList := TObjectList.Create;
  FAfterCommit := TNotifyEventsEx.Create(Self);
end;

destructor TQueryGroup.Destroy;
begin
  // Отписываемся от всех событий!
  FreeAndNil(FEventList);

end;

function TQueryGroup.ApplyUpdates: Boolean;
begin
  CheckMasterAndDetail;

  Main.TryPost;
  Detail.TryPost;

  Main.ApplyUpdates;
  Detail.ApplyUpdates;
  Result := (not Main.HaveAnyChanges) and (not Detail.HaveAnyChanges);
end;

procedure TQueryGroup.CancelUpdates;
begin
  CheckMasterAndDetail;

  // отменяем все сделанные изменения на стороне клиента
  Main.CancelUpdates;
  Detail.CancelUpdates;
end;

procedure TQueryGroup.CheckMasterAndDetail;
begin
  Assert(Main <> nil);
  Assert(Detail <> nil);
end;

procedure TQueryGroup.Commit;
begin
  CheckMasterAndDetail;
  // Предполагается что мы работаем в транзакции
  Assert(Connection.InTransaction);

  Main.TryPost;
  Detail.TryPost;

  if Connection.InTransaction then
    Connection.Commit;

  FAfterCommit.CallEventHandlers(Self);
end;

function TQueryGroup.GetChangeCount: Integer;
begin
  Assert(Main <> nil);
  Assert(Detail <> nil);
  Result := Main.FDQuery.ChangeCount + Detail.FDQuery.ChangeCount;
end;

function TQueryGroup.GetConnection: TFDCustomConnection;
begin
  Assert(Main <> nil);
  Result := Main.FDQuery.Connection;
end;

function TQueryGroup.GetHaveAnyChanges: Boolean;
begin
  Result := False;

  if Main <> nil then
    Result := Main.HaveAnyChanges;

  if (Detail <> nil) and (not Result) then
    Result := Detail.HaveAnyChanges;
end;

procedure TQueryGroup.InitializeQuery(AQuery: TFDQuery);
begin
  Assert(AQuery <> nil);
end;

procedure TQueryGroup.RefreshData;
begin
  Detail.FDQuery.DisableControls;
  Main.FDQuery.DisableControls;
  try
    Detail.SaveBookmark;
    Main.SaveBookmark;
    ReOpen;
    Main.RestoreBookmark;
    Detail.RestoreBookmark;
  finally
    Main.FDQuery.EnableControls;
    Detail.FDQuery.EnableControls;
  end;
end;

procedure TQueryGroup.ReOpen;
begin
  Detail.FDQuery.Close;
  Main.FDQuery.Close;

  Main.FDQuery.Open;
  Detail.FDQuery.Open;
end;

procedure TQueryGroup.Rollback;
begin
  CheckMasterAndDetail;

  Detail.TryCancel;
  Main.TryCancel;

  // Предполагается что мы работаем в транзакции
  if Connection.InTransaction then
  begin
    Connection.Rollback;
    ReOpen;
  end;
  // Иногда транзакция уже завершилась но программа об этом не знает
end;

procedure TQueryGroup.SetDetail(const Value: TQueryWithDataSource);
begin
  if FDetail <> Value then
  begin
    FDetail := Value;
    InitializeQuery(FDetail.FDQuery);
  end;
end;

procedure TQueryGroup.SetMain(const Value: TQueryWithDataSource);
begin
  if FMain <> Value then
  begin
    FMain := Value;
    InitializeQuery(FMain.FDQuery);
  end;
end;

procedure TQueryGroup.TryPost;
begin
  Main.TryPost;
  Detail.TryPost;
end;

end.
