unit DefaultParameters;

interface

uses
  SearchParameterQuery;

type
  TDefaultParameters = class(TObject)
  private
  class var
    FDatasheetParamSubParamID: Integer;
    FDescriptionParamSubParamID: Integer;
    FDiagramParamSubParamID: Integer;
    FDrawingParamSubParamID: Integer;
    FImageParamSubParamID: Integer;
    FPackagePinsParamSubParamID: Integer;
    FProducerParamSubParamID: Integer;
    FqSearchParameter: TQuerySearchParameter;

  var
    class function GetDatasheetParamSubParamID: Integer; static;
    class function GetDescriptionParamSubParamID: Integer; static;
    class function GetDiagramParamSubParamID: Integer; static;
    class function GetDrawingParamSubParamID: Integer; static;
    class function GetImageParamSubParamID: Integer; static;
    class function GetPackagePinsParamSubParamID: Integer; static;
    class function GetProducerParamSubParamID: Integer; static;
    class function GetqSearchParameter: TQuerySearchParameter; static;
    class property qSearchParameter: TQuerySearchParameter
      read GetqSearchParameter;
  public
    class property DatasheetParamSubParamID: Integer
      read GetDatasheetParamSubParamID;
    class property DescriptionParamSubParamID: Integer
      read GetDescriptionParamSubParamID;
    class property DiagramParamSubParamID: Integer
      read GetDiagramParamSubParamID;
    class property DrawingParamSubParamID: Integer
      read GetDrawingParamSubParamID;
    class property ImageParamSubParamID: Integer read GetImageParamSubParamID;
    class property PackagePinsParamSubParamID: Integer
      read GetPackagePinsParamSubParamID;
    class property ProducerParamSubParamID: Integer
      read GetProducerParamSubParamID;
  end;

implementation

uses ProjectConst, System.Contnrs, System.SysUtils, System.Classes;

var
  SingletonList: TObjectList;

class function TDefaultParameters.GetDatasheetParamSubParamID: Integer;
begin
  // ���� ���������� ��� ��������� � ��������� ������ Datasheet (����������� ������������)
  if FDatasheetParamSubParamID = 0 then
  begin
    // ���� �������� ���� ��������� ���
    qSearchParameter.SearchMainOrAppend(sDatasheetParamTableName, True);
    FDatasheetParamSubParamID := qSearchParameter.ParamSubParamID.AsInteger;
    Assert(FDatasheetParamSubParamID > 0);
  end;

  Result := FDatasheetParamSubParamID;
end;

class function TDefaultParameters.GetDescriptionParamSubParamID: Integer;
begin
  // ���� ���������� ��� ��������� � ��������� ������ Description (��������)
  if FDescriptionParamSubParamID = 0 then
  begin
    // ���� �������� ���� ��������� ���
    qSearchParameter.SearchMainOrAppend(sDescriptionParamTableName, True);
    FDescriptionParamSubParamID := qSearchParameter.ParamSubParamID.AsInteger;
    Assert(FDescriptionParamSubParamID > 0);
  end;

  Result := FDescriptionParamSubParamID;
end;

class function TDefaultParameters.GetDiagramParamSubParamID: Integer;
begin
  // ���� ���������� ��� ��������� � ��������� ������ Diagram (����������� �����)
  if FDiagramParamSubParamID = 0 then
  begin
    // ���� �������� ���� ��������� ���
    qSearchParameter.SearchMainOrAppend(sDiagramParamTableName, True);
    FDiagramParamSubParamID := qSearchParameter.ParamSubParamID.AsInteger;
    Assert(FDiagramParamSubParamID > 0);
  end;

  Result := FDiagramParamSubParamID;
end;

class function TDefaultParameters.GetDrawingParamSubParamID: Integer;
begin
  // ���� ���������� ��� ��������� � ��������� ������ Drawing (�����)
  if FDrawingParamSubParamID = 0 then
  begin
    // ���� �������� ���� ��������� ���
    qSearchParameter.SearchMainOrAppend(sDrawingParamTableName, True);
    FDrawingParamSubParamID := qSearchParameter.ParamSubParamID.AsInteger;
    Assert(FDrawingParamSubParamID > 0);
  end;

  Result := FDrawingParamSubParamID;
end;

class function TDefaultParameters.GetImageParamSubParamID: Integer;
begin
  // ���� ���������� ��� ��������� � ��������� ������ Image (�����������)
  if FImageParamSubParamID = 0 then
  begin
    // ���� �������� ���� ��������� ���
    qSearchParameter.SearchMainOrAppend(sImageParamTableName, True);
    FImageParamSubParamID := qSearchParameter.ParamSubParamID.AsInteger;
    Assert(FImageParamSubParamID > 0);
  end;

  Result := FImageParamSubParamID;
end;

class function TDefaultParameters.GetPackagePinsParamSubParamID: Integer;
begin
  // ���� ���������� ��� ��������� � ��������� ������ Package/Pins (������/���-�� �������)
  if FPackagePinsParamSubParamID = 0 then
  begin
    // ���� �������� ���� ��������� ���
    qSearchParameter.SearchMainOrAppend(sPackagePinsParamTableName, True);
    FPackagePinsParamSubParamID := qSearchParameter.ParamSubParamID.AsInteger;
    Assert(FPackagePinsParamSubParamID > 0);
  end;

  Result := FPackagePinsParamSubParamID;
end;

class function TDefaultParameters.GetProducerParamSubParamID: Integer;
begin
  // ���� ���������� ��� ������ ��������� � ��������� ������ Producer (�������������)
  // � ��� ������������� �� ���������
  if FProducerParamSubParamID = 0 then
  begin
    // ���� �������� ���� ��������� ���
    qSearchParameter.SearchMainOrAppend(sProducerParamTableName, True);
    FProducerParamSubParamID := qSearchParameter.ParamSubParamID.AsInteger;
    Assert(FProducerParamSubParamID > 0);
  end;

  Result := FProducerParamSubParamID;
end;

class function TDefaultParameters.GetqSearchParameter: TQuerySearchParameter;
begin
  if FqSearchParameter = nil then
  begin
    FqSearchParameter := TQuerySearchParameter.Create(nil);
    SingletonList.Add(FqSearchParameter);
  end;

  Result := FqSearchParameter;
end;

initialization
  SingletonList := TObjectList.Create(True);

finalization
begin
  FreeAndNil(SingletonList);
end;

end.
