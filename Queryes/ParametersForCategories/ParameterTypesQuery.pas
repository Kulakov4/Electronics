unit ParameterTypesQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, DragHelper, System.Generics.Collections,
  QueryWithDataSourceUnit;

type
  TQueryParameterTypes = class(TQueryWithDataSource)
    FDQueryID: TFDAutoIncField;
    FDQueryParameterType: TWideStringField;
    FDQueryOrd: TIntegerField;
    FDUpdateSQL: TFDUpdateSQL;
    fdqBase: TFDQuery;
  private
    FRecOrderList: TList<TRecOrder>;
    FShowDublicate: Boolean;
    FTableNameFilter: string;
    procedure DoBeforeOpen(Sender: TObject);
    function GetOrd: TField;
    function GetParameterType: TField;
    procedure SetShowDublicate(const Value: Boolean);
    procedure SetTableNameFilter(const Value: string);
    { Private declarations }
  protected
    procedure DoOnUpdateOrder(ARecOrder: TRecOrder);
    procedure UpdateOrder;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AddNewValue(const AValue: string);
    procedure LocateOrAppend(AValue: string);
    function Locate(AValue: string): Boolean;
    procedure MoveDSRecord(AStartDrag: TStartDrag; ADropDrag: TDropDrag);
    property Ord: TField read GetOrd;
    property ParameterType: TField read GetParameterType;
    property ShowDublicate: Boolean read FShowDublicate write SetShowDublicate;
    property TableNameFilter: string read FTableNameFilter write SetTableNameFilter;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses RepositoryDataModule, NotifyEvents, StrHelper;

constructor TQueryParameterTypes.Create(AOwner: TComponent);
begin
  inherited;

  // Копируем базовый запрос и параметры
  AssignFrom(fdqBase);

  FRecOrderList := TList<TRecOrder>.Create;

  AutoTransaction := False;

  TNotifyEventWrap.Create(BeforeOpen, DoBeforeOpen, FEventList);
end;

procedure TQueryParameterTypes.AddNewValue(const AValue: string);
begin
  FDQuery.Append;
  ParameterType.AsString := AValue;
  FDQuery.Post;
end;

procedure TQueryParameterTypes.DoBeforeOpen(Sender: TObject);
begin
  FDQuery.ParamByName('TableName').AsString := FTableNameFilter;
end;

procedure TQueryParameterTypes.DoOnUpdateOrder(ARecOrder: TRecOrder);
begin
  Ord.Value := ARecOrder.Order;
end;

function TQueryParameterTypes.GetOrd: TField;
begin
  Result := Field('Ord');
end;

function TQueryParameterTypes.GetParameterType: TField;
begin
  Result := Field('ParameterType');
end;

procedure TQueryParameterTypes.LocateOrAppend(AValue: string);
begin
  if not FDQuery.LocateEx(ParameterType.FieldName, AValue, []) then
    AddNewValue(AValue);
end;

function TQueryParameterTypes.Locate(AValue: string): Boolean;
begin
  Result := FDQuery.LocateEx(ParameterType.FieldName, AValue, [lxoPartialKey, lxoCaseInsensitive]);
end;

procedure TQueryParameterTypes.MoveDSRecord(AStartDrag: TStartDrag; ADropDrag:
    TDropDrag);
var
  AClone: TFDMemTable;
  AKeyField: TField;
  ANewOrderValue: Integer;
  AOrderField: TField;
//  ARecOrder: TRecOrder;
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

procedure TQueryParameterTypes.SetShowDublicate(const Value: Boolean);
var
  ASQL: String;
begin
  if FShowDublicate <> Value then
  begin
    FShowDublicate := Value;

    ASQL := fdqBase.SQL.Text;
    if FShowDublicate then
    begin
      ASQL := Replace(ASQL, '', '/* ShowDublicate');
      ASQL := Replace(ASQL, '', 'ShowDublicate */');
    end;

    FDQuery.Close;
    FDQuery.SQL.Text := ASQL;
    FDQuery.Open;
  end;
end;

procedure TQueryParameterTypes.SetTableNameFilter(const Value: string);
begin
  if FTableNameFilter <> Value then
  begin
    FTableNameFilter := Value;

    // Фильтруем по табличному имени
    FDQuery.Close;
    FDQuery.Open;
  end;
end;

procedure TQueryParameterTypes.UpdateOrder;
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
