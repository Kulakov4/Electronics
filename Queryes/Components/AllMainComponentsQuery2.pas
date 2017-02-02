unit AllMainComponentsQuery2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQueryAllMainComponents2 = class(TQueryBase)
  private
    function GetValue: TField;
    { Private declarations }
  public
    property Value: TField read GetValue;
    { Public declarations }
  end;

implementation

{$R *.dfm}

function TQueryAllMainComponents2.GetValue: TField;
begin
  Result := Field('Value');
end;

end.
