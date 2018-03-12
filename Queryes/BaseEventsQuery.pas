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
    property UseAfterPostMessage: Boolean read FUseAfterPostMessage
      write FUseAfterPostMessage;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses RepositoryDataModule;

{ TfrmDataModule }

constructor TQueryBaseEvents.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FOldState := dsInactive;

  // Создаём события
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

  // По умолчанию транзакции сами начинаются и заканчиваются
  FAutoTransaction := True;

  // Создаём список своих подписчиков на события
  FAutoTransactionEventList := TObjectList.Create;
  FMasterEventList := TObjectList.Create;
end;

destructor TQueryBaseEvents.Destroy;
begin
  FreeAndNil(FMasterEventList); // отписываемся от всех событий Мастера
  FreeAndNil(FAutoTransactionEventList);
  inherited;
end;

function TQueryBaseEvents.AddClone(const AFilter: String): TFDMemTable;
begin
  // Создаём список клонов
  if FClones = nil then
  begin
    FClones := TObjectList<TFDMemTable>.Create;

    // Список подписчиков
    FCloneEvents := TObjectList.Create;

    // Будем клонировать курсоры
    TNotifyEventWrap.Create( AfterOpen, DoAfterOpen, FCloneEvents );
    // Будем закрывать курсоры
    TNotifyEventWrap.Create( AfterClose, DoAfterClose, FCloneEvents );
  end;

  Result := TFDMemTable.Create(Self);
  Result.Filter := AFilter;

  // Клонируем
  if FDQuery.Active then
    CloneCursor(Result);

  FClones.Add(Result);
end;

procedure TQueryBaseEvents.CloneCursor(AClone: TFDMemTable);
var
  AFilter: String;
begin
  //Assert(not AClone.Filter.IsEmpty);
  AFilter := AClone.Filter;
  AClone.CloneCursor( FDQuery );

  // Если фильтр накладывать не надо
  if (AFilter.IsEmpty) then
    Exit;

  AClone.Filter := AFilter;
  AClone.Filtered := True;
end;

procedure TQueryBaseEvents.DoAfterClose(Sender: TObject);
var
  AClone: TFDMemTable;
begin
  // Закрываем клоны
  for AClone in FClones do
    AClone.Close;
end;

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

procedure TQueryBaseEvents.DoAfterOpen(Sender: TObject);
var
  AClone: TFDMemTable;
begin
  // клонируем курсоры
  for AClone in FClones do
  begin
    CloneCursor( AClone );
  end;
end;

procedure TQueryBaseEvents.DoAfterRollback(Sender: TObject);
begin
  // Помечаем что у нас нет не закоммитенных изменений
  FHaveAnyNotCommitedChanges := False;
end;

procedure TQueryBaseEvents.DoOnStartTransaction(Sender: TObject);
begin
  // начинаем транзакцию, если она ещё не началась
  if (not AutoTransaction) and (not FDQuery.Connection.InTransaction) then
    FDQuery.Connection.StartTransaction;
end;

procedure TQueryBaseEvents.DropClone(AClone: TFDMemTable);
begin
  Assert(AClone <> nil);
  Assert(FClones <> nil);

  FClones.Remove( AClone );

  if FClones.Count = 0 then
  begin
    // Отписываемся
    FreeAndNil(FCloneEvents);
    // Разрушаем список
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
  // Если транзакция ещё не завершилась
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

  // Если транзакция ещё не завершилась
  if FDQuery.Connection.InTransaction then
    FHaveAnyNotCommitedChanges := True;

  // Если используем сообщение
  if UseAfterPostMessage then
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
    FAfterPost.CallEventHandlers(FDQuery);

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
  FBeforeClose.CallEventHandlers(FDQuery);
end;

procedure TQueryBaseEvents.FDQueryBeforeDelete(DataSet: TDataSet);
begin
  inherited;
  // Запоминаем удаляемое значение первичного ключа
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

    // Если не включён режим автотранзакций
    if not FAutoTransaction then
    begin
      // Обработка не-автоматической транзакции
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

end.
