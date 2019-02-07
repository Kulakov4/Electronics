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

// Добавляет параметры на вкладку параметры
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
    // Цикл по всем описаниям полей
    for AFieldInfo in AExcelTable.FieldsInfo do
    begin
      // Извещаем о том, сколько параметров уже добавили
      Inc(i);
      API.ProcessRecords := i;
      AExcelTable.OnProgress.CallEventHandlers(API);

      // Если этому полю не соответствует связка параметра с подпараметром
      if not AExcelTable.GetParamSubParamIDByFieldName(AFieldInfo.FieldName,
        AParamSubParamID) then
        continue;

      // Если такой параметр уже добавляли
      if AParamOrders.ContainsKey(AParamSubParamID) then
        AOrder := AParamOrders[AParamSubParamID]
      else
      begin
        Inc(AOrder);
        // Новый порядковый номер нашей связи между параметром и подпараметром
        AParamOrders.Add(AParamSubParamID, AOrder);
      end;

      // Добавляем эту связь между параметром и подпараметром в очередную категорию
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

  // Если сначала нужно создать все необходимые параметры
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
        Assert(AExcelTable.IDComponent.AsInteger > 0);

        // Цикл по всем описаниям полей
        for AFieldInfo in AExcelTable.FieldsInfo do
        begin
          AExcelTable.CallOnProcessEvent;

          // Если этому полю не соответствует связка параметра с подпараметром
          if not AExcelTable.GetParamSubParamIDByFieldName(AFieldInfo.FieldName,
            AParamSubParamID) then
            continue;

          AExcelTable.CallOnProcessEvent;

          AValue := AExcelTable.FieldByName(AFieldInfo.FieldName).AsString;

          // если значение для параметра не пустое
          if AValue.IsEmpty then
            continue;

          // Делим строку на части по запятой
          a := AValue.Split([',']);
          for S in a do
          begin
            AValue := S.Trim;
            if AValue.IsEmpty then
              continue;

            // Если загружаем значение для компонента
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

            AIDComponent := AExcelTable.IDComponent.AsInteger;

            // Ищем все значения для какой либо связки параметра с подпараметром
            AQueryParametersValue.Search(AIDComponent, AParamSubParamID);
            AExcelTable.CallOnProcessEvent;

            // Добавляем значение в таблицу значений связки параметра с подпараметром
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

    // Единственное значение выносим я ячейку семейства
    Q := TQueryFamilyParamValues.Create(nil);
    API := TProgressInfo.Create;
    try
      API.TotalRecords := AUpdParamSubParamList.Count;
      i := 0;
      for AUpdPSP in AUpdParamSubParamList do
      begin
        // Если найдено единственное значение
        if Q.SearchEx(AUpdPSP.FamilyID, AUpdPSP.ParamSubParamID) = 1 then
        begin
          // Добавляем значение параметра для семейства
          AQueryParametersValue.Search(AUpdPSP.FamilyID, AUpdPSP.ParamSubParamID);
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
