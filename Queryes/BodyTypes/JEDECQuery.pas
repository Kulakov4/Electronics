unit JEDECQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, DSWrap;

type
  TJEDECW = class(TDSWrap)
  private
    FJEDEC: TFieldWrap;
    FID: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    function LocateOrAppend(const AJedec: string): Boolean;
    property JEDEC: TFieldWrap read FJEDEC;
    property ID: TFieldWrap read FID;
  end;

  TQueryJEDEC = class(TQueryBase)
  private
    FW: TJEDECW;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    property W: TJEDECW read FW;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TQueryJEDEC.Create(AOwner: TComponent);
begin
  inherited;
  FW := TJEDECW.Create(FDQuery);
end;

constructor TJEDECW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'ID', '', True);
  FJEDEC := TFieldWrap.Create(Self, 'JEDEC');
end;

function TJEDECW.LocateOrAppend(const AJedec: string): Boolean;
begin
  Assert(not AJedec.IsEmpty);

  Result := JEDEC.Locate( AJedec, [lxoCaseInsensitive] );
  if Result then Exit;

  TryAppend;
  JEDEC.F.AsString := AJedec;
  TryPost;
end;

end.
