unit DescriptionsGroupUnit2;

interface

uses
  QueryGroupUnit2, System.Classes, DescriptionsQuery, DescriptionTypesQuery,
  ProducersQuery, DescriptionsExcelDataModule, System.Generics.Collections,
  NotifyEvents;

type
  TDescriptionsGroup2 = class(TQueryGroup2)
  private
    FqDescriptions: TQueryDescriptions;
    FqDescriptions2: TQueryDescriptions;
    FqDescriptionTypes: TQueryDescriptionTypes;
    FqProducers: TQueryProducers;
    procedure DoAfterDelete(Sender: TObject);
    function GetqDescriptions: TQueryDescriptions;
    function GetqDescriptions2: TQueryDescriptions;
    function GetqDescriptionTypes: TQueryDescriptionTypes;
    function GetqProducers: TQueryProducers;
  protected
    property qDescriptions2: TQueryDescriptions read GetqDescriptions2;
  public
    constructor Create(AOwner: TComponent); override;
    function Find(const AFieldName, S: string): TList<String>;
    procedure LoadDataFromExcelTable(ADescriptionsExcelTable
      : TDescriptionsExcelTable);
    procedure LocateDescription(AIDDescription: Integer);
    function Re_Open(AShowDuplicate: Boolean;
      const AComponentName: string): Boolean;
    property qDescriptions: TQueryDescriptions read GetqDescriptions;
    property qDescriptionTypes: TQueryDescriptionTypes
      read GetqDescriptionTypes;
    property qProducers: TQueryProducers read GetqProducers;
  end;

implementation

uses
  System.SysUtils, Data.DB, FireDAC.Comp.DataSet;

constructor TDescriptionsGroup2.Create(AOwner: TComponent);
begin
  inherited;
  QList.Add(qDescriptionTypes);
  QList.Add(qDescriptions);
  QList.Add(qProducers);

  // Для каскадного удаления
  TNotifyEventWrap.Create(qDescriptionTypes.W.AfterDelete, DoAfterDelete,
    EventList);
end;

procedure TDescriptionsGroup2.DoAfterDelete(Sender: TObject);
begin
  Assert(qDescriptionTypes.W.DeletedPKValue > 0);
  // На сервере краткие описания уже каскадно удалились
  // Каскадно удаляем краткие описания с клиента
  qDescriptions.W.CascadeDelete(qDescriptionTypes.W.DeletedPKValue,
    qDescriptions.W.IDComponentType.FieldName, True);
end;

function TDescriptionsGroup2.Find(const AFieldName, S: string): TList<String>;
begin
  Assert(not AFieldName.IsEmpty);
  Result := TList<String>.Create();

  // Пытаемся искать среди кратких описаний по какому-то полю
  if qDescriptions.W.LocateByF(AFieldName, S,
    [lxoCaseInsensitive, lxoPartialKey]) then
  begin
    qDescriptionTypes.W.LocateByPK
      (qDescriptions.W.IDComponentType.F.Value, True);
    // запоминаем что надо искать на первом уровне
    Result.Add(qDescriptionTypes.W.ComponentType.F.AsString);
    // запоминаем что надо искать на втором уровне
    Result.Add(S);
  end
  else
    // Пытаемся искать среди типов кратких описаний
    if qDescriptionTypes.W.LocateByF
      (qDescriptionTypes.W.ComponentType.FieldName, S,
      [lxoCaseInsensitive, lxoPartialKey]) then
    begin
      Result.Add(S);
    end;

end;

function TDescriptionsGroup2.GetqDescriptions: TQueryDescriptions;
begin
  if FqDescriptions = nil then
  begin
    FqDescriptions := TQueryDescriptions.Create(Self);
    FqDescriptions.Name := 'qDescriptions';
  end;

  Result := FqDescriptions;
end;

function TDescriptionsGroup2.GetqDescriptions2: TQueryDescriptions;
begin
  if FqDescriptions2 = nil then
    FqDescriptions2 := TQueryDescriptions.Create(Self);

  Result := FqDescriptions2;
end;

function TDescriptionsGroup2.GetqDescriptionTypes: TQueryDescriptionTypes;
begin
  if FqDescriptionTypes = nil then
    FqDescriptionTypes := TQueryDescriptionTypes.Create(Self);
  Result := FqDescriptionTypes;
end;

function TDescriptionsGroup2.GetqProducers: TQueryProducers;
begin
  if FqProducers = nil then
  begin
    FqProducers := TQueryProducers.Create(Self);
    FqProducers.FDQuery.Open;
  end;
  Result := FqProducers;
end;

procedure TDescriptionsGroup2.LoadDataFromExcelTable(ADescriptionsExcelTable
  : TDescriptionsExcelTable);
var
  AField: TField;
  I: Integer;
begin
  qDescriptions.FDQuery.DisableControls;
  qDescriptionTypes.FDQuery.DisableControls;
  try
    // Цикл по всем записям, которые будем добавлять
    ADescriptionsExcelTable.First;
    ADescriptionsExcelTable.CallOnProcessEvent;
    while not ADescriptionsExcelTable.Eof do
    begin
      qDescriptionTypes.W.LocateOrAppend
        (ADescriptionsExcelTable.ComponentType.AsString);

      qDescriptions.FDQuery.Append;

      for I := 0 to ADescriptionsExcelTable.FieldCount - 1 do
      begin
        AField := qDescriptions.FDQuery.FindField
          (ADescriptionsExcelTable.Fields[I].FieldName);
        if AField <> nil then
          AField.Value := ADescriptionsExcelTable.Fields[I].Value;
      end;
      qDescriptions.W.IDComponentType.F.Value := qDescriptionTypes.W.PK.Value;
      qDescriptions.W.IDProducer.F.Value :=
        ADescriptionsExcelTable.IDProducer.Value;
      qDescriptions.FDQuery.Post;

      ADescriptionsExcelTable.Next;
      ADescriptionsExcelTable.CallOnProcessEvent;
    end;

  finally
    qDescriptions.FDQuery.EnableControls;
    qDescriptionTypes.FDQuery.EnableControls;
  end;
end;

procedure TDescriptionsGroup2.LocateDescription(AIDDescription: Integer);
begin
  Assert(AIDDescription > 0);

  qDescriptions.FDQuery.DisableControls;
  qDescriptionTypes.FDQuery.DisableControls;
  try
    qDescriptions.W.LocateByPK(AIDDescription);
    qDescriptionTypes.W.LocateByPK(qDescriptions.W.IDComponentType.F.AsInteger);
  finally
    qDescriptionTypes.FDQuery.EnableControls;
    qDescriptions.FDQuery.EnableControls;
  end;
end;

function TDescriptionsGroup2.Re_Open(AShowDuplicate: Boolean;
  const AComponentName: string): Boolean;
begin
  qDescriptions.W.TryPost;
  qDescriptionTypes.W.TryPost;

  // Сначала попытаемся применить фильтр на "запасном" запросе
  Result := qDescriptions2.TryApplyFilter(AShowDuplicate, AComponentName);
  if not Result then
    Exit;

  SaveBookmark;

  qDescriptions.TryApplyFilter(AShowDuplicate, AComponentName);
  qDescriptionTypes.TryApplyFilter(AShowDuplicate, AComponentName);

  RestoreBookmark;
end;

end.
