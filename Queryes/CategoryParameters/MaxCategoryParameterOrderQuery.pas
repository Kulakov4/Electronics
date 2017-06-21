unit MaxCategoryParameterOrderQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQueryMaxCategoryParameterOrder = class(TQueryBase)
  private
    function GetMaxOrder: TField;
    { Private declarations }
  public
    class function Max_Order: Integer; static;
    property MaxOrder: TField read GetMaxOrder;
    { Public declarations }
  end;

implementation

{$R *.dfm}

function TQueryMaxCategoryParameterOrder.GetMaxOrder: TField;
begin
  Result := Field('MaxOrder');
end;

class function TQueryMaxCategoryParameterOrder.Max_Order: Integer;
var
  Q: TQueryMaxCategoryParameterOrder;
begin
  Q := TQueryMaxCategoryParameterOrder.Create(nil);
  try
    Q.FDQuery.Open;
    Result := Q.MaxOrder.AsInteger;
  finally
    FreeAndNil(Q);
  end;
end;

end.
