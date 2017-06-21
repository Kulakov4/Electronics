unit QueryGroupUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  FireDAC.Comp.Client, QueryWithDataSourceUnit, System.Contnrs,
  ProducersExcelDataModule;

type
  TQueryGroup = class(TFrame)
    GridPanel1: TGridPanel;
  private
    FDetail: TQueryWithDataSource;
    FEventList: TObjectList;
    FMain: TQueryWithDataSource;
    function GetChangeCount: Integer;
    function GetConnection: TFDCustomConnection;
    procedure SetDetail(const Value: TQueryWithDataSource);
    procedure SetMain(const Value: TQueryWithDataSource);
    { Private declarations }
  protected
    procedure CheckMasterAndDetail;
    procedure InitializeQuery(AQuery: TFDQuery); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ApplyUpdates; virtual;
    procedure CancelUpdates; virtual;
    procedure Commit; virtual;
    procedure ReOpen; virtual;
    procedure Rollback; virtual;
    procedure TryPost;
    property ChangeCount: Integer read GetChangeCount;
    property Connection: TFDCustomConnection read GetConnection;
    property Detail: TQueryWithDataSource read FDetail write SetDetail;
    property Main: TQueryWithDataSource read FMain write SetMain;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TQueryGroup.Create(AOwner: TComponent);
begin
  inherited;
  FEventList := TObjectList.Create;
end;

destructor TQueryGroup.Destroy;
begin
  FreeAndNil(FEventList);
  try
    inherited;
  except
    ;
  end;
end;

procedure TQueryGroup.ApplyUpdates;
begin
  CheckMasterAndDetail;

  Main.TryPost;
  Detail.TryPost;

  Main.ApplyUpdates;
  Detail.ApplyUpdates;
end;

procedure TQueryGroup.CancelUpdates;
begin
  CheckMasterAndDetail;

  // отменяем все сделанные изменения на стороне клиента
  Main.CancelUpdates;
  Detail.CancelUpdates;
end;

procedure TQueryGroup.CheckMasterAndDetail;
begin
  Assert(Main <> nil);
  Assert(Detail <> nil);
end;

procedure TQueryGroup.Commit;
begin
  CheckMasterAndDetail;
  // Предполагается что мы работаем в транзакции
  Assert(Connection.InTransaction);

  Main.TryPost;
  Detail.TryPost;

  if Connection.InTransaction then
    Connection.Commit;
end;

function TQueryGroup.GetChangeCount: Integer;
begin
  Assert(Main <> nil);
  Assert(Detail <> nil);
  Result := Main.FDQuery.ChangeCount + Detail.FDQuery.ChangeCount;
end;

function TQueryGroup.GetConnection: TFDCustomConnection;
begin
  Assert(Main <> nil);
  Result := Main.FDQuery.Connection;
end;

procedure TQueryGroup.InitializeQuery(AQuery: TFDQuery);
begin
  Assert(AQuery <> nil);
end;

procedure TQueryGroup.ReOpen;
begin
  Detail.FDQuery.Close;
  Main.FDQuery.Close;

  Main.FDQuery.Open;
  Detail.FDQuery.Open;
end;

procedure TQueryGroup.Rollback;
begin
  CheckMasterAndDetail;

  Detail.TryCancel;
  Main.TryCancel;

  // Предполагается что мы работаем в транзакции
  if Connection.InTransaction then
  begin
    Connection.Rollback;
    ReOpen;
  end;
  // Иногда транзакция уже завершилась но программа об этом не знает
end;

procedure TQueryGroup.SetDetail(const Value: TQueryWithDataSource);
begin
  if FDetail <> Value then
  begin
    FDetail := Value;
    InitializeQuery(FDetail.FDQuery);
  end;
end;

procedure TQueryGroup.SetMain(const Value: TQueryWithDataSource);
begin
  if FMain <> Value then
  begin
    FMain := Value;
    InitializeQuery(FMain.FDQuery);
  end;
end;

procedure TQueryGroup.TryPost;
begin
  Main.TryPost;
  Detail.TryPost;
end;

end.
