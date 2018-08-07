unit BaseEventsQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  NotifyEvents, System.Contnrs, System.Generics.Collections;

const
  WM_DS_BEFORE_SCROLL = WM_USER + 555;
  WM_DS_AFTER_SCROLL = WM_USER + 556;
  WM_DS_AFTER_POST = WM_USER + 557;

type
  TQueryMonitor = class;

  TQueryBaseEvents = class(TQueryBase)
    procedure FDQueryAfterCancel(DataSet: TDataSet);
    procedure FDQueryAfterClose(DataSet: TDataSet);
    procedure FDQueryAfterDelete(DataSet: TDataSet);
    procedure FDQueryAfterEdit(DataSet: TDataSet);
    procedure FDQueryAfterInsert(DataSet: TDataSet);
    procedure FDQueryAfterOpen(DataSet: TDataSet);
    procedure FDQueryAfterPost(DataSet: TDataSet);
    procedure FDQueryAfterScroll(DataSet: TDataSet);
    procedure FDQueryBeforeClose(DataSet: TDataSet);
    procedure FDQueryBeforeDelete(DataSet: TDataSet);
    procedure FDQueryBeforeEdit(DataSet: TDataSet);
    procedure FDQueryBeforeInsert(DataSet: TDataSet);
    procedure FDQueryBeforeOpen(DataSet: TDataSet);
    procedure FDQueryBeforePost(DataSet: TDataSet);
    procedure FDQueryBeforeScroll(DataSet: TDataSet);
  private
    FAfterClose: TNotifyEventsEx;
    FBeforeClose: TNotifyEventsEx;
    FAfterDelete: TNotifyEventsEx;
    FAfterEdit: TNotifyEventsEx;
    FAfterInsert: TNotifyEventsEx;
    FAfterOpen: TNotifyEventsEx;
    FAfterPost: TNotifyEventsEx;
    FAfterScroll: TNotifyEventsEx;
    FAutoTransaction: Boolean;
    FBeforeDelete: TNotifyEventsEx;
    FBeforeEdit: TNotifyEventsEx;
    FBeforeInsert: TNotifyEventsEx;
    FBeforeOpen: TNotifyEventsEx;
    FBeforePost: TNotifyEventsEx;
    FBeforeScroll: TNotifyEventsEx;
    FAfterCommit: TNotifyEventsEx;
    FAfterCancel: TNotifyEventsEx;
    FAfterCancelUpdates: TNotifyEventsEx;
    FAfterPostI: TNotifyEventsEx;
    FBeforeScrollI: TNotifyEventsEx;
    FCloneEvents: TObjectList;
    FClones: TObjectList<TFDMemTable>;
    FHaveAnyNotCommitedChanges: Boolean;
    FOldPKValue: Variant;
    FOldState: TDataSetState;
    FResiveAfterPostMessage: Boolean;
    FResiveAfterScrollMessage: Boolean;
    FResiveBeforeScrollMessage: Boolean;
    FUseAfterPostMessage: Boolean;
    class var FMonitor: TQueryMonitor;
    procedure CloneCursor(AClone: TFDMemTable);
    procedure DoAfterClose(Sender: TObject);
    procedure DoAfterOpen(Sender: TObject);
    procedure TryStartTransaction(Sender: TObject);
    procedure SetAutoTransaction(const Value: Boolean);
    { Private declarations }
  protected
    FAutoTransactionEventList: TObjectList;
    FMasterEventList: TObjectList;
    procedure DoAfterCommit(Sender: TObject);
    procedure DoAfterRollback(Sender: TObject);
    function GetHaveAnyNotCommitedChanges: Boolean; override;
    procedure ProcessAfterPostMessage(var Message: TMessage);
      message WM_DS_AFTER_POST;
    procedure ProcessAfterScrollMessage(var Message: TMessage);
      message WM_DS_AFTER_SCROLL;
    procedure ProcessBeforeScrollMessage(var Message: TMessage);
      message WM_DS_BEFORE_SCROLL;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function AddClone(const AFilter: String): TFDMemTable;
    procedure CancelUpdates; override;
    procedure DropClone(AClone: TFDMemTable);
    procedure SmartRefresh; virtual;
    property AfterClose: TNotifyEventsEx read FAfterClose;
    property BeforeClose: TNotifyEventsEx read FBeforeClose;
    property AfterDelete: TNotifyEventsEx read FAfterDelete;
    property AfterEdit: TNotifyEventsEx read FAfterEdit;
    property AfterInsert: TNotifyEventsEx read FAfterInsert;
    property AfterOpen: TNotifyEventsEx read FAfterOpen;
    property AfterPost: TNotifyEventsEx read FAfterPost;
    property AfterScroll: TNotifyEventsEx read FAfterScroll;
    property AutoTransaction: Boolean read FAutoTransaction
      write SetAutoTransaction;
    property BeforeDelete: TNotifyEventsEx read FBeforeDelete;
    property BeforeEdit: TNotifyEventsEx read FBeforeEdit;
    property BeforeInsert: TNotifyEventsEx read FBeforeInsert;
    property BeforeOpen: TNotifyEventsEx read FBeforeOpen;
    property BeforePost: TNotifyEventsEx read FBeforePost;
    property BeforeScroll: TNotifyEventsEx read FBeforeScroll;
    property AfterCommit: TNotifyEventsEx read FAfterCommit;
    property AfterCancel: TNotifyEventsEx read FAfterCancel;
    property AfterCancelUpdates: TNotifyEventsEx read FAfterCancelUpdates;
    property AfterPostI: TNotifyEventsEx read FAfterPostI;
    property BeforeScrollI: TNotifyEventsEx read FBeforeScrollI;
    property HaveAnyNotCommitedChanges: Boolean read FHaveAnyNotCommitedChanges;
    property OldPKValue: Variant read FOldPKValue;
    property OldState: TDataSetState read FOldState;
    class property Monitor: TQueryMonitor read FMonitor;
    property UseAfterPostMessage: Boolean read FUseAfterPostMessage
      write FUseAfterPostMessage;
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

  FOldState := dsInactive;

  // ������ �������
  FBeforeScroll := TNotifyEventsEx.Create(Self);
  FBeforeScrollI := TNotifyEventsEx.Create(Self);
  FAfterScroll := TNotifyEventsEx.Create(Self);

  FBeforeInsert := TNotifyEventsEx.Create(Self);
  FAfterInsert := TNotifyEventsEx.Create(Self);

  FBeforeDelete := TNotifyEventsEx.Create(Self);
  FAfterDelete := TNotifyEventsEx.Create(Self);

  FBeforeOpen := TNotifyEventsEx.Create(Self);
  FAfterOpen := TNotifyEventsEx.Create(Self);

  FBeforeClose := TNotifyEventsEx.Create(Self);
  FAfterClose := TNotifyEventsEx.Create(Self);

  FBeforePost := TNotifyEventsEx.Create(Self);
  FAfterPost := TNotifyEventsEx.Create(Self);
  FAfterPostI := TNotifyEventsEx.Create(Self);

  FBeforeEdit := TNotifyEventsEx.Create(Self);
  FAfterEdit := TNotifyEventsEx.Create(Self);

  FAfterCancel := TNotifyEventsEx.Create(Self);

  FAfterCommit := TNotifyEventsEx.Create(Self);

  FAfterCancelUpdates := TNotifyEventsEx.Create(Self);

  FResiveAfterScrollMessage := True;
  FResiveBeforeScrollMessage := True;
  FResiveAfterPostMessage := True;

  FUseAfterPostMessage := True;

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
var
  I: Integer;
