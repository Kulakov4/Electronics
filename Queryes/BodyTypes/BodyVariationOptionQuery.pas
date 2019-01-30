unit BodyVariationOptionQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, DSWrap;

type
  TBodyVariationOptionW = class(TDSWrap)
  private
    FIDBodyOption: TFieldWrap;
    FID: TFieldWrap;
    FIDBodyVariation: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    property IDBodyOption: TFieldWrap read FIDBodyOption;
    property ID: TFieldWrap read FID;
    property IDBodyVariation: TFieldWrap read FIDBodyVariation;
  end;

  TQueryBodyVariationOption = class(TQueryBase)
  private
    FW: TBodyVariationOptionW;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    function SearchByIDBodyVariation(AIDBodyVariation: Integer): Integer;
    procedure UpdateOption(AIDBodyVariation: Integer; AOptionIDArr:
        TArray<Integer>);
    property W: TBodyVariationOptionW read FW;
    { Public declarations }
  end;

implementation

uses
  StrHelper, System.Generics.Collections;

{$R *.dfm}

constructor TQueryBodyVariationOption.Create(AOwner: TComponent);
begin
  inherited;
  FW := TBodyVariationOptionW.Create(FDQuery);
end;

function TQueryBodyVariationOption.SearchByIDBodyVariation(AIDBodyVariation : Integer):
    Integer;
begin
  Assert(AIDBodyVariation > 0);

  // Ищем
  Result := SearchEx([TParamRec.Create(W.IDBodyVariation.FullName,
    AIDBodyVariation)]);
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
    if not TArray.BinarySearch(AOptionIDArr, W.IDBodyOption.F.AsInteger, i) then
      FDQuery.Delete
    else
      FDQuery.Next;
  end;

  // Теперь добавим недостающее
  for i := Low(AOptionIDArr) to High(AOptionIDArr) do
  begin
    if not LocateByField(W.IDBodyOption.FieldName, AOptionIDArr[i], []) then
    begin
      W.TryAppend;
      W.IDBodyVariation.F.AsInteger := AIDBodyVariation;
      W.IDBodyOption.F.AsInteger := AOptionIDArr[i];
      W.TryPost;
    end;
  end;
end;

constructor TBodyVariationOptionW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'ID', '', True);
  FIDBodyOption := TFieldWrap.Create(Self, 'IDBodyOption');
  FIDBodyVariation := TFieldWrap.Create(Self, 'IDBodyVariation');
end;

end.
