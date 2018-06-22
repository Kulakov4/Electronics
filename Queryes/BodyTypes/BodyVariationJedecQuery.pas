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
    function SearchByIDJEDEC(AIDBodyVariation, AIDJEDEC: Integer; TestResult:
        Integer = -1): Integer;
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
  Result := Field('IDJEDEC');
end;

function TQueryBodyVariationJedec.SearchByIDJEDEC(AIDBodyVariation, AIDJEDEC:
    Integer; TestResult: Integer = -1): Integer;
var
  AFieldName1: string;
  AFieldName2: string;
begin
  Assert(AIDBodyVariation > 0);
  Assert(AIDJEDEC > 0);

  // ����� ����� ���� ��� �� ������, ��� ���� �� ��������
  AFieldName1 := 'IDBodyVariation';
  AFieldName2 := 'IDJEDEC';

  // ������ � ������� �������
  FDQuery.SQL.Text := Replace(FDQuery.SQL.Text,
    Format('where (%s = :%s) and (%s = :%s)', [AFieldName1, AFieldName1,
    AFieldName2, AFieldName2]
    ), 'where');
  SetParamType(AFieldName1);
  SetParamType(AFieldName2);

  // ����
  Result := Search([AFieldName1, AFieldName2], [AIDBodyVariation, AIDJEDEC]);

  if TestResult <> -1 then
    Assert(Result = TestResult);
  
end;

function TQueryBodyVariationJedec.SearchByIDBodyVariation(AIDBodyVariation:
    Integer): Integer;
var
  AFieldName: string;
begin
  Assert(AIDBodyVariation > 0);
  // ����� ����� ���� ��� �� ������, ��� ���� �� ��������
  AFieldName := 'IDBodyVariation';

  // ������ � ������� �������
  FDQuery.SQL.Text := Replace(FDQuery.SQL.Text, Format('where %s = :%s',
    [AFieldName, AFieldName]), 'where');
  SetParamType(AFieldName);

  // ����
  Result := Search([AFieldName], [AIDBodyVariation]);
end;

procedure TQueryBodyVariationJedec.UpdateJEDEC(AIDBodyVariation: Integer;
  AJedecIDArr: TArray<Integer>);
var
  i: Integer;
begin
  SearchByIDBodyVariation(AIDBodyVariation);

  // ������� ������ �� ������

  TArray.Sort<Integer>(AJedecIDArr);
  FDQuery.First;
  while not FDQuery.Eof do
  begin
    // ���� � ������� ������ ���� ��� - ����� ������� ��� �� ��
    if not TArray.BinarySearch(AJedecIDArr, IDJEDEC.AsInteger, i) then
      FDQuery.Delete
    else
      FDQuery.Next;
  end;

  // ������ ������� �����������
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
