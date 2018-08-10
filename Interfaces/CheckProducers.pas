unit CheckProducers;

interface

type
  ICheckProducer = interface(IInterface)
    function Exist(const AProducerName: String): Boolean; stdcall;
  end;

implementation

end.
