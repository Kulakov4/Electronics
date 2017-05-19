unit FieldInfoUnit;

interface

type
  TFieldInfo = class(TObject)
  private
    FErrorMessage: string;
    FFieldName: string;
    FIsCellUnion: Boolean;
    FRequired: Boolean;
  protected
  public
    constructor Create(AFieldName: string; ARequired: Boolean = False;
        AErrorMessage: String = ''; AIsCellUnion: Boolean = False);
    property ErrorMessage: string read FErrorMessage write FErrorMessage;
    property FieldName: string read FFieldName write FFieldName;
    property IsCellUnion: Boolean read FIsCellUnion write FIsCellUnion;
    property Required: Boolean read FRequired write FRequired;
  end;

implementation

uses System.SysUtils;

constructor TFieldInfo.Create(AFieldName: string; ARequired: Boolean = False;
    AErrorMessage: String = ''; AIsCellUnion: Boolean = False);
begin
  Assert(not AFieldName.IsEmpty);
  FFieldName := AFieldName;
  FRequired := ARequired;
  FErrorMessage := AErrorMessage;
  FIsCellUnion := AIsCellUnion;

  if FRequired then
    Assert(not FErrorMessage.IsEmpty);
end;

end.
