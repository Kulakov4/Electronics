unit DataModuleFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  NotifyEvents, System.Contnrs, System.Generics.Collections;

const
  WM_DS_BEFORE_SCROLL = WM_USER + 555;
  WM_DS_AFTER_SCROLL = WM_USER + 556;
  WM_DS_AFTER_POST = WM_USER + 557;
  WM_NEED_POST = WM_USER + 558;
  WM_ON_DATA_CHANGE = WM_USER + 559;

type
  TfrmDataModule = class(TFrame)
    DataSource: TDataSource;
    FDQuery: TFDQuery;
    Label1: TLabel;
    procedure DataSourceDataChange(Sender: TObject; Field: TField);
    procedure FDQueryAfterInsert(DataSet: TDataSet);
    procedure FDQueryAfterScroll(DataSet: TDataSet);
    procedure FDQueryBeforeInsert(DataSet: TDataSet);
    procedure FDQueryBeforeScroll(DataSet: TDataSet);
    procedure DefaultOnGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure FDQueryAfterClose(DataSet: TDataSet);
    procedure FDQueryAfterDelete(DataSet: TDataSet);
    procedure FDQueryAfterEdit(DataSet: TDataSet);
    procedure FDQueryAfterOpen(DataSet: TDataSet);
    procedure FDQueryAfterPost(DataSet: TDataSet);
    procedure FDQueryBeforeDelete(DataSet: TDataSet);
    procedure FDQueryBeforeEdit(DataSet: TDataSet);
    procedure FDQueryBeforeOpen(DataSet: TDataSet);
    procedure FDQueryBeforePost(DataSet: TDataSet);
    procedure HideNullGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
  private
    FAfterScroll: TNotifyEventsEx;
    FAfterInsert: TNotifyEventsEx;
    FAfterDelete: TNotifyEventsEx;
    FAfterEdit: TNotifyEventsEx;
    FAfterLoad: TNotifyEventsEx;
    FAfterOpen: TNotifyEventsEx;
    FAfterClose: TNotifyEventsEx;
    FAfterRefresh: TNotifyEventsEx;
    FAfterPost: TNotifyEventsEx;
    FAutoTransaction: Boolean;
    FBeforeScroll: TNotifyEventsEx;
    FBeforeInsert: TNotifyEventsEx;
    FBeforeDelete: TNotifyEventsEx;
    FBeforeEdit: TNotifyEventsEx;
    FBeforeLoad: TNotifyEventsEx;
    FBeforeOpen: TNotifyEventsEx;
    FBeforePost: TNotifyEventsEx;
    FBeforeScrollI: TNotifyEventsEx;
    FDetailParameterName: string;
    FIsModifedClone: TFDMemTable;
    FLock: Boolean;
    FMaster: TfrmDataModule;
    FNeedLoad: Boolean;
    FNeedRefresh: Boolean;
    FOnDataChange: TNotifyEventsEx;
    FPKFieldName: String;
    FResiveAfterScrollMessage: Boolean;
    FResiveBeforeScrollMessage: Boolean;
    FResiveAfterPostMessage: Boolean;
    FResiveOnDataChangeMessage: Boolean;
    FUseAfterPostMessage: Boolean;
    procedure DoAfterClose(Sender: TObject);
    procedure DoAfterMasterScroll(Sender: TObject);
    procedure DoAfterOpen(Sender: TObject);
    procedure DoBeforePost(Sender: TObject);
    procedure DoOnStartTransaction(Sender: TObject);
    function GetActual: Boolean;
    function GetCashedRecordBalance: Integer;
    function GetParentValue: Integer;
    function GetPKValue: Integer;
    procedure InitializeFields;
    procedure SetAutoTransaction(const Value: Boolean);
    procedure SetLock(const Value: Boolean);
    procedure SetMaster(const Value: TfrmDataModule);
    { Private declarations }
  protected
    FEventList: TObjectList;
    FAutoTransactionEventList: TObjectList;
    FMasterEventList: TObjectList;
    procedure ApplyDelete(ASender: TDataSet); virtual;
    procedure ApplyInsert(ASender: TDataSet); virtual;
    procedure ApplyUpdate(ASender: TDataSet); virtual;
    procedure DeleteSelfDetail(AIDMaster: Variant); virtual;
    procedure DoOnNeedPost(var Message: TMessage); message WM_NEED_POST;
    procedure DoOnQueryUpdateRecord(ASender: TDataSet; ARequest: TFDUpdateRequest;
        var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions);
    function GetHaveAnyChanges: Boolean; virtual;
    procedure ProcessAfterScrollMessage(var Message: TMessage);
      message WM_DS_AFTER_SCROLL;
    procedure ProcessAfterPostMessage(var Message: TMessage);
      message WM_DS_AFTER_POST;
    procedure ProcessBeforeScrollMessage(var Message: TMessage);
      message WM_DS_BEFORE_SCROLL;
    procedure ProcessOnDataChange(var Message: TMessage);
      message WM_ON_DATA_CHANGE;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AppendRows(AFieldName: string; AValues: TArray<String>); virtual;
    procedure ApplyUpdates; virtual;
    procedure CancelUpdates; virtual;
    procedure CascadeDelete; overload;
    procedure CascadeDelete(const AIDMaster: Integer;
      const ADetailKeyFieldName: String); overload; virtual;
    procedure CreateDefaultFields(AUpdate: Boolean);
    procedure DeleteByFilter(const AFilterExpression: string);
    procedure DeleteList(var AList: TList<Variant>);
    function Field(const AFieldName: String): TField;
    function GetFieldValues(AFieldName: string;
      ADelimiter: String = ','): String;
    function IsModifed(APKValue: Variant): Boolean;
    procedure Load(AIDParent: Integer); overload; virtual;
    procedure Load; overload;
    procedure Load(const AParamNames: array of string;
      const AParamValues: array of Variant); overload;
    function LocateByPK(APKValue: Variant): Boolean;
    procedure PostPostMessage;
    procedure TryLoad;
    procedure TryRefresh;
    procedure RefreshQuery;
    procedure TryEdit;
    procedure TryPost;
    procedure TryCancel;
    procedure TryAppend;
    property Actual: Boolean read GetActual;
    property AfterScroll: TNotifyEventsEx read FAfterScroll;
    property AfterInsert: TNotifyEventsEx read FAfterInsert;
    property AfterDelete: TNotifyEventsEx read FAfterDelete;
    property AfterEdit: TNotifyEventsEx read FAfterEdit;
    property AfterLoad: TNotifyEventsEx read FAfterLoad;
    property AfterOpen: TNotifyEventsEx read FAfterOpen;
    property AfterClose: TNotifyEventsEx read FAfterClose;
    property AfterRefresh: TNotifyEventsEx read FAfterRefresh;
    property AfterPost: TNotifyEventsEx read FAfterPost;
    property AutoTransaction: Boolean read FAutoTransaction
      write SetAutoTransaction;
    property BeforeScroll: TNotifyEventsEx read FBeforeScroll;
    property BeforeInsert: TNotifyEventsEx read FBeforeInsert;
    property BeforeDelete: TNotifyEventsEx read FBeforeDelete;
    property BeforeEdit: TNotifyEventsEx read FBeforeEdit;
    property BeforeLoad: TNotifyEventsEx read FBeforeLoad;
    property BeforeOpen: TNotifyEventsEx read FBeforeOpen;
    property BeforePost: TNotifyEventsEx read FBeforePost;
    property BeforeScrollI: TNotifyEventsEx read FBeforeScrollI;
    property CashedRecordBalance: Integer read GetCashedRecordBalance;
    property DetailParameterName: string read FDetailParameterName
      write FDetailParameterName;
    property HaveAnyChanges: Boolean read GetHaveAnyChanges;
    property Lock: Boolean read FLock write SetLock;
    property Master: TfrmDataModule read FMaster write SetMaster;
    property NeedRefresh: Boolean read FNeedRefresh;
    property ParentValue: Integer read GetParentValue;
    property PKFieldName: String read FPKFieldName;
    property PKValue: Integer read GetPKValue;
    property UseAfterPostMessage: Boolean read FUseAfterPostMessage
      write FUseAfterPostMessage;
    property OnDataChange: TNotifyEventsEx read FOnDataChange;
    { Public declarations }
  published
  end;

