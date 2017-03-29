unit MainParametersQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, DragHelper, System.Generics.Collections,
  NotifyEvents, QueryWithDataSourceUnit, SearchMainParameterQuery,
  ApplyQueryFrame;

const
  WM_arInsert = WM_USER + 139;

type
  TQueryMainParameters = class(TQueryWithDataSource)
    FDQuery2: TFDQuery;
    ParametersApplyQuery: TfrmApplyQuery;
  private
    FQuerySearchMainParameter: TQuerySearchMainParameter;
    FRecOrderList: TList<TRecOrder>;
    FShowDublicate: Boolean;
    FTableNameFilter: string;
    procedure DoAfterInsert(Sender: TObject);
    procedure DoAfterOpen(Sender: TObject);
    procedure DoBeforeOpen(Sender: TObject);
    function GetIDParameterType: TField;
    function GetIsCustomParameter: TField;
    function GetOrder: TField;
    function GetQuerySearchMainParameter: TQuerySearchMainParameter;
    function GetTableName: TField;
    function GetValue: TField;
    procedure SetShowDublicate(const Value: Boolean);
    procedure SetTableNameFilter(const Value: string);
    { Private declarations }
  protected
    procedure ApplyDelete(ASender: TDataSet); override;
    procedure ApplyInsert(ASender: TDataSet); override;
    procedure ApplyUpdate(ASender: TDataSet); override;
    procedure DoAfterInsertMessage(var Message: TMessage); message WM_arInsert;
    procedure DoOnUpdateOrder(ARecOrder: TRecOrder);
    procedure UpdateOrder;
    property QuerySearchMainParameter: TQuerySearchMainParameter
      read GetQuerySearchMainParameter;
  public
    constructor Create(AOwner: TComponent); override;
    function Locate(const AValue: string): Boolean;
    function Lookup(AValue: string): Integer;
    procedure MoveDSRecord(AStartDrag: TStartDrag; ADropDrag: TDropDrag);
    property IDParameterType: TField read GetIDParameterType;
    property IsCustomParameter: TField read GetIsCustomParameter;
    property Order: TField read GetOrder;
    property ShowDublicate: Boolean read FShowDublicate write SetShowDublicate;
    property TableName: TField read GetTableName;
    property TableNameFilter: string read FTableNameFilter
      write SetTableNameFilter;
    property Value: TField read GetValue;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses RepositoryDataModule, DBRecordHolder;

constructor TQueryMainParameters.Create(AOwner: TComponent);
begin
  inherited;
  FRecOrderList := TList<TRecOrder>.Create;

  FDQuery.OnUpdateRecord := DoOnQueryUpdateRecord;

  // Подписываемся на события
  TNotifyEventWrap.Create(AfterInsert, DoAfterInsert, FEventList);
  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, FEventList);
  TNotifyEventWrap.Create(BeforeOpen, DoBeforeOpen, FEventList);

  AutoTransaction := False;
end;

procedure TQueryMainParameters.ApplyDelete(ASender: TDataSet);
var
  AID: TField;
  AIsCustomParameter: TField;
  RH: TRecordHolder;
begin
  AID := ASender.FieldByName(PKFieldName);
  AIsCustomParameter := ASender.FieldByName(IsCustomParameter.FieldName);

  if AID.AsInteger <= 0 then
    Exit;

  // Если пытаемся удалить параметр "по умолчанию"
  if AIsCustomParameter.AsBoolean then
  begin
    RH := TRecordHolder.Create(ASender);
    try
      RH.Find(IDParameterType.FieldName).Value := NULL;
      ParametersApplyQuery.UpdateRecord(RH);
    finally
      FreeAndNil(RH);
    end;
  end
  else
  begin
    ParametersApplyQuery.DeleteRecord(AID.AsInteger);
  end;
end;

procedure TQueryMainParameters.ApplyInsert(ASender: TDataSet);
var
  AID: TField;
  AIsCustomParameter: TField;
  ATableName: TField;
  i: Integer;
  RH: TRecordHolder;
  RH2: TRecordHolder;
