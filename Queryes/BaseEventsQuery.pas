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

type
  TQueryMonitor = class;

  TQueryBaseEvents = class(TQueryBase)
    procedure DefaultOnGetText(Sender: TField; var Text: string; DisplayText:
        Boolean);
    procedure HideNullGetText(Sender: TField; var Text: string; DisplayText:
        Boolean);
  private
    FAutoTransaction: Boolean;
    FAfterCommit: TNotifyEventsEx;
    FAfterCancelUpdates: TNotifyEventsEx;
    FHaveAnyNotCommitedChanges: Boolean;
    FLock: Boolean;
    FMaster: TQueryBaseEvents;
    FNeedLoad: Boolean;
    FNeedRefresh: Boolean;
    class var FMonitor: TQueryMonitor;
    procedure DoAfterDelete(Sender: TObject);
    procedure DoAfterMasterScroll(Sender: TObject);
// TODO: FIsModifedClone
//  FIsModifedClone: TFDMemTable;
    procedure DoAfterOpen(Sender: TObject);
    procedure DoAfterPost(Sender: TObject);
    procedure DoBeforePost(Sender: TObject);
    function GetActual: Boolean;
    procedure InitializeFields;
    procedure TryStartTransaction(Sender: TObject);
    procedure SetAutoTransaction(const Value: Boolean);
    procedure SetLock(const Value: Boolean);
    procedure SetMaster(const Value: TQueryBaseEvents);
    { Private declarations }
  protected
    FAutoTransactionEventList: TObjectList;
    FDSWrap: TDSWrap;
    FMasterEventList: TObjectList;
    function CreateDSWrap: TDSWrap; virtual; abstract;
    procedure DoAfterCommit(Sender: TObject);
    procedure DoAfterRollback(Sender: TObject);
    function GetHaveAnyNotCommitedChanges: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    // TODO: AddClone
    // function AddClone(const AFilter: String): TFDMemTable;
    procedure CancelUpdates; override;
    procedure Load; overload;
    procedure MasterCascadeDelete;
    procedure RefreshQuery; override;
    // TODO: PostPostMessage
    // procedure PostPostMessage;
    procedure TryLoad;
    procedure TryPost; override;
    procedure TryRefresh;
    property Actual: Boolean read GetActual;
    property AutoTransaction: Boolean read FAutoTransaction
      write SetAutoTransaction;
    property AfterCommit: TNotifyEventsEx read FAfterCommit;
    property AfterCancelUpdates: TNotifyEventsEx read FAfterCancelUpdates;
    property HaveAnyNotCommitedChanges: Boolean read FHaveAnyNotCommitedChanges;
    property Lock: Boolean read FLock write SetLock;
    property Master: TQueryBaseEvents read FMaster write SetMaster;
    class property Monitor: TQueryMonitor read FMonitor;
    property NeedRefresh: Boolean read FNeedRefresh;
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

uses RepositoryDataModule, QueryGroupUnit, System.Math;

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

  // ��� ���� ����� ����������� �� ������ ���� + ����������� ������ (���� ����)
  TNotifyEventWrap.Create(Wrap.AfterOpen, DoAfterOpen, Wrap.EventList);

  // �� ���� ��������� ����� ����� ������� ��������� � �������� �������
  TNotifyEventWrap.Create(Wrap.BeforePost, DoBeforePost, Wrap.EventList);


  // ������ �������
  FAfterCommit := TNotifyEventsEx.Create(Self);

  FAfterCancelUpdates := TNotifyEventsEx.Create(Self);

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

procedure TQueryBaseEvents.CancelUpdates;
begin
  inherited;
  // ������������� �������� � ���, ��� ��������� ��������
  if FDQuery.CachedUpdates then
  begin
    FAfterCancelUpdates.CallEventHandlers(Self);
  end;
end;

procedure TQueryBaseEvents.DefaultOnGetText(Sender: TField; var Text: string;
    DisplayText: Boolean);
begin
  Text := VarToStr(Sender.Value);
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

procedure TQueryBaseEvents.DoAfterMasterScroll(Sender: TObject);
begin
  TryLoad;
end;

procedure TQueryBaseEvents.DoAfterOpen(Sender: TObject);
var
  i: Integer;
begin
  // ������� � ���������� ������ �����
  InitializeFields;

  // ������ ������������ ���� ����� �� ������ ����
  for i := 0 to FDQuery.FieldCount - 1 do
    FDQuery.Fields[i].Alignment := taLeftJustify;
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

