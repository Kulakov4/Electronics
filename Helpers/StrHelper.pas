unit StrHelper;

interface

uses System.Generics.Collections;

Type
  TMySplit = class
    S: String;
    X: String;
  public
    constructor Create(SS, XX: String);
  end;

function NameForm(X: Integer; const s1: String; const s2: String;
  const s5: String): String;
function DeleteDouble(const S: string; const AChar: Char): String;
function Contain(const SubStr: String; const S: String;
  const ADelimiter: Char = ','): Boolean;
function GetRelativeFileName(const AFullFileName, ARootDir: string): string;
function Replace(const S: String; const ANewValue: String; const AMark: String;
  const AEndChar: Char = #13): string;
// Разбивает строку на строку и число
function MySplit(const S: string): TList<TMySplit>;

function GetWords(const S: String): String;
function ReplaceNotKeyboadChars(const S: String): String;

implementation

uses System.SysUtils, System.RegularExpressions;

function NameForm(X: Integer; const s1: String; const s2: String;
  const s5: String): String;
var
  d: Integer;
begin
  d := X mod 100;
  if (d >= 10) and (d <= 20) then
  begin
    Result := s5;
    Exit;
  end;

  d := X mod 10;
  if d = 1 then
    Result := s1
  else if (d >= 2) and (d <= 4) then
    Result := s2
  else
    Result := s5;
end;

function GetWords(const S: String): String;
var
  m: TArray<String>;
  s2: string;
  s1: string;
begin
  Result := '';
  s1 := S.Trim();

  m := s1.Split([' ', '/', '-']);

  for s1 in m do
  begin
    s2 := s1.Trim;
    if s2.IsEmpty then
      Continue;
    Result := Format('%s'#13'%s', [Result, s2]);
  end;
  Result := Result.Trim([#13]);
end;

function ReplaceNotKeyboadChars(const S: String): String;
begin
  Result := S.Replace(chr($02C2), '<');
  Result := Result.Replace(chr($02C3), '>');
end;

function Replace(const S: String; const ANewValue: String; const AMark: String;
  const AEndChar: Char): string;
var
  i: Integer;
  j: Integer;
begin
  Assert(not S.IsEmpty);
  // Assert(not ANewValue.IsEmpty);
  Assert(not AMark.IsEmpty);

  // Ищем место в SQL запросе
  i := S.IndexOf(AMark);
  Assert(i > 0);
  j := S.IndexOf(AEndChar, i);

  // если конечного символа не нашли, то меняем до конца строки
  if j < 0 then
    j := S.Length;

  Result := S.Substring(0, i) + ANewValue + S.Substring(j);
end;

function GetRelativeFileName(const AFullFileName, ARootDir: string): string;
var
  i: Integer;
  S: String;
begin
  Assert(not AFullFileName.IsEmpty);
  Assert(not ARootDir.IsEmpty);

  S := ARootDir.Trim(['\']) + '\';

  // Ищем корневую папку в полном пути к файлу
  i := AFullFileName.IndexOf(S);
  Assert(i >= 0);

  Result := AFullFileName.Substring(i + S.Length);
end;

function Contain(const SubStr: String; const S: String;
  const ADelimiter: Char = ','): Boolean;
var
  s1: string;
  s2: string;
begin
  s1 := Format('%s%s%s', [ADelimiter, S.Trim([ADelimiter]), ADelimiter]);
  s2 := Format('%s%s%s', [ADelimiter, SubStr.Trim([ADelimiter]), ADelimiter]);
  Result := s1.IndexOf(s2) >= 0;
end;

function DeleteDouble(const S: string; const AChar: Char): String;
var
  s1: String;
  s2: String;
  SS: string;
begin
  Assert(AChar <> #0);
  s1 := String.Create(AChar, 1);
  s2 := String.Create(AChar, 2);

  Result := S;
  repeat
    SS := Result;
    Result := SS.Replace(s2, s1, [rfReplaceAll]);
  until Result = SS;
end;

// Разбивает строку на строку и число
function MySplit(const S: string): TList<TMySplit>;
Var
  i: Integer;

  m: TMatchCollection;
  Pattern: string;
  RegEx: TRegEx;
begin
  Result := nil;
  if S.Trim.IsEmpty then
    Exit;

  Pattern := '([\D]*)([\d]*)';
  RegEx := TRegEx.Create(Pattern);
  // Проверяем, соответствует ли строка шаблону
  if RegEx.IsMatch(S) then
  begin
    m := RegEx.Matches(S, Pattern); // получаем коллекцию совпадений
    // Должно быть минимум одно совпадение
    Assert(m.Count >= 1);

    Result := TList<TMySplit>.Create;
    for i := 0 to m.Count - 1 do
    begin
      // Должно быть ровно 3 группы
      Assert(m.Item[i].Groups.Count = 3);
      // В первую группу попадает всё совпадение
      Result.Add(TMySplit.Create(m.Item[i].Groups[1].Value,
        m.Item[i].Groups[2].Value));
    end;
  end;
end;

constructor TMySplit.Create(SS, XX: String);
begin
  S := SS;
  X := XX;
end;

end.
