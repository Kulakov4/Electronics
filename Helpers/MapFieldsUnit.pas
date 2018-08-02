unit MapFieldsUnit;

interface

uses System.Generics.Collections;

type
  TFieldsMap = class(TObject)
  private
    FMapDictionary: TDictionary<String, String>;
  public
    constructor Create(AFieldsMap: string);
    destructor Destroy; override;
    function Map(const ASourceFieldName: String): string;
  end;

implementation

uses System.SysUtils;

constructor TFieldsMap.Create(AFieldsMap: string);
var
  m: TArray<String>;
  m2: TArray<String>;
  S: string;
begin
  inherited Create;
  FMapDictionary := TDictionary<String, String>.Create;
  m := AFieldsMap.Split([';']);
  for S in m do
  begin
    m2 := S.Split(['->']);
    //  аждый переход пол€ состоит из двух названий полей
    Assert(Length(m2) = 2);
    // ƒобавл€ем переход в словарь
    FMapDictionary.Add(m2[0].ToUpper, m2[1].ToUpper);
  end;
end;

destructor TFieldsMap.Destroy;
begin
  inherited;
  FreeAndNil(FMapDictionary);
end;

function TFieldsMap.Map(const ASourceFieldName: String): string;
begin
  Assert(not ASourceFieldName.IsEmpty);
  Result := ASourceFieldName.ToUpper;
  if FMapDictionary.ContainsKey(Result) then
    Result := FMapDictionary[Result].ToUpper;
end;

end.
