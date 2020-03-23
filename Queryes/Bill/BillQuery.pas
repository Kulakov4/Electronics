unit BillQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, DSWrap, BaseEventsQuery, NotifyEvents,
  BillInterface, InsertEditMode, BillContentInterface;

type
  TBillW = class(TDSWrap)
  private
    FBillContent: IBillContent;
    FID: TFieldWrap;
    FNumber: TFieldWrap;
    FBillDate: TFieldWrap;
    FWidth: TFieldWrap;
    FShipmentDate: TFieldWrap;
    FDollar: TFieldWrap;
    FEuro: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Save(AMode: TMode; ABillInt: IBill): Integer;
    procedure ApplyNotShipmentFilter;
    procedure ApplyShipmentFilter;
    procedure Ship(ADate: TDate);
    procedure CancelShip;
    property BillContent: IBillContent read FBillContent write FBillContent;
    property ID: TFieldWrap read FID;
    property Number: TFieldWrap read FNumber;
    property BillDate: TFieldWrap read FBillDate;
    property Width: TFieldWrap read FWidth;
    property ShipmentDate: TFieldWrap read FShipmentDate;
    property Dollar: TFieldWrap read FDollar;
    property Euro: TFieldWrap read FEuro;
  end;

  TQryBill = class(TQueryBaseEvents)
  private
    FW: TBillW;
    procedure DoBeforePost(Sender: TObject);
    { Private declarations }
  protected
    function CreateDSWrap: TDSWrap; override;
  public
    constructor Create(AOwner: TComponent); override;
    function SearchByNumber(ANumber: Integer): Integer;
    class function SearchByNumberStatic(ANumber: Integer): Integer; static;
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
  TNotifyEventWrap.Create(W.BeforePost, DoBeforePost, W.EventList);
end;

function TQryBill.CreateDSWrap: TDSWrap;
begin
  Result := TBillW.Create(FDQuery);
end;

procedure TQryBill.DoBeforePost(Sender: TObject);
begin
  if W.BillDate.F.IsNull then
    raise Exception.Create('Дата создания счёта не может быть пустой');

  if (not W.ShipmentDate.F.IsNull) and
    (W.ShipmentDate.F.AsDateTime < W.BillDate.F.AsDateTime) then
    raise Exception.Create
      ('Дата отгрузки не может быть меньше даты создания счёта');
end;

function TQryBill.SearchByNumber(ANumber: Integer): Integer;
begin
  Assert(ANumber > 0);
  Result := SearchEx([TParamRec.Create(W.Number.FullName, ANumber)]);
end;

class function TQryBill.SearchByNumberStatic(ANumber: Integer): Integer;
var
  Q: TQryBill;
begin
  Q := TQryBill.Create(nil);
  try
    Result := Q.SearchByNumber(ANumber);
  finally
    FreeAndNil(Q);
  end;
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
  FWidth := TFieldWrap.Create(Self, 'Width');
end;

destructor TBillW.Destroy;
begin
  inherited;
end;

function TBillW.Save(AMode: TMode; ABillInt: IBill): Integer;
begin
  Assert(ABillInt <> nil);

  if AMode = EditMode then
    TryEdit
  else
    TryAppend;
  try
    Number.F.Value := ABillInt.BillNumber;
    Width.F.Value := ABillInt.BillWidth;
    BillDate.F.Value := ABillInt.BillDate;
    Dollar.F.Value := ABillInt.DollarCource;
    Euro.F.Value := ABillInt.EuroCource;
    TryPost;
    Result := PK.Value;
    Assert(Result > 0);
  except
    TryCancel;
    raise;
  end;

  // Выполняем операцию по отгрузке / отмене отгрузки
  if AMode = EditMode then
  begin
    if (ABillInt.ShipmentDate > 0) and (ShipmentDate.F.AsDateTime <= 0) then
      // Просим контент отгрузить товар и уменьшить его количество на складе
      Ship(ABillInt.ShipmentDate)
    else if (ABillInt.ShipmentDate <= 0) and (ShipmentDate.F.AsDateTime > 0)
    then
      // Просим контент отменить отгрузку товара и увеличить его количество на складе
      CancelShip();
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

procedure TBillW.Ship(ADate: TDate);
begin
  Assert(ShipmentDate.F.IsNull);
  Assert(BillContent <> nil);

  if ADate < BillDate.F.AsDateTime then
    raise Exception.Create
      ('Дата отгрузки не может быть меньше даты создания счёта');

  // Просим контент отгрузить товар и уменьшить его количество на складе
  BillContent.ShipAll;
  TryEdit;
  ShipmentDate.F.AsDateTime := ADate;
  TryPost;
end;

procedure TBillW.CancelShip;
begin
  Assert(not ShipmentDate.F.IsNull);
  Assert(BillContent <> nil);

  // Просим контент вернуть товар на склад
  BillContent.CalcelAllShip;
  TryEdit;
  ShipmentDate.F.Value := NULL;
  TryPost;
end;

end.
