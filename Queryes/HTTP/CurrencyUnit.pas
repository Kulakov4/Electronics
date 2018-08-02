unit CurrencyUnit;

interface

uses
  CurrencyInterface, System.Classes, System.Generics.Collections;

type
  TMyCurrency = class(TObject, ICurrency)
  strict private
  private
    class var Instance: TMyCurrency;

  var
    FDictionary: TDictionary<Cardinal, Double>;
    FRefCount: Integer;
    function GetKey(CurrencyID: Integer; ADate: TDateTime): Cardinal;
  public
    constructor Create;
    destructor Destroy; override;
    function GetCourses(CurrencyID: Integer; ADate: TDateTime): Double; stdcall;
    class function NewInstance: TObject; override;
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
  end;

implementation

uses
  System.SysUtils, HttpUnit, Winapi.Windows, System.Contnrs;

var
  SingletonList: TObjectList;

constructor TMyCurrency.Create;
begin
  if FDictionary <> nil then
    Exit;

  FDictionary := TDictionary<Cardinal, Double>.Create;
end;

destructor TMyCurrency.Destroy;
begin
  FreeAndNil(FDictionary);
  inherited;
end;

function TMyCurrency.GetCourses(CurrencyID: Integer; ADate: TDateTime): Double;
var
  ACources: TArray<Double>;
  Key: Cardinal;
begin
  Assert((CurrencyID >= 2) and (CurrencyID <= 3));
  Key := GetKey(CurrencyID, ADate);
  if not FDictionary.ContainsKey(Key) then
  begin
    // Пытаемся получить курс доллара и евро с сайта
    ACources := TCBRHttp.GetCourses(['Доллар США', 'Евро'], ADate);

    // Запоминаем курс доллара на дату
    FDictionary.Add(GetKey(2, ADate), ACources[0]);
    // Запоминаем курс евро на дату
    FDictionary.Add(GetKey(3, ADate), ACources[1]);
  end;

  Result := FDictionary[Key];
end;

function TMyCurrency.GetKey(CurrencyID: Integer; ADate: TDateTime): Cardinal;
Var
  Day: Word;
  Month: Word;
  Year: Word;
begin
  DecodeDate(ADate, Year, Month, Day);
  Result := CurrencyID * 1000000000 + Year * 10000 + Month * 100 + Day;
end;

class function TMyCurrency.NewInstance: TObject;
begin
  if not Assigned(Instance) then
  begin
    Instance := TMyCurrency(inherited NewInstance);
    SingletonList.Add(Instance);
  end;

  Result := Instance;
end;

function TMyCurrency.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;
end;

function TMyCurrency._AddRef: Integer;
begin
  Result := InterlockedIncrement(FRefCount);
end;

function TMyCurrency._Release: Integer;
begin
  Result := InterlockedDecrement(FRefCount);
//  Пусть синлтон существует, даже если на него нет ни одной ссылки
//  if Result = 0 then
//    Destroy;
end;

initialization

SingletonList := TObjectList.Create(True);

finalization

FreeAndNil(SingletonList);

end.
