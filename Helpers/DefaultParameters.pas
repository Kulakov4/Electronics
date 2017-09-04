unit DefaultParameters;

interface

uses
  SearchParameterQuery;

type
  TDefaultParameters = class(TObject)
  private
  class var
    FDatasheetParameterID: Integer;
    FDescriptionParameterID: Integer;
    FDiagramParameterID: Integer;
    FDrawingParameterID: Integer;
    FImageParameterID: Integer;
    FPackagePinsParameterID: Integer;
    FProducerParameterID: Integer;
    FqSearchParameter: TQuerySearchParameter;
    class function GetDatasheetParameterID: Integer; static;
    class function GetDescriptionParameterID: Integer; static;
    class function GetDiagramParameterID: Integer; static;
    class function GetDrawingParameterID: Integer; static;
    class function GetImageParameterID: Integer; static;
    class function GetPackagePinsParameterID: Integer; static;
    class function GetProducerParameterID: Integer; static;
    class function GetqSearchParameter: TQuerySearchParameter; static;
    class property qSearchParameter: TQuerySearchParameter read GetqSearchParameter;
  public
    class property DatasheetParameterID: Integer read GetDatasheetParameterID;
    class property DescriptionParameterID: Integer read GetDescriptionParameterID;
    class property DiagramParameterID: Integer read GetDiagramParameterID;
    class property DrawingParameterID: Integer read GetDrawingParameterID;
    class property ImageParameterID: Integer read GetImageParameterID;
    class property PackagePinsParameterID: Integer read GetPackagePinsParameterID;
    class property ProducerParameterID: Integer read GetProducerParameterID;
  end;

implementation

uses ProjectConst;

class function TDefaultParameters.GetDatasheetParameterID: Integer;
begin
  // Надо поределить код параметра с табличным именем Datasheet (техническая спецификация)
  if FDatasheetParameterID = 0 then
  begin
    // Ищем параметр либо добавляем его
    qSearchParameter.SearchMainOrAppend(sDatasheetParamTableName, True);
    FDatasheetParameterID := qSearchParameter.PK.AsInteger;
  end;

  Result := FDatasheetParameterID;
end;

class function TDefaultParameters.GetDescriptionParameterID: Integer;
begin
  // Надо поределить код параметра с табличным именем Description (описание)
  if FDescriptionParameterID = 0 then
  begin
    // Ищем параметр либо добавляем его
    qSearchParameter.SearchMainOrAppend(sDescriptionParamTableName, True);
    FDescriptionParameterID := qSearchParameter.PK.AsInteger;
  end;

  Result := FDescriptionParameterID;
end;

class function TDefaultParameters.GetDiagramParameterID: Integer;
begin
  // Надо поределить код параметра с табличным именем Diagram (структурная схема)
  if FDiagramParameterID = 0 then
  begin
    // Ищем параметр либо добавляем его
    qSearchParameter.SearchMainOrAppend(sDiagramParamTableName, True);
    FDiagramParameterID := qSearchParameter.PK.AsInteger;
  end;

  Result := FDiagramParameterID;
end;

class function TDefaultParameters.GetDrawingParameterID: Integer;
begin
  // Надо поределить код параметра с табличным именем Drawing (чертёж)
  if FDrawingParameterID = 0 then
  begin
    // Ищем параметр либо добавляем его
    qSearchParameter.SearchMainOrAppend(sDrawingParamTableName, True);
    FDrawingParameterID := qSearchParameter.PK.AsInteger;
  end;

  Result := FDrawingParameterID;
end;

class function TDefaultParameters.GetImageParameterID: Integer;
begin
  // Надо поределить код параметра с табличным именем Image (изображение)
  if FImageParameterID = 0 then
  begin
    // Ищем параметр либо добавляем его
    qSearchParameter.SearchMainOrAppend(sImageParamTableName, True);
    FImageParameterID := qSearchParameter.PK.AsInteger;
  end;

  Result := FImageParameterID;
end;

class function TDefaultParameters.GetPackagePinsParameterID: Integer;
begin
  // Надо поределить код параметра с табличным именем Package/Pins (Корпус/Кол-во выводов)
  if FPackagePinsParameterID = 0 then
  begin
    // Ищем параметр либо добавляем его
    qSearchParameter.SearchMainOrAppend(sPackagePinsParamTableName, True);
    FPackagePinsParameterID := qSearchParameter.PK.AsInteger;
  end;

  Result := FPackagePinsParameterID;
end;

class function TDefaultParameters.GetProducerParameterID: Integer;
begin
  // Надо поределить код параметра с табличным именем Producer (производитель)
  if FProducerParameterID = 0 then
  begin
    // Ищем параметр либо добавляем его
    qSearchParameter.SearchMainOrAppend(sProducerParamTableName, True);
    FProducerParameterID := qSearchParameter.PK.AsInteger;
  end;

  Result := FProducerParameterID;
end;

class function TDefaultParameters.GetqSearchParameter: TQuerySearchParameter;
begin
  if FqSearchParameter = nil then
    FqSearchParameter := TQuerySearchParameter.Create(nil);

  Result := FqSearchParameter;
end;

end.
