unit CustomExcelTable;

interface

uses
  FireDAC.Comp.Client, Data.DB, System.Classes, FieldInfoUnit,
  System.Generics.Collections, ErrorTable, DBRecordHolder, NotifyEvents,
  ProgressInfo, TableWithProgress, ErrorType, RecordCheck;

type
  TCustomExcelTable = class(TTableWithProgress)
  private
    FErrors: TErrorTable;
    FFieldsInfo: TObjectList<TFieldInfo>;
    FSaveAllActionCaption: string;
    FSkipAllActionCaption: string;
    function GetErrorType: TField;
    function GetExcelRow: TField;
    procedure SetSaveAllActionCaption(const Value: string);
    procedure SetSkipAllActionCaption(const Value: string);
  protected
    function ProcessValue(const AFieldName, AValue: string): String; virtual;
    procedure CreateFieldDefs; virtual;
    procedure ProcessErrors(ARecordCheck: TRecordCheck);
    procedure SetFieldsInfo; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AfterConstruction; override;
    function AppendRow(AExcelRow: Integer; var Value: Variant;
      ArrayRow: Integer): Boolean;
    function CheckRecord: Boolean; virtual;
    procedure ExcludeErrors(AErrorTypes: TErrorType);
    procedure SetUnionCellValues(ARecHolder: TRecordHolder);
    function TryEdit: Boolean;
    procedure TryPost;
    property Errors: TErrorTable read FErrors;
    property ErrorType: TField read GetErrorType;
    property ExcelRow: TField read GetExcelRow;
    property FieldsInfo: TObjectList<TFieldInfo> read FFieldsInfo;
    property SaveAllActionCaption: string read FSaveAllActionCaption write
        SetSaveAllActionCaption;
    property SkipAllActionCaption: string read FSkipAllActionCaption write
        SetSkipAllActionCaption;
  end;

implementation

uses System.SysUtils, System.Variants, StrHelper;

constructor TCustomExcelTable.Create(AOwner: TComponent);
begin
  inherited;
  FFieldsInfo := TObjectList<TFieldInfo>.Create;
  FErrors := TErrorTable.Create(Self);
end;

destructor TCustomExcelTable.Destroy;
begin
  FreeAndNil(FFieldsInfo);
  inherited;
end;

procedure TCustomExcelTable.AfterConstruction;
begin
  inherited;

  SetFieldsInfo;
  CreateFieldDefs;
  CreateDataSet;

  Open;
end;

function TCustomExcelTable.AppendRow(AExcelRow: Integer; var Value: Variant;
  ArrayRow: Integer): Boolean;
var
  AFieldInfo: TFieldInfo;
  i: Integer;
  k: Integer;
  S: string;
  V: Variant;
begin
  Assert(VarIsArray(Value));

  Append;
  ExcelRow.AsInteger := AExcelRow;
  i := 0;
  k := 0;
  // Цикл по всем полям из Excel файла
  for AFieldInfo in FieldsInfo do
  begin
    // Получаем очередное значение из вариантного массива
    V := VarArrayGet(Value, [ArrayRow, i + 1]);
    S := VarToStrDef(V, '');
    if not S.IsEmpty then
    begin
      FieldByName(AFieldInfo.FieldName).AsString :=
        ProcessValue(AFieldInfo.FieldName, S);
      Inc(k);
    end;
    Inc(i);
  end;
  Result := k > 0;

  if Result then
    Post
  else
    Cancel;
end;

function TCustomExcelTable.CheckRecord: Boolean;
var
  ACol: Integer;
  AFieldInfo: TFieldInfo;
  ARecordCheck: TRecordCheck;
begin
  Assert(not IsEmpty);
  ACol := 0;
  for AFieldInfo in FFieldsInfo do
  begin
    Inc(ACol);
    if (AFieldInfo.Required) and (FieldByName(AFieldInfo.FieldName).IsNull or
      FieldByName(AFieldInfo.FieldName).AsString.Trim.IsEmpty) then
    begin
      // Сигнализируем о пустом значении
      ARecordCheck.ErrorType := etError;
      ARecordCheck.Row := ExcelRow.AsInteger;
      ARecordCheck.Col := ACol;
      ARecordCheck.ErrorMessage := 'Пустое значение';
      ARecordCheck.Description := AFieldInfo.ErrorMessage;
      ProcessErrors(ARecordCheck);
    end;
  end;
  Result := ErrorType.AsInteger = Integer(etNone);
end;

function TCustomExcelTable.ProcessValue(const AFieldName,
  AValue: string): String;
begin
  // Избавляемся от начальных, конечных и двойных пробелов
  Result := DeleteDouble(AValue.Trim, ' ');
end;

procedure TCustomExcelTable.CreateFieldDefs;
var
  AFieldInfo: TFieldInfo;
begin
  // Сначала создаём все поля из Excel файла
  for AFieldInfo in FFieldsInfo do
  begin
    FieldDefs.Add(AFieldInfo.FieldName, ftWideString, AFieldInfo.Size);
  end;
  FieldDefs.Add('ExcelRow', ftInteger, 0, True); // Обяз. для заполнения
  FieldDefs.Add('ErrorType', ftInteger);
end;

procedure TCustomExcelTable.ExcludeErrors(AErrorTypes: TErrorType);
begin
  Filter := Format('%s < %d', [ErrorType.FieldName, Integer(AErrorTypes)]);
  Filtered := True;
end;

function TCustomExcelTable.GetErrorType: TField;
begin
  Result := FieldByName('ErrorType');
end;

function TCustomExcelTable.GetExcelRow: TField;
begin
  Result := FieldByName('ExcelRow');
end;

procedure TCustomExcelTable.ProcessErrors(ARecordCheck: TRecordCheck);
var
  OK: Boolean;
begin
  if ARecordCheck.ErrorType = etNone then
    Exit;

  // Помечаем, что в этой строке есть ошибка
  OK := TryEdit;
  ErrorType.AsInteger := Integer(ARecordCheck.ErrorType);
  if OK then TryPost;

  // Добавляем запись в таблицу с ошибками
  Errors.Add(ARecordCheck);
end;

procedure TCustomExcelTable.SetUnionCellValues(ARecHolder: TRecordHolder);
var
  AFieldInfo: TFieldInfo;
begin
  // Цикл по всем полям из excel-файла
  for AFieldInfo in FieldsInfo do
  begin
    // Если в Excel файле пустая ячейка и возможно она была объеденина
    if (FieldByName(AFieldInfo.FieldName).IsNull) and (AFieldInfo.IsCellUnion)
    then
    begin
      TryEdit;
      FieldByName(AFieldInfo.FieldName).Value := ARecHolder.Field
        [AFieldInfo.FieldName];
    end;
  end;
  TryPost;
end;

procedure TCustomExcelTable.SetFieldsInfo;
begin
  // TODO -cMM: TCustomExcelTable.SetFieldsInfo default body inserted
end;

procedure TCustomExcelTable.SetSaveAllActionCaption(const Value: string);
begin
  Assert(not Value.IsEmpty);
  FSaveAllActionCaption := Value;
end;

procedure TCustomExcelTable.SetSkipAllActionCaption(const Value: string);
begin
  Assert(not Value.IsEmpty);
  FSkipAllActionCaption := Value;
end;

function TCustomExcelTable.TryEdit: Boolean;
begin
  Assert(Active);
  Result := False;
  if not (State in [dsEdit, dsInsert]) then
  begin
    Edit;
    Result := True;
  end;
end;

procedure TCustomExcelTable.TryPost;
begin
  Assert(Active);
  if (State in [dsEdit, dsInsert]) then
    Post;
end;

end.
