unit AllFamilyQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
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
  public
    constructor Create(AOwner: TComponent); override;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses NotifyEvents, ParameterValuesUnit;

constructor TQueryAllFamily.Create(AOwner: TComponent);
begin
  inherited;
  // ���� Description (��������) � ����� ������� ���
  ParameterFields.Remove(TParameterValues.DescriptionParameterID);

  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, FEventList );
end;

procedure TQueryAllFamily.DoAfterOpen(Sender: TObject);
var
  AField: TField;
begin
  for AField in FDQuery.Fields do
    AField.ReadOnly := False;
end;

end.