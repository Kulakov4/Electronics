unit BaseEventsQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, NotifyEvents, System.Contnrs,
  System.Generics.Collections, DSWrap, HRTimer;

type
  TQueryMonitor = class;

  TQueryBaseEvents = class(TQueryBase)
    procedure DefaultOnGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure HideNullGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
  private
    FAutoTransaction: Boolean;
    FAfterCommit: TNotifyEventsEx;
    FAfterCancelUpdates: TNotifyEventsEx;
    FBeforeApplyUpdates: TNotifyEventsEx;
    FAfterApplyUpdates: TNotifyEventsEx;
    FAfterCommitUpdates: TNotifyEventsEx;
    FClientCount: Integer;
    FDebug: Boolean;
    FHaveAnyNotCommitedChanges: Boolean;
    FHRTimer: THRTimer;
    FMaster: TQueryBaseEvents;
    FNeedLoad: Boolean;
    class var FMonitor: TQueryMonitor;

  const
    FDebugFileName: string = 'C:\Public\SQL.txt';
    procedure DoAfterDelete(Sender: TObject);
    procedure DoAfterMasterScroll(Sender: TObject);
    procedure DoAfterOpen(Sender: TObject);
    procedure DoAfterPost(Sender: TObject);
    procedure DoBeforeApplyUpdates(Sender: TFDDataSet);
    procedure DoAfterApplyUpdates(Sender: TFDDataSet; AError: Integer);
    procedure DoBeforeMasterScroll(Sender: TObject);
    procedure DoBeforeOpenOrRefresh(Sender: TObject);
    procedure DoBeforePost(Sender: TObject);
    function GetActual: Boolean;
    function GetBeforeApplyUpdates: TNotifyEventsEx;
    function GetAfterApplyUpdates: TNotifyEventsEx;
    function GetAfterCommitUpdates: TNotifyEventsEx;
    procedure InitializeFields;
    procedure TryStartTransaction(Sender: TObject);
    procedure SetAutoTransaction(const Value: Boolean);
    procedure SetMaster(const Value: TQueryBaseEvents);
    { Private declarations }
  protected
    FAutoTransactionEventList: TObjectList;
    FDSWrap: TDSWrap;
    FMasterEventList: TObjectList;
    class var FFile: TextFile;
    function CreateDSWrap: TDSWrap; virtual; abstract;
    procedure DoAfterCommit(Sender: TObject);
    procedure DoAfterRefresh(Sender: TObject);
    procedure DoAfterRollback(Sender: TObject);
    function GetHaveAnyNotCommitedChanges: Boolean; override;
    procedure SaveDebugLog;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddClient;
    procedure ApplyUpdates; virtual;
    procedure CancelUpdates; virtual;
    procedure LoadFromMaster; overload;
    procedure LoadFromMaster(AIDParent: Integer;
      AForcibly: Boolean = False); overload;
    procedure MasterCascadeDelete;
    procedure RemoveClient;
    procedure TryCallAfterCommitUpdatesEvent;
    procedure TryLoad(AIDParent: Integer);
    procedure TryLoad2(AIDParent: Integer);
    procedure TryRefresh;
    property Actual: Boolean read GetActual;
    property AutoTransaction: Boolean read FAutoTransaction
      write SetAutoTransaction;
    property AfterCancelUpdates: TNotifyEventsEx read FAfterCancelUpdates;
    property BeforeApplyUpdates: TNotifyEventsEx read GetBeforeApplyUpdates;
    property AfterApplyUpdates: TNotifyEventsEx read GetAfterApplyUpdates;
    property AfterCommit: TNotifyEventsEx read FAfterCommit;
    property AfterCommitUpdates: TNotifyEventsEx read GetAfterCommitUpdates;
    property ClientCount: Integer read FClientCount;
    property Debug: Boolean read FDebug write FDebug;
    property HaveAnyNotCommitedChanges: Boolean read FHaveAnyNotCommitedChanges;
    property Master: TQueryBaseEvents read FMaster write SetMaster;
    class property Monitor: TQueryMonitor read FMonitor;
    property Wrap: TDSWrap read FDSWrap;
    { Public declarations }
  end;

  TQueryMonitor = class
  private
    FBeforeApplyUpdates: TNotifyEventsEx;
    FChangedQueries: TList<TQueryBaseEvents>;
    FEventList: TObjectList;
    FOnHaveAnyChanges: TNotifyEventsEx;
    FQueries: TList<TQueryBaseEvents>;
    procedure CheckChangedQueries;
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
    property BeforeApplyUpdates: TNotifyEventsEx read FBeforeApplyUpdates;
    property Connection: TFDCustomConnection read GetConnection;
    property HaveAnyChanges: Boolean read GetHaveAnyChanges;
    property IsEmpty: Boolean read GetIsEmpty;
    property OnHaveAnyChanges: TNotifyEventsEx read FOnHaveAnyChanges;
  end;

