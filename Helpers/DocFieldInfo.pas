unit DocFieldInfo;

interface

type
  TDocFieldInfo = class abstract
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
  FIDParameter := TDefaultParameters.DiagramParameterID;
  FErrorMessage := '���� ����� � ������ %s �� ������';
  FEmptyErrorMessage := '�� ������ �����';
end;

constructor TDatasheetDoc.Create;
begin
  FFieldName := 'Datasheet';
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
