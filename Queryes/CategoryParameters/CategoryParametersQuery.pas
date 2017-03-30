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
  System.Generics.Collections, DragHelper, DBRecordHolder;

type
  TQueryCategoryParameters = class(TQueryWithDataSource)
  private
    FQueryRecursiveParameters: TQueryRecursiveParameters;
    procedure DoAfterOpen(Sender: TObject);
    procedure DoBeforePost(Sender: TObject);
    function GetCategoryID: TField;
    function GetID: TField;
    function GetIsAttribute: TField;
    function GetIsEnabled: TField;
    function GetOrder: TField;
    function GetParameterID: TField;
    function GetPosID: TField;
    function GetProductCategoryID: TField;
    function GetQueryRecursiveParameters: TQueryRecursiveParameters;
    { Private declarations }
  protected
    procedure ApplyDelete(ASender: TDataSet); override;
    procedure ApplyUpdate(ASender: TDataSet); override;
    property QueryRecursiveParameters: TQueryRecursiveParameters
      read GetQueryRecursiveParameters;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AppendParameter(ARecordHolder: TRecordHolder; APosID: Integer);
    procedure Move(AData: TList<TRecOrder>);
    procedure SetPos(APosID: Integer);
    property CategoryID: TField read GetCategoryID;
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

uses NotifyEvents;

constructor TQueryCategoryParameters.Create(AOwner: TComponent);
begin
  inherited;
  DetailParameterName := 'ProductCategoryID';
  // Будем сохранять в БД изменения рекурсивно
  FDQuery.OnUpdateRecord := DoOnQueryUpdateRecord;

  TNotifyEventWrap.Create( AfterOpen, DoAfterOpen, FEventList );
  TNotifyEventWrap.Create( BeforePost, DoBeforePost, FEventList );
end;

procedure TQueryCategoryParameters.AppendParameter(ARecordHolder:
    TRecordHolder; APosID: Integer);
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

    QueryRecursiveParameters.Delete(
      AParameterID.OldValue,
      ACategoryID.OldValue
    );
end;

procedure TQueryCategoryParameters.ApplyUpdate(ASender: TDataSet);
var
  ACategoryID: TField;
  AOrder: TField;
  AParameterID: TField;
  APosID: TField;
begin
  APosID := ASender.FieldByName(PosID.FieldName);
  AParameterID := ASender.FieldByName(ParameterID.FieldName);
  ACategoryID := ASender.FieldByName(CategoryID.FieldName);
  AOrder := ASender.FieldByName(Order.FieldName);

  // Если изменилось положение параметра или его порядок
  if (APosID.OldValue <> APosID.Value) or (AOrder.OldValue <> AOrder.Value) then
  begin
    QueryRecursiveParameters.Update(
      APosID.OldValue, APosID.Value,
      AOrder.OldValue, AOrder.Value,
      AParameterID.AsInteger,
      ACategoryID.AsInteger
    );
  end;
end;

procedure TQueryCategoryParameters.DoAfterOpen(Sender: TObject);
begin
  SetFieldsReadOnly(False);
end;

procedure TQueryCategoryParameters.DoBeforePost(Sender: TObject);
begin
  ProductCategoryID.AsInteger := ParentValue;
  IsEnabled.AsBoolean := True;
  IsAttribute.AsBoolean := True;
end;

function TQueryCategoryParameters.GetCategoryID: TField;
begin
  Result := Field('ProductCategoryID');
end;

function TQueryCategoryParameters.GetID: TField;
begin
  Result := Field('ID');
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

procedure TQueryCategoryParameters.SetPos(APosID: Integer);
begin
  Assert(FDQuery.RecordCount > 0);
  Assert((APosID >= 0) and (APosID <= 2));

  TryEdit;
  PosID.AsInteger := APosID;
  TryPost;
end;

end.
