unit ProcRefUnit;

interface

uses NotifyEvents;

type
  // ������ �� ����� �������������� ������ �������
  TProcRef = reference to procedure(ASender: TObject);

  IHandling = interface(IInterface)
    procedure Process(AProcRef: TProcRef; ANotifyEventRef: TNotifyEventRef);
  end;

implementation

end.
