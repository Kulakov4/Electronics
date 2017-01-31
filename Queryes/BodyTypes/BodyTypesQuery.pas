unit BodyTypesQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQueryBodyTypes = class(TQueryBase)
  private
    function GetBodyType: TField;
    function GetIDParentBodyType: TField;
    function GetLevel: TField;
    { Private declarations }
  public
    procedure AddNewValue(const ABodyType: string);
    procedure LocateOrAppendRecord(const ABodyType: string;
      AIDParentBodyType, ALevel: Integer);
    function ConstructBodyKind(const APackage: String): string;
    function ConstructBodyType(const APackage: string): string;
    function LocateBodyType(const ABodyType: string): Boolean;
    procedure LocateOrAppend(const ABodyType: string);
    property BodyType: TField read GetBodyType;
    property IDParentBodyType: TField read GetIDParentBodyType;
    property Level: TField read GetLevel;
    { Public declarations }
  end;

var
  QueryBodyTypes: TQueryBodyTypes;

implementation

{$R *.dfm}

procedure TQueryBodyTypes.AddNewValue(const ABodyType: string);
Var
  BodyType0: String;
  BodyType1: String;
begin
  Assert(not ABodyType.IsEmpty);
  // Получаем корневую ветвь корпуса
  BodyType0 := ConstructBodyKind(ABodyType);
  if BodyType0.IsEmpty then
    LocateOrAppendRecord(ABodyType, 0, 0)
  else
  begin
    LocateOrAppendRecord(BodyType0, 0, 0);
    BodyType1 := ConstructBodyType(ABodyType);
    if BodyType1.IsEmpty then
      LocateOrAppendRecord(ABodyType, PKValue, 1)
    else
    begin
      LocateOrAppendRecord(BodyType1, PKValue, 1);
      LocateOrAppendRecord(ABodyType, PKValue, 2);
    end;

  end;
end;

procedure TQueryBodyTypes.LocateOrAppendRecord(const ABodyType: string;
  AIDParentBodyType, ALevel: Integer);
begin
  if not LocateBodyType(ABodyType) then
  begin
    FDQuery.Append;
    BodyType.AsString := ABodyType;
    if AIDParentBodyType > 0 then
      IDParentBodyType.Value := AIDParentBodyType;
    Level.Value := ALevel;
    FDQuery.Post;
  end;
end;

function TQueryBodyTypes.ConstructBodyKind(const APackage: String): string;
var
  m: TArray<String>;
begin
  // Выделяем название корпуса до первой точки с запятой

  Assert(not APackage.IsEmpty);
  m := APackage.Split([';']);
  if Length(m) = 1 then
    Result := APackage.Trim
  else
  begin
    Result := m[0].Trim([',', ' ']);
    // if Result.IsEmpty then
    // Result := '';
  end;
end;

function TQueryBodyTypes.ConstructBodyType(const APackage: string): string;
var
  AStartIndex: Integer;
  m: TArray<String>;
  S: string;
begin
  Assert(not APackage.IsEmpty);
  m := APackage.Split([';']);
  if Length(m) = 1 then
    Result := APackage
  else
  begin
    Result := m[0].Trim([',', ' ']);
    // if Result.IsEmpty then
    // Result := '';
    S := m[1];
    AStartIndex := 0;
    while S.IndexOfAny(['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'],
      AStartIndex) = AStartIndex do
      Inc(AStartIndex);

    if AStartIndex > 0 then
    begin
      S := S.Substring(0, AStartIndex);
      Result := Format('%s/%s', [Result, S]);
    end;
  end;
end;

function TQueryBodyTypes.GetBodyType: TField;
begin
  Result := Field('BodyType');
end;

function TQueryBodyTypes.GetIDParentBodyType: TField;
begin
  Result := Field('IDParentBodyType');
end;

function TQueryBodyTypes.GetLevel: TField;
begin
  Result := Field('Level');
end;

function TQueryBodyTypes.LocateBodyType(const ABodyType: string): Boolean;
begin
  Assert(not ABodyType.IsEmpty);
  Result := FDQuery.LocateEx(BodyType.FieldName, ABodyType,
    [lxoCaseInsensitive]);
end;

procedure TQueryBodyTypes.LocateOrAppend(const ABodyType: string);
begin
  if not LocateBodyType(ABodyType) then
    AddNewValue(ABodyType);
end;

end.
