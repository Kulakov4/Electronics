unit ComponentsSearchQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  SearchInterfaceUnit, CustomComponentsQuery, ApplyQueryFrame,
  MainComponentsQuery;

type

  TQueryComponentsSearch = class(TQueryMainComponents)
  strict private
  private const
    FEmptyAmount = 1;

  var
    FGetModeClone: TFDMemTable;
    FClone: TFDMemTable;
    FMode: TContentMode;
    procedure DoAfterClose(Sender: TObject);
    procedure DoAfterOpen(Sender: TObject);
    function GetCurrentMode: TContentMode;
    function GetIsClearEnabled: Boolean;
    function GetIsSearchEnabled: Boolean;
    { Private declarations }
  protected
    procedure ApplyDelete(ASender: TDataSet); override;
    procedure ApplyInsert(ASender: TDataSet); override;
    procedure ApplyUpdate(ASender: TDataSet); override;
    function GetHaveAnyChanges: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AppendRows(AFieldName: string; AValues: TArray<String>); override;
    procedure ClearSearchResult;
    procedure Search(const AIDList: string); stdcall;
    property IsClearEnabled: Boolean read GetIsClearEnabled;
    property IsSearchEnabled: Boolean read GetIsSearchEnabled;
    property Mode: TContentMode read FMode;
    { Public declarations }
  end;

implementation

Uses NotifyEvents, System.Math, DBRecordHolder;

{$R *.dfm}
{ TfrmQueryComponentsContent }

constructor TQueryComponentsSearch.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  // В режиме поиска - транзакции автоматом
  AutoTransaction := True;

  // Создаём два клона
  FGetModeClone := TFDMemTable.Create(Self);
  FClone := TFDMemTable.Create(Self);

  // Подписываемся на событие
  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, FEventList);
  TNotifyEventWrap.Create(AfterClose, DoAfterClose, FEventList);
end;

procedure TQueryComponentsSearch.AppendRows(AFieldName: string; AValues:
    TArray<String>);
begin
  if Mode = SearchMode then
  begin
    // Удаляем пустую строку
    if Value.AsString.IsEmpty then
      FDQuery.Delete;

    inherited;
  end;

end;

procedure TQueryComponentsSearch.ApplyDelete(ASender: TDataSet);
begin
  if Mode = RecordsMode then
    inherited;
end;

procedure TQueryComponentsSearch.ApplyInsert(ASender: TDataSet);
begin
  // Ничего не сохраняем на сервер
end;

procedure TQueryComponentsSearch.ApplyUpdate(ASender: TDataSet);
begin
  if Mode = RecordsMode then
    inherited;
end;

procedure TQueryComponentsSearch.ClearSearchResult;
begin
  // Ищем пустое значение - и ничего не находим
  Search('');
end;

procedure TQueryComponentsSearch.DoAfterClose(Sender: TObject);
begin
  FGetModeClone.Close;
  FClone.Close;
end;

procedure TQueryComponentsSearch.DoAfterOpen(Sender: TObject);
var
  I: Integer;
begin
  // Фильтруем клоны
  FGetModeClone.CloneCursor(FDQuery);
  FGetModeClone.Filter := 'ID > 0';
  FGetModeClone.Filtered := True;

  FClone.CloneCursor(FDQuery);
  FClone.Filter := 'Value <> null';
  FClone.Filtered := True;

  FDQuery.FieldByName('subGroup').ReadOnly := False;

  // Добавляем пустую запись для поиска, если она необходима
  AutoTransaction := True;
  for I := FDQuery.RecordCount to FEmptyAmount - 1 do
  begin
    FDQuery.Append;
    FDQuery.Fields[1].AsString := '';
    FDQuery.Post;
  end;
  FDQuery.First;

  // Вычисляем в какой режим мы перешли
  FMode := GetCurrentMode;

  // Выбираем нужный режим транзакции
  AutoTransaction := Mode = SearchMode;
end;

function TQueryComponentsSearch.GetCurrentMode: TContentMode;
begin
  if (FDQuery.RecordCount = 0) or (FGetModeClone.RecordCount > 0) then
    Result := RecordsMode
  else
    Result := SearchMode;
end;

// Есть-ли изменения не сохранённые в БД
function TQueryComponentsSearch.GetHaveAnyChanges: Boolean;
begin
  Result := False;

  case Mode of
    RecordsMode:
      Result := inherited;
    SearchMode:
      Result := False;
  else
    Assert(False);
  end;
end;

function TQueryComponentsSearch.GetIsClearEnabled: Boolean;
begin
  Result := (Mode = RecordsMode);

  if not Result then
  begin
    Result := FClone.RecordCount > 0;
  end;
end;

function TQueryComponentsSearch.GetIsSearchEnabled: Boolean;
begin
  Result := (Mode = SearchMode) and (FClone.RecordCount > 0);
end;

procedure TQueryComponentsSearch.Search(const AIDList: string);
begin
  // Загружаем компоенты по их идентификаторам
  Load(['IDList'], [AIDList]);

  // При открытии будет добавлена пустая запись
end;

end.