implementation

{$R *.dfm}

uses RepositoryDataModule, QueryGroupUnit2, System.Math;

{ TfrmDataModule }

constructor TQueryBaseEvents.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  // FDebug := True;

  // Создаём обёртку вокруг себя
  FDSWrap := CreateDSWrap;
  FDSWrap.Obj := Self;

  TNotifyEventWrap.Create(FDSWrap.AfterDelete, DoAfterDelete,
    FDSWrap.EventList);

  TNotifyEventWrap.Create(FDSWrap.AfterPost, DoAfterPost, FDSWrap.EventList);

  // Будем засекать время выполнения запроса
  TNotifyEventWrap.Create(Wrap.BeforeOpen, DoBeforeOpenOrRefresh,
    Wrap.EventList);
  TNotifyEventWrap.Create(Wrap.BeforeRefresh, DoBeforeOpenOrRefresh,
    Wrap.EventList);

  TNotifyEventWrap.Create(Wrap.AfterRefresh, DoAfterRefresh, Wrap.EventList);

  // Все поля будем выравнивать по левому краю + клонировать курсор (если надо)
  TNotifyEventWrap.Create(Wrap.AfterOpen, DoAfterOpen, Wrap.EventList);

  // Во всех строковых полях будем удалять начальные и конечные пробелы
  TNotifyEventWrap.Create(Wrap.BeforePost, DoBeforePost, Wrap.EventList);

  // Создаём события
  FAfterCommit := TNotifyEventsEx.Create(Self);

  FAfterCancelUpdates := TNotifyEventsEx.Create(Self);

  // По умолчанию транзакции сами начинаются и заканчиваются
  FAutoTransaction := True;

  // Создаём список своих подписчиков на события
  FAutoTransactionEventList := TObjectList.Create;
  FMasterEventList := TObjectList.Create;

  FHRTimer := THRTimer.Create(False);

  if FMonitor = nil then
  begin
    FMonitor := TQueryMonitor.Create;
    if FDebug then
    begin
      AssignFile(FFile, FDebugFileName);
      Rewrite(FFile);
    end;
  end;

  // Добавляем себя в список всех запросов
  FMonitor.Add(Self);

end;

destructor TQueryBaseEvents.Destroy;
begin
  FreeAndNil(FHRTimer);
  FreeAndNil(FAfterCommit);

  FreeAndNil(FAfterCancelUpdates);

  Assert(FMonitor <> nil);
  // Удаляем себя из списка всех запросов
  FMonitor.Remove(Self);

  // Если монитор больше не нужен
  if FMonitor.IsEmpty then
  begin
    FreeAndNil(FMonitor);
    if Debug then
      CloseFile(FFile);
  end;

  FreeAndNil(FMasterEventList); // отписываемся от всех событий Мастера
  FreeAndNil(FAutoTransactionEventList);
  inherited;
end;

procedure TQueryBaseEvents.AddClient;
begin
  Assert(FClientCount >= 0);
  Inc(FClientCount);

  if FClientCount > 1 then
    Exit;

  // если мастер изменился, нам пора обновиться
  if FNeedLoad then
  begin
    LoadFromMaster;
    Wrap.NeedRefresh := False; // Обновлять больше не нужно
  end
  else if Wrap.NeedRefresh then
    Wrap.RefreshQuery
  else if Master <> nil then
    LoadFromMaster
  else
    Wrap.TryOpen;
end;

procedure TQueryBaseEvents.ApplyUpdates;
begin
  Wrap.TryPost;
  if FDQuery.CachedUpdates then
  begin
    // Если все изменения прошли без ошибок
    if FDQuery.ApplyUpdates() = 0 then
      FDQuery.CommitUpdates;

    // Извещаем всех что CommitUpdates произошёл!
    if FAfterCommitUpdates <> nil then
      AfterCommitUpdates.CallEventHandlers(Self);
  end;

  // Тут какой-то глюк и до переоткрытия кол-во изменений не 0
  // Assert(FDQuery.ChangeCount = 0);
end;

