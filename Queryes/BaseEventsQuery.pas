unit BaseEventsQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  NotifyEvents, System.Contnrs, System.Generics.Collections, DSWrap;

const
  WM_DS_BEFORE_SCROLL = WM_USER + 555;
  WM_DS_AFTER_POST = WM_USER + 557;

type
  TQueryMonitor = class;

  TQueryBaseEvents = class(TQueryBase)
    procedure FDQueryBeforeScroll(DataSet: TDataSet);
  private
    FAutoTransaction: Boolean;
    FBeforeScroll: TNotifyEventsEx;
    FAfterCommit: TNotifyEventsEx;
    FAfterCancelUpdates: TNotifyEventsEx;
    FHaveAnyNotCommitedChanges: Boolean;
    FResiveBeforeScrollMessage: Boolean;
    class var FMonitor: TQueryMonitor;
    procedure DoAfterDelete(Sender: TObject);
    procedure DoAfterPost(Sender: TObject);
    procedure TryStartTransaction(Sender: TObject);
    procedure SetAutoTransaction(const Value: Boolean);
    { Private declarations }
  protected
    FAutoTransactionEventList: TObjectList;
    FDSWrap: TDSWrap;
    FMasterEventList: TObjectList;
    function CreateDSWrap: TDSWrap; virtual; abstract;
    procedure DoAfterCommit(Sender: TObject);
    procedure DoAfterRollback(Sender: TObject);
    function GetHaveAnyNotCommitedChanges: Boolean; override;
    procedure ProcessBeforeScrollMessage(var Message: TMessage);
      message WM_DS_BEFORE_SCROLL;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    // TODO: AddClone
    // function AddClone(const AFilter: String): TFDMemTable;
    procedure CancelUpdates; override;
    property AutoTransaction: Boolean read FAutoTransaction
      write SetAutoTransaction;
    property BeforeScroll: TNotifyEventsEx read FBeforeScroll;
    property AfterCommit: TNotifyEventsEx read FAfterCommit;
    property AfterCancelUpdates: TNotifyEventsEx read FAfterCancelUpdates;
    property HaveAnyNotCommitedChanges: Boolean read FHaveAnyNotCommitedChanges;
    class property Monitor: TQueryMonitor read FMonitor;
    property Wrap: TDSWrap read FDSWrap;
    { Public declarations }
  end;

  TQueryMonitor = class
  private
    FChangedQueries: TList<TQueryBaseEvents>;
    FEventList: TObjectList;
    FOnHaveAnyChanges: TNotifyEventsEx;
    FQueries: TList<TQueryBaseEvents>;
    procedure DoChangedListNotify(Sender: TObject; const Item: TQueryBaseEvents;
      Action: TCollectionNotification);
    function GetConnection: TFDCustomConnection;
    function GetHaveAnyChanges: Boolean;
    function GetIsEmpty: Boolean;
  protected
    procedure DoAfterCommitOrRollback(Sender: TObject);
    procedure DoAfterDelete(Sender: TObject);
    procedure DoAfterEditOrInsert(Sender: TObject);
    procedure DoAfterCancelOrPost(Sender: TObject);
    property Queries: TList<TQueryBaseEvents> read FQueries;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(AQuery: TQueryBaseEvents);
    procedure ApplyUpdates;
    procedure CancelUpdates;
    procedure Remove(AQuery: TQueryBaseEvents);
    procedure TryCommit;
    procedure TryRollback;
    property Connection: TFDCustomConnection read GetConnection;
    property HaveAnyChanges: Boolean read GetHaveAnyChanges;
    property IsEmpty: Boolean read GetIsEmpty;
    property OnHaveAnyChanges: TNotifyEventsEx read FOnHaveAnyChanges;
  end;

implementation

{$R *.dfm}

uses RepositoryDataModule, QueryGroupUnit;

{ TfrmDataModule }

