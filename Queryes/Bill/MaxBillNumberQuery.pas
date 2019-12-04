unit MaxBillNumberQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TMaxNumber = record
    Number: Integer;
    Width: Integer;
  public
  end;

  TQryMaxBillNumber = class(TQueryBase)
  private
    { Private declarations }
  protected
  public
    class function Get_Max_Number: TMaxNumber; static;
    { Public declarations }
  end;

implementation

{$R *.dfm}

class function TQryMaxBillNumber.Get_Max_Number: TMaxNumber;
var
  Q: TQryMaxBillNumber;
begin
  Result.Number := 0;
  Result.Width := 0;

  Q := TQryMaxBillNumber.Create(nil);
  try
    Q.FDQuery.Open;
    if Q.FDQuery.RecordCount > 0 then
    begin
      Result.Number := Q.FDQuery.FieldByName('Number').AsInteger;
      Result.Width := Q.FDQuery.FieldByName('Width').AsInteger;
    end;
  finally
    FreeAndNil(Q);
  end;
end;

end.
