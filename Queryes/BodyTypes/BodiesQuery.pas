unit BodiesQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  System.Generics.Collections;

type
  TQueryBodies = class(TQueryBase)
    FDUpdateSQL: TFDUpdateSQL;
  private
    function GetBody: TField;
    function GetIDBodyKind: TField;
    { Private declarations }
  protected
  public
    procedure LocateOrAppend(const ABody: string; AIDBodyKind: Integer);
    property Body: TField read GetBody;
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

function TQueryBodies.GetIDBodyKind: TField;
begin
  Result := Field('IDBodyKind');
end;

procedure TQueryBodies.LocateOrAppend(const ABody: string;
  AIDBodyKind: Integer);
var
  AFieldNames: string;
  AMatches: TList<TMySplit>;
  I: Integer;
  SS: String;
begin
  Assert(not ABody.IsEmpty);
  Assert(AIDBodyKind > 0);

  AFieldNames := Format('%s;%s', [IDBodyKind.FieldName, Body.FieldName]);

  if not FDQuery.LocateEx(AFieldNames, VarArrayOf([AIDBodyKind, ABody]),
    [lxoCaseInsensitive]) then
  begin
    AMatches := MySplit(ABody);
    try
      // Под шаблон подходит абсолютно любая строка
      Assert(AMatches <> nil);

      if (AMatches.Count > 3) then
        raise Exception.CreateFmt
          ('Слишком сложная комбинация чисел и строк в наименовании %s', [ABody]
          );

      TryAppend;
      for I := 0 to AMatches.Count - 1 do
      begin
        SS := AMatches[I].S;
        Field(Format('BODY%d', [I * 2])).Value := SS;
        SS := AMatches[I].X;
        if not SS.IsEmpty then
          Field(Format('BODY%d', [I * 2 + 1])).Value := SS;
      end;
      IDBodyKind.Value := AIDBodyKind;
      TryPost;
    finally
      FreeAndNil(AMatches);
    end;
    Assert(Body.AsString.Length > 0);
  end;
end;

end.
