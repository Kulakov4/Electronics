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

function DeleteDouble(const S: string; const AChar: Char): String;
function Contain(const SubStr: String; const S: String;
  const ADelimiter: Char = ','): Boolean;
function GetRelativeFileName(const AFullFileName, ARootDir: string): string;
function Replace(const S: String; const ANewValue: String; const AMark: String;
  const AEndChar: Char = #13): string;
// Разбивает строку на строку и число
function MySplit(const S: string): TList<TMySplit>;

implementation

uses System.SysUtils, System.RegularExpressions;

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
  Assert(j > 0);

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
  S1: string;
  S2: string;
begin
  S1 := Format('%s%s%s', [ADelimiter, S.Trim([ADelimiter]), ADelimiter]);
  S2 := Format('%s%s%s', [ADelimiter, SubStr.Trim([ADelimiter]), ADelimiter]);
  Result := S1.IndexOf(S2) >= 0;
end;

function DeleteDouble(const S: string; const AChar: Char): String;
var
  S1: String;
  S2: String;
  SS: string;
begin
  Assert(AChar <> #0);
  S1 := String.Create(AChar, 1);
  S2 := String.Create(AChar, 2);

  Result := S;
  repeat
    SS := Result;
    Result := SS.Replace(S2, S1, [rfReplaceAll]);
  until Result = SS;
end;

// Разбивает строку на строку и число
function MySplit(const S: string): TList<TMySplit>;
Var
  i: Integer;

  M: TMatchCollection;
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
    M := RegEx.Matches(S, Pattern); // получаем коллекцию совпадений
    // Должно быть минимум одно совпадение
    Assert(M.Count >= 1);

    Result := TList<TMySplit>.Create;
    for i := 0 to M.Count - 1 do
    begin
      // Должно быть ровно 3 группы
      Assert(M.Item[i].Groups.Count = 3);
      // В первую группу попадает всё совпадение
      Result.Add(TMySplit.Create(M.Item[i].Groups[1].Value,
        M.Item[i].Groups[2].Value));
    end;
  end;
end;

constructor TMySplit.Create(SS, XX: String);
begin
  S := SS;
  X := XX;
end;

end.
