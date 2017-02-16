unit SearchComponentsByValuesLike;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  SearchComponentsByValuesBase;

type
  TQuerySearchComponentsByValuesLike = class(TQuerySearchComponentsByValuesBase)
  private
    { Private declarations }
  public
    function Search(const AComponentNames: string): Integer; overload; override;
    { Public declarations }
  end;

var
  QuerySearchComponentsByValuesLike: TQuerySearchComponentsByValuesLike;

implementation

{$R *.dfm}

uses System.StrUtils;

function TQuerySearchComponentsByValuesLike.Search(const AComponentNames:
    string): Integer;
var
  i: Integer;
  j: Integer;
  LikeSQL: string;
  m: TArray<String>;
  s: String;
begin
  if FDQuery.Active then
    FDQuery.Close;

  LikeSQL := '';
  Assert(not AComponentNames.IsEmpty);
  m := AComponentNames.Split([',']);

  // ��������� ��������� �������
  for s in m do
  begin
    LikeSQL := IfThen(LikeSQL.IsEmpty, '', ' or ');
    LikeSQL := LikeSQL + Format('p.Value like %s', [QuotedStr(s + '%')]);
  end;

  s := FDQuery.SQL.Text;

  // ���� ����� � SQL �������
  i := s.IndexOf('p.Value like');
  Assert(i > 0);
  j := s.IndexOf(#13, i);
  Assert(j > 0);

  s := s.Substring(0, i) + LikeSQL + s.Substring(j);

  // ������ SQL ������ � ��������� ������
  FDQuery.Open(s);
  Result := FDQuery.RecordCount;
end;

end.