unit ProductsSearchQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DataModuleFrame, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  ProductsBaseQuery, SearchInterfaceUnit, ApplyQueryFrame,
  SearchComponentsByValues, StoreHouseListQuery;

type
  TQueryProductsSearch = class(TQueryProductsBase)
  strict private
  private
    FClone: TFDMemTable;
    FGetModeClone: TFDMemTable;
    FMode: TContentMode;
    FQuerySearchComponentsByValues: TQuerySearchComponentsByValues;
    FQueryStoreHouseList: TQueryStoreHouseList;

  const
    FEmptyAmount = 1;
    function GetCurrentMode: TContentMode;
    procedure DoAfterClose(Sender: TObject);
    procedure DoAfterOpen(Sender: TObject);
    function GetIsClearEnabled: Boolean;
    function GetIsSearchEnabled: Boolean;
    function GetQuerySearchComponentsByValues: TQuerySearchComponentsByValues;
    { Private declarations }
  protected
    procedure ApplyDelete(ASender: TDataSet); override;
    procedure ApplyInsert(ASender: TDataSet); override;
    procedure ApplyUpdate(ASender: TDataSet); override;
    function GetHaveAnyChanges: Boolean; override;
    procedure Search(const AIDList: string); stdcall;
    property QuerySearchComponentsByValues: TQuerySearchComponentsByValues
      read GetQuerySearchComponentsByValues;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AppendRows(AFieldName: string; AValues: TArray<String>); override;
    procedure ClearSearchResult;
    procedure DoSearch;
    property IsClearEnabled: Boolean read GetIsClearEnabled;
    property IsSearchEnabled: Boolean read GetIsSearchEnabled;
    property Mode: TContentMode read FMode;
    property QueryStoreHouseList: TQueryStoreHouseList read FQueryStoreHouseList
      write FQueryStoreHouseList;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses NotifyEvents, System.Math, RepositoryDataModule;

constructor TQueryProductsSearch.Create(AOwner: TComponent);
begin
  inherited;

  // В режиме поиска - транзакции автоматом
  AutoTransaction := True;

  // Создаём два клона
  FGetModeClone := TFDMemTable.Create(Self);
  FClone := TFDMemTable.Create(Self);

  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, FEventList);
  TNotifyEventWrap.Create(AfterClose, DoAfterClose, FEventList);
end;

procedure TQueryProductsSearch.AppendRows(AFieldName: string;
  AValues: TArray<String>);
begin
  if Mode = SearchMode then
  begin
    // Удаляем пустую строку
    if Value.AsString.IsEmpty then
      FDQuery.Delete;

    inherited;
  end;

end;

procedure TQueryProductsSearch.ApplyDelete(ASender: TDataSet);
begin
  if Mode = RecordsMode then
    inherited;
end;

procedure TQueryProductsSearch.ApplyInsert(ASender: TDataSet);
begin
  // Ничего не делаем
end;

procedure TQueryProductsSearch.ApplyUpdate(ASender: TDataSet);
begin
  if Mode = RecordsMode then
    inherited;
end;

function TQueryProductsSearch.GetCurrentMode: TContentMode;
begin
  if (FDQuery.RecordCount = 0) or (FGetModeClone.RecordCount > 0) then
    Result := RecordsMode
  else
    Result := SearchMode;
end;

procedure TQueryProductsSearch.ClearSearchResult;
begin
  Search('');
end;

procedure TQueryProductsSearch.DoAfterClose(Sender: TObject);
begin
  FGetModeClone.Close;
  FClone.Close;
end;

procedure TQueryProductsSearch.DoAfterOpen(Sender: TObject);
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

  for I := 0 to FDQuery.FieldCount - 1 do
    FDQuery.Fields[I].ReadOnly := False;

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

procedure TQueryProductsSearch.DoSearch;
var
  s: string;

begin
  TryPost;

  // Формируем через запятую список из значений поля Value
  s := GetFieldValues('Value').Trim([',']);

  // Ищем компоненты по их именам
  QuerySearchComponentsByValues.Search(s);

  // Получаем идентификаторы найденых компонентов
  s := QuerySearchComponentsByValues.GetFieldValues('ID').Trim([',']);

  Search(s);

end;

// Есть-ли изменения не сохранённые в БД
function TQueryProductsSearch.GetHaveAnyChanges: Boolean;
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

function TQueryProductsSearch.GetIsClearEnabled: Boolean;
begin
  Result := (Mode = RecordsMode);

  if not Result then
  begin
    Result := FClone.RecordCount > 0;
  end;
end;

function TQueryProductsSearch.GetIsSearchEnabled: Boolean;
begin
  Result := (Mode = SearchMode) and (FClone.RecordCount > 0);
end;

function TQueryProductsSearch.GetQuerySearchComponentsByValues
  : TQuerySearchComponentsByValues;
begin
  if FQuerySearchComponentsByValues = nil then
    FQuerySearchComponentsByValues :=
      TQuerySearchComponentsByValues.Create(Self);

  Result := FQuerySearchComponentsByValues;
end;

procedure TQueryProductsSearch.Search(const AIDList: string);
begin
  Load(['IDList'], [AIDList])
  // При открытии будет добавлена пустая запись, если нужно
end;

end.
