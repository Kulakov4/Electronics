unit DocFieldInfo;

interface

type
  TDocFieldInfo = class
  private
    FFieldName: string;
    FFolder: string;
  public
    property FieldName: string read FFieldName;
    property Folder: string read FFolder;
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

uses SettingsController;

constructor TDrawingDoc.Create;
begin
  FFieldName := 'Drawing';
  FFolder := TSettings.Create.ComponentsDrawingFolder;
end;

constructor TImageDoc.Create;
begin
  FFieldName := 'Image';
  FFolder := TSettings.Create.ComponentsImageFolder;
end;

constructor TDiagramDoc.Create;
begin
  FFieldName := 'Diagram';
  FFolder := TSettings.Create.ComponentsDiagramFolder;
end;

constructor TDatasheetDoc.Create;
begin
  FFieldName := 'Datasheet';
  FFolder := TSettings.Create.ComponentsDatasheetFolder;
end;

end.
