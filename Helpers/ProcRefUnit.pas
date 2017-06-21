unit ProcRefUnit;

interface

uses NotifyEvents;

type
  // ������ �� ����� �������������� ������ �������
  TProcRef = reference to procedure();

  IHandling = interface(IInterface)
    procedure Process(AProcRef: TProcRef; ANotifyEventRef: TNotifyEventRef);
  end;

implementation

end.
