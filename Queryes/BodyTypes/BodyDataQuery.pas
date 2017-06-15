unit BodyDataQuery;

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
  TQueryBodyData = class(TQueryBase)
    FDUpdateSQL: TFDUpdateSQL;
  private
    function GetBodyData: TField;
    function GetIDBody: TField;
    function GetIDProducer: TField;
    { Private declarations }
  public
    procedure LocateOrAppend(const ABodyData: string;
      AIDProducer, AIDBody: Integer);
    property BodyData: TField read GetBodyData;
    property IDBody: TField read GetIDBody;
    property IDProducer: TField read GetIDProducer;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses StrHelper;

function TQueryBodyData.GetBodyData: TField;
begin
  Result := Field('BodyData');
end;

function TQueryBodyData.GetIDBody: TField;
begin
  Result := Field('IDBody');
end;

function TQueryBodyData.GetIDProducer: TField;
begin
  Result := Field('IDProducer');
end;

procedure TQueryBodyData.LocateOrAppend(const ABodyData: string;
  AIDProducer, AIDBody: Integer);
var
  AFieldNames: string;
  AMatches: TList<TMySplit>;
  I: Integer;
begin
  Assert(not ABodyData.IsEmpty);
  Assert(AIDProducer > 0);
  Assert(AIDBody > 0);

  AFieldNames := Format('%s;%s;%s', [IDBody.FieldName, BodyData.FieldName, IDProducer.FieldName]);

  if not FDQuery.LocateEx(AFieldNames, VarArrayOf([AIDBody, ABodyData, AIDProducer]),
    [lxoCaseInsensitive]) then
  begin
    AMatches := MySplit(ABodyData);
    try
      // Под шаблон подходит абсолютно любая строка
      Assert(AMatches <> nil);

      if (AMatches.Count > 5) then
        raise Exception.CreateFmt
          ('Слишком сложная комбинация чисел и строк в корпусных данных %s', [ABodyData]
          );

      TryAppend;
      for I := 0 to AMatches.Count - 1 do
      begin
        Field(Format('BODYDATA%d', [I * 2])).Value := AMatches[I].S;
        if not AMatches[I].X.IsEmpty then
          Field(Format('BODYDATA%d', [I * 2 + 1])).Value := AMatches[I].X;
      end;
      IDBody.Value := AIDBody;
      IDProducer.Value := AIDProducer;

      TryPost;
    finally
      FreeAndNil(AMatches);
    end;
    Assert(BodyData.AsString.Length > 0);
  end;
end;

end.
