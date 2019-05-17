unit ParametersQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, DragHelper, System.Generics.Collections,
  NotifyEvents, SearchParameterQuery, ApplyQueryFrame, OrderQuery, DSWrap;

type
  TParameterW = class(TOrderW)
  private
    FChecked: TFieldWrap;
    FID: TFieldWrap;
    FCodeLetters: TFieldWrap;
    FDefinition: TFieldWrap;
    FIDParameterKind: TFieldWrap;
    FIDParameterType: TFieldWrap;
    FIsCustomParameter: TFieldWrap;
    FMeasuringUnit: TFieldWrap;
    FParamSubParamID: TFieldWrap;
    FProductCategoryID: TParamWrap;
    FTableName: TFieldWrap;
    FValue: TFieldWrap;
    FValueT: TFieldWrap;
  protected
    procedure DoAfterInsert(Sender: TObject);
    procedure DoBeforePost(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    property Checked: TFieldWrap read FChecked;
    property ID: TFieldWrap read FID;
    property CodeLetters: TFieldWrap read FCodeLetters;
    property Definition: TFieldWrap read FDefinition;
    property IDParameterKind: TFieldWrap read FIDParameterKind;
    property IDParameterType: TFieldWrap read FIDParameterType;
    property IsCustomParameter: TFieldWrap read FIsCustomParameter;
    property MeasuringUnit: TFieldWrap read FMeasuringUnit;
    property ParamSubParamID: TFieldWrap read FParamSubParamID;
    property ProductCategoryID: TParamWrap read FProductCategoryID;
    property TableName: TFieldWrap read FTableName;
    property Value: TFieldWrap read FValue;
    property ValueT: TFieldWrap read FValueT;
  end;

  TQueryParameters = class(TQueryOrder)
    fdqDeleteFromCategoryParams: TFDQuery;
  strict private
  private
    FCheckClone: TFDMemTable;
    FqSearchParameter: TQuerySearchParameter;
    FShowDuplicate: Boolean;
    FW: TParameterW;
    procedure DoAfterOpen(Sender: TObject);
    procedure DoBeforeOpen(Sender: TObject);
    function GetCheckClone: TFDMemTable;
    function GetqSearchParameter: TQuerySearchParameter;
    procedure SetShowDuplicate(const Value: Boolean);
    { Private declarations }
  protected
    procedure ApplyDelete(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure ApplyInsert(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure ApplyUpdate(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    function CreateDSWrap: TDSWrap; override;
    property CheckClone: TFDMemTable read GetCheckClone;
    property qSearchParameter: TQuerySearchParameter read GetqSearchParameter;
  public
    constructor Create(AOwner: TComponent); override;
    function ApplyFilter(ATableName: string): Integer;
    function GetCheckedValues(const AFieldName: String): string;
    function Lookup(AValue: string): Integer;
    function SearchByTableName(const ATableName: string): Integer;
    property ShowDuplicate: Boolean read FShowDuplicate write SetShowDuplicate;
    property W: TParameterW read FW;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses DBRecordHolder, System.StrUtils, StrHelper,
  BaseQuery, ErrorType, System.Math;

constructor TQueryParameters.Create(AOwner: TComponent);
begin
  inherited;
  FW := FDSWrap as TParameterW;

  FDQuery.OnUpdateRecord := DoOnQueryUpdateRecord;

  // Подписываемся на события
  TNotifyEventWrap.Create(W.AfterOpen, DoAfterOpen, W.EventList);
  TNotifyEventWrap.Create(W.BeforeOpen, DoBeforeOpen, W.EventList);

  AutoTransaction := False;
end;

procedure TQueryParameters.ApplyDelete(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  Assert(ASender = FDQuery);

  if W.PK.AsInteger <= 0 then
    Exit;

  // Если пытаемся удалить параметр "по умолчанию"
  if W.IsCustomParameter.F.AsBoolean then
  begin
    // Перемещаем параметр "По умолчанию" в "пустую" категорию
    qSearchParameter.SearchByID(W.PK.AsInteger, True);
    qSearchParameter.W.TryEdit;
    qSearchParameter.W.IDParameterType.F.Value := NULL;
    qSearchParameter.W.TryPost;

    // Тут надо удалить ссылки на этот параметр
    fdqDeleteFromCategoryParams.ParamByName(W.ParamSubParamID.FieldName)
      .AsInteger := W.ParamSubParamID.F.AsInteger;
    fdqDeleteFromCategoryParams.ExecSQL;
  end
  else
  begin
    qSearchParameter.SearchByID(W.PK.AsInteger, True);
    qSearchParameter.FDQuery.Delete;
  end;
end;

function TQueryParameters.ApplyFilter(ATableName: string): Integer;
var
  ASQL: string;
begin
  // Получаем первоначальный запрос
  ASQL := SQL;
  ASQL := ASQL.Replace('/* ShowDuplicate', '', [rfReplaceAll]);
  ASQL := ASQL.Replace('ShowDuplicate */', '', [rfReplaceAll]);

  if ATableName.IsEmpty then
  begin
    FDQuery.Close;
    FDQuery.SQL.Text := ASQL;
    FDQuery.Open;
    Result := FDQuery.RecordCount;
  end
  else
    Result := SearchEx([TParamRec.Create(W.TableName.FullName, ATableName,
      ftWideString)], -1, ASQL)
end;

procedure TQueryParameters.ApplyInsert(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
var
  AIsCustomParameter: Boolean;
  i: Integer;
  RH: TRecordHolder;
  AAIsCustomParameter: Integer;
begin
  Assert(ASender = FDQuery);
  Assert(not W.TableName.F.AsString.IsEmpty);

  AIsCustomParameter := False;

  RH := TRecordHolder.Create();
  try

    // Запоминаем поля, которые мы только-что отредактировали на клиенте
    RH.Attach(FDQuery, Format('%s;%s;%s;%s;%s', [W.PKFieldName,
      W.IsCustomParameter.FieldName, W.Checked.FieldName,
      W.ParamSubParamID.FieldName, W.Ord.FieldName]));

    // Ищем параметр "по умолчанию" с таким-же табличным именем
    i := qSearchParameter.SearchByTableName(W.TableName.F.AsString, True);
    // Если нашли параметр по умолчанию и с другим кодом
    if (i > 0) and (W.PK.AsInteger <> qSearchParameter.W.PK.AsInteger) then
    begin
      qSearchParameter.W.TryEdit;
      AIsCustomParameter := True;
    end
    else
    begin
      qSearchParameter.W.TryAppend;
    end;

    // Меняем поля
    RH.Put(qSearchParameter.FDQuery);
    qSearchParameter.W.IsCustomParameter.F.AsBoolean := AIsCustomParameter;

    // Сохраняем на сервере
    qSearchParameter.W.TryPost;

    AAIsCustomParameter := IfThen(AIsCustomParameter, 1, 0);

    // Производим обновление полей на стороне клиента
    FetchFields([W.PK.FieldName, W.IsCustomParameter.FieldName,
      W.ParamSubParamID.FieldName, '[' + W.Ord.FieldName + ']'],
      [qSearchParameter.W.PK.Value, AAIsCustomParameter,
      qSearchParameter.W.ParamSubParamID.F.Value,
      qSearchParameter.W.Order.F.Value], ARequest, AAction, AOptions);
  finally
    FreeAndNil(RH);
  end;
end;

procedure TQueryParameters.ApplyUpdate(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
var
  AID: Integer;
  AIsCustomEdited: Boolean;
  i: Integer;
  RH: TRecordHolder;
begin
  Assert(ASender = FDQuery);

  Assert(W.PK.AsInteger > 0);

  Assert(not W.TableName.F.AsString.IsEmpty);

  RH := TRecordHolder.Create();
  try
    // Копируем поля в буфер
    RH.Attach(FDQuery, Format('%s;%s;%s;%s', [W.PKFieldName,
      W.IsCustomParameter.FieldName, W.Checked.FieldName,
      W.ParamSubParamID.FieldName]));

    // Ищем параметр "по умолчанию" с таким-же табличным именем
    i := qSearchParameter.SearchByTableName(W.TableName.F.AsString, True);
    AIsCustomEdited := (i > 0) and
      (W.PK.AsInteger <> qSearchParameter.W.PK.AsInteger);

    // Если мы редактировали не параметр по умолчанию
    if not AIsCustomEdited then
      // Ищем ту запись, которую только-что редактировали на клиенте
      qSearchParameter.SearchByID(W.PK.AsInteger, True);

    // Меняем поля на сервере
    qSearchParameter.W.TryEdit;
    RH.Put(qSearchParameter.FDQuery);
    qSearchParameter.W.TryPost;
  finally
    FreeAndNil(RH);
  end;

  // Если мы редактировали параметр по умолчанию
  if AIsCustomEdited then
  begin
    AID := qSearchParameter.W.PK.AsInteger;

    // Удаляем ту запись, которую только-что редактировали на клиенте
    qSearchParameter.SearchByID(W.PK.AsInteger, True);
    qSearchParameter.FDQuery.Delete;

    // Меняем идентификатор той записи, что сейчас на клиенте
    FetchFields([W.PKFieldName, W.IsCustomParameter.FieldName], [AID, 1],
      ARequest, AAction, AOptions);
  end
end;

function TQueryParameters.CreateDSWrap: TDSWrap;
begin
  Result := TParameterW.Create(FDQuery);
end;

procedure TQueryParameters.DoAfterOpen(Sender: TObject);
begin
  W.Value.F.Required := True;

  W.Checked.F.ReadOnly := False;
end;

procedure TQueryParameters.DoBeforeOpen(Sender: TObject);
begin
  // Это постоянный параметр. Если галочки не нужны, то его значение = 0
  SetParameters([W.ProductCategoryID.FieldName],
    [W.ProductCategoryID.DefaultValue]);

  if FDQuery.FieldCount = 0 then
  begin
    // Обновляем описания полей и создаём поля по умолчанию
    W.CreateDefaultFields(True);
    W.Checked.F.FieldKind := fkInternalCalc;
  end;
end;

function TQueryParameters.GetCheckClone: TFDMemTable;
begin
  if FCheckClone = nil then
    FCheckClone := W.AddClone('');
  Result := FCheckClone;
end;

function TQueryParameters.GetCheckedValues(const AFieldName: String): string;
var
  AClone: TFDMemTable;
begin
  Assert(not AFieldName.IsEmpty);

  Result := '';
  AClone := W.AddClone(Format('%s = %d', [W.Checked.FieldName, 1]));
  try
    while not AClone.Eof do
    begin
      Result := Result + IfThen(Result.IsEmpty, '', ',') +
        AClone.FieldByName(AFieldName).AsString;
      AClone.Next;
    end;
  finally
    W.DropClone(AClone);
  end;
end;

function TQueryParameters.GetqSearchParameter: TQuerySearchParameter;
begin
  if FqSearchParameter = nil then
  begin
    FqSearchParameter := TQuerySearchParameter.Create(Self);
  end;

  Result := FqSearchParameter;
end;

function TQueryParameters.Lookup(AValue: string): Integer;
var
  V: Variant;
begin
  V := FDQuery.LookupEx(W.Value.FieldName, AValue, W.PKFieldName,
    [lxoCaseInsensitive]);
  if VarIsNull(V) then
    Result := 0
  else
    Result := V;
end;

function TQueryParameters.SearchByTableName(const ATableName: string): Integer;
begin
  Assert(not ATableName.IsEmpty);

  Result := SearchEx([TParamRec.Create(W.TableName.FullName, ATableName,
    ftWideString)]);
end;

procedure TQueryParameters.SetShowDuplicate(const Value: Boolean);
var
  ASQL: String;
begin
  if FShowDuplicate <> Value then
  begin
    FShowDuplicate := Value;

    // Получаем первоначальный запрос
    ASQL := SQL;
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

constructor TParameterW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'ID', '', True);
  FOrd := TFieldWrap.Create(Self, 'Order');
  FChecked := TFieldWrap.Create(Self, 'Checked');
  FCodeLetters := TFieldWrap.Create(Self, 'CodeLetters');
  FDefinition := TFieldWrap.Create(Self, 'Definition');
  FIDParameterKind := TFieldWrap.Create(Self, 'IDParameterKind');
  FIDParameterType := TFieldWrap.Create(Self, 'IDParameterType');
  FIsCustomParameter := TFieldWrap.Create(Self, 'IsCustomParameter');
  FIsCustomParameter.DefaultValue := False;

  FMeasuringUnit := TFieldWrap.Create(Self, 'MeasuringUnit');
  FParamSubParamID := TFieldWrap.Create(Self, 'ParamSubParamID');
  FTableName := TFieldWrap.Create(Self, 'TableName');
  FValue := TFieldWrap.Create(Self, 'Value', 'Наименование');
  FValueT := TFieldWrap.Create(Self, 'ValueT');

  // Параметры запроса
  FProductCategoryID := TParamWrap.Create(Self, 'cp.ProductCategoryID');
  FProductCategoryID.DefaultValue := 0;

  TNotifyEventWrap.Create(BeforePost, DoBeforePost, EventList);
  TNotifyEventWrap.Create(AfterInsert, DoAfterInsert, EventList);
end;

procedure TParameterW.DoAfterInsert(Sender: TObject);
begin
  FIsCustomParameter.F.Value := FIsCustomParameter.DefaultValue;
end;

procedure TParameterW.DoBeforePost(Sender: TObject);
begin
  // Если не заполнили табличное имя, то табличное имя = наименование
  if TableName.F.AsString.IsEmpty then
  begin
    TableName.F.AsString := Value.F.AsString;
  end;
end;

end.
