unit UpdateParamValueRec;

interface

uses
  System.Generics.Collections;

type
  TUpdParamSubParam = class
  private
    FFamilyID: Integer;
    FParamSubParamID: Integer;
  public
    constructor Create(AFamilyID, AParamSubParamID: Integer);
    function IsSame(AUpdParam: TUpdParamSubParam): Boolean;
    property FamilyID: Integer read FFamilyID;
    property ParamSubParamID: Integer read FParamSubParamID;
  end;

type
  TUpdParamSubParamList = class(TObjectList<TUpdParamSubParam>)
  public
    function Search(AFamilyID, AParamSubParamID: Integer): Integer;
  end;

implementation

function TUpdParamSubParamList.Search(AFamilyID, AParamSubParamID: Integer): Integer;
var
  I: Integer;
begin
  Assert(AFamilyID > 0);
  Assert(AParamSubParamID > 0);

  Result := -1;
  for I := 0 to Count - 1 do
  begin
    if (Items[I].FamilyID = AFamilyID) and (Items[I].ParamSubParamID = AParamSubParamID)
    then
    begin
      Result := I;
      Exit;
    end;
  end;
end;

constructor TUpdParamSubParam.Create(AFamilyID, AParamSubParamID: Integer);
begin
  Assert(AFamilyID > 0);
  Assert(AParamSubParamID > 0);

  FFamilyID := AFamilyID;
  FParamSubParamID := AParamSubParamID;
end;

function TUpdParamSubParam.IsSame(AUpdParam: TUpdParamSubParam): Boolean;
begin
  Assert(AUpdParam <> nil);

  Result := (FFamilyID = AUpdParam.FamilyID) and
    (FParamSubParamID = AUpdParam.ParamSubParamID);
end;

end.
