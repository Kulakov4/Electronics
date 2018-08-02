unit DataSetWrap;

interface

uses
  System.Classes, Data.DB, NotifyEvents;

type
  TDataSetWrap = class(TComponent)
  private
    FAfterClose: TNotifyEventsEx;
    FDataSet: TDataSet;
  protected
    procedure AfterDataSetClose(DataSet: TDataSet);
  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(ADataSet: TDataSet);
    property AfterClose: TNotifyEventsEx read FAfterClose;
  end;

implementation

constructor TDataSetWrap.Create(AOwner: TComponent);
begin
  inherited;
  Assign(AOwner as TDataSet);
end;

procedure TDataSetWrap.AfterDataSetClose(DataSet: TDataSet);
begin
  FAfterClose.CallEventHandlers(Self);
end;

procedure TDataSetWrap.Assign(ADataSet: TDataSet);
begin
  FDataSet := ADataSet;
  FDataSet.AfterClose := AfterDataSetClose;
end;

end.
