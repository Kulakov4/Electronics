unit ProducerInterface;

interface

type
  IProducer = interface(IInterface)
    function GetProducerID(const AProducerName: String): Integer; stdcall;
  end;

implementation

end.
