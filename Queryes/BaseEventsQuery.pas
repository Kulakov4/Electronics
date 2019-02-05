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
  WM_DS_AFTER_SCROLL = WM_USER + 556;
  WM_DS_AFTER_POST = WM_USER + 557;

type
  TQueryMonitor = class;

  TQueryBaseEvents = class(TQueryBase)
    procedure FDQueryAfterCancel(DataSet: TDataSet);
    procedure FDQueryAfterDelete(DataSet: TDataSet);
    procedure FDQueryAfterEdit(DataSet: TDataSet);
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
    FBeforeClose: TNotifyEventsEx;
    FAfterDelete: TNotifyEventsEx;
    FAfterEdit: TNotifyEventsEx;
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
//    FCloneEvents: TObjectList;
    FHaveAnyNotCommitedChanges: Boolean;
    FOldPKValue: Variant;
    FOldState: TDataSetState;
    FResiveAfterPostMessage: Boolean;
    FResiveAfterScrollMessage: Boolean;
    FResiveBeforeScrollMessage: Boolean;
    FUseAfterPostMessage: Boolean;
    class var FMonitor: TQueryMonitor;
// TODO: CloneCursor
//  procedure CloneCursor(AClone: TFDMemTable);
// TODO: DoAfterClose
//  procedure DoAfterClose(Sender: TObject);
// TODO: DoAfterOpen
//  procedure DoAfterOpen(Sender: TObject);
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
    procedure ProcessAfterPostMessage(var Message: TMessage);
      message WM_DS_AFTER_POST;
    procedure ProcessAfterScrollMessage(var Message: TMessage);
      message WM_DS_AFTER_SCROLL;
    procedure ProcessBeforeScrollMessage(var Message: TMessage);
      message WM_DS_BEFORE_SCROLL;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
// TODO: AddClone
//  function AddClone(const AFilter: String): TFDMemTable;
    procedure CancelUpdates; override;
// TODO: DropClone
//  procedure DropClone(AClone: TFDMemTable);
    procedure SmartRefresh; virtual;
    property BeforeClose: TNotifyEventsEx read FBeforeClose;
    property AfterDelete: TNotifyEventsEx read FAfterDelete;
    property AfterEdit: TNotifyEventsEx read FAfterEdit;
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

  // Создаём обёртку вокруг себя
  FDSWrap := CreateDSWrap;

  FOldState := dsInactive;

  // Создаём события
  FBeforeScroll := TNotifyEventsEx.Create(Self);
  FBeforeScrollI := TNotifyEventsEx.Create(Self);
  FAfterScroll := TNotifyEventsEx.Create(Self);

  FBeforeInsert := TNotifyEventsEx.Create(Self);

  FBeforeDelete := TNotifyEventsEx.Create(Self);
  FAfterDelete := TNotifyEventsEx.Create(Self);

  FBeforeOpen := TNotifyEventsEx.Create(Self);
  FAfterOpen := TNotifyEventsEx.Create(Self);

  FBeforeClose := TNotifyEventsEx.Create(Self);

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

  // По умолчанию транзакции сами начинаются и заканчиваются
  FAutoTransaction := True;

  // Создаём список своих подписчиков на события
  FAutoTransactionEventList := TObjectList.Create;
  FMasterEventList := TObjectList.Create;

  if FMonitor = nil then
    FMonitor := TQueryMonitor.Create;

  // Добавляем себя в список всех запросов
  FMonitor.Add(Self);

end;

destructor TQueryBaseEvents.Destroy;
begin

  FreeAndNil(FBeforeScroll);
  FreeAndNil(FBeforeScrollI);
  FreeAndNil(FAfterScroll);

  FreeAndNil(FBeforeInsert);

  FreeAndNil(FBeforeDelete);
  FreeAndNil(FAfterDelete);

  FreeAndNil(FBeforeOpen);
  FreeAndNil(FAfterOpen);

  FreeAndNil(FBeforeClose);

  FreeAndNil(FBeforePost);
  FreeAndNil(FAfterPost);
  FreeAndNil(FAfterPostI);

  FreeAndNil(FBeforeEdit);
  FreeAndNil(FAfterEdit);

  FreeAndNil(FAfterCancel);

  FreeAndNil(FAfterCommit);

  FreeAndNil(FAfterCancelUpdates);

  Assert(FMonitor <> nil);
  // Удаляем себя из списка всех запросов
  FMonitor.Remove(Self);

  // Если монитор больше не нужен
  if FMonitor.IsEmpty then
    FreeAndNil(FMonitor);

  FreeAndNil(FMasterEventList); // отписываемся от всех событий Мастера
  FreeAndNil(FAutoTransactionEventList);
  inherited;