constructor TQueryBaseEvents.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  // ������ ������ ������ ����
  FDSWrap := CreateDSWrap;

  TNotifyEventWrap.Create(FDSWrap.AfterDelete, DoAfterDelete,
    FDSWrap.EventList);

  TNotifyEventWrap.Create(FDSWrap.AfterPost, DoAfterPost,
    FDSWrap.EventList);



  // ������ �������
  FBeforeScroll := TNotifyEventsEx.Create(Self);

  FAfterCommit := TNotifyEventsEx.Create(Self);

  FAfterCancelUpdates := TNotifyEventsEx.Create(Self);

  FResiveBeforeScrollMessage := True;

  // �� ��������� ���������� ���� ���������� � �������������
  FAutoTransaction := True;

  // ������ ������ ����� ����������� �� �������
  FAutoTransactionEventList := TObjectList.Create;
  FMasterEventList := TObjectList.Create;

  if FMonitor = nil then
    FMonitor := TQueryMonitor.Create;

  // ��������� ���� � ������ ���� ��������
  FMonitor.Add(Self);

end;

destructor TQueryBaseEvents.Destroy;
begin

  FreeAndNil(FBeforeScroll);
  FreeAndNil(FAfterCommit);

  FreeAndNil(FAfterCancelUpdates);

  Assert(FMonitor <> nil);
  // ������� ���� �� ������ ���� ��������
  FMonitor.Remove(Self);

  // ���� ������� ������ �� �����
  if FMonitor.IsEmpty then
    FreeAndNil(FMonitor);

  FreeAndNil(FMasterEventList); // ������������ �� ���� ������� �������
  FreeAndNil(FAutoTransactionEventList);
  inherited;
end;

// TODO: AddClone
// function TQueryBaseEvents.AddClone(const AFilter: String): TFDMemTable;
// begin
/// / ������ ������ ������
// if FClones = nil then
// begin
// FClones := TObjectList<TFDMemTable>.Create;
//
// // ������ �����������
// FCloneEvents := TObjectList.Create;
//
// // ����� ����������� �������
// TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, FCloneEvents);
// // ����� ��������� �������
// TNotifyEventWrap.Create(AfterClose, DoAfterClose, FCloneEvents);
// end;
//
// Result := TFDMemTable.Create(nil); // ���������� ����� ������
// Result.Filter := AFilter;
//
/// / ���������
// if FDQuery.Active then
// CloneCursor(Result);
//
// FClones.Add(Result); // ���������� ����� ������
// end;

procedure TQueryBaseEvents.CancelUpdates;
begin
  inherited;
  // ������������� �������� � ���, ��� ��������� ��������
  if FDQuery.CachedUpdates then
  begin
    FAfterCancelUpdates.CallEventHandlers(Self);
  end;
end;

procedure TQueryBaseEvents.DoAfterCommit(Sender: TObject);
begin
  if FHaveAnyNotCommitedChanges then
  begin
    // �������� ��� � ��� ��� �� ������������� ���������
    FHaveAnyNotCommitedChanges := False;
    // �������� ���� ��� ���� ��������� �����������
    FAfterCommit.CallEventHandlers(Self);
  end;
end;

procedure TQueryBaseEvents.DoAfterDelete(Sender: TObject);
begin
  // ���� ���������� ��� �� �����������
  if FDQuery.Connection.InTransaction then
    FHaveAnyNotCommitedChanges := True;
end;

procedure TQueryBaseEvents.DoAfterPost(Sender: TObject);
begin
  // ���� ���������� ��� �� �����������
  if FDQuery.Connection.InTransaction then
    FHaveAnyNotCommitedChanges := True;
end;

procedure TQueryBaseEvents.DoAfterRollback(Sender: TObject);
begin
  // �������� ��� � ��� ��� �� ������������� ���������
  FHaveAnyNotCommitedChanges := False;
end;

procedure TQueryBaseEvents.TryStartTransaction(Sender: TObject);
begin
  // �������� ����������, ���� ��� ��� �� ��������
  if (not AutoTransaction) and (not FDQuery.Connection.InTransaction) then
    FDQuery.Connection.StartTransaction;
end;

procedure TQueryBaseEvents.FDQueryBeforeScroll(DataSet: TDataSet);
begin
  inherited;
  // ���� ���������� ��������� � ������ ��� ��������
  if FResiveBeforeScrollMessage then
  begin
    FResiveBeforeScrollMessage := False;
    // ���������� ����� ���������
    PostMessage(Handle, WM_DS_BEFORE_SCROLL, 0, 0);
  end;
end;

function TQueryBaseEvents.GetHaveAnyNotCommitedChanges: Boolean;
begin
  Result := FHaveAnyNotCommitedChanges;