procedure TQueryBaseEvents.CancelUpdates;
begin
  // отменяем все сделанные изменения на стороне клиента
  Wrap.TryCancel;
  if FDQuery.CachedUpdates then
  begin
    FDQuery.CancelUpdates;
    // Дополнительно сообщаем о том, что изменения отменены
    FAfterCancelUpdates.CallEventHandlers(Self);
  end
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
    // Помечаем что у нас нет не закоммитенных изменений
    FHaveAnyNotCommitedChanges := False;
    // Извещаем всех что наши изменения закоммичены
    FAfterCommit.CallEventHandlers(Self);
  end;
end;

procedure TQueryBaseEvents.DoAfterDelete(Sender: TObject);
begin
  // Если транзакция ещё не завершилась
  if FDQuery.Connection.InTransaction then
    FHaveAnyNotCommitedChanges := True;
end;

procedure TQueryBaseEvents.DoAfterMasterScroll(Sender: TObject);
// var
// S: String;
begin
  // S := Name;
  // if S.StartsWith('QueryCategoryParameters2') then
  // beep;

  TryLoad(IfThen(FMaster.FDQuery.RecordCount > 0,
    FMaster.Wrap.PK.AsInteger, -1));
end;

procedure TQueryBaseEvents.DoAfterOpen(Sender: TObject);
var
  i: Integer;
begin
  SaveDebugLog;

  // Костыль с некоторыми типами полей
  InitializeFields;

  // делаем выравнивание всех полей по левому краю
  for i := 0 to FDQuery.FieldCount - 1 do
    FDQuery.Fields[i].Alignment := taLeftJustify;
end;

procedure TQueryBaseEvents.DoAfterPost(Sender: TObject);
begin
  // Если транзакция ещё не завершилась
  if FDQuery.Connection.InTransaction then
    FHaveAnyNotCommitedChanges := True;
end;

procedure TQueryBaseEvents.DoAfterRefresh(Sender: TObject);
begin
  SaveDebugLog;
end;

procedure TQueryBaseEvents.DoAfterRollback(Sender: TObject);
begin
  // Помечаем что у нас нет не закоммитенных изменений
  FHaveAnyNotCommitedChanges := False;
end;

procedure TQueryBaseEvents.DoBeforeApplyUpdates(Sender: TFDDataSet);
begin
  Assert(FBeforeApplyUpdates <> nil);
  FBeforeApplyUpdates.CallEventHandlers(Self);
end;

procedure TQueryBaseEvents.DoAfterApplyUpdates(Sender: TFDDataSet;
  AError: Integer);
begin
  Assert(FAfterApplyUpdates <> nil);
  FAfterApplyUpdates.CallEventHandlers(Self);
end;

procedure TQueryBaseEvents.DoBeforeMasterScroll(Sender: TObject);
begin
  // Перед тем, как мастер переместится на новую запись,
  // нужно сохранить изменения в текущей
  if FDQuery.Active then
    Wrap.TryPost;
end;

procedure TQueryBaseEvents.DoBeforeOpenOrRefresh(Sender: TObject);
begin
  FHRTimer.StartTimer;
end;

procedure TQueryBaseEvents.DoBeforePost(Sender: TObject);
var
  i: Integer;
  S: string;
begin
  // Убираем начальные и конечные пробелы в строковых полях
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
  Result := FDQuery.Active and not Wrap.NeedRefresh;
end;

function TQueryBaseEvents.GetBeforeApplyUpdates: TNotifyEventsEx;
begin
  if FBeforeApplyUpdates = nil then
  begin
    Assert(not Assigned(FDQuery.BeforeApplyUpdates));
    FBeforeApplyUpdates := TNotifyEventsEx.Create(Self);
    FDQuery.BeforeApplyUpdates := DoBeforeApplyUpdates;
  end;
  Result := FBeforeApplyUpdates;
end;

function TQueryBaseEvents.GetAfterApplyUpdates: TNotifyEventsEx;
begin
  if FAfterApplyUpdates = nil then
  begin
    Assert(not Assigned(FDQuery.AfterApplyUpdates));
    FAfterApplyUpdates := TNotifyEventsEx.Create(Self);
    FDQuery.AfterApplyUpdates := DoAfterApplyUpdates;
  end;
  Result := FAfterApplyUpdates;
end;

function TQueryBaseEvents.GetAfterCommitUpdates: TNotifyEventsEx;
begin
  if FAfterCommitUpdates = nil then
  begin
    FAfterCommitUpdates := TNotifyEventsEx.Create(Self);
  end;

  Result := FAfterCommitUpdates;
end;

