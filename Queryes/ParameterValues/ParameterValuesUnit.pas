unit ParameterValuesUnit;

interface

uses
  ParametricExcelDataModule, System.Generics.Collections, SearchParameterQuery;

type
  TParameterValues = class(TObject)
  private
  class var
  public
    class procedure LoadParameters(AExcelTable: TParametricExcelTable); static;
    class procedure LoadParameterValues(AExcelTable: TParametricExcelTable;
      AddParameters: Boolean); static;
  end;

implementation

uses
  System.SysUtils, ParametersForProductQuery, ParametersValueQuery,
  ProgressInfo, System.Classes, FieldInfoUnit, System.Math,
  ProjectConst, SearchParametersForCategoryQuery,
  MaxCategoryParameterOrderQuery, IDTempTableQuery, UpdateParamValueRec,
  SearchFamilyParamValuesQuery;

// Добавляет параметры на вкладку параметры
class procedure TParameterValues.LoadParameters(AExcelTable
  : TParametricExcelTable);
var
  AFieldInfo: TFieldInfo;
  AParamSubParamID: Integer;
  AOrder: Integer;
  ATempTable: TQueryIDTempTable;
  AParamOrders: TDictionary<Integer, Integer>;
  API: TProgressInfo;
  AQueryParametersForProduct: TQueryParametersForProduct;
  i: Integer;
begin
  if AExcelTable.RecordCount = 0 then
    Exit;

  AQueryParametersForProduct := TQueryParametersForProduct.Create(nil);
  AParamOrders := TDictionary<Integer, Integer>.Create;
  ATempTable := TQueryIDTempTable.Create(nil);
  API := TProgressInfo.Create;;
  try
    // Сохраняем идентификаторы всех компонентов во временную таблицу
    ATempTable.AppendData(AExcelTable.IDComponent);

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

      // Берём либо сам параметр, либо родительский
      // AIDP := IfThen(AIDParentParameter > 0, AIDParentParameter, AParamSubParamID);

      // Если такой параметр уже добавляли
      if AParamOrders.ContainsKey(AParamSubParamID) then
        AOrder := AParamOrders[AParamSubParamID]
      else
      begin
        Inc(AOrder);
        // Новый порядковый номер нашей связи между параметром и подпараметром
        AParamOrders.Add(AParamSubParamID, AOrder);
      end;

      // Добавляем эту связь между параметром и подпараметром во все категории наших компонентов
      AQueryParametersForProduct.LoadAndProcess(ATempTable.TableName,
        AParamSubParamID, AOrder);
    end;
  finally
    FreeAndNil(ATempTable);
    FreeAndNil(AParamOrders);
    FreeAndNil(AQueryParametersForProduct);
  end;
end;

class procedure TParameterValues.LoadParameterValues
  (AExcelTable: TParametricExcelTable; AddParameters: Boolean);
var
  a: TArray<String>;
  AFieldInfo: TFieldInfo;
  AIDComponent: Integer;
  AParamSubParamID: Integer;
  AIDParentParameter: Integer;
  AQueryParametersForProduct: TQueryParametersForProduct;
  AQueryParametersValue: TQueryParametersValue;
  AUpdParamSubParamList: TUpdParamSubParamList;
  AUpdPSP: TUpdParamSubParam;
  AValue: String;
  Q: TQueryFamilyParamValues;
  S: string;
begin
  if AExcelTable.RecordCount = 0 then
    Exit;

  if AddParameters then
    LoadParameters(AExcelTable);

  AQueryParametersForProduct := TQueryParametersForProduct.Create(nil);
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
            AQueryParametersValue.Load(AIDComponent, AParamSubParamID);
            AExcelTable.CallOnProcessEvent;

            // Добавляем значение в таблицу значений связки параметра с подпараметром
            AQueryParametersValue.LocateOrAppend(AValue);
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
    try
      for AUpdPSP in AUpdParamSubParamList do
      begin
        // Если найдено единственное значение
        if Q.SearchEx(AUpdPSP.FamilyID, AUpdPSP.ParamSubParamID) = 1 then
        begin
          // Добавляем значение параметра для семейства
          AQueryParametersValue.Load(AUpdPSP.FamilyID, AUpdPSP.ParamSubParamID);
          AQueryParametersValue.LocateOrAppend(Q.Value.AsString);
        end;
      end;
    finally
      FreeAndNil(Q);
    end;

  finally
    FreeAndNil(AQueryParametersForProduct);
    FreeAndNil(AQueryParametersValue);
    FreeAndNil(AUpdParamSubParamList);
  end;
end;

end.
