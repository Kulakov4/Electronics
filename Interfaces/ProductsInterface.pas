unit ProductsInterface;

interface

uses
  StoreHouseListInterface;

type
  IProducts = interface(IInterface)
    procedure FreeInt;
    procedure LoadContent(AStoreHouseID: Integer; AStorehouseListInt:
        IStorehouseList);
  end;

implementation

end.
