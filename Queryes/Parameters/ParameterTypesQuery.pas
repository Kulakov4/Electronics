unit ParameterTypesQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, DragHelper, System.Generics.Collections,
  QueryWithDataSourceUnit, OrderQuery;

type
  TQueryParameterTypes = class(TQueryOrder)
    FDQueryID: TFDAutoIncField;
    FDQueryParameterType: TWideStringField;
    FDQueryOrd: TIntegerField;
    FDUpdateSQL: TFDUpdateSQL;
    fdqBase: TFDQuery;
  private
    FShowDublicate: Boolean;
    FTableNameFilter: string;
    procedure DoBeforeOpen(Sender: TObject);
    function GetParameterType: TField;
    procedure SetShowDublicate(const Value: Boolean);
    procedure SetTableNameFilter(const Value: string);
    { Private declarations }
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure AddNewValue(const AValue: string);
    procedure LocateOrAppend(AValue: string);
    function Locate(AValue: string): Boolean;
    property ParameterType: TField read GetParameterType;
    property ShowDublicate: Boolean read FShowDublicate write SetShowDublicate;
    property TableNameFilter: string read FTableNameFilter write SetTableNameFilter;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses RepositoryDataModule, NotifyEvents, StrHelper;

constructor TQueryParameterTypes.Create(AOwner: TComponent);
begin
  inherited;

  // Копируем базовый запрос и параметры
  AssignFrom(fdqBase);

  AutoTransaction := False;

  TNotifyEventWrap.Create(BeforeOpen, DoBeforeOpen, FEventList);
end;

procedure TQueryParameterTypes.AddNewValue(const AValue: string);
begin
  FDQuery.Append;
  ParameterType.AsString := AValue;
  FDQuery.Post;
end;

procedure TQueryParameterTypes.DoBeforeOpen(Sender: TObject);
begin
  FDQuery.ParamByName('TableName').AsString := FTableNameFilter;
end;

function TQueryParameterTypes.GetParameterType: TField;
begin
  Result := Field('ParameterType');
end;

procedure TQueryParameterTypes.LocateOrAppend(AValue: string);
begin
  if not FDQuery.LocateEx(ParameterType.FieldName, AValue, []) then
    AddNewValue(AValue);
end;

function TQueryParameterTypes.Locate(AValue: string): Boolean;
begin
  Result := FDQuery.LocateEx(ParameterType.FieldName, AValue, [lxoPartialKey, lxoCaseInsensitive]);
end;

procedure TQueryParameterTypes.SetShowDublicate(const Value: Boolean);
var
  ASQL: String;
begin
  if FShowDublicate <> Value then
  begin
    FShowDublicate := Value;

    ASQL := fdqBase.SQL.Text;
    if FShowDublicate then
    begin
      ASQL := Replace(ASQL, '', '/* ShowDublicate');
      ASQL := Replace(ASQL, '', 'ShowDublicate */');
    end;

    FDQuery.Close;
    FDQuery.SQL.Text := ASQL;
    FDQuery.Open;
  end;
end;

procedure TQueryParameterTypes.SetTableNameFilter(const Value: string);
begin
  if FTableNameFilter <> Value then
  begin
    FTableNameFilter := Value;

    // Фильтруем по табличному имени
    FDQuery.Close;
    FDQuery.Open;
  end;
end;

end.
