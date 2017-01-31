unit TableWithProgress;

interface

uses
  FireDAC.Comp.Client, ProgressInfo, NotifyEvents, System.Classes, ProcRefUnit;

type
  TTableWithProgress = class(TFDMemTable, IHandling)
  private
    FOnProgress: TNotifyEventsEx;
    FPI: TProgressInfo;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CallOnProcessEvent;
    procedure Process(AProcRef: TProcRef;
      ANotifyEventRef: TNotifyEventRef); overload;
    property OnProgress: TNotifyEventsEx read FOnProgress;
  end;

implementation

uses System.SysUtils, ProgressBarForm;

constructor TTableWithProgress.Create(AOwner: TComponent);
begin
  inherited;
  FPI := TProgressInfo.Create;
  FOnProgress := TNotifyEventsEx.Create(Self);
end;

destructor TTableWithProgress.Destroy;
begin
  FreeAndNil(FPI);
  inherited;
end;

procedure TTableWithProgress.CallOnProcessEvent;
begin
  Assert(Active);
  Assert(FPI <> nil);
  FPI.TotalRecords := RecordCount;
  FPI.ProcessRecords := RecNo;
  OnProgress.CallEventHandlers(FPI)
end;

procedure TTableWithProgress.Process(AProcRef: TProcRef;
  ANotifyEventRef: TNotifyEventRef);
var
  ne: TNotifyEventR;
begin
  Assert(Assigned(AProcRef));

  // Подписываем кого-то на событие
  ne := TNotifyEventR.Create(OnProgress, ANotifyEventRef);
  try
    // Вызываем метод, обрабатывающий нашу таблицу
    AProcRef;
  finally
    // Отписываем кого-то от события
    FreeAndNil(ne);
  end;
end;

end.
