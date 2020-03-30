unit ExcelDataModule;

interface

uses
  System.SysUtils, System.Classes, Vcl.OleServer, Excel2010,
  System.Generics.Collections, FireDAC.Comp.Client, CustomErrorTable,
  FieldInfoUnit, NotifyEvents, ProgressInfo, CustomExcelTable, ErrorTable,
  Data.DB, Graphics, ProcRefUnit;

{$WARN SYMBOL_PLATFORM OFF}

type
  TExcelDMClass = class of TExcelDM;

  TTotalProgress = class(TObject)
  private
    FPIList: TObjectList<TProgressInfo>;
    FTotalProgress: TProgressInfo;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(ATotalProgress: TTotalProgress);
    procedure Clear;
    procedure UpdateTotalProgress;
    property PIList: TObjectList<TProgressInfo> read FPIList;
    property TotalProgress: TProgressInfo read FTotalProgress;
  end;

  TStringTreeNode = class(TObject)
  private
    FChilds: TList<TStringTreeNode>;
    FID: Integer;
    FParent: TStringTreeNode;
    FValue: string;
  protected
    class var FMaxID: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    function AddChild(const AValue: String): TStringTreeNode;
    class procedure ClearMaxID;
    function FindByID(AID: Integer): TStringTreeNode;
    function IndexOf(AValue: string): Integer;
    property Childs: TList<TStringTreeNode> read FChilds write FChilds;
    property ID: Integer read FID;
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
    FAfterLoadSheet: TNotifyEventsEx;
    FBeforeLoadSheet: TNotifyEventsEx;
    FOnProgress: TNotifyEventsEx;
    FOnTotalProgress: TNotifyEventsEx;
    procedure FreezePanelsInternal;
    function GetCellsColor(ACell: OleVariant): TColor;
    procedure InternalLoadExcelFile(const AFileName: string);
    function IsRangeEmpty(AExcelRange: ExcelRange): Boolean;
    function LoadExcelFileHeaderEx(const AFileName: string): TStringTreeNode;
    function LoadExcelFileHeaderFromActiveSheetEx: TStringTreeNode;
    function LoadExcelFileHeaderInternal: TStringTreeNode;
    // TODO: LoadExcelFile
    // procedure LoadExcelFile(const AFileName: string; ANotifyEventRef:
    // TNotifyEventRef = nil);
    { Private declarations }
  protected
    FLastColIndex: Integer;
    procedure CallOnProcessEvent(API: TProgressInfo);
    function CreateExcelTable: TCustomExcelTable; virtual;
    function GetExcelRange(AStartLine, AStartCol, AEndLine, AEndCol: Integer)
      : ExcelRange;
    function GetIndent: Integer; virtual;
    function HaveHeader(const ARow: Integer): Boolean; virtual;
    procedure TryCreateExcelTable;
    function IsCellEmpty(ACell: OleVariant): Boolean;
    function IsEmptyRow(ARowIndex: Integer): Boolean;
    property Indent: Integer read GetIndent;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ConnectToSheet(ASheetIndex: Integer = -1);
    class procedure FreezePanes(const AFileName: string); static;
    procedure FreezePanesEx(const AFileName: string);
    procedure LoadExcelFile2(const AFileName: string;
      ANotifyEventRef: TNotifyEventRef = nil);
    class function LoadExcelFileHeader(const AFileName: string)
      : TStringTreeNode; static;
    class function LoadExcelFileHeaderFromActiveSheet: TStringTreeNode; static;
    procedure ProcessRange(AExcelRange: ExcelRange); virtual;
    procedure LoadFromActiveSheet;
    procedure Process(AProcRef: TProcRef;
      ANotifyEventRef: TNotifyEventRef); overload;
    property CustomExcelTable: TCustomExcelTable read FCustomExcelTable;
    property AfterLoadSheet: TNotifyEventsEx read FAfterLoadSheet;
    property BeforeLoadSheet: TNotifyEventsEx read FBeforeLoadSheet;
    property OnProgress: TNotifyEventsEx read FOnProgress;
    property OnTotalProgress: TNotifyEventsEx read FOnTotalProgress;
    { Public declarations }
  end;

  TExcelDMEvent = class(TObject)
  private
    FExcelTable: TCustomExcelTable;
    FSheetIndex: Integer;
    FTerminate: Boolean;
    FTotalProgress: TTotalProgress;
  public
    constructor Create(ASheetIndex: Integer; ATotalProgress: TTotalProgress;
      AExcelTable: TCustomExcelTable);
    property ExcelTable: TCustomExcelTable read FExcelTable;
    property SheetIndex: Integer read FSheetIndex;
    property Terminate: Boolean read FTerminate write FTerminate;
    property TotalProgress: TTotalProgress read FTotalProgress;
  end;

