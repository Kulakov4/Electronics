unit MainParametersQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, DragHelper, System.Generics.Collections,
  NotifyEvents, QueryWithDataSourceUnit, SearchParameterQuery,
  ApplyQueryFrame, OrderQuery;

type
  TQueryMainParameters = class(TQueryOrder)
    fdqBase: TFDQuery;
    ParametersApplyQuery: TfrmApplyQuery;
    fdqDeleteFromCategoryParams: TFDQuery;
  private
    FProductCategoryIDValue: Integer;
    FqSearchParameter: TQuerySearchParameter;
    FShowDuplicate: Boolean;
    FTableNameFilter: string;
    procedure DoAfterInsert(Sender: TObject);
    procedure DoAfterOpen(Sender: TObject);
    procedure DoBeforeOpen(Sender: TObject);
    function GetChecked: TField;
    function GetIDParameterKind: TField;
    function GetIDParameterType: TField;
    function GetParamSubParamID: TField;
    function GetIsCustomParameter: TField;
    function GetqSearchParameter: TQuerySearchParameter;
    function GetTableName: TField;
    function GetValue: TField;
    function GetValueT: TField;
    procedure SetShowDuplicate(const Value: Boolean);
    procedure SetTableNameFilter(const Value: string);
    { Private declarations }
  protected
    procedure ApplyDelete(ASender: TDataSet); override;
    procedure ApplyInsert(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure ApplyUpdate(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    function GetOrd: TField; override;
    property qSearchParameter: TQuerySearchParameter read GetqSearchParameter;
  public
    constructor Create(AOwner: TComponent); override;
    function GetCheckedValues(const AFieldName: String): string;
    function Lookup(AValue: string): Integer;
    property Checked: TField read GetChecked;
    property IDParameterKind: TField read GetIDParameterKind;
    property IDParameterType: TField read GetIDParameterType;
    property ParamSubParamID: TField read GetParamSubParamID;
    property IsCustomParameter: TField read GetIsCustomParameter;
    property ProductCategoryIDValue: Integer read FProductCategoryIDValue
      write FProductCategoryIDValue;
    property ShowDuplicate: Boolean read FShowDuplicate write SetShowDuplicate;
    property TableName: TField read GetTableName;
    property TableNameFilter: string read FTableNameFilter
      write SetTableNameFilter;
    property Value: TField read GetValue;
    property ValueT: TField read GetValueT;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses DBRecordHolder, System.StrUtils, StrHelper,
  BaseQuery;

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

procedure TQueryMainParameters.ApplyInsert(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
var
  AFetchList: TFetchFieldList;
  AID: Integer;
  ATableName: string;
  i: Integer;
  RH: TRecordHolder;
  RH2: TRecordHolder;
begin
  Assert(ASender = FDQuery);

  AFetchList := TFetchFieldList.Create;
  RH := TRecordHolder.Create(ASender);
  try
    ATableName := TableName.AsString;
    // Если не заполнили табличное имя, то табличное имя = наименование
    if ATableName.IsEmpty then
    begin
      AFetchList.Add(TableName.FieldName, Value.AsString);
      ATableName := Value.AsString;
    end;

    // Ищем параметр "по умолчанию" с таким-же табличным именем
    i := qSearchParameter.SearchMain(ATableName, True);
    // Если нашли и с другим кодом
    if (i > 0) and (PK.AsInteger <> qSearchParameter.PK.AsInteger) then
    begin
      // Копируем поля в буфер кроме IsCustomParameter
      RH.Attach(ASender, IsCustomParameter.FieldName);

      RH2 := TRecordHolder.Create(qSearchParameter.FDQuery);
      try
        // Заполняем пустые поля
        RH.UpdateNullValues(RH2);
      finally
        FreeAndNil(RH2);
      end;
      // Заполняем идентификатор той записи, которую будем редактировать
      RH.Field[PK.FieldName] := qSearchParameter.PK.Value;

      // Обновляем имеющуюся запись в БД
      ParametersApplyQuery.UpdateRecord(RH);

      // Обновляем вставленную запись на клиенте
      AFetchList.Add(PK.FieldName, qSearchParameter.PK.Value);
      AFetchList.Add(IsCustomParameter.FieldName, 1);
      // RH.Put(FDQuery);
      // IsCustomParameter.AsBoolean := True;
    end
    else
    begin
      // Копируем поля в буфер
      RH.Attach(FDQuery);
      // Вставляем запись на сервере и обновляем ID на клиенте
      AID := ParametersApplyQuery.InsertRecord(RH);
      AFetchList.Add(PK.FieldName, AID);
    end;

    // Производим обновление полей на стороне клиента
    FetchFields(AFetchList, ARequest, AAction, AOptions);
  finally
    FreeAndNil(RH);
    FreeAndNil(AFetchList);
  end;
end;

procedure TQueryMainParameters.ApplyUpdate(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
var
  i: Integer;
  RH: TRecordHolder;
begin
  Assert(ASender = FDQuery);

  Assert(PK.AsInteger > 0);

  if TableName.AsString.IsEmpty then
    raise EAbort.Create('Табличное имя не должно быть пустым');

  RH := TRecordHolder.Create();
  try
    // Ищем параметр "по умолчанию" с таким-же табличным именем
    i := qSearchParameter.SearchMain(TableName.AsString, True);
    // Если нашли и с другим кодом
    if (i > 0) and (PK.AsInteger <> qSearchParameter.PK.AsInteger) then
    begin
      // Будем копировать из изменившейся записи в имеющуюся
      // Копируем поля в буфер
      RH.Attach(ASender, Format('%s;%s', [PKFieldName,
        IsCustomParameter.FieldName]));
      if RH.Count > 0 then
      begin
        qSearchParameter.TryEdit;
        // Меняем поля
        RH.Put(qSearchParameter.FDQuery);
        qSearchParameter.TryPost;
      end;

      // Удаляем ту запись, которую только-что редактировали на клиенте
      ParametersApplyQuery.DeleteRecord(PK.AsInteger);

      // Меняем идентификатор той записи, что сейчас на клиенте
      FetchFields([PK.FieldName], [qSearchParameter.PK.Value], ARequest,
        AAction, AOptions);
      // AID.Value := qSearchParameter.PK.Value;
      // Помечаем, что мы имеем дело с параметром "по умолчанию"
      IsCustomParameter.AsBoolean := True;
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

procedure TQueryMainParameters.DoAfterOpen(Sender: TObject);
begin
  Value.DisplayLabel := 'Наименование';
  Value.Required := True;

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

function TQueryMainParameters.GetChecked: TField;
begin
  Result := Field('Checked');
end;

function TQueryMainParameters.GetCheckedValues(const AFieldName : String):
    string;
var
  AClone: TFDMemTable;
begin
  Assert(not AFieldName.IsEmpty);

  Result := '';
  AClone := AddClone(Format('%s = %d', [Checked.FieldName, 1]));
  try
    while not AClone.Eof do
    begin
      Result := Result + IfThen(Result.IsEmpty, '', ',') +
        AClone.FieldByName(AFieldName).AsString;
      AClone.Next;
    end;
  finally
    DropClone(AClone);
  end;
end;

function TQueryMainParameters.GetIDParameterKind: TField;
begin
  Result := Field('IDParameterKind');
end;

function TQueryMainParameters.GetIDParameterType: TField;
begin
  Result := Field('IDParameterType');
end;

function TQueryMainParameters.GetParamSubParamID: TField;
begin
  Result := Field('ParamSubParamID');
end;

function TQueryMainParameters.GetIsCustomParameter: TField;
begin
  Result := Field('IsCustomParameter');
end;

function TQueryMainParameters.GetOrd: TField;
begin
  Result := Field('Order');
end;

function TQueryMainParameters.GetqSearchParameter: TQuerySearchParameter;
begin
  if FqSearchParameter = nil then
  begin
    FqSearchParameter := TQuerySearchParameter.Create(Self);
  end;

  Result := FqSearchParameter;
end;

function TQueryMainParameters.GetTableName: TField;
begin
  Result := Field('TableName');
end;

function TQueryMainParameters.GetValue: TField;
begin
  Result := Field('Value');
end;

function TQueryMainParameters.GetValueT: TField;
begin
  Result := Field('ValueT');
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
      ASQL := ASQL.Replace('/* ShowDuplicate', '', [rfReplaceAll]);
      ASQL := ASQL.Replace('ShowDuplicate */', '', [rfReplaceAll]);
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
