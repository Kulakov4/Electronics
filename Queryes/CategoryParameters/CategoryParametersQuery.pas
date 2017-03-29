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
  System.Generics.Collections, DragHelper;

type
  TQueryCategoryParameters = class(TQueryWithDataSource)
  private
    FQueryRecursiveParameters: TQueryRecursiveParameters;
    function GetCategoryID: TField;
    function GetID: TField;
    function GetOrder: TField;
    function GetParameterID: TField;
    function GetPosID: TField;
    function GetQueryRecursiveParameters: TQueryRecursiveParameters;
    { Private declarations }
  protected
    procedure ApplyUpdate(ASender: TDataSet); override;
    property QueryRecursiveParameters: TQueryRecursiveParameters
      read GetQueryRecursiveParameters;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Move(AData: TList<TRecOrder>);
    procedure SetPos(APosID: Integer);
    property CategoryID: TField read GetCategoryID;
    property ID: TField read GetID;
    property Order: TField read GetOrder;
    property ParameterID: TField read GetParameterID;
    property PosID: TField read GetPosID;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TQueryCategoryParameters.Create(AOwner: TComponent);
begin
  inherited;
  DetailParameterName := 'ProductCategoryID';
  // Будем сохранять в БД изменения рекурсивно
  FDQuery.OnUpdateRecord := DoOnQueryUpdateRecord;
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
    QueryRecursiveParameters.Execute(
      APosID.OldValue, APosID.Value,
      AOrder.OldValue, AOrder.Value,
      AParameterID.AsInteger,
      ACategoryID.AsInteger
    );
  end;
end;

function TQueryCategoryParameters.GetCategoryID: TField;
begin
  Result := Field('ProductCategoryID');
end;

function TQueryCategoryParameters.GetID: TField;
begin
  Result := Field('ID');
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
var
  rc: Integer;
begin
  Assert(FDQuery.RecordCount > 0);
  Assert((APosID >= 0) and (APosID <= 2));

  TryEdit;
  PosID.AsInteger := APosID;
  TryPost;
end;

end.
