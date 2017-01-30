unit StrHelper;

interface

function DeleteDoubleSpace(const S: string): String;

implementation

uses System.SysUtils;

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
