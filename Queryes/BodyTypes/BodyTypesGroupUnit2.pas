unit BodyTypesGroupUnit2;

interface

uses
  QueryGroupUnit2, System.Classes, NotifyEvents, BodyKindsQuery,
  BodyTypesQuery2, ProducersQuery, BodyTypesSimpleQuery,
  BodyTypesExcelDataModule;

type
  TBodyTypesGroup2 = class(TQueryGroup2)
  private
    FqBodyKinds: TQueryBodyKinds;
    FqBodyTypes2: TQueryBodyTypes2;
    FqProducers: TQueryProducers;
    FQueryBodyTypesSimple: TQueryBodyTypesSimple;
    procedure DoAfterDelete(Sender: TObject);
    function GetqBodyKinds: TQueryBodyKinds;
    function GetqBodyTypes2: TQueryBodyTypes2;
    function GetqProducers: TQueryProducers;
    function GetQueryBodyTypesSimple: TQueryBodyTypesSimple;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure LoadDataFromExcelTable(ABodyTypesExcelTable: TBodyTypesExcelTable;
        AIDProducer: Integer);
    procedure Rollback; override;
    property qBodyKinds: TQueryBodyKinds read GetqBodyKinds;
    property qBodyTypes2: TQueryBodyTypes2 read GetqBodyTypes2;
    property qProducers: TQueryProducers read GetqProducers;
    property QueryBodyTypesSimple: TQueryBodyTypesSimple read
        GetQueryBodyTypesSimple;
  end;

implementation

uses
  Data.DB;

constructor TBodyTypesGroup2.Create(AOwner: TComponent);
begin
  inherited;
  QList.Add(qBodyKinds);
  QList.Add(qBodyTypes2);

  Assert(ComponentCount > 0);

  // Для каскадного удаления
  TNotifyEventWrap.Create(qBodyKinds.W.AfterDelete, DoAfterDelete, EventList);
end;

destructor TBodyTypesGroup2.Destroy;
begin
  Assert(ComponentCount > 0);
  ;
  inherited;
end;

procedure TBodyTypesGroup2.DoAfterDelete(Sender: TObject);
begin
  Assert(qBodyKinds.OldPKValue > 0);
  // На сервере типы корпусов уже каскадно удалились
  // Каскадно удаляем типы корпусов с клиента
  qBodyTypes2.CascadeDelete(qBodyKinds.OldPKValue,
    qBodyTypes2.W.IDBodyKind.FieldName, True);
end;

function TBodyTypesGroup2.GetqBodyKinds: TQueryBodyKinds;
begin
  if FqBodyKinds = nil then
    FqBodyKinds := TQueryBodyKinds.Create(Self);

  Result := FqBodyKinds;
end;

function TBodyTypesGroup2.GetqBodyTypes2: TQueryBodyTypes2;
begin
  if FqBodyTypes2 = nil then
    FqBodyTypes2 := TQueryBodyTypes2.Create(Self);

  Result := FqBodyTypes2;
end;

function TBodyTypesGroup2.GetqProducers: TQueryProducers;
begin
  if FqProducers = nil then
    FqProducers := TQueryProducers.Create(Self);
  Result := FqProducers;
end;

function TBodyTypesGroup2.GetQueryBodyTypesSimple: TQueryBodyTypesSimple;
begin
  if FQueryBodyTypesSimple = nil then
  begin
    FQueryBodyTypesSimple := TQueryBodyTypesSimple.Create(Self);
  end;

  Result := FQueryBodyTypesSimple;
end;

procedure TBodyTypesGroup2.LoadDataFromExcelTable(ABodyTypesExcelTable :
    TBodyTypesExcelTable; AIDProducer: Integer);
var
  AField: TField;
  AProducerID: Integer;
  F: TField;
begin
  ABodyTypesExcelTable.DisableControls;
  try
    QueryBodyTypesSimple.RefreshQuery;

    ABodyTypesExcelTable.First;
    ABodyTypesExcelTable.CallOnProcessEvent;
    QueryBodyTypesSimple.ClearUpdateRecCount;
    while not ABodyTypesExcelTable.Eof do
    begin
      if AIDProducer > 0 then
        AProducerID := AIDProducer
      else
        AProducerID := (ABodyTypesExcelTable as TBodyTypesExcelTable2).IDProducer.AsInteger;

      // ищем или добавляем корень - вид корпуса
      qBodyKinds.W.LocateOrAppend(ABodyTypesExcelTable.BodyKind.AsString);

      QueryBodyTypesSimple.W.TryAppend;
      QueryBodyTypesSimple.W.IDProducer.F.AsInteger := AProducerID;
      QueryBodyTypesSimple.W.IDBodyKind.F.Value := qBodyKinds.PK.Value;
      QueryBodyTypesSimple.W.Variations.F.AsString :=
        ABodyTypesExcelTable.Variation.AsString;
      QueryBodyTypesSimple.W.JEDEC.F.AsString :=
        ABodyTypesExcelTable.JEDEC.AsString;
      QueryBodyTypesSimple.W.Options.F.AsString :=
        ABodyTypesExcelTable.Options.AsString;

      for AField in ABodyTypesExcelTable.Fields do
      begin
        F := QueryBodyTypesSimple.FDQuery.FindField(AField.FieldName);
        if F <> nil then
          F.Value := AField.Value;
      end;

      QueryBodyTypesSimple.TryPost;
      QueryBodyTypesSimple.IncUpdateRecCount;

      ABodyTypesExcelTable.Next;
      ABodyTypesExcelTable.CallOnProcessEvent;
    end;
    // Финальный коммит
    QueryBodyTypesSimple.FDQuery.Connection.Commit;

    // Обновляем данные в сгруппированном запросе
    qBodyTypes2.RefreshQuery;
  finally
    ABodyTypesExcelTable.EnableControls;
  end;

end;

procedure TBodyTypesGroup2.Rollback;
begin
  inherited;
  qBodyTypes2.RefreshLinkedData;
end;

end.
