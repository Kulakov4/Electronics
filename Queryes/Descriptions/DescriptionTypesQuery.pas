unit DescriptionTypesQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, DragHelper, OrderQuery, DSWrap;

type
  TDescriptionTypeW = class(TOrderW)
  private
    FComponentName: TParamWrap;
    FComponentType: TFieldWrap;
    FID: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AddNewValue(const AValue: string);
    procedure LocateOrAppend(AValue: string);
    property ComponentName: TParamWrap read FComponentName;
    property ComponentType: TFieldWrap read FComponentType;
    property ID: TFieldWrap read FID;
  end;

  TQueryDescriptionTypes = class(TQueryOrder)
    FDUpdateSQL: TFDUpdateSQL;
  private
    FFilterText: string;
    FShowDuplicate: Boolean;
    FW: TDescriptionTypeW;
    procedure ApplyFilter(AShowDuplicate: Boolean; const AFilterText: string);
    { Private declarations }
  protected
    function CreateDSWrap: TDSWrap; override;
  public
    constructor Create(AOwner: TComponent); override;
    function TryApplyFilter(AShowDuplicate: Boolean;
      const AFilterText: string): Boolean;
    property FilterText: string read FFilterText;
    property ShowDuplicate: Boolean read FShowDuplicate;
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

procedure TQueryDescriptionTypes.ApplyFilter(AShowDuplicate: Boolean; const
    AFilterText: string);
var
  ASQL: String;
begin

  // Получаем первоначальный запрос
  ASQL := SQL;

  // Если нужно показать дубликаты
  if AShowDuplicate then
  begin
    ASQL := ASQL.Replace('/* ShowDuplicate', '', [rfReplaceAll]);
    ASQL := ASQL.Replace('ShowDuplicate */', '', [rfReplaceAll]);
  end;

  // Если нужно показать отфильтровать по названию компонента
  if not AFilterText.IsEmpty then
  begin
    ASQL := ASQL.Replace('/* Filter', '', [rfReplaceAll]);
    ASQL := ASQL.Replace('Filter */', '', [rfReplaceAll]);
  end;

  FDQuery.Close;
  FDQuery.SQL.Text := ASQL;

  if not AFilterText.IsEmpty then
  begin
    SetParamType(W.ComponentName.FieldName, ptInput, ftWideString);
    SetParameters([W.ComponentName.FieldName], [AFilterText + '%']);
  end;

  FDQuery.Open;
end;

function TQueryDescriptionTypes.TryApplyFilter(AShowDuplicate: Boolean;
  const AFilterText: string): Boolean;
var
  ASQL: String;
begin
  if (AShowDuplicate = FShowDuplicate) and (AFilterText = FFilterText) then
    Exit;

  ApplyFilter(AShowDuplicate, AFilterText);

  Result := FDQuery.RecordCount > 0;

  if Result then
  begin
    FShowDuplicate := AShowDuplicate;
    FFilterText := AFilterText;
  end
  else
    // Возвращаем старые значения
    ApplyFilter(FShowDuplicate, FFilterText);
end;

function TQueryDescriptionTypes.CreateDSWrap: TDSWrap;
begin
  Result := TDescriptionTypeW.Create(FDQuery);
end;

constructor TDescriptionTypeW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'ID', '', True);
  FOrd := TFieldWrap.Create(Self, 'Ord');
  FComponentType := TFieldWrap.Create(Self, 'ComponentType', 'Тип компонентов');
  FComponentName := TParamWrap.Create(Self, 'ComponentName');
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
