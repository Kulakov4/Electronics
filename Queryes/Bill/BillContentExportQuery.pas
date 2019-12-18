unit BillContentExportQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ProductsBaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, DSWrap;

type
  TBillContentExportW = class(TProductW)
  private
    FBillDate: TFieldWrap;
    FValue2: TFieldWrap;
    FShipmentDate: TFieldWrap;
    FBillNumber: TFieldWrap;
    FWidth: TFieldWrap;
  protected
    procedure InitFields; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure ApplyNotShipmentFilter;
    procedure ApplyShipmentFilter;
    property BillDate: TFieldWrap read FBillDate;
    property Value2: TFieldWrap read FValue2;
    property ShipmentDate: TFieldWrap read FShipmentDate;
    property BillNumber: TFieldWrap read FBillNumber;
    property Width: TFieldWrap read FWidth;
  end;

  TQueryBillContentExport = class(TQueryProductsBase)
  private
    function GetExportW: TBillContentExportW;
    { Private declarations }
  protected
    function CreateDSWrap: TDSWrap; override;
    procedure DoOnCalcFields; override;
    procedure InitFieldDefs; override;
  public
    function SearchByPeriod(ABeginDate, AEndDate: TDate): Integer;
    property ExportW: TBillContentExportW read GetExportW;
    { Public declarations }
  end;

implementation

uses
  StrHelper, System.StrUtils;

function TQueryBillContentExport.CreateDSWrap: TDSWrap;
begin
  Result := TBillContentExportW.Create(FDQuery);
end;

procedure TQueryBillContentExport.DoOnCalcFields;
begin
  inherited;

  if (CalcStatus > 0) then
    Exit;

  ExportW.Value2.F.AsString := Format('Счёт №%s от %s%s',
    [Format('%.' + ExportW.Width.F.AsString + 'd',
    [ExportW.BillNumber.F.AsInteger]), FormatDateTime('dd.mm.yyyy',
    ExportW.BillDate.F.AsDateTime), IfThen(ExportW.ShipmentDate.F.IsNull, '',
    Format(' отгружен %s', [FormatDateTime('dd.mm.yyyy',
    ExportW.ShipmentDate.F.AsDateTime)]))]);
end;

function TQueryBillContentExport.GetExportW: TBillContentExportW;
begin
  Result := W as TBillContentExportW;
end;

procedure TQueryBillContentExport.InitFieldDefs;
begin
  inherited;

  // Составное имя склада
  FDQuery.FieldDefs.Add(ExportW.Value2.FieldName, ftWideString, 100);
end;

function TQueryBillContentExport.SearchByPeriod(ABeginDate,
  AEndDate: TDate): Integer;
var
  AED: TDate;
  ANewSQL: string;
  ASD: TDate;
  AStipulation: string;
begin
  if ABeginDate <= AEndDate then
  begin
    ASD := ABeginDate;
    AED := AEndDate;
  end
  else
  begin
    ASD := AEndDate;
    AED := ABeginDate;
  end;

  // Делаем замену в SQL запросе
  AStipulation := Format('%s >= date(''%s'')', [ExportW.BillDate.FieldName,
    FormatDateTime('YYYY-MM-DD', ASD)]);
  ANewSQL := ReplaceInSQL(SQL, AStipulation, 0);

  // Делаем замену в SQL запросе
  AStipulation := Format('%s <= date(''%s'')', [ExportW.BillDate.FieldName,
    FormatDateTime('YYYY-MM-DD', AED)]);
  ANewSQL := ReplaceInSQL(ANewSQL, AStipulation, 1);

  FDQuery.SQL.Text := ANewSQL;
  W.RefreshQuery;
  Result := FDQuery.RecordCount;
end;

constructor TBillContentExportW.Create(AOwner: TComponent);
begin
  inherited;
  FShipmentDate := TFieldWrap.Create(Self, 'ShipmentDate');
  FBillDate := TFieldWrap.Create(Self, 'BillDate');
  FBillNumber := TFieldWrap.Create(Self, 'BillNumber');
  FWidth := TFieldWrap.Create(Self, 'Width');
  FValue2 := TFieldWrap.Create(Self, 'Value2');
end;

procedure TBillContentExportW.ApplyNotShipmentFilter;
begin
  DataSet.Filter := Format('%s is null', [ShipmentDate.FieldName]);
  DataSet.Filtered := True;
end;

procedure TBillContentExportW.ApplyShipmentFilter;
begin
  DataSet.Filter := Format('%s is not null', [ShipmentDate.FieldName]);
  DataSet.Filtered := True;
end;

procedure TBillContentExportW.InitFields;
begin
  inherited;
  Value2.F.FieldKind := fkInternalCalc;
end;

{$R *.dfm}

end.
