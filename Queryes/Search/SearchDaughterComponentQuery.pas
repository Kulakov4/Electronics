unit SearchDaughterComponentQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQuerySearchDaughterComponent = class(TQueryBase)
  private
    function GetParentProductID: TField;
    function GetProducer: TField;
    function GetValue: TField;
    { Private declarations }
  protected
  public
    function Search(const AComponentName: string): Integer; overload;
    function Search(const AComponentName, AProducer: string): Integer; overload;
    property ParentProductID: TField read GetParentProductID;
    property Producer: TField read GetProducer;
    property Value: TField read GetValue;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses ParameterValuesUnit;

function TQuerySearchDaughterComponent.GetParentProductID: TField;
begin
  Result := Field('ParentProductID');
end;

function TQuerySearchDaughterComponent.GetProducer: TField;
begin
  Result := Field('Producer');
end;

function TQuerySearchDaughterComponent.GetValue: TField;
begin
  Result := Field('Value');
end;

function TQuerySearchDaughterComponent.Search(const AComponentName: string):
    Integer;
begin
  Assert(not AComponentName.IsEmpty);

  // —нимаем фильтр
  FDQuery.Filtered := False;
  FDQuery.Filter := '';

  // »щем
  Result := Search(['ComponentName', 'ProducerParameterID'],
    [AComponentName, TParameterValues.ProducerParameterID]);
end;

function TQuerySearchDaughterComponent.Search(const AComponentName, AProducer:
    string): Integer;
begin
  Assert(not AProducer.IsEmpty);

  Result := Search( AComponentName );
  if Result > 0 then
  begin
    FDQuery.Filter := Format('%s=%s', [Producer.FieldName, QuotedStr(AProducer)]);
    FDQuery.Filtered := True;
  end;
end;

end.
