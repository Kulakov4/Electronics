unit SearchProducerTypesQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQuerySearchProducerTypes = class(TQueryBase)
  private
    function GetProducerType: TField;
    { Private declarations }
  protected
  public
    property ProducerType: TField read GetProducerType;
    { Public declarations }
  end;

implementation

{$R *.dfm}

function TQuerySearchProducerTypes.GetProducerType: TField;
begin
  Result := Field('ProducerType');
end;

end.
