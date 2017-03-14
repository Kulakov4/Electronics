unit BaseQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  NotifyEvents, System.Contnrs, System.Generics.Collections, ProgressInfo;

//  WM_NEED_POST = WM_USER + 558;


type
  TQueryBase = class(TFrame)
    FDQuery: TFDQuery;
    Label1: TLabel;
  private
    FAfterLoad: TNotifyEventsEx;
    FBeforeLoad: TNotifyEventsEx;
    FDetailParameterName: string;
    FPKFieldName: String;
    function GetCashedRecordBalance: Integer;
    function GetParentValue: Integer;
    function GetPKValue: Integer;
    { Private declarations }
  protected
    FEventList: TObjectList;
    procedure ApplyDelete(ASender: TDataSet); virtual;
    procedure ApplyInsert(ASender: TDataSet); virtual;
    procedure ApplyUpdate(ASender: TDataSet); virtual;
    procedure DeleteSelfDetail(AIDMaster: Variant); virtual;
// TODO: DoOnNeedPost
//  procedure DoOnNeedPost(var Message: TMessage); message WM_NEED_POST;
    procedure DoOnQueryUpdateRecord(ASender: TDataSet; ARequest: TFDUpdateRequest;
        var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions);
    function GetHaveAnyChanges: Boolean; virtual;
    function GetHaveAnyNotCommitedChanges: Boolean; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AppendRows(AFieldName: string; AValues: TArray<String>); virtual;
    procedure ApplyUpdates; virtual;
    procedure CancelUpdates; virtual;
    procedure CascadeDelete(const AIDMaster: Integer; const ADetailKeyFieldName:
        String); virtual;
    procedure CreateDefaultFields(AUpdate: Boolean);
    procedure DeleteByFilter(const AFilterExpression: string);
    procedure DeleteList(var AList: TList<Variant>);
    function Field(const AFieldName: String): TField;
    function GetFieldValues(AFieldName: string;
      ADelimiter: String = ','): String;
    procedure Load(AIDParent: Integer); overload; virtual;
    procedure Load(const AParamNames: array of string;
      const AParamValues: array of Variant); overload;
    function LocateByPK(APKValue: Variant): Boolean;
    procedure RefreshQuery; virtual;
    function Search(const AParamNames: array of string; const AParamValues: array
        of Variant): Integer; overload;
    procedure SetFieldsRequired(ARequired: Boolean);
    procedure SetFieldsReadOnly(AReadOnly: Boolean);
    procedure TryEdit;
    procedure TryPost; virtual;
    procedure TryCancel;
    procedure TryAppend;
    procedure TryOpen;
    property AfterLoad: TNotifyEventsEx read FAfterLoad;
    property BeforeLoad: TNotifyEventsEx read FBeforeLoad;
    property CashedRecordBalance: Integer read GetCashedRecordBalance;
    property DetailParameterName: string read FDetailParameterName
      write FDetailParameterName;
    property HaveAnyChanges: Boolean read GetHaveAnyChanges;
    property ParentValue: Integer read GetParentValue;
    property PKFieldName: String read FPKFieldName;
    property PKValue: Integer read GetPKValue;
    { Public declarations }
  published
  end;

implementation

uses System.Math, RepositoryDataModule;

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
end;

destructor TQueryBase.Destroy;
begin
  FreeAndNil(FEventList); // отписываемся от всех событий
  inherited;
end;

procedure TQueryBase.AppendRows(AFieldName: string; AValues:
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

procedure TQueryBase.ApplyDelete(ASender: TDataSet);
begin
end;

procedure TQueryBase.ApplyInsert(ASender: TDataSet);
begin
end;

procedure TQueryBase.ApplyUpdate(ASender: TDataSet);
begin
end;

procedure TQueryBase.ApplyUpdates;
begin
  if not FDQuery.CachedUpdates then
    raise Exception.Create('Не включен режим кэширования записей на клиенте');

  TryPost;

  FDQuery.ApplyUpdates();
  FDQuery.CommitUpdates;
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

function TQueryBase.GetPKValue: Integer;
begin
  Result := FDQuery.FieldByName(FPKFieldName).AsInteger;
end;

procedure TQueryBase.CancelUpdates;
begin
  // отменяем все сделанные изменения на стороне клиента
  TryCancel;
  FDQuery.CancelUpdates;
end;

procedure TQueryBase.CascadeDelete(const AIDMaster: Integer; const
    ADetailKeyFieldName: String);
begin
  Assert(AIDMaster > 0);

  // Формируем фильтр и удаляем
  DeleteByFilter(Format('%s = %d', [ADetailKeyFieldName, AIDMaster]));
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

procedure TQueryBase.DeleteList(var AList: TList<Variant>);
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

procedure TQueryBase.DeleteSelfDetail(AIDMaster: Variant);
begin
  // По умолчанию нет подчинённых своих-же записей
end;

procedure TQueryBase.DoOnQueryUpdateRecord(ASender: TDataSet; ARequest:
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
    raise;
  end;
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

function TQueryBase.GetHaveAnyNotCommitedChanges: Boolean;
begin
  Result := True;
end;

function TQueryBase.GetParentValue: Integer;
begin
  Assert(DetailParameterName <> '');
  Result := FDQuery.Params.ParamByName(DetailParameterName).AsInteger;
end;

procedure TQueryBase.Load(AIDParent: Integer);
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

procedure TQueryBase.Load(const AParamNames: array of string;
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

function TQueryBase.LocateByPK(APKValue: Variant): Boolean;
begin
  Result := FDQuery.LocateEx(FPKFieldName, APKValue);
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

function TQueryBase.Search(const AParamNames: array of string; const
    AParamValues: array of Variant): Integer;
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
  Result := FDQuery.RecordCount;
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

procedure TQueryBase.TryEdit;
begin
  Assert(FDQuery.Active);

  if not(FDQuery.State in [dsEdit, dsInsert]) then
    FDQuery.Edit;
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

end.
