unit AllFamilyQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  BaseFamilyQuery, ApplyQueryFrame;

type
  TQueryAllFamily = class(TQueryBaseFamily)
  private
    procedure DoAfterOpen(Sender: TObject);
    { Private declarations }
  protected
    procedure InitParameterFields; override;
  public
    constructor Create(AOwner: TComponent); override;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses NotifyEvents, DefaultParameters;

constructor TQueryAllFamily.Create(AOwner: TComponent);
begin
  inherited;
  TNotifyEventWrap.Create(W.AfterOpen, DoAfterOpen, W.EventList);
end;

procedure TQueryAllFamily.DoAfterOpen(Sender: TObject);
begin
  W.SetFieldsReadOnly(False);
end;

procedure TQueryAllFamily.InitParameterFields;
begin
  inherited;

  // ���� Description (��������) � ����� ������� ���
  ParameterFields.Remove(TDefaultParameters.DescriptionParamSubParamID);
end;

end.

