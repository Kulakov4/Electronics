unit ParameterValuesUnit;

interface

uses
  ParametricExcelDataModule, System.Generics.Collections,
  SearchMainParameterQuery;

type
  TParameterValues = class(TObject)
  private
  class var
    FPackagePinsParameterID: Integer;
    FDatasheetParameterID: Integer;
    FDiagramParameterID: Integer;
    FDrawingParameterID: Integer;
    FProducerParameterID: Integer;
    FImageParameterID: Integer;
    FDescriptionParameterID: Integer;
    FQuerySearchMainParameter: TQuerySearchMainParameter;
    class function GetPackagePinsParameterID: Integer; static;
    class function GetDatasheetParameterID: Integer; static;
    class function GetDiagramParameterID: Integer; static;
    class function GetDrawingParameterID: Integer; static;
    class function GetProducerParameterID: Integer; static;
    class function GetImageParameterID: Integer; static;
    class function GetDescriptionParameterID: Integer; static;
    class function GetQuerySearchMainParameter
      : TQuerySearchMainParameter; static;
    class property QuerySearchMainParameter: TQuerySearchMainParameter
      read GetQuerySearchMainParameter;
  public
    class procedure LoadParameters(AExcelTable: TParametricExcelTable); static;
    class procedure LoadParameterValues(AExcelTable: TParametricExcelTable;
        AddParameters: Boolean); static;
    class property PackagePinsParameterID: Integer
      read GetPackagePinsParameterID;
    class property DatasheetParameterID: Integer read GetDatasheetParameterID;
    class property DiagramParameterID: Integer read GetDiagramParameterID;
    class property DrawingParameterID: Integer read GetDrawingParameterID;
    class property ProducerParameterID: Integer read GetProducerParameterID;
    class property ImageParameterID: Integer read GetImageParameterID;
    class property DescriptionParameterID: Integer
      read GetDescriptionParameterID;
  end;

implementation

uses
  System.SysUtils, ParametersForProductQuery, ParametersValueQuery,
  ProgressInfo, System.Classes, FieldInfoUnit, System.Math,
  ProjectConst, SearchComponentCategoryQuery2, SearchParametersForCategoryQuery,
  MaxCategoryParameterOrderQuery, IDTempTableQuery;

class function TParameterValues.GetPackagePinsParameterID: Integer;
begin
  // Надо поределить код параметра с табличным именем Package/Pins (Корпус/Кол-во выводов)
  if FPackagePinsParameterID = 0 then
  begin
    // Ищем параметр либо добавляем его
    QuerySearchMainParameter.SearchOrAppend(sPackagePinsParamTableName, True);
    FPackagePinsParameterID := QuerySearchMainParameter.PK.AsInteger;
  end;

  Result := FPackagePinsParameterID;
end;

class function TParameterValues.GetDatasheetParameterID: Integer;
begin
  // Надо поределить код параметра с табличным именем Datasheet (техническая спецификация)
  if FDatasheetParameterID = 0 then
  begin
    // Ищем параметр либо добавляем его
    QuerySearchMainParameter.SearchOrAppend(sDatasheetParamTableName, True);
    FDatasheetParameterID := QuerySearchMainParameter.PK.AsInteger;
  end;

  Result := FDatasheetParameterID;
end;

class function TParameterValues.GetDiagramParameterID: Integer;
begin
  // Надо поределить код параметра с табличным именем Diagram (структурная схема)
  if FDiagramParameterID = 0 then
  begin
    // Ищем параметр либо добавляем его
    QuerySearchMainParameter.SearchOrAppend(sDiagramParamTableName, True);
    FDiagramParameterID := QuerySearchMainParameter.PK.AsInteger;
  end;

  Result := FDiagramParameterID;
end;

class function TParameterValues.GetDrawingParameterID: Integer;
begin
  // Надо поределить код параметра с табличным именем Drawing (чертёж)
  if FDrawingParameterID = 0 then
  begin
    // Ищем параметр либо добавляем его
    QuerySearchMainParameter.SearchOrAppend(sDrawingParamTableName, True);
    FDrawingParameterID := QuerySearchMainParameter.PK.AsInteger;
  end;

  Result := FDrawingParameterID;
end;

class function TParameterValues.GetProducerParameterID: Integer;
begin
  // Надо поределить код параметра с табличным именем Producer (производитель)
  if FProducerParameterID = 0 then
  begin
    // Ищем параметр либо добавляем его
    QuerySearchMainParameter.SearchOrAppend(sProducerParamTableName, True);
    FProducerParameterID := QuerySearchMainParameter.PK.AsInteger;
  end;

  Result := FProducerParameterID;
end;

