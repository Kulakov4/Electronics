unit ParametersExcelDataModule;

interface

uses
  System.SysUtils, System.Classes, ExcelDataModule, Excel2010, Vcl.OleServer,
  System.Generics.Collections, FireDAC.Stan.Intf,FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  CustomExcelTable;

{$WARN SYMBOL_PLATFORM OFF}

type
  TParametersExcelTable = class(TCustomExcelTable)
  private
    FDMemTable: TFDMemTable;
    FParametersDataSet: TFDDataSet;
    function GetParameterType: TField;
    function GetValue: TField;
    procedure SetParametersDataSet(const Value: TFDDataSet);
  protected
    function CheckParameter: Boolean;
    procedure Clone;
    function ProcessValue(const AValue: string): String; override;
    procedure SetFieldsInfo; override;
  public
    constructor Create(AOwner: TComponent); override;
    function CheckRecord: Boolean; override;
    property ParametersDataSet: TFDDataSet read FParametersDataSet write
        SetParametersDataSet;
    property ParameterType: TField read GetParameterType;
    property Value: TField read GetValue;
  end;

  TParametersExcelDM = class(TExcelDM)
  private
    function GetExcelTable: TParametersExcelTable;
    { Private declarations }
  protected
    function CreateExcelTable: TCustomExcelTable; override;
    function GetIndent: Integer; override;
    function HaveHeader(const ARow: Integer): Boolean; override;
  public
    function HaveNumberColumn: Boolean;
    property ExcelTable: TParametersExcelTable read GetExcelTable;
    { Public declarations }
  end;


implementation

{ %CLASSGROUP 'Vcl.Controls.TControl' }

{$R *.dfm}

uses System.Variants, System.Math, StrHelper, FieldInfoUnit, ProgressInfo;

function TParametersExcelDM.CreateExcelTable: TCustomExcelTable;
begin
  Result := TParametersExcelTable.Create(Self);
end;

function TParametersExcelDM.GetExcelTable: TParametersExcelTable;
begin
  Result := CustomExcelTable as TParametersExcelTable;
end;

function TParametersExcelDM.GetIndent: Integer;
begin
  // ������ ����� ������� �� ����, ���� �� ������� � �������
  Result := IfThen( HaveNumberColumn, 1, 0 );
end;

function TParametersExcelDM.HaveHeader(const ARow: Integer): Boolean;
var
  AFirstCell: OleVariant;
  R: ExcelRange;
  S: string;
begin
  Result := inherited;

  // ������������� ��������� ��� � ������ ������ ����������� ��������� ���� �
  if not Result then
  begin
    AFirstCell := EWS.Cells.Item[ARow, 1];
    R := EWS.Range[AFirstCell, AFirstCell];
    S := VarToStrDef(R.Value2, '');
    Result := S.IndexOf('�') >= 0;
  end;
end;

function TParametersExcelDM.HaveNumberColumn: Boolean;
var
  AFirstCell: OleVariant;
  S: string;
begin
  AFirstCell := EWS.Cells.Item[1, 1];
  S := VarToStrDef( EWS.Range[AFirstCell, AFirstCell].Value2, '');
  Result := S.IndexOf('�') >= 0;
end;

constructor TParametersExcelTable.Create(AOwner: TComponent);
begin
  inherited;
  FDMemTable := TFDMemTable.Create(Self);
end;

function TParametersExcelTable.CheckParameter: Boolean;
var
  V: Variant;
begin
  // ���� �������� � �����-�� ������
  V := FDMemTable.LookupEx(Value.FieldName, Value.Value, 'ID');

  Result := VarIsNull(V);

  // ���� �� �����
  if not Result then
  begin
    // ����������, ��� � ���� ������ ��������������
    MarkAsError(etWarring);

    Errors.AddWarring(ExcelRow.AsInteger, Value.Index + 1,
      Value.AsString, '�������� � ����� ������������� ��� ����������');
  end;
end;

function TParametersExcelTable.CheckRecord: Boolean;
begin
  Result := inherited;
  if Result then
  begin
    // ��������� ��� ����� ��������� ����������
    Result := CheckParameter;
  end;
end;

procedure TParametersExcelTable.Clone;
var
  AFDIndex: TFDIndex;
begin
  // ��������� ������
  FDMemTable.CloneCursor(ParametersDataSet);
  // ������ ������
  AFDIndex := FDMemTable.Indexes.Add;
  AFDIndex.Fields := 'Value';
  AFDIndex.Name := 'idxValue';
  AFDIndex.Active := True;
  FDMemTable.IndexName := AFDIndex.Name;
end;

function TParametersExcelTable.GetParameterType: TField;
begin
  Result := FieldByName('ParameterType');
end;

function TParametersExcelTable.GetValue: TField;
begin
  Result := FieldByName('Value');
end;

function TParametersExcelTable.ProcessValue(const AValue: string): String;
begin
  // ����������� �� ��������� �� ����� ������
  // ������� ������� ����� ����������� !!! ����. ����� ������� "Green"
  Result := AValue.Replace(#13, ' ', [rfReplaceAll]).Replace(#10, ' ', [rfReplaceAll]);
  // ����������� �� ������� ��������
  Result := DeleteDouble(Result, ' ');
end;

procedure TParametersExcelTable.SetFieldsInfo;
begin
  FieldsInfo.Add(TFieldInfo.Create('Value', True,
    '������������ ��������� �� ������ ���� ������'));
  FieldsInfo.Add(TFieldInfo.Create('CodeLetters'));
  FieldsInfo.Add(TFieldInfo.Create('MeasuringUnit'));
  FieldsInfo.Add(TFieldInfo.Create('TableName'));
  FieldsInfo.Add(TFieldInfo.Create('ValueT'));
  FieldsInfo.Add(TFieldInfo.Create('Definition'));
  FieldsInfo.Add(TFieldInfo.Create('ParameterType', True,
    '��� ��������� �� ������ ���� ������'));

end;

procedure TParametersExcelTable.SetParametersDataSet(const Value: TFDDataSet);
begin
  if FParametersDataSet <> Value then
  begin
    FParametersDataSet := Value;
    if FParametersDataSet <> nil then
    begin
      Clone;
    end;
  end;
end;

end.
