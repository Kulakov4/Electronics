unit ExtraChargeInterface;

interface

type
  IExtraCharge = interface(IInterface)
    function HaveDuplicate(const ARange: string): Boolean; stdcall;
  end;

implementation

end.
