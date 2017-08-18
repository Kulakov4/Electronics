unit ProgressInfo;

interface

uses
  NotifyEvents;

type
  TProgressInfo = class(TObject)
  private
    FOnAssign: TNotifyEventsEx;
    FProcessRecords: Cardinal;
    FTotalRecords: Cardinal;
    function GetPosition: Double;
  public
    constructor Create;
    procedure Assign(AProgressInfo: TProgressInfo);
    procedure Clear;
    property OnAssign: TNotifyEventsEx read FOnAssign;
    property Position: Double read GetPosition;
    property ProcessRecords: Cardinal read FProcessRecords
      write FProcessRecords;
    property TotalRecords: Cardinal read FTotalRecords write FTotalRecords;
  end;

implementation

uses System.Math;

constructor TProgressInfo.Create;
begin
  Clear;
  FOnAssign := TNotifyEventsEx.Create(Self);
end;

procedure TProgressInfo.Assign(AProgressInfo: TProgressInfo);
begin
  Assert(AProgressInfo <> nil);
  TotalRecords := AProgressInfo.TotalRecords;
  ProcessRecords := AProgressInfo.ProcessRecords;
  FOnAssign.CallEventHandlers(Self);
end;

procedure TProgressInfo.Clear;
begin
  ProcessRecords := 0;
  TotalRecords := 0;
end;

function TProgressInfo.GetPosition: Double;
begin
  if TotalRecords > 0 then
    Result := ProcessRecords * 100 / TotalRecords
  else
    Result := 0;
end;

end.
