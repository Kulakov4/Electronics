unit ComponentsExcelDataModule;

interface

uses
  System.SysUtils, System.Classes, ExcelDataModule, Excel2010, Vcl.OleServer,
  System.Generics.Collections, FireDAC.Comp.Client, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  CustomExcelTable, SearchCategoryQuery, SearchFamily;

{$WARN SYMBOL_PLATFORM OFF}

type
  TComponentsExcelTable = class(TCustomExcelTable)
  private
    FBadSubGroup: TList<String>;
    FGoodSubGroup: TList<String>;
    FQuerySearchFamily: TQuerySearchFamily;
    FqSearchCategory: TQuerySearchCategory;
    function GetIDFamily: TField;
    function GetFamilyName: TField;
    function GetSubGroup: TField;
    function GetComponentName: TField;
  protected
    function CheckComponent: Boolean;
    function CheckSubGroup: Boolean;
    procedure CreateFieldDefs; override;
    procedure SetFieldsInfo; override;
  public
    constructor Create(AOwner: TComponent); override;
    function CheckRecord: Boolean; override;
    property IDFamily: TField read GetIDFamily;
    property FamilyName: TField read GetFamilyName;
    property SubGroup: TField read GetSubGroup;
    property ComponentName: TField read GetComponentName;
  end;

  TComponentsExcelDM = class(TExcelDM)
  private
    function GetExcelTable: TComponentsExcelTable;
    { Private declarations }
  protected
    function CreateExcelTable: TCustomExcelTable; override;
    procedure ProcessRange2(AExcelRange: ExcelRange);
    // TODO: ProcessContent
    // procedure ProcessContent; override;
  public
    procedure ProcessRange(AExcelRange: ExcelRange); override;
    property ExcelTable: TComponentsExcelTable read GetExcelTable;
    // TODO: ProcessRange0
    // procedure ProcessRange0(AExcelRange: ExcelRange);
    { Public declarations }
  end;

implementation

{ %CLASSGROUP 'Vcl.Controls.TControl' }

{$R *.dfm}

uses System.Variants, FieldInfoUnit, ProgressInfo, DBRecordHolder;

function TComponentsExcelDM.CreateExcelTable: TCustomExcelTable;
begin
  Result := TComponentsExcelTable.Create(Self);
end;

function TComponentsExcelDM.GetExcelTable: TComponentsExcelTable;
begin
  Result := CustomExcelTable as TComponentsExcelTable;
end;

procedure TComponentsExcelDM.ProcessRange(AExcelRange: ExcelRange);
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
  CustomExcelTable.Filtered := False;
  CustomExcelTable.Filter := '';
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

      // Получаем диапазон объединения в первом столбце
      ACell := EWS.Cells.Item[ARow, Indent + 1];
      V := ACell.Value;
      ma := EWS.Range[ACell, ACell].MergeArea;

      // Возможно в этом диапазоне несколько строк - их будем обрабатывать отдельно
      // если для этого диапазона указан корпус
      if not VarToStrDef(ACell.Value, '').IsEmpty then
      begin
        ARange := GetExcelRange(ma.Row, Indent + 1, ma.Row + ma.Rows.Count - 1,
          Indent + FLastColIndex);
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
procedure TComponentsExcelDM.ProcessRange2(AExcelRange: ExcelRange);
var
  ARow: Integer;
  Arr: Variant;
  dc: Integer;
  hight: Integer;
  I: Integer;
  low: Integer;
  R: Integer;
  RH: TRecordHolder;
begin
  RH := TRecordHolder.Create();
  try
    // Копируем весь диапазон в вариантный массив
    Arr := AExcelRange.Value2;
    R := 0;
    dc := VarArrayDimCount(Arr);
    Assert(dc = 2);
    low := VarArrayLowBound(Arr, 1);
    hight := VarArrayHighBound(Arr, 1);

    // Цикл по всем строкам диапазона
    for I := low to hight do
    begin
      ARow := AExcelRange.Row + R;
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

constructor TComponentsExcelTable.Create(AOwner: TComponent);
begin
  inherited;
  FqSearchCategory := TQuerySearchCategory.Create(Self);
  FQuerySearchFamily := TQuerySearchFamily.Create(Self);
  FGoodSubGroup := TList<String>.Create;
  FBadSubGroup := TList<String>.Create;
end;

function TComponentsExcelTable.CheckComponent: Boolean;
begin
  Result := FQuerySearchFamily.SearchByValueSimple(FamilyName.AsString) = 0;

  // Если нашли такой компонент
  if not Result then
  begin
    // Запоминаем код родительского компонента
    Edit;
    IDFamily.Value := FQuerySearchFamily.PK.Value;
    Post;

    MarkAsError(etWarring);

    Errors.AddWarring(ExcelRow.AsInteger, FamilyName.Index + 1,
      FamilyName.AsString,
      Format('Компонент с таким именем уже занесён в БД в категорию %s',
      [FQuerySearchFamily.SubGroup.AsString]));
  end;
end;

function TComponentsExcelTable.CheckRecord: Boolean;
begin
  Result := inherited;
  if Result then
  begin
    Result := CheckSubGroup;
    CheckComponent;
  end;
end;

function TComponentsExcelTable.CheckSubGroup: Boolean;
var
  IsBad: Boolean;
  IsGood: Boolean;
  s: String;
  Splitted: TArray<String>;
  ss: string;
  x: Integer;
begin
  Result := True;
  Splitted := SubGroup.AsString.Split([',']);

  for ss in Splitted do
  begin
    s := ss.Trim;
    x := StrToIntDef(s, -1);
    if x <> -1 then
    begin
      IsBad := (FBadSubGroup.Indexof(s) >= 0);
      IsGood := (FGoodSubGroup.Indexof(s) >= 0);

      if (not IsGood) and (not IsBad) then
      begin
        // Ищем категорию компонента по внешнему идентификатору
        IsGood := FqSearchCategory.SearchByExternalID(s) = 1;
        if IsGood then
        begin
          FGoodSubGroup.Add(s);
        end
        else
        begin
          IsBad := True;
          FBadSubGroup.Add(s);
        end;
      end;

      if IsBad then
      begin
        MarkAsError(etError);

        Errors.AddError(ExcelRow.AsInteger, SubGroup.Index + 1, s,
          'не найдена категория с таким идентификатором');
        Result := False;
      end;
    end
    else
    begin
      MarkAsError(etError);

      Errors.AddError(ExcelRow.AsInteger, SubGroup.Index + 1, s,
        'неверный идентификатор категории');
      Result := False;
    end;

  end;
end;

procedure TComponentsExcelTable.CreateFieldDefs;
begin
  inherited;
  // при проверке будем заполнять код родительского компонента
  FieldDefs.Add('IDFamily', ftInteger);
end;

function TComponentsExcelTable.GetIDFamily: TField;
begin
  Result := FieldByName('IDFamily');
end;

function TComponentsExcelTable.GetFamilyName: TField;
begin
  Result := FieldByName('FamilyName');
end;

function TComponentsExcelTable.GetSubGroup: TField;
begin
  Result := FieldByName('SubGroup');
end;

function TComponentsExcelTable.GetComponentName: TField;
begin
  Result := FieldByName('ComponentName');
end;

procedure TComponentsExcelTable.SetFieldsInfo;
begin
  FieldsInfo.Add(TFieldInfo.Create('FamilyName', False, '', True));
  FieldsInfo.Add(TFieldInfo.Create('ComponentName', True,
    'Дочернее наименование не должно быть пустым'));
  FieldsInfo.Add(TFieldInfo.Create('SubGroup', False, '', True));
end;

end.