implementation

uses System.Math, RepositoryDataModule;

{$R *.dfm}
{ TfrmDataModule }

constructor TfrmDataModule.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  // Создаём список своих подписчиков на события
  FEventList := TObjectList.Create;
  FAutoTransactionEventList := TObjectList.Create;
  FMasterEventList := TObjectList.Create;

  // По умолчанию транзакции сами начинаются и заканчиваются
  FAutoTransaction := True;

  // Создаём события
  FOnDataChange := TNotifyEventsEx.Create(Self);

  FBeforeScroll := TNotifyEventsEx.Create(Self);
  FBeforeScrollI := TNotifyEventsEx.Create(Self);
  FAfterScroll := TNotifyEventsEx.Create(Self);

  FBeforeInsert := TNotifyEventsEx.Create(Self);
  FAfterInsert := TNotifyEventsEx.Create(Self);

  FBeforeDelete := TNotifyEventsEx.Create(Self);
  FAfterDelete := TNotifyEventsEx.Create(Self);

  FBeforeOpen := TNotifyEventsEx.Create(Self);
  FAfterOpen := TNotifyEventsEx.Create(Self);
  FAfterClose := TNotifyEventsEx.Create(Self);

  FBeforePost := TNotifyEventsEx.Create(Self);
  FAfterPost := TNotifyEventsEx.Create(Self);

  FBeforeLoad := TNotifyEventsEx.Create(Self);
  FAfterLoad := TNotifyEventsEx.Create(Self);
  FAfterRefresh := TNotifyEventsEx.Create(Self);

  FBeforeEdit := TNotifyEventsEx.Create(Self);
  FAfterEdit := TNotifyEventsEx.Create(Self);

  FPKFieldName := 'ID';
  FResiveAfterScrollMessage := True;
  FResiveBeforeScrollMessage := True;
  FResiveAfterPostMessage := True;

  FUseAfterPostMessage := True;
  FResiveOnDataChangeMessage := True;

  // Все поля будем выравнивать по левому краю + клонировать курсор (если надо)
  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, FEventList);

  // Во всех строковых полях будем удалять начальные и конечные пробелы
  TNotifyEventWrap.Create(BeforePost, DoBeforePost, FEventList);

  // После закрытия будем закрывать своих клонов
  TNotifyEventWrap.Create(AfterClose, DoAfterClose, FEventList);
