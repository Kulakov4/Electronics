unit DocFieldInfo;

interface

type
  TDocFieldInfo = class abstract
  private
    FEmptyErrorMessage: String;
    FErrorMessage: string;
    FFieldName: string;
    FFolder: string;
    FIDParamSubParam: Integer;
  public
    property EmptyErrorMessage: String read FEmptyErrorMessage;
    property ErrorMessage: string read FErrorMessage;
    property FieldName: string read FFieldName;
    property Folder: string read FFolder;
    property IDParamSubParam: Integer read FIDParamSubParam;
  end;

  TDatasheetDoc = class abstract(TDocFieldInfo)
  public
    constructor Create; virtual;
  end;

  TDiagramDoc = class abstract(TDocFieldInfo)
  public
    constructor Create; virtual;
  end;

  TDrawingDoc = class abstract(TDocFieldInfo)
  public
    constructor Create; virtual;
  end;

  TImageDoc = class abstract(TDocFieldInfo)
  public
    constructor Create; virtual;
  end;

  TOutlineDrawing = class(TDocFieldInfo)
  public
    constructor Create;
  end;

  TLandPattern = class(TDocFieldInfo)
  public
    constructor Create;
  end;

  TBodyTypeImageDoc = class(TDocFieldInfo)
  public
    constructor Create;
  end;

  TComponentDatasheetDoc = class(TDatasheetDoc)
  public
    constructor Create; override;
  end;

  TWareHouseDatasheetDoc = class(TDatasheetDoc)
  public
    constructor Create; override;
  end;

  TComponentDiagramDoc = class(TDiagramDoc)
  public
    constructor Create; override;
  end;

  TWareHouseDiagramDoc = class(TDiagramDoc)
  public
    constructor Create; override;
  end;

  TComponentDrawingDoc = class(TDrawingDoc)
  public
    constructor Create; override;
  end;

  TWareHouseDrawingDoc = class(TDrawingDoc)
  public
    constructor Create; override;
  end;

  TComponentImageDoc = class(TImageDoc)
  public
    constructor Create; override;
  end;

  TWareHouseImageDoc = class(TImageDoc)
  public
    constructor Create; override;
  end;

implementation

uses SettingsController, DefaultParameters;

constructor TDrawingDoc.Create;
begin
  FFieldName := 'Drawing';
  FFolder := TSettings.Create.ComponentsDrawingFolder;
  FIDParamSubParam := TDefaultParameters.DrawingParamSubParamID;
  FErrorMessage := 'Файл чертежа с именем %s не найден';
  FEmptyErrorMessage := 'Не задан чертёж';

end;

constructor TImageDoc.Create;
begin
  FFieldName := 'Image';
  FFolder := TSettings.Create.ComponentsImageFolder;
  FIDParamSubParam := TDefaultParameters.ImageParamSubParamID;
  FErrorMessage := 'Файл изображения с именем %s не найден';
  FEmptyErrorMessage := 'Не задано изображение';
end;

constructor TDiagramDoc.Create;
begin
  FFieldName := 'Diagram';
  FIDParamSubParam := TDefaultParameters.DiagramParamSubParamID;
  FErrorMessage := 'Файл схемы с именем %s не найден';
  FEmptyErrorMessage := 'Не задана схема';
end;

constructor TDatasheetDoc.Create;
begin
  FFieldName := 'Datasheet';
  FIDParamSubParam := TDefaultParameters.DatasheetParamSubParamID;
  FErrorMessage := 'Файл спецификации с именем %s не найден';
  FEmptyErrorMessage := 'Не задана спецификация';
end;

constructor TOutlineDrawing.Create;
begin
  FFieldName := 'OutlineDrawing';
  FFolder := TSettings.Create.BodyTypesOutlineDrawingFolder;
  FIDParamSubParam := 0;
  FErrorMessage := 'Файл чертежа посадочной площадки с именем %s не найден';
  FEmptyErrorMessage := 'Не задан чертёж посадочной площадки';
end;

constructor TLandPattern.Create;
begin
  FFieldName := 'LandPattern';
  FFolder := TSettings.Create.BodyTypesLandPatternFolder;
  FIDParamSubParam := 0;
  FErrorMessage := 'Файл чертежа корпуса с именем %s не найден';
  FEmptyErrorMessage := 'Не задан чертёж корпуса';
end;

constructor TBodyTypeImageDoc.Create;
begin
  FFieldName := 'Image';
  FFolder := TSettings.Create.BodyTypesImageFolder;
  FIDParamSubParam := 0;
  FErrorMessage := 'Файл изображения %s не найден';
  FEmptyErrorMessage := 'Не задан файл изображения';
end;

constructor TComponentDatasheetDoc.Create;
begin
  inherited;
  FFolder := TSettings.Create.ComponentsDatasheetFolder;
end;

constructor TWareHouseDatasheetDoc.Create;
begin
  inherited;
  FFolder := TSettings.Create.WareHouseDatasheetFolder;
end;

constructor TComponentDiagramDoc.Create;
begin
  inherited;
  FFolder := TSettings.Create.ComponentsDiagramFolder;
end;

constructor TWareHouseDiagramDoc.Create;
begin
  inherited;
  FFolder := TSettings.Create.WareHouseDiagramFolder;
end;

constructor TComponentDrawingDoc.Create;
begin
  inherited;
  FFolder := TSettings.Create.ComponentsDrawingFolder;
end;

constructor TWareHouseDrawingDoc.Create;
begin
  inherited;
  FFolder := TSettings.Create.WareHouseDrawingFolder;
end;

constructor TComponentImageDoc.Create;
begin
  inherited;
  FFolder := TSettings.Create.ComponentsImageFolder;
end;

constructor TWareHouseImageDoc.Create;
begin
  inherited;
  FFolder := TSettings.Create.WareHouseImageFolder;
end;

end.
