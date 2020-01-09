unit StoreHouseListInterface;

interface

type
  IStorehouseList = interface(IInterface)
    function GetStoreHouseCount: Integer;
    function GetStoreHouseTitle: string;
    property StoreHouseCount: Integer read GetStoreHouseCount;
    property StoreHouseTitle: string read GetStoreHouseTitle;
  end;

implementation

end.
