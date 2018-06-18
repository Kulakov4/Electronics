unit BodyVariationJedecQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQueryBodyVariationJedec = class(TQueryBase)
  private
    function GetIDBodyVariation: TField;
    function GetIDJEDEC: TField;
    { Private declarations }
  public
    function SearchByIDBodyVariation(AIDBodyVariation: Integer): Integer;
    procedure UpdateJEDEC(AIDBodyVariation: Integer;
      AJedecIDArr: TArray<Integer>);
    property IDBodyVariation: TField read GetIDBodyVariation;
    property IDJEDEC: TField read GetIDJEDEC;
    { Public declarations }
  end;

implementation

uses
  StrHelper, System.Generics.Collections;

{$R *.dfm}

function TQueryBodyVariationJedec.GetIDBodyVariation: TField;
begin
  Result := Field('IDBodyVariation');
end;

function TQueryBodyVariationJedec.GetIDJEDEC: TField;
begin
  Result := Field('JEDEC');
end;

function TQueryBodyVariationJedec.SearchByIDBodyVariation(AIDBodyVariation
  : Integer): Integer;
var
  AFieldName: string;
begin
  Assert(AIDBodyVariation > 0);
  AFieldName := IDBodyVariation.FieldName;

  // Меняем в запросе условие
  FDQuery.SQL.Text := Replace(FDQuery.SQL.Text, Format('where %s = :%s',
    [AFieldName, AFieldName]), 'where');
  SetParamType(AFieldName);

  // Ищем
  Result := Search([AFieldName], [AIDBodyVariation]);
end;

procedure TQueryBodyVariationJedec.UpdateJEDEC(AIDBodyVariation: Integer;
  AJedecIDArr: TArray<Integer>);
var
  i: Integer;
begin
  SearchByIDBodyVariation(AIDBodyVariation);

  // Сначала удалим всё лишнее

  TArray.Sort<Integer>(AJedecIDArr);
  FDQuery.First;
  while not FDQuery.Eof do
  begin
    // Ищем в массиве такого кода нет - нужно удалить его из БД
    if not TArray.BinarySearch(AJedecIDArr, IDJEDEC.AsInteger, i) then
      FDQuery.Delete
    else
      FDQuery.Next;
  end;

  // Теперь добавим недостающее
  for i := Low(AJedecIDArr) to High(AJedecIDArr) do
  begin
    if not LocateByField(IDJEDEC.FieldName, AJedecIDArr[i], []) then
    begin
      TryAppend;
      IDBodyVariation.AsInteger := AIDBodyVariation;
      IDJEDEC.AsInteger := AJedecIDArr[i];
      TryPost;
    end;
  end;
end;

end.
