unit DescriptionsInterface;

interface

uses
  RecordCheck;

type
//  TCheckDescriptionResult = (�����������, ����������������, ������������);
  IDescriptions = interface(IInterface)
    function Check(const AComponentName, ADescription: String; AProducerID:
        Integer): TRecordCheck; stdcall;

  end;

implementation

end.
