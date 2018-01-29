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
  DragHelper, System.Generics.Collections, DBRecordHolder;

type
  TQueryCategoryParameters2 = class(TQueryWithDataSource)
  private
    FInsertedClone: TFDMemTable;
    FMaxOrder: Integer;
    FOn_ApplyUpdates: TNotifyEventsEx;
    FQueryRecursiveParameters: TQueryRecursiveParameters;
    FRefreshQry: TQueryCategoryParameters2;
    procedure DoAfterInsert(Sender: TObject);
    procedure DoAfterOpen(Sender: TObject);
    procedure DoBeforePost(Sender: TObject);
    function GetCategoryID: TField;
    function GetHaveInserted: Boolean;
    function GetIsAttribute: TField;
    function GetIsEnabled: TField;
    function GetOrd: TField;
    function GetParameterType: TField;
    function GetParamSubParamId: TField;
    function GetPosID: TField;
    function GetProductCategoryID: TField;
    function GetQueryRecursiveParameters: TQueryRecursiveParameters;
    function GetRefreshQry: TQueryCategoryParameters2;
    { Private declarations }
  protected
    procedure ApplyDelete(ASender: TDataSet); override;
    procedure ApplyInsert(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure ApplyUpdate(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    property QueryRecursiveParameters: TQueryRecursiveParameters
      read GetQueryRecursiveParameters;
    property RefreshQry: TQueryCategoryParameters2 read GetRefreshQry;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AppendParameter(ARecordHolder: TRecordHolder; APosID: Integer);
    procedure ApplyUpdates; override;
    procedure CancelUpdates; override;
    procedure Move(AData: TList<TRecOrder>);
    function NextOrder: Integer;
    procedure SetPos(APosID: Integer);
    property CategoryID: TField read GetCategoryID;
    property HaveInserted: Boolean read GetHaveInserted;
    property IsAttribute: TField read GetIsAttribute;
    property IsEnabled: TField read GetIsEnabled;
    property Ord: TField read GetOrd;
    property ParameterType: TField read GetParameterType;
    property ParamSubParamId: TField read GetParamSubParamId;
    property PosID: TField read GetPosID;
    property ProductCategoryID: TField read GetProductCategoryID;
    property On_ApplyUpdates: TNotifyEventsEx read FOn_ApplyUpdates;
    { Public declarations }
  end;

implementation

uses
  MaxCategoryParameterOrderQuery;

{$R *.dfm}

constructor TQueryCategoryParameters2.Create(AOwner: TComponent);
begin
  inherited;
  DetailParameterName := 'ProductCategoryID';
  // Будем сохранять в БД изменения рекурсивно
  FDQuery.OnUpdateRecord := DoOnQueryUpdateRecord;

  // Создаём клон
  FInsertedClone := AddClone('0=0');
  FInsertedClone.FilterChanges := [rtInserted];

  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, FEventList);
  TNotifyEventWrap.Create(BeforePost, DoBeforePost, FEventList);
  TNotifyEventWrap.Create(AfterInsert, DoAfterInsert, FEventList);

  FOn_ApplyUpdates := TNotifyEventsEx.Create(Self);
end;

procedure TQueryCategoryParameters2.AppendParameter(ARecordHolder
  : TRecordHolder; APosID: Integer);
begin
  Assert(ARecordHolder <> nil);

  TryAppend;
  ARecordHolder.TryPut(FDQuery);
  PosID.AsInteger := APosID;
  TryPost;
end;

procedure TQueryCategoryParameters2.ApplyDelete(ASender: TDataSet);
begin
  Assert(ASender = FDQuery);

  // Рекурсивно удаляем из категорий сам параметр
  QueryRecursiveParameters.ExecDeleteSQL(ParamSubParamId.OldValue,
    CategoryID.OldValue);

  // Удаляем из категорий подпараметры удалённых параметров
  // fdqDeleteSubParameters.ExecSQL;
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

  // Заполняем первычный ключ у вставленной записи
  FetchFields([PK.FieldName], [RefreshQry.PK.Value], ARequest, AAction,
    AOptions);
  // AID.AsInteger := RefreshQry.PK.Value;
end;

procedure TQueryCategoryParameters2.ApplyUpdate(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  Assert(ASender = FDQuery);

  // Если изменилось положение параметра или его порядок
  if (PosID.OldValue <> PosID.Value) or (Ord.OldValue <> Ord.Value) or
    (IsAttribute.OldValue <> IsAttribute.NewValue) then
  begin
    QueryRecursiveParameters.ExecUpdateSQL(PosID.OldValue, PosID.Value,
      Ord.OldValue, Ord.Value, IsAttribute.OldValue, IsAttribute.Value,
      ParamSubParamId.AsInteger, CategoryID.AsInteger);
  end;
end;

procedure TQueryCategoryParameters2.ApplyUpdates;
begin
  inherited;
  // Чтобы в следующий раз его вычислить
  FMaxOrder := 0;
  FOn_ApplyUpdates.CallEventHandlers(Self);
end;

procedure TQueryCategoryParameters2.CancelUpdates;
begin
  inherited;
  FMaxOrder := 0;
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

function TQueryCategoryParameters2.GetCategoryID: TField;
begin
  Result := Field('ProductCategoryID');
end;

function TQueryCategoryParameters2.GetHaveInserted: Boolean;
begin
  FInsertedClone.FilterChanges := [rtInserted];
  Result := FDQuery.Active and (FInsertedClone.RecordCount > 0);
end;

function TQueryCategoryParameters2.GetIsAttribute: TField;
begin
  Result := Field('IsAttribute');
end;

function TQueryCategoryParameters2.GetIsEnabled: TField;
begin
  Result := Field('IsEnabled');
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
      ('--and', ' and ParamSubParamId = :ParamSubParamID');

    FRefreshQry.SetParamType('ParamSubParamID');
  end;

  Result := FRefreshQry;
end;

procedure TQueryCategoryParameters2.Move(AData: TList<TRecOrder>);
var
  ARecOrder: TRecOrder;
  OK: Boolean;
begin
  FDQuery.DisableControls;
  try
    for ARecOrder in AData do
    begin
      // Переходим на нужную запись
      OK := FDQuery.LocateEx(PKFieldName, ARecOrder.Key, []);
      Assert(OK);
      // Меняем порядок записи
      TryEdit;
      Ord.AsInteger := ARecOrder.Order;
      TryPost;
    end;
  finally
    FDQuery.EnableControls;
  end;
end;

function TQueryCategoryParameters2.NextOrder: Integer;
begin
  if FMaxOrder = 0 then
    FMaxOrder := TQueryMaxCategoryParameterOrder.Max_Order;
  Inc(FMaxOrder);
  Result := FMaxOrder;
end;

procedure TQueryCategoryParameters2.SetPos(APosID: Integer);
begin
  Assert(FDQuery.RecordCount > 0);
  Assert((APosID >= 0) and (APosID <= 2));

  TryEdit;
  PosID.AsInteger := APosID;
  TryPost;
end;

end.
