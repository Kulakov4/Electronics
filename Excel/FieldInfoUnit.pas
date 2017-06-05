unit FieldInfoUnit;

interface

type
  TFieldInfo = class(TObject)
  private
    FErrorMessage: string;
    FFieldName: string;
    FIsCellUnion: Boolean;
    FRequired: Boolean;
    FSize: Integer;
  protected
  public
    constructor Create(AFieldName: string; ARequired: Boolean = False;
        AErrorMessage: String = ''; AIsCellUnion: Boolean = False; ASize: Integer =
        1000);
    property ErrorMessage: string read FErrorMessage write FErrorMessage;
    property FieldName: string read FFieldName write FFieldName;
    property IsCellUnion: Boolean read FIsCellUnion write FIsCellUnion;
    property Required: Boolean read FRequired write FRequired;
    property Size: Integer read FSize write FSize;
  end;

implementation

uses System.SysUtils;

constructor TFieldInfo.Create(AFieldName: string; ARequired: Boolean = False;
    AErrorMessage: String = ''; AIsCellUnion: Boolean = False; ASize: Integer =
    1000);
begin
  Assert(not AFieldName.IsEmpty);
  FFieldName := AFieldName;
  FRequired := ARequired;
  FErrorMessage := AErrorMessage;
  FIsCellUnion := AIsCellUnion;
  FSize := ASize;

  if FRequired then
    Assert(not FErrorMessage.IsEmpty);
end;

end.
