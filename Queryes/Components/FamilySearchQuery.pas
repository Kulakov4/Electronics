unit FamilySearchQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  SearchInterfaceUnit, CustomComponentsQuery, ApplyQueryFrame, BaseFamilyQuery,
  DSWrap, SearchFamOrCompoQuery, System.Generics.Collections;

type
  TFamilySearchW = class(TBaseFamilyW)
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
    FqSearchFamilyOrComp: TQuerySearchFamilyOrComp;
    procedure DoAfterOpen(Sender: TObject);
    function GetCurrentMode: TContentMode;
    function GetFamilySearchW: TFamilySearchW;
    function GetIsClearEnabled: Boolean;
    function GetIsSearchEnabled: Boolean;
    function GetqSearchFamilyOrComp: TQuerySearchFamilyOrComp;
    { Private declarations }
  protected
    procedure ApplyDelete(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure ApplyInsert(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure ApplyUpdate(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    function CreateDSWrap: TDSWrap; override;
    function GetHaveAnyChanges: Boolean; override;
    property qSearchFamilyOrComp: TQuerySearchFamilyOrComp
      read GetqSearchFamilyOrComp;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AfterConstruction; override;
    procedure ClearSearchResult;
    procedure SearchByValue(AValues: TArray<String>; ALike: Boolean);
    property FamilySearchW: TFamilySearchW read GetFamilySearchW;
    property IsClearEnabled: Boolean read GetIsClearEnabled;
    property IsSearchEnabled: Boolean read GetIsSearchEnabled;
    { Public declarations }
  end;

implementation

Uses NotifyEvents, System.Math, DBRecordHolder, StrHelper;

{$R *.dfm}
{ TfrmQueryComponentsContent }

constructor TQueryFamilySearch.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  // В режиме поиска - транзакции автоматом
  AutoTransaction := True;

  // Создаём два клона
  FGetModeClone := W.AddClone(Format('%s > 0', [W.ID.FieldName]));
  FClone := W.AddClone(Format('%s <> null', [W.Value.FieldName]));

  // Подписываемся на событие
  TNotifyEventWrap.Create(W.AfterOpen, DoAfterOpen, W.EventList);
end;

procedure TQueryFamilySearch.AfterConstruction;
begin
  inherited;
  // Подставляем заведомо ложное условие чтобы очистить список
  FDQuery.SQL.Text := ReplaceInSQL(SQL, '0=1', 0);
end;

procedure TQueryFamilySearch.ApplyDelete(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
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
  // Подставляем заведомо ложное условие чтобы очистить список
  FDQuery.SQL.Text := ReplaceInSQL(SQL, '0=1', 0);
  W.RefreshQuery;
end;

function TQueryFamilySearch.CreateDSWrap: TDSWrap;
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
    W.SetFieldsReadOnly(False);
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

function TQueryFamilySearch.GetqSearchFamilyOrComp: TQuerySearchFamilyOrComp;
begin
  if FqSearchFamilyOrComp = nil then
    FqSearchFamilyOrComp := TQuerySearchFamilyOrComp.Create(Self);

  Result := FqSearchFamilyOrComp;
end;

procedure TQueryFamilySearch.SearchByValue(AValues: TArray<String>;
  ALike: Boolean);
var
  AStipulation: string;
begin
  // Готовим SQL запрос для поиска семейств
  qSearchFamilyOrComp.PrepareSearchByValue(AValues, ALike, True);

  AStipulation := Format('%s in (%s)',
    [W.ID.FullName, qSearchFamilyOrComp.FDQuery.SQL.Text]);

  FDQuery.SQL.Text := ReplaceInSQL(SQL, AStipulation, 0);
  W.RefreshQuery;
end;

procedure TFamilySearchW.AppendRows(AFieldName: string;
  AValues: TArray<String>);
var
  AValues2: TArray<String>;
  l: Integer;
begin
  // Если вставлять нечего
  if Length(AValues) = 0 then
    Exit;

  if Mode = SearchMode then
  begin
    // Сохраняем первое значение в пустой строке
    if Value.F.AsString.IsEmpty then
    begin
      TryEdit;
      Value.F.AsString := AValues[0];
      TryPost;
    end;

    l := Length(AValues);
    if l = 1 then
      Exit;

    SetLength(AValues2, Length(AValues) - 1);
    TArray.Copy<String>(AValues, AValues2, 1, 0, l - 1);
    inherited AppendRows(AFieldName, AValues2);
  end;

end;

end.
