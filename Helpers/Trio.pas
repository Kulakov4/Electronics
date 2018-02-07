unit Trio;

interface

type
  TTrio = record
    Key: Integer;
    Order: Integer;
    Value: Integer;
  public
    constructor Create(AKey, AValue, AOrder: Integer);
  end;

  TCategoryParamsRec = record
    ParamSubParamID: Integer;
    Order: Integer;
    IsAttribute: Integer;
    IdParameter: Integer;
    IdSubParameter: Integer;
    IsDefault: Integer;
    Name: string;
    Translation: string;
    ID: Integer;
  public
    constructor Create(AID, AParamSubParamId, AOrder, AIsAttribute, AIDParameter,
        AIDSubParameter: Integer; const AName, ATranslation: String; AIsDefault:
        Integer);
  end;

implementation

constructor TTrio.Create(AKey, AValue, AOrder: Integer);
begin
  Assert(AKey > 0);
  Assert(AValue > 0);
  Assert(AOrder > 0);

  Key := AKey;
  Value := AValue;
  Order := AOrder;
end;

constructor TCategoryParamsRec.Create(AID, AParamSubParamId, AOrder,
    AIsAttribute, AIDParameter, AIDSubParameter: Integer; const AName,
    ATranslation: String; AIsDefault: Integer);
begin
  inherited;
  ID := AID;
  ParamSubParamID := AParamSubParamId;
  Order := AOrder;
  IsAttribute := AIsAttribute;
  IdParameter := AIDParameter;
  IdSubParameter := AIDSubParameter;
  Name := AName;
  Translation := ATranslation;
  IsDefault := AIsDefault;
end;

end.
