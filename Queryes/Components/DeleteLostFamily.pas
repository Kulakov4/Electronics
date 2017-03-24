unit DeleteLostFamily;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQueryDeleteLostFamily = class(TQueryBase)
  private
    class procedure Execute; static;
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

class procedure TQueryDeleteLostFamily.Execute;
var
  Q: TQueryDeleteLostFamily;
begin
  Q := TQueryDeleteLostFamily.Create(nil);
  try
    // ¬ыполн€ем SQL запрос удалени€ "потер€нных" семейств
    Q.FDQuery.ExecSQL;
  finally
    FreeAndNil(Q);
  end;
end;

end.
