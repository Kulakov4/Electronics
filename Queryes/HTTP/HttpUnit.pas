unit HttpUnit;

interface

uses
  IdHTTP;

type
  TCBRHttp = class(TObject)
  public
    class function GetCourses(AValueNames: TArray<String>)
      : TArray<Double>; static;
    class function ParseXML(const AXML: String; AValueNames: TArray<String>)
      : TArray<Double>; static;
  end;

implementation

uses
  System.Classes, System.SysUtils, Xml.XMLDoc, Xml.XMLIntf,
  System.Generics.Collections;

class function TCBRHttp.GetCourses(AValueNames: TArray<String>): TArray<Double>;
var
  AidHttp: TIdHTTP;
  AURL: string;
  S: string;
begin
  Assert(Length(AValueNames) > 0);

  AURL := 'http://www.cbr.ru/scripts/XML_daily.asp';

  AidHttp := TIdHTTP.Create(nil);
  try
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
    try
      ARootNode := AXMLDocument.DocumentElement;

      // ÷икл по всем валютам
      for i := 0 to ARootNode.ChildNodes.Count - 1 do
      begin
        ANode := ARootNode.ChildNodes[i];

        S := ANode.ChildValues['Name'];

        // »щем, нужна ли нам така€ валюта
        k := AValues.IndexOf(S);
        if k = -1 then
          Continue;

        ANominal := StrToIntDef(ANode.ChildValues['Nominal'], 0);
        if ANominal = 0 then
          Continue;

        S := ANode.ChildValues['Value'];
        ACources[k] := StrToFloatDef(S, 0) / ANominal;
      end;
    finally
      FreeAndNil(AXMLDocument);
    end;
    Result := ACources.ToArray;
  finally
    FreeAndNil(AValues);
    FreeAndNil(ACources);
  end;
end;

end.
