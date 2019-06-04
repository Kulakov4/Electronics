unit BodyTypesGroupUnit2;

interface

uses
  QueryGroupUnit2, System.Classes, NotifyEvents, BodyKindsQuery,
  BodyTypesQuery2, ProducersQuery, BodyTypesSimpleQuery,
  BodyTypesExcelDataModule, SearchBodyVariationQuery, BodyKindsColorQuery;

type
  TBodyTypesGroup2 = class(TQueryGroup2)
  private
    FqBodyKinds: TQueryBodyKinds;
    FqBodyKindsColor: TQryBodyKindsColor;
    FqBodyTypes2: TQueryBodyTypes2;
    FqProducers: TQueryProducers;
    FqSearchBodyVariation: TQrySearchBodyVariation;
    FQueryBodyTypesSimple: TQueryBodyTypesSimple;
    procedure DoAfterDelete(Sender: TObject);
    function GetqBodyKinds: TQueryBodyKinds;
    function GetqBodyKindsColor: TQryBodyKindsColor;
    function GetqBodyTypes2: TQueryBodyTypes2;
    function GetqProducers: TQueryProducers;
    function GetqSearchBodyVariation: TQrySearchBodyVariation;
    function GetQueryBodyTypesSimple: TQueryBodyTypesSimple;
  protected
    property qSearchBodyVariation: TQrySearchBodyVariation
      read GetqSearchBodyVariation;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure LoadDataFromExcelTable(ABodyTypesExcelTable: TBodyTypesExcelTable;
      AIDProducer: Integer);
    procedure Re_Open(AShowDuplicate: Boolean);
    procedure Rollback; override;
    function Search(ABodyVariation: String): Boolean;
    property qBodyKinds: TQueryBodyKinds read GetqBodyKinds;
    property qBodyKindsColor: TQryBodyKindsColor read GetqBodyKindsColor;
    property qBodyTypes2: TQueryBodyTypes2 read GetqBodyTypes2;
    property qProducers: TQueryProducers read GetqProducers;
    property QueryBodyTypesSimple: TQueryBodyTypesSimple
      read GetQueryBodyTypesSimple;
  end;

implementation

uses
  Data.DB, System.Generics.Collections, System.SysUtils, FireDAC.Comp.DataSet;

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
  Assert(ComponentCount > 0);;
  inherited;
end;

procedure TBodyTypesGroup2.DoAfterDelete(Sender: TObject);
begin
  Assert(qBodyKinds.W.DeletedPKValue > 0);
  // На сервере типы корпусов уже каскадно удалились
  // Каскадно удаляем типы корпусов с клиента
  qBodyTypes2.W.CascadeDelete(qBodyKinds.W.DeletedPKValue,
    qBodyTypes2.W.IDBodyKind.FieldName, True);
end;

function TBodyTypesGroup2.GetqBodyKinds: TQueryBodyKinds;
begin
  if FqBodyKinds = nil then
    FqBodyKinds := TQueryBodyKinds.Create(Self);

  Result := FqBodyKinds;
end;

function TBodyTypesGroup2.GetqBodyKindsColor: TQryBodyKindsColor;
begin
  if FqBodyKindsColor = nil then
    FqBodyKindsColor := TQryBodyKindsColor.Create(Self);

  Result := FqBodyKindsColor;
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

function TBodyTypesGroup2.GetqSearchBodyVariation: TQrySearchBodyVariation;
begin
  if FqSearchBodyVariation = nil then
    FqSearchBodyVariation := TQrySearchBodyVariation.Create(Self);
  Result := FqSearchBodyVariation;
end;

function TBodyTypesGroup2.GetQueryBodyTypesSimple: TQueryBodyTypesSimple;
begin
  if FQueryBodyTypesSimple = nil then
  begin
    FQueryBodyTypesSimple := TQueryBodyTypesSimple.Create(Self);
  end;

  Result := FQueryBodyTypesSimple;
end;

procedure TBodyTypesGroup2.LoadDataFromExcelTable(ABodyTypesExcelTable
  : TBodyTypesExcelTable; AIDProducer: Integer);
var
  AField: TField;
  AProducerID: Integer;
  F: TField;
begin
  ABodyTypesExcelTable.DisableControls;
  try
    QueryBodyTypesSimple.W.RefreshQuery;

    ABodyTypesExcelTable.First;
    ABodyTypesExcelTable.CallOnProcessEvent;
    QueryBodyTypesSimple.ClearUpdateRecCount;
    while not ABodyTypesExcelTable.Eof do
    begin
      if AIDProducer > 0 then
        AProducerID := AIDProducer
      else
        AProducerID := (ABodyTypesExcelTable as TBodyTypesExcelTable2)
          .IDProducer.AsInteger;

      // ищем или добавляем корень - вид корпуса
      qBodyKinds.W.LocateOrAppend(ABodyTypesExcelTable.BodyKind.AsString);

      QueryBodyTypesSimple.W.TryAppend;
      QueryBodyTypesSimple.W.IDProducer.F.AsInteger := AProducerID;
      QueryBodyTypesSimple.W.IDBodyKind.F.Value := qBodyKinds.W.PK.Value;
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

      QueryBodyTypesSimple.W.TryPost;
      QueryBodyTypesSimple.IncUpdateRecCount;

      ABodyTypesExcelTable.Next;
      ABodyTypesExcelTable.CallOnProcessEvent;
    end;
    // Финальный коммит
    QueryBodyTypesSimple.FDQuery.Connection.Commit;

    // Обновляем данные в сгруппированном запросе
    qBodyTypes2.W.RefreshQuery;
  finally
    ABodyTypesExcelTable.EnableControls;
  end;

end;

procedure TBodyTypesGroup2.Re_Open(AShowDuplicate: Boolean);
begin
  qBodyTypes2.W.TryPost;
  qBodyKinds.W.TryPost;

  SaveBookmark;

  qBodyTypes2.ShowDuplicate := AShowDuplicate;
  qBodyKinds.ShowDuplicate := AShowDuplicate;

  RestoreBookmark;
end;

procedure TBodyTypesGroup2.Rollback;
begin
  inherited;
  qBodyTypes2.RefreshLinkedData;
end;

function TBodyTypesGroup2.Search(ABodyVariation: String): Boolean;
begin
  Assert(not ABodyVariation.IsEmpty);

  Result := False;

  // Если нашли такой вариант корпуса
  if qSearchBodyVariation.SearchVariation(ABodyVariation) > 0 then
  begin
    // Запрещаем всем компонентам отображать данные
    // Иначе cxGrid ведёт себя неадекватно
    qBodyTypes2.W.DataSource.Enabled := False;
    qBodyKinds.W.DataSource.Enabled := False;
    try
      qBodyTypes2.W.IDS.Locate(qSearchBodyVariation.W.IDS.F.AsString, [], True);
      qBodyKinds.W.ID.Locate(qBodyTypes2.W.IDBodyKind.F.AsInteger, [], True);
    finally
      // Разрешаем всем компонентам отображать данные
      qBodyKinds.W.DataSource.Enabled := True;
      qBodyTypes2.W.DataSource.Enabled := True;
    end;

    Result := True;
  end;
end;

end.
