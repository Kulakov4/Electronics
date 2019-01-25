unit BodiesQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  System.Generics.Collections, DSWrap;

type
  TBodyW = class(TDSWrap)
  private
    FBody: TFieldWrap;
    FID: TFieldWrap;
    FIDBodyKind: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    property Body: TFieldWrap read FBody;
    property ID: TFieldWrap read FID;
    property IDBodyKind: TFieldWrap read FIDBodyKind;
  end;

  TQueryBodies = class(TQueryBase)
    FDUpdateSQL: TFDUpdateSQL;
  private
    FW: TBodyW;
    { Private declarations }
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure LocateOrAppend(const ABody: string; AIDBodyKind: Integer);
    property W: TBodyW read FW;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses StrHelper;

constructor TQueryBodies.Create(AOwner: TComponent);
begin
  inherited;
  FW := TBodyW.Create(FDQuery);
end;

procedure TQueryBodies.LocateOrAppend(const ABody: string;
  AIDBodyKind: Integer);
var
  AFieldNames: string;
begin
  Assert(not ABody.IsEmpty);
  Assert(AIDBodyKind > 0);

  AFieldNames := Format('%s;%s', [W.IDBodyKind.FieldName, W.Body.FieldName]);

  if not FDQuery.LocateEx(AFieldNames, VarArrayOf([AIDBodyKind, ABody]),
    [lxoCaseInsensitive]) then
  begin
    W.TryAppend;
    W.Body.F.Value := ABody;
    W.IDBodyKind.F.Value := AIDBodyKind;
    W.TryPost;
  end;
end;

constructor TBodyW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'ID', '', True);
  FBody := TFieldWrap.Create(Self, 'Body');
  FIDBodyKind := TFieldWrap.Create(Self, 'IDBodyKind');
end;

end.
