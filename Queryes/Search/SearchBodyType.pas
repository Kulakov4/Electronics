unit SearchBodyType;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQuerySearchBodyType = class(TQueryBase)
  private
    { Private declarations }
  public
    function Search(const ABodyType: string): Integer; overload;
    { Public declarations }
  end;

implementation

{$R *.dfm}

function TQuerySearchBodyType.Search(const ABodyType: string): Integer;
begin
  Assert(not ABodyType.IsEmpty);
  Result := Search(['BodyType'], [ABodyType]);
end;

end.
