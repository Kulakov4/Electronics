unit BaseQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  NotifyEvents, System.Contnrs, System.Generics.Collections, DBRecordHolder;

// WM_NEED_POST = WM_USER + 558;

type
  TFetchFieldList = class
  private
    FFieldNames: TList<String>;
    FFieldValues: TList<Variant>;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(const AFieldName: String; const AFieldValue: Variant);
    property FieldNames: TList<String> read FFieldNames;
    property FieldValues: TList<Variant> read FFieldValues;
  end;

  TQueryBase = class(TFrame)
    FDQuery: TFDQuery;
    Label1: TLabel;
    procedure FDQueryBeforeOpen(DataSet: TDataSet);
  private
    FAfterLoad: TNotifyEventsEx;
    FBeforeLoad: TNotifyEventsEx;
    FBookmark: Variant;
    FDetailParameterName: string;
    FFDUpdateSQL: TFDUpdateSQL;
    FMaxUpdateRecCount: Integer;
    FUpdateRecCount: Integer;
  class var
    function GetCashedRecordBalance: Integer;
    function GetFDUpdateSQL: TFDUpdateSQL;
    function GetParentValue: Integer;
    function GetPK: TField;
    { Private declarations }
  protected
    FEventList: TObjectList;
    FPKFieldName: String;
    procedure ApplyDelete(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); virtual;
    procedure ApplyInsert(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); virtual;
    procedure ApplyUpdate(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); virtual;
    procedure DeleteSelfDetail(AIDMaster: Variant); virtual;
    // TODO: DoOnNeedPost
    // procedure DoOnNeedPost(var Message: TMessage); message WM_NEED_POST;
    procedure DoOnQueryUpdateRecord(ASender: TDataSet;
      ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
      AOptions: TFDUpdateRowOptions);
    procedure DoOnUpdateRecordException(AException: Exception); virtual;
    procedure FDQueryUpdateRecordOnClient(ASender: TDataSet;
      ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
      AOptions: TFDUpdateRowOptions);
    function GetHaveAnyChanges: Boolean; virtual;
    function GetHaveAnyNotCommitedChanges: Boolean; virtual;
    property FDUpdateSQL: TFDUpdateSQL read GetFDUpdateSQL;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AppendRows(AFieldName: string; AValues: TArray<String>);
      overload; virtual;
    procedure AppendRows(AFieldNames, AValues: TArray<String>);
      overload; virtual;
    procedure ApplyUpdates; virtual;
    procedure AssignFrom(AFDQuery: TFDQuery);
    procedure CancelUpdates; virtual;
    procedure CascadeDelete(const AIDMaster: Variant;
      const ADetailKeyFieldName: String;
      AFromClientOnly: Boolean = False); virtual;
    procedure ClearFields(AFieldList: TArray<String>;
      AProductIDList: TArray<Integer>);
    procedure ClearUpdateRecCount;
    procedure CreateDefaultFields(AUpdate: Boolean);
    procedure DeleteByFilter(const AFilterExpression: string);
    procedure FetchFields(const AFieldNames: TArray<String>;
      const AValues: TArray<Variant>; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); overload;
    procedure FetchFields(ARecordHolder: TRecordHolder;
      ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
      AOptions: TFDUpdateRowOptions); overload;
    procedure FetchFields(const AFetchFieldList: TFetchFieldList;
      ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
      AOptions: TFDUpdateRowOptions); overload;
    function Field(const AFieldName: String): TField;
    function GetFieldValues(AFieldName: string;
      ADelimiter: String = ','): String;
    function GetFieldValuesAsIntArray(AFieldName: string): TArray<Integer>;
    procedure IncUpdateRecCount;
    function InsertRecord(ARecordHolder: TRecordHolder): Integer;
    procedure Load(AIDParent: Integer; AForcibly: Boolean = False);
      overload; virtual;
    procedure Load(const AParamNames: TArray<String>;
      const AParamValues: TArray<Variant>); overload;
    function LocateByField(const AFieldName: string; const AValue: Variant;
      AOptions: TFDDataSetLocateOptions = [lxoCaseInsensitive, lxoPartialKey]
      ): Boolean;
    procedure SetParameters(const AParamNames: TArray<String>;
      const AParamValues: TArray<Variant>);
    function LocateByPK(APKValue: Variant; TestResult: Boolean = False)
      : Boolean;
    procedure LocateByPKAndDelete(APKValue: Variant);
    procedure RefreshQuery; virtual;
    function RestoreBookmark: Boolean;
    procedure SaveBookmark;
    function Search(const AParamNames: TArray<String>;
      const AParamValues: TArray<Variant>; TestResult: Integer = -1)
      : Integer; overload;
    procedure SetConditionSQL(const ABaseSQL, AConditionSQL, AMark: string;
      ANotifyEventRef: TNotifyEventRef = nil);
    procedure SetFieldsRequired(ARequired: Boolean);
    procedure SetFieldsReadOnly(AReadOnly: Boolean);
    procedure SetParamType(const AParamName: String;
      AParamType: TParamType = ptInput; ADataType: TFieldType = ftInteger);
    function TryEdit: Boolean;
    procedure TryPost; virtual;
    procedure TryCancel;
    procedure TryAppend;
    procedure TryOpen;
    procedure UpdateFields(AFields: TArray<TField>; AValues: TArray<Variant>;
      AUpdateNullFieldsOnly: Boolean);
    function UpdateRecord(ARecordHolder: TRecordHolder): Boolean;
    property AfterLoad: TNotifyEventsEx read FAfterLoad;
    property BeforeLoad: TNotifyEventsEx read FBeforeLoad;
    property CashedRecordBalance: Integer read GetCashedRecordBalance;
    property DetailParameterName: string read FDetailParameterName
      write FDetailParameterName;
    property HaveAnyChanges: Boolean read GetHaveAnyChanges;
    property ParentValue: Integer read GetParentValue;
    property PK: TField read GetPK;
    property PKFieldName: String read FPKFieldName;
    { Public declarations }
  published
  end;

