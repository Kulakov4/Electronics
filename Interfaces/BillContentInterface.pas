unit BillContentInterface;

interface

uses
  BillInterface;

type
  IBillContent = interface(IInterface)
    procedure CalcelAllShip;
    procedure CancelShip;
    procedure CascadeDelete(ABillID: Integer);
    procedure Ship;
    procedure ShipAll;
    procedure LoadContent(ABillID: Integer; ABill: IBill);
  end;

implementation

end.
