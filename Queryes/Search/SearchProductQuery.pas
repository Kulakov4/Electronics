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
    function GetDatasheet: TField;
    function GetDescriptionID: TField;
    function GetDiagram: TField;
    function GetDrawing: TField;
    function GetIDProducer: TField;
    function GetImage: TField;
    { Private declarations }
  public
    function SearchByID(AID: Integer): Integer;
    function SearchByValue(const AValue: string; const AIDProducer: Integer):
        Integer; overload;
    function SearchByValue(const AValue: string): Integer; overload;
    property Datasheet: TField read GetDatasheet;
    property DescriptionID: TField read GetDescriptionID;
    property Diagram: TField read GetDiagram;
    property Drawing: TField read GetDrawing;
    property IDProducer: TField read GetIDProducer;
    property Image: TField read GetImage;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses StrHelper;

function TQuerySearchProduct.GetDatasheet: TField;
begin
  Result := Field('Datasheet');
end;

function TQuerySearchProduct.GetDescriptionID: TField;
begin
  Result := Field('DescriptionID');
end;

function TQuerySearchProduct.GetDiagram: TField;
begin
  Result := Field('Diagram');
end;

function TQuerySearchProduct.GetDrawing: TField;
begin
  Result := Field('Drawing');
end;

function TQuerySearchProduct.GetIDProducer: TField;
begin
  Result := Field('IDProducer');
end;

function TQuerySearchProduct.GetImage: TField;
begin
  Result := Field('Image');
end;

function TQuerySearchProduct.SearchByID(AID: Integer): Integer;
begin
  Assert(AID > 0);

  // Меняем в запросе условие
  FDQuery.SQL.Text := Replace(FDQuery.SQL.Text, 'where ID = :ID', 'where');
  SetParamType('ID');

  // Ищем
  Result := Search(['ID'], [AID]);
end;

function TQuerySearchProduct.SearchByValue(const AValue: string; const
    AIDProducer: Integer): Integer;
begin
  Assert(not AValue.IsEmpty);
  Assert(AIDProducer > 0);

  // Меняем в запросе условие
  FDQuery.SQL.Text := Replace(FDQuery.SQL.Text,
  'where (Value = :Value) and (IDProducer=:IDProducer)', 'where');
  SetParamType('Value', ptInput, ftWideString);
  SetParamType('IDProducer');

  // Ищем
  Result := Search(['Value', 'IDProducer'], [AValue, AIDProducer]);
end;

function TQuerySearchProduct.SearchByValue(const AValue: string): Integer;
begin
  Assert(not AValue.IsEmpty);

  // Меняем в запросе условие
  FDQuery.SQL.Text := Replace(FDQuery.SQL.Text, 'where Value = :Value', 'where');
  SetParamType('Value', ptInput, ftWideString);

  // Ищем
  Result := Search(['Value'], [AValue]);
end;

end.
