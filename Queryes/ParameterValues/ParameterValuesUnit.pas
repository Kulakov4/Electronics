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

// ��������� ��������� �� ������� ���������
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
    // ���� �� ���� ��������� �����
    for AFieldInfo in AExcelTable.FieldsInfo do
    begin
      // �������� � ���, ������� ���������� ��� ��������
      Inc(i);
      API.ProcessRecords := i;
      AExcelTable.OnProgress.CallEventHandlers(API);

      // ���� ����� ���� �� ������������� ������ ��������� � �������������
      if not AExcelTable.GetParamSubParamIDByFieldName(AFieldInfo.FieldName,
        AParamSubParamID) then
        continue;

      // ���� ����� �������� ��� ���������
      if AParamOrders.ContainsKey(AParamSubParamID) then
        AOrder := AParamOrders[AParamSubParamID]
      else
      begin
        Inc(AOrder);
        // ����� ���������� ����� ����� ����� ����� ���������� � �������������
        AParamOrders.Add(AParamSubParamID, AOrder);
      end;

      // ��������� ��� ����� ����� ���������� � ������������� � ��������� ���������
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

  // ���� ������� ����� ������� ��� ����������� ���������
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

        // ���� �� ���� ��������� �����
        for AFieldInfo in AExcelTable.FieldsInfo do
        begin
          AExcelTable.CallOnProcessEvent;

          // ���� ����� ���� �� ������������� ������ ��������� � �������������
          if not AExcelTable.GetParamSubParamIDByFieldName(AFieldInfo.FieldName,
            AParamSubParamID) then
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

            // ���� ��������� �������� ��� ����������
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

            // ���� ��� �������� ��� ����� ���� ������ ��������� � �������������
            AQueryParametersValue.Search(AIDComponent, AParamSubParamID);
            AExcelTable.CallOnProcessEvent;

            // ��������� �������� � ������� �������� ������ ��������� � �������������
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

    // ������������ �������� ������� � ������ ���������
    Q := TQueryFamilyParamValues.Create(nil);
    API := TProgressInfo.Create;
    try
      API.TotalRecords := AUpdParamSubParamList.Count;
      i := 0;
      for AUpdPSP in AUpdParamSubParamList do
      begin
        // ���� ������� ������������ ��������
        if Q.SearchEx(AUpdPSP.FamilyID, AUpdPSP.ParamSubParamID) = 1 then
        begin
          // ��������� �������� ��������� ��� ���������
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
