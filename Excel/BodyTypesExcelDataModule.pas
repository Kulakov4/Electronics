unit BodyTypesExcelDataModule;

interface

uses
  System.SysUtils, System.Classes, ExcelDataModule, Excel2010, Vcl.OleServer,
  CustomExcelTable, Data.DB, FireDAC.Comp.Client, FireDAC.Comp.DataSet;

{$WARN SYMBOL_PLATFORM OFF}

type
  TBodyTypesExcelTable = class(TCustomExcelTable)
  private
// TODO: FBodyVariationsDataSet
//  FBodyVariationsDataSet: TFDDataSet;
    FfdmtBodyVariations: TFDMemTable;
    function GetBodyKind: TField;
    function GetBody: TField;
    function GetImage: TField;
    function GetLandPattern: TField;
    function GetOutlineDrawing: TField;
    function GetBodyData: TField;
    function GetVariation: TField;
// TODO: SetBodyVariationsDataSet
//  procedure SetBodyVariationsDataSet(const Value: TFDDataSet);
  protected
// TODO: CheckBodyVariation
//  function CheckBodyVariation: Boolean;
// TODO: Clone
//  procedure Clone;
    procedure SetFieldsInfo; override;
  public
    constructor Create(AOwner: TComponent); override;
// TODO: CheckRecord
//  function CheckRecord: Boolean; override;
    property BodyKind: TField read GetBodyKind;
    property Body: TField read GetBody;
// TODO: BodyVariationsDataSet
//  property BodyVariationsDataSet: TFDDataSet read FBodyVariationsDataSet
//    write SetBodyVariationsDataSet;
    property Image: TField read GetImage;
    property LandPattern: TField read GetLandPattern;
    property OutlineDrawing: TField read GetOutlineDrawing;
    property BodyData: TField read GetBodyData;
    property Variation: TField read GetVariation;
  end;

  TBodyTypesExcelDM = class(TExcelDM)
  private
    function GetExcelTable: TBodyTypesExcelTable;
    { Private declarations }
  protected
    function CreateExcelTable: TCustomExcelTable; override;
  public
    property ExcelTable: TBodyTypesExcelTable read GetExcelTable;
    { Public declarations }
  end;

implementation

{ %CLASSGROUP 'Vcl.Controls.TControl' }

{$R *.dfm}

uses System.Variants, FieldInfoUnit;

constructor TBodyTypesExcelTable.Create(AOwner: TComponent);
begin
  inherited;
  FfdmtBodyVariations := TFDMemTable.Create(Self);
end;

// TODO: CheckRecord
//// TODO: CheckBodyVariation
////function TBodyTypesExcelTable.CheckBodyVariation: Boolean;
////var
////V: Variant;
////begin
////// ���� �������� � �����-�� ������
////V := FfdmtBodyVariations.LookupEx(Format('%s', [Variation.FieldName]),
////  Variation.Value, 'ID');
////
////Result := VarIsNull(V);
////
////// ���� �����
////if not Result then
////begin
////  MarkAsError(etWarring);
////
////  Errors.AddWarring(ExcelRow.AsInteger, Variation.Index + 1,
////    Variation.AsString, '����� ������� ������� ��� ����������');
////end;
////
////end;
//
//function TBodyTypesExcelTable.CheckRecord: Boolean;
//begin
//Result := inherited;
//if Result then
//begin
//  // ��������� ��� ����� ������ ����������
//  Result := CheckBodyVariation;
//end;
//end;

// TODO: Clone
//procedure TBodyTypesExcelTable.Clone;
//var
//AFDIndex: TFDIndex;
//begin
//// ��������� ������
//FfdmtBodyVariations.CloneCursor(BodyVariationsDataSet);
//
//// ������ ������
//AFDIndex := FfdmtBodyVariations.Indexes.Add;
//
//AFDIndex.Fields := Format('%s', [Variation.FieldName]);
//AFDIndex.Name := 'idxBodyVariations';
//AFDIndex.Active := True;
//FfdmtBodyVariations.IndexName := AFDIndex.Name;
//end;

function TBodyTypesExcelTable.GetBodyKind: TField;
begin
  Result := FieldByName('BodyKind');
end;

function TBodyTypesExcelTable.GetBody: TField;
begin
  Result := FieldByName('Body');
end;

function TBodyTypesExcelTable.GetImage: TField;
begin
  Result := FieldByName('Image');
end;

function TBodyTypesExcelTable.GetLandPattern: TField;
begin
  Result := FieldByName('LandPattern');
end;

function TBodyTypesExcelTable.GetOutlineDrawing: TField;
begin
  Result := FieldByName('OutlineDrawing');
end;

function TBodyTypesExcelTable.GetBodyData: TField;
begin
  Result := FieldByName('BodyData');
end;

function TBodyTypesExcelTable.GetVariation: TField;
begin
  Result := FieldByName('Variation');
end;

// TODO: SetBodyVariationsDataSet
//procedure TBodyTypesExcelTable.SetBodyVariationsDataSet
//(const Value: TFDDataSet);
//begin
//if FBodyVariationsDataSet <> Value then
//begin
//  FBodyVariationsDataSet := Value;
//  if FBodyVariationsDataSet <> nil then
//  begin
//    Clone;
//  end;
//end;
//end;

procedure TBodyTypesExcelTable.SetFieldsInfo;
begin
  FieldsInfo.Add(TFieldInfo.Create('Body', True,
    '������ �� ����� ���� ������'));
  FieldsInfo.Add(TFieldInfo.Create('BodyData', True,
    '��������� ������ �� ����� ���� �������'));
  FieldsInfo.Add(TFieldInfo.Create('OutlineDrawing'));
  FieldsInfo.Add(TFieldInfo.Create('LandPattern'));
  FieldsInfo.Add(TFieldInfo.Create('Variation'));
  FieldsInfo.Add(TFieldInfo.Create('Image'));
  FieldsInfo.Add(TFieldInfo.Create('BodyKind', True,
    '��� ������� �� ����� ���� ������', True));

end;

function TBodyTypesExcelDM.CreateExcelTable: TCustomExcelTable;
begin
  Result := TBodyTypesExcelTable.Create(Self);
end;

function TBodyTypesExcelDM.GetExcelTable: TBodyTypesExcelTable;
begin
  Result := CustomExcelTable as TBodyTypesExcelTable;
end;

end.