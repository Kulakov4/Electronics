unit SubGroupsQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, DSWrap, BaseEventsQuery;

type
  TSubGroupW = class(TDSWrap)
  private
    FExternalID: TFieldWrap;
    FID: TFieldWrap;
    FIsMain: TFieldWrap;
    function GetIsRecordReadOnly: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    property ExternalID: TFieldWrap read FExternalID;
    property IsMain: TFieldWrap read FIsMain;
    property ID: TFieldWrap read FID;
    property IsRecordReadOnly: Boolean read GetIsRecordReadOnly;
  end;

  TfrmQuerySubGroups = class(TQueryBaseEvents)
  private
    FW: TSubGroupW;
    procedure DoAfterDBEvents(Sender: TObject);
    procedure UpdateReadOnly;
    { Private declarations }
  protected
    function CreateDSWrap: TDSWrap; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Search(AFirstExternalID, AValue: string); overload;
    property W: TSubGroupW read FW;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses NotifyEvents, StrHelper;

constructor TfrmQuerySubGroups.Create(AOwner: TComponent);
begin
  inherited;
  FW := FDSWrap as TSubGroupW;
  TNotifyEventWrap.Create(W.AfterOpen, DoAfterDBEvents, W.EventList);
  TNotifyEventWrap.Create(W.AfterInsert, DoAfterDBEvents, W.EventList);
  TNotifyEventWrap.Create(W.AfterScroll, DoAfterDBEvents, W.EventList);
end;

function TfrmQuerySubGroups.CreateDSWrap: TDSWrap;
begin
  Result := TSubGroupW.Create(FDQuery);
end;

procedure TfrmQuerySubGroups.DoAfterDBEvents(Sender: TObject);
begin
  UpdateReadOnly;
end;

procedure TfrmQuerySubGroups.Search(AFirstExternalID, AValue: string);
var
  AMainExternalID: string;
  ASQL: string;
  AStipulation: string;
begin
  AMainExternalID := 'MainExternalID';

  AStipulation := Format('%s = :%s', [W.ExternalID.FullName, AMainExternalID]);

  // Меняем SQL запрос
  ASQL := ReplaceInSQL(SQL, AStipulation, 0);

  AStipulation := Format('instr('',''||:%s||'','', '',''||%s||'','') > 0',
    [W.ExternalID.FieldName, W.ExternalID.FullName]);

  // Меняем SQL запрос
  FDQuery.SQL.Text := ReplaceInSQL(ASQL, AStipulation, 1);

  SetParamType(W.ExternalID.FieldName, ptInput, ftWideString);
  SetParamType(AMainExternalID, ptInput, ftWideString);
  Search([AMainExternalID, W.ExternalID.FieldName], [AFirstExternalID, AValue]);
end;

procedure TfrmQuerySubGroups.UpdateReadOnly;
begin

  FDQuery.UpdateOptions.EnableDelete := not W.IsRecordReadOnly;
  FDQuery.UpdateOptions.EnableUpdate := not W.IsRecordReadOnly;

end;

constructor TSubGroupW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'pc.ID', '', True);
  FIsMain := TFieldWrap.Create(Self, 'IsMain');
  FExternalID := TFieldWrap.Create(Self, 'pc.ExternalID');
end;

function TSubGroupW.GetIsRecordReadOnly: Boolean;
begin
  Result := (DataSet.RecordCount > 0) and (not IsMain.F.IsNull) and
    (IsMain.F.AsInteger = 1);
end;

end.
