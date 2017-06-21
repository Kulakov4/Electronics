unit ProducerTypesQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, QueryWithDataSourceUnit,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, OrderQuery;

type
  TQueryProducerTypes = class(TQueryOrder)
    FDUpdateSQL: TFDUpdateSQL;
  private
    procedure DoAfterOpen(Sender: TObject);
    function GetProducerType: TField;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    function LocateOrAppend(const AValue: string): Boolean;
    property ProducerType: TField read GetProducerType;
    { Public declarations }
  end;

var
  QueryProducerTypes: TQueryProducerTypes;

implementation

{$R *.dfm}

uses NotifyEvents;

constructor TQueryProducerTypes.Create(AOwner: TComponent);
begin
  inherited;
  AutoTransaction := False;
  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, FEventList);
end;

procedure TQueryProducerTypes.DoAfterOpen(Sender: TObject);
begin
  ProducerType.DisplayLabel := '“ËÔ';
end;

function TQueryProducerTypes.GetProducerType: TField;
begin
  Result := Field('ProducerType');
end;

function TQueryProducerTypes.LocateOrAppend(const AValue: string): Boolean;
begin
  Assert(not AValue.IsEmpty);
  Result := FDQuery.LocateEx(ProducerType.FieldName, AValue,
    [lxoCaseInsensitive]);
  if not Result then
  begin
    TryAppend;
    ProducerType.AsString := AValue;
    TryPost;
  end;
end;

end.