begin
  AID := ASender.FieldByName(PKFieldName);
  ATableName := ASender.FieldByName(TableName.FieldName);
  AIsCustomParameter := ASender.FieldByName(IsCustomParameter.FieldName);

  // Если не заполнили табличное имя, то табличное имя = наименование
  if ATableName.AsString.IsEmpty then
    ATableName.AsString := Value.AsString;

  RH := TRecordHolder.Create(ASender);
  try
    // Ищем параметр "по умолчанию" с таким-же табличным именем
    i := QuerySearchMainParameter.Search(ATableName.AsString, True);
    // Если нашли и с другим кодом
    if (i > 0) and (AID.AsInteger <> QuerySearchMainParameter.PKValue) then
    begin
      // Копируем поля в буфер кроме IsCustomParameter
      RH.Attach(ASender, IsCustomParameter.FieldName);

      RH2 := TRecordHolder.Create(QuerySearchMainParameter.FDQuery);
      try
        // Заполняем пустые поля
        RH.UpdateNullValues(RH2);
      finally
        FreeAndNil(RH2);
      end;
      // Заполняем идентификатор той записи, которую будем редактировать
      RH.Field[AID.FieldName] := QuerySearchMainParameter.PKValue;
      // Обновляем имеющуюся запись в БД
      ParametersApplyQuery.UpdateRecord(RH);
      // Обновляем вставленную запись на клиенте
      RH.Put(ASender);
      AIsCustomParameter.AsBoolean := True;
    end
    else
    begin
      // Копируем поля в буфер
      RH.Attach(ASender);
      // Вставляем запись на сервере и обновляем ID на клиенте
      AID.AsInteger := ParametersApplyQuery.InsertRecord(RH);
    end;
    // Заплатка.
    // PostMessage(Handle, WM_arInsert, AID.AsInteger, 0);
  finally
    FreeAndNil(RH);
  end;
end;

procedure TQueryMainParameters.ApplyUpdate(ASender: TDataSet);
var
  AID: TField;
  AIsCustomParameter: TField;
  ATableName: TField;
  i: Integer;
  RH: TRecordHolder;
begin
  AID := ASender.FieldByName(PKFieldName);
  ATableName := ASender.FieldByName(TableName.FieldName);
  AIsCustomParameter := ASender.FieldByName(IsCustomParameter.FieldName);

  Assert(AID.AsInteger > 0);

  if ATableName.AsString.IsEmpty then
    raise EAbort.Create('Табличное имя не должно быть пустым');

  RH := TRecordHolder.Create();
  try
    // Ищем параметр "по умолчанию" с таким-же табличным именем
    i := QuerySearchMainParameter.Search(ATableName.AsString, True);
    // Если нашли и с другим кодом
    if (i > 0) and (AID.AsInteger <> QuerySearchMainParameter.PKValue) then
    begin
      // Будем копировать из изменившейся записи в имеющуюся
      // Копируем поля в буфер
      RH.Attach(ASender, Format('%s;%s', [PKFieldName,
        IsCustomParameter.FieldName]));
      if RH.Count > 0 then
      begin
        QuerySearchMainParameter.TryEdit;
        // Меняем поля
        RH.Put(QuerySearchMainParameter.FDQuery);
        QuerySearchMainParameter.TryPost;
      end;

      // Удаляем ту запись, которую только-что редактировали на клиенте
      ParametersApplyQuery.DeleteRecord(AID.AsInteger);

      // Меняем идентификатор той записи, что сейчас на клиенте
      AID.AsInteger := QuerySearchMainParameter.PKValue;
      // Помечаем, что мы имеем дело с параметром "по умолчанию"
      AIsCustomParameter.AsBoolean := True;
      // Заплатка.
      // PostMessage(Handle, WM_arInsert, AID.AsInteger, 0);

    end
    else
    begin
      // Копируем поля в буфер
      RH.Attach(ASender);
      ParametersApplyQuery.UpdateRecord(RH);
    end;
  finally
    FreeAndNil(RH);
  end;
end;

procedure TQueryMainParameters.DoAfterInsert(Sender: TObject);
begin
  FDQuery.FieldByName('IsCustomParameter').AsBoolean := False;
end;

procedure TQueryMainParameters.DoAfterInsertMessage(var Message: TMessage);
var
  AID: Integer;
begin
  AID := Message.WParam;

  if LocateByPK(AID) then
  begin
    FDQuery.Edit;
    FDQuery.Post;
  end;
end;

procedure TQueryMainParameters.DoAfterOpen(Sender: TObject);
begin
  Value.DisplayLabel := 'Наименование';
  Value.Required := True;
end;

procedure TQueryMainParameters.DoBeforeOpen(Sender: TObject);
begin
  FDQuery.ParamByName('TableName').AsString := FTableNameFilter;
end;

procedure TQueryMainParameters.DoOnUpdateOrder(ARecOrder: TRecOrder);
begin
  Order.Value := ARecOrder.Order;
end;

function TQueryMainParameters.GetIDParameterType: TField;
begin
  Result := Field('IDParameterType');
end;

function TQueryMainParameters.GetIsCustomParameter: TField;
begin
  Result := Field('IsCustomParameter');
end;

function TQueryMainParameters.GetOrder: TField;
begin
  Result := Field('Order');
end;

function TQueryMainParameters.GetQuerySearchMainParameter
  : TQuerySearchMainParameter;
begin
  if FQuerySearchMainParameter = nil then
  begin
    FQuerySearchMainParameter := TQuerySearchMainParameter.Create(Self);
  end;

  Result := FQuerySearchMainParameter;
