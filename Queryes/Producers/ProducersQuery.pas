unit ProducersQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, NotifyEvents, QueryWithDataSourceUnit,
  ProducerInterface;

type
  TQueryProducers = class(TQueryWithDataSource, IProducer)
    procedure FDQueryCntGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
  strict private
    function GetProducerID(const AProducerName: String): Integer; stdcall;
  private
    procedure DoBeforeScroll(Sender: TObject);
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
    procedure CancelUpdates; override;
    function Locate(AValue: string; TestResult: Boolean = False): Boolean;
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


  TNotifyEventWrap.Create(BeforeOpen, DoBeforeOpen, FEventList);
  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, FEventList);
  TNotifyEventWrap.Create(BeforeScrollI, DoBeforeScroll, FEventList);

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

procedure TQueryProducers.DoBeforeScroll(Sender: TObject);
begin
  ;
end;

procedure TQueryProducers.DoBeforeOpen(Sender: TObject);
begin
  // Заполняем код параметра "Производитель"
  FDQuery.ParamByName('ProducerParamSubParamID').AsInteger :=
    TDefaultParameters.ProducerParamSubParamID;
end;

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

function TQueryProducers.GetProducerID(const AProducerName: String): Integer;
var
  V: Variant;
begin
  Result := 0;
  V := FDQuery.LookupEx(Name.FieldName, AProducerName, PK.FieldName);
  if not VarIsNull(V) then
    Result := V;
end;

function TQueryProducers.GetProducerTypeID: TField;
begin
  Result := Field('ProducerTypeID');
end;

function TQueryProducers.Locate(AValue: string; TestResult: Boolean = False):
    Boolean;
begin
  Result := FDQuery.LocateEx(Name.FieldName, AValue.Trim, [lxoCaseInsensitive]);
  if TestResult then
    Assert(Result);

end;

end.