procedure TQueryBaseEvents.TryStartTransaction(Sender: TObject);
begin
  // начинаем транзакцию, если она ещё не началась
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
    // TWideMemoField - событие OnGetText
    if FDQuery.Fields[i] is TWideMemoField then
      FDQuery.Fields[i].OnGetText := DefaultOnGetText;

    if FDQuery.Fields[i] is TFDAutoIncField then
      FDQuery.Fields[i].ProviderFlags := [pfInWhere, pfInKey];
  end;
end;

procedure TQueryBaseEvents.LoadFromMaster(AIDParent: Integer;
  AForcibly: Boolean = False);
begin
  Assert(DetailParameterName <> '');

  // Если есть необходимость в загрузке данных
  if (not FDQuery.Active) or (FDQuery.Params.ParamByName(DetailParameterName)
    .AsInteger <> AIDParent) or AForcibly then
  begin
    FDQuery.Params.ParamByName(DetailParameterName).AsInteger := AIDParent;
    Wrap.RefreshQuery;
  end;
end;

procedure TQueryBaseEvents.LoadFromMaster;
var
  AIDParent: Integer;
begin
  FNeedLoad := False;
  Assert(FMaster <> nil);
  AIDParent := IfThen(FMaster.FDQuery.RecordCount > 0,
    FMaster.Wrap.PK.AsInteger, -1);
  LoadFromMaster(AIDParent);
end;

procedure TQueryBaseEvents.MasterCascadeDelete;
var
  V: Variant;
begin
  Assert(FMaster <> nil);
  Assert(FMaster.FDQuery.RecordCount > 0);
  V := FMaster.Wrap.PK.Value;
  Wrap.CascadeDelete(V, DetailParameterName);
  FMaster.Wrap.LocateByPK(V, True);
end;

procedure TQueryBaseEvents.RemoveClient;
begin
  Assert(FClientCount > 0);
  Dec(FClientCount);
end;

procedure TQueryBaseEvents.SaveDebugLog;
var
  i: Integer;
  t: Double;
begin
  if not FDebug then
    Exit;

  t := FHRTimer.ReadTimer;
  Writeln(FFile, Format('Time = %f (%s)', [t, Label1.Caption]));
  // Записываем SQL запрос в файл
  for i := 0 to FDQuery.SQL.Count - 1 do
    Writeln(FFile, FDQuery.SQL[i]);
  if FDQuery.ParamCount > 0 then
  begin
    Writeln(FFile, '');
    for i := 0 to FDQuery.Params.Count - 1 do
    begin
      Writeln(FFile, Format(':%s = %s', [FDQuery.Params[i].Name,
        FDQuery.Params[i].AsString]));
    end;
  end;
  Writeln(FFile, '');
  Writeln(FFile, '');

  Flush(FFile);
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

procedure TQueryBaseEvents.SetMaster(const Value: TQueryBaseEvents);
begin
  if FMaster <> Value then
  begin
    // Отписываемся от всех событий старого мастера
    FMasterEventList.Clear;

    FMaster := Value;

    if FMaster <> nil then
    begin
      // Подписываемся на события нового мастера
      TNotifyEventWrap.Create(FMaster.Wrap.BeforeScroll, DoBeforeMasterScroll,
        FMasterEventList);

      TNotifyEventWrap.Create(FMaster.Wrap.AfterScrollM, DoAfterMasterScroll,
        FMasterEventList);
    end;

  end;
end;

procedure TQueryBaseEvents.TryCallAfterCommitUpdatesEvent;
begin
  if FAfterCommitUpdates <> nil then
    FAfterCommitUpdates.CallEventHandlers(Self);
end;

procedure TQueryBaseEvents.TryLoad(AIDParent: Integer);
var
  // AIDParent: Integer;
  AParamValueChange: Boolean;
begin
  Assert(DetailParameterName <> '');

  // Assert(FMaster <> nil);

  // AIDParent := IfThen(FMaster.FDQuery.RecordCount > 0,
  // FMaster.Wrap.PK.AsInteger, -1);

  // Если значение параметра изменилось
  AParamValueChange := FDQuery.Params.ParamByName(DetailParameterName).AsInteger
    <> AIDParent;

  // Если наш запрос пока ещё никто не использует
  if FClientCount = 0 then
  begin
    FNeedLoad := True;
    Exit;
  end;

  // Если наш запрос кто-то использует
  // но параметр  НЕ изменился и запрос уже открыт
  if (not AParamValueChange) and FDQuery.Active then
  begin
    Exit;
  end;

  if AParamValueChange then
    FDQuery.Params.ParamByName(DetailParameterName).AsInteger := AIDParent;

  // Обновляем или открываем заново запрос
  Wrap.RefreshQuery;
