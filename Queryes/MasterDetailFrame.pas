unit MasterDetailFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  FireDAC.Comp.Client, DataModuleFrame, System.Contnrs;

type
  TfrmMasterDetail = class(TFrame)
    GridPanel1: TGridPanel;
  private
    FDetail: TfrmDataModule;
    FEventList: TObjectList;
    FMain: TfrmDataModule;
    function GetChangeCount: Integer;
    function GetConnection: TFDCustomConnection;
    procedure SetDetail(const Value: TfrmDataModule);
    procedure SetMain(const Value: TfrmDataModule);
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
    property Detail: TfrmDataModule read FDetail write SetDetail;
    property Main: TfrmDataModule read FMain write SetMain;
    { Public declarations }
  end;

implementation

uses NotifyEvents;

{$R *.dfm}

constructor TfrmMasterDetail.Create(AOwner: TComponent);
begin
  inherited;
  FEventList := TObjectList.Create;
end;

destructor TfrmMasterDetail.Destroy;
begin
  FreeAndNil(FEventList);
  try
    inherited;
  except
    ;
  end;
end;

procedure TfrmMasterDetail.CheckMasterAndDetail;
begin
  Assert(Main <> nil);
  Assert(Detail <> nil);
end;

procedure TfrmMasterDetail.ApplyUpdates;
begin
  CheckMasterAndDetail;

  Main.TryPost;
  Detail.TryPost;

  Main.ApplyUpdates;
  Detail.ApplyUpdates;
end;

procedure TfrmMasterDetail.InitializeQuery(AQuery: TFDQuery);
begin
  Assert(AQuery <> nil);
end;

procedure TfrmMasterDetail.CancelUpdates;
begin
  CheckMasterAndDetail;

  // отменяем все сделанные изменения на стороне клиента
  Main.CancelUpdates;
  Detail.CancelUpdates;
end;

function TfrmMasterDetail.GetChangeCount: Integer;
begin
  Assert(Main <> nil);
  Assert(Detail <> nil);
  Result := Main.FDQuery.ChangeCount + Detail.FDQuery.ChangeCount;
end;

function TfrmMasterDetail.GetConnection: TFDCustomConnection;
begin
  Assert(Main <> nil);
  Result := Main.FDQuery.Connection;
end;

procedure TfrmMasterDetail.ReOpen;
begin
  Detail.FDQuery.Close;
  Main.FDQuery.Close;

  Main.FDQuery.Open;
  Detail.FDQuery.Open;
end;

procedure TfrmMasterDetail.Rollback;
begin
  CheckMasterAndDetail;
  // Предполагается что мы работаем в транзакции
  Assert(Connection.InTransaction);

  Detail.TryCancel;
  Main.TryCancel;

  Connection.Rollback;

  ReOpen;
end;

procedure TfrmMasterDetail.Commit;
begin
  CheckMasterAndDetail;
  // Предполагается что мы работаем в транзакции
  Assert(Connection.InTransaction);

  Main.TryPost;
  Detail.TryPost;

  Connection.Commit;
end;

procedure TfrmMasterDetail.SetDetail(const Value: TfrmDataModule);
begin
  if FDetail <> Value then
  begin
    FDetail := Value;
    InitializeQuery(FDetail.FDQuery);
  end;
end;

procedure TfrmMasterDetail.SetMain(const Value: TfrmDataModule);
begin
  if FMain <> Value then
  begin
    FMain := Value;
    InitializeQuery(FMain.FDQuery);
  end;
end;

procedure TfrmMasterDetail.TryPost;
begin
  Main.TryPost;
  Detail.TryPost;
end;

end.
