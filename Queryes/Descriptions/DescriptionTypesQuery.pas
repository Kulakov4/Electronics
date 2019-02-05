unit DescriptionTypesQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  QueryWithDataSourceUnit, DragHelper, OrderQuery, DSWrap;

type
  TDescriptionTypeW = class(TOrderW)
  private
    FComponentType: TFieldWrap;
    FID: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AddNewValue(const AValue: string);
    procedure LocateOrAppend(AValue: string);
    property ComponentType: TFieldWrap read FComponentType;
    property ID: TFieldWrap read FID;
  end;

  TQueryDescriptionTypes = class(TQueryOrder)
    FDUpdateSQL: TFDUpdateSQL;
  private
    FShowDuplicate: Boolean;
    FW: TDescriptionTypeW;
    procedure SetShowDuplicate(const Value: Boolean);
    { Private declarations }
  protected
    function CreateDSWrap: TDSWrap; override;
  public
    constructor Create(AOwner: TComponent); override;
    property ShowDuplicate: Boolean read FShowDuplicate write SetShowDuplicate;
    property W: TDescriptionTypeW read FW;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses StrHelper, RepositoryDataModule, NotifyEvents;

constructor TQueryDescriptionTypes.Create(AOwner: TComponent);
begin
  inherited;
  FW := FDSWrap as TDescriptionTypeW;

  AutoTransaction := False;

end;

function TQueryDescriptionTypes.CreateDSWrap: TDSWrap;
begin
  Result := TDescriptionTypeW.Create(FDQuery);
end;

procedure TQueryDescriptionTypes.SetShowDuplicate(const Value: Boolean);
var
  ASQL: String;
begin
  if FShowDuplicate <> Value then
  begin
    FShowDuplicate := Value;

    // Получаем первоначальный запрос
    ASQL := SQL;
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

constructor TDescriptionTypeW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'ID', '', True);
  FOrd := TFieldWrap.Create(Self, 'Ord');
  FComponentType := TFieldWrap.Create(Self, 'ComponentType', 'Тип компонентов');
end;

procedure TDescriptionTypeW.AddNewValue(const AValue: string);
begin
  TryAppend;
  ComponentType.F.AsString := AValue;
  TryPost;
end;

procedure TDescriptionTypeW.LocateOrAppend(AValue: string);
var
  OK: Boolean;
begin
  Assert(not AValue.IsEmpty);
  OK := FDDataSet.LocateEx(ComponentType.FieldName, AValue, []);

  if not OK then
    AddNewValue(AValue);
end;

end.
