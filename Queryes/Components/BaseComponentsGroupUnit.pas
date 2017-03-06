unit BaseComponentsGroupUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Comp.Client, Vcl.ExtCtrls, Data.DB,
  System.Generics.Collections, NotifyEvents, FireDAC.Comp.DataSet,
  ProducersQuery, BodyTypesQuery2, ExcelDataModule, CustomErrorTable,
  DocFieldInfo, BodyTypesQuery, CustomComponentsQuery, ProcRefUnit,
  TableWithProgress, BaseComponentsQuery, BaseFamilyQuery, QueryGroupUnit;

type
  TBaseComponentsGroup = class(TQueryGroup)
  strict private
  private
    FAfterApplyUpdates: TNotifyEventsEx;
    FFullDeleted: TList<Integer>;
    FBodyTypes: TQueryBodyTypes;
    FProducers: TQueryProducers;
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
    procedure ReOpen; override;
    procedure Rollback; override;
    property AfterApplyUpdates: TNotifyEventsEx read FAfterApplyUpdates;
    property BodyTypes: TQueryBodyTypes read FBodyTypes write FBodyTypes;
    property FullDeleted: TList<Integer> read FFullDeleted;
    property QueryBaseComponents: TQueryBaseComponents read GetQueryBaseComponents;
    property QueryBaseFamily: TQueryBaseFamily read GetQueryBaseFamily;
    property Producers: TQueryProducers read FProducers write FProducers;
    { Public declarations }
  end;

implementation

uses RepositoryDataModule, System.Math, System.IOUtils, SettingsController,
  System.Types, ProjectConst, StrHelper, BaseQuery;

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

function TBaseComponentsGroup.GetQueryBaseComponents:
    TQueryBaseComponents;
begin
  Assert(Detail <> nil);
  Result := Detail as TQueryBaseComponents;
end;

function TBaseComponentsGroup.GetQueryBaseFamily: TQueryBaseFamily;
begin
  Assert(Main <> nil);
  Result := Main as TQueryBaseFamily;
end;

procedure TBaseComponentsGroup.LoadDocFile(const AFileName: String;
  ADocFieldInfo: TDocFieldInfo);
var
  S: string;
begin
  if not AFileName.IsEmpty then
  begin
    // В БД храним путь до файла относительно папки с документацией
    S := GetRelativeFileName(AFileName, ADocFieldInfo.Folder);
    Main.TryEdit;
    Main.FDQuery.FieldByName(ADocFieldInfo.FieldName).AsString := S;
    Main.TryPost;
  end;
end;

procedure TBaseComponentsGroup.ReOpen;
begin
  // Сначала обновим детали, чтобы при обновлении мастера знать сколько у него дочерних
  Detail.RefreshQuery;
  Main.RefreshQuery;
end;

procedure TBaseComponentsGroup.Rollback;
begin
  inherited;
  FFullDeleted.Clear;
end;

end.
