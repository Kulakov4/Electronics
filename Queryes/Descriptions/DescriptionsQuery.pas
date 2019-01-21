unit DescriptionsQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, QueryWithDataSourceUnit,
  DescriptionsInterface, RecordCheck;

type
  TQueryDescriptions = class(TQueryWithDataSource, IDescriptions)
    FDQueryID: TFDAutoIncField;
    FDQueryComponentName: TWideStringField;
    FDQueryDescription: TWideMemoField;
    FDQueryIDComponentType: TIntegerField;
    FDQueryIDProducer: TIntegerField;
  strict private
    function Check(const AComponentName, ADescription: String;
      AProducerID: Integer): TRecordCheck; stdcall;
  private
    FCheckClone: TFDMemTable;
    FShowDuplicate: Boolean;
    function GetCheckClone: TFDMemTable;
    function GetComponentName: TField;
    function GetDescription: TField;
    function GetIDComponentType: TField;
    function GetIDProducer: TField;
    procedure SetShowDuplicate(const Value: Boolean);
    { Private declarations }
  protected
    property CheckClone: TFDMemTable read GetCheckClone;
  public
    constructor Create(AOwner: TComponent); override;
    property ComponentName: TField read GetComponentName;
    property Description: TField read GetDescription;
    property IDComponentType: TField read GetIDComponentType;
    property IDProducer: TField read GetIDProducer;
    property ShowDuplicate: Boolean read FShowDuplicate write SetShowDuplicate;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses RepositoryDataModule, NotifyEvents, StrHelper, ErrorType;

constructor TQueryDescriptions.Create(AOwner: TComponent);
begin
  inherited;
  // Копируем базовый запрос и параметры
  //AssignFrom(fdqBase);

  AutoTransaction := False;
end;

function TQueryDescriptions.Check(const AComponentName, ADescription: String;
  AProducerID: Integer): TRecordCheck;
begin
  Result.ErrorType := etNone;

  // Ищем компонент
  if not CheckClone.LocateEx(ComponentName.FieldName, AComponentName,
    [lxoCaseInsensitive]) then
    Exit;

  // Сравниваем описания
  if Description.AsString = ADescription then
  begin
    Result.ErrorType := etError;
    Result.Description := 'Такое описание уже есть в справочнике';
  end
  else
  begin
    Result.ErrorType := etWarring;
    Result.Description :=
      'Компонент с таким наименованием имеет другое описание в справочнике';
  end;
end;

function TQueryDescriptions.GetCheckClone: TFDMemTable;
begin
  if FCheckClone = nil then
    FCheckClone := AddClone('');

  Result := FCheckClone;
end;

function TQueryDescriptions.GetComponentName: TField;
begin
  Result := Field('ComponentName');
end;

function TQueryDescriptions.GetDescription: TField;
begin
  Result := Field('Description');
end;

function TQueryDescriptions.GetIDComponentType: TField;
begin
  Result := Field('IDComponentType');
end;

function TQueryDescriptions.GetIDProducer: TField;
begin
  Result := Field('IDProducer');
end;

procedure TQueryDescriptions.SetShowDuplicate(const Value: Boolean);
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

end.