begin
  // ������ ��� �����
  if FClones <> nil then
  begin
    for I := FClones.Count - 1 downto 0 do
      DropClone(FClones[i]);
  end;
  Assert(FClones = nil);

  FreeAndNil(FBeforeScroll);
  FreeAndNil(FBeforeScrollI);
  FreeAndNil(FAfterScroll);

  FreeAndNil(FBeforeInsert);
  FreeAndNil(FAfterInsert);

  FreeAndNil(FBeforeDelete);
  FreeAndNil(FAfterDelete);

  FreeAndNil(FBeforeOpen);
  FreeAndNil(FAfterOpen);

  FreeAndNil(FBeforeClose);
  FreeAndNil(FAfterClose);

  FreeAndNil(FBeforePost);
  FreeAndNil(FAfterPost);
  FreeAndNil(FAfterPostI);

  FreeAndNil(FBeforeEdit);
  FreeAndNil(FAfterEdit);

  FreeAndNil(FAfterCancel);

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

function TQueryBaseEvents.AddClone(const AFilter: String): TFDMemTable;
begin
  // ������ ������ ������
  if FClones = nil then
  begin
    FClones := TObjectList<TFDMemTable>.Create;

    // ������ �����������
    FCloneEvents := TObjectList.Create;

    // ����� ����������� �������
    TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, FCloneEvents);
    // ����� ��������� �������
    TNotifyEventWrap.Create(AfterClose, DoAfterClose, FCloneEvents);
  end;

  Result := TFDMemTable.Create(nil); // ���������� ����� ������
  Result.Filter := AFilter;

  // ���������
  if FDQuery.Active then
    CloneCursor(Result);

  FClones.Add(Result); // ���������� ����� ������
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

