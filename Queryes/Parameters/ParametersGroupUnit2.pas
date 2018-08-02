unit ParametersGroupUnit2;

interface

uses
  QueryGroupUnit2, System.Classes, ParameterKindsQuery, ParametersQuery,
  ParameterTypesQuery, ParamSubParamsQuery, SubParametersQuery2,
  System.Generics.Collections, ParametersExcelDataModule, NotifyEvents;

type
  TParametersGroup2 = class(TQueryGroup2)
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
  public
    constructor Create(AOwner: TComponent); override;
    function Find(const AFieldName, S: string): TList<String>;
    procedure LoadDataFromExcelTable(AParametersExcelTable: TParametersExcelTable);
    function LocateAll(AParameterID: Integer): Boolean;
    property ProductCategoryIDValue: Integer read FProductCategoryIDValue write
        SetProductCategoryIDValue;
    property qParameterKinds: TQueryParameterKinds read GetqParameterKinds;
    property qParameters: TQueryParameters read FqParameters;
    property qParameterTypes: TQueryParameterTypes read FqParameterTypes;
    property qParamSubParams: TQueryParamSubParams read FqParamSubParams;
    property qSubParameters: TQuerySubParameters2 read FqSubParameters;
  end;

implementation

uses
  System.SysUtils, Data.DB, ParameterKindEnum;

constructor TParametersGroup2.Create(AOwner: TComponent);
begin
  inherited;
  // Типы параметров
  FqParameterTypes := TQueryParameterTypes.Create(Self);
  // Параметры
  FqParameters := TQueryParameters.Create(Self);
  // Связь с подпараметрами
  FqParamSubParams := TQueryParamSubParams.Create(Self);
  // Подпараметры
  FqSubParameters := TQuerySubParameters2.Create(Self);

  QList.Add(qParameterTypes); // Тип каждого параметра
  QList.Add(qParameters);     // Сами параметры
  QList.Add(qSubParameters);  // Подпараметры
  QList.Add(qParamSubParams); // Связь между параметрами и подпараметрами

  // Для каскадного удаления
  TNotifyEventWrap.Create(qParameterTypes.BeforeDelete, DoBeforeDelete, EventList);
end;

procedure TParametersGroup2.DoBeforeDelete(Sender: TObject);
begin
  // Каскадно удаляем параметры
  qParameters.CascadeDelete(qParameterTypes.PK.Value,
    qParameters.IDParameterType.FieldName);
end;

function TParametersGroup2.Find(const AFieldName, S: string): TList<String>;
begin
  Assert(not AFieldName.IsEmpty);
  Result := TList<String>.Create();

  // Пытаемся искать среди параметров по какому-то полю
  if qParameters.LocateByField(AFieldName, S) then
  begin
    qParameterTypes.LocateByPK(qParameters.IDParameterType.Value, True);
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

function TParametersGroup2.GetqParameterKinds: TQueryParameterKinds;
begin
  if FqParameterKinds = nil then
  begin
    FqParameterKinds := TQueryParameterKinds.Create(Self);
    FqParameterKinds.FDQuery.Open;
    FqParameterKinds.ParameterKind.DisplayLabel := 'Вид параметра';
  end;
  Result := FqParameterKinds;
end;

procedure TParametersGroup2.LoadDataFromExcelTable(AParametersExcelTable:
    TParametersExcelTable);
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

function TParametersGroup2.LocateAll(AParameterID: Integer): Boolean;
begin
  // Сначала ищем параметр
  Result := qParameters.LocateByPK(AParameterID);
  if not Result then
    Exit;

  // Ищем тип параметра
  qParameterTypes.LocateByPK(qParameters.IDParameterType.AsInteger, True);
end;

procedure TParametersGroup2.SetProductCategoryIDValue(const Value: Integer);
begin
  if FProductCategoryIDValue = Value then
    Exit;

  FProductCategoryIDValue := Value;
  qParameters.ProductCategoryIDValue := FProductCategoryIDValue;
  qParamSubParams.ProductCategoryIDValue := FProductCategoryIDValue;
end;

end.
