unit ProducersGroupUnit2;

interface

uses
  QueryGroupUnit2, System.Classes, NotifyEvents, ProducersQuery,
  ProducerTypesQuery, System.Generics.Collections, ProducersExcelDataModule;

resourcestring
  //  атегори€ производителей которые добавл€ютс€ на склад в ручную или из Excel ‘айла
  sWareHouseDefaultProducerType = '—клад';

type
  TProducersGroup2 = class(TQueryGroup2)
  private
    FqProducers: TQueryProducers;
    FqProducerTypes: TQueryProducerTypes;
    function GetqProducers: TQueryProducers;
    function GetqProducerTypes: TQueryProducerTypes;
    procedure SetqProducers(const Value: TQueryProducers);
  protected
    procedure DoAfterDelete(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    function Find(const AProducer: string): TArray<String>;
    procedure LoadDataFromExcelTable(AProducersExcelTable
      : TProducersExcelTable);
    procedure LocateOrAppend(AValue: string; const AProducerType: String);
    property qProducers: TQueryProducers read GetqProducers write SetqProducers;
    property qProducerTypes: TQueryProducerTypes read GetqProducerTypes;
  end;

implementation

uses
  System.SysUtils, Data.DB, FireDAC.Comp.DataSet;

constructor TProducersGroup2.Create(AOwner: TComponent);
begin
  inherited;
  QList.Add(qProducerTypes);
  QList.Add(qProducers);

  // ƒл€ каскадного удалени€
  TNotifyEventWrap.Create(qProducerTypes.W.AfterDelete, DoAfterDelete,
    EventList);
end;

procedure TProducersGroup2.DoAfterDelete(Sender: TObject);
begin
  Assert(qProducerTypes.W.DeletedPKValue > 0);
  // Ќа сервере типы производителей уже каскадно удалились
  //  аскадно удал€ем производителей с клиента
  qProducers.W.CascadeDelete(qProducerTypes.W.DeletedPKValue,
    qProducers.W.ProducerTypeID.FieldName, True);
end;

function TProducersGroup2.Find(const AProducer: string): TArray<String>;
var
  L: TList<String>;
begin
  L := TList<String>.Create();
  try
    // ѕытаемс€ искать среди производителей по наименованию
    if qProducers.W.Name.Locate(AProducer, [lxoCaseInsensitive, lxoPartialKey])
    then
    begin
      qProducerTypes.W.LocateByPK(qProducers.W.ProducerTypeID.F.Value, True);
      // запоминаем что надо искать на первом уровне
      L.Add(qProducerTypes.W.ProducerType.F.AsString);
      // запоминаем что надо искать на втором уровне
      L.Add(AProducer);
    end
    else
      // ѕытаемс€ искать среди типов производителей
      if qProducerTypes.W.ProducerType.Locate(AProducer,
        [lxoCaseInsensitive, lxoPartialKey]) then
      begin
        L.Add(AProducer);
      end;

    Result := L.ToArray;
  finally
    FreeAndNil(L);
  end;
end;

function TProducersGroup2.GetqProducers: TQueryProducers;
begin
  if FqProducers = nil then
    FqProducers := TQueryProducers.Create(Self);

  Result := FqProducers;
end;

function TProducersGroup2.GetqProducerTypes: TQueryProducerTypes;
begin
  if FqProducerTypes = nil then
    FqProducerTypes := TQueryProducerTypes.Create(Self);

  Result := FqProducerTypes;
end;

procedure TProducersGroup2.LoadDataFromExcelTable(AProducersExcelTable
  : TProducersExcelTable);
var
  AField: TField;
  I: Integer;
begin
  qProducerTypes.FDQuery.DisableControls;
  qProducers.FDQuery.DisableControls;
  try
    // ÷икл по всем запис€м, которые будем добавл€ть
    AProducersExcelTable.First;
    AProducersExcelTable.CallOnProcessEvent;
    while not AProducersExcelTable.Eof do
    begin
      qProducerTypes.LocateOrAppend
        (AProducersExcelTable.ProducerType.AsString.Trim);

      // ≈сли производитель с таким именем уже есть
      if qProducers.Locate(AProducersExcelTable.Name.AsString.Trim) then
        qProducers.W.TryEdit
      else
        qProducers.W.TryAppend;

      // —в€зываем производител€ с его типом
      qProducers.W.ProducerTypeID.F.AsInteger := qProducerTypes.W.PK.AsInteger;

      for I := 0 to AProducersExcelTable.FieldCount - 1 do
      begin
        AField := qProducers.FDQuery.FindField(AProducersExcelTable.Fields[I]
          .FieldName);
        if AField <> nil then
          AField.Value := AProducersExcelTable.Fields[I].Value;
      end;

      qProducers.W.TryPost;

      AProducersExcelTable.Next;
      AProducersExcelTable.CallOnProcessEvent;
    end;

  finally
    qProducers.FDQuery.EnableControls;
    qProducerTypes.FDQuery.EnableControls;
  end;
end;

procedure TProducersGroup2.LocateOrAppend(AValue: string;
  const AProducerType: String);
var
  OK: Boolean;
begin
  OK := qProducers.Locate(AValue);

  if OK then
    Exit;

  qProducerTypes.LocateOrAppend(AProducerType);
  qProducers.W.AddNewValue(AValue, qProducerTypes.W.PK.AsInteger);
end;

procedure TProducersGroup2.SetqProducers(const Value: TQueryProducers);
begin
  FqProducers := Value;
end;

end.
