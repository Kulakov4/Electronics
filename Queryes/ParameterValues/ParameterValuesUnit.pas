unit ParameterValuesUnit;

interface

uses
  ParametricExcelDataModule, System.Generics.Collections, SearchParameterQuery,
  NotifyEvents;

type
  TParameterValues = class(TObject)
  private
  class var
  public
    class procedure LoadParameters(AProductCategoryIDArray: TArray<Integer>;
      AExcelTable: TParametricExcelTable); static;
    class procedure LoadParameterValues(AExcelTable: TParametricExcelTable;
      ANotifyEventRef: TNotifyEventRef); static;
  end;

implementation

uses
  System.SysUtils, ParametersValueQuery, ProgressInfo, System.Classes,
  FieldInfoUnit, System.Math, ProjectConst, MaxCategoryParameterOrderQuery,
  IDTempTableQuery, UpdateParamValueRec, SearchFamilyParamValuesQuery,
  CategoryParametersQuery, SearchComponentParamSubParamsQuery;

// ƒобавл€ет параметры на вкладку параметры
class procedure TParameterValues.LoadParameters(AProductCategoryIDArray
  : TArray<Integer>; AExcelTable: TParametricExcelTable);
var
  AFieldInfo: TFieldInfo;
  AParamSubParamID: Integer;
  AOrder: Integer;
  AParamOrders: TDictionary<Integer, Integer>;
  API: TProgressInfo;
  AProductCategoryID: Integer;
  qCategoryParams: TQueryCategoryParams;
  i: Integer;
begin
  Assert(Length(AProductCategoryIDArray) > 0);

  qCategoryParams := TQueryCategoryParams.Create(nil);
  AParamOrders := TDictionary<Integer, Integer>.Create;
  API := TProgressInfo.Create;;
  try
    AOrder := TQueryMaxCategoryParameterOrder.Max_Order;

    API.TotalRecords := AExcelTable.FieldsInfo.Count;
    i := 0;
    // ÷икл по всем описани€м полей
    for AFieldInfo in AExcelTable.FieldsInfo do
    begin
      // »звещаем о том, сколько параметров уже добавили
      Inc(i);
      API.ProcessRecords := i;
      AExcelTable.OnProgress.CallEventHandlers(API);

      // ≈сли этому полю не соответствует св€зка параметра с подпараметром
      if not AExcelTable.GetParamSubParamIDByFieldName(AFieldInfo.FieldName,
        AParamSubParamID) then
        continue;

      // ≈сли такой параметр уже добавл€ли
      if AParamOrders.ContainsKey(AParamSubParamID) then
        AOrder := AParamOrders[AParamSubParamID]
      else
      begin
        Inc(AOrder);
        // Ќовый пор€дковый номер нашей св€зи между параметром и подпараметром
        AParamOrders.Add(AParamSubParamID, AOrder);
      end;

      // ƒобавл€ем эту св€зь между параметром и подпараметром в очередную категорию
      for AProductCategoryID in AProductCategoryIDArray do
        qCategoryParams.AppendOrEdit(AProductCategoryID,
          AParamSubParamID, AOrder);

    end;
  finally
    FreeAndNil(AParamOrders);
    FreeAndNil(qCategoryParams);
    FreeAndNil(API);
  end;
end;

class procedure TParameterValues.LoadParameterValues
  (AExcelTable: TParametricExcelTable; ANotifyEventRef: TNotifyEventRef);
var
  a: TArray<String>;
  AFieldInfo: TFieldInfo;
  AIDComponent: Integer;
  AParamSubParamID: Integer;
  API: TProgressInfo;
  AQueryParametersValue: TQueryParametersValue;
  AUpdParamSubParamList: TUpdParamSubParamList;
  AUpdPSP: TUpdParamSubParam;
  AValue: String;
  i: Integer;
  Q: TQueryFamilyParamValues;
  S: string;
