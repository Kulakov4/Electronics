unit DescriptionsInterface;

interface

type
  TCheckDescriptionResult = (ƒублируетс€, —уществуетƒругое, Ќе—уществует);
  IDescriptions = interface(IInterface)
    function Check(const AComponentName, ADescription: String; AProducerID:
        Integer): TCheckDescriptionResult; stdcall;

  end;

implementation

end.
