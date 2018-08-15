unit SubParametersInterface;

interface

type
  ISubParameters = interface(IInterface)
    function GetSubParameterID(const AName: string): Integer; stdcall;
  end;

implementation

end.
