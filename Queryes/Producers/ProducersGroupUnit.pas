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
    qProducerTypes: TQueryProducerTypes;
    qProducers: TQueryProducers;
  private
    { Private declarations }
  protected
    procedure DoAfterDelete(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    function Find(const AFieldName, S: string): TList<String>;
    procedure InsertRecordList(AProducersExcelTable: TProducersExcelTable);
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
var
  OK: Boolean;
begin
  Assert(not AFieldName.IsEmpty);
  Result := TList<String>.Create();

  // �������� ������ ����� �������������� �� ������-�� ����
  if qProducers.LocateByField(AFieldName, S) then
  begin
    OK := qProducerTypes.LocateByPK(qProducers.ProducerTypeID.Value);
    Assert(OK);
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

procedure TProducersGroup.InsertRecordList(AProducersExcelTable
  : TProducersExcelTable);
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

end.
