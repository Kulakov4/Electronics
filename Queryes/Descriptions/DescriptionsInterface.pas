unit DescriptionsInterface;

interface

type
  TCheckDescriptionResult = (�����������, ����������������, ������������);
  IDescriptions = interface(IInterface)
    function Check(const AComponentName, ADescription: String; AProducerID:
        Integer): TCheckDescriptionResult; stdcall;

  end;

implementation

end.
