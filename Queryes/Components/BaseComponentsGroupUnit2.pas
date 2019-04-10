unit BaseComponentsGroupUnit2;

interface

uses
  QueryGroupUnit2, NotifyEvents, System.Classes, System.Generics.Collections,
  ProducersQuery, BaseComponentsQuery, BaseFamilyQuery, DocFieldInfo,
  ComponentsCountQuery, EmptyFamilyCountQuery;

type
  TBaseComponentsGroup2 = class(TQueryGroup2)
  private
    FAfterApplyUpdates: TNotifyEventsEx;
    FFullDeleted: TList<Integer>;
    FNeedUpdateCount: Boolean;
    FProducers: TQueryProducers;
    FQueryComponentsCount: TQueryComponentsCount;
    FQueryEmptyFamilyCount: TQueryEmptyFamilyCount;
    procedure AfterComponentPostOrDelete(Sender: TObject);
    function GetProducers: TQueryProducers;
    function GetqBaseComponents: TQueryBaseComponents;
    function GetqBaseFamily: TQueryBaseFamily;
    function GetQueryComponentsCount: TQueryComponentsCount;
    function GetQueryEmptyFamilyCount: TQueryEmptyFamilyCount;
    function GetTotalCount: Integer;
  protected
    property QueryComponentsCount: TQueryComponentsCount
      read GetQueryComponentsCount;
    property QueryEmptyFamilyCount: TQueryEmptyFamilyCount
      read GetQueryEmptyFamilyCount;
  public
    destructor Destroy; override;
    procedure Commit; override;
    procedure LoadDocFile(const AFileName: String;
      ADocFieldInfo: TDocFieldInfo);
    procedure Rollback; override;
    constructor Create(AOwner: TComponent); override;
    procedure AfterConstruction; override;
    property AfterApplyUpdates: TNotifyEventsEx read FAfterApplyUpdates;
    property FullDeleted: TList<Integer> read FFullDeleted;
    property Producers: TQueryProducers read GetProducers;
    property qBaseComponents: TQueryBaseComponents read GetqBaseComponents;
    property qBaseFamily: TQueryBaseFamily read GetqBaseFamily;
    property TotalCount: Integer read GetTotalCount;
  end;

implementation

uses
  System.SysUtils, BaseEventsQuery, StrHelper;

constructor TBaseComponentsGroup2.Create(AOwner: TComponent);
begin
  inherited;
  FFullDeleted := TList<Integer>.Create;

  // Создаём событие
  FAfterApplyUpdates := TNotifyEventsEx.Create(Self);
end;

destructor TBaseComponentsGroup2.Destroy;
begin
  FreeAndNil(FAfterApplyUpdates);
  FreeAndNil(FFullDeleted);
  inherited;
end;

procedure TBaseComponentsGroup2.AfterComponentPostOrDelete(Sender: TObject);
var
  S: string;
begin
  S := Sender.ClassName;
  FNeedUpdateCount := True;
end;

procedure TBaseComponentsGroup2.AfterConstruction;
begin
  TNotifyEventWrap.Create(qBaseFamily.W.AfterPostM, AfterComponentPostOrDelete,
    EventList);
  TNotifyEventWrap.Create(qBaseFamily.W.AfterDelete, AfterComponentPostOrDelete,
    EventList);

  TNotifyEventWrap.Create(qBaseComponents.W.AfterPostM,
    AfterComponentPostOrDelete, EventList);
  TNotifyEventWrap.Create(qBaseComponents.W.AfterDelete,
    AfterComponentPostOrDelete, EventList);
end;

procedure TBaseComponentsGroup2.Commit;
begin
  inherited;
  FFullDeleted.Clear;
  FNeedUpdateCount := True;
end;

function TBaseComponentsGroup2.GetProducers: TQueryProducers;
begin
  if FProducers = nil then
  begin
    FProducers := TQueryProducers.Create(Self);
    FProducers.FDQuery.Open;
  end;
  Result := FProducers;
end;

function TBaseComponentsGroup2.GetqBaseComponents: TQueryBaseComponents;
var
  Q: TQueryBaseEvents;
begin
  Assert(QList.Count > 0);
  Result := nil;

  for Q in QList do
  begin
    if Q is TQueryBaseComponents then
    begin
      Result := Q as TQueryBaseComponents;
      Exit;
    end;
  end;
  Assert(Result <> nil);
end;

function TBaseComponentsGroup2.GetqBaseFamily: TQueryBaseFamily;
var
  Q: TQueryBaseEvents;
begin
  Assert(QList.Count > 0);
  Result := nil;

  for Q in QList do
  begin
    if Q is TQueryBaseFamily then
    begin
      Result := Q as TQueryBaseFamily;
      Exit;
    end;
  end;
  Assert(Result <> nil);
end;

function TBaseComponentsGroup2.GetQueryComponentsCount: TQueryComponentsCount;
begin
  if FQueryComponentsCount = nil then
  begin
    FQueryComponentsCount := TQueryComponentsCount.Create(Self);
    // FQueryComponentsCount.FDQuery.Connection := qBaseFamily.FDQuery.Connection;
  end;
  Result := FQueryComponentsCount;
end;

function TBaseComponentsGroup2.GetQueryEmptyFamilyCount: TQueryEmptyFamilyCount;
begin
  if FQueryEmptyFamilyCount = nil then
  begin
    FQueryEmptyFamilyCount := TQueryEmptyFamilyCount.Create(Self);
    // FQueryEmptyFamilyCount.FDQuery.Connection := qBaseFamily.FDQuery.Connection;
  end;
  Result := FQueryEmptyFamilyCount;
end;

function TBaseComponentsGroup2.GetTotalCount: Integer;
var
  x: Integer;
begin
  if FNeedUpdateCount or not QueryEmptyFamilyCount.FDQuery.Active then
  begin
    // Обновляем кол-во компонентов без семей
    QueryEmptyFamilyCount.FDQuery.Close;
    QueryEmptyFamilyCount.FDQuery.Open;

    // Обновляем кол-во дочерних компонентов
    QueryComponentsCount.FDQuery.Close;
    QueryComponentsCount.FDQuery.Open;

    FNeedUpdateCount := false;
  end;
  x := QueryEmptyFamilyCount.Count + QueryComponentsCount.Count;
  Result := x;
end;

procedure TBaseComponentsGroup2.LoadDocFile(const AFileName: String;
  ADocFieldInfo: TDocFieldInfo);
var
  IsEdited: Boolean;
  S: string;
begin
  if not AFileName.IsEmpty then
  begin
    // В БД храним путь до файла относительно папки с документацией
    S := GetRelativeFileName(AFileName, ADocFieldInfo.Folder);
    IsEdited := not qBaseFamily.W.TryEdit;
    qBaseFamily.FDQuery.FieldByName(ADocFieldInfo.FieldName).AsString := S;

    // Сохраняем только если запись уже была сохранена до редактирования
    if not IsEdited then
      qBaseFamily.W.TryPost;
  end;
end;

procedure TBaseComponentsGroup2.Rollback;
begin
  inherited;
  FFullDeleted.Clear;
end;

end.
