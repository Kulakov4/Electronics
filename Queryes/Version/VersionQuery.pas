unit VersionQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, DSWrap;

type
  TVersionW = class(TDSWrap)
  private
    FVersion: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    property Version: TFieldWrap read FVersion;
  end;

  TQueryVersion = class(TQueryBase)
  private
    FW: TVersionW;
    { Private declarations }
  protected
  public
    constructor Create(AOwner: TComponent); override;
    class function GetDBVersion: Integer; static;
    property W: TVersionW read FW;
    { Public declarations }
  end;

implementation

constructor TVersionW.Create(AOwner: TComponent);
begin
  inherited;
  FVersion := TFieldWrap.Create(Self, 'Version', '', True);
end;

constructor TQueryVersion.Create(AOwner: TComponent);
begin
  inherited;
  FW := TVersionW.Create(FDQuery);
end;

class function TQueryVersion.GetDBVersion: Integer;
var
  Q: TQueryVersion;
begin
  Q := TQueryVersion.Create(nil);
  try
    Q.W.TryOpen;
    Result := Q.W.Version.F.AsInteger;
  finally
    FreeAndNil(Q);
  end;
end;

{$R *.dfm}

end.
