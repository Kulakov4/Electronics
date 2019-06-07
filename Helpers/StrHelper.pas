unit StrHelper;

interface

uses System.Generics.Collections;

Type

  TMySplitRec = record
    BracketInBalance: Boolean;
    StringArray: TArray<String>;
  end;

  TBracket = class
  public
    LeftBracket: Char;
    RightBracket: Char;
    constructor Create(ALeftBracket, ARightBracket: Char);
  end;

  TBracketList = class(TObjectList<TBracket>)
  public
    function IsLeftBracket(AChar: Char): TBracket;
    function IsRightBracket(AChar: Char): TBracket;
  end;

function NameForm(X: Integer; const s1: String; const s2: String;
  const s5: String): String;
function DeleteDouble(const S: string; const AChar: Char): String;
function Contain(const SubStr: String; const S: String;
  const ADelimiter: Char = ','): Boolean;
function GetRelativeFileName(const AFullFileName, ARootDir: string): string;
// ��������� ������ � ������ ����, ��� ����������� ����� ��������� � �������
function MySplit(const S: string; ADelimiter: Char): TMySplitRec;
function ReplaceInSQL(const ASQL: String; const AStipulation: String;
  ANumber: Integer): String;

function GetWords(const S: String): String;
function ReplaceNotKeyboadChars(const S: String): String;

implementation

uses System.SysUtils, System.RegularExpressions;

Var
  ABracketList: TBracketList;

function ReplaceInSQL(const ASQL: String; const AStipulation: String;
  ANumber: Integer): String;
var
  ATemplate: string;
  lp: Integer;
  p: Integer;
begin
  Assert(not ASQL.IsEmpty);
  Assert(not AStipulation.IsEmpty);

  ATemplate := Format('%d=%d', [ANumber, ANumber]);
  p := ASQL.IndexOf(ATemplate);
  Assert(p >= 0);
  lp := ASQL.LastIndexOf(ATemplate);
  // ������ ���� ��������� !
  Assert(lp = p);

  Result := ASQL.Replace(ATemplate, AStipulation);
end;

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

// ��������� ������ � ������ ����, ��� ����������� ����� ��������� � �������
function MySplit(const S: string; ADelimiter: Char): TMySplitRec;
var
  ch: Char;
  i: Integer;
  Brackets: String;
  ABracket: TBracket;
  AList: TList<String>;
  Str: string;
  SubStr: string;
begin
  Assert(ABracketList <> nil);

  Result.BracketInBalance := False;

  Str := S;

  AList := TList<String>.Create;
  try
    Brackets := '';

    i := 0;
    while i < Str.Length do
    begin
      ch := Str.Chars[i];
      // ����� �� ��������� ����� ������?
      ABracket := ABracketList.IsLeftBracket(ch);
      if ABracket <> nil then
        Brackets := Brackets + ch
      else
      begin
        // ����� �� ��������� ������ ������?
        ABracket := ABracketList.IsRightBracket(ch);
        if ABracket <> nil then
        begin
          // ���� ������ �� � �������
          if (Brackets.Length = 0) or
            (Brackets.Chars[Brackets.Length - 1] <> ABracket.LeftBracket) then
            Exit;

          // ������� ��������� �������� ������ �� ������
          Brackets := Brackets.Substring(0, Brackets.Length - 1);
        end;
      end;

      // ���� ��������� ������ - ��� ����������� � ��� ������ ���������
      if (ch = ADelimiter) and (Brackets.Length = 0) then
      begin
        SubStr := Str.Substring(0, i).Trim;
        if SubStr.Length > 0 then
          AList.Add(SubStr);

        Str := Str.Substring(i + 1);
        i := 0;
      end
      else
        Inc(i);
    end;

    // ���� �� ��� �������� ������ ���������
    if Brackets.Length > 0 then
      Exit;

    SubStr := Str.Trim;
    // ��������� ������� � ������� �� ������� ������������
    if SubStr.Length > 0 then
      AList.Add(SubStr);

    Result.StringArray := AList.ToArray;
    Result.BracketInBalance := True;
  finally
    FreeAndNil(AList);
  end;
end;

constructor TBracket.Create(ALeftBracket, ARightBracket: Char);
begin
  LeftBracket := ALeftBracket;
  RightBracket := ARightBracket;
end;

function TBracketList.IsLeftBracket(AChar: Char): TBracket;
begin
  for Result in Self do
  begin
    if Result.LeftBracket = AChar then
      Exit;
  end;

  Result := nil;
end;

function TBracketList.IsRightBracket(AChar: Char): TBracket;
begin
  for Result in Self do
  begin
    if Result.RightBracket = AChar then
      Exit;
  end;

  Result := nil;
end;

initialization

ABracketList := TBracketList.Create;
ABracketList.Add(TBracket.Create('(', ')'));
ABracketList.Add(TBracket.Create('{', '}'));
ABracketList.Add(TBracket.Create('[', ']'));

finalization

FreeAndNil(ABracketList);

end.
