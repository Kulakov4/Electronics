unit ComponentsExcelDataModule;

interface

uses
  System.SysUtils, System.Classes, ExcelDataModule, Excel2010, Vcl.OleServer,
  System.Generics.Collections, FireDAC.Comp.Client, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  CustomExcelTable, SearchCategoryQuery, SearchFamily,
  SearchComponentOrFamilyQuery;

{$WARN SYMBOL_PLATFORM OFF}

type
  TComponentsExcelTable = class(TCustomExcelTable)
  private
    FBadSubGroup: TList<String>;
    FGoodSubGroup: TList<String>;
    FProducer: string;
    FQuerySearchFamily: TQuerySearchFamily;
    FqSearchCategory: TQuerySearchCategory;
    FqSearchComponentOrFamily: TQuerySearchComponentOrFamily;
    function GetFamilyName: TField;
    function GetSubGroup: TField;
    function GetComponentName: TField;
    procedure SetProducer(const Value: string);
  protected
    function CheckComponent: Boolean;
    function CheckSubGroup: Boolean;
    procedure CreateFieldDefs; override;
    procedure SetFieldsInfo; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CheckRecord: Boolean; override;
    property FamilyName: TField read GetFamilyName;
    property SubGroup: TField read GetSubGroup;
    property ComponentName: TField read GetComponentName;
    property Producer: string read FProducer write SetProducer;
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

uses System.Variants, FieldInfoUnit, ProgressInfo, DBRecordHolder, ErrorType,
  RecordCheck;

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

  // ���� �� ���������� 5 ������ ����� ������ ���������
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
        // ��������� ���������� ������ ����� ������
        Inc(AEmptyLines);
        Continue;
      end;

      // �������� �������� ����������� � ������ �������
      ACell := EWS.Cells.Item[ARow, Indent + 1];
      V := ACell.Value;
      ma := EWS.Range[ACell, ACell].MergeArea;

      // �������� � ���� ��������� ��������� ����� - �� ����� ������������ ��������
      // ���� ��� ����� ��������� ������ ������
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

// ��������� �����������
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
    // �������� ���� �������� � ���������� ������
    Arr := AExcelRange.Value2;
    R := 0;
    dc := VarArrayDimCount(Arr);
    Assert(dc = 2);
    low := VarArrayLowBound(Arr, 1);
    hight := VarArrayHighBound(Arr, 1);

    // ���� �� ���� ������� ���������
    for I := low to hight do
    begin
      ARow := AExcelRange.Row + R;
      // ��������� ����� ������ � ������� � excel-�������
      ExcelTable.AppendRow(ARow, Arr, I);

      if RH.Count > 0 then
        ExcelTable.SetUnionCellValues(RH);

      // ��������� ������ �� ������� ������
      ExcelTable.CheckRecord;

      // ���������� ������� �������� ��� �������� �� ���������
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
  FqSearchComponentOrFamily := TQuerySearchComponentOrFamily.Create(Self);
  FGoodSubGroup := TList<String>.Create;
  FBadSubGroup := TList<String>.Create;
end;

destructor TComponentsExcelTable.Destroy;
begin
  FreeAndNil(FGoodSubGroup);
  FreeAndNil(FBadSubGroup);
  inherited;
end;

function TComponentsExcelTable.CheckComponent: Boolean;
var
  ARecordCheck: TRecordCheck;
begin
  Assert(not Producer.IsEmpty);

  // ���� ����� ��������� � ������������� � ����
  Result := FqSearchComponentOrFamily.SearchComponentWithProducer
    (ComponentName.AsString, Producer) = 0;

  // ���� ����� ����� ��������� � ����� ��������������
  if not Result then
  begin
    // ��� ��������� ��� ���� � ����, � ��������� � ��������� � ������ ������
    if FqSearchComponentOrFamily.W.FamilyValue.F.AsString <> FamilyName.AsString
    then
    begin
      ARecordCheck.ErrorType := etError;
      ARecordCheck.Row := ExcelRow.AsInteger;
      ARecordCheck.Col := FamilyName.Index + 1;
      ARecordCheck.ErrorMessage := FamilyName.AsString;
      ARecordCheck.Description :=
        Format('��������� %s �� ����� ������������ ���� ����������: %s � %s',
        [ComponentName.AsString,
        FqSearchComponentOrFamily.W.FamilyValue.F.AsString,
        FamilyName.AsString]);

      ProcessErrors(ARecordCheck);
    end
    else
    begin

      // ��� ��������� � ��� ��������� ��� ���� � ����
      ARecordCheck.ErrorType := etWarring;
      ARecordCheck.Row := ExcelRow.AsInteger;
      ARecordCheck.Col := FamilyName.Index + 1;
      ARecordCheck.ErrorMessage := ComponentName.AsString;
      ARecordCheck.Description :=
        Format('��������� %s � ��� ��������� %s ��� ������� � ��',
        [ComponentName.AsString, FamilyName.AsString]);

      ProcessErrors(ARecordCheck);
    end;

    // ���������� ��� ���������
{
    Edit;
    IDFamily.Value := FQuerySearchFamily.W.PK.Value;
    Post;
}
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
  ARecordCheck: TRecordCheck;
  IsBad: Boolean;
  IsGood: Boolean;
  s: String;
  Splitted: TArray<String>;
  ss: string;
  x: Integer;
begin
  Result := True;

  ARecordCheck.ErrorType := etError;
  ARecordCheck.Row := ExcelRow.AsInteger;
  ARecordCheck.Col := SubGroup.Index + 1;

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
        // ���� ��������� ���������� �� �������� ��������������
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
        ARecordCheck.ErrorMessage := s;
        ARecordCheck.Description :=
          '�� ������� ��������� � ����� ���������������';
        ProcessErrors(ARecordCheck);
        Result := False;
      end;
    end
    else
    begin
      ARecordCheck.ErrorMessage := s;
      ARecordCheck.Description := '�������� ������������� ���������';
      ProcessErrors(ARecordCheck);
      Result := False;
    end;

  end;
end;

procedure TComponentsExcelTable.CreateFieldDefs;
begin
  inherited;
  // ��� �������� ����� ��������� ��� ������������� ����������
  FieldDefs.Add('IDFamily', ftInteger);
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
    '������������ ���������� �� ������ ���� ������'));
  FieldsInfo.Add(TFieldInfo.Create('SubGroup', False, '', True));
end;

procedure TComponentsExcelTable.SetProducer(const Value: string);
begin
  Assert(not Value.IsEmpty);
  FProducer := Value;
end;

end.
