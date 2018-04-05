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
  StoreHouseListQuery, NotifyEvents, System.Generics.Collections;

type
  TQueryProductsSearch = class(TQueryProductsBase)
    fdqBase: TFDQuery;
  strict private
  private
    FClone: TFDMemTable;
    FGetModeClone: TFDMemTable;
    FMode: TContentMode;
    FOnBeginUpdate: TNotifyEventsEx;
    FOnEndUpdate: TNotifyEventsEx;
    FqStoreHouseList: TQueryStoreHouseList;
    FX: Integer;

  const
    FEmptyAmount = 1;
    function GetCurrentMode: TContentMode;
    procedure DoAfterInsert(Sender: TObject);
    procedure DoAfterOpen(Sender: TObject);
    function GetIsClearEnabled: Boolean;
    function GetIsSearchEnabled: Boolean;
    function GetqStoreHouseList: TQueryStoreHouseList;
    { Private declarations }
  protected
    procedure ApplyDelete(ASender: TDataSet; ARequest: TFDUpdateRequest;
  var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure ApplyInsert(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure ApplyUpdate(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    function GetExportFileName: string; override;
    function GetHaveAnyChanges: Boolean; override;
    // procedure SetConditionSQL(const AConditionSQL, AMark: String;
    // ANotifyEventRef: TNotifyEventRef = nil);
  public
    constructor Create(AOwner: TComponent); override;
    procedure AppendRows(AFieldName: string; AValues: TArray<String>); override;
    procedure ClearSearchResult;
    procedure DoSearch(ALike: Boolean);
    procedure Search(AValues: TList<String>); overload;
    property IsClearEnabled: Boolean read GetIsClearEnabled;
    property IsSearchEnabled: Boolean read GetIsSearchEnabled;
    property Mode: TContentMode read FMode;
    property OnBeginUpdate: TNotifyEventsEx read FOnBeginUpdate;
    property OnEndUpdate: TNotifyEventsEx read FOnEndUpdate;
    property qStoreHouseList: TQueryStoreHouseList read GetqStoreHouseList;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses System.Math, RepositoryDataModule, System.StrUtils, StrHelper;

constructor TQueryProductsSearch.Create(AOwner: TComponent);
begin
  inherited;

  // В режиме поиска - транзакции автоматом
  AutoTransaction := True;

  FDQuery.SQL.Text := Replace(fdqBase.SQL.Text, 'where ID = 0', '--where');

  // Создаём два клона
  FGetModeClone := AddClone('ID > 0');
  FClone := AddClone('Value <> null');

  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, FEventList);
  TNotifyEventWrap.Create(AfterInsert, DoAfterInsert, FEventList);

  FOnBeginUpdate := TNotifyEventsEx.Create(Self);
  FOnEndUpdate := TNotifyEventsEx.Create(Self);
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

procedure TQueryProductsSearch.ApplyDelete(ASender: TDataSet; ARequest: TFDUpdateRequest;
  var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions);
begin
  if Mode = RecordsMode then
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
  SetConditionSQL(fdqBase.SQL.Text, 'where ID = 0', '--where');
end;


procedure TQueryProductsSearch.DoAfterInsert(Sender: TObject);
begin
  Inc(FX);
  PK.Value := -FX;
  IsGroup.AsInteger := 0;
end;

procedure TQueryProductsSearch.DoAfterOpen(Sender: TObject);
var
  I: Integer;
begin
  SetFieldsRequired(False);
  SetFieldsReadOnly(False);

  // Добавляем пустую запись для поиска, если она необходима
  AutoTransaction := True;

  for I := FDQuery.RecordCount to FEmptyAmount - 1 do
  begin
    FDQuery.Append;
    Value.AsString := '';
    FDQuery.Post;
  end;

  FDQuery.First;

  // Вычисляем в какой режим мы перешли
  FMode := GetCurrentMode;

  // Выбираем нужный режим транзакции
  AutoTransaction := Mode = SearchMode;
end;

procedure TQueryProductsSearch.DoSearch(ALike: Boolean);
var
  AConditionSQL: string;
  AMark1: string;
  AMark2: string;
  m: TArray<String>;
  s: string;
begin
  TryPost;

  AMark1 := '--join1';
  AMark2 := '--join2';

  // Формируем через запятую список из значений поля Value
  s := GetFieldValues('Value').Trim([',']);

  // Если поиск по пустой строке
  if s = '' then
    ALike := True;

  if ALike then
  begin
    AConditionSQL := '';
    m := s.Split([',']);
    // Формируем несколько условий
    for s in m do
    begin
      AConditionSQL := IfThen(AConditionSQL.IsEmpty, '', ' or ');
      AConditionSQL := AConditionSQL + Format('p.Value like %s',
        [QuotedStr(s + '%')]);
    end;

    if not AConditionSQL.IsEmpty then
      AConditionSQL := Format(' and (%s)', [AConditionSQL]);
  end
  else
  begin
    AConditionSQL :=
      ' and (instr('',''||:Value||'','', '',''||p.Value||'','') > 0)';
  end;

  FDQuery.Close;
  FDQuery.SQL.Text := Replace(fdqBase.SQL.Text, AConditionSQL, AMark1);
  FDQuery.SQL.Text := Replace(FDQuery.SQL.Text, AConditionSQL, AMark2);

  if not ALike then
  begin
    with FDQuery.ParamByName('Value') do
    begin
       DataType := ftWideString;
       ParamType := ptInput;
       AsString := s;
     end;
  end;

  FDQuery.Open;
end;

function TQueryProductsSearch.GetExportFileName: string;
begin
  Result := Format('Поиск %s.xls', [FormatDateTime('dd.mm.yyyy', Date)]);
  Assert(not Result.IsEmpty);
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

function TQueryProductsSearch.GetqStoreHouseList: TQueryStoreHouseList;
begin
  if FqStoreHouseList = nil then
  begin
    FqStoreHouseList := TQueryStoreHouseList.Create(Self);
    FqStoreHouseList.RefreshQuery;
  end;
  Result := FqStoreHouseList;
end;

procedure TQueryProductsSearch.Search(AValues: TList<String>);
begin
  FOnBeginUpdate.CallEventHandlers(Self);
  try
    // Очищаем результат поиска
    ClearSearchResult;

    // Добавляем те записи, которые будем искать на складе
    AppendRows(Value.FieldName, AValues.ToArray);

    // Осуществляем поиск
    DoSearch(False);
  finally
    FOnEndUpdate.CallEventHandlers(Self);
  end;
end;

end.
