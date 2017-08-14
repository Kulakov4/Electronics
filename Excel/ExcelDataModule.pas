unit ExcelDataModule;

interface

uses
  System.SysUtils, System.Classes, Vcl.OleServer, Excel2010,
  System.Generics.Collections, FireDAC.Comp.Client, CustomErrorTable,
  FieldInfoUnit, NotifyEvents, ProgressInfo, CustomExcelTable, ErrorTable,
  Data.DB, Graphics, ProcRefUnit;

{$WARN SYMBOL_PLATFORM OFF}

type
  TStringTreeNode = class(TObject)
  private
    FChilds: TList<TStringTreeNode>;
    FParent: TStringTreeNode;
    FValue: string;
  public
    constructor Create;
    destructor Destroy; override;
    function AddChild(const AValue: String): TStringTreeNode;
    property Childs: TList<TStringTreeNode> read FChilds write FChilds;
    property Parent: TStringTreeNode read FParent write FParent;
    property Value: string read FValue write FValue;
  end;

  THeaderInfoTable = class(TFDMemTable)
  private
    function GetColumnName: TField;
  protected
    procedure CreateFieldDefs; virtual;
    property ColumnName: TField read GetColumnName;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TExcelDM = class(TDataModule, IHandling)
    EA: TExcelApplication;
    EWS: TExcelWorksheet;
    EWB: TExcelWorkbook;
  private
    FCustomExcelTable: TCustomExcelTable;
    FOnProgress: TNotifyEventsEx;
    function GetCellsColor(ACell: OleVariant): TColor;
    procedure InternalLoadExcelFile(const AFileName: string);
    { Private declarations }
  protected
    FLastColIndex: Integer;
    procedure CallOnProcessEvent(API: TProgressInfo);
    function CreateExcelTable: TCustomExcelTable; virtual;
    function GetExcelRange(AStartLine, AStartCol, AEndLine, AEndCol: Integer)
      : ExcelRange;
    function GetIndent: Integer; virtual;
    function HaveHeader(const ARow: Integer): Boolean; virtual;
    function IsCellEmpty(ACell: OleVariant): Boolean;
    function IsEmptyRow(ARowIndex: Integer): Boolean;
    property Indent: Integer read GetIndent;
  public
    constructor Create(AOwner: TComponent); override;
    procedure LoadExcelFile(const AFileName: string;
      ANotifyEventRef: TNotifyEventRef = nil);
    procedure LoadExcelFile2(const AFileName: string; ANotifyEventRef:
        TNotifyEventRef = nil);
    function LoadExcelFileHeader(const AFileName: string): TStringTreeNode;
    procedure LoadExcelFileInThread(const AFileName: String);
    procedure ProcessRange(AExcelRange: ExcelRange); virtual;
    procedure LoadFromActiveSheet;
    procedure Process(AProcRef: TProcRef;
      ANotifyEventRef: TNotifyEventRef); overload;
    property CustomExcelTable: TCustomExcelTable read FCustomExcelTable;
    property OnProgress: TNotifyEventsEx read FOnProgress;
    { Public declarations }
  end;

implementation

{ %CLASSGROUP 'Vcl.Controls.TControl' }

{$R *.dfm}

uses System.Variants, System.Math, ActiveX, ProjectConst, DBRecordHolder;

constructor TExcelDM.Create(AOwner: TComponent);
begin
  inherited;

  FCustomExcelTable := CreateExcelTable;

  if FCustomExcelTable <> nil then
    FLastColIndex := FCustomExcelTable.FieldsInfo.Count
  else
    FLastColIndex := 0;

  FOnProgress := TNotifyEventsEx.Create(Self);

end;

procedure TExcelDM.CallOnProcessEvent(API: TProgressInfo);
begin
  OnProgress.CallEventHandlers(API)
end;

function TExcelDM.CreateExcelTable: TCustomExcelTable;
begin
  // Assert(False);
  Result := nil;
end;

function TExcelDM.GetCellsColor(ACell: OleVariant): TColor;
var
  R: ExcelRange;
begin
  R := EWS.Range[ACell, ACell];
  Result := R.Interior.Color;
end;