end;

destructor TfrmDataModule.Destroy;
begin
  FreeAndNil(FEventList); // отписываемся от всех событий
  FreeAndNil(FMasterEventList); // отписываемся от всех событий Мастера
  FreeAndNil(FAutoTransactionEventList);
  inherited;
end;

procedure TfrmDataModule.AppendRows(AFieldName: string; AValues:
    TArray<String>);
var
  AValue: string;
begin
  Assert(not AFieldName.IsEmpty);

  // Добавляем в список родительские компоненты
  for AValue in AValues do
  begin
    TryAppend;
    Field(AFieldName).AsString := AValue;
    TryPost;
  end;
end;

procedure TfrmDataModule.ApplyDelete(ASender: TDataSet);
begin
end;

procedure TfrmDataModule.ApplyInsert(ASender: TDataSet);
begin
end;

procedure TfrmDataModule.ApplyUpdate(ASender: TDataSet);
begin
end;

procedure TfrmDataModule.ApplyUpdates;
begin
  if not FDQuery.CachedUpdates then
    raise Exception.Create('Не включен режим кэширования записей на клиенте');

  TryPost;

  FDQuery.ApplyUpdates();
  FDQuery.CommitUpdates;
end;

procedure TfrmDataModule.FDQueryAfterInsert(DataSet: TDataSet);
begin
  FAfterInsert.CallEventHandlers(FDQuery);
end;

procedure TfrmDataModule.FDQueryAfterScroll(DataSet: TDataSet);
begin
  // Если предыдущее сообщение о скроле уже получили
  if FResiveAfterScrollMessage then
  begin
    FResiveAfterScrollMessage := False;
    // Отправляем новое сообщение
    PostMessage(Handle, WM_DS_AFTER_SCROLL, 0, 0);
  end;

  // if not LockScroll then
  // FAfterScroll.CallEventHandlers(FDQuery);
end;

procedure TfrmDataModule.FDQueryBeforeInsert(DataSet: TDataSet);
begin
  FBeforeInsert.CallEventHandlers(FDQuery);
end;

