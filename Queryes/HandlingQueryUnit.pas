unit HandlingQueryUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  ProgressInfo, NotifyEvents, ProcRefUnit;

type
  THandlingQuery = class(TQueryBase, IHandling)
  private
    FOnProgress: TNotifyEventsEx;
    FPI: TProgressInfo;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CallOnProcessEvent;
    procedure Process(AProcRef: TProcRef;
      ANotifyEventRef: TNotifyEventRef); overload;
    property OnProgress: TNotifyEventsEx read FOnProgress;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor THandlingQuery.Create(AOwner: TComponent);
begin
  inherited;
  FPI := TProgressInfo.Create;
  FOnProgress := TNotifyEventsEx.Create(Self);
end;

destructor THandlingQuery.Destroy;
begin
  FreeAndNil(FPI);
  inherited;
end;

procedure THandlingQuery.CallOnProcessEvent;
begin
  Assert(FDQuery.Active);
  Assert(FPI <> nil);
  FPI.TotalRecords := FDQuery.RecordCount;
  FPI.ProcessRecords := FDQuery.RecNo;
  OnProgress.CallEventHandlers(FPI)
end;

procedure THandlingQuery.Process(AProcRef: TProcRef;
  ANotifyEventRef: TNotifyEventRef);
var
  ne: TNotifyEventR;
begin
  Assert(Assigned(AProcRef));

  // Подписываем кого-то на событие
  ne := TNotifyEventR.Create(OnProgress, ANotifyEventRef);
  try
    // Вызываем метод, обрабатывающий нашу таблицу
    AProcRef(Self);
  finally
    // Отписываем кого-то от события
    FreeAndNil(ne);
  end;
end;

end.
