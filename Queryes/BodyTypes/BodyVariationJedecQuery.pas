unit BodyVariationJedecQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, DSWrap;

type
  TBodyVariationJedecW = class(TDSWrap)
  private
    FIDBodyVariation: TFieldWrap;
    FIDJEDEC: TFieldWrap;
    FID: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    property IDBodyVariation: TFieldWrap read FIDBodyVariation;
    property IDJEDEC: TFieldWrap read FIDJEDEC;
    property ID: TFieldWrap read FID;
  end;

  TQueryBodyVariationJedec = class(TQueryBase)
  private
    FW: TBodyVariationJedecW;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    function SearchByIDJEDEC(AIDBodyVariation, AIDJEDEC: Integer;
      TestResult: Integer = -1): Integer;
    function SearchByIDBodyVariation(AIDBodyVariation: Integer): Integer;
    procedure UpdateJEDEC(AIDBodyVariation: Integer;
      AJedecIDArr: TArray<Integer>);
    property W: TBodyVariationJedecW read FW;
    { Public declarations }
  end;

implementation

uses
  StrHelper, System.Generics.Collections;

{$R *.dfm}

constructor TQueryBodyVariationJedec.Create(AOwner: TComponent);
begin
  inherited;
  FW := TBodyVariationJedecW.Create(FDQuery);
end;

function TQueryBodyVariationJedec.SearchByIDJEDEC(AIDBodyVariation,
  AIDJEDEC: Integer; TestResult: Integer = -1): Integer;
var
  AFieldName1: string;
  AFieldName2: string;
begin
  Assert(AIDBodyVariation > 0);
  Assert(AIDJEDEC > 0);

  // Ищем
  Result := SearchEx([TParamRec.Create(W.IDBodyVariation.FieldName,
    AIDBodyVariation), TParamRec.Create(W.IDJEDEC.FieldName, AIDJEDEC)],
    TestResult);
end;

function TQueryBodyVariationJedec.SearchByIDBodyVariation(AIDBodyVariation
  : Integer): Integer;
var
  AFieldName: string;
begin
  Assert(AIDBodyVariation > 0);

  // Ищем
  Result := SearchEx([TParamRec.Create(W.IDBodyVariation.FieldName,
    AIDBodyVariation)]);
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
    // Если в массиве такого кода нет - нужно удалить его из БД
    if not TArray.BinarySearch(AJedecIDArr, W.IDJEDEC.F.AsInteger, i) then
      FDQuery.Delete
    else
      FDQuery.Next;
  end;

  // Теперь добавим недостающее
  for i := Low(AJedecIDArr) to High(AJedecIDArr) do
  begin
    if not LocateByField(W.IDJEDEC.FieldName, AJedecIDArr[i], []) then
    begin
      W.TryAppend;
      W.IDBodyVariation.F.AsInteger := AIDBodyVariation;
      W.IDJEDEC.F.AsInteger := AJedecIDArr[i];
      W.TryPost;
    end;
  end;
end;

constructor TBodyVariationJedecW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'ID', '', True);
  FIDBodyVariation := TFieldWrap.Create(Self, 'IDBodyVariation');
  FIDJEDEC := TFieldWrap.Create(Self, 'IDJEDEC');
end;

end.