// Проверяет, находится ли в строке ARow заголовок
function TExcelDM.HaveHeader(const ARow: Integer): Boolean;
var
  ACell: OleVariant;
  AColor: TColor;
  AFirstCell: OleVariant;
  // ALastCell: OleVariant;
  ma: ExcelRange;
  R: Integer;
  rc: Integer;
begin
  ACell := EWS.Cells.Item[ARow, Indent + 1];
  AColor := GetCellsColor(ACell);
  Result := AColor <> clWhite;

  if not Result then
  begin
    // Получаем цвет левой верхней ячейки
    AFirstCell := EWS.Cells.Item[1, Indent + 1];
    AColor := GetCellsColor(AFirstCell);
    Result := AColor <> clWhite;

    if Result and (ARow > 1) then
    begin
      // Получаем диапазон объединения в первом столбце
      ma := EWS.Range[AFirstCell, AFirstCell].MergeArea;
      R := ma.Row;
      rc := ma.Rows.Count;
      Result := (R + rc - 1) >= ARow;
    end;
  end;
end;

function TExcelDM.GetExcelRange(AStartLine, AStartCol, AEndLine,
  AEndCol: Integer): ExcelRange;
begin
  if (AStartLine <= AEndLine) and (AStartCol <= AEndCol) then
  begin
    // Получаем новый "Рабочий" диапазон
    Result := EWS.Range[EWS.Cells.Item[AStartLine, AStartCol],
      EWS.Cells.Item[AEndLine, AEndCol]];
  end
  else
    Result := nil;

end;

function TExcelDM.GetIndent: Integer;
begin
  // отступ слева
  Result := 0;
end;

function TExcelDM.IsCellEmpty(ACell: OleVariant): Boolean;
begin
  Result := VarIsNull(ACell.Value) or VarIsEmpty(ACell.Value);
end;

function TExcelDM.IsEmptyRow(ARowIndex: Integer): Boolean;
Var
  ACell: OleVariant;
  I: Integer;
begin
  Result := True;

  for I := Indent + 1 to Indent + FLastColIndex do
  begin
    ACell := EWS.Cells.Item[ARowIndex, I];
    if not IsCellEmpty(ACell) then
    begin
      Result := False;
      Exit;
    end;
  end;
end;

procedure TExcelDM.LoadExcelFile(const AFileName: string;
ANotifyEventRef: TNotifyEventRef = nil);
var
  AEWS: ExcelWorksheet;
  ARange: ExcelRange;
  AStartLine: Integer;
  lcid: Integer;
  ne: TNotifyEventR;
  rc: Integer;
begin
  ne := nil;
  lcid := 0;
  InternalLoadExcelFile(AFileName);

  ARange := EWS.UsedRange[lcid];
  Assert(ARange <> nil);
  rc := ARange.Rows.Count;

  // Делаем или не делаем смещение на заголовок
  AStartLine := 1;
  while (HaveHeader(AStartLine)) do
    Inc(AStartLine);

  // Получаем "Рабочий" диапазон
  ARange := GetExcelRange(AStartLine, Indent + 1, rc, Indent + FLastColIndex);

  // Обрабатываем диапазон если он не пустой
  if ARange <> nil then
  begin
    // При необходимости подписываем кого-то на событие
    if Assigned(ANotifyEventRef) then
      ne := TNotifyEventR.Create(OnProgress, ANotifyEventRef);
    try
      ProcessRange(ARange);
    finally
      // Отписываем кого-то от события
      FreeAndNil(ne);
    end;
  end;

  AEWS := nil;
  EA.Quit;
  EA.Disconnect;
end;

procedure TExcelDM.InternalLoadExcelFile(const AFileName: string);
var
  AEWS: ExcelWorksheet;
  AWorkbook: ExcelWorkbook;
begin
  EA.Connect;
  AWorkbook := EA.Workbooks.Open(AFileName, EmptyParam, EmptyParam, EmptyParam,
    EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam,
    EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam, 0);

  if AWorkbook = nil then
    raise Exception.CreateFmt('Не удаётся открыть файл %s', [AFileName]);

  if AWorkbook.Sheets.Count = 0 then
    raise Exception.Create(sNoExcelSheets);

  AEWS := AWorkbook.ActiveSheet as ExcelWorksheet;
  EWS.ConnectTo(AEWS);
