unit ParametersExcelDataModule;

interface

uses
  System.SysUtils, System.Classes, ExcelDataModule, Excel2010, Vcl.OleServer,
  System.Generics.Collections, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  CustomExcelTable, ParameterKindsQuery, RecordCheck;

{$WARN SYMBOL_PLATFORM OFF}

type
  TParametersExcelTable = class;

  IParametersGroup = interface(IInterface)
    function Check(AParametersExcelTable: TParametersExcelTable): TRecordCheck;
        stdcall;
  end;

  TParametersExcelTable = class(TCustomExcelTable)
  private
    FParametersGroupInt: IParametersGroup;
    function GetCodeLetters: TField;
    function GetDefinition: TField;
    function GetMeasuringUnit: TField;
    function GetParameterKindID: TField;
    function GetParameterType: TField;
    function GetTableName: TField;
    function GetValue: TField;
    function GetValueT: TField;
  protected
    function CheckParameter: Boolean;
    function ProcessValue(const AFieldName, AValue: string): String; override;
    procedure SetFieldsInfo; override;
  public
    constructor Create(AOwner: TComponent); override;
    function CheckRecord: Boolean; override;
    property CodeLetters: TField read GetCodeLetters;
    property Definition: TField read GetDefinition;
    property MeasuringUnit: TField read GetMeasuringUnit;
    property ParameterKindID: TField read GetParameterKindID;
    property ParametersGroupInt: IParametersGroup read FParametersGroupInt write
        FParametersGroupInt;
    property ParameterType: TField read GetParameterType;
    property TableName: TField read GetTableName;
    property Value: TField read GetValue;
    property ValueT: TField read GetValueT;
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

uses System.Variants, System.Math, StrHelper, FieldInfoUnit, ProgressInfo,
  ParameterKindEnum, ErrorType;

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
  // отступ слева зависит от того, есть ли колонка с номером
  Result := IfThen(HaveNumberColumn, 1, 0);
end;

function TParametersExcelDM.HaveHeader(const ARow: Integer): Boolean;
var
  AFirstCell: OleVariant;
  R: ExcelRange;
  S: string;
begin
  Result := inherited;

  // Дополнительно проверяем что в первой строке выделенного диапазона есть №
  if not Result then
  begin
    AFirstCell := EWS.Cells.Item[ARow, 1];
    R := EWS.Range[AFirstCell, AFirstCell];
    S := VarToStrDef(R.Value2, '');
    Result := S.IndexOf('№') >= 0;
  end;
end;

function TParametersExcelDM.HaveNumberColumn: Boolean;
var
  AFirstCell: OleVariant;
  S: string;
begin
  AFirstCell := EWS.Cells.Item[1, 1];
  S := VarToStrDef(EWS.Range[AFirstCell, AFirstCell].Value2, '');
  Result := S.IndexOf('№') >= 0;
end;

constructor TParametersExcelTable.Create(AOwner: TComponent);
begin
  inherited;
end;

function TParametersExcelTable.CheckParameter: Boolean;
var
  rc: TRecordCheck;
begin
  Assert(ParametersGroupInt <> nil);

  rc := ParametersGroupInt.Check(Self);
  // Обрабатываем ошибки
  ProcessErrors(rc);
  Result := rc.ErrorType = etNone;
end;

function TParametersExcelTable.CheckRecord: Boolean;
begin
  Result := inherited;
  if Result then
  begin
    // Проверяем что такой параметр не существует
    Result := CheckParameter;
  end;
end;

function TParametersExcelTable.GetCodeLetters: TField;
begin
  Result := FieldByName('CodeLetters');
end;

function TParametersExcelTable.GetDefinition: TField;
begin
  Result := FieldByName('Definition');
end;

function TParametersExcelTable.GetMeasuringUnit: TField;
begin
  Result := FieldByName('MeasuringUnit');
end;

function TParametersExcelTable.GetParameterKindID: TField;
begin
  Result := FieldByName('ParameterKindID');
end;

function TParametersExcelTable.GetParameterType: TField;
begin
  Result := FieldByName('ParameterType');
end;

function TParametersExcelTable.GetTableName: TField;
begin
  Result := FieldByName('TableName');
end;

function TParametersExcelTable.GetValue: TField;
begin
  Result := FieldByName('Value');
end;

function TParametersExcelTable.GetValueT: TField;
begin
  Result := FieldByName('ValueT');
end;

function TParametersExcelTable.ProcessValue(const AFieldName, AValue: string):
    String;
begin
  // Избавляемся от переносов на новую строку
  // Двойные кавычки могут встречаться !!! Напр. Класс изделия "Green"
  Result := AValue.Replace(#13, ' ', [rfReplaceAll])
    .Replace(#10, ' ', [rfReplaceAll]);

  Result := inherited ProcessValue(AFieldName, Result);
end;

procedure TParametersExcelTable.SetFieldsInfo;
begin
  FieldsInfo.Add(TFieldInfo.Create('Value', True,
    'Наименование параметра не должно быть пустым'));
  FieldsInfo.Add(TFieldInfo.Create('CodeLetters'));
  FieldsInfo.Add(TFieldInfo.Create('MeasuringUnit'));
  FieldsInfo.Add(TFieldInfo.Create('TableName'));
  FieldsInfo.Add(TFieldInfo.Create('ValueT'));
  FieldsInfo.Add(TFieldInfo.Create('Definition'));
  FieldsInfo.Add(TFieldInfo.Create('ParameterType', True,
    'Тип параметра не должен быть пустым'));
  FieldsInfo.Add(TFieldInfo.Create('ParameterKindID', True,
    'Код вида параметра не должен быть пустым'));
end;

end.
