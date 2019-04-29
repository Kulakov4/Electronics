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

type
  TParamRec = record
    FieldName: String;
    Value: Variant;
    DataType: TFieldType;
    CaseInsensitive: Boolean;
    FullName: String;
    Operation: String;
  public
    constructor Create(const AFullName: String; const AValue: Variant;
      const ADataType: TFieldType = ftInteger;
      const ACaseInsensitive: Boolean = False; const AOperation: String = '=');
  end;

  TQueryBase = class(TFrame)
    FDQuery: TFDQuery;
    Label1: TLabel;
  private
    FAfterLoad: TNotifyEventsEx;
    FBeforeLoad: TNotifyEventsEx;
    FDetailParameterName: string;
    FFDUpdateRecordEvent: TFDUpdateRecordEvent;
    FFDUpdateSQL: TFDUpdateSQL;
    FMaxUpdateRecCount: Integer;
    FSQL: string;
    FUpdateRecCount: Integer;
  class var
    function GetCashedRecordBalance: Integer;
    function GetFDUpdateSQL: TFDUpdateSQL;
    function GetParentValue: Integer;
    procedure RefreshOrOpen; virtual;
    { Private declarations }
  protected
    FEventList: TObjectList;
    procedure ApplyDelete(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); virtual;
    procedure ApplyInsert(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); virtual;
    procedure ApplyUpdate(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); virtual;
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
    procedure AfterConstruction; override;
    procedure BeginApplyUpdatesOnClient;
    procedure ClearUpdateRecCount;
    procedure DeleteFromClient;
    procedure EndApplyUpdatesOnClient;
    procedure FetchFields(const AFieldNames: TArray<String>;
      const AValues: TArray<Variant>; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); overload;
    procedure FetchFields(ARecordHolder: TRecordHolder;
      ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
      AOptions: TFDUpdateRowOptions); overload;
    procedure IncUpdateRecCount;
    procedure Load(AIDParent: Integer; AForcibly: Boolean = False);
      overload; virtual;
    procedure Load(const AParamNames: TArray<String>;
      const AParamValues: TArray<Variant>); overload;
    procedure SetParameters(const AParamNames: TArray<String>;
      const AParamValues: TArray<Variant>);
    function Search(const AParamNames: TArray<String>;
      const AParamValues: TArray<Variant>; TestResult: Integer = -1)
      : Integer; overload;
    function SearchEx(AParams: TArray<TParamRec>; TestResult: Integer = -1;
      ASQL: String = ''): Integer;
    function SetParamType(const AParamName: String;
      AParamType: TParamType = ptInput; ADataType: TFieldType = ftInteger)
      : TFDParam;
    function SetParamTypeEx(const AParamName: String; AValue: Variant;
      AParamType: TParamType = ptInput; ADataType: TFieldType = ftInteger)
      : TFDParam;
    procedure UpdateFields(AFields: TArray<TField>; AValues: TArray<Variant>;
      AUpdateNullFieldsOnly: Boolean);
    property AfterLoad: TNotifyEventsEx read FAfterLoad;
    property BeforeLoad: TNotifyEventsEx read FBeforeLoad;
    property CashedRecordBalance: Integer read GetCashedRecordBalance;
    property DetailParameterName: string read FDetailParameterName
      write FDetailParameterName;
    property HaveAnyChanges: Boolean read GetHaveAnyChanges;
    property ParentValue: Integer read GetParentValue;
    property SQL: string read FSQL;
    { Public declarations }
  published
  end;

implementation

uses System.Math, RepositoryDataModule, StrHelper, MapFieldsUnit,
  System.StrUtils;

{$R *.dfm}
{ TfrmDataModule }

constructor TQueryBase.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  // Создаём список своих подписчиков на события
  FEventList := TObjectList.Create;

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

procedure TQueryBase.AfterConstruction;
begin
  inherited;
  // Сохраняем первоначальный SQL
  FSQL := FDQuery.SQL.Text;
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

procedure TQueryBase.BeginApplyUpdatesOnClient;
begin
  Assert(not Assigned(FFDUpdateRecordEvent));
  FFDUpdateRecordEvent := FDQuery.OnUpdateRecord;
  FDQuery.OnUpdateRecord := FDQueryUpdateRecordOnClient;
end;

procedure TQueryBase.EndApplyUpdatesOnClient;
begin
  Assert(Assigned(FFDUpdateRecordEvent));
  FDQuery.OnUpdateRecord := FFDUpdateRecordEvent;
  FFDUpdateRecordEvent := nil
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

procedure TQueryBase.ClearUpdateRecCount;
begin
  FUpdateRecCount := 0;
end;

procedure TQueryBase.DeleteFromClient;
begin
  Assert(FDQuery.RecordCount > 0);
  BeginApplyUpdatesOnClient;
  try
    FDQuery.Delete;
  finally
    EndApplyUpdatesOnClient;
  end;
end;

