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
    FShowDuplicate: Boolean;
    FTableNameFilter: string;
    procedure DoBeforeOpen(Sender: TObject);
    function GetParameterType: TField;
    procedure SetShowDuplicate(const Value: Boolean);
    procedure SetTableNameFilter(const Value: string);
    { Private declarations }
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure AddNewValue(const AValue: string);
    function GetParameterTypeID(const AParameterType: string): Integer;
    procedure LocateOrAppend(AValue: string);
    property ParameterType: TField read GetParameterType;
    property ShowDuplicate: Boolean read FShowDuplicate write SetShowDuplicate;
    property TableNameFilter: string read FTableNameFilter
      write SetTableNameFilter;
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

function TQueryParameterTypes.GetParameterTypeID(const AParameterType
  : string): Integer;
var
  V: Variant;
begin
  Result := 0;

  V := FDQuery.LookupEx(ParameterType.FieldName, AParameterType,
    PKFieldName, [lxoCaseInsensitive]);

  if not VarIsNull(V) then
    Result := V
end;

procedure TQueryParameterTypes.LocateOrAppend(AValue: string);
begin
  if not FDQuery.LocateEx(ParameterType.FieldName, AValue, [lxoCaseInsensitive])
  then
    AddNewValue(AValue);
end;

procedure TQueryParameterTypes.SetShowDuplicate(const Value: Boolean);
var
  ASQL: String;
begin
  if FShowDuplicate <> Value then
  begin
    FShowDuplicate := Value;

    ASQL := fdqBase.SQL.Text;
    if FShowDuplicate then
    begin
      ASQL := ASQL.Replace('/* ShowDuplicate', '', [rfReplaceAll]);
      ASQL := ASQL.Replace('ShowDuplicate */', '', [rfReplaceAll]);
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