implementation

{ %CLASSGROUP 'Vcl.Controls.TControl' }

{$R *.dfm}

uses System.Variants, System.Math, ActiveX, ProjectConst, DBRecordHolder;

constructor TExcelDM.Create(AOwner: TComponent);
begin
  inherited;
  TryCreateExcelTable;

  FOnProgress := TNotifyEventsEx.Create(Self);

  FOnTotalProgress := TNotifyEventsEx.Create(Self);

  FAfterLoadSheet := TNotifyEventsEx.Create(Self);

  FBeforeLoadSheet := TNotifyEventsEx.Create(Self);
end;

destructor TExcelDM.Destroy;
begin
  FreeAndNil(FCustomExcelTable);
  FreeAndNil(FOnProgress);
  FreeAndNil(FOnTotalProgress);
  FreeAndNil(FAfterLoadSheet);
  FreeAndNil(FBeforeLoadSheet);

  inherited;
end;

procedure TExcelDM.CallOnProcessEvent(API: TProgressInfo);
begin
  OnProgress.CallEventHandlers(API)
end;

procedure TExcelDM.ConnectToSheet(ASheetIndex: Integer = -1);
var
  AEWS: ExcelWorksheet;
begin
  if ASheetIndex = -1 then
    AEWS := EWB.ActiveSheet as ExcelWorksheet
  else
    AEWS := EWB.Sheets.Item[ASheetIndex] as ExcelWorksheet;

  EWS.ConnectTo(AEWS);
end;

function TExcelDM.CreateExcelTable: TCustomExcelTable;
begin
  // Assert(False);
  Result := nil;
end;

procedure TExcelDM.FreezePanelsInternal;
var
  AWindowsCount: Integer;
//  ACell: Variant;
  R: ExcelRange;
  W: Excel2010.Window;
begin
//  ACell := EWS.Cells.Item[1, 1];
//  R := EWS.Range['C4', EmptyParam];
//  R.Select;
//  AWindowsCount := EA.Windows.Count;
//  W := EA.Windows.Item[AWindowsCount];
//  W.FreezePanes := True;

  EA.ActiveWindow.SplitRow := 2;
  EA.ActiveWindow.SplitColumn := 2;
  EA.ActiveWindow.FreezePanes := True;
end;

class procedure TExcelDM.FreezePanes(const AFileName: string);
var
  AExcelDM: TExcelDM;
begin
  AExcelDM := TExcelDM.Create(nil);
  try
    AExcelDM.FreezePanesEx(AFileName);
  finally
    FreeAndNil(AExcelDM);
  end;
end;

procedure TExcelDM.FreezePanesEx(const AFileName: string);
begin
  InternalLoadExcelFile(AFileName);
  try
    ConnectToSheet(1);
    EA.Visible[0] := True;
    FreezePanelsInternal;
  finally
//    EA.Quit;
    EA.Disconnect;
  end;
end;

function TExcelDM.GetCellsColor(ACell: OleVariant): TColor;
var
  R: ExcelRange;
begin
  R := EWS.Range[ACell, ACell];
  Result := R.Interior.Color;
end;