end;

function TQueryMainParameters.GetTableName: TField;
begin
  Result := Field('TableName');
end;

function TQueryMainParameters.GetValue: TField;
begin
  Result := Field('Value');
end;

function TQueryMainParameters.Locate(const AValue: string): Boolean;
begin
  Result := FDQuery.LocateEx(Value.FieldName, AValue,
    [lxoCaseInsensitive, lxoPartialKey]);
end;

function TQueryMainParameters.Lookup(AValue: string): Integer;
var
  V: Variant;
begin
  V := FDQuery.LookupEx(Value.FieldName, AValue, PKFieldName,
    [lxoCaseInsensitive]);
  if VarIsNull(V) then
    Result := 0
  else
    Result := V;
end;

procedure TQueryMainParameters.MoveDSRecord(AStartDrag: TStartDrag;
  ADropDrag: TDropDrag);
var
  AClone: TFDMemTable;
  AKeyField: TField;
  ANewOrderValue: Integer;
  AOrderField: TField;
  // ARecOrder: TRecOrder;
  i: Integer;
  IsDown: Boolean;
  IsUp: Boolean;
  Sign: Integer;
begin

  // Готовимся обновить порядок параметров
  AClone := TFDMemTable.Create(Self);
  try
    AClone.CloneCursor(FDQuery);
    AClone.First;

    // Если был перенос вверх
    IsUp := (ADropDrag.OrderValue < AStartDrag.MinOrderValue);
    // Если был перенос вниз
    IsDown := not IsUp;

    AOrderField := AClone.FieldByName(Order.FieldName);
    AKeyField := AClone.FieldByName(PKFieldName);

    while not AClone.Eof do
    begin
      Sign := 0;

      // Если перетаскиваем вверх
      if IsUp and (AOrderField.AsInteger >= ADropDrag.OrderValue) and
        (AOrderField.AsInteger < AStartDrag.MinOrderValue) then
        Sign := 1;

      // Если перетаскиваем вниз
      if IsDown and (AOrderField.AsInteger <= ADropDrag.OrderValue) and
        (AOrderField.AsInteger > AStartDrag.MaxOrderValue) then
        Sign := -1;

      // Если текущую запись нужно сместить
      if Sign <> 0 then
      begin
        // Запоминаем, что нужно изменить
        FRecOrderList.Add(TRecOrder.Create(AKeyField.AsInteger,
          AOrderField.AsInteger + Sign * Length(AStartDrag.Keys)));
      end;

      AClone.Next;
    end;

    ANewOrderValue := ADropDrag.OrderValue;
    if IsDown then
      ANewOrderValue := ADropDrag.OrderValue - Length(AStartDrag.Keys) + 1;

    for i := Low(AStartDrag.Keys) to High(AStartDrag.Keys) do
    begin
      // Запоминаем, что нужно изменить
      FRecOrderList.Add(TRecOrder.Create(AStartDrag.Keys[i],
        ANewOrderValue + i));
    end;
  finally
    FreeAndNil(AClone);
  end;

  // Выполняем все изменения
  UpdateOrder;

end;

procedure TQueryMainParameters.SetShowDublicate(const Value: Boolean);
var
  ASQL: TStringList;
begin
  if FShowDublicate <> Value then
  begin
    FShowDublicate := Value;

    ASQL := TStringList.Create;
    try
      ASQL.Assign(FDQuery.SQL);

      FDQuery.Close;
      FDQuery.SQL.Assign(FDQuery2.SQL);
      FDQuery.Open;

      FDQuery2.SQL.Assign(ASQL);
    finally
      FreeAndNil(ASQL)
    end;
  end;
end;

procedure TQueryMainParameters.SetTableNameFilter(const Value: string);
begin
  if FTableNameFilter <> Value then
  begin
    FTableNameFilter := Value;
    FDQuery.Close;
    FDQuery.Open;
  end;
end;

procedure TQueryMainParameters.UpdateOrder;
var
  APKValue: Integer;
  i: Integer;
  Ok: Boolean;
begin
  if FRecOrderList.Count = 0 then
  begin
    Exit;
  end;

  FDQuery.DisableControls;
  try
    APKValue := PKValue;
    try
      // Теперь поменяем порядок
      for i := 0 to FRecOrderList.Count - 1 do
      begin
        Ok := FDQuery.Locate(PKFieldName, FRecOrderList[i].Key, []);
        Assert(Ok);

        FDQuery.Edit;
        DoOnUpdateOrder(FRecOrderList[i]);
        FDQuery.Post;
      end;

      for i := 0 to FRecOrderList.Count - 1 do
        FRecOrderList[i].Free;
      FRecOrderList.Clear;
    finally
      FDQuery.Locate(PKFieldName, APKValue, []);
    end;
  finally
    FDQuery.EnableControls;
  end;

end;

end.