end;

procedure TExcelDM.LoadExcelFile2(const AFileName: string; ANotifyEventRef:
    TNotifyEventRef = nil);
var
  AEWS: ExcelWorksheet;
  ARange: ExcelRange;
  AStartLine: Integer;
  lcid: Integer;
  ne: TNotifyEventR;
  rc: Integer;
begin
  ne := nil;
  lcid := 0;
  InternalLoadExcelFile(AFileName);

  ARange := EWS.UsedRange[lcid];
  Assert(ARange <> nil);
  rc := ARange.Rows.Count;

  // Делаем или не делаем смещение на заголовок
  AStartLine := 1;
  while (HaveHeader(AStartLine)) do
    Inc(AStartLine);

  // Получаем "Рабочий" диапазон
  ARange := GetExcelRange(AStartLine, Indent + 1, rc, Indent + FLastColIndex);

  // Обрабатываем диапазон если он не пустой
  if ARange <> nil then
  begin
    // При необходимости подписываем кого-то на событие
    if Assigned(ANotifyEventRef) then
      ne := TNotifyEventR.Create(OnProgress, ANotifyEventRef);
    try
      ProcessRange(ARange);
    finally
      // Отписываем кого-то от события
      FreeAndNil(ne);
    end;
  end;

  AEWS := nil;
  EA.Quit;
  EA.Disconnect;
end;

function TExcelDM.LoadExcelFileHeader(const AFileName: string): TStringTreeNode;
var
  ACell: OleVariant;
  ACell2: OleVariant;
  ACol: Integer;
  AColor: TColor;
  AColor2: TColor;
  ARow: Integer;
  AStringNode: TStringTreeNode;
begin
  InternalLoadExcelFile(AFileName);

  // Создали дерево
  Result := TStringTreeNode.Create;
  AStringNode := nil;

  ARow := 1;
  ACol := 1;
  while True do
  begin
    ACell := EWS.Cells.Item[ARow, ACol];
    AColor := GetCellsColor(ACell);
    if AColor = clWhite then
      break
    else
    begin
      // Если это новая ячейка, то создаём новый узел
      if ACell.Value <> '' then
        AStringNode := Result.AddChild(ACell.Value);

      // Получаем ячейку под нашей
      ACell2 := EWS.Cells.Item[ARow + 1, ACol];
      // Получаем её цвет
      AColor2 := GetCellsColor(ACell2);

      // если в заголовке указан подпараметр
      if (AColor2 <> clWhite) and (ACell2.Value <> '') then
      begin
        // Родительская ячейка должна быть заполнена
        Assert(AStringNode <> nil);
        AStringNode.AddChild(ACell2.Value);
      end;
    end;
    Inc(ACol);
  end;

  EA.Quit;
  EA.Disconnect;
end;

procedure TExcelDM.LoadExcelFileInThread(const AFileName: String);
begin
  FThread := TThread.CreateAnonymousThread(
    procedure
    begin
      CoInitialize(nil);
      LoadExcelFile(AFileName);
    end);
  FThread.OnTerminate := DoOnThreadTerminate;
  FThread.Start;
end;

procedure TExcelDM.ProcessRange(AExcelRange: ExcelRange);
var
  AEmptyLines: Integer;
  ARow: Integer;
  Arr: Variant;
  dc: Integer;
  I: Integer;
  PI: TProgressInfo;
  R: Integer;
  RH: TRecordHolder;
  V: Variant;
