unit ParameterPosQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, QueryWithDataSourceUnit, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, BaseQuery;

type
  TQueryParameterPos = class(TQueryWithDataSource)
  private
    procedure DoAfterOpen(Sender: TObject);
    function GetPos: TField;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    property Pos: TField read GetPos;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses NotifyEvents;

constructor TQueryParameterPos.Create(AOwner: TComponent);
begin
  inherited;
  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, FEventList);
end;

procedure TQueryParameterPos.DoAfterOpen(Sender: TObject);
begin
  Pos.DisplayLabel := 'Расположение';
end;

function TQueryParameterPos.GetPos: TField;
begin
  Result := Field('Pos');
end;

end.
