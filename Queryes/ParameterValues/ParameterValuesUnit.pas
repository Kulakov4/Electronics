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
  // ���� ���������� ��� ��������� � ��������� ������ Package/Pins (������/���-�� �������)
  if FPackagePinsParameterID = 0 then
  begin
    // ���� �������� ���� ��������� ���
    QuerySearchMainParameter.SearchOrAppend(sPackagePinsParamTableName, True);
    FPackagePinsParameterID := QuerySearchMainParameter.PK.AsInteger;
  end;

  Result := FPackagePinsParameterID;
end;

class function TParameterValues.GetDatasheetParameterID: Integer;
begin
  // ���� ���������� ��� ��������� � ��������� ������ Datasheet (����������� ������������)
  if FDatasheetParameterID = 0 then
  begin
    // ���� �������� ���� ��������� ���
    QuerySearchMainParameter.SearchOrAppend(sDatasheetParamTableName, True);
    FDatasheetParameterID := QuerySearchMainParameter.PK.AsInteger;
  end;

  Result := FDatasheetParameterID;
end;

class function TParameterValues.GetDiagramParameterID: Integer;
begin
  // ���� ���������� ��� ��������� � ��������� ������ Diagram (����������� �����)
  if FDiagramParameterID = 0 then
  begin
    // ���� �������� ���� ��������� ���
    QuerySearchMainParameter.SearchOrAppend(sDiagramParamTableName, True);
    FDiagramParameterID := QuerySearchMainParameter.PK.AsInteger;
  end;

  Result := FDiagramParameterID;
end;

class function TParameterValues.GetDrawingParameterID: Integer;
begin
  // ���� ���������� ��� ��������� � ��������� ������ Drawing (�����)
  if FDrawingParameterID = 0 then
  begin
    // ���� �������� ���� ��������� ���
    QuerySearchMainParameter.SearchOrAppend(sDrawingParamTableName, True);
    FDrawingParameterID := QuerySearchMainParameter.PK.AsInteger;
  end;

  Result := FDrawingParameterID;
end;

class function TParameterValues.GetProducerParameterID: Integer;
begin
  // ���� ���������� ��� ��������� � ��������� ������ Producer (�������������)
  if FProducerParameterID = 0 then
  begin
    // ���� �������� ���� ��������� ���
    QuerySearchMainParameter.SearchOrAppend(sProducerParamTableName, True);
    FProducerParameterID := QuerySearchMainParameter.PK.AsInteger;
  end;

  Result := FProducerParameterID;
end;

class function TParameterValues.GetImageParameterID: Integer;
begin
  // ���� ���������� ��� ��������� � ��������� ������ Image (�����������)
  if FImageParameterID = 0 then
  begin
    // ���� �������� ���� ��������� ���
    QuerySearchMainParameter.SearchOrAppend(sImageParamTableName, True);
    FImageParameterID := QuerySearchMainParameter.PK.AsInteger;
  end;

  Result := FImageParameterID;
end;

class function TParameterValues.GetDescriptionParameterID: Integer;
begin
  // ���� ���������� ��� ��������� � ��������� ������ Description (��������)
  if FDescriptionParameterID = 0 then
  begin
    // ���� �������� ���� ��������� ���
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
    // ��������� �������������� ���� ����������� �� ��������� �������
    ATempTable.AppendData(AExcelTable.IDComponent);

    AOrder := TQueryMaxCategoryParameterOrder.Max_Order;

    API.TotalRecords := AExcelTable.FieldsInfo.Count;
    i := 0;
    // ���� �� ���� ��������� �����
    for AFieldInfo in AExcelTable.FieldsInfo do
    begin
      // �������� � ���, ������� ���������� ��� ��������
      Inc(i);
      API.ProcessRecords := i;
      AExcelTable.OnProgress.CallEventHandlers(API);

      if not AExcelTable.GetIDParamByFieldName(AFieldInfo.FieldName,
        AIDParameter, AIDParentParameter) then
        continue;

      // ���� ���� ��� ��������, ���� ������������
      AIDP := IfThen(AIDParentParameter > 0, AIDParentParameter, AIDParameter);

      // ���� ����� �������� ��� ���������
      if AParamOrders.ContainsKey(AIDP) then
        AOrder := AParamOrders[AIDP]
      else
      begin
        Inc(AOrder); // ����� ���������� ����� ������ ���������
        AParamOrders.Add(AIDP, AOrder);
      end;

      // ��������� ���� �������� �� ��� ��������� ����� �����������
      AQueryParametersForProduct.LoadAndProcess(ATempTable.TableName,
        AIDP, AOrder);

      // ��� ��������� ��������� ��������� ��� ���� �� ��� ��������� ����� �����������
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

        // ���� �� ���� ��������� �����
        for AFieldInfo in AExcelTable.FieldsInfo do
        begin
          AExcelTable.CallOnProcessEvent;

          if not AExcelTable.GetIDParamByFieldName(AFieldInfo.FieldName,
            AIDParameter, AIDParentParameter) then
            continue;

          AExcelTable.CallOnProcessEvent;

          AValue := AExcelTable.FieldByName(AFieldInfo.FieldName).AsString;

          // ���� �������� ��� ��������� �� ������
          if AValue.IsEmpty then
            continue;

          // ����� ������ �� ����� �� �������
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

            // ���� �� ��������� � ������������� ����������
            for AIDComponent in AIDComponents do
            begin
              AExcelTable.CallOnProcessEvent;

              // ��������� �������� � ������� �������� ���������
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
