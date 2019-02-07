unit ParametersGroupUnit2;

interface

uses
  QueryGroupUnit2, System.Classes, ParameterKindsQuery, ParametersQuery,
  ParameterTypesQuery, ParamSubParamsQuery, SubParametersQuery2,
  System.Generics.Collections, ParametersExcelDataModule, NotifyEvents,
  RecordCheck, DSWrap;

type
  TParametersGroup2 = class(TQueryGroup2, IParametersGroup)
  strict private
    function Check(AParametersExcelTable: TParametersExcelTable)
      : TRecordCheck; stdcall;
  private
    FProductCategoryIDValue: Integer;
    FqParameterKinds: TQueryParameterKinds;
    FqParameters: TQueryParameters;
    FqParameterTypes: TQueryParameterTypes;
    procedure DoBeforeDelete(Sender: TObject);
    function GetqParameterKinds: TQueryParameterKinds;
    procedure SetProductCategoryIDValue(const Value: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    procedure Commit; override;
    procedure DeleteParamType(AID: Integer);
    function Find(const AFieldName, S: string): TArray<String>;
    procedure LoadDataFromExcelTable(AParametersExcelTable
      : TParametersExcelTable);
    function LocateAll(AParameterID: Integer): Boolean;
    property ProductCategoryIDValue: Integer read FProductCategoryIDValue
      write SetProductCategoryIDValue;
    property qParameterKinds: TQueryParameterKinds read GetqParameterKinds;
    property qParameters: TQueryParameters read FqParameters;
    property qParameterTypes: TQueryParameterTypes read FqParameterTypes;
  end;

implementation

uses
  System.SysUtils, Data.DB, ParameterKindEnum, ErrorType, System.Variants,
  FireDAC.Comp.DataSet;

constructor TParametersGroup2.Create(AOwner: TComponent);
begin
  inherited;
  // ���� ����������
  FqParameterTypes := TQueryParameterTypes.Create(Self);
  // ���������
  FqParameters := TQueryParameters.Create(Self);

  QList.Add(qParameterTypes); // ��� ������� ���������
  QList.Add(qParameters); // ���� ���������

  // ��� ���������� ��������
  TNotifyEventWrap.Create(qParameterTypes.W.BeforeDelete, DoBeforeDelete,
    EventList);
end;

function TParametersGroup2.Check(AParametersExcelTable: TParametersExcelTable)
  : TRecordCheck;
var
  AFieldNames: string;
  AParameterKindID: Integer;
  AIDParameterType: Integer;
  Arr: Variant;
  V: Variant;
begin
  Result.ErrorType := etNone;

  // ���������, ��� � ����� ����� �����
  AParameterKindID :=
    StrToIntDef(AParametersExcelTable.ParameterKindID.AsString, -100);

  // ���� ��� ��������� ����� �������
  if AParameterKindID = -100 then
  begin
    // ���� � ����������� ����� ����������
    AParameterKindID := qParameterKinds.W.GetIDByParameterKind
      (AParametersExcelTable.ParameterKindID.AsString);

    if AParameterKindID = 0 then
    begin
      // ����������, ��� � ���� ������ ������
      Result.ErrorType := etError;
      Result.Row := AParametersExcelTable.ExcelRow.AsInteger;
      Result.Col := AParametersExcelTable.ParameterKindID.Index + 1;
      Result.ErrorMessage := AParametersExcelTable.ParameterKindID.AsString;
      Result.Description :=
        Format('��� ���� ��������� ������ ���� ����� ������ �� %d �� %d',
        [Integer(��������������), Integer(���������_���������)]);
      Exit;
    end;
  end
  else
  begin
    if (AParameterKindID < Integer(��������������)) or
      (AParameterKindID > Integer(���������_���������)) then
    begin
      // ����������, ��� � ���� ������ ������
      Result.ErrorType := etError;
      Result.Row := AParametersExcelTable.ExcelRow.AsInteger;
      Result.Col := AParametersExcelTable.ParameterKindID.Index + 1;
      Result.ErrorMessage := AParametersExcelTable.ParameterKindID.AsString;
      Result.Description := Format('��� ���� ��������� ������ ���� �� %d �� %d',
        [Integer(��������������), Integer(���������_���������)]);
      Exit;
    end;
  end;

  // ������������ � ����� ���������
  AIDParameterType := qParameterTypes.W.GetParameterTypeID
    (AParametersExcelTable.ParameterType.AsString);

  // ���� ��� ������������ ����� ��� ���������
  if AIDParameterType > 0 then
  begin

    // �������� ��� ������ ��������
    AFieldNames := Format('%s;%s;%s;%s;%s;%s;%s;%s',
      [qParameters.W.Value.FieldName, qParameters.W.ValueT.FieldName,
      qParameters.W.CodeLetters.FieldName,
      qParameters.W.MeasuringUnit.FieldName, qParameters.W.TableName.FieldName,
      qParameters.W.Definition.FieldName,
      qParameters.W.IDParameterType.FieldName,
      qParameters.W.IDParameterKind.FieldName]);

    with AParametersExcelTable do
      Arr := VarArrayOf([Value.Value, ValueT.Value, CodeLetters.Value,
        MeasuringUnit.Value, TableName.Value, Definition.Value,
        AIDParameterType, AParameterKindID]);

    // ���� ��������
    V := qParameters.FDQuery.LookupEx(AFieldNames, Arr, qParameters.PKFieldName,
      [lxoCaseInsensitive]);

    if not VarIsNull(V) then
    begin
      // ����������, ��� � ���� ������ ������
      Result.ErrorType := etError;
      Result.Row := AParametersExcelTable.ExcelRow.AsInteger;
      Result.Col := AParametersExcelTable.TableName.Index + 1;
      Result.ErrorMessage := AParametersExcelTable.TableName.AsString;
      Result.Description :=
        '����� ����� �� �������� ��� ���� � ����������� ����������';
      Exit;
    end;
  end;

  AFieldNames := Format('%s;%s', [qParameters.W.TableName.FieldName,
    qParameters.W.IsCustomParameter.FieldName]);

  Arr := VarArrayOf([AParametersExcelTable.TableName.Value, False]);

  // ���� �������� �� ���������� �����
  V := qParameters.FDQuery.LookupEx(AFieldNames, Arr, qParameters.PKFieldName,
    [lxoCaseInsensitive]);

  if not VarIsNull(V) then
  begin
    // ����������, ��� � ���� ������ ������
    Result.ErrorType := etWarring;
    Result.Row := AParametersExcelTable.ExcelRow.AsInteger;
    Result.Col := AParametersExcelTable.TableName.Index + 1;
    Result.ErrorMessage := AParametersExcelTable.TableName.AsString;
    Result.Description :=
      '�������� � ����� ��������� ������ ��� ���� � ����������� ����������';
    Exit;
  end;
end;

procedure TParametersGroup2.Commit;
begin
  // ������ �� � ������ ����������� ������� ��� �����-�� ���������
  if ProductCategoryIDValue > 0 then
    TryPost
  else
    inherited;
end;

procedure TParametersGroup2.DeleteParamType(AID: Integer);
var
  ASQL: string;
begin
  ASQL := Format('delete from ParameterTypes where ID = %d', [AID]);
  Connection.ExecSQL(ASQL);
end;

procedure TParametersGroup2.DoBeforeDelete(Sender: TObject);
var
  AIDParameterType: Integer;
begin
  AIDParameterType := qParameterTypes.PK.Value;
  // �������� ������� ���������
  qParameters.W.CascadeDelete(AIDParameterType,
    qParameters.W.IDParameterType.FieldName);

  // cxGrid ������� ������, ������� ������������ �� �����
  qParameterTypes.LocateByPK(AIDParameterType, True);
end;

function TParametersGroup2.Find(const AFieldName, S: string): TArray<String>;
var
  L: TList<String>;
begin
  Assert(not AFieldName.IsEmpty);
  L := TList<String>.Create();

  // �������� ������ ����� ���������� �� ������-�� ����
  if qParameters.LocateByField(AFieldName, S) then
  begin
    qParameterTypes.LocateByPK(qParameters.W.IDParameterType.F.Value, True);

    // ���������� ��� ���� ������ �� ������ ������
    L.Add(qParameterTypes.W.ParameterType.F.AsString);
    // ���������� ��� ���� ������ �� ������ ������
    L.Add(S);
  end
  else
    // �������� ������ ����� ����� ����������
    if qParameterTypes.LocateByField(qParameterTypes.W.ParameterType.FieldName, S)
    then
    begin
      L.Add(S);
    end;

  Result := L.ToArray;
end;

function TParametersGroup2.GetqParameterKinds: TQueryParameterKinds;
begin
  if FqParameterKinds = nil then
  begin
    FqParameterKinds := TQueryParameterKinds.Create(Self);
    FqParameterKinds.FDQuery.Open;
//    FqParameterKinds.W.ParameterKind.F.DisplayLabel := '��� ���������';
  end;
  Result := FqParameterKinds;
end;

procedure TParametersGroup2.LoadDataFromExcelTable(AParametersExcelTable
  : TParametersExcelTable);
var
  AField: TField;
  AParameterKindID: Integer;
  AParameterType: string;
  I: Integer;
begin
  TryPost;
  if qParameterKinds.FDQuery.RecordCount = 0 then
    raise Exception.Create('���������� ����� ���������� �� ��������');

  AParametersExcelTable.DisableControls;
  qParameterTypes.FDQuery.DisableControls;
  qParameters.FDQuery.DisableControls;
  try
    AParametersExcelTable.First;
    AParametersExcelTable.CallOnProcessEvent;
    while not AParametersExcelTable.Eof do
    begin
      AParameterType := AParametersExcelTable.ParameterType.AsString;
      qParameterTypes.W.LocateOrAppend(AParameterType);

      AParameterKindID :=
        StrToIntDef(AParametersExcelTable.ParameterKindID.AsString, -1);
      // ���� ��� ��������� �� ��������
      if AParameterKindID = -1 then
      begin
        // ���� ����� ����� ��� ��������� � �����������
        if qParameterKinds.LocateByField
          (qParameterKinds.W.ParameterKind.FieldName,
          AParametersExcelTable.ParameterKindID.AsString) then
          AParameterKindID := qParameterKinds.PK.AsInteger
        else
          AParameterKindID := Integer(��������������);
      end
      else
      begin
        // ���� ����� ��� ��������� � �����������
        if not qParameterKinds.LocateByPK(AParameterKindID) then
          AParameterKindID := Integer(��������������);
      end;

      qParameters.FDQuery.Append;
      try
        for I := 0 to AParametersExcelTable.FieldCount - 1 do
        begin
          AField := qParameters.FDQuery.FindField
            (AParametersExcelTable.Fields[I].FieldName);
          if AField <> nil then
          begin
            AField.Value := AParametersExcelTable.Fields[I].Value;
          end;
        end;

        qParameters.W.IDParameterType.F.AsInteger :=
          qParameterTypes.PK.AsInteger;
        qParameters.W.IDParameterKind.F.AsInteger := AParameterKindID;

        qParameters.FDQuery.Post;
      except
        qParameters.FDQuery.Cancel;
        raise;
      end;

      AParametersExcelTable.Next;
      AParametersExcelTable.CallOnProcessEvent;
    end;
  finally
    AParametersExcelTable.EnableControls;
    qParameters.FDQuery.EnableControls;
    qParameterTypes.FDQuery.EnableControls;
  end;
end;

function TParametersGroup2.LocateAll(AParameterID: Integer): Boolean;
begin
  // ������� ���� ��������
  Result := qParameters.LocateByPK(AParameterID);
  if not Result then
    Exit;

  // ���� ��� ���������
  qParameterTypes.LocateByPK(qParameters.W.IDParameterType.F.AsInteger, True);
end;

procedure TParametersGroup2.SetProductCategoryIDValue(const Value: Integer);
begin
  if FProductCategoryIDValue = Value then
    Exit;

  FProductCategoryIDValue := Value;
//  qParameters.ProductCategoryIDValue := FProductCategoryIDValue;

  // �������� ����������� ���������
  qParameters.W.ProductCategoryID.DefaultValue := FProductCategoryIDValue;
end;

end.
