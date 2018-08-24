unit QueryWithMasterUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseEventsQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQueryWithMaster = class(TQueryBaseEvents)
  private
    FLock: Boolean;
    FMaster: TQueryWithMaster;
    FNeedLoad: Boolean;
    FNeedRefresh: Boolean;
    procedure DoAfterMasterScroll(Sender: TObject);
    function GetActual: Boolean;
    procedure SetLock(const Value: Boolean);
    procedure SetMaster(const Value: TQueryWithMaster);
    { Private declarations }
  public
    procedure Load; overload;
    procedure MasterCascadeDelete;
    procedure RefreshQuery; override;
    // TODO: PostPostMessage
    // procedure PostPostMessage;
    procedure TryLoad;
    procedure TryPost; override;
    procedure TryRefresh;
    property Actual: Boolean read GetActual;
    property Lock: Boolean read FLock write SetLock;
    property Master: TQueryWithMaster read FMaster write SetMaster;
    property NeedRefresh: Boolean read FNeedRefresh;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses NotifyEvents, System.Math;

procedure TQueryWithMaster.DoAfterMasterScroll(Sender: TObject);
begin
  TryLoad;
end;

function TQueryWithMaster.GetActual: Boolean;
begin
  Result := FDQuery.Active and not NeedRefresh;
end;

procedure TQueryWithMaster.Load;
var
  AIDParent: Integer;
begin
  FNeedLoad := False;
  Assert(FMaster <> nil);
  AIDParent := IfThen(FMaster.FDQuery.RecordCount > 0,
    FMaster.PK.AsInteger, -1);
  Load(AIDParent);
end;

procedure TQueryWithMaster.MasterCascadeDelete;
var
  V: Variant;
begin
  Assert(FMaster <> nil);
  Assert(FMaster.FDQuery.RecordCount > 0);
  V := FMaster.PK.Value;
  CascadeDelete(V, DetailParameterName);
  FMaster.LocateByPK(V, True);
end;

procedure TQueryWithMaster.RefreshQuery;
begin
  FNeedRefresh := False;
  inherited;
end;

procedure TQueryWithMaster.SetLock(const Value: Boolean);
begin
  if FLock <> Value then
  begin
    FLock := Value;

    if (not FLock) then
    begin
      // если мастер изменился, нам пора обновиться
      if FNeedLoad then
      begin
        Load;
        FNeedRefresh := False; // Обновлять больше не нужно
      end
      else if FNeedRefresh then
        RefreshQuery;
    end;
  end;
end;

procedure TQueryWithMaster.SetMaster(const Value: TQueryWithMaster);
begin
  if FMaster <> Value then
  begin
    // Отписываемся от всех событий старого мастера
    FMasterEventList.Clear;

    FMaster := Value;

    if FMaster <> nil then
    begin
      // Подписываемся на события нового мастера
      TNotifyEventWrap.Create(FMaster.AfterScroll, DoAfterMasterScroll,
        FMasterEventList);
    end;

  end;
end;

procedure TQueryWithMaster.TryLoad;
begin
  // Будем обновляться, т.к. мы подчинены мастеру
  if not Lock then
    Load
  else
    FNeedLoad := True;
end;

procedure TQueryWithMaster.TryPost;
begin
  // если заблокировано и не активно
  if Lock and (not FDQuery.Active) then
    Exit;

  inherited;
end;

procedure TQueryWithMaster.TryRefresh;
begin
  // Будем обновляться, т.к. мы подчинены мастеру
  if not Lock then
    RefreshQuery
  else
    FNeedRefresh := True;
end;

end.
