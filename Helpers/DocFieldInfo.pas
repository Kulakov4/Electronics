unit DocFieldInfo;

interface

type
  TDocFieldInfo = class
  private
    FEmptyErrorMessage: String;
    FErrorMessage: string;
    FFieldName: string;
    FFolder: string;
    FIDParameter: Integer;
  public
    property EmptyErrorMessage: String read FEmptyErrorMessage;
    property ErrorMessage: string read FErrorMessage;
    property FieldName: string read FFieldName;
    property Folder: string read FFolder;
    property IDParameter: Integer read FIDParameter;
  end;

  TDatasheetDoc = class(TDocFieldInfo)
  public
    constructor Create;
  end;

  TDiagramDoc = class(TDocFieldInfo)
  public
    constructor Create;
  end;

  TDrawingDoc = class(TDocFieldInfo)
  public
    constructor Create;
  end;

  TImageDoc = class(TDocFieldInfo)
  public
    constructor Create;
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

implementation

uses SettingsController, DefaultParameters;

constructor TDrawingDoc.Create;
begin
  FFieldName := 'Drawing';
  FFolder := TSettings.Create.ComponentsDrawingFolder;
  FIDParameter := TDefaultParameters.DrawingParameterID;
  FErrorMessage := 'Файл чертежа с именем %s не найден';
  FEmptyErrorMessage := 'Не задан чертёж';

end;

constructor TImageDoc.Create;
begin
  FFieldName := 'Image';
  FFolder := TSettings.Create.ComponentsImageFolder;
  FIDParameter := TDefaultParameters.ImageParameterID;
  FErrorMessage := 'Файл изображения с именем %s не найден';
  FEmptyErrorMessage := 'Не задано изображение';
end;

constructor TDiagramDoc.Create;
begin
  FFieldName := 'Diagram';
  FFolder := TSettings.Create.ComponentsDiagramFolder;
  FIDParameter := TDefaultParameters.DiagramParameterID;
  FErrorMessage := 'Файл схемы с именем %s не найден';
  FEmptyErrorMessage := 'Не задана схема';

end;

constructor TDatasheetDoc.Create;
begin
  FFieldName := 'Datasheet';
  FFolder := TSettings.Create.ComponentsDatasheetFolder;
  FIDParameter := TDefaultParameters.DatasheetParameterID;
  FErrorMessage := 'Файл спецификации с именем %s не найден';
  FEmptyErrorMessage := 'Не задана спецификация';
end;

constructor TOutlineDrawing.Create;
begin
  FFieldName := 'OutlineDrawing';
  FFolder := TSettings.Create.BodyTypesOutlineDrawingFolder;
  FIDParameter := 0;
  FErrorMessage := 'Файл чертежа посадочной площадки с именем %s не найден';
  FEmptyErrorMessage := 'Не задан чертёж посадочной площадки';
end;

constructor TLandPattern.Create;
begin
  FFieldName := 'LandPattern';
  FFolder := TSettings.Create.BodyTypesLandPatternFolder;
  FIDParameter := 0;
  FErrorMessage := 'Файл чертежа корпуса с именем %s не найден';
  FEmptyErrorMessage := 'Не задан чертёж корпуса';
end;

constructor TBodyTypeImageDoc.Create;
begin
  FFieldName := 'Image';
  FFolder := TSettings.Create.BodyTypesImageFolder;
  FIDParameter := 0;
  FErrorMessage := 'Файл изображения %s не найден';
  FEmptyErrorMessage := 'Не задан файл изображения';
end;

end.
