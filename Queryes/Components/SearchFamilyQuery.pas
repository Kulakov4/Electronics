unit SearchFamilyQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQrySearchFamily = class(TQueryBase)
  private
    { Private declarations }
  public
    procedure PrepareSearchByValue(AValues: TArray<String>; ALike: Boolean);
    { Public declarations }
  end;

implementation

uses
  System.StrUtils, StrHelper;

{$R *.dfm}

procedure TQrySearchFamily.PrepareSearchByValue(AValues: TArray<String>; ALike:
    Boolean);
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
end;

end.
