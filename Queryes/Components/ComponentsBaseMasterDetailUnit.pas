unit ComponentsBaseMasterDetailUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Comp.Client, Vcl.ExtCtrls, Data.DB,
  System.Generics.Collections, NotifyEvents, FireDAC.Comp.DataSet,
  Manufacturers2Query, BodyTypesQuery2, ExcelDataModule, CustomErrorTable,
  DocFieldInfo, SearchMainComponent, MasterDetailFrame, BodyTypesQuery,
  ComponentsBaseDetailQuery, CustomComponentsQuery,
  SearchMainComponent2, ProcRefUnit, SearchMainComponent3, TableWithProgress;

type
  TComponentsBaseMasterDetail = class(TfrmMasterDetail)
  strict private
  private
    FAfterApplyUpdates: TNotifyEventsEx;
    FFullDeleted: TList<Integer>;
    FBodyTypes: TQueryBodyTypes;
    FManufacturers: TQueryManufacturers2;
    FQuerySearchMainComponent3: TQuerySearchMainComponent3;
    FQuerySearchMainComponent2: TQuerySearchMainComponent2;
    function GetDetailComponentsQuery: TQueryComponentsBaseDetail;
    function GetMainComponentsQuery: TQueryCustomComponents;
    function GetQuerySearchMainComponent3: TQuerySearchMainComponent3;
    function GetQuerySearchMainComponent2: TQuerySearchMainComponent2;
    { Private declarations }
  protected
    procedure DeleteLostComponents;
    property QuerySearchMainComponent3: TQuerySearchMainComponent3
      read GetQuerySearchMainComponent3;
    property QuerySearchMainComponent2: TQuerySearchMainComponent2
      read GetQuerySearchMainComponent2;
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
    property DetailComponentsQuery: TQueryComponentsBaseDetail
      read GetDetailComponentsQuery;
    property MainComponentsQuery: TQueryCustomComponents
      read GetMainComponentsQuery;
    property Manufacturers: TQueryManufacturers2 read FManufacturers
      write FManufacturers;
    { Public declarations }
  end;

implementation

uses LostComponentsQuery, RepositoryDataModule, System.Math, System.IOUtils,
  SettingsController, System.Types, AllMainComponentsQuery,
  ProjectConst, StrHelper, BaseQuery;

{$R *.dfm}

constructor TComponentsBaseMasterDetail.Create(AOwner: TComponent);
begin
  inherited;
  FFullDeleted := TList<Integer>.Create;

  // Создаём событие
  FAfterApplyUpdates := TNotifyEventsEx.Create(Self);
end;

destructor TComponentsBaseMasterDetail.Destroy;
begin
  FreeAndNil(FFullDeleted);
  inherited;
end;

// Удаляет "Потерянные" компоненты.
// Почему они теряются, надо ещё разобраться
procedure TComponentsBaseMasterDetail.DeleteLostComponents;
var
  AQuery: TDeleteLostComponentsQuery;
begin
  AQuery := TDeleteLostComponentsQuery.Create(Self);
  try
    AQuery.Connection := Main.FDQuery.Connection;
    // AQuery.Connection := FDTransaction.Connection;
    // AQuery.Transaction := FDTransaction;
    AQuery.ExecSQL;
  finally
    FreeAndNil(AQuery);
  end;
end;

procedure TComponentsBaseMasterDetail.Commit;
begin
  inherited;
  FFullDeleted.Clear;
end;

function TComponentsBaseMasterDetail.GetDetailComponentsQuery
  : TQueryComponentsBaseDetail;
begin
  Assert(Detail <> nil);
  Result := Detail as TQueryComponentsBaseDetail;
end;

function TComponentsBaseMasterDetail.GetMainComponentsQuery
  : TQueryCustomComponents;
begin
  Assert(Main <> nil);
  Result := Main as TQueryCustomComponents;
end;

function TComponentsBaseMasterDetail.GetQuerySearchMainComponent3
  : TQuerySearchMainComponent3;
begin
  if FQuerySearchMainComponent3 = nil then
    FQuerySearchMainComponent3 := TQuerySearchMainComponent3.Create(Self);

  Result := FQuerySearchMainComponent3;
end;

function TComponentsBaseMasterDetail.GetQuerySearchMainComponent2
  : TQuerySearchMainComponent2;
begin
  if FQuerySearchMainComponent2 = nil then
    FQuerySearchMainComponent2 := TQuerySearchMainComponent2.Create(Self);

  Result := FQuerySearchMainComponent2;
end;

procedure TComponentsBaseMasterDetail.LoadDocFile(const AFileName: String;
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

procedure TComponentsBaseMasterDetail.ReOpen;
begin
  // Сначала обновим детали, чтобы при обновлении мастера знать сколько у него дочерних
  Detail.RefreshQuery;
  Main.RefreshQuery;
end;

procedure TComponentsBaseMasterDetail.Rollback;
begin
  inherited;
  FFullDeleted.Clear;
end;

end.
