unit StrHelper;

interface

function DeleteDoubleSpace(const S: string): String;
function Contain(const SubStr: String; const S: String; const ADelimiter: Char =
    ','): Boolean;
function GetRelativeFileName(const AFullFileName, ARootDir: string): string;
function Replace(const S: String; const ANewValue: String; const AMark: String; const AEndChar: Char = #13): string;

implementation

uses System.SysUtils;

function Replace(const S: String; const ANewValue: String; const AMark: String; const AEndChar: Char): string;
var
  i: Integer;
  j: Integer;
begin
  Assert(not S.IsEmpty);
  Assert(not ANewValue.IsEmpty);
  Assert(not AMark.IsEmpty);

  // »щем место в SQL запросе
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

  // »щем корневую папку в полном пути к файлу
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

function DeleteDoubleSpace(const S: string): String;
var
  SS: string;
begin
  Result := S;
  repeat
    SS := Result;
    Result := SS.Replace('  ', ' ', [rfReplaceAll]);
  until Result = SS;
end;

end.
