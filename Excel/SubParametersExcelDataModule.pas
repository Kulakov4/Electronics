unit SubParametersExcelDataModule;

interface

uses
  System.SysUtils, System.Classes, ExcelDataModule, Excel2010, Vcl.OleServer,
  CustomExcelTable, Data.DB, FireDAC.Comp.Client, FireDAC.Comp.DataSet;

type
  TSubParametersExcelTable = class(TCustomExcelTable)
  private
    FDMemTable: TFDMemTable;
    FSubParametersDataSet: TFDDataSet;
    function GetName: TField;
    function GetTranslation: TField;
    procedure SetSubParametersDataSet(const Value: TFDDataSet);
  protected
    function CheckSubParameter: Boolean;
    procedure Clone;
    function ProcessValue(const AValue: string): String; override;
    procedure SetFieldsInfo; override;
  public
    constructor Create(AOwner: TComponent); override;
    function CheckRecord: Boolean; override;
    property Name: TField read GetName;
    property SubParametersDataSet: TFDDataSet read FSubParametersDataSet write
        SetSubParametersDataSet;
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
  FieldInfoUnit, System.Variants, StrHelper;

constructor TSubParametersExcelTable.Create(AOwner: TComponent);
begin
  inherited;
  FDMemTable := TFDMemTable.Create(Self);
end;

function TSubParametersExcelTable.CheckSubParameter: Boolean;
var
  V: Variant;
begin
  // Ищем подпараметр с таким-же именем
  V := FDMemTable.LookupEx(Name.FieldName, Name.Value, 'ID');

  Result := VarIsNull(V);

  // Если не нашли
  if not Result then
  begin
    // Запоминаем, что в этой строке предупреждение
    MarkAsError(etWarring);

    Errors.AddWarring(ExcelRow.AsInteger, Name.Index + 1, Name.AsString,
      'Подпараметр с таким наименованием уже существует');
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

procedure TSubParametersExcelTable.Clone;
var
  AFDIndex: TFDIndex;
begin
  // Клонируем курсор
  FDMemTable.CloneCursor(FSubParametersDataSet);
  // Создаём индекс
  AFDIndex := FDMemTable.Indexes.Add;
  AFDIndex.Fields := 'Name';
  AFDIndex.Name := 'idxName';
  AFDIndex.Active := True;
  FDMemTable.IndexName := AFDIndex.Name;
end;

function TSubParametersExcelTable.GetName: TField;
begin
  Result := FieldByName('Name');
end;

function TSubParametersExcelTable.GetTranslation: TField;
begin
  Result := FieldByName('Translation');
end;

function TSubParametersExcelTable.ProcessValue(const AValue: string): String;
begin
  // Избавляемся от двойных пробелов
  Result := DeleteDouble(AValue, ' ');
end;

procedure TSubParametersExcelTable.SetFieldsInfo;
begin
  FieldsInfo.Add(TFieldInfo.Create('Name', True,
    'Наименование подпараметра не должно быть пустым'));
  FieldsInfo.Add(TFieldInfo.Create('Translation'));
end;

procedure TSubParametersExcelTable.SetSubParametersDataSet(const Value:
    TFDDataSet);
begin
  if FSubParametersDataSet <> Value then
  begin
    FSubParametersDataSet := Value;
    if FSubParametersDataSet <> nil then
    begin
      Clone;
    end;
  end;
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