end;

// TODO: AddClone
//function TQueryBaseEvents.AddClone(const AFilter: String): TFDMemTable;
//begin
//// Создаём список клонов
//if FClones = nil then
//begin
//  FClones := TObjectList<TFDMemTable>.Create;
//
//  // Список подписчиков
//  FCloneEvents := TObjectList.Create;
//
//  // Будем клонировать курсоры
//  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, FCloneEvents);
//  // Будем закрывать курсоры
//  TNotifyEventWrap.Create(AfterClose, DoAfterClose, FCloneEvents);
//end;
//
//Result := TFDMemTable.Create(nil); // Владельцем будет список
//Result.Filter := AFilter;
//
//// Клонируем
//if FDQuery.Active then
//  CloneCursor(Result);
//
//FClones.Add(Result); // Владельцем будет список
//end;

procedure TQueryBaseEvents.CancelUpdates;
begin
  inherited;
  // Дополнительно сообщаем о том, что изменения отменены
  if FDQuery.CachedUpdates then
  begin
    FAfterCancelUpdates.CallEventHandlers(Self);
  end;
end;

// TODO: CloneCursor
//procedure TQueryBaseEvents.CloneCursor(AClone: TFDMemTable);
//var
//AFilter: String;
//begin
//// Assert(not AClone.Filter.IsEmpty);
//AFilter := AClone.Filter;
//AClone.CloneCursor(FDQuery);
//
//// Если фильтр накладывать не надо
//if (AFilter.IsEmpty) then
//  Exit;
//
//AClone.Filter := AFilter;
//AClone.Filtered := True;
//end;

// TODO: DoAfterClose
//procedure TQueryBaseEvents.DoAfterClose(Sender: TObject);
//var
//AClone: TFDMemTable;
//begin
//// Закрываем клоны
//for AClone in FClones do
//  AClone.Close;
//end;

procedure TQueryBaseEvents.DoAfterCommit(Sender: TObject);
begin
  if FHaveAnyNotCommitedChanges then
  begin
    // Помечаем что у нас нет не закоммитенных изменений
    FHaveAnyNotCommitedChanges := False;
    // Извещаем всех что наши изменения закоммичены
    FAfterCommit.CallEventHandlers(Self);
  end;
end;

// TODO: DoAfterOpen
//procedure TQueryBaseEvents.DoAfterOpen(Sender: TObject);
//var
//AClone: TFDMemTable;
//begin
//// клонируем курсоры
//for AClone in FClones do
//begin
//  CloneCursor(AClone);
//end;
//end;

procedure TQueryBaseEvents.DoAfterRollback(Sender: TObject);
begin
  // Помечаем что у нас нет не закоммитенных изменений
  FHaveAnyNotCommitedChanges := False;
end;

procedure TQueryBaseEvents.TryStartTransaction(Sender: TObject);
begin
  // начинаем транзакцию, если она ещё не началась
  if (not AutoTransaction) and (not FDQuery.Connection.InTransaction) then
    FDQuery.Connection.StartTransaction;
end;

// TODO: DropClone
//procedure TQueryBaseEvents.DropClone(AClone: TFDMemTable);
//begin
//Assert(AClone <> nil);
//Assert(FClones <> nil);
//
//FClones.Remove(AClone);
//
//if FClones.Count = 0 then
//begin
//  // Отписываемся
//  FreeAndNil(FCloneEvents);
//  // Разрушаем список
//  FreeAndNil(FClones);
//end;
//
//end;

procedure TQueryBaseEvents.FDQueryAfterCancel(DataSet: TDataSet);
begin
  inherited;
  FAfterCancel.CallEventHandlers(Self);
end;

procedure TQueryBaseEvents.FDQueryAfterDelete(DataSet: TDataSet);
begin
  inherited;
  // Если транзакция ещё не завершилась
  if FDQuery.Connection.InTransaction then
    FHaveAnyNotCommitedChanges := True;

  FAfterDelete.CallEventHandlers(Self);
