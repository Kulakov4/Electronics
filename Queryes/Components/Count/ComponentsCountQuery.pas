unit ComponentsCountQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQueryComponentsCount = class(TQueryBase)
  private
    function GetCount: Integer;
    { Private declarations }
  protected
  public
    property Count: Integer read GetCount;
    { Public declarations }
  end;

implementation

uses System.Math;

{$R *.dfm}

function TQueryComponentsCount.GetCount: Integer;
var
  AField: TField;
begin
  AField := FDQuery.FieldByName('Components_Count');
  if not AField.IsNull then
    Result := AField.AsInteger
  else
    Result := 0;

end;

end.
