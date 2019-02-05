unit DescriptionsQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, QueryWithDataSourceUnit,
  DescriptionsInterface, RecordCheck, DSWrap;

type
  TDescriptionW = class(TDSWrap)
  private
    FComponentName: TFieldWrap;
    FDescription: TFieldWrap;
    FIDComponentType: TFieldWrap;
    FIDProducer: TFieldWrap;
    FID: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    property ComponentName: TFieldWrap read FComponentName;
    property Description: TFieldWrap read FDescription;
    property IDComponentType: TFieldWrap read FIDComponentType;
    property IDProducer: TFieldWrap read FIDProducer;
    property ID: TFieldWrap read FID;
  end;

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
    FW: TDescriptionW;
    function GetCheckClone: TFDMemTable;
    procedure SetShowDuplicate(const Value: Boolean);
    { Private declarations }
  protected
    function CreateDSWrap: TDSWrap; override;
    property CheckClone: TFDMemTable read GetCheckClone;
  public
    constructor Create(AOwner: TComponent); override;
    property ShowDuplicate: Boolean read FShowDuplicate write SetShowDuplicate;
    property W: TDescriptionW read FW;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses RepositoryDataModule, NotifyEvents, StrHelper, ErrorType;

constructor TQueryDescriptions.Create(AOwner: TComponent);
begin
  inherited;
  FW := FDSWrap as TDescriptionW;

  AutoTransaction := False;
end;

function TQueryDescriptions.Check(const AComponentName, ADescription: String;
  AProducerID: Integer): TRecordCheck;
begin
  Result.ErrorType := etNone;

  // Ищем компонент
  if not CheckClone.LocateEx(W.ComponentName.FieldName, AComponentName,
    [lxoCaseInsensitive]) then
    Exit;

  // Сравниваем описания
  if W.Description.F.AsString = ADescription then
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

function TQueryDescriptions.CreateDSWrap: TDSWrap;
begin
  Result := TDescriptionW.Create(FDQuery);
end;

function TQueryDescriptions.GetCheckClone: TFDMemTable;
begin
  if FCheckClone = nil then
    FCheckClone := W.AddClone('');

  Result := FCheckClone;
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

constructor TDescriptionW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'ID', '', True);
  FComponentName := TFieldWrap.Create(Self, 'ComponentName');
  FDescription := TFieldWrap.Create(Self, 'Description');
  FIDComponentType := TFieldWrap.Create(Self, 'IDComponentType');
  FIDProducer := TFieldWrap.Create(Self, 'IDProducer');
end;

end.