end;

procedure TQueryBaseEvents.ProcessBeforeScrollMessage(var Message: TMessage);
begin
  FBeforeScroll.CallEventHandlers(Self);
  FResiveBeforeScrollMessage := True;
end;

procedure TQueryBaseEvents.SetAutoTransaction(const Value: Boolean);
begin
  if FAutoTransaction <> Value then
  begin
    FAutoTransaction := Value;

    // ���� �� ������� ����� ��������������
    if not FAutoTransaction then
    begin
      // ��������� ��-�������������� ����������
      TNotifyEventWrap.Create(DMRepository.AfterCommit, DoAfterCommit,
        FAutoTransactionEventList);

      TNotifyEventWrap.Create(DMRepository.AfterRollback, DoAfterRollback,
        FAutoTransactionEventList);

      TNotifyEventWrap.Create(Wrap.BeforeInsert, TryStartTransaction,
        FAutoTransactionEventList);
      TNotifyEventWrap.Create(Wrap.BeforeDelete, TryStartTransaction,
        FAutoTransactionEventList);
      TNotifyEventWrap.Create(Wrap.BeforeEdit, TryStartTransaction,
        FAutoTransactionEventList);
    end
    else
    begin
      FAutoTransactionEventList.Clear;
    end;

  end;
end;

constructor TQueryMonitor.Create;
begin
  inherited;
  FQueries := TList<TQueryBaseEvents>.Create;
  FChangedQueries := TList<TQueryBaseEvents>.Create;
  FChangedQueries.OnNotify := DoChangedListNotify;

  FEventList := TObjectList.Create(True);

  TNotifyEventWrap.Create(DMRepository.AfterCommit, DoAfterCommitOrRollback,
    FEventList);

  TNotifyEventWrap.Create(DMRepository.AfterRollback, DoAfterCommitOrRollback,
    FEventList);

  FOnHaveAnyChanges := TNotifyEventsEx.Create(Self);
end;

destructor TQueryMonitor.Destroy;
begin
  FreeAndNil(FOnHaveAnyChanges);
  FreeAndNil(FEventList);
  FreeAndNil(FQueries);
  FreeAndNil(FChangedQueries);
  inherited;
end;

procedure TQueryMonitor.Add(AQuery: TQueryBaseEvents);
var
  i: Integer;
begin
  Assert(AQuery <> nil);

  i := FQueries.IndexOf(AQuery);
  Assert(i = -1);

  FQueries.Add(AQuery);

  TNotifyEventWrap.Create(AQuery.FDSWrap.AfterEdit, DoAfterEditOrInsert,
    FEventList);
  TNotifyEventWrap.Create(AQuery.FDSWrap.AfterInsert, DoAfterEditOrInsert,
    FEventList);
  TNotifyEventWrap.Create(AQuery.FDSWrap.AfterDelete, DoAfterDelete,
    FEventList);
  TNotifyEventWrap.Create(AQuery.FDSWrap.AfterCancel, DoAfterCancelOrPost,
    FEventList);
  TNotifyEventWrap.Create(AQuery.FDSWrap.AfterPost, DoAfterCancelOrPost,
    FEventList);
  TNotifyEventWrap.Create(AQuery.AfterCancelUpdates, DoAfterCancelOrPost,
    FEventList);
end;

procedure TQueryMonitor.DoAfterCommitOrRollback(Sender: TObject);
var
  i: Integer;
begin
  for i := FChangedQueries.Count - 1 downto 0 do
  begin
    if not FChangedQueries[i].HaveAnyChanges then
      FChangedQueries.Delete(i);
  end;
end;

procedure TQueryMonitor.DoAfterDelete(Sender: TObject);
var
  i: Integer;
  Q: TQueryBaseEvents;
begin
  Q := Sender as TQueryBaseEvents;

  // ���� ��� ������������� ���������
  if not Q.HaveAnyChanges then
  begin
    i := FChangedQueries.IndexOf(Q);
    if i >= 0 then
      FChangedQueries.Delete(i);
  end
  else
    FChangedQueries.Add(Q);
  // ����������, ��� ����� ���� �� ���������� ���������
end;

procedure TQueryMonitor.DoAfterEditOrInsert(Sender: TObject);
var
  i: Integer;
  Q: TQueryBaseEvents;
