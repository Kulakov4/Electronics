unit SubParametersExcelDataModule;

interface

uses
  System.SysUtils, System.Classes, ExcelDataModule, Excel2010, Vcl.OleServer,
  CustomExcelTable, Data.DB, FireDAC.Comp.Client, FireDAC.Comp.DataSet,
  SubParametersInterface;

type
  TSubParametersExcelTable = class(TCustomExcelTable)
  private
    FSubParametersInt: ISubParameters;
    function GetName: TField;
    function GetTranslation: TField;
  protected
    function CheckSubParameter: Boolean;
    procedure SetFieldsInfo; override;
  public
    constructor Create(AOwner: TComponent); override;
    function CheckRecord: Boolean; override;
    property Name: TField read GetName;
    property SubParametersInt: ISubParameters read FSubParametersInt write
        FSubParametersInt;
    property Translation: TField read GetTranslation;
  end;

  TSubParametersExcelDM = class(TExcelDM)
  private
    function GetExcelTable: TSubParametersExcelTable;
    { Private declarations }
  protected
    function CreateExcelTable: TCustomExcelTable; override;
  public
    property ExcelTable: TSubParametersExcelTable read GetExcelTable;
    { Public declarations }
  end;

implementation

uses
  FieldInfoUnit, System.Variants, StrHelper, ErrorType, RecordCheck;

constructor TSubParametersExcelTable.Create(AOwner: TComponent);
begin
  inherited;
end;

function TSubParametersExcelTable.CheckSubParameter: Boolean;
var
  ARecordCheck: TRecordCheck;
begin
  Assert(SubParametersInt <> nil);
  Result := SubParametersInt.GetSubParameterID(Name.Value) = 0;

  // Если не нашли
  if not Result then
  begin
    // Запоминаем, что в этой строке предупреждение
    ARecordCheck.ErrorType := etError;
    ARecordCheck.Row := ExcelRow.AsInteger;
    ARecordCheck.Col := Name.Index + 1;
    ARecordCheck.ErrorMessage := Name.AsString;
    ARecordCheck.Description := 'Подпараметр с таким наименованием уже существует.';
    ProcessErrors(ARecordCheck);
  end;
end;

function TSubParametersExcelTable.CheckRecord: Boolean;
begin
  Result := inherited;
  if Result then
  begin
    // Проверяем что такой компонент существует
    Result := CheckSubParameter;
  end;
end;

function TSubParametersExcelTable.GetName: TField;
begin
  Result := FieldByName('Name');
end;

function TSubParametersExcelTable.GetTranslation: TField;
begin
  Result := FieldByName('Translation');
end;

procedure TSubParametersExcelTable.SetFieldsInfo;
begin
  FieldsInfo.Add(TFieldInfo.Create('Name', True,
    'Наименование подпараметра не должно быть пустым'));
  FieldsInfo.Add(TFieldInfo.Create('Translation'));
end;

function TSubParametersExcelDM.CreateExcelTable: TCustomExcelTable;
begin
  Result := TSubParametersExcelTable.Create(Self);
end;

function TSubParametersExcelDM.GetExcelTable: TSubParametersExcelTable;
begin
  // TODO -cMM: TSubParametersExcelDM.GetExcelTable default body inserted
  Result := CustomExcelTable as TSubParametersExcelTable;
end;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
