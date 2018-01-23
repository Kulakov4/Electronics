unit UpdateParamValueRec;

interface

uses
  System.Generics.Collections;

type
  TUpdParam = class
  private
    FFamilyID: Integer;
    FParameterID: Integer;
  public
    constructor Create(AFamilyID, AParameterID: Integer);
    function IsSame(AUpdParam: TUpdParam): Boolean;
    property FamilyID: Integer read FFamilyID;
    property ParameterID: Integer read FParameterID;
  end;

type
  TUpdParamList = class(TList<TUpdParam>)
  public
    function Search(AFamilyID, AParameterID: Integer): Integer;
  end;

implementation

function TUpdParamList.Search(AFamilyID, AParameterID: Integer): Integer;
var
  I: Integer;
begin
  Assert(AFamilyID > 0);
  Assert(AParameterID > 0);

  Result := -1;
  for I := 0 to Count - 1 do
  begin
    if (Items[I].FamilyID = AFamilyID) and (Items[I].ParameterID = AParameterID)
    then
    begin
      Result := I;
      Exit;
    end;
  end;
end;

constructor TUpdParam.Create(AFamilyID, AParameterID: Integer);
begin
  Assert(AFamilyID > 0);
  Assert(AParameterID > 0);

  FFamilyID := AFamilyID;
  FParameterID := AParameterID;
end;

function TUpdParam.IsSame(AUpdParam: TUpdParam): Boolean;
begin
  Assert(AUpdParam <> nil);

  Result := (FFamilyID = AUpdParam.FamilyID) and
    (FParameterID = AUpdParam.ParameterID);
end;

end.
