unit ProducerTypesQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, QueryWithDataSourceUnit,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, OrderQuery, DSWrap;

type
  TProducerTypeW = class(TDSWrap)
  private
    FProducerType: TFieldWrap;
    FID: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    property ProducerType: TFieldWrap read FProducerType;
    property ID: TFieldWrap read FID;
  end;

  TQueryProducerTypes = class(TQueryOrder)
    FDUpdateSQL: TFDUpdateSQL;
  private
    FW: TProducerTypeW;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    function LocateOrAppend(const AValue: string): Boolean;
    property W: TProducerTypeW read FW;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses NotifyEvents;

constructor TQueryProducerTypes.Create(AOwner: TComponent);
begin
  inherited;
  FW := TProducerTypeW.Create(FDQuery);
  AutoTransaction := False;
end;

function TQueryProducerTypes.LocateOrAppend(const AValue: string): Boolean;
begin
  Assert(not AValue.IsEmpty);
  Result := FDQuery.LocateEx(W.ProducerType.FieldName, AValue,
    [lxoCaseInsensitive]);
  if not Result then
  begin
    W.TryAppend;
    W.ProducerType.F.AsString := AValue;
    W.TryPost;
  end;
end;

constructor TProducerTypeW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'ID', '', True);
  FProducerType := TFieldWrap.Create(Self, 'ProducerType', '“ËÔ');
end;

end.