procedure TfrmDataModule.FDQueryBeforeScroll(DataSet: TDataSet);
begin
  FBeforeScrollI.CallEventHandlers(FDQuery);

  // Если предыдущее сообщение о скроле уже получили
  if FResiveBeforeScrollMessage then
  begin
    FResiveBeforeScrollMessage := False;
    // Отправляем новое сообщение
    PostMessage(Handle, WM_DS_BEFORE_SCROLL, 0, 0);
  end;
end;

procedure TfrmDataModule.DefaultOnGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  Text := VarToStr(Sender.Value);
end;

procedure TfrmDataModule.FDQueryAfterDelete(DataSet: TDataSet);
begin
  FAfterDelete.CallEventHandlers(FDQuery);
end;

procedure TfrmDataModule.FDQueryBeforeDelete(DataSet: TDataSet);
begin
  FBeforeDelete.CallEventHandlers(FDQuery);
end;

// Есть-ли изменения не сохранённые в БД
function TfrmDataModule.GetHaveAnyChanges: Boolean;
begin
  Result := FDQuery.State in [dsEdit, dsInsert];
  if Result then
    Exit;

  // Если все изменения кэшируются на стороне клиента
  if FDQuery.CachedUpdates then
  begin
    Result := FDQuery.ChangeCount > 0;
  end
  else
  begin
    // если транзакция не завершена
    Result := FDQuery.Connection.InTransaction;
  end;

end;

procedure TfrmDataModule.HideNullGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  if VarIsNull(Sender.Value) or (Sender.Value = 0) then
    Text := ''
  else
    Text := Sender.Value;
end;

function TfrmDataModule.GetPKValue: Integer;
begin
  Result := FDQuery.FieldByName(FPKFieldName).AsInteger;
end;

procedure TfrmDataModule.CancelUpdates;
begin
  // отменяем все сделанные изменения на стороне клиента
  TryCancel;
  FDQuery.CancelUpdates;
end;

procedure TfrmDataModule.CascadeDelete;
begin
  Assert(FMaster <> nil);
  Assert(FMaster.FDQuery.RecordCount > 0);

  CascadeDelete(FMaster.PKValue, DetailParameterName);
end;

procedure TfrmDataModule.CascadeDelete(const AIDMaster: Integer;
  const ADetailKeyFieldName: String);
begin
  Assert(AIDMaster > 0);

  // Формируем фильтр и удаляем
  DeleteByFilter(Format('%s = %d', [ADetailKeyFieldName, AIDMaster]));
end;

procedure TfrmDataModule.CreateDefaultFields(AUpdate: Boolean);
var
  i: Integer;
begin
  Assert(not FDQuery.Active);
  with FDQuery do
  begin
    if AUpdate then
      FieldDefs.Update;
    for i := 0 to FieldDefs.Count - 1 do
    begin
      FieldDefs[i].CreateField(FDQuery);
    end;
  end;
end;

procedure TfrmDataModule.DataSourceDataChange(Sender: TObject; Field: TField);
begin
  // если есть подписчики
  if (FOnDataChange.Count > 0) and (FResiveOnDataChangeMessage) then
  begin
    FResiveOnDataChangeMessage := False;
    PostMessage(Handle, WM_ON_DATA_CHANGE, 0, 0);
  end;
end;

procedure TfrmDataModule.DeleteByFilter(const AFilterExpression: string);
Var
  AClone: TFDMemTable;
begin
  Assert(not AFilterExpression.IsEmpty);

  // Создаём клона
  AClone := TFDMemTable.Create(Self);
  try
    // Клонируем курсор
    AClone.CloneCursor(FDQuery);
    // Накладываем фильтр
    AClone.Filter := AFilterExpression;
    // Включаем фильтр
    AClone.Filtered := True;

    if AClone.RecordCount > 0 then
    begin
      FDQuery.DisableControls;
      try

        // Удаляем все отфильтрованные записи
        while AClone.RecordCount > 0 do
        begin
          // Сначала удаляем подчинённые себе записи
          DeleteSelfDetail(AClone.FieldByName(FPKFieldName).Value);

          if LocateByPK(AClone.FieldByName(FPKFieldName).Value) then
          begin
            // Потом сам
            FDQuery.Delete;
          end;
        end;
      finally
        FDQuery.EnableControls;
      end;
    end;

  finally
    FreeAndNil(AClone);
  end;

end;

procedure TfrmDataModule.DeleteList(var AList: TList<Variant>);
var
  V: Variant;
