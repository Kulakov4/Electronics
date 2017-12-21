unit ProtectUnit;

interface

uses
  System.SysUtils, System.Win.Registry, Winapi.Windows, System.DateUtils,
  Soap.EncdDecd;

type
  TProtect = class(TObject)
  private
    class var Instance: TProtect;
  protected
    function CreateKey(ADate1, ADate2: TDateTime; AOldKey: String = '')
      : Boolean;
    function DecodeDate(const Str: String;
      var ADate1, ADate2: TDateTime): Boolean;
    function DropKey(const AKey: String): Boolean;
    function EncodeDate(ADate1, ADate2: TDateTime): String;
    function SearchKey: String;
  public
    class function NewInstance: TObject; override;
    function Check: Boolean;
    function Unlock: Boolean;
  end;

implementation

uses
  System.Classes;

const
  d1: Integer = 0;
  d2: Integer = 0;
  KEYPATH: String = 'SOFTWARE\{A6B78162-D43E-4867-B931-A68BC7075C2E}';
  MYKEY: String = 'XPT_CE2.Interop.';
  DemoDays: Integer = 30;

function TProtect.DecodeDate(const Str: String;
  var ADate1, ADate2: TDateTime): Boolean;
var
  m: TArray<String>;
  S: String;
begin
  Result := False;
  if Str.IsEmpty then
    Exit;
  S := DecodeString(Str);
  m := S.Split(['_']);
  if Length(m) <> 2 then
    Exit;
  try
    ADate1 := StrToDateTime(m[0]);
    ADate2 := StrToDateTime(m[1]);
    Result := True;
  except
    ;
  end;
end;

function TProtect.EncodeDate(ADate1, ADate2: TDateTime): String;
var
  S: string;
begin
  S := Format('%s_%s', [DateTimeToStr(ADate1), DateTimeToStr(ADate2)]);
  Result := EncodeString(S);
end;

class function TProtect.NewInstance: TObject;
begin
  if not Assigned(Instance) then
    Instance := TProtect(inherited NewInstance);

  Result := Instance;
end;

function TProtect.Check: Boolean;
var
  ADate1: TDateTime;
  ADate2: TDateTime;
  S: string;
  AKeyName: string;
  ANow: TDateTime;
  x: Integer;
begin
  AKeyName := SearchKey;

  // Такого ключа вообще нет - считаем что программа загрузилась впервые
  if AKeyName.IsEmpty then
  begin
    Result := CreateKey(Now, Now);
  end
  else
  begin
    // Получаем хвостик ключа
    S := AKeyName.Substring(MYKEY.Length);
    // Декодируем даты
    Result := DecodeDate(S, ADate1, ADate2);
    if not Result then
      Exit;

    ADate1 := ADate1 - d1;
    ADate2 := ADate2 - d2;

    ANow := Now;

    // Текущая дата должна быть больше чем дата первого и последнео запуска
    Result := (ADate1 < ANow) and (ADate2 < ANow);
    if not Result then
      Exit;

    //x := MinutesBetween(ADate1, ANow);
    x := DaysBetween(ADate1, ANow);

    Result := x < DemoDays;
    if not Result then
      Exit;

    Result := CreateKey(ADate1, ANow, AKeyName);
  end;

end;

function TProtect.CreateKey(ADate1, ADate2: TDateTime;
  AOldKey: String = ''): Boolean;
var
  AKeyName: string;
  r: TRegistry;
  S: String;
begin
  ADate1 := ADate1 + d1;
  ADate2 := ADate2 + d2;
  S := EncodeDate(ADate1, ADate2);
  // Формируем имя ключа
  AKeyName := Format('%s\%s%s', [KEYPATH, MYKEY, S]);
  r := TRegistry.Create(KEY_WRITE OR KEY_WOW64_64KEY);
  try
    r.RootKey := HKEY_CURRENT_USER;
    Result := r.CreateKey(AKeyName);
    if not Result then
      Exit;

    if not AOldKey.IsEmpty then
    begin
      AKeyName := Format('%s\%s', [KEYPATH, AOldKey]);
      // Удаляем из реестра старый ключ
      Result := r.DeleteKey(AKeyName);
    end;

  finally
    FreeAndNil(r);
  end;
end;

function TProtect.DropKey(const AKey: String): Boolean;
var
  AKeyName: string;
  r: TRegistry;
begin
  Result := False;
  r := TRegistry.Create(KEY_WRITE OR KEY_WOW64_64KEY);
  try
    r.RootKey := HKEY_CURRENT_USER;

    AKeyName := Format('%s\%s', [KEYPATH, AKey]);
    // Удаляем из реестра старый ключ
    Result := r.DeleteKey(AKeyName);
  finally
    FreeAndNil(r);
  end;

end;

function TProtect.SearchKey: String;
var
  ASL: TStringList;
  r: TRegistry;
  S: String;
begin
  Result := '';
  r := TRegistry.Create();
  try
    r.RootKey := HKEY_CURRENT_USER;
    if not r.OpenKeyReadOnly(KEYPATH) then
      Exit;
    ASL := TStringList.Create;
    try
      r.GetKeyNames(ASL);
      for S in ASL do
      begin
        if S.StartsWith(MYKEY) then
        begin
          Result := S;
          break;
        end;
      end;
    finally
      FreeAndNil(ASL);
    end;
  finally
    FreeAndNil(r);

  end;
end;

function TProtect.Unlock: Boolean;
var
  AKeyName: String;
begin
  AKeyName := SearchKey;

  Result :=  AKeyName.IsEmpty;
  if Result then
    Exit;

  Result := DropKey(AKeyName);
end;

end.
