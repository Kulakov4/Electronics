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
  SearchParamSubParamQuery, System.Generics.Defaults, DSWrap;

type
  TRecHolderList = class(TObjectList<TRecordHolder>)
  public
  end;

  TCategoryParameters2W = class(TDSWrap)
  private
    FCategoryID: TFieldWrap;
    FID: TFieldWrap;
    FIDParameter: TFieldWrap;
    FIDParameterKind: TFieldWrap;
    FIdSubParameter: TFieldWrap;
    FIsAttribute: TFieldWrap;
    FIsDefault: TFieldWrap;
    FIsEnabled: TFieldWrap;
    FName: TFieldWrap;
    FOrd: TFieldWrap;
    FParameterType: TFieldWrap;
    FParamSubParamId: TFieldWrap;
    FPosID: TFieldWrap;
    FProductCategoryID: TFieldWrap;
    FTableName: TFieldWrap;
    FTranslation: TFieldWrap;
    FValue: TFieldWrap;
    FValueT: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AppendR(AParamSubParamId, AOrd, AIsAttribute, APosID,
      AIDParameter, AIDSubParameter: Integer; const AValue, ATableName, AValueT,
      AParameterType, AName: String; const ATranslation: Variant;
      AIsDefault: Integer);
    procedure FilterByIsDefault(AIsDefault: Integer);
    procedure FilterByPosition(APosID: Integer);
    function Locate(AIDParameter, APosID, AOrder: Integer;
      TestResult: Boolean = False): Boolean; overload;
    function Locate(AIDParameter, AIDSubParameter: Integer;
      TestResult: Boolean = False): Boolean; overload;
    procedure LocateDefault(AIDParameter: Integer; TestResult: Boolean = False);
    procedure Move(AData: TArray < TPair < Integer, Integer >> );
    function NextEx: Boolean;
    procedure SetPos(APosID: Integer); overload;
    procedure SetPos(AIDArray: TArray<Integer>; APosID: Integer); overload;
    property CategoryID: TFieldWrap read FCategoryID;
    property ID: TFieldWrap read FID;
    property IDParameter: TFieldWrap read FIDParameter;
    property IDParameterKind: TFieldWrap read FIDParameterKind;
    property IdSubParameter: TFieldWrap read FIdSubParameter;
    property IsAttribute: TFieldWrap read FIsAttribute;
    property IsDefault: TFieldWrap read FIsDefault;
    property IsEnabled: TFieldWrap read FIsEnabled;
    property Name: TFieldWrap read FName;
    property Ord: TFieldWrap read FOrd;
    property ParameterType: TFieldWrap read FParameterType;
    property ParamSubParamId: TFieldWrap read FParamSubParamId;
    property PosID: TFieldWrap read FPosID;
    property ProductCategoryID: TFieldWrap read FProductCategoryID;
    property TableName: TFieldWrap read FTableName;
    property Translation: TFieldWrap read FTranslation;
    property Value: TFieldWrap read FValue;
    property ValueT: TFieldWrap read FValueT;
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
    FW: TCategoryParameters2W;
    procedure DoAfterInsert(Sender: TObject);
    procedure DoAfterOpen(Sender: TObject);
    procedure DoBeforePost(Sender: TObject);
    function GetHaveInserted: Boolean;
    function GetQueryRecursiveParameters: TQueryRecursiveParameters;
    function GetRefreshQry: TQueryCategoryParameters2;
    { Private declarations }
  protected
    procedure ApplyDelete(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure ApplyInsert(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure ApplyUpdate(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    function CreateDSWrap: TDSWrap; override;
    procedure DoOnUpdateRecordException(AException: Exception); override;
    property QueryRecursiveParameters: TQueryRecursiveParameters
      read GetQueryRecursiveParameters;
    property RefreshQry: TQueryCategoryParameters2 read GetRefreshQry;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AfterConstruction; override;
    procedure ApplyUpdates; override;
    procedure CancelUpdates; override;
    procedure ClearSubParamsRecHolders;
    function CreateSubParamsClone: TFDMemTable;
    function GetAllIDSubParamList: string;
    procedure IncOrder(AStartOrder: Integer);
    function NextOrder: Integer;
    function SearchAnalog(AProductCategoryID: Integer): Integer;
    procedure SetIsAttribute(AID, AIsAttribute: Integer);
    property DeletedSubParams: TRecHolderList read FDeletedSubParams;
    property EditedSubParams: TRecHolderList read FEditedSubParams;
    property HaveInserted: Boolean read GetHaveInserted;
    property InsertedSubParams: TRecHolderList read FInsertedSubParams;
    property PKDictionary: TDictionary<Integer, Integer> read FPKDictionary;
    property W: TCategoryParameters2W read FW;
    property On_ApplyUpdates: TNotifyEventsEx read FOn_ApplyUpdates;
    { Public declarations }
  end;

implementation

uses
  MaxCategoryParameterOrderQuery, System.StrUtils, StrHelper,
  ParameterKindEnum, UpdateParameterValuesParamSubParamQuery, BaseQuery;

{$R *.dfm}

constructor TQueryCategoryParameters2.Create(AOwner: TComponent);
begin
  inherited;
  FW := FDSWrap as TCategoryParameters2W;
  DetailParameterName := W.ProductCategoryID.FieldName;

  // Будем сохранять в БД изменения рекурсивно
  FDQuery.OnUpdateRecord := DoOnQueryUpdateRecord;

  // Создаём клон
  FInsertedClone := W.AddClone('');
  FInsertedClone.FilterChanges := [rtInserted];

  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, FEventList);
  TNotifyEventWrap.Create(BeforePost, DoBeforePost, FEventList);
  TNotifyEventWrap.Create(W.AfterInsert, DoAfterInsert, W.EventList);

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
  FreeAndNil(FOn_ApplyUpdates);
  FreeAndNil(FEditedSubParams);
  FreeAndNil(FDeletedSubParams);
  FreeAndNil(FInsertedSubParams);
  FreeAndNil(FPKDictionary);
  inherited;
end;

procedure TQueryCategoryParameters2.AfterConstruction;
begin
  inherited; // Сохраняем первоначальный SQL

  // Добавляем в запрос параметр
  FDQuery.SQL.Text := ReplaceInSQL(SQL,
    Format('%s = :%s', [W.ProductCategoryID.FullName,
    W.ProductCategoryID.FieldName]), 0);
end;

procedure TQueryCategoryParameters2.ApplyDelete(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  Assert(ASender = FDQuery);
  // Рекурсивно удаляем из категорий сам параметр
  QueryRecursiveParameters.ExecDeleteSQL(W.ParamSubParamId.F.OldValue,
    W.CategoryID.F.OldValue);

  // Запоминаем, какаой подпараметр мы удалили
  FDeletedSubParams.Add(TRecordHolder.Create(FDQuery));

  // Удаляем данные удалённого параметра
  TqUpdateParameterValuesParamSubParam.DoDelete(W.ParamSubParamId.F.AsInteger,
    W.ProductCategoryID.F.AsInteger);
end;

procedure TQueryCategoryParameters2.ApplyInsert(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  Assert(ASender = FDQuery);

  // Рекурсивно вставляем записи в БД
  QueryRecursiveParameters.ExecInsertSQL(W.PosID.F.Value, W.Ord.F.Value,
    W.ParamSubParamId.F.Value, W.CategoryID.F.Value);

  // Выбираем вставленную запись чтобы узнать её идентификатор
  RefreshQry.Load([DetailParameterName, W.ParamSubParamId.FieldName],
    [W.CategoryID.F.Value, W.ParamSubParamId.F.Value]);

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

  if ((W.PosID.F.OldValue <> W.PosID.F.Value) or
    (W.Ord.F.OldValue <> W.Ord.F.Value)) then
  begin
    // Одновременно с изменением позиции или порядка ничего больше не должно меняться
    Assert(W.IsAttribute.F.OldValue = W.IsAttribute.F.Value);
    Assert(W.ParamSubParamId.F.OldValue = W.ParamSubParamId.F.Value);

    QueryRecursiveParameters.ExecUpdateOrdSQL(W.PosID.F.OldValue,
      W.PosID.F.Value, W.Ord.F.OldValue, W.Ord.F.Value,
      W.ParamSubParamId.F.AsInteger, W.CategoryID.F.AsInteger);
  end;

  // Если изменилось что-то другое
  if (W.IsAttribute.F.OldValue <> W.IsAttribute.F.Value) or
    (W.ParamSubParamId.F.OldValue <> W.ParamSubParamId.F.Value) then
  begin
    Assert(W.PosID.F.OldValue = W.PosID.F.Value);
    Assert(W.Ord.F.OldValue = W.Ord.F.Value);

    QueryRecursiveParameters.ExecUpdateSQL(W.PosID.F.OldValue, W.PosID.F.Value,
      W.Ord.F.OldValue, W.Ord.F.Value, W.IsAttribute.F.OldValue,
      W.IsAttribute.F.Value, W.ParamSubParamId.F.OldValue,
      W.ParamSubParamId.F.AsInteger, W.CategoryID.F.AsInteger);

    ARecHolder := TRecordHolder.Create(FDQuery);
    ARecHolder.Field[W.ParamSubParamId.FieldName] :=
      W.ParamSubParamId.F.OldValue;
    FEditedSubParams.Add(ARecHolder);

    // Переносим данные с со старого подпараметра на новый
    TqUpdateParameterValuesParamSubParam.DoUpdate(W.ParamSubParamId.F.AsInteger,
      W.ParamSubParamId.F.OldValue, W.ProductCategoryID.F.AsInteger);
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

function TQueryCategoryParameters2.CreateDSWrap: TDSWrap;
begin
  Result := TCategoryParameters2W.Create(FDQuery);
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

  AIDParameter := W.IDParameter.F.AsInteger;
  AIsDefault := W.IsDefault.F.AsInteger;

  // Список идентификаторов, стоящих рядом и принадлежащих одному параметру
  AIDList := TList<Integer>.Create;
  try
    FDQuery.DisableControls;
    try
      SaveBookmark;
      // Сначала пытаемся двигаться вверх по набору данных
      while (W.IDParameter.F.AsInteger = AIDParameter) and
        (W.IsDefault.F.AsInteger = AIsDefault) and (not FDQuery.Bof) do
        FDQuery.Prior;

      if not FDQuery.Bof then
      begin
        Assert((W.IDParameter.F.AsInteger <> AIDParameter) or
          (W.IsDefault.F.AsInteger <> AIsDefault));

        FDQuery.Next;
      end;

      Assert((W.IDParameter.F.AsInteger = AIDParameter) and
        (W.IsDefault.F.AsInteger = AIsDefault));
      // Теперь пытаемся двигаться вниз, по набору данных
      while (W.IDParameter.F.AsInteger = AIDParameter) and
        (W.IsDefault.F.AsInteger = AIsDefault) and (not FDQuery.Eof) do
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
  Result := W.AddClone(AFilter);

end;

procedure TQueryCategoryParameters2.DoAfterInsert(Sender: TObject);
begin
  W.IsEnabled.F.AsInteger := 1;
  W.IsAttribute.F.AsInteger := 1;
end;

procedure TQueryCategoryParameters2.DoAfterOpen(Sender: TObject);
begin
  SetFieldsReadOnly(False);
  FMaxOrder := 0;
end;

procedure TQueryCategoryParameters2.DoBeforePost(Sender: TObject);
begin
  W.ProductCategoryID.F.AsInteger := ParentValue;
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

function TQueryCategoryParameters2.GetAllIDSubParamList: string;
var
  AClone: TFDMemTable;
  AFilter: string;
begin
  Result := '';

  // Все подпараметры, кроме подпараметра "по умолчанию"
  AFilter := Format('%s = (%d) and %s = 0', [W.IDParameter.FieldName,
    W.IDParameter.F.AsInteger, W.IsDefault.FieldName]);
  AClone := W.AddClone(AFilter);
  try
    while not AClone.Eof do
    begin
      Result := Result + IfThen(Result.IsEmpty, '', ',') +
        AClone.FieldByName(W.IdSubParameter.FieldName).AsString;
      AClone.Next;
    end;
  finally
    W.DropClone(AClone);
  end;
end;

function TQueryCategoryParameters2.GetHaveInserted: Boolean;
begin
  FInsertedClone.FilterChanges := [rtInserted];
  Result := FDQuery.Active and (FInsertedClone.RecordCount > 0);
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
    AClone := W.AddClone(Format('%s >= %d', [W.Ord.FieldName, AStartOrder]));
    try
      while not AClone.Eof do
      begin
        D.Add(AClone.FieldByName(PKFieldName).AsInteger,
          AClone.FieldByName(W.Ord.FieldName).AsInteger);
        AClone.Next;
      end;
    finally
      W.DropClone(AClone);
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
  W.Move(A);
  RestoreBookmark;
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

  Result := SearchEx([TParamRec.Create(W.ProductCategoryID.FullName,
    AProductCategoryID), TParamRec.Create(W.IDParameterKind.FullName,
    Integer(Неиспользуется), ftInteger, False, '<>')]);
end;

procedure TQueryCategoryParameters2.SetIsAttribute(AID, AIsAttribute: Integer);
var
  AClone: TFDMemTable;
begin
  Assert(AID > 0);
  Assert(AIsAttribute in [0, 1]);

  LocateByPK(AID, True);
  AClone := CreateSubParamsClone;
  try
    while not AClone.Eof do
    begin
      AClone.Edit;
      AClone.FieldByName(W.IsAttribute.FieldName).AsInteger := AIsAttribute;
      AClone.Post;

      AClone.Next;
    end;
  finally
    W.DropClone(AClone);
  end;
end;

constructor TCategoryParameters2W.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'ID', '', True);
  FCategoryID := TFieldWrap.Create(Self, 'CategoryID');
  FIDParameter := TFieldWrap.Create(Self, 'IDParameter');
  FIdSubParameter := TFieldWrap.Create(Self, 'IdSubParameter');
  FIsAttribute := TFieldWrap.Create(Self, 'IsAttribute');
  FIsDefault := TFieldWrap.Create(Self, 'IsDefault');
  FIsEnabled := TFieldWrap.Create(Self, 'IsEnabled');
  FName := TFieldWrap.Create(Self, 'Name');
  FOrd := TFieldWrap.Create(Self, 'Ord');
  FParameterType := TFieldWrap.Create(Self, 'ParameterType');
  FParamSubParamId := TFieldWrap.Create(Self, 'ParamSubParamId');
  FPosID := TFieldWrap.Create(Self, 'PosID');
  FProductCategoryID := TFieldWrap.Create(Self, 'ProductCategoryID');
  FTableName := TFieldWrap.Create(Self, 'TableName');
  FTranslation := TFieldWrap.Create(Self, 'Translation');
  FValue := TFieldWrap.Create(Self, 'Value');
  FValueT := TFieldWrap.Create(Self, 'ValueT');
end;

procedure TCategoryParameters2W.AppendR(AParamSubParamId, AOrd, AIsAttribute,
  APosID, AIDParameter, AIDSubParameter: Integer;
const AValue, ATableName, AValueT, AParameterType, AName: String;
const ATranslation: Variant; AIsDefault: Integer);
begin
  TryAppend;
  ParamSubParamId.F.Value := AParamSubParamId;
  Ord.F.Value := AOrd;
  IsAttribute.F.Value := AIsAttribute;
  PosID.F.Value := APosID;
  IDParameter.F.Value := AIDParameter;
  IdSubParameter.F.Value := AIDSubParameter;
  Value.F.Value := AValue;
  TableName.F.Value := ATableName;
  ValueT.F.Value := AValueT;
  ParameterType.F.Value := AParameterType;
  Name.F.Value := AName;
  Translation.F.Value := ATranslation;
  IsDefault.F.Value := AIsDefault;
  TryPost;
end;

procedure TCategoryParameters2W.FilterByIsDefault(AIsDefault: Integer);
begin
  Assert(AIsDefault >= 0);
  DataSet.Filter := Format('%s=%d', [IsDefault.FieldName, AIsDefault]);
  DataSet.Filtered := True;
end;

procedure TCategoryParameters2W.FilterByPosition(APosID: Integer);
begin
  Assert(APosID >= 0);
  DataSet.Filter := Format('%s=%d', [PosID.FieldName, APosID]);
  DataSet.Filtered := True;
end;

function TCategoryParameters2W.Locate(AIDParameter, APosID, AOrder: Integer;
TestResult: Boolean = False): Boolean;
var
  AFieldNames: string;
begin
  Assert(AIDParameter > 0);
  Assert(APosID >= 0);
  Assert(AOrder > 0);

  AFieldNames := Format('%s;%s;%s', [IDParameter.FieldName, PosID.FieldName,
    Ord.FieldName]);

  Result := FDDataSet.LocateEx(AFieldNames,
    VarArrayOf([AIDParameter, APosID, AOrder]));

  if TestResult then
    Assert(Result);
end;

function TCategoryParameters2W.Locate(AIDParameter, AIDSubParameter: Integer;
TestResult: Boolean = False): Boolean;
var
  AFieldNames: string;
begin
  Assert(AIDParameter > 0);
  Assert(AIDSubParameter >= 0);

  AFieldNames := Format('%s;%s', [IDParameter.FieldName,
    IdSubParameter.FieldName]);

  Result := FDDataSet.LocateEx(AFieldNames,
    VarArrayOf([AIDParameter, AIDSubParameter]));

  if TestResult then
    Assert(Result);
end;

procedure TCategoryParameters2W.LocateDefault(AIDParameter: Integer;
TestResult: Boolean = False);
var
  AFieldName: string;
begin
  Assert(AIDParameter > 0);
  AFieldName := Format('%s;%s', [IDParameter.FieldName, IsDefault.FieldName]);
  FDDataSet.LocateEx(AFieldName, VarArrayOf([AIDParameter, 1]));
end;

procedure TCategoryParameters2W.Move(AData: TArray < TPair < Integer,
  Integer >> );
var
  APair: TPair<Integer, Integer>;
begin
  DataSet.DisableControls;
  try
    for APair in AData do
    begin
      // Переходим на нужную запись
      LocateByPK(APair.Key, True);
      // Меняем порядок записи
      TryEdit;
      Ord.F.AsInteger := APair.Value;
      TryPost;
    end;
  finally
    DataSet.EnableControls;
  end;
end;

function TCategoryParameters2W.NextEx: Boolean;
var
  AIDParameter: Integer;
  AIsDefault: Integer;
begin
  Assert(not DataSet.Eof);

  AIDParameter := IDParameter.F.AsInteger;
  AIsDefault := IsDefault.F.AsInteger;

  DataSet.Next;

  // Мы всё ещё в той же группе?
  Result := (IDParameter.F.AsInteger = AIDParameter) and
    (IsDefault.F.AsInteger = AIsDefault) and (not DataSet.Eof);
end;

procedure TCategoryParameters2W.SetPos(APosID: Integer);
begin
  Assert(DataSet.RecordCount > 0);
  Assert((APosID >= 0) and (APosID <= 2));

  TryEdit;
  PosID.F.AsInteger := APosID;
  TryPost;
end;

procedure TCategoryParameters2W.SetPos(AIDArray: TArray<Integer>;
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
