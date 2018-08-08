unit HttpUnit;

interface

uses
  IdHTTP;

type
  TCBRHttp = class(TObject)
  public
    class function GetCourses(AValueNames: TArray<String>; ADate: TDateTime = 0)
      : TArray<Double>; static;
    class function ParseXML(const AXML: String; AValueNames: TArray<String>)
      : TArray<Double>; static;
  end;

implementation

uses
  System.Classes, System.SysUtils, Xml.XMLDoc, Xml.XMLIntf,
  System.Generics.Collections;

class function TCBRHttp.GetCourses(AValueNames: TArray<String>;
  ADate: TDateTime = 0): TArray<Double>;
var
  AidHttp: TIdHTTP;
  AURL: string;
  S: string;
begin
  Assert(Length(AValueNames) > 0);

  AURL := 'http://www.cbr.ru/scripts/XML_daily.asp';
  if ADate > 0 then
    AURL := AURL + Format('?date_req=%s',
      [FormatDateTime('dd/mm/yyyy', ADate)]);

  AidHttp := TIdHTTP.Create(nil);
  try
    AidHttp.HandleRedirects := True; // Чтобы сам обрабатывал перенаправление
    AidHttp.Request.UserAgent := 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0';
    S := AidHttp.Get(AURL);
  finally
    FreeAndNil(AidHttp);
  end;

  Result := ParseXML(S, AValueNames);
end;

class function TCBRHttp.ParseXML(const AXML: String;
  AValueNames: TArray<String>): TArray<Double>;
var
  ACources: TList<Double>;
  ANode: IXMLNode;
  ANominal: Integer;
  ARootNode: IXMLNode;
  AValues: TList<String>;
  AXMLDocument: IXMLDocument;
  i: Integer;
  k: Integer;
  S: String;
begin
  AValues := TList<String>.Create;
  ACources := TList<Double>.Create;
  try
    AValues.AddRange(AValueNames);
    for i := 0 to AValues.Count - 1 do
      ACources.Add(0);

    AXMLDocument := LoadXMLData(AXML); // TXMLDocument.Create(nil);

    ARootNode := AXMLDocument.DocumentElement;

    // Цикл по всем валютам
    for i := 0 to ARootNode.ChildNodes.Count - 1 do
    begin
      ANode := ARootNode.ChildNodes[i];

      S := ANode.ChildValues['Name'];

      // Ищем, нужна ли нам такая валюта
      k := AValues.IndexOf(S);
      if k = -1 then
        Continue;

      ANominal := StrToIntDef(ANode.ChildValues['Nominal'], 0);
      if ANominal = 0 then
        Continue;

      S := ANode.ChildValues['Value'];
      ACources[k] := StrToFloatDef(S, 0) / ANominal;
    end;

    Result := ACources.ToArray;
  finally
    FreeAndNil(AValues);
    FreeAndNil(ACources);
  end;
end;

end.
