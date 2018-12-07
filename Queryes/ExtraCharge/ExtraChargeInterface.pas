unit ExtraChargeInterface;

interface

type
  IExtraCharge = interface(IInterface)
    function HaveDuplicate(const AExtraChargeTypeName, ARange: String): Boolean;
        stdcall;
  end;

implementation

end.
