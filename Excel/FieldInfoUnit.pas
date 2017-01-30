unit FieldInfoUnit;

interface

type
  TFieldInfo = class(TObject)
  private
    FErrorMessage: string;
    FFieldName: string;
    FRequired: Boolean;
  public
    constructor Create(AFieldName: string; ARequired: Boolean = False;
      AErrorMessage: String = '');
    property ErrorMessage: string read FErrorMessage write FErrorMessage;
    property FieldName: string read FFieldName write FFieldName;
    property Required: Boolean read FRequired write FRequired;
  end;

implementation

uses System.SysUtils;

constructor TFieldInfo.Create(AFieldName: string; ARequired: Boolean = False;
  AErrorMessage: String = '');
begin
  Assert(not AFieldName.IsEmpty);
  FFieldName := AFieldName;
  FRequired := ARequired;
  FErrorMessage := AErrorMessage;

  if FRequired then
    Assert(not FErrorMessage.IsEmpty);
end;

end.