begin
  // Удаляет список
  FDQuery.DisableControls;
  try
    for V in AList do
    begin
      // Сначала удаляем у себя же подчинённые записи
      DeleteSelfDetail(V);

      // Теперь удаляем саму запись
      if LocateByPK(V) then
      begin
        // Затем удаляем себя
        FDQuery.Delete;
      end;
    end;
  finally
    FDQuery.EnableControls;
  end;
end;

procedure TfrmDataModule.DeleteSelfDetail(AIDMaster: Variant);
begin
  // По умолчанию нет подчинённых своих-же записей
end;

procedure TfrmDataModule.DoAfterClose(Sender: TObject);
begin
  // Если ранее создали клона
  if FIsModifedClone <> nil then
    FIsModifedClone.Close;
end;

procedure TfrmDataModule.DoAfterMasterScroll(Sender: TObject);
begin
  TryLoad;
end;

procedure TfrmDataModule.DoAfterOpen(Sender: TObject);
var
  i: Integer;
begin
  // Если клона создавали раньше, то клонируем курсор
  if FIsModifedClone <> nil then
    FIsModifedClone.CloneCursor(FDQuery);

  // делаем выравнивание всех полей по левому краю
  for i := 0 to FDQuery.FieldCount - 1 do
    FDQuery.Fields[i].Alignment := taLeftJustify;
end;

procedure TfrmDataModule.DoBeforePost(Sender: TObject);
var
  i: Integer;
  S: string;
begin
  for i := 0 to FDQuery.FieldCount - 1 do
  begin
    if (FDQuery.Fields[i] is TStringField) and (not FDQuery.Fields[i].ReadOnly)
    then
    begin
      S := FDQuery.Fields[i].AsString.Trim;
      if FDQuery.Fields[i].AsString <> S then
        FDQuery.Fields[i].AsString := S;
    end;
  end;
end;

procedure TfrmDataModule.DoOnNeedPost(var Message: TMessage);
var
  AID: Integer;
begin
  AID := Message.WParam;
  if (FDQuery.RecordCount > 0) and (AID = PKValue) then
    TryPost;
end;

procedure TfrmDataModule.DoOnStartTransaction(Sender: TObject);
begin
  // начинаем транзакцию, если она ещё не началась
  if (not AutoTransaction) and (not FDQuery.Connection.InTransaction) then
    FDQuery.Connection.StartTransaction;
end;

procedure TfrmDataModule.FDQueryAfterClose(DataSet: TDataSet);
begin
  FAfterClose.CallEventHandlers(Self);
end;

procedure TfrmDataModule.FDQueryAfterEdit(DataSet: TDataSet);
begin
  FAfterEdit.CallEventHandlers(Self);
end;

procedure TfrmDataModule.FDQueryAfterOpen(DataSet: TDataSet);
begin
  InitializeFields;
  FAfterOpen.CallEventHandlers(FDQuery);
end;

procedure TfrmDataModule.FDQueryAfterPost(DataSet: TDataSet);
begin
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

procedure TfrmDataModule.FDQueryBeforeEdit(DataSet: TDataSet);
begin
  FBeforeEdit.CallEventHandlers(Self);
end;

procedure TfrmDataModule.FDQueryBeforeOpen(DataSet: TDataSet);
begin
  FBeforeOpen.CallEventHandlers(Self);
end;

procedure TfrmDataModule.FDQueryBeforePost(DataSet: TDataSet);
begin
  FBeforePost.CallEventHandlers(Self);
end;

procedure TfrmDataModule.DoOnQueryUpdateRecord(ASender: TDataSet; ARequest:
    TFDUpdateRequest; var AAction: TFDErrorAction; AOptions:
    TFDUpdateRowOptions);
begin
  try
    // Если произошло удаление
    if ARequest = arDelete then
    begin
      ApplyDelete(ASender);
    end;

    // Операция добавления записи на клиенте
    if ARequest = arInsert then
    begin
      ApplyInsert(ASender);
    end;

    // Операция обновления записи на клиенте
    if ARequest = arUpdate then
    begin
      ApplyUpdate(ASender);
    end;


    AAction := eaApplied;
  except
    AAction := eaFail;
  end;
end;

function TfrmDataModule.Field(const AFieldName: String): TField;
begin
  Result := FDQuery.FieldByName(AFieldName);
end;

function TfrmDataModule.GetActual: Boolean;
begin
  Result := FDQuery.Active and not NeedRefresh;

