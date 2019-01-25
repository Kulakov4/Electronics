unit BillQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, QueryWithDataSourceUnit,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, DSWrap;

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
    property ID: TFieldWrap read FID;
    property Number: TFieldWrap read FNumber;
    property BillDate: TFieldWrap read FBillDate;
    property ShipmentDate: TFieldWrap read FShipmentDate;
    property Dollar: TFieldWrap read FDollar;
    property Euro: TFieldWrap read FEuro;
  end;

  TQryBill = class(TQueryWithDataSource)
  private
    FW: TBillW;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    function AddBill(const ADollarCource, AEuroCource: Double): Integer;
    property W: TBillW read FW;
    { Public declarations }
  end;

implementation

uses
  MaxBillNumberQuery;

{$R *.dfm}

constructor TQryBill.Create(AOwner: TComponent);
begin
  inherited;
  FW := TBillW.Create(FDQuery);
end;

function TQryBill.AddBill(const ADollarCource, AEuroCource: Double): Integer;
begin
  TryAppend;
  try
    W.Number.F.Value := TQryMaxBillNumber.Get_Max_Number + 1;
    W.BillDate.F.Value := Date;     // ���� ����� - ������� ����
    W.Dollar.F.Value := ADollarCource;
    W.Euro.F.Value := AEuroCource;
    W.TryPost;
    Result := W.PK.Value;
    Assert(Result > 0);
  except
    W.TryCancel;
    raise;
  end;
end;

constructor TBillW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'ID', '', True);
  FNumber := TFieldWrap.Create(Self, 'Number', '�����');
  FBillDate := TFieldWrap.Create(Self, 'BillDate', '����');
  FShipmentDate := TFieldWrap.Create(Self, 'ShipmentDate', '���� ��������');
  FDollar := TFieldWrap.Create(Self, 'Dollar', '���� �������');
  FEuro := TFieldWrap.Create(Self, 'Euro', '���� ����');
end;

end.
