unit ProductsSearchQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  ProductsBaseQuery, SearchInterfaceUnit, ApplyQueryFrame,
  StoreHouseListQuery, NotifyEvents, System.Generics.Collections, DSWrap,
  ProducersGroupUnit2, ProductsSearchQry;

type
  TProductSearchW = class(TProductW)
  private
    FMode: TContentMode;
  public
    procedure AppendRows(AFieldName: string; AValues: TArray<String>); override;
    property Mode: TContentMode read FMode;
  end;

  TQueryProductsSearch = class(TQueryProductsBase)
  strict private
  private
    FOnBeginUpdate: TNotifyEventsEx;
    FOnEndUpdate: TNotifyEventsEx;
    FqProductsSearch: TQryProductsSearch;

    procedure DoAfterOpen(Sender: TObject);
    function GetProductSearchW: TProductSearchW;
    function GetqProductsSearch: TQryProductsSearch;
    { Private declarations }
  protected
    procedure ApplyDelete(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure ApplyInsert(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure ApplyUpdate(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    function CreateDSWrap: TDSWrap; override;
    procedure DoBeforePost(Sender: TObject); override;
    function GetHaveAnyChanges: Boolean; override;
    property qProductsSearch: TQryProductsSearch read GetqProductsSearch;
    // procedure SetConditionSQL(const AConditionSQL, AMark: String;
    // ANotifyEventRef: TNotifyEventRef = nil);
  public
    constructor Create(AOwner: TComponent;
      AProducersGroup: TProducersGroup2); override;
    destructor Destroy; override;
    procedure ClearSearchResult;
    function DoSearch(ALike: Boolean): Boolean;
    procedure Search(AValues: TList<String>); overload;
    property OnBeginUpdate: TNotifyEventsEx read FOnBeginUpdate;
    property OnEndUpdate: TNotifyEventsEx read FOnEndUpdate;
    property ProductSearchW: TProductSearchW read GetProductSearchW;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses System.Math, RepositoryDataModule, System.StrUtils, StrHelper;

constructor TQueryProductsSearch.Create(AOwner: TComponent;
  AProducersGroup: TProducersGroup2);
begin
  inherited;

  // В режиме поиска - транзакции автоматом
  AutoTransaction := True;

  TNotifyEventWrap.Create(W.AfterOpen, DoAfterOpen, W.EventList);
  TNotifyEventWrap.Create(W.AfterRefresh, DoAfterOpen, W.EventList);

  FOnBeginUpdate := TNotifyEventsEx.Create(Self);
  FOnEndUpdate := TNotifyEventsEx.Create(Self);
end;

destructor TQueryProductsSearch.Destroy;
begin
  FreeAndNil(FOnBeginUpdate);
  FreeAndNil(FOnEndUpdate);
  inherited;
end;

procedure TQueryProductsSearch.ApplyDelete(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  if ProductSearchW.Mode = RecordsMode then
    inherited;
end;

procedure TQueryProductsSearch.ApplyInsert(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  // Ничего не делаем
end;

procedure TQueryProductsSearch.ApplyUpdate(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  if ProductSearchW.Mode = RecordsMode then
    inherited;
end;

procedure TQueryProductsSearch.ClearSearchResult;
begin
  W.RefreshQuery;
end;

function TQueryProductsSearch.CreateDSWrap: TDSWrap;
begin
  Result := TProductSearchW.Create(FDQuery);
end;

procedure TQueryProductsSearch.DoAfterOpen(Sender: TObject);
begin
  W.SetFieldsRequired(False);
  W.SetFieldsReadOnly(False);

  if FDQuery.RecordCount > 0 then
    ProductSearchW.FMode := RecordsMode
  else
  begin
    ProductSearchW.FMode := SearchMode;
    FDQuery.Append;
    W.Value.F.AsString := '';
    FDQuery.Post;
    FDQuery.ApplyUpdates();
    FDQuery.CommitUpdates;
    // На самом деле никаких изменений в БД не пойдёт.
    // Запись добавиться только на стороне клиента
    FDQuery.First;
  end;
end;

procedure TQueryProductsSearch.DoBeforePost(Sender: TObject);
begin
  // Предполагаем что при поиске
  // записи на склад не вставляются и проверка не нужна!!!
  if (FDQuery.State <> dsEdit) or (ProductSearchW.FMode = SearchMode) then
    Exit;

  inherited;
end;

function TQueryProductsSearch.DoSearch(ALike: Boolean): Boolean;
var
  m: TArray<String>;
  s: string;
begin
  Assert(ProductSearchW.FMode = SearchMode);
  W.TryPost;

  // Формируем через запятую список из значений поля Value
  s := W.Value.AllValues;

  // Если поиск по пустой строке
  if s = '' then
    ALike := True;

  m := s.Split([',']);

  qProductsSearch.Search(m, ALike);
  Result := qProductsSearch.FDQuery.RecordCount > 0;

  if not Result then
    Exit;

  W.DeleteAll;
  FDQuery.BeginBatch();
  try
    W.CopyFrom(qProductsSearch.FDQuery);
  finally
    FDQuery.EndBatch;
  end;
  FDQuery.ApplyUpdates();
  FDQuery.CommitUpdates;

  qProductsSearch.FDQuery.Close;
  FreeAndNil(FqProductsSearch);

  FDQuery.First;
  Assert(FDQuery.RecordCount > 0);

  // Переходим в режим записей
  ProductSearchW.FMode := RecordsMode;
end;

// Есть-ли изменения не сохранённые в БД
function TQueryProductsSearch.GetHaveAnyChanges: Boolean;
begin
  Result := False;

  case ProductSearchW.Mode of
    RecordsMode:
      Result := inherited;
    SearchMode:
      Result := False;
  else
    Assert(False);
  end;
end;

function TQueryProductsSearch.GetProductSearchW: TProductSearchW;
begin
  Result := W as TProductSearchW;
end;

function TQueryProductsSearch.GetqProductsSearch: TQryProductsSearch;
begin
  if FqProductsSearch = nil then
    FqProductsSearch := TQryProductsSearch.Create(Self);

  Result := FqProductsSearch;
end;

procedure TQueryProductsSearch.Search(AValues: TList<String>);
begin
  FOnBeginUpdate.CallEventHandlers(Self);
  try
    // Очищаем результат поиска
    ClearSearchResult;

    // Добавляем те записи, которые будем искать на складе
    ProductSearchW.AppendRows(W.Value.FieldName, AValues.ToArray);

    // Осуществляем поиск
    DoSearch(False);
  finally
    FOnEndUpdate.CallEventHandlers(Self);
  end;
end;

procedure TProductSearchW.AppendRows(AFieldName: string;
  AValues: TArray<String>);
begin
  if Length(AValues) = 0 then
    Exit;

  if Mode = SearchMode then
  begin
    // Удаляем пустую строку
    if Value.F.AsString.IsEmpty then
      DataSet.Delete;

    inherited;
  end;

end;

end.
