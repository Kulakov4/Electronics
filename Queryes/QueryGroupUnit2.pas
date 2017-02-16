unit QueryGroupUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  FireDAC.Comp.Client, System.Contnrs, QueryWithDataSourceUnit;

type
  TQuerysGroup = class(TFrame)
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
    procedure ReOpen; virtual;
    procedure Rollback; virtual;
    procedure Commit; virtual;
    procedure TryPost;
    property ChangeCount: Integer read GetChangeCount;
    property Connection: TFDCustomConnection read GetConnection;
    property Detail: TQueryWithDataSource read FDetail write SetDetail;
    property Main: TQueryWithDataSource read FMain write SetMain;
    { Public declarations }
  end;

implementation

uses NotifyEvents;

{$R *.dfm}

constructor TQuerysGroup.Create(AOwner: TComponent);
begin
  inherited;
  FEventList := TObjectList.Create;
end;

destructor TQuerysGroup.Destroy;
begin
  FreeAndNil(FEventList);
  try
    inherited;
  except
    ;
  end;
end;

procedure TQuerysGroup.CheckMasterAndDetail;
begin
  Assert(Main <> nil);
  Assert(Detail <> nil);
end;

procedure TQuerysGroup.ApplyUpdates;
begin
  CheckMasterAndDetail;

  Main.TryPost;
  Detail.TryPost;

  Main.ApplyUpdates;
  Detail.ApplyUpdates;
end;

procedure TQuerysGroup.InitializeQuery(AQuery: TFDQuery);
begin
  Assert(AQuery <> nil);
end;

procedure TQuerysGroup.CancelUpdates;
begin
  CheckMasterAndDetail;

  // отменяем все сделанные изменения на стороне клиента
  Main.CancelUpdates;
  Detail.CancelUpdates;
end;

function TQuerysGroup.GetChangeCount: Integer;
begin
  Assert(Main <> nil);
  Assert(Detail <> nil);
  Result := Main.FDQuery.ChangeCount + Detail.FDQuery.ChangeCount;
end;

function TQuerysGroup.GetConnection: TFDCustomConnection;
begin
  Assert(Main <> nil);
  Result := Main.FDQuery.Connection;
end;

procedure TQuerysGroup.ReOpen;
begin
  Detail.FDQuery.Close;
  Main.FDQuery.Close;

  Main.FDQuery.Open;
  Detail.FDQuery.Open;
end;

procedure TQuerysGroup.Rollback;
begin
  CheckMasterAndDetail;
  // Предполагается что мы работаем в транзакции
  Assert(Connection.InTransaction);

  Detail.TryCancel;
  Main.TryCancel;

  Connection.Rollback;

  ReOpen;
end;

procedure TQuerysGroup.Commit;
begin
  CheckMasterAndDetail;
  // Предполагается что мы работаем в транзакции
  Assert(Connection.InTransaction);

  Main.TryPost;
  Detail.TryPost;

  Connection.Commit;
end;

procedure TQuerysGroup.SetDetail(const Value: TQueryWithDataSource);
begin
  if FDetail <> Value then
  begin
    FDetail := Value;
    InitializeQuery(FDetail.FDQuery);
  end;
end;

procedure TQuerysGroup.SetMain(const Value: TQueryWithDataSource);
begin
  if FMain <> Value then
  begin
    FMain := Value;
    InitializeQuery(FMain.FDQuery);
  end;
end;

procedure TQuerysGroup.TryPost;
begin
  Main.TryPost;
  Detail.TryPost;
end;

end.
