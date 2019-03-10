unit BillQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, DSWrap, BaseEventsQuery;

type
  TBillW = class(TDSWrap)
  private
    FID: TFieldWrap;
    FNumber: TFieldWrap;
    FBillDate: TFieldWrap;
    FShipmentDate: TFieldWrap;
    FDollar: TFieldWrap;
    FEuro: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    function AddBill(const ADollarCource, AEuroCource: Double): Integer;
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
    property W: TBillW read FW;
    { Public declarations }
  end;

implementation

uses
  MaxBillNumberQuery, NotifyEvents;

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

constructor TBillW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'ID', '', True);
  FNumber := TFieldWrap.Create(Self, 'Number', 'Номер');
  FBillDate := TFieldWrap.Create(Self, 'BillDate', 'Дата');
  FShipmentDate := TFieldWrap.Create(Self, 'ShipmentDate', 'Дата отгрузки');
  FDollar := TFieldWrap.Create(Self, 'Dollar', 'Курс $');
  FEuro := TFieldWrap.Create(Self, 'Euro', 'Курс €');
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

end.