end;

function TfrmDataModule.GetCashedRecordBalance: Integer;
var
  AClone: TFDMemTable;
begin
  Result := 0;

  // Exit;

  if not FDQuery.Active then
    Exit;

  // Если все изменения кэшируются на стороне клиента
  if FDQuery.CachedUpdates then
  begin
    // Создаём клона
    AClone := TFDMemTable.Create(Self);
    try
      AClone.CloneCursor(FDQuery);

      // Добавляем кол-во добавленных
      AClone.FilterChanges := [rtInserted];
      Result := AClone.RecordCount;

      // Вычитаем кол-во удалённых
      AClone.FilterChanges := [rtDeleted];
      Result := Result - AClone.RecordCount;

    finally
      FreeAndNil(AClone);
    end;
    (*
      // Узнать баланс кэша можно только в состоянии просмотра
      Assert(FDQuery.State = dsBrowse);
      FDQuery.DisableControls;
      try
      // Добавляем кол-во добавленных
      FDQuery.FilterChanges := [rtInserted];
      Result := FDQuery.RecordCount;
      // Вычитаем кол-во удалённых
      FDQuery.FilterChanges := [rtDeleted];
      Result := Result - FDQuery.RecordCount;

      FDQuery.FilterChanges := [rtUnmodified, rtModified, rtInserted];
      finally
      FDQuery.EnableControls;
      end;
    *)
  end
  else
    Result := IfThen(FDQuery.State in [dsInsert], 1, 0);

end;

function TfrmDataModule.GetFieldValues(AFieldName: string;
  ADelimiter: String = ','): String;
var
  AClone: TFDMemTable;
  AValue: string;
begin
  Result := ADelimiter;

  // Создаём клона
  AClone := TFDMemTable.Create(Self);
  try
    AClone.CloneCursor(FDQuery);
    AClone.First;
    while not AClone.Eof do
    begin

      AValue := AClone.FieldByName(AFieldName).AsString;

      if (AValue <> '') then
      begin
        Result := Result + AValue + ADelimiter;
      end;

      AClone.Next;
    end;
  finally
    FreeAndNil(AClone);
  end;
end;

function TfrmDataModule.GetParentValue: Integer;
begin
  Assert(DetailParameterName <> '');
  Result := FDQuery.Params.ParamByName(DetailParameterName).AsInteger;
end;

procedure TfrmDataModule.InitializeFields;
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

function TfrmDataModule.IsModifed(APKValue: Variant): Boolean;
var
  AFDDataSet: TFDDataSet;
  OK: Boolean;
begin
  // Если проверяем текущую запись
  if PKValue = APKValue then
    AFDDataSet := FDQuery
  else
  begin
    // Для проверки другой записи надо создать клон
    if FIsModifedClone = nil then
    begin
      // Создаём набор данных в памяти
      FIsModifedClone := TFDMemTable.Create(Self);
      // Создаём клон себя
      FIsModifedClone.CloneCursor(FDQuery);
    end;
    OK := FIsModifedClone.LocateEx(FPKFieldName, APKValue);
    Assert(OK);
    AFDDataSet := FIsModifedClone;
  end;

  Result := AFDDataSet.UpdateStatus in [usModified, usInserted]
end;

procedure TfrmDataModule.Load(AIDParent: Integer);
begin
  Assert(DetailParameterName <> '');

  // Если есть необходимость в загрузке данных
  if (not FDQuery.Active) or (FDQuery.Params.ParamByName(DetailParameterName)
    .AsInteger <> AIDParent) then
  begin
    FBeforeLoad.CallEventHandlers(FDQuery);

    FDQuery.Close;
    FDQuery.Params.ParamByName(DetailParameterName).AsInteger := AIDParent;
    FDQuery.Open();

    FAfterLoad.CallEventHandlers(FDQuery);
  end;
end;

procedure TfrmDataModule.Load;
var
  AIDParent: Integer;
begin
  FNeedLoad := False;
  Assert(FMaster <> nil);
  AIDParent := IfThen(FMaster.FDQuery.RecordCount > 0, FMaster.PKValue, -1);
  Load(AIDParent);
end;

procedure TfrmDataModule.Load(const AParamNames: array of string;
  const AParamValues: array of Variant);
var
  i: Integer;