end;

procedure TQueryBaseEvents.TryLoad2(AIDParent: Integer);
var
  // AIDParent: Integer;
  AParamValueChange: Boolean;
begin
  Assert(DetailParameterName <> '');

  // Если значение параметра изменилось
  AParamValueChange := FDQuery.Params.ParamByName(DetailParameterName).AsInteger
    <> AIDParent;

  // Если наш запрос кто-то использует
  // но параметр  НЕ изменился и запрос уже открыт
  if (not AParamValueChange) and FDQuery.Active then
  begin
    Exit;
  end;

  if AParamValueChange then
    FDQuery.Params.ParamByName(DetailParameterName).AsInteger := AIDParent;

  // Обновляем или открываем заново запрос
  Wrap.RefreshQuery;
end;

procedure TQueryBaseEvents.TryRefresh;
begin
  (*
    if not Lock then
    Wrap.RefreshQuery
    else
    Wrap.NeedRefresh := True;
  *)

  if FClientCount > 0 then
    Wrap.RefreshQuery
  else
    Wrap.NeedRefresh := True;
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

  FBeforeApplyUpdates := TNotifyEventsEx.Create(Self);

  FOnHaveAnyChanges := TNotifyEventsEx.Create(Self);
end;

destructor TQueryMonitor.Destroy;
begin
  FreeAndNil(FBeforeApplyUpdates);
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

  TNotifyEventWrap.Create(AQuery.AfterCommitUpdates, DoAfterCancelOrPost,
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
  Q := (Sender as TDSWrap).Obj as TQueryBaseEvents;

  // Если нет несохранённных изменений
  if not Q.HaveAnyChanges then
  begin
    i := FChangedQueries.IndexOf(Q);
    if i >= 0 then
      FChangedQueries.Delete(i);
  end
  else
  begin
    i := FChangedQueries.IndexOf(Q);
    // Если этого запроса ещё нет в списке изменённых
    if i = -1 then
      FChangedQueries.Add(Q);
  end;

end;

procedure TQueryMonitor.DoAfterEditOrInsert(Sender: TObject);
var
  i: Integer;
  Q: TQueryBaseEvents;
begin
  Q := (Sender as TDSWrap).Obj as TQueryBaseEvents;

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
  Q := nil;
  if Sender is TQueryBaseEvents then
    Q := Sender as TQueryBaseEvents
  else if Sender is TDSWrap then
    Q := (Sender as TDSWrap).Obj as TQueryBaseEvents;

  Assert(Q <> nil);

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
  AQueryGroup: TQueryGroup2;
  i: Integer;
  k: Integer;
  Q: TQueryBaseEvents;
begin
  if not HaveAnyChanges then
    Exit;

  // Дополнительно проверяем, что сохранение необходимо!!!
  CheckChangedQueries;

  if not HaveAnyChanges then
    Exit;

  ACount := FChangedQueries.Count;
  k := 0;

  FBeforeApplyUpdates.CallEventHandlers(Self);

  while (FChangedQueries.Count > 0) do
  begin
    Q := FChangedQueries[0];
    if (Q.Owner <> nil) and (Q.Owner is TQueryGroup2) then
    begin
      AQueryGroup := Q.Owner as TQueryGroup2;
      // Просим группу сохранить свои изменения
      AQueryGroup.ApplyUpdates;
    end
    else
    begin
      // Если запрос сам по себе
      Q.ApplyUpdates;
    end;

    CheckChangedQueries;

    // Если количество запросов нуждающихся в сохранении не уменьшилось
    if FChangedQueries.Count = ACount then
      break;
  end;

  TryCommit;
end;

procedure TQueryMonitor.CancelUpdates;
var
  ACount: Integer;
  AQueryGroup: TQueryGroup2;
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
    if (Q.Owner <> nil) and (Q.Owner is TQueryGroup2) then
    begin
      AQueryGroup := Q.Owner as TQueryGroup2;
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

procedure TQueryMonitor.CheckChangedQueries;
var
  i: Integer;
  Q: TQueryBaseEvents;
begin
  for i := FChangedQueries.Count - 1 downto 0 do
  begin
    Q := FChangedQueries[i];

    // Если нет несохранённых изменений
    if not Q.HaveAnyChanges then
      FChangedQueries.Delete(i);
  end;
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

  // Мы не должны разрушать запрос, который имеет несохранённые данные
  i := FChangedQueries.IndexOf(AQuery);

  // if i >= 0 then
  // beep;

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
