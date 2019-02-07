unit BodyOptionsQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, DSWrap;

type
  TBodyOptionsW = class(TDSWrap)
  private
    FOption: TFieldWrap;
    FID: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    function LocateOrAppend(const AOption: string): Boolean;
    property Option: TFieldWrap read FOption;
    property ID: TFieldWrap read FID;
  end;

  TQueryBodyOptions = class(TQueryBase)
  private
    FW: TBodyOptionsW;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    property W: TBodyOptionsW read FW;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TQueryBodyOptions.Create(AOwner: TComponent);
begin
  inherited;
  FW := TBodyOptionsW.Create(FDQuery);
end;

constructor TBodyOptionsW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'ID', '', True);
  FOption := TFieldWrap.Create(Self, 'Option');
end;

function TBodyOptionsW.LocateOrAppend(const AOption: string): Boolean;
begin
  Assert(not AOption.IsEmpty);

  Result := Option.Locate(AOption, [lxoCaseInsensitive]);
  if Result then Exit;

  TryAppend;
  Option.F.AsString := AOption;
  TryPost;
end;

end.