begin
  if AExcelTable.RecordCount = 0 then
    Exit;

  // ≈сли сначала нужно создать все необходимые параметры
  // if AProductCategoryID > 0 then
  // LoadParameters(AProductCategoryID, AExcelTable);

  AQueryParametersValue := TQueryParametersValue.Create(nil);
  AUpdParamSubParamList := TUpdParamSubParamList.Create;
  try
    AExcelTable.DisableControls;
    try
      AExcelTable.First;
      AExcelTable.CallOnProcessEvent;
      while not AExcelTable.Eof do
      begin
        AIDComponent := AExcelTable.IDComponent.AsInteger;
        Assert(AIDComponent > 0);

        // ÷икл по всем описани€м полей
        for AFieldInfo in AExcelTable.FieldsInfo do
        begin
          AExcelTable.CallOnProcessEvent;

          // ≈сли этому полю не соответствует св€зка параметра с подпараметром
          if not AExcelTable.GetParamSubParamIDByFieldName(AFieldInfo.FieldName,
            AParamSubParamID) then
            continue;

          AExcelTable.CallOnProcessEvent;

          AValue := AExcelTable.FieldByName(AFieldInfo.FieldName).AsString;

          // если значение дл€ параметра пустое и нет необходимости удал€ть старве значени€
          if AValue.IsEmpty and not AExcelTable.Replace then
            continue;

          // »щем все значени€ дл€ какой либо св€зки параметра с подпараметром
          AQueryParametersValue.Search(AIDComponent, AParamSubParamID);

          // ≈сли нужно заменить значени€ загружаемого параметра
          if AExcelTable.Replace then
            // ”дал€ем все значени€ параметров дл€ текущего компонента и св€зки параметра с подпараметром
            AQueryParametersValue.W.DeleteAll;

          // если значение дл€ параметра пустое
          if AValue.IsEmpty then
            continue;

          // ƒелим строку на части по зап€той
          a := AValue.Split([',']);
          for S in a do
          begin
            AValue := S.Trim;
            if AValue.IsEmpty then
              continue;

            // ≈сли загружаем значение дл€ компонента (не дл€ семейства)
            if AExcelTable.IDParentComponent.AsInteger > 0 then
            begin
              if AUpdParamSubParamList.Search
                (AExcelTable.IDParentComponent.AsInteger, AParamSubParamID) = -1
              then
              begin
                AUpdParamSubParamList.Add
                  (TUpdParamSubParam.Create
                  (AExcelTable.IDParentComponent.AsInteger, AParamSubParamID));
              end;
            end;

            // ƒобавл€ем значение в таблицу значений св€зки параметра с подпараметром
            AQueryParametersValue.W.LocateOrAppend(AValue);
            AExcelTable.CallOnProcessEvent;
          end;
        end;
        AExcelTable.Next;
        AExcelTable.CallOnProcessEvent;
      end;
    finally
      AExcelTable.EnableControls;
    end;

    // ≈динственное значение выносим € €чейку семейства
    Q := TQueryFamilyParamValues.Create(nil);
    API := TProgressInfo.Create;
    try
      API.TotalRecords := AUpdParamSubParamList.Count;
      i := 0;
      for AUpdPSP in AUpdParamSubParamList do
      begin
        // ≈сли найдено единственное значение
        if Q.SearchEx(AUpdPSP.FamilyID, AUpdPSP.ParamSubParamID) = 1 then
        begin
          // ƒобавл€ем значение параметра дл€ семейства
          AQueryParametersValue.Search(AUpdPSP.FamilyID,
            AUpdPSP.ParamSubParamID);
          AQueryParametersValue.W.LocateOrAppend(Q.W.Value.F.AsString);
        end;
        Inc(i);
        API.ProcessRecords := i;
        if Assigned(ANotifyEventRef) then
          ANotifyEventRef(API);
      end;
    finally
      FreeAndNil(Q);
      FreeAndNil(API);
    end;

  finally
    FreeAndNil(AQueryParametersValue);
    FreeAndNil(AUpdParamSubParamList);
  end;
end;

end.