// ���������, ��������� �� � ������ ARow ���������
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
    // �������� ���� ����� ������� ������
    AFirstCell := EWS.Cells.Item[1, Indent + 1];
    AColor := GetCellsColor(AFirstCell);
    Result := AColor <> clWhite;

    if Result and (ARow > 1) then
    begin
      // �������� �������� ����������� � ������ �������
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
    // �������� ����� "�������" ��������
    Result := EWS.Range[EWS.Cells.Item[AStartLine, AStartCol],
      EWS.Cells.Item[AEndLine, AEndCol]];
  end
  else
    Result := nil;

end;

function TExcelDM.GetIndent: Integer;
begin
  // ������ �����
  Result := 0;
end;

procedure TExcelDM.TryCreateExcelTable;
begin
  if FCustomExcelTable <> nil then
    Exit;

  FCustomExcelTable := CreateExcelTable;

  if FCustomExcelTable <> nil then
    FLastColIndex := FCustomExcelTable.FieldsInfo.Count
  else
    FLastColIndex := 0;
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

procedure TExcelDM.InternalLoadExcelFile(const AFileName: string);
var
  AWorkbook: ExcelWorkbook;
begin
  EA.Connect;
  AWorkbook := EA.Workbooks.Open(AFileName, EmptyParam, EmptyParam, EmptyParam,
    EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam,
    EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam, 0);

  if AWorkbook = nil then
    raise Exception.CreateFmt('�� ������ ������� ���� %s', [AFileName]);

  if AWorkbook.Sheets.Count = 0 then
    raise Exception.Create(sNoExcelSheets);

  EWB.ConnectTo(AWorkbook);

  // AEWS := AWorkbook.ActiveSheet as ExcelWorksheet;
  // EWS.ConnectTo(AEWS);
end;

function TExcelDM.IsRangeEmpty(AExcelRange: ExcelRange): Boolean;
Var
  Arr: Variant;
  dc: Integer;
  I: Integer;
  j: Integer;
  V: Variant;
begin
  Result := True;
  Arr := AExcelRange.Value2;

  dc := VarArrayDimCount(Arr);

  // ���� �������� ������� �� ������ ��������
  if dc = 0 then
  begin
    Result := VarIsNull(Arr) or (Arr = Unassigned);
    Exit;
  end;

  // ���� �� ���� ������� ���������
  for I := VarArrayLowBound(Arr, 1) to VarArrayHighBound(Arr, 1) do
  begin
    for j := VarArrayLowBound(Arr, 2) to VarArrayHighBound(Arr, 2) do
    begin
      V := VarArrayGet(Arr, [I, j]);
      Result := VarIsNull(V);
      if not Result then
        Exit;
    end;
  end;
end;

procedure TExcelDM.LoadExcelFile2(const AFileName: string;
  ANotifyEventRef: TNotifyEventRef = nil);
var
  AEWS: ExcelWorksheet;
  API: TProgressInfo;
  ARange: ExcelRange;
  AStartLine: Integer;
  ATotalProgress: TTotalProgress;
  ATotalProgressNE: TNotifyEventR;
  e: TExcelDMEvent;
  I: Integer;
  lcid: Integer;
  ne: TNotifyEventR;
  rc: Integer;
