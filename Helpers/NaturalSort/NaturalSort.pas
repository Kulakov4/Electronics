unit NaturalSort;

interface

uses System.Generics.Defaults, System.SysUtils, System.Character;

type
  TNaturalStringComparer = class(TComparer<String>)
  private
    function InChunk(Ch, OtherCh: Char): Boolean;
  public
    function Compare(const Left, Right: String): Integer; override;
  end;

implementation

type
  TChunkType = (Alphanumeric, Numeric);

  // var
  // FS: TFormatSettings := TFormatSettings.Create;

function TNaturalStringComparer.Compare(const Left, Right: String): Integer;
Var
  FS: TFormatSettings;
  s: string;
  s1: String;
  s2: string;
  thatCh: Char;
  thatChunk: TStringBuilder;
  thatMarker: Integer;
  thatNumericChunk: Integer;
  thisCh: Char;
  thisChunk: TStringBuilder;
  thisMarker: Integer;
  thisNumericChunk: Integer;
  x1: Double;
  x2: Double;
begin
  s1 := Left;
  s2 := Right;

  FS := TFormatSettings.Create;

  // Меняем точку на правильный разделитель целой и дробной части
  s := s1.Replace('.', FS.DecimalSeparator);

  // Возможно мы имеем дело с числами
  x1 := StrToFloatDef(s, MaxInt);
  if x1 <> MaxInt then
  begin
    // Меняем точку на правильный разделитель целой и дробной части
    s := s2.Replace('.', FS.DecimalSeparator);
    x2 := StrToFloatDef(s, MaxInt);
    if x2 <> MaxInt then
    begin
      if x1 = x2 then
        Result := 0
      else if x1 > x2 then
        Result := 1
      else
        Result := -1;
      Exit;
    end;
  end;

  Result := 0;

  thisMarker := 0;
  // thisNumericChunk := 0;
  thatMarker := 0;
  // thatNumericChunk := 0;

  thisChunk := TStringBuilder.Create;
  thatChunk := TStringBuilder.Create;
  try

    while ((thisMarker < s1.Length) or (thatMarker < s2.Length)) do
    begin
      if (thisMarker >= s1.Length) then
      begin
        Result := -1;
        Exit;
      end
      else if (thatMarker >= s2.Length) then
      begin
        Result := 1;
        Exit;
      end;
      thisCh := s1.Chars[thisMarker];
      thatCh := s2.Chars[thatMarker];

      thisChunk.Clear;
      thatChunk.Clear;

      while (thisMarker < s1.Length) AND
        ((thisChunk.Length = 0) OR InChunk(thisCh, thisChunk[0])) do
      begin
        thisChunk.Append(thisCh);
        Inc(thisMarker);

        if (thisMarker < s1.Length) then
        begin
          thisCh := s1.Chars[thisMarker];
        end;
      end;

      while (thatMarker < s2.Length) AND
        ((thatChunk.Length = 0) OR InChunk(thatCh, thatChunk[0])) do
      begin
        thatChunk.Append(thatCh);
        Inc(thatMarker);

        if (thatMarker < s2.Length) then
        begin
          thatCh := s2.Chars[thatMarker];
        end;
      end;

      Result := 0;

      // If both chunks contain numeric characters, sort them numerically
      if thisChunk[0].IsDigit AND thatChunk[0].IsDigit then
      begin
        thisNumericChunk := thisChunk.ToString.ToInteger;
        thatNumericChunk := thatChunk.ToString.ToInteger;

        if (thisNumericChunk < thatNumericChunk) then
        begin
          Result := -1;
        end;

        if (thisNumericChunk > thatNumericChunk) then
        begin
          Result := 1;
        end;
      end
      else
      begin
        Result := thisChunk.ToString().CompareTo(thatChunk.ToString());
      end;

      if (Result <> 0) then
      begin
        Exit;
      end;
    end;
  finally
    FreeAndNil(thisChunk);
    FreeAndNil(thatChunk);
  end;
end;

function TNaturalStringComparer.InChunk(Ch, OtherCh: Char): Boolean;
var
  AType: TChunkType;
begin
  AType := Alphanumeric;

  if OtherCh.IsDigit then
  begin
    AType := Numeric;
  end;

  Result := not(((AType = Alphanumeric) AND Ch.IsDigit) OR
    ((AType = Numeric) AND not Ch.IsDigit))
end;

end.
