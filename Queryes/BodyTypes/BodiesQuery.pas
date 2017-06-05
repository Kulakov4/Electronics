unit BodiesQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQueryBodies = class(TQueryBase)
    FDUpdateSQL: TFDUpdateSQL;
  private
    function GetBody: TField;
    function GetBody0: TField;
    function GetBody1: TField;
    function GetBody2: TField;
    function GetBody3: TField;
    function GetBody4: TField;
    function GetBody5: TField;
    function GetIDBodyKind: TField;
    { Private declarations }
  protected
  public
    procedure LocateOrAppend(const ABody: string; AIDBodyKind: Integer);
    property Body: TField read GetBody;
    property Body0: TField read GetBody0;
    property Body1: TField read GetBody1;
    property Body2: TField read GetBody2;
    property Body3: TField read GetBody3;
    property Body4: TField read GetBody4;
    property Body5: TField read GetBody5;
    property IDBodyKind: TField read GetIDBodyKind;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses StrHelper;

function TQueryBodies.GetBody: TField;
begin
  Result := Field('Body');
end;

function TQueryBodies.GetBody0: TField;
begin
  Result := Field('Body0');
end;

function TQueryBodies.GetBody1: TField;
begin
  Result := Field('Body1');
end;

function TQueryBodies.GetBody2: TField;
begin
  Result := Field('Body2');
end;

function TQueryBodies.GetBody3: TField;
begin
  Result := Field('Body3');
end;

function TQueryBodies.GetBody4: TField;
begin
  Result := Field('Body4');
end;

function TQueryBodies.GetBody5: TField;
begin
  Result := Field('Body5');
end;

function TQueryBodies.GetIDBodyKind: TField;
begin
  Result := Field('IDBodyKind');
end;

procedure TQueryBodies.LocateOrAppend(const ABody: string;
  AIDBodyKind: Integer);
var
  ABody0: string;
  ABody1: Integer;
  ABody2: string;
  ABody3: Integer;
  ABody4: string;
  ABody5: Integer;
  AFieldNames: string;
begin
  Assert(not ABody.IsEmpty);
  Assert(AIDBodyKind > 0);

  AFieldNames := Format('%s;%s', [IDBodyKind.FieldName, Body.FieldName]);

  if not FDQuery.LocateEx(AFieldNames, VarArrayOf([AIDBodyKind, ABody]),
    [lxoCaseInsensitive]) then
  begin
    if not MySplit(ABody, ABody0, ABody1, ABody2, ABody3, ABody4, ABody5) then
      raise Exception.CreateFmt
        ('Наименование %s не удовлетворяет шаблону "Строка/Число"', [ABody]);

    TryAppend;
    Body0.Value := ABody0;
    if ABody1 > 0 then
      Body1.Value := ABody1;
    if ABody2.IsEmpty then
      Body2.Value := ABody2;
    if ABody3 > 0 then
      Body3.Value := ABody3;
    if ABody4.IsEmpty then
      Body4.Value := ABody4;
    if ABody5 > 0 then
      Body5.Value := ABody5;

    IDBodyKind.Value := AIDBodyKind;
    TryPost;
    Assert(Body.AsString.Length > 0);
  end;
end;

end.
