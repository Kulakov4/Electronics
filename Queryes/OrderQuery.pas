unit OrderQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, QueryWithDataSourceUnit,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, DragHelper, System.Generics.Collections;

type
  TQueryOrder = class(TQueryWithDataSource)
  private
    FRecOrderList: TList<TRecOrder>;
    { Private declarations }
  protected
    procedure DoOnUpdateOrder(ARecOrder: TRecOrder);
    function GetOrd: TField; virtual;
    procedure UpdateOrder;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure MoveDSRecord(AStartDrag: TStartDrag; ADropDrag: TDropDrag);
    property Ord: TField read GetOrd;
    { Public declarations }
  end;

var
  QueryOrder: TQueryOrder;

implementation

{$R *.dfm}

constructor TQueryOrder.Create(AOwner: TComponent);
begin
  inherited;
  FRecOrderList := TList<TRecOrder>.Create;
end;

destructor TQueryOrder.Destroy;
begin
  FreeAndNil(FRecOrderList);
  inherited;
end;

procedure TQueryOrder.DoOnUpdateOrder(ARecOrder: TRecOrder);
begin
  Ord.Value := ARecOrder.Order;
end;

function TQueryOrder.GetOrd: TField;
begin
  Result := Field('Ord');
end;

procedure TQueryOrder.MoveDSRecord(AStartDrag: TStartDrag; ADropDrag:
    TDropDrag);
var
  AClone: TFDMemTable;
  AKeyField: TField;
  ANewOrderValue: Integer;
  AOrderField: TField;
  I: Integer;
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

    AOrderField := AClone.FieldByName(Ord.FieldName);
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
        FRecOrderList.Add(TRecOrder.Create(AKeyField.AsInteger, AOrderField.AsInteger + Sign *
          Length(AStartDrag.Keys)));
      end;

      AClone.Next;
    end;

    ANewOrderValue := ADropDrag.OrderValue;
    if IsDown then
      ANewOrderValue := ADropDrag.OrderValue - Length(AStartDrag.Keys) + 1;

    for I := Low(AStartDrag.Keys) to High(AStartDrag.Keys) do
    begin
      // Запоминаем, что нужно изменить
      FRecOrderList.Add(TRecOrder.Create(AStartDrag.Keys[I], ANewOrderValue + I));
    end;
  finally
    FreeAndNil(AClone);
  end;

  // Выполняем все изменения
  UpdateOrder;

end;

procedure TQueryOrder.UpdateOrder;
var
  APKValue: Integer;
  I: Integer;
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
      for I := 0 to FRecOrderList.Count - 1 do
      begin
        Ok := FDQuery.Locate(PKFieldName, FRecOrderList[I].Key, []);
        Assert(Ok);

        FDQuery.Edit;
        DoOnUpdateOrder(FRecOrderList[I]);
        FDQuery.Post;
      end;

      for I := 0 to FRecOrderList.Count - 1 do
        FRecOrderList[I].Free;
      FRecOrderList.Clear;
    finally
      FDQuery.Locate(PKFieldName, APKValue, []);
    end;
  finally
    FDQuery.EnableControls;
  end;

end;

end.