begin
  // ������� ����������
  ATotalProgress := TTotalProgress.Create;
  try
    ne := nil;
    lcid := 0;
    InternalLoadExcelFile(AFileName);

    // ������� ������ ���������� �� ���� ������
    for I := 1 to EWB.Sheets.Count do
    begin
      // ����������� � ������
      ConnectToSheet(I);

      ARange := EWS.UsedRange[lcid];
      Assert(ARange <> nil);

      API := TProgressInfo.Create;

      // ���� ���� ���� �� ������
      if not IsRangeEmpty(ARange) then
      begin
        rc := ARange.Rows.Count;
        // ������ ��� �� ������ �������� �� ���������
        AStartLine := 1;
        while (HaveHeader(AStartLine)) do
          Inc(AStartLine);

        API.TotalRecords := rc - AStartLine + 1;
      end;
      ATotalProgress.PIList.Add(API)
    end;

    // ����������� ����-�� �� ����� ��������
    ATotalProgressNE := nil;
    if Assigned(ANotifyEventRef) then
      ATotalProgressNE := TNotifyEventR.Create(OnTotalProgress,
        ANotifyEventRef);

    // ������������� �� ������� OnProgress
    ne := TNotifyEventR.Create(OnProgress,
      procedure(Sender: TObject)
      Var
        API: TProgressInfo;
      begin
        API := Sender as TProgressInfo;
        Assert((I >= 1) and (I <= EWB.Sheets.Count));
        // ��������� �������� �� i-�� �����
        ATotalProgress.PIList[I - 1].Assign(API);
        // ��������� ����� ��������
        ATotalProgress.UpdateTotalProgress;
        // �������� ����, ��� ����� �������� ���������

        // �������� � ���, ��� ���� ���� ��� ���������
        e := TExcelDMEvent.Create(I, ATotalProgress, CustomExcelTable);
        try
          // �������� ���� � �������
          FOnTotalProgress.CallEventHandlers(e);
        finally
          FreeAndNil(e);
        end;
        // FOnTotalProgress.CallEventHandlers(ATotalProgress.TotalProgress);
      end);
    try
      for I := 1 to EWB.Sheets.Count do
      begin
        // ���� ���� ���� ��� ������
        if ATotalProgress.PIList[I - 1].TotalRecords = 0 then
          Continue;

        // ����������� � ������
        ConnectToSheet(I);

        ARange := EWS.UsedRange[lcid];
        Assert(ARange <> nil);
        rc := ARange.Rows.Count;

        // ������ ��� �� ������ �������� �� ���������
        AStartLine := 1;
        while (HaveHeader(AStartLine)) do
          Inc(AStartLine);

        // �������� "�������" ��������
        ARange := GetExcelRange(AStartLine, Indent + 1, rc,
          Indent + FLastColIndex);

        // ������������ �������� ���� �� �� ������
        if ARange <> nil then
        begin
          // �������� � ���, ��� ���������� ������� ����
          e := TExcelDMEvent.Create(I, ATotalProgress, CustomExcelTable);
          try
            // �������� ���� � �������
            FBeforeLoadSheet.CallEventHandlers(e);
            // ���� ��������� ����� ��������� �� ����
            if e.Terminate then
              break;
          finally
            FreeAndNil(e);
          end;

          ProcessRange(ARange);
          {
            // �������� � ���, ��� ���� ���� ��� ���������
            e := TExcelDMEvent.Create(I, ATotalProgress, CustomExcelTable);
            try
            // �������� ���� � �������
            FAfterLoadSheet.CallEventHandlers(e);
            // ���� ��������� ����� ��������� �� ����
            if e.Terminate then
            break;
            finally
            FreeAndNil(e);
            end;
          }
        end
        else
        begin
          ATotalProgress.PIList[I - 1].Clear;
          // ��������� ����� ��������
          ATotalProgress.UpdateTotalProgress;
          // �������� ����, ��� ����� �������� ���������
          // FOnTotalProgress.CallEventHandlers(ATotalProgress.TotalProgress);
        end;

        // �������� � ���, ��� ���� ���� ��� ���������
        e := TExcelDMEvent.Create(I, ATotalProgress, CustomExcelTable);
        try
          // �������� ���� � �������
          FAfterLoadSheet.CallEventHandlers(e);
          // ���� ��������� ����� ��������� �� ����
          if e.Terminate then
            break;
        finally
          FreeAndNil(e);
        end;

      end;
    finally
      // ������������ �� �������
      FreeAndNil(ne);
      // ���������� ����-�� �� �������
      if Assigned(ATotalProgressNE) then
        FreeAndNil(ATotalProgressNE);
    end;

    AEWS := nil;
    EA.Quit;
    EA.Disconnect;
  finally
    FreeAndNil(ATotalProgress);
  end;
end;

class function TExcelDM.LoadExcelFileHeader(const AFileName: string)
  : TStringTreeNode;
var
  AExcelDM: TExcelDM;