begin
  Q := Sender as TQueryBaseEvents;

  if not Q.HaveAnyChanges then
    Exit;

  i := FChangedQueries.IndexOf(Q);
  // ���� ����� ������� ��� ��� � ������ ���������
  if i = -1 then
    FChangedQueries.Add(Q);
end;

procedure TQueryMonitor.DoAfterCancelOrPost(Sender: TObject);
var
  i: Integer;
  Q: TQueryBaseEvents;
begin
  Q := Sender as TQueryBaseEvents;

  i := FChangedQueries.IndexOf(Q);

  // ���� ��������� � ���� ������� �� ������� ����������
  if i < 0 then
    Exit;

  // ���� ��� ������������ ���������
  if not Q.HaveAnyChanges then
    FChangedQueries.Delete(i);
end;

function TQueryMonitor.GetHaveAnyChanges: Boolean;
begin
  Result := FChangedQueries.Count > 0;
end;

procedure TQueryMonitor.ApplyUpdates;
var
  ACount: Integer;
  AQueryGroup: TQueryGroup;
  k: Integer;
  Q: TQueryBaseEvents;
begin
  if not HaveAnyChanges then
    Exit;

  ACount := FChangedQueries.Count;
  k := 0;

  while (FChangedQueries.Count > 0) and (k < ACount) do
  begin
    Q := FChangedQueries[0];
    if (Q.Owner <> nil) and (Q.Owner is TQueryGroup) then
    begin
      AQueryGroup := Q.Owner as TQueryGroup;
      // ������ ������ ��������� ���� ���������
      AQueryGroup.ApplyUpdates;
      Inc(k);
    end
    else
    begin
      // ���� ������ ��� �� ����
      Q.ApplyUpdates;
    end;

    Continue;
  end;

  TryCommit;
end;

procedure TQueryMonitor.CancelUpdates;
var
  ACount: Integer;
  AQueryGroup: TQueryGroup;
  k: Integer;
  Q: TQueryBaseEvents;
begin
  if not HaveAnyChanges then
    Exit;

  ACount := FChangedQueries.Count;
  k := 0;

  while (FChangedQueries.Count > 0) and (k < ACount) do
  begin
    Q := FChangedQueries[0];
    if (Q.Owner <> nil) and (Q.Owner is TQueryGroup) then
    begin
      AQueryGroup := Q.Owner as TQueryGroup;
      // ������ ������ �������� ���� ���������
      AQueryGroup.CancelUpdates;
      Inc(k);
    end
    else
    begin
      // ���� ������ ��� �� ����
      Q.CancelUpdates;
    end;

    Continue;
  end;

  TryRollback;
end;

procedure TQueryMonitor.DoChangedListNotify(Sender: TObject;
  const Item: TQueryBaseEvents; Action: TCollectionNotification);
var
  ACount: Integer;
begin
  ACount := (Sender as TList<TQueryBaseEvents>).Count;
  if ((Action = cnAdded) and (ACount = 1)) or
    ((Action = cnRemoved) and (ACount = 0)) then
  begin
    FOnHaveAnyChanges.CallEventHandlers(Self);
  end;
end;

function TQueryMonitor.GetConnection: TFDCustomConnection;
begin
  Result := nil;
  if FQueries.Count = 0 then
    Exit;

  Result := FQueries.Last.FDQuery.Connection;
end;

function TQueryMonitor.GetIsEmpty: Boolean;
begin
  Result := FQueries.Count = 0;
end;

procedure TQueryMonitor.Remove(AQuery: TQueryBaseEvents);
var
  i: Integer;
begin
  Assert(AQuery <> nil);

  // �� �� ������ ��������� ������, ������� ����� ������������ ������
  i := FChangedQueries.IndexOf(AQuery);

  if i >= 0 then
    beep;

  Assert(i = -1);

  i := FQueries.IndexOf(AQuery);
  Assert(i >= 0);

  FQueries.Delete(i);
end;

procedure TQueryMonitor.TryCommit;
begin
  // ���� ���� ������������� ����������
  if Connection.InTransaction then
    Connection.Commit;
end;

procedure TQueryMonitor.TryRollback;
begin
  // ���� ���� ������������� ����������
  if Connection.InTransaction then
    Connection.Rollback; // �������� ����������
end;

end.
