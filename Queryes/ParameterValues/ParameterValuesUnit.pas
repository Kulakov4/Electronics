unit ParameterValuesUnit;

interface

uses
  RecommendedReplacementExcelDataModule, System.Generics.Collections,
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
    class procedure LoadParameterValues(AExcelTable: TParameterExcelTable2;
      UpdateOrder: Boolean); static;
    class property PackagePinsParameterID: Integer
      read GetPackagePinsParameterID;
    class property DatasheetParameterID: Integer read GetDatasheetParameterID;
    class property DiagramParameterID: Integer read GetDiagramParameterID;
    class property DrawingParameterID: Integer read GetDrawingParameterID;
    class property ProducerParameterID: Integer read GetProducerParameterID;
    class property ImageParameterID: Integer read GetImageParameterID;
    class property DescriptionParameterID: Integer read GetDescriptionParameterID;
  end;

implementation

uses
  System.SysUtils, ParametersForProductQuery, ParametersValueQuery,
  ProgressInfo, System.Classes, FieldInfoUnit, System.Math,
  ProjectConst, SearchComponentCategoryQuery2, SearchParametersForCategoryQuery;

class function TParameterValues.GetPackagePinsParameterID: Integer;
var
  rc: Integer;
begin
  // Надо поределить код параметра с табличным именем Package/Pins (Корпус/Кол-во выводов)
  if FPackagePinsParameterID = 0 then
  begin
    // Ищем параметр
    rc := QuerySearchMainParameter.Search(sPackagePinsParamTableName);
    // Что делать если не нашли?
    Assert(rc = 1);
    FPackagePinsParameterID := QuerySearchMainParameter.PKValue;
  end;

  Result := FPackagePinsParameterID;
end;

class function TParameterValues.GetDatasheetParameterID: Integer;
var
  rc: Integer;
begin
  // Надо поределить код параметра с табличным именем Datasheet (техническая спецификация)
  if FDatasheetParameterID = 0 then
  begin
    // Ищем параметр
    rc := QuerySearchMainParameter.Search(sDatasheetParamTableName);
    // Что делать если не нашли?
    Assert(rc = 1);
    FDatasheetParameterID := QuerySearchMainParameter.PKValue;
  end;

  Result := FDatasheetParameterID;
end;

class function TParameterValues.GetDiagramParameterID: Integer;
var
  rc: Integer;
begin
  // Надо поределить код параметра с табличным именем Diagram (структурная схема)
  if FDiagramParameterID = 0 then
  begin
    // Ищем параметр
    rc := QuerySearchMainParameter.Search(sDiagramParamTableName);
    // Что делать если не нашли?
    Assert(rc = 1);
    FDiagramParameterID := QuerySearchMainParameter.PKValue;
  end;

  Result := FDiagramParameterID;
end;

class function TParameterValues.GetDrawingParameterID: Integer;
var
  rc: Integer;
begin
  // Надо поределить код параметра с табличным именем Drawing (чертёж)
  if FDrawingParameterID = 0 then
  begin
    // Ищем параметр
    rc := QuerySearchMainParameter.Search(sDrawingParamTableName);
    // Что делать если не нашли?
    Assert(rc = 1);
    FDrawingParameterID := QuerySearchMainParameter.PKValue;
  end;

  Result := FDrawingParameterID;
end;

class function TParameterValues.GetProducerParameterID: Integer;
var
  rc: Integer;
begin
  // Надо поределить код параметра с табличным именем Producer (производитель)
  if FProducerParameterID = 0 then
  begin
    // Ищем параметр
    rc := QuerySearchMainParameter.Search(sProducerParamTableName);
    // Что делать если не нашли?
    Assert(rc = 1);
    FProducerParameterID := QuerySearchMainParameter.PKValue;
  end;

  Result := FProducerParameterID;
end;

class function TParameterValues.GetImageParameterID: Integer;
var
  rc: Integer;
begin
  // Надо поределить код параметра с табличным именем Image (изображение)
  if FImageParameterID = 0 then
  begin
    // Ищем параметр
    rc := QuerySearchMainParameter.Search(sImageParamTableName);
    // Что делать если не нашли?
    Assert(rc = 1);
    FImageParameterID := QuerySearchMainParameter.PKValue;
  end;

  Result := FImageParameterID;
end;

class function TParameterValues.GetDescriptionParameterID: Integer;
var
  rc: Integer;
begin
  // Надо поределить код параметра с табличным именем Description (описание)
  if FDescriptionParameterID = 0 then
  begin
    // Ищем параметр
    rc := QuerySearchMainParameter.Search(sDescriptionParamTableName);
    // Что делать если не нашли?
    Assert(rc = 1);
    FDescriptionParameterID := QuerySearchMainParameter.PKValue;
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

