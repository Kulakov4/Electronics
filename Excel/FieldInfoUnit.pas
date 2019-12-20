unit FieldInfoUnit;

interface

uses
  System.Generics.Collections;

type
  TFieldInfo = class(TObject)
  private
    FDisplayLabel: string;
    FErrorMessage: string;
    FFieldName: string;
    FIsCellUnion: Boolean;
    FRequired: Boolean;
    FSize: Integer;
  protected
  public
    constructor Create(AFieldName: string; ARequired: Boolean = False;
        AErrorMessage: String = ''; ADisplayLabel: String = ''; AIsCellUnion:
        Boolean = False; ASize: Integer = 1000);
    property DisplayLabel: string read FDisplayLabel;
    property ErrorMessage: string read FErrorMessage write FErrorMessage;
    property FieldName: string read FFieldName write FFieldName;
    property IsCellUnion: Boolean read FIsCellUnion write FIsCellUnion;
    property Required: Boolean read FRequired write FRequired;
    property Size: Integer read FSize write FSize;
  end;

  TFieldsInfo = class(TList<TFieldInfo>)
  public
    function Find(const AFieldName: string): TFieldInfo;
  end;

implementation

uses System.SysUtils;

constructor TFieldInfo.Create(AFieldName: string; ARequired: Boolean = False;
    AErrorMessage: String = ''; ADisplayLabel: String = ''; AIsCellUnion:
    Boolean = False; ASize: Integer = 1000);
begin
  Assert(not AFieldName.IsEmpty);
  FFieldName := AFieldName;
  FDisplayLabel := ADisplayLabel;
  FRequired := ARequired;
  FErrorMessage := AErrorMessage;
  FIsCellUnion := AIsCellUnion;
  FSize := ASize;

  if FRequired then
    Assert(not FErrorMessage.IsEmpty);
end;

function TFieldsInfo.Find(const AFieldName: string): TFieldInfo;
begin
  Assert(not AFieldName.IsEmpty);

  for Result in Self do
  begin
    if Result.FieldName = AFieldName then
      Exit;
  end;
  Result := nil;
end;

end.
