unit ProcRefUnit;

interface

uses NotifyEvents;

type
  // —сылка на метод обрабатывающий данные запроса
  TProcRef = reference to procedure(ASender: TObject);

  IHandling = interface(IInterface)
    procedure Process(AProcRef: TProcRef; ANotifyEventRef: TNotifyEventRef);
  end;

implementation

end.
