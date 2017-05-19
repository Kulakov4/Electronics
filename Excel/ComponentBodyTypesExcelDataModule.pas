unit ComponentBodyTypesExcelDataModule;

interface

uses
  System.SysUtils, System.Classes, ExcelDataModule, Excel2010, Vcl.OleServer,
  FireDAC.Comp.DataSet, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB,
  FireDAC.Comp.Client, CustomExcelTable, DBRecordHolder, NotifyEvents,
  ProgressInfo, SearchComponentQuery;

{$WARN SYMBOL_PLATFORM OFF}

type
  TComponentBodyTypesExcelTable = class(TCustomExcelTable)
  private
    FBodyTypes: TFDMemTable;
    FBodyTypesDataSet: TFDDataSet;
    FQuerySearchComponent: TQuerySearchComponent;
    function FindBodyType: Variant;
    function GetComponentName: TField;
    function GetIDBodyType: TField;
    function GetIDComponent: TField;
    function GetBodyType: TField;
    procedure SetBodyTypesDataSet(const Value: TFDDataSet);
  protected
    function CheckBodyType: Integer;
    function CheckComponent: Boolean;
    procedure CreateClone;
    procedure CreateFieldDefs; override;
    procedure SetFieldsInfo; override;
  public
    constructor Create(AOwner: TComponent); override;
    function CheckRecord: Boolean; override;
    property BodyTypesDataSet: TFDDataSet read FBodyTypesDataSet
      write SetBodyTypesDataSet;
    property ComponentName: TField read GetComponentName;
    property IDBodyType: TField read GetIDBodyType;
    property IDComponent: TField read GetIDComponent;
    property BodyType: TField read GetBodyType;
  end;

  TComponentBodyTypesExcelDM = class(TExcelDM)
  private
    function GetBodyTypesDataSet: TFDDataSet;
    function GetExcelTable: TComponentBodyTypesExcelTable;
    procedure SetBodyTypesDataSet(const Value: TFDDataSet);
    { Private declarations }
  protected
    function CreateExcelTable: TCustomExcelTable; override;
    procedure ProcessRange2(AExcelRange: ExcelRange);
  public
    procedure ProcessRange(AExcelRange: ExcelRange); override;
    property BodyTypesDataSet: TFDDataSet read GetBodyTypesDataSet
      write SetBodyTypesDataSet;
    property ExcelTable: TComponentBodyTypesExcelTable read GetExcelTable;
    { Public declarations }
  end;

implementation

{ %CLASSGROUP 'Vcl.Controls.TControl' }

{$R *.dfm}

uses System.Variants, System.Math, FieldInfoUnit;

function TComponentBodyTypesExcelDM.CreateExcelTable: TCustomExcelTable;
begin
  Result := TComponentBodyTypesExcelTable.Create(Self);;
end;

function TComponentBodyTypesExcelDM.GetBodyTypesDataSet: TFDDataSet;
begin
  Result := ExcelTable.BodyTypesDataSet;
end;

function TComponentBodyTypesExcelDM.GetExcelTable:
    TComponentBodyTypesExcelTable;
begin
  Result := CustomExcelTable as TComponentBodyTypesExcelTable;
end;

procedure TComponentBodyTypesExcelDM.ProcessRange(AExcelRange: ExcelRange);
var
  ACell: OleVariant;
  AEmptyLines: Integer;
  ARange: ExcelRange;
  ARow: Integer;
  I: Integer;
  ma: ExcelRange;
  PI: TProgressInfo;
  rc: Integer;
  V: Variant;
begin
  CustomExcelTable.Errors.EmptyDataSet;
  CustomExcelTable.EmptyDataSet;
  AEmptyLines := 0;
  I := 0;

  // пока не встретится 5 пустых линий подряд загружать
  rc := AExcelRange.Rows.Count;
  PI := TProgressInfo.Create;
  try
    PI.TotalRecords := rc;
    CallOnProcessEvent(PI);
    while (AEmptyLines <= 5) and (I < rc) do
    begin
      ARow := AExcelRange.Row + I;
      if IsEmptyRow(ARow) then
      begin
        // увеличить количество пустых линий подряд
        Inc(AEmptyLines);
        Continue;
      end;

      // Получаем диапазон объединения во втором столбце
      ACell := EWS.Cells.Item[ARow, Indent + 2];
      V := ACell.Value;
      ma := EWS.Range[ACell, ACell].MergeArea;

      // Возможно в этом диапазоне несколько строк - их будем обрабатывать отдельно
      // если для этого диапазона указан корпус
      if not VarToStrDef(ACell.Value, '').IsEmpty then
      begin
        ARange := GetExcelRange(ma.Row, Indent + 1, ma.Row + ma.Rows.Count -
          1, FLastColIndex);
        ProcessRange2(ARange);
      end;

      Inc(I, ma.Rows.Count);
      PI.ProcessRecords := I;
      CallOnProcessEvent(PI);
    end;
  finally
    FreeAndNil(PI);
  end;
end;

// Обработка объединения
procedure TComponentBodyTypesExcelDM.ProcessRange2(AExcelRange: ExcelRange);
var
  ARow: Integer;
  Arr: Variant;
  dc: Integer;
  I: Integer;
  R: Integer;
  RH: TRecordHolder;