procedure TQueryBase.DoOnQueryUpdateRecord(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  AAction := eaApplied;

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
  // else
  // AAction := eaSkip;
end;

procedure TQueryBase.DoOnUpdateRecordException(AException: Exception);
begin
  raise AException;
end;

procedure TQueryBase.FDQueryUpdateRecordOnClient(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  inherited;
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
    Assert(not VarIsNull(V));
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

function TQueryBase.GetHaveAnyNotCommitedChanges: Boolean;
begin
  Result := True;
end;

function TQueryBase.GetParentValue: Integer;
begin
  Assert(DetailParameterName <> '');
  Result := FDQuery.Params.ParamByName(DetailParameterName).AsInteger;
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

procedure TQueryBase.Load(AIDParent: Integer; AForcibly: Boolean = False);
begin
  Assert(DetailParameterName <> '');

  // Если есть необходимость в загрузке данных
  if (not FDQuery.Active) or (FDQuery.Params.ParamByName(DetailParameterName)
    .AsInteger <> AIDParent) or AForcibly then
  begin
    FBeforeLoad.CallEventHandlers(FDQuery);

    FDQuery.Params.ParamByName(DetailParameterName).AsInteger := AIDParent;

    RefreshOrOpen;

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

procedure TQueryBase.RefreshOrOpen;
begin
  if FDQuery.Active then
    FDQuery.Refresh
  else
    FDQuery.Open;
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

function TQueryBase.Search(const AParamNames: TArray<String>;
  const AParamValues: TArray<Variant>; TestResult: Integer = -1): Integer;
begin
  Load(AParamNames, AParamValues);

  Result := FDQuery.RecordCount;
  if TestResult >= 0 then
    Assert(Result = TestResult);
end;

function TQueryBase.SearchEx(AParams: TArray<TParamRec>;
  TestResult: Integer = -1; ASQL: String = ''): Integer;
var
  AParamNames: TList<String>;
  AFormatStr: string;
  ANewValue: string;
  ANewSQL: string;
  AValues: TList<Variant>;
  i: Integer;
begin
  Assert(Length(AParams) > 0);

  // Восстанавливаем первоначальный SQL или используем заданный
  ANewSQL := IfThen(ASQL.IsEmpty, SQL, ASQL);

  for i := Low(AParams) to High(AParams) do
  begin
    // Если поиск нечувствительный к регистру
    if AParams[i].CaseInsensitive then
      AFormatStr := 'upper(%s) %s upper(:%s)'
    else
      AFormatStr := '%s %s :%s';

    ANewValue := Format(AFormatStr, [AParams[i].FullName, AParams[i].Operation,
      AParams[i].FieldName]);

    // Делаем замену в SQL запросе
    ANewSQL := ReplaceInSQL(ANewSQL, ANewValue, i);
  end;

  // Меняем SQL запрос
  FDQuery.SQL.Text := ANewSQL;

  AParamNames := TList<String>.Create;
  AValues := TList<Variant>.Create;
  try
    // Создаём параметры SQL запроса
    for i := Low(AParams) to High(AParams) do
    begin
      SetParamType(AParams[i].FieldName, ptInput, AParams[i].DataType);

      AParamNames.Add(AParams[i].FieldName);
      AValues.Add(AParams[i].Value);
    end;

    // Выполняем поиск
    Result := Search(AParamNames.ToArray, AValues.ToArray, TestResult);
  finally
    FreeAndNil(AParamNames);
    FreeAndNil(AValues);
  end;
end;

function TQueryBase.SetParamType(const AParamName: String;
  AParamType: TParamType = ptInput; ADataType: TFieldType = ftInteger)
  : TFDParam;
begin
  Result := FDQuery.FindParam(AParamName);
  Assert(Result <> nil);
  Result.ParamType := AParamType;
  Result.DataType := ADataType;
end;

function TQueryBase.SetParamTypeEx(const AParamName: String; AValue: Variant;
  AParamType: TParamType = ptInput; ADataType: TFieldType = ftInteger)
  : TFDParam;
begin
  Assert(not VarIsNull(AValue));
  Result := SetParamType(AParamName, AParamType, ADataType);
  Result.Value := AValue;
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

constructor TParamRec.Create(const AFullName: String; const AValue: Variant;
  const ADataType: TFieldType = ftInteger;
  const ACaseInsensitive: Boolean = False; const AOperation: String = '=');
var
  p: Integer;
begin
  inherited;
  Assert(not AFullName.IsEmpty);
  Assert(not VarIsNull(AValue));

  FullName := AFullName;
  p := FullName.IndexOf('.');
  FieldName := IfThen(p > 0, AFullName.Substring(p + 1), AFullName);
  Value := AValue;
  DataType := ADataType;
  CaseInsensitive := ACaseInsensitive;
  Operation := AOperation;

  if ACaseInsensitive then
    Assert(ADataType = ftWideString);
end;

end.
