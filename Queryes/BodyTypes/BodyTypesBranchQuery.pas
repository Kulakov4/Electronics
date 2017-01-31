unit BodyTypesBranchQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQueryBodyTypesBranch = class(TQueryBase)
  private
    function GetBodyType: TField;
    function GetIDParentBodyType: TField;
    function GetLevel: TField;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    procedure AddNewValue(const AValue: String; ALevel: Integer);
    function LocateBodyType(const ABodyType: string): Boolean;
    procedure LocateOrAppend(const AValue: String; ALevel: Integer);
    property BodyType: TField read GetBodyType;
    property IDParentBodyType: TField read GetIDParentBodyType;
    property Level: TField read GetLevel;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TQueryBodyTypesBranch.Create(AOwner: TComponent);
begin
  inherited;
  DetailParameterName := 'IDParentBodyType';
end;

procedure TQueryBodyTypesBranch.AddNewValue(const AValue: String;
  ALevel: Integer);
begin
  FDQuery.Append;
  BodyType.AsString := AValue;
  Level.AsInteger := ALevel;
  IDParentBodyType.AsInteger := FDQuery.ParamByName(DetailParameterName)
    .AsInteger;
  FDQuery.Post;
end;

function TQueryBodyTypesBranch.GetBodyType: TField;
begin
  Result := Field('BodyType');
end;

function TQueryBodyTypesBranch.GetIDParentBodyType: TField;
begin
  Result := Field('IDParentBodyType');
end;

function TQueryBodyTypesBranch.GetLevel: TField;
begin
  Result := Field('Level');
end;

function TQueryBodyTypesBranch.LocateBodyType(const ABodyType: string): Boolean;
begin
  Result := FDQuery.LocateEx(BodyType.FieldName, ABodyType.Trim, []);
end;

procedure TQueryBodyTypesBranch.LocateOrAppend(const AValue: String;
  ALevel: Integer);
begin
  if not LocateBodyType(AValue) then
    AddNewValue(AValue, ALevel)
end;

end.
