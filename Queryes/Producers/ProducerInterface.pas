unit ProducerInterface;

interface

type
  IProducer = interface(IInterface)
    function GetProducerID(const AProducerName: String): Integer; stdcall;
    function Exist(const AProducerName: String): Boolean; stdcall;
  end;

implementation

end.
