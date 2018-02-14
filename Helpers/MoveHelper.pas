unit MoveHelper;

interface

uses
  System.Generics.Collections, System.Generics.Defaults, System.SysUtils;

type
  TMoveHelper = class(TObject)
  private
  public
    class function Move(AArray: TArray<TPair<Integer, Integer>>; AUp: Boolean;
        ACount: Integer): TArray<TPair<Integer, Integer>>; static;
  end;

implementation

uses
  System.Math;

class function TMoveHelper.Move(AArray: TArray<TPair<Integer, Integer>>; AUp:
    Boolean; ACount: Integer): TArray<TPair<Integer, Integer>>;
var
  Coef: Integer;
  AComparer: IComparer<TPair<Integer, Integer>>;
  ATargetCount: Integer;
  I: Integer;
  J: Integer;
  L: TList<TPair<Integer, Integer>>;
begin
  Assert(ACount > 0);
  ATargetCount := Length(AArray) - ACount;
  Assert(ATargetCount > 0);

  Coef := IfThen(AUp, 1, -1);
  // Сортируем по возрастанию или убыванию
  AComparer := TComparer < TPair < Integer, Integer >>.Construct(
    function(const Left, Right: TPair<Integer, Integer>): Integer
    begin
      Result := 0;
      if Left.Value < Right.Value then
        Result := -1 * Coef
      else if Left.Value > Right.Value then
        Result := Coef;
    end);

  TArray.Sort < TPair < Integer, Integer >> (AArray, AComparer);

  // Готовимся к перестановке записей

  L := TList < TPair < Integer, Integer >>.Create;
  try
    {
      // 1) Меняем порядок на противоположный
      for I := 0 to ATargetCount - 1 do
      L.Add(TPair<Integer, Integer>.Create(AArray[I].Key, -AArray[I].Value));
    }
    // 2) Сдвигаем записи вверх (вниз)
    J := 0;
    for I := ATargetCount to Length(AArray) - 1 do
    begin
      Assert(J < Length(AArray));
      L.Add(TPair<Integer, Integer>.Create(AArray[I].Key, AArray[J].Value));
      Inc(J);
    end;
    // 3) сдвигаем записи на освободившееся место
    for I := 0 to ATargetCount - 1 do
    begin
      Assert(J < Length(AArray));
      L.Add(TPair<Integer, Integer>.Create(AArray[I].Key, AArray[J].Value));
      Inc(J);
    end;
    Result := L.ToArray;
  finally
    FreeAndNil(L);
  end;

end;

end.
