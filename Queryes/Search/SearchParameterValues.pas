unit SearchParameterValues;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQuerySearchParameterValues = class(TQueryBase)
  private
    function GetValue: TField;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    function Search(AIDParameter: Integer): Integer; overload;
    property Value: TField read GetValue;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TQuerySearchParameterValues.Create(AOwner: TComponent);
begin
  inherited;
  // TODO -cMM: TQuerySearchParameterValues.Create default body inserted
end;

function TQuerySearchParameterValues.GetValue: TField;
begin
  Result := Field('Value');
end;

function TQuerySearchParameterValues.Search(AIDParameter: Integer): Integer;
begin
  Assert(AIDParameter > 0);
  Result := Search(['ParameterId'], [AIDParameter]);
end;

end.
