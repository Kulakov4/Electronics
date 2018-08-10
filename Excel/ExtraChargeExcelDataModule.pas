unit ExtraChargeExcelDataModule;

interface

uses
  System.SysUtils, System.Classes, ExcelDataModule, Excel2010, Vcl.OleServer,
  CustomExcelTable, Data.DB, FireDAC.Comp.Client, FireDAC.Comp.DataSet,
  ExtraChargeSimpleQuery, ExtraChargeInterface;

type
  TExtraChargeExcelTable = class(TCustomExcelTable)
  private
    FExtraChargeInt: IExtraCharge;
    FqExtraChargeSimple: TQueryExtraChargeSimple;
    function GetqExtraChargeSimple: TQueryExtraChargeSimple;
    function GetRange: TField;
    function GetWholeSale: TField;
  protected
    function CheckRange: Boolean;
    procedure SetFieldsInfo; override;
    property qExtraChargeSimple: TQueryExtraChargeSimple read GetqExtraChargeSimple;
  public
    constructor Create(AOwner: TComponent); override;
    function CheckRecord: Boolean; override;
    property ExtraChargeInt: IExtraCharge read FExtraChargeInt write
        FExtraChargeInt;
    property Range: TField read GetRange;
    property WholeSale: TField read GetWholeSale;
  end;

  TExtraChargeExcelDM = class(TExcelDM)
  private
    function GetExcelTable: TExtraChargeExcelTable;
    { Private declarations }
  protected
    function CreateExcelTable: TCustomExcelTable; override;
  public
    property ExcelTable: TExtraChargeExcelTable read GetExcelTable;
    { Public declarations }
  end;

implementation

uses
  FieldInfoUnit, System.RegularExpressions, System.Variants, ErrorType;

constructor TExtraChargeExcelTable.Create(AOwner: TComponent);
begin
  inherited;
end;

function TExtraChargeExcelTable.CheckRange: Boolean;
var
  AErrorMessage: string;
  AHigh: Integer;
  ALow: Integer;
begin
  Assert(ExtraChargeInt <> nil);

  // ���� ����� �����-�� ��������
  Result := not ExtraChargeInt.HaveDuplicate(Range.Value);

  // ���� ����� �������� ���������
  if not Result then
  begin
    MarkAsError(etWarring);

    Errors.AddWarring(ExcelRow.AsInteger, Range.Index + 1, Range.AsString,
      '����� �������� ��� ����������');
    Exit;
  end;

  AErrorMessage := qExtraChargeSimple.CheckBounds(0, Range.AsString, ALow, AHigh );
  Result := AErrorMessage.IsEmpty;

  // ���� �� �����
  if not Result then
  begin
    MarkAsError(etError);

    Errors.AddError(ExcelRow.AsInteger, Range.Index + 1, Range.AsString,
      AErrorMessage);
  end;
end;

function TExtraChargeExcelTable.CheckRecord: Boolean;
begin
  Result := inherited;
  if Result then
  begin
    // ��������� ��� ����� ������������� ����������
    Result := CheckRange;
  end;
end;

function TExtraChargeExcelTable.GetqExtraChargeSimple: TQueryExtraChargeSimple;
begin
  if FqExtraChargeSimple = nil then
    FqExtraChargeSimple := TQueryExtraChargeSimple.Create(Self);

  Result := FqExtraChargeSimple;
end;

function TExtraChargeExcelTable.GetRange: TField;
begin
  Result := FieldByName('Range');
end;

function TExtraChargeExcelTable.GetWholeSale: TField;
begin
  Result := FieldByName('WholeSale');
end;

procedure TExtraChargeExcelTable.SetFieldsInfo;
begin
  FieldsInfo.Add(TFieldInfo.Create('Range', True,
    '�������� �� ����� ���� ������'));
  FieldsInfo.Add(TFieldInfo.Create('Wholesale', True,
    '������� �� ����� ���� ������'));
end;

function TExtraChargeExcelDM.CreateExcelTable: TCustomExcelTable;
begin
  Result := TExtraChargeExcelTable.Create(Self);
end;

function TExtraChargeExcelDM.GetExcelTable: TExtraChargeExcelTable;
begin
  Result := CustomExcelTable as TExtraChargeExcelTable;
end;

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

end.