procedure TQueryBaseEvents.DoBeforePost(Sender: TObject);
var
  i: Integer;
  S: string;
begin
  // ������� ��������� � �������� ������� � ��������� �����
  for i := 0 to FDQuery.FieldCount - 1 do
  begin
    if (FDQuery.Fields[i] is TStringField) and
      (not FDQuery.Fields[i].ReadOnly and not FDQuery.Fields[i].IsNull) then
    begin
      S := FDQuery.Fields[i].AsString.Trim;
      if FDQuery.Fields[i].AsString <> S then
        FDQuery.Fields[i].AsString := S;
    end;
  end;
end;

function TQueryBaseEvents.GetActual: Boolean;
begin
  Result := FDQuery.Active and not NeedRefresh;
end;

procedure TQueryBaseEvents.TryStartTransaction(Sender: TObject);
begin
  // �������� ����������, ���� ��� ��� �� ��������
  if (not AutoTransaction) and (not FDQuery.Connection.InTransaction) then
    FDQuery.Connection.StartTransaction;
end;

function TQueryBaseEvents.GetHaveAnyNotCommitedChanges: Boolean;
begin
  Result := FHaveAnyNotCommitedChanges;
end;

procedure TQueryBaseEvents.HideNullGetText(Sender: TField; var Text: string;
    DisplayText: Boolean);
begin
  if VarIsNull(Sender.Value) or (Sender.Value = 0) then
    Text := ''
  else
    Text := Sender.Value;
end;

procedure TQueryBaseEvents.InitializeFields;
var
  i: Integer;
begin
  for i := 0 to FDQuery.Fields.Count - 1 do
  begin
    // TWideMemoField - ������� OnGetText
    if FDQuery.Fields[i] is TWideMemoField then
      FDQuery.Fields[i].OnGetText := DefaultOnGetText;

    if FDQuery.Fields[i] is TFDAutoIncField then
      FDQuery.Fields[i].ProviderFlags := [pfInWhere, pfInKey];
  end;
end;

procedure TQueryBaseEvents.Load;
var
  AIDParent: Integer;
begin
  FNeedLoad := False;
  Assert(FMaster <> nil);
  AIDParent := IfThen(FMaster.FDQuery.RecordCount > 0,
    FMaster.PK.AsInteger, -1);
  Load(AIDParent);
end;

procedure TQueryBaseEvents.MasterCascadeDelete;
var
  V: Variant;
begin
  Assert(FMaster <> nil);
  Assert(FMaster.FDQuery.RecordCount > 0);
  V := FMaster.PK.Value;
  Wrap.CascadeDelete(V, DetailParameterName);
  FMaster.LocateByPK(V, True);
end;

procedure TQueryBaseEvents.RefreshQuery;
begin
  FNeedRefresh := False;
  inherited;
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

procedure TQueryBaseEvents.SetLock(const Value: Boolean);
begin
  if FLock <> Value then
  begin
    FLock := Value;

    if (not FLock) then
    begin
      // ���� ������ ���������, ��� ���� ����������
      if FNeedLoad then
      begin
        Load;
        FNeedRefresh := False; // ��������� ������ �� �����
      end
      else if FNeedRefresh then
        RefreshQuery;
    end;
  end;
end;

procedure TQueryBaseEvents.SetMaster(const Value: TQueryBaseEvents);
begin
  if FMaster <> Value then
  begin
    // ������������ �� ���� ������� ������� �������
    FMasterEventList.Clear;

    FMaster := Value;

    if FMaster <> nil then
    begin
      // ������������� �� ������� ������ �������
      TNotifyEventWrap.Create(FMaster.Wrap.AfterScrollM, DoAfterMasterScroll,
        FMasterEventList);
    end;

  end;
end;

procedure TQueryBaseEvents.TryLoad;
begin
  // ����� �����������, �.�. �� ��������� �������
  if not Lock then
    Load
  else
    FNeedLoad := True;
end;

procedure TQueryBaseEvents.TryPost;
begin
  // ���� ������������� � �� �������
  if Lock and (not FDQuery.Active) then
    Exit;

  inherited;
end;

procedure TQueryBaseEvents.TryRefresh;
begin
  // ����� �����������, �.�. �� ��������� �������
  if not Lock then
    RefreshQuery
  else
    FNeedRefresh := True;
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
