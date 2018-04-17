unit ParameterKindsQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, QueryWithDataSourceUnit,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQueryParameterKinds = class(TQueryWithDataSource)
  private
    function GetParameterKind: TField;
    { Private declarations }
  protected
    procedure DoAfterOpen(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    property ParameterKind: TField read GetParameterKind;
    { Public declarations }
  end;

implementation

uses
  NotifyEvents;

{$R *.dfm}

constructor TQueryParameterKinds.Create(AOwner: TComponent);
begin
  inherited;
  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, FEventList);
end;

procedure TQueryParameterKinds.DoAfterOpen(Sender: TObject);
begin
  ParameterKind.DisplayLabel := 'Тип параметра';
end;

function TQueryParameterKinds.GetParameterKind: TField;
begin
  Result := Field('ParameterKind');
end;

end.