begin
  AExcelDM := TExcelDM.Create(nil);
  try
    Result := AExcelDM.LoadExcelFileHeaderEx(AFileName);
  finally
    FreeAndNil(AExcelDM);
  end;
end;

function TExcelDM.LoadExcelFileHeaderEx(const AFileName: string)
  : TStringTreeNode;
begin
  InternalLoadExcelFile(AFileName);
  ConnectToSheet(1);

  Result := LoadExcelFileHeaderInternal;

  EA.Quit;
  EA.Disconnect;
end;

class function TExcelDM.LoadExcelFileHeaderFromActiveSheet: TStringTreeNode;
var
  AExcelDM: TExcelDM;
begin
  AExcelDM := TExcelDM.Create(nil);
  try
    Result := AExcelDM.LoadExcelFileHeaderFromActiveSheetEx;
  finally
    FreeAndNil(AExcelDM);
  end;
end;

function TExcelDM.LoadExcelFileHeaderFromActiveSheetEx: TStringTreeNode;
begin
  EA.ConnectKind := ckRunningInstance;
  try
    EA.Connect;
  except
    raise Exception.Create('�� ������ �������� ���� ��������� Excel');
  end;

  if EA.ActiveWorkbook = nil then
    raise Exception.Create('�� ������ �������� ���� ��������� Excel');

  EWB.ConnectTo(EA.ActiveWorkbook);
  EWS.ConnectTo(EWB.ActiveSheet as _WorkSheet);

  Result := LoadExcelFileHeaderInternal;

  EWS.Disconnect;
  EWB.Disconnect;
  EA.Disconnect;
end;

function TExcelDM.LoadExcelFileHeaderInternal: TStringTreeNode;
var
  ACell: OleVariant;
  ACell2: OleVariant;
  ACellValue: string;
  ACol: Integer;
  AColor: TColor;
  AColor2: TColor;
  ARow: Integer;
  AStringNode: TStringTreeNode;
begin
  // ��������
  TStringTreeNode.ClearMaxID;
  // ������� ������
  Result := TStringTreeNode.Create;
  AStringNode := nil;

  ARow := 1;
  ACol := 1;
  while True do
  begin
    ACell := EWS.Cells.Item[ARow, ACol];
    {
      if ACell.MergeCells then
      begin
      r := ACell.MergeArea.Row;
      c := ACell.MergeArea.Column;
      rc := ACell.MergeArea.Rows.Count;
      cc := ACell.MergeArea.Columns.Count;
      end;
    }
    AColor := GetCellsColor(ACell);
    if (AColor = clWhite) and (not ACell.MergeCells) then
      break
    else
    begin
      ACellValue := ACell.Value;
      // ���� ��� ����� ������, �� ������ ����� ����
      if ACellValue <> '' then
        AStringNode := Result.AddChild(ACellValue);

      // �������� ������ ��� �����
      ACell2 := EWS.Cells.Item[ARow + 1, ACol];
      // �������� � ����
      AColor2 := GetCellsColor(ACell2);

      ACellValue := ACell2.Value;
      // ���� � ��������� ������ �����������
      if (AColor2 <> clWhite) and (ACellValue <> '') then
      begin
        // ������������ ������ ������ ���� ���������
        Assert(AStringNode <> nil);
        AStringNode.AddChild(ACellValue);
      end;
    end;
    Inc(ACol);
  end;

end;

procedure TExcelDM.ProcessRange(AExcelRange: ExcelRange);
var
  AEmptyLines: Integer;
  ARow: Integer;
  Arr: Variant;
  dc: Integer;
  I: Integer;
  API: TProgressInfo;
  R: Integer;
  RH: TRecordHolder;
  V: Variant;
