unit ParameterKindsQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, DSWrap, BaseEventsQuery;

type
  TParameterKindW = class(TDSWrap)
  private
    FParameterKind: TFieldWrap;
    FID: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    function GetIDByParameterKind(const AParameterKind: String): Integer;
    property ParameterKind: TFieldWrap read FParameterKind;
    property ID: TFieldWrap read FID;
  end;

  TQueryParameterKinds = class(TQueryBaseEvents)
  private
    FW: TParameterKindW;
    { Private declarations }
  protected
    function CreateDSWrap: TDSWrap; override;
  public
    constructor Create(AOwner: TComponent); override;
    property W: TParameterKindW read FW;
    { Public declarations }
  end;

implementation

uses
  NotifyEvents;

{$R *.dfm}

constructor TQueryParameterKinds.Create(AOwner: TComponent);
begin
  inherited;
  FW := FDSWrap as TParameterKindW;
end;

function TQueryParameterKinds.CreateDSWrap: TDSWrap;
begin
  Result := TParameterKindW.Create(FDQuery);
end;

constructor TParameterKindW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'ID', '', True);
  FParameterKind := TFieldWrap.Create(Self, 'ParameterKind', 'Тип параметра');
end;

function TParameterKindW.GetIDByParameterKind(const AParameterKind
  : String): Integer;
var
  V: Variant;
begin
  V := FDDataSet.LookupEx(ParameterKind.FieldName, AParameterKind, PKFieldName,
    [lxoCaseInsensitive]);

  if VarIsNull(V) then
    Result := 0
  else
    Result := V;
end;

end.
