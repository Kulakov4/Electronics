unit BodyTypesExcelDataModule3;

interface

uses
  System.SysUtils, System.Classes, ExcelDataModule, Excel2010, Vcl.OleServer,
  CustomExcelTable, Data.DB, FireDAC.Comp.Client, FireDAC.Comp.DataSet;

{$WARN SYMBOL_PLATFORM OFF}

type
  TBodyTypesExcelTable3 = class(TCustomExcelTable)
  private
    FBodyVariationsDataSet: TFDDataSet;
    FfdmtBodyVariations: TFDMemTable;
    function GetBodyKind: TField;
    function GetBody: TField;
    function GetImage: TField;
    function GetLandPattern: TField;
    function GetOutlineDrawing: TField;
    function GetBodyData: TField;
    function GetVariation: TField;
    procedure SetBodyVariationsDataSet(const Value: TFDDataSet);
  protected
    function CheckBodyVariation: Boolean;
    procedure Clone;
    procedure SetFieldsInfo; override;
  public
    constructor Create(AOwner: TComponent); override;
    function CheckRecord: Boolean; override;
    property BodyKind: TField read GetBodyKind;
    property Body: TField read GetBody;
    property BodyVariationsDataSet: TFDDataSet read FBodyVariationsDataSet
      write SetBodyVariationsDataSet;
    property Image: TField read GetImage;
    property LandPattern: TField read GetLandPattern;
    property OutlineDrawing: TField read GetOutlineDrawing;
    property BodyData: TField read GetBodyData;
    property Variation: TField read GetVariation;
  end;

  TBodyTypesExcelDM3 = class(TExcelDM)
  private
    function GetExcelTable: TBodyTypesExcelTable3;
    { Private declarations }
  protected
    function CreateExcelTable: TCustomExcelTable; override;
  public
    property ExcelTable: TBodyTypesExcelTable3 read GetExcelTable;
    { Public declarations }
  end;

implementation

{ %CLASSGROUP 'Vcl.Controls.TControl' }

{$R *.dfm}

uses System.Variants, FieldInfoUnit;

constructor TBodyTypesExcelTable3.Create(AOwner: TComponent);
begin
  inherited;
  FfdmtBodyVariations := TFDMemTable.Create(Self);
end;

function TBodyTypesExcelTable3.CheckBodyVariation: Boolean;
var
  V: Variant;
begin
  // Ищем параметр с таким-же именем
  V := FfdmtBodyVariations.LookupEx(Format('%s', [Variation.FieldName]),
    Variation.Value, 'ID');

  Result := VarIsNull(V);

  // Если нашли
  if not Result then
  begin
    MarkAsError(etWarring);

    Errors.AddWarring(ExcelRow.AsInteger, Variation.Index + 1,
      Variation.AsString, 'Такой вариант корпуса уже существует');
  end;
end;

function TBodyTypesExcelTable3.CheckRecord: Boolean;
begin
  Result := inherited;
  if Result then
  begin
    // Проверяем что такой корпус существует
    Result := CheckBodyVariation;
  end;
end;

procedure TBodyTypesExcelTable3.Clone;
var
  AFDIndex: TFDIndex;
begin
  // Клонируем курсор
  FfdmtBodyVariations.CloneCursor(BodyVariationsDataSet);

  // Создаём индекс
  AFDIndex := FfdmtBodyVariations.Indexes.Add;

  AFDIndex.Fields := Format('%s', [Variation.FieldName]);
  AFDIndex.Name := 'idxBodyVariations';
  AFDIndex.Active := True;
  FfdmtBodyVariations.IndexName := AFDIndex.Name;
end;

function TBodyTypesExcelTable3.GetBodyKind: TField;
begin
  Result := FieldByName('BodyKind');
end;

function TBodyTypesExcelTable3.GetBody: TField;
begin
  Result := FieldByName('Body');
end;

function TBodyTypesExcelTable3.GetImage: TField;
begin
  Result := FieldByName('Image');
end;

function TBodyTypesExcelTable3.GetLandPattern: TField;
begin
  Result := FieldByName('LandPattern');
end;

function TBodyTypesExcelTable3.GetOutlineDrawing: TField;
begin
  Result := FieldByName('OutlineDrawing');
end;

function TBodyTypesExcelTable3.GetBodyData: TField;
begin
  Result := FieldByName('BodyData');
end;

function TBodyTypesExcelTable3.GetVariation: TField;
begin
  Result := FieldByName('Variation');
end;

procedure TBodyTypesExcelTable3.SetBodyVariationsDataSet
  (const Value: TFDDataSet);
begin
  if FBodyVariationsDataSet <> Value then
  begin
    FBodyVariationsDataSet := Value;
    if FBodyVariationsDataSet <> nil then
    begin
      Clone;
    end;
  end;
end;

procedure TBodyTypesExcelTable3.SetFieldsInfo;
begin
  FieldsInfo.Add(TFieldInfo.Create('Body', True,
    'Корпус не может быть пустым'));
  FieldsInfo.Add(TFieldInfo.Create('BodyData', True,
    'Корпусные данные не могут быть пустыми'));
  FieldsInfo.Add(TFieldInfo.Create('OutlineDrawing'));
  FieldsInfo.Add(TFieldInfo.Create('LandPattern'));
  FieldsInfo.Add(TFieldInfo.Create('Variation'));
  FieldsInfo.Add(TFieldInfo.Create('Image'));
  FieldsInfo.Add(TFieldInfo.Create('BodyKind', True,
    'Тип корпуса не может быть пустым'));

end;

function TBodyTypesExcelDM3.CreateExcelTable: TCustomExcelTable;
begin
  Result := TBodyTypesExcelTable3.Create(Self);
end;

function TBodyTypesExcelDM3.GetExcelTable: TBodyTypesExcelTable3;
begin
  Result := CustomExcelTable as TBodyTypesExcelTable3;
end;

end.
