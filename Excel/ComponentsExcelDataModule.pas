unit ComponentsExcelDataModule;

interface

uses
  System.SysUtils, System.Classes, ExcelDataModule, Excel2010, Vcl.OleServer,
  System.Generics.Collections, FireDAC.Comp.Client, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, CustomExcelTable, SearchProductCategoryByExternalID,
  SearchMainComponent;

{$WARN SYMBOL_PLATFORM OFF}

type
  TComponentsExcelTable = class(TCustomExcelTable)
  private
    FBadSubGroup: TList<String>;
    FGoodSubGroup: TList<String>;
    FQuerySearchMainComponent: TQuerySearchMainComponent;
    FQuerySearchProductCategory: TQuerySearchProductCategoryByExternalID;
    function GetIDMainComponent: TField;
    function GetMainValue: TField;
    function GetSubGroup: TField;
    function GetValue: TField;
  protected
    function CheckComponent: Boolean;
    function CheckSubGroup: Boolean;
    procedure CreateFieldDefs; override;
    procedure SetFieldsInfo; override;
  public
    constructor Create(AOwner: TComponent); override;
    function CheckRecord: Boolean; override;
    property IDMainComponent: TField read GetIDMainComponent;
    property MainValue: TField read GetMainValue;
    property SubGroup: TField read GetSubGroup;
    property Value: TField read GetValue;
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
        ExcelTable.SetDefaultValues(RH);

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
  FQuerySearchProductCategory := TQuerySearchProductCategoryByExternalID.Create(Self);
  FQuerySearchMainComponent := TQuerySearchMainComponent.Create(Self);
  FGoodSubGroup := TList<String>.Create;
  FBadSubGroup := TList<String>.Create;
end;

function TComponentsExcelTable.CheckComponent: Boolean;
begin
  Result := FQuerySearchMainComponent.Search(MainValue.AsString) = 0;

  // Если нашли такой компонент
  if not Result then
  begin
    // Запоминаем код родительского компонента
    Edit;
    IDMainComponent.AsInteger := FQuerySearchMainComponent.PKValue;
    Post;

    MarkAsError(etWarring);

    Errors.AddWarring(ExcelRow.AsInteger, MainValue.Index + 1,
      MainValue.AsString,
      Format('Компонент с таким именем уже занесён в БД в категорию %s',
      [FQuerySearchMainComponent.SubGroup.AsString]));
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
        {
          DM.fdqFindProductCategory.Close;
          DM.fdqFindProductCategory.ParamByName('vExternalId').AsString := s;
          DM.fdqFindProductCategory.Open;

          Assert(DM.fdqFindProductCategory.RecordCount <= 1);

          IsGood := DM.fdqFindProductCategory.RecordCount = 1;
        }
        IsGood := FQuerySearchProductCategory.Search(s) = 1;
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
  FieldDefs.Add('IDMainComponent', ftInteger);
end;

function TComponentsExcelTable.GetIDMainComponent: TField;
begin
  Result := FieldByName('IDMainComponent');
end;

function TComponentsExcelTable.GetMainValue: TField;
begin
  Result := FieldByName('MainValue');
end;

function TComponentsExcelTable.GetSubGroup: TField;
begin
  Result := FieldByName('SubGroup');
end;

function TComponentsExcelTable.GetValue: TField;
begin
  Result := FieldByName('Value');
end;

procedure TComponentsExcelTable.SetFieldsInfo;
begin
  FieldsInfo.Add(TFieldInfo.Create('MainValue'));
  FieldsInfo.Add(TFieldInfo.Create('Value', True,
    'Дочернее наименование не должно быть пустым'));
  FieldsInfo.Add(TFieldInfo.Create('SubGroup'));
end;

end.
