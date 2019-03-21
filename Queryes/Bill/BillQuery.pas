unit BillQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, DSWrap, BaseEventsQuery, NotifyEvents;

type
  TBillW = class(TDSWrap)
  private
    FBeforeShip: TNotifyEventsEx;
    FID: TFieldWrap;
    FNumber: TFieldWrap;
    FBillDate: TFieldWrap;
    FShipmentDate: TFieldWrap;
    FDollar: TFieldWrap;
    FEuro: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function AddBill(const ADollarCource, AEuroCource: Double): Integer;
    procedure ApplyNotShipmentFilter;
    procedure ApplyShipmentFilter;
    procedure Ship;
    property BeforeShip: TNotifyEventsEx read FBeforeShip;
    property ID: TFieldWrap read FID;
    property Number: TFieldWrap read FNumber;
    property BillDate: TFieldWrap read FBillDate;
    property ShipmentDate: TFieldWrap read FShipmentDate;
    property Dollar: TFieldWrap read FDollar;
    property Euro: TFieldWrap read FEuro;
  end;

  TQryBill = class(TQueryBaseEvents)
  private
    FW: TBillW;
    { Private declarations }
  protected
    function CreateDSWrap: TDSWrap; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure CancelBill;
    function SearchByPeriod(ABeginDate, AEndDate: TDate): Integer;
    property W: TBillW read FW;
    { Public declarations }
  end;

implementation

uses
  MaxBillNumberQuery, BaseQuery, StrHelper;

{$R *.dfm}

constructor TQryBill.Create(AOwner: TComponent);
begin
  inherited;
  FW := FDSWrap as TBillW;
end;

procedure TQryBill.CancelBill;
begin
  // TODO -cMM: TQryBill.CancelBill default body inserted
end;

function TQryBill.CreateDSWrap: TDSWrap;
begin
  Result := TBillW.Create(FDQuery);
end;

function TQryBill.SearchByPeriod(ABeginDate, AEndDate: TDate): Integer;
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
  AStipulation := Format('%s >= date(''%s'')',
    [W.BillDate.FieldName, FormatDateTime('YYYY-MM-DD', ASD)]);
  ANewSQL := ReplaceInSQL(SQL, AStipulation, 0);

  // Делаем замену в SQL запросе
  AStipulation := Format('%s <= date(''%s'')',
    [W.BillDate.FieldName, FormatDateTime('YYYY-MM-DD', AED)]);
  ANewSQL := ReplaceInSQL(ANewSQL, AStipulation, 1);

  FDQuery.SQL.Text := ANewSQL;
  W.RefreshQuery;
  Result := FDQuery.RecordCount;
end;

constructor TBillW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'ID', '', True);
  FNumber := TFieldWrap.Create(Self, 'Number', 'Номер');
  FBillDate := TFieldWrap.Create(Self, 'BillDate', 'Дата');
  FShipmentDate := TFieldWrap.Create(Self, 'ShipmentDate', 'Дата отгрузки');
  FDollar := TFieldWrap.Create(Self, 'Dollar', 'Курс $');
  FEuro := TFieldWrap.Create(Self, 'Euro', 'Курс €');

  FBeforeShip := TNotifyEventsEx.Create(Self);
end;

destructor TBillW.Destroy;
begin
  inherited;
  FreeAndNil(FBeforeShip);
end;

function TBillW.AddBill(const ADollarCource, AEuroCource: Double): Integer;
begin
  TryAppend;
  try
    Number.F.Value := TQryMaxBillNumber.Get_Max_Number + 1;
    BillDate.F.Value := Date; // Дата счёта - текущая дата
    Dollar.F.Value := ADollarCource;
    Euro.F.Value := AEuroCource;
    TryPost;
    Result := PK.Value;
    Assert(Result > 0);
  except
    TryCancel;
    raise;
  end;
end;

procedure TBillW.ApplyNotShipmentFilter;
begin
  DataSet.Filter := Format('%s is null', [ShipmentDate.FieldName]);
  DataSet.Filtered := True;
end;

procedure TBillW.ApplyShipmentFilter;
begin
  DataSet.Filter := Format('%s is not null', [ShipmentDate.FieldName]);
  DataSet.Filtered := True;
end;

procedure TBillW.Ship;
begin
  Assert(ShipmentDate.F.IsNull);

  FBeforeShip.CallEventHandlers(Self);

  TryEdit;
  ShipmentDate.F.AsDateTime := Date;
  TryPost;
end;

end.
