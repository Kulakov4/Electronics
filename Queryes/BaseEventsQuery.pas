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
    procedure DoOnStartTransaction(Sender: TObject);
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
    FHaveAnyChange: Boolean;
    FQueries: TList<TQueryBaseEvents>;
  protected
    procedure DoAfterCommit(Sender: TObject);
    procedure DoAfterDelete(Sender: TObject);
    procedure DoAfterEdit(Sender: TObject);
    procedure DoAfterPost(Sender: TObject);
    procedure DoAfterRollback(Sender: TObject);
    property Queries: TList<TQueryBaseEvents> read FQueries;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(AQuery: TQueryBaseEvents);
    property HaveAnyChange: Boolean read FHaveAnyChange;
  end;

implementation

{$R *.dfm}

uses RepositoryDataModule;

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

  FBeforeEdit := TNotifyEventsEx.Create(Self);
  FAfterEdit := TNotifyEventsEx.Create(Self);

  FAfterCommit := TNotifyEventsEx.Create(Self);

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
begin
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

  Result := TFDMemTable.Create(Self);
  Result.Filter := AFilter;

  // ���������
  if FDQuery.Active then
    CloneCursor(Result);

  FClones.Add(Result);
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

procedure TQueryBaseEvents.DoOnStartTransaction(Sender: TObject);
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

  FAfterDelete.CallEventHandlers(FDQuery);
end;

procedure TQueryBaseEvents.FDQueryAfterEdit(DataSet: TDataSet);
begin
  inherited;
  FAfterEdit.CallEventHandlers(Self);
end;

procedure TQueryBaseEvents.FDQueryAfterInsert(DataSet: TDataSet);
begin
  inherited;
  FAfterInsert.CallEventHandlers(FDQuery);
end;

procedure TQueryBaseEvents.FDQueryAfterOpen(DataSet: TDataSet);
begin
  inherited;
  FAfterOpen.CallEventHandlers(FDQuery);
end;

procedure TQueryBaseEvents.FDQueryAfterPost(DataSet: TDataSet);
begin
  inherited;

  // ���� ���������� ��� �� �����������
  if FDQuery.Connection.InTransaction then
    FHaveAnyNotCommitedChanges := True;

  // ���� ���������� ���������
  if UseAfterPostMessage then
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
    FAfterPost.CallEventHandlers(FDQuery);

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
  FBeforeClose.CallEventHandlers(FDQuery);
end;

procedure TQueryBaseEvents.FDQueryBeforeDelete(DataSet: TDataSet);
begin
  inherited;
  // ���������� ��������� �������� ���������� �����
  FOldPKValue := PK.Value;

  FBeforeDelete.CallEventHandlers(FDQuery);
end;

procedure TQueryBaseEvents.FDQueryBeforeEdit(DataSet: TDataSet);
begin
  inherited;
  FBeforeEdit.CallEventHandlers(Self);
end;

procedure TQueryBaseEvents.FDQueryBeforeInsert(DataSet: TDataSet);
begin
  inherited;
  FBeforeInsert.CallEventHandlers(FDQuery);
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
  FBeforeScrollI.CallEventHandlers(FDQuery);

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
  FAfterPost.CallEventHandlers(FDQuery);
  FResiveAfterPostMessage := True;
end;

procedure TQueryBaseEvents.ProcessAfterScrollMessage(var Message: TMessage);
begin
  FAfterScroll.CallEventHandlers(FDQuery);
  FResiveAfterScrollMessage := True;
end;

procedure TQueryBaseEvents.ProcessBeforeScrollMessage(var Message: TMessage);
begin
  FBeforeScroll.CallEventHandlers(FDQuery);
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

      TNotifyEventWrap.Create(BeforeInsert, DoOnStartTransaction,
        FAutoTransactionEventList);
      TNotifyEventWrap.Create(BeforeDelete, DoOnStartTransaction,
        FAutoTransactionEventList);
      TNotifyEventWrap.Create(BeforeEdit, DoOnStartTransaction,
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
  FEventList := FEventList.Create(True);

  TNotifyEventWrap.Create(DMRepository.AfterCommit, DoAfterCommit, FEventList);

  TNotifyEventWrap.Create(DMRepository.AfterRollback, DoAfterRollback,
    FEventList);

end;

destructor TQueryMonitor.Destroy;
begin
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

  TNotifyEventWrap.Create(AQuery.AfterEdit, DoAfterEdit, FEventList);
  TNotifyEventWrap.Create(AQuery.AfterPost, DoAfterPost, FEventList);
  TNotifyEventWrap.Create(AQuery.AfterDelete, DoAfterDelete, FEventList);
end;

procedure TQueryMonitor.DoAfterCommit(Sender: TObject);
var
  I: Integer;
begin
  for I := FChangedQueries.Count - 1 downto 0 do
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

procedure TQueryMonitor.DoAfterEdit(Sender: TObject);
var
  Q: TQueryBaseEvents;
begin
  Q := Sender as TQueryBaseEvents;
  FChangedQueries.Add(Q);
end;

procedure TQueryMonitor.DoAfterPost(Sender: TObject);
var
  i: Integer;
  Q: TQueryBaseEvents;
begin
  Q := Sender as TQueryBaseEvents;

  i := FChangedQueries.IndexOf(Q);
  Assert(i >= 0);

  // ���� ��� ������������� ���������
  if not Q.HaveAnyChanges then
    FChangedQueries.Delete(i);
end;

procedure TQueryMonitor.DoAfterRollback(Sender: TObject);
begin
  // TODO -cMM: TQueryMonitor.DoAfterRollback default body inserted
end;

end.
