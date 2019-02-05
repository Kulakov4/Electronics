unit ParameterPosQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, QueryWithDataSourceUnit,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, BaseQuery,
  DSWrap;

type
  TParameterPosW = class(TDSWrap)
  private
    FPos: TFieldWrap;
    FID: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    property Pos: TFieldWrap read FPos;
    property ID: TFieldWrap read FID;
  end;

  TQueryParameterPos = class(TQueryWithDataSource)
  private
    FW: TParameterPosW;
    { Private declarations }
  protected
    function CreateDSWrap: TDSWrap; override;
  public
    constructor Create(AOwner: TComponent); override;
    property W: TParameterPosW read FW;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses NotifyEvents;

constructor TQueryParameterPos.Create(AOwner: TComponent);
begin
  inherited;
  FW := FDSWrap as TParameterPosW;
end;

function TQueryParameterPos.CreateDSWrap: TDSWrap;
begin
  Result := inherited CreateDSWrap;
end;

constructor TParameterPosW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'ID', '', True);
  FPos := TFieldWrap.Create(Self, 'Pos', 'Расположение');
end;

end.
