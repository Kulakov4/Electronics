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
    FqDescriptionTypes: TQueryDescriptionTypes;
    FqProducers: TQueryProducers;
    procedure DoAfterDelete(Sender: TObject);
    function GetqDescriptions: TQueryDescriptions;
    function GetqDescriptionTypes: TQueryDescriptionTypes;
    function GetqProducers: TQueryProducers;
  public
    constructor Create(AOwner: TComponent); override;
    function Find(const AFieldName, S: string): TList<String>;
    procedure LoadDataFromExcelTable(ADescriptionsExcelTable :
        TDescriptionsExcelTable);
    procedure LocateDescription(AIDDescription: Integer);
    property qDescriptions: TQueryDescriptions read GetqDescriptions;
    property qDescriptionTypes: TQueryDescriptionTypes read GetqDescriptionTypes;
    property qProducers: TQueryProducers read GetqProducers;
  end;

implementation

uses
  System.SysUtils, Data.DB;

constructor TDescriptionsGroup2.Create(AOwner: TComponent);
begin
  inherited;
  QList.Add(qDescriptionTypes);
  QList.Add(qDescriptions);
  QList.Add(qProducers);

  // ��� ���������� ��������
  TNotifyEventWrap.Create(qDescriptionTypes.W.AfterDelete, DoAfterDelete,
    EventList);
end;

procedure TDescriptionsGroup2.DoAfterDelete(Sender: TObject);
begin
  Assert(qDescriptionTypes.W.DeletedPKValue > 0);
  // �� ������� ������� �������� ��� �������� ���������
  // �������� ������� ������� �������� � �������
  qDescriptions.CascadeDelete(qDescriptionTypes.W.DeletedPKValue,
    qDescriptions.W.IDComponentType.FieldName, True);
end;

function TDescriptionsGroup2.Find(const AFieldName, S: string): TList<String>;
begin
  Assert(not AFieldName.IsEmpty);
  Result := TList<String>.Create();

  // �������� ������ ����� ������� �������� �� ������-�� ����
  if qDescriptions.LocateByField(AFieldName, S) then
  begin
    qDescriptionTypes.LocateByPK(qDescriptions.W.IDComponentType.F.Value, True);
    // ���������� ��� ���� ������ �� ������ ������
    Result.Add(qDescriptionTypes.W.ComponentType.F.AsString);
    // ���������� ��� ���� ������ �� ������ ������
    Result.Add(S);
  end
  else
    // �������� ������ ����� ����� ������� ��������
    if qDescriptionTypes.LocateByField
      (qDescriptionTypes.W.ComponentType.FieldName, S) then
    begin
      Result.Add(S);
    end;

end;

function TDescriptionsGroup2.GetqDescriptions: TQueryDescriptions;
begin
  if FqDescriptions = nil then
    FqDescriptions := TQueryDescriptions.Create(Self);

  Result := FqDescriptions;
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

procedure TDescriptionsGroup2.LoadDataFromExcelTable(ADescriptionsExcelTable :
    TDescriptionsExcelTable);
var
  AField: TField;
  I: Integer;
begin
  qDescriptions.FDQuery.DisableControls;
  qDescriptionTypes.FDQuery.DisableControls;
  try
    // ���� �� ���� �������, ������� ����� ���������
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
      qDescriptions.W.IDComponentType.F.Value := qDescriptionTypes.PK.Value;
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
    qDescriptions.LocateByPK(AIDDescription);
    qDescriptionTypes.LocateByPK(qDescriptions.W.IDComponentType.F.AsInteger);
  finally
    qDescriptionTypes.FDQuery.EnableControls;
    qDescriptions.FDQuery.EnableControls;
  end;
end;

end.
