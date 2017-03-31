unit Sequence;

interface

type
  TSequence = class(TObject)
  private
  protected
    FValue: Integer;
  public
    constructor Create(StartValue: Integer = 0);
    function NextValue: Integer; virtual;
    property Value: Integer read FValue write FValue;
  end;

implementation

constructor TSequence.Create(StartValue: Integer = 0);
begin
  inherited Create;
  FValue := StartValue;
end;

function TSequence.NextValue: Integer;
begin
  Inc(FValue);
  Result := FValue;
end;

end.
