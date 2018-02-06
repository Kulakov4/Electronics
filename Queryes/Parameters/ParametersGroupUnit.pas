unit ParametersGroupUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, ParameterTypesQuery, MainParametersQuery, SubParametersQuery,
  FireDAC.Comp.Client, FireDAC.Stan.Intf, NotifyEvents,
  ParametersExcelDataModule, System.Generics.Collections, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, QueryWithDataSourceUnit, BaseQuery, BaseEventsQuery,
  QueryWithMasterUnit, QueryGroupUnit, OrderQuery, ParameterKindsQuery,
  SubParametersQuery2, ParamSubParamsQuery;

type
  TParametersGroup = class(TQueryGroup)
    qParameterTypes: TQueryParameterTypes;
    qMainParameters: TQueryMainParameters;
    qParamSubParams: TQueryParamSubParams;
    qSubParameters2: TQuerySubParameters2;
  private
    FAfterDataChange: TNotifyEventsEx;
    FProductCategoryIDValue: Integer;
    FqParameterKinds: TQueryParameterKinds;
    procedure DoOnDataChange(Sender: TObject);
    procedure DoBeforeDelete(Sender: TObject);
    function GetqParameterKinds: TQueryParameterKinds;
    procedure SetProductCategoryIDValue(const Value: Integer);
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Commit; override;
    function Find(const AFieldName, S: string): TList<String>;
    procedure InsertList(AParametersExcelTable: TParametersExcelTable);
    procedure ReOpen; override;
    procedure Rollback; override;
    procedure TryPost; override;
    property AfterDataChange: TNotifyEventsEx read FAfterDataChange;
    property ProductCategoryIDValue: Integer read FProductCategoryIDValue write
        SetProductCategoryIDValue;
    property qParameterKinds: TQueryParameterKinds read GetqParameterKinds;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses RepositoryDataModule, ParameterKindEnum;

constructor TParametersGroup.Create(AOwner: TComponent);
begin
  inherited;

  Main := qParameterTypes;
  Detail := qMainParameters;

  FAfterDataChange := TNotifyEventsEx.Create(Self);

  TNotifyEventWrap.Create(qParameterTypes.AfterPost, DoOnDataChange);
  TNotifyEventWrap.Create(qParameterTypes.AfterDelete, DoOnDataChange);

  TNotifyEventWrap.Create(qMainParameters.AfterPost, DoOnDataChange);
  TNotifyEventWrap.Create(qMainParameters.AfterDelete, DoOnDataChange);

  TNotifyEventWrap.Create(qParamSubParams.AfterPost, DoOnDataChange);
  TNotifyEventWrap.Create(qParamSubParams.AfterDelete, DoOnDataChange);

  TNotifyEventWrap.Create(qParameterTypes.AfterOpen, DoOnDataChange);
  TNotifyEventWrap.Create(qMainParameters.AfterOpen, DoOnDataChange);
  TNotifyEventWrap.Create(qParamSubParams.AfterOpen, DoOnDataChange);


  // Для каскадного удаления
  TNotifyEventWrap.Create(qParameterTypes.BeforeDelete, DoBeforeDelete);
end;

destructor TParametersGroup.Destroy;
begin
  inherited;
end;

procedure TParametersGroup.Commit;
begin
  CheckMasterAndDetail;
  // Предполагается что мы работаем в транзакции
  Assert(Connection.InTransaction);

  qParameterTypes.TryPost;
  qMainParameters.TryPost;
  qSubParameters2.TryPost;
  qParamSubParams.TryPost;

  Connection.Commit;

  AfterCommit.CallEventHandlers(Self);
end;

procedure TParametersGroup.DoOnDataChange(Sender: TObject);
begin
  FAfterDataChange.CallEventHandlers(Self);
end;

procedure TParametersGroup.DoBeforeDelete(Sender: TObject);
begin
  // Каскадно удаляем параметры
  qMainParameters.CascadeDelete(qParameterTypes.PK.Value,
    qMainParameters.IDParameterType.FieldName);
end;

