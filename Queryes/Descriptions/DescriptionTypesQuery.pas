unit DescriptionTypesQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  QueryWithDataSourceUnit, DragHelper, OrderQuery;

type
  TQueryDescriptionTypes = class(TQueryOrder)
    fdqBase: TFDQuery;
    FDUpdateSQL: TFDUpdateSQL;
  private
    FShowDuplicate: Boolean;
    function GetComponentType: TField;
    procedure SetShowDuplicate(const Value: Boolean);
    { Private declarations }
  protected
    procedure DoAfterOpen(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    procedure AddNewValue(const AValue: string);
    procedure LocateOrAppend(AValue: string);
    property ComponentType: TField read GetComponentType;
    property ShowDuplicate: Boolean read FShowDuplicate write SetShowDuplicate;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses StrHelper, RepositoryDataModule, NotifyEvents;

constructor TQueryDescriptionTypes.Create(AOwner: TComponent);
begin
  inherited;
  // Копируем базовый запрос и параметры
  AssignFrom(fdqBase);

  AutoTransaction := False;

  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, FEventList);
end;

procedure TQueryDescriptionTypes.AddNewValue(const AValue: string);
begin
  FDQuery.Append;
  ComponentType.AsString := AValue;
  FDQuery.Post;
end;

procedure TQueryDescriptionTypes.DoAfterOpen(Sender: TObject);
begin
  ComponentType.DisplayLabel := 'Тип компонентов';
end;

function TQueryDescriptionTypes.GetComponentType: TField;
begin
  Result := Field('ComponentType');
end;

procedure TQueryDescriptionTypes.LocateOrAppend(AValue: string);
var
  OK: Boolean;
begin
  Assert(not AValue.IsEmpty);
  OK := FDQuery.LocateEx('ComponentType', AValue, []);

  if not OK then
    AddNewValue(AValue);
end;

procedure TQueryDescriptionTypes.SetShowDuplicate(const Value: Boolean);
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

end.
