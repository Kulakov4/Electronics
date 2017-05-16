unit BodyDataQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQueryBodyData = class(TQueryBase)
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
begin
  Assert(not ABodyData.IsEmpty);
  Assert(AIDProducer > 0);
  Assert(AIDBody > 0);

  AFieldNames := Format('%s;%s', [BodyData.FieldName, IDProducer.FieldName]);

  if FDQuery.LocateEx(AFieldNames, VarArrayCreate([ABodyData, AIDProducer]),
    [lxoCaseInsensitive]) then
  begin
    if IDBody.Value <> AIDBody then
      raise Exception.Create
        ('Добавляемые корпусные данные относится к другому корпусу');
  end
  else
  begin
    TryAppend;
    BodyData.Value := ABodyData;
    IDBody.Value := AIDBody;
    IDProducer.Value := AIDProducer;
    TryPost;
  end;
end;

end.
