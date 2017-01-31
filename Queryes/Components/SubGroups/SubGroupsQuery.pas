unit SubGroupsQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  QueryWithDataSourceUnit;

type
  TfrmQuerySubGroups = class(TQueryWithDataSource)
  private
    procedure DoAfterDBEvents(Sender: TObject);
    function GetIsRecordReadOnly: Boolean;
    procedure UpdateReadOnly;
    { Private declarations }
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure Load(AFirstExternalID, AValue: string); overload;
    property IsRecordReadOnly: Boolean read GetIsRecordReadOnly;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses NotifyEvents;

constructor TfrmQuerySubGroups.Create(AOwner: TComponent);
begin
  inherited;
  TNotifyEventWrap.Create(AfterOpen, DoAfterDBEvents, FEventList);
  TNotifyEventWrap.Create(AfterInsert, DoAfterDBEvents, FEventList);
  TNotifyEventWrap.Create(AfterScroll, DoAfterDBEvents, FEventList);
end;

procedure TfrmQuerySubGroups.DoAfterDBEvents(Sender: TObject);
begin
  UpdateReadOnly;
end;

function TfrmQuerySubGroups.GetIsRecordReadOnly: Boolean;
begin
  Result := (FDQuery.RecordCount > 0) and
  (not FDQuery.FieldByName('IsMain').IsNull) and
  (FDQuery.FieldByName('IsMain').AsInteger = 1);
end;

procedure TfrmQuerySubGroups.Load(AFirstExternalID, AValue: string);
begin
  Load(['MainExternalID', 'Value'], [AFirstExternalID, AValue]);
end;

procedure TfrmQuerySubGroups.UpdateReadOnly;
begin

  FDQuery.UpdateOptions.EnableDelete := not IsRecordReadOnly;
  FDQuery.UpdateOptions.EnableUpdate := not IsRecordReadOnly;

end;

end.
