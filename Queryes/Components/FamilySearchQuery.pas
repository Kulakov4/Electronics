unit FamilySearchQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  SearchInterfaceUnit, CustomComponentsQuery, ApplyQueryFrame, BaseFamilyQuery;

type
  TFamilySearchW = class(TCustomComponentsW)
  private
    FMode: TContentMode;
  public
    procedure AppendRows(AFieldName: string; AValues: TArray<String>); override;
    property Mode: TContentMode read FMode;
  end;

  TQueryFamilySearch = class(TQueryBaseFamily)
  strict private
  private const
    FEmptyAmount = 1;
  var
    FGetModeClone: TFDMemTable;
    FClone: TFDMemTable;
    procedure DoAfterOpen(Sender: TObject);
    function GetCurrentMode: TContentMode;
    function GetFamilySearchW: TFamilySearchW;
    function GetIsClearEnabled: Boolean;
    function GetIsSearchEnabled: Boolean;
    { Private declarations }
  protected
    procedure ApplyDelete(ASender: TDataSet; ARequest: TFDUpdateRequest;
  var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure ApplyInsert(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure ApplyUpdate(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    function CreateDataSetWrap: TCustomComponentsW; override;
    function GetHaveAnyChanges: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure ClearSearchResult;
    procedure Search(const AIDList: string); stdcall;
    property FamilySearchW: TFamilySearchW read GetFamilySearchW;
    property IsClearEnabled: Boolean read GetIsClearEnabled;
    property IsSearchEnabled: Boolean read GetIsSearchEnabled;
    { Public declarations }
  end;

implementation

Uses NotifyEvents, System.Math, DBRecordHolder;

{$R *.dfm}
{ TfrmQueryComponentsContent }

constructor TQueryFamilySearch.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  // В режиме поиска - транзакции автоматом
  AutoTransaction := True;

  // Создаём два клона
  FGetModeClone := AddClone('ID > 0');
  FClone := AddClone('Value <> null');

  // Подписываемся на событие
  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, FEventList);
end;

procedure TQueryFamilySearch.ApplyDelete(ASender: TDataSet; ARequest: TFDUpdateRequest;
  var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions);
begin
  if FamilySearchW.Mode = RecordsMode then
    inherited;
end;

procedure TQueryFamilySearch.ApplyInsert(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  // Ничего не сохраняем на сервер
end;

procedure TQueryFamilySearch.ApplyUpdate(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  if FamilySearchW.Mode = RecordsMode then
    inherited;
end;

procedure TQueryFamilySearch.ClearSearchResult;
begin
  // Ищем пустое значение - и ничего не находим
  Search('');
end;

function TQueryFamilySearch.CreateDataSetWrap: TCustomComponentsW;
begin
  Result := TFamilySearchW.Create(FDQuery);
end;

procedure TQueryFamilySearch.DoAfterOpen(Sender: TObject);
var
  I: Integer;
begin
  W.SubGroup.F.ReadOnly := False;

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
  FamilySearchW.FMode := GetCurrentMode;

  // Выбираем нужный режим транзакции
  AutoTransaction := FamilySearchW.Mode = SearchMode;

  if FamilySearchW.Mode = RecordsMode then
    SetFieldsReadOnly(False);
end;

function TQueryFamilySearch.GetCurrentMode: TContentMode;
begin
  if (FDQuery.RecordCount = 0) or (FGetModeClone.RecordCount > 0) then
    Result := RecordsMode
  else
    Result := SearchMode;
end;

function TQueryFamilySearch.GetFamilySearchW: TFamilySearchW;
begin
  Result := W as TFamilySearchW;
end;

// Есть-ли изменения не сохранённые в БД
function TQueryFamilySearch.GetHaveAnyChanges: Boolean;
begin
  Result := False;

  case FamilySearchW.Mode of
    RecordsMode:
      Result := inherited;
    SearchMode:
      Result := False;
  else
    Assert(False);
  end;
end;

function TQueryFamilySearch.GetIsClearEnabled: Boolean;
begin
  Result := (FamilySearchW.Mode = RecordsMode);

  if not Result then
  begin
    Result := FClone.RecordCount > 0;
  end;
end;

function TQueryFamilySearch.GetIsSearchEnabled: Boolean;
begin
  Result := (FamilySearchW.Mode = SearchMode) and (FClone.RecordCount > 0);
end;

procedure TQueryFamilySearch.Search(const AIDList: string);
begin
  // Загружаем компоенты по их идентификаторам
  Load(['IDList'], [AIDList]);

  // При открытии будет добавлена пустая запись
end;

procedure TFamilySearchW.AppendRows(AFieldName: string; AValues:
    TArray<String>);
begin
  // Если вставлять нечего
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