class function TParameterValues.GetImageParameterID: Integer;
begin
  // Надо поределить код параметра с табличным именем Image (изображение)
  if FImageParameterID = 0 then
  begin
    // Ищем параметр либо добавляем его
    QuerySearchMainParameter.SearchOrAppend(sImageParamTableName, True);
    FImageParameterID := QuerySearchMainParameter.PK.AsInteger;
  end;

  Result := FImageParameterID;
end;

class function TParameterValues.GetDescriptionParameterID: Integer;
begin
  // Надо поределить код параметра с табличным именем Description (описание)
  if FDescriptionParameterID = 0 then
  begin
    // Ищем параметр либо добавляем его
    QuerySearchMainParameter.SearchOrAppend(sDescriptionParamTableName, True);
    FDescriptionParameterID := QuerySearchMainParameter.PK.AsInteger;
  end;

  Result := FDescriptionParameterID;
end;

class function TParameterValues.GetQuerySearchMainParameter
  : TQuerySearchMainParameter;
begin
  if FQuerySearchMainParameter = nil then
    FQuerySearchMainParameter := TQuerySearchMainParameter.Create(nil);

  Result := FQuerySearchMainParameter;
end;

class procedure TParameterValues.LoadParameters(AExcelTable
  : TParametricExcelTable);
var
  AFieldInfo: TFieldInfo;
  AIDP: Integer;
  AIDParameter: Integer;
  AIDParentParameter: Integer;
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

      if not AExcelTable.GetIDParamByFieldName(AFieldInfo.FieldName,
        AIDParameter, AIDParentParameter) then
        continue;

      // Берём либо сам параметр, либо родительский
      AIDP := IfThen(AIDParentParameter > 0, AIDParentParameter, AIDParameter);

      // Если такой параметр уже добавляли
      if AParamOrders.ContainsKey(AIDP) then
        AOrder := AParamOrders[AIDP]
      else
      begin
        Inc(AOrder); // Новый порядковый номер нашего параметра
        AParamOrders.Add(AIDP, AOrder);
      end;

      // Добавляем этот параметр во все категории наших компонентов
      AQueryParametersForProduct.LoadAndProcess(ATempTable.TableName,
        AIDP, AOrder);

      // Для дочернего параметра добавляем его тоже во все категории наших компонентов
      if AIDParameter <> AIDP then
        AQueryParametersForProduct.LoadAndProcess(ATempTable.TableName,
          AIDParameter, 0);

    end;
  finally
    FreeAndNil(ATempTable);
    FreeAndNil(AParamOrders);
    FreeAndNil(AQueryParametersForProduct);
  end;
end;

class procedure TParameterValues.LoadParameterValues(AExcelTable:
    TParametricExcelTable; AddParameters: Boolean);
var
  a: TArray<String>;
  AFieldInfo: TFieldInfo;
  AIDComponent: Integer;
  AIDComponents: TList<Integer>;
  AIDParameter: Integer;
  AIDParentParameter: Integer;
  AQueryParametersForProduct: TQueryParametersForProduct;
  AQueryParametersValue: TQueryParametersValue;
  AValue: String;
  S: string;
begin
  if AExcelTable.RecordCount = 0 then
    Exit;

  if AddParameters then
    LoadParameters(AExcelTable);

  AQueryParametersForProduct := TQueryParametersForProduct.Create(nil);
  AQueryParametersValue := TQueryParametersValue.Create(nil);
  AIDComponents := TList<Integer>.Create;
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

          if not AExcelTable.GetIDParamByFieldName(AFieldInfo.FieldName,
            AIDParameter, AIDParentParameter) then
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

            AIDComponents.Clear;
            AIDComponents.Add(AExcelTable.IDComponent.AsInteger);
            if AExcelTable.IDParentComponent.AsInteger > 0 then
              AIDComponents.Add(AExcelTable.IDParentComponent.AsInteger);

            // Цикл по дочернему и родительскому компоненту
            for AIDComponent in AIDComponents do
            begin
              AExcelTable.CallOnProcessEvent;

              // Добавляем значение в таблицу значений параметра
              AQueryParametersValue.Load(AIDComponent, AIDParameter);
              AExcelTable.CallOnProcessEvent;
              AQueryParametersValue.LocateOrAppend(AValue);
              AExcelTable.CallOnProcessEvent;
            end;
          end;
        end;
        AExcelTable.Next;
        AExcelTable.CallOnProcessEvent;
      end;
    finally
      AExcelTable.EnableControls;
    end;
  finally
    FreeAndNil(AQueryParametersForProduct);
    FreeAndNil(AQueryParametersValue);
    FreeAndNil(AIDComponents);
  end;
end;

end.
