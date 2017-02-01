unit StrHelper;

interface

function DeleteDoubleSpace(const S: string): String;
function Contain(const SubStr: String; const S: String; const ADelimiter: Char =
    ','): Boolean;
function GetRelativeFileName(const AFullFileName, ARootDir: string): string;

implementation

uses System.SysUtils;

function GetRelativeFileName(const AFullFileName, ARootDir: string): string;
var
  i: Integer;
  S: String;
begin
  Assert(not AFullFileName.IsEmpty);
  Assert(not ARootDir.IsEmpty);

  S := ARootDir.Trim(['\']) + '\';

  // ���� �������� ����� � ������ ���� � �����
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
