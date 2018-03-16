unit ProducersGroupUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, QueryGroupUnit, Vcl.ExtCtrls,
  ProducersQuery, BaseQuery, BaseEventsQuery, QueryWithMasterUnit,
  QueryWithDataSourceUnit, ProducerTypesQuery, ProducersExcelDataModule,
  OrderQuery, System.Generics.Collections;

type
  TProducersGroup = class(TQueryGroup)
  private
    FqProducers: TQueryProducers;
    FqProducerTypes: TQueryProducerTypes;
    function GetqProducers: TQueryProducers;
    function GetqProducerTypes: TQueryProducerTypes;
    procedure SetqProducers(const Value: TQueryProducers);
    { Private declarations }
  protected
    procedure DoAfterDelete(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    function Find(const AFieldName, S: string): TList<String>;
    procedure LoadDataFromExcelTable(AProducersExcelTable: TProducersExcelTable);
    procedure LocateOrAppend(AValue: string; const AProducerType: String);
    property qProducers: TQueryProducers read GetqProducers write SetqProducers;
    property qProducerTypes: TQueryProducerTypes read GetqProducerTypes;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses Data.DB, NotifyEvents;

constructor TProducersGroup.Create(AOwner: TComponent);
begin
  inherited;
  Main := qProducerTypes;
  Detail := qProducers;

  // ��� ���������� ��������
  TNotifyEventWrap.Create(qProducerTypes.AfterDelete, DoAfterDelete);
end;

procedure TProducersGroup.DoAfterDelete(Sender: TObject);
begin
  Assert(qProducerTypes.OldPKValue > 0);
  // �������� ������� ��������������
  qProducers.CascadeDelete(qProducerTypes.OldPKValue,
    qProducers.ProducerTypeID.FieldName, True);
end;

function TProducersGroup.Find(const AFieldName, S: string): TList<String>;
begin
  Assert(not AFieldName.IsEmpty);
  Result := TList<String>.Create();

  // �������� ������ ����� �������������� �� ������-�� ����
  if qProducers.LocateByField(AFieldName, S) then
  begin
    qProducerTypes.LocateByPK(qProducers.ProducerTypeID.Value, True);
    // ���������� ��� ���� ������ �� ������ ������
    Result.Add(qProducerTypes.ProducerType.AsString);
    // ���������� ��� ���� ������ �� ������ ������
    Result.Add(S);
  end
  else
    // �������� ������ ����� ����� ����������
    if qProducerTypes.LocateByField(qProducerTypes.ProducerType.FieldName, S) then
    begin
      Result.Add(S);
    end;

end;

function TProducersGroup.GetqProducers: TQueryProducers;
begin
  if FqProducers = nil then
    FqProducers := TQueryProducers.Create(Self);

  Result := FqProducers;
end;

function TProducersGroup.GetqProducerTypes: TQueryProducerTypes;
begin
  if FqProducerTypes = nil then
    FqProducerTypes := TQueryProducerTypes.Create(Self);

  Result := FqProducerTypes;
end;

procedure TProducersGroup.LoadDataFromExcelTable(AProducersExcelTable:
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
        qProducers.TryEdit
      else
        qProducers.TryAppend;

      // ��������� ������������� � ��� �����
      qProducers.ProducerTypeID.AsInteger := qProducerTypes.PK.AsInteger;

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

procedure TProducersGroup.LocateOrAppend(AValue: string; const AProducerType:
    String);
var
  OK: Boolean;
begin
  OK := qProducers.Locate(AValue);

  if OK then
    Exit;

  qProducerTypes.LocateOrAppend(AProducerType);
  qProducers.AddNewValue(AValue, qProducerTypes.PK.AsInteger);
end;

procedure TProducersGroup.SetqProducers(const Value: TQueryProducers);
begin
  FqProducers := Value;
end;

end.
