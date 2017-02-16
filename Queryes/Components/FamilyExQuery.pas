unit FamilyExQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FamilyQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  ApplyQueryFrame, NotifyEvents;

type
  TQueryFamilyEx = class(TQueryFamily)
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

constructor TQueryFamilyEx.Create(AOwner: TComponent);
begin
  inherited;
  FOn_ApplyUpdate := TNotifyEventsEx.Create(Self);
end;

procedure TQueryFamilyEx.ApplyDelete(ASender: TDataSet);
begin
  // ������ �� ������ ��� �������
end;

procedure TQueryFamilyEx.ApplyInsert(ASender: TDataSet);
begin
  // ������ �� ������ ��� ����������
end;

procedure TQueryFamilyEx.ApplyUpdate(ASender: TDataSet);
begin
  // ��������� ��� ���� ���������� ����������
  On_ApplyUpdate.CallEventHandlers(ASender);
end;

end.
