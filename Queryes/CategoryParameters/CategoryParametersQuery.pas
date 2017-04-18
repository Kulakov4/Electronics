unit CategoryParametersQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, QueryWithDataSourceUnit,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, RecursiveParametersQuery,
  System.Generics.Collections, DragHelper, DBRecordHolder, Sequence,
  MaxCategoryParameterOrderQuery;

type
  TQueryCategoryParameters = class(TQueryWithDataSource)
    fdqDeleteSubParameters: TFDQuery;
  private
    FInsertedClone: TFDMemTable;
    FMaxOrder: Integer;
    FQueryRecursiveParameters: TQueryRecursiveParameters;
    FRefreshQry: TQueryCategoryParameters;
    procedure DoAfterClose(Sender: TObject);
    procedure DoAfterInsert(Sender: TObject);
    procedure DoAfterOpen(Sender: TObject);
    procedure DoBeforePost(Sender: TObject);
    function GetCategoryID: TField;
    function GetHaveInserted: Boolean;
    function GetID: TField;
    function GetInsertedClone: TFDMemTable;
    function GetIsAttribute: TField;
    function GetIsEnabled: TField;
    function GetOrder: TField;
    function GetParameterID: TField;
    function GetPosID: TField;
    function GetProductCategoryID: TField;
    function GetQueryRecursiveParameters: TQueryRecursiveParameters;
    function GetRefreshQry: TQueryCategoryParameters;
    { Private declarations }
  protected
    procedure ApplyDelete(ASender: TDataSet); override;
    procedure ApplyInsert(ASender: TDataSet); override;
    procedure ApplyUpdate(ASender: TDataSet); override;
    procedure DoBeforeDelete(Sender: TObject);
    property InsertedClone: TFDMemTable read GetInsertedClone;
    property QueryRecursiveParameters: TQueryRecursiveParameters
      read GetQueryRecursiveParameters;
    property RefreshQry: TQueryCategoryParameters read GetRefreshQry;
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
    property ID: TField read GetID;
    property IsAttribute: TField read GetIsAttribute;
    property IsEnabled: TField read GetIsEnabled;
    property Order: TField read GetOrder;
    property ParameterID: TField read GetParameterID;
    property PosID: TField read GetPosID;
    property ProductCategoryID: TField read GetProductCategoryID;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses NotifyEvents, RepositoryDataModule;

constructor TQueryCategoryParameters.Create(AOwner: TComponent);
begin
  inherited;
  DetailParameterName := 'ProductCategoryID';
  // Будем сохранять в БД изменения рекурсивно
  FDQuery.OnUpdateRecord := DoOnQueryUpdateRecord;

  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, FEventList);
  TNotifyEventWrap.Create(BeforePost, DoBeforePost, FEventList);
  TNotifyEventWrap.Create(AfterInsert, DoAfterInsert, FEventList);
  TNotifyEventWrap.Create(AfterClose, DoAfterClose, FEventList);

  // Для каскадного удаления
  TNotifyEventWrap.Create(BeforeDelete, DoBeforeDelete);
end;

procedure TQueryCategoryParameters.AppendParameter(ARecordHolder: TRecordHolder;
  APosID: Integer);
begin
  Assert(ARecordHolder <> nil);

  TryAppend;
  ARecordHolder.TryPut(FDQuery);
  PosID.AsInteger := APosID;
  TryPost;
end;

procedure TQueryCategoryParameters.ApplyDelete(ASender: TDataSet);
var
  ACategoryID: TField;
  AParameterID: TField;
begin
  AParameterID := ASender.FieldByName(ParameterID.FieldName);
  ACategoryID := ASender.FieldByName(CategoryID.FieldName);

  // Рекурсивно удаляем из категорий сам параметр
  QueryRecursiveParameters.ExecDeleteSQL(AParameterID.OldValue,
    ACategoryID.OldValue);

  // Удаляем из категорий подпараметры удалённых параметров
  fdqDeleteSubParameters.ExecSQL;
end;

procedure TQueryCategoryParameters.ApplyInsert(ASender: TDataSet);
var
  ACategoryID: TField;
  AID: TField;
  AOrder: TField;
  AParameterID: TField;
  APosID: TField;
begin
  APosID := ASender.FieldByName(PosID.FieldName);
  AOrder := ASender.FieldByName(Order.FieldName);
  AParameterID := ASender.FieldByName(ParameterID.FieldName);
  ACategoryID := ASender.FieldByName(CategoryID.FieldName);
  AID := ASender.FieldByName(PKFieldName);

  // Рекурсивно вставляем записи в БД
  QueryRecursiveParameters.ExecInsertSQL(APosID.Value, AOrder.Value,
    AParameterID.Value, ACategoryID.Value);

  // Выбираем вставленную запись чтобы узнать её идентификатор
  RefreshQry.Load([DetailParameterName, 'ParameterID'],
    [ACategoryID.Value, AParameterID.Value]);
  // Должна быть выбрана только одна запись
  // Иначе - нарушено ограничение уникальности
  Assert(RefreshQry.FDQuery.RecordCount = 1);
  Assert(RefreshQry.PKValue > 0);

  // Заполняем первычный ключ у вставленной записи
//  if ASender.State in [dsEdit, dsInsert] then
  ASender.Edit;
  AID.AsInteger := RefreshQry.PKValue;
  ASender.Post;
end;

procedure TQueryCategoryParameters.ApplyUpdate(ASender: TDataSet);
var
  ACategoryID: TField;
  AIsAttribute: TField;
  AOrder: TField;
  AParameterID: TField;
  APosID: TField;
