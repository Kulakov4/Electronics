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
  FErrorMessage := '���� ������� � ������ %s �� ������';
  FEmptyErrorMessage := '�� ����� �����';

end;

constructor TImageDoc.Create;
begin
  FFieldName := 'Image';
  FFolder := TSettings.Create.ComponentsImageFolder;
  FIDParameter := TDefaultParameters.ImageParameterID;
  FErrorMessage := '���� ����������� � ������ %s �� ������';
  FEmptyErrorMessage := '�� ������ �����������';
end;

constructor TDiagramDoc.Create;
begin
  FFieldName := 'Diagram';
  FFolder := TSettings.Create.ComponentsDiagramFolder;
  FIDParameter := TDefaultParameters.DiagramParameterID;
  FErrorMessage := '���� ����� � ������ %s �� ������';
  FEmptyErrorMessage := '�� ������ �����';

end;

constructor TDatasheetDoc.Create;
begin
  FFieldName := 'Datasheet';
  FFolder := TSettings.Create.ComponentsDatasheetFolder;
  FIDParameter := TDefaultParameters.DatasheetParameterID;
  FErrorMessage := '���� ������������ � ������ %s �� ������';
  FEmptyErrorMessage := '�� ������ ������������';
end;

constructor TOutlineDrawing.Create;
begin
  FFieldName := 'OutlineDrawing';
  FFolder := TSettings.Create.BodyTypesOutlineDrawingFolder;
  FIDParameter := 0;
  FErrorMessage := '���� ������� ���������� �������� � ������ %s �� ������';
  FEmptyErrorMessage := '�� ����� ����� ���������� ��������';
end;

constructor TLandPattern.Create;
begin
  FFieldName := 'LandPattern';
  FFolder := TSettings.Create.BodyTypesLandPatternFolder;
  FIDParameter := 0;
  FErrorMessage := '���� ������� ������� � ������ %s �� ������';
  FEmptyErrorMessage := '�� ����� ����� �������';
end;

constructor TBodyTypeImageDoc.Create;
begin
  FFieldName := 'Image';
  FFolder := TSettings.Create.BodyTypesImageFolder;
  FIDParameter := 0;
  FErrorMessage := '���� ����������� %s �� ������';
  FEmptyErrorMessage := '�� ����� ���� �����������';
end;

end.
