unit BodyVariationOptionQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQueryBodyVariationOption = class(TQueryBase)
  private
    function GetIDBodyOption: TField;
    function GetIDBodyVariation: TField;
    { Private declarations }
  public
    function SearchByIDBodyVariation(AIDBodyVariation: Integer): Integer;
    procedure UpdateOption(AIDBodyVariation: Integer; AOptionIDArr:
        TArray<Integer>);
    property IDBodyOption: TField read GetIDBodyOption;
    property IDBodyVariation: TField read GetIDBodyVariation;
    { Public declarations }
  end;

implementation

uses
  StrHelper, System.Generics.Collections;

{$R *.dfm}

function TQueryBodyVariationOption.GetIDBodyOption: TField;
begin
  Result := Field('IDBodyOption');
end;

function TQueryBodyVariationOption.GetIDBodyVariation: TField;
begin
  Result := Field('IDBodyVariation');
end;

function TQueryBodyVariationOption.SearchByIDBodyVariation(AIDBodyVariation : Integer):
    Integer;
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

procedure TQueryBodyVariationOption.UpdateOption(AIDBodyVariation: Integer;
    AOptionIDArr: TArray<Integer>);
var
  i: Integer;
begin
  SearchByIDBodyVariation(AIDBodyVariation);

  // Сначала удалим всё лишнее

  TArray.Sort<Integer>(AOptionIDArr);
  FDQuery.First;
  while not FDQuery.Eof do
  begin
    // Ищем в массиве такого кода нет - нужно удалить его из БД
    if not TArray.BinarySearch(AOptionIDArr, IDBodyOption.AsInteger, i) then
      FDQuery.Delete
    else
      FDQuery.Next;
  end;

  // Теперь добавим недостающее
  for i := Low(AOptionIDArr) to High(AOptionIDArr) do
  begin
    if not LocateByField(IDBodyOption.FieldName, AOptionIDArr[i], []) then
    begin
      TryAppend;
      IDBodyVariation.AsInteger := AIDBodyVariation;
      IDBodyOption.AsInteger := AOptionIDArr[i];
      TryPost;
    end;
  end;
end;

end.