begin
  RH := TRecordHolder.Create();
  try

    Arr := AExcelRange.Value2;
    R := 0;
    dc := VarArrayDimCount(Arr);
    Assert(dc = 2);
    // Цикл по всем строкам диапазона
    for I := VarArrayLowBound(Arr, 1) to VarArrayHighBound(Arr, 1) do
    begin
      ARow := AExcelRange.Row + R;
      // Получаем i-ю строку диапазона
      // Arr2 := VarArrayGet(Arr, [I, 1]);
      // Добавляем новую строку в таблицу с excel-данными
      ExcelTable.AppendRow(ARow, Arr, I);

      if RH.Count > 0 then
        ExcelTable.SetUnionCellValues(RH);

      // Проверяем запись на наличие ошибок
      ExcelTable.CheckRecord;

      // Запоминаем текущие значения как значения по умолчанию
      RH.Attach(ExcelTable);

      Inc(R);
    end;
  finally
    FreeAndNil(RH);
  end;
end;

procedure TComponentBodyTypesExcelDM.SetBodyTypesDataSet
  (const Value: TFDDataSet);
begin
  ExcelTable.BodyTypesDataSet := Value;
end;

constructor TComponentBodyTypesExcelTable.Create(AOwner: TComponent);
begin
  inherited;
  FQuerySearchComponent := TQuerySearchComponent.Create(Self);
end;

function TComponentBodyTypesExcelTable.CheckBodyType: Integer;
var
  V: Variant;
begin
  Result := 0;

  // Ищем корпус с такими-же характеристиками
  V := FindBodyType;

  Edit;


  if not VarIsNull(V) then
  begin
    // Если нашли подходящий корпус
    Result := V;
    IDBodyType.AsInteger := Result;
  end
  else
  begin
    // Запоминаем, что в этой строке ошибка
    if ErrorType.AsInteger = 0 then
      ErrorType.AsInteger := Integer(etWarring);

    Errors.AddWarring(ExcelRow.AsInteger, BodyType.Index + 1,
      Format('%s', [BodyType.AsString]),
      'Такой формфактор корпуса не найден в справочнике корпусов');
  end;

  Post;
end;

function TComponentBodyTypesExcelTable.CheckComponent: Boolean;
begin
  Result := FQuerySearchComponent.Search(ComponentName.AsString) > 0;
{
  DM.fdqFindComponent.Close;
  DM.fdqFindComponent.ParamByName('vValue').AsString :=
    ComponentName.AsString;
  DM.fdqFindComponent.Open;

  Result := DM.fdqFindComponent.RecordCount > 0;
}
  Edit;

  if Result then
    IDComponent.AsInteger := FQuerySearchComponent.PKValue
  else
  begin
   // Запоминаем, что в этой строке ошибка
    ErrorType.AsInteger := Integer(etError);

    Errors.AddError(ExcelRow.AsInteger, ComponentName.Index + 1,
      ComponentName.AsString, 'Компонент с таким именем не найден');
  end;

  Post;
end;

function TComponentBodyTypesExcelTable.CheckRecord: Boolean;
begin
  Result := inherited;
  if Result then
  begin
    // Проверяем что такой компонент существует
    Result := CheckComponent;
    // Проверяем что такой корпус существует
    CheckBodyType;
  end;
end;

procedure TComponentBodyTypesExcelTable.CreateClone;
var
  AFDIndex: TFDIndex;
begin
  FBodyTypes := TFDMemTable.Create(Self);
  // Клонируем курсор
  FBodyTypes.CloneCursor(BodyTypesDataSet);

  // Создаём индекс для поиска
  AFDIndex := FBodyTypes.Indexes.Add;
  AFDIndex.Fields := BodyType.FieldName;
  AFDIndex.Name := 'idxAll';
  AFDIndex.Active := True;
  FBodyTypes.IndexName := AFDIndex.Name;
end;

procedure TComponentBodyTypesExcelTable.CreateFieldDefs;
begin
  inherited;
  // при проверке будем заполнять тип корпуса
  FieldDefs.Add('IDBodyType', ftInteger);
  // При проверке, будем заполнять идентификатор компонента
  FieldDefs.Add('IDComponent', ftInteger);
end;

function TComponentBodyTypesExcelTable.FindBodyType: Variant;
begin
  Result := FBodyTypes.LookupEx(BodyType.FieldName, BodyType.AsString, 'ID');
end;

function TComponentBodyTypesExcelTable.GetComponentName: TField;
begin
  Result := FieldByName(FieldsInfo[0].FieldName);
end;

function TComponentBodyTypesExcelTable.GetIDBodyType: TField;
begin
  Result := FieldByName('IDBodyType');
end;

function TComponentBodyTypesExcelTable.GetIDComponent: TField;
begin
  Result := FieldByName('IDComponent');
end;

function TComponentBodyTypesExcelTable.GetBodyType: TField;
begin
  Result := FieldByName(FieldsInfo[1].FieldName);
end;

procedure TComponentBodyTypesExcelTable.SetBodyTypesDataSet
  (const Value: TFDDataSet);
begin
  if FBodyTypesDataSet <> Value then
  begin
    FBodyTypesDataSet := Value;
    if FBodyTypesDataSet <> nil then
    begin
      CreateClone;
    end;
  end;
end;

procedure TComponentBodyTypesExcelTable.SetFieldsInfo;
begin
  FieldsInfo.Add(TFieldInfo.Create('ComponentName', True,
    'Название компонента не может быть пустым'));
  FieldsInfo.Add(TFieldInfo.Create('BodyType', True,
    'Формфактор корпуса не может быть пустым'));

// Этих полей в Excel файле не будет
//  FieldsInfo.Add(TFieldInfo.Create('OutlineDrawing'));
//  FieldsInfo.Add(TFieldInfo.Create('LandPattern'));
//  FieldsInfo.Add(TFieldInfo.Create('Variation'));
end;

end.
