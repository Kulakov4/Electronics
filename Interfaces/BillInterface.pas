unit BillInterface;

interface

type
  IBill = interface(IInterface)
    function GetBillDate: TDate;
    function GetBillNumber: Integer;
    function GetBillNumberStr: String;
    function GetBillWidth: Integer;
    function GetDollarCource: Double;
    function GetEuroCource: Double;
    function GetShipmentDate: TDate;
    property BillDate: TDate read GetBillDate;
    property BillNumber: Integer read GetBillNumber;
    property BillNumberStr: String read GetBillNumberStr;
    property BillWidth: Integer read GetBillWidth;
    property DollarCource: Double read GetDollarCource;
    property EuroCource: Double read GetEuroCource;
    property ShipmentDate: TDate read GetShipmentDate;
  end;

implementation

end.