begin
  CustomExcelTable.Errors.EmptyDataSet;
  CustomExcelTable.EmptyDataSet;
  AEmptyLines := 0; // Кол-во пустых строк в диапазоне

  // Копируем весь диапазон в массив
  Arr := AExcelRange.Value2;
  R := 0;
  dc := VarArrayDimCount(Arr);
  // Если диапазон состоит из одного значения
  if dc = 0 then
  begin
    V := Arr;
    Arr := VarArrayCreate([1, 1, 1, 1], varVariant);
    VarArrayPut(Arr, V, [1, 1]);
    // dc := VarArrayDimCount(Arr);
  end;

  // Assert(dc = 2);

  PI := TProgressInfo.Create;
  try
    PI.TotalRecords := VarArrayHighBound(Arr, 1) - VarArrayLowBound(Arr, 1) + 1;
    CallOnProcessEvent(PI);
    RH := TRecordHolder.Create();
    try
      // Цикл по всем строкам диапазона
      for I := VarArrayLowBound(Arr, 1) to VarArrayHighBound(Arr, 1) do
      begin
        ARow := AExcelRange.Row + R;

        // Добавляем новую строку в таблицу с excel-данными
        if CustomExcelTable.AppendRow(ARow, Arr, I) then
        begin
          if RH.Count > 0 then
            CustomExcelTable.SetUnionCellValues(RH);

          // Проверяем запись на наличие ошибок
          CustomExcelTable.CheckRecord;

          // Запоминаем текущие значения как значения по умолчанию
          RH.Attach(CustomExcelTable);
        end
        else
        begin
          Inc(AEmptyLines);
          if AEmptyLines >= 5 then
          begin
            PI.TotalRecords := PI.ProcessRecords;
            CallOnProcessEvent(PI);
            break;
          end;
        end;
        Inc(R);
        PI.ProcessRecords := R;
        if R mod 100 = 0 then
          CallOnProcessEvent(PI);
      end;
    finally
      FreeAndNil(RH);
    end;
    CallOnProcessEvent(PI);
  finally
    FreeAndNil(PI);
  end;
end;

procedure TExcelDM.LoadFromActiveSheet;
var
  ARange: ExcelRange;
  AStartLine: Integer;
  lcid: Integer;
begin
  lcid := 0;
  EA.ConnectKind := ckRunningInstance;
  try
    EA.Connect;
  except
    raise Exception.Create('Не найден активный лист документа Excel');
  end;

  EWB.ConnectTo(EA.ActiveWorkbook);
  EWS.ConnectTo(EWB.ActiveSheet as _WorkSheet);

  // EWS.UsedRange[lcid]

  // Получаем выделенную область
  ARange := EA.Selection[lcid] as ExcelRange;
  Assert(ARange <> nil);

  // если в первой строке выделенного диапазона заголовок
  AStartLine := IfThen(HaveHeader(ARange.Row), ARange.Row + 1, ARange.Row);
  ARange := GetExcelRange(AStartLine, Indent + 1, ARange.Rows.Count,
    Indent + FLastColIndex);

  if ARange <> nil then
    ProcessRange(ARange);

  EWS.Disconnect;
  EWB.Disconnect;
  EA.Disconnect;
end;

procedure TExcelDM.Process(AProcRef: TProcRef;
ANotifyEventRef: TNotifyEventRef);
var
  ne: TNotifyEventR;
begin
  Assert(Assigned(AProcRef));

  // Подписываем кого-то на событие о прогрессе загрузки данных
  ne := TNotifyEventR.Create(OnProgress, ANotifyEventRef);
  try
    // Вызываем метод, обрабатывающий нашу таблицу
    AProcRef;
  finally
    // Отписываем кого-то от события
    FreeAndNil(ne);
  end;
end;

constructor THeaderInfoTable.Create(AOwner: TComponent);
begin
  inherited;
  CreateFieldDefs;
  CreateDataSet;
  Open;
end;

procedure THeaderInfoTable.CreateFieldDefs;
begin
  FieldDefs.Add('ColumnName', ftString, 200);
end;

function THeaderInfoTable.GetColumnName: TField;
begin
  Result := FieldByName('ColumnName');
end;

constructor TStringTreeNode.Create;
begin
  inherited;
  FChilds := TList<TStringTreeNode>.Create;
end;

destructor TStringTreeNode.Destroy;
begin
  FreeAndNil(FChilds);
  inherited;
end;

function TStringTreeNode.AddChild(const AValue: String): TStringTreeNode;
begin
  Result := TStringTreeNode.Create;
  Result.Value := AValue;
  Result.Parent := Self;
  Assert(Childs <> nil);
  Childs.Add(Result);
end;

end.
