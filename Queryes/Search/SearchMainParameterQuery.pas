unit SearchMainParameterQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQuerySearchMainParameter = class(TQueryBase)
  private
    { Private declarations }
  public
    function Search(const ATableName: String): Integer; overload;
    { Public declarations }
  end;

implementation

{$R *.dfm}

function TQuerySearchMainParameter.Search(const ATableName: String): Integer;
begin
  Assert(not ATableName.IsEmpty);

  Result := Search(['TableName'], [ATableName]);
end;

end.
