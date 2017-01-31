unit QueryWithDataSourceUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  NotifyEvents;

const
  WM_ON_DATA_CHANGE = WM_USER + 559;

type
  TQueryWithDataSource = class(TQueryBase)
    DataSource: TDataSource;
    procedure DataSourceDataChange(Sender: TObject; Field: TField);
  private
    FOnDataChange: TNotifyEventsEx;
    FResiveOnDataChangeMessage: Boolean;
    { Private declarations }
  protected
    procedure ProcessOnDataChange(var Message: TMessage); message WM_ON_DATA_CHANGE;
  public
    constructor Create(AOwner: TComponent); override;
    property OnDataChange: TNotifyEventsEx read FOnDataChange;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TQueryWithDataSource.Create(AOwner: TComponent);
begin
  inherited;
  // Создаём события
  FOnDataChange := TNotifyEventsEx.Create(Self);
  FResiveOnDataChangeMessage := True;
end;

procedure TQueryWithDataSource.DataSourceDataChange(Sender: TObject; Field:
    TField);
begin
  // если есть подписчики
  if (FOnDataChange.Count > 0) and (FResiveOnDataChangeMessage) then
  begin
    FResiveOnDataChangeMessage := False;
    PostMessage(Handle, WM_ON_DATA_CHANGE, 0, 0);
  end;
end;

procedure TQueryWithDataSource.ProcessOnDataChange(var Message: TMessage);
begin
  FOnDataChange.CallEventHandlers(Self);
  FResiveOnDataChangeMessage := True;
end;

end.
