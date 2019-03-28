unit ParameterTypesQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, DragHelper, System.Generics.Collections,
  OrderQuery, DSWrap;

type
  TParameterTypeW = class(TOrderW)
  private
    FParameterType: TFieldWrap;
    FID: TFieldWrap;
    FTableName: TParamWrap;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AddNewValue(const AValue: string);
    function GetParameterTypeID(const AParameterType: string): Integer;
    procedure LocateOrAppend(AValue: string);
    property ParameterType: TFieldWrap read FParameterType;
    property ID: TFieldWrap read FID;
    property TableName: TParamWrap read FTableName;
  end;

  TQueryParameterTypes = class(TQueryOrder)
    FDQueryID: TFDAutoIncField;
    FDQueryParameterType: TWideStringField;
    FDQueryOrd: TIntegerField;
    fdqDeleteNotUsedPT: TFDQuery;
  private
    FW: TParameterTypeW;
    procedure DoBeforeOpen(Sender: TObject);
    { Private declarations }
  protected
    function CreateDSWrap: TDSWrap; override;
  public
    constructor Create(AOwner: TComponent); override;
    function ApplyFilter(AShowDuplicate: Boolean; ATableName: string): Integer;
    function SearchByTableName(const ATableName: string): Integer;
    property W: TParameterTypeW read FW;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses RepositoryDataModule, NotifyEvents, StrHelper, BaseQuery;

constructor TQueryParameterTypes.Create(AOwner: TComponent);
begin
  inherited;
  FW := FDSWrap as TParameterTypeW;

  AutoTransaction := False;

  TNotifyEventWrap.Create(W.BeforeOpen, DoBeforeOpen, W.EventList);
end;

function TQueryParameterTypes.ApplyFilter(AShowDuplicate: Boolean;
  ATableName: string): Integer;
var
  ASQL: string;
begin
  // Получаем первоначальный запрос
  ASQL := SQL;
  if AShowDuplicate then
  begin
    ASQL := SQL;
    ASQL := ASQL.Replace('/* ShowDuplicate', '', [rfReplaceAll]);
    ASQL := ASQL.Replace('ShowDuplicate */', '', [rfReplaceAll]);
  end;

  if ATableName.IsEmpty then
  begin
    FDQuery.Close;
    FDQuery.SQL.Text := ASQL;
    FDQuery.Open;
    Result := FDQuery.RecordCount;
  end
  else
    Result := SearchEx([TParamRec.Create(W.TableName.FullName, ATableName,
      ftWideString)], -1, ASQL)
end;

function TQueryParameterTypes.CreateDSWrap: TDSWrap;
begin
  Result := TParameterTypeW.Create(FDQuery);
end;

procedure TQueryParameterTypes.DoBeforeOpen(Sender: TObject);
begin
  // Удаляем неиспользуемые типы параметров
  fdqDeleteNotUsedPT.ExecSQL;
end;

function TQueryParameterTypes.SearchByTableName(const ATableName
  : string): Integer;
begin
  Assert(not ATableName.IsEmpty);
  Result := SearchEx([TParamRec.Create(W.TableName.FullName, ATableName,
    ftWideString)]);
end;

constructor TParameterTypeW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'ID', '', True);
  FOrd := TFieldWrap.Create(Self, 'Ord');
  FParameterType := TFieldWrap.Create(Self, 'ParameterType');

  // Параметр SQL запроса
  FTableName := TParamWrap.Create(Self, 'TableName');
end;

procedure TParameterTypeW.AddNewValue(const AValue: string);
begin
  Assert(not AValue.IsEmpty);
  TryAppend;
  ParameterType.F.AsString := AValue;
  tryPost;
end;

function TParameterTypeW.GetParameterTypeID(const AParameterType
  : string): Integer;
var
  V: Variant;
begin
  Result := 0;

  V := FDDataSet.LookupEx(ParameterType.FieldName, AParameterType, PKFieldName,
    [lxoCaseInsensitive]);

  if not VarIsNull(V) then
    Result := V
end;

procedure TParameterTypeW.LocateOrAppend(AValue: string);
begin
  if not FDDataSet.LocateEx(ParameterType.FieldName, AValue,
    [lxoCaseInsensitive]) then
    AddNewValue(AValue);
end;

end.
