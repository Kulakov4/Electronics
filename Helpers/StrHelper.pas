unit StrHelper;

interface

function DeleteDouble(const S: string; const AChar: Char): String;
function Contain(const SubStr: String; const S: String; const ADelimiter: Char =
    ','): Boolean;
function GetRelativeFileName(const AFullFileName, ARootDir: string): string;
function Replace(const S: String; const ANewValue: String; const AMark: String; const AEndChar: Char = #13): string;
// Разбивает строку на строку и число
function MySplit(const S: string; var S0: String; var S1: Integer; var S2:
    String; var S3: Integer; var S4: string; var S5: Integer): Boolean;

implementation

uses System.SysUtils, System.RegularExpressions;

function Replace(const S: String; const ANewValue: String; const AMark: String; const AEndChar: Char): string;
var
  i: Integer;
  j: Integer;
begin
  Assert(not S.IsEmpty);
//  Assert(not ANewValue.IsEmpty);
  Assert(not AMark.IsEmpty);

  // Ищем место в SQL запросе
  i := s.IndexOf(AMark);
  Assert(i > 0);
  j := s.IndexOf(AEndChar, i);
  Assert(j > 0);

  Result := s.Substring(0, i) + ANewValue + s.Substring(j);
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

  Result := AFullFileName.Substring( i + S.Length);
end;

function Contain(const SubStr: String; const S: String; const ADelimiter: Char =
    ','): Boolean;
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
function MySplit(const S: string; var S0: String; var S1: Integer; var S2:
    String; var S3: Integer; var S4: string; var S5: Integer): Boolean;
Var

  M: TMatchCollection;
  Pattern: string;
  RegEx: TRegEx;
begin
  Result := False;
  if S.Trim.IsEmpty then
    Exit;

  Pattern := '^([\D]*)([\d]*)([\D]*)([\d]*)([\D]*)([\d]*)$';
  RegEx:=TRegEx.Create(Pattern);
  // Проверяем, соответствует ли строка шаблону
  if RegEx.IsMatch(S) then
  begin
    M:=RegEx.Matches(S, Pattern); //получаем коллекцию совпадений
    // Должно быть ровно одно совпадение
    Assert(M.Count = 1);
    // Должно быть ровно 7 группы
    Assert(M.Item[0].Groups.Count = 7);

    S0 := M.Item[0].Groups[1].Value;
    S1 := M.Item[0].Groups[2].Value.ToInteger();
    S2 := M.Item[0].Groups[1].Value;
    S3 := M.Item[0].Groups[2].Value.ToInteger();
    S4 := M.Item[0].Groups[1].Value;
    S5 := M.Item[0].Groups[2].Value.ToInteger();
    Result := True;
  end;

end;

end.