end;

procedure TQueryBaseEvents.FDQueryAfterEdit(DataSet: TDataSet);
begin
  inherited;
  FAfterEdit.CallEventHandlers(Self);
end;

procedure TQueryBaseEvents.FDQueryAfterOpen(DataSet: TDataSet);
begin
  inherited;
  FAfterOpen.CallEventHandlers(Self);
end;

procedure TQueryBaseEvents.FDQueryAfterPost(DataSet: TDataSet);
begin
  inherited;

  // Если транзакция ещё не завершилась
  if FDQuery.Connection.InTransaction then
    FHaveAnyNotCommitedChanges := True;

  // Если используем сообщение и есть подписчики
  if (FAfterPost.Count > 0) and UseAfterPostMessage then
  begin
    // Если предыдущее сообщение было получено
    if FResiveAfterPostMessage then
    begin
      FResiveAfterPostMessage := False;
      // Отправляем новое сообщение
      PostMessage(Handle, WM_DS_AFTER_POST, 0, 0);
    end;
  end
  else
    FAfterPost.CallEventHandlers(Self);

  // Извещаем тех, кто кочет получить сообщение немедленно
  FAfterPostI.CallEventHandlers(Self);
end;

procedure TQueryBaseEvents.FDQueryAfterScroll(DataSet: TDataSet);
begin
  inherited;
  // Если предыдущее сообщение о скроле уже получили
  if FResiveAfterScrollMessage then
  begin
    FResiveAfterScrollMessage := False;
    // Отправляем новое сообщение
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
  // Запоминаем удаляемое значение первичного ключа
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

  // Если предыдущее сообщение о скроле уже получили
  if FResiveBeforeScrollMessage then
  begin
    FResiveBeforeScrollMessage := False;
    // Отправляем новое сообщение
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

    // Если не включён режим автотранзакций
    if not FAutoTransaction then
    begin
      // Обработка не-автоматической транзакции
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
  // Обновление данных, при котором не возникает события AfterScroll
  FDQuery.DisableControls;
  try
    SaveBookmark;

    // Как будто предыдущее сообщение AfterScroll ещё не получили
    FResiveAfterScrollMessage := False;

    // Заново выполняем запрос
    RefreshQuery;

    OK := RestoreBookmark;

    // Если старой записи не существует
    if not OK then
    begin
      // Как будто предыдущее сообщение AfterScroll ещё уже получили
      FResiveAfterScrollMessage := True;

      // Искусственно вызываем событие AfterScroll
      FDQueryAfterScroll(FDQuery);
    end;

  finally
    // Тут визуальные компоненты DevExpress начнут загрузку данных и будут делать Scroll
    FDQuery.EnableControls;
  end;

  if OK then
    // Как будто предыдущее сообщение AfterScroll ещё уже получили
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
  TNotifyEventWrap.Create(AQuery.FDSWrap.AfterInsert, DoAfterEditOrInsert, FEventList);
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

  // Если нет несохранённных изменений
  if not Q.HaveAnyChanges then
  begin
    i := FChangedQueries.IndexOf(Q);
    if i >= 0 then
      FChangedQueries.Delete(i);
  end
  else
    FChangedQueries.Add(Q);
  // Запоминаем, что здесь есть не сохранённые изменения
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
  // Если этого запроса ещё нет в списке изменённых
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

  // Если изменения в этом запросе не требуют сохранения
  if i < 0 then
    Exit;

  // Если нет несохранённых изменений
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
      // Просим группу сохранить свои изменения
      AQueryGroup.ApplyUpdates;
      Inc(k);
    end
    else
    begin
      // Если запрос сам по себе
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
      // Просим группу Отменить свои изменения
      AQueryGroup.CancelUpdates;
      Inc(k);
    end
    else
    begin
      // Если запрос сам по себе
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
  if FQueries.Count = 0 then Exit;

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

  // Мы не должны разрушать запрос, который имеет несохранённые данные
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
  // Если есть незавершённая транзакция
  if Connection.InTransaction then
    Connection.Commit;
end;

procedure TQueryMonitor.TryRollback;
begin
  // Если есть незавершённая транзакция
  if Connection.InTransaction then
    Connection.Rollback; // Отменяем транзакцию
end;

end.
