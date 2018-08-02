unit BaseComponentsGroupUnit2;

interface

uses
  QueryGroupUnit2, NotifyEvents, System.Classes, System.Generics.Collections,
  ProducersQuery, BaseComponentsQuery, BaseFamilyQuery, DocFieldInfo;

type
  TBaseComponentsGroup2 = class(TQueryGroup2)
  private
    FAfterApplyUpdates: TNotifyEventsEx;
    FFullDeleted: TList<Integer>;
    FProducers: TQueryProducers;
    function GetProducers: TQueryProducers;
    function GetQueryBaseComponents: TQueryBaseComponents;
    function GetQueryBaseFamily: TQueryBaseFamily;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Commit; override;
    procedure LoadDocFile(const AFileName: String; ADocFieldInfo: TDocFieldInfo);
    procedure Rollback; override;
    property AfterApplyUpdates: TNotifyEventsEx read FAfterApplyUpdates;
    property FullDeleted: TList<Integer> read FFullDeleted;
    property Producers: TQueryProducers read GetProducers;
    property QueryBaseComponents: TQueryBaseComponents read GetQueryBaseComponents;
    property QueryBaseFamily: TQueryBaseFamily read GetQueryBaseFamily;
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

procedure TBaseComponentsGroup2.Commit;
begin
  inherited;
  FFullDeleted.Clear;
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

function TBaseComponentsGroup2.GetQueryBaseComponents: TQueryBaseComponents;
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

function TBaseComponentsGroup2.GetQueryBaseFamily: TQueryBaseFamily;
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
    IsEdited := not QueryBaseFamily.TryEdit;
    QueryBaseFamily.FDQuery.FieldByName(ADocFieldInfo.FieldName).AsString := S;

    // Сохраняем только если запись уже была сохранена до редактирования
    if not IsEdited then
      QueryBaseFamily.TryPost;
  end;
end;

procedure TBaseComponentsGroup2.Rollback;
begin
  inherited;
  FFullDeleted.Clear;
end;

end.