begin
  APosID := ASender.FieldByName(PosID.FieldName);
  AOrder := ASender.FieldByName(Order.FieldName);
  AParameterID := ASender.FieldByName(ParameterID.FieldName);
  ACategoryID := ASender.FieldByName(CategoryID.FieldName);
  AIsAttribute := ASender.FieldByName(IsAttribute.FieldName);

  // Если изменилось положение параметра или его порядок
  if (APosID.OldValue <> APosID.Value) or
  (AOrder.OldValue <> AOrder.Value) or
  (AIsAttribute.OldValue <> AIsAttribute.NewValue)
  then
  begin
    QueryRecursiveParameters.ExecUpdateSQL(APosID.OldValue, APosID.Value,
      AOrder.OldValue, AOrder.Value, AIsAttribute.OldValue, AIsAttribute.Value,
      AParameterID.AsInteger, ACategoryID.AsInteger);
  end;
end;

procedure TQueryCategoryParameters.ApplyUpdates;
begin
  inherited;
  // Чтобы в следующий раз его вычислить
  FMaxOrder := 0;
end;

procedure TQueryCategoryParameters.CancelUpdates;
begin
  inherited;
  FMaxOrder := 0;
end;

procedure TQueryCategoryParameters.DoAfterClose(Sender: TObject);
begin
  if FInsertedClone <> nil then
    FInsertedClone.Close;
end;

procedure TQueryCategoryParameters.DoAfterInsert(Sender: TObject);
begin
  IsEnabled.AsBoolean := True;
  IsAttribute.AsBoolean := True;
end;

procedure TQueryCategoryParameters.DoAfterOpen(Sender: TObject);
begin
  SetFieldsReadOnly(False);
  FMaxOrder := 0;

  if FInsertedClone <> nil then
  begin
    FInsertedClone.CloneCursor(FDQuery);
    FInsertedClone.FilterChanges := [rtInserted];
  end;

  IsEnabled.DefaultExpression := 'true';
  IsAttribute.DefaultExpression := 'true';
end;

procedure TQueryCategoryParameters.DoBeforeDelete(Sender: TObject);
begin
//  CascadeDelete();
end;

procedure TQueryCategoryParameters.DoBeforePost(Sender: TObject);
begin
  ProductCategoryID.AsInteger := ParentValue;
end;

function TQueryCategoryParameters.GetCategoryID: TField;
begin
  Result := Field('ProductCategoryID');
end;

function TQueryCategoryParameters.GetHaveInserted: Boolean;
begin
  Result := FDQuery.Active and (InsertedClone.RecordCount > 0);
end;

function TQueryCategoryParameters.GetID: TField;
begin
  Result := Field('ID');
end;

function TQueryCategoryParameters.GetInsertedClone: TFDMemTable;
begin
  if FInsertedClone = nil then
  begin
    FInsertedClone := TFDMemTable.Create(Self);
    FInsertedClone.Name := 'qwewe';
    if FDQuery.Active then
    begin
      FInsertedClone.CloneCursor(FDQuery);
      FInsertedClone.FilterChanges := [rtInserted];
    end;
  end;
  Result := FInsertedClone;
end;

function TQueryCategoryParameters.GetIsAttribute: TField;
begin
  Result := Field('IsAttribute');
end;

function TQueryCategoryParameters.GetIsEnabled: TField;
begin
  Result := Field('IsEnabled');
end;

function TQueryCategoryParameters.GetOrder: TField;
begin
  Result := Field('Order');
end;

function TQueryCategoryParameters.GetParameterID: TField;
begin
  Result := Field('ParameterID');
end;

function TQueryCategoryParameters.GetPosID: TField;
begin
  Result := Field('PosID');
end;

function TQueryCategoryParameters.GetProductCategoryID: TField;
begin
  Result := Field('ProductCategoryID');
end;

function TQueryCategoryParameters.GetQueryRecursiveParameters
  : TQueryRecursiveParameters;
begin
  if FQueryRecursiveParameters = nil then
    FQueryRecursiveParameters := TQueryRecursiveParameters.Create(Self);
  Result := FQueryRecursiveParameters;
end;

function TQueryCategoryParameters.GetRefreshQry: TQueryCategoryParameters;
begin
  if FRefreshQry = nil then
  begin
    FRefreshQry := TQueryCategoryParameters.Create(Self);
    // Добавляем в текст SQL запроса условие с параметром
    FRefreshQry.SetConditionSQL(FRefreshQry.FDQuery.SQL.Text,
      ' and ParameterId = :ParameterID', '--and',
      procedure(Sender: TObject)
      begin
        with FRefreshQry.FDQuery.ParamByName('ParameterID') do
        begin
          DataType := ftInteger;
          ParamType := ptInput;
        end;
      end
    );
  end;

  Result := FRefreshQry;
end;

procedure TQueryCategoryParameters.Move(AData: TList<TRecOrder>);
var
  ARecOrder: TRecOrder;
  OK: Boolean;
begin
  FDQuery.DisableControls;
  try
    for ARecOrder in AData do
    begin
      // Переходим на нужную запись
      OK := FDQuery.LocateEx(ID.FieldName, ARecOrder.Key, []);
      Assert(OK);
      // Меняем порядок записи
      TryEdit;
      Order.AsInteger := ARecOrder.Order;
      TryPost;
    end;
  finally
    FDQuery.EnableControls;
  end;
end;

function TQueryCategoryParameters.NextOrder: Integer;
begin
  if FMaxOrder = 0 then
    FMaxOrder := TQueryMaxCategoryParameterOrder.Max_Order;
  Inc(FMaxOrder);
  Result := FMaxOrder;
end;

procedure TQueryCategoryParameters.SetPos(APosID: Integer);
begin
  Assert(FDQuery.RecordCount > 0);
  Assert((APosID >= 0) and (APosID <= 2));

  TryEdit;
  PosID.AsInteger := APosID;
  TryPost;
end;

end.
