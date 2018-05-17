unit ParametersGroupUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, ParameterTypesQuery, ParametersQuery, FireDAC.Comp.Client,
  FireDAC.Stan.Intf, NotifyEvents, ParametersExcelDataModule,
  System.Generics.Collections, FireDAC.Stan.Option,  FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,  FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  QueryWithDataSourceUnit, BaseQuery, BaseEventsQuery, QueryWithMasterUnit,
  QueryGroupUnit, OrderQuery, ParameterKindsQuery,
  SubParametersQuery2, ParamSubParamsQuery;

type
  TParametersGroup = class(TQueryGroup)
  private
    FProductCategoryIDValue: Integer;
    FqParameterKinds: TQueryParameterKinds;
    FqParameters: TQueryParameters;
    FqParameterTypes: TQueryParameterTypes;
    FqParamSubParams: TQueryParamSubParams;
    FqSubParameters: TQuerySubParameters2;
    procedure DoBeforeDelete(Sender: TObject);
    function GetqParameterKinds: TQueryParameterKinds;
    procedure SetProductCategoryIDValue(const Value: Integer);
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ApplyUpdates: Boolean; override;
    function Find(const AFieldName, S: string): TList<String>;
    procedure LoadDataFromExcelTable(AParametersExcelTable: TParametersExcelTable);
    function LocateAll(AParameterID: Integer): Boolean;
    procedure ReOpen; override;
    procedure Rollback; override;
    procedure TryPost; override;
    property ProductCategoryIDValue: Integer read FProductCategoryIDValue write
        SetProductCategoryIDValue;
    property qParameterKinds: TQueryParameterKinds read GetqParameterKinds;
    property qParameters: TQueryParameters read FqParameters;
    property qParameterTypes: TQueryParameterTypes read FqParameterTypes;
    property qParamSubParams: TQueryParamSubParams read FqParamSubParams;
    property qSubParameters: TQuerySubParameters2 read FqSubParameters;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses RepositoryDataModule, ParameterKindEnum;

constructor TParametersGroup.Create(AOwner: TComponent);
begin
  inherited;
  // ���� ����������
  FqParameterTypes := TQueryParameterTypes.Create(Self);
  // ���������
  FqParameters := TQueryParameters.Create(Self);
  // ����� � ��������������
  FqParamSubParams := TQueryParamSubParams.Create(Self);
  // ������������
  FqSubParameters := TQuerySubParameters2.Create(Self);

  Main := qParameterTypes;
  Detail := qParameters;

  // ��� ���������� ��������
  TNotifyEventWrap.Create(qParameterTypes.BeforeDelete, DoBeforeDelete, EventList);
end;

destructor TParametersGroup.Destroy;
begin
  inherited;
end;

function TParametersGroup.ApplyUpdates: Boolean;
begin
  CheckMasterAndDetail;

  // �������������� ��� �� �������� � ����������
  Assert(Connection.InTransaction);

  qParameterTypes.ApplyUpdates(False);
  qParameters.ApplyUpdates(False);
  qSubParameters.ApplyUpdates(False);
  qParamSubParams.ApplyUpdates(False);

  Connection.Commit;
  Result := (not Main.HaveAnyChanges) and (not Detail.HaveAnyChanges);

  AfterCommit.CallEventHandlers(Self);

end;

procedure TParametersGroup.DoBeforeDelete(Sender: TObject);
begin
  // �������� ������� ���������
  qParameters.CascadeDelete(qParameterTypes.PK.Value,
    qParameters.IDParameterType.FieldName);
end;

function TParametersGroup.Find(const AFieldName, S: string): TList<String>;
begin
  Assert(not AFieldName.IsEmpty);
  Result := TList<String>.Create();

  // �������� ������ ����� ���������� �� ������-�� ����
  if qParameters.LocateByField(AFieldName, S) then
  begin
    qParameterTypes.LocateByPK(qParameters.IDParameterType.Value, True);
    // ���������� ��� ���� ������ �� ������ ������
    Result.Add(qParameterTypes.ParameterType.AsString);
    // ���������� ��� ���� ������ �� ������ ������
    Result.Add(S);
  end
  else
    // �������� ������ ����� ����� ����������
    if qParameterTypes.LocateByField(qParameterTypes.ParameterType.FieldName, S)
    then
    begin
      Result.Add(S);
    end;
end;

function TParametersGroup.GetqParameterKinds: TQueryParameterKinds;
begin
  if FqParameterKinds = nil then
  begin
    FqParameterKinds := TQueryParameterKinds.Create(Self);
    FqParameterKinds.FDQuery.Open;
    FqParameterKinds.ParameterKind.DisplayLabel := '��� ���������';
  end;
  Result := FqParameterKinds;
end;

procedure TParametersGroup.LoadDataFromExcelTable(AParametersExcelTable:
    TParametersExcelTable);
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
      qParameterTypes.LocateOrAppend(AParameterType);

      AParameterKindID :=
        StrToIntDef(AParametersExcelTable.ParameterKindID.AsString, -1);
      // ���� ��� ��������� �� ��������
      if AParameterKindID = -1 then
      begin
        // ���� ����� ����� ��� ��������� � �����������
        if qParameterKinds.LocateByField
          (qParameterKinds.ParameterKind.FieldName,
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

        qParameters.IDParameterType.AsInteger :=
          qParameterTypes.PK.AsInteger;
        qParameters.IDParameterKind.AsInteger := AParameterKindID;

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

function TParametersGroup.LocateAll(AParameterID: Integer): Boolean;
begin
  // ������� ���� ��������
  Result := qParameters.LocateByPK(AParameterID);
  if not Result then
    Exit;

  // ���� ��� ���������
  qParameterTypes.LocateByPK(qParameters.IDParameterType.AsInteger, True);
end;

procedure TParametersGroup.ReOpen;
begin
  qSubParameters.FDQuery.Close;
  qParamSubParams.FDQuery.Close;
  qParameters.FDQuery.Close;
  qParameterTypes.FDQuery.Close;
  qParameterKinds.FDQuery.Close;

  qParameterKinds.FDQuery.Open;
  qParameterTypes.FDQuery.Open;
  qParameters.FDQuery.Open;
  qSubParameters.FDQuery.Open;
  qParamSubParams.FDQuery.Open;
end;

procedure TParametersGroup.Rollback;
begin
  CheckMasterAndDetail;
  // �������������� ��� �� �������� � ����������
  Assert(Connection.InTransaction);

  qSubParameters.TryCancel;
  qParameters.TryCancel;
  qParameterTypes.TryCancel;
  qParamSubParams.TryCancel;

  Connection.Rollback;

  ReOpen;
end;

procedure TParametersGroup.SetProductCategoryIDValue(const Value: Integer);
begin
  if FProductCategoryIDValue = Value then
    Exit;

  FProductCategoryIDValue := Value;
  qParameters.ProductCategoryIDValue := FProductCategoryIDValue;
  qParamSubParams.ProductCategoryIDValue := FProductCategoryIDValue;
end;

procedure TParametersGroup.TryPost;
begin
  qSubParameters.TryPost;
  qParameterTypes.TryPost;
  qParameters.TryPost;
  qParamSubParams.TryPost;
end;

end.
