unit SearchFamOrCompoQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQuerySearchFamilyOrComp = class(TQueryBase)
  private
    { Private declarations }
  public
    procedure PrepareSearchByValue(AValues: TArray<String>;
      ALike, AFamily: Boolean);
    function SearchFamily(const AFamily: String): Integer;
    function SearchComponent(const AComponent: String): Integer;
    function SearchEx(const AValue: String; ALike, AFamily: Boolean): Integer;
    { Public declarations }
  end;

implementation

uses
  StrHelper, System.StrUtils;

{$R *.dfm}

procedure TQuerySearchFamilyOrComp.PrepareSearchByValue(AValues: TArray<String>;
  ALike, AFamily: Boolean);
var
  ANewStipulation: string;
  AStipulation: string;
  AUpperS: string;
  S: string;
begin
  Assert(Length(AValues) > 0);

  AStipulation := '';
  // Формируем несколько условий
  for S in AValues do
  begin
    AUpperS := S.ToUpper;
    ANewStipulation := 'upper(Value) ' +
      IfThen(ALike, 'like ' + QuotedStr(AUpperS + '%'),
      '= ' + QuotedStr(AUpperS));
    AStipulation := AStipulation + IfThen(AStipulation.IsEmpty, '', ' or ') +
      ANewStipulation;
  end;

  // Делаем замену в первоначальном SQL запросе
  FDQuery.SQL.Text := ReplaceInSQL(SQL, AStipulation, 0);

  AStipulation := Format('ParentProductId is %s null',
    [IfThen(AFamily, '', 'not')]);

  FDQuery.SQL.Text := ReplaceInSQL(FDQuery.SQL.Text, AStipulation, 1);
end;

function TQuerySearchFamilyOrComp.SearchFamily(const AFamily: String): Integer;
begin
  Result := SearchEx(AFamily, False, True);
end;

function TQuerySearchFamilyOrComp.SearchComponent(const AComponent
  : String): Integer;
begin
  Result := SearchEx(AComponent, False, False);
end;

function TQuerySearchFamilyOrComp.SearchEx(const AValue: String;
  ALike, AFamily: Boolean): Integer;
begin
  Assert(not AValue.IsEmpty);

  PrepareSearchByValue([AValue], ALike, AFamily);

  FDQuery.Close;
  FDQuery.Open;

  Result := FDQuery.RecordCount;
end;

end.
