unit BaseComponentsGroupUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Comp.Client, Vcl.ExtCtrls, Data.DB,
  System.Generics.Collections, NotifyEvents, FireDAC.Comp.DataSet,
  ProducersQuery, BodyTypesQuery2, ExcelDataModule, CustomErrorTable,
  DocFieldInfo, CustomComponentsQuery, ProcRefUnit,
  TableWithProgress, BaseComponentsQuery, BaseFamilyQuery, QueryGroupUnit;

type
  TBaseComponentsGroup = class(TQueryGroup)
  strict private
  private
    FAfterApplyUpdates: TNotifyEventsEx;
    FFullDeleted: TList<Integer>;
    FProducers: TQueryProducers;
    function GetProducers: TQueryProducers;
    function GetQueryBaseComponents: TQueryBaseComponents;
    function GetQueryBaseFamily: TQueryBaseFamily;
    { Private declarations }
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Commit; override;
    procedure LoadDocFile(const AFileName: String;
      ADocFieldInfo: TDocFieldInfo);
    procedure Rollback; override;
    property AfterApplyUpdates: TNotifyEventsEx read FAfterApplyUpdates;
    property FullDeleted: TList<Integer> read FFullDeleted;
    property QueryBaseComponents: TQueryBaseComponents read GetQueryBaseComponents;
    property QueryBaseFamily: TQueryBaseFamily read GetQueryBaseFamily;
    property Producers: TQueryProducers read GetProducers;
    { Public declarations }
  end;

implementation

uses RepositoryDataModule, System.Math, System.IOUtils, SettingsController,
  System.Types, ProjectConst, StrHelper, BaseQuery, BaseEventsQuery;

{$R *.dfm}

constructor TBaseComponentsGroup.Create(AOwner: TComponent);
begin
  inherited;
  FFullDeleted := TList<Integer>.Create;

  // Создаём событие
  FAfterApplyUpdates := TNotifyEventsEx.Create(Self);
end;

destructor TBaseComponentsGroup.Destroy;
begin
  FreeAndNil(FFullDeleted);
  inherited;
end;

procedure TBaseComponentsGroup.Commit;
begin
  inherited;
  FFullDeleted.Clear;
end;

function TBaseComponentsGroup.GetProducers: TQueryProducers;
begin
  if FProducers = nil then
  begin
    FProducers := TQueryProducers.Create(Self);
    FProducers.FDQuery.Open;
  end;
  Result := FProducers;
end;

function TBaseComponentsGroup.GetQueryBaseComponents: TQueryBaseComponents;
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

function TBaseComponentsGroup.GetQueryBaseFamily: TQueryBaseFamily;
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

procedure TBaseComponentsGroup.LoadDocFile(const AFileName: String;
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

procedure TBaseComponentsGroup.Rollback;
begin
  inherited;
  FFullDeleted.Clear;
end;

end.