procedure TQueryBaseEvents.CloneCursor(AClone: TFDMemTable);
var
  AFilter: String;
begin
  // Assert(not AClone.Filter.IsEmpty);
  AFilter := AClone.Filter;
  AClone.CloneCursor(FDQuery);

  // ���� ������ ����������� �� ����
  if (AFilter.IsEmpty) then
    Exit;

  AClone.Filter := AFilter;
  AClone.Filtered := True;
end;

procedure TQueryBaseEvents.DoAfterClose(Sender: TObject);
var
  AClone: TFDMemTable;
begin
  // ��������� �����
  for AClone in FClones do
    AClone.Close;
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

procedure TQueryBaseEvents.DoAfterOpen(Sender: TObject);
var
  AClone: TFDMemTable;
begin
  // ��������� �������
  for AClone in FClones do
  begin
    CloneCursor(AClone);
  end;
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

procedure TQueryBaseEvents.DropClone(AClone: TFDMemTable);
begin
  Assert(AClone <> nil);
  Assert(FClones <> nil);

  FClones.Remove(AClone);

  if FClones.Count = 0 then
  begin
    // ������������
    FreeAndNil(FCloneEvents);
    // ��������� ������
    FreeAndNil(FClones);
  end;

end;

procedure TQueryBaseEvents.FDQueryAfterCancel(DataSet: TDataSet);
begin
  inherited;
  FAfterCancel.CallEventHandlers(Self);
end;

procedure TQueryBaseEvents.FDQueryAfterClose(DataSet: TDataSet);
begin
  inherited;
  FAfterClose.CallEventHandlers(Self);
end;

procedure TQueryBaseEvents.FDQueryAfterDelete(DataSet: TDataSet);
begin
  inherited;
  // ���� ���������� ��� �� �����������
  if FDQuery.Connection.InTransaction then
    FHaveAnyNotCommitedChanges := True;

  FAfterDelete.CallEventHandlers(Self);
end;

procedure TQueryBaseEvents.FDQueryAfterEdit(DataSet: TDataSet);
begin
  inherited;
  FAfterEdit.CallEventHandlers(Self);
end;

procedure TQueryBaseEvents.FDQueryAfterInsert(DataSet: TDataSet);
begin
  inherited;
  FAfterInsert.CallEventHandlers(Self);
end;

procedure TQueryBaseEvents.FDQueryAfterOpen(DataSet: TDataSet);
begin
  inherited;
  FAfterOpen.CallEventHandlers(Self);
end;

procedure TQueryBaseEvents.FDQueryAfterPost(DataSet: TDataSet);
begin
  inherited;

  // ���� ���������� ��� �� �����������
  if FDQuery.Connection.InTransaction then
    FHaveAnyNotCommitedChanges := True;

  // ���� ���������� ��������� � ���� ����������
  if (FAfterPost.Count > 0) and UseAfterPostMessage then
  begin
    // ���� ���������� ��������� ���� ��������
    if FResiveAfterPostMessage then
    begin
      FResiveAfterPostMessage := False;
      // ���������� ����� ���������
      PostMessage(Handle, WM_DS_AFTER_POST, 0, 0);
    end;
  end
  else
    FAfterPost.CallEventHandlers(Self);

  // �������� ���, ��� ����� �������� ��������� ����������
  FAfterPostI.CallEventHandlers(Self);
end;

procedure TQueryBaseEvents.FDQueryAfterScroll(DataSet: TDataSet);
begin
  inherited;
  // ���� ���������� ��������� � ������ ��� ��������
  if FResiveAfterScrollMessage then
  begin
    FResiveAfterScrollMessage := False;
    // ���������� ����� ���������
    PostMessage(Handle, WM_DS_AFTER_SCROLL, 0, 0);
  end;
end;

procedure TQueryBaseEvents.FDQueryBeforeClose(DataSet: TDataSet);
begin
  inherited;
  FBeforeClose.CallEventHandlers(Self);
end;

procedure TQueryBaseEvents.FDQueryBeforeDelete(DataSet: TDataSet);
begin
  inherited;
  // ���������� ��������� �������� ���������� �����
  FOldPKValue := PK.Value;

  FBeforeDelete.CallEventHandlers(Self);
end;

procedure TQueryBaseEvents.FDQueryBeforeEdit(DataSet: TDataSet);
begin
  inherited;
  FBeforeEdit.CallEventHandlers(Self);
end;

