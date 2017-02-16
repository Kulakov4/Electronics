unit ComponentsExQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, ApplyQueryFrame, NotifyEvents,
  ComponentsQuery;

type
  TQueryComponentsEx = class(TQueryComponents)
  private
    FOn_ApplyUpdate: TNotifyEventsEx;
    { Private declarations }
  protected
    procedure ApplyDelete(ASender: TDataSet); override;
    procedure ApplyInsert(ASender: TDataSet); override;
    procedure ApplyUpdate(ASender: TDataSet); override;
  public
    constructor Create(AOwner: TComponent); override;
    property On_ApplyUpdate: TNotifyEventsEx read FOn_ApplyUpdate;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TQueryComponentsEx.Create(AOwner: TComponent);
begin
  inherited;
  FOn_ApplyUpdate := TNotifyEventsEx.Create(Self);
end;

procedure TQueryComponentsEx.ApplyDelete(ASender: TDataSet);
begin
  // ничего не делаем при удаении
end;

procedure TQueryComponentsEx.ApplyInsert(ASender: TDataSet);
begin
  // Ничего не делаем при добавлении
end;

procedure TQueryComponentsEx.ApplyUpdate(ASender: TDataSet);
begin
  // Оповещаем что надо обработать обновление
  On_ApplyUpdate.CallEventHandlers(ASender);
end;

end.