begin
  Assert(Low(AParamNames) = Low(AParamValues));
  Assert(High(AParamNames) = High(AParamValues));

  FDQuery.DisableControls;
  try
    FDQuery.Close;
    for i := Low(AParamNames) to High(AParamNames) do
    begin
      FDQuery.ParamByName(AParamNames[i]).Value := AParamValues[i];
    end;
    FDQuery.Open;
  finally
    FDQuery.EnableControls;
  end;
end;

function TfrmDataModule.LocateByPK(APKValue: Variant): Boolean;
begin
  Result := FDQuery.LocateEx(FPKFieldName, APKValue);
end;

procedure TfrmDataModule.PostPostMessage;
begin
  PostMessage(Handle, WM_NEED_POST, PKValue, 0);
end;

procedure TfrmDataModule.TryLoad;
begin
  // Будем обновляться, т.к. мы подчинены мастеру
  if not Lock then
    Load
  else
    FNeedLoad := True;
end;

procedure TfrmDataModule.TryRefresh;
begin
  // Будем обновляться, т.к. мы подчинены мастеру
  if not Lock then
    RefreshQuery
  else
    FNeedRefresh := True;
end;

procedure TfrmDataModule.ProcessAfterScrollMessage(var Message: TMessage);
begin
  FAfterScroll.CallEventHandlers(FDQuery);
  FResiveAfterScrollMessage := True;
end;

procedure TfrmDataModule.ProcessAfterPostMessage(var Message: TMessage);
begin
  FAfterPost.CallEventHandlers(FDQuery);
  FResiveAfterPostMessage := True;
end;

procedure TfrmDataModule.ProcessBeforeScrollMessage(var Message: TMessage);
begin
  FBeforeScroll.CallEventHandlers(FDQuery);
  FResiveBeforeScrollMessage := True;
end;

procedure TfrmDataModule.ProcessOnDataChange(var Message: TMessage);
begin
  FOnDataChange.CallEventHandlers(Self);
  FResiveOnDataChangeMessage := True;
end;

procedure TfrmDataModule.RefreshQuery;
begin
  FNeedRefresh := False;
  FDQuery.DisableControls;
  try
    FDQuery.Close;
    FDQuery.Open();
    FAfterRefresh.CallEventHandlers(Self);
  finally
    FDQuery.EnableControls;
  end;
end;

procedure TfrmDataModule.SetAutoTransaction(const Value: Boolean);
begin
  if FAutoTransaction <> Value then
  begin
    FAutoTransaction := Value;

    // Если не включён режим автотранзакций
    if not FAutoTransaction then
    begin
      // Обработка не-автоматической транзакции
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

procedure TfrmDataModule.SetLock(const Value: Boolean);
begin
  if FLock <> Value then
  begin
    FLock := Value;

    if (not FLock) then
    begin
      // если мастер изменился, нам пора обновиться
      if FNeedLoad then
      begin
        Load;
        FNeedRefresh := False; // Обновлять больше не нужно
      end
      else if FNeedRefresh then
        RefreshQuery;
    end;
  end;
end;

procedure TfrmDataModule.SetMaster(const Value: TfrmDataModule);
begin
  if FMaster <> Value then
  begin
    // Отписываемся от всех событий старого мастера
    FMasterEventList.Clear;

    FMaster := Value;

    if FMaster <> nil then
    begin
      // Подписываемся на события нового мастера
      TNotifyEventWrap.Create(FMaster.AfterScroll, DoAfterMasterScroll,
        FMasterEventList);
    end;

  end;
end;

procedure TfrmDataModule.TryEdit;
begin
  Assert(FDQuery.Active);

  if not(FDQuery.State in [dsEdit, dsInsert]) then
    FDQuery.Edit;
end;

procedure TfrmDataModule.TryPost;
begin
  // если заблокировано и не активно
  if Lock and (not FDQuery.Active) then
    Exit;

  Assert(FDQuery.Active);

  if FDQuery.State in [dsEdit, dsInsert] then
    FDQuery.Post;
end;

procedure TfrmDataModule.TryCancel;
begin
  Assert(FDQuery.Active);

  if FDQuery.State in [dsEdit, dsInsert] then
    FDQuery.Cancel;
end;

procedure TfrmDataModule.TryAppend;
begin
  Assert(FDQuery.Active);

  if not(FDQuery.State in [dsEdit, dsInsert]) then
    FDQuery.Append;
end;

end.
