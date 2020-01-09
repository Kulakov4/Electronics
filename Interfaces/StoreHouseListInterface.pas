unit StoreHouseListInterface;

interface

type
  IStorehouseList = interface(IInterface)
    function GetStoreHouseTitle: string;
    property StoreHouseTitle: string read GetStoreHouseTitle;
  end;

implementation

end.