implementation

uses System.Math, RepositoryDataModule, StrHelper, MapFieldsUnit;

{$R *.dfm}
{ TfrmDataModule }

constructor TQueryBase.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  // Создаём список своих подписчиков на события
  FEventList := TObjectList.Create;

  FPKFieldName := 'ID';

  // Создаём события
  FBeforeLoad := TNotifyEventsEx.Create(Self);
  FAfterLoad := TNotifyEventsEx.Create(Self);

  // Максимальное количество обновлённых записей в рамках одной транзакции
  FMaxUpdateRecCount := 1000;
end;

destructor TQueryBase.Destroy;
begin
  FreeAndNil(FEventList); // отписываемся от всех событий
  FreeAndNil(FBeforeLoad);
  FreeAndNil(FAfterLoad);
  inherited;
end;

procedure TQueryBase.AppendRows(AFieldName: string; AValues: TArray<String>);
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

procedure TQueryBase.AppendRows(AFieldNames, AValues: TArray<String>);
var
  AValue: string;
  i: Integer;
  m: TArray<String>;
begin
  Assert(Length(AFieldNames) > 0);

  // Добавляем в список родительские компоненты
  for AValue in AValues do
  begin
    // Делим строку на части по табуляции
    m := AValue.Split([#9]);

    if Length(m) = Length(AFieldNames) then
    begin
      TryAppend;

      // Заполняем все поля
      for i := Low(AFieldNames) to High(AFieldNames) do
      begin
        FDQuery.ParamByName(AFieldNames[i]).Value := m[i];
      end;

      TryPost;
    end
    else
      raise Exception.Create('Несоответствие количества полей');
  end;
end;

procedure TQueryBase.ApplyDelete(ASender: TDataSet; ARequest: TFDUpdateRequest;
  var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions);
begin
end;

procedure TQueryBase.ApplyInsert(ASender: TDataSet; ARequest: TFDUpdateRequest;
  var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions);
begin
end;

procedure TQueryBase.ApplyUpdate(ASender: TDataSet; ARequest: TFDUpdateRequest;
  var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions);
begin
end;

procedure TQueryBase.ApplyUpdates;
begin
  TryPost;
  if FDQuery.CachedUpdates then
  begin
    // Если все изменения прошли без ошибок
    if FDQuery.ApplyUpdates() = 0 then
      FDQuery.CommitUpdates;
  end
end;

procedure TQueryBase.AssignFrom(AFDQuery: TFDQuery);
begin
  Assert(AFDQuery <> nil);
  Assert(AFDQuery <> FDQuery);
  Assert(not AFDQuery.SQL.Text.IsEmpty);

  // Копируем базовый запрос
  FDQuery.SQL.Text := AFDQuery.SQL.Text;
  // Копируем параметры
  FDQuery.Params.Assign(AFDQuery.Params);
end;

// Есть-ли изменения не сохранённые в БД
function TQueryBase.GetHaveAnyChanges: Boolean;
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
    Result := FDQuery.Connection.InTransaction and GetHaveAnyNotCommitedChanges;
  end;

end;

procedure TQueryBase.CancelUpdates;
begin
  // отменяем все сделанные изменения на стороне клиента
  TryCancel;
  if FDQuery.CachedUpdates then
  begin
    FDQuery.CancelUpdates;
  end
end;

procedure TQueryBase.CascadeDelete(const AIDMaster: Variant;
  const ADetailKeyFieldName: String; AFromClientOnly: Boolean = False);
var
  E: TFDUpdateRecordEvent;
begin
  Assert(AIDMaster > 0);

  E := FDQuery.OnUpdateRecord;
  try
    // Если каскадное удаление уже реализовано на стороне сервера
    // Просто удалим эти записи с клиента ничего не сохраняя на стороне сервера
    if AFromClientOnly then
      FDQuery.OnUpdateRecord := FDQueryUpdateRecordOnClient;

    FDQuery.DisableControls;
    try
      // Пока есть записи подчинённые мастеру
      while FDQuery.LocateEx(ADetailKeyFieldName, AIDMaster, []) do
      begin
        FDQuery.Delete;
      end;
    finally
      FDQuery.EnableControls;
    end;

  finally
    if AFromClientOnly then
      FDQuery.OnUpdateRecord := E;
  end;

  // Формируем фильтр и удаляем
  // DeleteByFilter(Format('%s = %d', [ADetailKeyFieldName, AIDMaster]));
end;

procedure TQueryBase.ClearFields(AFieldList: TArray<String>;
  AProductIDList: TArray<Integer>);
var
  AFieldName: String;
  AID: Integer;
begin
  Assert(Length(AFieldList) > 0);
  Assert(Length(AProductIDList) > 0);

  FDQuery.DisableControls;
  try
    SaveBookmark;
    for AID in AProductIDList do
    begin
      if not LocateByPK(AID) then
        Continue;
      TryEdit;
      for AFieldName in AFieldList do
        Field(AFieldName).Value := NULL;
      TryPost;
    end;
    RestoreBookmark;
  finally
    FDQuery.EnableControls;
  end;
end;

procedure TQueryBase.ClearUpdateRecCount;
begin
  FUpdateRecCount := 0;
end;

procedure TQueryBase.CreateDefaultFields(AUpdate: Boolean);
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

procedure TQueryBase.DeleteByFilter(const AFilterExpression: string);
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

procedure TQueryBase.DeleteSelfDetail(AIDMaster: Variant);
begin
  // По умолчанию нет подчинённых своих-же записей
end;

procedure TQueryBase.DoOnQueryUpdateRecord(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  if ARequest in [arDelete, arInsert, arUpdate] then
  begin
    // try
    AAction := eaApplied;
    // Если произошло удаление
    if ARequest = arDelete then
    begin
      ApplyDelete(ASender, ARequest, AAction, AOptions);
    end;

    // Операция добавления записи на клиенте
    if ARequest = arInsert then
    begin
      ApplyInsert(ASender, ARequest, AAction, AOptions);
    end;

    // Операция обновления записи на клиенте
    if ARequest = arUpdate then
    begin
      ApplyUpdate(ASender, ARequest, AAction, AOptions);
    end;
    {
      except
      on E: Exception do
      begin
      AAction := eaFail;
      DoOnUpdateRecordException(E);
      end;
      end;
    }
  end
  else
    AAction := eaSkip;
end;

procedure TQueryBase.DoOnUpdateRecordException(AException: Exception);
begin
  raise AException;
end;

procedure TQueryBase.FDQueryBeforeOpen(DataSet: TDataSet);
begin;
end;

procedure TQueryBase.FDQueryUpdateRecordOnClient(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  AAction := eaApplied;
end;

procedure TQueryBase.FetchFields(const AFieldNames: TArray<String>;
  const AValues: TArray<Variant>; ARequest: TFDUpdateRequest;
  var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions);
var
  ASQL: string;
  i: Integer;
  S: string;
  V: Variant;
begin
  Assert(Low(AFieldNames) = Low(AValues));
  Assert(High(AFieldNames) = High(AValues));

  ASQL := 'SELECT ';
  for i := Low(AFieldNames) to High(AFieldNames) do
  begin
    V := AValues[i];
    if VarIsStr(V) then
      S := QuotedStr(V)
    else
    begin
      S := V;

      // Если у нас вещественное число,
      // надо в SQL запросе в качестве разделителя использовать точку
      if VarIsType(V, [varDouble, varCurrency]) then
        S := S.Replace(',', '.');
    end;
    S := S + ' ' + AFieldNames[i];

    if i > Low(AFieldNames) then
      ASQL := ASQL + ', ';
    ASQL := ASQL + S;
  end;

  case ARequest of
    arInsert:
      FDUpdateSQL.InsertSQL.Text := ASQL;
    arUpdate:
      FDUpdateSQL.ModifySQL.Text := ASQL;
  end;

  FDUpdateSQL.Apply(ARequest, AAction, AOptions);
end;

procedure TQueryBase.FetchFields(ARecordHolder: TRecordHolder;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
var
  ASQL: string;
  i: Integer;
  S: string;
  V: Variant;
begin
  ASQL := 'SELECT ';
  for i := 0 to ARecordHolder.Count - 1 do
  begin
    V := ARecordHolder[i].Value;
    if VarIsNull(V) then
      Continue;

    if VarIsStr(V) then
      S := QuotedStr(V)
    else
    begin
      S := V;

      // Если у нас вещественное число,
      // надо в SQL запросе в качестве разделителя использовать точку
      if VarIsType(V, [varDouble, varCurrency]) then
        S := S.Replace(',', '.');

    end;
    S := S + ' ' + ARecordHolder[i].FieldName;

    if i > 0 then
      ASQL := ASQL + ', ';
    ASQL := ASQL + S;
  end;

  case ARequest of
    arInsert:
      FDUpdateSQL.InsertSQL.Text := ASQL;
    arUpdate:
      FDUpdateSQL.ModifySQL.Text := ASQL;
  end;

  FDUpdateSQL.Apply(ARequest, AAction, AOptions);
end;

procedure TQueryBase.FetchFields(const AFetchFieldList: TFetchFieldList;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  Assert(AFetchFieldList <> nil);
  FetchFields(AFetchFieldList.FieldNames.ToArray,
    AFetchFieldList.FieldValues.ToArray, ARequest, AAction, AOptions);
end;

function TQueryBase.Field(const AFieldName: String): TField;
begin
  Result := FDQuery.FieldByName(AFieldName);
end;

function TQueryBase.GetCashedRecordBalance: Integer;
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

function TQueryBase.GetFDUpdateSQL: TFDUpdateSQL;
begin
  if FFDUpdateSQL = nil then
  begin
    FFDUpdateSQL := TFDUpdateSQL.Create(Self);
    FFDUpdateSQL.DataSet := FDQuery;
  end;
  Result := FFDUpdateSQL;
end;

function TQueryBase.GetFieldValues(AFieldName: string;
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

function TQueryBase.GetFieldValuesAsIntArray(AFieldName: string)
  : TArray<Integer>;
var
  AClone: TFDMemTable;
  AValue: Integer;
  L: TList<Integer>;
begin
  // Создаём список
  L := TList<Integer>.Create;
  // Создаём клона
  AClone := TFDMemTable.Create(Self);
  try
    AClone.CloneCursor(FDQuery);
    AClone.First;
    while not AClone.Eof do
    begin

      AValue := AClone.FieldByName(AFieldName).AsInteger;
      L.Add(AValue);

      AClone.Next;
    end;
    Result := L.ToArray;
  finally
    FreeAndNil(AClone);
    FreeAndNil(L);
  end;
end;

function TQueryBase.GetHaveAnyNotCommitedChanges: Boolean;
begin
  Result := True;
end;

function TQueryBase.GetParentValue: Integer;
begin
  Assert(DetailParameterName <> '');
  Result := FDQuery.Params.ParamByName(DetailParameterName).AsInteger;
end;

function TQueryBase.GetPK: TField;
begin
  Result := Field(FPKFieldName);
end;

procedure TQueryBase.IncUpdateRecCount;
begin
  Assert(FDQuery.Connection.InTransaction);
  Assert(FUpdateRecCount < FMaxUpdateRecCount);
  Inc(FUpdateRecCount);
  if FUpdateRecCount >= FMaxUpdateRecCount then
  begin
    // Делаем промежуточный коммит
    FDQuery.Connection.Commit;
    FUpdateRecCount := 0;
  end;
end;

function TQueryBase.InsertRecord(ARecordHolder: TRecordHolder): Integer;
var
  AFieldHolder: TFieldHolder;
  f: TField;
begin
  Assert(ARecordHolder <> nil);

  TryAppend;
  try
    for f in FDQuery.Fields do
    begin
      // Первичный ключ заполнять не будем
      if f.FieldName.ToUpper = PKFieldName.ToUpper then
        Continue;

      // Ищем такое поле в коллекции вставляемых значений
      AFieldHolder := ARecordHolder.Find(f.FieldName);

      // Если нашли
      if (AFieldHolder <> nil) and not VarIsNull(AFieldHolder.Value) then
      begin
        f.Value := AFieldHolder.Value;
      end;

    end;

    TryPost;
    // Первичный ключ должен получить значение
    Assert(not PK.IsNull);

    Result := PK.AsInteger;
  except
    TryCancel;
    raise;
  end;

end;

procedure TQueryBase.Load(AIDParent: Integer; AForcibly: Boolean = False);
begin
  Assert(DetailParameterName <> '');

  // Если есть необходимость в загрузке данных
  if (not FDQuery.Active) or (FDQuery.Params.ParamByName(DetailParameterName)
    .AsInteger <> AIDParent) or AForcibly then
  begin
    FBeforeLoad.CallEventHandlers(FDQuery);

    FDQuery.Close;
    FDQuery.Params.ParamByName(DetailParameterName).AsInteger := AIDParent;
    FDQuery.Open();

    FAfterLoad.CallEventHandlers(FDQuery);
  end;
end;

procedure TQueryBase.Load(const AParamNames: TArray<String>;
  const AParamValues: TArray<Variant>);
begin
  FDQuery.DisableControls;
  try
    FDQuery.Close;
    SetParameters(AParamNames, AParamValues);
    FDQuery.Open;
  finally
    FDQuery.EnableControls;
  end;
end;

function TQueryBase.LocateByField(const AFieldName: string;
  const AValue: Variant;
  AOptions: TFDDataSetLocateOptions = [lxoCaseInsensitive, lxoPartialKey]
  ): Boolean;
begin
  Assert(not AFieldName.IsEmpty);
  Result := FDQuery.LocateEx(AFieldName, AValue, AOptions);
end;

procedure TQueryBase.SetParameters(const AParamNames: TArray<String>;
  const AParamValues: TArray<Variant>);
var
  i: Integer;
begin
  Assert(Low(AParamNames) = Low(AParamValues));
  Assert(High(AParamNames) = High(AParamValues));

  for i := Low(AParamNames) to High(AParamNames) do
  begin
    FDQuery.ParamByName(AParamNames[i]).Value := AParamValues[i];
  end;
end;

function TQueryBase.LocateByPK(APKValue: Variant;
  TestResult: Boolean = False): Boolean;
begin
  Result := FDQuery.LocateEx(FPKFieldName, APKValue);
  if TestResult then
  begin
    if not Result then
      beep;

    Assert(Result);
  end;
end;

procedure TQueryBase.LocateByPKAndDelete(APKValue: Variant);
begin
  LocateByPK(APKValue, True);
  FDQuery.Delete;
end;

procedure TQueryBase.RefreshQuery;
begin
  FDQuery.DisableControls;
  try
    FDQuery.Close;
    FDQuery.Open();
  finally
    FDQuery.EnableControls;
  end;
end;

function TQueryBase.RestoreBookmark: Boolean;
begin
  Result := False;
  if VarIsNull(FBookmark) then
    Exit;
  Result := LocateByPK(FBookmark);
end;

procedure TQueryBase.SaveBookmark;
begin
  FBookmark := PK.Value;
end;

function TQueryBase.Search(const AParamNames: TArray<String>;
  const AParamValues: TArray<Variant>; TestResult: Integer = -1): Integer;
begin
  Load(AParamNames, AParamValues);

  Result := FDQuery.RecordCount;
  if TestResult >= 0 then
    Assert(Result = TestResult);
end;

procedure TQueryBase.SetConditionSQL(const ABaseSQL, AConditionSQL,
  AMark: string; ANotifyEventRef: TNotifyEventRef = nil);
begin
  Assert(not ABaseSQL.IsEmpty);
  Assert(not AConditionSQL.IsEmpty);
  Assert(not AMark.IsEmpty);

  FDQuery.DisableControls;
  try
    FDQuery.Close;
    FDQuery.SQL.Text := Replace(ABaseSQL, AConditionSQL, AMark);
    if Assigned(ANotifyEventRef) then
      ANotifyEventRef(Self);
    FDQuery.Open;
  finally
    FDQuery.EnableControls;
  end;
end;

procedure TQueryBase.SetFieldsRequired(ARequired: Boolean);
var
  AField: TField;
begin
  inherited;
  for AField in FDQuery.Fields do
    AField.Required := ARequired;
end;

procedure TQueryBase.SetFieldsReadOnly(AReadOnly: Boolean);
var
  AField: TField;
begin
  inherited;
  for AField in FDQuery.Fields do
    AField.ReadOnly := AReadOnly;
end;

procedure TQueryBase.SetParamType(const AParamName: String;
  AParamType: TParamType = ptInput; ADataType: TFieldType = ftInteger);
var
  AFDParam: TFDParam;
begin
  AFDParam := FDQuery.FindParam(AParamName);
  Assert(AFDParam <> nil);
  AFDParam.ParamType := AParamType;
  AFDParam.DataType := ADataType;
end;

function TQueryBase.TryEdit: Boolean;
begin
  Assert(FDQuery.Active);

  Result := False;
  if FDQuery.State in [dsEdit, dsInsert] then
    Exit;

  Assert(FDQuery.RecordCount > 0);
  FDQuery.Edit;
  Result := True;
end;

procedure TQueryBase.TryPost;
begin
  Assert(FDQuery.Active);

  if FDQuery.State in [dsEdit, dsInsert] then
    FDQuery.Post;
end;

procedure TQueryBase.TryCancel;
begin
  Assert(FDQuery.Active);

  if FDQuery.State in [dsEdit, dsInsert] then
    FDQuery.Cancel;
end;

procedure TQueryBase.TryAppend;
begin
  Assert(FDQuery.Active);

  if not(FDQuery.State in [dsEdit, dsInsert]) then
    FDQuery.Append;
end;

procedure TQueryBase.TryOpen;
begin
  if not FDQuery.Active then
    FDQuery.Open;
end;

procedure TQueryBase.UpdateFields(AFields: TArray<TField>;
  AValues: TArray<Variant>; AUpdateNullFieldsOnly: Boolean);
var
  f: TField;
  i: Integer;
  V: Variant;
begin
  Assert(FDQuery.State in [dsInsert, dsEdit]);

  Assert(Length(AFields) > 0);
  Assert(Length(AFields) = Length(AValues));

  // Обновляет пустые значения полей на значения из ADataSet
  for i := Low(AFields) to High(AFields) do
  begin
    f := AFields[i];
    V := AValues[i];

    // Если NULL или пустая строка
    if ((not AUpdateNullFieldsOnly) or (f.IsNull or f.AsString.Trim.IsEmpty))
      and (not VarIsNull(V) and (not VarToStr(V).Trim.IsEmpty)) then
      f.Value := V;
  end;
end;

function TQueryBase.UpdateRecord(ARecordHolder: TRecordHolder): Boolean;
var
  AChangedFields: TDictionary<String, Variant>;
  AFieldHolder: TFieldHolder;
  AFieldName: string;
  f: TField;
begin
  Assert(ARecordHolder <> nil);

  // Создаём словарь тех полей что нужно будет обновить
  AChangedFields := TDictionary<String, Variant>.Create;
  try

    for f in FDQuery.Fields do
    begin
      // Первичный ключ обновлять не будем
      if f.FieldName.ToUpper = PKFieldName.ToUpper then
        Continue;

      // Ищем такое поле в коллекции обновляемых значений
      AFieldHolder := ARecordHolder.Find(f.FieldName);

      // Запоминаем в словаре какое поле нужно будет обновить
      if (AFieldHolder <> nil) and (f.Value <> AFieldHolder.Value) then
        AChangedFields.Add(f.FieldName, AFieldHolder.Value);
    end;

    Result := AChangedFields.Count > 0;

    // Если есть те поля, которые нужно обновлять
    if Result then
    begin
      TryEdit;
      try
        // Цикл по всем изменившимся полям
        for AFieldName in AChangedFields.Keys do
        begin
          Field(AFieldName).Value := AChangedFields[AFieldName];
        end;
        TryPost;
      except
        TryCancel;
        raise;
      end;
    end;

  finally
    FreeAndNil(AChangedFields);
  end;
end;

constructor TFetchFieldList.Create;
begin
  FFieldNames := TList<String>.Create;
  FFieldValues := TList<Variant>.Create;
end;

destructor TFetchFieldList.Destroy;
begin
  FreeAndNil(FFieldNames);
  FreeAndNil(FFieldValues);
  inherited;
end;

procedure TFetchFieldList.Add(const AFieldName: String;
  const AFieldValue: Variant);
begin
  Assert(not AFieldName.IsEmpty);
  Assert(not VarIsNull(AFieldValue));

  FFieldNames.Add(AFieldName);
  FFieldValues.Add(AFieldValue);
end;

end.
