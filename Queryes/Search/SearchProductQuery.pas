unit SearchProductQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQuerySearchProduct = class(TQueryBase)
  private
    function GetIDProducer: TField;
    { Private declarations }
  public
    function Search(const AValue: string; const AIDProducer: Integer)
      : Integer; overload;
    function Search(const AValue: string): Integer; overload;
    property IDProducer: TField read GetIDProducer;
    { Public declarations }
  end;

implementation

{$R *.dfm}

function TQuerySearchProduct.GetIDProducer: TField;
begin
  Result := Field('IDProducer');
end;

function TQuerySearchProduct.Search(const AValue: string;
  const AIDProducer: Integer): Integer;
begin
  Assert(not AValue.IsEmpty);
  Assert(AIDProducer > 0);

  Result := Search(AValue);
  if Result > 0 then
  begin
    // Фильтруем по производителю
    FDQuery.Filter := Format('IDProducer=%d', [AIDProducer]);
    FDQuery.Filtered := True;
    Result := FDQuery.RecordCount;
  end;
end;

function TQuerySearchProduct.Search(const AValue: string): Integer;
begin
  Assert(not AValue.IsEmpty);

  FDQuery.Filtered := False;
  FDQuery.Filter := '';

  Result := Search(['Value'], [AValue]);
end;

end.
