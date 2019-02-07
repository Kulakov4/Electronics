unit MaxBillNumberQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQryMaxBillNumber = class(TQueryBase)
  private
    { Private declarations }
  protected
  public
    class function Get_Max_Number: Integer; static;
    { Public declarations }
  end;

implementation

{$R *.dfm}

class function TQryMaxBillNumber.Get_Max_Number: Integer;
var
  Q: TQryMaxBillNumber;
begin
  Q := TQryMaxBillNumber.Create(nil);
  try
    Q.FDQuery.Open;
    Result := Q.FDQuery.FieldByName('MaxNumber').AsInteger;
  finally
    FreeAndNil(Q);
  end;
end;

end.
