unit SearchComponentsByValues;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQuerySearchComponentsByValues = class(TQueryBase)
  private
    function GetParentProductID: TField;
    { Private declarations }
  public
    function GetFieldValues(AFieldName: string; ADelimiter: String = ','): String;
    function Search(const AComponentNames: string): Integer; overload;
    property ParentProductID: TField read GetParentProductID;
    { Public declarations }
  end;

implementation

{$R *.dfm}

function TQuerySearchComponentsByValues.GetFieldValues(AFieldName: string;
    ADelimiter: String = ','): String;
var
  AClone: TFDMemTable;
  AValue: string;
begin
  Result := ADelimiter;

  // Создаём клона
  AClone := TFDMemTable.Create(Self);
  try
    AClone.CloneCursor(FDQuery);
    AClone.First;
    while not AClone.Eof do
    begin

      AValue := AClone.FieldByName(AFieldName).AsString;

      if (AValue <> '') then
      begin
        Result := Result + AValue + ADelimiter;
      end;

      AClone.Next;
    end;
  finally
    FreeAndNil(AClone);
  end;
end;

function TQuerySearchComponentsByValues.GetParentProductID: TField;
begin
  Result := Field('ParentProductID');
end;

function TQuerySearchComponentsByValues.Search(const AComponentNames: string):
    Integer;
begin
  Assert(not AComponentNames.IsEmpty);
  Result := Search(['Value'], [AComponentNames]);
end;

end.
