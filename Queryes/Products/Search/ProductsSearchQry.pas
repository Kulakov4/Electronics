unit ProductsSearchQry;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, DSWrap;

type
  TProductsSearchWr = class(TDSWrap)
  private
    FValue: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    property Value: TFieldWrap read FValue;
  end;

  TQryProductsSearch = class(TQueryBase)
  private
    FW: TProductsSearchWr;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    procedure Search(AValues: TArray<String>; ALike: Boolean);
    property W: TProductsSearchWr read FW;
    { Public declarations }
  end;

implementation

uses
  System.StrUtils;

{$R *.dfm}

constructor TQryProductsSearch.Create(AOwner: TComponent);
begin
  inherited;
  FW := TProductsSearchWr.Create(FDQuery);
end;

procedure TQryProductsSearch.Search(AValues: TArray<String>; ALike: Boolean);
var
  AConditionSQL: string;
  ANewSQL: string;
  p: Integer;
  s: string;
  Str: string;
begin
  if ALike then
  begin
    AConditionSQL := '';
    // Формируем несколько условий
    for s in AValues do
    begin
      AConditionSQL := IfThen(AConditionSQL.IsEmpty, '', ' or ');
      AConditionSQL := AConditionSQL + Format('%s like %s',
        [W.Value.FullName, QuotedStr(s + '%')]);
    end;

    // if not AConditionSQL.IsEmpty then
    // AConditionSQL := Format(' and (%s)', [AConditionSQL]);
  end
  else
  begin
    AConditionSQL := Format('instr('',''||:%s||'','', '',''||%s||'','') > 0',
      [W.Value.FieldName, W.Value.FullName]);
    // ' and (instr('',''||:Value||'','', '',''||p.Value||'','') > 0)';
  end;

  if AConditionSQL <> '' then
  begin
    p := SQL.IndexOf('1=1');
    Assert(p > 0);
    ANewSQL := SQL.Replace('1=1', AConditionSQL);
    p := ANewSQL.IndexOf('2=2');
    Assert(p > 0);
    ANewSQL := ANewSQL.Replace('2=2', AConditionSQL);
  end;

  FDQuery.Close;
  FDQuery.SQL.Text := ANewSQL;

  if not ALike then
  begin
    Str := '';
    for s in AValues do
      Str := Str + IfThen(Str.IsEmpty, '', ',') + s;

    SetParamTypeEx(W.Value.FieldName, Str, ptInput, ftWideString);
  end;

  FDQuery.Open;
end;

constructor TProductsSearchWr.Create(AOwner: TComponent);
begin
  inherited;
  FValue := TFieldWrap.Create(Self, 'p.Value');
end;

end.
