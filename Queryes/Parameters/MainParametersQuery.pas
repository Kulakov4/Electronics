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
  ApplyQueryFrame, OrderQuery;

const
  WM_arInsert = WM_USER + 139;

type
  TQueryMainParameters = class(TQueryOrder)
    fdqBase: TFDQuery;
    ParametersApplyQuery: TfrmApplyQuery;
    fdqDeleteFromCategoryParams: TFDQuery;
  private
    FProductCategoryIDValue: Integer;
    FQuerySearchMainParameter: TQuerySearchMainParameter;
    FShowDuplicate: Boolean;
    FTableNameFilter: string;
    procedure DoAfterInsert(Sender: TObject);
    procedure DoAfterOpen(Sender: TObject);
    procedure DoBeforeOpen(Sender: TObject);
    procedure DoOnDataChange(Sender: TObject);
    function GetChecked: TField;
    function GetIDParameterType: TField;
    function GetIsCustomParameter: TField;
    function GetQuerySearchMainParameter: TQuerySearchMainParameter;
    function GetTableName: TField;
    function GetValue: TField;
    procedure SetShowDuplicate(const Value: Boolean);
    procedure SetTableNameFilter(const Value: string);
    { Private declarations }
  protected
    procedure ApplyDelete(ASender: TDataSet); override;
    procedure ApplyInsert(ASender: TDataSet; ARequest:
    TFDUpdateRequest; var AAction: TFDErrorAction; AOptions:
    TFDUpdateRowOptions); override;
    procedure ApplyUpdate(ASender: TDataSet); override;
    procedure DoAfterInsertMessage(var Message: TMessage); message WM_arInsert;
    function GetOrd: TField; override;
    property QuerySearchMainParameter: TQuerySearchMainParameter
      read GetQuerySearchMainParameter;
  public
    constructor Create(AOwner: TComponent); override;
    function GetCheckedPKValues: string;
    function Locate(const AFieldName, AValue: string): Boolean;
    function Lookup(AValue: string): Integer;
    property Checked: TField read GetChecked;
    property IDParameterType: TField read GetIDParameterType;
    property IsCustomParameter: TField read GetIsCustomParameter;
    property ProductCategoryIDValue: Integer read FProductCategoryIDValue
      write FProductCategoryIDValue;
    property ShowDuplicate: Boolean read FShowDuplicate write SetShowDuplicate;
    property TableName: TField read GetTableName;
    property TableNameFilter: string read FTableNameFilter
      write SetTableNameFilter;
    property Value: TField read GetValue;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses RepositoryDataModule, DBRecordHolder, System.StrUtils, StrHelper;

constructor TQueryMainParameters.Create(AOwner: TComponent);
begin
  inherited;

  // Копируем базовый запрос и параметры
  AssignFrom(fdqBase);

  FDQuery.OnUpdateRecord := DoOnQueryUpdateRecord;

  // Подписываемся на события
  TNotifyEventWrap.Create(AfterInsert, DoAfterInsert, FEventList);
  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, FEventList);
  TNotifyEventWrap.Create(BeforeOpen, DoBeforeOpen, FEventList);

  TNotifyEventWrap.Create(OnDataChange, DoOnDataChange, FEventList);

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

      // Тут надо удалить ссылки на этот параметр
      fdqDeleteFromCategoryParams.ParamByName('ParameterID').AsInteger :=
        AID.AsInteger;
      fdqDeleteFromCategoryParams.ExecSQL;
    finally
      FreeAndNil(RH);
    end;
  end
  else
  begin
    ParametersApplyQuery.DeleteRecord(AID.AsInteger);
  end;
end;

procedure TQueryMainParameters.ApplyInsert(ASender: TDataSet; ARequest:
    TFDUpdateRequest; var AAction: TFDErrorAction; AOptions:
    TFDUpdateRowOptions);
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
    if (i > 0) and (AID.AsInteger <> QuerySearchMainParameter.PK.AsInteger) then
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
      RH.Field[AID.FieldName] := QuerySearchMainParameter.PK.Value;
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
    if (i > 0) and (AID.AsInteger <> QuerySearchMainParameter.PK.AsInteger) then
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
      AID.Value := QuerySearchMainParameter.PK.Value;
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

  // Checked.FieldKind := fkInternalCalc;
  Checked.ReadOnly := False;

end;

procedure TQueryMainParameters.DoBeforeOpen(Sender: TObject);
begin
  SetParameters(['TableName', 'ProductCategoryID'],
    [FTableNameFilter, FProductCategoryIDValue]);

  if FDQuery.FieldCount = 0 then
  begin
    // Обновляем описания полей
    FDQuery.FieldDefs.Update;
    // Создаём поля по умолчанию
    CreateDefaultFields(False);
    Checked.FieldKind := fkInternalCalc;
  end;
end;

procedure TQueryMainParameters.DoOnDataChange(Sender: TObject);
begin
  // TryCommit;
end;

function TQueryMainParameters.GetChecked: TField;
begin
  Result := Field('Checked');
end;

function TQueryMainParameters.GetCheckedPKValues: string;
var
  AClone: TFDMemTable;
begin
  Result := '';
  AClone := TFDMemTable.Create(Self);
  try
    AClone.CloneCursor(FDQuery);
    // Фильтруем клона
    AClone.Filter := Format('%s = %d', [Checked.FieldName, 1]);
    AClone.Filtered := True;
    while not AClone.Eof do
    begin
      Result := Result + IfThen(Result.IsEmpty, '', ',');
      Result := Result + AClone.FieldByName(PKFieldName).AsString;
      AClone.Next;
    end;
  finally
    FreeAndNil(AClone);
  end;
end;

function TQueryMainParameters.GetIDParameterType: TField;
begin
  Result := Field('IDParameterType');
end;

function TQueryMainParameters.GetIsCustomParameter: TField;
begin
  Result := Field('IsCustomParameter');
end;

function TQueryMainParameters.GetOrd: TField;
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

function TQueryMainParameters.Locate(const AFieldName, AValue: string): Boolean;
begin
  Assert(not AFieldName.IsEmpty);
  Result := FDQuery.LocateEx(AFieldName, AValue,
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

procedure TQueryMainParameters.SetShowDuplicate(const Value: Boolean);
var
  ASQL: String;
begin
  if FShowDuplicate <> Value then
  begin
    FShowDuplicate := Value;

    ASQL := fdqBase.SQL.Text;
    if FShowDuplicate then
    begin
      ASQL := Replace(ASQL, '', '/* ShowDuplicate');
      ASQL := Replace(ASQL, '', 'ShowDuplicate */');
    end;

    FDQuery.Close;
    FDQuery.SQL.Text := ASQL;
    FDQuery.Open;
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

end.