procedure TQueryBaseEvents.FDQueryBeforeInsert(DataSet: TDataSet);
begin
  inherited;
  FBeforeInsert.CallEventHandlers(Self);
end;

procedure TQueryBaseEvents.FDQueryBeforeOpen(DataSet: TDataSet);
begin
  inherited;
  FBeforeOpen.CallEventHandlers(Self);
end;

procedure TQueryBaseEvents.FDQueryBeforePost(DataSet: TDataSet);
begin
  inherited;
  FOldState := FDQuery.State;
  FBeforePost.CallEventHandlers(Self);
end;

procedure TQueryBaseEvents.FDQueryBeforeScroll(DataSet: TDataSet);
begin
  inherited;
  FBeforeScrollI.CallEventHandlers(Self);

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

procedure TQueryBaseEvents.ProcessAfterPostMessage(var Message: TMessage);
begin
  FAfterPost.CallEventHandlers(Self);
  FResiveAfterPostMessage := True;
end;

procedure TQueryBaseEvents.ProcessAfterScrollMessage(var Message: TMessage);
begin
  FAfterScroll.CallEventHandlers(Self);
  FResiveAfterScrollMessage := True;
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

      TNotifyEventWrap.Create(BeforeInsert, TryStartTransaction,
        FAutoTransactionEventList);
      TNotifyEventWrap.Create(BeforeDelete, TryStartTransaction,
        FAutoTransactionEventList);
      TNotifyEventWrap.Create(BeforeEdit, TryStartTransaction,
        FAutoTransactionEventList);
    end
    else
    begin
      FAutoTransactionEventList.Clear;
    end;

  end;
end;

procedure TQueryBaseEvents.SmartRefresh;
var
  OK: Boolean;
begin
  // ���������� ������, ��� ������� �� ��������� ������� AfterScroll
  FDQuery.DisableControls;
  try
    SaveBookmark;

    // ��� ����� ���������� ��������� AfterScroll ��� �� ��������
    FResiveAfterScrollMessage := False;

    // ������ ��������� ������
    RefreshQuery;

    OK := RestoreBookmark;

    // ���� ������ ������ �� ����������
    if not OK then
    begin
      // ��� ����� ���������� ��������� AfterScroll ��� ��� ��������
      FResiveAfterScrollMessage := True;

      // ������������ �������� ������� AfterScroll
      FDQueryAfterScroll(FDQuery);
    end;

  finally
    // ��� ���������� ���������� DevExpress ������ �������� ������ � ����� ������ Scroll
    FDQuery.EnableControls;
  end;

  if OK then
    // ��� ����� ���������� ��������� AfterScroll ��� ��� ��������
    FResiveAfterScrollMessage := True;

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

  TNotifyEventWrap.Create(AQuery.AfterEdit, DoAfterEditOrInsert, FEventList);
  TNotifyEventWrap.Create(AQuery.AfterInsert, DoAfterEditOrInsert, FEventList);
  TNotifyEventWrap.Create(AQuery.AfterDelete, DoAfterDelete, FEventList);
  TNotifyEventWrap.Create(AQuery.AfterCancel, DoAfterCancelOrPost, FEventList);
  TNotifyEventWrap.Create(AQuery.AfterPostI, DoAfterCancelOrPost, FEventList);
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

  // ���� ��� �������������� ���������
  if not Q.HaveAnyChanges then
  begin
    i := FChangedQueries.IndexOf(Q);
    if i >= 0 then
      FChangedQueries.Delete(i);
  end
  else
    FChangedQueries.Add(Q);
  // ����������, ��� ����� ���� �� ����������� ���������
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
  // ���� ����� ������� ��� ��� � ������ ����������
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

  // ���� ��� ������������� ���������
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

  // ���� ���� ������������� ����������
  if Queries[0].FDQuery.Connection.InTransaction then
    Queries[0].FDQuery.Connection.Commit;
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

  // ���� ���� ������������� ����������
  if Queries[0].FDQuery.Connection.InTransaction then
    Queries[0].FDQuery.Connection.Rollback; // �������� ����������
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

function TQueryMonitor.GetIsEmpty: Boolean;
begin
  Result := FQueries.Count = 0;
end;

procedure TQueryMonitor.Remove(AQuery: TQueryBaseEvents);
var
  i: Integer;
begin
  Assert(AQuery <> nil);

  // �� �� ������ ��������� ������, ������� ����� ������������� ������
  i := FChangedQueries.IndexOf(AQuery);

  if i >= 0 then
    beep;


  Assert(i = -1);

  i := FQueries.IndexOf(AQuery);
  Assert(i >= 0);

  FQueries.Delete(i);
end;

end.