class procedure TParameterValues.LoadParameterValues
  (AExcelTable: TParameterExcelTable2; UpdateOrder: Boolean);
var
  a: TArray<String>;
  ACaregoryIDList: TList<Integer>;
  AFieldInfo: TFieldInfo;
  AIDComponent: Integer;
  AIDComponents: TList<Integer>;
  AIDParameter: Integer;
  AOrder: Integer;
  AQueryParametersForProduct: TQueryParametersForProduct;
  AQueryParametersValue: TQueryParametersValue;
  AQrySearchComponentCategory2: TQuerySearchComponentCategory2;
  AQrySearchParamForCat: TQuerySearchParametersForCategory;
  AValue: String;
  S: string;
begin
  if AExcelTable.RecordCount = 0 then
    Exit;

  if UpdateOrder then
  begin
    AQrySearchComponentCategory2 := TQuerySearchComponentCategory2.Create(nil);
    AQrySearchParamForCat := TQuerySearchParametersForCategory.Create(nil);
    ACaregoryIDList := TList<Integer>.Create;
  end;
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

        if UpdateOrder then
        begin
          // Сначала ищем, в какие категории входит наш компонент
          AQrySearchComponentCategory2.Search
            (AExcelTable.IDComponent.AsInteger, '');
          // Цикл по всем категориям компонента
          while not AQrySearchComponentCategory2.FDQuery.Eof do
          begin
            if ACaregoryIDList.IndexOf
              (AQrySearchComponentCategory2.ProductCategoryID.AsInteger) < 0
            then
            begin
              // Смещаем порядок параметров в отрицательную область и делаем их скрытыми
              AQrySearchParamForCat.SearchAndProcess
                (AQrySearchComponentCategory2.ProductCategoryID.AsInteger);
              ACaregoryIDList.Add
                (AQrySearchComponentCategory2.ProductCategoryID.AsInteger);
            end;
            AQrySearchComponentCategory2.FDQuery.Next;
          end;
        end;

        AOrder := 0;

        // Цикл по всем описаниям полей
        for AFieldInfo in AExcelTable.FieldsInfo do
        begin
          AExcelTable.CallOnProcessEvent;
          AIDParameter := AExcelTable.GetIDParamByFieldName
            (AFieldInfo.FieldName);
          if AIDParameter > 0 then
          begin
            Inc(AOrder); // Новый порядковый номер нашего параметра

            AIDComponent := IfThen(AExcelTable.IDParentComponent.AsInteger > 0,
              AExcelTable.IDParentComponent.AsInteger,
              AExcelTable.IDComponent.AsInteger);

            // Даже если значение будет пустым нужно добавить этот параметр во все категории текущего компонента
            AQueryParametersForProduct.LoadAndProcess(AIDParameter,
              AIDComponent, AOrder);
            AExcelTable.CallOnProcessEvent;

            AValue := AExcelTable.FieldByName(AFieldInfo.FieldName).AsString;

            // если значение для параметра не пустое
            if not AValue.IsEmpty then
            begin
              // Делим строку на части по запятой
              a := AValue.Split([',']);
              for S in a do
              begin
                AValue := S.Trim;
                if not AValue.IsEmpty then
                begin
                  AIDComponents.Clear;
                  AIDComponents.Add(AExcelTable.IDComponent.AsInteger);
                  if AExcelTable.IDParentComponent.AsInteger > 0 then
                    AIDComponents.Add(AExcelTable.IDParentComponent.AsInteger);

                  // Цикл по дочернему и родительскому компоненту
                  for AIDComponent in AIDComponents do
                  begin
                    // Сначала добавим параметр во все категории каждого компонента
                    // AQueryParametersForProduct.LoadAndProcess(AIDParameter,
                    // AIDComponent, AOrder);
                    AExcelTable.CallOnProcessEvent;

                    // Добавляем значение в таблицу значений параметра
                    AQueryParametersValue.Load(AIDComponent, AIDParameter);
                    AExcelTable.CallOnProcessEvent;
                    AQueryParametersValue.LocateOrAppend(AValue);
                    AExcelTable.CallOnProcessEvent;
                  end;
                end;
              end;
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
    if UpdateOrder then
    begin
      FreeAndNil(AQrySearchParamForCat);
      FreeAndNil(AQrySearchComponentCategory2);
      FreeAndNil(ACaregoryIDList);
    end;
  end;
end;

end.
