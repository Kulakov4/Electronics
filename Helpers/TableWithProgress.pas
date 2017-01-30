unit TableWithProgress;

interface

uses
  FireDAC.Comp.Client, ProgressInfo, NotifyEvents, System.Classes;

type
  // Ссылка на метод обрабатывающий таблицу в памяти
  TProcRef = reference to procedure();

  TTableWithProgress = class(TFDMemTable)
  private
    FOnProgress: TNotifyEventsEx;
    FPI: TProgressInfo;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CallOnProcessEvent;
    procedure Process(AProcRef: TProcRef;
      ANotifyEventRef: TNotifyEventRef); overload;
    procedure Process(AProcRef: TProcRef; const ACaption: string); overload;
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

procedure TTableWithProgress.Process(AProcRef: TProcRef;
  const ACaption: string);
var
  AfrmProgressBar: TfrmProgressBar;
begin
  Assert(Assigned(AProcRef));

  AfrmProgressBar := TfrmProgressBar.Create(nil);
  try
    if not ACaption.IsEmpty then
      AfrmProgressBar.Caption := ACaption;
    AfrmProgressBar.Show;

    // Вызываем метод-обработку табличных данных
    Process(AProcRef,
      procedure(ASender: TObject)
      begin
        AfrmProgressBar.ProgressInfo.Assign(ASender as TProgressInfo);
      end);
  finally
    FreeAndNil(AfrmProgressBar);
  end;
end;

end.
