unit ProducersGroupUnit2;

interface

uses
  QueryGroupUnit2, System.Classes, NotifyEvents, ProducersQuery,
  ProducerTypesQuery, System.Generics.Collections, ProducersExcelDataModule;

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
    function Find(const AFieldName, S: string): TList<String>;
    procedure LoadDataFromExcelTable(AProducersExcelTable: TProducersExcelTable);
    procedure LocateOrAppend(AValue: string; const AProducerType: String);
    property qProducers: TQueryProducers read GetqProducers write SetqProducers;
    property qProducerTypes: TQueryProducerTypes read GetqProducerTypes;
  end;

implementation

uses
  System.SysUtils, Data.DB;

constructor TProducersGroup2.Create(AOwner: TComponent);
begin
  inherited;
  QList.Add(qProducerTypes);
  QList.Add(qProducers);

  // ��� ���������� ��������
  TNotifyEventWrap.Create(qProducerTypes.W.AfterDelete, DoAfterDelete, EventList);
end;

procedure TProducersGroup2.DoAfterDelete(Sender: TObject);
begin
  Assert(qProducerTypes.W.DeletedPKValue > 0);
  // �� ������� ���� �������������� ��� �������� ���������
  // �������� ������� �������������� � �������
  qProducers.W.CascadeDelete(qProducerTypes.W.DeletedPKValue,
    qProducers.W.ProducerTypeID.FieldName, True);
end;

function TProducersGroup2.Find(const AFieldName, S: string): TList<String>;
begin
  Assert(not AFieldName.IsEmpty);
  Result := TList<String>.Create();

  // �������� ������ ����� �������������� �� ������-�� ����
  if qProducers.LocateByField(AFieldName, S) then
  begin
    qProducerTypes.LocateByPK(qProducers.W.ProducerTypeID.F.Value, True);
    // ���������� ��� ���� ������ �� ������ ������
    Result.Add(qProducerTypes.W.ProducerType.F.AsString);
    // ���������� ��� ���� ������ �� ������ ������
    Result.Add(S);
  end
  else
    // �������� ������ ����� ����� ����������
    if qProducerTypes.LocateByField(qProducerTypes.W.ProducerType.FieldName, S) then
    begin
      Result.Add(S);
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

procedure TProducersGroup2.LoadDataFromExcelTable(AProducersExcelTable:
    TProducersExcelTable);
var
  AField: TField;
  I: Integer;
begin
  qProducerTypes.FDQuery.DisableControls;
  qProducers.FDQuery.DisableControls;
  try
    // ���� �� ���� �������, ������� ����� ���������
    AProducersExcelTable.First;
    AProducersExcelTable.CallOnProcessEvent;
    while not AProducersExcelTable.Eof do
    begin
      qProducerTypes.LocateOrAppend
        (AProducersExcelTable.ProducerType.AsString.Trim);

      // ���� ������������� � ����� ������ ��� ����
      if qProducers.Locate(AProducersExcelTable.Name.AsString.Trim) then
        qProducers.W.TryEdit
      else
        qProducers.W.TryAppend;

      // ��������� ������������� � ��� �����
      qProducers.W.ProducerTypeID.F.AsInteger := qProducerTypes.PK.AsInteger;

      for I := 0 to AProducersExcelTable.FieldCount - 1 do
      begin
        AField := qProducers.FDQuery.FindField(AProducersExcelTable.Fields[I]
          .FieldName);
        if AField <> nil then
          AField.Value := AProducersExcelTable.Fields[I].Value;
      end;

      qProducers.TryPost;

      AProducersExcelTable.Next;
      AProducersExcelTable.CallOnProcessEvent;
    end;

  finally
    qProducers.FDQuery.EnableControls;
    qProducerTypes.FDQuery.EnableControls;
  end;
end;

procedure TProducersGroup2.LocateOrAppend(AValue: string; const AProducerType:
    String);
var
  OK: Boolean;
begin
  OK := qProducers.Locate(AValue);

  if OK then
    Exit;

  qProducerTypes.LocateOrAppend(AProducerType);
  qProducers.W.AddNewValue(AValue, qProducerTypes.PK.AsInteger);
end;

procedure TProducersGroup2.SetqProducers(const Value: TQueryProducers);
begin
  FqProducers := Value;
end;

end.