function TParametersGroup.Find(const AFieldName, S: string): TList<String>;
begin
  Assert(not AFieldName.IsEmpty);
  Result := TList<String>.Create();

  // Пытаемся искать среди параметров по какому-то полю
  if qMainParameters.LocateByField(AFieldName, S) then
  begin
    qParameterTypes.LocateByPK(qMainParameters.IDParameterType.Value, True);
    // запоминаем что надо искать на первом уровне
    Result.Add(qParameterTypes.ParameterType.AsString);
    // запоминаем что надо искать на втором уровне
    Result.Add(S);
  end
  else
    // Пытаемся искать среди типов параметров
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
    FqParameterKinds.ParameterKind.DisplayLabel := 'Вид параметра';
  end;
  Result := FqParameterKinds;
end;

procedure TParametersGroup.InsertList(AParametersExcelTable
  : TParametersExcelTable);
var
  AField: TField;
  AParameterKindID: Integer;
  AParameterType: string;
  I: Integer;
begin
  TryPost;
  if qParameterKinds.FDQuery.RecordCount = 0 then
    raise Exception.Create('Справочник видов параметров не заполнен');

  AParametersExcelTable.DisableControls;
  qParameterTypes.FDQuery.DisableControls;
  qMainParameters.FDQuery.DisableControls;
  try
    AParametersExcelTable.First;
    AParametersExcelTable.CallOnProcessEvent;
    while not AParametersExcelTable.Eof do
    begin
      AParameterType := AParametersExcelTable.ParameterType.AsString;
      qParameterTypes.LocateOrAppend(AParameterType);

      AParameterKindID :=
        StrToIntDef(AParametersExcelTable.ParameterKindID.AsString, -1);
      // Если вид параметра не числовой
      if AParameterKindID = -1 then
      begin
        // Если нашли такой вид параметра в справочнике
        if qParameterKinds.LocateByField
          (qParameterKinds.ParameterKind.FieldName,
          AParametersExcelTable.ParameterKindID.AsString) then
          AParameterKindID := qParameterKinds.PK.AsInteger
        else
          AParameterKindID := Integer(Неиспользуется);
      end
      else
      begin
        // Ищем такой вид параметра в справочнике
        if not qParameterKinds.LocateByPK(AParameterKindID) then
          AParameterKindID := Integer(Неиспользуется);
      end;

      qMainParameters.FDQuery.Append;
      try
        for I := 0 to AParametersExcelTable.FieldCount - 1 do
        begin
          AField := qMainParameters.FDQuery.FindField
            (AParametersExcelTable.Fields[I].FieldName);
          if AField <> nil then
          begin
            AField.Value := AParametersExcelTable.Fields[I].Value;
          end;
        end;

        qMainParameters.IDParameterType.AsInteger :=
          qParameterTypes.PK.AsInteger;
        qMainParameters.IDParameterKind.AsInteger := AParameterKindID;

        qMainParameters.FDQuery.Post;
      except
        qMainParameters.FDQuery.Cancel;
        raise;
      end;

      AParametersExcelTable.Next;
      AParametersExcelTable.CallOnProcessEvent;
    end;
  finally
    AParametersExcelTable.EnableControls;
    qMainParameters.FDQuery.EnableControls;
    qParameterTypes.FDQuery.EnableControls;
  end;
end;

procedure TParametersGroup.ReOpen;
begin
  qSubParameters2.FDQuery.Close;
  qParamSubParams.FDQuery.Close;
  qMainParameters.FDQuery.Close;
  qParameterTypes.FDQuery.Close;
  qParameterKinds.FDQuery.Close;

  qParameterKinds.FDQuery.Open;
  qParameterTypes.FDQuery.Open;
  qMainParameters.FDQuery.Open;
  qSubParameters2.FDQuery.Open;
  qParamSubParams.FDQuery.Open;
end;

procedure TParametersGroup.Rollback;
begin
  CheckMasterAndDetail;
  // Предполагается что мы работаем в транзакции
  Assert(Connection.InTransaction);

  qSubParameters2.TryCancel;
  qMainParameters.TryCancel;
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
  qMainParameters.ProductCategoryIDValue := FProductCategoryIDValue;
  qParamSubParams.ProductCategoryIDValue := FProductCategoryIDValue;
end;

procedure TParametersGroup.TryPost;
begin
  qSubParameters2.TryPost;
  qParameterTypes.TryPost;
  qMainParameters.TryPost;
  qParamSubParams.TryPost;
end;

end.