begin
  CustomExcelTable.Errors.EmptyDataSet;
  CustomExcelTable.EmptyDataSet;
  CustomExcelTable.Filtered := False;
  CustomExcelTable.Filter := '';
  AEmptyLines := 0; // ���-�� ������ ����� � ���������

  // �������� ���� �������� � ������
  Arr := AExcelRange.Value2;
  R := 0;
  dc := VarArrayDimCount(Arr);
  // ���� �������� ������� �� ������ ��������
  if dc = 0 then
  begin
    V := Arr;
    Arr := VarArrayCreate([1, 1, 1, 1], varVariant);
    VarArrayPut(Arr, V, [1, 1]);
    // dc := VarArrayDimCount(Arr);
  end;

  // Assert(dc = 2);

  API := TProgressInfo.Create;
  try
    API.TotalRecords := VarArrayHighBound(Arr, 1) -
      VarArrayLowBound(Arr, 1) + 1;
    CallOnProcessEvent(API);
    RH := TRecordHolder.Create();
    try
      // ���� �� ���� ������� ���������
      for I := VarArrayLowBound(Arr, 1) to VarArrayHighBound(Arr, 1) do
      begin
        ARow := AExcelRange.Row + R;

        // ��������� ����� ������ � ������� � excel-�������
        if CustomExcelTable.AppendRow(ARow, Arr, I) then
        begin
          if RH.Count > 0 then
            CustomExcelTable.SetUnionCellValues(RH);

          // ��������� ������ �� ������� ������
          CustomExcelTable.CheckRecord;

          // ���������� ������� �������� ��� �������� �� ���������
          RH.Attach(CustomExcelTable);
          Inc(R);
        end
        else
        begin
          Inc(AEmptyLines);
          if AEmptyLines >= 5 then
          begin
            API.TotalRecords := API.ProcessRecords;
            break;
          end;
        end;

        API.ProcessRecords := R;
        if R mod OnReadProcessEventRecordCount = 0 then
          CallOnProcessEvent(API);
      end;
    finally
      FreeAndNil(RH);
    end;
    CallOnProcessEvent(API);
  finally
    FreeAndNil(API);
  end;
end;

procedure TExcelDM.LoadFromActiveSheet;
var
  ARange: ExcelRange;
  AStartLine: Integer;
  ATotalProgress: TTotalProgress;
  e: TExcelDMEvent;
  lcid: Integer;
  ne: TNotifyEventR;
begin
  lcid := 0;
  EA.ConnectKind := ckRunningInstance;
  try
    EA.Connect;
  except
    raise Exception.Create('�� ������ �������� ���� ��������� Excel');
  end;

  EWB.ConnectTo(EA.ActiveWorkbook);
  EWS.ConnectTo(EWB.ActiveSheet as _WorkSheet);

  // EWS.UsedRange[lcid]

  // �������� ���������� �������
  ARange := EA.Selection[lcid] as ExcelRange;
  Assert(ARange <> nil);

  // ���� � ������ ������ ����������� ��������� ���������
  // ������ ��� �� ������ �������� �� ���������
  AStartLine := ARange.Row;
  while (HaveHeader(AStartLine)) do
    Inc(AStartLine);


  // AStartLine := IfThen(HaveHeader(ARange.Row), ARange.Row + 1, ARange.Row);

  ARange := GetExcelRange(AStartLine, Indent + 1,
    ARange.Row - 1 + ARange.Rows.Count - (AStartLine - ARange.Row),
    Indent + FLastColIndex);

  if ARange <> nil then
  begin
    ATotalProgress := TTotalProgress.Create;

    // ������������� �� ������� OnProgress
    ne := TNotifyEventR.Create(OnProgress,
      procedure(Sender: TObject)
      Var
        API: TProgressInfo;
      begin
        API := Sender as TProgressInfo;
        ATotalProgress.PIList[0].Assign(API);
        ATotalProgress.UpdateTotalProgress;
        FOnTotalProgress.CallEventHandlers(API);
      end);
    try
      ATotalProgress.PIList.Add(TProgressInfo.Create);
      // �������� � ���, ��� ���������� ������� ����
      FBeforeLoadSheet.CallEventHandlers(Self);

      ProcessRange(ARange);
      // �������� � ���, ��� ���� ���� ��� ���������

      e := TExcelDMEvent.Create(1, ATotalProgress, CustomExcelTable);
      try
        // �������� ���� � �������
        FAfterLoadSheet.CallEventHandlers(e);
      finally
        FreeAndNil(e);
      end;

    finally
      FreeAndNil(ne);
      FreeAndNil(ATotalProgress);
    end;
  end;

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

  // ����������� ����-�� �� ������� � ����� ��������� �������� ������
  ne := TNotifyEventR.Create(OnTotalProgress, ANotifyEventRef);
  try
    // �������� �����, �������������� ���� �������
    AProcRef(Self);
  finally
    // ���������� ����-�� �� �������
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
  FieldDefs.Add('ColumnName', ftWideString, 200);
