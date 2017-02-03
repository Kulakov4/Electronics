unit DocFieldInfo;

interface

type
  TDocFieldInfo = class
  private
    FFieldName: string;
    FFolder: string;
    FIDParameter: Integer;
  public
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

implementation

uses SettingsController, ParameterValuesUnit;

constructor TDrawingDoc.Create;
begin
  FFieldName := 'Drawing';
  FFolder := TSettings.Create.ComponentsDrawingFolder;
  FIDParameter := TParameterValues.DrawingParameterID;
end;

constructor TImageDoc.Create;
begin
  FFieldName := 'Image';
  FFolder := TSettings.Create.ComponentsImageFolder;
  FIDParameter := TParameterValues.ImageParameterID;
end;

constructor TDiagramDoc.Create;
begin
  FFieldName := 'Diagram';
  FFolder := TSettings.Create.ComponentsDiagramFolder;
  FIDParameter := TParameterValues.DiagramParameterID;
end;

constructor TDatasheetDoc.Create;
begin
  FFieldName := 'Datasheet';
  FFolder := TSettings.Create.ComponentsDatasheetFolder;
  FIDParameter := TParameterValues.DatasheetParameterID;
end;

end.
