unit ProducersQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, NotifyEvents, QueryWithDataSourceUnit;

type
  TQueryProducers = class(TQueryWithDataSource)
    procedure FDQueryCntGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
  private
    FAfterDataChange: TNotifyEventsEx;
    procedure DoAfterPostOrDelete(Sender: TObject);
    procedure DoBeforeOpen(Sender: TObject);
// TODO: DropUnuses
//  procedure DropUnuses;
    function GetCnt: TField;
    function GetName: TField;
    function GetProducerTypeID: TField;
    { Private declarations }
  protected
    procedure DoAfterOpen(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    procedure AddNewValue(const AValue: string; AProducerTypeID: Integer);
    procedure ApplyUpdates; override;
    procedure CancelUpdates; override;
    function Locate(AValue: string): Boolean;
    property AfterDataChange: TNotifyEventsEx read FAfterDataChange;
    property Cnt: TField read GetCnt;
    property Name: TField read GetName;
    property ProducerTypeID: TField read GetProducerTypeID;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses RepositoryDataModule, DefaultParameters, ProducerTypesQuery;

constructor TQueryProducers.Create(AOwner: TComponent);
begin
  inherited;

  FAfterDataChange := TNotifyEventsEx.Create(Self);

  TNotifyEventWrap.Create(BeforeOpen, DoBeforeOpen);
  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen);
  TNotifyEventWrap.Create(AfterPost, DoAfterPostOrDelete);
  TNotifyEventWrap.Create(AfterDelete, DoAfterPostOrDelete);

  AutoTransaction := False;
end;

procedure TQueryProducers.AddNewValue(const AValue: string; AProducerTypeID:
    Integer);
begin
  Assert(AProducerTypeID > 0);

  FDQuery.Append;
  ProducerTypeID.AsInteger := AProducerTypeID;
  Name.AsString := AValue;
  FDQuery.Post;
end;

procedure TQueryProducers.ApplyUpdates;
begin
  TryPost;
  FDQuery.Connection.Commit;
end;

procedure TQueryProducers.CancelUpdates;
begin
  // отменяем все сделанные изменения на стороне клиента
  TryCancel;
  FDQuery.Connection.Rollback;
  RefreshQuery;
end;

procedure TQueryProducers.DoAfterOpen(Sender: TObject);
begin
  // Кол-во - только для чтения
  Cnt.ReadOnly := True;
  Cnt.OnGetText := FDQueryCntGetText;
  Name.DisplayLabel := 'Производитель';
end;

procedure TQueryProducers.DoAfterPostOrDelete(Sender: TObject);
begin
  FAfterDataChange.CallEventHandlers(Self);
end;

procedure TQueryProducers.DoBeforeOpen(Sender: TObject);
begin
  // Заполняем код параметра "Производитель"
  FDQuery.ParamByName('ProducerParameterID').AsInteger :=
    TDefaultParameters.ProducerParameterID;
end;

// TODO: DropUnuses
//procedure TQueryProducers.DropUnuses;
//begin
//// fdqDropUnused.ExecSQL;
//// RefreshQuery;
//end;

procedure TQueryProducers.FDQueryCntGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  if (not Sender.IsNull) and (Sender.AsFloat > 0) then
    Text := String.Format('%.0n', [Sender.AsFloat])
  else
    Text := '';
end;

function TQueryProducers.GetCnt: TField;
begin
  Result := Field('Cnt');
end;

function TQueryProducers.GetName: TField;
begin
  Result := Field('Name');
end;

function TQueryProducers.GetProducerTypeID: TField;
begin
  Result := Field('ProducerTypeID');
end;

function TQueryProducers.Locate(AValue: string): Boolean;
begin
  Result := FDQuery.LocateEx(Name.FieldName, AValue.Trim, [lxoCaseInsensitive]);
end;

end.