end;

function THeaderInfoTable.GetColumnName: TField;
begin
  Result := FieldByName('ColumnName');
end;

constructor TStringTreeNode.Create;
begin
  inherited;
  FChilds := TObjectList<TStringTreeNode>.Create;
  FID := FMaxID;
end;

destructor TStringTreeNode.Destroy;
begin
  FreeAndNil(FChilds);
  inherited;
end;

function TStringTreeNode.AddChild(const AValue: String): TStringTreeNode;
begin
  // ����������� ������������ �������������
  Inc(FMaxID);
  Result := TStringTreeNode.Create;
  Result.Value := AValue;
  Result.Parent := Self;
  Assert(Childs <> nil);
  Childs.Add(Result);
end;

class procedure TStringTreeNode.ClearMaxID;
begin
  FMaxID := 0;
end;

function TStringTreeNode.FindByID(AID: Integer): TStringTreeNode;
var
  AStringTreeNode: TStringTreeNode;
begin
  Assert(AID > 0);

  Result := Self;

  if FID = AID then
    Exit;

  for AStringTreeNode in Childs do
  begin
    // ������ ���� �������� ���� �������� � ����
    Result := AStringTreeNode.FindByID(AID);
    if Result <> nil then
      Exit;
  end;

  Result := nil;
end;

function TStringTreeNode.IndexOf(AValue: string): Integer;
var
  I: Integer;
begin
  Assert(not AValue.IsEmpty);

  for I := 0 to Childs.Count - 1 do
  begin
    Result := I;
    if String.CompareText(Childs[I].Value, AValue) = 0 then
      Exit;
  end;
  Result := -1;
end;

constructor TTotalProgress.Create;
begin
  inherited;

  FPIList := TObjectList<TProgressInfo>.Create;
  FTotalProgress := TProgressInfo.Create;
end;

destructor TTotalProgress.Destroy;
begin
  FreeAndNil(FPIList);
  FreeAndNil(FTotalProgress);
  inherited;
end;

procedure TTotalProgress.Assign(ATotalProgress: TTotalProgress);
var
  ANewPI: TProgressInfo;
  ASourcePI: TProgressInfo;
begin
  Clear;
  for ASourcePI in ATotalProgress.PIList do
  begin
    ANewPI := TProgressInfo.Create;
    ANewPI.Assign(ASourcePI);
    FPIList.Add(ANewPI);
  end;
  UpdateTotalProgress;
end;

procedure TTotalProgress.Clear;
begin
  FPIList.Clear;
  TotalProgress.Clear;
end;

procedure TTotalProgress.UpdateTotalProgress;
var
  API: TProgressInfo;
begin
  FTotalProgress.Clear;
  for API in FPIList do
  begin
    FTotalProgress.ProcessRecords := FTotalProgress.ProcessRecords +
      API.ProcessRecords;
    FTotalProgress.TotalRecords := FTotalProgress.TotalRecords +
      API.TotalRecords;
  end;
end;

constructor TExcelDMEvent.Create(ASheetIndex: Integer;
ATotalProgress: TTotalProgress; AExcelTable: TCustomExcelTable);
begin
  inherited Create;
  FSheetIndex := ASheetIndex;
  FTotalProgress := ATotalProgress;
  FExcelTable := AExcelTable;
  FTerminate := False;
end;

end.
