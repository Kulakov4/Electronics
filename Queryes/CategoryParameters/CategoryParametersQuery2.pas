unit CategoryParametersQuery2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, QueryWithDataSourceUnit,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, NotifyEvents, RecursiveParametersQuery,
  DragHelper, System.Generics.Collections, DBRecordHolder,
  SearchParamSubParamQuery, System.Generics.Defaults;

type
  TRecHolderList = class(TObjectList<TRecordHolder>)
  public
  end;

  TQueryCategoryParameters2 = class(TQueryWithDataSource)
  private
    FDeletedSubParams: TRecHolderList;
    FEditedSubParams: TRecHolderList;
    FInsertedClone: TFDMemTable;
    FInsertedSubParams: TRecHolderList;
    FMaxOrder: Integer;
    FOn_ApplyUpdates: TNotifyEventsEx;
    FPKDictionary: TDictionary<Integer, Integer>;
    FQueryRecursiveParameters: TQueryRecursiveParameters;
    FRefreshQry: TQueryCategoryParameters2;
    procedure DoAfterInsert(Sender: TObject);
    procedure DoAfterOpen(Sender: TObject);
    procedure DoBeforePost(Sender: TObject);
    function GetCategoryID: TField;
    function GetHaveInserted: Boolean;
    function GetIDParameter: TField;
    function GetIDParameterKind: TField;
    function GetIdSubParameter: TField;
    function GetIsAttribute: TField;
    function GetIsDefault: TField;
    function GetIsEnabled: TField;
    function GetName: TField;
    function GetOrd: TField;
    function GetParameterType: TField;
    function GetParamSubParamId: TField;
    function GetPosID: TField;
    function GetProductCategoryID: TField;
    function GetQueryRecursiveParameters: TQueryRecursiveParameters;
    function GetRefreshQry: TQueryCategoryParameters2;
    function GetTableName: TField;
    function GetTranslation: TField;
    function GetValue: TField;
    function GetValueT: TField;
    { Private declarations }
  protected
    procedure ApplyDelete(ASender: TDataSet); override;
    procedure ApplyInsert(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure ApplyUpdate(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure DoOnUpdateRecordException(AException: Exception); override;
    property QueryRecursiveParameters: TQueryRecursiveParameters
      read GetQueryRecursiveParameters;
    property RefreshQry: TQueryCategoryParameters2 read GetRefreshQry;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure FilterByPosition(APosID: Integer);
    procedure AppendR(AParamSubParamId, AOrd, AIsAttribute, APosID,
      AIDParameter, AIDSubParameter: Integer; const AValue, ATableName, AValueT,
      AParameterType, AName: String; const ATranslation: Variant;
      AIsDefault: Integer);
    procedure ApplyUpdates; override;
    procedure CancelUpdates; override;
    procedure ClearSubParamsRecHolders;
    function CreateSubParamsClone: TFDMemTable;
    procedure FilterByIsDefault(AIsDefault: Integer);
    function GetAllIDSubParamList: string;
    procedure IncOrder(AStartOrder: Integer);
    function Locate(AIDParameter, APosID, AOrder: Integer;
      TestResult: Boolean = False): Boolean; overload;
    function Locate(AIDParameter, AIDSubParameter: Integer;
      TestResult: Boolean = False): Boolean; overload;
    procedure LocateDefault(AIDParameter: Integer; TestResult: Boolean = False);
    procedure Move(AData: TArray < TPair < Integer, Integer >> );
    function NextEx: Boolean;
    function NextOrder: Integer;
    function SearchAnalog(AProductCategoryID: Integer): Integer;
    procedure SetPos(APosID: Integer); overload;
    procedure SetPos(AIDArray: TArray<Integer>; APosID: Integer); overload;
    property CategoryID: TField read GetCategoryID;
    property DeletedSubParams: TRecHolderList read FDeletedSubParams;
    property EditedSubParams: TRecHolderList read FEditedSubParams;
    property HaveInserted: Boolean read GetHaveInserted;
    property IDParameter: TField read GetIDParameter;
    property IDParameterKind: TField read GetIDParameterKind;
    property IdSubParameter: TField read GetIdSubParameter;
    property InsertedSubParams: TRecHolderList read FInsertedSubParams;
    property IsAttribute: TField read GetIsAttribute;
    property IsDefault: TField read GetIsDefault;
    property IsEnabled: TField read GetIsEnabled;
    property Name: TField read GetName;
    property Ord: TField read GetOrd;
    property ParameterType: TField read GetParameterType;
    property ParamSubParamId: TField read GetParamSubParamId;
    property PKDictionary: TDictionary<Integer, Integer> read FPKDictionary;
    property PosID: TField read GetPosID;
    property ProductCategoryID: TField read GetProductCategoryID;
    property TableName: TField read GetTableName;
    property Translation: TField read GetTranslation;
    property Value: TField read GetValue;
    property ValueT: TField read GetValueT;
    property On_ApplyUpdates: TNotifyEventsEx read FOn_ApplyUpdates;
    { Public declarations }
  end;

implementation

uses
  MaxCategoryParameterOrderQuery, System.StrUtils, StrHelper,
  ParameterKindEnum, UpdateParameterValuesParamSubParamQuery;

{$R *.dfm}

constructor TQueryCategoryParameters2.Create(AOwner: TComponent);
begin
  inherited;
  DetailParameterName := 'ProductCategoryID';
  // Будем сохранять в БД изменения рекурсивно
  FDQuery.OnUpdateRecord := DoOnQueryUpdateRecord;

  // Создаём клон
  FInsertedClone := AddClone('');
  FInsertedClone.FilterChanges := [rtInserted];

  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, FEventList);
  TNotifyEventWrap.Create(BeforePost, DoBeforePost, FEventList);
  TNotifyEventWrap.Create(AfterInsert, DoAfterInsert, FEventList);

  FDeletedSubParams := TRecHolderList.Create;
  FEditedSubParams := TRecHolderList.Create;
  FInsertedSubParams := TRecHolderList.Create;

  FPKDictionary := TDictionary<Integer, Integer>.Create;

  FOn_ApplyUpdates := TNotifyEventsEx.Create(Self);

  // Не будем сами начинать транзакцию!!!
  // Работаем в режиме кэширования записей
  // AutoTransaction := True;
end;

destructor TQueryCategoryParameters2.Destroy;
begin
  FreeAndNil(FEditedSubParams);
  FreeAndNil(FDeletedSubParams);
  FreeAndNil(FInsertedSubParams);
  FreeAndNil(FPKDictionary);
  inherited;
end;

procedure TQueryCategoryParameters2.FilterByPosition(APosID: Integer);
begin
  Assert(APosID >= 0);
  FDQuery.Filter := Format('%s=%d', [PosID.FieldName, APosID]);
  FDQuery.Filtered := True;
end;

procedure TQueryCategoryParameters2.AppendR(AParamSubParamId, AOrd,
  AIsAttribute, APosID, AIDParameter, AIDSubParameter: Integer;
  const AValue, ATableName, AValueT, AParameterType, AName: String;
  const ATranslation: Variant; AIsDefault: Integer);
begin
  TryAppend;
  ParamSubParamId.Value := AParamSubParamId;
  Ord.Value := AOrd;
  IsAttribute.Value := AIsAttribute;
  PosID.Value := APosID;
  IDParameter.Value := AIDParameter;
  IdSubParameter.Value := AIDSubParameter;
  Value.Value := AValue;
  TableName.Value := ATableName;
  ValueT.Value := AValueT;
  ParameterType.Value := AParameterType;
  Name.Value := AName;
  Translation.Value := ATranslation;
  IsDefault.Value := AIsDefault;
  TryPost;
end;

procedure TQueryCategoryParameters2.ApplyDelete(ASender: TDataSet);
begin
  Assert(ASender = FDQuery);
  // Рекурсивно удаляем из категорий сам параметр
  QueryRecursiveParameters.ExecDeleteSQL(ParamSubParamId.OldValue,
    CategoryID.OldValue);

  // Запоминаем, какаой подпараметр мы удалили
  FDeletedSubParams.Add(TRecordHolder.Create(FDQuery));

  // Удаляем данные удалённого параметра
  TqUpdateParameterValuesParamSubParam.DoDelete(ParamSubParamId.AsInteger,
    ProductCategoryID.AsInteger);

end;

procedure TQueryCategoryParameters2.ApplyInsert(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  Assert(ASender = FDQuery);

  // Рекурсивно вставляем записи в БД
  QueryRecursiveParameters.ExecInsertSQL(PosID.Value, Ord.Value,
    ParamSubParamId.Value, CategoryID.Value);

  // Выбираем вставленную запись чтобы узнать её идентификатор
  RefreshQry.Load([DetailParameterName, 'ParamSubParamID'],
    [CategoryID.Value, ParamSubParamId.Value]);

  // Должна быть выбрана только одна запись
  // Иначе - нарушено ограничение уникальности
  Assert(RefreshQry.FDQuery.RecordCount = 1);
  Assert(RefreshQry.PK.AsInteger > 0);

  // Запоминаем, какой был первичный ключ, и какой он стал
  FPKDictionary.Add(PK.AsInteger, RefreshQry.PK.AsInteger);

  // Заполняем первычный ключ у вставленной записи
  FetchFields([PK.FieldName], [RefreshQry.PK.Value], ARequest, AAction,
    AOptions);
  // AID.AsInteger := RefreshQry.PK.Value;

  // Запоминаем, вставленную запись
  FInsertedSubParams.Add(TRecordHolder.Create(FDQuery));
end;

procedure TQueryCategoryParameters2.ApplyUpdate(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
var
  ARecHolder: TRecordHolder;
begin
  Assert(ASender = FDQuery);

  if ((PosID.OldValue <> PosID.Value) or (Ord.OldValue <> Ord.Value)) then
  begin
    // Одновременно с изменением позиции или порядка ничего больше не должно меняться
    Assert(IsAttribute.OldValue = IsAttribute.Value);
    Assert(ParamSubParamId.OldValue = ParamSubParamId.Value);

    QueryRecursiveParameters.ExecUpdateOrdSQL(PosID.OldValue, PosID.Value,
      Ord.OldValue, Ord.Value, ParamSubParamId.AsInteger, CategoryID.AsInteger);
  end;

  // Если изменилось что-то другое
  if (IsAttribute.OldValue <> IsAttribute.Value) or
    (ParamSubParamId.OldValue <> ParamSubParamId.Value) then
  begin
    Assert(PosID.OldValue = PosID.Value);
    Assert(Ord.OldValue = Ord.Value);

    QueryRecursiveParameters.ExecUpdateSQL(PosID.OldValue, PosID.Value,
      Ord.OldValue, Ord.Value, IsAttribute.OldValue, IsAttribute.Value,
      ParamSubParamId.OldValue, ParamSubParamId.AsInteger,
      CategoryID.AsInteger);

    ARecHolder := TRecordHolder.Create(FDQuery);
    ARecHolder.Field[ParamSubParamId.FieldName] := ParamSubParamId.OldValue;
    FEditedSubParams.Add(ARecHolder);

    // Переносим данные с со старого подпараметра на новый
    TqUpdateParameterValuesParamSubParam.DoUpdate(ParamSubParamId.AsInteger,
      ParamSubParamId.OldValue, ProductCategoryID.AsInteger);

  end;
end;

procedure TQueryCategoryParameters2.ApplyUpdates;
begin
  FPKDictionary.Clear;
  inherited;
  // Чтобы в следующий раз его вычислить
  FMaxOrder := 0;
  FOn_ApplyUpdates.CallEventHandlers(Self);
end;

procedure TQueryCategoryParameters2.CancelUpdates;
begin
  inherited;
  FMaxOrder := 0;
  ClearSubParamsRecHolders;
end;

procedure TQueryCategoryParameters2.ClearSubParamsRecHolders;
begin
  FInsertedSubParams.Clear;
  FDeletedSubParams.Clear;
  FEditedSubParams.Clear;
end;

function TQueryCategoryParameters2.CreateSubParamsClone: TFDMemTable;
var
  AIDList: TList<Integer>;
  AIDParameter: Integer;
  AFilter: string;
  AID: Integer;
  AIsDefault: Integer;
  S: string;
begin
  // Возвращает клон, содержащий либо сам параметр, либо его подпараметры
  Assert(FDQuery.RecordCount > 0);

  AIDParameter := IDParameter.AsInteger;
  AIsDefault := IsDefault.AsInteger;

  // Список идентификаторов, стоящих рядом и принадлежащих одному параметру
  AIDList := TList<Integer>.Create;
  try
    FDQuery.DisableControls;
    try
      SaveBookmark;
      // Сначала пытаемся двигаться вверх по набору данных
      while (IDParameter.AsInteger = AIDParameter) and
        (IsDefault.AsInteger = AIsDefault) and (not FDQuery.Bof) do
        FDQuery.Prior;

      if not FDQuery.Bof then
      begin
        Assert((IDParameter.AsInteger <> AIDParameter) or
          (IsDefault.AsInteger <> AIsDefault));

        FDQuery.Next;
      end;

      Assert((IDParameter.AsInteger = AIDParameter) and
        (IsDefault.AsInteger = AIsDefault));
      // Теперь пытаемся двигаться вниз, по набору данных
      while (IDParameter.AsInteger = AIDParameter) and
        (IsDefault.AsInteger = AIsDefault) and (not FDQuery.Eof) do
      begin
        AIDList.Add(PK.AsInteger);
        FDQuery.Next;
      end;

      // Возвращаемся на то же место
      RestoreBookmark;
    finally
      FDQuery.EnableControls;
    end;

    Assert(AIDList.Count > 0);
    S := '';
    for AID in AIDList do
    begin
      S := S + IfThen(S.IsEmpty, '', ',') + AID.ToString;
    end;
  finally
    FreeAndNil(AIDList);
  end;

  AFilter := Format('%s in (%s)', [PKFieldName, S]);
  Result := AddClone(AFilter);

end;

procedure TQueryCategoryParameters2.DoAfterInsert(Sender: TObject);
begin
  IsEnabled.AsInteger := 1;
  IsAttribute.AsInteger := 1;
end;

procedure TQueryCategoryParameters2.DoAfterOpen(Sender: TObject);
begin
  SetFieldsReadOnly(False);
  FMaxOrder := 0;
end;

procedure TQueryCategoryParameters2.DoBeforePost(Sender: TObject);
begin
  ProductCategoryID.AsInteger := ParentValue;
end;

procedure TQueryCategoryParameters2.DoOnUpdateRecordException
  (AException: Exception);
const
  S = 'UNIQUE constraint failed: CategoryParams2.ProductCategoryId, CategoryParams2.ParamSubParamId';
  ErrorMessage = 'Ошибка.'#13#10#13#10 +
    'Недопускается появление двух одинаковых параметров.'#13#10#13#10 +
    'Действие отменено';
var
  E: Exception;
begin
  if AException.Message.IndexOf(S) >= 0 then
    E := Exception.Create(ErrorMessage)
  else
    E := AException;

  raise E;
end;

procedure TQueryCategoryParameters2.FilterByIsDefault(AIsDefault: Integer);
begin
  Assert(AIsDefault >= 0);
  FDQuery.Filter := Format('%s=%d', [IsDefault.FieldName, AIsDefault]);
  FDQuery.Filtered := True;
end;

function TQueryCategoryParameters2.GetAllIDSubParamList: string;
var
  AClone: TFDMemTable;
  AFilter: string;
begin
  Result := '';

  // Все подпараметры, кроме подпараметра "по умолчанию"
  AFilter := Format('%s = (%d) and %s = 0', [IDParameter.FieldName,
    IDParameter.AsInteger, IsDefault.FieldName]);
  AClone := AddClone(AFilter);
  try
    while not AClone.Eof do
    begin
      Result := Result + IfThen(Result.IsEmpty, '', ',') +
        AClone.FieldByName(IdSubParameter.FieldName).AsString;
      AClone.Next;
    end;
  finally
    DropClone(AClone);
  end;
end;

function TQueryCategoryParameters2.GetCategoryID: TField;
begin
  Result := Field('ProductCategoryID');
end;

function TQueryCategoryParameters2.GetHaveInserted: Boolean;
begin
  FInsertedClone.FilterChanges := [rtInserted];
  Result := FDQuery.Active and (FInsertedClone.RecordCount > 0);
end;

function TQueryCategoryParameters2.GetIDParameter: TField;
begin
  Result := Field('IdParameter');
end;

function TQueryCategoryParameters2.GetIDParameterKind: TField;
begin
  Result := Field('IDParameterKind');
end;

function TQueryCategoryParameters2.GetIdSubParameter: TField;
begin
  Result := Field('IdSubParameter');
end;

function TQueryCategoryParameters2.GetIsAttribute: TField;
begin
  Result := Field('IsAttribute');
end;

function TQueryCategoryParameters2.GetIsDefault: TField;
begin
  Result := Field('IsDefault');
end;

function TQueryCategoryParameters2.GetIsEnabled: TField;
begin
  Result := Field('IsEnabled');
end;

function TQueryCategoryParameters2.GetName: TField;
begin
  Result := Field('Name');
end;

function TQueryCategoryParameters2.GetOrd: TField;
begin
  Result := Field('Ord');
end;

function TQueryCategoryParameters2.GetParameterType: TField;
begin
  Result := Field('ParameterType');
end;

function TQueryCategoryParameters2.GetParamSubParamId: TField;
begin
  Result := Field('ParamSubParamID');
end;

function TQueryCategoryParameters2.GetPosID: TField;
begin
  Result := Field('PosID');
end;

function TQueryCategoryParameters2.GetProductCategoryID: TField;
begin
  Result := Field('ProductCategoryID');
end;

function TQueryCategoryParameters2.GetQueryRecursiveParameters
  : TQueryRecursiveParameters;
begin
  if FQueryRecursiveParameters = nil then
    FQueryRecursiveParameters := TQueryRecursiveParameters.Create(Self);
  Result := FQueryRecursiveParameters;
end;

function TQueryCategoryParameters2.GetRefreshQry: TQueryCategoryParameters2;
begin
  if FRefreshQry = nil then
  begin
    FRefreshQry := TQueryCategoryParameters2.Create(Self);
    // Добавляем в текст SQL запроса условие с параметром
    FRefreshQry.FDQuery.SQL.Text := FRefreshQry.FDQuery.SQL.Text.Replace
      ('and 0=0', 'and 0=0 and ParamSubParamId = :ParamSubParamID');

    FRefreshQry.SetParamType('ParamSubParamID');
  end;

  Result := FRefreshQry;
end;

function TQueryCategoryParameters2.GetTableName: TField;
begin
  Result := Field('Tablename');
end;

function TQueryCategoryParameters2.GetTranslation: TField;
begin
  Result := Field('Translation');
end;

function TQueryCategoryParameters2.GetValue: TField;
begin
  Result := Field('Value');
end;

function TQueryCategoryParameters2.GetValueT: TField;
begin
  Result := Field('ValueT');
end;

procedure TQueryCategoryParameters2.IncOrder(AStartOrder: Integer);
var
  A: TArray<TPair<Integer, Integer>>;
  AClone: TFDMemTable;
  D: TDictionary<Integer, Integer>;
  AComparer: IComparer<TPair<Integer, Integer>>;
  I: Integer;
begin
  D := TDictionary<Integer, Integer>.Create;
  try
    AClone := AddClone(Format('%s >= %d', [Ord.FieldName, AStartOrder]));
    try
      while not AClone.Eof do
      begin
        D.Add(AClone.FieldByName(PKFieldName).AsInteger,
          AClone.FieldByName(Ord.FieldName).AsInteger);
        AClone.Next;
      end;
    finally
      DropClone(AClone);
    end;
    A := D.ToArray;
  finally
    FreeAndNil(D);
  end;

  // Правило для сравнения элементов массива
  AComparer := TComparer < TPair < Integer, Integer >>.Construct(
    function(const Left, Right: TPair<Integer, Integer>): Integer
    begin
      Result := -1 * TComparer<Integer>.Default.Compare(Left.Value,
        Right.Value);
    end);
  // Сортируем массив по Ord в обратном порядке
  TArray.Sort < TPair < Integer, Integer >> (A, AComparer);

  // Увеличиваем на 1 Ord
  for I := Low(A) to High(A) do
    A[I].Value := A[I].Value + 1;

  SaveBookmark;
  // Просим произвести изменения в БД
  Move(A);
  RestoreBookmark;
end;

function TQueryCategoryParameters2.Locate(AIDParameter, APosID, AOrder: Integer;
TestResult: Boolean = False): Boolean;
var
  AFieldNames: string;
begin
  Assert(AIDParameter > 0);
  Assert(APosID >= 0);
  Assert(AOrder > 0);

  AFieldNames := Format('%s;%s;%s', [IDParameter.FieldName, PosID.FieldName,
    Ord.FieldName]);

  Result := FDQuery.LocateEx(AFieldNames,
    VarArrayOf([AIDParameter, APosID, AOrder]));

  if TestResult then
    Assert(Result);
end;

function TQueryCategoryParameters2.Locate(AIDParameter, AIDSubParameter
  : Integer; TestResult: Boolean = False): Boolean;
var
  AFieldNames: string;
begin
  Assert(AIDParameter > 0);
  Assert(AIDSubParameter >= 0);

  AFieldNames := Format('%s;%s', [IDParameter.FieldName,
    IdSubParameter.FieldName]);

  Result := FDQuery.LocateEx(AFieldNames,
    VarArrayOf([AIDParameter, AIDSubParameter]));

  if TestResult then
    Assert(Result);
end;

procedure TQueryCategoryParameters2.LocateDefault(AIDParameter: Integer;
TestResult: Boolean = False);
var
  AFieldName: string;
begin
  Assert(AIDParameter > 0);
  AFieldName := Format('%s;%s', [IDParameter.FieldName, IsDefault.FieldName]);
  FDQuery.LocateEx(AFieldName, VarArrayOf([AIDParameter, 1]));
end;

procedure TQueryCategoryParameters2.Move(AData: TArray < TPair < Integer,
  Integer >> );
var
  APair: TPair<Integer, Integer>;
begin
  FDQuery.DisableControls;
  try
    for APair in AData do
    begin
      // Переходим на нужную запись
      LocateByPK(APair.Key, True);
      // Меняем порядок записи
      TryEdit;
      Ord.AsInteger := APair.Value;
      TryPost;
    end;
  finally
    FDQuery.EnableControls;
  end;
end;

function TQueryCategoryParameters2.NextEx: Boolean;
var
  AIDParameter: Integer;
  AIsDefault: Integer;
begin
  Assert(not FDQuery.Eof);

  AIDParameter := IDParameter.AsInteger;
  AIsDefault := IsDefault.AsInteger;

  FDQuery.Next;

  // Мы всё ещё в той же группе?
  Result := (IDParameter.AsInteger = AIDParameter) and
    (IsDefault.AsInteger = AIsDefault) and (not FDQuery.Eof);
end;

function TQueryCategoryParameters2.NextOrder: Integer;
begin
  if FMaxOrder = 0 then
    FMaxOrder := TQueryMaxCategoryParameterOrder.Max_Order;
  Inc(FMaxOrder);
  Result := FMaxOrder;
end;

function TQueryCategoryParameters2.SearchAnalog(AProductCategoryID
  : Integer): Integer;
begin
  Assert(AProductCategoryID > 0);

  // Добавляем в запрос условие
  FDQuery.SQL.Text := Replace(FDQuery.SQL.Text,
    Format('and (p.IDParameterKind <> %d)',
    [Integer(Неиспользуется)]), 'and 0=0');

  // Ищем
  Result := Search(['ProductCategoryID'], [AProductCategoryID]);
end;

procedure TQueryCategoryParameters2.SetPos(APosID: Integer);
begin
  Assert(FDQuery.RecordCount > 0);
  Assert((APosID >= 0) and (APosID <= 2));

  TryEdit;
  PosID.AsInteger := APosID;
  TryPost;
end;

procedure TQueryCategoryParameters2.SetPos(AIDArray: TArray<Integer>;
APosID: Integer);
var
  AID: Integer;
begin
  for AID in AIDArray do
  begin
    LocateByPK(AID, True);
    SetPos(APosID);
  end;
end;

end.
